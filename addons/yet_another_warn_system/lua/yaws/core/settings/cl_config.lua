-- Caches the server's in-game config settings
YAWS.Config.ClientReady = YAWS.Config.ClientReady or false 

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

-- UI data that isn't sent over for obvious reasons
YAWS.Config.SettingOrder = {
    [1] = { -- Branding
        "prefix",
        "prefix_color",
        "chat_color"
    },
    [2] = { -- Warnings
        "broadcast_warns",
        "reason_required",
        "purge_on_punishment"
    },
    [3] = { -- Points
        "point_max",
        "point_cooldown_time",
        "point_cooldown_amount",
        "join_message_enabled",
        "join_message_message",
        "message_admins_on_active_join"
    }
}
YAWS.Config.UIData = {
    prefix = {
        name = "admin_settings_prefix_name",
        desc = "admin_settings_prefix_desc"
    },
    prefix_color = {
        name = "admin_settings_prefix_color_name",
        desc = "admin_settings_prefix_color_desc"
    },
    chat_color = {
        name = "admin_settings_chat_color_name",
        desc = "admin_settings_chat_color_desc"
    },
    
    broadcast_warns = {
        name = "admin_settings_broadcast_warns_name",
        desc = "admin_settings_broadcast_warns_desc",
    },
    reason_required = {
        name = "admin_settings_reason_required_name",
        desc = "admin_settings_reason_required_desc",
    },
    purge_on_punishment = {
        name = "admin_settings_purge_on_punishment_name",
        desc = "admin_settings_purge_on_punishment_desc",
    },

    point_max = {
        name = "admin_settings_point_max_name",
        desc = "admin_settings_point_max_desc",
    },
    point_cooldown_time = {
        name = "admin_settings_point_cooldown_time_name",
        desc = "admin_settings_point_cooldown_time_desc",
    },
    point_cooldown_amount = {
        name = "admin_settings_point_cooldown_amount_name",
        desc = "admin_settings_point_cooldown_amount_desc",
    },
    join_message_enabled = {
        name = "admin_settings_join_message_enabled_name",
        desc = "admin_settings_join_message_enabled_desc",
    },
    join_message_message = {
        name = "admin_settings_join_message_message_name",
        desc = "admin_settings_join_message_message_desc",
    },
    message_admins_on_active_join = {
        name = "admin_settings_message_admins_on_active_join_name",
        desc = "admin_settings_message_admins_on_active_join_desc",
    }
}

hook.Add("InitPostEntity", "yaws.config.ready", function()
    net.Start("yaws.config.cacherequest")
    net.SendToServer()
end)


net.Receive("yaws.config.cache", function(len)
    YAWS.Core.PayloadDebug("yaws.config.cache", len)

    local length = net.ReadUInt(16)
    local data = util.JSONToTable(util.Decompress(net.ReadData(length)))

    YAWS.Config.Settings = data

    YAWS.Config.ClientReady = true
    hook.Run("yaws.config.clientready")
end)

function YAWS.Config.GetValue(key)
    if(!YAWS.Config.Settings[key]) then return end

    if(YAWS.Config.Settings[key].value == nil) then
        return YAWS.Config.Settings[key].default
    end
    return YAWS.Config.Settings[key].value
end 