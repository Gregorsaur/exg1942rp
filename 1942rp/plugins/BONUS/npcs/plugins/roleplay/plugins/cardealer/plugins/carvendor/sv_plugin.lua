local PLUGIN = PLUGIN

------------------------------------------------------------------------------------------
net.Receive("carvendoropenaction", function()
    local client = net.ReadEntity()
    local entity = net.ReadEntity()
    local data = PLUGIN:VendorGetData(entity)
    netstream.Start(client, "CarVendorOpen", entity, data)
end)

------------------------------------------------------------------------------------------
net.Receive("carvendorretrieveaction", function()
    local client = net.ReadEntity()
    local entity = net.ReadEntity()
    local data = PLUGIN:VendorGetData(entity)
    netstream.Start(client, "openGarageMenu", entity, data)
end)
------------------------------------------------------------------------------------------