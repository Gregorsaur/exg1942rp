-- Player Storage/Fetching
hook.Add("PlayerInitialSpawn", "yaws.player.playerstore", function(ply)
    YAWS.Database.Query(nil, [[
        REPLACE INTO `%splayers`(`steamid`, `name`, `usergroup`, `server_id`) VALUES(%s, %s, %s, %s);
    ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(ply:SteamID64()), YAWS.Database.String(ply:Name()), YAWS.Database.String(ply:GetUserGroup()), YAWS.Database.String(YAWS.ManualConfig.Database.ServerID))

    YAWS.Database.Query(function(err, q, data)
        if(!data) then return end
        if(#data > 0) then return end

        YAWS.Database.Query(nil, [[
            INSERT INTO `%splayer_information`(`steamid`, `note`, `points_deducted`) VALUES(%s, null, null);
        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(ply:SteamID64()))
    end, [[
        SELECT steamid FROM `%splayer_information` WHERE steamid = %s;
    ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(ply:SteamID64()))    
end)

hook.Add("onPlayerChangedName", "yaws.player.darkrpnameupdate", function(ply, old, new)
    -- Update table
    YAWS.Database.Query(nil, [[
        UPDATE `%splayers` SET `name` = %s WHERE `server_id` = %s AND `steamid` = %s;
    ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(new), YAWS.Database.String(YAWS.ManualConfig.Database.ServerID), YAWS.Database.String(ply:SteamID64()))
end)
hook.Add("playerClassVarsApplied", "yaws.player.darkrpnameffswhyisthisnotininitspawnfuckyoudarkrpjkloveyoubutyourkindadying", function(ply)
    -- Update table
    YAWS.Database.Query(nil, [[
        UPDATE `%splayers` SET `name` = %s WHERE `server_id` = %s AND `steamid` = %s;
    ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(ply:Name()), YAWS.Database.String(YAWS.ManualConfig.Database.ServerID), YAWS.Database.String(ply:SteamID64()))
end)
-- https://github.com/glua/CAMI
hook.Add("CAMI.PlayerUsergroupChanged", "yaws.player.camiupdate", function(ply, from, to)
    -- Update table
    YAWS.Database.Query(nil, [[
        UPDATE `%splayers` SET `usergroup` = %s WHERE `server_id` = %s AND `steamid` = %s;
    ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(to), YAWS.Database.String(YAWS.ManualConfig.Database.ServerID), YAWS.Database.String(ply:SteamID64()))
end)
hook.Add("CAMI.SteamIDUsergroupChanged", "yaws.player.camiupdatesid", function(steamid, from, to)
    -- Update table
    YAWS.Database.Query(nil, [[
        UPDATE `%splayers` SET `usergroup` = %s WHERE `server_id` = %s AND `steamid` = %s;
    ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(to), YAWS.Database.String(YAWS.ManualConfig.Database.ServerID), YAWS.Database.String(steamid))
end)

function YAWS.Players.GetPlayer64(steamid)
    local d = deferred.new()

    if(steamid == YAWS.ConsoleEnt:SteamID64()) then
        d:resolve({
            steamid = steamid,
            name = "Console",
            usergroup = "superadmin",
            isConsole = true
        })
        return d
    end 

    local online = player.GetBySteamID64(steamid)
    if(online) then -- don't ask
        d:resolve({    
            entity = online,
            steamid = steamid,
            name = online:Name(),
            usergroup = online:GetUserGroup()
        })
    else
        YAWS.Database.Query(function(err, q, data)
            if(err) then
                d:reject(err)
                return d
            end
            if(#data <= 0) then 
                d:resolve({
                    invalid = true,
                    steamid = "0000000000000000",
                    name = "Unknown Player",
                    usergroup = "Blank"
                })
                return d
            end 

            d:resolve({
                steamid = data[1].steamid,
                name = data[1].name,
                usergroup = data[1].usergroup
            })
        end, [[
            SELECT * FROM `%splayers` WHERE `server_id` = %s AND `steamid` = %s;
        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(YAWS.ManualConfig.Database.ServerID), YAWS.Database.String(steamid))
    end 

    return d
end 