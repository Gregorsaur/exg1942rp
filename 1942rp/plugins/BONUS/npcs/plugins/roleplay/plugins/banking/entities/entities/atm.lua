AddCSLuaFile()
ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "ATM"
ENT.Author = "Leonheart#7476"
ENT.Category = "Leonheart NPCs"
ENT.Spawnable = true
ENT.AdminOnly = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/craphead_scripts/ch_atm/atm.mdl")
        self:SetUseType(SIMPLE_USE)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:DrawShadow(true)
        self:SetSolid(SOLID_OBB)
        self:PhysicsInit(SOLID_OBB)
        local physObj = self:GetPhysicsObject()

        if IsValid(physObj) then
            physObj:EnableMotion(false)
            physObj:Sleep()
        end
    end

    function ENT:OnTakeDamage()
        return false
    end

    function ENT:AcceptInput(Name, Activator, Caller)
        if Name == "Use" and Caller:IsPlayer() then
            netstream.Start(Caller, "OpenBankingTeller")
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
        drawText("ATM", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
    end
end