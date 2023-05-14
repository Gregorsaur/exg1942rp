net.Receive("taxi_job", function(len, ply)
    if ply:Team() == FACTION_CITIZEN then
        local faction = nut.faction.indices[FACTION_TAXI]
        ply:getChar().vars.faction = faction.uniqueID
        ply:getChar():setFaction(faction.index)
        ply:notify("You have been hired into Berlin Taxis.")
    else
        ply:notify("You already have a job!")
    end
end)

-------------------------------------------------------------------------------------------
net.Receive("taxi_resign", function(len, ply)
    if ply:Team() ~= FACTION_TAXI then return end
    local faction = nut.faction.indices[FACTION_CITIZEN]
    ply:getChar().vars.faction = faction.uniqueID
    ply:getChar():setFaction(faction.index)
end)

-------------------------------------------------------------------------------------------
net.Receive("taxi_take", function(length, ply)
    if IsValid(ply.taxiEnt) then
        ply:notify("You already have a Taxi out.")

        return
    end

    for k, v in pairs(ents.FindInSphere(Vector(-2728.754639, 6359.442383, 7368.031250), 150)) do
        if IsValid(v) and (v:GetClass() == "gmod_sent_vehicle_fphysics_base" or (v:IsPlayer() and v:Alive())) then
            ply:notify("The Taxi Cab spawn is being blocked.")

            return
        end
    end

    local _v = simfphys.SpawnVehicleSimple("simfphys_mafia2_shubert_taxi", Vector(-2728.754639, 6359.442383, 7368.031250), Angle(0, 90, 0))
    _v:SetNWInt("Owner", ply:EntIndex())
    _v:SetSkin(1)
    _v:Lock()

    _v.CPPIGetOwner = function()
        return ply
    end

    _v.taxi = true
    ply.taxiEnt = _v
    print(_v)

    timer.Simple(0.1, function()
        net.Start("taxi_sendtruck_cl")
        net.WriteEntity(_v)
        net.Send(ply)
    end)

    ply:notify("You have taken out a Taxi")
end)

-------------------------------------------------------------------------------------------
net.Receive("taxi_return", function(length, ply)
    local ent = ply.taxiEnt

    if IsValid(ent) then
        ent:Remove()
        ply:notify("Your Taxi has been returned.")
        net.Start("taxi_sendtruck_cl")
        net.WriteEntity(NULL)
        net.Send(ply)
    else
        ply:notify("You don't have a Taxi taken out.")
    end
end)