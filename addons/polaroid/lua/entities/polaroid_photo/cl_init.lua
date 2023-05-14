-- developed for gmod.store
-- from incredible-gmod.ru with love <3

include("shared.lua")

local ColorAlpha = ColorAlpha

concommand.Add("open_polaroidphoto", function()
	if LocalPlayer():IsSuperAdmin() == false then return end

	local photo = LocalPlayer():GetEyeTrace().Entity
	if not (IsValid(photo) and (photo.IsPolaroidPhoto or photo.IsPolaroidPhotoFrame)) then return end

	gui.OpenURL(photo:GetURL())
end)

net.Receive("incredible-gmod.ru/polaroid/entity", function()
	local ent = net.ReadEntity()

	local menu = vgui.Create("incredible-gmod.ru/polaroid/menu")
	menu:Center()
	menu:MakePopup()
	menu:SetMode(ent, ent.IsPolaroidPhotoFrame and (ent:GetImgID() ~= "" and 1 or 4) or 3)
end)


surface.CreateFont("PolaroidCamera.Description", {
	font = "Roboto",
	extended = true,
	size = 56,
	width = 600,
})

ENT.ShadowAlpha = 1
ENT.NextVisTrace = 0
ENT._IsVisible = true

function ENT:DrawImage(dist, pos, ang, webMat)
	local alpha = render.GetLightColor(pos):Length()

	self.ShadowAlpha = 1 - math.min(alpha*8, 1)

	cam.Start3D2D(pos + ang:Up()*self.PictureOffsets.up + ang:Right()*self.PictureOffsets.right + ang:Forward()*self.PictureOffsets.forward, ang, self.PictureSize.size)
		local w, h = self.PictureSize.w * 16/9, self.PictureSize.h

		local alpha =  dist/self.MaxDist * 255
		alpha = (255 - alpha) * 5
		surface.SetDrawColor(255, 255, 255, alpha)
		surface.SetMaterial(webMat)
		surface.DrawTexturedRect(0, 0, w, h)

		draw.SimpleText(self:GetDesc(), self.TextFont, self.TextPos.x, self.TextPos.y, ColorAlpha(self.TextColr, alpha))

		surface.SetDrawColor(25, 25, 25, self.ShadowAlpha * 255)
		surface.DrawRect(0, 0, w, h)
	cam.End3D2D()
end

file.CreateDir("polaroid")

local WebMaterialCache = {}

local Material = Material
local function WebMaterial(path)
	return Material("data/".. path, "smooth")
end

local empty_mat = Material("debug/debugvertexcolor")

function ENT:DownloadMaterial()
	local img_id = self:GetImgID()
	if img_id == "" then return empty_mat end

	if WebMaterialCache[img_id] then return WebMaterialCache[img_id] end

	local path = "polaroid/".. img_id ..".png"

	if file.Exists(path, "DATA") then
		WebMaterialCache[img_id] = WebMaterial(path)
		return WebMaterialCache[img_id]
	end

	WebMaterialCache[img_id] = empty_mat

	http.Fetch(self:GetURL(), function(body)
		if not body or body == "" or body:find("<!DOCTYPE HTML>", 1, true) then return end

		file.Write(path, body)
		WebMaterialCache[img_id] = WebMaterial(path)
	end)

	return empty_mat
end

function ENT:Draw()
	self:DrawModel()

	if self:GetImgID() == "" then return end

	local pos = self:GetPos()
	local dist = pos:DistToSqr(LocalPlayer():GetPos())
	if dist > self.MaxDist then return end

	local ang = self:GetAngles()
	self.PictureOffsets.modifyang(ang)

	self:DrawImage(dist, pos, ang, self:DownloadMaterial())
end

ENT.PictureSize = {
	w = 400,
	h = 380,
	size = 0.01875
}
ENT.PictureOffsets = {
	up = 0.07,
	right = -4,
	forward = -6.5,
	modifyang = function(ang)
		ang:RotateAroundAxis(ang:Up(), -90)
	end
}

function ENT:ScaleImage(scale)
	self:SetModelScale(scale)

	self.PictureSize_size_orig = self.PictureSize_size_orig or self.PictureSize.size
	self.PictureSize.size = self.PictureSize_size_orig * scale

	self.PictureOffsets_orig = self.PictureOffsets_orig or table.Copy(self.PictureOffsets)
	for k, v in pairs(self.PictureOffsets_orig) do
		if isnumber(v) then
			self.PictureOffsets[k] = v * scale
		end
	end
end

ENT.TextFont = "PolaroidCamera.Description"
ENT.TextColr = Color(50, 50, 50)
ENT.TextPos = {
	x = 0,
	y = 400
}

ENT.MaxDist = 512 ^ 2