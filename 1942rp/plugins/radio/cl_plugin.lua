local PLUGIN = PLUGIN
local NUT_RADIO_VC_KEY = CreateClientConVar("nutRadioToggleVCKey", "KP_0", true)
local NUT_RADIO_VC_MODE = CreateClientConVar("nutRadioToggleVCMode", 0, true)
local keytoenum = {
    ["0"] = KEY_0,
    ["1"] = KEY_1,
    ["2"] = KEY_2,
    ["3"] = KEY_3,
    ["4"] = KEY_4,
    ["5"] = KEY_5,
    ["6"] = KEY_6,
    ["7"] = KEY_7,
    ["8"] = KEY_8,
    ["9"] = KEY_9,
    ["KP_0"] = KEY_PAD_0,
    ["KP_1"] = KEY_PAD_1,
    ["KP_2"] = KEY_PAD_2,
    ["KP_3"] = KEY_PAD_3,
    ["KP_4"] = KEY_PAD_4,
    ["KP_5"] = KEY_PAD_5,
    ["KP_6"] = KEY_PAD_6,
    ["KP_7"] = KEY_PAD_7,
    ["KP_8"] = KEY_PAD_8,
    ["KP_9"] = KEY_PAD_9,
    ["KP_DIVIDE"] = KEY_PAD_DIVIDE,
    ["KP_MULTIPLY"] = KEY_PAD_MULTIPLY,
    ["KP_MINUS"] = KEY_PAD_MINUS,
    ["KP_PLUS"] = KEY_PAD_PLUS,
    ["KP_ENTER"] = KEY_PAD_ENTER,
    ["KP_DECIMAL"] = KEY_PAD_DECIMAL,
    ["A"] = KEY_A,
    ["B"] = KEY_B,
    ["C"] = KEY_C,
    ["D"] = KEY_D,
    ["E"] = KEY_E,
    ["F"] = KEY_F,
    ["G"] = KEY_G,
    ["H"] = KEY_H,
    ["I"] = KEY_I,
    ["J"] = KEY_J,
    ["K"] = KEY_K,
    ["L"] = KEY_L,
    ["M"] = KEY_M,
    ["N"] = KEY_N,
    ["O"] = KEY_O,
    ["P"] = KEY_P,
    ["Q"] = KEY_Q,
    ["R"] = KEY_R,
    ["S"] = KEY_S,
    ["T"] = KEY_T,
    ["U"] = KEY_U,
    ["V"] = KEY_V,
    ["W"] = KEY_W,
    ["X"] = KEY_X,
    ["Y"] = KEY_Y,
    ["Z"] = KEY_Z,
    ["NUMLOCK"] = KEY_NUMLOCK,
    ["CAPSLOCK"] = KEY_CAPSLOCK,
    ["SCROLLLOCK"] = KEY_SCROLLLOCK,
    ["INSERT"] = KEY_INSERT,
    ["HOME"] = KEY_HOME,
    ["DELETE"] = KEY_DELETE,
    ["END"] = KEY_END,
    ["PAGEUP"] = KEY_PAGEUP,
    ["PAGEDOWN"] = KEY_PAGEDOWN,
    ["BREAK"] = KEY_BREAK,
    ["LWIN"] = KEY_LWIN,
    ["RWIN"] = KEY_RWIN,
    ["BACKSPACE"] = KEY_BACKSPACE,
    ["TAB"] = KEY_TAB,
    ["SHIFT"] = KEY_LSHIFT,
    ["CONTROL"] = KEY_LCONTROL,
    ["ALT"] = KEY_LALT,
    ["SPACE"] = KEY_SPACE,
    ["UP"] = KEY_UP,
    ["LEFT"] = KEY_LEFT,
    ["RIGHT"] = KEY_RIGHT,
    ["DOWN"] = KEY_DOWN,
    ["F1"] = KEY_F1,
    ["F2"] = KEY_F2,
    ["F3"] = KEY_F3,
    ["F4"] = KEY_F4,
    ["F5"] = KEY_F5,
    ["F6"] = KEY_F6,
    ["F7"] = KEY_F7,
    ["F8"] = KEY_F8,
    ["F9"] = KEY_F9,
    ["F10"] = KEY_F10,
    ["F11"] = KEY_F11,
    ["F12"] = KEY_F12
}

net.Receive("nutRadioFreq", function()
    Derma_StringRequest("Frequency", "Choose a frequency.", net.ReadString(), function(text)
		nut.command.send("setfrequency", text)
	end)
end)

concommand.Add("nutRadioToggleVC", function()
    net.Start("nutRadioVCToggle")
        net.WriteBool(not LocalPlayer():getLocalVar("nutRadioVC", false))
    net.SendToServer()
end)

concommand.Add("nutRadioListKeys", function()
    print("\n---- Possible keys ----\n")
    for k, v in SortedPairsByValue(keytoenum) do
        print(k)
    end
    print("\n------------------\n")
end)

concommand.Add("nutRadioToggleKey", function(ply, cmd, args)
    local key = args[1]

    if not key then
        print("You must specify a key!")
        return
    end
    
    if not keytoenum[key] then
        print("Invalid key!")
        return
    end

    print("Radio voice chat key set to " .. key)
    NUT_RADIO_VC_KEY:SetString(key)
end)

concommand.Add("nutRadioToggleMode", function(ply, cmd, args)
    local mode = args[1]

    if not mode then
        print("You must specify a mode!")
        return
    end
    
    if not mode:lower() == "toggle" or not mode:lower() == "hold" then
        print("Invalid mode!")
        return
    end

    print("Radio voice chat mode set to "..mode:lower().."!")
    NUT_RADIO_VC_MODE:SetInt(mode:lower() == "hold" and 0 or 1)
end)

function PLUGIN:PlayerButtonDown(ply, key)
    local mode = NUT_RADIO_VC_MODE:GetInt()
    if key == keytoenum[NUT_RADIO_VC_KEY:GetString()] then
        net.Start("nutRadioVCToggle")
            net.WriteBool(not LocalPlayer():getLocalVar("nutRadioVC", false))
        net.SendToServer()
    end
end

function PLUGIN:PlayerButtonUp(ply, key)
    local mode = NUT_RADIO_VC_MODE:GetInt()
    if mode == 0 and key == keytoenum[NUT_RADIO_VC_KEY:GetString()] then
        net.Start("nutRadioVCToggle")
            net.WriteBool(false)
        net.SendToServer()
    end
end

function PLUGIN:HUDPaint()
    local radio = PLUGIN:GetRadio(LocalPlayer(), false, true)

    if not radio or not radio:getData("active", false) then return end

    local w, h = ScrW(), ScrH()
    -- draw a text on right side of screen "Radio: on or off"
    local val = LocalPlayer():getLocalVar("nutRadioVC", false)
    local text = "Radio: " .. (val and "On" or "Off")
    local col = val and Color(0, 255, 0) or Color(255, 0, 0)

    draw.SimpleText("Transmit Voice: " .. (val and "On" or "Off"), "nutGenericFont", 10, h / 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end