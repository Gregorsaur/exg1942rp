local notifTypes = {
    [1] = {
        col = Color(200, 60, 60),
        icon = "icon16/exclamation.png"
    },
    -- ERROR
    [2] = {
        col = Color(255, 100, 100),
        icon = "icon16/cross.png"
    },
    -- COULD BE CANCELED
    [3] = {
        col = Color(255, 100, 100),
        icon = "icon16/cancel.png"
    },
    -- WILL BE CANCELED
    [4] = {
        col = Color(100, 185, 255),
        icon = "icon16/book.png"
    },
    -- TUTORIAL/GUIDE
    [5] = {
        col = Color(64, 185, 85),
        icon = "icon16/accept.png"
    },
    -- YES
    [7] = {
        col = Color(100, 185, 255),
        icon = "icon16/information.png"
    }
}

-- NORMAL
NOT_COULDBECANCELLED = 2
NOT_WILLBECANCELLED = 3
NOT_TUTORIAL = 4
NOT_ERROR = 1
NOT_CORRECT = 5
NOT_NORMAL = 7
-- List of notice panels.
nut.noticess = nut.noticess or {}
--Enums
local NORMAL_NOTICE_HEIGHT = 36
local QUERY_NOTICE_HEIGHT = NORMAL_NOTICE_HEIGHT * 2.3
local NOTICE_MARGIN = 5
local DEFAULT_NOTICE_TYPE = 7

-- Move all notices to their proper positions.
local function OrganizeNotices()
    --Calculating every height of every panel BEFORE the one we need to rearrange
    --Panels to rearrange
    for k, v in ipairs(nut.noticess) do
        local topMargin = 0

        --All panels before (calculate margin)
        for k2, v2 in pairs(nut.noticess) do
            if k < k2 then
                topMargin = topMargin + v2:GetTall() + NOTICE_MARGIN
            end
        end

        v:MoveTo(v:GetX(), topMargin + 5, 0.15, 0, 5)
    end
end

function removeNotice(notice)
    -- Search for the notice to remove.
    for k, v in ipairs(nut.noticess) do
        if v == notice then
            notice:SizeTo(notice:GetWide(), 0, 0.2, 0, -1, function()
                notice:Remove()
            end)

            -- Remove the notice from the list and move other notices.
            table.remove(nut.noticess, k)
            OrganizeNotices()
            break
        end
    end
end

local function createNoticePanel(length, notimer)
    if not notimer then
        notimer = false
    end

    local notice = vgui.Create("noticePanel")
    notice.start = CurTime() + 0.25
    notice.endTime = CurTime() + length
    notice.oh = notice:GetTall()

    function notice:Paint(w, h)
        local t = notifTypes[7]
        local mat

        if self.notifType ~= nil and not isstring(self.notifType) and self.notifType > 0 then
            t = notifTypes[self.notifType]
            mat = nut.util.getMaterial(t.icon)
        end

        draw.RoundedBox(4, 0, 0, w, h, Color(35, 35, 35, 200))

        --Drawing time progress
        if self.start then
            local w2 = math.TimeFraction(self.start, self.endTime, CurTime()) * w
            local col = (t and t.col) or nut.config.get("color")
            draw.RoundedBox(4, w2, 0, w - w2, h, col)
        end

        --Drawing icon
        if t and mat then
            local sw, sh = 24, 24
            surface.SetDrawColor(color_white)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(20, h / 2 - sh / 2, sw, sh)
        end
    end

    if not notimer then
        timer.Simple(length, function()
            removeNotice(notice)
        end)
    end

    return notice
end

