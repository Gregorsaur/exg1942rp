BANKCONF = BANKCONF

local PLAYER = FindMetaTable("Player")

function PLAYER:HasBankAccount()
  return self:getNetVar("hasBankAcc", false)
end

function PLAYER:BankBal()
  return self:getNetVar("bankBal", 0)
end

function PLAYER:GetBankAccType()
  return self:getNetVar("bankAccType", REG_ACC)
end

function PLAYER:HasLoan()
  return self:getNetVar("bankLoanAmount", 0) > 0
end

function PLAYER:LoanAmount()
  return self:getNetVar("bankLoanAmount", 0)
end
