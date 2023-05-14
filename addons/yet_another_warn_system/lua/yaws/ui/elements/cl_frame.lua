-- woah wtf im not copying and pasting elements directly over from other addons
-- of mine for once? whaa
local PANEL = {}

AccessorFunc(PANEL, "master", "MasterPanel")
AccessorFunc(PANEL, "sidebar", "Sidebar")
-- https://github.com/Facepunch/garrysmod/blob/ad636ea0569228b3656e72637a76570db488856c/garrysmod/lua/vgui/dframe.lua#L14
AccessorFunc(PANEL, "m_bBackgroundBlur", "BackgroundBlur", FORCE_BOOL)

function PANEL:Init()
    -- https://github.com/Facepunch/garrysmod/blob/ad636ea0569228b3656e72637a76570db488856c/garrysmod/lua/vgui/dframe.lua#L63
    self.m_fCreateTime = SysTime()
    if(!YAWS.UserSettings.GetValue("disable_fades")) then 
        self:SetAlpha(0)
    end

    self.bgColor = Color(0, 0, 0, 0)

    self.fadeInAnim = Derma_Anim("yaws_frame_fadein", self, function(pnl, anim, delta, data)
        pnl:SetAlpha(delta * 255)
    end)
    self.fadeOutAnim = Derma_Anim("yaws_frame_fadeout", self, function(pnl, anim, delta, data)
        pnl:SetAlpha(math.abs(1 - delta) * 255)
    end)
    self.dueForRemoval = false
end 

function PANEL:SetupSideBar(close)
    self.sideContainer = vgui.Create("yaws.panel", self)

    self.sidebar = vgui.Create("yaws.sidebar", self.sideContainer)
    self.sidebar:NoShadows()
    
    self.master = vgui.Create("DPanel", self)
    self.master.Paint = function() end
    
    if(close) then
        self.close = vgui.Create("yaws.sidebar_button", self.sideContainer)
        self.close:SetName(YAWS.Language.GetTranslation("sidebar_close"))
        self.close:SetIcon(YAWS.UI.MaterialCache['close'])
        self.close:SetCallback(function() 
            self:Close()
        end)
        self.close.DoClick = function(self)
            self.callback()
        end
    end
    self:InvalidateLayout()
end 

function PANEL:FadeIn()
    self.fadeInAnim:Start(0.2)
end 
function PANEL:FadeOut()
    self.fadeOutAnim:Start(0.25)
end 
function PANEL:Think()
    if(self.fadeInAnim:Active()) then 
        self.fadeInAnim:Run()
    end 
    if(self.fadeOutAnim:Active()) then 
        self.fadeOutAnim:Run()
    else 
        if(self.dueForRemoval) then 
            self:Remove()
        end 
    end 

    self:PostThink()
end 
function PANEL:PostThink() end 
function PANEL:Close()
    if(YAWS.UserSettings.GetValue("disable_fades")) then 
        self:Remove()
        return
    end 

    self:FadeOut()
    self.dueForRemoval = true
end 


function PANEL:OnRemove()
    YAWS.UI.LoadingCache = nil
end 

function PANEL:AddSidebarTab(name, icon, selectable, callback)
    self.sidebar:AddTab(name, icon, selectable, callback)
end 
function PANEL:AddSidebarBottomTab(name, icon, selectable, callback)
    self.sidebar:AddBottomTab(name, icon, selectable, callback)
end 
function PANEL:SetSidebarSelected(id)
    -- this is crude but it should be fine
    self.sidebar:UpdateSelected(id)
    self.sidebar.tabs[id].element:DoClick()
end 
function PANEL:SetSidebarSelectedName(name)
    self.sidebar:SetSelectedName(name)
end 

function PANEL:Paint(w, h)
    local old = DisableClipping(true)

    local posX,posY = self:GetPos()
    draw.RoundedBox(0, 0 - posX, 0 - posY, ScrW(), ScrH(), self.bgColor)

    DisableClipping(false)

    -- https://github.com/Facepunch/garrysmod/blob/ad636ea0569228b3656e72637a76570db488856c/garrysmod/lua/vgui/dframe.lua#L199
    if(self.m_bBackgroundBlur) then
        Derma_DrawBackgroundBlur(self, self.m_fCreateTime)
    end
    
    local colors = YAWS.UI.ColorScheme() 
    draw.RoundedBox(0, 0, 0, w, h, colors['frame_background'])

    DisableClipping(true)

    YAWS.UI.DrawShadow(w, 0, 3, h, false)
    YAWS.UI.DrawShadow(0, h, w + 1, 3, true)
    
    DisableClipping(old)
end 

function PANEL:PerformLayout(w, h)
    self.sideContainer:Dock(LEFT)
    self.sideContainer:SetWide(w * 0.09) -- i think im too used to web design now

    if(self.sidebar) then
        self.sidebar:Dock(FILL)
        self.close:SetWidth(self.sideContainer:GetWide())

        self.master:Dock(FILL)
        
        if(self.close) then 
            self.close:Dock(BOTTOM)
            self.close:SetWidth(self.sideContainer:GetWide())
            self.close:SetHeight(self.sideContainer:GetWide())
        end 
    end 

    self:PostPerformLayout() -- aka once everything is loaded
end
function PANEL:PostPerformLayout() end 

vgui.Register("yaws.frame", PANEL, "EditablePanel")