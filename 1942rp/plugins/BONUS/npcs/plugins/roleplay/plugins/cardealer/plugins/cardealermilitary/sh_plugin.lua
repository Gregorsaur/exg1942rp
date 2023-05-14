local PLUGIN = PLUGIN
local PLUGIN = PLUGIN
PLUGIN.name = "Car Vendor Military Sub-Module"
PLUGIN.author = "Leonheart#7476"
PLUGIN.desc = "A Car vendor to facilitate the sell of vehicles"
nut.util.include("sh_config.lua")
nut.util.include("sv_plugin.lua")

function PLUGIN:CanShowCars(cat, rest, ply)
    if CLIENT then
        ply = LocalPlayer()
    end

    if rest.faction then
        if istable(rest.faction) then
            for k, v in pairs(rest.faction) do
                if ply:Team() == v then return true end
            end

            return false
        else
            return ply:Team() == rest.faction
        end
    end

    if rest.group then
        if istable(rest.group) then
            for k, v in pairs(rest.group) do
                if ply:IsUserGroup(v) then return true end
            end

            return false
        else
            return ply:IsUserGroup(rest.group)
        end
    end

    return true
end

function PLUGIN:GetVehiclePrice(class)
    for car, l in pairs(self.carList) do
        for cl, price in pairs(l) do
            if cl == class then return price end
        end
    end

    return nil
end

function PLUGIN:PlayerHasInsurance(ply, class)
    local subs = ply:GetSubscriptions()

    for id, data in pairs(subs) do
        if id:find("carInsurance") then
            if data.class and data.class == class then return true end
        end
    end

    return false
end

--Register car insurance subscription
function PLUGIN:GetInsurancePrice(ply)
    if CLIENT then
        netstream.Start("PlayerGetInsurancePrice")
    end

    local subs = GetSubscriptionList()
    --Getting sub index
    local si = "carInsurance"

    for k, v in pairs(self.subscriptionForGroup) do
        if ply:IsUserGroup(v) then
            si = k
        end
    end

    --Getting price
    local price = subs[si].cost

    return price
end

netstream.Hook("PlayerGetInsurancePrice", function(ply)
    local price = PLUGIN:GetInsurancePrice(ply)
    netstream.Start(ply, "ReturnInsurancePrice", price)
end)

--Adding insurance
hook.Add("AddSubscription", "AddingCarInsuranceSub", function(subs)
    subs["carInsurance"] = {
        name = "Car Insurance",
        cost = 380
    }

    subs["carInsuranceVIP"] = {
        name = "Car Insurance (VIP)",
        cost = 100
    }
end)

--Vehicle Data
function PLUGIN:SetVehicleData(ply, class, index, data)
    local char = ply:getChar()
    local ov = char:getData("ownedvehicles", {})

    if not ov[class] then
        ErrorNoHalt("Trying to write vehicle data on un-owned vehicle class '" .. class .. "'\n")

        return
    end

    ov[class][index] = data
    char:setData("ownedvehicles", ov)
end

function PLUGIN:GetVehicleData(ply, class, index)
    local char = ply:getChar()
    local ov = char:getData("ownedvehicles", {})

    if not ov[class] then
        ErrorNoHalt("Trying to get data on un-owned vehicle class '" .. class .. "'\n")

        return
    end

    return ov[class][index] or nil
end

--VIP Garage Command
local garageVIPGroups = {"superadmin", "vip"}

function PLUGIN:GetRemoteCarSpawnPos(ply)
    local spawnPos = (ply:GetPos() + ply:GetForward() * 200) + Vector(0, 0, 10)
    local spawnAng = ply:GetAngles()

    return spawnPos, spawnAng
end