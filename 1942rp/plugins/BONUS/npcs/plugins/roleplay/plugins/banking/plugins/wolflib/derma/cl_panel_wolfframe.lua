local PANEL = {}

function PANEL:Init()
	self.white = false

	self.btnClose:Hide()
  self.close = self:Add("DButton") --Changing default appearance of close button
  self.close:SetSize(50,25)
  self.close:SetText("x")
  self.close:SetColor(color_white)
	function self.close.PerformLayout(this,w, h)
		this:SetPos(self:GetWide()-w)
	end
  function self.close:Paint(w,h)
		if self:IsHovered() then
			draw.RoundedBoxEx(4, 0, 0, w, h, Color(235,85,85), false, true)
		else
			draw.RoundedBoxEx(4, 0, 0, w, h, Color(225,75,75), false, true)
		end
  end
	function self.close.DoClick()
		self:Close()
	end

	self.lblTitle:Hide()
	self.title = self:Add("DLabel")
	self.title:SetFont("WB_Small") --Setting title font to WB_Small
	self.title:SetColor(color_white)
	function self.title.PerformLayout(this,w,h)
		this:SetText(self.lblTitle:GetText())
		this:SizeToContents()
		this:SetPos(0,25/2-h/2)
		this:CenterHorizontal()
	end

	--Top Control button placeholder
	self.tconscr = self:Add("DScrollPanel")
	self.tconscr:SetTall(25)
	self.tcon = self.tconscr:Add("DIconLayout")
	function self.tcon:Paint(w,h)
		draw.RoundedBox(0, 0, 0, w, h, Color(255,0,0,100))
	end
	function self.tcon.Think(this)
		local accw = 0
		for k,v in pairs(this:GetChildren()) do
			accw = accw + v:GetWide()
		end

		self.tconscr:SetWide(accw)
		this:SetWide(accw)
	end

	--Little opening animation
	self:SetAlpha(0)

	timer.Simple(0.05, function()
		if not self or not IsValid(self) then return end
		local x,y = self:GetPos()
		self:SetPos(x+50,y+50)
		self:MoveTo(x, y, 0.3, 0, -1)
		self:AlphaTo(255, 0.3, 0.15)
	end)
end

function PANEL:Close()
	self:AlphaTo(0,0.15,0,function()
		if ( self:GetDeleteOnClose() ) then
			self:Remove()
		end

		self:OnClose()
	end)
end

function PANEL:AddTopControl(txt)
	local b = self.tcon:Add("DButton")
	b:SetText(txt)
	b:SetSize(60,25)
	b.rounded = {4,true,false,false,false}
	function b:Paint(w,h)
		draw.RoundedBoxEx(self.rounded[1], 0, 0, w, h, self.color, unpack(self.rounded, 2))
	end

	return b
end

function PANEL:SetWhite(white)
	self.white = white

	if white then
		self.title:SetColor(color_black)
	else
		self.title:SetColor(color_white)
	end
end

function PANEL:GetWorkPanel()
	local wp = self:Add("DPanel")
	wp:SetSize(self:GetWide(), self:GetTall()-self.close:GetTall())
	wp:SetPos(0,self.close:GetTall())
	wp.noPaint = false
	function wp.Paint(this,w,h)
		if not this.noPaint then
			if self.white then
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(240, 240, 240), false, false, true, true)
			else
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(53,53,53,200), false, false, true, true)
			end
		end
	end
	return wp
end

function PANEL:OnKeyCodePressed(key)
	if key == KEY_F1 then
		self:Remove()
	end
end

function PANEL:Paint(w,h)
	nut.util.drawBlur(self,4)

	if self.white then
		draw.RoundedBox(4, 0, 0, w, h, Color(200,200,200,200))
	else
		draw.RoundedBox(4, 0, 0, w, h, Color(50,50,50,230))
	end
end

vgui.Register("WolfFrame", PANEL, "DFrame")
