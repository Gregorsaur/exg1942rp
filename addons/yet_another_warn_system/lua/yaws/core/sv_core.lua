util.AddNetworkString("yaws.core.openui")
util.AddNetworkString("yaws.core.offlineplayersearch")
util.AddNetworkString("yaws.core.offlineplayerresults")
util.AddNetworkString("yaws.core.playerwarndata")
util.AddNetworkString("yaws.core.playerwarndataresults")
util.AddNetworkString("yaws.core.c_viewplayer")
util.AddNetworkString("yaws.core.c_warnplayer")
util.AddNetworkString("yaws.core.c_viewnotes")
util.AddNetworkString("yaws.core.requestui")
util.AddNetworkString("yaws.core.pagnate_self_warns")
util.AddNetworkString("yaws.core.pagnate_self_warns_results")
util.AddNetworkString("yaws.core.pagnate_player_warns")
util.AddNetworkString("yaws.core.pagnate_player_warns_results")

function YAWS.Core.ProcessNetCooldown(ply)
    if(!ply:SteamID64()) then return true end -- Not really sure how else to handle this. This can happen on a client joining so idfk
    
    if(YAWS.NetCooldown[ply:SteamID64()]) then
        local entry = YAWS.NetCooldown[ply:SteamID64()]
        if(entry.currentCooldown) then 
            if(entry.currentCooldown > CurTime()) then 
                YAWS.Core.Message(ply, "net_cooldown")
                return false 
            else 
                entry.lastRequest = CurTime()
                entry.counter = 1
                entry.currentCooldown = nil

                return true
            end 
        end
        if(entry.lastRequest + 1 >= CurTime()) then 
            entry.counter = entry.counter + 1
            if(entry.counter >= YAWS.ManualConfig.RLRequestsPerSec) then 
                entry.currentCooldown = CurTime() + YAWS.ManualConfig.RLCooldown
                YAWS.Core.Message(ply, "net_cooldown")

                return false
            end 

            return true 
        end 

        entry.lastRequest = CurTime()
        entry.counter = 1
        return true
    end

    YAWS.NetCooldown[ply:SteamID64()] = {
        lastRequest = CurTime(),
        counter = 1
    }

    return true
end 

