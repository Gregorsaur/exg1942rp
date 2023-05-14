nut.command.add("deliver", {
    syntax = "",
    onRun = function(client, arguments)
        if client:Team() ~= FACTION_DELIVERY then
            client:notify("Only deliverymen can use this command.")

            return
        end

        if not IsValid(client.DeliveryCrate) then
            client:notify("You have no active deliveries. Talk to the delivery NPC.")

            return
        end

        local crate = client.DeliveryCrate
        if crate.Reserved then return end

        if not crate.Location then
            client:notify("Crate spawned with no location - error")

            return
        end

        local location = DeliveryNPCLocations[crate.Location]
        local place = crate.Location

        if not location then
            client:notify("Crate location invalid - error")

            return
        end

        local distance = crate:GetPos():Distance(location.Position)

        if distance > 600 then
            client:notify("You need to get the crate closer to the location")

            return
        end

        crate.Reserved = true
        crate:Remove()

        if IsValid(client.deliveryTruckEnt) then
            client.deliveryTruckEnt.DeliveryCrateAttached = nil
        end

        local pay = location.Pay
        client:getChar():giveMoney(pay)
        client:notify("You've made " .. nut.currency.get(pay) .. " for delivering this package to " .. place)
        net.Start("delivery_sendtruck_cl")
        net.WriteString("DeliveryCrate")
        net.WriteEntity(NULL)
        net.Send(client)
        net.Start("delivery_setwaypoint")
        net.WriteBool(false)
        net.Send(client)
    end
})