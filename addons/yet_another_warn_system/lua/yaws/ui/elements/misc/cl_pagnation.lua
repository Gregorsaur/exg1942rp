local PANEL = {}

function PANEL:Init()
    -- this was initially going to be a infinite scroll, but thats stupid to
    -- implement properly in gmod

    self.page = 1
    self.itemsMax = -1
    self.pageCount = -1
    self.buttons = {}
    self.loadRotation = 0

    self.nextButton = vgui.Create("yaws.iconbtn", self)
    self.nextButton:SetIconPadding(8)
    self.nextButton:SetMaterial(YAWS.UI.MaterialCache['arrow'])
    self.nextButton.DoClick = function()
        self:NextPage()
    end
    
    self.prevButton = vgui.Create("yaws.iconbtn", self)
    self.prevButton:SetIconPadding(8)
    self.prevButton:FlipIcon(true)
    self.prevButton:SetMaterial(YAWS.UI.MaterialCache['arrow'])
    self.prevButton.DoClick = function()
        self:PrevPage()
    end


    self.startButton = vgui.Create("yaws.iconbtn", self)
    self.startButton:SetIconPadding(8)
    self.startButton:SetMaterial(YAWS.UI.MaterialCache['double_arrow'])
    self.startButton:FlipIcon(true)
    self.startButton.DoClick = function()
        self:SetPage(1)
    end
    
    self.endButton = vgui.Create("yaws.iconbtn", self)
    self.endButton:SetIconPadding(8)
    self.endButton:SetMaterial(YAWS.UI.MaterialCache['double_arrow'])
    self.endButton.DoClick = function()
        self:SetPage(self.pageCount)
    end

    self.sideShadow = vgui.Create("yaws.shadow", self:GetParent())
    self.bottomShadow = vgui.Create("yaws.shadow", self:GetParent())
    self.bottomShadow:Down()
end 

function PANEL:RefreshPage(page, offset, amount) end 

function PANEL:SetItemCount(count)
    self.itemsMax = count
    self.pageCount = math.ceil(count / YAWS.ManualConfig.PagnationCount)
    self:CalculatePageSelections()
end

function PANEL:CalculatePageSelections()
    if(#self.buttons > 0) then 
        for k,v in ipairs(self.buttons) do
            v:Remove()
        end
    end 
end 

function PANEL:NextPage()
    self:SetPage(self.page + 1)
end 
function PANEL:PrevPage()
    self:SetPage(self.page - 1)
end 

function PANEL:SetPage(page)
    if(page == self.page) then return end -- unnessasary data requests are the devils friend
    if(page < 1 || page > self.pageCount) then return end
    self.page = page
    self:RefreshPage(self.page, (self.page - 1) * YAWS.ManualConfig.PagnationCount, YAWS.ManualConfig.PagnationCount)
end 

function PANEL:PerformLayout(w, h)
    self.prevButton:Dock(LEFT)
    self.prevButton:SetSize(h, h)
    self.startButton:Dock(LEFT)
    self.startButton:SetSize(h, h)

    self.nextButton:Dock(RIGHT)
    self.nextButton:SetSize(h, h)
    self.endButton:Dock(RIGHT)
    self.endButton:SetSize(h, h)

    self:LayoutShadows(w, h)
end 

function PANEL:Paint(w, h)
    local colors = YAWS.UI.ColorScheme() 
    
    draw.RoundedBox(0, 0, 0, w, h, colors['panel_background'])

    if(YAWS.UI.CurrentData.WaitingForPagnatedResponse) then 
        self.loadRotation = Lerp(RealFrameTime() * 100, self.loadRotation, self.loadRotation + 1)

        local wt = draw.SimpleText(YAWS.Language.GetTranslation("loading"), "yaws.7", w / 2 + (h / 4), h / 2, colors['text_header'], 1, 1)

        draw.NoTexture()
        surface.SetMaterial(YAWS.UI.MaterialCache['load'])
        YAWS.UI.SetSurfaceDrawColor(colors["text_main"])
        surface.DrawTexturedRectRotated(w / 2 - (wt / 2) - 5, h / 2, h / 2, h / 2, self.loadRotation)
    else 
        draw.SimpleText(YAWS.Language.GetFormattedTranslation("page_format", self.page, math.max(self.pageCount, 1)), "yaws.7", w / 2, h / 2, colors['text_header'], 1, 1)
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

vgui.Register("yaws.pagnation", PANEL, "DPanel")