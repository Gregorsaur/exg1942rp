ENT.Type = "anim"
ENT.PrintName = "Type Writer"
ENT.Category = "NutScript"
ENT.DisplayName = "Type Writer"
ENT.Model = "models/props_lab/citizenradio.mdl"
ENT.Spawnable = true
ENT.AdminOnly = true

if SERVER then
    function ENT:setupVars()
        self:setNetVar("id", 0)
        self:setNetVar("name", "")
        self:setNetVar("messages", {})
    end

    function ENT:Initialize()
        self:SetModel(self.Model)
        self:SetUseType(SIMPLE_USE)
        self:SetMoveType(MOVETYPE_NONE)
        self:DrawShadow(true)
        self:SetSolid(SOLID_BBOX)
        self:PhysicsInit(SOLID_BBOX)

        local physObj = self:GetPhysicsObject()

	    if (IsValid(physObj)) then
		    physObj:EnableMotion(false)
		    physObj:Sleep()
	    end
    end

    function ENT:Use(client)
        if not IsValid(client) then return end

        netstream.Start(client, "nut_type_writer_send", self:getNetVar("id", 0))
    end

    function ENT:OnRemove()
        hook.Run("WriterRemoved", self)
    end
else
    local TEXT_OFFSET = Vector(0, 0, 20)
    local toScreen = FindMetaTable("Vector").ToScreen
    local colorAlpha = ColorAlpha
    local drawText = nut.util.drawText
    local configGet = nut.config.get

    ENT.DrawEntityInfo = true

    function ENT:onDrawEntityInfo(alpha)
        local subname = self:getNetVar("name", nil)
        local position = toScreen(self:LocalToWorld(self:OBBCenter()) + TEXT_OFFSET)
        local x, y = position.x, position.y

        drawText(
            self.DisplayName,
            x, y,
            colorAlpha(configGet("color"), alpha),
            1, 1,
            nil,
            alpha * 0.65
        )

        if subname then 
            drawText(
                subname,
                x, y + 16,
                colorAlpha(configGet("color"), alpha),
                1, 1,
                "nutSmallFont",
                alpha * 0.65
            )
        end
    end
end