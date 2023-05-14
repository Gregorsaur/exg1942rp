net.Receive("ui_taxi_npc", function()
    cooldown = net.ReadBool()

    talkablenpcs.dialog("Amaboutoblow", "models/odessa.mdl", "Manager", "DreamyBull Taxis", function(ply)
        talkablenpcs.dialogframe("Amaboutoblow", "models/odessa.mdl", "Manager", "DreamyBull Taxis")
        talkablenpcs.dialogtext("What can I do for you?")

        talkablenpcs.dialogbutton("Nevermind. (Close)", 40, function()
            self:Remove()
        end)

        talkablenpcs.dialogbutton("What do you do?", 40, function()
            self:Remove()
            talkablenpcs.dialogframe("Amaboutoblow", "models/odessa.mdl", "Manager", "DreamyBull Taxis")
            talkablenpcs.dialogtext("We're Berlin's largest taxi firm! We transport thousands of people a day to and from wherever they need!")

            talkablenpcs.dialogbutton("Alright. (Close)", 40, function()
                self:Remove()
            end)
        end)

        talkablenpcs.dialogbutton("I'm interested in a position here.", 40, function()
            self:Remove()
            talkablenpcs.dialogframe("Amaboutoblow", "models/odessa.mdl", "Manager", "DreamyBull Taxis")
            talkablenpcs.dialogtext("Okay, just sign here and you can get started.")

            talkablenpcs.dialogbutton("Nevermind. (Close)", 40, function()
                self:Remove()
            end)

            talkablenpcs.dialogbutton("Sign paperwork. (Become Taxi Driver)", 40, function()
                if team.GetName(LocalPlayer():Team()) ~= "Citizens of Berlin" then
                    nut.util.notify("You already have a job!", 2)
                    self:Remove()

                    return
                end

                net.Start("taxi_job")
                net.SendToServer()
                self:Remove()
                talkablenpcs.dialogframe("Amaboutoblow", "models/odessa.mdl", "Manager", "DreamyBull Taxis")
                talkablenpcs.dialogtext("Welcome to DreamyBull Taxis, let me know when you want to start and we can get you a car.")

                talkablenpcs.dialogbutton("Got it. (Close)", 40, function()
                    self:Remove()
                end)
            end)
        end)
    end)
end)

-------------------------------------------------------------------------------------------
net.Receive("ui_taxi_hired_npc", function()
    cooldown = net.ReadBool()

    talkablenpcs.dialog("Amaboutoblow", "models/odessa.mdl", "Manager", "DreamyBull Taxis", function(ply)
        talkablenpcs.dialogframe("Amaboutoblow", "models/odessa.mdl", "Manager", "DreamyBull Taxis")
        talkablenpcs.dialogtext("What's up?")

        talkablenpcs.dialogbutton("Nevermind. (Close)", 35, function()
            self:Remove()
        end)

        if not IsValid(LocalPlayer().taxiEnt) then
            talkablenpcs.dialogbutton("I'd like to take out a Taxi.", 30, function()
                self:Remove()
                net.Start("taxi_take")
                net.SendToServer()
            end)
        else
            talkablenpcs.dialogbutton("I'd like to return my Taxi.", 30, function()
                self:Remove()
                net.Start("taxi_return")
                net.SendToServer()
            end)
        end

        talkablenpcs.dialogbutton("I'd like to resign.", 35, function()
            self:Remove()
            nut.util.notify("You have resigned from DreamyBull Taxis.")
            net.Start("taxi_resign")
            net.SendToServer()
            talkablenpcs.dialogframe("Amaboutoblow", "models/odessa.mdl", "Manager", "DreamyBull Taxis")
            talkablenpcs.dialogtext("Okay, let me know if you need another job. We're always in need of Drivers. Look after yourself.")

            talkablenpcs.dialogbutton("(Close)", 30, function()
                self:Remove()
            end)
        end)
    end)
end)