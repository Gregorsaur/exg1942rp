local mMaterial = Material
local IsKeyDown = input.IsKeyDown
local KEY_X, KEY_ESCAPE, CENTER = KEY_X, KEY_ESCAPE, TEXT_ALIGN_CENTER
local RoundedBox, RoundedBoxEx = draw.RoundedBox, draw.RoundedBoxEx
local SetDrawColor, DrawRect, SetMaterial, DrawTexturedRect, SimpleText, floor = surface.SetDrawColor, surface.DrawRect, surface.SetMaterial, surface.DrawTexturedRect, draw.SimpleText, math.floor

local MaterialCache = {}

local Material = Material
local function DataMaterial(path)
	return Material("data/".. path, "smooth")
end

file.CreateDir("polaroid/materials")

local function DownloadMaterial(url, cback, cback_err, proxy, alive_time, uid)
	alive_time = alive_time or 86400

	if uid == nil then
		uid = util.CRC(url)  .."_".. url:match("([^/]+)$")
	end
	local path = "polaroid/materials/".. uid

	if MaterialCache[uid] then
		if cback then cback(MaterialCache[uid], path) end
		return uid
	end

	if file.Exists(path, "DATA") and file.Time(path, "DATA") + alive_time > os.time() then
		MaterialCache[uid] = DataMaterial(path)
		if cback then cback(MaterialCache[uid], path) end
		return uid
	end

	if proxy then
		url = "https://proxy.duckduckgo.com/iu/?u=".. url
	end

	http.Fetch(url, function(body)
		if not body or body == "" then return end

		file.Write(path, body)
		MaterialCache[uid] = DataMaterial(path)
		if cback then cback(MaterialCache[uid], path) end
	end, cback_err)

	return uid
end

local Colors = {
	Background = Color(220, 70, 40),
	White = Color(255, 255, 255),
	WhiteBG = Color(250, 220, 195),
	WhiteHover = Color(250, 200, 160),
	Hover = Color(219, 193, 167),
	Dark = Color(51, 51, 51),
	Shadow = Color(5, 5, 15, 125),
	ShadowD = Color(5, 5, 5, 30),
}

local Materials = {
	Close = Material("polaroid/close.png", "smooth mips"),
	Brush = Material("polaroid/brush.png", "smooth mips"),
	Pen = Material("polaroid/pen.png", "smooth mips"),
	Eraser = Material("polaroid/eraser.png", "smooth mips"),
	Text = Material("polaroid/text.png", "smooth mips"),
	Printer = Material("polaroid/printer.png", "smooth mips"),
	Sticker = Material("polaroid/sticker.png", "smooth mips"),
	Knob = Material("polaroid/knob.png", "smooth"),
	Pipette = Material("polaroid/pipette.png", "smooth"),
	Layers = Material("polaroid/layers.png", "smooth mips"),
	Eye = Material("polaroid/eye.png", "smooth"),
	Trashbin = Material("polaroid/trashbin.png", "smooth")
}

surface.CreateFont("incredible-gmod.ru/polaroid/tooltip", {
	font = "Roboto",
	extended = true,
	size = 16,
	weight = 300,
})

surface.CreateFont("incredible-gmod.ru/polaroid/brush_size", {
	font = "Roboto",
	extended = true,
	size = 14,
	weight = 300,
})

local function AddProperty(self, name, construct, ...)
	if construct then
		self["Set".. name] = function(me, ...)
			me[name] = construct(...)
		end
	else
		self["Set".. name] = function(me, val)
			me[name] = val
		end
	end

	self["Get".. name] = function(me)
		return me[name]
	end

	if #{...} > 0 and not self[name] then
		self[name] = construct and construct(...) or ...
	end
end

local function ColorConstruct(r, g, b, a)
	if IsColor(r) then
		return r
	end

	return Color(r, g, b, a)
end

local PaintApp = {}
PaintApp.Base = "DHTML"

function PaintApp:Init()
	self:Dock(FILL)
	self:OpenURL("https://incredible-gmod.ru/gmodstore/polaroid/paint")
end

function PaintApp:SetImage(path_or_url)
	self:Call("window.sketcher.SetImage(".. sql.SQLStr(path_or_url) ..");")
end

function PaintApp:SetMode(mode)
	self:Call("window.sketcher.SetMode(".. sql.SQLStr(mode) ..");")
end

function PaintApp:SetBrushSize(size)
	self:Call("window.sketcher.SetBrushSize(".. size ..");")
end

function PaintApp:SetPenSize(size)
	self:Call("window.sketcher.SetPenSize(".. size ..");")
end

