AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Import Item"
ENT.Author = "Barata"
ENT.Category = "NutScript"
ENT.Spawnable = true
ENT.AdminOnly = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/Items/item_item_crate.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        local phys = self:GetPhysicsObject()

        if phys:IsValid() then
            phys:Wake()
        end
    end

    function ENT:Use(activator, caller)
        if self:GetNWInt("imported_owner") then
            if self:GetNWInt("imported_owner") == caller:EntIndex() then
                local item = self:GetNWString("imported_item")
                local itemTable = nut.item.list[item]
                caller:getChar():getInv():add(item)
                self:Remove()
                caller:notify("You've picked up a " .. itemTable.name .. " from the package!")
            else
                caller:notify("You do not own this!")
            end
        end
    end
end