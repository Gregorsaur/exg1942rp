local PLUGIN = PLUGIN
local PLAYER = FindMetaTable("Player")

local function checkCanRemoveTimer(ply)
    --Remove the timer if there's no more subscriptions
    local char = ply:getChar()
    if table.Count(ply:GetSubscriptions(), {}) <= 0 then
        char:setData("subTime", nil)
    end
end

function PLAYER:GetSubscriptionTime()
    local char = self:getChar()
    
    if char then
        return char:getData("subTime")
    end
end

function PLAYER:RemSubscription(id)
    local char = self:getChar()
    local subs = self:GetSubscriptions()
    for tid, data in pairs(subs) do
        if tid:find(id) then
            if data.onCancel then
                data.onCancel(self, data)
            end

            subs[id] = nil --Remove it!
            char:setData("subscriptions", subs) --Save it!
            
            local name = PLUGIN.subscriptions[id].name
            self:notify((data.name or id) .. " subscription was removed!") --Bop it!
            break
        end
    end

    checkCanRemoveTimer(self)
end

function PLAYER:AddSubscription(id, data)
    local char = self:getChar()
    local subs = self:GetSubscriptions()
    local sid = id .. os.time()
    if subs[sid] then
        ErrorNoHalt("Tried to add subscription '" .. id .. "' already added\n")
        return
    end

    if not PLUGIN.subscriptions[id] then
        Error("Tried to add subscription '" .. id .. "' doesn't exist.\n")
        return
    end

    if not self:HasBankAccount() then
        self:notify("Failed to add subscription, you do not have a bank account!", NOT_ERROR)
        return false
    end

    local sub = PLUGIN.subscriptions[id]
    if self:BankBal() < sub.cost then
        self:notify("Failed to add subscription, you do not have enough funds to start the subscription", NOT_ERROR)
        return false
    end

    --Adding the ID to the data
    if not data then
        data = {
            id = id
        }
    else
        data.id = id
    end

    --Saving data
    subs[sid] = data
    char:setData("subscriptions", subs)

    --Setting subtime
    local subTime = self:GetSubscriptionTime()
    if not subTime then
        local interval = sub.interval or 86400
        char:setData("subTime", interval)
    end
end

function PLAYER:CollectSubscriptions()
    local char = self:getChar()
    local subs = self:GetSubscriptions()

    for id,data in pairs(self:GetSubscriptions()) do
        local sub = PLUGIN.subscriptions[data.id]

        local bal = self:BankBal()
        if bal >= sub.cost then
            self:SetBankBal(bal - sub.cost)
            self:notify("You just payed " .. nut.currency.get(sub.cost) .. " for your " .. sub.name)
            if sub.onRun then
                sub.onRun(self, sub, data)
            end

            local interval = sub.interval or 86400
            char:setData("subTime", os.time() + interval) --Reset sub time to 1 day
        else
            self:notify("You do not have enough money for your " .. sub.name .. " it has been cancelled.")
            if sub.onCancel then
                sub.onCancel(self, sub)
            end

            --Remove subscription
            subs[id] = nil
            char:setData("subscriptions", subs)

            checkCanRemoveTimer(self)
        end
    end
end

local function checkSubscriptions()
    MsgC(Color(0,255,0), "Checking Subscriptions\n")

    for _,ply in pairs(player.GetAll()) do
        local char = ply:getChar()

        local subs = ply:GetSubscriptions()
        if not subs then return end
        if table.Count(subs) > 0 then --Player has subs
            local time = ply:GetSubscriptionTime() --Checking time
            if time <= os.time() then
                ply:CollectSubscriptions()
            end
        end
    end
end

--Subscription Checker (20 mins)
timer.Create("SubscriptionChecker", 1200, 0, function()
    checkSubscriptions()
end)

--Cool commands
concommand.Add("getsubs", function(ply)
    PrintTable(ply:GetSubscriptions())
end)

concommand.Add("getsubtime", function(ply)
    print(ply:getChar():getData("subTime"))
end)

concommand.Add("skipsubtime", function(ply)
    if ply and not ply:IsAdmin() then return end
    ply:getChar():setData("subTime", CurTime())
    print("Skipped Sub Time")
end)

concommand.Add("checksubs", function(ply)
    if ply and not ply:IsAdmin() then return end
    checkSubscriptions()
end)
