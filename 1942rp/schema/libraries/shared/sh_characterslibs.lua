nut.flag.add("F", "Finance Flag")
nut.flag.add("O", "Faction Brodcast Flag")
nut.flag.add("u", "Banned from OOC")
ALWAYS_RAISED["cross_arms_swep"] = true
ALWAYS_RAISED["cross_arms_infront_swep"] = true
ALWAYS_RAISED["weapon_cuff_elastic"] = true
ALWAYS_RAISED["voice_amplifier"] = true
ALWAYS_RAISED["weapon_medkit"] = true
ALWAYS_RAISED["pensive_swep"] = true
ALWAYS_RAISED["sswep_trenchwhistle"] = true
ALWAYS_RAISED["weapon_ciga"] = true
ALWAYS_RAISED["fishing_rod"] = true
ALWAYS_RAISED["garde_a_vousv1.1"] = true
ALWAYS_RAISED["weapon_ciga"] = true
ALWAYS_RAISED["fishing_rod"] = true
ALWAYS_RAISED["garde_a_vousv1.1"] = true
ALWAYS_RAISED["fas2_ifak"] = true
ALWAYS_RAISED["doi_atow_mp40"] = true
ALWAYS_RAISED["doi_atow_mg42"] = true
ALWAYS_RAISED["doi_atow_m1912"] = true
ALWAYS_RAISED["doi_atow_sw1917"] = true
ALWAYS_RAISED["doi_atow_webley"] = true
ALWAYS_RAISED["doi_atow_p08"] = true
ALWAYS_RAISED["doi_atow_p38"] = true
ALWAYS_RAISED["doi_atow_m1911a1"] = true
ALWAYS_RAISED["doi_atow_mg34"] = true
ALWAYS_RAISED["doi_atow_k98k"] = true
ALWAYS_RAISED["doi_atow_g43"] = true
ALWAYS_RAISED["doi_atow_bayonetde"] = true
ALWAYS_RAISED["doi_atow_m3greasegun"] = true
ALWAYS_RAISED["doi_atow_m1903a3"] = true
ALWAYS_RAISED["doi_atow_m1garand"] = true
ALWAYS_RAISED["cw_mr96"] = true
ALWAYS_RAISED["cross_arms_infront_swep"] = true
ALWAYS_RAISED["cross_arms_swep"] = true
hook.Remove("PlayerInitialSpawn", "VJBaseSpawn")

-------------------------------------------------------------------------------------------------------------------------
local isStaff = {
    owner = true,
    communitymanager = true,
    superadmin = true,
    senioradmin = true,
    admin = true,
    moderator = true,
    developer = true,
}

-------------------------------------------------------------------------------------------------------------------------
local isVip = {
    owner = true,
    communitymanager = true,
    superadmin = true,
    senioradmin = true,
    admin = true,
    moderator = true,
    developer = true,
    vip = true,
    vipplus = true
}

-------------------------------------------------------------------------------------------------------------------------
function SCHEMA:CanDeleteChar(ply, char)
    if char:getMoney() < nut.config.get("defMoney", 0) then return true end
end

-------------------------------------------------------------------------------------------------------------------------
function SCHEMA:PlayerSwitchFlashlight(ply, on)
    if not ply:getChar() then return end

    if ply:getChar():getInv():hasItem("flashlight") then
        return true
    else
        return false
    end
end

-------------------------------------------------------------------------------------------------------------------------
function SCHEMA:PlayerSpray(client)
    return true
end

-------------------------------------------------------------------------------------------------------------------------
function SCHEMA:GetGameDescription()
    return "WW2RP"
end

-------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerNoClip", "nsClippyClip", function(player, state)
    if (player:IsAdmin()) then
        if (state) then
            player:SetNoDraw(true)
            player:DrawShadow(false)
            player:SetNotSolid(true)
        else
            player:SetNoDraw(false)
            player:DrawShadow(true)
            player:SetNotSolid(false)
        end
    elseif player:getChar():getFaction() == FACTION_STAFF then
        if (state) then
            player:SetNoDraw(true)
            player:DrawShadow(false)
            player:SetNotSolid(true)
        else
            player:SetNoDraw(false)
            player:DrawShadow(false)
            player:SetNotSolid(false)
        end

        return true
    else
        return false
    end
end)

-------------------------------------------------------------------------------------------------------------------------
function SCHEMA:CanPlayerSpawnStorage(client)
    if client:IsSuperAdmin() or client:IsAdmin() then
        return true
    else
        return false
    end
end

------------------------------------------------------------------------------------------------------------------------
hook.Add("SCHEMA:PlayerLoadedChar", "StaffGod", function(client, character, lastChar)
    if not character:getInv():hasItem("citizenid") then
        character:getInv():add("citizenid")
    else
        return
    end

    if client:Team() == FACTION_STAFF then
        client:GodEnable()
    else
        client:GodDisable()
    end

    if client:Team() == FACTION_STAFF and not isStaff[client:GetUserGroup()] then
        client:getChar():kick()
        client:notify("You cannot access a staff character unless you are a staff member!")
    end

    if isVip[client:GetUserGroup()] and not client:getChar():hasFlags("pet") then
        client:getChar():giveFlags("pet")
    end
end)

------------------------------------------------------------------------------------------------------------------------
function SCHEMA:CanPlayerDropItem(client, item)
    if (item.uniqueID == "citizenid") then
        return false
    else
        return true
    end
end

------------------------------------------------------------------------------------------------------------------------
function SCHEMA:OnCharCreated(client, character)
    timer.Simple(5, function()
        client:SendLua([[gui.OpenURL("https://discord.gg/externalgaming")]])
    end)
end

------------------------------------------------------------------------------------------------------------------------
function SCHEMA:OnWeaponEquipped(client, equip)
    client:notify("You have equipped your" .. ITEM.name .. ".")
end

------------------------------------------------------------------------------------------------------------------------
function SCHEMA:OnItemDropped(client)
    client:notify("You have dropped your" .. ITEM.name .. ".")
end

------------------------------------------------------------------------------------------------------------------------
function SCHEMA:ShouldCollide(f, t)
    if f:GetClass() == "nut_item" and t:GetClass() == "nut_item" then return false end
end

------------------------------------------------------------------------------------------------------------------------
hook.Add("CheckValidSit", "noVehSit", function(ply, trace)
    local ent = trace.Entity
    if ent:IsVehicle() then return false end
end)

------------------------------------------------------------------------------------------------------------------------
function SCHEMA:EntityTakeDamage(target, dmginfo)
    if (target:IsPlayer()) then
        local inflictor = dmginfo:GetInflictor()

        if (IsValid(inflictor) and (inflictor:GetClass() == "gmod_sent_vehicle_fphysics_base" or inflictor:GetClass() == "gmod_sent_vehicle_fphysics_wheel")) then
            if (not IsValid(target:GetVehicle())) then
                dmginfo:ScaleDamage(0)

                if (not IsValid(target.nutRagdoll)) then
                    target:setRagdolled(true, 5)
                end
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------------------
