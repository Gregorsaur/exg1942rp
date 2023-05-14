-- Material Cache
YAWS.UI.MaterialCache = {}
YAWS.UI.MaterialCache['left_gradient'] = Material("gui/gradient")
YAWS.UI.MaterialCache['down_gradient'] = Material("gui/gradient_down")
YAWS.UI.MaterialCache['close'] = Material("livaco/yet_another_warn_system/close.png", "smooth mips")
YAWS.UI.MaterialCache['warning'] = Material("livaco/yet_another_warn_system/warning.png", "mips smooth")
YAWS.UI.MaterialCache['warning_slash'] = Material("livaco/yet_another_warn_system/warning_slash.png", "smooth mips")
YAWS.UI.MaterialCache['player'] = Material("livaco/yet_another_warn_system/player.png", "smooth mips")
YAWS.UI.MaterialCache['admin'] = Material("livaco/yet_another_warn_system/admin.png", "smooth mips")
YAWS.UI.MaterialCache['settings'] = Material("livaco/yet_another_warn_system/wrench.png", "smooth mips")
YAWS.UI.MaterialCache['permissions'] = Material("livaco/yet_another_warn_system/permissions.png", "smooth mips")
YAWS.UI.MaterialCache['paper'] = Material("livaco/yet_another_warn_system/paper.png", "smooth mips")
YAWS.UI.MaterialCache['gavel'] = Material("livaco/yet_another_warn_system/gavel.png", "smooth mips")
YAWS.UI.MaterialCache['search'] = Material("livaco/yet_another_warn_system/search.png", "smooth mips")
YAWS.UI.MaterialCache['check'] = Material("livaco/yet_another_warn_system/check.png", "smooth mips")
YAWS.UI.MaterialCache['arrow'] = Material("livaco/yet_another_warn_system/arrow_thingy.png", "smooth mips")
YAWS.UI.MaterialCache['double_arrow'] = Material("livaco/yet_another_warn_system/double_arrow.png", "smooth mips")
YAWS.UI.MaterialCache['trash'] = Material("livaco/yet_another_warn_system/bin.png", "smooth mips")
YAWS.UI.MaterialCache['edit'] = Material("livaco/yet_another_warn_system/edit.png", "smooth mips")
YAWS.UI.MaterialCache['load'] = Material("livaco/yet_another_warn_system/load.png", "smooth mips")
YAWS.UI.MaterialCache['idkwhatthisiscalled'] = Material("livaco/yet_another_warn_system/expand_thingy_idk_what_its_called.png", "smooth mips")

function YAWS.UI.UpdatePermissionNames()
    YAWS.UI.PermissionsNames = {
        view_ui = YAWS.Language.GetTranslation("permission_view_ui"),
        view_self_warns = YAWS.Language.GetTranslation("permission_view_self_warns"),
        view_others_warns = YAWS.Language.GetTranslation("permission_view_others_warns"),
        view_admin_settings = YAWS.Language.GetTranslation("permission_view_admin_settings"),
        create_warns = YAWS.Language.GetTranslation("permission_create_warns"),
        customise_reason = YAWS.Language.GetTranslation("permission_customise_reason"),
        delete_warns = YAWS.Language.GetTranslation("permission_delete_warns"),
    }
end
-- Some "nice names" for the permissions keys
hook.Add("yaws.core.initalize", "yaws.ui.yesihadtouseahookhere", YAWS.UI.UpdatePermissionNames)
hook.Add("yaws.language.updated", "yaws.ui.anoterfuckinguselesshook", YAWS.UI.UpdatePermissionNames)

-- All the possible permissions that a group can have so the ui can loop through
-- it in order
YAWS.UI.Permissions = {"view_ui", "view_self_warns", "view_others_warns", "view_admin_settings", "create_warns", "customise_reason", "delete_warns"}

-- I do this way of fonts so theres fonts for the scaling function to use pls
-- don't yell at me thanks xx
for i=0,12 do
    surface.CreateFont("yaws." .. i, {
        font = "Roboto",
        size = ScreenScale(i),
        antialias = true,
        extended = true,
    })
    -- weight = 600,
