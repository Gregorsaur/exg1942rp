local PLUGIN = PLUGIN

net.Receive("nutRadioVCToggle", function(l, ply)
    if (ply.LastnutRadioVCToggle or 0) > CurTime() then return end
    ply.LastnutRadioVCToggle = CurTime() + 0.05

    local desiredstate = net.ReadBool()

    local radio = PLUGIN:GetRadio(ply, false, true)

    if not radio or not radio:getData("active") then return end

    ply:setLocalVar("nutRadioVC", desiredstate)
end)

local function CanHear(listener, speaker)
    local radio = PLUGIN:GetRadio(listener, true)
    local radio2 = PLUGIN:GetRadio(speaker)

    if nut.config.get("allowVoice", false) then
        if (radio and radio2) and radio:getData("active", false) and speaker:getLocalVar("nutRadioVC") and radio:getData("freq", "000.0") == radio2:getData("freq", "000.0") then
            return true, false
        end
    end
end

hook.Add("PlayerCanHearPlayersVoice", "nutRadio", function(listener, speaker)
    return CanHear(listener, speaker)
end)

local function voiceboxCanHear(listener, speaker)
    local res = CanHear(listener, speaker)

    if res then
        VoiceBox.FX.IsRadioComm(listener:EntIndex(), speaker:EntIndex(), not VoiceBox.FX.__PlayerCanHearPlayersVoice(listener, speaker))
        return res
    end

    VoiceBox.FX.IsRadioComm(listener:EntIndex(), speaker:EntIndex(), false)
end

if VoiceBox and VoiceBox.FX then
    hook.Add("PlayerCanHearPlayersVoice", "nutRadio", voiceboxCanHear)
else
    hook.Add("VoiceBox.FX", "nutRadio", function()
        VoiceBox.FX.SetRadioStaticEnabled(true)
        hook.Add("PlayerCanHearPlayersVoice", "nutRadio", voiceboxCanHear)
    end)
end