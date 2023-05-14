
ITEM.name = "Salmon"
ITEM.model = "models/foodnhouseholditems/salmon.mdl"
ITEM.category = "Food"
ITEM.desc = "A seared filet of salmon, with delicious seafood seasoning!"
ITEM.noBusiness = true
ITEM.uniqueID = "salmon"
ITEM.price = 4
ITEM.width = 2
ITEM.height = 2

ITEM.functions.use = { -- sorry, for name order.
	name = "Eat",
	tip = "drinkTip",
	icon = "icon16/add.png",
	onRun = function(item)
   		item.player:SetHealth(math.min(item.player:Health() + 4, 100))
		return true
	end,
}

