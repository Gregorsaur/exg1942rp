local PLUGIN = PLUGIN
PLUGIN.checkSpawnRadius = 90 --Checking distance to see if there's another vehicle near the spot
PLUGIN.sellFraction = 0.30 --30% returned
PLUGIN.defaultGarageSpace = 2

PLUGIN.garageSpacePerRank = {
    ["root"] = 7,
    ["superadmin"] = 7,
    ["communitymanager"] = 7,
    ["headadmin"] = 5,
    ["headgm"] = 5,
    ["senioradmin"] = 5,
    ["admin"] = 2,
    ["moderator"] = 2,
    ["trusted"] = 4,
    ["vip"] = 4,
    ["user"] = 2
}

local carlist = {
    ["Default"] = {
        ["truppenfahrrad"] = 500,
        ["sim_fphys_citroen3"] = 3500,
        ["vw38"] = 4400,
        ["codww2renault"] = 5500,
        ["codww2_cta"] = 6400,
    },
    ["Utility"] = {
        ["codww2opel_civ"] = 3000,
        ["codww2opel_civ_fb"] = 3500,
        ["codww2opel_civ2"] = 3000,
        ["codww2peugeottruck"] = 4000,
    },
    ["Law Enforcement"] = {
        ["sim_fphy_citroenpolizeiRigged"] = 3000,
        ["codww2fiat_orpo"] = 4500,
    },
    ["Military & Government"] = {
        ["codww2kubel"] = 3500,
        ["codww2kubel2"] = 4200,
        ["sim_fphys_r75ww2tf"] = 5500,
        ["sim_fphy_codww2opel"] = 6000,
        ["simfphys_cbww2_opelomnibus"] = 8500,
    },
    ["VIP"] = {
        ["simfphys_cbww2_simca5"] = 3900,
        ["codww2opelkadett"] = 5400,
        ["indian"] = 6200,
        ["sim_fphys_w150"] = 7500,
        ["sim_fphys_citroenvan"] = 18800,
    }
}

-- Generate a category lookup table
local categoryLookup = {}

for category, vehicleList in pairs(carlist) do
    for vehicle, _ in pairs(vehicleList) do
        categoryLookup[vehicle] = category
    end
end

local categoryRestrictions = {
    ["Military & Government"] = {
        faction = {FACTION_WK3, FACTION_STAFF, FACTION_RSHA, FACTION_OKW, FACTION_OKM, FACTION_OKL, FACTION_LSSAH, FACTION_ALLG}
    },
    ["Law Enforcement"] = {
        faction = {FACTION_ORPO}
    },
    ["VIP"] = {
        group = {"vip", "moderator", "administrator", "senioradmin", "headgm", "headadmin", "communitymanager", "superadmin", "root"}
    }
}

PLUGIN.subscriptionForGroup = {
    carInsuranceVIP = {"vip", "moderator", "administrator", "senioradmin", "headgm", "headadmin", "communitymanager", "superadmin", "root"}
}

PLUGIN.carList = carlist
PLUGIN.categoryLookup = categoryLookup
PLUGIN.categoryRestrictions = categoryRestrictions