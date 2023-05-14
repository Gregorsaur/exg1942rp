local PLUGIN = PLUGIN

function PLUGIN:OpenAdminMenu(ent, data, showSpawnpoints, showFactionRestrictions, showVehicleCategory)
    local admin = vgui.Create("DFrame")
    admin:SetSize(400, 450)
    admin:MakePopup()

    local function title(t)
        local title = admin:Add("DLabel")
        title:SetText(t)
        title:SetFont("WB_Medium")
        title:Dock(TOP)

        return title
    end

    local function hint(t)
        local hint = admin:Add("DLabel")
        hint:SetText(t)
        hint:SetFont("WB_Small")
        hint:SetColor(color_white)
        hint:SetTall(40)
        hint:SetWrap(true)
        hint:Dock(TOP)
    end

    if showSpawnpoints then
        --Spawnpoints
        admin.nsp = {}
        local spTitle = title("Spawnpoints")
        local spHint = hint("You can add car spawnpoints here, go in the console type 'getpos' while being at the location (and pointing in the right direction). Copy the output in this box.")
        local spTE = admin:Add("DTextEntry")
        spTE:Dock(TOP)
        local spNum = admin:Add("DLabel")
        spNum:SetFont("WB_Medium")
        spNum:SetColor(color_white)
        spNum:Dock(TOP)
        spNum:SetContentAlignment(5)

        function spNum:Think()
            local total = 0
            total = total + table.Count(admin.nsp)
            total = total + (table.Count(data.spawnpoints) or 0)
            self:SetText(total .. " spawnpoint(s)")
        end

        local spAdd = admin:Add("DButton")
        spAdd:SetText("Add Spawnpoint")
        spAdd:Dock(TOP)
        spAdd:DockMargin(0, 5, 0, 0)

        function spAdd:DoClick()
            local val = spTE:GetText()
            if not val or val == "" then return end
            --Checking if the output is right 
            if not val:find("setpos") or not val:find("setang") then return end
            table.insert(admin.nsp, val)
            spTE:SetText("")
            nut.util.notify("Added spawnpoint", NOT_CORRECT)
        end

        local spClear = admin:Add("DButton")
        spClear:SetText("Clear Spawnpoints")
        spClear:Dock(TOP)

        function spClear:DoClick()
            admin.nsp = {}
            data.spawnpoints = {}
            nut.util.notify("Cleared the spawnpoints", NOT_CORRECT)
        end
    end

    --Faction restrictions
    if showFactionRestrictions then
        local facrTitle = title("Faction Restriction")
        facrTitle:DockMargin(0, 5, 0, 0)
        local facrHint = hint("The only faction that can access the ent menu. Select 'disabled' to allow everyone.")
        admin.facrCombo = admin:Add("DComboBox")
        admin.facrCombo:Dock(TOP)

        for k, v in pairs(nut.faction.indices) do
            local choose = false

            if data.faction == v.index then
                choose = true
            end

            admin.facrCombo:AddChoice(v.name, v.index, choose)
        end

        admin.facrCombo:AddChoice("Disabled", 0, false, "icon16/cross.png")
    end

    if showVehicleCategory then
        --Vehicle category
        local cvTitle = title("Vehicle Category")
        cvTitle:DockMargin(0, 5, 0, 0)
        local cvHint = hint("The vehicle category... e.g. Police Cars, Boats, Aircrafts, etc.")
        local categories = {}

        for cat, list in pairs(PLUGIN.carList) do
            table.insert(categories, cat)
        end

        local scroll = admin:Add("DScrollPanel")
        scroll:SetSize(admin:GetWide(), 100)
        scroll:Dock(TOP)

        function scroll:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 80))
        end

        local list = scroll:Add("DIconLayout")
        list:SetSize(scroll:GetSize())
        list:SetPos(0, 0)
        admin.checkboxes = {}

        for _, c in pairs(categories) do
            local cb = list:Add("DCheckBoxLabel")
            cb:SetText(c)
            cb:SetWide(scroll:GetWide())

            if data.category and #data.category > 0 then
                for _, f in pairs(data.category or {}) do
                    if f == c then
                        cb:SetChecked(true)
                    end
                end
            end

            table.insert(admin.checkboxes, cb)
        end
    end

    --Save button
    local save = admin:Add("DButton")
    save:SetTall(30)
    save:SetText("Save Config")
    save:Dock(BOTTOM)

    function save:DoClick()
        local payload = {}

        if showVehicleCategory then
            local cats = {} --Getting categories

            for k, v in pairs(admin.checkboxes) do
                if v:GetChecked() then
                    table.insert(cats, v.Label:GetText())
                end
            end

            payload.category = cats
        end

        if showFactionRestrictions then
            --Faction restriction
            local findex = admin.facrCombo:GetOptionData(admin.facrCombo:GetSelectedID())

            --There is a fac restriction
            if findex ~= 0 then
                payload.faction = findex
            end
        end

        if showSpawnpoints then
            payload.spawnpoints = {}

            for k, v in pairs(admin.nsp) do
                local pos, ang = strPosAngConv(v)

                table.insert(payload.spawnpoints, {
                    pos = pos,
                    ang = ang
                })
            end
        end

        netstream.Start("PlayerUpdateEntityData", ent, payload)
    end

    return admin
end