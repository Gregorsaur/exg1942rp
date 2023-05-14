local PLUGIN = PLUGIN

ENT.RemoveDelay = 30

ENT.Type = "anim"
ENT.PrintName = "Storage"
ENT.Category = "EXG - Crafting"
ENT.Spawnable = false


if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_junk/watermelon01.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.receivers = {}
		
		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:Wake()
        end
        
        self.die = CurTime() + 30
	end

	function ENT:setInventory(inventory)
		self:setNetVar("id", inventory:getID())
	end

	function ENT:OnRemove()
		local index = self:getNetVar("id")

		if (!nut.shuttingDown and !self.nutIsSafe and nut.entityDataLoaded and index) then
			local item = nut.item.inventories[index]

			if (item) then
				nut.item.inventories[index] = nil

				nut.db.query("DELETE FROM nut_items WHERE _invID = "..index)
				nut.db.query("DELETE FROM nut_inventories WHERE _invID = "..index)

				hook.Run("StorageItemRemoved", self, item)
			end
		end
	end

	local OPEN_TIME = .7
	function ENT:OpenInv(activator)
		local inventory = self:getInv()

		activator:setAction("Opening...", OPEN_TIME, function()
			if (activator:GetPos():Distance(self:GetPos()) <= 100) then
				self.receivers[activator] = true
				activator.nutBagEntity = self
				
				inventory:sync(activator)
				netstream.Start(activator, "openTempStorage", self, inventory:getID())
				self:EmitSound("items/ammocrate_open.wav")
			end
		end)
	end

	function ENT:Use(activator)
		local inventory = self:getInv()
		if (inventory and (activator.nutNextOpen or 0) < CurTime()) then
			if (activator:getChar()) then
				self:OpenInv(activator)
			end

			activator.nutNextOpen = CurTime() + OPEN_TIME * 1.5
		end
	end
else
	ENT.DrawEntityInfo = true

	local COLOR_LOCKED = Color(242, 38, 19)
	local COLOR_UNLOCKED = Color(135, 211, 124)
	local toScreen = FindMetaTable("Vector").ToScreen
	local colorAlpha = ColorAlpha
	local drawText = nut.util.drawText
    local configGet = nut.config.get
    
    function ENT:Initialize()
        self.die = CurTime() + self.RemoveDelay
	end

	function ENT:onDrawEntityInfo(alpha)
        local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)))
        local x, y = position.x, position.y

        y = y - 20

        local tx, ty = drawText("Storage", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
        y = y + ty + 1
        
        drawText(string.format("%d seconds left until self deletion",  self.die - CurTime()), x, y, colorAlpha(color_white, alpha), 1, 1, nil, alpha * 0.65)
    end
end

function ENT:getInv()
	return nut.item.inventories[self:getNetVar("id", 0)]
end