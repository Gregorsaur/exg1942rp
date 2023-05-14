
ITEM.name = "Shrimp Cocktail"
ITEM.model = "models/foodnhouseholditems/pineapple_drink.mdl"
ITEM.category = "Food"
ITEM.desc = "A seafood delight of Shrimp served with tangy cocktail sauce!"
ITEM.noBusiness = true
ITEM.uniqueID = "shrimpcocktail"
ITEM.price = 5
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

