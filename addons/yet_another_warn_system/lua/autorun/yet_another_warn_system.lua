-- shitty table names are a small price compared to the meme of calling your
-- premium gmodstore addon people pay for and the addon you've so far put the
-- most effort into ever "yet another warn system"
YAWS = YAWS or {}

YAWS.Version = {}
YAWS.Version.Major = 2
YAWS.Version.Minor = 1
YAWS.Version.Patch = 2
YAWS.Version.Suffix = "Stable"
YAWS.Version.Release = YAWS.Version.Major .. "." .. YAWS.Version.Minor .. "." .. YAWS.Version.Patch .. " (" .. YAWS.Version.Suffix .. ")"
YAWS.Version.IsOutdated = YAWS.Version.IsOutdated or false

YAWS.Core = YAWS.Core or {}

YAWS.Language = YAWS.Language or {}
YAWS.Language.Languages = YAWS.Language.Languages or {}
YAWS.ManualConfig = YAWS.ManualConfig or {} -- file config
YAWS.ManualConfig.FullPerms = {}
YAWS.ManualConfig.Immunes = {}
YAWS.Config = YAWS.Config or {} -- in-game config
YAWS.Punishments = YAWS.Punishments or {}

if(SERVER) then 
    -- Serverside-only tables
    YAWS.ManualConfig.Database = {}
    YAWS.ManualConfig.Discord = {}

    YAWS.NetCooldown = {}
    YAWS.Database = YAWS.Database or {}
    YAWS.Permissions = YAWS.Permissions or {}
    YAWS.Warns = YAWS.Warns or {}
    YAWS.Players = YAWS.Players or {}
    YAWS.NiceServerNames = YAWS.NiceServerNames or {}
    YAWS.Convert = YAWS.Convert or {}
    YAWS.API = YAWS.API or {}

    resource.AddWorkshop("2665322617")
else 
    -- Clientside-only tables
    YAWS.UI = YAWS.UI or {}
    YAWS.UI.Tabs = YAWS.UI.Tabs or {}
    YAWS.UI.StateCache = {}
    YAWS.UserSettings = YAWS.UserSettings or {}
end 



-- Whole shit ton of logging functions - yeeeah I might've taken these too far. Oh well lol
-- #4dd8b3 = Color(77, 216, 179)
YAWS.Core.LogColors = {
    PrefixColor = Color(77, 216, 179),
    InfoColor = Color(148, 216, 109),
    WarnColor = Color(255, 175, 70),
    ErrorColor = Color(255, 70, 70),
    DebugColor = Color(218, 117, 228),
    TextHighlightColor = Color(144, 174, 255),
    Gray = Color(200, 200, 200),
}
function YAWS.Core.Log(prefix, prefixColor, ...)
    MsgC(YAWS.Core.LogColors.PrefixColor, "[YAWS] ", prefixColor, prefix, " >> ", color_white, unpack({...}))
    MsgC("\n")
end
function YAWS.Core.LogInfo(...) 
    -- cant cache this color since it's called before the cache is created
    YAWS.Core.Log("INFO", YAWS.Core.LogColors.InfoColor, unpack({...})) 
end
function YAWS.Core.LogWarning(...) 
    -- cant cache this color since it's called before the cache is created
    YAWS.Core.Log("WARN", YAWS.Core.LogColors.WarnColor, unpack({...})) 
end
function YAWS.Core.LogError(...) 
    -- cant cache this color since it's called before the cache is created
    YAWS.Core.Log("ERROR", YAWS.Core.LogColors.ErrorColor, unpack({...})) 
end 
function YAWS.Core.LogDebug(...) 
    -- cant cache this color since it's called before the cache is created
    YAWS.Core.Log("DEBUG", YAWS.Core.LogColors.DebugColor, unpack({...})) 
end 
function YAWS.Core.Space() 
    -- lol
    print("")
end 
function YAWS.Core.Divider(short)
    if(short) then 
        return "---------------------------------------"
    end 
    return "------------------------------------------------------------------------------------"
