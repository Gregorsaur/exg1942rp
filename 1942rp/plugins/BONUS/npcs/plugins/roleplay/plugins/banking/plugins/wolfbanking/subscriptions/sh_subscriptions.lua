local PLAYER = FindMetaTable("Player")
local PLUGIN = PLUGIN
PLUGIN.subscriptions = {}

hook.Run("AddSubscription", PLUGIN.subscriptions)

function GetSubscriptionList()
    return PLUGIN.subscriptions
end

function AddSubscription(id, name, cost, onRun, onCancel)
    PLUGIN.subscriptions[id] = {
        name = name,
        cost = cost,
        onRun = onRun,
        onCancel = onCancel
    }
end

function PLAYER:GetSubscriptions()
    local char = self:getChar()
    
    if char then
        return char:getData("subscriptions", {})
    end
end