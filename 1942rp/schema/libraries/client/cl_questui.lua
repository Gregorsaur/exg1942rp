WW2 = WW2 or {}

function SCHEMA:HUDPaint()
    local ply = LocalPlayer()
    local character = ply:getChar()
    local width, height = ScrW(), ScrH()
    local format = "%A, %d %B 1941 %X"
    local xOF = 320
    local y = 50
    local timer = 0
    if not character then return end

    if timer < CurTime() then
        timer = CurTime() + 0.5
        surface.SetFont("MAIN_Font32")
        y = y + 12
        WW2.DrawShadowText("Current Time:", width - xOF, y, nil, false)
        y = y + 26
        surface.SetFont("MAIN_Font24")
        WW2.DrawShadowText(os.date(format, nut.date.get()), width - xOF, y, nil, false)
        y = y + 21
    end
end

function WW2.DrawShadowText(txt, x, y, c, centered)
    WW2.ColorShadow = Color(255, 255, 255)
    surface.SetTextColor(WW2.ColorShadow)
    local width, height = surface.GetTextSize(txt)
    x = x - (centered and (width / 2) or 0)
    surface.SetTextPos(x + 2, y + 2)
    surface.DrawText(txt)
end