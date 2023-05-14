ITEM.name = "Document"
ITEM.desc = "A document."
ITEM.category = ""
ITEM.model = "models/props_c17/BriefCase001a.mdl"
ITEM.width = 1
ITEM.height = 1

ITEM.functions.read = {
	name = "Read",
	tip = "equipTip",
	icon = "icon16/tick.png",
	onRun = function(item)
		netstream.Start(item.player, 'nut.docs.read', item:getData("nut.docs.title", ""), item:getData("nut.docs.contents", ""))

		return false
	end
}

ITEM.functions.edit = {
	name = "Edit",
	tip = "equipTip",
	icon = "icon16/tick.png",
	onRun = function(item)
		netstream.Start(item.player, 'nut.docs.edit', item)

		return false
	end
}
