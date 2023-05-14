---------------------------------------------------------------------------------------------------
-- This file is for creating custom punishment types. If you're unsure what your doing here but want to add a new punishment type,
-- throw down a good o'l ticket and I'll help you out in making it.
-- If you're in here to add an admin mod, if possible make a ticket and gimme the code so I can add support for it for other people
-- as well. Credit will be given, naturally.
--
-- To reiterate, this file is NOT for defining actual punishments. That's done in-game. This file is those punishments, e.g the
-- the code to kick, ban, jail, etc.
--
-- Feel free to localise these to your local language if need be. Unfortunately I can't offer translations to these as they're a
-- customisable part of the addon.
---------------------------------------------------------------------------------------------------

YAWS.Punishments.Types = YAWS.Punishments.Types or {} -- Don't touch me.

-- Ban
YAWS.Punishments.Types['ban'] = {
    name = "Ban", -- The name of the punishment type.
    description = "Ban a player from the server.", -- The description of the punishment. Don't make this too long.
    params = { -- The parameters a admin can use for this.
        ['duration'] = {
            name = "Duration",
            description = "How long the ban should last in days.",
            type = "number",
            default = "1"
        },
        ['reason'] = {
            name = "Reason",
            description = "The reason the target gets banned.",
            type = "string",
            default = "You reached the warning limit."
        },
    },
    -- The function to execute. This is where the punishment happens. Returning
    -- true means the punishment was successful. False means it failed, and will
    -- send a failed message to the admin/console.
    -- If it does end up failing, return two values: false, "The message"
    -- e.g return false, "This player is immune to being banned."
    -- Note: This is ran SERVERSIDE. targetSteamID is a SteamID64!
    action = function(admin, targetSteamID, params)
        if(ulx) then 
            ulx.banid(admin, util.SteamIDFrom64(targetSteamID), (params.duration * 24) * 60, params.reason)
            return true
        end 
        if(sam) then 
            -- sam.player.ban_id(util.SteamIDFrom64(targetSteamID), (params.duration * 24) * 60, params.reason, admin:SteamID())
            -- function(ply, promise, length, reason)
            -- sam.Command.get("banid").OnExecute(util.SteamIDFrom64(targetSteamID), (params.duration * 24) * 60, params.reason)

            -- I WAS TOLD TO DO IT https://upload.livaco.dev/u/1gYParUlZ2.png
            RunConsoleCommand("sam", "banid", targetSteamID, (params.duration * 24) * 60, params.reason)
            return true
        end 
        if(xAdmin) then -- https://github.com/TheXYZNetwork/xAdmin not the bad one >:)
            local args = {
                targetSteamID,
                (params.duration * 24) * 60
            }
            local reason = string.Explode(params.reason, " ")
            for k, v in pairs(reason) do
                table.insert(args, v)
            end

            xAdmin.Commands['ban'].func(admin, args)
            return true
        end 
        
        return false, "Could not find a supported admin system to ban with."
    end 
}

-- Kick
YAWS.Punishments.Types['kick'] = {
    name = "Kick", -- The name of the punishment type.
    description = "Kicks a player from the server if they are online.", -- The description of the punishment. Don't make this too long.
    params = { -- The parameters a admin can use for this.
        ['reason'] = {
            name = "Reason",
            description = "The reason the target gets kicked.",
            type = "string",
            default = "You reached the warning limit."
        },
    },
    -- The function to execute. This is where the punishment happens. Returning
    -- true means the punishment was successful. False means it failed, and will
    -- send a failed message to the admin/console.
    -- If it does end up failing, return two values: false, "The message"
    -- e.g return false, "This player is immune to being banned."
    -- Note: This is ran SERVERSIDE. targetSteamID is a SteamID64!
    action = function(admin, targetSteamID, params)
        -- no admin mod support needed here
        local ply = player.GetBySteamID64(targetSteamID)
        if(!ply) then return false,"Player is not online." end
        
        ply:Kick(params.reason)
        return true
    end 
}

