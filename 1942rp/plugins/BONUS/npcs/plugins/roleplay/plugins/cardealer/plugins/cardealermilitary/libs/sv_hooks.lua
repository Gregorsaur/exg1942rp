local PLUGIN = PLUGIN

--Spawn/Dismiss
netstream.Hook("PlayerSpawnVehicle", function(ply, vehicle, valet, vData)
    PLUGIN:SpawnCar(ply, vehicle, valet, vData)
end)

netstream.Hook("PlayerSpawnRemoteVehicle", function(ply, vehicle, vData)
    PLUGIN:SpawnRemoteCar(ply, vehicle, vData)
end)

netstream.Hook("PlayerDismissVehicle", function(ply, ent)
    if ent:CPPIGetOwner() == ply then
        ent:Remove()
        ply:notify("Your vehicle has been dismissed", NOT_CORRECT)
    end
end)

--Buy/Sell
netstream.Hook("PlayerSellVehicle", function(ply, class, carName)
    if not class then return end
    local char = ply:getChar()
    if not ply:OwnsVehicle(class) then return end -- We don't own this vehicle.
    -- Ignore the price send by the player -- fixes money exploit. Robert learn to NEVER trust the client!
    local price = PLUGIN:GetVehiclePrice(class) * PLUGIN.sellFraction
    --Giving back money
    char:giveMoney(price)
    --Removing from owned vehicles
    ply:SellVehicle(class)
    -- Unsubscribe from insurance
    local subs = ply:GetSubscriptions()

    for id, data in pairs(subs) do
        if data and data.class and data.class == class then
            subs[id] = nil
        end
    end

    ply:getChar():setData("subscriptions", subs)
    --Notifying
    ply:notify("You just received " .. nut.currency.get(price) .. " for selling your " .. carName)
end)

netstream.Hook("PlayerBuyVehicle", function(ply, cat, class, color)
    -- Rewritten since there was no serverside checks what so ever.
    local char = ply:getChar()
    if not char then return end
    local catl = PLUGIN.categoryLookup[class]
    if not catl then return end -- The car is not in any category, probs modified in.
    local restrictions = PLUGIN.categoryRestrictions[cat]
    if restrictions and not PLUGIN:CanShowCars(nil, restrictions, ply) then return end
    local clist = PLUGIN.carList[cat]
    if not clist then return end
    local price = clist[class]
    if not price then return end

    if not char:hasMoney(price) then
        ply:notify("Not enough funds!", NOT_ERROR)

        return
    end

    if table.Count(ply:GetOwnedVehicles()) >= ply:GetGarageSpace() then
        ply:notify("You don't anymore space in your garage!", NOT_ERROR)

        return
    end

    ply:PurchaseVehicle(class, color)
    --Take Money
    char:takeMoney(price)
    local vlist = list.Get("simfphys_vehicles")
    ply:notify("You just bought " .. vlist[class].Name .. " for " .. nut.currency.get(price) .. "!")
end)

--Insurance hooks
netstream.Hook("PlayerBuyInsurance", function(ply, class)
    ply:AddSubscription("carInsurance", {
        class = class
    })
end)

netstream.Hook("PlayerCancelInsurance", function(ply, class)
    local subs = ply:GetSubscriptions()

    for id, data in pairs(subs) do
        if data and data.class and data.class == class then
            subs[id] = nil
        end
    end

    ply:getChar():setData("subscriptions", subs)
end)

netstream.Hook("PlayerUpdateEntityData", function(ply, ent, payload)
    if not ply:IsAdmin() then return end
    local data = PLUGIN:getData()

    for k, v in pairs(payload) do
        ent[k] = v or nil
        data[ent.id][k] = v
    end

    PLUGIN:setData(data)
    ply:notify("The configuration was saved, will take effect next time you open the menu!", NOT_CORRECT)
end)

--Remove on disconnect
hook.Add("PlayerDisconnected", "RemovedSpawnedVehicleOnDisconnect", function(ply)
    local sv = ply:GetNWEntity("spawnedVehicle", nil)

    if sv and IsValid(sv) then
        sv:Remove()
    end
end)

--Permaprops things
function PLUGIN:Register(ent)
    if ent.id then return end --Already registered
    local data = self:getData() or {}
    --Adding entity
    local id = #data + 1

    data[id] = {
        class = ent:GetClass(),
        pos = ent:GetPos(),
        ang = ent:GetAngles(),
        category = ent.category or {},
        faction = ent.faction or nil
    }

    --Saving it to plugin data
    self:setData(data)
    ent.id = id
end

function PLUGIN:UnRegister(ent)
    if not ent.id then return end
    --Removing the ent
    local data = self:getData()
    data[ent.id] = nil
    self:setData(data) --Saving
end

