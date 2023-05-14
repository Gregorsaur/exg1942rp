PLUGIN.name = "Usergroup-Based Entity Restriction"
PLUGIN.author = "Calloway#4110"
PLUGIN.desc = "Restricts entities based on your usergroup. Useful for tanks and shit."

-- put usergroups here that you wanna allow to spawn the vehicles.
local UA = {
	["founder"] = true,
	["superadmin"] = true,
	["admin"] = false,
	["junioradmin"] = false,
	["senioradmin"] = false,
	["juniormoderator"] = false,
	["management"] = false,
	["goldvip"] = false,
	["silvervip"] = false,
	["bronzevip"] = false,
	["trusted"] = false,
	["user"] = false,
	["moderator"] = false
}

--[[---------------------------
    RESTRICTED VEHICLE TABLE
]]-----------------------------
local RestrictedVehicles = {
    ["avx_t-34-85"] = true,
    ["sim_fphys_chaos126p"] = true,
    ["sim_fphys_hedgehog"] = true,
    ["sim_fphys_ratmobile"] = true,
    ["sim_fphys_tank2"] = true,
    ["sim_fphys_tank"] = true,
    ["sim_fphys_conscriptapc_armed"] = true,
    ["sim_fphys_combineapc_armed"] = true,
    ["sim_fphys_jeep_armed2"] = true,
    ["sim_fphys_jeep_armed"] = true,
    ["sim_fphys_tank3"] = true,
    ["sim_fphys_v8elite_armed2"] = true,
    ["sim_fphys_v8elite_armed"] = true,
    ["sim_fphys_tank4"] = true,
    ["sim_fphys_couch"] = true,
    ["sim_fphys_dukes"] = true,
    ["sim_fphys_conscriptapc"] = true,
    ["sim_fphys_combineapc"] = true,
    ["sim_fphys_jeep"] = true,
    ["sim_fphys_jalopy"] = true,
    ["sim_fphys_v8elite"] = true,
    ["sim_fphys_van"] = true,
    ["T34rp"] = true,
    ["t34_76rp"] = true,
    ["T34_85rp"] = true,
    ["T34"] = true,
    ["t34_76"] = true,
    ["sdkfz_234"] = true,
    ["ps_sdkfz_251_armed"] = true,
    ["gb_bomb_cbu"] = true,
    ["gb_bomb_1000gp"] = true,
    ["gb_bomb_2000gp"] = true,
    ["gb_bomb_fab250"] = true,
    ["gb_bomb_gbu12"] = true,
    ["gb_bomb_250gp"] = true,
    ["gb_bomb_500gp"] = true,
    ["gb_bomb_gbu38"] = true,
    ["gb_bomb_mk77"] = true,
    ["gb_bomb_mk82"] = true,
    ["gb_bomb_sc100"] = true,
    ["gb_bomb_sc1000"] = true,
    ["gb_bomb_sc250"] = true,
    ["gb_bomb_sc500"] = true,
    ["gb_rocket_hvar"] = true,
    ["gb_rocket_hydra"] = true,
    ["gb_rocket_nebel"] = true,
    ["gb_rocket_rp3"] = true,
    ["gb_rocket_v1"] = true,
    ["gred_ammobox"] = true,
    ["T34_85"] = true
}

--[[-----------------------------------------------------------
    ACTUAL CODE, DO NOT EDIT UNLESS YOU KNOW WHAT YOU'RE DOING
]]-----------------------------------------------------------

hook.Add("PlayerSpawnVehicle", "RestrictVehicles", function(ply, model, name)
    local uniqueID = ply:GetUserGroup()
    if (RestrictedVehicles[name] && !UA[uniqueID]) then
        ply:notifyP("You are not the proper rank to spawn that vehicle. Call Staff to spawn this.")
        return false
    end
end)