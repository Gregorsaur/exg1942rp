-- A panel I can kinda just place so I can paint shadows without messing with widths n shit
local PANEL = {}

function PANEL:Init()
    self.down = false
end 
function PANEL:Down()
    self.down = true
end 

function PANEL:Paint(w, h)
    -- shadows suck in dark theme
    if(YAWS.UI.UseDarkTheme()) then return end 
    YAWS.UI.DrawShadow(0, 0, w, h, self.down)
end 

vgui.Register("yaws.shadow", PANEL, "DPanel")