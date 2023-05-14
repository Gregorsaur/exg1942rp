-- stolen from betterbanking which stole this from devlogs lol
local PANEL = {}

function PANEL:Init()
	self.avatar = vgui.Create("AvatarImage", self)
	self.avatar:SetPaintedManually(true)
end

function PANEL:PerformLayout()
	self.avatar:SetSize(self:GetWide(), self:GetTall())
end

function PANEL:SetPlayer(ply, size)
	self.avatar:SetPlayer(ply, size)
end
function PANEL:SetSteamID(sid, size)
	self.avatar:SetSteamID(sid, size)
end

function PANEL:Paint(w, h)
	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_ZERO)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(1)

	draw.NoTexture()
	surface.SetDrawColor(color_black)
	YAWS.UI.DrawCircle(w / 2, h / 2, h / 2, math.max(w, h) / 2)

	render.SetStencilFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(1)

	self.avatar:PaintManual()

	render.SetStencilEnable(false)
	render.ClearStencil()
end

vgui.Register("yaws.round_avatar", PANEL)