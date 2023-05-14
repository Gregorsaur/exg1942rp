-- just a normal panel but with s h a d o w s
local PANEL = {}

function PANEL:Init()
    self.sideShadow = vgui.Create("yaws.shadow", self:GetParent())
    self.bottomShadow = vgui.Create("yaws.shadow", self:GetParent())
    self.bottomShadow:Down()
end 

function PANEL:Paint(w, h)
    local colors = YAWS.UI.ColorScheme() 

    draw.RoundedBox(0, 0, 0, w, h, colors['panel_background'])
end

function PANEL:RemoveShadows()
    self.sideShadow:Remove()
    self.bottomShadow:Remove()
end 
function PANEL:HideShadows(hide) -- for panels like the admin tab where it's reused through multiple senarios, both needing and wanting to ditch shadows each
    if(hide) then
        self:RemoveShadows()
    else
        if(!IsValid(self.sideShadow)) then 
            self.sideShadow = vgui.Create("yaws.shadow", self:GetParent())
        end
        if(!IsValid(self.bottomShadow)) then 
            self.bottomShadow = vgui.Create("yaws.shadow", self:GetParent())
            self.bottomShadow:Down()
        end
        self:InvalidateLayout()
    end
end 

function PANEL:PerformLayout(w, h)
    self:LayoutShadows(w, h)
    self:PostPerformLayout(w, h)
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
function PANEL:PostPerformLayout(w, h) end 

function PANEL:OnRemove()
    self:RemoveShadows()
end 

vgui.Register("yaws.panel", PANEL, "DPanel")