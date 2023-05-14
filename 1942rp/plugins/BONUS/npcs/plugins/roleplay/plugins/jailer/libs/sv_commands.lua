nut.command.add("releasechar", {
    adminOnly = true,
    syntax = "[character name]",
    onRun = function(client, args)
        local target = nut.command.findPlayer(client, args[1])
        local faction = nut.faction.indices[target:Team()]
        local factionupdate
        local info
        client:notify("You have released " .. target:Nick() .. "!")
        target:notify("Your Sentence ended therefore you are released.")
        timer.Remove(target:SteamID() .. "_jailtimer")

        if not info then
            info = nut.faction.indices[faction.name:lower()]

            for k, v in ipairs(nut.faction.indices) do
                if nut.util.stringMatches(tostring(v.index), target:getChar():getData("prejail_faction", faction.index)) then
                    factionupdate = v.index
                    break
                end
            end
        end

        target:getChar():setFaction(factionupdate)
        target:getChar():setModel(target:getChar():getData("jail_old_model"))
        target:getChar():setData("jail_old_model", "nil")
        target:getChar():setData("jail_arrest_reason", "nil")
        target:getChar():setData("jailtime", 0)
        target:getChar():setData("prejail_faction", "nil")
    end
})

nut.command.add("charcheckjailstat", {
    adminOnly = true,
    syntax = "[character name]",
    onRun = function(client, args)
        local target = nut.command.findPlayer(client, args[1])
        local time = target:getChar():getData("jailtime", 0)
        local reason = target:getChar():getData("jail_arrest_reason")

        if target:getChar():getData("jailtime", 0) > 0 then
            client:ChatPrint(target:Nick() .. " with the ID: " .. target:getChar():getID() .. " is currently jailed for " .. time / 60 .. " minutes (" .. time .. " seconds) with the following reason: " .. reason)
        else
            client:ChatPrint("Target not Jailed!")
        end
    end
})

nut.command.add("resetjailsettings", {
    adminOnly = true,
    syntax = "[character name]",
    onRun = function(client, args)
        local target = nut.command.findPlayer(client, args[1])
        client:notify("You have reseted " .. target:Nick() .. " jail stats!")
        target:getChar():setData("jail_old_model", "nil")
        target:getChar():setData("jail_arrest_reason", "nil")
        target:getChar():setData("jailtime", 0)
        target:getChar():setData("prejail_faction", "nil")
    end
})