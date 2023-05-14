net.Receive("collect_paycheck", function()
    local client = net.ReadEntity()
    local char = client:getChar()
    local bal = client:BankBal()

    if char then
        local amount = char:getData("earnings", 0)

        if client:HasBankAccount() then
            if amount > 0 then
                client:notify("You have been paid " .. amount .. ". This value was sent to the bank")
                client:SetBankBal(bal + amount)
                char:setData("earnings", 0)
            else
                client:notify("You do not have any payments to receive.")
            end
        else
            if amount > 0 then
                client:notify("You have been paid " .. amount .. ".")
                char:giveMoney(amount)
                char:setData("earnings", 0)
            else
                client:notify("You do not have any payments to receive.")
            end
        end
    end
end)