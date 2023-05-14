ITEM.name = "Check"
ITEM.model = "models/props_junk/garbage_carboard002a.mdl"
ITEM.flags = "Y"
ITEM.uniqueID = "check"

if CLIENT then
  local function openCheckWrite(item)
    local pop = vgui.Create("DFrame")
    pop:SetSize(500,200)
    pop:Center()
    pop:MakePopup()
    pop:SetTitle("Enter Details")

    local wp = pop:Add('DPanel')
    wp:SetSize(pop:GetWide(), pop:GetTall()-25)
    wp:SetPos(0,25)
    wp.hint = wp:Add("DLabel") --Hint to help out players
    wp.hint:SetText(BANKCONF.hint)
    -- wp.hint:SetFont("WB_Small")
    wp.hint:SetColor(Color(200,200,200))
    wp.hint:SizeToContents()
    wp.hint:CenterHorizontal()
    wp.hint:CenterVertical(0.10)

    local form = wp:Add("nutForm")
    form:SetSize(wp:GetWide()-10, wp:GetTall()*0.65)
    form:CenterHorizontal()
    local tname = form:AddTextEntry("Player Name")
    local tamount = form:AddTextEntry("Amount")
    tamount:SetNumeric(true)

    function tname:OnEnter()
      self:RequestFocus()
      local val = self:GetText():lower()
      for k,v in pairs(player.GetAll()) do
        local pn = v:Nick():lower() --Player Name
        if pn:find(val) or val == tname then
          self:SetText(v:Nick())
          self.player = v --Ez access to the desired player
          tamount:RequestFocus()
        end
      end
    end

    local done = wp:Add("DButton")
    done:SetText("Write Check")
    -- done:SetFont("WB_Small")
    done:SetColor(color_white)
    done:SetSize(wp:GetWide(), 35)
    done:SetPos(0, wp:GetTall()-done:GetTall())
    function done:Paint(w,h)
      draw.RoundedBoxEx(4, 0, 0, w, h, ColorAlpha(nut.config.get('color'), 155), false,false,true,true)
    end
    function done:DoClick()
      local name, amount = tname:GetText(),tamount:GetText()
      if not name or name == "" or not amount or amount == "" then
        return
      end
      if not tname.player then return end

      if LocalPlayer():BankBal() < tonumber(amount) then
        self:Flash("You don't have enough funds", BC_CRITICAL, 1, true)
        return
      end
      -- if not LocalPlayer():getChar():hasMoney(tonumber(amount)) then
      --   self:Flash("You don't have enough funds", BC_CRITICAL, 1, true)
      --   return
      -- end

      --Sending info to server for completion
      local target, amount = tname.player,tamount:GetText()
      netstream.Start("PlayerWritesCheck", item, target, amount)

      pop:Close()
    end
  end
  netstream.Hook("WriteCheckMenu", openCheckWrite)
end

ITEM.functions.write = {
  name = "Write",
  icon = "icon16/pencil.png",
  onRun = function(item)
    local ply = item.player
    netstream.Start(ply,"WriteCheckMenu", item)

    return false
  end,
  onCanRun = function(item)
    if item:getData("amount", nil) then
      return false
    end
  end
}

hook.Add("OverrideItemTooltip", "OverrideCheckTooltip", function(panel, data, item)
  if item.uniqueID == "check" and item:getData("target", nil) and item:getData("amount", nil) then
    local targetName,amount = item:getData("targetName"), item:getData("amount")
    local ntt = "<font=nutGenericFont>Official Check</font>\n<font=nutSmallFont>Written For: " .. targetName .. "\nAmount: " .. amount .. nut.currency.symbol .. "</font>"
    return ntt
  end
end)
