-- developed for gmod.store
-- from incredible-gmod.ru with love <3

include("shared.lua")

surface.CreateFont("PolaroidCamera.DescriptionLarge", {
	font = "Roboto",
	extended = true,
	size = 24,
	width = 700,
})

local scale = 2

ENT.PictureSize = {
	w = 380 * scale,
	h = 380 * scale,
	size = 0.24 / scale
}
ENT.PictureOffsets = {
	up = 0.5,
	right = -47,
	forward = -68,
	modifyang = function(ang)
		ang:RotateAroundAxis(ang:Right(), 90)
		ang:RotateAroundAxis(ang:Up(), -90)
	end
}

ENT.TextFont = "PolaroidCamera.DescriptionLarge"
ENT.TextPos = {
	x = 5 * scale,
	y = 362 * scale
}
ENT.TextColr = Color(220, 220, 220)

ENT.MaxDist = 1500 ^ 2