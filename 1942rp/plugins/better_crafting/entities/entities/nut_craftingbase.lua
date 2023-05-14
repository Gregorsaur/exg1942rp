AddCSLuaFile()

ENT.Type				= "anim"

ENT.Author				= "Ernie"
ENT.Contact				= "ernie"
ENT.Instructions		= "Press USE whilst looking at table to open crafting menu"
ENT.Spawnable			= false
ENT.AdminOnly			= true
ENT.DisableDuplicator	= true
ENT.Category			= "EXG - Crafting"
ENT.IsCraftingTable		= true

local PLUGIN = PLUGIN

if (SERVER) then
	function ENT:Initialize()
		self:SetModel(self.Model or "models/props_c17/FurnitureTable001a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.receivers = {}
		
		local physicsObject = self:GetPhysicsObject()
		if (IsValid(physicsObject)) then
			physicsObject:Wake()
		end

		nut.inventory.instance("grid", {w = self.InvWidth, h = self.InvHeight})
			:next(function(inventory)
				inventory.invType = "grid"

				self:setInventory(inventory)
				inventory.noBags = true
	
				function inventory:onCanTransfer(client, oldX, oldY, x, y, newInvID)
					return hook.Run('StorageCanTransfer', inventory, client, oldX, oldY, x, y, newInvID)
				end
			end)

		PLUGIN:SaveData()
	end

	function ENT:DoCraft(client)
		if (!self.AllowedBlueprints) then return client:notifyLocalized("notSetup", self.PrintName) end

		if (!client:CanCraft()) then
			return client:notifyLocalized("cantCraft")
		end

		local blueprints, weapons = {}, {}

		local our_inv = self:getInv()
		local our_items = our_inv:getItems()
		local client_inv = client:getChar():getInv()
		
		if (!client_inv) then return client:notifyLocalized("cantCraft") end
		local client_items = client_inv:getItems()

		for k, v in pairs(our_items) do
			if (v.isBlueprint) then table.insert(blueprints, v) end
			if (v.isWeapon) then table.insert(weapons, v) end
		end

		local blueprints_count = #blueprints
		local weapons_count = #weapons

		if (blueprints_count > 0) then
			if (blueprints_count > 1) then return client:notifyLocalized("tooMany", "blueprints") end
			
			-- Guaranteed single valid blueprint at this point

			local blueprint = blueprints[1]
			local blueprint_item = nut.item.get(blueprint.uniqueID)

			if (!self.AllowedBlueprints[blueprint.uniqueID]) then
				local other_tables = {}
				for name, tbl in pairs(CraftingTables) do
					if (!tbl) then continue end
					for ingredient, allowed in pairs(tbl) do
						if (!allowed) then continue end
						if (ingredient ~= blueprint.uniqueID) then continue end
						table.insert(other_tables, name)
						break
					end
				end
				return client:notifyLocalized("wrongBlueprint", table.concat(other_tables, " or "))
			end

			-- Allowed to craft using the blueprint
			-- Remove ingredients from inventory

			local items_to_remove = {}
			for _, req in ipairs(blueprint.requirements) do
				local item_count = our_inv:getItemCount(req[1])
				
				if (item_count < req[2]) then
					return client:notifyLocalized("missingIngredients", req[2] - item_count, req[1])
				end

				table.insert(items_to_remove, req)
			end

			for _, item in ipairs(items_to_remove) do
				for i=1, item[2] do
					local itm = PLUGIN:HasItem(our_inv, item[1])
					if itm then
						itm:remove()
					end
				end
			end

			-- Insert crafting result
			for _, item in ipairs(blueprint.result) do
				for i=1, item[2] do
					local item_definition = nut.item.list[item[1]]
					if (!item_definition) then
						return client:notifyLocalized("illegalAccess, %s", "invalid crafting result")
					end

					local fits = client_inv:canItemFitInInventory(item[1], item_definition.width, item_definition.height)
					if fits then
						client_inv:add(item[1])
					else
						nut.item.spawn(item[1], self:GetPos() + self:GetUp() * 15)
					end
				end
			end
			

			self:EmitSound(self.CraftSound or "player/shove_01.wav")
			
		elseif (weapons_count > 0 and self.WeaponAttachments) then
			if (weapons_count > 1) then return client:notifyLocalized("tooMany", "weapons") end
			
			local weapon = weapons[1]
			local attachments = weapon:getData("mod") or {}
			local weaponTable = weapons.GetStored(weapon.class)

			if (!weaponTable) then return client:notifyLocalized("invalid", "weapon information") end 
			
			local available_attachments = {}
			local attach_table = {}
			local items_to_remove = {}

			for _, v in pairs(attachments) do
				our_inv:add(v)
			end

			for _, v in pairs(our_items) do
				if (v.isAttachment) then
					available_attachments[v.uniqueID] = v
				end
			end

			for category, data in ipairs(weaponTable.Attachments) do
				for k, name in pairs(data.atts) do
					local attachment = available_attachments[name]

					if (attachment and !attach_table[category]) then
						attach_table[category] = name
						table.insert(items_to_remove, attachment)
					end
				end
			end

			for _, v in ipairs(items_to_remove) do
				v:remove()
			end

			if (table.Count(attach_table) <= 0) then
				attach_table = nil
			end

			weapon:setData("mod", attach_table)
		else
			return client:notifyLocalized("nothingCraftable")
		end
		

	end

	function ENT:setInventory(inventory)
		if (!inventory) then return end

		self:setNetVar("id", inventory:getID())
		inventory:addAccessRule(function(inventory, action, context)
			local client = context.client
			local ent = client.m_nUsingCraftingBench
			if not IsValid(ent) then return end
			if (not IsValid(client)) then return end
			if (ent:getInv() ~= inventory) then return end
	
			-- If the player is too far away from storage, then ignore.
			local distance = ent:GetPos():Distance(client:GetPos())
			if (distance > 128) then return false end
	
			-- Allow if the player is a receiver of the storage.
			if (ent.receivers[client]) then
				return true
			end
		end)
	end
	
	function ENT:Use(activator)
		local inventory = self:getInv()
		if (!inventory or (activator.nutNextOpen or 0) > CurTime()) then return end

		if (activator:getChar()) then
			activator:setAction("Opening...", 1, function()
				if (activator:GetPos():DistToSqr(self:GetPos()) <= 10000) then
					if (self:IsTableLocked()) then
						self:EmitSound("doors/default_locked.wav")
						activator:notifyLocalized("lockedTable")
					else
						activator.m_nUsingCraftingBench = self
						self.receivers[activator] = true
						activator.nutBagEntity = self
						
						inventory:sync(activator)
						netstream.Start(activator, "craftingTableOpen", self, inventory:getID())
					end
					
				end
			end)
		end

		activator.nutNextOpen = CurTime() + 1.5
	end

	function ENT:OnRemove()		
		local index = self:getNetVar("id")
		if (nut.shuttingDown or self.nutIsSafe or !index) then return end
		
		-- local item = nut.inventory.instances[index]

		-- if (item and table.Count(item:getItems()) >= 1 ) then
		-- 	local storage = ents.Create("nut_tempcrate")
		-- 	storage:SetPos(self:GetPos() + Vector(0, 0, 15))
		-- 	storage:SetAngles(self:GetAngles())
		-- 	storage:Spawn()
		-- 	storage:SetModel("models/props_junk/cardboard_box004a.mdl")
		-- 	storage:SetSolid(SOLID_VPHYSICS)
		-- 	storage:PhysicsInit(SOLID_VPHYSICS)
			

		-- 	local our_inv = self:getInv()
		-- 	storage:setInventory(our_inv)
		-- 	our_inv:sync(activator)

		-- 	storage.die = CurTime() + storage.RemoveDelay
			
		-- 	self:setNetVar("die", storage.die)

		-- 	dying_storages = dying_storages or {}
		-- 	table.insert(dying_storages, storage)
		-- end
	end

	function ENT:SpawnFunction( ply, tr, ClassName )

		if ( !tr.Hit ) then return end
	
		local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
		local ent = ents.Create( ClassName )
		ent:SetPos( SpawnPos )
		ent.Owner = ply
		ent:Spawn()
		ent:Activate()
	
		return ent
	
	end
	
	netstream.Hook("doCraft", function(client, entity, seconds)
		local distance = client:GetPos():DistToSqr(entity:GetPos())
		
		if (entity:IsValid() and client:IsValid() and client:getChar() and
			distance < 16384) then
			entity:DoCraft(client)
		end
	end)
else
	-- needed?
	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:onShouldDrawEntityInfo()
		return true
	end

	function ENT:onDrawEntityInfo(alpha)
		local position = (self:LocalToWorld(self:OBBCenter()) + self:GetUp()*16):ToScreen()
		local x, y = position.x, position.y

		nut.util.drawText(self.PrintName, x, y, ColorAlpha(nut.config.get("color"), alpha), 1, 1, nil, alpha * 0.65)
		nut.util.drawText(self.Purpose, x, y + 16, ColorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
	end
end

function ENT:getInv()
	return nut.inventory.instances[self:getNetVar("id", 0)]
end