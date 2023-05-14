local pageMat = Material("docs/page.jpg")

local PANEL = {}

function PANEL:Init()
	self:InitSelf()
	self:InitChildren()
end

function PANEL:InitSelf()
	self:SetTitle("")
	self:SetSize(ScrW() * 0.375, ScrH() * 0.92)
	self:Center()
	self:SetDraggable(false)
	self:MakePopup()
end

function PANEL:InitChildren()
	self.title = vgui.Create("DLabel", self)
	self.title:Dock(TOP)
	self.title:DockMargin(20, 0, 20, 0)
	self.title:SetFont("nut.docs.title")
	self.title:SetColor(Color(0, 0, 0, 255))
	
	self.contents = vgui.Create("DLabel", self)
	self.contents:Dock(FILL)
	self.contents:DockMargin(20, 20, 20, 0)
	self.contents:SetFont("nut.docs.contents")
	self.contents:SetColor(Color(0, 0, 0, 255))
	self.contents:SetAutoStretchVertical(true)
	self.contents:SetWrap(true)
	self.contents:SizeToContents()
end

function PANEL:SetHeader(text)
	self.title:SetText(text)
end

function PANEL:SetContents(text)
	self.contents:SetText(text)
	self.contents:SizeToContents()
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(255, 255, 255, 255) 
	surface.SetMaterial(pageMat)
	surface.DrawTexturedRect(0, 0, w, h)
end

vgui.Register("nut.docs.read", PANEL, "DFrame")

local PANEL = {}

function PANEL:Init()
	self:SetFont("nut.docs.contents")
	self:SetTextColor(Color(0, 0, 0, 255))
	self:SetPlaceholderColor(Color(255, 255, 255, 255))
end

function PANEL:Paint(w, h)
	self:DrawTextEntryText(self:GetTextColor(), Color(0, 0, 255), self:GetCursorColor())
end

vgui.Register("nut.docs.input", PANEL, "DTextEntry")

local PANEL = {}

function PANEL:Init()
	self:InitSelf()
	self:InitChildren()
end

function PANEL:InitSelf()
	self:SetTitle("")
	self:SetSize(ScrW() * 0.375, ScrH() * 0.92)
	self:Center()
	self:SetDraggable(false)
	self:MakePopup()
end

function PANEL:InitChildren()
	self.title = vgui.Create("nut.docs.input", self)
	self.title:Dock(TOP)
	self.title:DockMargin(20, 0, 20, 0)
	self.title:SetFont("nut.docs.title")
	self.title:SetValue("Title...")
	self.title:SetPlaceholderText("Enter title...")

	local width, height = self:GetSize()

	self.contents = vgui.Create("nut.docs.input", self)
	self.contents:Dock(TOP)
	self.contents:DockMargin(20, 20, 20, 0)
	self.contents:SetSize(width, height * 0.89)
	self.contents:SetMultiline(true)
	self.contents:SetValue("Contents...")
	self.contents:SetPlaceholderText("Enter contents...")
end

function PANEL:GetHeader()
	return self.title:GetValue()
end

function PANEL:GetContents()
	return self.contents:GetValue()
end

function PANEL:SetItem(item)
	self.item = nut.item.instances[item.id]

	self.title:SetValue(self.item:getData("nut.docs.title", self:GetHeader()))
	self.contents:SetValue(self.item:getData("nut.docs.contents", self:GetContents()))
end

function PANEL:OnClose()
	if self.item then
		netstream.Start("nut.docs.edit", self.item, self.title:GetValue(), self.contents:GetValue())
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(255, 255, 255, 255) 
	surface.SetMaterial(pageMat)
	surface.DrawTexturedRect(0, 0, w, h)
end

vgui.Register("nut.docs.edit", PANEL, "DFrame")

local PANEL = {}

function PANEL:Init()
	self:InitSelf()
	self:InitChildren()
end

function PANEL:InitSelf()
	self:SetTitle("")
	self:SetSize(ScrW() * 0.375, ScrH() * 0.4)
	self:Center()
	self:SetDraggable(false)
	self:MakePopup()
end

function PANEL:InitChildren()
	self.scrollable = vgui.Create("DScrollPanel", self)
	self.scrollable:Dock(FILL)

	self.messages = {}
end

function PANEL:SetMessages(messages)
	for _, message in pairs(messages) do
		local button = self.scrollable:Add("DButton")
		button:Dock(TOP)
		button:SetText(string.format("%s - %s", message.title, os.date("%H:%M:%S", message.time)))
		button:SetTextColor(Color(255, 255, 255))

		button.DoClick = function(arguments)
			local messagePanel = vgui.Create("nut.docs.read")
			messagePanel:SetHeader(message.title)
			messagePanel:SetContents(message.contents)
		end
	end
end

vgui.Register("nut.docs.list", PANEL, "DFrame")