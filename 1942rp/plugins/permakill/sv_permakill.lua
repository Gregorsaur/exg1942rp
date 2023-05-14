local characterMeta = nut.meta.character


function characterMeta:enablePK(char)
    if (char:getData("pkCom")) then
        char:setData("pkCom", false, false, player.GetAll())
    else
        char:setData("pkCom", true, false, player.GetAll())
    end
end

hook.Add("PlayerDeath", "pkCommand", function(victim, inflictor, attacker)
    local char = victim:getChar()
    local worldcheck = IsValid(attacker)

    -- Normal PK
    if (victim:getChar() && victim:getChar():getData("pkCom")) then
        --if !nut.config.get("spawnTime") then
            for k,v in pairs(player.GetAll()) do
                if v:IsAdmin() then
                    if worldcheck then
                        print("[BURST] " .. attacker:GetName() .. " (" .. attacker:SteamID() .. ")" .. " has perma-killed " .. victim:Name() .. " (" .. victim:SteamID() .. ")")
                        v:PlayerMsg(Color(255, 153, 51, 255),"● ", Color(255,255,255), attacker:GetName() .. " (" .. attacker:SteamID() .. ")" .. " has perma-killed " .. victim:Name() .. " (" .. victim:SteamID() .. ")")
                    else
                        print("[BURST] " .. victim:Name() .. " (" .. victim:SteamID() .. ")" .. "has been perma-killed by the World.")
                        v:PlayerMsg(Color(255, 153, 51, 255),"● ", Color(255,255,255), victim:Name() .. " (" .. victim:SteamID() .. ")" .. "has been perma-killed by the World.")
                    end
                end
            end
            
            timer.Simple(nut.config.get("spawnTime", 5), function()
                char:setData("banned", true)
                char:kick()
                victim:notifyP("Your player has been PK'd. Please go to External Gamings Forums to appeal this if you feel it's unjust.")
            end)
        --end
    end
end)