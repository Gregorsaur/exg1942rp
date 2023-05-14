
ITEM.name = "Hot Dog"
ITEM.model = "models/food/hotdog.mdl"
ITEM.category = "Food"
ITEM.desc = "A snappy ballpark grilled hot doggie!"
ITEM.noBusiness = true
ITEM.uniqueID = "hotdog"
ITEM.price = 1
ITEM.width = 2
ITEM.height = 2

ITEM.functions.use = { -- sorry, for name order.
	name = "Eat",
	tip = "drinkTip",
	icon = "icon16/add.png",
	onRun = function(item)
   		item.player:SetHealth(math.min(item.player:Health() + 1, 100))
		return true
	end,
}

