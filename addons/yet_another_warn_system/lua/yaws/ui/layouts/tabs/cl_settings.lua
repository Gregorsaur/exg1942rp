function YAWS.UI.Tabs.Settings(master)
    master:Clear()

    -- Settings Panel
    local scrollContainer = vgui.Create("DPanel", master)
    scrollContainer.Paint = function() end 
    local settingsPanel = vgui.Create("yaws.scroll", scrollContainer)
    
    local panels = {}
    local i = 0
    local max = table.Count(YAWS.UserSettings.Settings) -- Not numerically indexed ;-;
    
    for category,settings in ipairs(YAWS.UserSettings.SettingOrder) do
        local panel = vgui.Create("yaws.collapsable", settingsPanel)
        panel:SetLabel(YAWS.Language.GetTranslation("user_settings_category_" .. YAWS.UserSettings.Settings[settings[1]].category))
        panels[#panels + 1] = {
            panel = panel,
            shit = true
        }
    
        local settingEntrys = vgui.Create("yaws.panel", panel)
        settingEntrys:RemoveShadows()
        -- settingEntrys.Paint = function(self, w, h) end 
    
        panel:SetContents(settingEntrys)
    
        -- for k,v in pairs(YAWS.UserSettings.Settings) do
        for k,v in ipairs(settings) do 
            i = i + 1
            local k,v = v, YAWS.UserSettings.Settings[v] -- ah the glory of laziness of changing around variable names (and comments apparently)

            local panel = vgui.Create("yaws.settings_entry", settingEntrys)
            panel:SetName(YAWS.Language.GetTranslation(v.name))
            panel:SetDesc(YAWS.Language.GetTranslation(v.desc))
            panel:SetType(v.type)
            panel:Construct()
            if(v.value != nil) then
                panel:SetValue(v.value)
            else 
                panel:SetValue(v.default)
            end

            -- Switch
            if(v.type == "boolean") then
                panel.OnChange = function(val)
                    YAWS.UserSettings.SetValue(k, val)
                end
            end

            -- Combo Box
            if(v.type == "combo") then
                panel:SetOptions(v.options, v.icons or nil)
                panel.OnChange = function(index, value, data)
                    YAWS.UserSettings.SetValue(k, value)
                end

                panel.element:Dim()
            end

            panels[#panels + 1] = {
                ['panel'] = panel
            }
        end
    end
    
    settingsPanel.PerformLayout = function(s, w, h)
        for x,y in ipairs(panels) do
            y.panel:Dock(TOP)

            if(!y.shit) then 
                y.panel:UseReccomendedHeight()
            else 
                y.panel.Header:SetTall(h * 0.075)
            end 
        end
    end

    master.Paint = function(self, w, h) end
    master.PerformLayout = function(self, w, h)
        scrollContainer:Dock(FILL)
        scrollContainer:DockMargin(10, 10, 10, 10)

        settingsPanel:Dock(FILL)
        settingsPanel:DockMargin(0, 0, 0, 0)
    end
    
    master:InvalidateLayout()
end