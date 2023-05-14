banksubm.accounts = function(panel)
  local function GetX(panel)
    local x,y = panel:GetPos() return x
  end
  local function GetY(panel)
    local x,y = panel:GetPos() return y
  end

  local sc = panel:Add("DScrollPanel")
  sc:SetSize(panel:GetSize())

  --Create Account Panel
  --[[
  local ca = panel:section(sc, "Create New Account")

  --Hint
  ca.hint = ca:Add("DLabel")
  ca.hint:SetText(BANKCONF.hint)
  -- ca.hint:SetFont("WB_Small")
  ca.hint:SetColor(Color(200,200,200))
  ca.hint:SetSize(ca:GetWide(),35)
  ca.hint:SetContentAlignment(5)
  ca.hint:SetPos(0,25)
  ca.hint:CenterHorizontal()

  --Form
  local fs = ca:Add("DScrollPanel")
  fs:SetSize(ca:GetWide(), ca:GetTall()-60-ca.hint:GetTall())
  fs:SetPos(0,60-ca.hint:GetTall()/2)

  local name = fs:Add("DTextEntry")
  name:SetPos(32, 25)
  name:SetWide(fs:GetWide() - 64)
  name:SetTall(30)
  function name:Paint(w,h)
    draw.RoundedBox(4, 0, 0, w, h, Color(230,230,230))
    self:DrawTextEntryText(color_black, Color(200,200,200), color_black)
  end
	name:SetText('Player Name')
  function name:Think()
		if name:IsEditing() and name:GetText() == 'Player Name' then
			name:SetText("")
		end
		if not name:IsEditing() and name:GetText() == "" then
			name:SetText('Player Name')
		end
  end
  panel:PlayerSearchTE(name)

  local done = ca:Add("DButton")
  done:SetSize(ca:GetWide(),30)
  done:SetPos(0, ca:GetTall()-done:GetTall())
  -- done:SetFont("WB_Small")
  done:SetText("Create Account")
  done:SetColor(color_white)
  function done:Paint(w,h)
    draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(nut.config.get('color'), 155))
  end
  function done:DoClick()
    if not name.player then
      -- LocalPlayer():notify("Player was not found", NOT_CANCELLED)
      nut.util.notify("Player was not found", LocalPlayer())
      return
    end

    netstream.Start("BankerCreateAccount", name.player)
  end
  --]]

  --Manage Created Accounts
  local man = panel:section(sc, "Manage Accounts (Connected Players)")
  -- man:SetPos(0, ca:GetTall() + 10)
  man:SetPos(0, 10)
  man:SetTall(man:GetTall()+100)

  man.te = man:Add("DTextEntry")
  man.te:SetSize(man:GetWide() - 64, 30)
  man.te:SetPos(32, 45)
  man.te:CenterHorizontal()
	man.te:SetText('Search Roster')
  function man.te:Think()
		if man.te:IsEditing() and man.te:GetText() == 'Search Roster' then
			man.te:SetText("")
		end
		if not man.te:IsEditing() and man.te:GetText() == "" then
			man.te:SetText('Search Roster')
		end
  end
  function man.te:Paint(w,h)
    draw.RoundedBox(4, 0, 0, w, h, Color(230,230,230))
    self:DrawTextEntryText(color_black, Color(200,200,200), color_black)
  end
  panel:PlayerSearchTE(man.te, function()
    if man.profile and IsValid(man.profile) then man.profile:Remove() end
    if man.te.player and IsValid(man.te.player) then --Found Player
      local target = man.te.player

      man.profile = man:Add("DButton")
      man.profile:SetText("")
      man.profile:SetSize(man:GetWide()/4, man:GetTall()-man.hint:GetTall()-man.te:GetTall()-40)
      man.profile:SetPos(0, GetY(man.te)+man.te:GetTall()+10)
      man.profile:CenterHorizontal()
      function man.profile:Paint(w,h)
        draw.RoundedBox(4, 0, 0, w, h, Color(44, 44, 44))
      end

      if not target:HasBankAccount() then
        local noacc = man.profile:Add("DLabel")
        noacc:SetText("No Account")
        -- noacc:SetFont("WB_Small")
        noacc:SetColor(color_white)
        noacc:SizeToContents()
        noacc:Center()
        return
      end

      man.profile:SetTooltip("Click to Manage")
      function man.profile:DoClick()
        local menu = DermaMenu()
        --Upgrade/Downgrade
        local char = target:getChar()
        local accType = char:getData("bankAccType", REG_ACC)
        if accType == REG_ACC then
          local upg = menu:AddOption("Upgrade Account to Premium", function()
            netstream.Start("BankerUpdateAccountType", target, PREM_ACC)
          end):SetIcon("icon16/arrow_up.png")
        elseif accType == PREM_ACC then
          local dgd = menu:AddOption("Downgrade Account to Regular", function()
            netstream.Start("BankerUpdateAccountType", target, REG_ACC)
          end):SetIcon("icon16/arrow_down.png")
        end

        --Delete account
        local del = menu:AddSubMenu("Delete Account"):AddOption("Confirm", function()
          netstream.Start("BankerDeleteAccount", target)
          man.te:OnEnter()
        end):SetIcon("icon16/tick.png")

        menu:Open()
      end
        if target:HasBankAccount() then
          man.profile.name = man.profile:Add("DLabel")
          man.profile.name:SetText(target:Nick())
          -- man.profile.name:SetFont("WB_Small")
          man.profile.name:SetColor(color_white)
          man.profile.name:SetSize(man.profile:GetWide(), 20)
          man.profile.name:SetContentAlignment(5)
          function man.profile.name:Paint(w,h)
            draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,50))
          end

          --The markup string of the info
          -- local mkup = "<font=WB_Small>Account Type: %s\nAccount Balance: %s\nTotal Loan: %s\nTotal Balance: %s\nNext Fees: %s</font>"
          local mkup = "Account Type: %s\nAccount Balance: %s\nTotal Loan: %s\nTotal Balance: %s\nNext Fees: %s"

          --Getting all the info needed in string format
          local at = target:GetBankAccType()
          if at == PREM_ACC then at = "<colour=0, 180, 255>Premium</colour>" end
          if at == REG_ACC then at = "Regular" end

          local ab = target:BankBal() .. nut.currency.symbol
          local tl = (target:LoanAmount() or 0) .. nut.currency.symbol
          local tbal = (target:BankBal() - (target:LoanAmount() or 0))
          local tb = tbal .. nut.currency.symbol
          if tbal < 0 then
            tb = "<colour=255,0,0>" .. tb .. "</colour>"
          end
          if target:getChar():getData("onRunNextCheck") then
            local diff = string.FormattedTime(target:getChar():getData("upRunNextCheck") - os.time())
            local nf = ""
            for k,v in pairs(diff) do
              if v > 0 then
                nf = nf .. " " .. v .. k
              end
            end

            if target:getChar():getData("upRunNextCheck") - os.time() < 0 then
              nf = "Now"
            end
          else
            nf = "None"
          end

          mkup = markup.Parse(string.format(mkup, at, ab, tl, tb, nf), man.profile:GetWide())

          --Displaying Info
          man.profile.info = man.profile:Add("DPanel")
          man.profile.info:SetPos(-20)
          man.profile.info:SetSize(mkup:Size())
          man.profile.info:Center()
          function man.profile.info:Paint(w,h)
            mkup:Draw(0, h/2, TEXT_ALIGN_Left, TEXT_ALIGN_CENTER)
          end
        end
    end
  end)
end
