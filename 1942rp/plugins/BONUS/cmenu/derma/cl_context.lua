local PANEL = {}

function PANEL:Init()
    self:MakePopup()
    self:Center()
    self:ToggleVisible(false)
    local menu = DermaMenu()

    menu:AddOption("Request Search", function()
        LocalPlayer():ConCommand("say /requestsearch")
        self:Close()
    end)

    menu:AddOption("Tie Player", function()
        LocalPlayer():ConCommand("say /tieplayer")
        self:Close()
    end)

    menu:AddOption("Give money", function()
        LocalPlayer():ConCommand("say /cmenugivemoney")
        self:Close()
    end)

    menu:AddOption("Use Medkit on Player", function()
        LocalPlayer():ConCommand("say /cmenumedkit")
        self:Close()
    end)

    menu:AddOption("Use Bandage on Player", function()
        LocalPlayer():ConCommand("say /cmenubandage")
        self:Close()
    end)

    menu:Open()
    menu:MakePopup()
    menu:Center()
end

vgui.Register("cmenu", PANEL, "DFrame")