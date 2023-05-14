local PANEL = {}

function PANEL:Init()
    self.huePicker = vgui.Create("DRGBPicker", self)
    self.colorPicker = vgui.Create("DColorCube", self)

    self.huePicker.OnChange = function(s, col)
        -- Update the color cube too 
        local h = ColorToHSV(col)
        local _,s,v = ColorToHSV(self.colorPicker:GetRGB())
        self.colorPicker:SetColor(HSVToColor(h, s, v))

        self:UpdateColor()
    end 
    self.colorPicker.OnUserChanged = function(s, col)
        self:UpdateColor()
    end 

    self.fixOnLayout = nil
end 

function PANEL:UpdateColor()
    local h,_,_ = ColorToHSV(self.huePicker:GetRGB())
    local _,s,v = ColorToHSV(self.colorPicker:GetRGB())
    
    self:ValueChanged(HSVToColor(h, s, v))
end 
function PANEL:ValueChanged(col) end

function PANEL:SetColor(col)
    local h,s,v = ColorToHSV(col)

    self.huePicker.LastY = (1 - (h / 360)) * self.huePicker:GetTall()
    self.colorPicker:SetColor(col)
    self.fixOnLayout = col
end 
function PANEL:GetColor()
    local h = ColorToHSV(self.huePicker:GetRGB())
    local _,s,v = ColorToHSV(self.colorPicker:GetRGB())
    return HSVToColor(h, s, v)
end 

function PANEL:PerformLayout(w, h)
    self.huePicker:Dock(LEFT)
    self.huePicker:SetWide(math.min(w * 0.1, 20))
    
    self.colorPicker:Dock(FILL)
    self.colorPicker:DockMargin(10, 0, 0, 0)

    -- needs to be here so the color is in the correct place when it's height is updated
    -- not like it's being ran every frame
    if(self.fixOnLayout) then 
        local h = ColorToHSV(self.fixOnLayout)
        self.huePicker.LastY = (1 - (h / 360)) * self.huePicker:GetTall()
    end 
end 

function PANEL:Paint(w, h)
end 

vgui.Register("yaws.color", PANEL, "DPanel")