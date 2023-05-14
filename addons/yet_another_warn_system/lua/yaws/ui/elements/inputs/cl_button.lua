local PANEL = {}

AccessorFunc(PANEL, "label", "Label", FORCE_STRING)
AccessorFunc(PANEL, "font", "Font", FORCE_STRING)

function PANEL:Init() 
    self.label = "Unnamed"
    self.font = "yaws.6"
    -- Tried to store the raw colors here but gmod decided to have the variables
    -- removed one frame and there another. I don't understand this fucking game
    -- sometimes. https://upload.livaco.dev/u/L63qjiTAB2.png
    self.hoverColor = "button_hover"
    self.baseColor = "button_base"
    self.color = YAWS.UI.ColorScheme()[self.baseColor]

    self.lerp = 0
    self.frameTime = RealFrameTime()

    self:SetText("")
end 

function PANEL:SetColors(base, hover)
    self.baseColor = base
    self.hoverColor = hover
end 

function PANEL:Paint(w, h) 
    local colors = YAWS.UI.ColorScheme() 

    if(self:IsHovered()) then 
        self.color = YAWS.UI.LerpColor(self.frameTime * 5, self.color, colors[self.hoverColor])
    else 
        self.color = YAWS.UI.LerpColor(self.frameTime * 5, self.color, colors[self.baseColor])
    end 

    
    draw.RoundedBox(0, 0, 0, w, h, self.color)
    if(self:IsDown()) then 
        draw.RoundedBox(0, 0, 0, w, h, colors['button_faded'])
    end 
    draw.SimpleText(self.label, self.font, w / 2, h / 2, colors['button_text'], 1, 1)
end 

vgui.Register("yaws.button", PANEL, "DButton")