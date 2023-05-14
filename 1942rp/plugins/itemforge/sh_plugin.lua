PLUGIN.name = "Item Maker"
PLUGIN.author = "Barata"
PLUGIN.desc = "Allows creating custom items in-game // Stop Begging Snoopi <3"
NSForgedItems = NSForgedItems or {}
NSForgedItems.List = NSForgedItems.List or {}
nut.util.include("sv_plugin.lua")
nut.util.include("cl_plugin.lua")
nut.util.include("cl_commands.lua")

function NSForgedItems.RegisterCustomItem(id, itemData)
    if (not id) then return end
    local ITEM = nut.item.register(id, nil, false, nil, true)

    if (ITEM) then
        for k, v in pairs(itemData) do
            ITEM[k] = v
        end

        if (itemData.restore) then
            ITEM.functions.Use = {
                onRun = function(item)
                    item.player:SetHealth(math.min(item.player:Health() + item.restore, 100))
                    item.player:setLocalVar("stm", math.min(item.player:getLocalVar("stm", 100) + item.restore, 100))
                end
            }
        end
    end
end