
ITEM.name = "Oysters Rockefeller"
ITEM.model = "models/foodnhouseholditems/fishsteak.mdl"
ITEM.category = "Food"
ITEM.desc = "A dish of Oysters with a delicious topping, truly exquisite!"
ITEM.noBusiness = true
ITEM.uniqueID = "oystersrockefeller"
ITEM.price = 8
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

