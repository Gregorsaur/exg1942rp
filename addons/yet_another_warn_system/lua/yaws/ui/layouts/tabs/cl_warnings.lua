function YAWS.UI.Tabs.Warnings(master)
    master:Clear()
    master.PerformLayout = function() end 
    
    -- YAWS.UI.CurrentData.self_warns
    local playerPanel = vgui.Create("yaws.panel", master)
    local picture = vgui.Create("yaws.round_avatar", playerPanel)
    picture:SetPlayer(LocalPlayer(), 256)

    playerPanel.PostPerformLayout = function(self, w, h)
        picture:Dock(LEFT)
        picture:DockMargin(10, 10, 10, 10)
        picture:SetWide(picture:GetTall())
    end 

    -- Warning Points
    surface.SetFont("yaws.7")

    playerPanel.Paint = function(self, w, h)
        local colors = YAWS.UI.ColorScheme()
        draw.RoundedBox(0, 0, 0, w, h, colors['panel_background'])

        draw.SimpleText(LocalPlayer():Name(), "yaws.10", h + (5), h * 0.375, colors['text_header'], 0, 1)
        draw.SimpleText(LocalPlayer():SteamID(), "yaws.7", h + (5), h * 0.625, colors['text_main'], 0, 1)

        -- points 
        local x = w - 10
        local pointsTextSize = draw.SimpleText(YAWS.UI.CurrentData.self_warn_point_count, "yaws.7", x, h * 0.775, colors['text_main'], 2, 1)

        x = x - pointsTextSize - (h * 0.235) - 3
        YAWS.UI.SetSurfaceDrawColor(colors['active_warning'])
        surface.SetMaterial(YAWS.UI.MaterialCache['warning'])
        surface.DrawTexturedRect(x, h - (h * 0.235) - 10, h * 0.235, h * 0.235)
        
        if(YAWS.UserSettings.GetValue("colorblind_text")) then
            x = x - 10
            draw.SimpleText(YAWS.Language.GetTranslation("accessability_points"), "yaws.7", x, h * 0.775, colors['text_main'], 2, 1)
        end
        
        if(YAWS.Config.GetValue("point_cooldown_time") != 0) then
            if(YAWS.UserSettings.GetValue("colorblind_text")) then
                x = w - 10
                local expiredPointsTextSize = draw.SimpleText(YAWS.UI.CurrentData.self_warn_expired_point_count, "yaws.7", x, h * 0.775 - (h * 0.235) - 5, colors['text_main'], 2, 1)

                x = x - expiredPointsTextSize - (h * 0.235) - 3
                YAWS.UI.SetSurfaceDrawColor(colors['expired_warning'])
                surface.DrawTexturedRect(w - 14 - (h * 0.235) - expiredPointsTextSize, h - ((h * 0.235) * 2) - 15, h * 0.235, h * 0.235)
                
                if(YAWS.UserSettings.GetValue("colorblind_text")) then
                    x = x - 10
                    draw.SimpleText(YAWS.Language.GetTranslation("accessability_inactivepoints"), "yaws.7", x, h * 0.775 - (h * 0.235) - 5, colors['text_main'], 2, 1)
                end
            else 
                -- Horizontal display if not
                x = x - 15
                local expiredPointsTextSize = draw.SimpleText(YAWS.UI.CurrentData.self_warn_expired_point_count, "yaws.7", x, h * 0.775, colors['text_main'], 2, 1)

                x = x - expiredPointsTextSize - (h * 0.235) - 3
                YAWS.UI.SetSurfaceDrawColor(colors['expired_warning'])
                surface.DrawTexturedRect(x, h - (h * 0.235) - 10, h * 0.235, h * 0.235)
            end 
        end
    end 

    local warnings 
    local warningList

    local pagnation = vgui.Create("yaws.pagnation", master)
    pagnation:SetItemCount(YAWS.UI.CurrentData.self_warns_total)
    
    if(!YAWS.UserSettings.GetValue("table_view")) then 
        warnings = vgui.Create("yaws.panel", master)
        warningList = vgui.Create("yaws.scroll", warnings)
    else 
        warnings = vgui.Create("yaws.table", master)
        warnings:Dock(FILL)
        warnings:AddColumn(YAWS.Language.GetTranslation("viewing_player_table_admin"), 0.125)
        warnings:AddColumn(YAWS.Language.GetTranslation("viewing_player_table_reason"), 0.425)
        warnings:AddColumn(YAWS.Language.GetTranslation("viewing_player_table_time"), 0.15)
        warnings:AddColumn(YAWS.Language.GetTranslation("viewing_player_table_points"), 0.15)
        warnings:AddColumn(YAWS.Language.GetTranslation("viewing_player_table_server"), 0.15)
    end

    local function DisplayWarnings(data, count) 
        if(!YAWS.UserSettings.GetValue("table_view")) then
            warningList:Clear()
            if(count > 0) then
                warnings.Paint = function() end 
                warnings:RemoveShadows()
            end 
        
            warningList.Paint = function(self, w, h)
                if(count > 0) then return end 
        
                local colors = YAWS.UI.ColorScheme() 
                
                YAWS.UI.SetSurfaceDrawColor(colors['sidebutton_dull'])
                surface.SetMaterial(YAWS.UI.MaterialCache['warning_slash'])
                surface.DrawTexturedRect((w / 2) - ((h * 0.15) / 2), h * 0.35, h * 0.15, h * 0.15)
                
                local _,textH = draw.SimpleText(YAWS.Language.GetTranslation("no_warning_found1"), "yaws.9", w / 2, h * 0.55, colors['sidebutton_dull'], 1, 1)
                draw.SimpleText(YAWS.Language.GetTranslation("no_warning_found2"), "yaws.9", w / 2, h * 0.55 + textH, colors['sidebutton_dull'], 1, 1)
            end
        
            local cards = {}
            for k,v in SortedPairsByMemberValue(data, "timestamp", true) do 
                local card = vgui.Create("yaws.warning_entry_test", warningList)
                card:SetWarningData(v)
                cards[#cards + 1] = card 
            end 
        
            warnings.PostPerformLayout = function(self, w, h)
                warningList:Dock(FILL)
        
                for k,v in ipairs(cards) do
                    v:Dock(TOP)
                    v:DockMargin(0, 0, 0, 10)
                    -- v:SetHeaderHeight(71)
                    v:SetHeaderHeight(h * 0.165)
                    -- v:DelayedLayout(w, h)
                end
            end 
        else 
            warnings:Clear()
            if(count <= 0) then -- they're numberically indexed but not guarenteed to start at 0
                warnings:RemoveDividersInBody()
                
                warnings.CenterPaint = function(self, w, h)
                    local colors = YAWS.UI.ColorScheme() 
                    
                    YAWS.UI.SetSurfaceDrawColor(colors['sidebutton_dull'])
                    surface.SetMaterial(YAWS.UI.MaterialCache['warning_slash'])
                    surface.DrawTexturedRect((w / 2) - ((h * 0.15) / 2), h * 0.35, h * 0.15, h * 0.15)
                
                    local _,textH = draw.SimpleText(YAWS.Language.GetTranslation("no_warning_found1"), "yaws.9", w / 2, h * 0.55, colors['sidebutton_dull'], 1, 1)
                    draw.SimpleText(YAWS.Language.GetTranslation("no_warning_found2"), "yaws.9", w / 2, h * 0.55 + textH, colors['sidebutton_dull'], 1, 1)
                end
            else 
                local defaultPlayerData = {
                    steamid = LocalPlayer():SteamID64(),
                    realSteamID = LocalPlayer():SteamID(),
                    name = LocalPlayer():Name(),
                    usergroup = LocalPlayer():GetUserGroup()
                }
                for k,v in SortedPairsByMemberValue(data, "timestamp", true) do
                    warnings:AddEntry(function()
                        YAWS.UI.StateCache["viewing_self"] = {
                            -- data = data
                        }
                        YAWS.UI.StateCache["warn_data_return"] = "viewing_self"
            
                        YAWS.UI.DisplayWarnData(defaultPlayerData, v)
                    end, {
                        {
                            name = YAWS.Language.GetTranslation("viewing_player_table_right_id"),
                            func = function() 
                                SetClipboardText(v.id) 
                            end,
                            icon = "icon16/bullet_key.png"
                        },
                        {
                            name = YAWS.Language.GetTranslation("viewing_player_table_right_admin"),
                            func = function() 
                                SetClipboardText(v.admin .. "(" .. util.SteamIDFrom64(v.adminSteamID or "") ")") 
                            end,
                            icon = "icon16/group_key.png"
                        },
                        {
                            name = YAWS.Language.GetTranslation("viewing_player_table_right_reason"),
                            func = function() 
                                SetClipboardText(v.reason)
                            end,
                            icon = "icon16/page_edit.png"
                        },
                        { 
                            name = YAWS.Language.GetTranslation("viewing_player_table_right_time"),
                            func = function() 
                                SetClipboardText(os.date("%H:%M:%S on %d/%m/%Y", v.time))
                            end,
                            icon = "icon16/clock.png"
                        },
                        {
                            name = YAWS.Language.GetTranslation("viewing_player_table_right_points"),
                            func = function() 
                                SetClipboardText(v.points .. " points")
                            end,
                            icon = "icon16/award_star_gold_3.png"
                        },
                        {
                            name = YAWS.Language.GetTranslation("viewing_player_table_right_server"),
                            func = function() 
                                SetClipboardText(v.server_id)
                            end,
                            icon = "icon16/computer.png"
                        },
                        {
                            name = YAWS.Language.GetTranslation("viewing_player_table_right_log"),
                            func = function() 
                                SetClipboardText(string.format("[%s] %s(%s) warned %s(%s) for the reason \"%s\", adding %s points.", os.date("%H:%M:%S on %d/%m/%Y", v.time), v.admin, util.SteamIDFrom64(v.adminSteamID or ""), LocalPlayer():Name(), LocalPlayer():SteamID(), v.reason, v.points))
                            end,
                            icon = "icon16/folder.png"
                        },
                    }, v.admin, v.reason, string.NiceTime(os.time() - v.timestamp) .. " ago", v.points, v.server_id)
                end
            end
        end 
        warnings:InvalidateLayout()
    end 

    DisplayWarnings(YAWS.UI.CurrentData.self_warns, YAWS.UI.CurrentData.self_warns_total)
    pagnation.RefreshPage = function(self, page, offset, amount)
        net.Start("yaws.core.pagnate_self_warns")
        net.WriteUInt(page, 6)
        net.SendToServer()
    
        YAWS.UI.CurrentData.WaitingForPagnatedResponse = true 
    end 
    net.Receive("yaws.core.pagnate_self_warns_results", function(len)
        YAWS.Core.PayloadDebug("yaws.core.playerwarndataresults", len)
        if(!YAWS.UI.CurrentData.WaitingForPagnatedResponse) then
            YAWS.Core.LogWarning("[yaws.core.pagnate_self_warns_results] Just got a message from the server without wanting data from the server..?")
            return
        end 

        local data = util.JSONToTable(util.Decompress(net.ReadData(net.ReadUInt(16))))
        DisplayWarnings(data.results, data.count)

        YAWS.UI.CurrentData.WaitingForPagnatedResponse = false 
    end)

    master.Paint = function(self, w, h) end 
    master.PerformLayout = function(self, w, h) 
        playerPanel:Dock(TOP)
        playerPanel:SetHeight(h * 0.15)
        playerPanel:DockMargin(10, 10, 10, 10)

        -- warnTable:Dock(FILL)
        -- warnTable:DockMargin(10, 0, 10, 10)
        -- if(table.Count(YAWS.UI.CurrentData.self_warns) > 0) then
        --     warnTable:FindBestSize()
        -- end

        if(!YAWS.UserSettings.GetValue("table_view")) then 
            warnings:Dock(FILL)
            warnings:DockMargin(10, 0, 10, 10)
        else 
            warnings:Dock(FILL)
            warnings:DockMargin(10, 0, 10, 10)
            if(table.Count(YAWS.UI.CurrentData.self_warns) > 0) then
                warnings:FindBestSize()
            end
        end 

        pagnation:Dock(BOTTOM)
        pagnation:SetTall(h * 0.05575) -- 33
        pagnation:DockMargin(10, 0, 10, 10)
    end
    master:InvalidateLayout()
end