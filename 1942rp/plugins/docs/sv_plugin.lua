netstream.Hook("nut.docs.edit", function(ply, item, title, contents)
	item = nut.item.instances[item.id]

	if not nut.item.isItem(item) then return end
	if item:getOwner() ~= ply then return end

	item:setData("nut.docs.title", title)
	item:setData("nut.docs.contents", contents)
end)
