
ITEM.name = "Clam Chowder"
ITEM.model = "models/polievka/bowlbreaking.mdl"
ITEM.category = "Food"
ITEM.desc = "A lovely blend of flavors from New England in clam filled a bowl!"
ITEM.noBusiness = true
ITEM.uniqueID = "clamchowder"
ITEM.price = 3
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

