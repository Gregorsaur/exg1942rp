
ITEM.name = "Steak Dinner"
ITEM.model = "models/foodnhouseholditems/steak2.mdl"
ITEM.category = "Food"
ITEM.desc = "A seasoned sirloin steak grilled to perfection!"
ITEM.noBusiness = true
ITEM.uniqueID = "steakdinner"
ITEM.price = 6
ITEM.width = 2
ITEM.height = 2

ITEM.functions.use = { -- sorry, for name order.
	name = "Eat",
	tip = "drinkTip",
	icon = "icon16/add.png",
	onRun = function(item)
   		item.player:SetHealth(math.min(item.player:Health() + 5, 100))
		return true
	end,
}

