util.AddNetworkString("yaws.config.cacherequest")
util.AddNetworkString("yaws.config.cache")
util.AddNetworkString("yaws.config.update")
util.AddNetworkString("yaws.config.addpreset")
util.AddNetworkString("yaws.config.editpreset")
util.AddNetworkString("yaws.config.removepreset")
util.AddNetworkString("yaws.config.confirmupdate")
YAWS.Config.Settings = YAWS.Config.Settings or {
    prefix = {
        -- name = "admin_settings_prefix_name",
        -- desc = "admin_settings_prefix_desc",
        default = "Yet Another Warn System >>",
        value = nil,
        type = "string",
        category = "branding"
    },
    prefix_color = {
        default = Color(83, 182, 155),
        value = nil,
        type = "color",
        category = "branding"
    },
    chat_color = {
        default = Color(255, 255, 255),
        value = nil,
        type = "color",
        category = "branding"
    },
    
    broadcast_warns = {
        default = true,
        value = nil,
        type = "boolean",
        category = "warnings"
    },
    reason_required = {
        default = false,
        value = nil,
        type = "boolean",
        category = "warnings"
    },
    purge_on_punishment = {
        default = false,
        value = nil,
        type = "boolean",
        category = "warnings"
    },

    point_max = {
        default = 50,
        value = nil,
        type = "number",
        category = "points"
    },
    point_cooldown_time = {
        default = 1800, -- 30 minutes
        value = nil,
        type = "number",
        category = "points"
    },
    point_cooldown_amount = {
        default = 1,
        value = nil,
        type = "number",
        category = "points"
    },
    join_message_enabled = {
        default = true,
        value = nil,
        type = "boolean",
        category = "points"
    },
    join_message_message = {
        default = "Welcome back. You have {active} active points out of {points} points in total.", -- Also have a {inactive} thing
        value = nil,
        type = "string",
        category = "points"
    },
    message_admins_on_active_join = {
        default = false,
        value = nil,
        type = "boolean",
        category = "points"
    },
}
YAWS.Config.Presets = YAWS.Config.Presets or {}

