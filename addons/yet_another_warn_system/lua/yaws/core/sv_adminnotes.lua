util.AddNetworkString("yaws.adminnotes.updatenotes")

function YAWS.Core.GetAdminNote(steamid)
    local d = deferred.new()

    YAWS.Database.Query(function(err, q, data)
        if(err) then 
            d:resolve("")
            return 
        end 
        if(#data <= 0) then 
            d:resolve("")
            return 
        end 

        if(data[1].note == "NULL") then 
            data[1].note = ""
        end 
        d:resolve(data[1].note or "")
    end, [[
        SELECT `note` FROM `%splayer_information` WHERE steamid = %s;
    ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid))

    return d 
    -- return YAWS.AdminNotes.Cache[steamid] or ""
end 
function YAWS.Core.SetAdminNote(steamid, newNote)
    if(#newNote > 3000) then return end 

    YAWS.Database.Query(nil, [[
        REPLACE INTO `%splayer_information`(`steamid`, `note`) VALUES(%s, %s);
    ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid), YAWS.Database.String(newNote))
end 

net.Receive("yaws.adminnotes.updatenotes", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "view_others_warns")) then return end
    YAWS.Core.PayloadDebug("yaws.adminnotes.updatenotes", len)

    local steamid = net.ReadString()
    local newNote = net.ReadString()
    if(#newNote > 3000) then return end 

    YAWS.Players.GetPlayer64(steamid)
        :next(function(data)
            if(data.invalid) then return end 
            YAWS.Core.SetAdminNote(steamid, newNote)
            YAWS.Core.Message(ply, "admin_player_note_update")

            hook.Run("yaws.adminnotes.updatenotes", ply, data.steamid)
        end)
        :catch(function(err)
            YAWS.Core.Trace("Updating player notes", err, ply)
        end)
end)