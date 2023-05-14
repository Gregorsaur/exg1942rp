local netcalls = {"banker", "netmessage_housing", "collect_paycheck", "open_bank"}

for k, v in pairs(netcalls) do
    util.AddNetworkString(v)
end

-------------------------------------------------------------------------------------------
function PLUGIN:SaveData()
    local data = {}

    for k, v in ipairs(ents.FindByClass("banker")) do
        data[#data + 1] = {
            class = v:GetClass(),
            pos = v:GetPos(),
            angles = v:GetAngles()
        }
    end

    for k, v in ipairs(ents.FindByClass("atm")) do
        data[#data + 1] = {
            class = v:GetClass(),
            pos = v:GetPos(),
            angles = v:GetAngles()
        }
    end

    self:setData(data)
end

-------------------------------------------------------------------------------------------
function PLUGIN:LoadData()
    for k, v in ipairs(self:getData() or {}) do
        local entity = ents.Create(v.class)
        entity:SetPos(v.pos)
        entity:SetAngles(v.angles)
        entity:Spawn()
    end
end

-------------------------------------------------------------------------------------------
net.Receive("netmessage_housing", function()
    local client = net.ReadEntity()
    net.Start("housing_npc")
    net.Send(client)
end)

net.Receive("open_bank", function()
    local client = net.ReadEntity()
    netstream.Start(client, "OpenBankingTeller")
end)