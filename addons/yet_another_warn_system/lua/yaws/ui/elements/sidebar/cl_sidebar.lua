local PANEL = {}

function PANEL:Init()
    self.tabs = {}
    self.selected = -1

    -- unsure if to keep this
    self.sideShadow = vgui.Create("yaws.shadow", self:GetParent())
    self.bottomShadow = vgui.Create("yaws.shadow", self:GetParent())
    self.bottomShadow:Down()
end 
function PANEL:Paint(w, h)
    local colors = YAWS.UI.ColorScheme() 
    draw.RoundedBox(0, 0, 0, w, h, colors['bar_background'])
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

function PANEL:NoShadows()
    self.renderShadow = false
end 

function PANEL:AddTab(name, icon, selectable, callback)
    self.tabs[#self.tabs + 1] = {
        name = name,
        icon = icon,
        callback = callback,
        selectable = selectable,
        bottom = false,
        element = nil
    }

    local element = vgui.Create("yaws.sidebar_button", self)
    element:SetName(name)
    element:SetIcon(icon)
    element:AllowSelectable(selectable)
    element:SetCallback(callback)
    element.id = #self.tabs
    self.tabs[#self.tabs].element = element
    self.tabs[#self.tabs].id = id

    self:InvalidateLayout()
end 
function PANEL:AddBottomTab(name, icon, selectable, callback)
    self.tabs[#self.tabs + 1] = {
        name = name,
        icon = icon,
        callback = callback,
        selectable = selectable,
        bottom = true,
        element = nil
    }

    local element = vgui.Create("yaws.sidebar_button", self)
    element:SetName(name)
    element:SetIcon(icon)
    element:AllowSelectable(selectable)
    element:SetCallback(callback)
    element.id = #self.tabs
    self.tabs[#self.tabs].element = element
    self.tabs[#self.tabs].id = id

    self:InvalidateLayout()
end 

function PANEL:PerformLayout(w, h)
    self:PerformLayoutInternal() 

    -- self:Dock(LEFT)
    -- self:DockPadding(0, 0, 0, 0)
    -- self:SetWide(self:GetTall() * 0.15)

    for k,v in pairs(self.tabs) do 
        if(!v.element) then continue end 

        if(v.bottom) then 
            v.element:Dock(TOP)
        else 
            v.element:Dock(TOP)
        end 
        v.element:SetHeight(v.element:GetWide())
    end 
    self:LayoutShadows(w, h)

    self:PostPerformLayout()
end 

function PANEL:PostPerformLayout() end 

function PANEL:SetSelected(tabID)
    if(self.selected == tabID) then return end 
    
    self:UpdateSelected(id)
    self.tabs[tabID].element:DoClick()
    self.selected = tabID
end 
function PANEL:SetSelectedName(name)
    -- this is crude but it should be fine
    for k,v in pairs(self.tabs) do
        if(v.name == name) then
            self:SetSelected(k)
            -- v.element:DoClick()
            break
        end
    end
end 

function PANEL:UpdateSelected(tabID) 
    for k,v in ipairs(self.tabs) do
        if(!v.element) then continue end 
        if(v.element.id == tabID) then continue end
        v.element.selected = false
    end 
end 

-- who thought changing a DPanel base to a yaws.scroll base would be a really shitty, autism inducing idea?
-- at least you can't have too many tabs now
vgui.Register("yaws.sidebar", PANEL, "yaws.scroll")