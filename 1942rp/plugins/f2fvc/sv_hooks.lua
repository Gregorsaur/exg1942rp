--Check who has a radio, on what freq and if it's turned on
local function getRadio(ply)
  local char = ply:getChar()
  for k,v in pairs(char:getInv():getItems()) do
    if v.uniqueID == "vradio" then
      return v
    end
  end
end
local function checkForRadio(ply)
  local char = ply:getChar()
  if char then
    local radio = getRadio(ply)
    if not radio then return end
    return radio:getData("freq", nil), radio:getData("enabled", false)
  end

  return false
end

--Bleep -- Bleep
netstream.Hook("radioPlayerStoppedVoice", function(talker)
  if talker.radioBleepCooldown and talker.radioBleepCooldown > CurTime() then return end
  for _,listener in pairs(player.GetAll()) do
    if listener == talker then continue end
    local lfreq, le = checkForRadio(listener)
    local tfreq, te = checkForRadio(talker)

    if lfreq and tfreq then
      if lfreq == tfreq and le and te then
        talker.radioBleepCooldown = CurTime()+2
        netstream.Start(listener, "radioEndBleep")
      end
    end
  end
end)

--Hook to decide who hears who
hook.Add("PlayerCanHearPlayersVoice", "CheckVCRadio", function(listener, talker)
  local lfreq, le = checkForRadio(listener)
  local tfreq, te = checkForRadio(talker)

  if lfreq and tfreq then
    if lfreq == tfreq and le and te then
      return true
    end
  end
end)

--Setting a radio's frequency
netstream.Hook("setRadioFreq", function(ply, itemID, freq)
  local item = nut.item.instances[itemID]
  if item:getOwner() == ply then
    item:setData("freq", math.Round(freq, 1))
  end
end)

--Setting the radio's IO bind
netstream.Hook("playerSetRadioIOBind", function(ply, keyCode, keyName)
  ply:setNutData("radioIO", keyCode)
  ply:notify("New button '" .. keyName .. "' has been set to 'Radio Turn On/Off'!", NOT_CORRECT)
end)

--Toggling Radio IO
netstream.Hook("radioToggleIO", function(ply)
  local radio = getRadio(ply)
  if radio then
    local e = radio:getData("enabled", false)
    radio:setData("enabled", (not e))

    --Notifying
    if (not e) == true then
      ply:notify("Your radio was enabled")
    end

    if (not e) == false then
      ply:notify("Your radio was disabled")
    end
  end
end)