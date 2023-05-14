
ITEM.name = "Glazed Ham Dinner"
ITEM.model = "models/foodnhouseholditems/miniwheats.mdl"
ITEM.category = "Food"
ITEM.desc = "A flavorful glazed ham, slow baked for a tender bite!"
ITEM.noBusiness = true
ITEM.uniqueID = "hamdinner"
ITEM.price = 8
ITEM.width = 2
ITEM.height = 2

ITEM.functions.use = { -- sorry, for name order.
	name = "Eat",
	tip = "drinkTip",
	icon = "icon16/add.png",
	onRun = function(item)
   		item.player:SetHealth(math.min(item.player:Health() + 7, 100))
		return true
	end,
}

