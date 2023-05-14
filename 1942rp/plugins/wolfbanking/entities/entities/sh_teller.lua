ENT.Type = "anim"
ENT.PrintName = "IBM"
ENT.Category = "NutScript"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.isVendor = true

function ENT:Initialize()
    if (SERVER) then
        self:SetModel("models/player/breen.mdl")
        self:SetUseType(SIMPLE_USE)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:DrawShadow(true)
        self:SetSolid(SOLID_OBB)
        self:PhysicsInit(SOLID_OBB)
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
        if v:lower():find("idle") and v ~= "idlenoise" then return self:ResetSequence(k) end
    end

    self:ResetSequence(4)
end

if SERVER then
    function ENT:SpawnFunction(client, trace)
        local angles = (trace.HitPos - client:GetPos()):Angle()
        angles.r = 0
        angles.p = 0
        angles.y = angles.y + 180
        local entity = ents.Create("sh_teller")
        entity:SetPos(trace.HitPos)
        entity:SetAngles(angles)
        entity:Spawn()
        -- entity:AddToPerma()

        return entity
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
        drawText("Bank Teller", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
    end
end

function ENT:Use(ply)
    netstream.Start(ply, "OpenBankingTeller")
end