AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Public Phone"
ENT.Author = "EXG - Communications"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Category = "EXG - Communications"


if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_equipment/phone_booth.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.receivers = {}
		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:Wake()
		end
	end

	
	function ENT:Use(activator)
	net.Start("Public_Phone_Menu")
	net.Send(activator)
	activator:ConCommand("say /me Picks up phone")
	end

else
	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:onShouldDrawEntityInfo()
		return true
	end

	local TEXT_OFFSET = Vector(0, 0, 0)
	local toScreen = FindMetaTable("Vector").ToScreen
	local colorAlpha = ColorAlpha
	local drawText = nut.util.drawText
	local configGet = nut.config.get

	function ENT:onDrawEntityInfo(alpha)
		local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
		local x, y = position.x, position.y
		--local desc = self.getNetVar(self, "desc")

		drawText("Public Phone", x, y - 56 , colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)

		--if (desc) then
			--drawText("Public Telephone", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
		--end
	end

end