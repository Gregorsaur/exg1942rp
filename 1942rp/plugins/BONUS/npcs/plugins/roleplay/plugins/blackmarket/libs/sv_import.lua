local PLUGIN = PLUGIN

net.Receive("import_drugs", function(len, ply)
    local character = ply:getChar()
    local item = net.ReadString()
    local price = net.ReadInt(32)
    local itemTable = nut.item.list[item]
    local value = math.random(1, 6)

    if character:hasMoney(price) then
        character:takeMoney(price)
        ply:notify("You've placed an order for a " .. itemTable.name .. " for $" .. price .. ". It will arrive in " .. PLUGIN.ImportTime .. " seconds. Stay here!")
        ply:SetNWBool("npc_cooldown_" .. item, true)

        timer.Create(ply:UniqueID() .. "_Import_" .. item, PLUGIN.ImportTime, 0, function()
            ply:SetNWBool("npc_cooldown_" .. item, false)

            for k, v in pairs(PLUGIN.DrugLocations) do
                if v[3] == value then
                    local imported = ents.Create("import_item")
                    imported:SetPos(v[2])
                    imported:SetNWInt("imported_owner", ply:EntIndex())
                    imported:SetNWString("imported_item", item)
                    imported:Spawn()
                    net.Start("waypoint_start_drug")
                    net.WriteString(v[1])
                    net.WriteVector(v[2])
                    net.Send(ply)
                    ply:notify("Your " .. itemTable.name .. " has arrived to it's destination! Current Location: " .. v[1])
                end
            end

            timer.Remove(ply:UniqueID() .. "_Import_" .. item)
        end)
    else
        ply:notify("You cannot afford this shipment!")
    end
end)