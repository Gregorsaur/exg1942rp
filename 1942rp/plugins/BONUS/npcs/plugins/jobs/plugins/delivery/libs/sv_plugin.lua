function PLUGIN:PlayerEnteredVehicle(ply, veh, role)
    if IsValid(veh.vehiclebase) then
        veh = veh.vehiclebase
    end

    if veh.DeliveryTruck then
        veh:SetBodygroup(1, 0)
    end
end

function PLUGIN:PlayerLeaveVehicle(ply, veh)
    if IsValid(veh.vehiclebase) then
        veh = veh.vehiclebase
    end

    if veh.DeliveryTruck then
        veh:SetBodygroup(1, 1)
    end
end

function PLUGIN:PlayerDisconnected(ply)
    local ent = ply.deliveryTruckEnt

    if IsValid(ent) then
        ent:Remove()
    end

    if IsValid(ply.DeliveryCrate) then
        ply.DeliveryCrate:Remove()
    end
end