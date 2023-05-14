local function GetX(panel)
    local x, y = panel:GetPos()

    return x
end

local function GetY(panel)
    local x, y = panel:GetPos()

    return y
end

local function bankingmenu()
    local frame = vgui.Create("DFrame")
    frame:SetSize(800, 250)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("Bank Teller")

    local function wpTitle(wp, title)
        wp.title = wp:Add("DLabel")
        wp.title:SetText(title)
        -- wp.title:SetFont("WB_Small")
        wp.title:SetColor(color_white)
        wp.title:SetSize(wp:GetWide(), 25)
        wp.title:SetContentAlignment(5)

        function wp.title:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 25))
        end
    end

    if LocalPlayer():HasBankAccount() then
        local wnd = frame:Add('DPanel')
        wnd:SetSize(frame:GetWide(), frame:GetTall() - 25)
        wnd:SetPos(0, 25)
        wnd:SetWide(frame:GetWide() / 2 - 4)
        wpTitle(wnd, "Deposits / Withdrawals")
        wnd.bal = wnd:Add("DLabel")
        -- wnd.bal:SetFont("WB_Medium")
        wnd.bal:SetColor(color_white)

        function wnd.bal:PerformLayout()
            self:SizeToContents()
            self:CenterHorizontal()
            self:CenterVertical(0.2)
        end

        function wnd.bal:Update()
            self:SetText("Balance: " .. LocalPlayer():BankBal() .. nut.currency.symbol)
        end

        wnd.bal:Update()

        local function actionButton(h)
            local ab = wnd:Add("DButton")
            ab:SetColor(color_white)
            -- ab:SetFont("WB_Small")
            ab:SetSize(150, 35)
            ab:CenterHorizontal(h)
            ab:CenterVertical()

            return ab
        end

        local function closeActions()
            if wnd.payLoan and IsValid(wnd.payLoan) then
                wnd.payLoan:SetAlpha(0)
            end

            wnd.itemBank:Hide()
            wnd.withdraw:Hide()
            wnd.deposit:Hide()
            --Hiding text
            wnd.bal:SetAlpha(0)

            if wnd.loan and IsValid(wnd.loan) then
                wnd.loan:SetAlpha(0)
            end
        end

        local function showEntryStage(hint, onComplete)
            local es = {}

            function es:Close()
                for k, v in pairs(self) do
                    if isfunction(v) then continue end

                    v:AlphaTo(0, 0.2, 0, function()
                        v:Remove()
                    end)
                end
            end

            es.hintp = wnd:Add("DLabel")
            -- es.hintp:SetFont("WB_Small")
            es.hintp:SetColor(Color(230, 230, 230))
            es.hintp:SetText(hint or "")
            es.hintp:SizeToContents()
            es.hintp:CenterHorizontal()
            es.hintp:CenterVertical(0.25)
            es.te = wnd:Add("DTextEntry")
            es.te:SetSize(150, 30)
            es.te:Center()
            es.te:RequestFocus()
            es.te:SetNumeric(true)

            function es.te:Paint(w, h)
                draw.RoundedBox(4, 0, 0, w, h, Color(230, 230, 230))
                self:DrawTextEntryText(color_black, Color(100, 100, 100), color_black)
            end

            es.done = wnd:Add("DButton")
            es.done:SetSize(150, 35)
            es.done:SetText("Done")
            -- es.done:SetFont("WB_Small")
            es.done:SetColor(color_white)

            function es.done:PerformLayout(w, h)
                self:CenterHorizontal()
                self:CenterVertical(0.75)
            end

            function es.done:Paint(w, h)
                draw.RoundedBox(4, 0, 0, w, h, nut.config.get('color'))
            end

            function es.done:DoClick()
                local amount = tonumber(es.te:GetText())

                if not amount or amount == nil then
                    es.done:SetText("Not a number")

                    return
                end

                if amount <= 0 then
                    es.done:SetText("Amount incorrect")

                    return
                end

                onComplete(es)
            end

            --Fade-in children
            for k, v in pairs(es) do
                if isfunction(v) then continue end
                v:SetAlpha(0)
                v:AlphaTo(255, 0.2, 0)
            end
        end

        --Loan Display
        local actionFadeoutTime = 0.35

        if LocalPlayer():HasLoan() then
            wnd.loan = wnd:Add("DLabel")
            wnd.loan:SetText("Loan: " .. LocalPlayer():LoanAmount() .. nut.currency.symbol)
            -- wnd.loan:SetFont("WB_Medium")
            wnd.loan:SetColor(color_white)

            function wnd.loan:PerformLayout()
                self:SizeToContents()
                self:SetPos(0, GetY(wnd.bal) + wnd.bal:GetTall() + 10)
                self:CenterHorizontal()
            end

            wnd.payLoan = actionButton(0.5)
            wnd.payLoan:SetText("Pay Loan")
            wnd.payLoan:CenterVertical(0.75)

            function wnd.payLoan:DoClick()
                closeActions()

                timer.Simple(actionFadeoutTime, function()
                    showEntryStage("Enter the amount you would like to pay off", function(es)
                        local amount = tonumber(es.te:GetText())
                        local loanAmount = LocalPlayer():LoanAmount()

                        if amount > LocalPlayer():BankBal() then
                            es.done:SetText("Not enough funds!")

                            return
                        end

                        if amount > loanAmount then
                            es.done:SetText("Too high amount!")

                            return
                        end

                        netstream.Start("PlayerRepayLoan", amount)
                        frame:Close()
                    end)
                end)
            end

            function wnd.payLoan:Paint(w, h)
                draw.RoundedBox(4, 0, 0, w, h, nut.config.get('color'))
            end
        end

        -- Item Bank
        -- local itemBank
        if wnd.payLoan and IsValid(wnd.payLoan) then
            wnd.payLoan:CenterHorizontal(0.75)
            wnd.itemBank = actionButton(0.25)
        else
            wnd.itemBank = actionButton(0.5)
        end

        wnd.itemBank:CenterVertical(0.75)
        wnd.itemBank:SetText("Item Bank")

        function wnd.itemBank:DoClick()
            frame:Close()
            netstream.Start("PlayerOpenItemBank")
        end

        function wnd.itemBank:Paint(w, h)
            draw.RoundedBox(4, 0, 0, w, h, nut.config.get('color'))
        end

        -- WITHDRAW
        wnd.withdraw = actionButton(0.25)
        wnd.withdraw:SetText("Withdraw")

        function wnd.withdraw:DoClick()
            closeActions()

            showEntryStage("Enter the amount you would like to withdraw", function(es)
                local amount = tonumber(es.te:GetText())

                if LocalPlayer():BankBal() < amount then
                    es.done:SetText("Not enough money in bank account")

                    return
                end

                netstream.Start("playerBankWithdraw", amount)
                LocalPlayer():EmitSound("artemis/signatureb.wav")
                frame:Close()
            end)
        end

        function wnd.withdraw:Paint(w, h)
            draw.RoundedBox(4, 0, 0, w, h, nut.config.get('color'))
        end

        --DEPOSIT
        wnd.deposit = actionButton(0.75)
        wnd.deposit:SetText("Deposit")

        function wnd.deposit:DoClick()
            closeActions()

            showEntryStage("Enter the amount you would like to deposit", function(es)
                --Check if the player has this amount of money
                local amount = tonumber(es.te:GetText())

                if not LocalPlayer():getChar():hasMoney(amount) then
                    es.done:SetText("Insufficient Funds")

                    return
                end

                netstream.Start("playerBankDeposit", amount)
                LocalPlayer():EmitSound("artemis/signatureb.wav")
                frame:Close()
            end)
        end

        function wnd.deposit:Paint(w, h)
            draw.RoundedBox(4, 0, 0, w, h, nut.config.get('color'))
        end

        --Depositing Checks Part
        local cwp = frame:Add('DPanel')
        cwp:SetPos(frame:GetWide() - wnd:GetWide(), GetY(wnd))
        cwp:SetSize(frame:GetWide() / 2 - 5, frame:GetTall() - 25)
        wpTitle(cwp, "Deposit Checks")
        local tcb = {} --Temporary item ban, if a player has multiple checks they can't deposit the same one multiple times.
        cwp.hint = cwp:Add("DLabel")
        -- cwp.hint:SetFont("WB_Small")
        cwp.hint:SetColor(color_white)
        cwp.hint:SizeToContents()
        cwp.hint:SetText("")

        function cwp:DisplayDepoBtn()
            local inv = LocalPlayer():getChar():getInv()
            local checks = {}

            if inv then
                local items = inv:getItems()

                for k, v in pairs(inv:getItems()) do
                    if v.uniqueID == "check" and v:getData("amount", nil) ~= nil then
                        checks[#checks + 1] = {
                            id = v:getID(),
                            itemData = v
                        }
                    end
                end
            end

            if #checks > 0 then
                cwp.hint:SetText("You have " .. #checks .. " check(s) available to deposit")
                cwp.hint:SizeToContents()
                cwp.hint:SetPos(0, cwp.title:GetTall() + 10)
                cwp.hint:CenterHorizontal()
            else
                cwp.hint:SetText("You do not have any checks to deposit.")
                cwp.hint:SizeToContents()
                cwp.hint:Center()

                return
            end

            cwp.dep = cwp:Add("DButton")
            cwp.dep:SetText("Deposit Check (" .. checks[1].itemData:getData("amount", nil) .. nut.currency.symbol .. ")")
            cwp.dep:SetColor(color_white)
            -- cwp.dep:SetFont("WB_Small")
            cwp.dep:SetSize(cwp:GetWide() * 0.8, 30)
            cwp.dep:Center()

            function cwp.dep:Paint(w, h)
                if self:GetDisabled() then
                    draw.RoundedBox(4, 0, 0, w, h, Color(140, 140, 140))

                    return
                end

                draw.RoundedBox(4, 0, 0, w, h, nut.config.get('color'))
            end

            function cwp.dep:DoClick()
                self:SetDisabled(true)
                self:SetText("Please Wait...", BC_NEUTRAL, 2, true)
                netstream.Start("PlayerDepositCheck", checks[1])

                timer.Simple(2, function()
                    -- tcb[check[1].id] = true
                    wnd.bal:Update()
                    cwp.dep:Remove()
                    cwp.txHint:Remove()
                    cwp:DisplayDepoBtn()
                end)
            end

            local cAmount = tonumber(checks[1].itemData:getData("amount", nil))
            local tx = BANKCONF.checkTaxes
            local symbol = nut.currency.symbol
            cwp.txHint = cwp:Add("DLabel")
            cwp.txHint:SetText([[
        Taxes will be deduced:
        ]] .. cAmount .. symbol .. [[ - ]] .. cAmount * tx .. symbol .. [[ (]] .. tx * 100 .. [[%)

        Total Deposited: ]] .. cAmount - (cAmount * tx) .. symbol .. [[
      ]])
            -- cwp.txHint:SetFont("WB_Small")
            cwp.txHint:SetColor(color_white)
            cwp.txHint:SizeToContents()
            cwp.txHint:CenterVertical(0.75)
            cwp.txHint:CenterHorizontal()
        end

        cwp:DisplayDepoBtn() --Initial call
    else --No Account Part
        local noacchint = frame:Add("DLabel")
        -- noacchint:SetText("You do not have a bank account, you can talk to a banker to open one.")
        noacchint:SetText("You do not have a bank account, you can create one for " .. nut.currency.symbol .. BANKCONF.accountCreationPrice)
        -- noacchint:SetFont("WB_Small")
        noacchint:SetColor(color_white)
        noacchint:SizeToContents()
        -- noacchint:Center()
        noacchint:CenterHorizontal()
        noacchint:CenterVertical(0.33)
        local createAccountButton = frame:Add("DButton")
        createAccountButton:SetColor(color_white)
        createAccountButton:SetSize(150, 35)
        createAccountButton:SetText("Create an account")
        createAccountButton:CenterHorizontal()
        createAccountButton:CenterVertical(0.67)

        function createAccountButton:Paint(w, h)
            draw.RoundedBox(4, 0, 0, w, h, nut.config.get('color'))
        end

        function createAccountButton:DoClick()
            if (not LocalPlayer():getChar():hasMoney(BANKCONF.accountCreationPrice)) then
                nut.util.notify("You don't have enough money to open a bank account", LocalPlayer())

                return
            end

            netstream.Start("PlayerCreateAccount")
            frame:Close()
        end
    end
end

netstream.Hook("OpenBankingTeller", bankingmenu)