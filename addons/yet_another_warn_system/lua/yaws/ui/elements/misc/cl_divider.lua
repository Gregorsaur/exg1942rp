-- Another 'throwaway element' i use as a divider
local PANEL = {}

AccessorFunc(PANEL, "full", "FullSize", FORCE_BOOL)

function PANEL:Init()
end 

function PANEL:Paint(w, h)
    local colors = YAWS.UI.ColorScheme() 
    draw.RoundedBox(0, self.full and 0 or 10, 0, self.full and w or (w - 20), h, colors['divider'])
end 

function PANEL:PerformLayout()
    self:SetHeight(2)
end 

vgui.Register("yaws.divider", PANEL, "DPanel")