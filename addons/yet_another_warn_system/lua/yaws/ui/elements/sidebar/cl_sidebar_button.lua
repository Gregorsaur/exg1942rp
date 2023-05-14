local PANEL = {}

AccessorFunc(PANEL, "name", "Name", FORCE_STRING)
AccessorFunc(PANEL, "callback", "Callback")
AccessorFunc(PANEL, "icon", "Icon")

function PANEL:Init()
    self:SetText("")

    self.id = 0;
    self.name = "Unnamed"
    self.color = YAWS.UI.ColorScheme()['sidebutton_dull']
    self.callback = function() end 
    self.bgColor = Color(0, 0, 0, 0)
    self.icon = YAWS.UI.MaterialCache['close']
    self.selectable = true
    self.selected = false

    self.frameTime = RealFrameTime()
end 

function PANEL:AllowSelectable(selectable) 
    self.selectable = selectable
end 

function PANEL:DoClick()
    if(self.selected) then return end 
    
    if(self.selectable) then 
        self.selected = true
        self:GetParent():GetParent():UpdateSelected(self.id)
    end 

    self.callback()
end

function PANEL:Paint(w, h) 
    self.frameTime = RealFrameTime()
    
    -- draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0))
    local colors = YAWS.UI.ColorScheme()
    local useThis = "sidebutton_dull"
    if(self:IsHovered() || self.selected) then 
        useThis = "sidebutton_highlight"
    end 
    self.color = YAWS.UI.LerpColor(10 * self.frameTime, self.color, colors[useThis])

    if(self.selected) then 
        self.bgColor = YAWS.UI.LerpColor(10 * self.frameTime, self.bgColor, colors["sidebutton_highlightbg"])
    else 
        self.bgColor = YAWS.UI.LerpColor(10 * self.frameTime, self.bgColor, colors["sidebutton_highlightbg2"])
    end 

    local pad = w * 0.05
    draw.RoundedBox(5, pad, pad, w - (pad * 2), w - (pad * 2), self.bgColor)

    draw.NoTexture()
    surface.SetDrawColor(self.color.r, self.color.g, self.color.b)
    surface.SetMaterial(self.icon)

    surface.DrawTexturedRect(w * 0.37, w * 0.37 - (h * 0.08), w - (w * 0.37 * 2), (h - (w * 0.37 * 2)))

    draw.SimpleText(self.name, "yaws.6", (w / 2) - 1, h * 0.7, self.color, 1, 1)
end 

function PANEL:PerformLayout()
    self:SetHeight(self:GetWide())
end 

vgui.Register("yaws.sidebar_button", PANEL, "DButton")