-- Scroll Panel
local PANEL = {}

function PANEL:Init()
    local colors = YAWS.UI.ColorScheme()

    self.VBar:SetWide(3)
    self.VBar:SetHideButtons(true)
    self.VBar.bgClr = colors['scroll_bg']
    self.VBar.gripClr = colors['scroll_grip']
    self.VBar.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, self.VBar.bgClr)
    end
    self.VBar.btnGrip.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, self.VBar.gripClr)
    end
end

function PANEL:Paint(w, h) end

vgui.Register("yaws.scroll", PANEL, "DScrollPanel")