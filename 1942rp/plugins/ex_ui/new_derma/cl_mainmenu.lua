local PLUGIN = PLUGIN
local PANEL = {}
DEFINE_BASECLASS('EditablePanel')

local BGs = PLUGIN.backgrounds
local eagle = nut.util.getMaterial('external_g/eagle.png')
local click_sound = 'weapons/grenade/tick1.wav'
local function playClickSound()
    surface.PlaySound(click_sound)
end

function PANEL:Init()
    if IsValid(nut.gui.newCharMenu) then
        nut.gui.newCharMenu:Remove()
    end
    nut.gui.newCharMenu = self
    self:SetSize(ScrW(), ScrH())
    self:SetPos(0, 0)
    self:MakePopup()

    self.background = self:Add('EditablePanel')
    self.background:SetSize(ScrW(), ScrH())
    self.background:SetPos(0, 0)

    self:CreateBG()
    self.bg_initialized = true

    self.list = self:Add('DScrollPanel')
    self.list:SetSize(ScrW() * .24, ScrH() * .5)
    self.list:SetPos(ScrW() * .082, (ScrH() * .635) - (ScrH() * .5)/2)

    self.logo = self:Add('EditablePanel')
    self.logo:SetSize(ScrW() * .243, ScrH() * .15)
    self.logo:SetPos(ScrW() * .082, ScrH() * .15)
    self.logo.Paint = function(me, w, h)
        -- placeholder image
        surface.SetMaterial(eagle)

        surface.SetDrawColor(0, 0, 0)
        surface.DrawTexturedRect((w / 2) - w/4 + 1, 1, w / 2, h)

        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRect((w / 2) - w/4, 0, w / 2, h)
    end

    self.selected = self:Add('EditablePanel')
    self.selected:SetSize(ScrW() * .25, ScrH() * .05)
    self.selected:SetPos((ScrW() * .5) - (ScrW() * .25)/2, ScrH() - (ScrH() * .1))
    self.selected.alpha = 0
    self.selected.Paint = function(me, w, h)
        if me.text == '' then
            me.alpha = Lerp(math.ease.InOutCirc(0.1), me.alpha, 0)
        else
            me.alpha = Lerp(math.ease.InOutCirc(0.1), me.alpha, 255)
        end

        me:SetAlpha(me.alpha)
        surface.SetDrawColor(0, 0, 0, 166)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(255, 255, 255)
        surface.DrawRect(0, 0, 2, h)

        draw.Text({
            text = self.selected.text:upper(),
            font = 'nutEgMainMenu',
            pos = {w / 2, h / 2},
            xalign = TEXT_ALIGN_CENTER,
            yalign = TEXT_ALIGN_CENTER,
            color = me.text_color
        })
    end
    self.selected.text = ''

    if LocalPlayer():getChar() then
        self:CreateButton('Resume', 'Return to game', function()
            if IsValid(nut.gui.bgMusic) then
                nut.gui.bgMusic:Remove()
            end
            self:Remove()
        end)
    end

    if #nut.characters > 0 then
        self:CreateButton('Characters', 'Your characters', function(me)
            if me.pressed then return end
            self:MoveTo(0, ScrH(), .8, 0, -1, function()
                self:Remove()
            end)
            vgui.Create('nsNewCharactersMenu')
        end)
    end

	if (hook.Run('CanPlayerCreateCharacter', LocalPlayer()) ~= false) && self:CanCreateCharacter() then
        self:CreateButton('New Character', 'Create a new character', function(me)
            if me.pressed then return end
            self:MoveTo(0, -ScrH(), .8, 0, -1, function()
                self:Remove()
            end)
            vgui.Create('nsNewCreateCharacterMenu')
        end)
	end

    self:CreateButton('Discord', 'Our Discord server', function()
        gui.OpenURL(PLUGIN.discordURL)
    end)

    self:CreateButton('Website', 'Our website', function()
        gui.OpenURL(PLUGIN.websiteURL)
    end)

    self:CreateButton('Exit', 'Disconnect from server', function(me)
        vgui.Create('nutNewCharacterConfirm')
            :setTitle(L('disconnect'):upper()..'?')
            :setMessage(L('You will disconnect from the server.'):upper())
            :onConfirm(function() LocalPlayer():ConCommand('disconnect') end)
    end)

    if not IsValid(nut.gui.bgMusic) then
	    nut.gui.bgMusic = vgui.Create('nutNewCharBGMusic')
    end
end

