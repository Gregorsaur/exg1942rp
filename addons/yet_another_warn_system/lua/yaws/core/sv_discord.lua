if(YAWS.ManualConfig.Discord.Method == "CHTTP" && YAWS.ManualConfig.Discord.Enabled) then 
    require("CHTTP")
end

-- lua_run hook.Run("yaws.warns.warned", "76561198121018313", "76561198058562944", "test", 5)
hook.Add("yaws.warns.warned", "yaws.discord.webhook", function(player, admin, reason, points, id)
    if(!YAWS.ManualConfig.Discord.Enabled) then return end 

    local color = tonumber(string.format("0x%02x%02x%02x", 
        math.floor(YAWS.ManualConfig.Discord.EmbedColor.r),
        math.floor(YAWS.ManualConfig.Discord.EmbedColor.g),
        math.floor(YAWS.ManualConfig.Discord.EmbedColor.b)))

    -- ew ew ew ew ew ew e wew ew w w ew
    -- async has cursed me
    YAWS.Players.GetPlayer64(player)
        :next(function(target)
            YAWS.Players.GetPlayer64(admin)
                :next(function(admin)
                    -- request time
                    if(YAWS.ManualConfig.Discord.Method == "CHTTP") then 
                        CHTTP({
                            url = YAWS.ManualConfig.Discord.WebhookURL,
                            method = "POST",
                            type = "application/json",
                            body = util.TableToJSON({
                                embeds = {
                                    {
                                        type = "rich",
                                        title = (YAWS.ManualConfig.Discord.UseEmojis && "⚠️ " || "") .. YAWS.ManualConfig.Discord.EmbedTitle,
                                        description = YAWS.ManualConfig.Discord.EmbedDescription,
                                        color = color,
                                        timestamp = os.date("!%Y-%m-%dT%H:%M:%S"),
                                        fields = {
                                            {
                                                name = (YAWS.ManualConfig.Discord.UseEmojis && "🧑 " || "") .. "Player",
                                                value = target.name .. " (" .. util.SteamIDFrom64(target.steamid) ..")",
                                                inline = true
                                            },
                                            {
                                                name = (YAWS.ManualConfig.Discord.UseEmojis && "👮 " || "") .. "Admin",
                                                value = admin.name .. " (" .. util.SteamIDFrom64(admin.steamid) ..")",
                                                inline = true
                                            },
                                            {
                                                name = (YAWS.ManualConfig.Discord.UseEmojis && "❌ " || "") .. "Points",
                                                value = tostring(points),
                                                inline = true
                                            },
                                            {
                                                name = (YAWS.ManualConfig.Discord.UseEmojis && "📝 " || "") .. "Reason",
                                                value = reason,
                                                inline = false
                                            },
                                        },
                                        footer = {
                                            text = YAWS.ManualConfig.Database.ServerName
                                        }
                                    }
                                }
                            }),
                            success = function(code, body, headers)
                                if(!YAWS.ManualConfig.Discord.Debug) then return end 

                                YAWS.Core.LogDebug("[Discord] POST request was successful.")
                                YAWS.Core.LogDebug("[Discord] Response Code: ", code)
                                YAWS.Core.LogDebug("[Discord] Response Headers: ", util.TableToJSON(headers))
                                YAWS.Core.LogDebug("[Discord] Response Body: ", body)
                            end,
                            failed = function(reason)
                                YAWS.Core.LogError("Discord webhook POST request failed!")
                                YAWS.Core.LogError("Reason given from CHTTP: ", reason)
                            end 
                        })
                    end 

                    if(YAWS.ManualConfig.Discord.Method == "RELAY") then 
                        http.Post(YAWS.ManualConfig.Discord.RelayURL, {
                            -- relay itself handles json
                            webhookURL = YAWS.ManualConfig.Discord.WebhookURL,
                            title = (YAWS.ManualConfig.Discord.UseEmojis && "⚠️ " || "") .. YAWS.ManualConfig.Discord.EmbedTitle,
                            description = YAWS.ManualConfig.Discord.EmbedDescription,
                            color = tostring(color),
                            emojiTime = tostring(YAWS.ManualConfig.Discord.UseEmojis),

                            -- I send names and steamids seperately in case anyone opens the
                            -- webhook code and wants to change the format of the message. Idc
                            -- lol. 
                            targetName = target.name,
                            targetSteamID = util.SteamIDFrom64(target.steamid),

                            adminName = admin.name,
                            adminSteamID = util.SteamIDFrom64(admin.steamid),

                            points = tostring(points),
                            reason = reason,
                            server = YAWS.ManualConfig.Database.ServerName
                        }, function(body, size, headers, code)
                            if(!YAWS.ManualConfig.Discord.Debug) then return end 

                            YAWS.Core.LogDebug("[Discord] POST request was successful.")
                            YAWS.Core.LogDebug("[Discord] Response Code: ", code)
                            YAWS.Core.LogDebug("[Discord] Response Headers: ", util.TableToJSON(headers))
                            YAWS.Core.LogDebug("[Discord] Response Body: ", body)
                        end, function(error)
                            YAWS.Core.LogError("Discord webhook POST request failed!")
                            YAWS.Core.LogError("Reason given from http.Post: ", reason)
                        end, {
                            ["Authorization"] = YAWS.ManualConfig.Discord.Password,
                        })
                    end 
                end)
        end)
end)