function PaintApp:SetEraserSize(size)
	self:Call("window.sketcher.SetEraserSize(".. size ..");")
end

function PaintApp:SetPaintColor(col)
	col = "rgba(".. col.r ..", ".. col.g ..", ".. col.b ..", ".. (col.a / 255) ..")"
	self:Call("window.sketcher.SetPaintColor(".. sql.SQLStr(col) ..");")
end

function PaintApp:SetSize(w, h)
	self:Call("window.sketcher.SetSize(".. w ..", ".. h ..");")
end

local Tooltip = {}
Tooltip.Base = "EditablePanel"

AddProperty(Tooltip, "TextColor", ColorConstruct, 255, 255, 255)
AddProperty(Tooltip, "BackgrondColor", ColorConstruct, 24, 25, 28)
AddProperty(Tooltip, "DrawBackground", tobool, true)
AddProperty(Tooltip, "Text", tostring, "")
AddProperty(Tooltip, "Font", tostring, "incredible-gmod.ru/polaroid/tooltip")
AddProperty(Tooltip, "Offset", tonumber, 6)
AddProperty(Tooltip, "AnimatonLength", tonumber, 0.3)

function Tooltip:Init()
	self:SetAlpha(0)
	self:SetMouseInputEnabled(false)
	self:MoveToFront()
	self:SetDrawOnTop(true)
end

