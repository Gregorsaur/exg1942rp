-- Handles the transfering of data from one warning mod to the other

concommand.Add("yaws_convert", function(ply, cmd, args, argStr)
    if(IsValid(ply)) then return end 
    if(YAWS.ManualConfig.DisableConversionScripts) then 
        YAWS.Core.LogWarning("Conversion scripts have been disabled.")
        return 
    end 

    -- Forcing the type.
    if(#args > 0) then 
        local addon = args[1]
        
        if(addon == "backup") then 
            YAWS.Convert.Backup()
            return
        end 
        if(addon == "continue") then 
            if(!YAWS.Convert.Timeout || !YAWS.Convert.Converter) then 
                YAWS.Core.LogInfo("Your conversion timed out. Try again.")
                return
            end 
            if(YAWS.Convert.Timeout <= CurTime()) then 
                YAWS.Core.LogInfo("Your conversion timed out. Try again.")
                YAWS.Convert.Timeout = nil
                YAWS.Convert.Converter = nil
                return
            end 

            YAWS.Core.LogInfo("Converting data from ", YAWS.Core.LogColors.TextHighlightColor, YAWS.Convert.Converter, color_white, " to Yet Another Warning System. Please wait as this may take a few minutes depending on how much data there is.")
            YAWS.Core.LogWarning("Starting in 10 seconds.")

            timer.Simple(10, function()
                YAWS.Convert.Converters[YAWS.Convert.Converter].convert()
                YAWS.Convert.Converter = nil
            end)
            YAWS.Convert.Timeout = nil

            return 
        end 
        if(addon == "list") then 
            YAWS.Core.LogInfo("The following converters are available. Enter one with ", YAWS.Core.LogColors.TextHighlightColor, "yaws_convert <converter>")
            for k,v in pairs(YAWS.Convert.Converters) do 
                YAWS.Core.LogInfo(" > ", YAWS.Core.LogColors.Gray, "yaws_convert ", color_white, k)
            end

            return 
        end 

        if(!YAWS.Convert.Converters[addon]) then 
            YAWS.Core.LogWarning("The converter ", YAWS.Core.LogColors.TextHighlightColor, addon, color_white, " does not exist.")
            YAWS.Core.LogInfo("The following converters are available. Enter one with ", YAWS.Core.LogColors.TextHighlightColor, "yaws_convert <converter>")
            for k,v in pairs(YAWS.Convert.Converters) do 
                YAWS.Core.LogInfo(" > ", YAWS.Core.LogColors.Gray, "yaws_convert ", color_white, k)
            end

            return 
        end

        YAWS.Core.LogInfo("Selected addon: ",  YAWS.Core.LogColors.TextHighlightColor, addon)
        YAWS.Core.Space()
        YAWS.Core.LogWarning("It's advised you make a backup of YAWS's current data before continuing.")
        YAWS.Core.LogWarning("Running ", YAWS.Core.LogColors.TextHighlightColor, "'yaws_convert backup'", color_white, " will create a backup that can be restored.")
        YAWS.Core.Space()
        YAWS.Core.LogInfo("Enter ", YAWS.Core.LogColors.TextHighlightColor, "'yaws_convert continue'", color_white, " in the next 15 seconds to continue with the conversion.")
        YAWS.Core.LogInfo("ONLY DO THIS IF YOU ARE SURE.")

        YAWS.Convert.Timeout = CurTime() + 15
        YAWS.Convert.Converter = addon
        return
        -- YAWS.Convert.Converters[addon].convert()
    end 

    YAWS.Convert.AutoDetect()
        :next(function(detected)
            if(table.Count(detected) <= 0) then 
                YAWS.Core.LogWarning("Couldn't find any valid data for converters to use. Please ensure YAWS is connected to the same database as the data you wish to convert over.")
                return
            end 
            if(table.Count(detected) > 1) then 
                YAWS.Core.LogInfo("Detected more than one valid converter. Please select the appropriate one with ", YAWS.Core.LogColors.TextHighlightColor, "yaws_convert <converter>")
                for k,v in pairs(YAWS.Convert.Converters) do 
                    YAWS.Core.LogInfo(" > ", YAWS.Core.LogColors.Gray, "yaws_convert ", color_white, k)
                end
                return
            end 

            local key = table.GetKeys(detected)[1]
            
            YAWS.Core.LogInfo("Detected the following converter: ", YAWS.Core.LogColors.TextHighlightColor, key)
            YAWS.Core.Space()
            YAWS.Core.LogWarning("It's advised you make a backup of YAWS's current data before continuing.")
            YAWS.Core.LogWarning("Running ", YAWS.Core.LogColors.TextHighlightColor, "'yaws_convert backup'", color_white, " will create a backup that can be restored.")
            YAWS.Core.Space()
            YAWS.Core.LogInfo("Enter ", YAWS.Core.LogColors.TextHighlightColor, "'yaws_convert continue'", color_white, " in the next 15 seconds to continue with the conversion.")
            YAWS.Core.LogInfo("ONLY DO THIS IF YOU ARE SURE.")

            YAWS.Convert.Timeout = CurTime() + 15
            YAWS.Convert.Converter = key
        end)
end)

function YAWS.Convert.AutoDetect()
    -- Auto-detect 
    local d = deferred.new()

    local detected = {}
    local count = 0
    for k,v in pairs(YAWS.Convert.Converters) do
        v.detection()
            :next(function(result)
                detected[k] = ((result == true) && true || nil)
                count = count + 1
                if(count == table.Count(YAWS.Convert.Converters)) then 
                    d:resolve(detected)
                    return d
                end
            end)
            :catch(function()
                count = count + 1
                if(count == table.Count(YAWS.Convert.Converters)) then 
                    d:resolve(detected)
                    return d
                end
            end)
    end 

    return d
end 

function YAWS.Convert.Backup()
    YAWS.Core.Space() 
    YAWS.Core.LogInfo(YAWS.Core.Divider(false))
    YAWS.Core.LogInfo(YAWS.Core.CenterDividerText("Creating Database Backup", false))
    YAWS.Core.LogInfo(YAWS.Core.Divider(false))
    YAWS.Convert.Start = os.clock()
    
    if(YAWS.ManualConfig.Database.Enabled) then 
        -- MySQL
        YAWS.Database.Query(function(err, q, data)
            if(err) then 
                YAWS.Core.LogError("Aborting backup due to MySQL error.")
                return
            end

            YAWS.Core.LogInfo(" Found ", YAWS.Core.LogColors.TextHighlightColor, #data, color_white, " tables prefixed with ", YAWS.Core.LogColors.TextHighlightColor, "'", YAWS.ManualConfig.Database.TablePrefix, "'")
            local count = #data
            local done = 0

            local tableNames = {}
            local consistentDate = os.date("!%d%m%y-%H%M%S")
            
            for k,v in ipairs(data) do 
                YAWS.Core.LogInfo("")
                YAWS.Core.LogInfo(" Backing up table '", v.TABLE_NAME, "'")

                tableNames[#tableNames + 1] = "BACKUP_" .. consistentDate .. "_" .. v.TABLE_NAME
                YAWS.Database.Query(function(err, q, data)
                    if(err) then 
                        YAWS.Core.LogError(" Error backing up table '", YAWS.Core.LogColors.TextHighlightColor, v.TABLE_NAME, "'")
                        YAWS.Core.LogError(err)
                    else 
                        YAWS.Core.LogInfo(" ", v.TABLE_NAME, " > BACKUP_", consistentDate, "_", v.TABLE_NAME)
                    end 
                    done = done + 1

                    if(done >= count) then 
                        YAWS.Core.LogInfo(YAWS.Core.Divider())
                        YAWS.Core.LogInfo("Backup complete. Took " .. (os.clock() - YAWS.Convert.Start) .. "s")
                        YAWS.Convert.Start = nil

                        -- Drop query generation to make peoples lives a little easier
                        if(!file.Exists("yaws_backups", "DATA")) then 
                            file.CreateDir("yaws_backups")
                        end
                        local dropStr = "/* AUTO GENERATED BY YET ANOTHER WARNING SYSTEM AT " .. os.date("%d %m %Y at %I:%M%p %z") .. " */\n/* ONLY RUN THIS SQL IF YOU WANT TO DELETE YOUR DATABASE BACKUPS! */\n/* OTHERWISE LEAVE IT THE FUCK ALONE */\n\n"
                        for k,v in ipairs(tableNames) do 
                            dropStr = dropStr .. "DROP TABLE `" .. v .. "`;\n"
                        end 
                        local fileName = "yaws_backups/yaws_backup_" .. consistentDate .. "_drop.txt"
                        file.Write(fileName, dropStr)
                        YAWS.Core.LogInfo("Drop file generated, it can be found at: ", YAWS.Core.LogColors.TextHighlightColor, "/garrysmod/data/", fileName)
                    end
                end, [[
                    CREATE TABLE `%s` AS SELECT * FROM `%s`;
                ]], "BACKUP_" .. consistentDate .. "_" .. v.TABLE_NAME, v.TABLE_NAME)
            end 
        end, [[
            SELECT table_name FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME LIKE '%s%%';
        ]], YAWS.ManualConfig.Database.TablePrefix)
    else 
        -- SQLite 
        YAWS.Database.Query(function(err, q, data)
            if(err) then 
                YAWS.Core.LogError("Aborting backup due to MySQL error.")
                return
            end 
             
            YAWS.Core.LogInfo(" Found ", YAWS.Core.LogColors.TextHighlightColor, #data, color_white, " tables prefixed with ", YAWS.Core.LogColors.TextHighlightColor, "'", YAWS.ManualConfig.Database.TablePrefix, "'")
            local count = #data
            local done = 0
    
            local tableNames = {}
            local consistentDate = os.date("!%d%m%y-%H%M%S")

            for k,v in ipairs(data) do 
                YAWS.Core.LogInfo(YAWS.Core.Divider()) 
                YAWS.Core.LogInfo(" Backing up table '", v.TABLE_NAME, "'")
    
                tableNames[#tableNames + 1] = "BACKUP_" .. consistentDate .. "_" .. v.TABLE_NAME
                YAWS.Database.Query(function(err, q, data)
                    if(err) then 
                        YAWS.Core.LogError(" Error backing up table '", YAWS.Core.LogColors.TextHighlightColor, v.TABLE_NAME, "'")
                        YAWS.Core.LogError(err)
                    else 
                        YAWS.Core.LogInfo(" ", v.TABLE_NAME, " > BACKUP_", consistentDate, "_", v.TABLE_NAME)
                    end 
                    done = done + 1
    
                    if(done >= count) then 
                        YAWS.Core.LogInfo(YAWS.Core.Divider()) 
                        YAWS.Core.LogInfo("Backup complete. Took " .. math.Round(os.clock() - YAWS.Convert.Start, 4) .. "s") 
                        YAWS.Convert.Start = nil
                        
                        -- Drop query generation to make peoples lives a little easier
                        if(!file.Exists("yaws_backups", "DATA")) then 
                            file.CreateDir("yaws_backups")
                        end
                        local dropStr = "/* AUTO GENERATED BY YET ANOTHER WARNING SYSTEM AT " .. os.date("%d %m %Y at %I:%M%p %z") .. " */\n/* ONLY RUN THIS SQL IF YOU WANT TO DELETE YOUR DATABASE BACKUPS! */\n/* OTHERWISE LEAVE IT THE FUCK ALONE */\n\n"
                        for k,v in ipairs(tableNames) do 
                            dropStr = dropStr .. "DROP TABLE `" .. v .. "`;\n"
                        end 
                        local fileName = "yaws_backups/yaws_backup_" .. consistentDate .. "_drop.txt"
                        file.Write(fileName, dropStr)
                        YAWS.Core.LogInfo("Drop file generated, it can be found at: ", YAWS.Core.LogColors.TextHighlightColor, "/garrysmod/data/", fileName)
                    end
                end, [[
                    CREATE TABLE `%s` AS SELECT * FROM `%s`;
                ]], "BACKUP_" .. consistentDate .. "_" .. v.TABLE_NAME, v.TABLE_NAME)
            end 
        end, [[
            SELECT `name` AS `TABLE_NAME` FROM `sqlite_master` WHERE `type`='table' AND `name` LIKE '%s%%';
        ]], YAWS.ManualConfig.Database.TablePrefix) -- legit this query is the only difference
    end 
end







-- Converting time
YAWS.Convert.Converters = {}

-- Awarn 3
YAWS.Convert.Converters['awarn3'] = {
    detection = function()
        local d = deferred.new()

        if(YAWS.ManualConfig.Database.Enabled) then 
            YAWS.Database.Query(function(err, q, data)
                d:resolve(#data > 0)
            end, [[
                SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='awarn3_warningtable';
            ]])
        else
            d:resolve(sql.TableExists("awarn3_warningtable"))
        end 

        return d
    end,
    convert = function()
        YAWS.Core.Space()
        YAWS.Core.LogInfo("Beginning conversion from AWarn 3.")
        YAWS.Convert.Start = os.clock()

        YAWS.Core.LogInfo(YAWS.Core.Divider())
        YAWS.Core.LogInfo("Wiping all tables.")
        YAWS.Database.Query(function(err, q, data)
            if(err) then 
                YAWS.Core.LogError("  Error wiping tables.")
                YAWS.Core.LogError("  ", err)
                YAWS.Core.LogError("  Aborting.")
                return
            end 
            YAWS.Core.LogInfo("  Done.")
            YAWS.Convert.Converters['awarn3'].warningConvert()
        end, [[
            DELETE FROM `%swarns`;
            DELETE FROM `%splayers`;
            DELETE FROM `%splayer_information`;
        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.ManualConfig.Database.TablePrefix, YAWS.ManualConfig.Database.TablePrefix)
    end,
    warningConvert = function()
        YAWS.Core.LogInfo(YAWS.Core.Divider())
        YAWS.Core.LogInfo("Converting warnings.")
        
        YAWS.Database.Query(function(err, q, data)
            if(err) then 
                YAWS.Core.LogError(" Error querying for old warnings.")
                YAWS.Core.LogError(" ", err)
                YAWS.Core.LogError(" Aborting.")
                return
            end
            
            local total = #data
            if(total > 0) then
                local startTime = os.clock()
                
                -- I fuckin hate how different transactions are between SQLite and MySQLoo...
                if(YAWS.ManualConfig.Database.Enabled) then 
                    local transaction = YAWS.Database.BeginTransaction()

                    for k,v in ipairs(data) do 
                        local oldID = v.WarningID
                        local newID = YAWS.Core.GenerateUUID() -- WarningID is discarded as it uses auto increment like a noob
                        local player = v.PlayerID 
                        local admin = v.AdminID
                        local reason = v.WarningReason
                        -- local serverName = v.WarningServer -- Not sure how to handle this guy 
                        local timestamp = v.WarningDate
                        -- local timestamp = os.time()

                        if(string.StartWith(player, "Bot")) then 
                            YAWS.Core.LogWarning("  ", YAWS.Core.LogColors.Gray, "(", k, " / ", total, ")", color_white, " Discarding warning ID ", oldID, " as the warned player is a bot. YAWS does not support warning bots!")
                            continue 
                        end 

                        YAWS.Database.AddQueryToTransaction(transaction, [[
                            INSERT INTO `%swarns`(`id`, `player`, `admin`, `reason`, `points`, `timestamp`, `server_id`) VALUES(UUID_TO_BIN(%s), %s, %s, %s, %s, %s, %s);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(newID), YAWS.Database.String(player), YAWS.Database.String(admin), YAWS.Database.String(reason), 1, timestamp, YAWS.Database.String(YAWS.ManualConfig.Database.ServerID))
                    end

                    transaction.onSuccess = function()
                        YAWS.Core.LogInfo("")
                        YAWS.Core.LogInfo("Finished. Converted ", total, " warnings in ", math.Round(os.clock() - startTime, 4), " seconds.")
                    end
                    transaction.onError = function(tr, err)
                        YAWS.Core.LogError("  Error converting warnings.")
                        YAWS.Core.LogError("  ", err)
                    end
                    YAWS.Database.CommitTransaction(transaction)
                else 
                    YAWS.Database.BeginTransaction()
                    for k,v in ipairs(data) do 
                        local oldID = v.WarningID
                        local newID = YAWS.Core.GenerateUUID() -- WarningID is discarded as it uses auto increment like a noob
                        local player = v.PlayerID 
                        local admin = v.AdminID
                        local reason = v.WarningReason
                        -- local serverName = v.WarningServer -- Not sure how to handle this guy 
                        local timestamp = v.WarningDate
                        -- local timestamp = os.time()

                        if(string.StartWith(player, "Bot")) then 
                            YAWS.Core.LogWarning("  ", YAWS.Core.LogColors.Gray, "(", k, " / ", total, ")", color_white, " Discarding warning ID ", oldID, " as the warned player is a bot. YAWS does not support warning bots!")
                            continue 
                        end 

                        YAWS.Database.Query(function(err, q, data)
                            if(err) then 
                                YAWS.Core.LogError("  ", YAWS.Core.LogColors.Gray, "(", k, " / ", total, ")", color_white, " An error occured while transfering Warning ID ", oldID, ": ", YAWS.Core.LogColors.TextHighlightColor, err, color_white, ".")
                                YAWS.Core.LogError("  Skipping.")
                                return
                            end 
                        end, [[
                            INSERT INTO `%swarns`(`id`, `player`, `admin`, `reason`, `points`, `timestamp`, `server_id`) VALUES(%s, %s, %s, %s, %s, %s, %s);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(newID), YAWS.Database.String(player), YAWS.Database.String(admin), YAWS.Database.String(reason), 1, timestamp, YAWS.Database.String(YAWS.ManualConfig.Database.ServerID))
                    end
                    YAWS.Database.CommitTransaction()
                    
                    YAWS.Core.LogInfo("")
                    YAWS.Core.LogInfo("Finished. Converted ", total, " warnings in ", math.Round(os.clock() - startTime, 4), " seconds.")
                end 
            else 
                YAWS.Core.LogInfo("  Skipping step, no warnings were found.")
            end 
            
            YAWS.Convert.Converters['awarn3'].playerConvert()
        end, [[
            SELECT * FROM `awarn3_warningtable`;
        ]])
    end ,
    playerConvert = function()
        YAWS.Core.LogInfo(YAWS.Core.Divider())
        YAWS.Core.LogInfo("Converting player data.")
        
        YAWS.Database.Query(function(err, q, data)
            if(err) then return end 
    
            local total = #data
            if(total > 0) then
                local startTime = os.clock()
                
                if(YAWS.ManualConfig.Database.Enabled) then 
                    local transaction = YAWS.Database.BeginTransaction()

                    for k,v in ipairs(data) do 
                        local steamid = v.PlayerID
                        local name = v.PlayerName

                        if(string.StartWith(steamid, "Bot")) then 
                            YAWS.Core.LogWarning("  ", YAWS.Core.LogColors.Gray, "(", k, " / ", total, ")", color_white, " Discarding current player ", steamid, " as the player is a bot. YAWS does not support warning bots!")
                            continue 
                        end 
                        if(steamid == "[CONSOLE]") then 
                            YAWS.Core.LogWarning("  ", YAWS.Core.LogColors.Gray, "(", k, " / ", total, ")", color_white, " Discarding current player as player is the console. Seriously awarn devs, why did this need to be stored lol.")
                            continue 
                        end 

                        YAWS.Database.AddQueryToTransaction(transaction, [[
                            INSERT INTO `%splayers`(`steamid`, `name`, `usergroup`, `server_id`) VALUES(%s, %s, 'Unknown', %s);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid), YAWS.Database.String(name), YAWS.Database.String(YAWS.ManualConfig.Database.ServerID))
                        YAWS.Database.AddQueryToTransaction(transaction, [[
                            INSERT INTO `%splayer_information`(`steamid`, `note`, `points_deducted`) VALUES(%s, null, null);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid))
                    end

                    transaction.onSuccess = function()
                        YAWS.Core.LogInfo("")
                        YAWS.Core.LogInfo("Finished. Converted ", total, " players in ", math.Round(os.clock() - startTime, 4), " seconds.")
                    end
                    transaction.onError = function(tr, err)
                        YAWS.Core.LogError("  Error converting warnings.")
                        YAWS.Core.LogError("  ", err)
                    end
                    YAWS.Database.CommitTransaction(transaction)
                else 
                    YAWS.Database.BeginTransaction()
                    for k,v in ipairs(data) do 
                        local steamid = v.PlayerID
                        local name = v.PlayerName

                        if(string.StartWith(steamid, "Bot")) then 
                            YAWS.Core.LogWarning("  ", YAWS.Core.LogColors.Gray, "(", k, " / ", total, ")", color_white, " Discarding current player ", steamid, " as the player is a bot. YAWS does not support warning bots!")
                            continue 
                        end 
                        if(steamid == "[CONSOLE]") then 
                            YAWS.Core.LogWarning("  ", YAWS.Core.LogColors.Gray, "(", k, " / ", total, ")", color_white, " Discarding current player as player is the console. Seriously awarn devs, why did this need to be stored lol.")
                            continue 
                        end 

                        YAWS.Database.Query(function(err, q, data)
                            if(err) then 
                                YAWS.Core.LogError("  ", YAWS.Core.LogColors.Gray, "(", k, " / ", total, ")", color_white, " An error occured while transfering Player SteamID ", steamid, ": ", YAWS.Core.LogColors.TextHighlightColor, err, color_white, ".")
                                YAWS.Core.LogError("  Skipping.")
                                return
                            end 
                        end, [[
                            INSERT INTO `%splayers`(`steamid`, `name`, `usergroup`, `server_id`) VALUES(%s, %s, 'Unknown', %s);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid), YAWS.Database.String(name), YAWS.Database.String(YAWS.ManualConfig.Database.ServerID))
                        YAWS.Database.Query(function(err, q, data)
                            if(err) then 
                                YAWS.Core.LogError("  ", YAWS.Core.LogColors.Gray, "(", k, " / ", total, ")", color_white, " An error occured while transfering Player SteamID ", steamid, ": ", YAWS.Core.LogColors.TextHighlightColor, err, color_white, ".")
                                YAWS.Core.LogError("  Skipping.")
                                return
                            end 
                        end, [[
                            INSERT INTO `%splayer_information`(`steamid`, `note`, `points_deducted`) VALUES(%s, null, null);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid))
                    end
                    YAWS.Database.CommitTransaction()
                    
                    YAWS.Core.LogInfo("")
                    YAWS.Core.LogInfo("Finished. Converted ", total, " players in ", math.Round(os.clock() - startTime, 4), " seconds.")
                end 
            else 
                YAWS.Core.LogInfo("  Skipping step, no players were found.")
            end 
    
            YAWS.Convert.Converters['awarn3'].cleanup()
        end, [[
            SELECT * FROM `awarn3_playertable`;
        ]])
    end,
    cleanup = function()
        local time = os.clock() - YAWS.Convert.Start
        YAWS.Core.LogInfo(YAWS.Core.Divider())
        YAWS.Core.LogInfo("Finished conversion in ", string.NiceTime(time), " (", time, "s).")
        YAWS.Core.LogInfo("It is ", YAWS.Core.LogColors.ErrorColor, "HIGHLY RECOMMENDED", color_white, " that you restart your server now, to ensure YAWS loads the fresh data.")
        YAWS.Core.LogInfo("Don't make a ticket talking about the addon not working if you don't restart your server ", YAWS.Core.LogColors.WarnColor, "otherwise I will hunt you down and beat you with a bat.")
        YAWS.Convert.Start = nil
    end 
}

-- Bob's Admin Kit thingy
YAWS.Convert.Converters['bobs_admin_kit'] = {
    detection = function()
        local d = deferred.new()

        if(YAWS.ManualConfig.Database.Enabled) then 
            YAWS.Database.Query(function(err, q, data)
                d:resolve(#data > 0)
            end, [[
                SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='admin_tool_kit_warns';
            ]])
        else
            d:resolve(sql.TableExists("admin_tool_kit_warns"))
        end 

        return d
    end,
    convert = function()
        YAWS.Core.Space()
        YAWS.Core.LogInfo("Beginning conversion from Bob's Admin Tool Kit.")
        YAWS.Convert.Start = os.clock()

        YAWS.Core.LogInfo(YAWS.Core.Divider())
        YAWS.Core.LogInfo("Wiping all tables.")
        YAWS.Database.Query(function(err, q, data)
            if(err) then 
                YAWS.Core.LogError("  Error wiping tables.")
                YAWS.Core.LogError("  ", err)
                YAWS.Core.LogError("  Aborting.")
                return
            end 
            YAWS.Core.LogInfo("  Done.")
            YAWS.Convert.Converters['bobs_admin_kit'].warningConvert()
        end, [[
            DELETE FROM `%swarns`;
            DELETE FROM `%splayers`;
            DELETE FROM `%splayer_information`;
        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.ManualConfig.Database.TablePrefix, YAWS.ManualConfig.Database.TablePrefix)
    end,
    warningConvert = function()
        YAWS.Core.LogInfo(YAWS.Core.Divider())
        YAWS.Core.LogInfo("Converting warnings.")

        YAWS.Database.Query(function(err, q, data)
            if(err) then 
                YAWS.Core.LogError(" Error querying for old warnings.")
                YAWS.Core.LogError(" ", err)
                YAWS.Core.LogError(" Aborting.")
                return
            end 
    
            local total = #data
            if(total > 0) then
                if(YAWS.ManualConfig.Database.Enabled) then 
                    local transaction = YAWS.Database.BeginTransaction()

                    for k,v in ipairs(data) do 
                        local oldID = v.id
                        local newID = YAWS.Core.GenerateUUID() -- WarningID is discarded as it uses auto increment like a noob
                        local player = v.user_id 
                        local admin = v.warned_by
                        local reason = v.reason
                        
                        local timestamp = v.created_at
                        -- WARNING: YUCKY ASS CODE BELOW
                        -- This is why I don't use TIMESTAMP is SQL, because it returns a fucking string instead of a....
                        -- TIMESTAMP!!!!!!!! WOWW!!!!!! fuck you
                        local newTimesamp = os.time({
                            day = string.sub(timestamp, 9, 10),
                            month = string.sub(timestamp, 6, 7),
                            year = string.sub(timestamp, 1, 4),
                            hour = string.sub(timestamp, 12, 13),
                            min = string.sub(timestamp, 15, 16),
                            sec = string.sub(timestamp, 18, 19)
                        })
                        
                        YAWS.Database.AddQueryToTransaction(transaction, [[
                            INSERT INTO `%swarns`(`id`, `player`, `admin`, `reason`, `points`, `timestamp`, `server_id`) VALUES(UUID_TO_BIN(%s), %s, %s, %s, %s, %s, %s);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(newID), YAWS.Database.String(player), YAWS.Database.String(admin), YAWS.Database.String(reason), 1, newTimesamp, YAWS.Database.String(YAWS.ManualConfig.Database.ServerID))
                    end

                    transaction.onSuccess = function()
                        YAWS.Core.LogInfo("")
                        YAWS.Core.LogInfo("Finished. Converted ", total, " warnings in ", math.Round(os.clock() - startTime, 4), " seconds.")
                    end
                    transaction.onError = function(tr, err)
                        YAWS.Core.LogError("  Error converting warnings.")
                        YAWS.Core.LogError("  ", err)
                    end
                    YAWS.Database.CommitTransaction(transaction)
                else 
                    YAWS.Database.BeginTransaction()
                    for k,v in ipairs(data) do 
                        local oldID = v.id
                        local newID = YAWS.Core.GenerateUUID() -- WarningID is discarded as it uses auto increment like a noob
                        local player = v.user_id 
                        local admin = v.warned_by
                        local reason = v.reason
                        
                        local timestamp = v.created_at
                        -- WARNING: YUCKY ASS CODE BELOW
                        -- This is why I don't use TIMESTAMP is SQL, because it returns a fucking string instead of a....
                        -- TIMESTAMP!!!!!!!! WOWW!!!!!! fuck you
                        local newTimesamp = os.time({
                            day = string.sub(timestamp, 9, 10),
                            month = string.sub(timestamp, 6, 7),
                            year = string.sub(timestamp, 1, 4),
                            hour = string.sub(timestamp, 12, 13),
                            min = string.sub(timestamp, 15, 16),
                            sec = string.sub(timestamp, 18, 19)
                        })

                        if(string.StartWith(player, "Bot")) then 
                            YAWS.Core.LogWarning("  ", YAWS.Core.LogColors.Gray, "(", k, " / ", total, ")", color_white, " Discarding warning ID ", oldID, " as the warned player is a bot. YAWS does not support warning bots!")
                            continue 
                        end 

                        YAWS.Database.Query(function(err, q, data)
                            if(err) then 
                                YAWS.Core.LogError("  ", YAWS.Core.LogColors.Gray, "(", k, " / ", total, ")", color_white, " An error occured while transfering Warning ID ", oldID, ": ", YAWS.Core.LogColors.TextHighlightColor, err, color_white, ".")
                                YAWS.Core.LogError("  Skipping.")
                                return
                            end 
                        end, [[
                            INSERT INTO `%swarns`(`id`, `player`, `admin`, `reason`, `points`, `timestamp`, `server_id`) VALUES(%s, %s, %s, %s, %s, %s, %s);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(newID), YAWS.Database.String(player), YAWS.Database.String(admin), YAWS.Database.String(reason), 1, newTimesamp, YAWS.Database.String(YAWS.ManualConfig.Database.ServerID))
                    end
                    YAWS.Database.CommitTransaction()
                    
                    YAWS.Core.LogInfo("")
                    YAWS.Core.LogInfo("Finished. Converted ", total, " warnings in ", math.Round(os.clock() - startTime, 4), " seconds.")
                end 
            else 
                YAWS.Core.LogInfo("  Skipping step, no warnings were found.")
            end 
    
            YAWS.Convert.Converters['bobs_admin_kit'].playerConvert()
        end, [[
            SELECT * FROM `admin_tool_kit_warns`;
        ]])
    end ,
    playerConvert = function()
        YAWS.Core.LogInfo(YAWS.Core.Divider())
        YAWS.Core.LogInfo("Converting player data.")
        
        YAWS.Database.Query(function(err, q, data)
            if(err) then return end 
    
            local total = #data
            if(total > 0) then
                local startTime = os.clock()
                if(YAWS.ManualConfig.Database.Enabled) then 
                    local transaction = YAWS.Database.BeginTransaction()

                    for k,v in ipairs(data) do 
                        local steamid = v.steamid64
                        local name = v.name
                        local usergroup = v.usergroup

                        YAWS.Database.AddQueryToTransaction(transaction, [[
                            INSERT INTO `%splayers`(`steamid`, `name`, `usergroup`, `server_id`) VALUES(%s, %s, %s, %s);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid), YAWS.Database.String(name), YAWS.Database.String(usergroup), YAWS.Database.String(YAWS.ManualConfig.Database.ServerID))
                        YAWS.Database.AddQueryToTransaction(transaction, [[
                            INSERT INTO `%splayer_information`(`steamid`, `note`, `points_deducted`) VALUES(%s, null, null);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid))
                    end

                    transaction.onSuccess = function()
                        YAWS.Core.LogInfo("")
                        YAWS.Core.LogInfo("Finished. Converted ", total, " players in ", math.Round(os.clock() - startTime, 4), " seconds.")
                    end
                    transaction.onError = function(tr, err)
                        YAWS.Core.LogError("  Error converting warnings.")
                        YAWS.Core.LogError("  ", err)
                    end
                    YAWS.Database.CommitTransaction(transaction)
                else 
                    YAWS.Database.BeginTransaction()
                    for k,v in ipairs(data) do 
                        local steamid = v.steamid64
                        local name = v.name
                        local usergroup = v.usergroup

                        YAWS.Database.Query(function(err, q, data)
                            if(err) then 
                                YAWS.Core.LogError("  ", YAWS.Core.LogColors.Gray, "(", k, " / ", total, ")", color_white, " An error occured while transfering Player SteamID ", steamid, ": ", YAWS.Core.LogColors.TextHighlightColor, err, color_white, ".")
                                YAWS.Core.LogError("  Skipping.")
                                return
                            end 
                        end, [[
                            INSERT INTO `%splayers`(`steamid`, `name`, `usergroup`, `server_id`) VALUES(%s, %s, %s, %s);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid), YAWS.Database.String(name), YAWS.Database.String(usergroup), YAWS.Database.String(YAWS.ManualConfig.Database.ServerID))
                        YAWS.Database.Query(function(err, q, data)
                            if(err) then 
                                YAWS.Core.LogError("  ", YAWS.Core.LogColors.Gray, "(", k, " / ", total, ")", color_white, " An error occured while transfering Player SteamID ", steamid, ": ", YAWS.Core.LogColors.TextHighlightColor, err, color_white, ".")
                                YAWS.Core.LogError("  Skipping.")
                                return
                            end 
                        end, [[
                            INSERT INTO `%splayer_information`(`steamid`, `note`, `points_deducted`) VALUES(%s, null, null);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid))
                    end
                    YAWS.Database.CommitTransaction()
                    
                    YAWS.Core.LogInfo("")
                    YAWS.Core.LogInfo("Finished. Converted ", total, " players in ", math.Round(os.clock() - startTime, 4), " seconds.")
                end 
            else 
                YAWS.Core.LogInfo("  Skipping step, no players were found.")
            end 
    
            -- can't be bothered accessing your config table to transfer presets so just clean up and move on
            YAWS.Convert.Converters['bobs_admin_kit'].cleanup()
        end, [[
            SELECT * FROM `admin_tool_kit_users`;
        ]])
    end,
    cleanup = function()
        local time = os.clock() - YAWS.Convert.Start
        YAWS.Core.LogInfo(YAWS.Core.Divider())
        YAWS.Core.LogInfo("Finished conversion in ", string.NiceTime(time), " (", time, "s).")
        YAWS.Core.LogInfo("It is ", YAWS.Core.LogColors.ErrorColor, "HIGHLY RECOMMENDED", color_white, " that you restart your server now, to ensure YAWS loads the fresh data.")
        YAWS.Core.LogInfo("Don't make a ticket talking about the addon not working if you don't restart your server ", YAWS.Core.LogColors.WarnColor, "otherwise I will hunt you down and beat you with a bat.")
        YAWS.Convert.Start = nil
    end 
}

-- Warning System (SlownLS)
YAWS.Convert.Converters['slownls_warning_system'] = {
    detection = function()
        local d = deferred.new()

        if(YAWS.ManualConfig.Database.Enabled) then 
            YAWS.Database.Query(function(err, q, data)
                d:resolve(#data > 0)
            end, [[
                SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='ws_warns';
            ]])
        else
            d:resolve(sql.TableExists("ws_warns"))
        end 

        return d
    end,
    convert = function()
        YAWS.Core.Space()
        YAWS.Core.LogInfo("Beginning conversion from Warning System.")
        YAWS.Convert.Start = os.clock()

        YAWS.Core.LogInfo(YAWS.Core.Divider())
        YAWS.Core.LogInfo("Wiping all tables.")
        YAWS.Database.Query(function(err, q, data)
            if(err) then 
                YAWS.Core.LogError("  Error wiping tables.")
                YAWS.Core.LogError("  ", err)
                YAWS.Core.LogError("  Aborting.")
                return
            end 
            YAWS.Core.LogInfo("  Done.")
            YAWS.Convert.Converters['slownls_warning_system'].warningConvert()
        end, [[
            DELETE FROM `%swarns`;
            DELETE FROM `%splayers`;
            DELETE FROM `%splayer_information`;
        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.ManualConfig.Database.TablePrefix, YAWS.ManualConfig.Database.TablePrefix)
    end,
    warningConvert = function()
        YAWS.Core.LogInfo(YAWS.Core.Divider())
        YAWS.Core.LogInfo("Converting warnings.")
        
        YAWS.Database.Query(function(err, q, data)
            if(err) then 
                YAWS.Core.LogError(" Error querying for old warnings.")
                YAWS.Core.LogError(" ", err)
                YAWS.Core.LogError(" Aborting.")
                return
            end 
    
            local total = #data
            if(total > 0) then
                if(YAWS.ManualConfig.Database.Enabled) then 
                    local transaction = YAWS.Database.BeginTransaction()

                    for k,v in ipairs(data) do 
                        local oldID = v.id
                        local newID = YAWS.Core.GenerateUUID() -- WarningID is discarded as it uses auto increment like a noob
                        local player = v.steamid
                        local admin = v.administrator_steamid
                        local reason = v.reason
                        local points = v.penalty
                        local timestamp = v.created_at

                        -- bots apparently just break that addon causing it to go into a permanent loading screen so fuck this check i guess lmao
                        -- if(string.StartWith(player, "Bot")) then 
                        --     YAWS.Core.Print("[" .. k .. " / " .. total .. "] Discarding warning ID " .. oldID .. " as the warned player is a bot. YAWS does not support warning bots!")
                        --     continue 
                        -- end 

                        YAWS.Database.AddQueryToTransaction(transaction, [[
                            INSERT INTO `%swarns`(`id`, `player`, `admin`, `reason`, `points`, `timestamp`, `server_id`) VALUES(UUID_TO_BIN(%s), %s, %s, %s, %s, %s, %s);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(newID), YAWS.Database.String(player), YAWS.Database.String(admin), YAWS.Database.String(reason), points, timestamp, YAWS.Database.String(YAWS.ManualConfig.Database.ServerID))
                    end

                    transaction.onSuccess = function()
                        YAWS.Core.LogInfo("")
                        YAWS.Core.LogInfo("Finished. Converted ", total, " warnings in ", math.Round(os.clock() - startTime, 4), " seconds.")
                    end
                    transaction.onError = function(tr, err)
                        YAWS.Core.LogError("  Error converting warnings.")
                        YAWS.Core.LogError("  ", err)
                    end
                    YAWS.Database.CommitTransaction(transaction)
                else 
                    YAWS.Database.BeginTransaction()
                    for k,v in ipairs(data) do 
                        local oldID = v.id
                        local newID = YAWS.Core.GenerateUUID() -- WarningID is discarded as it uses auto increment like a noob
                        local player = v.steamid
                        local admin = v.administrator_steamid
                        local reason = v.reason
                        local points = v.penalty
                        local timestamp = v.created_at

                        -- bots apparently just break that addon causing it to go into a permanent loading screen so fuck this check i guess lmao
                        -- if(string.StartWith(player, "Bot")) then 
                        --     YAWS.Core.Print("[" .. k .. " / " .. total .. "] Discarding warning ID " .. oldID .. " as the warned player is a bot. YAWS does not support warning bots!")
                        --     continue 
                        -- end 

                        YAWS.Database.Query(function(err, q, data)
                            if(err) then 
                                YAWS.Core.LogError("  ", YAWS.Core.LogColors.Gray, "(", k, " / ", total, ")", color_white, " An error occured while transfering Warning ID ", oldID, ": ", YAWS.Core.LogColors.TextHighlightColor, err, color_white, ".")
                                YAWS.Core.LogError("  Skipping.")
                                return
                            end 
                        end, [[
                            INSERT INTO `%swarns`(`id`, `player`, `admin`, `reason`, `points`, `timestamp`, `server_id`) VALUES(%s, %s, %s, %s, %s, %s, %s);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(newID), YAWS.Database.String(player), YAWS.Database.String(admin), YAWS.Database.String(reason), points, timestamp, YAWS.Database.String(YAWS.ManualConfig.Database.ServerID))
                    end
                    YAWS.Database.CommitTransaction()
                    
                    YAWS.Core.LogInfo("")
                    YAWS.Core.LogInfo("Finished. Converted ", total, " warnings in ", math.Round(os.clock() - startTime, 4), " seconds.")
                end 
            else
                YAWS.Core.LogInfo("  Skipping step, no warnings were found.")
            end
    
            YAWS.Convert.Converters['slownls_warning_system'].playerConvert()
        end, [[
            SELECT * FROM `ws_warns`;
        ]])
    end,
    playerConvert = function()
        YAWS.Core.LogInfo(YAWS.Core.Divider())
        YAWS.Core.LogInfo("Converting player data.")
        
        YAWS.Database.Query(function(err, q, data)
            if(err) then return end 
    
            local total = #data
            if(total > 0) then
                -- wow for a addon that has offline player tracking this really does store fuck all huh
                -- don't rely on Steam's API for everything is the lesson to be learned here kids. Think of the ratelimits!!!! #stopapiabuse 
                if(YAWS.ManualConfig.Database.Enabled) then 
                    local transaction = YAWS.Database.BeginTransaction()

                    for k,v in ipairs(data) do 
                        local steamid = v.steamid
                        local note = v.note

                        YAWS.Database.AddQueryToTransaction(transaction, [[
                            INSERT INTO `%splayers`(`steamid`, `name`, `usergroup`, `server_id`) VALUES(%s, 'Unknown', 'Unknown', %s);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid), YAWS.Database.String(YAWS.ManualConfig.Database.ServerID))
                        YAWS.Database.AddQueryToTransaction(transaction, [[
                            INSERT INTO `%splayer_information`(`steamid`, `note`, `points_deducted`) VALUES(%s, %s, null);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid), YAWS.Database.String(note))
                    end

                    transaction.onSuccess = function()
                        YAWS.Core.LogInfo("")
                        YAWS.Core.LogInfo("Finished. Converted ", total, " players in ", math.Round(os.clock() - startTime, 4), " seconds.")
                    end
                    transaction.onError = function(tr, err)
                        YAWS.Core.LogError("  Error converting warnings.")
                        YAWS.Core.LogError("  ", err)
                    end
                    YAWS.Database.CommitTransaction(transaction)
                else 
                    YAWS.Database.BeginTransaction()
                    for k,v in ipairs(data) do 
                        local steamid = v.steamid
                        local note = v.note

                        YAWS.Database.Query(function(err, q, data)
                            if(err) then 
                                YAWS.Core.LogError("  ", YAWS.Core.LogColors.Gray, "(", k, " / ", total, ")", color_white, " An error occured while transfering Player SteamID ", steamid, ": ", YAWS.Core.LogColors.TextHighlightColor, err, color_white, ".")
                                YAWS.Core.LogError("  Skipping.")
                                return
                            end 
                        end, [[
                            INSERT INTO `%splayers`(`steamid`, `name`, `usergroup`, `server_id`) VALUES(%s, 'Unknown', 'Unknown', %s);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid), YAWS.Database.String(YAWS.ManualConfig.Database.ServerID))
                        YAWS.Database.Query(function(err, q, data)
                            if(err) then 
                                YAWS.Core.LogError("  ", YAWS.Core.LogColors.Gray, "(", k, " / ", total, ")", color_white, " An error occured while transfering Player SteamID ", steamid, ": ", YAWS.Core.LogColors.TextHighlightColor, err, color_white, ".")
                                YAWS.Core.LogError("  Skipping.")
                                return
                            end 
                        end, [[
                            INSERT INTO `%splayer_information`(`steamid`, `note`, `points_deducted`) VALUES(%s, %s, null);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid), YAWS.Database.String(note))
                    end
                    YAWS.Database.CommitTransaction()
                    
                    YAWS.Core.LogInfo("")
                    YAWS.Core.LogInfo("Finished. Converted ", total, " players in ", math.Round(os.clock() - startTime, 4), " seconds.")
                end 
            else 
                YAWS.Core.LogInfo("  Skipping step, no players were found.")
            end 
            
            -- can't be bothered accessing your config table to transfer presets so just clean up and move on
            YAWS.Convert.Converters['slownls_warning_system'].cleanup()
        end, [[
            SELECT * FROM `ws_players`;
        ]])
    end,
    cleanup = function()
        local time = os.clock() - YAWS.Convert.Start
        YAWS.Core.LogInfo(YAWS.Core.Divider())
        YAWS.Core.LogInfo("Finished conversion in ", string.NiceTime(time), " (", time, "s).")
        YAWS.Core.LogInfo("It is ", YAWS.Core.LogColors.ErrorColor, "HIGHLY RECOMMENDED", color_white, " that you restart your server now, to ensure YAWS loads the fresh data.")
        YAWS.Core.LogInfo("Don't make a ticket talking about the addon not working if you don't restart your server ", YAWS.Core.LogColors.WarnColor, "otherwise I will hunt you down and beat you with a bat.")
        YAWS.Convert.Start = nil
        
        YAWS.Core.Space()
        YAWS.Core.LogWarning(YAWS.Core.Divider())
        YAWS.Core.LogWarning(YAWS.Core.CenterDividerText("Important information about \"Warning System\" conversions"))
        YAWS.Core.LogWarning(YAWS.Core.LogColors.WarnColor, YAWS.Core.CenterDividerText("READ ME"))
        YAWS.Core.LogWarning(YAWS.Core.Divider())
        YAWS.Core.LogWarning("  Warning System does not store player data, and instead fetches it from the Steam API.")
        YAWS.Core.LogWarning(YAWS.Core.LogColors.ErrorColor, "  YAWS was able to fetch absolutely zero player data. Nothing is known aside from player notes.")
        YAWS.Core.LogWarning("  Once the player joins, YAWS will be able to update they're information and store it properly")
        YAWS.Core.LogWarning("")
        YAWS.Core.LogWarning("  The lesson to be learned here: Don't rely on Steam's API for everything, as other addons can't")
        YAWS.Core.LogWarning("  convert properly without being rate limited or missing records :(")
    end 
}