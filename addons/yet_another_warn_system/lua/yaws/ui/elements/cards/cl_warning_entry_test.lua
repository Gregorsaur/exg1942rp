-- this is the warning entry I'm using, can't be fucked to remove the _test so deal with it
local PANEL = {}

function PANEL:Init()
    self.warningData = {
        admin = "Unknown",
        adminSteamID = "00000000000000000",
        id = "",
        player = "00000000000000000",
        points = 0,
        reason = "N/A",
        server_id = "None",
        timestamp = 0,
    }

    self.btn.he = 0
    self:SetExpanded(false)

    self.expandLerp = 255

    self.adminAvatar = vgui.Create("yaws.round_avatar", self.btn)
    self.userAvatar = vgui.Create("yaws.round_avatar", self.btn)

    self.btn.PerformLayout = function(s, w, h)  
        self.adminAvatar:Dock(LEFT)
        self.adminAvatar:DockMargin(10, 10, 10, 10)
        self.adminAvatar:SetWide(h - 20)
        
        self.userAvatar:Dock(RIGHT)
        self.userAvatar:DockMargin(10, 10, 10 + ((h / 2) + 20), 10)
        self.userAvatar:SetWide(h - 20)
        self.userAvatar:SetAlpha(0)
    end 
    self.btn.DoRightClick = function()
        local options = DermaMenu()

        options:AddOption(YAWS.Language.GetTranslation("viewing_player_table_right_id"), function() 
            SetClipboardText(self.warningData.id) 
        end):SetIcon("icon16/bullet_key.png")

        options:AddOption(YAWS.Language.GetTranslation("viewing_player_table_right_admin"), function() 
            SetClipboardText(self.warningData.admin .. "(" .. util.SteamIDFrom64(self.warningData.adminSteamID or "") .. ")") 
        end):SetIcon("icon16/group_key.png")

        options:AddOption(YAWS.Language.GetTranslation("viewing_player_table_right_reason"), function() 
            SetClipboardText(self.warningData.reason) 
        end):SetIcon("icon16/page_edit.png")

        options:AddOption(YAWS.Language.GetTranslation("viewing_player_table_right_time"), function() 
            SetClipboardText(os.date("%H:%M:%S on %d/%m/%Y", self.warningData.timestamp))
        end):SetIcon("icon16/clock.png")

        options:AddOption(YAWS.Language.GetTranslation("viewing_player_table_right_points"), function() 
            SetClipboardText(YAWS.Language.GetFormattedTranslation("points_format", self.warningData.points)) 
        end):SetIcon("icon16/award_star_gold_3.png")

        options:AddOption(YAWS.Language.GetTranslation("viewing_player_table_right_server"), function() 
            SetClipboardText(self.warningData.server_id) 
        end):SetIcon("icon16/computer.png")

        options:AddOption(YAWS.Language.GetTranslation("viewing_player_table_right_log"), function() 
            SetClipboardText(YAWS.Language.GetFormattedTranslation("viewing_player_table_log_format", os.date("%H:%M:%S on %d/%m/%Y", self.warningData.timestamp), self.warningData.admin, util.SteamIDFrom64(self.warningData.adminSteamID or ""), self.warningData.playerName, util.SteamIDFrom64(self.warningData.player), self.warningData.reason, self.warningData.points))
        end):SetIcon("icon16/folder.png")

        options:Open()
    end 
    
    self.bottomPanel = vgui.Create("DPanel", self)
    self.bottomPanel.Paint = function() end 
    if(YAWS.UI.CurrentData.can_view.delete_warns) then 
        self.deleteButton = vgui.Create("yaws.button", self.bottomPanel)
        self.deleteButton:SetLabel(YAWS.Language.GetTranslation("generic_delete"))
        self.deleteButton:SetColors('button_warn_base', 'button_warn_hover')
        self.deleteButton.DoClick = function()
            YAWS.UI.CurrentData.FrameCache:Remove()

            net.Start("yaws.warns.deletewarn")
            net.WriteString(self.warningData.id)
            net.SendToServer()
        end
    end 
    
    self.content.PerformLayout = function(s, w, h)
        self.bottomPanel:Dock(BOTTOM)
        self.bottomPanel:DockMargin(10, 10, 10, 10)
        self.bottomPanel:SetTall(33)

        if(self.deleteButton) then 
            self.deleteButton:Dock(FILL)
        end

        -- if(YAWS.UI.CurrentData.can_view.delete_warns) then 
        --     self.deleteButton:Dock(RIGHT)
        --     self.deleteButton:SetWide(33)
        -- end
        -- self.contextButton:Dock(RIGHT)
        -- self.contextButton:SetWide(33)
    end 

    local colors = YAWS.UI.ColorScheme()

    self.mainFade = table.Copy(colors['text_main'])
    self.headerFadeInv = table.Copy(colors['text_main'])
    self.mainFadeInv = table.Copy(colors['text_main'])
    self.mainFade.a = self.expandLerp
    self.headerFadeInv.a = 255 - self.expandLerp
    self.mainFadeInv.a = 255 - self.expandLerp
