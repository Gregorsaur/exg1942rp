local PANEL = {}

-- Same as a regular text entry but designed to work with a icon too

AccessorFunc(PANEL, "placeholder", "Placeholder")

function PANEL:Init()
    self.textEntry = vgui.Create("yaws.text_entry", self)
    self.textEntry.Paint = function(self, w, h) 
        local colors = YAWS.UI.ColorScheme()
        self:DrawTextEntryText(colors["text_main"], colors["theme"], colors["theme"])

        if(self:GetText() == "" && (!self:HasFocus() || !self:IsEnabled())) then 
            draw.SimpleText(self.placeholder, self:GetFont(), self.overrideX && self.overrideX || 5, (!self:IsMultiline()) && (h / 2) - 1 || 5, colors['text_placeholder'], 0, (!self:IsMultiline()) && 1 || 0)
        end 
    end 
    
    self.icon = nil
    self.iconPanel = nil

    self.frameTime = RealFrameTime()

    self.borderColor = YAWS.UI.ColorScheme()['text_entry_border_inactive']
    self.sideShadow = vgui.Create("yaws.shadow", self:GetParent())
    self.bottomShadow = vgui.Create("yaws.shadow", self:GetParent())
    self.bottomShadow:Down()
end 

function PANEL:GetTextEntry()
    return self.textEntry
end 

function PANEL:Paint(w, h)
    self.frameTime = RealFrameTime()
    local colors = YAWS.UI.ColorScheme()

    -- don't question this
    if(self:HasFocus()) then 
        self.borderColor = YAWS.UI.LerpColor(self.frameTime * 5, self.borderColor, colors['text_entry_border_active'])
    else
        self.borderColor = YAWS.UI.LerpColor(self.frameTime * 5, self.borderColor, colors['text_entry_border_inactive'])
    end 

    draw.RoundedBox(0, 0, 0, w, h, self.borderColor)
    draw.RoundedBox(0, 1, 1, w - 2, h - 2, colors['input_bg'])
end 

function PANEL:LayoutShadows(w, h)
    local x,y = self:GetPos()
    if(IsValid(self.sideShadow)) then 
        self.sideShadow:SetPos(x + w, y)
        self.sideShadow:SetSize(3, h)
    end 

    if(IsValid(self.bottomShadow)) then 
        self.bottomShadow:SetPos(x, y + h)
        self.bottomShadow:SetSize(w + 1, 3)
    end
end 

function PANEL:SetIcon(mat)
    self.icon = mat

    if(!self.iconPanel) then 
        self.iconPanel = vgui.Create("DPanel", self)
        self.iconPanel.Paint = function(sself, w, h)
            -- draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 120))
            YAWS.UI.SetSurfaceDrawColor(YAWS.UI.ColorScheme()['text_header'])
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(h * 0.2, h * 0.2, h * 0.65, h * 0.65)
        end 
        self:InvalidateLayout()
    end 
end 

function PANEL:PerformLayout(w, h)
    if(self.iconPanel) then 
        self.iconPanel:Dock(LEFT)
        self.iconPanel:SetSize(h - 5, h)
    end 

    self.textEntry:Dock(FILL)
    self:LayoutShadows(w, h)
end 

vgui.Register("yaws.icon_text_entry", PANEL, "DPanel")