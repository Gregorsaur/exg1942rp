PLUGIN.name = "Remove Equipped Weapons"
PLUGIN.author = "DoopieWop & Baid"
PLUGIN.desc = "Weapon removing on death."

if SERVER then
    function PLUGIN:DoPlayerDeath(client)
        client.LostItems = {}
        
        local items = client:getChar():getInv():getItems()
        for k, v in pairs(items) do
            if v.isWeapon then
                if v:getData("equip") then
                    table.insert(client.LostItems, v.uniqueID)
                    v:remove()
                end
            end
        end
        
        if #client.LostItems > 0 then
            local amount = #client.LostItems > 1 and #client.LostItems.." items" or "an item"
            client:notify("Because you died, you have lost " .. amount .. ".")
        end
    end
end
    
nut.command.add("returnitems", {
adminOnly = true,
syntax = "<string name>",
onRun = function(client, arguments)
	local target = nut.command.findPlayer(client, arguments[1])
	
	if IsValid(target) then
	    if !target.LostItems then
	        client:notify("The target hasn't died recently or they had their items returned already!")
	        return
	    end
	    
	    if table.IsEmpty(target.LostItems) then
	        client:notify("Cannot return any items; the player hasn't lost any!")
	        return
	    end
	    
	    local char = target:getChar()
	    
	    if !char then return end
	    
	    local inv = char:getInv()
	    
	    if !inv then return end
	    
	    for k, v in pairs(target.LostItems) do
	        inv:add(v)
	    end
	    
	    target.LostItems = nil
        
        target:notify("Your items have been returned.")
	    
	    client:notify("Returned the items.")
	end
end})