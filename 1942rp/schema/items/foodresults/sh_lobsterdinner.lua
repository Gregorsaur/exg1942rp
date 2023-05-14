
ITEM.name = "Lobster Dinner"
ITEM.model = "models/foodnhouseholditems/lobster2.mdl"
ITEM.category = "Food"
ITEM.desc = "A slow boiled lobster, with butter sauce for a delicious high class meal!"
ITEM.noBusiness = true
ITEM.uniqueID = "lobsterdinner"
ITEM.price = 11
ITEM.width = 2
ITEM.height = 2

ITEM.functions.use = { -- sorry, for name order.
	name = "Eat",
	tip = "drinkTip",
	icon = "icon16/add.png",
	onRun = function(item)
   		item.player:SetHealth(math.min(item.player:Health() + 11, 100))
		return true
	end,
}

