local PLUGIN = PLUGIN

net.Receive("ui_delivery_npc", function()
    cooldown = net.ReadBool()

    talkablenpcs.dialog("Pierce Bowman", "models/odessa.mdl", "Manager", "Speedy Delivery", function(ply)
        talkablenpcs.dialogframe("Pierce Bowman", "models/odessa.mdl", "Manager", "Speedy Delivery")
        talkablenpcs.dialogtext("Hey, whatcha need?")

        talkablenpcs.dialogbutton("Nevermind. (Close)", 40, function()
            self:Remove()
        end)

        talkablenpcs.dialogbutton("What do you do?", 40, function()
            self:Remove()
            talkablenpcs.dialogframe("Pierce Bowman", "models/odessa.mdl", "Manager", "Speedy Delivery")
            talkablenpcs.dialogtext("Speedy Delivery is a business that transports goods from one place to another for our clients for a price. We employ people such as yourselves to deliver these packages. ")

            talkablenpcs.dialogbutton("I see, thanks for the information! (Close)", 40, function()
                self:Remove()
            end)
        end)

        talkablenpcs.dialogbutton("I'm interested in a position here.", 40, function()
            self:Remove()
            talkablenpcs.dialogframe("Pierce Bowman", "models/odessa.mdl", "Manager", "Speedy Delivery")
            talkablenpcs.dialogtext("Great, just sign here and we'll get to work. We also provide you with a Truck to complete these deliveries, providing you meet the legal requirement. ")

            talkablenpcs.dialogbutton("Nevermind. (Close)", 40, function()
                self:Remove()
            end)

            talkablenpcs.dialogbutton("Sign paperwork. (Become Delivery Driver)", 40, function()
                if ply:Team() ~= FACTION_CITIZEN then
                    nut.util.notify("You already have a job!", 2)
                    self:Remove()

                    return
                end

                net.Start("delivery_job")
                net.SendToServer()
                self:Remove()
            end)
        end)
    end)
end)

net.Receive("ui_delivery_hired_npc", function()
    cooldown = net.ReadBool()

    talkablenpcs.dialog("Pierce Bowman", "models/odessa.mdl", "Manager", "Speedy Delivery", function(ply)
        talkablenpcs.dialogframe("Pierce Bowman", "models/odessa.mdl", "Manager", "Speedy Delivery")
        talkablenpcs.dialogtext("Hey, what do you need?")

        talkablenpcs.dialogbutton("Nevermind. (Close)", 35, function()
            self:Remove()
        end)

        talkablenpcs.dialogbutton("Delivery Options", 35, function()
            self:Remove()
            talkablenpcs.dialogframe("Pierce Bowman", "models/odessa.mdl", "Manager", "Speedy Delivery")
            talkablenpcs.dialogtext("What exactly do you need?")

            talkablenpcs.dialogbutton("Nevermind. (Close)", 30, function()
                self:Remove()
            end)

            if not IsValid(LocalPlayer().deliveryTruckEnt) then
                talkablenpcs.dialogbutton("I'd like to take out a Delivery Van.", 30, function()
                    self:Remove()
                    net.Start("delivery_truck")
                    net.SendToServer()
                end)
            else
                talkablenpcs.dialogbutton("I'd like to return my Delivery Van.", 30, function()
                    self:Remove()
                    net.Start("delivery_truck_return")
                    net.SendToServer()
                end)
            end

            if not IsValid(LocalPlayer().DeliveryCrate) then
                talkablenpcs.dialogbutton("What deliveries need to be made?", 35, function()
                    self:Remove()
                    self.frame = vgui.Create("WolfFrame")
                    self.frame:SetTitle("Deliveries")
                    self.frame:SetSize(500, 500)
                    self.frame:Center()
                    self.frame:MakePopup()
                    local fr = self.frame

                    for k, v in pairs(PLUGIN.DeliveryNPCLocations) do
                        self.button = vgui.Create("WButton", self.frame)
                        self.button:SetText(k .. " (" .. nut.currency.get(v.Pay) .. ")")
                        self.button:Dock(TOP)
                        self.button:SetColorAcc(Color(30, 31, 33))
                        self.button:SetupHover(Color(35, 36, 38))
                        self.button:DockMargin(0, 0, 0, 5)
                        self.button:SetTextColor(color_white)
                        self.button:SetTall(45)

                        self.button.DoClick = function()
                            net.Start("delivery_start")
                            net.WriteString(k)
                            net.SendToServer()
                            fr:Remove()
                        end
                    end
                end)
            else
                talkablenpcs.dialogbutton("I can't make my delivery", 35, function()
                    net.Start("delivery_cancel")
                    net.SendToServer()
                    self:Remove()
                end)
            end
        end)

        talkablenpcs.dialogbutton("I'd like to resign.", 35, function()
            self:Remove()
            nut.util.notify("You have resigned from Speedy Delivery LTD.")
            net.Start("delivery_resign")
            net.SendToServer()
            talkablenpcs.dialogframe("Pierce Bowman", "models/odessa.mdl", "Manager", "Speedy Delivery")
            talkablenpcs.dialogtext("You're not joking? Damn, okay. Thanks for the help, come back and speak to me if you ever want to do some more work. We always need people like you.")

            talkablenpcs.dialogbutton("(Close)", 30, function()
                self:Remove()
            end)
        end)
    end)
end)

net.Receive("delivery_job_accepted", function()
    talkablenpcs.dialogframe("Pierce Bowman", "models/odessa.mdl", "Manager", "Speedy Delivery")
    talkablenpcs.dialogtext("Welcome to the team pal, let me know when you want to work and I'll assign you a task. You work when you want and for as long as you want. You'll be paid for each delivery you complete.")

    talkablenpcs.dialogbutton("Got it. (Close)", 40, function()
        self:Remove()
    end)
end)