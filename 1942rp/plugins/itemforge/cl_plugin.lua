-- You won't be able to steal this ;)
netstream.Hook("NSForgedItemsLoad", function(items)
    NSForgedItems.List = items

    for uniqueID, itemData in pairs(NSForgedItems.List) do
        NSForgedItems.RegisterCustomItem(uniqueID, itemData)
    end
end)

netstream.Hook("NSForgedItemsLoadSingle", function(id, itemData)
    NSForgedItems.List[id] = item
    NSForgedItems.RegisterCustomItem(id, itemData)
end)

netstream.Hook("ItemMakerGUI", function()
    local panel = vgui.Create("WolfFrame")
    panel:SetSize(500, 225)
    panel:SetTitle("Item Maker")
    panel:Center()
    panel:MakePopup()
    local size_offset = 0
    local label1 = vgui.Create("DLabel", panel)
    label1:SetPos(5, 30 + size_offset)
    label1:SetText("Unique ID:")
    label1:SizeToContents()
    size_offset = size_offset + 25
    local txtUniqueID = vgui.Create("DTextEntry", panel)
    txtUniqueID:SetPos(105, 26 + size_offset - 25)
    txtUniqueID:SetSize(390, 20)
    txtUniqueID:SetTooltip("This is the item's Unique ID. Every item needs a different one. Example: water_bottle_fiji")
    local label1 = vgui.Create("DLabel", panel)
    label1:SetPos(5, 30 + size_offset)
    label1:SetText("Item Name:")
    label1:SizeToContents()
    size_offset = size_offset + 25
    local txtName = vgui.Create("DTextEntry", panel)
    txtName:SetPos(105, 26 + size_offset - 25)
    txtName:SetSize(390, 20)
    local label1 = vgui.Create("DLabel", panel)
    label1:SetPos(5, 30 + size_offset)
    label1:SetText("Item Description:")
    label1:SizeToContents()
    size_offset = size_offset + 25
    local txtDesc = vgui.Create("DTextEntry", panel)
    txtDesc:SetPos(105, 26 + size_offset - 25)
    txtDesc:SetSize(390, 20)
    local label1 = vgui.Create("DLabel", panel)
    label1:SetPos(5, 30 + size_offset)
    label1:SetText("Item Model:")
    label1:SizeToContents()
    size_offset = size_offset + 25
    local txtModel = vgui.Create("DTextEntry", panel)
    txtModel:SetPos(105, 26 + size_offset - 25)
    txtModel:SetSize(390, 20)
    local label1 = vgui.Create("DLabel", panel)
    label1:SetPos(5, 30 + size_offset)
    label1:SetText("Item Category:")
    label1:SizeToContents()
    size_offset = size_offset + 25
    local txtCategory = vgui.Create("DTextEntry", panel)
    txtCategory:SetPos(105, 26 + size_offset - 25)
    txtCategory:SetSize(390, 20)
    local label1 = vgui.Create("DLabel", panel)
    label1:SetPos(5, 30 + size_offset)
    label1:SetText("Item Price:")
    label1:SizeToContents()
    size_offset = size_offset + 25
    local txtPrice = vgui.Create("DTextEntry", panel)
    txtPrice:SetPos(105, 26 + size_offset - 25)
    txtPrice:SetSize(390, 20)
    local label1 = vgui.Create("DLabel", panel)
    label1:SetPos(5, 30 + size_offset)
    label1:SetText("Restore Amount:")
    label1:SizeToContents()
    size_offset = size_offset + 25
    local txtRestore = vgui.Create("DTextEntry", panel)
    txtRestore:SetPos(105, 26 + size_offset - 25)
    txtRestore:SetSize(390, 20)
    txtRestore:SetTooltip("Leave empty or set to 0 if you do not wish the item to be consumable.")
    local submitButton = vgui.Create("WButton", panel)
    submitButton:SetPos(5, 26 + size_offset)
    submitButton:SetSize(490, 20)
    submitButton:SetText("Create/Update Item")
    submitButton:SetSkin("Default")

    submitButton.DoClick = function()
        for k, v in pairs({txtUniqueID, txtName, txtDesc, txtModel}) do
            if (not v:GetValue() or type(v:GetValue()) ~= "string" or v:GetValue() == "") then
                nut.util.notify("You have to specify a Unique ID, Name, Description and Model")

                return
            end
        end

        local itemData = {
            name = txtName:GetValue(),
            desc = txtDesc:GetValue(),
            model = txtModel:GetValue()
        }

        if (txtCategory:GetValue() and txtCategory:GetValue() ~= "") then
            itemData.category = txtCategory:GetValue()
        end

        itemData.price = tonumber(txtPrice:GetValue())
        local restore = tonumber(txtRestore:GetValue())

        if (restore and restore > 0) then
            itemData.restore = restore
        end

        netstream.Start("ItemMakerGUI", txtUniqueID:GetValue(), itemData)
    end
end)

netstream.Hook("ItemMakerDetails", function(uniqueID, items)
    print("Item table for custom item " .. uniqueID)
    PrintTable(items)
    chat.AddText(color_white, "Details have been printed to your console.")
end)

netstream.Hook("ItemMakerList", function(items)
    for k, v in pairs(items) do
        print(k .. " = " .. v.name)
    end

    chat.AddText(color_white, "A list of all custom item forge items has been printed to your console. Use /ItemMakerdetails <uniqueID> for details.")
end)