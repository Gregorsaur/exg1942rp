--[[BANKER ACTIONS]]
--
BANKCONF = BANKCONF

function PlayerHasBankFlags(ply)
    return ply:getChar():getFlags():find("b")
end

--CREATE/DELETE
-- netstream.Hook("BankerCreateAccount", function(ply, target)
--   if not PlayerHasBankFlags(ply) then return end
--   local char = target:getChar()
--   if target:HasBankAccount() then
--     ply:notify("Player has already got a bank account", NOT_CANCELLED)
--     return
--   end
--   --Setting variables
--   target:SetHasBank(true)
--   target:SetBankAccountType(REG_ACC)
--   --Setting Intervals
--   char:setData("upRunNextCheck", os.time() + BANKCONF.upRunInverval)
--   --Notifying
--   ply:notify("You successfuly created an account for " .. target:Nick(), NOT_CORRECT)
--   target:notify(ply:Nick() .. " Created a bank account for you", NOT_TUTORIAL)
-- end)
netstream.Hook("BankerDeleteAccount", function(ply, target)
    if not PlayerHasBankFlags(ply) then return end
    if not ply:getChar():getFlags():find("y") then return end
    local char = target:getChar()
    if not target:HasBankAccount() then return end --No acc?
    local prevBankBal = target:BankBal()
    target:SetHasBank(false)
    target:SetBankBal(0) --Reset bank balance
    char:giveMoney(prevBankBal) --Give back money
    --Notifying
    target:notify("Your bank account was deleted, you got " .. prevBankBal .. nut.currency.symbol .. " back.", NOT_ERROR) --Notify target
    ply:notify("You successfuly deleted " .. target:Nick() .. "'s account", NOT_CORRECT) --Notify banker
end)

--UPDATE ACCOUNT TYPE
netstream.Hook("BankerUpdateAccountType", function(ply, target, atype)
    if not PlayerHasBankFlags(ply) then return end
    netstream.Start(target, "BankUpdateAccount.Request", ply, atype)
end)

netstream.Hook("BankUpdateAccount.Return", function(ply, banker, atype, accepted)
    if not accepted then
        banker:notify(ply:Nick() .. " refused to update his/her bank account.", NOT_CANCELLED)
    else
        local char = ply:getChar()
        local bal = ply:BankBal()
        local URA = BANKCONF.premiumSettings.upRunAmount

        --Swtiching to premium account
        if atype == PREM_ACC then
            if char:getData("bankAccType") == PREM_ACC then return end

            --Initial premium fee
            if bal > URA then
                ply:SetBankBal(bal - URA)
                ply:SetBankAccountType(PREM_ACC)
                ply:AddSubscription("bankprem")
                banker:notify("Successfuly upgraded " .. ply:Nick() .. "'s  account to premium", NOT_CORRECT)
            else --Not enough money in account
                banker:notify(ply:Nick() .. " doesn't have enough money to get the premium started. (50" .. nut.currency.symbol .. ")", NOT_CANCELLED)

                return
            end
        end

        --Switching to regular account
        if atype == REG_ACC then
            ply:SetBankAccountType(REG_ACC)
            ply:RemSubscription("bankprem")
            banker:notify("Account successfuly downgraded", NOT_CORRECT)
        end
    end
end)

--CREATE LOAN
netstream.Hook("BankerCreateLoan", function(ply, target, amount)
    if not PlayerHasBankFlags(ply) then return end
    if not ply:getChar():getFlags():find("l") then return end

    if not ply:getChar():getFlags():find("b") then
        MsgC(Color(255, 0, 0), ply:Nick() .. "(" .. ply:SteamID64() .. ") tried to create a loan without a the 'b' flag!\n")

        return
    end

    if BGF:GetFunds() < amount then
        ply:Notify("The " .. BANKNAME .. " does not have enough funds to provide the loan.", NOT_CANCELLED)

        return
    end

    --Send request to player
    netstream.Start(target, "BankerCreateLoan.Request", ply, amount)
end)

netstream.Hook("BankerCreateLoan.Return", function(target, banker, amount, accepted)
    if not accepted then
        banker:notify(target:Nick() .. " refused your loan.", NOT_CANCELLED)

        return
    else
        local char = target:getChar()
        target:SetBankBal(target:BankBal() + amount) --Give money
        --Setting vars
        target:SetLoan(target:LoanAmount() + amount)
        char:setData("bankLoanInterval", CurTime() + BANKCONF.loanInterestInverval)
        --Removing money from BGF
        BGF:RemoveFunds(amount)
        --Notifying
        banker:notify("You successfuly created a loan for " .. target:Nick(), NOT_CORRECT)
        target:notify("You have accepted a " .. nut.currency.get(amount) .. " loan!", NOT_CORRECT)
    end
end)