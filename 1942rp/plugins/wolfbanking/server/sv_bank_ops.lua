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
  check = ply:getChar():getInv():getItemByID(check.id)

  if check:getData("target", nil) == ply:SteamID64() then
    local cAmount = tonumber(check:getData("amount"))
    local tx = BANKCONF.checkTaxes --The deposit tax
    local dAmount = cAmount - (cAmount*tx)

    ply:SetBankBal(ply:BankBal() + dAmount)
    ply:notify("Your check was successfuly deposited! (" .. dAmount .. nut.currency.symbol .. ")", NOT_CORRECT)

    check:remove()
  end

  --Log
  banklist.Add(ply, CHECKDEPO, {
    amount = dAmount,
    tax = cAmount*tx,
    time = os.time()
  })
end)

--Repay Loan
netstream.Hook("PlayerRepayLoan", function(ply, amount)
  if not ply:HasLoan() then return end
  
  --Moving money
  ply:SetBankBal(ply:BankBal() - amount)
  ply:SetLoan(ply:LoanAmount() - amount)
  
  --Loan Finish!
  if ply:LoanAmount() <= 0 then
    ply:getChar():setData("bankLoan", nil)
    ply:getChar():setData("bankLoanAmount", nil)

    ply:notify("You have payed the remaining of your loan!", NOT_CORRECT)
  end

   --Log
  banklist.Add(ply, REPAYLOAN, {
    amount = amount,
    time = os.time()
  })
end)