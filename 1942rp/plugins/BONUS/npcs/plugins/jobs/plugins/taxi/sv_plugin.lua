local netcalls = {"taxi_job", "taxi_resign", "taxi_take", "taxi_return", "ui_taxi_hired_npc", "ui_taxi_npc", "taxi_sendtruck_cl",}

for k, v in pairs(netcalls) do
    util.AddNetworkString(v)
end

-------------------------------------------------------------------------------------------
function PLUGIN:PlayerDisconnected(ply)
    local ent = ply.taxiEnt

    if IsValid(ent) then
        ent:Remove()
    end

    for k, v in pairs(ents.GetAll()) do
        if v:IsVehicle() and v:GetNWInt("Owner") == ply:EntIndex() and v:GetModel() == "models/left4dead/vehicles/taxi_old.mdl" then
            v:Remove()
        end
    end
end

-------------------------------------------------------------------------------------------
function PLUGIN:SaveData()
    local data = {}

    for k, v in ipairs(ents.FindByClass("npctaxi")) do
        data[#data + 1] = {
            pos = v:GetPos(),
            angles = v:GetAngles()
        }
    end

    self:setData(data)
end

-------------------------------------------------------------------------------------------
function PLUGIN:LoadData()
    for k, v in ipairs(self:getData() or {}) do
        local entity = ents.Create("npctaxi")
        entity:SetPos(v.pos)
        entity:SetAngles(v.angles)
        entity:Spawn()
    end
end