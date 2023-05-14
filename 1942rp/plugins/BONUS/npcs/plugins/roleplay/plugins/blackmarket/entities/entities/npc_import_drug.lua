AddCSLuaFile()
ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Black Market NPC"
ENT.Author = "Leonheart#7476"
ENT.Category = "Leonheart NPCs"
ENT.Spawnable = true
ENT.AdminOnly = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/Eli.mdl")
        self:SetHullType(HULL_HUMAN)
        self:SetHullSizeNormal()
        self:SetNPCState(NPC_STATE_SCRIPT)
        self:SetSolid(SOLID_BBOX)
        self:CapabilitiesAdd(CAP_ANIMATEDFACE)
        self:SetUseType(SIMPLE_USE)

        timer.Simple(1, function()
            if IsValid(self) then
                self:setAnim()
            end
        end)
    end

    function ENT:OnTakeDamage()
        return false
    end

    function ENT:AcceptInput(Name, Activator, Caller)
        if Name == "Use" and Caller:IsPlayer() then
            if not Caller:GetNWBool("npc_cooldown", false) then
                net.Start("ui_import_npc_drugs")
                net.Send(Caller)
            else
                Caller:notify("You need to wait for your shipment to arrive before using this again!")
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
        drawText("Johnny Smithie", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
        drawText("Wanna get some funny stuff?", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
    end
end

function ENT:setAnim()
    for k, v in ipairs(self:GetSequenceList()) do
        if v:lower():find("idle") and v ~= "idlenoise" then return self:ResetSequence(k) end
    end

    self:ResetSequence(4)
end