end 
function YAWS.Core.CenterDividerText(text, short) 
    local length = ((short && 39 || 84) - #text) / 2
    return string.rep(" ", length) .. text .. string.rep(" ", length)
end 


YAWS.Core.Space() 
YAWS.Core.LogInfo(YAWS.Core.Divider(true))
YAWS.Core.LogInfo(YAWS.Core.CenterDividerText("Loading Yet Another Warning System", true))
YAWS.Core.LogInfo(YAWS.Core.Divider(true))
YAWS.Core.LoadClock = os.clock()
function YAWS.Core.RecursiveLoad(folder, depth) -- yes, depth is just for the visuals.
    -- Load the files in that directory first.
    if(SERVER) then 
        for k,v in ipairs(file.Find(folder .. "/sv*.lua", "LUA")) do
            YAWS.Core.LogInfo(string.rep("  ", depth + 1) .. "> " .. v)
            include(folder .. "/" .. v)
        end
        for k,v in ipairs(file.Find(folder .. "/sh*.lua", "LUA")) do
            YAWS.Core.LogInfo(string.rep("  ", depth + 1) .. "> " .. v)
            include(folder .. "/" .. v)
            AddCSLuaFile(folder .. "/" .. v)
        end
        for k,v in ipairs(file.Find(folder .. "/cl*.lua", "LUA")) do
            YAWS.Core.LogInfo(string.rep("  ", depth + 1) .. "> " .. v)
            AddCSLuaFile(folder .. "/" .. v)
        end
    else 
        for k,v in ipairs(file.Find(folder .. "/sh*.lua", "LUA")) do
            YAWS.Core.LogInfo(string.rep("  ", depth + 1) .. "> " .. v)
            include(folder .. "/" .. v)
        end
        for k,v in ipairs(file.Find(folder .. "/cl*.lua", "LUA")) do
            YAWS.Core.LogInfo(string.rep("  ", depth + 1) .. "> " .. v)
            include(folder .. "/" .. v)
        end
    end

    -- Find the others
    local _,dirs = file.Find(folder .. "/*", "LUA")
    for k,v in ipairs(dirs) do 
        YAWS.Core.LogInfo(YAWS.Core.LogColors.Gray, string.rep("  ", depth + 1) .. v)
        YAWS.Core.RecursiveLoad(folder .. "/" .. v, depth + 1)
    end 
end 
YAWS.Core.RecursiveLoad("yaws", 0)

YAWS.Core.LogInfo("------------------------------------")
YAWS.Core.LogInfo("Core files loaded in " .. math.Round(os.clock() - YAWS.Core.LoadClock, 4) .. " seconds.")
YAWS.Core.Space()
YAWS.Core.LoadClock = nil
hook.Run("yaws.core.initalize")

if(!CAMI) then 
    -- The only thing that would actually break is the permissions ui, since
    -- it'll be unable to get all the usergroups. Still, nothing like a nice
    -- scary warning for unsuspecting users >:)
    YAWS.Core.Space() 
    YAWS.Core.LogWarning(YAWS.Core.Divider())
    YAWS.Core.LogWarning(" CAMI was not detected on this server.")
    YAWS.Core.LogWarning(YAWS.Core.LogColors.ErrorColor, " YET ANOTHER WARNING SYSTEM WILL NOT FUCKING WORK PROPERLY WITHOUT IT!")
    YAWS.Core.LogWarning(YAWS.Core.Divider())
    YAWS.Core.LogWarning(" Please get a admin mod that was coded competentely. YAWS will try to work around it")
    YAWS.Core.LogWarning(" but some features might be wonky or outright broken.", YAWS.Core.LogColors.TextHighlightColor, " https://github.com/glua/CAMI")
    YAWS.Core.LogWarning(YAWS.Core.Divider())
end 
if(!ulx && !sam && !xAdmin) then 
    YAWS.Core.Space() 
    YAWS.Core.LogWarning(YAWS.Core.Divider() )
    YAWS.Core.LogWarning(" No supported admin mods detected. Most punishments will not work without at least")
    YAWS.Core.LogWarning(" one of them installed.")
    YAWS.Core.LogWarning("")
    YAWS.Core.LogWarning(" If you wish to request an admin mod to be added to the supported list, please make")
    YAWS.Core.LogWarning(" a ticket on Gmodstore.")
    YAWS.Core.LogWarning(YAWS.Core.Divider())
end 
if(xAdmin) then 
    if(!xAdmin.Github) then
        YAWS.Core.Space() 
        YAWS.Core.LogWarning(YAWS.Core.Divider())
        YAWS.Core.LogWarning(" If your looking for xAdmin support, YAWS only supports the free xAdmin, not")
        YAWS.Core.LogWarning(" TheXnator's xAdmin. ", YAWS.Core.LogColors.TextHighlightColor, "https://github.com/TheXYZNetwork/xAdmin")
        YAWS.Core.LogWarning(YAWS.Core.Divider())
    end
