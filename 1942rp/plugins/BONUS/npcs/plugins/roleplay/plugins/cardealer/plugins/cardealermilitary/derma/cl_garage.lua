local PLUGIN = PLUGIN

local function openGarageMenu(valet, data)
    if IsValid(PLUGIN.GarageFrame) then
        PLUGIN.GarageFrame:Remove()
    end

    local owned = LocalPlayer():GetOwnedVehicles()
    local garageSpace = LocalPlayer():GetGarageSpace()
    local height = 200

    if garageSpace > PLUGIN.defaultGarageSpace then
        height = height * 2
    end

    local frame = vgui.Create("WolfFrame")
    frame:SetSize(3 * 200, height)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("Garage (" .. (table.Count(owned) or "0") .. "/" .. garageSpace .. ")")

    function frame:OnKeyCodePressed(key)
        if key == KEY_F3 then
            PLUGIN:OpenAdminMenu(valet, data, true, true, false)
        end
    end

    PLUGIN.GarageFrame = frame
    local wp = frame:GetWorkPanel()
    local scroll = wp:Add("WScrollList")
    scroll:SetSize(wp:GetWide(), wp:GetTall())
    local cList = scroll:GetList()

    for k, data in pairs(owned) do
        local car = list.Get("simfphys_vehicles")[k]
        if not car then continue end
        -- Find category and check if vehicle still exists.
        local found = false

        for cat, vehicles in pairs(PLUGIN.carList) do
            if not vehicles[k] then continue end
            found = cat
            break
        end

        --if not found then continue end -- This car is not in the table atm so dont show it.
        local gc = cList:Add("DPanel")
        gc:SetSize(scroll:GetWide() / 3, scroll:GetTall() - 2)
        gc.defaultColor = Color(45, 45, 45)
        gc.color = gc.defaultColor

        function gc:Paint(w, h)
            draw.RoundedBox(4, 0, 0, w, h, self.color)
        end

        if garageSpace > PLUGIN.defaultGarageSpace then
            gc:SetTall(scroll:GetTall() / 2 - 2)
        end

        gc.mdl = gc:Add("DModelPanel")
        gc.mdl:SetModel(car.Model)
        gc.mdl:Dock(FILL)
        gc.mdl:SetFOV(75)
        gc.mdl:SetCamPos(Vector(-160, 30, 50))
        gc.mdl:SetLookAng(Angle(5, -5, 0))

        --Sets the model color
        if data.color then
            gc.mdl:SetColor(data.color)
        end

        function gc.mdl:LayoutEntity(ent)
            ent:SetAngles(Angle(0, 45, 0))
        end

        function gc.mdl:Think()
            if not found or (data.destroyed and data.destroyed - os.time() > 0) or data.impounded then
                gc.color = Color(25, 25, 25)
            elseif self:IsHovered() then
                gc.color = Color(55, 55, 55)
            else
                gc.color = gc.defaultColor
            end
        end

        function gc.mdl:DoClick()
            if not found then
                nut.util.notify("This car is currently unsuported, please ask an admin: " .. k, NOT_ERROR)

                return
            elseif data.impounded then
                nut.util.notify("Your car is impounded, visit the goverment impound to get it back.", NOT_ERROR)

                return
            elseif data.destroyed and data.destroyed - os.time() > 0 then
                nut.util.notify("Your car was destroyed but your insurance paid for it, please wait " .. string.NiceTime(data.destroyed - os.time()) .. " before spawning it again", NOT_ERROR)

                return
            end

            self:AlphaTo(0, 0.5, 0)

            scroll:AlphaTo(0, 0.5, 0, function()
                scroll:Remove()

                local function but(vc)
                    local b = wp:Add("WButton")
                    b:SetSize(300, 35)
                    b:CenterHorizontal()
                    b:CenterVertical(vc)
                    b:SetAccentColor(Color(45, 45, 45))
                    b:SetFont("WB_Medium")
                    b:SetTextColor(color_white)

                    return b
                end

                --Creating action buttons
                local spawn = but(0.25)
                spawn:SetText("Spawn Vehicle")

                function spawn:DoClick()
                    self:SetDisabled(true)
                    frame:Close()

                    if not IsValid(valet) then
                        netstream.Start("PlayerSpawnRemoteVehicle", k, data)
                    else
                        netstream.Start("PlayerSpawnVehicle", k, valet, data)
                    end
                end

                local buyInsurance = but(0.5)
                buyInsurance:SetText("Buy Insurance")

                local function updateInsuranceButton()
                    buyInsurance:SetDisabled(false)

                    function buyInsurance:DoClick()
                        local price = PLUGIN:GetInsurancePrice(LocalPlayer())

                        netstream.Hook("ReturnInsurancePrice", function(price)
                            Choice_Request("Are you sure you want to get the insurance for this vehicle? " .. nut.currency.get(price) .. "/24hrs (realtime)", function()
                                netstream.Start("PlayerBuyInsurance", k)
                                --Updating insurance button
                                timer.Simple(0.2, updateInsuranceButton)
                                self:SetDisabled(true)
                            end)
                        end)
                    end

                    --Checking if insurance was already bought
                    for id, data in pairs(LocalPlayer():GetSubscriptions() or {}) do
                        if id:find("carInsurance") and data.class and data.class == k then
                            buyInsurance:SetText("Cancel Insurance")

                            function buyInsurance:DoClick()
                                self:SetDisabled(true)
                                netstream.Start("PlayerCancelInsurance", k)
                                timer.Simple(0.2, updateInsuranceButton)
                            end

                            break
                        end
                    end
                end

                updateInsuranceButton()
                local sell = but(0.75)
                sell:SetText("Sell Vehicle")

                function sell:DoClick()
                    local price = PLUGIN:GetVehiclePrice(k) or 0
                    local frac = PLUGIN.sellFraction
                    price = price * frac --Calculate the fraction of the price upon selling

                    Choice_Request("Are you sure you want to sell this vehicle for " .. nut.currency.get(price) .. " ?", function()
                        netstream.Start("PlayerSellVehicle", k, car.Name)
                        frame:Close()
                    end)
                end
            end)
        end
    end

    local block = wp:Add("DPanel")
    block:Dock(FILL)

    function block:Paint(w, h)
        nut.util.drawBlur(self, 4)
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 80))
    end

    function frame:CheckForVehicle()
        --Check if there's a vehicle already spawned
        local playerVehicle = LocalPlayer():GetNWEntity("spawnedVehicle", nil)

        if playerVehicle and IsValid(playerVehicle) then
            local warn = block:Add("DLabel")
            warn:SetText("You already have a personal vehicle spawned")
            warn:SetFont("WB_Large")
            warn:SizeToContents()
            warn:CenterHorizontal()
            warn:CenterVertical(0.25)
            -- "Hack" the matrix
            local hacked = false

            if not IsValid(valet) then
                valet = LocalPlayer()
                hacked = true
            end

            if playerVehicle:GetPos():Distance(valet:GetPos()) > 600 then
                local locationWarn = block:Add("DLabel")
                locationWarn:SetText("Your vehicle is too far to dismiss it.")
                locationWarn:SetFont("WB_Medium")
                locationWarn:SetColor(Color(225, 75, 75))
                locationWarn:SizeToContents()
                locationWarn:Center()
            else
                local dismiss = block:Add("WButton")
                dismiss:SetText("Dismiss Vehicle")
                dismiss:SetFont("WB_Medium")
                dismiss:SetSize(200, 40)
                dismiss:SetAccentColor(Color(35, 35, 35))
                dismiss:Center()

                function dismiss:DoClick()
                    self:SetText("Loading...")
                    self:SetDisabled(true)
                    netstream.Start("PlayerDismissVehicle", playerVehicle)

                    timer.Simple(0.25, function()
                        frame:CheckForVehicle()
                    end)
                end
            end

            -- Undo "hack"
            if hacked then
                valet = nil
            end
        else
            block:AlphaTo(0, 0.2, 0, function()
                block:Remove()
            end)
        end
    end

    timer.Simple(0.25, function()
        frame:CheckForVehicle()
    end)
end

netstream.Hook("openGarageMenu", openGarageMenu)