function Tooltip:Paint(w, h)
	if self:GetDrawBackground() then
		surface.SetDrawColor(self:GetBackgrondColor())
		surface.DrawRect(0, 0, w, h)
	end

	SimpleText(self:GetText(), self:GetFont(), w*0.5, h*0.5, self:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function Tooltip:Think()
	if IsValid(self._parent) == false then
		return self:Remove()
	end

	if self._hover ~= self._parent:IsHovered() then
		self._hover = self._parent:IsHovered()
		self:AlphaTo(self._hover and 255 or 0, self:GetAnimatonLength())
	end

	local x, y = self._parent:LocalToScreen(0, 0)
	x = x + self._parent:GetWide() * 0.5 - self:GetWide() * 0.5
	y = y - self:GetOffset() - self:GetTall()

	self:SetPos(x, y)
end

local SetText = Tooltip.SetText
function Tooltip:SetText(str)
	SetText(self, str)

	surface.SetFont(self:GetFont())
	local w, h = surface.GetTextSize(str)

	self:SetSize(w + 8, h + 6)
end

local Menu = {}
Menu.Base = "EditablePanel"

AddProperty(Menu, "Tool", tostring, "Brush")

function Menu:SetPhoto(path_or_url)
	self.WorkSpace.Image:SetPhoto(path_or_url)
end

local AllowedTools = {
	Brush = true,
	Pen = true,
	Eraser = true
}

local SetTool = Menu.SetTool
function Menu:SetTool(tool)
	SetTool(self, tool)
	self.WorkSpace.PaintApp:SetMode(tool)

	self.DisableCursor = not AllowedTools[tool]

	if IsValid(self.TypeTool) and self:GetTool() ~= "Type" then
		self.TypeTool.input:OnEnter()
		self.TypeTool:Remove()
	end
end

Menu.BrushColor = Colors.White

function Menu:GetBrushColor()
	return self.BrushColor
end

function Menu:SetPaintColor(col)
	if col == self.BrushColor then return end

	self.BrushColor = col
	self.WorkSpace.PaintApp:SetPaintColor(col)

	if IsValid(self.TypeTool) then
		self.TypeTool.input:SetTextColor(col)
	end
end

Menu.BrushSize = 8
Menu.PenSize = 8
Menu.EraserSize = 8

function Menu:GetBrushSize()
	return self.BrushSize
end

function Menu:SetBrushSize(size)
	self.BrushSize = size
	self.WorkSpace.PaintApp:SetBrushSize(size)
end

function Menu:GetPenSize()
	return self.PenSize
end

function Menu:SetPenSize(size)
	self.PenSize = size
	self.WorkSpace.PaintApp:SetPenSize(size)
end

function Menu:GetEraserSize()
	return self.EraserSize
end

function Menu:SetEraserSize(size)
	self.EraserSize = size
	self.WorkSpace.PaintApp:SetEraserSize(size)
end

function Menu:Init()
	self.Layers = {}

	local w = 4 + 28 + 36 + 4
	local h = 4 + 4 + 34 + 4

	local img_w = math.min(1280, ScrW() - w - 32 - 16)
	local img_h = math.min(720, ScrH() - h - 32 - 16)

	w = w + img_w + 32
	h = h + img_h + 32

	self:SetAlpha(0)
	self:AlphaTo(255, 0.2)
	self:SetSize(w, h)
	self:Center()
	self:MakePopup()

	self.Shadow = self:Add("EditablePanel")
	self.Shadow:SetPos(0, 32)
	self.Shadow:SetSize(self:GetWide() - 24, self:GetTall() - 32)
	self.Shadow.Paint = function(me, w, h)
		RoundedBox(9, 0, 0, w, h, Colors.Shadow)
	end

	self.WorkSpace = self:Add("EditablePanel")
	self.WorkSpace:SetPos(12, 16)
	self.WorkSpace:SetSize(self:GetWide() - 24, self:GetTall() - 32)
	self.WorkSpace.Paint = function(me, w, h)
		RoundedBox(9, 0, 0, w, h, Colors.Background)
		RoundedBox(9, 4, 4, w - 8, h - 8, Colors.WhiteBG)
	end

	self.WorkSpace.Tools = self.WorkSpace:Add("EditablePanel")
	self.WorkSpace.Tools:Dock(LEFT)
	self.WorkSpace.Tools:DockMargin(4, 4, 0, 4)
	self.WorkSpace.Tools:SetWide(32)
	self.WorkSpace.Tools.Paint = function(me, w, h)
		SetDrawColor(Colors.Background)
		DrawRect(0, 0, w, h)
	end
	self.WorkSpace.Tools.AddTool = function(me, name, icon, cback)
		local tool = me:Add("EditablePanel")
		tool.icon = icon
		tool.name = name
		tool:Dock(TOP)
		tool:SetTall(28)
		tool:DockMargin(0, 4, 4, 0)
		tool:SetCursor("hand")
		tool.Paint = function(me, w, h)
			local x, y = 0, 0
			if self:GetTool() == me.name then
				x, y = 2, 2
				w, h = w - 4, h - 4
			end

			RoundedBox(4, x, y, w, h, me:IsHovered() and Colors.WhiteHover or Colors.WhiteBG)

			SetDrawColor(self:GetTool() == name and Colors.Background or Colors.Dark)
			SetMaterial(me.icon)
			DrawTexturedRect(x + 2, y + 2, w - 4, h - 4)
		end

		tool.tooltip = vgui.CreateFromTable(Tooltip)
		tool.tooltip._parent = tool
		tool.tooltip:SetText(name)

		tool.OnMouseReleased = function(me, mcode)
			if mcode == MOUSE_LEFT then
				self:SetTool(name)
				if cback then cback(me) end
			end
		end

		return tool
	end

	local function MakeToolPopup(me)
		if IsValid(self.WorkSpace.popup_tool) then self.WorkSpace.popup_tool:Remove() end

		self.WorkSpace.popup_tool = self.WorkSpace:Add("EditablePanel")
		local popup = self.WorkSpace.popup_tool
		popup:SetPos(39, me.y + 6)
		popup.Paint = function(me, w, h)
			RoundedBox(4, 0, 0, w, h, Colors.Background)
			RoundedBox(4, 2, 2, w - 4, h - 4, Colors.WhiteBG)
		end
		popup:SetSize(128, 256)
		popup:SetZPos(850)

		return popup
	end

	local function PaintAppPopup(me)
		local text = me.name .." Size:"

		local popup = MakeToolPopup(me)
		popup:SetTall(46)
		popup.PaintOver = function(me, w, h)
			SimpleText(text, "incredible-gmod.ru/polaroid/brush_size", 8, 6, Colors.Dark)
		end

		local slider = popup:Add("DSlider")
		slider:Dock(TOP)
		slider:DockMargin(8, 24, 8, 0)
		slider.Paint = function(me, w, h)
			SetDrawColor(Colors.Dark)
			DrawRect(0, h * 0.5 - 10, w, 6)
		end
		slider.Knob.Paint = function(me, w, h)
			SetDrawColor(Colors.Background)
			SetMaterial(Materials.Knob)
			DrawTexturedRect(0, 0, w, h)
		end
		slider.Knob:SetSize(10, 10)
		slider:SetCursor("hand")

		local input = popup:Add("incredible-gmod.ru/polaroid/input")
		input:SetSize(42, 16)
		input:SetTextDarkest(50, 255)
		input:SetNumeric(true)
		input.m_bBackground = true
		input.FocusedBackgroundColor = Colors.Background
		input.BackgroundColor = Colors.Background
		input.BottomLineSize = 1

		local fontname = "incredible-gmod.ru/polaroid/brush_size"
		input:SetFont(fontname)
		input.m_FontName = fontname
		input:SetFontInternal(fontname)

		local Paint = input.Paint
		input.Paint = function(me, w, h)
			SetDrawColor(Colors.WhiteBG)
			DrawRect(0, 0, w, h)

			Paint(me, w, h)
		end

		input.y = 4
		input.x = popup:GetWide() - input:GetWide() - 8

		local GetPaintSize = self["Get".. me.name .."Size"]
		local SetPaintSize = self["Set".. me.name .."Size"]

		input:SetText(GetPaintSize(self))
		slider:SetSlideX(GetPaintSize(self) / 256)
		slider.TranslateValues = function(me, x, y)
			local num = 1 + math.floor(255 * x)
			input:SetText(num)
			SetPaintSize(self, num)

			return x, y
		end
	end

	local BrushTool = self.WorkSpace.Tools:AddTool("Brush", Materials.Brush, PaintAppPopup)
	self.WorkSpace.Tools:AddTool("Pen", Materials.Pen, PaintAppPopup)
	self.WorkSpace.Tools:AddTool("Eraser", Materials.Eraser, PaintAppPopup)
	self.WorkSpace.Tools:AddTool("Type", Materials.Text, function(me)
		local popup = MakeToolPopup(me)

		popup:SetTall(86)
		popup.PaintOver = function(me, w, h)
			SimpleText("Font Size:", "incredible-gmod.ru/polaroid/brush_size", 8, 6, Colors.Dark)
			SimpleText("Font Weight:", "incredible-gmod.ru/polaroid/brush_size", 8, 52, Colors.Dark)
		end

		local function AddSlider(addY)
			local slider = popup:Add("DSlider")
			slider:SetSize(popup:GetWide() - 16, 16)
			slider:SetPos(8, 24 + addY)
			slider.Paint = function(me, w, h)
				SetDrawColor(Colors.Dark)
				DrawRect(0, h * 0.5 - 10, w, 6)
			end
			slider.Knob.Paint = function(me, w, h)
				SetDrawColor(Colors.Background)
				SetMaterial(Materials.Knob)
				DrawTexturedRect(0, 0, w, h)
			end
			slider.Knob:SetSize(10, 10)

			local input = popup:Add("incredible-gmod.ru/polaroid/input")
			input:SetSize(42, 16)
			input:SetTextDarkest(50, 255)
			input:SetNumeric(true)
			input.m_bBackground = true
			input.FocusedBackgroundColor = Colors.Background
			input.BackgroundColor = Colors.Background
			input.BottomLineSize = 1

			local fontname = "incredible-gmod.ru/polaroid/brush_size"
			input:SetFont(fontname)
			input.m_FontName = fontname
			input:SetFontInternal(fontname)

			local Paint = input.Paint
			input.Paint = function(me, w, h)
				SetDrawColor(Colors.WhiteBG)
				DrawRect(0, 0, w, h)

				Paint(me, w, h)
			end

			input.y = 4 + addY
			input.x = popup:GetWide() - input:GetWide() - 8

			return input, slider
		end

		local input_size, input_weight

		local font_weights = {
			light = 500,
			normal = 550,
			bold = 600
		}

		local function Update()
			local size, weight = input_size:GetText(), input_weight:GetText()
			local name = "incredible-gmod.ru/polaroid/font_tool/".. size .."/".. weight
			surface.CreateFont(name, {
				font = "Roboto",
				extended = true,
				size = tonumber(size),
				weight = font_weights[weight],
			})

			self.TypeToolFont = name
			if IsValid(self.TypeTool) and IsValid(self.TypeTool.input) then
				self.TypeTool.input:SetFont(name)
				self.TypeTool.input:OnChange()
			end
		end

		local input, slider = AddSlider(0)

		input_size = input
		input:SetText(26)
		slider:SetSlideX(26 / 255)
		slider.TranslateValues = function(me, x, y)
			local num = 4 + math.floor(251 * x)
			input:SetText(num)
			Update()
			return x, y
		end
		slider:SetCursor("hand")

		local input, slider = AddSlider(46)

		input_weight = input
		input:SetNumeric(false)
		input:SetText("normal")
		slider:SetSlideX(0.5)
		slider.TranslateValues = function(me, x, y)
			local txt = (x > 0.75 and "bold") or (x < 0.25 and "light") or "normal"
			input:SetText(txt)
			Update()
			return x, y
		end
	end)

	local function BeautifyScroll(scroll)
		local vbar = scroll:GetVBar()

		vbar:SetWide(8)

		vbar.Paint = function(me, w, h)
			local mar = me.VerticalMargin or 6
			draw.RoundedBox(4, 0, 0, w, h, Colors.Background)
		end
		vbar.btnGrip.Paint = function(me, w, h)
			draw.RoundedBox(4, 0, 3, w, h - 6, Colors.Dark)
		end

		vbar.btnUp:SetAlpha(0)
		vbar.btnDown:SetAlpha(0)
		vbar.btnUp:SetTall(0)
		vbar.btnDown:SetTall(0)

		local PerformLayout = vbar.PerformLayout
		vbar.PerformLayout = function(me, w, h)
			PerformLayout(me, w, h)

			me.btnUp:SetTall(0)
			me.btnDown:SetTall(0)
		end
	end

	self.WorkSpace.Tools:AddTool("Stickers", Materials.Sticker, function(me)
		local popup = MakeToolPopup(me)

		popup:SetWide(60 * 4 + 8 * 3 + 4 + 8)
		local scroll = popup:Add("DScrollPanel")
		BeautifyScroll(scroll)
		scroll:Dock(FILL)
		scroll:DockMargin(2, 2, 2, 2)

		local count = 0
		for name, package in pairs(POLAROID_CONFIG.Stickers) do
			if package.CustomCheck then
				local _, res = pcall(package.CustomCheck, LocalPlayer())
				if res == false then continue end
			end

			local title = scroll:Add("EditablePanel")
			title:Dock(TOP)
			title:SetTall(20)
			title.Paint = function(me, w, h)
				SimpleText(name, "incredible-gmod.ru/polaroid/tooltip", 4, 2, Colors.Background)
			end

			local layout = scroll:Add("DIconLayout")
			layout:Dock(TOP)
			layout:SetTall(56)
			layout:SetSpaceX(8)
			layout:DockMargin(0, 0, 0, 8)

			for i, sticker in ipairs(package.Stickers) do
				DownloadMaterial(sticker.url, function(mat)
					if mat:IsError() then return end

					local col = Color(0, 0, 0)

					local item = layout:Add("EditablePanel")
					item:SetSize(60, 60)
					item:SetCursor("hand")
					item.Paint = function(me, w, h)
						col.a = me:IsHovered() and 75 or 25
						RoundedBox(6, 0, 0, w, h, col)

						SetDrawColor(255, 255, 255)
						SetMaterial(mat)
						DrawTexturedRect(2, 2, w - 4, h - 4)
					end
					item.OnMousePressed = function(me, mcode)
						if mcode ~= MOUSE_LEFT then return end

						popup:Hide()

						local a = 175

						count = count + 1

						local sticker_item = self.WorkSpace:Add("EditablePanel")
						sticker_item:SetZPos(700 + count)
						sticker_item:SetCursor("sizeall")
						sticker_item:SetSize(56, 56)
						sticker_item.Think = function(me)
							me.x, me.y = self.WorkSpace:CursorPos()
							me.x = me.x - 28
							me.y = me.y - 28
						end
						sticker_item.Paint = function(me, w, h)
							SetDrawColor(255, 255, 255, a)
							SetMaterial(mat)
							DrawTexturedRect(0, 0, w, h)

							if me.IsLayerHovered then
								SetDrawColor(Colors.Background)
								DrawRect(0, 0, w, 2)
								DrawRect(0, 0, 2, h)
								DrawRect(0, h - 2, w, 2)
								DrawRect(w - 2, 0, 2, h)
							end
						end
						sticker_item.OnMousePressed = function(me, mcode)
							if mcode ~= MOUSE_LEFT then return end
							me.OnMousePressed = nil
							me:SetMouseInputEnabled(false)

							a = 255
							me.Think = nil
							popup:Show()

							me.LayerName = "Sticker"
							me.LayerIcon = Materials.Sticker
							me.LayerIndex = table.insert(self.Layers, me)
						end
					end

					item.tooltip = vgui.CreateFromTable(Tooltip)
					item.tooltip._parent = item
					item.tooltip:SetText(sticker.name or "???")
				end)
			end
		end
	end)
	self.WorkSpace.Tools:AddTool("Layers", Materials.Layers, function(me)
		local popup = MakeToolPopup(me)

		local scroll = popup:Add("DScrollPanel")
		BeautifyScroll(scroll)
		scroll:Dock(FILL)
		scroll:DockMargin(2, 2, 2, 2)

		for i, layer in ipairs(self.Layers) do
			local item = scroll:Add("EditablePanel")
			item:Dock(TOP)
			item:DockMargin(0, 0, 0, 2)
			item:SetTall(32)
			item.Paint = function(me, w, h)
				SetDrawColor(Colors.Background)
				DrawRect(0, 0, w, h)

				local _, icon_h = SimpleText(layer.LayerName, "incredible-gmod.ru/polaroid/brush_size", 40, h * 0.5, Colors.WhiteBG, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

				SetDrawColor(Colors.WhiteBG)
				SetMaterial(layer.LayerIcon)
				DrawTexturedRect(24, h * 0.5 - icon_h * 0.5, icon_h, icon_h)

				layer.IsLayerHovered = me:IsHovered()
			end

			local check = item:Add("EditablePanel")
			check.bool = layer:IsVisible()
			check:SetSize(item:GetTall() * 0.5, item:GetTall() * 0.5)
			check.x = 4
			check.y = item:GetTall() * 0.5 - check:GetTall() * 0.5
			check:SetCursor("hand")
			check.Paint = function(me, w, h)
				SetDrawColor(Colors.WhiteBG)

				if me.bool then
					SetMaterial(Materials.Eye)
					DrawTexturedRect(0, 0, w, h)
				else
					DrawRect(0, 0, w, 1)
					DrawRect(0, 0, 1, h)
					DrawRect(0, h - 1, w, 1)
					DrawRect(w - 1, 0, 1, h)
				end
			end
			check.OnMouseReleased = function(me, mcode)
				if mcode == MOUSE_LEFT then
					me.bool = not me.bool
					layer:SetVisible(me.bool)
				end
			end

			if not layer.LayerIndex then continue end

			local trashbin = item:Add("EditablePanel")
			trashbin:SetCursor("hand")
			trashbin:SetSize(check:GetSize())
			trashbin.y = check.y
			trashbin.PaintOver = function(me, w)
				me.x = item:GetWide() - w - check.x
				me.PaintOver = nil
			end
			trashbin.Paint = function(me, w, h)
				SetDrawColor(Colors.WhiteBG)
				SetMaterial(Materials.Trashbin)
				DrawTexturedRect(0, 0, w, h)
			end
			trashbin.OnMouseReleased = function(me, mcode)
				if mcode == MOUSE_LEFT then
					table.remove(self.Layers, layer.LayerIndex)
					item:Remove()
					layer:Remove()
				end
			end
		end
	end)

	local colorSelector = self.WorkSpace.Tools:AddTool("Color picker", nil, function(me)
		local popup = MakeToolPopup(me)
		popup:SetSize(168, 144)

		local cube = popup:Add("DColorMixer")
		cube:SetColor(self:GetBrushColor())
		cube:SetPalette(false)
		cube:SetAlphaBar(false)
		cube:SetWangs(false)
		cube:Dock(FILL)
		cube:DockMargin(8, 8, 8, 8)
		cube.ValueChanged = function(me, col)
			self:SetPaintColor(col)
		end
	end)
	colorSelector.Paint = function(me, w, h)
		local x, y = 0, 0
		if self:GetTool() == me.name then
			x, y = 2, 2
			w, h = w - 4, h - 4
		end

		RoundedBox(4, x, y, w, h, self:GetBrushColor())
	end

	self.WorkSpace.Tools:AddTool("Print", Materials.Printer, function(me)
		self.WorkSpace.popup_tool:Hide()
		self.WorkSpace.Cursor:Hide()

		hook.Add("PostRender", "incredible-gmod.ru/polaroid", function()
			hook.Remove("PostRender", "incredible-gmod.ru/polaroid")
			local x, y = self.WorkSpace.Image:LocalToScreen(0, 0)
			local w, h = self.WorkSpace.Image:GetSize()

			local photo = render.Capture({
				format = "jpeg",
				quality = math.Clamp(POLAROID_CONFIG.PhotoQuality, 0, 100),
				x = x,
				y = y,
				w = w,
				h = h
			})

			self.swep:UploadPhoto(photo)

			self:Close(true)
		end)
	end):DockMargin(0, 16, 4, 0)

	self.WorkSpace.Image = self.WorkSpace:Add("EditablePanel")
	self.WorkSpace.Image:SetSize(img_w, img_h)
	self.WorkSpace.Image:SetPos(58, 16)
	self.WorkSpace.Image.Paint = function(me, w, h)
		if me.Material == nil then return end

		SetDrawColor(255, 255, 255)
		SetMaterial(me.Material)
		DrawTexturedRect(0, 0, w, h)
	end

	self.WorkSpace.PaintApp = vgui.CreateFromTable(PaintApp, self.WorkSpace)
	self.WorkSpace.PaintApp:SetZPos(500)
	self.WorkSpace.PaintApp.LayerName = "Paint"
	self.WorkSpace.PaintApp.LayerIcon = Materials.Brush
	table.insert(self.Layers, self.WorkSpace.PaintApp)
	self.WorkSpace.PaintApp:SetPos(16, 16)
	self.WorkSpace.PaintApp:SetWide(img_w + 32)
	self.WorkSpace.PaintApp:SetTall(img_h + 32)
	self.WorkSpace.PaintApp:SetSize(img_w, img_h)
	self.WorkSpace.PaintApp:SetPaintColor(self.BrushColor)
	self.WorkSpace.PaintApp:SetKeyBoardInputEnabled(false)
	self.WorkSpace.PaintApp.PaintOver = function(me, w, h)
		if me.IsLayerHovered then
			local x, y = 22, 16
			w, h = img_w, img_h

			SetDrawColor(Colors.Background)
			DrawRect(x, y, w, 2)
			DrawRect(x, y, 2, h)
			DrawRect(x, y + h - 2, w, 2)
			DrawRect(x + w - 2, y, 2, h)
		end
	end
	hook.Add("VGUIMousePressed", self.WorkSpace.PaintApp, function(me, pnl, mcode)
		if pnl == me then
			if mcode ~= MOUSE_RIGHT and mcode ~= MOUSE_LEFT then return end
			if IsValid(me.popup) then return me.popup:Remove() end
		end
		self:OnPaintAppClick(mcode)
	end)

	BrushTool:OnMouseReleased(MOUSE_LEFT)

	self.WorkSpace.Cursor = self.WorkSpace:Add("EditablePanel")
	self.WorkSpace.Cursor:SetSize(img_w, img_h)
	self.WorkSpace.Cursor:SetPos(58, 16)
	self.WorkSpace.Cursor:SetMouseInputEnabled(false)
	self.WorkSpace.Cursor.PaintOver = function(me, w, h)
		if input.IsKeyDown(KEY_LALT) and input.IsMouseDown(MOUSE_LEFT) then
			render.SetViewPort(0, 0, ScrW(), ScrH())
			cam.Start2D()
				local x, y = input.GetCursorPos()
				render.CapturePixels()
				local r, g, b = render.ReadPixel(x, y)
				self:SetPaintColor(Color(r, g, b))
			cam.End2D()
		end
	end
	self.WorkSpace.Cursor.Paint = function(me, w, h)
		if self.DisableCursor then return end
		if self.WorkSpace.PaintApp:IsMouseInputEnabled() then
			if self.WorkSpace.PaintApp:IsHovered() == false then return end
		end

		local x, y = me:LocalCursorPos()

		if input.IsKeyDown(KEY_LALT) then
			self.WorkSpace.PaintApp:SetMouseInputEnabled(false)

			SetDrawColor(255, 255, 255)
			SetMaterial(Materials.Pipette)
			DrawTexturedRect(x, y - 16, 16, 16)
			return
		end

		self.WorkSpace.PaintApp:SetMouseInputEnabled(true)

		local PaintSize = self["Get".. self:GetTool() .."Size"](self)
		if self:GetTool() == "Pen" then
			local sz = PaintSize
			local sx_2 = sz * 0.5

			SetDrawColor(255, 255, 255)

			DrawRect(x - sx_2, y - sx_2, sz, 1)
			DrawRect(x - sx_2, y - sx_2, 1, sz)

			DrawRect(x - sx_2, y + sx_2 - 1, sz, 1)
			DrawRect(x + sx_2 - 1, y - sx_2, 1, sz)
		else
			surface.DrawCircle(x, y, PaintSize * 0.5, 220, 220, 220)
		end
	end

	self:SetBrushSize(8)
	self:SetTool("Brush")

	self.CloseShadow = self:Add("EditablePanel")
	self.CloseShadow:SetSize(48, 48)
	self.CloseShadow.X = self:GetWide() - self.CloseShadow:GetWide() - 4
	self.CloseShadow.Y = 6
	self.CloseShadow:SetMouseInputEnabled(false)
	self.CloseShadow.Paint = function(me, w, h)
		SetDrawColor(Colors.Shadow)
		SetMaterial(Materials.Close)
		DrawTexturedRect(0, 0, w, h)
	end
	self.CloseShadow:SetZPos(900)

	self.CloseButton = self:Add("EditablePanel")
	self.CloseButton:SetMouseInputEnabled(true)
	self.CloseButton:SetCursor("hand")
	self.CloseButton:SetSize(48, 48)
	self.CloseButton.X = self:GetWide() - self.CloseButton:GetWide()
	self.CloseButton.OnMouseReleased = function(me, mcode)
		if mcode == MOUSE_LEFT then
			self:Close()
		end
	end
	self.CloseButton.Paint = function(me, w, h)
		SetDrawColor(me:IsHovered() and Colors.Hover or Colors.WhiteBG)
		SetMaterial(Materials.Close)
		DrawTexturedRect(0, 0, w, h)
	end
	function self.CloseButton:TestHover(x, y)
		x, y = self:ScreenToLocal(x, y)

		local radius = self:GetWide() * 0.5
		return math.Distance(x, y, radius, radius) < radius
	end
	self.CloseButton:SetZPos(901)
end

function Menu:OnPaintAppClick(mcode)
	if self:GetTool() == "Type" then
		if mcode == MOUSE_LEFT then
			if IsValid(self.TypeTool) then
				self.TypeTool.input:RequestFocus(true)
				return
			end

			self:MakeTypeTool()
		end
	end
end

function Menu:MakeTypeTool()
	local tool = self.WorkSpace:Add("EditablePanel")
	tool:SetZPos(800)
	self.TypeTool = tool

	tool.PaintOver = function(me) -- w8 for docking & actual cursor pos
		local this = me

		me.PaintOver = nil
		local x, y = me:LocalCursorPos()

		local input = me:Add("incredible-gmod.ru/polaroid/input")
		me.input = input
		input:SetPos(x, y)
		input:SetSize(24, 24)
		local SetTextColor = input.SetTextColor
		input.SetTextColor = function(me, col)
			SetTextColor(me, col)
			local col = Color(col.r, col.g, col.b, col.a - 75)
			me:SetCursorColor(col)
		end
		input:SetTextColor(self:GetBrushColor())
		input.m_bBackground = false
		input.m_bAlwaysShowCursor = true
		input:RequestFocus(true)
		input:SetText(" ")
		input.OnChange = function(me)
			local txt = me:GetText()

			surface.SetFont(me:GetFont())
			local w, h = surface.GetTextSize(txt)

			me:SetSize(math.max(w, 24), h)
		end

		if self.TypeToolFont then
			input:SetFont(self.TypeToolFont)
		end

		input.OnEnter = function(me)
			if me:GetText():gsub(" ", "") == "" then return end

			local text = self.WorkSpace:Add("EditablePanel")
			text.txt = me:GetText()
			text.font = me:GetFont()
			text.col = me:GetTextColor()

			local x, y = me:GetPos()
			local w, h = me:GetSize()

			text:SetPos(x + self.WorkSpace.Cursor.x + 2, y + self.WorkSpace.Cursor.y)
			text:SetSize(w, h)

			text.Paint = function(me, w, h)
				if me.IsLayerHovered then
					SetDrawColor(Colors.Background)
					DrawRect(0, 0, w, 2)
					DrawRect(0, 0, 2, h)
					DrawRect(0, h - 2, w, 2)
					DrawRect(w - 2, 0, 2, h)
				end

				SimpleText(me.txt, me.font, 0, 0, me.col)
			end

			text.LayerName = "Text"
			text.LayerIcon = Materials.Text
			text.LayerIndex = table.insert(self.Layers, text)

			this:Remove()
		end
	end
	tool:Dock(FILL)
	tool:DockMargin(21, 16, 21, 30)
	tool:SetCursor("sizeall")

	tool.OnMousePressed = function(me, mcode)
		if mcode ~= MOUSE_LEFT then return end

		local x, y = me:CursorPos()
		me.Dragging = {x = x - me.input.x, y = y - me.input.y}
		me:MouseCapture(true)
	end

	tool.Think = function(me)
		if me.Dragging == nil then return end

		if not input.IsMouseDown(MOUSE_LEFT) then
			me.Dragging = nil
			me:MouseCapture(false)
			return
		end

		local mouseX, mouseY = me:CursorPos()

		me.input.x = math.Clamp(mouseX - me.Dragging.x, 0, me:GetWide() - me.input:GetWide())
		me.input.y = math.Clamp(mouseY - me.Dragging.y, 0, me:GetTall() - me.input:GetTall())
	end
end

function Menu:Close(is_print)
	if self._Closing then return end
	self._Closing = true

	self:AlphaTo(0, 0.2, 0, function()
		if not is_print then
			self.swep.IsBusy = false
			net.Start("incredible-gmod.ru/polaroid")
				net.WriteBool(false)
			net.SendToServer()
		end

		self:Remove()
	end)
end

function Menu:Think()
	if IsKeyDown(KEY_ESCAPE) then
		self:Remove()
	end
end

vgui.Register("incredible-gmod.ru/polaroid/editor", Menu, Menu.Base)