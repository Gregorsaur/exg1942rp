
ITEM.name = "German Potato Salad"
ITEM.model = "models/foodnhouseholditems/potato.mdl"
ITEM.category = "Food"
ITEM.desc = "A blend of potatos and tasty ingredients in a bowl for a hearty meal!"
ITEM.noBusiness = true
ITEM.uniqueID = "germanpotatosalad"
ITEM.price = 3
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

