local PLUGIN = PLUGIN

net.Receive("car_dealer_wehrkreis", function()
    local client = LocalPlayer()
    local entity = net.ReadEntity()

    talkablenpcs.dialog("CPT Arminass", "models/gman_high.mdl", "NYPD Car Vendor", "NYPD", function(ply)
        talkablenpcs.dialogframe("CPT Arminass", "models/gman_high.mdl", "NYPD Security Car Vendor", "NYPD")
        talkablenpcs.dialogtext("What are you looking to do?")

        talkablenpcs.dialogbutton("Buy a Car", 40, function()
            if entity.faction and entity.faction > 0 and not client:IsAdmin() then
                if client:Team() ~= entity.faction then
                    client:notify("You are not allowed to access this NPC", NOT_ERROR)

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