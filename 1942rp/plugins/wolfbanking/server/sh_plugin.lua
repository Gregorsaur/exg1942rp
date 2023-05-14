PLUGIN = PLUGIN or {}
PLUGIN.name = "Banking"
PLUGIN.desc = "The banking solution for 1942RP"
PLUGIN.author = "Robert Bearson // Barata"

BANKCONF = {}

--Enums
REG_ACC = 1
PREM_ACC = 2

--Settings
nut.util.include("sh_bank_gen_funds.lua") --Get the BGF vars before assigning them to the BANKCONF settings table
BANKCONF.secDay = 86400 --How many seconds in a (real time) day
BANKCONF.checkTaxes = 0.15 -- 15% Taxes on check deposit

BANKCONF.upRunInverval = 14400 --Interval of when players need to pay for their account
BANKCONF.loanInterestInverval = BANKCONF.secDay --Adds interests everyday
BANKCONF.premiumSettings = {
  upRunAmount = 50,
  loanInter = 0.17, -- premium account loan interest
  balInter = 0.03 --10% Balance Interest
}

BANKCONF.inventorySize = {
  -- 100 slots
  default = {
    width = 10,
    height = 10
  },
  -- 144 slots
  vip = {
    width = 12,
    height = 12
  }
}

-- nut.item.registerInv("itemBankInventory", 10, 10) --100 Slots
-- nut.item.registerInv("itemBankInventoryVIP", 12, 12) --144 Slots

-- local gridInvBase = nut.inventory.types["grid"]

-- local itemBankInventory = gridInvBase:extend("itemBankInventory")
-- function itemBankInventory:getWidth() return 10 end
-- function itemBankInventory:getHeight() return 10 end
-- itemBankInventory:register("itemBankInventory")


BANKCONF.basicSettings = {
  loanInter = 0.025, -- regular account loan interest
}

BANKCONF.vipGroups = {
  "founder",
  "director",
  "hos",
  "sa",
  "senioradmin",
  "administrator",
  "jradmin",
  "moderator",
  "jrmod",
  "trialmod",
  "diamond",
  "platinum",
  "gold"
}

BANKCONF.hint = "Enter part of or the full name of the player then press ENTER"

--Resources
resource.AddFile("sound/artemis/signatureb.wav")
nut.util.include("sh_meta.lua")
nut.util.include("server/sv_meta.lua")
nut.util.include("sh_bank_logging.lua")
nut.util.include("server/sv_player_actions.lua")
nut.util.include("server/sv_banker_actions.lua")
nut.util.include("server/sv_intervals.lua")
nut.util.include("subscriptions/sh_subscriptions.lua")
nut.util.include("subscriptions/sv_subscriptions.lua")

banksubm = {}
nut.util.include("derma/subm/cl_accounts.lua")
nut.util.include("derma/subm/cl_loans.lua")
nut.util.include("derma/subm/cl_logs.lua")

function PLUGIN:LoadData()
  -- REE
  banklist:Init()
end

-- This hook does not run....
hook.Add("PlayerLoadedChar", "CheckWhoHasBankAccount", function(ply, char, lastChar)
    ply:SetHasBank(char:getData("hasBankAcc", false))
    ply:SetBankBal(char:getData("bankBal", 0))
    ply:SetBankAccountType(char:getData("bankAccType", REG_ACC))
    ply:SetLoan(char:getData("bankLoanAmount", 0))

    --Transfer player from old premium system to new
    -- print("BankAccountType", ply:GetBankAccType(), PREM_ACC)
    if ply:GetBankAccType() == PREM_ACC then
      local subs = ply:GetSubscriptions()
      for k,v in pairs(subs) do
        if k:find("bankprem") then return end --Player got a subscription
      end

      --Create subscription for the guy
      ply:AddSubscription("bankprem")
    end
end)

--Adding banker flag
nut.flag.add("b", "Allows the access to the banker menu")
nut.flag.add("y", "Allows to yeet an bank account")
nut.flag.add("l", "Allows to give out loans")

--Banker Manager Menu Command
nut.command.add("bank", {
  onRun = function(ply)
    netstream.Start(ply, "OpenBankingManageMenu")
  end
})

--Adding subscription
PLUGIN.subscriptions["bankprem"] = {
  name = "Bank Premium Account",
  cost = BANKCONF.premiumSettings.upRunAmount,
  interval = 14400,
  onRun = function(ply, sub, data)
    --Applying balance interest
    local bal = ply:BankBal()
    local interest = BANKCONF.premiumSettings.balInter

    local nbal = math.Round(bal * interest)
    ply:SetBankBal(math.Round(bal + nbal)) --Setting new balance
    ply:notify("You gained " .. nut.currency.get(nbal) .. " from your balance interest.")

    --Giving the cost of the premium bank fees to BGF
    BGF:AddFunds(sub.cost)
  end,
  onCancel = function(ply)
    ply:notify("You were stripped from your premium bank account!", NOT_ERROR)
    ply:SetBankAccountType(REG_ACC)
  end
}

-- hook.Add("AddSubscription", "AddPremiumBankSubscription", function(subs)  
  
-- end)