-- developed for gmod.store
-- from incredible-gmod.ru with love <3

include("shared.lua")

SWEP.WM_Offsets = {
    ang = Angle(188.69, 175.448, 16.552),
    vec = Vector(4.482759, -4.827586, -1.37931)
}

function SWEP:DrawWorldModel()
    local Owner = self:GetOwner()

    if not IsValid(self._WM) then
        self._WM = ClientsideModel(self.WorldModel)
        self._WM:SetNoDraw(true)
    end

    if IsValid(Owner) then
        local boneid = Owner:LookupBone("ValveBiped.Bip01_R_Hand")
        if not boneid then return end
        local matrix = Owner:GetBoneMatrix(boneid)
        if not matrix then return end
        local newPos, newAng = LocalToWorld(self.WM_Offsets.vec, self.WM_Offsets.ang, matrix:GetTranslation(), matrix:GetAngles())
        self._WM:SetPos(newPos)
        self._WM:SetAngles(newAng)
        self._WM:SetupBones()
    else
        self._WM:SetPos(self:GetPos())
        self._WM:SetAngles(self:GetAngles())
    end

    self._WM:DrawModel()
end

function SWEP:AdjustMouseSensitivity()
    if self:GetOwner():KeyDown(IN_ATTACK2) then return 0 end

    return self:GetZoom() / 140
end

function SWEP:CalcView(_, origin, angles, fov)
    return origin, angles, fov
end

function SWEP:FreezeMovement()
    return self:GetOwner():KeyDown(IN_ATTACK2) or self:GetOwner():KeyReleased(IN_ATTACK2) or self:GetOwner():KeyDown(IN_RELOAD)
end

function SWEP:DrawHUD() end
function SWEP:PrintWeaponInfo() end

local CHudWeaponSelection = {CHudWeaponSelection = true}
function SWEP:HUDShouldDraw(elem)
    if CHudWeaponSelection[elem] then return true end
    return self.DrawInnerShadow == nil
end

SWEP.WepSelectIcon = surface.GetTextureID("vgui/gmod_camera")

local chat_message = {
    Color(227, 68, 47),
    "[P",
    Color(243, 131, 23),
    "OL",
    Color(232, 164, 37),
    "AR",
    Color(127, 178, 60),
    "OI",
    Color(18, 143, 201),
    "D]: ",
    Color(225, 225, 225),
    PolaroidLANG("Photo printing error, as it looks like the polaroid is overheated. Try waiting a couple of seconds and take the photo again.")
}

local OverlayText = {
    Zoom = PolaroidLANG("ZOOM") ..": ",
    Dof = PolaroidLANG("DOF") ..": ",
    Frames = PolaroidLANG("Frames") ..": ",
}

