ITEM.name = "Cold Medicine"
ITEM.model = "models/healthvial.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.healAmount = 15
ITEM.healSeconds = 1
ITEM.price = 100
ITEM.desc = "Medicine to help with a cold."
ITEM.uniqueID = "medicine"
ITEM.flag = "v"
--ITEM.container = "j_empty_vial"
ITEM.color = Color(232, 0, 0)
ITEM.permit = "permit_med"

ITEM.iconCam = {
	pos = Vector(89.432174682617, 74.904991149902, 54.501823425293),
	ang = Angle(25, 220, 0),
	fov = 5,
}

ITEM.cures = {
	["dis_cold"] = true, 
	["dis_flu"] = true
}

local function healPlayer(client, target, amount, seconds)
	hook.Run("OnPlayerHeal", client, target, amount, seconds)

	if (client:Alive() and target:Alive()) then
		local id = "nutHeal_"..FrameTime()
		timer.Create(id, 1, seconds, function()
			if (!target:IsValid() or !target:Alive()) then
				timer.Destroy(id)	
			end

			target:SetHealth(math.Clamp(target:Health() + (amount/seconds), 0, target:GetMaxHealth()))
		end)
	end
end

// On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.use = { -- sorry, for name order.
	name = "Use",
	tip = "useTip",
	icon = "icon16/add.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
	
		if (item.player:Alive()) then
		
			local position = item.player:getItemDropPos()
			healPlayer(item.player, item.player, item.healAmount, item.healSeconds)
			if(item.container) then
				nut.item.spawn(item.container, position)
			end	
			
			for k, v in pairs(DISEASES.diseases) do 
				if(char:getData(k) and item.cures[k]) then
					char:setData(k, nil)
					
					nut.chat.send(client, "body", table.Random(v.cure)) --sends them a message about being cured
				end
			end
		end
	end
}

// On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.usef = { -- sorry, for name order.
	name = "Use Forward",
	tip = "useTip",
	icon = "icon16/arrow_up.png",
	onRun = function(item)
		local client = item.player
		local position = client:getItemDropPos()
		local trace = client:GetEyeTraceNoCursor() -- We don't need cursors.
		local target = trace.Entity

		if (target and target:IsValid() and target:IsPlayer() and target:Alive()) then
			healPlayer(item.player, target, item.healAmount, item.healSeconds)

			return true
		end
		
		local char = target:getChar()
		for k, v in pairs(DISEASES.diseases) do 
			if(char:getData(k) and item.cures[k]) then
				char:setData(k, nil)
				
				nut.chat.send(client, "body", table.Random(v.cure)) --sends them a message about being cured
			end
		end

		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity))
	end
}
