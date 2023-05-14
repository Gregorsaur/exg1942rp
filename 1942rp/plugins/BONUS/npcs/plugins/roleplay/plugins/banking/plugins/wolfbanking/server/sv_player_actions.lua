-- Create account
netstream.Hook("PlayerCreateAccount", function(ply)
    if ply:HasBankAccount() then
        ply:notify("You already have a bank account", NOT_CANCELLED)

        return
    end

    local char = ply:getChar()

    -- Take money
    if not char:hasMoney(BANKCONF.accountCreationPrice) then
        ply:notify("You don't have enough money to create a bank account")

        return
    end

    char:takeMoney(BANKCONF.accountCreationPrice)
    --Setting variables
    ply:SetHasBank(true)
    ply:SetBankAccountType(REG_ACC)
    --Setting Intervals
    char:setData("upRunNextCheck", os.time() + BANKCONF.upRunInverval)
    --Notifying
    ply:notify("You successfuly created an account", NOT_CORRECT)
end)

--Deposit/Withdraw
netstream.Hook("playerBankDeposit", function(ply, amount)
    local char = ply:getChar()
    local bal = ply:BankBal()

    if char:hasMoney(amount) then
        char:takeMoney(amount)
        ply:SetBankBal(bal + amount)
        ply:notify(amount .. nut.currency.symbol .. " was deposited into your account.", NOT_CORRECT)
    else
        ply:notify("Something went wrong when depositing the money (Err: NEF)", NOT_CANCELLED)
    end

    --Log
    banklist.Add(ply, DEPOSIT, {
        amount = amount,
        time = os.time()
    })
end)

netstream.Hook("playerBankWithdraw", function(ply, amount)
    if amount < 0 then return end
    local char = ply:getChar()
    local bal = ply:BankBal()

    if bal >= amount then
        char:giveMoney(amount)
        ply:SetBankBal(bal - amount)
        ply:notify(amount .. nut.currency.symbol .. " was withdrawn", NOT_CORRECT)
    else
        ply:notify("Something went wrong while withdrawing the money (Err: NEF2)", NOT_CANCELLED)
    end

    --Log
    banklist.Add(ply, WITHDRAW, {
        amount = amount,
        time = os.time()
    })
end)

--Deposit Check
netstream.Hook("PlayerDepositCheck", function(ply, check)
    check = ply:getChar():getInv():getItemByID(check.itemData.id)
    print(check:getData("amount"))

    if check:getData("target", nil) == ply:SteamID64() then
        local cAmount = tonumber(check:getData("amount"))
        local tx = BANKCONF.checkTaxes --The deposit tax
        local dAmount = cAmount - (cAmount * tx)
        ply:SetBankBal(ply:BankBal() + dAmount)
        ply:notify("Your check was successfuly deposited! (" .. dAmount .. nut.currency.symbol .. ")", NOT_CORRECT)
        BGF:AddFunds(cAmount * tx) --Add tax to BGF
        check:remove()

        --Log
        banklist.Add(ply, CHECKDEPO, {
            amount = dAmount,
            tax = cAmount * tx,
            time = os.time()
        })
    end
end)

--Repay Loan
netstream.Hook("PlayerRepayLoan", function(ply, amount)
    if not ply:HasLoan() then return end
    --Moving money
    ply:SetBankBal(ply:BankBal() - amount)
    ply:SetLoan(ply:LoanAmount() - amount)
    --Regiving money to BGF
    BGF:AddFunds(amount)

    --Loan Finish!
    if ply:LoanAmount() <= 0 then
        ply:SetLoan(0)
        ply:notify("You have payed the remaining of your loan!", NOT_CORRECT)
    end

    ply:notify("You repayed " .. nut.currency.get(amount) .. " off of your loan")

    --Log
    banklist.Add(ply, REPAYLOAN, {
        amount = amount,
        time = os.time()
    })
end)

--Player Writes Check
netstream.Hook("PlayerWritesCheck", function(ply, item, target, amount)
    amount = tonumber(amount)
    local char = ply:getChar()
    local bBal = ply:BankBal()
    if not bBal >= amount then return end
    ply:SetBankBal(bBal - amount)

    for k, v in pairs(char:getInv():getItems()) do
        if v.id == item.id then
            v:setData("writer", ply:SteamID64())
            v:setData("targetName", target:Nick())
            v:setData("target", target:SteamID64())
            v:setData("amount", amount)
            break
        end
    end
end)

--Player open item bank
netstream.Hook("PlayerOpenItemBank", function(ply)
    local char = ply:getChar()
    local ibInvID = char:getData("itemBankInvID", nil)
    local isVIP = false

    if BANKCONF.vipGroups and BANKCONF.vipGroups[ply:GetUserGroup()] then
        isVIP = BANKCONF.vipGroups[ply:GetUserGroup()]
    end

    local inventorySize = BANKCONF.inventorySize[isVIP and "vip" or "default"]

    --Inventory has not been created yet
    if not ibInvID then
        --Creating inventory
        nut.inventory.instance("grid"):next(function(inventory)
            inventory:sync(ply)
            inventory:setSize(inventorySize.width, inventorySize.height)
            inventory:setOwner(ply)
            char:setData("itemBankInvID", inventory:getID())
            inventory:sync(ply)
            inventory.isBank = true

            -- Avoid inventory having not synced with the client
            timer.Simple(2, function()
                netstream.Start(ply, "OpenItemBank", ibInvID)
            end)
        end)
    else --Possible problems trying to get solved.
        local inventory = nut.inventory.instances[ibInvID]
        local w, h = inventory:getSize()
        inventory.isBank = true

        if w ~= inventorySize.width or h ~= inventorySize.height then
            inventory:setSize(inventorySize.width, inventorySize.height)
            inventory:sync(ply)
        end

        netstream.Start(ply, "OpenItemBank", ibInvID)
    end
end)