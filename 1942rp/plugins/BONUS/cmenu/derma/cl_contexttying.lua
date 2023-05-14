local PANEL = {}

function PANEL:Init()
    self:MakePopup()
    self:Center()
    self:ToggleVisible(false)
    local menu = DermaMenu()

    menu:AddOption("Blindfold/Unblindfold Player", function()
        LocalPlayer():ConCommand("say /blindplayer")
        self:Close()
    end)

    menu:AddOption("Gag/Ungag Player", function()
        LocalPlayer():ConCommand("say /gagplayer")
        self:Close()
    end)

    menu:AddOption("Allow/Disallow Vehicle Usage", function()
        LocalPlayer():ConCommand("say /allowcarentry")
        self:Close()
    end)

    menu:AddOption("Stop Dragging/Drag Player", function()
        LocalPlayer():ConCommand("say /dragplayer")
        self:Close()
    end)

    menu:AddOption("Search Player", function()
        LocalPlayer():ConCommand("say /charsearch")
        self:Close()
    end)

    menu:Open()
    menu:MakePopup()
    menu:Center()
end

vgui.Register("cmenu_tying", PANEL, "DFrame")