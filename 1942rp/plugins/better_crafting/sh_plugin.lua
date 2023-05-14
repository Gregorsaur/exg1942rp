local PLUGIN = PLUGIN
PLUGIN.name = "Better Crafting"
PLUGIN.author = "Ernie"
PLUGIN.desc = "Advanced crafting system."


local PLAYER = FindMetaTable("Player")
local ENTITY = FindMetaTable("Entity")

function PLAYER:CanCraft(craftID)
	return self:Alive() and self:getChar()
end

function PLUGIN:HasItem(inventory, itemType)
	for _, item in pairs(inventory:getItems()) do
		if (item.uniqueID == itemType) then
			return item
		end
	end

	return false
end

if (CLIENT) then
	netstream.Hook("craftingTableOpen", function(entity, index)
		local inventory = nut.item.inventories[index]
		if (!IsValid(entity) or !inventory) then return end

		local inv1 = LocalPlayer():getChar():getInv():show()
		inv1:ShowCloseButton(false)
		inv1:SetDraggable(false)

		local inv2 = inventory:show()
		inv2:ShowCloseButton(true)
		inv2:SetTitle(entity.PrintName)
		inv2:SetDraggable(false)
		inv2.OnClose = function(this)
			if (IsValid(inv1)) then
				inv1:Remove()
			end

			netstream.Start("invExit")
		end

		local actPanel = vgui.Create("DPanel")
		actPanel:SetDrawOnTop(true)
		actPanel:SetSize(100, inv2:GetTall())
		actPanel.Think = function(this)
			if (!inv2 or !inv2:IsValid() or !inv2:IsVisible()) then
				this:Remove()

				return
			end

			local x, y = inv2:GetPos()
			this:SetPos(x - this:GetWide() - 5, y)
		end

		local btn = actPanel:Add("DButton")
		btn:Dock(TOP)
		btn:SetText(L"craft")
		btn:SetColor(color_white)
		btn:DockMargin(5, 5, 5, 0)

		function btn.DoClick()
			netstream.Start("doCraft", entity, v)
		end

		local middle = ( inv1:GetWide() + inv2:GetWide() ) / 2
		local current = inv2:GetWide() + inv1:GetWide() / 2
		local new = current - middle
		
		inv1:MoveBy(new, 0, 0, 0, -1)
		inv2:MoveLeftOf(inv1, 4)
		inv2:MoveBy(new, 0, 0, 0, -1)

		nut.gui["inv"..index] = inv2
	end)

	netstream.Hook("openTempStorage", function(entity, index)
		local inventory = nut.item.inventories[index]

		if (IsValid(entity) and inventory) then
			local inv1 = LocalPlayer():getChar():getInv():show()
			inv1:ShowCloseButton(false)
			inv1:SetDraggable(false)

			local inv2 = inventory:show()
			inv2:ShowCloseButton(true)
			inv2:SetTitle(entity.PrintName)
			inv2:SetDraggable(false)
			inv2.OnClose = function(this)
				if (IsValid(inv1)) then
					inv1:Remove()
				end
	
				netstream.Start("invExit")
			end

			local middle = ( inv1:GetWide() + inv2:GetWide() ) / 2
			local current = inv2:GetWide() + inv1:GetWide() / 2
			local new = current - middle

			inv1:MoveBy(new, 0, 0, 0, -1)
			inv2:MoveLeftOf(inv1, 4)
			inv2:MoveBy(new, 0, 0, 0, -1)

			nut.gui["inv"..index] = inv2
		end
	end)
else
	local PLUGIN = PLUGIN

	function PLUGIN:SaveData()
		local to_save = {}

		for k, v in ipairs(ents.GetAll()) do
			if (!v.IsCraftingTable) then continue end
			to_save[#to_save + 1] = {
				class	= v:GetClass(),
				pos		= v:GetPos(),
				ang		= v:GetAngles(),
				id		= v:getNetVar("id", 0)
			}
		end

		self:setData(to_save)
	end

	function PLUGIN:LoadData()
    	for k, v in ipairs(ents.GetAll()) do
   			if (v.IsCraftingTable) then
        		v:Remove()
    		end
		end
    
		local to_load = self:getData() or {}

		for k, v in ipairs(to_load) do
			local crafting_table = ents.Create(v.class)
			nut.inventory.loadByID(v.id)
				:next(function(inventory)
					if (not inventory) then return end

					-- inventory:setData("w", crafting_table.InvWidth)
					-- inventory:setData("h", crafting_table.InvHeight)

					crafting_table:SetPos(v.pos)
					crafting_table:SetAngles(v.ang)
					crafting_table:Spawn()
					crafting_table:Activate()
					crafting_table:setInventory(inventory)
				end)
		end
	end
	
	dying_storages = dying_storages or {}

	hook.Add("Think", "kill_storages", function()
		local t = CurTime()
		for _, storage in ipairs(dying_storages) do
			if (!IsValid(storage)) then continue end
			if (storage.die > t) then continue end
			table.RemoveByValue(dying_storages, storage)
			storage:Remove()
		end
	end)

	function PLUGIN:PlayerDeath(client)
	end

	function PLUGIN:PlayerSpawn(client)
	end

	function ENTITY:LockTable(locked)
		assert(isbool(locked), "Expected bool, got", type(locked))
		if (self:IsValid() and self.IsCraftingTable) then
			self:setNetVar("table_locked", locked)
			return true
		end
		return false	
	end
	
	function ENTITY:IsTableLocked()
		if (self:IsValid() and self.IsCraftingTable) then
			return self:getNetVar("table_locked", false)
		end
		return true	
	end
end


nut.command.add("craftlock", {
	adminOnly = false,
	syntax = "",
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local ent = trace.Entity
		local dist = ent:GetPos():DistToSqr(client:GetPos())

		-- Validate Table
		if (!ent or !ent:IsValid()) then
			return nil
		end
		if (!ent.IsCraftingTable) then
			return client:notifyLocalized("notATable")
		end

		-- Check action criteria
		if (dist > 16384) then
			return client:notifyLocalized("tooFar")
		end

		if (ent.Owner ~= client) then
			return client:notifyLocalized("notOwner")
		end

		-- Perform action
		ent:LockTable(true)
		ent:EmitSound("doors/default_locked.wav")
		client:notifyLocalized("lockTable")
	end
})

nut.command.add("craftunlock", {
	adminOnly = false,
	syntax = "",
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local ent = trace.Entity
		local dist = ent:GetPos():DistToSqr(client:GetPos())

		-- Valdiate vehicle
		if (!ent or !ent:IsValid()) then
			return nil
		end
		if (!ent.IsCraftingTable) then
			return client:notifyLocalized("notATable")
		end
		-- Check action criteria
		if (dist > 16384) then
			return client:notifyLocalized("tooFar")
		end

		if (ent.Owner ~= client) then
			return client:notifyLocalized("notOwner")
		end

		-- Perform action
		ent:LockTable(false)
		ent:EmitSound("items/ammocrate_open.wav")
		client:notifyLocalized("unlockTable")
	end
})