hook.Add("yaws.database.loaded", "yaws.config.populate", function()
    YAWS.Database.Query(function(err, q, data)
        if(err) then return end 
        if(#data <= 0) then return end

        for k,v in ipairs(data) do 
            if(!YAWS.Config.Settings[v.key]) then 
                YAWS.Database.Query(nil, [[
                    DELETE FROM `%sconfig` WHERE `key` = %s;
                ]], YAWS.Database.ServerSpecificPrefix, YAWS.Database.String(v.key))

                continue
            end 

            local val = YAWS.Core.StorableToLua(v.value, YAWS.Config.Settings[v.key].type)
            if(val == YAWS.Config.Settings[v.key].default) then 
                YAWS.Database.Query(nil, [[
                    DELETE FROM `%sconfig` WHERE `key` = %s;
                ]], YAWS.Database.ServerSpecificPrefix, YAWS.Database.String(v.key))

                continue
            end 

            YAWS.Config.Settings[v.key].value = val
        end 

        YAWS.Core.LogInfo("Successfully loaded server settings.")
        hook.Run("yaws.config.loaded")
    end, [[
        SELECT * FROM `%sconfig`;
    ]], YAWS.Database.ServerSpecificPrefix)

    -- Presets
    YAWS.Database.Query(function(err, q, data)
        if(err) then return end 
        if(#data <= 0) then return end

        for k,v in ipairs(data) do 
            YAWS.Config.Presets[v.name] = {
                reason = v.reason,
                points = v.points,
            }
        end 
    end, [[
        SELECT * FROM `%spresets`;
    ]], YAWS.Database.ServerSpecificPrefix)
end)

hook.Add("yaws.config.loaded", "yaws.config.justincaseweareluarefreshing", function()
    for k,v in ipairs(player.GetAll()) do 
        YAWS.Config.UserCache(v)
    end 
end)

function YAWS.Config.SetValue(key, val, noUpdate)
    if(YAWS.Config.Settings[key].value == val) then return end

    YAWS.Config.Settings[key].value = val
    
    local storable = YAWS.Core.LuaToStorable(val)
    YAWS.Database.Query(nil, [[
        REPLACE INTO `%sconfig`(`key`, `value`) VALUES(%s, %s);
    ]], YAWS.Database.ServerSpecificPrefix, YAWS.Database.String(key), YAWS.Database.String(storable))

    if(!noUpdate) then 
        hook.Run("yaws.config.updated")
    end 
end 

function YAWS.Config.GetValue(key)
    if(!YAWS.Config.Settings[key]) then return end
    
    if(YAWS.Config.Settings[key].value == nil) then
        return YAWS.Config.Settings[key].default
    end
    return YAWS.Config.Settings[key].value
end 

-- Caching Shit
net.Receive("yaws.config.cacherequest", function(len, ply)
    YAWS.Core.PayloadDebug("yaws.config.cacherequest", len)
    YAWS.Config.UserCache(ply)
end)
function YAWS.Config.UserCache(ply)
    net.Start("yaws.config.cache")
    
    local compressed = util.Compress(util.TableToJSON(YAWS.Config.Settings))
    net.WriteUInt(#compressed, 16)
    net.WriteData(compressed)

    net.Send(ply)
end 
hook.Add("yaws.config.updated", "yaws.config.updateclient", function()
    for k,v in ipairs(player.GetAll()) do 
        YAWS.Config.UserCache(v)
    end 
end)

net.Receive("yaws.config.update", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "view_admin_settings")) then return end
    YAWS.Core.PayloadDebug("yaws.config.update", len)

    local length = net.ReadUInt(16)
    for i=1,length do 
        local key = net.ReadString()
        if(!YAWS.Config.Settings[key]) then continue end 

        local type = YAWS.Config.Settings[key].type 
        local val

        if(type == "string" || type == "combo") then 
            val = net.ReadString()
        end 
        if(type == "boolean") then 
            val = net.ReadBool()
        end
        if(type == "color") then 
            val = Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))
        end
        if(type == "number") then 
            if(key == "point_max") then 
                val = net.ReadInt(12)
            else
                val = net.ReadInt(32)
            end
        end

        if(val == nil) then continue end 
        YAWS.Config.SetValue(key, val, true)
    end
    hook.Run("yaws.config.updated")

    YAWS.Core.Message(ply, "admin_config_saved")
end)

-- Preset Stuff. I was too lazy to move it to a new file
net.Receive("yaws.config.addpreset", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "view_admin_settings")) then return end
    YAWS.Core.PayloadDebug("yaws.config.addpreset", len)

    local name = string.Trim(net.ReadString())
    local reason = string.Trim(net.ReadString())
    local points = net.ReadUInt(12)

    if(name == "" || reason == "") then 
        YAWS.Core.Message(ply, "admin_preset_nope")
        net.Start("yaws.config.confirmupdate")
        net.WriteBool(false)
        net.Send(ply)
        return
    end 
    if(YAWS.Config.Presets[name]) then 
        YAWS.Core.Message(ply, "admin_preset_dupe")
        net.Start("yaws.config.confirmupdate")
        net.WriteBool(false)
        net.Send(ply)
        return
    end 
    if(table.Count(YAWS.Config.Presets) >= 32) then -- limit of 32 for once again, net message limits
        YAWS.Core.Message(ply, "admin_preset_limit")
        net.Start("yaws.config.confirmupdate")
        net.WriteBool(false)
        net.Send(ply)
        return
    end

    YAWS.Config.Presets[name] = {
        reason = reason,
        points = points
    }
    YAWS.Database.Query(nil, [[
        INSERT INTO `%spresets`(`name`, `reason`, `points`) VALUES(%s, %s, %s);
    ]], YAWS.Database.ServerSpecificPrefix, YAWS.Database.String(name), YAWS.Database.String(reason), YAWS.Database.String(points))

    YAWS.Core.Message(ply, "admin_preset_added")
    hook.Run("yaws.config.updatepresets")

    net.Start("yaws.config.confirmupdate")
    net.WriteBool(true)
    net.Send(ply)
