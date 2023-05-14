-- The base for the expandable cards like the warnings n shit. Originally was a
-- DCollapsableCategory but jesus fuck those retards are just fiddly messes, so
-- I'm using a custom one now instead.
local PANEL = {}

AccessorFunc(PANEL, "expanded", "Expanded", FORCE_BOOL)
AccessorFunc(PANEL, "expandedHeight", "ExpandedHeight", FORCE_NUMBER)

function PANEL:Init()
    self:SetExpanded(false)
    self.clr = Color(20, 20, 20)

    if(!YAWS.UserSettings.GetValue("disable_ui_anims")) then 
        self.animTime = 0.6
    else 
        self.animTime = 0.001
    end 

    self.content = vgui.Create("DPanel", self)
    self.content:SetHeight(0)
    self.content.Paint = function(s, w, h)
        self:ContentPaint(w, h)
        -- draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0))
    end 

    self.expandAnim = Derma_Anim("Expand", self, function(pnl, anim, delta, data)
        local deltaEase = YAWS.UI.EaseOutCubic(delta)
        pnl.content:SetTall(pnl:GetExpandedHeight() * deltaEase)
        pnl:SetTall(pnl.btn:GetTall() + (pnl:GetExpandedHeight() * deltaEase))
    end)
    self.retractAnim = Derma_Anim("Retract", self, function(pnl, anim, delta, data)
        local deltaEase = YAWS.UI.EaseOutCubic(delta)
        pnl.content:SetTall(pnl:GetExpandedHeight() * (1 - deltaEase))
        pnl:SetTall(pnl.btn:GetTall() + (pnl:GetExpandedHeight() * (1 - deltaEase)))
    end)

    self:SetExpandedHeight(100)

    self.btn = vgui.Create("DButton", self)
    self.btn:SetText("")
    self.btn.DoClick = function()
        if(!self:GetExpanded()) then 
            self:Expand()
        else
            self:Retract()
        end 
    end 
    self.btn.Paint = function(s, w, h)
        self:HeaderPaint(w, h)
    end 
    self.btn:SetZPos(10)
end

function PANEL:Expand()
    self.expandAnim:Start(self.animTime)
    self:SetExpanded(true)
end
function PANEL:Retract()
    self.retractAnim:Start(self.animTime)
    self:SetExpanded(false)
end

function PANEL:Think()
    if(self.expandAnim:Active()) then 
        self.expandAnim:Run()
    end
    if(self.retractAnim:Active()) then 
        self.retractAnim:Run()
    end
end 

function PANEL:Paint() end 
function PANEL:HeaderPaint() end 
function PANEL:ContentPaint() end 

function PANEL:PerformLayout(w, h)
    self:CalculateHeights(w, h)
    self:PostPerformLayout(w, h)

    self.btn:Dock(TOP)
    self.content:SetPos(0, self.btn:GetTall())
    self.content:SetSize(w, self.content:GetTall())
end
function PANEL:CalculateHeights(w, h) end 
function PANEL:PostPerformLayout(w, h) end 

function PANEL:SetHeaderHeight(h)
    self.btn:SetTall(h)
    if(h > self:GetTall()) then 
        self:SetTall(h)
    end 
end

vgui.Register("yaws.expandable_card_base", PANEL, "DPanel")