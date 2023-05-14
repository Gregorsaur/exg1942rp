PLUGIN.name = "Trunk Storage"
PLUGIN.author = "Ernie"
PLUGIN.desc = "Implements storage for vehicle trunks"

PLUGIN.vehicles = PLUGIN.vehicles or {}
VEHICLE_DEFINITIONS = PLUGIN.vehicles

nut.util.include("sh_definitions.lua")

-- Miscellanous functions for easy interaction

local function LockTrunk(self, locked)
	assert(isbool(locked), "Expected bool, got", type(locked))
	if (self:IsValid() and self:IsVehicle() and VEHICLE_DEFINITIONS[self:GetModel():lower()]) then
		self:setNetVar("trunk_locked", locked)
		return true
	end
	return false	
end

local function IsTrunkLocked(self)
	if (self:IsValid() and self:IsVehicle()) then
		if (VEHICLE_DEFINITIONS[self:GetModel():lower()]) then
			return self:getNetVar("trunk_locked", false)
		end
	end
	return true	
end

local function getInv(self)
	if (IsValid(self) and self:IsVehicle() and VEHICLE_DEFINITIONS[self:GetModel():lower()]) then
		return nut.inventory.instances[self:getNetVar("trunk_id", self.trunk_id or 0)]
	end
end

--[[
for k, v in pairs(PLUGIN.vehicles) do
	if (k and v.width and v.height) then
		nut.item.registerInv("trunk_"..k, v.width, v.height)
	else
		ErrorNoHalt("[NutScript] Trunk storage for '"..k.."' is missing all inventory information!\n")
		PLUGIN.vehicles[k] = nil
	end
end
--]]

if (SERVER) then
	function PLUGIN:PlayerSpawnedVehicle(client, ent)
		local char = client:getChar()
	
		local def = VEHICLE_DEFINITIONS[ent:GetModel():lower()]
		if (def) then
			ent.WCDOwner = client
		
			ent.LockTrunk = LockTrunk
			ent.IsTrunkLocked = IsTrunkLocked
			ent.getInv = getInv
		
			local wcd_trunks
			local old_inventory
			
			if(char) then
				wcd_trunks = char:getData("wcd_trunks", {})
				old_inventory = wcd_trunks[ent:GetModel():lower()] 
			end
			
			if (old_inventory) then --load the old inventory if it exists
				nut.inventory.loadByID(old_inventory)
				:next(function(inventory)
					if (inventory) then
						inventory.isStorage = true
						ent:setNetVar("trunk_id", inventory:getID())
						ent.trunk_id = inventory:getID()
						
						hook.Run("StorageInventorySet", ent, inventory)
					end
				end)
			else --create a new inventory
				nut.inventory.instance("grid", {w = def.width, h = def.height})
				:next(function(inventory)
					if (IsValid(ent)) then
						inventory.isStorage = true

						ent:setNetVar("trunk_id", inventory:getID())
						ent.trunk_id = inventory:getID()
						
						hook.Run("StorageInventorySet", ent, inventory)
					end
				end)
			end
		end
	end

	function PLUGIN:EntityRemoved(ent)
		if (IsValid(ent) and ent:IsVehicle() and VEHICLE_DEFINITIONS[ent:GetModel():lower()]) then
			if (!IsValid(ent.WCDOwner)) then
				-- Drop the items (Might cause issues)
				local inventory = ent:getInv()
				
				if(inventory) then
					for k, v in pairs(inventory:getItems()) do
						v:removeFromInventory(true)
						v:spawn(ent:GetPos(), ent:GetAngles())
					end
				end
			else
				-- Save data
				local inventory = ent:getInv()
				local char = ent.WCDOwner:getChar()
				
				if(char) then
					local wcd_trunks = char:getData("wcd_trunks", {})

					wcd_trunks[ent:GetModel():lower()] = inventory:getID()
					char:setData("wcd_trunks", wcd_trunks)
				end
			end
		end
	end

	--this shouldnt be necessary anymore
	--[[
	hook.Add("WCD::SpawnedVehicle", "TrunkLoadData", function(client, entity)
		if (!IsValid(entity)) then return end
		if (!entity:IsVehicle()) then return end

		local def = VEHICLE_DEFINITIONS[entity:GetModel():lower()]
		if (!def) then return end

		local char = client:getChar()
		if (!char) then return end

		entity.WCDOwner = client

		local wcd_trunks = char:getData("wcd_trunks", {})
		if (wcd_trunks[entity:GetModel():lower()]) then
			local old_inventory = wcd_trunks[entity:GetModel():lower()]
			if (old_inventory) then return end

			nut.inventory.loadByID(old_inventory)
			:next(function(inventory)
				if (inventory) then
					inventory.isStorage = true
					entity:setNetVar("trunk_id", inventory:getID())
					entity.trunk_id = inventory:getID()
					
					hook.Run("StorageInventorySet", entity, inventory)
				end
			end)
		end
	end)
	--]]