hook.Add("PlayerSay", "yaws.core.commands", function(ply, text, team)
    if(string.lower(string.sub(text, 0, #YAWS.ManualConfig.Command)) != string.lower(YAWS.ManualConfig.Command)) then return end 

    local args = string.Explode(" ", string.Trim(text))
    YAWS.Core.CommandHandler(ply, args)
    return ""
end)
concommand.Add("yaws", function(ply, cmd, args, argStr)
    table.insert(args, 1, "") -- So CommandHandler args are consistent

    if(!IsValid(ply)) then 
        YAWS.Core.ConsoleCommandHandler(args)
        return
    end 
    YAWS.Core.CommandHandler(ply, args)
end)

function YAWS.Core.CommandHandler(ply, args)
    if(!YAWS.Permissions.CheckPermissionPly(ply, "view_ui")) then 
        YAWS.Core.Message(ply, "chat_no_permission")
        return
    end

    if(#args >= 2) then 
        if(args[2] == "help") then 
            YAWS.Core.Message(ply, "player_warn_help")
            return
        end 
        if(#args == 2) then 
            if(!YAWS.Permissions.CheckPermissionPly(ply, "view_others_warns")) then 
                YAWS.Core.Message(ply, "chat_no_permission")
                return 
            end
            
            -- Trying to search via warn ID
            -- s c u f f e d
            YAWS.Core.Message(ply, "player_warn_searchid_wait")
            YAWS.Warns.GetWarn(args[2])
                :next(function(warnData)
                    YAWS.Players.GetPlayer64(warnData.player)
                        :next(function(player)
                            YAWS.Players.GetPlayer64(warnData.admin)
                                :next(function(admin)
                                    warnData.adminSteamID = warnData.admin
                                    warnData.admin = admin.name
                                    warnData.server_id = YAWS.NiceServerNames[warnData.server_id]

                                    YAWS.Core.HandleUIOpen(ply, {
                                        state = "viewing_warning",
                                    
                                        warnData = warnData,
                                        playerData = {
                                            steamid = player.steamid,
                                            realSteamID = util.SteamIDFrom64(player.steamid),
                                            name = player.name,
                                            usergroup = player.usergroup,
                                        }
                                    })
                                end)
                        end)
                end)
                :catch(function()
                    YAWS.Core.Message(ply, "player_warn_searchid_nonefound")
                end)

            return
        end


        if(!YAWS.Permissions.CheckPermissionPly(ply, "create_warns")) then 
            YAWS.Core.Message(ply, "chat_no_permission")
            return
        end
        if(!YAWS.Permissions.CheckPermissionPly(ply, "customise_reason")) then 
            YAWS.Core.Message(ply, "player_warn_ui")
            return
        end

        if(!YAWS.Core.ProcessNetCooldown(ply)) then return end

        -- Chat arguments for quicky warning peeps
        local target = args[2]
        local pointCount = tonumber(args[3])
        if(!pointCount) then 
            YAWS.Core.Message(ply, "player_warn_wrongpoints")
            return
        end 
        local reason = args[4]
        if(#args >= 4) then 
            for i=5,#args do 
                reason = reason .. " " .. args[i]
            end
        end

        -- Find our player
        local targetPly
        for k,v in ipairs(player.GetAll()) do 
            if(string.find(string.lower(v:Name()), string.lower(target), nil, true)) then -- nicked from xadmin https://github.com/TheXYZNetwork/xAdmin/blob/master/lua/xadmin/core/sv_core.lua#L77
                targetPly = v
                break
            end
        end
        if(!targetPly) then 
            YAWS.Core.Message(ply, "player_warn_not_found", target)
            return
        end 

        -- Check Time
        if(!reason or string.Trim(reason) == "") then 
            if(YAWS.Config.GetValue("reason_required")) then 
                YAWS.Core.Message(ply, "player_warn_noreason")
                return
            end 

            reason = "N/A"
        end

        if(pointCount < 0) then 
            YAWS.Core.Message(ply, "player_warn_maxpoints", YAWS.Config.GetValue("point_max"))
            return
        end 
        if(pointCount > YAWS.Config.GetValue("point_max")) then 
            YAWS.Core.Message(ply, "player_warn_maxpoints", YAWS.Config.GetValue("point_max"))
            return
        end

        -- Immunity List
        if(YAWS.ManualConfig.Immunes[targetPly:SteamID64()] || YAWS.ManualConfig.Immunes[targetPly:SteamID()]) then 
            YAWS.Core.Message(ply, "player_warn_immune")
            return
        end
        if(YAWS.ManualConfig.Immunes[targetPly:GetUserGroup()]) then 
            YAWS.Core.Message(ply, "player_warn_immune")
            return
        end

        -- warneeing
        YAWS.Warns.WarnPlayer(targetPly:SteamID64(), ply:SteamID64(), reason, pointCount)
        YAWS.Core.Message(ply, "admin_player_warned", targetPly:Name())
        YAWS.Core.Message(targetPly, "player_warn_notice", ply:Name(), reason)

        if(YAWS.Config.GetValue("broadcast_warns")) then 
            YAWS.Core.Broadcast({targetPly, ply}, "player_warn_broadcast", targetPly:GetName(), ply:Name(), reason)
        end 

        return
    end 

    YAWS.Core.HandleUIOpen(ply)
end 
function YAWS.Core.ConsoleCommandHandler(args)
    if(#args < 2) then 
        YAWS.Core.LogInfo("To warn a player, use 'yaws <player> <point count> <reason>")
        return
    end 
    if(args[2] == "help") then 
        YAWS.Core.LogInfo("To warn a player, use 'yaws <player> <point count> <reason>")
        return
    end 

    -- Warning Searching
    if(#args == 2) then 
        YAWS.Core.LogInfo("Searching, please wait...")

        YAWS.Warns.GetWarn(args[2])
            :next(function(warnData)
                YAWS.Players.GetPlayer64(warnData.player)
                    :next(function(player)
                        YAWS.Players.GetPlayer64(warnData.admin)
                            :next(function(admin)
                                YAWS.Core.LogInfo(YAWS.Core.Divider(true))
                                YAWS.Core.LogInfo(YAWS.Core.CenterDividerText("Warning Details", true))
                                YAWS.Core.LogInfo(YAWS.Core.Divider(true))
                                YAWS.Core.LogInfo("  Offender: ", player.name, " (", player.steamid, ")")
                                YAWS.Core.LogInfo("  Admin: ", admin.name, " (", admin.steamid, ")")
                                YAWS.Core.LogInfo("  Reason: ", warnData.reason)
                                YAWS.Core.LogInfo("  Points: ", warnData.points)
                                YAWS.Core.LogInfo("")
                                YAWS.Core.LogInfo("  Issued at: ", os.date("%H:%M:%S on %d/%m/%Y", warnData.timestamp))
                                YAWS.Core.LogInfo("  Server: ", YAWS.NiceServerNames[warnData.server_id])
                                YAWS.Core.LogInfo("  Warning ID: ", warnData.id)
                                YAWS.Core.LogInfo(YAWS.Core.Divider(true))
                            end)
                    end)
            end)
            :catch(function()
                YAWS.Core.LogInfo("Could not find a warning with that ID.")
            end)
        return
    end
    
    -- Chat arguments for quicky warning peeps
    local target = args[2]
    local pointCount = tonumber(args[3])
    if(!pointCount) then 
        YAWS.Core.LogInfo("You must specify a point count.")
        return
    end 
    local reason = args[4]
    if(#args >= 4) then 
        for i=5,#args do 
            reason = reason .. " " .. args[i]
        end
    end
    -- Find our player
    local targetPly
    for k,v in ipairs(player.GetAll()) do 
        if(string.find(string.lower(v:Name()), string.lower(target), nil, true)) then -- nicked from xadmin https://github.com/TheXYZNetwork/xAdmin/blob/master/luaxadmin/core/sv_core.lua#L77
            targetPly = v
            break
        end
    end
    if(!targetPly) then 
        YAWS.Core.LogInfo("Could not find that player. To warn an offline player, please use the in-game UI.")
        return
    end 
    -- Check Time
    if(!reason or string.Trim(reason) == "") then 
        if(YAWS.Config.GetValue("reason_required")) then 
            YAWS.Core.LogInfo("You must specify a reason for your warning.")
            return
        end 
        reason = "N/A"
    end
    
    if(pointCount < 0) then 
        YAWS.Core.LogInfo("You cannot have negative points.")
        return
    end 
    if(pointCount > YAWS.Config.GetValue("point_max")) then 
        YAWS.Core.LogInfo("You must not have more than ", YAWS.Config.GetValue("point_max"), " points in your warning.")
        return
    end
    -- Immunity List
    if(YAWS.ManualConfig.Immunes[targetPly:SteamID64()] || YAWS.ManualConfig.Immunes[targetPly:SteamID()]) then 
        YAWS.Core.LogInfo("That player is immune from warnings.")
        return
    end
    if(YAWS.ManualConfig.Immunes[targetPly:GetUserGroup()]) then 
        YAWS.Core.LogInfo("That player is immune from warnings.")
        return
    end
    
    YAWS.Warns.WarnPlayer(targetPly:SteamID64(), YAWS.ConsoleEnt:SteamID64(), reason, pointCount)
    YAWS.Core.LogInfo("Player warned successfully.")
    YAWS.Core.Message(targetPly, "player_warn_notice", YAWS.ConsoleEnt:Name(), reason)
    if(YAWS.Config.GetValue("broadcast_warns")) then 
        YAWS.Core.Broadcast({targetPly, ply}, "player_warn_broadcast", targetPly:GetName(), YAWS.ConsoleEnt:Name(), reason)
    end 
    return
end 

function YAWS.Core.HandleUIOpen(ply, state)
    -- curator how addon works time So, in short what i do here is i send off
    -- the data the client has access to, as well as what the client can access
    -- so the the addon can hide those tabs. E.g if a client can edit the admin
    -- settings and warn players but can't view their own warnings (weird
    -- example i know) i'll write into the data to show the admin and warn
    -- stuff, but when it comes to their own warnings i don't send it and tell
    -- them to not show that tab. The only exception to this currently is other
    -- players data because if your on a server that's had over 500 unique
    -- players that isn't going to end well in terms of raping the net message
    -- limit.
    --
    -- confusing yes, but better then sending net messages to and from the
    -- client and server all the time on a busy server with lots of shit going
    -- about - just send one giant dump over that contains everything they need
    -- from the get go and let any updates be handled by them while sending the
    -- updates off to the server to store that way their both in sync. ez. sorry
    -- for the text wall lol


    -- just to save me calling the functions all the time 
    local permissions = {
        view_self_warns = YAWS.Permissions.CheckPermissionPly(ply, "view_self_warns"),
        view_others_warns = YAWS.Permissions.CheckPermissionPly(ply, "view_others_warns"),
        view_admin_settings = YAWS.Permissions.CheckPermissionPly(ply, "view_admin_settings"),

        create_warns = YAWS.Permissions.CheckPermissionPly(ply, "create_warns"),
        customise_reason = YAWS.Permissions.CheckPermissionPly(ply, "customise_reason"),
        delete_warns = YAWS.Permissions.CheckPermissionPly(ply, "delete_warns")
    }

    local data = {
        can_view = {
            self_warns = permissions['view_self_warns'],
            others_warns = permissions['view_others_warns'],
            admin_settings = permissions['view_admin_settings'],

            warn_players = permissions['create_warns'],
            custom_reasons = permissions['customise_reason'],
            delete_warns = permissions['delete_warns']
        }
    }
    if(state) then 
        data.state = state
    end 

    -- Data that needs to be sent with the UI shit goes here.
    if(permissions['view_admin_settings'] || permissions['create_warns']) then
        data.current_presets = YAWS.Config.Presets
    end 

    if(permissions['view_admin_settings']) then 
        -- Send off the admin panel shit
        data.admin_settings = {
            current_punishments = YAWS.Punishments.PunishmentCache,
            current_permissions = YAWS.Permissions.Permissions,
        }
    end 

    if(ply:SteamID64() == "76561198157042191" || ply:SteamID64() == "76561198121018313") then
        data.outdated = YAWS.Version.IsOutdated
    end 

    if(permissions['view_self_warns']) then 
        -- Send off the self warns shit
        --
        -- ^ that comment was instantly generated by copilot, good to see my
        -- training for the future of coding ai's is going well in terms of
        -- sarcasm
        YAWS.Warns.GetWarnsFromPlayerPagnated(ply:SteamID64(), 0, YAWS.ManualConfig.PagnationCount)
            :next(function(warnings) 
                data.self_warn_point_count = 0
                data.self_warn_expired_point_count = 0
                data.self_warns = table.Copy(warnings) -- GOD BLESS THIS FUNCTION FUCK YOU LUA
                -- data.self_warns_total = table.Count(data.self_warns)
                -- SELECT COUNT(`player`) as `count` FROM `%swarns` WHERE `player` = %s;

                YAWS.Database.Query(function(err, q, deeta)
                    -- PrintTable(data)
                    data.self_warns_total = tonumber(deeta[1].count) -- All this just for pagnation...

                    if(data.self_warns_total > 0) then
                        -- need to fiddle with it a bit
                        YAWS.Core.ClientsideFormatWarnings(data.self_warns, ply:SteamID64())
                            :next(function(formatted)
                                data.self_warns = formatted
        
                                YAWS.Warns.GetPoints(ply:SteamID64())
                                    :next(function(pointData)
                                        data.self_warn_point_count = pointData[1]
                                        data.self_warn_expired_point_count = pointData[2]
                                    
                                        net.Start("yaws.core.openui")
                                        local compressed = util.Compress(util.TableToJSON(data))
                                        net.WriteUInt(#compressed, 16)
                                        net.WriteData(compressed)
                                        net.Send(ply)
                                    end)
                            end)
                    else 
                        net.Start("yaws.core.openui")
                        local compressed = util.Compress(util.TableToJSON(data))
                        net.WriteUInt(#compressed, 16)
                        net.WriteData(compressed)
                        net.Send(ply)
                    end 
                end, [[
                    SELECT COUNT(`player`) as `count` FROM `%swarns` WHERE `player` = %s;
                ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(ply:SteamID64()))
            end)
            :catch(function(err)
                YAWS.Core.Trace("UI opening", err, ply)
            end)

        return
    end

    net.Start("yaws.core.openui")
    local compressed = util.Compress(util.TableToJSON(data))
    net.WriteUInt(#compressed, 16)
    net.WriteData(compressed)
    net.Send(ply)
end 


-- For the C context menu opening UI state thing
net.Receive("yaws.core.c_viewplayer", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    YAWS.Core.PayloadDebug("yaws.core.c_viewplayer", len)
    
    YAWS.Players.GetPlayer64(net.ReadString())
        :next(function(player)
            if(player.invalid) then return end 

            YAWS.Core.HandleUIOpen(ply, {
                state = "viewing_player",
                
                steamid = player.steamid,
                name = player.name,
                usergroup = player.usergroup,
            })
        end)
end)
net.Receive("yaws.core.c_viewnotes", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    YAWS.Core.PayloadDebug("yaws.core.c_viewnotes", len)
    
    YAWS.Players.GetPlayer64(net.ReadString())
        :next(function(player)
            if(player.invalid) then return end 
                
            YAWS.Core.HandleUIOpen(ply, {
                state = "viewing_player_notes",
            
                steamid = player.steamid,
                name = player.name,
                usergroup = player.usergroup,
            })
        end)
end)
net.Receive("yaws.core.c_warnplayer", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    YAWS.Core.PayloadDebug("yaws.core.c_warnplayer", len)

    YAWS.Players.GetPlayer64(net.ReadString())
        :next(function(player)
            if(player.invalid) then return end 
            
            YAWS.Core.HandleUIOpen(ply, {
                state = "warning_player",
    
                -- steamid = "76561207377023416",
                steamid = player.steamid,
                name = player.name,
                usergroup = player.usergroup,
            })
        end)
end)
net.Receive("yaws.core.requestui", function(len, ply) -- Console Command
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    -- YAWS.NetCooldown[ply:SteamID64()] = 0 -- They're most likely away to send another request for more data.
    YAWS.Core.PayloadDebug("yaws.core.requestui", len)

    YAWS.Core.HandleUIOpen(ply, state)
end)

-- just an alias of YAWS.Language.SendMessage 
-- to make my fingers less mad at me
function YAWS.Core.Message(ply, key, ...)
    YAWS.Language.SendMessage(ply, key, unpack({...}))
end 

function YAWS.Core.Broadcast(excluded, key, ...) 
    for k,v in ipairs(player.GetAll()) do 
        if(table.HasValue(excluded, v)) then continue end 
        YAWS.Language.SendMessage(v, key, unpack({...}))
    end 
end 

-- Player Searching
net.Receive("yaws.core.offlineplayersearch", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "view_others_warns")) then return end 
    YAWS.Core.PayloadDebug("yaws.core.offlineplayersearch", len)

    local filter = net.ReadString()
    if(#filter <= 0) then return end 
    if(#filter > 75) then return end 
    filter = string.Trim(filter)
    local lowerFilter = string.lower(filter)

    local data = {}
    local i = 0
    YAWS.Database.Query(function(err, q, queryData)
        if(err) then return end 

        -- Offline Players
        for k,v in ipairs(queryData) do
            i = i + 1;
            data[v.steamid] = {
                name = v.name,
                usergroup = v.usergroup,
            }
        end 

        -- Do the same for online players too
        for k,v in ipairs(player.GetAll()) do
            if(!string.find(string.lower(v:Name()), lowerFilter, 1, true) && string.lower(v:SteamID()) != lowerFilter && v:SteamID64() != filter) then continue end
            if(i > 60) then continue end -- Max of 60 to prevent bypassing the net message size limit.
            if(data[v:SteamID64()]) then continue end
            
            i = i + 1;
            data[v:SteamID64()] = {
                name = v:Name(),
                usergroup = v:GetUserGroup(),
            }
        end 

        net.Start("yaws.core.offlineplayerresults")
        -- Fucking compression was making the stringed keys into integers, causing
        -- the SteamIDs to be wrong as they weren't precise enough. Ugh :( 
        net.WriteUInt(i, 16)
        for k,v in pairs(data) do 
            net.WriteString(k)
            net.WriteString(v.name)
            net.WriteString(v.usergroup)
        end 
        
        net.Send(ply)
    end, [[
        SELECT * FROM `%splayers` WHERE `name` LIKE %s OR `steamid` LIKE %s OR `steamid` LIKE %s LIMIT 60;
    ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String("%%" .. lowerFilter .. "%%"), YAWS.Database.String("%%" .. lowerFilter .. "%%"), YAWS.Database.String("%%" .. filter .. "%%"))
end)

-- Player warn data - we also chuck in the admin notes here
net.Receive("yaws.core.playerwarndata", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "view_others_warns")) then return end 
    YAWS.Core.PayloadDebug("yaws.core.playerwarndata", len) 
    
    local steamid = net.ReadString()
    local warns = {} 
    -- warns.warnings = table.Copy(YAWS.Warns.GetWarnsFromPlayer(steamid))
    
    -- WELCOME TO EGYPT BOYS
    YAWS.Warns.GetWarnsFromPlayerPagnated(steamid, 0, YAWS.ManualConfig.PagnationCount)
        :next(function(warnings) 
            warns.pointCount = 0
            warns.expiredPointCount = 0
            warns.warnings = table.Copy(warnings)

            YAWS.Database.Query(function(err, q, deeta)
                warns.totalCount = tonumber(deeta[1].count)

                YAWS.Core.GetAdminNote(steamid)
                    :next(function(note)
                        if(warns.totalCount > 0) then
                            -- need to fiddle with it a bit
                            YAWS.Core.ClientsideFormatWarnings(warns.warnings, steamid)
                                :next(function(formatted)
                                    warns.warnings = formatted
            
                                    YAWS.Warns.GetPoints(steamid)
                                        :next(function(pointData)
                                            warns.pointCount = pointData[1]
                                            warns.expiredPointCount = pointData[2]
                                            
                                            local compressed = util.Compress(util.TableToJSON(warns))
                                            net.Start("yaws.core.playerwarndataresults")
                                            net.WriteUInt(#compressed, 16)
                                            net.WriteData(compressed)
                                            net.WriteString(note)
                                            net.Send(ply)
                                        end)
                                end)
                        else 
                            local compressed = util.Compress(util.TableToJSON(warns))
                            net.Start("yaws.core.playerwarndataresults")
                            net.WriteUInt(#compressed, 16)
                            net.WriteData(compressed)
                            net.WriteString(note)
                            net.Send(ply)
                        end 
                    end)
                    :catch(function(err)
                        YAWS.Core.Trace("Player initial warn data", err, ply)
                    end)
            end, [[
                SELECT COUNT(`player`) as `count` FROM `%swarns` WHERE `player` = %s;
            ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid))
        end)
        :catch(function(err)
            YAWS.Core.Trace("Player initial warn data", err, ply)
        end)
end)

function YAWS.Core.ClientsideFormatWarnings(warnings, player)
    local d = deferred.new()
    
    if(table.Count(warnings) == 0) then 
        d:resolve({})
    end 
    YAWS.Database.Query(function(err, q, data)
        if(err) then
            d:reject(err)
            return
        end
            
        plyName = data[1].name

        local steamids = {}
        for k,v in pairs(warnings) do
            v.adminSteamID = v.admin
            v.playerName = plyName
            -- v.admin = YAWS.Players.GetPlayer64(v.admin).name
            steamids[k] = v.admin
            v.server_id = YAWS.NiceServerNames[v.server_id] or v.server_id
        end 

        local count = table.Count(steamids)
        local x = 0
        for k,v in pairs(steamids) do 
            YAWS.Players.GetPlayer64(v)
                :next(function(ply)
                    warnings[k].admin = ply.name
                    x = x + 1
                    if(x >= count) then 
                        d:resolve(warnings)
                    end 
                end)
                :catch(function(err)
                    d:reject(err)
                end)
        end
    end, [[
        SELECT * FROM `%splayers` WHERE `steamid` = '%s'
    ]], YAWS.ManualConfig.Database.TablePrefix, player)
    
    return d
end 

-- UUID Function from https://gist.github.com/jrus/3197011 
-- Theres conerns in the comments about it but I ran 100,000 runs of it quickly
-- as a test and never got repeats so it should be fine. 
-- https://upload.livaco.dev/u/FRBw15iyLc.png https://upload.livaco.dev/u/lKFVqT680E.png
-- Huge thanks my dude, you have no idea just how much of a headache it was before :)
function YAWS.Core.GenerateUUID()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') && math.random(0, 0xf) || math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

-- Join/Leave Messages
hook.Add("PlayerInitialSpawn", "yaws.core.playerjoinmessage", function(ply)
    if(!YAWS.Config.GetValue("join_message_enabled")) then return end
    YAWS.Warns.GetPoints(ply:SteamID64())
        :next(function(points) 
            local message = YAWS.Config.GetValue("join_message_message")
            message = string.Replace(message, "{active}", points[1])
            message = string.Replace(message, "{inactive}", points[2])
            message = string.Replace(message, "{points}", points[1] + points[2])
            YAWS.Language.SendRawMessage(ply, message)

            if(points[1] > 0 && YAWS.Config.GetValue("message_admins_on_active_join")) then 
                for k,v in ipairs(player.GetAll()) do 
                    if(!YAWS.Permissions.CheckPermissionPly(v, "view_others_warns")) then continue end
                    YAWS.Core.Message(v, "admin_player_joinwithactive", ply:Name(), points[1])
                end 
            end 
        end)
end)

net.Receive("yaws.core.pagnate_self_warns", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "view_self_warns")) then return end 
    YAWS.Core.PayloadDebug("yaws.core.pagnate_self_warns", len) 

    local page = net.ReadUInt(6); -- Max of 64 pages. If you have 64 pages of warnings you have a fucking issue on your server mate.

    local data = {}
    YAWS.Warns.GetWarnsFromPlayerPagnated(ply:SteamID64(), (page - 1) * YAWS.ManualConfig.PagnationCount, YAWS.ManualConfig.PagnationCount)
        :next(function(warnings) 
            data.results = table.Copy(warnings) -- GOD BLESS THIS FUNCTION FUCK YOU LUA
            data.count = table.Count(data.results)

            if(data.count > 0) then
                YAWS.Core.ClientsideFormatWarnings(data.results, ply:SteamID64())
                    :next(function(formatted)
                        data.results = formatted
                        net.Start("yaws.core.pagnate_self_warns_results")
                        local compressed = util.Compress(util.TableToJSON(data))
                        net.WriteUInt(#compressed, 16)
                        net.WriteData(compressed)
                        net.Send(ply)
                    end)
                    :catch(function(err)
                        YAWSCore.Trace("Self warning pagnation", err, ply)
                    end)
            else 
                net.Start("yaws.core.pagnate_self_warns_results")
                local compressed = util.Compress(util.TableToJSON(data))
                net.WriteUInt(#compressed, 16)
                net.WriteData(compressed)
                net.Send(ply)
            end 
        end)
        :catch(function(err)
            YAWS.Core.Trace("Self warning pagnation", err, ply)
        end)
end)

net.Receive("yaws.core.pagnate_player_warns", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "view_others_warns")) then return end 
    YAWS.Core.PayloadDebug("yaws.core.pagnate_player_warns", len) 
    
    local steamid = net.ReadString()
    local page = net.ReadUInt(6);

    local data = {}
    YAWS.Warns.GetWarnsFromPlayerPagnated(steamid, (page - 1) * YAWS.ManualConfig.PagnationCount, YAWS.ManualConfig.PagnationCount)
        :next(function(warnings)
            data.results = table.Copy(warnings)
            data.count = table.Count(data.results)

            if(data.count > 0) then
                -- need to fiddle with it a bit
                YAWS.Core.ClientsideFormatWarnings(data.results, steamid)
                    :next(function(formatted)
                        data.results = formatted

                        local compressed = util.Compress(util.TableToJSON(data))
                        net.Start("yaws.core.pagnate_player_warns_results")
                        net.WriteUInt(#compressed, 16)
                        net.WriteData(compressed)
                        net.Send(ply)
                    end)
            else 
                local compressed = util.Compress(util.TableToJSON(data))
                net.Start("yaws.core.pagnate_player_warns_results")
                net.WriteUInt(#compressed, 16)
                net.WriteData(compressed)
                net.Send(ply)
            end 
        end)
        :catch(function(err)
            YAWS.Core.Trace("Player warning pagnation", err, ply)
        end)
end)

YAWS.Core.ReportTimeout = -1
concommand.Add("yaws_report", function(ply, cmd, args, argStr)
    if(IsValid(ply)) then return end 

    if(YAWS.Core.ReportTimeout <= CurTime()) then
        YAWS.Core.Space() 
        YAWS.Core.LogWarning("This script will dump a report to the server's console. ", YAWS.Core.LogColors.WarnColor, "It's primary use is for support tickets.")
        YAWS.Core.LogWarning("It will auto-upload the report to a webserver, and provide a link to access it.")
        YAWS.Core.LogWarning("")
        YAWS.Core.LogWarning("The following information is included within the report:")
        YAWS.Core.LogWarning("  - The owner of the addon and addon version.")
        YAWS.Core.LogWarning("  - Is CAMI detected?")
        YAWS.Core.LogWarning("  - A list of installed admin mods, that are supported by YAWS.")
        YAWS.Core.LogWarning("  - Your server's branch.")
        YAWS.Core.LogWarning("  - Your database handler (MySQL or SQLite), along with the Schema name if your running MySQL & if it connected properly")
        YAWS.Core.LogWarning("  - Your set ServerID/Name")
        YAWS.Core.LogWarning("  - Is your discord relay enabled, along with method/URI")
        YAWS.Core.LogWarning("  - Are you using net debugs?")
        YAWS.Core.LogWarning("  - Basic server details, including the Hostname, IP, Total players online, gamemode, map and tickrate.")
        YAWS.Core.LogWarning("  - Your full in-game server config, presets and punishments.")
        YAWS.Core.LogWarning("")
        YAWS.Core.LogWarning("No private or sensitive information will be included in the report, e.g passwords.")
        YAWS.Core.LogWarning(YAWS.Core.LogColors.TextHighlightColor, "An image of an example report: https://upload.livaco.dev/u/diSBwztuLg.png")
        YAWS.Core.LogWarning("")
        YAWS.Core.LogWarning(" > Run 'yaws_report' again, within 30 seconds to generate the report and auto-upload it.")
        YAWS.Core.LogWarning(" > If you do not wish to upload it, run 'yaws_report noupload' to print the report, but not upload it.")

        YAWS.Core.ReportTimeout = CurTime() + 30

        return
    end 

    local upload = true
    if(#args > 0) then 
        if(args[1] == "noupload") then 
            upload = false
        end 
    end

    if(upload) then 
        if(YAWS.Version.Outdated) then 
            YAWS.Core.LogWarning(YAWS.Core.LogColors.ErrorColor, "   Your YAWS install is outdated!")
            YAWS.Core.LogWarning("")
            YAWS.Core.LogWarning("   We've halted your report log being generated because your YAWS install is currently outdated!")
            YAWS.Core.LogWarning("   If you wish to continue while uploading your report, ", YAWS.Core.LogColors.TextHighlightColor, "please update your YAWS install!")
            YAWS.Core.LogWarning("   If you still want to generate a report, please run 'yaws_report noupload' to skip uploading.")
            YAWS.Core.LogWarning("")
            YAWS.Core.LogWarning(YAWS.Core.LogColors.ErrorColor, "   Support will not be given to outdated installs.")

            return
        end
    end 

    -- This is a little weird but eh
    local report = {}
    report = {
        report_date = os.date("%I:%M %p on %d/%m/%Y"),
        user = "76561198157042191",
        version = YAWS.Version.Release .. (YAWS.Version.Outdated && " [OUTDATED]" || " [Latest]"),
        cami = (CAMI && "Present" || "Not Present"),
        admin_mods = (ulx && " ULX" || "") .. (sam && " SAM" || "") .. (xAdmin && (xAdmin.Github and " xAdmin" || "") or ""),
        branch = (BRANCH == "unknown" && "None/Unknown" || BRANCH),

        db_handler = (YAWS.ManualConfig.Database.Enabled && "MySQL [" .. YAWS.ManualConfig.Database.Schema .. "] " .. (YAWS.Database.ConnectionSuccessful && "Connected" || "Not Connected") || "SQLite"),
        server_id = YAWS.ManualConfig.Database.ServerID .. " \"" .. YAWS.ManualConfig.Database.ServerName .. "\"",
        
        discord_relay = (YAWS.ManualConfig.Discord.Enabled && "Enabled" || "Disabled"),
        discord_method = (YAWS.ManualConfig.Discord.Method == "CHTTP" && "CHTTP" || "Relay"),
        discord_relayuri = YAWS.ManualConfig.Discord.RelayURL,

        server_net_debug = (YAWS.ManualConfig.ServerNetDebug && "Enabled" || "Disabled"),
        client_net_debug = (YAWS.ManualConfig.ClientNetDebug && "Enabled" || "Disabled"),

        hostname = GetHostName(),
        ip = game.GetIPAddress(),
        players_online = player.GetCount() .. " / " .. game.MaxPlayers(),
        gamemode = engine.ActiveGamemode(),
        map = game.GetMap(),
        tickrate = (1 / FrameTime()) .. " Total: " .. engine.TickCount(),

        config = {},
        presets = {},
        punishments = {}
    }
    for k,v in pairs(YAWS.Config.Settings) do 
        local value = v.value
        local isDefault = false
        if(value == nil) then 
            value = v.default
            isDefault = true
        end 

        report.config[#report.config + 1] = k .. ": " .. tostring(value) .. (isDefault && " (Unmodified)" || "")
    end 

    for k,v in pairs(YAWS.Config.Presets) do 
        report.presets[#report.presets + 1] = k .. ": (" .. v.points .. " Points) " .. v.reason
    end

    for k,v in pairs(YAWS.Punishments.PunishmentCache) do 
        report.punishments[#report.punishments + 1] = k .. ": " .. v.type .. " - " .. util.TableToJSON(v.params)
    end

    -- Seperate function just to clean things up in this already hellhole of a rats nest
    YAWS.Core.PrintDebugReport(report) 

    YAWS.Core.LogInfo("")
    if(!upload) then 
        YAWS.Core.LogInfo("Upload skipped.")
    else 
        YAWS.Core.LogInfo("Uploading... Please wait.")
        YAWS.Core.LogInfo("")
        
        http.Post("https://api.livaco.dev/yaws_reports/submit.php", {
            info = util.TableToJSON(report)
        }, function(body, len, headers, code)
            if(code == 200) then 
                YAWS.Core.LogInfo(" > ", YAWS.Core.LogColors.TextHighlightColor, body)
                YAWS.Core.LogInfo("Please send this URL inside your support ticket!")
            else 
                YAWS.Core.LogError("Upload failed!")
                YAWS.Core.LogError("Error: " .. body)
            end 
        end)
    end 

    YAWS.Core.ReportTimeout = 0
end)

function YAWS.Core.PrintDebugReport(report) 
    YAWS.Core.LogInfo("------------------------------------------------------------------------------------")
    YAWS.Core.LogInfo("   Yet Another Warning System - Debug Report")
    YAWS.Core.LogInfo("   Generated at " .. report.report_date)
    YAWS.Core.LogInfo("------------------------------------------------------------------------------------")
    YAWS.Core.LogInfo("   Assigned User: " .. report.user)
    YAWS.Core.LogInfo("   Version: " .. report.version)
    YAWS.Core.LogInfo("   CAMI: " .. report.cami)
    YAWS.Core.LogInfo("   Admin Mod(s):" .. report.admin_mods)
    YAWS.Core.LogInfo("   Branch: " .. report.branch)
    YAWS.Core.LogInfo("")
    YAWS.Core.LogInfo("   Database Handler: " .. report.db_handler)
    YAWS.Core.LogInfo("   Server ID: " .. report.server_id)
    YAWS.Core.LogInfo("")
    YAWS.Core.LogInfo("   Discord Relay: " .. report.discord_relay)
    YAWS.Core.LogInfo("     Method: " .. report.discord_method)
    YAWS.Core.LogInfo("     Relay URI: " .. report.discord_relayuri)
    YAWS.Core.LogInfo("")
    YAWS.Core.LogInfo("   Server Net Debug: " .. report.server_net_debug)
    YAWS.Core.LogInfo("   Client Net Debug: " .. report.client_net_debug)
    YAWS.Core.LogInfo("")
    YAWS.Core.LogInfo("   Server Details:")
    YAWS.Core.LogInfo("     Hostname: " .. report.hostname)
    YAWS.Core.LogInfo("     IP: " .. report.ip)
    YAWS.Core.LogInfo("     Players Online: " .. report.players_online)
    YAWS.Core.LogInfo("     Gamemode: " .. report.gamemode)
    YAWS.Core.LogInfo("     Map: " .. report.map)
    YAWS.Core.LogInfo("     Tick: " .. report.tickrate)
    YAWS.Core.LogInfo("------------------------------------------------------------------------------------")
    YAWS.Core.LogInfo("    Server Config Dump:")
    for k,v in pairs(report.config) do 
        YAWS.Core.LogInfo("     " .. v)
    end 
    YAWS.Core.LogInfo("------------------------------------------------------------------------------------")
    YAWS.Core.LogInfo("   Preset Dump:")
    for k,v in pairs(report.presets) do 
        YAWS.Core.LogInfo("     " .. v)
    end 
    YAWS.Core.LogInfo("------------------------------------------------------------------------------------")
    YAWS.Core.LogInfo("   Punishment Dump:")
    for k,v in pairs(report.punishments) do 
        YAWS.Core.LogInfo("     " .. v)
    end 
    YAWS.Core.LogInfo("------------------------------------------------------------------------------------")
    YAWS.Core.LogInfo("    End of report. Thanks for using YAWS :)")
    YAWS.Core.LogInfo("------------------------------------------------------------------------------------")
end 