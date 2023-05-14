ITEM.name = "Radio"
ITEM.desc = "Radio to use to talk to other people"
ITEM.flag = "Y"
ITEM.model = "models/gibs/shield_scanner_gib1.mdl"

ITEM.functions.bindKey = {
    name = "Bind Turn On/Off Key",
    icon = "icon16/keyboard.png",
    onRun = function(item)
        netstream.Start(item.player, "radioChangeKeybind", item.id)
        return false
    end
}

--Enable/Disable
ITEM.functions.enable = {
    name = "Turn On",
    icon = "icon16/connect.png",
    onRun = function(item)
        item:setData("enabled", true)
        return false
    end,
    onCanRun = function(item)
        if not item.entity and not item:getData("enabled") then
            return true
        else
            return false
        end
    end
}

ITEM.functions.disable = {
    name = "Turn Off",
    icon = "icon16/disconnect.png",
    onRun = function(item)
        item:setData("enabled", false)
        return false
    end,
    onCanRun = function(item)
        if not item.entity and item:getData("enabled") then
            return true
        else
            return false
        end
    end
}

--Change Freq
ITEM.functions.changeFreq = {
    name = "Change Frequency",
    icon = "icon16/transmit_blue.png",
    onRun = function(item)
        netstream.Start(item.player, "radioChangeFreq", item.id)
        return false
    end,
    onCanRun = function(item)
        if item.entity then return false end
    end
}