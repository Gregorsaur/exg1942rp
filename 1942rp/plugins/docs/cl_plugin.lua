netstream.Hook("nut.docs.read", function(title, contents)
	local panel = vgui.Create("nut.docs.read")
	panel:SetHeader(title)
	panel:SetContents(contents)
end)

netstream.Hook("nut.docs.edit", function(item)
	local panel = vgui.Create("nut.docs.edit")
	panel:SetItem(item)
end)