else
	-- "Inspired" by nutscript's storage addon
	netstream.Hook("trunkOpen", function(entity, index)
		local inventory = nut.inventory.instances[index]

		if (IsValid(entity) and entity:IsVehicle() and inventory) then
			local data = VEHICLE_DEFINITIONS[entity:GetModel():lower()]
			if (data) then
				-- Number of pixels between the local inventory and storage inventory.
				local PADDING = 4

				-- Get the inventory for the player and storage.
				local localInv = LocalPlayer():getChar() and LocalPlayer():getChar():getInv()
				local storageInv = inventory
				if (not localInv or not storageInv) then
					return false
					--return nutStorageBase:exitStorage()
				end

				-- Show both the storage and inventory.
				local localInvPanel = localInv:show()
				local storageInvPanel = storageInv:show()
				storageInvPanel:SetTitle(data.name or "Vehicle")

				-- Allow the inventory panels to close.
				localInvPanel:ShowCloseButton(true)
				storageInvPanel:ShowCloseButton(true)

				-- Put the two panels, side by side, in the middle.
				local extraWidth = (storageInvPanel:GetWide() + PADDING) / 2
				localInvPanel:Center()
				storageInvPanel:Center()
				localInvPanel.x = localInvPanel.x + extraWidth
				storageInvPanel:MoveLeftOf(localInvPanel, PADDING)

				-- Signal that the user left the inventory if either closes.
				local firstToRemove = true
				localInvPanel.oldOnRemove = localInvPanel.OnRemove
				storageInvPanel.oldOnRemove = storageInvPanel.OnRemove

				local function exitStorageOnRemove(panel)
					if (firstToRemove) then
						firstToRemove = false
						nutStorageBase:exitStorage()
						local otherPanel =
							panel == localInvPanel and storageInvPanel or localInvPanel
						if (IsValid(otherPanel)) then otherPanel:Remove() end
					end
					panel:oldOnRemove()
				end

				localInvPanel.OnRemove = exitStorageOnRemove
				storageInvPanel.OnRemove = exitStorageOnRemove
			end
		end
	end)
end
	
nut.command.add("trunk", {
	adminOnly = false,
	syntax = "",
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local ent = trace.Entity
		local dist = ent:GetPos():DistToSqr(client:GetPos())

		-- Validate vehicle
		if (!ent or !ent:IsValid()) then
			return
		end
		if (!ent:IsVehicle()) then
			return client:notifyLocalized("invalidVehicle")
		end
		if (!VEHICLE_DEFINITIONS[ent:GetModel():lower()]) then
			return client:notifyLocalized("noTrunk")
		end
		local def = VEHICLE_DEFINITIONS[ent:GetModel():lower()]

		-- Check action criteria
		if (dist > 16384) then
			return client:notifyLocalized("tooFar")
		end
		if (ent:IsTrunkLocked()) then
			ent:EmitSound("doors/default_locked.wav")
			return client:notifyLocalized("trunkLocked")
		end
		
		-- Perform action
		client:setAction("Opening...", .7, function()					
			local inventory = ent:getInv()

			--make sure this exists so item transfers can happen
			if(!ent.receivers) then ent.receivers = {} end

			client.nutStorageEntity = ent
			ent.receivers[client] = true
			inventory:sync(client)
			netstream.Start(client, "trunkOpen", ent, inventory:getID())
			ent:EmitSound(def.trunkSound or "items/ammocrate_open.wav")
		end)
	end
})

nut.command.add("locktrunk", {
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
		if (!ent:IsVehicle()) then
			return client:notifyLocalized("invalidVehicle")
		end
		if (!VEHICLE_DEFINITIONS[ent:GetModel():lower()]) then
			return client:notifyLocalized("noTrunk")
		end

		local def = VEHICLE_DEFINITIONS[ent:GetModel():lower()]

		-- Check action criteria
		if (dist > 16384) then
			return client:notifyLocalized("tooFar")
		end

		if (ent.WCDOwner ~= client and ent.EntityOwner ~= client) then
			return client:notifyLocalized("notOwner")
		end

		-- Perform action
		ent:LockTrunk(true)
		ent:EmitSound(def.lockSound or "doors/default_locked.wav")
		client:notifyLocalized("lockTrunk")
	end
})

nut.command.add("unlocktrunk", {
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
		if (!ent:IsVehicle()) then
			return client:notifyLocalized("invalidVehicle")
		end
		if (!VEHICLE_DEFINITIONS[ent:GetModel():lower()]) then
			return client:notifyLocalized("noTrunk")
		end

		local def = VEHICLE_DEFINITIONS[ent:GetModel():lower()]
		-- Check action criteria
		if (dist > 16384) then
			return client:notifyLocalized("tooFar")
		end

		if (ent.WCDOwner ~= client and ent.EntityOwner ~= client) then
			return client:notifyLocalized("notOwner")
		end

		-- Perform action
		ent:LockTrunk(false)
		ent:EmitSound(def.unlockSound or "items/ammocrate_open.wav")
		client:notifyLocalized("unlockTrunk")
	end
})