-- Jail
YAWS.Punishments.Types['jail'] = {
    name = "Jail", -- The name of the punishment type.
    description = "Jails a player on the server.", -- The description of the punishment. Don't make this too long.
    params = { -- The parameters a admin can use for this.
        ['duration'] = {
            name = "Duration",
            description = "How long they should be jailed in minutes.",
            type = "number",
            default = "1"
        },
    },
    -- The function to execute. This is where the punishment happens. Returning
    -- true means the punishment was successful. False means it failed, and will
    -- send a failed message to the admin/console.
    -- If it does end up failing, return two values: false, "The message"
    -- e.g return false, "This player is immune to being banned."
    -- Note: This is ran SERVERSIDE. targetSteamID is a SteamID64!
    action = function(admin, targetSteamID, params)
        local ply = player.GetBySteamID64(targetSteamID)
        if(!ply) then return false,"Player is not online." end

        if(ulx) then 
            ulx.jail(admin, {ply}, params['duration'] * 60, false)
            YAWS.Language.SendRawMessage(ply, "Due to your actions you have been jailed.")
            return true
        end 
        if(sam) then 
            -- I WAS TOLD TO DO IT https://upload.livaco.dev/u/1gYParUlZ2.png
            RunConsoleCommand("sam", "jail", targetSteamID, params.duration)
            YAWS.Language.SendRawMessage(ply, "Due to your actions you have been jailed.")
            return true
        end 
        -- and apparently xadmin doesn't support jailing :(

        
        return false, "Could not find a supported admin system to jail with."
    end 
}

-- Usergroup Change
YAWS.Punishments.Types['usergroup'] = {
    name = "Usergroup Change", -- The name of the punishment type.
    description = "Changes the players usergroup.", -- The description of the punishment. Don't make this too long.
    params = { -- The parameters a admin can use for this.
        ['group'] = {
            name = "Usergroup",
            description = "The name of the usergroup. Case sensitive.",
            type = "string",
            default = "user"
        },
    },
    -- The function to execute. This is where the punishment happens. Returning
    -- true means the punishment was successful. False means it failed, and will
    -- send a failed message to the admin/console.
    -- If it does end up failing, return two values: false, "The message"
    -- e.g return false, "This player is immune to being banned."
    -- Note: This is ran SERVERSIDE. targetSteamID is a SteamID64!
    action = function(admin, targetSteamID, params)
        if(!CAMI) then 
            return false, "The Usergroup punishment requires CAMI. Get a competently made admin mod retard."
        end 
        CAMI.SignalSteamIDUserGroupChanged(util.SteamIDFrom64(targetSteamID), "", params['group'], "yaws_usergroup_punishment")
        YAWS.Language.SendRawMessage(player, "Due to your actions your usergroup has been changed to " .. params.group .. ".")

        if(ulx) then 
            if(ULib.VERSION < 2.80) then 
                -- it says not to access this directly but at the same time if I do the proper way it gives me a completely different version. what the fuck.
                return false, "ULIb versions below 2.80 do not support the CAMI functions to use the usergroup punishment. Please update your ULIb to 2.80 or greater."
            end 
        end 

        return true 
    end 
}

hook.Add("Initialize", "yaws.punishmentsconfig.gamemodecheck", function()
    -- DarkRP Money Punishment
    if(DarkRP) then 
        YAWS.Punishments.Types['drp_money'] = {
            name = "DarkRP Money", -- The name of the punishment type.
            description = "Charges the user money.", -- The description of the punishment. Don't make this too long.
            params = { -- The parameters a admin can use for this.
                ['amount'] = {
                    name = "Amount",
                    description = "The amount of money to charge.",
                    type = "number",
                    default = 500
                },
            },
            -- The function to execute. This is where the punishment happens. Returning
            -- true means the punishment was successful. False means it failed, and will
            -- send a failed message to the admin/console.
            -- If it does end up failing, return two values: false, "The message"
            -- e.g return false, "This player is immune to being banned."
            -- Note: This is ran SERVERSIDE. targetSteamID is a SteamID64!
            action = function(admin, targetSteamID, params)
                if(!DarkRP) then 
                    return false,"DarkRP is not installed!"
                end 

                local ply = player.GetBySteamID64(targetSteamID)
                if(!ply) then return false,"Player is not online." end
                ply:addMoney(params.amount * -1)
                YAWS.Language.SendRawMessage(ply, "Due to your actions you have been charged " .. string.Comma(params.amount) .. ".")

                return true 
            end 
        }
    end
end)