local PLUGIN = PLUGIN

local function openCarVendor(vendor, data)
    if PLUGIN.VendorFrame then return end
    PLUGIN.VendorFrame = true
    local blur = vgui.Create("DPanel")
    blur:SetSize(ScrW(), ScrH())
    blur:Center()

    function blur:Paint(w, h)
        nut.util.drawBlur(self, 6)
        draw.RoundedBox(4, 0, 0, w, h, Color(50, 50, 50, 120))
    end

    blur:SetAlpha(0)

    QuickBackground(1, function()
        blur:AlphaTo(255, 0.5, 0)
        local frame = blur:Add("WolfFrame")
        frame:SetSize(ScrW() * 0.60, ScrH() * 0.50)
        frame:MakePopup()
        frame:Center()
        frame:SetTitle("Car Dealer")
        local wp = frame:GetWorkPanel()

        function frame:OnRemove()
            RemoveBackground(1)

            blur:AlphaTo(0, 0.5, 0, function()
                blur:Remove()
            end)

            PLUGIN.VendorFrame = nil

            if self.admin then
                self.admin:Remove()
            end
        end

        --Admin Section
        if LocalPlayer():IsAdmin() then
            --Notify only if the vendor is not setup
            if not category or table.Count(category) <= 0 then
                nut.util.notify("Press F3 to access admin section")
            end

            function frame:OnKeyCodePressed(key)
                if key == KEY_F3 then
                    self:OpenAdmin()
                end
            end

            function frame:OpenAdmin()
                self.admin = PLUGIN:OpenAdminMenu(vendor, data, false, true, true)
            end
        end

        --Getting vehicles to show
        category = data.category

        if not category or table.Count(category) <= 0 then
            local err = wp:Add("DLabel")
            err:SetText("There's no vehicle category assigned to this vendor, please see admin.")
            err:SetFont("WB_Large")
            err:SetColor(Color(225, 75, 75))
            err:SizeToContents()
            err:Center()

            return
        end

        --[[
        --Building the list of vehicles to show
        local vts = {}
        local vlist = list.Get("simfphys_vehicles")
        for k,v in pairs(category) do
            local allowed = true
            local rest = PLUGIN.categoryRestrictions[v]
            if rest then --Check if there are any restrictions for that category
                allowed = PLUGIN:CanShowCars(v, rest)
            end
    
            local carlist = PLUGIN.carList[v]
            for c,price in pairs(carlist) do
                if vlist[c] then
                    local tbl = vlist[c]
                    tbl.price = price
                    tbl.allowed = allowed
                    tbl.rest = rest
                    vts[c] = tbl
                end
            end
        end

        --Drawing the list
        local curCar = table.GetKeys(vts)[1]
        local cscroll = wp:Add("WScrollList")
        cscroll:SetSize(wp:GetWide()/2, wp:GetTall()*0.70)
        clist = cscroll:GetList()
        clist:AddTitleBar("Vehicles")

        for k,v in pairs(vts) do
            local c = clist:Add("WButton")
            c:SetSize(cscroll:GetWide(),30)
            c:SetText(v.Name)
            if not v.allowed and v.rest and v.rest.group then
                local g = v.rest.group
                if type(g) == "table" then g = table.concat(g, ", ") end
                
                c:SetText(v.Name .. " (" .. string.upper(g) .. " Only)")
                c:SetIcon("icon16/lock.png")
            end
            c:SetFont("WB_Small")
            c:SetColor(color_white)
            c:SetDisabled(not v.allowed)
            function c:DoClick()
                curCar = k
                frame:Update()
            end
            function c:Think()
                if self:GetDisabled() then
                    self.color = Color(25,25,25)
                    self:SetTextColor(Color(100,100,100))
                    return
                end

                if curCar == k then
                    if self.accentColor ~= BC_NEUTRAL then
                        self:SetAccentColor(BC_NEUTRAL)
                    end
                else
                    if self.accentColor ~= Color(45,45,45) then
                        self:SetAccentColor(Color(45,45,45))
                    end
                end
            end
        end
        ]]
        --
        local cscroll = wp:Add("WScrollList")
        cscroll:SetSize(wp:GetWide() / 2, wp:GetTall() * 1)
        clist = cscroll:GetList()
        -- Rewritten xx damian
        local first = true
        local curCar = {}
        local vlist = list.Get("simfphys_vehicles")

        for _, v in ipairs(category) do
            clist:AddTitleBar(v .. " Vehicles")
            -- Check if the user has access to this category.
            local access = true
            local restrictions = PLUGIN.categoryRestrictions[v]

            if restrictions then
                access = PLUGIN:CanShowCars(v, restrictions)
            end

            local carlist = PLUGIN.carList[v]

            for class, price in pairs(carlist) do
                local veh = vlist[class]
                if not veh then continue end -- This vehicle is gone?

                if first then
                    curCar = {
                        price = price,
                        cat = v,
                        allowed = access,
                        class = class
                    }

                    first = false
                end

                local c = clist:Add("WButton")
                c:SetSize(cscroll:GetWide(), 30)
                c:SetText(veh.Name)

                if not access then
                    c:SetIcon("icon16/lock.png")
                end

                c:SetFont("WB_Small")
                c:SetColor(color_white)

                --c:SetDisabled(not v.allowed)
                function c:DoClick()
                    curCar = {
                        price = price,
                        cat = v,
                        allowed = access,
                        class = class
                    }

                    frame:Update()
                end

                function c:Think()
                    if curCar.class == class then
                        if self.accentColor ~= BC_NEUTRAL then
                            self:SetAccentColor(BC_NEUTRAL)
                        end
                    elseif not access then
                        self.color = Color(25, 25, 25)
                        self:SetTextColor(Color(100, 100, 100))
                    else
                        if self.accentColor ~= Color(45, 45, 45) then
                            self:SetAccentColor(Color(45, 45, 45))
                        end
                    end
                end
            end
        end

        --[[
        --Color swatcher
        local swScroll = wp:Add("WScrollList")
        swScroll:SetSize(wp:GetWide() / 2, wp:GetTall() * 0.30)
        swScroll:SetPos(0, wp:GetTall() - swScroll:GetTall())
        local swList = swScroll:GetList()

        local colors = {Color(160, 160, 160), Color(58, 58, 58), color_white, Color(25, 25, 25), Color(44, 62, 80), Color(0, 0, 110), Color(234, 70, 70), Color(230, 126, 34),}

        --Gray,
        --Not quite black
        --Just black
        -- (damian) Midnight blue
        --Blue
        --Red
        -- (damian) Carrot orange
        for _, col in pairs(colors) do
            local cp = swList:Add("DButton")
            cp:SetText("")
            cp:SetSize(swScroll:GetWide() / 4 - 2, swScroll:GetTall() / 2 - 2)

            function cp:Paint(w, h)
                draw.RoundedBox(4, 2, 2, w - 4, h - 4, col)
            end

            function cp:DoClick()
                wp.mdl:SetColor(col)
            end
        end]]
        --The price of the car
        local price = wp:Add("DLabel")
        price:SetText("")
        price:SetFont("WB_Large")
        price:SetColor(color_white)
        price:SetSize(wp:GetWide() / 2, 50)
        price:SetPos(cscroll:GetWide(), 0)

        function price:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(45, 45, 45))
        end

        function price:PerformLayout()
            price:SetContentAlignment(5)
        end

        --Vehicle Model
        wp.mdl = wp:Add("DModelPanel")
        wp.mdl:SetSize(wp:GetWide() / 2, wp:GetTall() - price:GetTall() - 50)
        wp.mdl:SetPos(wp:GetWide() - wp.mdl:GetWide(), 0)
        wp.mdl:SetFOV(75)
        wp.mdl:SetCamPos(Vector(-200, 0, 80))
        --Buy
        local buy = wp:Add("WButton")
        buy:SetSize(wp:GetWide() / 2, wp:GetTall() - wp.mdl:GetTall() - price:GetTall())
        buy:SetPos(wp:GetWide() / 2, wp:GetTall() - buy:GetTall())
        buy:SetText("Purchase")
        buy:SetFont("WB_Large")
        buy:SetColor(color_white)
        buy:SetAccentColor(Color(45, 45, 45))

        function buy:DoClick()
            local veh = vlist[curCar.class]
            if not veh then return end -- WTF?? but sure.
            print("OHOHOOHOHOHOHOHO")

            if not LocalPlayer():getChar():hasMoney(curCar.price) then
                nut.util.notify("You do not have enough money!", NOT_ERROR)

                return
            end

            --Confirmation
            Choice_Request("Are you sure you want to buy " .. veh.Name .. " for " .. nut.currency.get(curCar.price) .. " ?", function()
                netstream.Start("PlayerBuyVehicle", curCar.cat, curCar.class, wp.mdl:GetColor())
            end)
        end

        --Update the panels when checking a vehicle
        function frame:Update()
            if not curCar then return end
            local veh = vlist[curCar.class]

            -- WTF?? but sure.
            if not veh then
                wp.mdl:SetModel("models/error.mdl")
                price:SetText("Error")
                buy:SetDisabled(true)
                buy:SetText("Vehicle unknown!")
                buy:SetAccentColor(Color(225, 75, 75))
            end

            wp.mdl:SetModel(veh.Model)
            price:SetText(nut.currency.get(curCar.price))
            --Check if vehicle is already owned
            local ownList = LocalPlayer():GetOwnedVehicles()
            local owned = false

            for class, _ in pairs(ownList) do
                if class == curCar.class then
                    owned = true
                    break
                end
            end

            --Determine if player can buy the vehicle
            if owned then
                buy:SetDisabled(true)
                buy:SetText("You already own this vehicle")
                buy:SetAccentColor(Color(225, 75, 75))
            elseif table.Count(ownList) >= LocalPlayer():GetGarageSpace() then
                buy:SetDisabled(true)
                buy:SetText("No more space in your garage!")
                buy:SetAccentColor(Color(225, 75, 75))
            elseif not LocalPlayer():getChar():hasMoney(curCar.price) then
                buy:SetDisabled(true)
                buy:SetText("Not enough funds!")
                buy:SetAccentColor(Color(225, 75, 75))
            elseif not curCar.allowed then
                buy:SetDisabled(true)
                buy:SetText("You are not allowed to buy this car")
                buy:SetAccentColor(Color(225, 75, 75))
            else
                buy:SetDisabled(false)
                buy:SetText("Purchase")
                buy:SetAccentColor(Color(45, 45, 45))
            end
        end

        frame:Update()
    end)
end

netstream.Hook("CarVendorOpen", openCarVendor)

nut.command.add("garage", {
    syntax = "",
    onRun = function(ply) end
})