-- reusing code from betterbanking to save time here
-- had to go through it and fix my mess of lerp shit tho
local PANEL = {}

function PANEL:Init()
    self:SetText("")

    local colors = YAWS.UI.ColorScheme()
    self.color = color_white
    self.bgColor = colors["switch_bg"]

    self.fade = true

    self.stateSet = false
    self.value = false

    self.frameTime = RealFrameTime()
    self.lerp = self:GetTall() / 2
    self.lerpC = self.color
    self.lerpB = self.bgColor

    self.fadedColor = Color(200, 200, 200)
    self.fadedColorTwo = Color(50, 50, 50)

    self:SetSize(40, 20)
end

function PANEL:SetColor(clr)
    self.color = YAWS.UI.TintColor(clr, 50)
    self.lerpC = YAWS.UI.TintColor(clr, 50)

    self.bgColor = YAWS.UI.TintColor(clr, -50)
    self.lerpB = self.bgColor
end
function PANEL:SetBGColor(clr)
    self.bgColor = clr
    self.lerpB = self.bgColor
end
function PANEL:SetFade(fade)
    self.fade = fade
end
function PANEL:SetValue(value)
    self.value = value
    self:ResetLerp()

    self.OnToggle(self.value)
end
function PANEL:GetValue(value)
    return self.value
end
function PANEL:Toggle()
    if(self.locked) then return end
    self.value = !self.value

    self.OnToggle(self.value)
end

function PANEL:OnToggle(value)
end

function PANEL:DoClick()
    self:Toggle()
end

function PANEL:Paint(w, h)
    self.frameTime = RealFrameTime()

    if(self.value) then
        self.lerp = Lerp(self.frameTime * 5, self.lerp, w - (h / 2))
        if(self.fade) then
            self.lerpC = YAWS.UI.LerpColor(self.frameTime * 5, self.lerpC, self.color)
            self.lerpB = YAWS.UI.LerpColor(self.frameTime * 5, self.lerpB, self.bgColor)
        end
    else
        self.lerp = Lerp(self.frameTime * 5, self.lerp, h / 2)
        if(self.fade) then
            self.lerpC = YAWS.UI.LerpColor(self.frameTime * 5, self.lerpC, self.fadedColor)
            self.lerpB = YAWS.UI.LerpColor(self.frameTime * 5, self.lerpB, self.fadedColorTwo)
        end
    end

    draw.RoundedBox(h / 2, 2, 2, w - 4, h - 4, self.lerpB)

    surface.SetDrawColor(self.lerpC.r, self.lerpC.g, self.lerpC.b)
    YAWS.UI.DrawCircle(self.lerp, h / 2, h / 2, 15)

    if(YAWS.UserSettings.GetValue("switch_icons")) then
        YAWS.UI.SetSurfaceDrawColor(self.lerpB) 
        if(self.value) then 
            surface.SetMaterial(YAWS.UI.MaterialCache['check'])
        else 
            surface.SetMaterial(YAWS.UI.MaterialCache['close'])
        end 
        surface.DrawTexturedRect(self.lerp - (h / 4), h / 4, h / 2, h / 2)
    end
end
function PANEL:ResetLerp()
    if(self.value) then
        self.lerp = self:GetWide() - (self:GetTall() / 2)
        if(self.fade) then
            self.lerpC = self.color
            self.lerpB = self.bgColor
        end
    else
        self.lerp = self:GetTall() / 2
        if(self.fade) then
            self.lerpC = self.fadedColor
            self.lerpB = self.fadedColorTwo
        end
    end
end 
function PANEL:PerformLayout()
    if(self.stateSet) then return end 
    self:ResetLerp()
    self.stateSet = true 
end 

vgui.Register("yaws.switch", PANEL, "DButton")