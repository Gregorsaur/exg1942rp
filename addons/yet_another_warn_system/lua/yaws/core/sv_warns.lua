-- Actually handles the warns. I'm only starting to write this file 2 fucking
-- months into this project, motivation is just dead init

util.AddNetworkString("yaws.warns.warnplayer")
util.AddNetworkString("yaws.warns.deletewarn")
util.AddNetworkString("yaws.warns.wipewarns")
util.AddNetworkString("yaws.warns.confirmupdate")

function YAWS.Warns.WarnPlayer(steamid, admin, reason, points, serverOverride) 
    -- Check immunity list
    if(YAWS.ManualConfig.Immunes[steamid] || YAWS.ManualConfig.Immunes[util.SteamIDFrom64(steamid)]) then return end
    YAWS.Players.GetPlayer64(steamid)
        :next(function(playerData)
            if(playerData.invalid) then return end 
            if(YAWS.ManualConfig.Immunes[playerData.usergroup]) then return end

            local id = YAWS.Core.GenerateUUID()
            if(YAWS.ManualConfig.Database.Enabled) then 
                YAWS.Database.Query(nil, [[
                    INSERT INTO `%swarns`(`id`, `player`, `admin`, `reason`, `points`, `timestamp`, `server_id`) VALUES(UUID_TO_BIN(%s), %s, %s, %s, %s, %s, %s);
                ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(id), YAWS.Database.String(steamid), YAWS.Database.String(admin), YAWS.Database.String(reason), points, YAWS.Database.String(tostring(os.time())), YAWS.Database.String((!serverOverride and YAWS.ManualConfig.Database.ServerID || serverOverride)))
            else 
                YAWS.Database.Query(nil, [[
                    INSERT INTO `%swarns`(`id`, `player`, `admin`, `reason`, `points`, `timestamp`, `server_id`) VALUES(%s, %s, %s, %s, %s, %s, %s);
                ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(id), YAWS.Database.String(steamid), YAWS.Database.String(admin), YAWS.Database.String(reason), points, YAWS.Database.String(tostring(os.time())), YAWS.Database.String((!serverOverride and YAWS.ManualConfig.Database.ServerID || serverOverride)))
            end 

            hook.Run("yaws.warns.warned", steamid, admin, reason, points, id)
        end)
end 

function YAWS.Warns.GetWarn(id)
    local d = deferred.new()

    if(YAWS.ManualConfig.Database.Enabled) then
        YAWS.Database.Query(function(err, q, data)
            if(err) then 
                d:reject(err)
                return
            end 
            if(#data <= 0) then
                d:resolve(nil)
                return
            end 

            local warning = data[1]
            d:resolve(warning)
        end, [[
            SELECT BIN_TO_UUID(`id`) `id`, `player`, `admin`, `reason`, `points`, `server_id`, `timestamp` FROM `%swarns` WHERE `id` = UUID_TO_BIN(%s);
        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(id))
    else 
        YAWS.Database.Query(function(err, q, data)
            if(err) then 
                d:reject(err)
                return
            end 
            if(#data <= 0) then
                d:resolve(nil)
                return
            end 
    
            local warning = data[1]
            d:resolve(warning)
        end, [[
            SELECT * FROM `%swarns` WHERE `id` = %s;
        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(id))
    end 

    return d
end 

function YAWS.Warns.GetWarnsFromPlayer(steamid) 
    local d = deferred.new()

    if(YAWS.ManualConfig.Database.Enabled) then
        YAWS.Database.Query(function(err, q, data)
            if(err) then 
                d:reject(err)
                return
            end 
            if(#data <= 0) then
                d:resolve({})
                return
            end 
        
            local warnings = {}
            for k,v in ipairs(data) do 
                warnings[#warnings + 1] = v
            end
            d:resolve(warnings)
        end, [[
            SELECT BIN_TO_UUID(`id`) `id`, `player`, `admin`, `reason`, `points`, `server_id`, `timestamp` FROM `%swarns` WHERE `player` = %s;
        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid))
    else 
        YAWS.Database.Query(function(err, q, data)
            if(err) then 
                d:reject(err)
                return
            end 
            if(#data <= 0) then
                d:resolve({})
                return
            end 
            
            local warnings = {}
            for k,v in ipairs(data) do 
                warnings[#warnings + 1] = v
            end
            d:resolve(warnings)
        end, [[
            SELECT * FROM `%swarns` WHERE `player` = %s;
        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid))
    end 

    return d
end 
-- Same as above but with offset/limit
function YAWS.Warns.GetWarnsFromPlayerPagnated(steamid, offset, limit) 
    local d = deferred.new()

    if(YAWS.ManualConfig.Database.Enabled) then
        YAWS.Database.Query(function(err, q, data)
            if(err) then 
                d:reject(err)
                return
            end 
            if(#data <= 0) then
                d:resolve({})
                return
            end 
        
            local warnings = {}
            for k,v in ipairs(data) do 
                warnings[#warnings + 1] = v
            end
            d:resolve(warnings)
        end, [[
            SELECT BIN_TO_UUID(`id`) `id`, `player`, `admin`, `reason`, `points`, `server_id`, `timestamp` FROM `%swarns` WHERE `player` = %s ORDER BY `timestamp` DESC LIMIT %s,%s;
        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid), offset, limit)
    else 
        YAWS.Database.Query(function(err, q, data)
            if(err) then 
                d:reject(err)
                return
            end 
            if(#data <= 0) then
                d:resolve({})
                return
            end 
            
            local warnings = {}
            for k,v in ipairs(data) do 
                warnings[#warnings + 1] = v
            end
            d:resolve(warnings)
        end, [[
            SELECT * FROM `%swarns` WHERE `player` = %s ORDER BY `timestamp` DESC LIMIT %s,%s;
        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid), offset, limit)
    end 

    return d
end 

-- this is an outright mess cus of this async bullshit
function YAWS.Warns.DeleteWarn(id) 
    YAWS.Warns.GetWarn(id)
        :next(function(warn)
            local points = warn.points 
            local ply = warn.player
            -- local currentPoints,currentDeductedPoints = YAWS.Warns.GetPoints(ply)
            YAWS.Warns.GetPoints(ply)
                :next(function(pointsTables)
                    if(YAWS.ManualConfig.Database.Enabled) then 
                        YAWS.Database.Query(nil, [[
                            DELETE FROM `%swarns` WHERE `id` = UUID_TO_BIN(%s);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(id))
                    else 
                        YAWS.Database.Query(nil, [[
                            DELETE FROM `%swarns` WHERE `id` = %s;
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(id))
                    end 

                    -- only way I can get it to be consistent
                    YAWS.Warns.RecalculatePoints(ply)
                end)
        end)
        :catch(function(err)
            YAWS.Core.Trace("Deleting warning", err)
        end)
end 

function YAWS.Warns.RecalculatePoints(steamid)
    YAWS.Warns.GetWarnsFromPlayer(steamid)
        :next(function(data)
            local points = 0
            for k,v in pairs(data) do 
                points = points + v.points
            end 

            YAWS.Warns.GetPoints(steamid)
                :next(function(data)
                    local oldPoints,oldDeductedPoints = data[1], data[2]
                    local newDeductedPoints = oldDeductedPoints
                    if(oldDeductedPoints > points) then 
                        newDeductedPoints = points
                    end 

                    YAWS.Database.Query(nil, [[
                        UPDATE `%splayer_information` SET `points_deducted` = %s WHERE `steamid` = %s;
                    ]], YAWS.ManualConfig.Database.TablePrefix, newDeductedPoints, YAWS.Database.String(steamid))
                end)
        end)
        :catch(function()
            YAWS.Core.Trace("Calculating Points", err)
        end)
end

net.Receive("yaws.warns.deletewarn", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "delete_warns")) then return end 
    YAWS.Core.PayloadDebug("yaws.warns.deletewarn", len)

    local id = net.ReadString()
    YAWS.Warns.GetWarn(id)
        :next(function(data)
            YAWS.Warns.DeleteWarn(id) 
            YAWS.Core.Message(ply, "player_warn_deleted")
            
            local offender = player.GetBySteamID64(data.player)
            if(IsValid(offender)) then 
                YAWS.Core.Message(offender, "player_warn_deleted_user", ply:Name())
            end
            hook.Run("yaws.warns.deleted", ply, data.player, data.admin, data.reason, data.points, id)
        end)
        :catch(function(err)
            YAWS.Core.Trace("Deleting warning", err, ply)
        end)
end)

net.Receive("yaws.warns.warnplayer", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "create_warns")) then return end 
    YAWS.Core.PayloadDebug("yaws.warns.warnplayer", len)
    
    local forcePreset = net.ReadBool()
    local steamid = net.ReadString()
    -- if(steamid == ply:SteamID64()) then
    --     YAWS.Core.Message(ply, "player_warn_notyou") 
    --     return 
    -- end

    local attemptGetPly = player.GetBySteamID64(steamid) 
    if(attemptGetPly) then 
        if(attemptGetPly:IsBot()) then 
            return -- just fail silently as bots should be blocked anyway - addon's got 4 translators at this point can't be bugging them over small shit like this ngl
        end
    end

    local reason 
    local points
    if(!YAWS.Permissions.CheckPermissionPly(ply, "customise_reason") || forcePreset) then 
        local presetKey = net.ReadString()
        if(!YAWS.Config.Presets[presetKey]) then return end
        
        reason = YAWS.Config.Presets[presetKey].reason
        points = YAWS.Config.Presets[presetKey].points
    else 
        reason = net.ReadString()
        if(!reason or string.Trim(reason) == "") then 
            if(YAWS.Config.GetValue("reason_required")) then 
                YAWS.Core.Message(ply, "player_warn_noreason")
                return 
            end 
            
            reason = "N/A" 
        end
        if(#reason > 150) then 
            YAWS.Core.Message(ply, "player_warn_toolong")
            return 
        end

        points = net.ReadUInt(12)
        if(points > YAWS.Config.GetValue("point_max")) then 
            YAWS.Core.Message(ply, "player_warn_maxpoints", YAWS.Config.GetValue("point_max"))
            return 
        end
    end

    YAWS.Players.GetPlayer64(steamid)
        :next(function(offender)
            if(!offender) then return end -- Not in the DB??
            -- Check immunity list
            if(YAWS.ManualConfig.Immunes[steamid] || YAWS.ManualConfig.Immunes[util.SteamIDFrom64(steamid)]) then 
                YAWS.Core.Message(ply, "player_warn_immune")
                return 
            end

            if(YAWS.ManualConfig.Immunes[offender.usergroup]) then 
                YAWS.Core.Message(ply, "player_warn_immune")
                return 
            end

            YAWS.Warns.WarnPlayer(steamid, ply:SteamID64(), reason, points)
            YAWS.Core.Message(ply, "admin_player_warned", offender.name)
            if(offender.entity) then 
                YAWS.Core.Message(offender.entity, "player_warn_notice", ply:Name(), reason)
            end 
    
            if(YAWS.Config.GetValue("broadcast_warns")) then 
                YAWS.Core.Broadcast({offender.entity, ply}, "player_warn_broadcast", offender.name, ply:Name(), reason)
            end
        end)
end)

function YAWS.Warns.GetPoints(steamid)
    local d = deferred.new()

    YAWS.Warns.GetWarnsFromPlayer(steamid)
        :next(function(warns)
            local points = 0
            local deductedPoints = 0
            YAWS.Database.Query(function(err, q, data)
                if(!err) then 
                    if(#data > 0) then 
                        deductedPoints = tonumber(data[1]['points_deducted']) or 0
                        if(deductedPoints > 0) then 
                            points = deductedPoints * -1
                        end
                    end
                end 

                for k,v in pairs(warns) do 
                    points = points + v.points
                end 
                
                d:resolve({math.abs(tonumber(points)), math.abs(tonumber(deductedPoints or 0))})
            end, [[
                SELECT `points_deducted` FROM `%splayer_information` WHERE `steamid` = %s;
            ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid))
        end)
        :catch(function(err)
            if(err == nil) then
                d:resolve({0, 0})
            end 
            
            YAWS.Core.LogError("Error getting points: ", err)
            d:resolve({0, 0})
        end)

    return d 
end

-- point expiring
function YAWS.Warns.DoPointDeductions(ply)
    -- local points,deductedPoints = YAWS.Warns.GetPoints(ply:SteamID64())
    YAWS.Warns.GetPoints(ply:SteamID64())
        :next(function(pointData)
            local points,deductedPoints = pointData[1], pointData[2]
            if(points <= 0) then return end 

            YAWS.Database.Query(function(err, q, data)
                local deductedPoints = tonumber(data[1].points_deducted) or 0

                local newDeducted = math.min(tonumber(YAWS.Config.GetValue("point_cooldown_amount")), (points + deductedPoints)) -- sqlite shit once again :|
                if(deductedPoints) then 
                    newDeducted = math.min(deductedPoints + tonumber(YAWS.Config.GetValue("point_cooldown_amount")), (points + deductedPoints))
                end
                
                YAWS.Database.Query(function(err, q, data) end, [[
                    UPDATE `%splayer_information` SET `points_deducted` = %s WHERE `steamid` = %s;
                ]], YAWS.ManualConfig.Database.TablePrefix, newDeducted, YAWS.Database.String(ply:SteamID64()))
            end, [[
                SELECT `points_deducted` FROM `%splayer_information` WHERE `steamid` = %s;
            ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(ply:SteamID64()))
        end)
end 
hook.Add("yaws.config.loaded", "yaws.warns.expirelystuff", function()
    if(YAWS.Config.GetValue("point_cooldown_time") != 0) then
        timer.Create("yaws.point.expirey", YAWS.Config.GetValue("point_cooldown_time"), 0, function()
            if(YAWS.Config.GetValue("point_cooldown_time") == 0) then return end 

            for k,v in ipairs(player.GetAll()) do 
                YAWS.Warns.DoPointDeductions(v)
            end
        end) 
    end
end)
hook.Add("yaws.config.updated", "yaws.warns.expreiystuff2", function()
    timer.Remove("yaws.point.expirey")
    
    if(YAWS.Config.GetValue("point_cooldown_time") == 0) then return end 
    timer.Create("yaws.point.expirey", YAWS.Config.GetValue("point_cooldown_time"), 0, function()
        if(YAWS.Config.GetValue("point_cooldown_time") == 0) then return end 
        
        for k,v in ipairs(player.GetAll()) do 
            YAWS.Warns.DoPointDeductions(v)
        end 
    end)
end)

-- Wiping warns 
net.Receive("yaws.warns.wipewarns", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "delete_warns")) then return end
    YAWS.Core.PayloadDebug("yaws.warns.wipewarns", len)

    local steamid = net.ReadString()
    YAWS.Players.GetPlayer64(steamid)
        :next(function(player)
            -- PrintTable(player)
            -- Player Exists
            YAWS.Warns.GetWarnsFromPlayer(steamid)
                :next(function(warnings)
                    for k,v in ipairs(warnings) do 
                        YAWS.Warns.DeleteWarn(v.id)
                    end 

                    hook.Run("yaws.warns.wiped", ply, player.steamid)

                    YAWS.Core.Message(ply, "admin_player_wipewarns", player.name)
                end)
                :catch(function()
                    YAWS.Core.Trace("Wiping player warnings", err, ply)
                    return
                end) 
        end)
        :catch(function()
            YAWS.Core.Trace("Wiping player warnings", err, ply)
            return
        end)

    net.Start("yaws.warns.confirmupdate")
    net.WriteBool(true)
    net.Send(ply)
end)