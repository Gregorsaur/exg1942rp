local PANEL = {}

function PANEL:Init()
    local colors = YAWS.UI.ColorScheme()
    
    self:SetTextColor(colors['text_main'])
    self:SetFont("yaws.6")

    self.disableTint = Color(0, 0, 0, 50)
    self.DropButton.ChevPreviousState = nil
    self.DropButton.Paint = function(s, w, h)
        -- local triangle = {
        -- 	{x = 0, y = (h * 0.3)},
        --     {x = w * 0.8, y = (h * 0.3)},
        -- 	{x = (w * 0.8) / 2, y = (h * 0.7)},
        -- }

        -- YAWS.UI.SetSurfaceDrawColor(colors['text_main'])
    	-- draw.NoTexture()
    	-- surface.DrawPoly(triangle)

        self.DropButton.ChevPreviousState = YAWS.UI.DrawAnimatedChevron(0, 0, w, h, self.DropButton.ChevPreviousState, self:IsMenuOpen())
    end
    
    self.frameTime = 0
    self.borderColor = YAWS.UI.ColorScheme()['text_entry_border_inactive']

    self.sideShadow = vgui.Create("yaws.shadow", self:GetParent())
    self.bottomShadow = vgui.Create("yaws.shadow", self:GetParent())
    self.bottomShadow:Down()
end

function PANEL:Paint(w, h)
    self.frameTime = RealFrameTime()
    local colors = YAWS.UI.ColorScheme()
    
    -- don't question this
    if(self:IsMenuOpen()) then 
        self.borderColor = YAWS.UI.LerpColor(self.frameTime * 5, self.borderColor, colors['text_entry_border_active'])
    else
        self.borderColor = YAWS.UI.LerpColor(self.frameTime * 5, self.borderColor, colors['text_entry_border_inactive'])
    end 
    
    draw.RoundedBox(0, 0, 0, w, h, self.borderColor)
    draw.RoundedBox(0, 1, 1, w - 2, h - 2, colors['input_bg'])
    
    -- self:DrawTextEntryText(colors["text_main"], colors["theme"], colors["theme"])

    if(!self:IsEnabled()) then 
        draw.RoundedBox(0, 0, 0, w, h, self.disableTint)
        self:DrawTextEntryText(colors["text_placeholder"], colors["theme"], colors["theme"])
    else 
        self:DrawTextEntryText(colors["text_main"], colors["theme"], colors["theme"])
    end 
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

function PANEL:PerformLayout(w, h)
    self.DropButton:Dock(RIGHT)
    self.DropButton:DockMargin(0, h * 0.35, h * 0.35, h * 0.35)
    self.DropButton:SetSize(h * 0.55, h * 0.1)

    -- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dcombobox.lua#L81
	-- Make sure the text color is updated
	DButton.PerformLayout( self, w, h )

    self:LayoutShadows(w, h)
end 

-- fuck this
-- function PANEL:OnMenuOpened(menu)
--     local colors = YAWS.UI.ColorScheme()

--     self.Menu.Paint = function(s, w, h)
--         draw.RoundedBox(0, 0, 0, w, h, self.borderColor)
--         draw.RoundedBox(0, 1, 0, w - 2, h - 1, colors['input_bg'])
--     end

--     local options = self.Menu:GetChildren()
--     for k,v in ipairs(options) do
--         v.Paint = function(s, w, h)
--             if(!self:IsHovered()) then return end 
--             draw.RoundedBox(0, 1, 0, w - 2, h - 1, colors['bar_background'])
--         end 
--     end 
-- end 

function PANEL:Dim() end -- stub incase i forget to remove any calls that use it 

vgui.Register("yaws.combo", PANEL, "DComboBox")