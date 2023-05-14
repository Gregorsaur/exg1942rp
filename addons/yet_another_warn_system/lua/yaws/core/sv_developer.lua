-- This is the Developer API for YAWS.
-- If you want Docs, you can find them here: https://yaws.livaco.dev/

-------------------------------------------------------------------------------------
-- DO NOT MODIFY THIS FILE - YOU WILL BREAK EVERY 3RD PARTY THING FOR YAWS CREATED --
--                           IT WILL BE YOUR OWN FAULT                             --
-- IF YOU WANT TO CONTRIBUTE MAKE A TICKET WITH YOUR IDEA OR MESSAGE ME ON DISCORD --
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- DO NOT MODIFY THIS FILE - YOU WILL BREAK EVERY 3RD PARTY THING FOR YAWS CREATED --
--                           IT WILL BE YOUR OWN FAULT                             --
-- IF YOU WANT TO CONTRIBUTE MAKE A TICKET WITH YOUR IDEA OR MESSAGE ME ON DISCORD --
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- DO NOT MODIFY THIS FILE - YOU WILL BREAK EVERY 3RD PARTY THING FOR YAWS CREATED --
--                           IT WILL BE YOUR OWN FAULT                             --
-- IF YOU WANT TO CONTRIBUTE MAKE A TICKET WITH YOUR IDEA OR MESSAGE ME ON DISCORD --
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- DO NOT MODIFY THIS FILE - YOU WILL BREAK EVERY 3RD PARTY THING FOR YAWS CREATED --
--                           IT WILL BE YOUR OWN FAULT                             --
-- IF YOU WANT TO CONTRIBUTE MAKE A TICKET WITH YOUR IDEA OR MESSAGE ME ON DISCORD --
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- DO NOT MODIFY THIS FILE - YOU WILL BREAK EVERY 3RD PARTY THING FOR YAWS CREATED --
--                           IT WILL BE YOUR OWN FAULT                             --
-- IF YOU WANT TO CONTRIBUTE MAKE A TICKET WITH YOUR IDEA OR MESSAGE ME ON DISCORD --
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- DO NOT MODIFY THIS FILE - YOU WILL BREAK EVERY 3RD PARTY THING FOR YAWS CREATED --
--                           IT WILL BE YOUR OWN FAULT                             --
-- IF YOU WANT TO CONTRIBUTE MAKE A TICKET WITH YOUR IDEA OR MESSAGE ME ON DISCORD --
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- DO NOT MODIFY THIS FILE - YOU WILL BREAK EVERY 3RD PARTY THING FOR YAWS CREATED --
--                           IT WILL BE YOUR OWN FAULT                             --
-- IF YOU WANT TO CONTRIBUTE MAKE A TICKET WITH YOUR IDEA OR MESSAGE ME ON DISCORD --
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- DO NOT MODIFY THIS FILE - YOU WILL BREAK EVERY 3RD PARTY THING FOR YAWS CREATED --
--                           IT WILL BE YOUR OWN FAULT                             --
-- IF YOU WANT TO CONTRIBUTE MAKE A TICKET WITH YOUR IDEA OR MESSAGE ME ON DISCORD --
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- DO NOT MODIFY THIS FILE - YOU WILL BREAK EVERY 3RD PARTY THING FOR YAWS CREATED --
--                           IT WILL BE YOUR OWN FAULT                             --
-- IF YOU WANT TO CONTRIBUTE MAKE A TICKET WITH YOUR IDEA OR MESSAGE ME ON DISCORD --
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- DO NOT MODIFY THIS FILE - YOU WILL BREAK EVERY 3RD PARTY THING FOR YAWS CREATED --
--                           IT WILL BE YOUR OWN FAULT                             --
-- IF YOU WANT TO CONTRIBUTE MAKE A TICKET WITH YOUR IDEA OR MESSAGE ME ON DISCORD --
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- DO NOT MODIFY THIS FILE - YOU WILL BREAK EVERY 3RD PARTY THING FOR YAWS CREATED --
--                           IT WILL BE YOUR OWN FAULT                             --
-- IF YOU WANT TO CONTRIBUTE MAKE A TICKET WITH YOUR IDEA OR MESSAGE ME ON DISCORD --
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- DO NOT MODIFY THIS FILE - YOU WILL BREAK EVERY 3RD PARTY THING FOR YAWS CREATED --
--                           IT WILL BE YOUR OWN FAULT                             --
-- IF YOU WANT TO CONTRIBUTE MAKE A TICKET WITH YOUR IDEA OR MESSAGE ME ON DISCORD --
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- DO NOT MODIFY THIS FILE - YOU WILL BREAK EVERY 3RD PARTY THING FOR YAWS CREATED --
--                           IT WILL BE YOUR OWN FAULT                             --
-- IF YOU WANT TO CONTRIBUTE MAKE A TICKET WITH YOUR IDEA OR MESSAGE ME ON DISCORD --
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- DO NOT MODIFY THIS FILE - YOU WILL BREAK EVERY 3RD PARTY THING FOR YAWS CREATED --
--                           IT WILL BE YOUR OWN FAULT                             --
-- IF YOU WANT TO CONTRIBUTE MAKE A TICKET WITH YOUR IDEA OR MESSAGE ME ON DISCORD --
-------------------------------------------------------------------------------------




