---------------------------------------------------------------------------------------------------
-- This file is for the settings that are sensitive, or secure. Don't share anything inside this file, and make sure you type it 
-- correctly, otherwise you could easily mess your addon up.
-- 
-- If you need help, follow the comments. If you still need help, make a ticket
---------------------------------------------------------------------------------------------------


-- These two settings are related to rate limiting. If you are unsure on these, leave the the
-- fucking shit alone. If configured incorrectly, you run the risk of someone crashing your
-- server by spamming net messages.

-- The maximum requests per minute before a cooldown is put on the player.
-- Default: 5
YAWS.ManualConfig.RLRequestsPerSec = 5
-- The cooldown length in seconds
-- Default: 3
YAWS.ManualConfig.RLCooldown = 3


-- This setting disables the yaws_convert command completely. This should be set to true
-- once you've converted your addon's data over, or if you're not needing to convert data 
-- in the first place. 
-- This is a security measure in-case someone finds their way into a RCON exploit or something.
-- Default: false 
YAWS.ManualConfig.DisableConversionScripts = false



-- These settings are all for MySQL usage. If you aren't planning on using MySQL, you can leave
-- these alone and continue on with your day.
--
-- There are numerous requirements for MySQL:
--    > The latest version of MySQLoo, found at https://github.com/FredyH/MySQLOO
--    > A database software that has BIN_TO_UUID and vice-versa functions.
--        - If you're using MariaDB, you will not have it.
--        - If you do not have this, you can follow this guide to fix this requirement:
--          https://www.gmodstore.com/help/addon/713165594686816257/installation-setup-2/topics/mariadb-usage
--
-- Without these requirements, YAWS MySQL will NOT WORK. Most likely you will just error the fuck out of
-- your addon. 
-- If you don't meet these, don't come running to me in a support ticket that the addon doesn't work. It's 
-- in the addon's requirements section on gmodstore for a fucking reason.
--
-- Anyways, here's the settings to get going if you do meet these requirements.


-- This enables MySQL.
-- Default: false
YAWS.ManualConfig.Database.Enabled = false


-- The actual details of the account. The account should have full access to it's schema, and it's reccomended
-- to run a seperate schema just for YAWS. If not, it will still work however.
YAWS.ManualConfig.Database.Username = "root" -- Username
YAWS.ManualConfig.Database.Password = "judy_is_hot" -- Password
YAWS.ManualConfig.Database.Host = "localhost" -- Host
YAWS.ManualConfig.Database.Port = 3306 -- Port
YAWS.ManualConfig.Database.Schema = "yaws" -- Schema (the database to use)


-- The table prefix. If you are running 2 seperate, completely seperate YAWS systems on the same schema
-- then you will need to change this. Keep in mind servers that you want to have warns synced between must
-- have the same prefix.
YAWS.ManualConfig.Database.TablePrefix = "yaws_"


-- This is the server's "ID" - This is the way YAWS will identify this server in warnings.
-- Make sure this isn't:
--    > Above 50 characters long.
--    > Have spaces, or any special characters.
--    > Would work as a MySQL table name, as this can be appended to table names.
-- Default: darkrp
YAWS.ManualConfig.Database.ServerID = "darkrp"

-- The "pretty" version of your server name. For displaying it. Can't be above
-- 100 chars, other than that do what you want with it.
-- Default: DarkRP #1 
YAWS.ManualConfig.Database.ServerName = "DarkRP #1"


-- This is the "Refresh Rate" of your database. This is the time in seconds that the database will
-- go back and check for new data, specifically any new servers it needs to know about. Do NOT set
-- this too low, think of it as a timer that runs every x seconds. Setting it low will cause it to
-- pretty much constantly run. The addon will warn you if this is below 15.
-- Default: 30
YAWS.ManualConfig.Database.RefreshRate = 30



-- And you're done! If MySQL does not work for you still, make a ticket and I'll be happy to help you
-- get it set up.