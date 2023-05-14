
ITEM.name = "Spaghetti and Meatballs"
ITEM.model = "models/foodnhouseholditems/pancake.mdl"
ITEM.category = "Food"
ITEM.desc = "A plate of Spaghetti and meatballs with a flavorful red sauce!"
ITEM.noBusiness = true
ITEM.uniqueID = "spaghetti"
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

