local function openBankingManager()
  if not LocalPlayer():getChar():getFlags():find("b") then --Check if player has 'b' flag
    nut.util.notify("You cannot access this menu", NOT_CANCELLED)
    return
  end

  local frame = vgui.Create("DFrame")
  frame:SetSize(750,500)
  frame:SetTitle("Bank Manager")
  frame:MakePopup()
  frame:Center()

  -- local frame = frame:GetWorkPanel()
  -- function frame:ClearChildren(callback)
  --   for k,v in pairs(self:GetChildren()) do
  --     if v == frame.tabsScroll or v == frame.tabsList then continue end
  --     v:AlphaTo(0, 0.2, 0)
  --   end

  --   timer.Simple(0.2, function() if callback then callback() end end)
  -- end

  frame.tabsScroll = frame:Add("DScrollPanel")
  frame.tabsScroll:SetSize(frame:GetWide() - 1, 30)
  frame.tabsScroll:SetPos(1, 24)
  frame.tabsList = frame.tabsScroll:Add("DIconLayout")
  frame.tabsList:SetSize(frame.tabsScroll:GetSize())

  local function createIframe()
    local iframe = frame:Add("DPanel")
    iframe:SetSize(frame:GetWide() - 2, frame:GetTall() - 55)
    iframe:SetPos(1, 55)
    iframe.Paint = nil

    function iframe:PlayerSearchTE(te, callback)
      te.player = nil --Reset player
      function te:OnEnter()
        self:RequestFocus()
        local val = self:GetText():lower()
        for k,v in pairs(player.GetAll()) do
          local pn = v:Nick():lower() --Player Name
          if pn:find(val) or val == pn then
            self:SetText(v:Nick())
            self.player = v --Ez access to the desired player
          end
        end

        if callback then callback() end
      end
    end

    return iframe
  end
  local iframe = createIframe()

  function iframe:section(panel, hint)
    local s = panel:Add("DPanel")
    s:SetSize(panel:GetWide(),panel:GetTall()*0.35)
    function s:Paint(w,h)
      surface.SetDrawColor(Color(40,40,40))
      surface.DrawRect(0, 0, w, h)
    end

    s.hint = s:Add("DLabel")
    s.hint:SetText(hint)
    -- s.hint:SetFont("WB_Small")
    s.hint:SetColor(color_white)
    s.hint:SetSize(s:GetWide(), 25)
    s.hint:SetContentAlignment(5)
    function s.hint:Paint(w,h)
      draw.RoundedBox(0, 0, 0, w, h, Color(30,30,30))
    end

    return s
  end

  --BGF Summary
  title = iframe:Add("DLabel")
  title:SetText("General Bank funds & stats")
  -- title:SetFont("WB_Large")
  title:SizeToContents()
  title:SetPos(0,5)
  title:CenterHorizontal()

  local function GetX(panel)
    local x,y = panel:GetPos() return x
  end
  local function GetY(panel)
    local x,y = panel:GetPos() return y
  end

  local function addStat(title, val, horizontalFrac, verticalFrac)
    horizontalFrac = horizontalFrac or 0.5
    verticalFrac = verticalFrac or 0.5

    local g = {}
    
    g[title.."title"] = iframe:Add("DLabel")
    local statTitle = g[title.."title"]
    statTitle:SetText(title)
    -- statTitle:SetFont("WB_Medium")
    statTitle:SizeToContents()
    statTitle:CenterHorizontal(horizontalFrac)
    statTitle:CenterVertical(verticalFrac)

    g[title .. "val"] = iframe:Add("DLabel")
    local statVal = g[title .. "val"]
    statVal:SetText(val)
    -- statVal:SetFont("WB_Enormous")
    statVal:SizeToContents()
		local side = side or BOTTOM
  
		if side == BOTTOM then
			local p2x,p2y = statTitle:GetPos()
			statVal:SetPos(p2x, p2y+statTitle:GetTall()+10)
		elseif side == LEFT then
			statVal:SetPos(GetX(statTitle)-statVal:GetWide()-5,GetY(statVal)-statVal:GetTall()/4)
		elseif side == RIGHT then
			statVal:SetPos(GetX(statTitle)+statTitle:GetWide(), GetY(statTitle)-statVal:GetTall()/4)
		end
    statVal:SetPos(GetX(statVal)+statTitle:GetWide()/2-statVal:GetWide()/2, GetY(statVal))

    return statTitle, statVal
  end

  local t,v = addStat("Funds left for investments/loans", nut.currency.get(BGF:GetFunds()), 0.5, 0.25)
  v:SetColor(Color(75,225,75))

  BGF:CalculateStats(function(data)
    local totAcc = data.totalAccounts
    local premAcc = data.totalPremium
    
    --Adding stats to menu
    addStat("Total Bank Accounts", data.totalAccounts, 0.20)
    addStat("Total Premium Accounts", data.totalPremium, 0.80)

    --Calculating what pourcentage of accounts are premium
    local pourc = math.ceil((premAcc*100)/totAcc)
    addStat("Percentage of premium accounts", pourc .. "%")

    --Calculating revenue/hr
    local accPremFees = BANKCONF.premiumSettings.upRunAmount
    local rev = math.Round(premAcc * accPremFees, 2)
    local t,v = addStat("Revenue per day", nut.currency.get(rev) .. "/day", 0.5, 0.75)
    v:SetColor(Color(75,225,75))
  end)

  local tabs = {
    ["Accounts"] = banksubm.accounts,
    ["Loans"] = banksubm.loans
  }

  local activeTab
  for title,open in pairs(tabs) do
    local t = frame.tabsList:Add("DButton")
    t:SetText(title)
    -- t:SetFont("WB_Small")
    t:SetColor(color_white)
    t:SetSize(frame.tabsList:GetWide()/table.Count(tabs), 30)
    function t:Paint(w,h)
      draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(nut.config.get('color'), 105))
      if self == activeTab then
        surface.SetDrawColor(Color(255, 75, 75))
        surface.DrawRect(0, h-1, w, 5)
      end
    end
    function t:DoClick()
      activeTab = self
      iframe:Clear()
      open(iframe)
    end

    -- --Auto Select first tab
    -- if title == "Accounts" then
    --   t:DoClick()
    -- end
  end
end

netstream.Hook("OpenBankingManageMenu", openBankingManager)
