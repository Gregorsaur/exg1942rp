function YAWS.UI.Tabs.Admin(master)
    master:Clear()

    -- Content Panel
    local settingsSidebar = vgui.Create("yaws.sidebar", master)

    local panelContainer = vgui.Create("DPanel", master)
    panelContainer.Paint = function() end 

    local settingsPanel = vgui.Create("yaws.panel", panelContainer)
    settingsPanel:RemoveShadows()
    
    -- this is really shit but idk how else to make this work properly
    local function clearPanel(hidePanelShadow)
        panelContainer:Clear()

        settingsPanel:Remove()
        settingsPanel = vgui.Create("yaws.panel", panelContainer)
        settingsPanel:HideShadows(hidePanelShadow)

        master.PerformLayout = function(self, w, h)
            settingsSidebar:Dock(LEFT)
            settingsSidebar:SetWide((w * 0.1) + 3)
            settingsSidebar:DockMargin(10, 10, 5, 10)
            
            panelContainer:Dock(FILL)
            panelContainer:DockMargin(0, 0, 0, 0)
    
            settingsPanel:Dock(FILL)
            settingsPanel:DockMargin(5, 10, 10, 10)
        end 
        master:InvalidateLayout()
    end 

    settingsSidebar:AddTab(YAWS.Language.GetTranslation("admin_tab_sidebar_permissions"), YAWS.UI.MaterialCache['permissions'], true, function()
        settingsPanel:Clear() 
        clearPanel(true)
        settingsPanel.Paint = function() end 

        -- Permissions Shit
        local groupSelect = vgui.Create("yaws.combo", panelContainer)
        for k,v in pairs(CAMI.GetUsergroups()) do 
            groupSelect:AddChoice(k, k)
        end 
        
        -- The actual permissions entries
        local grid = vgui.Create("yaws.grid", settingsPanel)
        grid:SetColumns(2)
        grid:SetHorizontalMargin(10)
        grid:SetVerticalMargin(10)
        grid:InvalidateParent(true)
        
        local changed = {}
        groupSelect.OnSelect = function(self, index, value, data)
            grid:Clear()
            
            local defaults = {}
            if(YAWS.UI.CurrentData['admin_settings']['current_permissions'][value]) then 
                defaults = YAWS.UI.CurrentData['admin_settings']['current_permissions'][value]
            end 

            if(!YAWS.UI.PermissionsNames) then 
                YAWS.UI.UpdatePermissionNames()
            end 
            for k,v in ipairs(YAWS.UI.Permissions) do
                local entry = vgui.Create("yaws.permissions_entry", grid)
                entry:SetName(YAWS.UI.PermissionsNames[v])
                entry:SetHeight(50)
                if(defaults[v]) then 
                    entry:SetValue(defaults[v])
                end 
                entry.OnChange = function(val)
                    if(!changed[value]) then 
                        changed[value] = {} 
                    end 
                    changed[value][v] = val
                end 
                
                grid:AddCell(entry)
                grid:SetHorizontalMargin(10)
                grid:SetVerticalMargin(10)
            end
        end
        groupSelect:ChooseOptionID(1)

        local save = vgui.Create("yaws.button", panelContainer)
        save:SetLabel(YAWS.Language.GetTranslation("generic_save"))
        save.DoClick = function()
            net.Start("yaws.permissions.updatepermissions")

            net.WriteUInt(table.Count(changed), 16)
            for k,v in pairs(changed) do 
                net.WriteString(k)

                net.WriteUInt(table.Count(v), 16)
                for x,y in pairs(v) do 
                    net.WriteString(x)
                    net.WriteBool(y)
                end 
            end 

            net.SendToServer()
        end 
        
        settingsPanel.PostPerformLayout = function(self, w, h)
            grid:Dock(FILL)
        end 
        master.PerformLayout = function(s, w, h)
            settingsSidebar:Dock(LEFT)
            settingsSidebar:SetWide((w * 0.1) + 3)
            settingsSidebar:DockMargin(10, 10, 5, 10)

            groupSelect:Dock(TOP)
            groupSelect:SetHeight(h * 0.059)
            groupSelect:DockMargin(5, 10, 10, 5)

            panelContainer:Dock(FILL)
            panelContainer:DockMargin(0, 0, 0, 0)

            settingsPanel:Dock(FILL)
            settingsPanel:DockMargin(5, 5, 10, 5)

            save:Dock(BOTTOM)
            save:SetHeight(h * 0.055)
            save:DockMargin(5, 5, 10, 10)
        end 

        master:InvalidateLayout()
    end)

    settingsSidebar:AddTab(YAWS.Language.GetTranslation("admin_tab_sidebar_settings"), YAWS.UI.MaterialCache['settings'], true, function()
        settingsPanel:Clear() 
        clearPanel(true)

        settingsPanel.Paint = function() end 
        
        
        local scrollPanel = vgui.Create("yaws.scroll", settingsPanel)
        scrollPanel.Paint = function(self, w, h)
            -- draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0))
        end 
        
        -- Settings n shit
        local panels = {}
        local i = 0
        local changed = {}

        for category,settings in pairs(YAWS.Config.SettingOrder) do
            local panel = vgui.Create("yaws.collapsable", scrollPanel)
            panel:SetLabel(YAWS.Language.GetTranslation("admin_settings_category_" .. YAWS.Config.Settings[settings[1]].category))
            panels[#panels + 1] = {
                panel = panel,
                shit = true
            }

            local settingEntrys = vgui.Create("yaws.panel", panel)
            settingEntrys:RemoveShadows()
            -- settingEntrys.Paint = function(self, w, h) end 

            panel:SetContents(settingEntrys)

            for k,v in ipairs(settings) do 
                i = i + 1
                local k,v = v, YAWS.Config.Settings[v] -- ah the glory of laziness of changing around variable names
                -- local uiData = YAWS.Config.UIData[k]
    
                local panel = vgui.Create("yaws.settings_entry", settingEntrys)
                -- panel:SetName(k)
                panel:SetName(YAWS.Language.GetTranslation("admin_settings_" .. k .. "_name"))
                panel:SetDesc(YAWS.Language.GetTranslation("admin_settings_" .. k .. "_desc"))
                panel:SetType(v.type)
                panel:Construct()
                if(v.value != nil) then
                    panel:SetValue(v.value)
                else 
                    panel:SetValue(v.default)
                end 
    
                -- Text Entry
                if(v.type == "string") then
                    panel.OnChange = function(val)
                        changed[k] = {
                            type = "string",
                            value = val
                        }
                    end
                end
    
                -- Switch
                if(v.type == "boolean") then
                    panel.OnChange = function(val)
                        changed[k] = {
                            type = "boolean",
                            value = val
                        }
                    end
                end
    
                -- Combo Box
                if(v.type == "combo") then
                    panel:SetOptions(v.options)
                    panel.OnChange = function(index, value, data)
                        changed[k] = {
                            type = "combo",
                            value = value
                        }
                    end
    
                    panel.element:Dim()
                end
    
                -- Color
                if(v.type == "color") then
                    panel.OnChange = function(val)
                        changed[k] = {
                            type = "color",
                            value = val
                        }
                    end
                end
    
                -- Number/Integer
                if(v.type == "number") then
                    panel.OnChange = function(val)
                        changed[k] = {
                            type = "number",
                            value = val
                        }
                    end
                end
    
                panels[#panels + 1] = {
                    ['panel'] = panel,
                }
            end 
        end

        local save = vgui.Create("yaws.button", panelContainer)
        save:SetLabel(YAWS.Language.GetTranslation("generic_save"))
        save.DoClick = function()
            net.Start("yaws.config.update")

            net.WriteUInt(table.Count(changed), 16) -- have to bite not using a numerical table here to prevent dupe entries
            for k,v in pairs(changed) do
                net.WriteString(k)

                if(v.type == "string" || v.type == "combo") then 
                    net.WriteString(v.value)
                end 
                if(v.type == "boolean") then 
                    net.WriteBool(v.value)
                end 
                if(v.type == "color") then 
                    net.WriteUInt(v.value.r, 8)
                    net.WriteUInt(v.value.g, 8)
                    net.WriteUInt(v.value.b, 8)
                    net.WriteUInt(v.value.a, 8)
                end 
                if(v.type == "number") then 
                    -- microoptimisations for the win
                    if(k == "point_max") then 
                        net.WriteUInt(v.value, 12)
                        continue 
                    end 

                    net.WriteInt(v.value, 32)
                end 
            end

            net.SendToServer()
        end

        settingsPanel.PostPerformLayout = function(self, w, h)
            scrollPanel:Dock(FILL)

            for x,y in pairs(panels) do
                y.panel:Dock(TOP)

                if(!y.shit) then 
                    y.panel:UseReccomendedHeight()
                else 
                    y.panel.Header:SetTall(h * 0.075)
                end 
            end
        end 
        settingsPanel:InvalidateLayout()

        master.PerformLayout = function(self, w, h)
            settingsSidebar:Dock(LEFT)
            settingsSidebar:SetWide((w * 0.1) + 3)
            settingsSidebar:DockMargin(10, 10, 5, 10)
    
            panelContainer:Dock(FILL)
            panelContainer:DockMargin(0, 0, 0, 0)
    
            settingsPanel:Dock(FILL)
            settingsPanel:DockMargin(5, 10, 10, 5)
    
            save:Dock(BOTTOM)
            save:SetHeight(h * 0.055)
            save:DockMargin(5, 5, 10, 10)
        end 
        master:InvalidateLayout()
    end)

    settingsSidebar:AddTab(YAWS.Language.GetTranslation("admin_tab_sidebar_presets"), YAWS.UI.MaterialCache['paper'], true, function()
        settingsPanel:Clear() 
        clearPanel(true)
        settingsPanel.Paint = function() end 

        local scrollPanel = vgui.Create("yaws.scroll", settingsPanel)
        local max = table.Count(YAWS.UI.CurrentData.current_presets)
        if(max == 0) then 
            scrollPanel.Paint = function(self, w, h)
                local colors = YAWS.UI.ColorScheme()

                YAWS.UI.SetSurfaceDrawColor(colors['sidebutton_dull'])
                surface.SetMaterial(YAWS.UI.MaterialCache['paper'])
                surface.DrawTexturedRect((w / 2) - ((h * 0.11) / 2), h * 0.4, h * 0.11, h * 0.11)
                
                local _,textH = draw.SimpleText(YAWS.Language.GetTranslation("no_presets_found1"), "yaws.8", w / 2, h * 0.55, colors['sidebutton_dull'], 1, 1)
                draw.SimpleText(YAWS.Language.GetTranslation("no_presets_found2"), "yaws.7", w / 2, h * 0.55 + textH, colors['sidebutton_dull'], 1, 1)
            end 
        end 

        local panels = {}
        -- TODO: Find a way to resort these
        for k,v in pairs(YAWS.UI.CurrentData.current_presets) do 
            local panel = vgui.Create("yaws.preset_entry", scrollPanel)
            panel:Dock(TOP)
            panel:DockMargin(0, 0, 0, 10)
            panel:SetHeight(60)
            panel:SetPresetData(k, v)

            panels[#panels + 1] = panel
        end 

        
        local createPreset = vgui.Create("yaws.panel", panelContainer)
        
        local settings = vgui.Create("yaws.panel", createPreset)
        settings.Paint = function() end 
        settings:RemoveShadows()

        local name = vgui.Create("yaws.text_entry", settings)
        name:SetPlaceholder(YAWS.Language.GetTranslation("admin_tab_presets_name"))
        name:SetMaximumCharCount(25)

        local reason = vgui.Create("yaws.text_entry", settings)
        reason:SetPlaceholder(YAWS.Language.GetTranslation("admin_tab_presets_reason"))
        reason:SetMaximumCharCount(150)

        local points = vgui.Create("yaws.wang", settings)
        points:SetText("")
        points:SetPlaceholder(YAWS.Language.GetTranslation("generic_point_count"))
        points:SetMin(0)
        points:SetMax(YAWS.Config.GetValue("player_warn_maxpoints"))

        local create = vgui.Create("yaws.button", createPreset)
        create:SetLabel(YAWS.Language.GetTranslation("admin_tab_presets_create"))
        create.DoClick = function()
            YAWS.UI.CurrentData.WaitingForServerResponse = true 
            YAWS.UI.DisplayLoading(master)

            net.Start("yaws.config.addpreset")
            net.WriteString(name:GetValue())
            net.WriteString(reason:GetValue())
            net.WriteUInt(points:GetValue(), 12)
            net.SendToServer()

            YAWS.UI.LoadingCache = {
                panel = "add_preset",
                name = name:GetValue(),
                reason = reason:GetValue(),
                points = points:GetValue()
            }
        end

        settingsPanel.PerformLayout = function(self, w, h)
            for k,v in ipairs(panels) do 
                v:SetTall(h * 0.128)
            end 
        end 

        settings.PostPerformLayout = function(self, w, h)
            name:Dock(LEFT)
            name:SetWidth(w * 0.2)

            reason:Dock(LEFT)
            reason:DockMargin(10, 0, 0, 0)
            reason:SetWidth((w * 0.65) - 10)

            points:Dock(RIGHT)
            points:SetWidth(w * 0.15 - 9)
        end 

        createPreset.PostPerformLayout = function(self, w, h)
            settings:Dock(TOP)
            settings:SetHeight(h * 0.35)
            settings:DockMargin(10, 10, 10, 10)

            create:Dock(FILL)
            create:DockMargin(10, 0, 10, 10)
        end 

        master.PerformLayout = function(self, w, h)
            settingsSidebar:Dock(LEFT)
            settingsSidebar:SetWide((w * 0.1) + 3)
            settingsSidebar:DockMargin(10, 10, 5, 10)
            
            panelContainer:Dock(FILL)
            panelContainer:DockMargin(0, 0, 0, 0)
    
            settingsPanel:Dock(FILL)
            settingsPanel:DockMargin(5, 10, 10, 10)

            scrollPanel:Dock(FILL)

            createPreset:Dock(BOTTOM)
            createPreset:DockMargin(5, 0, 10, 10)
            createPreset:SetHeight(h * 0.16)
        end 
    end)

    settingsSidebar:AddTab(YAWS.Language.GetTranslation("admin_tab_sidebar_punishments"), YAWS.UI.MaterialCache['gavel'], true, function()
        settingsPanel:Clear() 
        clearPanel(true)

        settingsPanel.Paint = function() end 
    
        local scrollPanel = vgui.Create("yaws.scroll", settingsPanel)
        local max = table.Count(YAWS.UI.CurrentData.admin_settings.current_punishments)
        if(max == 0) then 
            scrollPanel.Paint = function(self, w, h)
                local colors = YAWS.UI.ColorScheme()

                YAWS.UI.SetSurfaceDrawColor(colors['sidebutton_dull'])
                surface.SetMaterial(YAWS.UI.MaterialCache['gavel'])
                surface.DrawTexturedRect((w / 2) - ((h * 0.15) / 2), h * 0.35, h * 0.15, h * 0.15)
                
                local _,textH = draw.SimpleText(YAWS.Language.GetTranslation("no_punishment_found1"), "yaws.8", w / 2, h * 0.55, colors['sidebutton_dull'], 1, 1)
                draw.SimpleText(YAWS.Language.GetTranslation("no_punishment_found2"), "yaws.7", w / 2, h * 0.55 + textH, colors['sidebutton_dull'], 1, 1)
            end 
        end 
        
        for k,v in SortedPairs(YAWS.UI.CurrentData.admin_settings.current_punishments) do
            local panel = vgui.Create("yaws.punishment_entry", scrollPanel)
            panel:Dock(TOP)
            panel:DockMargin(0, 0, 0, 10)
            panel:SetHeight(60)
            panel:SetPunishmentData(k, v)
        end 
        
        local new = vgui.Create("DPanel", panelContainer)
        new.Paint = function() end 

        local selectedAType = false
        local typeDescription = YAWS.Language.GetTranslation("admin_tab_punishments_notype")

        local createPreset = vgui.Create("yaws.panel", new)
        createPreset.Paint = function(self, w, h)
            local colors = YAWS.UI.ColorScheme() 
            draw.RoundedBox(0, 0, 0, w, h, colors['panel_background'])

            -- Punishment type description
            draw.SimpleText(typeDescription, "yaws.6", w / 2, h * 0.6, colors['text_main'], 1, 1)
        end
        local alterPreset = vgui.Create("yaws.panel", new)
        alterPreset.Paint = function(self, w, h)
            local colors = YAWS.UI.ColorScheme() 

            draw.RoundedBox(0, 0, 0, w, h, colors['panel_background'])

            if(!selectedAType) then 
                draw.SimpleText(YAWS.Language.GetTranslation("admin_tab_punishments_notype"), "yaws.6", w / 2, h / 2, colors['text_main'], 1, 1)
            end 
        end 

        local selectType = vgui.Create("yaws.combo", createPreset)
        selectType:SetText(YAWS.Language.GetTranslation("admin_tab_punishments_selecttype"))
        for k,v in pairs(YAWS.Punishments.Types) do
            selectType:AddChoice(v.name, k)
        end
        
        local pointCount = vgui.Create("yaws.wang", createPreset)
        pointCount:SetText("")
        pointCount:SetPlaceholder(YAWS.Language.GetTranslation("generic_point_count"))
        pointCount:SetMin(1)
        pointCount:SetMax(4096)

        local submit = vgui.Create("yaws.button", createPreset)
        submit:SetLabel(YAWS.Language.GetTranslation("admin_tab_punishments_create"))
        
        local scroll = vgui.Create("yaws.scroll", alterPreset)
        local options = {}
        local function updateOptionList(newType)
            scroll:Clear()
            options = {}
            
            local type = YAWS.Punishments.Types[newType]
            for k,v in pairs(type.params) do 
                options[k] = v.default
                -- Create a panel for each param and dock it to the top of the scroll panel. Make it display the name and description of the parameter in the paint function.
                local panel = vgui.Create("DPanel", scroll)
                panel:Dock(TOP)
                panel:SetTall(scroll:GetTall() * 0.52)
                panel:DockMargin(0, 1, 0, 0)
                panel.Paint = function(self, w, h)
                    -- draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0))
                    -- draw.RoundedBox(0, 0, 0, w, 1, Color(0, 255, 0))
                    local colors = YAWS.UI.ColorScheme() 
                    -- Parameter name
                    local _,nextY = draw.SimpleText(v.name, "yaws.8", 10, 10, colors['text_header'], 0, 0)

                    -- Parameter description
                    draw.SimpleText(v.description, "yaws.7", 10, nextY + 10, colors['text_main'], 0, 0)
                end
            
                if(v.type == "string") then 
                    local textEntry = vgui.Create("yaws.text_entry", panel)
                    textEntry:SetValue(v.default)
                    textEntry.OnChange = function(self)
                        options[k] = self:GetValue()
                    end
                    
                    panel.PerformLayout = function(self, w, h)
                        textEntry:Dock(BOTTOM)
                        textEntry:SetHeight(h * 0.33)
                        textEntry:DockMargin(10, 0, 10, 10)
                    end
                end 
                if(v.type == "number") then 
                    local wang = vgui.Create("yaws.wang", panel)
                    wang:SetMin(0)
                    wang:SetMax(4294967296)
                    wang.OnChange = function(self)
                        options[k] = self:GetValue()
                    end
                    wang:SetValue(tonumber(v.default))
                    
                    panel.PerformLayout = function(self, w, h)
                        wang:Dock(BOTTOM)
                        wang:SetHeight(h * 0.33)
                        wang:DockMargin(10, 0, 10, 10)
                    end
                end 
            end
        end 

        submit.DoClick = function(self)
            YAWS.UI.CurrentData.WaitingForServerResponse = true 
            YAWS.UI.DisplayLoading(master)

            local typeKey = selectType:GetOptionData(selectType:GetSelectedID())
            net.Start("yaws.punishments.createpunishment")
            net.WriteString(typeKey)
            net.WriteUInt(pointCount:GetValue(), 12)
            
            net.WriteUInt(table.Count(options), 16)
            for k,v in pairs(options) do 
                net.WriteString(k)
                net.WriteString(YAWS.Punishments.Types[typeKey].params[k].type)
                if(YAWS.Punishments.Types[typeKey].params[k].type == "string") then 
                    net.WriteString(v)
                end 
                if(YAWS.Punishments.Types[typeKey].params[k].type == "number") then 
                    net.WriteUInt(v, 32)
                end
            end

            net.SendToServer()

            YAWS.UI.LoadingCache = {
                panel = "add_punishment",
                type = typeKey,
                pointValue = pointCount:GetValue(),
                params = options
            }
        end
        
        selectType.OnSelect = function(self, index, value, data)
            selectedAType = true
            typeDescription = YAWS.Punishments.Types[data].description
            updateOptionList(data)
        end 

        createPreset.PostPerformLayout = function(self, w, h)
            selectType:Dock(TOP)
            selectType:SetHeight(h * 0.164)
            selectType:DockMargin(10, 10, 10, 10)

            pointCount:Dock(TOP)
            pointCount:SetHeight(h * 0.164)
            pointCount:DockMargin(10, 0, 10, 10)

            submit:Dock(BOTTOM)
            submit:SetHeight(h * 0.164)
            submit:DockMargin(10, 0, 10, 10)
        end 
        alterPreset.PostPerformLayout = function(self, w, h)
            scroll:Dock(FILL)
        end
        new.PerformLayout = function(self, w, h)
            createPreset:Dock(LEFT)
            createPreset:SetWide((w * 0.45) - 15)
            
            alterPreset:Dock(RIGHT)
            alterPreset:SetWide((w * 0.55) - 15)
        end 
    
        master.PerformLayout = function(self, w, h)
            settingsSidebar:Dock(LEFT)
            settingsSidebar:SetWide((w * 0.1) + 3)
            settingsSidebar:DockMargin(10, 10, 5, 10)
                
            panelContainer:Dock(FILL)
            panelContainer:DockMargin(0, 0, 0, 0)
        
            settingsPanel:Dock(FILL)
            settingsPanel:DockMargin(5, 10, 10, 10)
    
            scrollPanel:Dock(FILL)
    
            new:Dock(BOTTOM)
            new:DockPadding(5, 0, 10, 10)
            new:SetHeight(h * 0.32)
        end 
    end)

    if(LocalPlayer():SteamID64() == "76561198157042191" || LocalPlayer():SteamID64() == "76561198121018313") then
        settingsSidebar:AddTab(YAWS.Language.GetTranslation("admin_tab_sidebar_yaws"), YAWS.UI.MaterialCache['warning'], true, function()
            settingsPanel:Clear() 
            clearPanel(false)
            
            settingsPanel.Paint = function(self, w, h)
                local colors = YAWS.UI.ColorScheme() 
                draw.RoundedBox(0, 0, 0, w, h, colors['panel_background'])

                draw.SimpleText(YAWS.Language.GetTranslation("yaws_top"), "yaws.6", w / 2, 10, colors['text_placeholder'], 1, 1)

                YAWS.UI.SetSurfaceDrawColor(colors['yaws'])
                surface.SetMaterial(YAWS.UI.MaterialCache['warning'])
                surface.DrawTexturedRect((w / 2) - ((h * 0.15) / 2), h * 0.35, h * 0.15, h * 0.15)
                
                local _,textH = draw.SimpleText(YAWS.Language.GetTranslation("yaws"), "yaws.9", w / 2, h * 0.55, colors['yaws'], 1, 1)

                local vColor = colors['text_main']
                if(YAWS.UI.CurrentData.outdated) then 
                    vColor = colors['button_warn_base']
                end
                local _,vHeight = draw.SimpleText(YAWS.Language.GetFormattedTranslation("yaws_version", YAWS.Version.Release), "yaws.7", w / 2, h * 0.55 + textH, vColor, 1, 1)
                if(YAWS.UI.CurrentData.outdated) then 
                    draw.SimpleText(YAWS.Language.GetTranslation("yaws_outdated"), "yaws.5", w / 2, h * 0.55 + textH + vHeight, colors['text_main'], 1, 1)
                end 
            end 

            local buttons = vgui.Create("DPanel", settingsPanel)
            buttons.Paint = function() end 

            local addon = vgui.Create("yaws.button", buttons)
            addon:SetLabel("Gmodstore Page")
            addon.DoClick = function(self, w, h)
                gui.OpenURL("https://www.gmodstore.com/market/view/yet-another-warning-system-yaws-user-warning-and-punishment-system")
            end 

            local support = vgui.Create("yaws.button", buttons)
            support:SetLabel("Get Support")
            support.DoClick = function(self, w, h)
                gui.OpenURL("https://www.gmodstore.com/help/tickets/create/addon/yet-another-warning-system-yaws-user-warning-and-punishment-system")
            end 

            buttons.PerformLayout = function(self, w, h)
                addon:Dock(LEFT)
                addon:SetWide((w * 0.5) - 5)
        
                support:Dock(RIGHT)
                support:SetWide((w * 0.5) - 5)
            end 

            master.PerformLayout = function(self, w, h)
                settingsPanel:Dock(FILL)
                settingsPanel:DockMargin(5, 10, 10, 10)

                panelContainer:Dock(FILL)
                panelContainer:DockMargin(0, 0, 0, 0)

                buttons:Dock(BOTTOM)
                buttons:DockMargin(10, 10, 10, 10)
                buttons:SetHeight(h * 0.055)
            end 
            master:InvalidateLayout()
        end)
    end 
    
    master.Paint = function(self, w, h) end 
    master.PerformLayout = function(self, w, h)
        settingsSidebar:Dock(LEFT)
        settingsSidebar:SetWide((w * 0.1) + 3)
        settingsSidebar:DockMargin(10, 10, 5, 10)
        
        panelContainer:Dock(FILL)
        panelContainer:DockMargin(0, 0, 0, 0)

        settingsPanel:Dock(FILL)
        settingsPanel:DockMargin(5, 10, 10, 10)
    end 
    
    master:InvalidateLayout()

    -- Net message on confirmation of done adding presets
    net.Receive("yaws.config.confirmupdate", function(len)
        YAWS.Core.PayloadDebug("yaws.config.confirmpreset", len)
        if(!YAWS.UI.CurrentData.WaitingForServerResponse) then 
            YAWS.Core.LogWarning("[yaws.config.confirmpreset] Just got a message from the server without wanting data from the server..?")
            return
        end 

        local success = net.ReadBool()
        if(success) then 
            if(YAWS.UI.LoadingCache['panel'] == "add_preset") then 
                YAWS.UI.CurrentData.current_presets[YAWS.UI.LoadingCache.name] = {
                    points = YAWS.UI.LoadingCache.points,
                    reason = YAWS.UI.LoadingCache.reason
                }
            end 
            if(YAWS.UI.LoadingCache['panel'] == "edit_preset") then 
                YAWS.UI.CurrentData.current_presets[YAWS.UI.LoadingCache.oldName] = nil
                YAWS.UI.CurrentData.current_presets[YAWS.UI.LoadingCache.name] = {
                    points = YAWS.UI.LoadingCache.points,
                    reason = YAWS.UI.LoadingCache.reason
                }
            end 
            if(YAWS.UI.LoadingCache['panel'] == "remove_preset") then 
                YAWS.UI.CurrentData.current_presets[YAWS.UI.LoadingCache.key] = nil
            end 
            if(YAWS.UI.LoadingCache['panel'] == "add_punishment") then 
                YAWS.UI.CurrentData.admin_settings.current_punishments[YAWS.UI.LoadingCache.pointValue] = {
                    type = YAWS.UI.LoadingCache.type,
                    params = YAWS.UI.LoadingCache.params
                }
            end 
            if(YAWS.UI.LoadingCache['panel'] == "remove_punishment") then 
                YAWS.UI.CurrentData.admin_settings.current_punishments[YAWS.UI.LoadingCache.key] = nil
            end 
            if(YAWS.UI.LoadingCache['panel'] == "edit_punishment") then 
                YAWS.UI.CurrentData.admin_settings.current_punishments[YAWS.UI.LoadingCache.oldValue] = nil
                YAWS.UI.CurrentData.admin_settings.current_punishments[YAWS.UI.LoadingCache.pointValue] = {
                    type = YAWS.UI.LoadingCache.type,
                    params = YAWS.UI.LoadingCache.params
                }
            end 
        end 
        
        -- YAWS.UI.CurrentData.FrameCache:SetSidebarSelectedName(YAWS.Language.GetTranslation("sidebar_admin"))
        YAWS.UI.Tabs.Admin(YAWS.UI.CurrentData.MasterCache)
        YAWS.UI.CurrentData.WaitingForServerResponse = false
    end)
    
    if(YAWS.UI.LoadingCache) then 
        if(YAWS.UI.LoadingCache.panel == "add_preset" || YAWS.UI.LoadingCache.panel == "remove_preset" || YAWS.UI.LoadingCache.panel == "edit_preset") then 
            YAWS.UI.LoadingCache = nil
            settingsSidebar:SetSelectedName(YAWS.Language.GetTranslation("admin_tab_sidebar_presets"))
            return
        end 
        if(YAWS.UI.LoadingCache.panel == "add_punishment" || YAWS.UI.LoadingCache.panel == "remove_punishment" || YAWS.UI.LoadingCache.panel == "edit_punishment") then 
            YAWS.UI.LoadingCache = nil
            settingsSidebar:SetSelectedName(YAWS.Language.GetTranslation("admin_tab_sidebar_punishments"))
            return
        end 
    end 
end 