end

-- panel.DoRightClick = function()
--     local options = DermaMenu()
--     for k,v in ipairs(menu) do 
--         local x = options:AddOption(v.name, v.func)
--         if(v.icon) then 
--             x:SetIcon(v.icon)
--         end
--     end
--     options:Open()
-- end

function PANEL:HeaderPaint(w, h)
    if(self.btn.he == 0) then
        self.btn.he = h * 0.42
    end

    local colors = YAWS.UI.ColorScheme()
    draw.RoundedBox(0, 0, 0, w, h, colors["panel_background"])

    if(self:GetExpanded()) then
        if(self.expandLerp > 0.0000005) then -- Prevents it from running unnessasarially, a performance thing
            if(!YAWS.UserSettings.GetValue("disable_ui_anims")) then 
                self.expandLerp = Lerp(RealFrameTime() * 15, self.expandLerp, 0)
            else 
                self.expandLerp = 0
            end 

            self.mainFade.a = self.expandLerp
            self.headerFadeInv.a = 255 - self.expandLerp
            self.mainFadeInv.a = 255 - self.expandLerp
        end
    else
        if(self.expandLerp < 254.99995) then -- Prevents it from running unnessasarially, a performance thing
            if(!YAWS.UserSettings.GetValue("disable_ui_anims")) then 
                self.expandLerp = Lerp(RealFrameTime() * 15, self.expandLerp, 255)
            else 
                self.expandLerp = 255
            end 

            self.mainFade.a = self.expandLerp
            self.headerFadeInv.a = 255 - self.expandLerp
            self.mainFadeInv.a = 255 - self.expandLerp
        end
    end
    


    -- Actual info
    local adminLength = draw.SimpleText(self.warningData.admin, "yaws.9", h + 3, h * 0.35, colors['text_header'], 0, 1)
    local sidLength = draw.SimpleText(util.SteamIDFrom64(self.warningData.adminSteamID), "yaws.7", h + 3, h * 0.65, colors['text_main'], 0, 1)
    local textX = math.max(w * 0.3, math.max(adminLength, sidLength) + (h + 6))
    
    draw.SimpleText(YAWS.UI.CutoffText(self.warningData.reason, "yaws.8", w - textX - ((h / 2) + 10) - 10), "yaws.8", textX, h / 2, self.mainFade, 0, 1)

    -- 19x11
    self.btn.chevState = YAWS.UI.DrawAnimatedChevron(w - ((h / 2) + 10), self.btn.he, math.min(self.btn.he, 19), math.min(h * 0.195, 11), self.btn.chevState, self:GetExpanded())


    -- Expanded State
    self.userAvatar:SetAlpha(255 - self.expandLerp)
    self.bottomPanel:SetAlpha(255 - self.expandLerp)

    textX = w - ((h / 2) + 20) - (h - 20) - 23
    -- draw.SimpleText(YAWS.UI.CutoffText(self.warningData.playerName, "yaws.9", maxWidth, cacheKey), "yaws.9", textX, h * 0.35, self.headerFadeInv, 2, 1)
    draw.SimpleText(self.warningData.playerName, YAWS.UI.ScaleFont(self.warningData.playerName, w * 0.25, 8, 9), textX, h * 0.35, self.headerFadeInv, 2, 1)
    draw.SimpleText(util.SteamIDFrom64(self.warningData.player), "yaws.7", textX, h * 0.65, self.mainFadeInv, 2, 1)

    local warnedWidth = draw.SimpleText(YAWS.Language.GetTranslation("generic_warned"), "yaws.8", w / 2, h * 0.5, self.mainFadeInv, 1, 1)

    YAWS.UI.SetSurfaceDrawColor(self.mainFadeInv)
    surface.SetMaterial(YAWS.UI.MaterialCache['arrow'])
    -- this math is dubious
    surface.DrawTexturedRect((w / 2) + (warnedWidth / 2) + 5, h * 0.5 - ((h * 0.25) / 2), h * 0.25, h * 0.25)
    surface.DrawTexturedRect((w / 2) - (warnedWidth / 2) - 5 - (h * 0.25 * 0.8), h * 0.5 - ((h * 0.25) / 2), h * 0.25, h * 0.25)
