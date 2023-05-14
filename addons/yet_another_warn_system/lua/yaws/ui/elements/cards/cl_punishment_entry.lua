local PANEL = {}

function PANEL:Init()
    self.punishmentData = {}
    
    local colors = YAWS.UI.ColorScheme()
    self.bin = vgui.Create("yaws.iconbtn", self)
    self.bin:SetMaterial(YAWS.UI.MaterialCache['trash'], colors['text_header'])
    self.bin.DoClick = function()
        YAWS.UI.CurrentData.WaitingForServerResponse = true 
        YAWS.UI.DisplayLoading(YAWS.UI.CurrentData.MasterCache)
    
        net.Start("yaws.punishments.removepunishment")
        net.WriteUInt(self.punishmentData.threshold, 16)
        net.SendToServer()
    
        YAWS.UI.LoadingCache = {
            panel = "remove_punishment",
            key = self.punishmentData.threshold,
        }
    end

    self.edit = vgui.Create("yaws.iconbtn", self)
    self.edit:SetMaterial(YAWS.UI.MaterialCache['edit'], colors['text_header'])
    self.edit.DoClick = function()
        YAWS.UI.EditPunishment(self.punishmentData)
    end 

    self.descX = nil 

    self.sideShadow = vgui.Create("yaws.shadow", self:GetParent())
    self.bottomShadow = vgui.Create("yaws.shadow", self:GetParent())
    self.bottomShadow:Down()
end 

function PANEL:Paint(w, h)
    local colors = YAWS.UI.ColorScheme()
    draw.RoundedBox(0, 0, 0, w, h, colors["panel_background"])

    local curX = h / 2
    local thresholdWidth = draw.SimpleText(self.punishmentData.threshold, "yaws.9", curX, h / 2, colors['text_header'], 1, 1)

    curX = math.max(h / 2 + 30, h / 2 + thresholdWidth)
    draw.RoundedBox(0, curX, 10, 2, h - 20, colors['divider'])

    curX = curX + 20
    local nW = draw.SimpleText(self.punishmentData.typeInfo.name, "yaws.8", curX, h / 2, colors['text_header'], 0, 1)

    curX = curX + nW + 15
    draw.SimpleText(self.punishmentData.typeInfo.description, "yaws.7", curX, h / 2, colors['text_main'], 0, 1)
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
    self.bin:Dock(RIGHT)
    self.bin:DockMargin(h / 3, h / 3, h / 3, h / 3)
    self.bin:SetWide(h / 3)

    self.edit:Dock(RIGHT)
    self.edit:DockMargin(h / 3, h / 3, 0, h / 3)
    self.edit:SetWide(h / 3)

    self:LayoutShadows(w, h)
end 

function PANEL:SetPunishmentData(threshold, data)
    self.punishmentData = data
    self.punishmentData.threshold = threshold
    self.punishmentData.typeInfo = YAWS.Punishments.Types[data.type]

    -- params:
    --      reason	=	you fucked up lol
    -- type	=	kick
    -- typeInfo:
    --     action	=	function: 0x02cc9d58b768
    --     description	=	Kicks a player from the server if they are online.
    --     name	=	Kick
    --     params:
    --             reason:
    --                     default	=	You reached the warning limit.
    --                     description	=	The reason the target gets kicked.
    --                     name	=	Reason
    --                     type	=	string
end 

vgui.Register("yaws.punishment_entry", PANEL, "DPanel")