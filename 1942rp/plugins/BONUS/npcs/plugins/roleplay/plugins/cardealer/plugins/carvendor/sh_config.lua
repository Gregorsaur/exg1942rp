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

PLUGIN.subscriptionForGroup = {
    carInsuranceVIP = {"vip", "moderator", "administrator", "senioradmin", "headgm", "headadmin", "communitymanager", "superadmin", "root"}
}

PLUGIN.carList = {
    ["Default"] = {
        ["simfphys_mafia2_JefProv"] = 5,
        ["simfphys_mafia2_lassiter_69"] = 5,
        ["simfphys_mafia2_trautenberg_grande"] = 5,
        ["simfphys_mafia2_ulver_newyorker"] = 5,
        ["simfphys_mafia2_shubert_elysium"] = 5,
        ["simfphys_mafia2_delizia_grandeamerica"] = 5,
        ["simfphys_mafia2_waybar"] = 5,
        ["simfphys_mafia2_isw_508"] = 5,
    },
    ["Law Enforcement"] = {
        ["simfphys_mafia2_ulver_newyorker_p"] = 5,
        ["simfphys_mafia2_smith_200_p_pha"] = 5,
    },
    ["VIP"] = {
        ["simfphys_mafia2_JefProv"] = 5,
        ["simfphys_mafia2_lassiter_69"] = 5,
        ["simfphys_mafia2_trautenberg_grande"] = 5,
        ["simfphys_mafia2_ulver_newyorker"] = 5,
        ["simfphys_mafia2_shubert_elysium"] = 5,
        ["simfphys_mafia2_delizia_grandeamerica"] = 5,
        ["simfphys_mafia2_waybar"] = 5,
        ["simfphys_mafia2_isw_508"] = 5,
    }
}

PLUGIN.categoryLookup = {}

for category, vehicleList in pairs(PLUGIN.carList) do
    for vehicle, _ in pairs(vehicleList) do
        PLUGIN.categoryLookup[vehicle] = category
    end
end

PLUGIN.categoryRestrictions = {
    ["Law Enforcement"] = {
        faction = {FACTION_NYPD, FACTION_STAFF}
    },
    ["VIP"] = {
        group = {"vip", "moderator", "administrator", "senioradmin", "headgm", "headadmin", "communitymanager", "superadmin", "root"}
    }
}