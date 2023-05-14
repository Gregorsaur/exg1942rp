local PLAYER = FindMetaTable("Player")

function PLAYER:SetHasBank(hasBank)
    if self.getChar and self:getChar() then
        local char = self:getChar()
        char:setData("hasBankAcc", hasBank)
        self:setNetVar("hasBankAcc", hasBank)
    end
end

function PLAYER:SetBankAccountType(acc)
    if self.getChar and self:getChar() then
        local char = self:getChar()
        char:setData("bankAccType", acc)
        self:setNetVar("bankAccType", acc)
    end
end

function PLAYER:SetBankBal(bal)
    self:getChar():setData("bankBal", bal)
    self:setNetVar("bankBal", bal)
end

function PLAYER:SetLoan(amount)
    self:getChar():setData("bankLoanAmount", amount)
    self:setNetVar("bankLoanAmount", amount)
end