function nut.util.notifQuery(question, option1, option2, manualDismiss, notifType, callback)
    --Some basic variable needy statments
    if not callback or not isfunction(callback) then
        Error("A callback function must be specified")
    end

    if not question or not isstring(question) then
        Error("A question string must be specified")
    end

    --Setting defaults
    if not option1 then
        option1 = "Yes"
    end

    if not option2 then
        option2 = "No"
    end

    if not manualDismiss then
        manualDismiss = false
    end

    local notice = createNoticePanel(10, manualDismiss)
    local i = table.insert(nut.noticess, notice)
    notice.isQuery = true
    notice.text:SetText(question)
    notice:SetPos(0, (i - 1) * (notice:GetTall() + 4) + 4)
    notice:SetTall(QUERY_NOTICE_HEIGHT)
    notice:CalcWidth(120)
    notice:CenterHorizontal()
    notice.notifType = notifType or DEFAULT_NOTICE_TYPE

    if manualDismiss then
        notice.start = nil
    end

    notice.opt1 = notice:Add("DButton")
    notice.opt1:SetAlpha(0)
    notice.opt2 = notice:Add("DButton")
    notice.opt2:SetAlpha(0)
    --Create animation (size up)
    notice.oh = notice:GetTall()
    OrganizeNotices()
    notice:SetTall(0)

    notice:SizeTo(notice:GetWide(), QUERY_NOTICE_HEIGHT, 0.2, 0, -1, function()
        notice.text:SetPos(0, 0)

        local function styleOpt(o)
            o.color = Color(0, 0, 0, 30)
            AccessorFunc(o, "color", "Color")

            function o:Paint(w, h)
                if self.left then
                    draw.RoundedBoxEx(4, 0, 0, w + 2, h, self.color, false, false, true, false)
                else
                    draw.RoundedBoxEx(4, 0, 0, w + 2, h, self.color, false, false, false, true)
                end
            end
        end

        --Creates first option
        if notice.opt1 and IsValid(notice.opt1) then
            notice.opt1:SetAlpha(255)
            notice.opt1:SetSize(notice:GetWide() / 2, 25)
            notice.opt1:SetText(option1 .. " (F8)")
            notice.opt1:SetPos(0, notice:GetTall() - notice.opt1:GetTall())
            notice.opt1:CenterHorizontal(0.25)
            notice.opt1:SetAlpha(0)
            notice.opt1:AlphaTo(255, 0.2)
            notice.opt1:SetTextColor(color_white)
            notice.opt1.left = true
            styleOpt(notice.opt1)

            function notice.opt1:keyThink()
                if input.IsKeyDown(KEY_F8) and (CurTime() - notice.lastKey) >= 0.5 then
                    self:ColorTo(Color(24, 215, 37), 0.2, 0)
                    notice.respondToKeys = false
                    callback(1, notice)

                    timer.Simple(1, function()
                        if notice and IsValid(notice) then
                            removeNotice(notice)
                        end
                    end)

                    notice.lastKey = CurTime()
                end
            end
        end

        --Creates second option
        if notice.opt2 and IsValid(notice.opt2) then
            notice.opt2:SetAlpha(255)
            notice.opt2:SetSize(notice:GetWide() / 2, 25)
            notice.opt2:SetText(option2 .. " (F9)")
            notice.opt2:SetPos(0, notice:GetTall() - notice.opt2:GetTall())
            notice.opt2:CenterHorizontal(0.75)
            notice.opt2:SetAlpha(0)
            notice.opt2:AlphaTo(255, 0.2)
            notice.opt2:SetTextColor(color_white)
            styleOpt(notice.opt2)

            function notice.opt2:keyThink()
                if input.IsKeyDown(KEY_F9) and (CurTime() - notice.lastKey) >= 0.5 then
                    self:ColorTo(Color(24, 215, 37), 0.2, 0)
                    notice.respondToKeys = false
                    callback(2, notice)

                    timer.Simple(1, function()
                        if notice and IsValid(notice) then
                            removeNotice(notice)
                        end
                    end)

                    notice.lastKey = CurTime()
                end
            end
        end

        --Key mapping
        notice.lastKey = CurTime()
        notice.respondToKeys = true

        function notice:Think()
            if not self.respondToKeys then return end
            local queries = {}

            for k, v in pairs(nut.noticess) do
                if v.isQuery then
                    queries[#queries + 1] = v
                end
            end

            for k, v in pairs(queries) do
                if v == self and k > 1 then return end
            end

            if self.opt1 and IsValid(self.opt1) then
                self.opt1:keyThink()
            end

            if self.opt2 and IsValid(self.opt2) then
                self.opt2:keyThink()
            end
        end
    end)

    return notice
end

--Receives a query
netstream.Hook("notifyQuery", nut.util.notifQuery)
--Overwriting the default NS notification derma element
local PANEL = {}

function PANEL:Init()
    self.padding = 60
    self:SetSize(256, 36)
    self:SetContentAlignment(5)
    self.text = self:Add("DLabel")
    self.text:SetText("Unassigned")
    self.text:SetExpensiveShadow(1, Color(0, 0, 0, 150))
    self.text:SetFont("nutMediumFont")
    self.text:SetTextColor(color_white)
    self.text:SetDrawOnTop(true)

    function self.text.Think(this)
        this:SizeToContents()
        this:Center()
    end
end

function PANEL:CalcWidth(padding)
    self.text:SizeToContents()
    self:SetWide(self.text:GetWide() + padding)
end

function PANEL:Paint(w, h)
    nut.util.drawBlur(self, 10)
    surface.SetDrawColor(230, 230, 230, 10)
    surface.DrawRect(0, 0, w, h)

    if self.start then
        local w2 = math.TimeFraction(self.start, self.endTime, CurTime()) * w
        surface.SetDrawColor(nut.config.get("color"))
        surface.DrawRect(w2, 0, w - w2, h)
    end

    surface.SetDrawColor(0, 0, 0, 45)
    surface.DrawOutlinedRect(0, 0, w, h)
end

vgui.Register("noticePanel", PANEL, "DPanel")