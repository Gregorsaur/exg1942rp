local PLUGIN = PLUGIN
local PLAYER = FindMetaTable("Player")

function PLAYER:GetGarageSpace()
    for k, v in pairs(PLUGIN.garageSpacePerRank) do
        if self:IsUserGroup(k) then return v end
    end

    return PLUGIN.defaultGarageSpace
end

function PLAYER:GetOwnedVehicles()
    local char = self:getChar()
    if char then return char:getData("ownedvehicles", {}) end
end