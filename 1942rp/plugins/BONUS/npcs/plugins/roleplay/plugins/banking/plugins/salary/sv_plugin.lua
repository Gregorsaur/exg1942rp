local PLUGIN = PLUGIN

------------------------------------------------------------------------------------------------------------------------
function PLUGIN:CreateSalaryTimer(client)
    local character = client:getChar()
    if not character then return end
    local faction = nut.faction.indices[character:getFaction()]
    local class = nut.class.list[character:getClass()]
    local pay = hook.Run("GetSalaryAmount", client, faction, class) or (class and class.pay) or (faction and faction.pay) or 0
    local amount = pay
    if amount == 0 then return end
    character:setData("earnings", character:getData("earnings", 0) + amount)
    local timerID = "nutSalary" .. client:SteamID()
    local timerFunc = timer.Exists(timerID) and timer.Adjust or timer.Create
    local delay = 600

    if DEV then
        delay = 60
    end

    timerFunc(timerID, delay, 0, function()
        if not IsValid(client) or client:getChar() ~= character then
            timer.Remove(timerID)

            return
        end

        if limit and character:getMoney() >= limit then return end
        character:setData("earnings", character:getData("earnings", 0) + amount)
        client:notifyLocalized("salary", nut.currency.get(amount))
    end)
end