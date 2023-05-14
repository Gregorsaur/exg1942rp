-- quick copy and paste for me to wipe database tables - don't mind these
--[[
DROP TABLE yaws_darkrp_config;
DROP TABLE yaws_darkrp_permissions;
DROP TABLE yaws_darkrp_presets;
DROP TABLE yaws_darkrp_punishments;
DROP TABLE yaws_player_information;
DROP TABLE yaws_players;
DROP TABLE yaws_servers;
DROP TABLE yaws_warns;
--]]

if(YAWS.ManualConfig.Database.Enabled) then 
    require("mysqloo")
end 

YAWS.Database.ConnectionSuccessful = false

function YAWS.Database.Initalize() 
    YAWS.Database.ServerSpecificPrefix = YAWS.ManualConfig.Database.TablePrefix .. YAWS.ManualConfig.Database.ServerID .. "_"

    if(YAWS.ManualConfig.Database.Enabled) then 
        YAWS.Database.Connection = mysqloo.connect(YAWS.ManualConfig.Database.Host, YAWS.ManualConfig.Database.Username, YAWS.ManualConfig.Database.Password, YAWS.ManualConfig.Database.Schema, YAWS.ManualConfig.Database.Port)

        YAWS.Database.Connection.onConnected = function(db) 
            YAWS.Core.LogInfo("MySQL connection successful.")
            YAWS.Core.LogInfo("Beginning check transaction.")
            
            local transaction = YAWS.Database.BeginTransaction()
            
            -- Servers Table
            YAWS.Database.AddQueryToTransaction(transaction, [[
                CREATE TABLE IF NOT EXISTS `%sservers`(
                    `id` VARCHAR(100) NOT NULL PRIMARY KEY,
                    `name` VARCHAR(100) NOT NULL
                );

                REPLACE INTO `%sservers`(`id`, `name`) VALUES(%s, %s);
            ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(YAWS.ManualConfig.Database.ServerID), YAWS.Database.String(YAWS.ManualConfig.Database.ServerName))

            -- Quickly fill in our cache of "nice names" while we're here
            YAWS.Database.Query(function(err, q, data)
                if(err) then return end 
                if(#data <= 0) then return end 

                for k,v in pairs(data) do 
                    YAWS.NiceServerNames[v.id] = v.name
                end 
            end, [[
                SELECT * FROM `%sservers`;
            ]], YAWS.ManualConfig.Database.TablePrefix)

            -- Server-Specific tables.

            -- Permissions Table
            -- booooo json in a database, suck my fucking ass
            YAWS.Database.AddQueryToTransaction(transaction, [[
                CREATE TABLE IF NOT EXISTS `%spermissions`(
                    `usergroup` VARCHAR(50) NOT NULL PRIMARY KEY,
                    `permissions` LONGTEXT NOT NULL
                );
            ]], YAWS.Database.ServerSpecificPrefix)

            -- Config Table or "admin settings"
            YAWS.Database.AddQueryToTransaction(transaction, [[
                CREATE TABLE IF NOT EXISTS `%sconfig`(
                    `key` VARCHAR(50) NOT NULL PRIMARY KEY,
                    `value` VARCHAR(255) NOT NULL
                );
            ]], YAWS.Database.ServerSpecificPrefix)
            
            -- Reason Presets Table 
            YAWS.Database.AddQueryToTransaction(transaction, [[
                CREATE TABLE IF NOT EXISTS `%spresets`(
                    `name` VARCHAR(25) PRIMARY KEY,
                    `reason` VARCHAR(500),
                    `points` INT NOT NULL
                );
            ]], YAWS.Database.ServerSpecificPrefix)
            
            -- Punishments Table 
            YAWS.Database.AddQueryToTransaction(transaction, [[
                CREATE TABLE IF NOT EXISTS `%spunishments`(
                    `threshold` INT PRIMARY KEY,
                    `type` VARCHAR(50) NOT NULL,
                    `parameters` LONGTEXT NOT NULL
                );
            ]], YAWS.Database.ServerSpecificPrefix)


            -- Tables shared between servers

            -- Players table - used for getting basic data about a offline player
            YAWS.Database.AddQueryToTransaction(transaction, [[
                CREATE TABLE IF NOT EXISTS `%splayers`(
                    `steamid` VARCHAR(17) NOT NULL,
                    `name` VARCHAR(255) NOT NULL,
                    `usergroup` VARCHAR(50) NOT NULL,
                    `server_id` VARCHAR(100) NOT NULL,

                    PRIMARY KEY(`steamid`, `server_id`)
                );
            ]], YAWS.ManualConfig.Database.TablePrefix)
            -- This is a table for player information that *isn't* based off
            -- servers like above, e.g admin notes and point deductions that
            -- need to be seen between servers
            YAWS.Database.AddQueryToTransaction(transaction, [[
                CREATE TABLE IF NOT EXISTS `%splayer_information`(
                    `steamid` VARCHAR(17) PRIMARY KEY,
                    `note` TEXT,
                    `points_deducted` INT
                );
            ]], YAWS.ManualConfig.Database.TablePrefix)
            
            -- Warns Table 
            -- Quick note here: I use UUIDs as primary keys instead of
            -- numberical primary keys. Numberical keys are shitty + are
            -- terrible to work with if for example if a server needs to swap db
            -- tables your fucked. take a look at this for further understanding
            -- of my reasoning for prefering uuids
            -- https://www.mysqltutorial.org/mysql-uuid/
            YAWS.Database.AddQueryToTransaction(transaction, [[
                CREATE TABLE IF NOT EXISTS `%swarns`(
                    `id` BINARY(16) PRIMARY KEY,
                    `player` VARCHAR(17) NOT NULL,
                    `admin` VARCHAR(17) NOT NULL,
                    `reason` VARCHAR(150),
                    `points` INT NOT NULL,
                    `timestamp` INT NOT NULL,
                    `server_id` VARCHAR(100) NOT NULL
                );
            ]], YAWS.ManualConfig.Database.TablePrefix)
            
            transaction.onSuccess = function()
                YAWS.Core.LogInfo("Database checks complete.")

                YAWS.Database.ConnectionSuccessful = true
                hook.Run("yaws.database.loaded")
            end
            transaction.onError = function(tr, err)
                YAWS.Core.LogError("FATAL: Error while running database query transaction.")
                YAWS.Core.LogError("Error: ", err)
                YAWS.Core.LogError("")
                YAWS.Core.LogError("Do NOT run the addon in this state, otherwise you can expect a lot of stuff to be, if i may speak frankly,")
                YAWS.Core.LogError("fucking shitted up beyond any form of comprehension.")
                hook.Run("yaws.database.loaded")
            end

            YAWS.Database.CommitTransaction(transaction)
        end
        YAWS.Database.Connection.onConnectionFailed = function(db, err) 
            YAWS.Core.LogError("FATAL: Unable to connect to database.")
            YAWS.Core.LogError("Error: ", err)
            YAWS.Core.LogError("")
            YAWS.Core.LogError("Do NOT run the addon in this state, otherwise you can expect a lot of stuff to be, if i may speak frankly,")
            YAWS.Core.LogError("fucking shitted up beyond any form of comprehension.")
        end 
        
        YAWS.Core.LogInfo("Connecting to database.")
        YAWS.Database.Connection:connect()
        
        return
    end
    
    local function tableCreationCallback(err, q, data) 
        if(!err) then return end 
        YAWS.Core.LogError("FATAL: Error while running database query transaction.")
        YAWS.Core.LogError("Error: ", data)
        YAWS.Core.LogError("")
        YAWS.Core.LogError("Do NOT run the addon in this state, otherwise you can expect a lot of stuff to be, if i may speak frankly,")
        YAWS.Core.LogError("fucking shitted up beyond any form of comprehension.")
    end 

    YAWS.Core.LogInfo("Loading with SQLite...")
    YAWS.Core.LogInfo("Beginning check transaction.")
    
    YAWS.Database.BeginTransaction()

    -- Servers Table
    YAWS.Database.Query(tableCreationCallback, [[
        CREATE TABLE IF NOT EXISTS `%sservers`(
            `id` VARCHAR(100) NOT NULL PRIMARY KEY,
            `name` VARCHAR(100) NOT NULL
        );
    
        REPLACE INTO `%sservers`(`id`, `name`) VALUES(%s, %s);
    ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(YAWS.ManualConfig.Database.ServerID), YAWS.Database.String(YAWS.ManualConfig.Database.ServerName))

    -- Quickly fill in our cache of "nice names" while we're here
    YAWS.Database.Query(function(err, q, data)
        if(err) then return end 
        if(#data <= 0) then return end 

        for k,v in pairs(data) do 
            YAWS.NiceServerNames[v.id] = v.name
        end 
    end, [[
        SELECT * FROM `%sservers`;
    ]], YAWS.ManualConfig.Database.TablePrefix)


    -- Server-Specific Tables

    -- Permissions Table
    -- booooo json in a database, suck my fucking ass
    YAWS.Database.Query(tableCreationCallback, [[
        CREATE TABLE IF NOT EXISTS `%spermissions`(
            `usergroup` VARCHAR(50) NOT NULL PRIMARY KEY,
            `permissions` LONGTEXT NOT NULL
        );
    ]], YAWS.Database.ServerSpecificPrefix)

    -- Config Table or "admin settings"
    YAWS.Database.Query(tableCreationCallback, [[
        CREATE TABLE IF NOT EXISTS `%sconfig`(
            `key` VARCHAR(50) NOT NULL PRIMARY KEY,
            `value` VARCHAR(255) NOT NULL
        );
    ]], YAWS.Database.ServerSpecificPrefix)

    -- Reason Presets Table 
    YAWS.Database.Query(tableCreationCallback, [[
        CREATE TABLE IF NOT EXISTS `%spresets`(
            `name` VARCHAR(25) PRIMARY KEY,
            `reason` VARCHAR(500),
            `points` INT NOT NULL
        );
    ]], YAWS.Database.ServerSpecificPrefix)

    -- Punishments Table 
    YAWS.Database.Query(tableCreationCallback, [[
        CREATE TABLE IF NOT EXISTS `%spunishments`(
            `threshold` INT PRIMARY KEY,
            `type` VARCHAR(50) NOT NULL,
            `parameters` LONGTEXT NOT NULL
        );
    ]], YAWS.Database.ServerSpecificPrefix)


    -- Tables shared between servers

    -- Players table - used for getting basic data about a offline player
    YAWS.Database.Query(tableCreationCallback, [[
        CREATE TABLE IF NOT EXISTS `%splayers`(
            `steamid` VARCHAR(17) NOT NULL,
            `name` VARCHAR(255) NOT NULL,
            `usergroup` VARCHAR(50) NOT NULL,
            `server_id` VARCHAR(100) NOT NULL,

            PRIMARY KEY(`steamid`, `server_id`)
        );
    ]], YAWS.ManualConfig.Database.TablePrefix)
    -- This is a table for player information that *isn't* based off
    -- servers like above, e.g admin notes and point deductions that
    -- need to be seen between servers
    YAWS.Database.Query(tableCreationCallback, [[
        CREATE TABLE IF NOT EXISTS `%splayer_information`(
            `steamid` VARCHAR(17) PRIMARY KEY,
            `note` TEXT,
            `points_deducted` INT
        );
    ]], YAWS.ManualConfig.Database.TablePrefix)

    -- Warns Table 
    -- Quick note here: I use UUIDs as primary keys instead of
    -- numberical primary keys. Numberical keys are shitty + are
    -- terrible to work with if for example if a server needs to swap db
    -- tables your fucked. take a look at this for further understanding
    -- of my reasoning for prefering uuids
    -- https://www.mysqltutorial.org/mysql-uuid/
    -- Because of SQLite not being able to convert UUIDs to binary, I have to
    -- use VarChar here unfortunately and miss out on a lil performance :(
    YAWS.Database.Query(tableCreationCallback, [[
        CREATE TABLE IF NOT EXISTS `%swarns`(
            `id` VARCHAR(36) PRIMARY KEY,
            `player` VARCHAR(17) NOT NULL,
            `admin` VARCHAR(17) NOT NULL,
            `reason` VARCHAR(150),
            `points` INT NOT NULL,
            `timestamp` INT NOT NULL,
            `server_id` VARCHAR(100) NOT NULL
        );
    ]], YAWS.ManualConfig.Database.TablePrefix)

    YAWS.Database.CommitTransaction()

    YAWS.Database.ConnectionSuccessful = true
    YAWS.Core.LogInfo("Database checks complete. Check above for errors!")
    hook.Run("yaws.database.loaded")
end 
hook.Add("yaws.core.initalize", "yaws.database.initalize", YAWS.Database.Initalize)

-- Queries.
-- callback(isError, query, data)
function YAWS.Database.Query(callback, q, ...)
    q = string.Trim(string.format(q, unpack({...})))
    -- print(q)

    if(YAWS.ManualConfig.Database.Enabled) then 
        local query = YAWS.Database.Connection:query(q)
        query.onSuccess = function(qu, data)
            if(!callback) then return end 
            callback(false, qu, data)
        end 
        query.onError = function(qu, err)
            YAWS.Core.LogWarning("Attempt at MySQL query failed.")
            YAWS.Core.LogWarning("Error: ", err)
            YAWS.Core.LogWarning("Attempted Query: ", q)
            YAWS.Core.LogWarning("")
            YAWS.Core.LogWarning("The addon might be able to recover from this in certain circumstances, but this also has the potential to")
            YAWS.Core.LogWarning("break something. Check down in your console to see if anything has been fucked up.")
            YAWS.Core.LogWarning("")
            YAWS.Core.LogWarning("Calling callback...")
            
            if(callback == nil) then return end 
            callback(true, q, err)
        end
        
        query:start() 
        
        return
    end 
    
    -- SQLite 
    local query = sql.Query(q)
    if(query == false) then 
        YAWS.Core.LogWarning("Attempt at MySQL query failed.")
        YAWS.Core.LogWarning("Error: ", sql.LastError())
        YAWS.Core.LogWarning("Attempted Query: ", q)
        YAWS.Core.LogWarning("")
        YAWS.Core.LogWarning("The addon might be able to recover from this in certain circumstances, but this also has the potential to")
        YAWS.Core.LogWarning("break something. Check down in your console to see if anything has been fucked up.")
        YAWS.Core.LogWarning("")
        YAWS.Core.LogWarning("Calling callback...")
            
        if(callback == nil) then return end 
        callback(true, q, sql.LastError())
        return
    end
    
    if(callback == nil) then return end 
    callback(false, q, query or {})
    return
end 

-- Escaping strings.
function YAWS.Database.String(str)
    if(YAWS.ManualConfig.Database.Enabled) then 
        return "'" .. YAWS.Database.Connection:escape(str) .. "'"
    end 
    
    return sql.SQLStr(str)
end 

-- Transactions
function YAWS.Database.BeginTransaction()
    if(YAWS.ManualConfig.Database.Enabled) then 
        return YAWS.Database.Connection:createTransaction()
    end 

    sql.Begin()
end
function YAWS.Database.AddQueryToTransaction(transaction, q, ...)
    if(!YAWS.ManualConfig.Database.Enabled) then return end

    q = string.Trim(string.format(q, unpack({...})))
    local query = YAWS.Database.Connection:query(q)
    transaction:addQuery(query)
end
function YAWS.Database.CommitTransaction(transaction)
    if(YAWS.ManualConfig.Database.Enabled) then 
        transaction:start()
    end 

    sql.Commit()
end

timer.Create("yaws.database.refresh", YAWS.ManualConfig.Database.RefreshRate, 0, function()
    hook.Run("yaws.database.refresh")
end)
hook.Add("yaws.database.refresh", "yaws.database.nicenamerefresh", function()
    -- Any servers being added during this one
    YAWS.Database.Query(function(err, q, data)
        if(err) then return end 
        if(#data <= 0) then return end 

        for k,v in ipairs(data) do 
            YAWS.NiceServerNames[v.id] = v.name
        end 
    end, [[
        SELECT * FROM `%sservers`;
    ]], YAWS.ManualConfig.Database.TablePrefix)
end)