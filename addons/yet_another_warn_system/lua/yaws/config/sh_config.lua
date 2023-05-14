---------------------------------------------------------------------------------------------------
-- __     __  _                          _   _                __          __              _                _____           _
-- \ \   / / | |       /\               | | | |               \ \        / /             (_)              / ____|         | |
--  \ \_/ /__| |_     /  \   _ __   ___ | |_| |__   ___ _ __   \ \  /\  / /_ _ _ __ _ __  _ _ __   __ _  | (___  _   _ ___| |_ ___ _ __ ___
--   \   / _ \ __|   / /\ \ | '_ \ / _ \| __| '_ \ / _ \ '__|   \ \/  \/ / _` | '__| '_ \| | '_ \ / _` |  \___ \| | | / __| __/ _ \ '_ ` _ \
--    | |  __/ |_   / ____ \| | | | (_) | |_| | | |  __/ |       \  /\  / (_| | |  | | | | | | | | (_| |  ____) | |_| \__ \ ||  __/ | | | | |
--    |_|\___|\__| /_/    \_\_| |_|\___/ \__|_| |_|\___|_|        \/  \/ \__,_|_|  |_| |_|_|_| |_|\__, | |_____/ \__, |___/\__\___|_| |_| |_|
--                                                                                                 __/ |          __/ |
--                                                                                                |___/          |___/
---------------------------------------------------------------------------------------------------
-- Welcome to the configruation file for Yet Another Warning System!
-- This file is for anything that is somewhat secure, or that the addon requires immedietely without loading the in-game config.
-- The config you will be editing mostly is in-game, and can be accessed from the !warn menu inside the Admin tab.
--
-- Of course, if you require help or guidance, making a support ticket or joining my discord server will allow you to ask
-- any questions you might have, and allow me to answer them. If you end up enjoying the addon, please make a review. It helps
-- me a lot more than you might think. And if you hate it, make a ticket and tell me why, I might be able to help you out!
--
-- Thanks!
---------------------------------------------------------------------------------------------------



-- This is a list of usergroups or SteamID(64)'s that will always have full permissions.
-- Anyone in this list will always have full access to the addon, regardless of their permissions set inside the addon.
-- Accepts SteamID's, SteamID64's and usergroups.
YAWS.ManualConfig.FullPerms['superadmin'] = true
YAWS.ManualConfig.FullPerms['STEAM_0:1:80376292'] = true
YAWS.ManualConfig.FullPerms['76561198121018313'] = true


-- This list is of usergroups or SteamID(64)'s that can never be warned.
-- Anyone in this list can never be given a warning, for any reason or any point count.
-- Accepts SteamID's, SteamID64's and usergroups.
YAWS.ManualConfig.Immunes['superadmin'] = true
YAWS.ManualConfig.Immunes['STEAM_0:1:80376292'] = true
YAWS.ManualConfig.Immunes['76561198121018313'] = true


-- The command to access the UI in-game. Set this to whatever you want to type into chat.
-- Default: !warn
YAWS.ManualConfig.Command = "!warn"


-- The amount of items shown in pages. The reason this is defined here is because it's used serverside to serve data
-- to the client, at a point before the client can send a request to it, for optimization. 
-- (if you're a glua nerd and want futher explanation as to why it's here: https://upload.livaco.dev/u/IjRoPxd0L2.txt)
--
-- Keep this value ideally ~15 for small servers, ~20 for large servers with beefy CPU's, as a larger value means more 
-- data needs to be retieved and sent. Try to keep it above about 12, as keep in mind people could be using the more 
-- compact table view. Or, just keep it at the default if you're not sure.
--
-- Default: 15
YAWS.ManualConfig.PagnationCount = 15



--
-- Now, you can go in-game using the command you set above, and set up the rest of the addon!
-- There are some other config files you can view if you want to enable extra stuff
--    > If you want to change some super important, secure settings or set up MySQL, you can have a peep about sv_config.lua
--      and set that up however you want 
--    > If you know your Lua and want to add your own Punishment categories, e.g a punishment that slaps the player about
--      a bit, you can go into sh_punishments.lua and add it easily!
--    > If you want to enable those fancy Discord Webhooks you saw in the addon media, go into sv_discord.lua to go about that.
--





























--
-- This is all stuff for debugging, and development. If you don't know what these do, keep them on their default values
-- as guided in the comments. If you've not changed them and don't know what these do, don't touch them at all.
-- (Or do, I'm a comment not a cop)
--


-- Print net message payload lengths client-side. Lots of data being thrown
-- about so this is a concern sometimes.
-- Try not to enable this without an actual reason. They can just lag your server if enough net messages are used.
-- Default: false
YAWS.ManualConfig.ClientNetDebug = false

-- Same as above, but on the server-side realm.
-- Default: false
YAWS.ManualConfig.ServerNetDebug = false

-- Supresses Async call error logging into the console. NEVER recommended to enable.
-- Default: false
YAWS.ManualConfig.SupressAsyncTraces = false