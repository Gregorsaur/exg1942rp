local PLUGIN = PLUGIN
ENT.PrintName = "Car dealer"
ENT.Author = "Barata"
ENT.Category = "Leonheart NPCs"
ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.SaveType = "cardealer"

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/gman_high.mdl")
        self:SetSolid(SOLID_BBOX)
        self:SetUseType(SIMPLE_USE)
        self:SetCollisionGroup(COLLISION_GROUP_NONE)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        PLUGIN:Register(self) --Register for permaprops

        timer.Simple(1, function()
            if IsValid(self) then
                self:setAnim()
            end
        end)
    end

    function ENT:Use(client)
        net.Start("car_dealer")
        net.WriteEntity(self)
        net.Send(client)
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
        drawText("Car Dealer", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
        drawText("Buy and Retrieve your vehicle!", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
    end
end

function ENT:setAnim()
    for k, v in ipairs(self:GetSequenceList()) do
        if v:lower():find("idle") and v ~= "idlenoise" then return self:ResetSequence(k) end
    end

    self:ResetSequence(4)
end