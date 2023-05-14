SCHEMA.version = "BETA 1.0"
resource.AddFile("barata_is_my_daddy/logo.png")
local agLogo = Material("barata_is_my_daddy/logo.png")

hook.Add("HUDPaint", "watermarkpaint", function()
    local w, h = 45, 45
    surface.SetMaterial(agLogo)
    surface.SetDrawColor(255, 255, 255, 80)
    surface.DrawTexturedRect(5, ScrH() - h - 5, w, h)
    surface.SetTextColor(255, 255, 255, 80)
    surface.SetFont("nutSmallChatFont")
    local tw, th = surface.GetTextSize(SCHEMA.version)
    surface.SetTextPos(15 + w, ScrH() - 5 - h / 2 - th / 2)
    surface.DrawText(SCHEMA.version)
end)