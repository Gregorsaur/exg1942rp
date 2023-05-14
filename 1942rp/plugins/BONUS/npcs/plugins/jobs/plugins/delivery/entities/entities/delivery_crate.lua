AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "Delivery Crate"
ENT.Author = "Leonheart#7476"
ENT.Category = "Leonheart NPCs"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.DrawEntityInfo = true

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/props/cs_militia/crate_extrasmallmill.mdl")
        self:SetUseType(SIMPLE_USE)
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetTrigger(true)
        local physObj = self:GetPhysicsObject()

        if IsValid(physObj) then
            physObj:EnableMotion(true)
            physObj:Wake()
        end
    end
end

if SERVER then
    function ENT:StartTouch(ent)
        if not self.Affixed and ent.DeliveryTruck and ent.DeliveryTruckOwner == self.CrateOwner and not IsValid(ent.DeliveryCrateAttached) then
            self.Affixed = true
            self:SetTrigger(false)
            self:SetParent(ent)
            self:SetPos(Vector(-100, 0, 25))
            self:SetAngles(Angle(0, 0, 0))
            constraint.NoCollide(self, ent, 0, 0)
            ent.DeliveryCrateAttached = self
        end
    end
else
    function ENT:onDrawEntityInfo(alpha)
        local position = self.LocalToWorld(self, self.OBBCenter(self)):ToScreen()
        local x, y = position.x, position.y
        nut.util.drawText("Delivery Crate", x, y, ColorAlpha(nut.config.get("color"), alpha), 1, 1, nil, alpha * 0.65)
    end
end