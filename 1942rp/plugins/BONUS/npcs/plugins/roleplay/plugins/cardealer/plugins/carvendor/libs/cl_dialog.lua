local PLUGIN = PLUGIN

net.Receive("car_dealer", function()
    local client = LocalPlayer()
    local entity = net.ReadEntity()

    talkablenpcs.dialog("Thomas Wilson", "models/gman_high.mdl", "Car Dealer", "Cars 4tardes", function(ply)
        talkablenpcs.dialogframe("Thomas Wilson", "models/gman_high.mdl", "Car Dealer", "Dolfie Hittie Cars")
        talkablenpcs.dialogtext("What are you looking to do?")

        talkablenpcs.dialogbutton("Buy a Car", 40, function()
            if entity.faction and entity.faction > 0 and not client:IsAdmin() then
                if client:Team() ~= entity.faction then
                    client:notify("You are not allowed to access this NPC")

                    return
                end
            end

            net.Start("carvendoropenaction")
            net.WriteEntity(client)
            net.WriteEntity(entity)
            net.SendToServer()
            self:Remove()
        end)

        talkablenpcs.dialogbutton("Retrieve Car", 40, function()
            net.Start("carvendorretrieveaction")
            net.WriteEntity(client)
            net.WriteEntity(entity)
            net.SendToServer()
            self:Remove()
        end)
    end)
end)