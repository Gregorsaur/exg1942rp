banksubm.logs = function(panel)
  local cpanel = panel:Add("DPanel")
  cpanel:SetSize(panel:GetWide(), 80)
  function cpanel:Paint(w,h)
    draw.RoundedBox(0, 0, 0, w, h, Color(30,30,30))
  end
  
  local actTranslate = {
    "Deposit",
    "Withdraw",
    "Check Deposit",
    "Loan Repay"
  }

  cpanel.hint = cpanel:Add("DLabel")
  cpanel.hint:SetText("Filters")
  -- cpanel.hint:SetFont("WB_Small")
  cpanel.hint:SetColor(color_white)
  cpanel.hint:SizeToContents()
  cpanel.hint:CenterHorizontal()
  cpanel.hint:CenterVertical(0.25)
  
  cpanel.form = cpanel:Add("nutForm")
  cpanel.form:SetSize(cpanel:GetWide(), cpanel:GetTall()*0.75)
  cpanel.form:SetPos(0, cpanel:GetTall()-cpanel.form:GetTall())

  --Player name filter
  local name = cpanel.form:AddTextEntry("Player Name")
  name:SetSize(150,30)
  name:CenterHorizontal()
  name:CenterVertical(0.75)
  -- name:SetFont("WB_Small")
  name:SetPlaceholder("Player Name")
  panel:PlayerSearchTE(name)

  local actType = cpanel.form:AddComboBox()
  actType:AddChoice("All", 0, true)
  actType:AddChoice(actTranslate[1], 1)
  actType:AddChoice(actTranslate[2], 2)
  actType:AddChoice(actTranslate[3], 3)
  actType:AddChoice(actTranslate[4], 4)
  function actType:OnSelect(index, val, sel)
    sel = tonumber(sel)

    if sel == 0 then panel.list:Refresh() return end
    panel.list:Filter(function(panel)
      local action = tonumber(panel.entry.action)
      if action ~= sel then
        panel:Hide()
      end
    end)
  end

  --Getting bank logs
  netstream.Start("GetBankLogs")
  netstream.Hook("ReceiveBankLogs", function(data)
    local pls = player.GetAll()
    local pot = {}

    -- If the player changed tab then stop loading things.
    if (!IsValid(cpanel)) then return end

    --List
    panel.scroll = panel:Add("WScrollList")
    panel.scroll:SetSize(panel:GetWide(), panel:GetTall()-cpanel:GetTall())
    panel.scroll:SetPos(0, cpanel:GetTall())
    panel.list = panel.scroll:GetList()
    function panel.list:Refresh()
      for k,v in pairs(self:GetChildren()) do
        if v.isPlayerSel then continue end
        v:Show()
      end
    end
    function panel.list:Filter(callback)
      for k,v in pairs(self:GetChildren()) do
        if v.isPlayerSel then continue end
        v:Show()

        if callback then callback(v) end
        panel.list:InvalidateLayout(true)
      end
    end

    local curPly
    local function showEntries(ply)
      local et = {}
      for k,entry in pairs(pot[ply]) do
        local e = panel.list:Add("DPanel")
        e.entry = entry
        e.ply = ply
        e:SetSize(panel.list:GetWide(), 30)
        function e:Paint(w,h)
          draw.RoundedBox(0, 0, 0, w, h, Color(45,45,45))
        end
        e:SetAlpha(0)
        e:AlphaTo(255, 0.5)

        e.name = e:Add("DLabel")
        e.name:SetText(ply:Nick())
        -- e.name:SetFont("WB_Small")
        e.name:SetColor(color_white)
        e.name:SetSize(e:GetWide()/3, e:GetTall())
        e.name:SetContentAlignment(5)
        function e.name:Paint(w,h)
          draw.RoundedBox(0, 0, 0, w-2, h, Color(60,60,60))
        end

        e.action = e:Add("DLabel")
        e.action:SetText(actTranslate[tonumber(entry.action)])
        -- e.action:SetFont("WB_Small")
        e.action:SetColor(color_white)
        e.action:SetSize(e:GetWide()/3, e:GetTall())
        e.action:SetContentAlignment(5)
        e.action:SetPos(e.name:GetWide(), 0)
        function e.action:Paint(w,h)
          draw.RoundedBox(0, 0, 0, w-2, h, Color(50,50,50))
        end

        --Getting info (converting from JSON)
        local info
        if isstring(entry.info) then 
          info = util.JSONToTable(entry.info)
        else
          info = entry.info
        end

        e.amount = e:Add("DLabel")
        e.amount:SetText(info.amount .. nut.currency.symbol)
        -- e.amount:SetFont("WB_Small")
        e.amount:SetColor(color_white)
        e.amount:SetSize(e:GetWide()/3, e:GetTall())
        e.amount:SetContentAlignment(5)
        e.amount:SetPos(e.action:GetWide()*2, 0)
        function e.amount:Paint(w,h)
          draw.RoundedBox(0, 0, 0, w-2, h, Color(60,60,60))
        end

        --Show the time of the log
        local year = nut.config.get("year")
        e:SetTooltip(os.date("%I:%M:%S%p - %d/%m/" .. year, info.time))

        et[#et+1] = e
      end

      return et
    end

    local plySelectors = {}
    local function showPlayers()
      local function addBack(callback)
        local bbtn = panel.list:Add("DButton")
        bbtn:SetText("[Back]")
        bbtn:SetColor(color_white)
        -- bbtn:SetFont("WB_Small")
        bbtn:SetSize(panel.list:GetWide(), 40)
        function bbtn:Paint(w,h)
          draw.RoundedBox(0, 0, 0, w, h, Color(45,45,45))
        end
        function bbtn:DoClick()
          callback(self)
        end
      end
      local function remPS(curSel)
        for ply,panel in pairs(plySelectors) do
          if panel == curSel then continue end
          panel:Remove()
        end
      end
      local function showPS()
        for ply,panel in pairs(plySelectors) do
          panel:Show()
        end
      end

      --Determinating potential player info
      for _,ply in pairs(pls) do
        if ply:IsBot() then
          pot[ply] = data["1234"]
        end
        if data[ply:SteamID64()] then
          pot[ply] = data[ply:SteamID64()]
        end
      end

      --Disaplying players
      local playerBtns = {}
      local function HidePlayerBtns(plySel)
        PrintTable(playerBtns)
        for btn,ply in pairs(playerBtns) do
          if plySel ~= ply then
            btn:Hide()
          end
        end
      end
      local function ShowPlayerBtns()
        for btn, ply in pairs(playerBtns) do
          btn:Show()
        end
      end

      local function showBack(entries)
        local back = panel.list:Add("WButton")
        back:SetAccentColor(Color(30,30,30))
        back:SetText("[BACK]")
        back:SetSize(panel.list:GetWide(), 30)
        function back:DoClick()
          for k,v in pairs(entries) do
            v:Remove()
          end

          ShowPlayerBtns()
          self:Remove()
        end
      end

      local curSel = nil
      for ply,v in pairs(pot) do
        local p = panel.list:Add("WButton")
        p:SetAccentColor(Color(40,40,40))
        p:SetSize(panel.list:GetWide(), 45)
        p:SetText(ply:Nick())
        -- p:SetFont("WB_Medium")
        
        function p:DoClick()
          if curSel == ply then return end
          curSel = ply
          HidePlayerBtns(ply)
          local entries = showEntries(ply)
          showBack(entries)
        end

        playerBtns[p] = ply
      end
    end

    showPlayers()
  end)
end