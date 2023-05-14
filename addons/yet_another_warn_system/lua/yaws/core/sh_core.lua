-- helper shit
YAWS.Core.StorableToLuaConverters = {}
YAWS.Core.StorableToLuaConverters["string"] = function(val) return tostring(val) end 
YAWS.Core.StorableToLuaConverters["boolean"] = function(val) return tobool(val) end 
YAWS.Core.StorableToLuaConverters["table"] = function(val) 
    local tbl = util.JSONToTable(val)
    return tbl
end 
YAWS.Core.StorableToLuaConverters["color"] = function(val) 
    local tbl = util.JSONToTable(val)
    return Color(tbl.r, tbl.g, tbl.b, tbl.a)
end 
YAWS.Core.StorableToLuaConverters["number"] = function(val) return tonumber(val) end 

YAWS.Core.LuaToStorableConverters = {}
YAWS.Core.LuaToStorableConverters["string"] = function(val) return val end 
YAWS.Core.LuaToStorableConverters["boolean"] = function(val) return tostring(val) end 
YAWS.Core.LuaToStorableConverters["table"] = function(val) return util.TableToJSON(val) end 
YAWS.Core.LuaToStorableConverters["color"] = function(val) return util.TableToJSON(val) end 
YAWS.Core.LuaToStorableConverters["number"] = function(val) return tostring(val) end 
-- 0 - String  1 - Bool  2 - Table  3 - Int
function YAWS.Core.StorableToLua(val, type)
    return YAWS.Core.StorableToLuaConverters[type](val)
end
function YAWS.Core.LuaToStorable(val)
    return YAWS.Core.LuaToStorableConverters[type(val)](val)
end


function YAWS.Core.HasFullPerms(ply)
    return YAWS.ManualConfig.FullPerms[ply:GetUserGroup()] != nil || YAWS.ManualConfig.FullPerms[ply:SteamID()] != nil || YAWS.ManualConfig.FullPerms[ply:SteamID64()] != nil
end 
function YAWS.Core.HasFullPermsMisc(val)
    return YAWS.ManualConfig.FullPerms[val] != nil
end 

function YAWS.Core.GetAllUserGroups()
    if(CAMI) then return CAMI.GetUsergroups() end 

    -- aw shit - you HAD to use a shitty admin mod didn't ya?
    local groups = {}
    for k,v in ipairs(player.GetAll()) do
        groups[v:GetUserGroup()] = v:GetUserGroup()
    end 

    return groups
end 

function YAWS.Core.PayloadDebug(message, len)
    if(SERVER && !YAWS.ManualConfig.ServerNetDebug) then return end 
    if(CLIENT && !YAWS.ManualConfig.ClientNetDebug) then return end 

    YAWS.Core.LogDebug("(", message, ") Payload Size: ", YAWS.Core.LogColors.TextHighlightColor, string.NiceSize(len / 8), color_white, " / ", YAWS.Core.LogColors.TextHighlightColor, (len / 8), " bytes")

    if(len >= 32000) then
        for i=0,50 do -- someone should notice this... right..?
            YAWS.Core.LogWarning(YAWS.Core.LogColors.ErrorColor, "GETTING CLOSE TO THE NET LIMIT - THIS COULD BE A FATAL ISSUE")
            YAWS.Core.LogWarning(YAWS.Core.LogColors.ErrorColor, "Payload Size: " .. string.NiceSize(5454) .. " / " .. 2353 .. " bytes")
        end 
    end 
end

function YAWS.Core.Trace(action, err, ply)
    if(YAWS.ManualConfig.SupressAsyncTraces) then
        if(ply) then 
            YAWS.Core.Message(ply, "error")
        end 

        return
    end 

    YAWS.Core.LogError("Error in handling action ", YAWS.Core.LogColors.TextHighlightColor, action, color_white, ": ", err)

    if(ply) then 
        YAWS.Core.Message(ply, "error")
        YAWS.Core.LogError("Action triggered by ", YAWS.Core.LogColors.TextHighlightColor, ply:Name(), " (", ply:SteamID(), " / ", ply:SteamID64(), ")")
    end

    for k,v in ipairs(string.Explode("\n", debug.traceback())) do
        YAWS.Core.LogError(v)
    end
end