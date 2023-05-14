local PLAYER = FindMetaTable("Player")

function PLAYER:SetOwnedVehicles(tbl)
    self:getChar():setData("ownedvehicles", tbl)
end

function PLAYER:PurchaseVehicle(class, color)
    local char = self:getChar()

    if char then
        local owned = self:GetOwnedVehicles()

        owned[class] = {
            color = color
        }

        self:SetOwnedVehicles(owned)
    end
end

function PLAYER:OwnsVehicle(class)
    local char = self:getChar()

    if char then
        local owned = self:GetOwnedVehicles()
        if owned[class] then return true end
    end

    return false
end

function PLAYER:SellVehicle(class)
    local char = self:getChar()

    if char then
        local owned = self:GetOwnedVehicles()
        owned[class] = nil --Remove it!
        self:SetOwnedVehicles(owned)
    end
end