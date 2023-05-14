include("shared.lua")

net.Receive("taxi_sendtruck_cl", function()
    LocalPlayer().taxiEnt = net.ReadEntity()
end)

local TEXT_OFFSET = Vector(0, 0, 20)
local toScreen = FindMetaTable("Vector").ToScreen
local colorAlpha = ColorAlpha
local drawText = nut.util.drawText
local configGet = nut.config.get
ENT.DrawEntityInfo = true

function ENT:onDrawEntityInfo(alpha)
    local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
    local x, y = position.x, position.y
    --local desc = self.getNetVar(self, "desc")
    drawText("Amaboutoblow", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
    --if (desc) then
    drawText("Need some work?", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
    --end
end