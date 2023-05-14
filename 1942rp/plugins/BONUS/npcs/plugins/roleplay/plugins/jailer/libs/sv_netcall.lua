local PLUGIN = PLUGIN

net.Receive("release_player", function()
    local charid = net.ReadFloat()
    local ply = net.ReadEntity()
    local factionupdate
    local info

    for _, client in pairs(player.GetHumans()) do
        if client:getChar():getID() == charid then
            if not info then
                local faction = nut.faction.indices[client:Team()]
                info = nut.faction.indices[faction.name:lower()]

                for k, v in ipairs(nut.faction.indices) do
                    if nut.util.stringMatches(tostring(v.index), client:getChar():getData("prejail_faction", "1")) then
                        factionupdate = v.index
                        break
                    end
                end
            end

            client:getChar():setFaction(factionupdate)
            client:getChar():setModel(client:getChar():getData("jail_old_model"))
            client:getChar():setData("jail_old_model", "nil")
            client:getChar():setData("jail_arrest_reason", "nil")
            client:getChar():setData("jailtime", 0)
            client:getChar():setData("prejail_faction", "nil")
            ply:notify("You have released " .. client:Nick() .. " !")
            client:setRestrictedTying(false)
        end
    end
end)

net.Receive("arrest_player", function()
    local charid = net.ReadFloat()
    local time = net.ReadFloat()
    local reason = net.ReadString()
    local ply = net.ReadEntity()
    local chance = math.random(1, 4)

    for _, client in pairs(player.GetHumans()) do
        local factionupdate
        local info
        local faction = nut.faction.indices[client:Team()]

        if client:getChar():getID() == charid then
            ply:ChatPrint("You have arrested " .. client:Nick() .. " with the ID: " .. tonumber(charid) .. " for " .. time / 60 .. " minutes (" .. time .. " seconds) with the following reason: " .. reason)
            SetDrag(nil, ply)
            SetDrag(client, nil)
            client:setRestrictedTying(false)

            if chance == 1 then
                client:SetPos(Vector(-6160.031250, 13192.101563, -195.760651))
            elseif chance == 2 then
                client:SetPos(Vector(-6165.481445, 12965.024414, -200.719788, 7449.207520))
            elseif chance == 3 then
                client:SetPos(Vector(-6160.031250, 12613.355469, -206.666122))
            else
                client:SetPos(Vector(-6160.031250, 12417.038086, -215.755646))
            end

            client:FreeTies()
            client:setNetVar("restricted", false)
            client:getChar():setData("prejail_faction", tostring(faction.index))
            client:getChar():setData("jail_old_model", client:getChar():getModel())
            client:getChar():setData("jail_arrest_reason", reason)
            --     client:getChar():setFaction(FACTION_INMATES)
            --       client:getChar():setModel("models/player/Group01/male_07.mdl")
            client:getChar():setData("jailtime", CurTime() + time)

            timer.Create(client:SteamID() .. "_jailtimer", time, 1, function()
                if not info then
                    info = nut.faction.indices[faction.name:lower()]

                    for k, v in ipairs(nut.faction.indices) do
                        if nut.util.stringMatches(tostring(v.index), client:getChar():getData("prejail_faction", "1")) then
                            factionupdate = v.index
                            break
                        end
                    end
                end

                client:getChar():setFaction(factionupdate)
                client:getChar():setModel(client:getChar():getData("jail_old_model"))
                client:getChar():setData("jail_old_model", "nil")
                client:getChar():setData("jail_arrest_reason", "nil")
                client:getChar():setData("jailtime", 0)
                client:getChar():setData("prejail_faction", "nil")
            end)
        end
    end
end)