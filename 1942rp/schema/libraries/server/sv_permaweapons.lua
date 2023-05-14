if not SERVER then return end

--Weapons
local donatorPermaWeps = {
    ["76561198090105626"] = {"weaponid"},
    ["steamid64"] = {"weaponid", "", "", ""},
}

local function checkWeapons(ply)
    local weps = donatorPermaWeps[ply:SteamID64()] or {}

    for _, wep in ipairs(weps) do
        ply:Give(wep)
    end

    return #weps > 0
end

hook.Add("PlayerLoadout", "mafiarp.donator.loadouts", function(ply)
    checkWeapons(ply)
end)

nut.command.add("claimweapons", {
    syntax = "",
    onRun = function(client, args)
        client:notify(Either(checkWeps(client), "There you go. Thanks for donating!", "There's no weapons to claim :("))
    end
})