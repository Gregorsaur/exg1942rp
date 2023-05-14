local HasPermission = {
    owner = true,
    communitymanager = true,
    superadmin = true,
    senioradmin = true,
    admin = true,
    moderator = true,
    developer = true,
}

function PLUGIN:SaveData()
    self:setData(NSForgedItems.List)
end

function PLUGIN:LoadData()
    NSForgedItems.List = self:getData() or {}

    for uniqueID, itemData in pairs(NSForgedItems.List) do
        NSForgedItems.RegisterCustomItem(uniqueID, itemData)
    end

    netstream.Start(nil, "NSForgedItemsLoad", NSForgedItems.List)
end

function PLUGIN:PlayerInitialSpawn(client)
    netstream.Start(client, "NSForgedItemsLoad", NSForgedItems.List)
end

netstream.Hook("ItemMakerGUI", function(client, id, itemData)
    if (not HasPermission[client:GetUserGroup()]) then return end
    if (not id or not itemData) then return end
    if (not itemData.name or not itemData.desc) then return end
    NSForgedItems.List[id] = itemData
    NSForgedItems.RegisterCustomItem(id, itemData)
    netstream.Start(nil, "NSForgedItemsLoadSingle", id, itemData)
    client:notify("You've successfully registered '" .. id .. "'. It can now be spawned in and used as an item!")
end)

netstream.Hook("ItemMakerDelete", function(uniqueID)
    nut.item.list[uniqueID] = nil
    NSForgedItems.List[uniqueID] = nil
end)

nut.command.add("ItemMaker", {
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments)
        if (not HasPermission[client:GetUserGroup()]) then
            client:notify("You do not have access to this command.")

            return false
        end

        netstream.Start(client, "ItemMakerGUI")
    end
})

nut.command.add("ItemMakerlist", {
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments)
        if (not HasPermission[client:GetUserGroup()]) then
            client:notify("You do not have access to this command.")

            return false
        end

        netstream.Start(client, "ItemMakerList", NSForgedItems.List)
    end
})

nut.command.add("ItemMakerdetails", {
    adminOnly = true,
    syntax = "<uniqueID>",
    onRun = function(client, arguments)
        if (not HasPermission[client:GetUserGroup()]) then
            client:notify("You do not have access to this command.")

            return false
        end

        local uniqueID = arguments[1]

        if (not uniqueID or not NSForgedItems.List[uniqueID]) then
            client:notify("Unique ID is invalid. Consider using /ItemMakerlist")

            return
        end

        netstream.Start(client, "ItemMakerDetails", uniqueID, NSForgedItems.List[uniqueID])
    end
})

nut.command.add("ItemMakerdelete", {
    adminOnly = true,
    syntax = "<uniqueID>",
    onRun = function(client, arguments)
        if (not HasPermission[client:GetUserGroup()]) then
            client:notify("You do not have access to this command.")

            return false
        end

        local uniqueID = arguments[1]

        if (not uniqueID) then
            client:notify("You have to specify a unique ID")

            return
        end

        if (not NSForgedItems.List[uniqueID]) then
            client:notify("That is not an item-forge generated item ID.")

            return
        end

        NSForgedItems.List[uniqueID] = nil
        local count = 0

        for k, v in pairs(nut.item.instances) do
            if (v and istable(v) and v.uniqueID and v.uniqueID == uniqueID) then
                count = count + 1
                v:remove()
            end
        end

        nut.item.list[uniqueID] = nil
        client:notify("Removed " .. count .. " instances of " .. uniqueID .. " in the world & removed item type!")
        netstream.Start(nil, "ItemMakerDelete", uniqueID)
    end
})