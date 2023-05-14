AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/odessa.mdl")
    self:SetSkin(13)
    self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)
    self:DrawShadow(true)
    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
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
    if Name == "Use" and Caller:IsPlayer() and Caller:Team() == FACTION_DELIVERY then
        net.Start("ui_delivery_hired_npc")
        net.Send(Caller)
    else
        net.Start("ui_delivery_npc")
        net.Send(Caller)
    end
end