hook.Add("Polaroid/LangsLoaded", "Polaroid/SWEP", function()
    chat_message[#chat_message] = PolaroidLANG("Photo printing error, as it looks like the polaroid is overheated. Try waiting a couple of seconds and take the photo again.")

    OverlayText = {
        Zoom = PolaroidLANG("ZOOM") ..": ",
        Dof = PolaroidLANG("DOF") ..": ",
        Frames = PolaroidLANG("Frames") ..": ",
    }
end)

--[[ method for https://x0.at/ & https://imgur.com/ (we're using pomf based hostings now because its doesnt needs to configure, so installation is comfy for customers)
local function GetBoundary(content)
    local fname = "polaroid_".. LocalPlayer():SteamID64() .."_".. math.floor(SysTime()) ..".jpg"

    local boundary = "fboundary".. math.random(1, 100)
    local header_bound = "Content-Disposition: form-data; name=\"file\"; filename=\"".. fname .."\"\r\nContent-Type: application/octet-stream\r\n"

    content =  "--".. boundary .."\r\n".. header_bound .."\r\n".. content .."\r\n--".. boundary .."--\r\n"
    return boundary, content
end
]]--

local random, gsub, format = math.random, string.gsub, string.format
local x = {x = true}
local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"

local function string_random()
    return gsub(template, "[xy]", function(c)
        local v = x[c] and random(0, 0xf) or random(8, 0xb)
        return format("%x", v)
    end)
end

local function GetBoundary(content) -- method for https://github.com/pomf/pomf based hostings
    local fname = "polaroid_".. LocalPlayer():SteamID64() .."_".. math.floor(SysTime()) ..".jpg"

    local boundary = "----WebKitFormBoundary".. string_random()
    local header_bound = "Content-Disposition: form-data; name=\"files[]\"; filename=\"".. fname .."\"\r\nContent-Type: image/jpeg\r\n"

    content =  "--".. boundary .."\r\n".. header_bound .."\r\n".. content .."\r\n--".. boundary .."--"
    return boundary, content
end

function SWEP:UploadPhoto(screenshoot)
    local boundary, content = GetBoundary(screenshoot)

    HTTP({
        url = POLAROID_CONFIG.Host,
        method = "post",
        type = "multipart/form-data; boundary=".. boundary,
        body = content,
        success = function(code, response, headers)
            timer.Simple(2, function()
                if IsValid(self) then
                    self.IsBusy = false
                end
            end)

            -- local url = string.match(response, "([^/]+)$-.png") -- method for https://x0.at/ & https://imgur.com/
            local resp, id = util.JSONToTable(response)
            if resp and resp.files and resp.files[1] then
                id = resp.files[1].url:match("([^/]+)$-.jpg")
            end

            if id then
                net.Start("incredible-gmod.ru/polaroid")
                    net.WriteBool(true)
                    net.WriteString(id)
                net.SendToServer()
            else
                chat.AddText(unpack(chat_message))
                print("Message for server owner: Something went wrong when uploading photo to ".. POLAROID_CONFIG.Host ..".")
                print(response)
                print(code)
                PrintTable(headers)
                print(boundary)
                print(content)
            end
        end,
        failed = function(err)
            print("Message for server owner: Something went wrong when uploading photo to ".. POLAROID_CONFIG.Host ..".\nError: ".. err)
            print(boundary)
            print(content)
        end
    })
end

--file.CreateDir("polaroid/last_photo")

function SWEP:DoScreenshoot()
    if self.DeveloperMode then
        timer.Simple(2, function()
            if IsValid(self) then
                self.IsBusy = false
            end
        end)

        LocalPlayer():ScreenFade(SCREENFADE.IN, nil, 0.25, 0.15)

        net.Start("incredible-gmod.ru/polaroid")
            net.WriteBool(true)
            net.WriteString("")
        net.SendToServer()

        return
    end

    self.DrawInnerShadow = true

    timer.Simple(0, function() -- w8 1 frame for hl2 chatbox hide
        hook.Add("PostRender", self, function()
            local screenshoot = render.Capture({
                format = "jpeg",
                quality = math.Clamp(POLAROID_CONFIG.PhotoQuality, 0, 100),
                x = 0,
                y = 0,
                w = ScrW(),
                h = ScrH()
            })

            hook.Remove("PostRender", self)
            self.DrawInnerShadow = nil

            if POLAROID_CONFIG.EnableEditor then
                local files = file.Find("polaroid/last_photo/*", "DATA")
                for i, fname in ipairs(files) do
                    file.Delete("polaroid/last_photo_".. fname)
                end

                local path = "polaroid/last_photo_".. os.time() ..".jpg" -- _G.Material returns cached IMaterial, so i need to make unique file name :(

                file.Write(path, screenshoot)
                local photo_editor = vgui.Create("incredible-gmod.ru/polaroid/editor")
                photo_editor.swep = self
                photo_editor.WorkSpace.Image.Material = Material("data/".. path)
            else
                self:UploadPhoto(screenshoot)
            end

            LocalPlayer():ScreenFade(SCREENFADE.IN, nil, 0.25, 0.15)
        end)
    end)
end

local overlay = {
    mat = Material("polaroid/overlay.png"),
    vignette = Material("polaroid/vignette.png"),
    inner_shadow = Material("polaroid/inner_shadow.png"),
    col = Color(0, 0, 15, 125),
    txtcol = Color(0, 0, 15, 200),
    vignette_col = Color(0, 0, 15),
    redcol = Color(225, 0, 15, 225),
}

surface.CreateFont("polaroid", {
    font = "Roboto",
    size = 28 * ScrH()/1080
})

SWEP.DOF = 0

function SWEP:GetDOF()
    return self.DOF
end

function SWEP:SetDOF(n)
    self.DOF = n
end

local dof = GetConVar("pp_dof")
local dof_spacing = GetConVar("pp_dof_spacing")
local dof_initlength = GetConVar("pp_dof_initlength")

local function DrawDOF(force)
    if force < 1 or system.HasFocus() == false then return false end

    local val = 5000 - force*975
    dof_spacing:SetInt(val)
    dof_initlength:SetInt(val)

    return true
end

hook.Add("HUDPaint", "incredible-gmod.ru/polaroid", function()
    hook.Remove("HUDPaint", "incredible-gmod.ru/polaroid")

    if IsValid(_PolaroidOverlayPanel) then _PolaroidOverlayPanel:Remove() end
    _PolaroidOverlayPanel = vgui.Create("EditablePanel")
    _PolaroidOverlayPanel:SetSize(ScrW(), ScrH())
    _PolaroidOverlayPanel.Paint = function(me, SW, SH)
        local LocalPlayer = LocalPlayer()
        if GetViewEntity() ~= LocalPlayer then return end

        local swep = LocalPlayer:GetActiveWeapon()
        if IsValid(swep) == false or swep.IsPolaroidCamera == nil then timer.Simple(0, function() dof:SetBool(false) end) return end

        local bool = DrawDOF(swep:GetDOF())
        timer.Simple(0, function() dof:SetBool(bool) end) -- HACK

        surface.SetDrawColor(overlay.vignette_col)
        surface.SetMaterial(overlay.vignette)
        surface.DrawTexturedRect(0, 0, SW, SH)

        if swep.DrawInnerShadow then
            surface.SetDrawColor(overlay.vignette_col)
            surface.SetMaterial(overlay.inner_shadow)
            surface.DrawTexturedRect(0, 0, SW, SH + 4)
            return
        end

        if LocalPlayer:KeyDown(IN_WALK) and LocalPlayer:KeyDown(IN_ATTACK2) then return end

        surface.SetDrawColor(overlay.col)
        surface.SetMaterial(overlay.mat)
        surface.DrawTexturedRect(0, 0, SW, SH)

        local WScale = SW / 1920
        local HScale = SH / 1080

        local _, txth = draw.SimpleText(OverlayText.Zoom .. math.Round( (90 - swep:GetZoom()) / 20 ), "polaroid", WScale * 110, HScale * 990, overlay.txtcol, nil, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(OverlayText.Dof .. math.Round(swep:GetDOF()), "polaroid", WScale * 110, HScale * 990 - txth, overlay.txtcol, nil, TEXT_ALIGN_BOTTOM)

        if not swep.IsUnlimited then
            local col = overlay.txtcol
            if swep:Clip1() < 1 and (input.IsMouseDown(MOUSE_LEFT) or math.sin(CurTime()) < 0.25) then
                col = overlay.redcol
            end
            draw.SimpleText(OverlayText.Frames .. swep:Clip1(), "polaroid", SW - WScale * 110, HScale * 990, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
        end
    end
end)