function PLUGIN:LoadData()
    local data = self:getData()

    for k, v in pairs(data) do
        local ven = ents.Create(v.class or "carvendor")
        ven.id = k
        ven:SetPos(v.pos)
        ven:SetAngles(v.ang)
        ven.category = v.category or {}
        ven.faction = v.faction or nil
        ven.spawnpoints = v.spawnpoints or nil
        ven:Spawn()
    end
end

function PLUGIN:VendorGetData(ent)
    local data = {
        category = ent.category or {},
        faction = ent.faction or nil,
        spawnpoints = ent.spawnpoints or {}
    }

    return data
end

--[[SPAWN CAR]]
local function canSpawnAtLocation(pos, ang)
    local wrongClasses = {"gmod_sent_vehicle_fphysics_gib"}

    local nearby = ents.FindInSphere(pos, PLUGIN.checkSpawnRadius)

    for _, e in pairs(nearby) do
        if e:IsVehicle() or e:IsPlayer() then return false end
    end

    return true
end

local function spawnCar(ply, class, pos, ang, data)
    if not ply:OwnsVehicle(class) then return end
    if data.destroyed and data.destroyed - os.time() > 0 then return end -- Car is destroyed don't spawn.
    if data.impounded then return end -- Car is impounded don't spawn.
    local veh = simfphys.SpawnVehicleSimple(class, pos, ang)

    if not veh then
        ply:notify("Failed to spawn your car, Could not create entity.")

        return
    end

    veh:SetNWEntity("owner", ply) --Setting owner
    veh:Lock()

    veh:CallOnRemove("RemovePlayerVehEnt", function(ent)
        local owner = ent:GetNWEntity("owner", nil)

        if owner then
            owner:SetNWEntity("spawnedVehicle", nil) --Removing NW Variable
        end
    end)

    ply:SetNWEntity("spawnedVehicle", veh) --Assign the player's vehicle

    -- Euugghh police fix.
    if class == "sim_fphys_dod_monaco_pol" then
        veh:SetSkin(11)
    end

    --Setting owned (For Nutscript)
    function veh:CPPIGetOwner()
        return self:GetNWEntity("owner", nil)
    end

    veh.OnDestroyed = function(ent)
        local owner = ent:CPPIGetOwner()
        local class = ent:GetSpawn_List()
        -- Return if the car is from a goverment thing.
        if class == "sim_fphys_ats_pierce_arrow" or class == "sim_fphys_dod_monaco_pol" or class == "sim_fphys_dod_monaco" or class == "sim_fphys_ford_f350_amb" then return end
        --Check if player has insurance for vehicle
        local hasInsurance = PLUGIN:PlayerHasInsurance(owner, class)

        if hasInsurance then
            PLUGIN:SetVehicleData(owner, class, "destroyed", os.time() + 900) -- 15 minutes not-spawnable.
            owner:notify("Your vehicle was destroyed! It was returned to your garage.")

            return
        elseif owner:getChar():hasMoney(500) then
            owner:getChar():takeMoney(500)
            PLUGIN:SetVehicleData(owner, class, "destroyed", os.time() + 900)
            owner:notify("Your vehicle was destroyed! You paid the fee and it was returned to your garage.")
        else
            PLUGIN:SetVehicleData(owner, class, "destroyed", os.time() + 60 * 60)
            owner:notify("Your vehicle was destroyed! Since you have no money and no insurance, you'll have to wait one hour to retrieve your car from the garage.")
        end
    end

    if data.color then
        veh:SetColor(data.color)
    end
end

function PLUGIN:SpawnCar(ply, class, valet, vData)
    if IsValid(ply:GetNWEntity("spawnedVehicle", nil)) then return end
    local spawnpoints = valet.spawnpoints

    --There's no spawnpoints
    if not spawnpoints or table.Count(spawnpoints) <= 0 then
        ply:notify("There was an error spawning your car :( [No Spawnpoints]", NOT_ERROR)

        return
    end

    --Finding a spawnpoint for the vehicle
    for _, v in pairs(spawnpoints) do
        local pos, ang = v.pos, v.ang
        ang = ang + Angle(0, -90, 0)
        local canSpawn = canSpawnAtLocation(pos, ang)

        if canSpawn then
            spawnCar(ply, class, pos, ang, vData)

            return
        end
    end

    ply:notify("We could not find a spot to spawn your vehicle", NOT_ERROR)
end

function PLUGIN:SpawnRemoteCar(ply, class, vData)
    if IsValid(ply:GetNWEntity("spawnedVehicle", nil)) then return end
    --Finding good pos
    local spawnPos, spawnAng = PLUGIN:GetRemoteCarSpawnPos(ply)
    --Checking if spawn is clear
    local se = ents.FindInSphere(spawnPos, 50)

    for _, e in pairs(se) do
        if e ~= ply and e:IsPlayer() or e:IsVehicle() then
            print(e)
            ply:notify("Spawn isn't safe!", NOT_ERROR)

            return
        end
    end

    spawnCar(ply, class, spawnPos, spawnAng, vData)
end