function YAWS.UI.WarnPlayerPopup(data)
    local inPreset = false

    local frame = vgui.Create("yaws.frame")
    frame:SetSize(ScrW() * 0.45, ScrH() * 0.28)
    frame:Center()
    frame:MakePopup()
    frame.bgColor = Color(0, 0, 0, 200)

    local panel = vgui.Create("DPanel", frame)
    panel.Paint = function() end 

    local playerPanel = vgui.Create("yaws.panel", panel)
    local picture = vgui.Create("yaws.round_avatar", playerPanel)
    picture:SetSteamID(data.steamid, 256)
    playerPanel.PostPerformLayout = function(self, w, h)
        picture:Dock(LEFT)
        picture:DockMargin(10, 10, 10, 10)
        picture:SetWide(picture:GetTall())
    end 
    playerPanel.Paint = function(self, w, h)
        local colors = YAWS.UI.ColorScheme()
        draw.RoundedBox(0, 0, 0, w, h, colors['panel_background'])

        draw.SimpleText(data.name, "yaws.10", h + (5), h * 0.375, colors['text_header'], 0, 1)
        draw.SimpleText(data.realSteamID, "yaws.7", h + (5), h * 0.625, colors['text_main'], 0, 1)
    end 

    

    local presetSelection = vgui.Create("yaws.combo", panel)
    presetSelection:SetText(YAWS.Language.GetTranslation("admin_tab_warning_presets_box"))
    for k,v in pairs(YAWS.UI.CurrentData.current_presets) do
        presetSelection:AddChoice(k)
    end
    if(table.Count(YAWS.UI.CurrentData.current_presets) <= 0) then
        presetSelection:SetEnabled(false)
    end 
    
    local reason = vgui.Create("yaws.text_entry", panel)
    reason:SetPlaceholder(YAWS.Language.GetTranslation("admin_tab_warning_reason_placeholder"))
    reason:SetUpdateOnType(true)
    reason:SetMaximumCharCount(150)
    reason.OnValueChange = function(self, value)
        if(!inPreset) then return end 
        inPreset = false
        presetSelection:SetText(YAWS.Language.GetTranslation("admin_tab_warning_presets_box"))
    end
    
    local points = vgui.Create("yaws.wang", panel)
    points:SetUpdateOnType(true)
    points:SetMin(0)
    points:SetMin(YAWS.Config.GetValue("player_warn_maxpoints"))
    points:SetText("")
    points:SetPlaceholder(YAWS.Language.GetTranslation("generic_point_count"))
    points.OnValueChanged = function(self, value)
        if(!inPreset) then return end 
        inPreset = false
        presetSelection:SetText(YAWS.Language.GetTranslation("admin_tab_warning_presets_box"))
    end

    if(!YAWS.UI.CurrentData['can_view']['custom_reasons']) then 
        reason:SetEnabled(false)
        points:SetEnabled(false)
    end 

    presetSelection.OnSelect = function(self, index, value, data)
        local preset = YAWS.UI.CurrentData.current_presets[value]
        if(!preset) then return end

        inPreset = false
        reason:SetValue(preset.reason)
        points:SetValue(preset.points)
        inPreset = true
    end 

    local bottomPanel = vgui.Create("DPanel", frame)
    bottomPanel.Paint = function() end 

    local submit = vgui.Create("yaws.button", bottomPanel)
    submit:SetLabel(YAWS.Language.GetTranslation("warn_player_submit"))
    submit.DoClick = function()
        if(!YAWS.UI.CurrentData['can_view']['custom_reasons']) then 
            if(!presetSelection:GetSelected()) then return end 
        else 
            if(string.Trim(reason:GetValue()) == "") then return end 
            if(string.Trim(points:GetValue()) == "") then return end 
        end

        if(points:GetValue() < 0) then return end -- prevents integer underflow - just incase :)
        net.Start("yaws.warns.warnplayer")
        net.WriteBool(false)
        net.WriteString(data.steamid)
        if(!YAWS.UI.CurrentData['can_view']['custom_reasons']) then 
            net.WriteString(presetSelection:GetSelected())
        else 
            net.WriteString(reason:GetValue())
            net.WriteUInt(points:GetValue(), 12)
        end 
        
        net.SendToServer()

        frame:Close()
        YAWS.UI.CurrentData.FrameCache:Close()
    end 
    
    panel.PerformLayout = function(self, w, h) 
        playerPanel:Dock(TOP)
        playerPanel:SetHeight(h * 0.386)
        playerPanel:DockMargin(0, 0, 0, 10)

        presetSelection:Dock(TOP)
        presetSelection:DockMargin(0, 0, 0, 10)
        presetSelection:SetTall(h * 0.143)

        reason:Dock(TOP)
        reason:DockMargin(0, 0, 0, 10)
        reason:SetTall(h * 0.143)

        points:Dock(TOP)
        points:DockMargin(0, 0, 0, 10)
        points:SetTall(h * 0.143)
    end 

    local close = vgui.Create("yaws.button", bottomPanel)
    close:SetLabel(YAWS.Language.GetTranslation("generic_cancel"))
    close:SetColors('button_warn_base', 'button_warn_hover')
    close.DoClick = function() 
        frame:Close()
    end 
    
    frame.PerformLayout = function(self, w, h)
        bottomPanel:Dock(BOTTOM)
        bottomPanel:SetHeight(h * 0.12)
        bottomPanel:DockMargin(10, 10, 10, 10)
        
        submit:Dock(LEFT)
        submit:SetWide(bottomPanel:GetWide() * 0.5 - 5)
        
        close:Dock(RIGHT)
        close:SetWide(bottomPanel:GetWide() * 0.5 - 5)
        
        panel:Dock(FILL)
        panel:DockPadding(10, 10, 10, 10)

        if(!YAWS.UserSettings.GetValue("disable_fades")) then 
            frame:FadeIn()
        end
    end 
end