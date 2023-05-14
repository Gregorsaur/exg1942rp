netstream.Hook("BankUpdateAccount.Request", function(banker, atype)
  local URA = BANKCONF.premiumSettings.upRunAmount
  if atype == PREM_ACC then
    Derma_Query("Would you want to take out a premium account? (" .. nut.currency.get(URA) .. "/day)", '', 'Yes', function() netstream.Start("BankUpdateAccount.Return", banker, atype, true) end, 'No', function()  end)
  elseif atype == REG_ACC then
    Derma_Query("Would you want to downgrade your bank account to regular? (You will lose all your benefits)", '', 'Yes', function() netstream.Start("BankUpdateAccount.Return", banker, atype, false) end, 'No', function()  end)
  end

end)

netstream.Hook("BankerCreateLoan.Request",  function(banker, amount)
  Derma_Query(
    banker:Nick() .. " is giving you a " .. nut.currency.get(amount) .. " loan. Do you want to accept it?", "",
    "Accept", function() netstream.Start("BankerCreateLoan.Return", banker, amount, true) end,
    "Refuse", function() netstream.Start("BankerCreateLoan.Return", banker, amount, false) end
  )

  -- nut.util.notifQuery(banker:Nick() .. " is giving you a " .. nut.currency.get(amount) .. " loan. Do you want to accept it?", "Accept", "Refuse", true, NOT_CORRECT,
  -- function(code)
  --   netstream.Start("BankerCreateLoan.Return", banker, amount, (code == 1))
  -- end)
end)
