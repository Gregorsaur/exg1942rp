
ITEM.name = "Flapjacks"
ITEM.model = "models/foodnhouseholditems/pancakes.mdl"
ITEM.category = "Food"
ITEM.desc = "A tall stack of delicious flapjacks!"
ITEM.noBusiness = true
ITEM.uniqueID = "flapjacks"
ITEM.price = 4
ITEM.width = 2
ITEM.height = 2

ITEM.functions.use = { -- sorry, for name order.
	name = "Eat",
	tip = "drinkTip",
	icon = "icon16/add.png",
	onRun = function(item)
   		item.player:SetHealth(math.min(item.player:Health() + 3, 100))
		return true
	end,
}