end
hook.Add("OnScreenSizeChanged", "yaws.ui.fontshit", function()
    for i=0,12 do
        surface.CreateFont("yaws." .. i, {
            font = "Roboto",
            size = ScreenScale(i),
            antialias = true,
            extended = true,
        })
        -- weight = 600,
    end
end)

-- Bits and pieces of helper stuff
function YAWS.UI.DrawShadow(x, y, w, h, downGradient)
    if(YAWS.UI.UseDarkTheme()) then return end 
    
    draw.NoTexture()
    surface.SetDrawColor(35, 35, 35, 50)

    if(downGradient) then
        surface.SetMaterial(YAWS.UI.MaterialCache['down_gradient'])
    else
        surface.SetMaterial(YAWS.UI.MaterialCache['left_gradient'])
    end

    surface.DrawTexturedRect(x, y, w, h)
end

function YAWS.UI.LerpColor(amount, old, new)
    local clr = Color(old.r, old.g, old.b, old.a)
    clr.r = Lerp(amount, old.r, new.r)
    clr.g = Lerp(amount, old.g, new.g)
    clr.b = Lerp(amount, old.b, new.b)
    clr.a = Lerp(amount, old.a, new.a)

    return clr
end

function YAWS.UI.DrawCircle(x, y, radius, quality)
    local cir = {}

    for i=1,quality do
        local rad = math.rad(i * 360) / quality

        cir[i] = {
            x = x + math.cos(rad) * radius,
            y = y + math.sin(rad) * radius
        }
    end

    draw.NoTexture()
    surface.DrawPoly(cir)
end

function YAWS.UI.TintColor(clr, amount)
    return Color(clr.r + amount, clr.g + amount, clr.b + amount)
end

-- \/ why i make fonts without knowing they'll be used
function YAWS.UI.ScaleFont(text, maxSize, min, max)
    local font = "yaws." .. min

    for i=min,max do
        font = "yaws." .. i
        surface.SetFont(font)
        local w = surface.GetTextSize(text)
        if(w <= maxSize) then continue end

        return "yaws." .. math.Max((i - 1), min)
    end

    return "yaws." .. max
end

-- I need to cache the result cus somehow im dipping 15-20fps from using this
-- function. Yeah, don't ask, because im fucking clueless
YAWS.UI.CutoffTextCache = {}
function YAWS.UI.CutoffText(text, font, maxWidth, cacheKey)
    if(YAWS.UI.CutoffTextCache[text]) then 
        return YAWS.UI.CutoffTextCache[text]
    end 

    surface.SetFont(font)
    local curSize = surface.GetTextSize(text)
    if(curSize < maxWidth) then 
        YAWS.UI.CutoffTextCache[text] = text
        return text 
    end

    for i=0,#text do
        i = #text - i
        if(i < 3) then 
            YAWS.UI.CutoffTextCache[text] = "..."
            return "..." 
        end
        if(surface.GetTextSize(string.sub(text, 1, i)) < maxWidth) then 
            YAWS.UI.CutoffTextCache[text] = string.sub(text, 1, i - 3) .. "..." 
            return string.sub(text, 1, i - 3) .. "..." 
        end
    end

    YAWS.UI.CutoffTextCache[text] = "..."
    return "..." 
end
timer.Create("yaws.ui.cutofftext.cache", 30, 0, function()
    -- Resets that cache so it doesn't get clogged up with utter shit
    YAWS.UI.CutoffTextCache = {}
end)

function YAWS.UI.SetSurfaceDrawColor(clr)
    surface.SetDrawColor(clr:Unpack())
end

