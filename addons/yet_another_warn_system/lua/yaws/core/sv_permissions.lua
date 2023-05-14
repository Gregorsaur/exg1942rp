util.AddNetworkString("yaws.permissions.updatepermissions")
util.AddNetworkString("yaws.permissions.caniviewcontextquestionmark")
util.AddNetworkString("yaws.permissions.maybeyoucanviewyes")

YAWS.Permissions.Permissions = {
    superadmin = {
        view_ui = true,
        view_self_warns = true,

        view_others_warns = true,
        view_admin_settings = true,

        create_warns = true,
        customise_reason = true,
        delete_warns = true,
    },
    admin = {
        view_ui = true,
        view_self_warns = true,
        
        view_others_warns = true,
        view_admin_settings = false,
        
        create_warns = true,
        customise_reason = true,
        delete_warns = false,
    },
    user = {
        view_ui = true,
        view_self_warns = true,
        
        view_others_warns = false,
        view_admin_settings = false,
        
        create_warns = false,
        customise_reason = false,
        delete_warns = false,
    }
}

-- Load the permissions on startup.
hook.Add("yaws.database.loaded", "yaws.permissions.load", function()
    YAWS.Database.Query(function(err, q, data)
        if(err) then return end 
        if(data == nil) then return end
    
        for k,v in ipairs(data) do
            if(!YAWS.Permissions.Permissions[v.usergroup]) then 
                YAWS.Permissions.Permissions[v.usergroup] = {}
            end 

            local json = util.JSONToTable(v.permissions)
            for x,y in pairs(json) do 
                YAWS.Permissions.Permissions[v.usergroup][x] = y
            end 
        end

        hook.Run("yaws.permissions.loaded")
    end, [[
        SELECT * FROM `%spermissions`;
    ]], YAWS.Database.ServerSpecificPrefix)
end)

function YAWS.Permissions.UpdatePermissions(usergroup, key, value)
    if(!YAWS.Permissions.Permissions[usergroup]) then 
        YAWS.Permissions.Permissions[usergroup] = {}
    end 

    YAWS.Permissions.Permissions[usergroup][key] = value

    YAWS.Database.Query(nil, [[
        REPLACE INTO `%spermissions`(`usergroup`, `permissions`) VALUES(%s, %s);
    ]], YAWS.Database.ServerSpecificPrefix, YAWS.Database.String(usergroup), YAWS.Database.String(util.TableToJSON(YAWS.Permissions.Permissions[usergroup])))

    hook.Run("yaws.permissions.updated", usergroup, key, val)
end 

function YAWS.Permissions.CheckPermission(usergroup, key)
    if(YAWS.Core.HasFullPermsMisc(usergroup)) then return true end 
    if(!YAWS.Permissions.Permissions[usergroup]) then return false end 
    if(!YAWS.Permissions.Permissions[usergroup][key]) then return false end 

    return YAWS.Permissions.Permissions[usergroup][key]
end 
function YAWS.Permissions.CheckPermissionPly(ply, key)
    return YAWS.Permissions.CheckPermission(ply:GetUserGroup(), key) || YAWS.Core.HasFullPerms(ply)
end 


net.Receive("yaws.permissions.updatepermissions", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "view_admin_settings")) then return end 
    YAWS.Core.PayloadDebug("yaws.permissions.updatepermissions", len)
    
    local length = net.ReadUInt(16)
    local data = {}
    for i=0,length - 1 do 
        local group = net.ReadString()
        data[group] = {}
        
        local dataLength = net.ReadUInt(16) 
        for x=0,dataLength - 1 do 
            data[group][net.ReadString()] = net.ReadBool()
        end 
    end 

    -- apply it
    for k,v in pairs(data) do 
        for x,y in pairs(v) do 
            YAWS.Permissions.UpdatePermissions(k, x, y)
        end
    end 

    YAWS.Core.Message(ply, "admin_permissions_saved")
end)

-- Context menu permission cache
net.Receive("yaws.permissions.caniviewcontextquestionmark", function(len, ply)
    YAWS.Core.PayloadDebug("yaws.permissions.caniviewcontextquestionmark", len)

    net.Start("yaws.permissions.maybeyoucanviewyes")
    net.WriteBool(YAWS.Permissions.CheckPermissionPly(ply, "view_others_warns")) -- View warns/admin notes
    net.WriteBool(YAWS.Permissions.CheckPermissionPly(ply, "create_warns")) -- Create warnings

    if(YAWS.Permissions.CheckPermissionPly(ply, "create_warns")) then 
        local compressed = util.Compress(util.TableToJSON(YAWS.Config.Presets))
        net.WriteUInt(#compressed, 16)
        net.WriteData(compressed)
    end 
    net.Send(ply)
end)
hook.Add("yaws.permissions.updated", "yaws.permissions.updateclients", function(usergroup, key, val)
    -- Update clients
    for k,v in ipairs(player.GetAll()) do
        if(v:GetUserGroup() != usergroup) then return end 

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