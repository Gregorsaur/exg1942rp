
ITEM.name = "Deviled Eggs"
ITEM.model = "models/foodnhouseholditems/chocolatine.mdl"
ITEM.category = "Food"
ITEM.desc = "A hard boiled egg that has been topped with a creamy yellow filling!"
ITEM.noBusiness = true
ITEM.uniqueID = "deviledeggs"
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

