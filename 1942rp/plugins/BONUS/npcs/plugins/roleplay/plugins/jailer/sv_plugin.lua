-------------------------------------------------------------------------------------------
local psaString = [[
/*------------------------------------------------------------
IMPORTANT PSA: TYING PLUGIN IS NEEDED FOR THIS SCRIPT TO WORK!

PLEASE GET HIM AT:
> https://github.com/ts-co/Metro-2033/tree/master/plugins/tying

> ASK Leonheart#7476 ABOUT THE CUSTOM VERSION
                               -Nutscript Development Team
*/------------------------------------------------------------]]

function PLUGIN:InitializedPlugins()
    if not nut.plugin.list.tying then
        MsgC(Color(255, 0, 0), psaString .. "\n")
    end
end

-------------------------------------------------------------------------------------------
local netcalls = {"jailer_npc", "set_player_prisioner_arrest", "arrest_player", "release_player", "set_player_prisioner_release",}

for k, v in pairs(netcalls) do
    util.AddNetworkString(v)
end

-------------------------------------------------------------------------------------------
function PLUGIN:SaveData()
    local data = {}

    for k, v in ipairs(ents.FindByClass("jailer_npc")) do
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
        local entity = ents.Create("jailer_npc")
        entity:SetPos(v.pos)
        entity:SetAngles(v.angles)
        entity:Spawn()
    end
end