local netcalls = {"import_drugs", "ui_import_npc_drugs", "waypoint_start_drug"}

for k, v in pairs(netcalls) do
    util.AddNetworkString(v)
end

-------------------------------------------------------------------------------------------
function PLUGIN:SaveData()
    local data = {}

    for k, v in ipairs(ents.FindByClass("npc_import_drug")) do
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
        local entity = ents.Create("npc_import_drug")
        entity:SetPos(v.pos)
        entity:SetAngles(v.angles)
        entity:Spawn()
    end
end