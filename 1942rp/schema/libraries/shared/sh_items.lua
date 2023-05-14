nsitem = nsitem or {}
nsitem.register = nsitem.register or {}
nsitem.register = nsitem.register.weapons or {}

nsitem.register.misc = {
    ["flashlight"] = {
        ["name"] = "Flashlight",
        ["desc"] = "A regular flashlight with batteries included.",
        ["model"] = "models/maxofs2d/lamp_flashlight.mdl",
        ["width"] = 1,
        ["height"] = 1,
        ["price"] = 0,
    },
    ["letter"] = {
        ["name"] = "Letter",
        ["desc"] = "Write some letters.",
        ["model"] = "models/props_c17/BriefCase001a.mdl",
        ["width"] = 1,
        ["height"] = 1,
        ["price"] = 0,
    },
    ["stamps"] = {
        ["name"] = "Stamps",
        ["desc"] = "Write some letters.",
        ["model"] = "models/props_c17/BriefCase001a.mdl",
        ["width"] = 1,
        ["height"] = 1,
        ["price"] = 0,
    },
    ["tobbaco"] = {
        ["name"] = "Tobbaco Leaves",
        ["desc"] = "Tobbaco Leaves",
        ["model"] = "models/props_c17/BriefCase001a.mdl",
        ["width"] = 1,
        ["height"] = 1,
        ["price"] = 0,
    },
    ["paper_tobbaco"] = {
        ["name"] = "Tobbaco Paper",
        ["desc"] = "Tobbaco Paper",
        ["model"] = "models/props_c17/BriefCase001a.mdl",
        ["width"] = 1,
        ["height"] = 1,
        ["price"] = 0,
    },
    ["grapes"] = {
        ["name"] = "Wine Grapes",
        ["desc"] = "Wine Grapes",
        ["model"] = "models/props_c17/BriefCase001a.mdl",
        ["width"] = 1,
        ["height"] = 1,
        ["price"] = 0,
    },
    ["tobbacoleaves"] = {
        ["name"] = "Tobbaco Leaves",
        ["desc"] = "Tobbaco Leaves",
        ["model"] = "models/props_c17/BriefCase001a.mdl",
        ["width"] = 1,
        ["height"] = 1,
        ["price"] = 0,
    },
    ["uniqueid"] = {
        ["name"] = "Name of Item",
        ["desc"] = "Description of Item",
        ["model"] = "models/props_c17/BriefCase001a.mdl",
        ["width"] = 1,
        ["height"] = 1,
        ["price"] = 0,
    },
}

nsitem.register.weapons = {}
--[[["drc_ma37_c"] = {
        ["name"] = "Ma37",
        ["desc"] = "Ma37.",
        ["model"] = "models/props_c17/BriefCase001a.mdl",
        ["class"] = "drc_ma37_c",
        ["width"] = 1,
        ["height"] = 1,
        ["price"] = 2,
    },
    ["drc_ma37_c"] = {
        ["name"] = "Ma37",
        ["desc"] = "Ma37",
        ["model"] = "models/props_c17/BriefCase001a.mdl",
        ["class"] = "drc_ma37_c",
        ["width"] = 1,
        ["height"] = 1,
        ["price"] = 2,
    },]]
nsitem.register.entities = {}
--[[["vb02ua"] = {
        ["name"] = "VB-02 Un-Armed",
        ["desc"] = "microfusion cell",
        ["model"] = "models/halokiller38/fallout/weapons/explosives/cryogrenade.mdl",
        ["entity"] = "lfs_vertibird",
        ["width"] = 1,
        ["height"] = 1,
        ["price"] = 10,
    },]]
nsitem.register.ammo = {}

--[[
    ["carrotseeds"] = {
        ["name"] = "(S) Carrot Seeds",
        ["desc"] = "Carrot Seeds",
        ["model"] = "models/mosi/fnv/props/health/healingpowder.mdl",
        ["ammo"] = "ch_farming_seed_carrot",
        ["width"] = 1,
        ["height"] = 1,
        ["price"] = 2,
    },]]
function SCHEMA:InitializedPlugins()
    for i, v in pairs(nsitem.register) do
        if (i == "weapons") then
            for x, y in pairs(v) do
                SCHEMA:registerWeapon(x, y, i)
            end
        elseif (i == "entities" or i == "ammo") then
            for x, y in pairs(v) do
                SCHEMA:registerEnts(x, y)
            end
        else
            for x, y in pairs(v) do
                SCHEMA:registerItem(x, y, i)
            end
        end
    end
end

function SCHEMA:registerEnts(id, data, base)
    local ITEM = nut.item.register(id, "base_ents", nil, nil, true)
    ITEM.name = data["name"]
    ITEM.desc = data["desc"] or ITEM.name
    ITEM.model = data["model"] or "models/fallout/components/box.mdl"
    ITEM.price = data["price"]
    ITEM.width = data["width"] or 1
    ITEM.height = data["height"] or 1
    ITEM.entdrop = data["entity"] or data["ammo"]
end

function SCHEMA:registerWeapon(id, data, category)
    local ITEM = nut.item.register(id, "base_weapons", nil, nil, true)
    ITEM.name = data["name"]
    ITEM.desc = data["desc"]
    ITEM.model = data["model"]
    ITEM.class = data["class"]
    ITEM.width = data["width"] or 2
    ITEM.price = data["price"]
    ITEM.height = data["height"] or 2
end

function SCHEMA:registerItem(id, data, base)
    local ITEM = nut.item.register(id, "base_junk", nil, nil, true)
    ITEM.name = data["name"]
    ITEM.desc = data["desc"] or ITEM.name
    ITEM.model = data["model"] or "models/fallout/components/box.mdl"
    ITEM.price = data["price"]
    ITEM.width = data["width"] or 1
    ITEM.height = data["height"] or 1
end