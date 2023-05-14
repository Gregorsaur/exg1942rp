local function checkForLoans()
    for _, ply in pairs(player.GetAll()) do
        local char = ply:getChar()
        local data = char.vars.data
        if not data.bankLoan then continue end

        if os.time() >= data.bankLoanInterval then
            local playerConnected = not isstring(ply)
            local amount = data.bankLoanAmount
            local accType = data.bankAccType
            local interRate

            --Getting Interest Rate based on account type
            if accType == PREM_ACC then
                interRate = BANKCONF.premiumSettings.loanInter
            else
                interRate = BANKCONF.basicSettings.loanInter
            end

            --Calculate interest amount
            local ia = amount * interRate
            local newAmount = math.Round(ply:LoanAmount() + ia)
            local newInterval = os.time() + BANKCONF.secDay

            if playerConnected then
                ply:notify("The loan interest passed, " .. ia .. nut.currency.symbol .. " got added to your loan")
                ply:SetLoan(newAmount)
                --Setting new check time
                ply:getChar():setData("bankLoanInterval", newInterval)
            end
        end
    end

    print(" -> Checked Player Loans")
end

timer.Create("BankerChecker", 900, 0, function()
    print("Banking Checker Running...")
    checkForLoans()
end)