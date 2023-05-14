function YAWS.UI.EditPreset(presetData)
    local frame = vgui.Create("yaws.frame")
    frame:SetSize(ScrW() * 0.5, ScrH() * 0.098)
    frame:Center()
    frame:MakePopup()
    frame.bgColor = Color(0, 0, 0, 200)
    frame:DoModal()
    local oldName = presetData.name
    
    local master = vgui.Create("DPanel", frame)
    frame.PerformLayout = function(self, w, h)
        master:Dock(FILL)
        
        if(!YAWS.UserSettings.GetValue("disable_fades")) then 
            frame:FadeIn()
        end
    end 
    
    local settings = vgui.Create("yaws.panel", master)
    settings.Paint = function(self, w, h) 
        -- draw.RoundedBox(0, 0, 0, w, h, Color(0, 255, 0))
    end 
    settings:RemoveShadows()
    
    local name = vgui.Create("yaws.text_entry", settings)
    name:SetPlaceholder(YAWS.Language.GetTranslation("admin_tab_presets_name"))
    name:SetMaximumCharCount(25)
    name:SetValue(presetData.name)
    
    local reason = vgui.Create("yaws.text_entry", settings)
    reason:SetPlaceholder(YAWS.Language.GetTranslation("admin_tab_presets_reason"))
    reason:SetMaximumCharCount(150)
    reason:SetValue(presetData.reason)
    
    local points = vgui.Create("yaws.wang", settings)
    points:SetText("")
    points:SetPlaceholder(YAWS.Language.GetTranslation("generic_point_count"))
    points:SetMin(0)
    points:SetMax(YAWS.Config.GetValue("player_warn_maxpoints"))
    points:SetValue(presetData.points)
    
    settings.PerformLayout = function(self, w, h)
        name:Dock(LEFT)
        name:SetWidth(w * 0.2)
        
        reason:Dock(LEFT)
        reason:DockMargin(10, 0, 0, 0)
        reason:SetWidth((w * 0.65) - 10)
        
        points:Dock(RIGHT)
        points:SetWidth(w * 0.15 - 9)
    end 
    
    
    local buttonPanel = vgui.Create("DPanel", master)
    buttonPanel.Paint = function(self, w, h)
        -- draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0))
    end 
    
    local cancel = vgui.Create("yaws.button", buttonPanel)
    cancel:SetLabel(YAWS.Language.GetTranslation("generic_cancel"))
    cancel:SetColors('button_warn_base', 'button_warn_hover')
    cancel.DoClick = function() 
        frame:Close()
    end 
    
    local save = vgui.Create("yaws.button", buttonPanel)
    save:SetLabel(YAWS.Language.GetTranslation("generic_save"))
    save.DoClick = function() 
        YAWS.UI.CurrentData.WaitingForServerResponse = true 
        YAWS.UI.DisplayLoading(YAWS.UI.CurrentData.MasterCache)
        
        net.Start("yaws.config.editpreset")
        net.WriteString(oldName)
        net.WriteString(name:GetValue())
        net.WriteString(reason:GetValue())
        net.WriteUInt(points:GetValue(), 12)
        net.SendToServer()
        
        YAWS.UI.LoadingCache = {
            panel = "edit_preset",
            oldName = oldName,
            name = name:GetValue(),
            reason = reason:GetValue(),
            points = points:GetValue()
        }
        
        frame:Close()
    end 
    
    master.Paint = function(self, w, h) end 
    master.PerformLayout = function(self, w, h) 
        buttonPanel:Dock(BOTTOM)
        buttonPanel:DockPadding(10, 10, 10, 10)
        buttonPanel:SetTall(h * 0.55)
        
        save:Dock(RIGHT)
        save:SetWide(w * 0.25)
        save:DockMargin(0, 0, 10, 0)
        
        cancel:Dock(RIGHT)
        cancel:SetWide(w * 0.25)
        
        settings:Dock(FILL)
        settings:DockMargin(10, 10, 10, 0)
    end
    master:InvalidateLayout()
end