function YAWS.UI.DisplayLoading(master)
    master.PerformLayout = function(self, w, h) end
    master:Clear()
    
    local clr = YAWS.UI.ColorScheme()['text_header']
    master.loadRotation = 0

    -- yes this is a crude attempt at a easter egg
    master.text = ((math.random(0, 100) < 99) && YAWS.Language.GetTranslation("loading")) || YAWS.Language.GetTranslation("loading_hehe")

    master.Paint = function(self, w, h) 
        master.loadRotation = Lerp(RealFrameTime() * 100, master.loadRotation, master.loadRotation + 1)

        draw.NoTexture()
        surface.SetMaterial(YAWS.UI.MaterialCache['load'])
        YAWS.UI.SetSurfaceDrawColor(clr)
        surface.DrawTexturedRectRotated(w /2 , h / 2, w * 0.05, w * 0.05, master.loadRotation)

        draw.SimpleText(master.text, "yaws.8", w / 2, (h * 0.45) + (w * 0.05) + (h * 0.05), clr, 1, 1)
    end

    master:InvalidateLayout()
end

function YAWS.UI.ConfirmDeleteWarns(master, data)
    master.PerformLayout = function(self, w, h) end
    master:Clear()
        
    master.Paint = function(self, w, h) 
        local colors = YAWS.UI.ColorScheme()

        draw.SimpleText(YAWS.Language.GetFormattedTranslation("viewing_player_wipe_header", data.name), "yaws.9", w / 2, h * 0.46, colors['text_header'], 1, 1)
        draw.SimpleText(YAWS.Language.GetTranslation("viewing_player_wipe_subtext"), "yaws.7", w / 2, h * 0.505, colors['text_main'], 1, 1)
    end

    local buttons = vgui.Create("DPanel", master)
    buttons.Paint = function() end 

    local confirm = vgui.Create("yaws.button", buttons)
    confirm:SetLabel(YAWS.Language.GetTranslation("generic_save"))
    confirm.DoClick = function() 
        net.Start("yaws.warns.wipewarns")
        net.WriteString(data.steamid)
        net.SendToServer()
    
        if(YAWS.UI.CurrentData.FrameCache) then 
            YAWS.UI.CurrentData.FrameCache:Close()
        end 
    end 

    local back = vgui.Create("yaws.button", buttons)
    back:SetColors("button_warn_base", "button_warn_hover")
    back:SetLabel(YAWS.Language.GetTranslation("generic_cancel"))
    back.DoClick = function() 
        YAWS.UI.DisplayPlayerInfo(master, data)
    end 
    
    master.PerformLayout = function(self, w, h) 
        buttons:SetPos(master:GetWide() * 0.2, master:GetTall() * 0.55)
        buttons:SetSize(master:GetWide() * 0.6, master:GetTall() * 0.056)

        confirm:Dock(LEFT)
        confirm:SetWide((buttons:GetWide() / 2) - 5)

        back:Dock(RIGHT)
        back:SetWide((buttons:GetWide() / 2) - 5)
    end
    master:InvalidateLayout()
end 


net.Receive("yaws.warns.confirmupdate", function(len)
    YAWS.Core.PayloadDebug("yaws.warns.confirmupdate", len)
    if(!YAWS.UI.CurrentData.WaitingForServerResponse) then 
        YAWS.Core.LogWarning("[yaws.warns.confirmupdate] Just got a message from the server without wanting data from the server..?")
        return
    end 

    local success = net.ReadBool()
    if(success) then 
        if(YAWS.UI.LoadingCache['panel'] == "wipe_warns") then 
            YAWS.UI.LoadingCache['data'].warnData.warnings = {}
            YAWS.UI.LoadingCache['data'].warnData.expiredPointCount = 0
            YAWS.UI.LoadingCache['data'].warnData.pointCount = 0
        end 
    end 

    YAWS.UI.CurrentData.FrameCache:SetSidebarSelectedName(YAWS.Language.GetTranslation("sidebar_players"))
    YAWS.UI.DisplayPlayerInfo(YAWS.UI.CurrentData.MasterCache, YAWS.UI.LoadingCache['data'])
    YAWS.UI.CurrentData.WaitingForServerResponse = false
end)