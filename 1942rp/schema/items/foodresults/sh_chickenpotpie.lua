
ITEM.name = "Chicken Pot Pie"
ITEM.model = "models/foodnhouseholditems/pie.mdl"
ITEM.category = "Food"
ITEM.desc = "A baked pie, filled with a tasty mix of dinner foods!"
ITEM.noBusiness = true
ITEM.uniqueID = "chickenpotpie"
ITEM.price = 4
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

