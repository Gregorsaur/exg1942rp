local PLUGIN = PLUGIN or {}
PLUGIN.name = "f2fvc"
PLUGIN.author = "Robert Bearson"
PLUGIN.desc = "Faction 2 Faction Voice Chat"

nut.util.include("sv_hooks.lua")
nut.util.include("cl_popups.lua")
nut.util.include("cl_sounds.lua")

--Including sound files
resource.AddFile("sound/artemis/radio_bleep.mp3")
resource.AddFile("sound/artemis/radio_static.mp3")
PLUGIN.bleep = "artemis/radio_bleep.mp3"
PLUGIN.static = "artemis/radio_static.mp3"

--Overrides the tooltip to let the player know what the radio's frequency is at
hook.Add("OverrideItemTooltip", "CustomRadioDesc", function(inv, data, item)
    if item.uniqueID == "vradio" then
        --Getting and reformatting frequency
        local freq = item:getData("freq", nil)
        if not freq then return end
        freq = math.Round(freq,1)

        --Getting if radio is enabled
        local enabled = item:getData("enabled", false) and "Enabled" or "Disabled"

        return Format(nut.config.itemFormat, item.getName and item:getName() or L(item.name), "Frequency: " .. (freq or "") .. "\n" .. enabled)
    end
end)