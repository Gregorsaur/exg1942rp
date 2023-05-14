local PANEL = {}

function PANEL:Init()
    self:SetText("")
    self.material = nil 
    self.color = YAWS.UI.ColorScheme()["icon_button_base"]
    self.padding = 0
    self.flip = false
end 

function PANEL:SetMaterial(mat)
    self.material = mat
end 
function PANEL:SetIconPadding(pad)
    self.padding = pad
end 
function PANEL:FlipIcon(flip)
    self.flip = flip
end 

function PANEL:Paint(w, h)
    if(!self.material) then return end

    if(self:IsHovered()) then 
        self.color = YAWS.UI.LerpColor(RealFrameTime() * 5, self.color, YAWS.UI.ColorScheme()["icon_button_hover"])
    else 
        self.color = YAWS.UI.LerpColor(RealFrameTime() * 5, self.color, YAWS.UI.ColorScheme()["icon_button_base"])
    end 

    YAWS.UI.SetSurfaceDrawColor(self.color)
    surface.SetMaterial(self.material)
    if(self.flip) then 
        surface.DrawTexturedRectRotated(self.padding + (w / 4), self.padding + (h / 4), w - (self.padding * 2), h - (self.padding * 2), 180)
    else 
        surface.DrawTexturedRect(self.padding, self.padding, w - (self.padding * 2), h - (self.padding * 2))
    end
end 

vgui.Register("yaws.iconbtn", PANEL, "DButton")