-- wow this is one fancy ass function
function YAWS.UI.DrawAnimatedChevron(x, y, w, h, prevState, isDown)
    local poly = {}
    
    if(prevState) then 
        poly = prevState
        if(isDown) then 
            -- was initially gona remove the X lerping, but when the scrollbar
            -- comes in on the admin settings the X lerping causes the chevron
            -- to move over smoothly instead of harshly, which I like so it's
            -- staying :)
            poly[1] = {
                x = Lerp(RealFrameTime() * 5, poly[1].x, x),
                y = Lerp(RealFrameTime() * 5, poly[1].y, y),
            }
            poly[2] = {
                x = Lerp(RealFrameTime() * 5, poly[2].x, x + (w / 2)),
                y = Lerp(RealFrameTime() * 5, poly[2].y, y + h),
            }
            poly[3] = {
                x = Lerp(RealFrameTime() * 5, poly[3].x, (x + w)),
                y = Lerp(RealFrameTime() * 5, poly[3].y, y),
            }
        else 
            poly[1] = {
                x = Lerp(RealFrameTime() * 5, poly[1].x, x),
                y = Lerp(RealFrameTime() * 5, poly[1].y, y + h),
            }
            poly[2] = {
                x = Lerp(RealFrameTime() * 5, poly[2].x, x + (w / 2)),
                y = Lerp(RealFrameTime() * 5, poly[2].y, y),
            }
            poly[3] = {
                x = Lerp(RealFrameTime() * 5, poly[3].x, (x + w)),
                y = Lerp(RealFrameTime() * 5, poly[3].y, y + h),
            }
        end 
    else 
        poly = {
            {
                x = x,
                y = y
            },
            {
                x = x + (w / 2),
                y = y + h
            },
            {
                x = (x + w),
                y = y
            },
        }
    end 
    
    draw.NoTexture()
    YAWS.UI.SetSurfaceDrawColor(YAWS.UI.ColorScheme()['text_header'])

    for k,v in ipairs(poly) do
        if(k >= #poly) then continue end 
        surface.DrawLine(v.x, v.y, poly[k + 1].x, poly[k + 1].y)
    end

    return poly
end 

-- NOTE: Must be used with something like draw.DrawText or something
function YAWS.UI.TextWrap(text, font, maxWidth)
    local i = ""
    surface.SetFont(font)
    for k,v in ipairs(string.Explode(" ", text)) do 
        i = i .. " " .. v

        local width = surface.GetTextSize(i)
        if(width >= maxWidth) then 
            i = string.Trim(string.sub(i, 0, #i - #v)) .. "\n" .. string.Trim(v)
        end 
    end 

    return string.Trim(i)
end 

-- https://easings.net/#easeOutCubic 
-- Was originally easeOutCirc but changed it cus this one is cheaper to run with
-- the same sort of results.
function YAWS.UI.EaseOutCubic(x)
    return 1 - ((1 - x) ^ 3)
end 


-- Other shit
net.Receive("yaws.core.openui", function(len)
    YAWS.Core.PayloadDebug("yaws.core.openui", len)
    -- nother curator learn how addon work time
    -- Here I store the data the addon needs inside this table, that way if the
    -- UI needs the data it's in this table. I do this just to prevent me from
    -- shipping parameters into the ui functions all the time. 
    YAWS.UI.CurrentData = util.JSONToTable(util.Decompress(net.ReadData(net.ReadUInt(16))))

    if(YAWS.UI.CurrentData.state) then
        -- needs to open seperately
        if(YAWS.UI.CurrentData.state.state == "warning_player") then
            YAWS.UI.WarnPlayerPopup({
                steamid = YAWS.UI.CurrentData.state.steamid,
                realSteamID = util.SteamIDFrom64(YAWS.UI.CurrentData.state.steamid),
                name = YAWS.UI.CurrentData.state.name,
                usergroup = YAWS.UI.CurrentData.state.usergroup,
            })

            return
        end
        if(YAWS.UI.CurrentData.state.state == "viewing_warning") then
            YAWS.UI.ViewWarning(YAWS.UI.CurrentData.state.playerData, YAWS.UI.CurrentData.state.warnData)
            YAWS.UI.StateCache = {}
            YAWS.UI.StateCache["warn_data_return"] = "viewing_self"
            
            return
        end
    end

    YAWS.UI.CoreUI()

    -- Cached states
    if(YAWS.UI.CurrentData.state) then
        if(YAWS.UI.CurrentData.state.state == "viewing_player") then
            YAWS.UI.CurrentData.FrameCache:SetSidebarSelectedName(YAWS.Language.GetTranslation("sidebar_players"))

            YAWS.UI.HandleGettingPlayerWarndata(YAWS.UI.CurrentData.MasterCache, {
                steamid = YAWS.UI.CurrentData.state.steamid,
                name = YAWS.UI.CurrentData.state.name,
                usergroup = YAWS.UI.CurrentData.state.usergroup,
            })
        end

        if(YAWS.UI.CurrentData.state.state == "viewing_player_notes") then
            YAWS.UI.CurrentData.FrameCache:SetSidebarSelectedName(YAWS.Language.GetTranslation("sidebar_players"))

            YAWS.UI.HandleGettingPlayerWarndata(YAWS.UI.CurrentData.MasterCache, {
                steamid = YAWS.UI.CurrentData.state.steamid,
                name = YAWS.UI.CurrentData.state.name,
                usergroup = YAWS.UI.CurrentData.state.usergroup,
            }, true)
        end
    end
end)

-- Properties menu stuff 
properties.Add("yaws_primary", {
    MenuLabel = (YAWS.Language.GetTranslationSafe("yaws") == "" && "Yet Another Warning System" || YAWS.Language.GetTranslationSafe("yaws")),
    MenuIcon = "icon16/book_error.png",
    StructureField = 90000,
    Filter = function(self, ent, player)
        if(!IsValid(ent)) then return false end
        if(!ent:IsPlayer()) then return false end

        return YAWS.UI.ContextData['view'] || YAWS.UI.ContextData['create']
    end,
    -- return true 
    MenuOpen = function(self, option, ent, tr)
        if(!ent || !IsValid(ent)) then return end 
        
        local options = option:AddSubMenu("base")

        if(YAWS.UI.ContextData['create']) then
            options:AddOption(YAWS.Language.GetTranslationSafe("context_warn"), function()
                net.Start("yaws.core.c_warnplayer")
                -- 76561198121018313
                net.WriteString(ent:SteamID64() || "")
                net.SendToServer()
            end):SetIcon("icon16/page_white_edit.png")

            -- Presets
            local presetSub, presetMenuOption = options:AddSubMenu(YAWS.Language.GetTranslationSafe("context_presets"))
            presetMenuOption:SetIcon("icon16/folder_error.png")

            for k, v in pairs(YAWS.UI.ContextData['presets']) do
                local preset = presetSub:AddSubMenu(k)
                preset:AddOption(YAWS.Language.GetFormattedTranslation("context_points", v.points)):SetIcon("icon16/award_star_gold_3.png")
                preset:AddOption(YAWS.Language.GetFormattedTranslation("context_reason", v.reason)):SetIcon("icon16/page_edit.png")
                preset:AddSpacer()

                preset:AddOption(YAWS.Language.GetTranslationSafe('context_submit'), function()
                    net.Start("yaws.warns.warnplayer")
                    net.WriteBool(true)
                    net.WriteString(ent:SteamID64() || "")
                    net.WriteString(k)
                    net.SendToServer()
                end):SetIcon("icon16/accept.png")
            end

            if(YAWS.UI.ContextData['view']) then
                options:AddSpacer()
            end
        end

        if(YAWS.UI.ContextData['view']) then
            options:AddOption(YAWS.Language.GetTranslationSafe("context_viewwarns"), function()
                net.Start("yaws.core.c_viewplayer")
                net.WriteString(ent:SteamID64() || "")
                net.SendToServer()
            end):SetIcon("icon16/eye.png")

            options:AddOption(YAWS.Language.GetTranslationSafe("context_viewnotes"), function()
                net.Start("yaws.core.c_viewnotes")
                net.WriteString(ent:SteamID64() || "")
                net.SendToServer()
            end):SetIcon("icon16/page_white_edit.png")
        end
    end
})

-- Request to the server if we should be able to see the context menu 
-- This is the only cached shit there is settings/presets based 
YAWS.UI.ContextData = YAWS.UI.ContextData || {}

hook.Add("InitPostEntity", "yaws.ui.contextgview", function()
    net.Start("yaws.permissions.caniviewcontextquestionmark")
    net.SendToServer()
end)

net.Receive("yaws.permissions.maybeyoucanviewyes", function()
    YAWS.UI.ContextData['view'] = net.ReadBool()
    YAWS.UI.ContextData['create'] = net.ReadBool()

    if(YAWS.UI.ContextData['create']) then
        YAWS.UI.ContextData['presets'] = util.JSONToTable(util.Decompress(net.ReadData(net.ReadUInt(16))))
    end
end)