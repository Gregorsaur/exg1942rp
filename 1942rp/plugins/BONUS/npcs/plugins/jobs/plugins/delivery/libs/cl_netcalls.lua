net.Receive("delivery_setwaypoint", function()
    local setNew = net.ReadBool()

    if not setNew then
        LocalPlayer().DeliveryWaypoint = nil

        return
    end

    LocalPlayer().DeliveryWaypoint = {
        Name = net.ReadString(),
        Position = net.ReadVector()
    }
end)

hook.Add("HUDPaint", "DeliveryNPC::DeliveryLocation", function()
    local info = LocalPlayer().DeliveryWaypoint
    if not info then return end
    local dist = LocalPlayer():GetPos():Distance(info.Position)
    local spos = info.Position:ToScreen()
    local howclose = math.Round(dist / 40)
    if not spos then return end
    surface.SetFont("CenterPrintText")
    local t_w, t_h = surface.GetTextSize("A")
    draw.DrawText(info.Name, "CenterPrintText", spos.x + 1, spos.y + 1, color_black, TEXT_ALIGN_CENTER)
    draw.DrawText(info.Name, "CenterPrintText", spos.x, spos.y, Color(123, 57, 209), TEXT_ALIGN_CENTER)
    spos.y = spos.y + t_h
    draw.DrawText(howclose .. " m", "CenterPrintText", spos.x + 1, spos.y + 1, color_black, TEXT_ALIGN_CENTER)
    draw.DrawText(howclose .. " m", "CenterPrintText", spos.x, spos.y, color_white, TEXT_ALIGN_CENTER)
    spos.y = spos.y + t_h

    if howclose < 30 then
        draw.DrawText(howclose .. " m", "CenterPrintText", spos.x + 1, spos.y + 1, color_black, TEXT_ALIGN_CENTER)
        draw.DrawText("/deliver to Drop Off", "CenterPrintText", spos.x, spos.y, color_white, TEXT_ALIGN_CENTER)
        spos.y = spos.y + t_h
    end
end)

net.Receive("delivery_sendtruck_cl", function()
    LocalPlayer()[net.ReadString()] = net.ReadEntity()
end)