end)

net.Receive("yaws.config.removepreset", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "view_admin_settings")) then return end
    YAWS.Core.PayloadDebug("yaws.config.removepreset", len)

    local name = net.ReadString()
    if(!YAWS.Config.Presets[name]) then 
        YAWS.Core.Message(ply, "admin_preset_cantfind")
        net.Start("yaws.config.confirmupdate")
        net.WriteBool(false)
        net.Send(ply)
        return
    end

    YAWS.Config.Presets[name] = nil
    YAWS.Database.Query(nil, [[
        DELETE FROM `%spresets` WHERE `name` = %s;
    ]], YAWS.Database.ServerSpecificPrefix, YAWS.Database.String(name))

    YAWS.Core.Message(ply, "admin_preset_removed")
    hook.Run("yaws.config.updatepresets")

    net.Start("yaws.config.confirmupdate")
    net.WriteBool(true)
    net.Send(ply)
end)

net.Receive("yaws.config.editpreset", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "view_admin_settings")) then return end
    YAWS.Core.PayloadDebug("yaws.config.editpreset", len)

    local replaceMe = string.Trim(net.ReadString())
    local name = string.Trim(net.ReadString())
    local reason = string.Trim(net.ReadString())
    local points = net.ReadUInt(12)

    if(!YAWS.Config.Presets[replaceMe]) then 
        YAWS.Core.Message(ply, "admin_preset_cantfind")
        net.Start("yaws.config.confirmupdate")
        net.WriteBool(false)
        net.Send(ply)
        return
    end 
    if(name == "" || reason == "") then 
        YAWS.Core.Message(ply, "admin_preset_nope")
        net.Start("yaws.config.confirmupdate")
        net.WriteBool(false)
        net.Send(ply)
        return
    end 
    if(table.Count(YAWS.Config.Presets) >= 32) then -- limit of 32 for once again, net message limits
        YAWS.Core.Message(ply, "admin_preset_limit")
        net.Start("yaws.config.confirmupdate")
        net.WriteBool(false)
        net.Send(ply)
        return
    end

    if(replaceMe != name) then 
        if(YAWS.Config.Presets[name]) then 
            YAWS.Core.Message(ply, "admin_preset_dupe")
            net.Start("yaws.config.confirmupdate")
            net.WriteBool(false)
            net.Send(ply)
            return
        end 

        YAWS.Config.Presets[replaceMe] = nil
        YAWS.Database.Query(nil, [[
            DELETE FROM `%spresets` WHERE `name` = %s;
        ]], YAWS.Database.ServerSpecificPrefix, YAWS.Database.String(replaceMe))
    end 

    YAWS.Config.Presets[name] = {
        reason = reason,
        points = points
    }
    YAWS.Database.Query(nil, [[
        REPLACE INTO `%spresets`(`name`, `reason`, `points`) VALUES(%s, %s, %s);
    ]], YAWS.Database.ServerSpecificPrefix, YAWS.Database.String(name), YAWS.Database.String(reason), YAWS.Database.String(points))

    YAWS.Core.Message(ply, "admin_preset_edited")
    hook.Run("yaws.config.updatepresets")

    net.Start("yaws.config.confirmupdate")
    net.WriteBool(true)
    net.Send(ply)
end)

hook.Add("yaws.config.updatepresets", "yaws.config.updateclientswithcontext", function()
    -- Update clients
    for k,v in ipairs(player.GetAll()) do
        net.Start("yaws.permissions.maybeyoucanviewyes")
        net.WriteBool(YAWS.Permissions.CheckPermissionPly(v, "view_others_warns")) -- View warns/admin notes
        net.WriteBool(YAWS.Permissions.CheckPermissionPly(v, "create_warns")) -- Create warnings
        
        if(YAWS.Permissions.CheckPermissionPly(v, "create_warns")) then 
            local compressed = util.Compress(util.TableToJSON(YAWS.Config.Presets))
            net.WriteUInt(#compressed, 16)
            net.WriteData(compressed)
        end 
        net.Send(v)
    end 
end)