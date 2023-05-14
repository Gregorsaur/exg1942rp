AddCSLuaFile()
ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Jailer NPC"
ENT.Author = "Leonheart#7476"
ENT.Category = "Leonheart NPCs"
ENT.Spawnable = true
ENT.AdminOnly = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/odessa.mdl")
        self:SetHullType(HULL_HUMAN)
        self:SetHullSizeNormal()
        self:SetSolid(SOLID_BBOX)
        self:CapabilitiesAdd(CAP_ANIMATEDFACE)
        self:SetUseType(SIMPLE_USE)
    end

    function ENT:OnTakeDamage()
        return false
    end

    function ENT:Use(activator, caller, useType, value)
        if activator:Team() == FACTION_NYPD or activator:IsAdmin() then
            net.Start("jailer_npc")
            net.Send(activator)
        else
            activator:notify("You can't use this!")
        end
    end
end