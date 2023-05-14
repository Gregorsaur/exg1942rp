local MaxW = ScrW() * .4
local MaxH = ScrH() * .2

function talkablenpcs.dialog(name, model, profession, place_of_employment, dialog, sound)
    local npc_name = name
    local npc_model = model
    local npc_profession = profession
    local npc_place_of_employment = place_of_employment
    self = vgui.Create("WolfFrame")
    self:SetTitle(name .. " - " .. place_of_employment .. " " .. profession)
    self:SetPos(ScrW() * .5 - MaxW * .5, ScrH() - MaxH * 1.5)
    self:SetSize(MaxW, MaxH)
    self:MakePopup()
    self:ShowCloseButton(true)
    self.ModelPanel = vgui.Create("DModelPanel", self)
    self.ModelPanel:SetFOV(70)
    self.ModelPanel:SetPos(3, 3)
    self.ModelPanel:SetSize(MaxH - 6, MaxH - 6)
    self.ModelPanel:SetLookAt(Vector(-1, 0, 66))
    self.ModelPanel:SetModel(npc_model)
    self.credentials = vgui.Create("DLabel", self)
    self.credentials:SetFont("WB_Large")
    self.credentials:SetText("Name: " .. name .. "\n" .. "Occupation: " .. profession .. "\n" .. "Affiliation: " .. place_of_employment)
    self.credentials:SizeToContents()
    self.credentials:SetPos(250, 35)
    self.buttonbox = vgui.Create("DPanel", self)
    self.buttonbox:SetSize((ScrW() * .5 - MaxW * .5) / 1.11, ScrH() - MaxH * 1.5)
    self.buttonbox:Dock(RIGHT)
    self.closebutton = vgui.Create("WButton", self.buttonbox)
    self.closebutton:SetHeight(20)
    self.closebutton:SetColorAcc(Color(30, 31, 33))
    self.closebutton:SetupHover(Color(35, 36, 38))
    self.closebutton:SetTextColor(color_white)
    self.closebutton:SetText("Close")
    self.closebutton:Dock(BOTTOM)
    self.closebutton:DockMargin(0, 0, 0, 5)

    self.closebutton.DoClick = function(ply)
        self:Close()
        self:Remove()
    end

    self.speakbutton = vgui.Create("WButton", self.buttonbox)
    self.speakbutton:SetHeight(20)
    self.speakbutton:SetText("Speak to " .. name)
    self.speakbutton:Dock(BOTTOM)
    self.speakbutton:DockMargin(0, 0, 0, 5)
    self.speakbutton:SetColorAcc(Color(30, 31, 33))
    self.speakbutton:SetupHover(Color(35, 36, 38))
    self.speakbutton:SetTextColor(color_white)

    self.speakbutton.DoClick = function(ply)
        self:Close()
        self:Remove()
        dialog(name, model, profession, place_of_employment)
    end
end

function talkablenpcs.dialogframe(name, model, profession, place_of_employment)
    self = vgui.Create("WolfFrame")
    self:SetTitle(name .. " - " .. place_of_employment .. " " .. profession)
    self:SetPos(ScrW() * .5 - MaxW * .5, ScrH() - MaxH * 1.5)
    self:SetSize(MaxW, MaxH)
    self:MakePopup()
    self:ShowCloseButton(true)
    self.ModelPanel = vgui.Create("DModelPanel", self)
    self.ModelPanel:SetFOV(70)
    self.ModelPanel:SetCamPos(Vector(14, 0, 60))

    function self.ModelPanel:LayoutEntity(Entity)
    end

    self.ModelPanel:SetPos(3, 3)
    self.ModelPanel:SetSize(MaxH - 6, MaxH - 6)
    self.ModelPanel:SetLookAt(Vector(-1, 0, 66))
    self.ModelPanel:SetModel(model)
    self.buttonbox = vgui.Create("DPanel", self)
    self.buttonbox:SetSize((ScrW() * .5 - MaxW * .5) / 1.11, ScrH() - MaxH * 1.5)
    self.buttonbox:Dock(RIGHT)
end

function talkablenpcs.dialogbutton(text, height, doclick)
    self.button = vgui.Create("WButton", self.buttonbox)
    self.button:SetText(text)
    self.button:Dock(BOTTOM)
    self.button:SetColorAcc(Color(30, 31, 33))
    self.button:SetupHover(Color(35, 36, 38))
    self.button:DockMargin(0, 0, 0, 5)
    self.button:SetTextColor(color_white)
    self.button:SetTall(height)

    self.button.DoClick = function(len, ply)
        doclick()
    end
end

function talkablenpcs.dialogtext(text, height)
    self.text = vgui.Create("RichText", self.buttonbox)

    if not height then
        self.text:SetTall(55)
    else
        self.text:SetTall(height)
    end

    self.text.Paint = function()
        self.text.m_FontName = "WB_Small"
        self.text:SetFontInternal("WB_Small")
        self.text:SetBGColor(Color(0, 0, 0, 0))
        self.text.Paint = nil
    end

    self.text:Dock(TOP)
    self.text:AppendText(text)
end

function talkablenpcs.dialogtextlong(text, height)
end

function talkablenpcs.playsound(sound)
    if CLIENT then
        LocalPlayer():EmitSound(sound)
    end
end

function talkablenpcs.npctext(name, desc)
    local TEXT_OFFSET = Vector(0, 0, 20)
    local toScreen = FindMetaTable("Vector").ToScreen
    local colorAlpha = ColorAlpha
    local drawText = nut.util.drawText
    local configGet = nut.config.get
    ENT.DrawEntityInfo = true

    function ENT:onDrawEntityInfo(alpha)
        local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
        local x, y = position.x, position.y
        drawText(name, x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
        drawText(desc, x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
    end
end