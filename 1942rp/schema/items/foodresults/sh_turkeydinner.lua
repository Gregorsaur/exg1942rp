
ITEM.name = "Turkey Dinner"
ITEM.model = "models/foodnhouseholditems/turkey2.mdl"
ITEM.category = "Food"
ITEM.desc = "A large meal with a classic American mashup of turkey and sides!"
ITEM.noBusiness = true
ITEM.uniqueID = "turkeydinner"
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

