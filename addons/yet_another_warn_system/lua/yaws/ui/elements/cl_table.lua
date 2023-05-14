-- this is some weird and messy ass code 
-- initally tried to style a dlistview but it didn't want to listen to me trying
-- my hardest to get it to paint properly so here we are
local PANEL = {}

function PANEL:Init()
    self.columns = {}
    self.values = {}
    self.panels = {}

    self.drawDividersInBody = true

    self.columnPanel = vgui.Create("DPanel", self)
    self.columnPanel.Paint = function(panel, w, h) 
        local colors = YAWS.UI.ColorScheme()

        local curPos = 0
        for k,v in ipairs(self.columns) do 
            draw.SimpleText(v.name, "yaws.8", curPos + (h / 4), h / 2, colors['text_header'], 0, 1)
            curPos = curPos + (w * v.scale)
        end 

        draw.RoundedBox(0, 0, h - 1, w, 1, colors['divider'])
    end 

    self.scroll = vgui.Create("yaws.scroll", self)
    -- self.scroll.vBar:Remove()
end 

function PANEL:AddColumn(name, scale)
    self.columns[#self.columns + 1] = {
        name = name,
        scale = scale
    }
end 

function PANEL:RemoveDividersInBody()
    self.drawDividersInBody = false
end 
function PANEL:SetCenterMessage(key)
    self.centerText = key
end 

function PANEL:AddEntry(onclick, menu, ...)
    local values = {...}
    if(#values != #self.columns) then return end 
    
    self.values[#self.values + 1] = values

    local panel
    if(onclick) then 
        panel = vgui.Create("DButton", self.scroll)
    else 
        panel = vgui.Create("DPanel", self.scroll)
    end 
    panel:Dock(TOP)
    panel:SetTall(35)
    panel.Paint = function(panel, w, h)
        local colors = YAWS.UI.ColorScheme()

        local curPos = 0
        for k,v in ipairs(values) do 
            local size = (w * self.columns[k].scale)

            draw.SimpleText(YAWS.UI.CutoffText(tostring(v), "yaws.7", size), "yaws.7", curPos + (h / 4), h / 2, colors['text_main'], 0, 1)
            curPos = curPos + size
        end 

        draw.RoundedBox(0, 0, h - 1, w, 1, colors['divider_faded'])
    end
    if(onclick) then 
        panel:SetText("")
        panel.DoClick = function()
            onclick()
        end
    end 
    if(menu) then 
        panel.DoRightClick = function()
            local options = DermaMenu()
            for k,v in ipairs(menu) do 
                local x = options:AddOption(v.name, v.func)
                if(v.icon) then 
                    x:SetIcon(v.icon)
                end
            end
            options:Open()
        end
    end 
    self.panels[#self.values] = panel
end 

function PANEL:PerformLayout(w, h)
    self.columnPanel:Dock(TOP)
    self.columnPanel:SetHeight(math.min(40, h * 0.2))
    
    self.scroll:Dock(FILL)
    
    self:LayoutShadows(w, h)
    self:PostPerformLayout(w, h)
end 

function PANEL:Paint(w, h)
    local colors = YAWS.UI.ColorScheme() 
    draw.RoundedBox(0, 0, 0, w, h, colors['panel_background'])

    local curPos = 0
    for k,v in ipairs(self.columns) do 
        local height = h - 1
        if(!self.drawDividersInBody) then 
            height = self.columnPanel:GetTall() - 1
        end 

        draw.RoundedBox(0, curPos + (w * v.scale), 0, 1, height + 1, colors['divider'])
    
        curPos = curPos + (w * v.scale)
    end 

    -- if(self.centerText != nil) then 
    --     draw.SimpleText(YAWS.Language.GetTranslation(self.centerText), "yaws.8", w / 2, h / 2, colors['text_main'], 1, 1)
    -- end
    self:CenterPaint(w, h)
end 

function PANEL:CenterPaint(w, h) end 

function PANEL:FindBestSize()
    local newSizes = {}
    for k,v in ipairs(self.columns) do 
        surface.SetFont("yaws.8")
        local columnSize = surface.GetTextSize(v.name) + (self.columnPanel:GetTall() / 4)

        for x,y in pairs(self.values) do 
            local value = y[k]
            local size = (self:GetWide() * self.columns[k].scale)
            surface.SetFont("yaws.7") 
            columnSize = math.Max(columnSize, surface.GetTextSize(YAWS.UI.CutoffText(value, "yaws.7", size)))
        end 

        newSizes[k] = columnSize
    end

    local totalWidth = 0
    for k,v in ipairs(self.columns) do 
        local newWidth = newSizes[k] / self:GetWide()
        self.columns[k].scale = newWidth
        totalWidth = totalWidth + newSizes[k]
    end

    if(totalWidth < self:GetWide()) then 
        -- Scale the columns out so they match the panel width
        local scale = (self:GetWide() / totalWidth)
        for k,v in ipairs(self.columns) do 
            self.columns[k].scale = self.columns[k].scale * scale
        end
    end
end 

function PANEL:Clear()
    for k,v in ipairs(self.panels) do 
        v:Remove()
    end 

    self.values = {}
    self.panels = {}
end 

vgui.Register("yaws.table", PANEL, "yaws.panel")