end

function PANEL:ContentPaint(w, h)
    local colors = YAWS.UI.ColorScheme() 
    
    draw.RoundedBox(0, 0, 0, w, h, colors["panel_background"])

    local _,rHeaderH = draw.SimpleText(YAWS.Language.GetTranslation("viewing_warn_reason"), "yaws.8", 10, 10, self.headerFadeInv, 0, 1)
    
    -- DrawText doesn't return like the others :/
    draw.DrawText(YAWS.UI.TextWrap(self.warningData.reason, "yaws.7", w - 20), "yaws.7", 10, rHeaderH, self.mainFadeInv, 0, 1)
    surface.SetFont("yaws.7")
    local _,reasonH = surface.GetTextSize(YAWS.UI.TextWrap(self.warningData.reason, "yaws.7", w - 20))

    local _,tHeaderH = draw.SimpleText(YAWS.Language.GetTranslation("viewing_warn_time"), "yaws.8", 10, rHeaderH + reasonH + 25, self.headerFadeInv, 0, 1)
    draw.SimpleText(YAWS.Language.GetTranslation("viewing_warn_server"), "yaws.8", w / 2, rHeaderH + reasonH + 25, self.headerFadeInv, 1, 1)
    draw.SimpleText(YAWS.Language.GetTranslation("viewing_warn_point"), "yaws.8", w - 10, rHeaderH + reasonH + 25, self.headerFadeInv, 2, 1)
    
    draw.SimpleText(os.date("%H:%M:%S on %d/%m/%Y", self.warningData.timestamp), "yaws.7", 10, rHeaderH + reasonH + tHeaderH + 25, self.mainFadeInv, 0, 1)
    draw.SimpleText(self.warningData.server_id, "yaws.7", w / 2, rHeaderH + reasonH + tHeaderH + 25, self.mainFadeInv, 1, 1)
    draw.SimpleText(YAWS.Language.GetFormattedTranslation("points_format", self.warningData.points), "yaws.7", w - 10, rHeaderH + reasonH + tHeaderH + 25, self.mainFadeInv, 2, 1)
end 

function PANEL:SetWarningData(data)
    self.warningData = data

    self.adminAvatar:SetSteamID(data.adminSteamID, 128)
    self.userAvatar:SetSteamID(data.player, 128)

    
    -- Looks like (from PrintTable): 
    -- admin	=	Livaco
    -- adminSteamID	=	76561198121018313
    -- id	=	e5af2b73-0c6f-481a-8e1e-5000dd72f952
    -- player	=	76561198121018313
    -- points	=	3
    -- reason	=	test
    -- server_id	=	Server One
    -- timestamp	=	1645917741    
end

function PANEL:CalculateHeights(w, h) 
    local x = 0
    
    surface.SetFont("yaws.8")
    x = x + select(2, surface.GetTextSize(YAWS.Language.GetTranslation("viewing_warn_reason"))) + 10 
    
    surface.SetFont("yaws.7")
    x = x + select(2, surface.GetTextSize(YAWS.UI.TextWrap(self.warningData.reason, "yaws.7", w - 20)))
    
    surface.SetFont("yaws.8")
    x = x + select(2, surface.GetTextSize(YAWS.Language.GetTranslation("viewing_warn_time"))) + 10
    
    surface.SetFont("yaws.7")
    x = x + select(2, surface.GetTextSize(os.date("%H:%M:%S on %d/%m/%Y", self.warningData.time))) + 5

    if(YAWS.UI.CurrentData.can_view.delete_warns) then 
        x = x + 53
    end 

    self:SetExpandedHeight(x)
end 

vgui.Register("yaws.warning_entry_test", PANEL, "yaws.expandable_card_base")