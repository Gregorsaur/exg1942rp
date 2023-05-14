ITEM.name = "Food Base"
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.isFood = true
ITEM.cookable = true
ITEM.foodDesc = "This is test food."
ITEM.category = "Consumable"
ITEM.mustCooked = false
ITEM.quantity = 1
ITEM.container = ""
ITEM.permit = "permit_food"
ITEM.sound = "npc/barnacle/barnacle_crunch2.wav"

ITEM.functions.use = {
	name = "Consume",
	tip = "useTip",
	icon = "icon16/cup.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
	
		local cooked = item:getData("cooked", 1)
		local quantity = item:getData("quantity", item.quantity)
		local mul = COOKLEVEL[cooked][2]
		local position = item.player:getItemDropPos()
		
		quantity = quantity - 1
		
		item.player:addHunger(item.hungerAmount * mul)
		item.player:EmitSound(item.sound)
		
		if (quantity >= 1) then
			item:setData("quantity", quantity)
			return false
		else
			--not used for now
			--[[
			if(item.container != "") then
				nut.item.spawn(item.container, position)
			end
			--]]
		end
		
		return true
	end,
	onCanRun = function(item)
		if (item.mustCooked and item:getData("cooked", 1) == 1) then
			return false
		end
		
		return (!IsValid(item.entity))
	end
}

function ITEM:getDesc()
	local str = self.foodDesc
	
	if (self.mustCooked != false) then
		str = str .. "\nThis food must be cooked."
	end

	if (self.cookable != false) then
		str = str .. "\nFood Status: %s."
	end

	if(self.quantity) then
		str = str .. "\nPortions remaining: " .. self:getData("quantity", self.quantity)
	end
		
	return Format(str, COOKLEVEL[(self:getData("cooked") or 1)][1])
end

if (CLIENT) then --draws a square on the food item for how well cooked it is.
	function ITEM:paintOver(item, w, h)
		local cooked = item:getData("cooked", 1)
		local quantity = item:getData("quantity", item.quantity)

		if (quantity > 1) then
			draw.SimpleText(quantity, "DermaDefault", 6, h - 16, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
		end

		if (cooked > 1) then
			local col = COOKLEVEL[cooked][3]

			surface.SetDrawColor(col.r, col.g, col.b, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end
