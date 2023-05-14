function YAWS.UI.ViewWarning(playerData, warnData)
    local frame = vgui.Create("yaws.frame")
    frame:SetSize(ScrW() * 0.5, ScrH() * 0.28)
    frame:Center()
    frame:MakePopup()
    frame.bgColor = Color(0, 0, 0, 200)
    frame:DoModal()

    local master = vgui.Create("DPanel", frame)
    frame.PerformLayout = function(self, w, h)
        master:Dock(FILL)

        if(!YAWS.UserSettings.GetValue("disable_fades")) then 
            frame:FadeIn()
        end
    end 

    local playersPanel = vgui.Create("yaws.panel", master)

    local user = vgui.Create("yaws.round_avatar", playersPanel)
    user:SetSteamID(warnData.player, 256)
    local admin = vgui.Create("yaws.round_avatar", playersPanel)
    admin:SetSteamID(warnData.adminSteamID, 256)
    
    playersPanel.PostPerformLayout = function(self, w, h)
        user:Dock(LEFT)
        user:DockMargin(10, 10, 10, 10)
        user:SetWide(user:GetTall())
            
        admin:Dock(RIGHT)
        admin:DockMargin(10, 10, 10, 10)
        admin:SetWide(admin:GetTall())
    end 
    local adminRealSteamID = util.SteamIDFrom64(warnData.adminSteamID)
    playersPanel.Paint = function(self, w, h)
        local colors = YAWS.UI.ColorScheme()
        draw.RoundedBox(0, 0, 0, w, h, colors['panel_background'])
    
        draw.SimpleText(playerData.name, "yaws.10", h + 5, h * 0.375, colors['text_header'], 0, 1)
        draw.SimpleText(playerData.realSteamID, "yaws.7", h + 5, h * 0.625, colors['text_main'], 0, 1)
    
        draw.SimpleText(warnData.admin, "yaws.10", w - (h + 5), h * 0.375, colors['text_header'], 2, 1)
        draw.SimpleText(adminRealSteamID, "yaws.7", w - (h + 5), h * 0.625, colors['text_main'], 2, 1)
    end 
    
    local infoPanel = vgui.Create("yaws.panel", master)
    infoPanel.Paint = function(self, w, h)
        local colors = YAWS.UI.ColorScheme() 
        draw.RoundedBox(0, 0, 0, w, h, colors['panel_background'])

        local _,baseH = draw.SimpleText(YAWS.Language.GetTranslation("viewing_warn_time"), "yaws.9", 10, 10, colors['text_header'], 0, 0)
        draw.SimpleText(os.date("%H:%M:%S on %d/%m/%Y", warnData.timestamp), "yaws.7", 10, baseH + 10, colors['text_header'], 0, 0)
        
        draw.SimpleText(YAWS.Language.GetTranslation('viewing_warn_point'), "yaws.9", w / 2, 10, colors['text_header'], 1, 0)
        draw.SimpleText(YAWS.Language.GetFormattedTranslation("points_format", warnData.points), "yaws.7", w / 2, baseH + 10, colors['text_header'], 1, 0)
        
        draw.SimpleText(YAWS.Language.GetTranslation("viewing_warn_server"), "yaws.9", w - 10, 10, colors['text_header'], 2, 0)
        local _,subtractMe = draw.SimpleText(warnData.server_id, "yaws.7", w - 10, baseH + 10, colors['text_header'], 2, 0)
        
        draw.SimpleText(YAWS.Language.GetTranslation("viewing_warn_reason"), "yaws.9", 10, h - (subtractMe + baseH + 10), colors['text_header'], 0, 0)
        draw.SimpleText(warnData.reason, YAWS.UI.ScaleFont(warnData.reason, w, 5, 7), 10, h - subtractMe, colors['text_header'], 0, 1)
    end 

    local actionPanel = vgui.Create("yaws.panel", master)
    -- actionPanel:DockPadding(10, 10, 10, 10)
    actionPanel:RemoveShadows()
    
    local goBackButton = vgui.Create("yaws.button", actionPanel)
    goBackButton:SetLabel(YAWS.Language.GetTranslation("generic_back"))
    goBackButton.DoClick = function()
        frame:Close()
    end

    local deleteButton 
    if(YAWS.UI.CurrentData.can_view.delete_warns) then 
        deleteButton = vgui.Create("yaws.button", actionPanel)
        deleteButton:SetLabel(YAWS.Language.GetTranslation("generic_delete"))
        deleteButton:SetColors('button_warn_base', 'button_warn_hover')
        deleteButton.DoClick = function()
            frame:Close()
            if(YAWS.UI.CurrentData.FrameCache) then 
                YAWS.UI.CurrentData.FrameCache:Close()
            end 
            
            net.Start("yaws.warns.deletewarn")
            net.WriteString(warnData.id)
            net.SendToServer()
        end
    end 
    
    actionPanel.Paint = function() end 
    actionPanel.PerformLayout = function(self, w, h)
        if(deleteButton) then 
            goBackButton:Dock(LEFT)
            goBackButton:SetWide((w * 0.5) - 5)

            deleteButton:Dock(RIGHT)
            deleteButton:SetWide((w * 0.5) - 5)
        else 
            goBackButton:Dock(FILL)
        end 
    end 
    
    master.Paint = function(self, w, h) end 
    master.PerformLayout = function(self, w, h) 
        playersPanel:Dock(TOP)
        playersPanel:SetHeight(h * 0.321)
        playersPanel:DockMargin(10, 10, 10, 10)

        infoPanel:Dock(FILL)
        infoPanel:DockMargin(10, 0, 10, 10)
    
        actionPanel:Dock(BOTTOM)
        actionPanel:SetHeight(33)
        actionPanel:DockMargin(10, 0, 10, 10)
    end
    master:InvalidateLayout()
end