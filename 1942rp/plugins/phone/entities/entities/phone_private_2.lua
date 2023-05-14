AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Home Phone 02"
ENT.Author = "EXG - Communications"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Category = "EXG - Communications"


if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/hts/berlinrp/phonesystem/ger_payphone_01.mdl")
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
	net.Start("Private_Phone_Menu")
	net.Send(activator)
	end

else
	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:onShouldDrawEntityInfo()
		return true
	end

	function ENT:onDrawEntityInfo(alpha)
		local position = (self:LocalToWorld(self:OBBCenter()) + self:GetUp()*1):ToScreen()
		local x, y = position.x, position.y

		nut.util.drawText("Telephone", x, y, ColorAlpha(nut.config.get("color"), alpha), 1, 1, nil, alpha * 0.65)
	end
end