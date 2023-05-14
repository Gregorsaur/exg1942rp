local PANEL = {}

function PANEL:Init()
    self:SetExpanded(true)
    self.clr = Color(20, 20, 20)

    self.Header:SetTall(40)
    self.Header:SetText("")
    self.Header.label = ""
    self.Header.clr = Color(20, 20, 20)
    self.Header.he = 0
    self.Header.Paint = function(s, w, h)
        if(s.he == 0) then 
            s.he = h / 2
        end 
        local colors = YAWS.UI.ColorScheme() 

        -- draw.RoundedBoxEx(5, 0, 0, w, h, s.clr, true, true, false, false)
        draw.RoundedBox(0, 0, 0, w, h, colors["panel_background"])
        if(!self:GetExpanded()) then 
            s.he = Lerp(RealFrameTime() * 5, s.he, h * 0.42)
        else 
            s.he = Lerp(RealFrameTime() * 5, s.he, ((h / 2) - 2))
        end
        -- print(s.he)
        draw.SimpleText(self.Header.label, "yaws.9", w * 0.01, s.he, colors['text_header'], 0, 1)

        draw.RoundedBox(0, 0, h - 2, w, 2, colors['divider'])
        s.chevState = YAWS.UI.DrawAnimatedChevron(w - ((h / 2) + 10), s.he - 5, s.he, (h / 4), s.chevState, self:GetExpanded())
    end
end

function PANEL:SetHeaderColor(clr)
    self.Header.clr = clr
end

function PANEL:SetLabel(txt)
    self.Header:SetText("")
    self.Header.label = txt
end

function PANEL:Paint(w, h) 
    -- tried to get shadows here but can't figure it out, if anyone gets it done lemme know so I can add it pls xx oo
end 

vgui.Register("yaws.collapsable", PANEL, "DCollapsibleCategory")