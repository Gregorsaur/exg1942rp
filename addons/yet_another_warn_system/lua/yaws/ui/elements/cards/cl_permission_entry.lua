local PANEL = {}

AccessorFunc(PANEL, "name", "Name", FORCE_STRING)

function PANEL:Init()
    self.name = "Unnamed"

    self.element = vgui.Create("yaws.switch", self)
    self.element:SetColor(YAWS.UI.ColorScheme()['theme'])
    self.element.OnToggle = function(val)
        self.OnChange(val)
    end 
end 

function PANEL:Paint(w, h)
    local colors = YAWS.UI.ColorScheme()
    
    -- uncomment for a nice accidental sezuire from me debugging the layouts :)
    -- draw.RoundedBox(0, 0, 0, w, h, Color(math.Rand(0, 255), math.Rand(0, 255), math.Rand(0, 255)))
    draw.RoundedBox(0, 0, 0, w, h, colors["panel_background"])

    draw.SimpleText(self.name, "yaws.7", math.max(30, w * 0.109) + h / 2, h / 2, colors["text_header"], 0, 1)
end

function PANEL:SetValue(val)
    self.element:SetValue(val)
end 
function PANEL:GetValue(val)
    return self.element:GetValue()
end 

function PANEL:GetReccomendedHeight()
    surface.SetFont("yaws.7")
    local _,titleHeight = surface.GetTextSize(self.name)
    return titleHeight + 30
end
function PANEL:UseReccomendedHeight()
    self:SetHeight(self:GetReccomendedHeight())
end 

function PANEL:PerformLayout(w, h)
    self.element:Dock(LEFT)
    self.element:SetWide(math.max(30, w * 0.109))
    self.element:DockMargin(10, (h * 0.295), 10, (h * 0.295))
end 

function PANEL:OnChange(val)
end 

vgui.Register("yaws.permissions_entry", PANEL, "DPanel")