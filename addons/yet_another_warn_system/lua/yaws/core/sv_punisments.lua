util.AddNetworkString("yaws.punishments.createpunishment")
util.AddNetworkString("yaws.punishments.removepunishment")
util.AddNetworkString("yaws.punishments.editpunishment")

YAWS.Punishments.PunishmentCache = YAWS.Punishments.PunishmentCache or {}

net.Receive("yaws.punishments.createpunishment", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "view_admin_settings")) then return end 
    YAWS.Core.PayloadDebug("yaws.punishments.createpunishment", len)

    local typeKey = net.ReadString()
    if(!YAWS.Punishments.Types[typeKey]) then return end -- someone is trying to roger roger us
    local threshold = net.ReadUInt(12)
    if(threshold < 1) then return end -- lol

    local params = {}
    for i=0,net.ReadUInt(16) do 
        local key = net.ReadString()
        local typeOfValue = net.ReadString()

        if(typeOfValue == "string") then 
            params[key] = net.ReadString()
        end
        if(typeOfValue == "number") then 
            params[key] = net.ReadUInt(32)
        end
    end 

    YAWS.Punishments.PunishmentCache[threshold] = {
        type = typeKey,
        params = params
    }
    YAWS.Database.Query(nil, [[
        REPLACE INTO `%spunishments`(`threshold`, `type`, `parameters`) VALUES(%s, %s, %s);
    ]], YAWS.Database.ServerSpecificPrefix, threshold, YAWS.Database.String(typeKey), YAWS.Database.String(util.TableToJSON(params)))

    YAWS.Core.Message(ply, "admin_punishment_created")
    net.Start("yaws.config.confirmupdate")
    net.WriteBool(true)
    net.Send(ply)
end)
net.Receive("yaws.punishments.removepunishment", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "view_admin_settings")) then return end 
    YAWS.Core.PayloadDebug("yaws.punishments.removepunishment", len)

    local key = net.ReadUInt(16)
    if(!YAWS.Punishments.PunishmentCache[key]) then return end 

    YAWS.Punishments.PunishmentCache[key] = nil
    YAWS.Database.Query(nil, [[
        DELETE FROM `%spunishments` WHERE `threshold` = %s;
    ]], YAWS.Database.ServerSpecificPrefix, key)

    YAWS.Core.Message(ply, "admin_punishment_removed")
    net.Start("yaws.config.confirmupdate")
    net.WriteBool(true)
    net.Send(ply)
end)

hook.Add("yaws.database.loaded", "yaws.punishments.load", function()
    YAWS.Database.Query(function(err, q, data)
        -- PrintTable(data)
        if(!data) then return end
        if(#data <= 0) then return end 
        
        for k,v in ipairs(data) do
            YAWS.Punishments.PunishmentCache[tonumber(v.threshold)] = {
                type = v.type,
                params = util.JSONToTable(v.parameters)
            }
        end
    end, [[
        SELECT * FROM `%spunishments`;
    ]], YAWS.Database.ServerSpecificPrefix)
end)

hook.Add("yaws.warns.warned", "yaws.punisments.process", function(steamid, admin, reason, points, id)
    YAWS.Warns.GetPoints(steamid)
        :next(function(pointData)
            local oldPoints = pointData[1] - tonumber(points)
            local newPoints = oldPoints + tonumber(points)
            
            -- Find the punishment to run 
            local punishment
            for k,v in pairs(YAWS.Punishments.PunishmentCache) do 
                k = tonumber(k) -- SQLite can fuck this it seems? https://upload.livaco.dev/u/KujtfbYO48.png
                if(oldPoints >= k) then continue end
                if(newPoints < k) then continue end
                -- if(k >= newPoints) then continue end
                if(punishment) then 
                    if(k < punishment.threshold) then continue end 
                end
                
                punishment = v
                punishment.threshold = k
            end
            if(!punishment) then return end
            
            local adminEnt = player.GetBySteamID64(admin)
            if(!adminEnt) then return end -- uhhhhhhh how
            local result,message = YAWS.Punishments.Types[punishment.type].action(adminEnt, steamid, punishment.params)
            if(!result) then 
                YAWS.Core.LogError("Failed to run punishment for SteamID ", steamid)
                YAWS.Core.LogError("Message: ", message)
            end 
            
            if(YAWS.Config.GetValue("purge_on_punishment")) then 
                -- purge time 
                YAWS.Punishments.PurgePoints(steamid)
            end 
            hook.Run("yaws.punishments.executed", steamid, admin, punishment.type)
        end)
        :catch(function(err)
            YAWS.Core.Trace("Running Punishment", err)
        end)
end)

function YAWS.Punishments.PurgePoints(steamid)
    YAWS.Warns.GetPoints(steamid)
        :next(function(pointData)
            local currentPoints,currentDeductedPoints = pointData[1], pointData[2]
            YAWS.Database.Query(nil, [[
                UPDATE `%splayer_information` SET `points_deducted` = %s WHERE `steamid` = %s;
            ]], YAWS.ManualConfig.Database.TablePrefix, currentPoints + currentDeductedPoints, YAWS.Database.String(steamid))
        end)
        :catch(function(err)
            YAWS.Core.Trace("Purging points", err)
        end)
end 

-- Editing Punishments
net.Receive("yaws.punishments.editpunishment", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "view_admin_settings")) then return end 
    YAWS.Core.PayloadDebug("yaws.punishments.editpunishment", len)
    
    local old = net.ReadUInt(12)
    local typeKey = net.ReadString()
    if(!YAWS.Punishments.Types[typeKey]) then return end -- someone is trying to roger roger us
    local threshold = net.ReadUInt(12)
    
    local params = {}
    for i=0,net.ReadUInt(16) do 
        local key = net.ReadString()
        local typeOfValue = net.ReadString()
    
        if(typeOfValue == "string") then 
            params[key] = net.ReadString()
        end
        if(typeOfValue == "number") then 
            params[key] = net.ReadUInt(32)
        end
    end 
    
    YAWS.Punishments.PunishmentCache[threshold] = {
        type = typeKey,
        params = params
    }
    if(old != threshold) then 
        YAWS.Punishments.PunishmentCache[old] = nil
        YAWS.Database.Query(nil, [[
            DELETE FROM `%spunishments` WHERE `threshold` = %s
        ]], YAWS.Database.ServerSpecificPrefix, old)
    end 

    YAWS.Database.Query(nil, [[
        REPLACE INTO `%spunishments`(`threshold`, `type`, `parameters`) VALUES(%s, %s, %s);
    ]], YAWS.Database.ServerSpecificPrefix, threshold, YAWS.Database.String(typeKey), YAWS.Database.String(util.TableToJSON(params)))

    YAWS.Core.Message(ply, "admin_punishment_edited")
    net.Start("yaws.config.confirmupdate")
    net.WriteBool(true)
    net.Send(ply)
end)