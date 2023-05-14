net.Receive("ui_import_npc_drugs", function()
    import_items = {}

    import_items["unprocessedcocaine"] = {
        item = "unprocessedcocaine",
        price = 100,
        category = "Drugs",
        access = {FACTION_CITIZEN, FACTION_STAFF},
    }

    import_items["unprocessedweed"] = {
        item = "unprocessedweed",
        price = 100,
        category = "Drugs",
        access = {FACTION_CITIZEN, FACTION_STAFF},
    }

    import_items["unprocessedheroin"] = {
        item = "unprocessedheroin",
        price = 100,
        category = "Drugs",
        access = {FACTION_CITIZEN, FACTION_STAFF},
    }

    import_items["universalammo"] = {
        item = "universalammo",
        price = 100,
        category = "Guns",
        access = {FACTION_CITIZEN, FACTION_STAFF},
    }

    import_categories = {"Drugs", "Guns", "Misc"}

    talkablenpcs.dialog("Johnny Smithie", "models/Eli.mdl", "Drug Addict/Black Market Vendor", "Entropy Mafia", function(ply)
        talkablenpcs.dialogframe("Johnny Smithie", "models/Eli.mdl", "Drug Addict/Black Market Vendor", "Entropy Mafia")
        talkablenpcs.dialogtext("Do you wish to donate to a poor fella?")

        talkablenpcs.dialogbutton("Exit.", 48, function()
            self:Remove()
        end)

        talkablenpcs.dialogbutton("I'd like to have something shipped in.", 48, function()
            self:Remove()
            self = vgui.Create("DFrame")
            self:SetTitle("Categories")
            self:SetSize(400, 400)
            self:MakePopup()
            self:Center()

            for y, x in pairs(import_categories) do
                self.button = vgui.Create("DButton", self)
                self.button:SetText(x)
                self.button:SetHeight(25)
                self.button:Dock(TOP)

                self.button.DoClick = function()
                    self:Remove()
                    self = vgui.Create("DFrame")
                    self:SetTitle(x)
                    self:SetSize(400, 400)
                    self:MakePopup()
                    self:Center()
                    self.scroll = vgui.Create("DScrollPanel", self)
                    self.scroll:Dock(FILL)

                    for k, v in pairs(import_items) do
                        if v.category == x then
                            if table.HasValue(v.access, LocalPlayer():Team()) then
                                local price = v.price
                                local itemTable = nut.item.list[v.item]
                                self.button = vgui.Create("DButton", self.scroll)
                                self.button:SetText(itemTable.name .. " - $" .. price)
                                self.button:SetHeight(25)
                                self.button:Dock(TOP)

                                self.button.DoClick = function()
                                    if LocalPlayer():GetNWBool("npc_cooldown_" .. v.item, false) then
                                        LocalPlayer():ChatPrint("This Drug is on Cooldown for you!")
                                        self:Remove()
                                    else
                                        net.Start("import_drugs")
                                        net.WriteString(v.item)
                                        net.WriteInt(price, 32)
                                        net.SendToServer()
                                        self:Remove()
                                    end
                                end
                            end
                        else
                            LocalPlayer():ChatPrint("You do not have access to this item!")
                        end
                    end
                end
            end
        end)
    end)
end)