function PANEL:CanCreateCharacter()
	local validFactions = {}
	for k, v in pairs(nut.faction.teams) do
		if (nut.faction.hasWhitelist(v.index)) then
			validFactions[#validFactions + 1] = v.index
		end
	end

	if (#validFactions == 0) then
		return false
	end
	self.validFactions = validFactions

	local maxChars = hook.Run('GetMaxPlayerCharacter', LocalPlayer())
		or nut.config.get('maxChars', 5)
	if (nut.characters and #nut.characters >= maxChars) then
		return false
	end

	local canCreate = hook.Run('ShouldMenuButtonShow', 'create')
	if (canCreate == false) then
		return false
	end

	return true
end

local function DrawTexturedRectRotatedPoint(x, y, w, h, rot, x0, y0)
	local c = math.cos( math.rad( rot ) )
	local s = math.sin( math.rad( rot ) )

	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s

	surface.DrawTexturedRectRotated( x + newx, y + newy, w, h, rot )
end

local btnIcon = nut.util.getMaterial('external_g/swastika.png')
function PANEL:CreateButton(text, description, callback)
    local btn = self.list:Add('DButton')
    btn:SetText('')
    btn:Dock(TOP)
    btn:DockMargin(5, 5, 5, 5)
    btn.tall = ScrH() * .064/2
    btn.width = 2
    btn.text_color = color_white
    btn.icon_rot = 0
    btn.text = text
    btn.pressed = false
    btn.text_x = btn:GetWide() * 0.09
    btn:SetTall(btn.tall)
    btn.Paint = function(me, w, h)
        if me:IsHovered() then
            me.tall = Lerp(math.ease.InOutCirc(0.2), me.tall, ScrH() * .064)
            me.width = Lerp(math.ease.InOutCirc(0.2), me.width, w + 1)
            me.text_color = LerpColor(math.ease.InOutCirc(0.2), me.text_color, color_black)
            me.text_x = Lerp(math.ease.InOutCirc(0.2), me.text_x, w * 0.14)
            --me.icon_rot = -(CurTime() * 360)
            self.selected.text = description || 'No description'
        else
            me.tall = Lerp(math.ease.InOutCirc(0.2), me.tall, ScrH() * .064 / 1.5)
            me.width = Lerp(math.ease.InOutCirc(0.2), me.width, 2)
            me.text_color = LerpColor(math.ease.InOutCirc(0.2), me.text_color, color_white)
            me.text_x = Lerp(math.ease.InOutCirc(0.2), me.text_x, w * 0.09)
        end

        surface.SetDrawColor(0, 0, 0, 166)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(255, 255, 255)
        surface.DrawRect(0, 0, btn.width, h)

        me:SetTall(btn.tall)
        draw.Text({
            text = me.text:upper(),
            font = 'nutEgMainMenu',
            pos = {me.text_x, h / 2},
            xalign = TEXT_ALIGN_LEFT,
            yalign = TEXT_ALIGN_CENTER,
            color = me.text_color
        })

        surface.SetDrawColor(me.text_color)
        surface.SetMaterial(btnIcon)
        --surface.DrawTexturedRect((h / 2) - (h/2) / 2, (h / 2) - (h/2) / 2, h / 2, h / 2)

        DrawTexturedRectRotatedPoint(h / 2, h / 2, h / 2, h / 2, me.icon_rot, 0, 0)
    end
    btn.DoClick = function(me)
        playClickSound()
        callback(me)
        me.pressed = true
    end
end

function PANEL:Fade()
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end

local oBackground = 0
local function performBackground()
    oBackground = oBackground + 1
    if not BGs[oBackground] then
        oBackground = 1
    end

    local chosen = BGs[oBackground]
    return chosen
end

function PANEL:CreateBG()
    local background = performBackground()

    local bg = self.background:Add('EditablePanel')
    bg:SetSize(self:GetWide(), self:GetTall())
    if self.bg_initialized then
        bg:SetPos(ScrW(), 0)

        bg:MoveTo(0, 0, 1, 0, -1, function()
            timer.Simple(8, function()
                if not IsValid(self) then return end
                bg:MoveTo(-ScrW(), 0, 1, 0, -1, function()
                    bg:Remove()
                end)
    
                self:CreateBG()
            end)
        end)
    else
        bg:SetPos(0, 0)
        timer.Simple(8, function()
            if not IsValid(self) then return end
            bg:MoveTo(-ScrW(), 0, 1, 0, -1, function()
                bg:Remove()
            end)

            self:CreateBG()
        end)
    end

    bg.Paint = function(me, w, h)
        local x, y = (nut.gui.newCharMenu && not self.bClosing) && select(1, input.GetCursorPos())*.02 || 0, (nut.gui.newCharMenu && not self.bClosing) && select(2, input.GetCursorPos())*.02 || 0
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(background)
        surface.DrawTexturedRect(x, y, w, h)
    end
end

function PANEL:Remove()
    self.bClosing = true
    self:AlphaTo(0, .3, 0, function()
        BaseClass.Remove(self)
    end)
end

vgui.Register('nsNewCharacterMenu', PANEL, 'EditablePanel')