ENT.Type = "anim"
ENT.PrintName = "Salary Distributer"
ENT.Category = "EXG - NPCs"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.isVendor = true

function ENT:Initialize()
	if (SERVER) then
		self:SetModel("models/player/Suits/male_08_shirt_tie.mdl")
		self:SetUseType(SIMPLE_USE)
		self:SetMoveType(MOVETYPE_NONE)
		self:DrawShadow(true)
		self:SetSolid(SOLID_BBOX)
		self:PhysicsInit(SOLID_BBOX)

		self:setNetVar("name", "Reichsbanker")
		self:setNetVar("desc", "Need to collect your paycheck?")

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
	end

	timer.Simple(1, function()
		if (IsValid(self)) then
			self:setAnim()
		end
	end)
end

function ENT:setAnim()
	for k, v in ipairs(self:GetSequenceList()) do
		if (v:lower():find("idle") and v != "idlenoise") then
			return self:ResetSequence(k)
		end
	end

	self:ResetSequence(4)
end

if (SERVER) then
	local PLUGIN = PLUGIN

	function ENT:SpawnFunction(client, trace)
		local angles = (trace.HitPos - client:GetPos()):Angle()
		angles.r = 0
		angles.p = 0
		angles.y = angles.y + 180

		local entity = ents.Create("nut_salary")
		entity:SetPos(trace.HitPos)
		entity:SetAngles(angles)
		entity:Spawn()

		PLUGIN:SaveData()

		return entity
	end

	function ENT:Use(activator)
		local char = activator:getChar()
		if(char) then
			local amount = char:getData("earnings", 0)
			if(amount > 0) then
				activator:notify("You have been paid " .. amount .. ".")
				char:giveMoney(amount)
				char:setData("earnings", 0)
			else
				activator:notify("You do not have any payments to receive.")
			end
		end
	end
else
	local TEXT_OFFSET = Vector(0, 0, 20)
	local toScreen = FindMetaTable("Vector").ToScreen
	local colorAlpha = ColorAlpha
	local drawText = nut.util.drawText
	local configGet = nut.config.get

	ENT.DrawEntityInfo = true

	function ENT:onDrawEntityInfo(alpha)
		local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
		local x, y = position.x, position.y
		local desc = self.getNetVar(self, "desc")

		drawText(self.getNetVar(self, "name", "John Doe"), x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)

		if (desc) then
			drawText(desc, x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
		end
	end
end