function YAWS.UI.CoreUI(dontWipeCache) 
    local currentCache
    if(dontWipeCache) then 
        currentCache = {}
    else 
        currentCache = table.Copy(YAWS.UI.StateCache)
    end 
    
    local frame = vgui.Create("yaws.frame")
    frame:SetupSideBar(true)
    frame:SetSize(ScrW() * 0.6, ScrH() * 0.6)
    frame:Center()
    frame:SetBackgroundBlur(YAWS.UserSettings.GetValue("blur_background"))
    frame:MakePopup()
    YAWS.UI.CurrentData.FrameCache = frame

    local master = frame:GetMasterPanel()
    YAWS.UI.CurrentData.MasterCache = master

    if(YAWS.UI.CurrentData['can_view']['self_warns']) then 
        frame:AddSidebarTab(YAWS.Language.GetTranslation("sidebar_warnings"), YAWS.UI.MaterialCache['warning'], true, function()
            YAWS.UI.Tabs.Warnings(master)
        end)
    end

    if(YAWS.UI.CurrentData['can_view']['others_warns']) then
        frame:AddSidebarTab(YAWS.Language.GetTranslation("sidebar_players"), YAWS.UI.MaterialCache['player'], true, function()
            YAWS.UI.Tabs.Players(master)
        end)
    end

    if(YAWS.UI.CurrentData['can_view']['admin_settings']) then 
        frame:AddSidebarTab(YAWS.Language.GetTranslation("sidebar_admin"), YAWS.UI.MaterialCache['admin'], true, function()
            YAWS.UI.Tabs.Admin(master)
        end)
    end 

    frame:AddSidebarBottomTab(YAWS.Language.GetTranslation("sidebar_settings"), YAWS.UI.MaterialCache['settings'], true, function()
        YAWS.UI.Tabs.Settings(master)
    end)

    if(dontWipeCache) then 
        YAWS.UI.StateCache = currentCache
    end 

    if(YAWS.UI.StateCache && dontWipeCache) then
        if(YAWS.UI.StateCache["warn_data_return"] == "viewing_player") then 
            YAWS.UI.StateCache["player_ignore"] = true -- To ensure the player search cache doesn't obliterate itself
            frame:SetSidebarSelectedName(YAWS.Language.GetTranslation("sidebar_players"))
            YAWS.UI.DisplayPlayerInfo(master, YAWS.UI.StateCache['viewing_player'].data)
            YAWS.UI.StateCache["player_ignore"] = nil

            YAWS.UI.StateCache["warn_data_return"] = nil
        end
        if(YAWS.UI.StateCache["warn_data_return"] == "viewing_self") then 
            frame:SetSidebarSelected(1)
            YAWS.UI.StateCache["warn_data_return"] = nil
        end
    end 

    frame.PostPerformLayout = function()
        if(!YAWS.UI.CurrentData.state) then 
            frame:SetSidebarSelected(1)
        end 
        
        if(!YAWS.UserSettings.GetValue("disable_fades")) then 
            frame:FadeIn()
        end
    end 
end 

-- this is for my tendancys of breaking the ui during development
-- if this isn't commented out let me know immedietely
-- concommand.Add("yaws_resetui", function()
--     YAWS.UI.CurrentData.FrameCache:Remove()
-- end)