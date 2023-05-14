local function GetX(panel)
  local x,y = panel:GetPos() return x
end
local function GetY(panel)
  local x,y = panel:GetPos() return y
end

banksubm.loans = function(panel)
  local sc = panel:Add("DScrollPanel")
  sc:SetSize(panel:GetSize())

  --Panel Section
  local cr = panel:section(sc, "Create Loan")
  -- cr:SetTall(220)

  local wf = cr:Add("DScrollPanel") --Form
  wf:SetSize(cr:GetWide(), cr:GetTall() - 30)

  --Form Entries
  local name = wf:Add("DTextEntry")
  name:SetPos(175, 40)
  name:SetWide(200)
	name:SetText('Player Name')
  function name:Think()
		if name:IsEditing() and name:GetText() == 'Player Name' then
			name:SetText("")
		end
		if not name:IsEditing() and name:GetText() == "" then
			name:SetText('Player Name')
		end
  end
  name:SetTall(30)
  function name:Paint(w,h)
    draw.RoundedBox(4, 0, 0, w, h, Color(230,230,230))
    self:DrawTextEntryText(color_black, Color(200,200,200), color_black)
  end
  panel:PlayerSearchTE(name, function()
    if not name.player then return end
    if wf.amount:GetText() == nil or wf.amount:GetText() == "" then return end
    wf.amount:RequestFocus() --Focus on other TE

    local hint = cr:Add("DLabel")
    -- hint:SetFont("WB_Small")
    hint:SetColor(color_white)
    hint:SetAlpha(0)
    hint:SetContentAlignment(5)
    function hint:PerformLayout()
    end

    --Account Configs
    local p = BANKCONF.premiumSettings
    local r = BANKCONF.basicSettings

    function hint:Think()
      local amount = tonumber(wf.amount:GetText())
      if not amount then return end

      local inter
      if name.player:GetBankAccType() == PREM_ACC then
        inter = p.loanInter
      elseif name.player:GetBankAccType() == REG_ACC then
        inter = r.loanInter
      end

      hint:SetText([[
        Daily interests apply at a rate of: ]] .. inter .. [[%
        (+]] .. amount * inter .. nut.currency.symbol .. [[/day)
      ]])

      self:SetAlpha(255)
      self:SizeToContents()
      self:CenterHorizontal()
      self:CenterVertical(0.68)
    end
  end)
  wf.amount = wf:Add("DTextEntry")
  wf.amount:SetPos(385, 40)
  wf.amount:SetWide(200)
	wf.amount:SetText('Amount')
  function wf.amount:Think()
		if wf.amount:IsEditing() and wf.amount:GetText() == 'Amount' then
			wf.amount:SetText("")
		end
		if not wf.amount:IsEditing() and wf.amount:GetText() == "" then
			wf.amount:SetText('Amount')
		end
  end
  wf.amount:SetTall(30)
  wf.amount:SetNumeric(true)
  function wf.amount:Paint(w,h)
    draw.RoundedBox(4, 0, 0, w, h, Color(230,230,230))
    self:DrawTextEntryText(color_black, Color(200,200,200), color_black)
  end

  --Done Button
  local done = cr:Add("DButton")
  done:SetText("Create Loan")
  -- done:SetFont("WB_Small")
  done:SetColor(color_white)
  done:SetSize(cr:GetWide(), 30)
  done:SetPos(0,cr:GetTall()-done:GetTall())
  function done:Paint(w,h)
    draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(nut.config.get('color'), 155))
  end
  function done:DoClick()
    if not wf.amount:GetText() or wf.amount:GetText() == "" then return end
    if not name.player or not IsValid(name.player) then return end
    local loanAmount = tonumber(wf.amount:GetText())

	if loanAmount > 10000 and not LocalPlayer():IsSuperAdmin() then
		nut.util.notify("You can only loan out a maximum of $10000", NOT_ERROR)
      	return
	end

    if loanAmount <= 0 then
      nut.util.notify("You trying to rob this player or what?", NOT_ERROR)
      return
    end

    if not name.player:HasBankAccount() then
      nut.util.notify("Player doesn't have a bank account!", NOT_ERROR)
      return
    end

    if loanAmount > BGF:GetFunds() then
      nut.util.notify("The bankers do not have funds to lend money at the moment", NOT_CANCELLED)
      return
    end

    local frame = vgui.Create("DFrame")
    frame:SetSize(500,200)
    frame:Center()
    frame:MakePopup()

    local function createChoice(text, col)
      local b = frame:Add("DButton")
      b:SetText(text)
      b:SetColor(color_white)
      -- b:SetFont("WB_Small")
      b:SetSize(frame:GetWide()/2, 30)
      function b:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, nut.config.get('color'))
      end

      return b
    end

    --Choices
    local y = createChoice("Yes", BC_AGREE)
    y:SetPos(0, frame:GetTall()-y:GetTall())
    function y:DoClick()
      frame:Close()

      netstream.Start("BankerCreateLoan", name.player, loanAmount)
    end

    local n = createChoice("No", BC_CRITICAL)
    n:SetPos(y:GetWide(), frame:GetTall()-n:GetTall())
    function n:DoClick()
      frame:Close()
    end

    --What's the question?
    frame.hint = frame:Add("DLabel")
    frame.hint:SetText("Are you sure you want to create a loan for " .. name.player:Nick() .. "?")
    -- frame.hint:SetFont("WB_Small")
    frame.hint:SetColor(color_white)
    frame.hint:SizeToContents()
    frame.hint:SetPos(0, (frame:GetTall()-y:GetTall())/2 - frame.hint:GetTall()/2)
    frame.hint:CenterHorizontal()
  end

  local loanlist = panel:section(sc, "Loan List")
  loanlist:SetSize(panel:GetWide(), panel:GetTall()-cr:GetTall()-20)
  local side = side or BOTTOM

  if side == BOTTOM then
    local p2x,p2y = cr:GetPos()
    loanlist:SetPos(p2x, p2y+cr:GetTall()+10)
  elseif side == LEFT then
    loanlist:SetPos(GetX(cr)-loanlist:GetWide()-5,GetY(loanlist)-loanlist:GetTall()/4)
  elseif side == RIGHT then
    loanlist:SetPos(GetX(cr)+cr:GetWide(), GetY(cr)-loanlist:GetTall()/4)
  end
  loanlist:SetPos(GetX(loanlist)+cr:GetWide()/2-loanlist:GetWide()/2, GetY(loanlist))

  local PANEL = {}
  function PANEL:GetList(sx,sy)
    sx = sx or 1
    sy = sy or 1
    self.list = self:Add("DIconLayout")
    self.list:SetPos(sx,sy)
    self.list:SetSpaceX(sx)
    self.list:SetSpaceY(sy)

    self.list:SetWide(self:GetWide()-sx*2, self:GetTall()-sy*2)

    function self.list:AddTitleBar(txt)
      local title = self:Add("DLabel")
      title:SetText(txt)
      -- title:SetFont("WB_Small")
      title:SetColor(color_white)
      title:SetSize(self:GetWide(), 30)
      title:SetContentAlignment(5)
      title.noRemove = true
      function title:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(40,40,40))
      end
      
      return title
    end

    function self.list:RemoveChildren()
      for k,v in pairs(self:GetChildren()) do
        if not v.noRemove then v:Remove() end
      end
    end

    return self.list
  end

  vgui.Register("nutscriptScrollList",PANEL,"DScrollPanel")

  local lsc = loanlist:Add("nutscriptScrollList")
  lsc:SetSize(loanlist:GetWide(), loanlist:GetTall()-25)
  lsc:SetPos(0,25)
  local llist = lsc:GetList(2,2)

  local function addPlayerToList(ply)
    if not ply.getChar or not ply:getChar() then return end
    local loanAmt = ply:LoanAmount()

    local pp = llist:Add("DPanel")
    pp:SetSize(llist:GetWide(), 35)
    function pp:Paint(w,h)
      draw.RoundedBox(4,0,0,w,h,Color(35,35,35))
    end

    pp.name = pp:Add("DLabel")
    pp.name:SetText(ply:Nick())
    -- pp.name:SetFont("WB_Small")
    pp.name:SetColor(color_white)
    pp.name:SizeToContents()
    pp.name:CenterHorizontal(0.25)
    pp.name:CenterVertical()

    pp.amt = pp:Add("DLabel")
    pp.amt:SetText(nut.currency.get(loanAmt))
    pp.amt:SetColor(Color(255,0,0))
    -- pp.amt:SetFont("WB_Small")
    pp.amt:SizeToContents()
    pp.amt:CenterHorizontal(0.75)
    pp.amt:CenterVertical()
  end

  for _,ply in pairs(player.GetAll()) do
    if ply.getChar and ply:getChar() then
      if ply:HasBankAccount() and ply:LoanAmount() > 0 then
        addPlayerToList(ply)
      end
    end
  end
end
