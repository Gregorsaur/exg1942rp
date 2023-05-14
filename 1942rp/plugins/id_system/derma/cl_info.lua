local PANEL = {}
local HIGHLIGHT = Color(255, 255, 255, 50)

function PANEL:Init()
    self.ageLabel = self:addLabel("Age")
    self.age = self:addNumberEntry("age")
    self.age:SetTall(48)

    self.age.onTabPressed = function()
        self.dob:RequestFocus()
    end

    self.dobLabel = self:addLabel("Date of Birth")
    self.dob = self:addTextEntry("dob")
    self.dob:SetTall(48)

    self.dob.onTabPressed = function()
        self.pob:RequestFocus()
    end

    self.pobLabel = self:addLabel("Place of Birth")
    self.pob = self:addTextEntry("pob")
    self.pob:SetTall(48)

    self.pob.onTabPressed = function()
        self.height:RequestFocus()
    end

    self.heightLabel = self:addLabel("Height")
    self.height = self:addTextEntry("height")
    self.height:SetTall(48)

    self.height.onTabPressed = function()
        self.hairColor:RequestFocus()
    end

    self.hairLabel = self:addLabel("Hair Color")
    self.hair = self:addTextEntry("hair")
    self.hair:SetTall(48)

    self.hair.onTabPressed = function()
        self.eyeColor:RequestFocus()
    end

    self.eyeLabel = self:addLabel("Eye Color")
    self.eye = self:addTextEntry("eye")
    self.eye:SetTall(48)

    self.eye.onTabPressed = function()
        self.religion:RequestFocus()
    end

    self.religionLabel = self:addLabel("Religion")
    self.religion = self:addTextEntry("religion")
    self.religion:SetTall(48)

    self.religion.onTabPressed = function()
        self.occupation:RequestFocus()
    end

    self.bloodLabel = self:addLabel("Blood Type")
    self.blood = self:addBloodEntry("blood")
    self.blood:SetTall(48)
    self.occupationLabel = self:addLabel("Occupation")
    self.occupation = self:addTextEntry("occupation")
    self.occupation:SetTall(48)

    self.occupation.onTabPressed = function()
        self.age:RequestFocus()
    end
end

function PANEL:addTextEntry(contextName)
    local entry = self:Add("DTextEntry")
    entry:Dock(TOP)
    entry:SetFont("nutCharButtonFont")
    entry.Paint = self.paintTextEntry
    entry:DockMargin(0, 4, 0, 16)

    entry.OnValueChange = function(_, value)
        self:setContext(contextName, string.Trim(value))
    end

    entry.contextName = contextName

    entry.OnKeyCodeTyped = function(name, keyCode)
        if (keyCode == KEY_TAB) then
            entry:onTabPressed()

            return true
        end
    end

    entry:SetUpdateOnType(true)

    return entry
end

function PANEL:addNumberEntry(contextName)
    local entry = self:Add("DNumberWang")
    entry:Dock(TOP)
    entry:SetFont("nutCharButtonFont")
    entry.Paint = self.paintNumberEntry
    entry:DockMargin(0, 4, 0, 16)

    entry.OnValueChange = function(_, value)
        self:setContext(contextName, string.Trim(value))
    end

    entry.contextName = contextName

    entry.OnKeyCodeTyped = function(name, keyCode)
        if (keyCode == KEY_TAB) then
            entry:onTabPressed()

            return true
        end
    end

    entry:SetUpdateOnType(true)

    return entry
end

function PANEL:addBloodEntry(contextName)
    local entry = self:Add("DComboBox")
    entry:Dock(TOP)
    entry:SetFont("nutCharButtonFont")
    entry:DockMargin(0, 4, 0, 16)
    entry.GetValue = function() return entry:GetSelected() end
    entry.Paint = self.paintTextEntry

    for i, v in ipairs({"O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"}) do
        entry:AddChoice(v)
    end

    return entry
end

function PANEL:getPanels()
    return {self.age, self.dob, self.pob, self.height, self.hair, self.eye, self.religion, self.blood, self.occupation}
end

function PANEL:onDisplay()
end

function PANEL:validate()
    -- check if all fields are filled
    for _, entry in pairs(self:getPanels()) do
        --print(entry,entry:GetValue())
        if (entry:IsValid() and entry:GetValue() == "") then return false, "You must fill out all fields." end
    end

    local mydata = {
        ["Age"] = tostring(self.age:GetValue()),
        ["Date of Birth"] = self.dob:GetValue(),
        ["Place of Birth"] = self.pob:GetValue(),
        ["Height"] = self.height:GetValue(),
        ["Hair Color"] = self.hair:GetValue(),
        ["Eye Color"] = self.eye:GetValue(),
        ["Religion"] = self.religion:GetValue(),
        ["Blood Type"] = self.blood:GetValue(),
        ["Occupation"] = self.occupation:GetValue()
    }

    self:setContext("data", {
        ["charCharacteristics"] = mydata
    })

    return true
end

-- self refers to the text entry
function PANEL:paintTextEntry(w, h)
    nut.util.drawBlur(self)
    surface.SetDrawColor(0, 0, 0, 100)
    surface.DrawRect(0, 0, w, h)
    self:DrawTextEntryText(color_white, HIGHLIGHT, HIGHLIGHT)
end

function PANEL:paintNumberEntry(w, h)
    nut.util.drawBlur(self)
    surface.SetDrawColor(0, 0, 0, 100)
    surface.DrawRect(0, 0, w, h)
    self:DrawTextEntryText(color_white, HIGHLIGHT, HIGHLIGHT)
end

vgui.Register("nutCharacterDocuments", PANEL, "nutCharacterCreateStep")