end 

-- Database config checks
if(SERVER) then
    if(string.find(YAWS.ManualConfig.Database.TablePrefix, " ")) then 
        YAWS.Core.Space() 
        YAWS.Core.LogWarning(YAWS.Core.Divider())
        YAWS.Core.LogWarning(" The set Table Prefix inside your database config contains spaces.")
        YAWS.Core.LogWarning(" This does not make it a valid SQL table name. Please change it!")
        YAWS.Core.LogWarning(YAWS.Core.Divider())
    end 
    if(string.find(YAWS.ManualConfig.Database.ServerID, " ")) then 
        YAWS.Core.Space() 
        YAWS.Core.LogWarning(YAWS.Core.Divider())
        YAWS.Core.LogWarning(" The set ServerID inside your database config contains spaces.")
        YAWS.Core.LogWarning(" This does not make it a valid SQL table name. Please change it!")
        YAWS.Core.LogWarning(YAWS.Core.Divider())
    end 
    if(#YAWS.ManualConfig.Database.TablePrefix > 20) then 
        YAWS.Core.Space() 
        YAWS.Core.LogWarning(YAWS.Core.Divider())
        YAWS.Core.LogWarning(" Your table prefix should ideally not be more than 20 characters in length.")
        YAWS.Core.LogWarning(" While this won't affect anything, it's reccomended to change it!")
        YAWS.Core.LogWarning(YAWS.Core.Divider())
    end 
    if(#YAWS.ManualConfig.Database.ServerID > 50) then 
        YAWS.Core.Space() 
        YAWS.Core.LogWarning(YAWS.Core.Divider())
        YAWS.Core.LogWarning(" Your ServerID should not be more than 50 characters in length.")
        YAWS.Core.LogWarning(" Please change it!")
        YAWS.Core.LogWarning(YAWS.Core.Divider())
    end 
    if(#YAWS.ManualConfig.Database.ServerName > 100) then 
        YAWS.Core.Space() 
        YAWS.Core.LogWarning(YAWS.Core.Divider())
        YAWS.Core.LogWarning(" Your server name should not be more than 100 characters in length.")
        YAWS.Core.LogWarning(" Please change it!")
        YAWS.Core.LogWarning(YAWS.Core.Divider())
    end 
    if(YAWS.ManualConfig.Database.RefreshRate < 15) then 
        YAWS.Core.Space() 
        YAWS.Core.LogWarning(YAWS.Core.Divider())
        YAWS.Core.LogWarning(" Your database refresh rate should not be less than 15!")
        YAWS.Core.LogWarning(" Keep in mind that number means YAWS will check the database")
        YAWS.Core.LogWarning(" after every x seconds. It's reccomended to set it to 30 -> 60 seconds.")
        YAWS.Core.LogWarning(YAWS.Core.Divider())
    end 
end

-- Now to do our version check.
hook.Add("PlayerConnect", "yaws.core.versioncheck", function()
    -- No, this isn't a backdoor. It's a version check script that does nothing
    -- but return the latest addon version for checking. Calm down. If you
    -- really don't believe me go make your fucking gmodstore site ticket and
    -- i'll prove to them it's not one.
    http.Fetch("https://api.livaco.dev/yaws_version_check.php", function(body, size, headers, code)
        local version = body 
        local v = string.Split(version, ".")
        
        local isOuted = false
        -- youch
        if(tonumber(v[1]) > YAWS.Version.Major) then 
            isOuted = true
        elseif(tonumber(v[1]) == YAWS.Version.Major) then 
            if(tonumber(v[2]) > YAWS.Version.Minor) then
                isOuted = true
            elseif(tonumber(v[2]) == YAWS.Version.Minor) then
                if(tonumber(v[3]) > YAWS.Version.Patch) then
                    isOuted = true
                end
            end
        end

        if(isOuted) then
            YAWS.Version.IsOutdated = true 

            YAWS.Core.Space()
            YAWS.Core.LogWarning(YAWS.Core.Divider())
            YAWS.Core.LogWarning("  Your YAWS install is outdated. Please update to the latest version.")
            YAWS.Core.LogWarning("  Latest Version: ", YAWS.Core.LogColors.TextHighlightColor, version)
            YAWS.Core.LogWarning(YAWS.Core.Divider())
        end
    end,
    function(err)
        YAWS.Core.LogError("Error checking for newer version: ", err)
    end)

    hook.Remove("PlayerConnect", "yaws.core.versioncheck")
end)