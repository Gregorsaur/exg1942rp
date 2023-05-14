local PLUGIN = PLUGIN

function PLUGIN:PostPlayerLoadout(ply)
    local uniqueID = ply:GetUserGroup()

    if UserGroups.StaffRanks[uniqueID] and ply:Team() == FACTION_STAFF then
        ply:Give("adminstick")
    elseif UserGroups.superRanks[uniqueID] then
        ply:Give("adminstick")
    end
end