local PLUGIN = PLUGIN

net.Receive("delivery_job", function(len, ply)
    if ply.DeliveryJobCD and ply.DeliveryJobCD > SysTime() then
        ply:notify("You recently resigned from this job! Wait " .. math.floor(ply.DeliveryJobCD - SysTime()) .. " seconds before taking this job on again")

        return
    end

    if ply:Team() == FACTION_CITIZEN then
        local faction = nut.faction.indices[FACTION_DELIVERY]
        ply:getChar().vars.faction = faction.uniqueID
        ply:getChar():setFaction(faction.index)
        ply:notify("You have been hired into Speedy Delivery LTD.")
        net.Start("delivery_job_accepted")
        net.Send(ply)
    else
        ply:notify("You already have a job!")
    end
end)

net.Receive("delivery_resign", function(len, ply)
    if ply:Team() ~= FACTION_DELIVERY then return end
    local faction = nut.faction.indices[FACTION_CITIZEN]
    ply:getChar().vars.faction = faction.uniqueID
    ply:getChar():setFaction(faction.index)

    if IsValid(ply.deliveryTruckEnt) then
        ply.deliveryTruckEnt:Remove()
    end

    if IsValid(ply.DeliveryCrate) then
        ply.DeliveryCrate:Remove()
    end

    ply.DeliveryJobCD = SysTime() + 5
    net.Start("delivery_setwaypoint")
    net.WriteBool(false)
    net.Send(ply)
end)

net.Receive("delivery_truck", function(length, ply)
    if IsValid(ply.deliveryTruckEnt) then
        ply:notify("You already have a Delivery Van taken out.")

        return
    end

    for k, v in pairs(ents.FindInSphere(Vector(-2558.922852, 5311.521973, 7376.031250), 100)) do
        if IsValid(v) and (v:GetClass() == "gmod_sent_vehicle_fphysics_base" or (v:IsPlayer() and v:Alive())) then
            ply:notify("The Delivery Van spawn is being blocked.")

            return
        end
    end

    local _v = simfphys.SpawnVehicleSimple("simfphys_mafia2_shubert_truck_qd", Vector(-2558.922852, 5311.521973, 7376.031250), Angle(0, 90, 0))
    _v:SetNWInt("Owner", ply:EntIndex())
    _v:SetBodygroup(1, 1)
    _v:Lock()

    _v.CPPIGetOwner = function()
        return ply
    end

    _v.DeliveryTruck = true
    _v.DeliveryTruckOwner = ply
    ply.deliveryTruckEnt = _v

    timer.Simple(0.1, function()
        net.Start("delivery_sendtruck_cl")
        net.WriteString("deliveryTruckEnt")
        net.WriteEntity(_v)
        net.Send(ply)
    end)

    ply:notify("You have taken out a Delivery Van.")
end)

net.Receive("delivery_truck_return", function(length, ply)
    local ent = ply.deliveryTruckEnt

    if IsValid(ent) then
        ent:Remove()
        ply:notify("Your Delivery Van has been returned.")
        net.Start("delivery_sendtruck_cl")
        net.WriteString("deliveryTruckEnt")
        net.WriteEntity(NULL)
        net.Send(ply)
    else
        ply:notify("You don't have a Delivery Van taken out.")
    end
end)

net.Receive("delivery_start", function(length, ply)
    if ply.NextNewDelivery and ply.NextNewDelivery > SysTime() then
        ply:notify("You have to wait another " .. math.floor(ply.NextNewDelivery - SysTime()) .. " seconds before starting another delivery.")

        return
    end

    if IsValid(ply.DeliveryCrate) then
        ply:notify("You already have a crate you are delivering.")

        return
    end

    local place = net.ReadString()
    if not PLUGIN.DeliveryNPCLocations[place] then return end
    ply.NextNewDelivery = SysTime() + 205
    local crate = ents.Create("delivery_crate")
    crate.CrateOwner = ply
    crate.Location = place
    crate:SetPos(Vector(-2578.665283, 5012.954590, 7376.031250))
    crate:Spawn()
    ply.DeliveryCrate = crate
    ply:notify("Load the package into your truck and deliver the package to " .. place .. " (Follow the waypoint)")
    ply:ChatPrint("Use /deliver once at the location to drop the package off.")

    timer.Simple(0.1, function()
        net.Start("delivery_sendtruck_cl")
        net.WriteString("DeliveryCrate")
        net.WriteEntity(crate)
        net.Send(ply)
    end)

    net.Start("delivery_setwaypoint")
    net.WriteBool(true)
    net.WriteString(place)
    net.WriteVector(PLUGIN.DeliveryNPCLocations[place].Position)
    net.Send(ply)
end)

net.Receive("delivery_cancel", function(len, ply)
    if IsValid(ply.DeliveryCrate) then
        ply.DeliveryCrate:Remove()
        ply:notify("You've cancelled your delivery. Your boss is disappointed in you.")
    end
end)