--
-- Warnings
--

--- (Async) Fetches data about a Warning from the database, using the Warning ID.
--
-- @param id (String/Warning ID) The UUID of the warning to search for.
-- @return Warning data if found. nil if no warning was foun
function YAWS.API.FetchWarningByID(id)
    local d = deferred.new()
    
    if(!id) then 
        d:reject("No Warning ID was given.")
        return d
    end 
    
    -- Fetch the warning from the internal API.
    YAWS.Warns.GetWarn(id)
    :next(function(data)
        -- Format it to the API format.
        data.adminSteamID64 = data.admin
        data.adminSteamID = util.SteamIDFrom64(data.admin)
        data.playerSteamID64 = data.player
        data.playerSteamID = util.SteamIDFrom64(data.player)
        
        data.admin = nil 
        data.player = nil
        
        d:resolve(data)
    end)
    :catch(function(err)
        d:reject(err)
    end)
    
    return d
end

--- (Async) Fetches data about all a player's Warnings from the database, by searching for their SteamID
-- 
-- @param steamid (String/SteamID) The SteamID/SteamID64 of the player.
-- @return A numerical table of Warnings if any are found. nil if no warnings were found.
function YAWS.API.FetchWarningByPlayer(steamid)
    local d = deferred.new()
    
    -- Validate if the SteamID is a valid SteamID or not.
    if(!steamid) then 
        d:reject("No SteamID was given.")
        return d
    end 
    if(string.find(steamid, "^STEAM_[0-5]:[0-1]:[0-9]*$")) then 
        -- Change it to SteamID64.
        steamid = util.SteamIDTo64(steamid)
    end 
    
    -- Fetch the warnings from the internal API.
    YAWS.Warns.GetWarnsFromPlayer(steamid)
    :next(function(data)
        if(#data <= 0) then 
            d:resolve(nil)
            return
        end 
        
        -- Format all entries to the API format.
        -- Kinda poopy but needs to be done for simplicity of the dev.
        for k,v in ipairs(data) do
            v.adminSteamID64 = v.admin
            v.adminSteamID = util.SteamIDFrom64(v.admin)
            v.playerSteamID64 = v.player
            v.playerSteamID = util.SteamIDFrom64(v.player)
            
            v.admin = nil 
            v.player = nil
        end 
        
        d:resolve(data)
    end)
    :catch(function(err)
        d:reject(err)
    end)
    
    return d
end

--- (Async) Creates a warning for a player.
-- This function will not send a warning notice to the player being warned, as it doesn't have guarenteed access to player data.
-- WARNING: While this function will check if the player is immune, it will NOT check if the admin exists, nor if that admin has actual 
-- permissions to warn the player. Use it carefully!
-- 
-- @param steamid (String/SteamID) The SteamID/SteamID64 of the player to warn.
-- @param admin (String/SteamID) The SteamID/SteamID64 of the admin that warned the player.
-- @param reason (String) The reason for the warning. Cannot be longer than 150 characters.
-- @param points (Number) The point count of the warning.
-- @param server_id (String) Optional. The ServerID the warning was given from, will automatically use the server executing the code otherwise. 
-- @returns True if warning was created successfully. An error message if not.
function YAWS.API.WarnPlayer(steamid, admin, reason, points, server_id)
    local d = deferred.new()
    
    if(!steamid) then 
        d:reject("No SteamID was given.")
        return d
    end 
    if(string.find(steamid, "^STEAM_[0-5]:[0-1]:[0-9]*$")) then 
        -- Change it to SteamID64.
        steamid = util.SteamIDTo64(steamid)
    end 
    if(!admin) then 
        d:reject("No admin SteamID was given.")
        return d
    end 
    if(string.find(admin, "^STEAM_[0-5]:[0-1]:[0-9]*$")) then 
        -- Change it to SteamID64.
        admin = util.SteamIDTo64(admin)
    end 
    
    local attemptGetPly = player.GetBySteamID64(steamid) 
    if(attemptGetPly) then 
        if(attemptGetPly:IsBot()) then 
            d:reject("Warning bots is not supported by Yet Another Warning System.")
            return d
        end
    end
    
    if(!reason or string.Trim(reason) == "") then 
        if(YAWS.Config.GetValue("reason_required")) then 
            d:reject("You must give a reason for your warning.")
            return d
        end 
        
        reason = "N/A" 
    end
    if(#reason > 150) then 
        d:reject("Your warning reason cannot be longer than 150 characters.")
        return d
    end
    
    if(!points) then 
        d:reject("You must specify a point value.")
        return d
    end 
    if(points < 0) then 
        d:reject("You must specify a point value.")
        return d
    end 
    if(points > YAWS.Config.GetValue("point_max")) then 
        d:reject("You cannot have more than " .. YAWS.Config.GetValue("point_max") .. " points on a warning.")
        return d
    end
    
    YAWS.Players.GetPlayer64(steamid)
        :next(function(offender)
            if(!offender) then 
                d:reject("Couldn't find offender.")
                return 
            end
            
            -- Check immunity list
            if(YAWS.ManualConfig.Immunes[steamid] || YAWS.ManualConfig.Immunes[util.SteamIDFrom64(steamid)]) then 
                d:reject("This player is immune from being warned.")
                return
            end
            if(YAWS.ManualConfig.Immunes[offender.usergroup]) then 
                d:reject("This player is immune from being warned.")
                return
            end
            
            YAWS.Warns.WarnPlayer(steamid, admin, reason, points, server_id)
            -- YAWS.Core.Message(ply, "admin_player_warned", offender.name)
            d:resolve(true)
        end)
        :catch(function(err)
            d:reject(err)
        end)

    return d
end

--- (Async) Checks if a player is immune from being warned.
--
-- @param steamid (String/SteamID) The SteamID/SteamID64 of the player to warn.
-- @returns Boolean indicating if they are immune or not.
function YAWS.API.IsPlayerImmune(steamid)
    local d = deferred.new()
    
    if(!steamid) then 
        d:reject("No SteamID was given.")
        return d
    end 
    if(string.find(steamid, "^STEAM_[0-5]:[0-1]:[0-9]*$")) then 
        -- Change it to SteamID64.
        steamid = util.SteamIDTo64(steamid)
    end 
    
    YAWS.Players.GetPlayer64(steamid)
        :next(function(ply)
            if(!ply) then
                d:reject("Player was not found inside the database.") 
                return
            end
            
            -- Check immunity list
            if(YAWS.ManualConfig.Immunes[steamid] || YAWS.ManualConfig.Immunes[util.SteamIDFrom64(steamid)]) then 
                d:resolve(true)
            end
            if(YAWS.ManualConfig.Immunes[ply.usergroup]) then 
                d:resolve(true)
            end
            
            d:resolve(false)
        end)
    
    return d
end 

--- Deletes a Warning via the Warning ID.
--
-- @param WarningID (String/Warning ID) The UUID of the warning to delete.
function YAWS.API.DeleteWarningByID(id)
    if(!id) then 
        return
    end 
    YAWS.Warns.DeleteWarn(id) -- lol
end 




--
-- Players
--

--- (Async) Fetches data about a Player from the database, using the player's SteamID/SteamID64.
--
-- @param (String/SteamID) The SteamID of the player to get data on.
-- @returns Player data if found. nil if no player was found.
function YAWS.API.GetPlayerInformation(steamid)
    local d = deferred.new()
    
    if(!steamid) then 
        d:reject("No SteamID was given.")
        return d
    end 
    if(string.find(steamid, "^STEAM_[0-5]:[0-1]:[0-9]*$")) then 
        -- Change it to SteamID64.
        steamid = util.SteamIDTo64(steamid)
    end
    
    YAWS.Players.GetPlayer64(steamid)
    :next(function(result)
        -- If the result is invalid, return nil.
        if(result.invalid) then 
            d:resolve(nil)
        else 
            -- Convert the SteamID64 only result to both for ease.
            result.steamid64 = steamid
            result.steamid = util.SteamIDFrom64(result.steamid) 
            
            d:resolve(result)
        end
    end)
    :catch(function(err)
        -- Oopsie Poopsie.
        d:reject(err)
    end)
    
    return d
end

--- Updates the Player data in the database on the specified Player's SteamID. Useful for if your changing player data about. NOTE: YAWS already listens to hooks to update this information automatically! Only use this if YAWS is not updating the information already!
-- 
-- @param steamid (String/SteamID) The SteamID of the player to modify.
-- @param value (String) The data entry to modify. MUST be either 'name' or 'usergroup' - YAWS does NOT allow modificaiton of any other entry.
-- @param newdata (String) The new data to put into the entry.
-- @param server_id (String) Optional. The ServerID to perform this operation on, will automatically use the server executing the code otherwise.
-- @return True/False to indicate if it was successful or not. If false, a second parameter as an error message.
function YAWS.API.UpdatePlayerInformation(steamid, value, newData, server_id)
    if(!steamid) then 
        return false,"No SteamID given."
    end
    if(string.find(steamid, "^STEAM_[0-5]:[0-1]:[0-9]*$")) then 
        -- Change it to SteamID64.
        steamid = util.SteamIDTo64(steamid)
    end 
    
    if(!value) then 
        return false,"No value given."
    end 
    value = string.Trim(string.lower(value))
    if(value != "name" && value != "usergroup") then 
        return false,"Value does not exist, or is not allowed to be changed."
    end
    
    if(!newData) then 
        return false,"No new data given."
    end 
    
    if(!server_id) then 
        server_id = YAWS.ManualConfig.Database.ServerID
    end 
    
    -- For simplicity's sake we don't check if the player exists, as it would require making this async. Just unnessasary logic.
    
    if(value == "name") then 
        YAWS.Database.Query(nil, [[
        UPDATE `%splayers` SET `name` = %s WHERE `server_id` = %s AND `steamid` = %s;
        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(newData), YAWS.Database.String(server_id), YAWS.Database.String(steamid))
        
        return true
    end 
    if(value == "usergroup") then 
        YAWS.Database.Query(nil, [[
        UPDATE `%splayers` SET `usergroup` = %s WHERE `server_id` = %s AND `steamid` = %s;
        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(newData), YAWS.Database.String(server_id), YAWS.Database.String(steamid))
        
        return true
    end 
    
    return false,"Unknown error."
end 



--
-- Hooks
--

-- yaws.developers.warned
-- Called when a warning is created for a player.
-- @param The warning data.
hook.Add("yaws.warns.warned", "yaws.developers.warned.proxy", function(steamid, admin, reason, points, id)
    YAWS.API.FetchWarningByID(id) -- This is done to give the hook output the proper data. Wanna crucify me? Go for it fucknugget.
    :next(function(data)
        hook.Run("yaws.developers.warned", data)
    end)
    :catch(function(err)
        YAWS.Core.Trace("Developer API: yaws.developer.warns.warned hook handling", err)
    end)
end)

-- yaws.developers.warndeleted
-- Called when a warning is deleted. By this point the warning is already removed from the database, so data here is limited.
-- @param id The warning's UUID.
-- @param deletingAdmin The player entity of the person deleting the warning.
-- @param player The warned player's SteamID64.
-- @param admin The admin's SteamID64.
-- @param reason The reason for the warning.
-- @param points The number of points given on the warning.
hook.Add("yaws.warns.deleted", "yaws.developers.deleted.proxy", function(ply, player, admin, reason, points, id)
    hook.Run("yaws.developers.warnremoved", id, ply, player, admin, reason, points)
end)