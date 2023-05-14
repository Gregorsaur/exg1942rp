local PLUGIN = PLUGIN or {}

hook.Add("PlayerEndVoice", "radioCheckPlayerEndVoice", function()
  netstream.Start("radioPlayerStoppedVoice")

  local char = LocalPlayer():getChar()
  
  if not char then return end

  for k,v in pairs(char:getInv():getItems()) do
    if v.uniqueID == "vradio" then
      if v:getData("enabled", false) == true then
        surface.PlaySound(PLUGIN.bleep)
        return
      end
    end
  end
end)

netstream.Hook("radioEndBleep", function()
  surface.PlaySound(PLUGIN.bleep)
end)