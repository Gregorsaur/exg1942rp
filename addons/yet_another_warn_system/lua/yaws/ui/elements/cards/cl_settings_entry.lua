-- A entry in a settings category.
local PANEL = {}

AccessorFunc(PANEL, "name", "Name", FORCE_STRING)
AccessorFunc(PANEL, "desc", "Desc", FORCE_STRING)
AccessorFunc(PANEL, "type", "Type", FORCE_STRING)

function PANEL:Init()
    self.name = "Unnamed"
    self.desc = "A empty setting."
    self.type = "switch"

    self.element = nil
end 

function PANEL:Paint(w, h)
    local colors = YAWS.UI.ColorScheme()
    -- draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0))

    local _,titleHeight = draw.SimpleText(self.name, "yaws.9", 10, 10, colors["text_header"], 0, 0)
    draw.SimpleText(self.desc, "yaws.6", 10, titleHeight + 7.5, colors["text_main"], 0, 0)
end 

function PANEL:GetReccomendedHeight()
    -- fancy ass function to calculate the minimum height
    -- of the panel including title, desc, and input plus 
    -- padding - just to save me some time lol
    local totalHeight = 0

    surface.SetFont("yaws.9")
    local _,titleHeight = surface.GetTextSize(self.name)
    totalHeight = totalHeight + titleHeight

    surface.SetFont("yaws.6")
    local _,descHeight = surface.GetTextSize(self.desc)
    totalHeight = totalHeight + descHeight

    if(self.type == "color") then 
        totalHeight = totalHeight + 75 -- account for giant ass color box
    end 

    -- some extra padding - 10 on top and bottom
    totalHeight = totalHeight + 20

    return totalHeight
end 

function PANEL:SetValue(val)
    if(self.type == "color") then 
        self.updateColorOnLayout = val
        self.element:SetColor(val)
        return
    end 

    if(self.type == "boolean") then 
        self.element:SetValue(tobool(val))
        return
    end 

    self.element:SetValue(val)
end 
function PANEL:GetValue(val)
    return self.element:GetValue()
end 

function PANEL:UseReccomendedHeight()
    self:SetHeight(self:GetReccomendedHeight())
end  

function PANEL:Construct()
    if(self.type == "boolean") then 
        self.element = vgui.Create("yaws.switch", self)
        self.element:SetColor(YAWS.UI.ColorScheme()['theme'])
        function self:PerformLayout(w, h)
            self.element:Dock(RIGHT)
            self.element:SetWide(math.max(30, w * 0.05))
            self.element:DockMargin(10, (h / 3), 10, (h / 3))
        end 
        self.element.OnToggle = function(val)
            self.OnChange(val)
        end 
        self:InvalidateLayout()

        return 
    end 

    if(self.type == "combo") then 
        self.element = vgui.Create("yaws.combo", self)
        function self:PerformLayout(w, h)
            self.element:Dock(RIGHT)
            self.element:SetWide(math.max(240, w * 0.3))
            self.element:DockMargin(10, (h / 4), 10, (h / 4))
        end 
        self.element.OnSelect = function(s, index, value, data)
            self.OnChange(index, value, data)
        end 
        self:InvalidateLayout()
    end 

    if(self.type == "string") then 
        self.element = vgui.Create("yaws.text_entry", self)
        self.element:SetUpdateOnType(true)
        function self:PerformLayout(w, h)
            self.element:Dock(RIGHT)
            self.element:SetWide(math.max(240, w * 0.3))
            self.element:DockMargin(10, (h / 4), 10, (h / 4))
        end
        -- self.element.OnSelect = function(index, value, data)
        --     self.OnChange(index, value, data)
        -- end 
        self.element.OnValueChange = function(s, val)
            self.OnChange(val)
        end 
        self:InvalidateLayout()
    end 

    if(self.type == "number") then 
        self.element = vgui.Create("yaws.wang", self)
        self.element:SetUpdateOnType(true)
        self.element:SetMin(0)
        self.element:SetMax(65536) -- 16 bits
        function self:PerformLayout(w, h)
            self.element:Dock(RIGHT)
            self.element:SetWide(math.max(240, w * 0.3))
            self.element:DockMargin(10, (h / 4), 10, (h / 4))
        end
        -- self.element.OnSelect = function(index, value, data)
        --     self.OnChange(index, value, data)
        -- end 
        self.element.OnValueChange = function(s, val)
            self.OnChange(val)
        end 
        self:InvalidateLayout()
    end 

    if(self.type == "color") then 
        self.element = vgui.Create("yaws.color", self)
        function self:PerformLayout(w, h)
            self.element:Dock(RIGHT)
            self.element:SetWide(math.max(250, w * 0.3))
            self.element:DockMargin(10, 10, 10, 10)
        end 
        -- self.element:SetPalette(false)
        -- self.element:SetWangs(false)
        -- self.element:SetAlphaBar(false)

        self.element.ValueChanged = function(s) 
            -- I know this returns a table already but it's not in the color
            -- metatable. GetColor() is faster than converting itback into a
            -- color value (afaik).
            -- https://wiki.facepunch.com/gmod/DColorMixer:ValueChanged
            self.OnChange(self.element:GetColor())
        end
    end 
end 

function PANEL:SetOptions(options, icons)
    for k,v in pairs(options) do 
        if(icons) then 
            self.element:AddChoice(v, nil, false, icons[v])
        else 
            self.element:AddChoice(v, nil, false)
        end 
    end
end 

function PANEL:OnChange() end 

vgui.Register("yaws.settings_entry", PANEL, "DPanel")