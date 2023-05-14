ITEM.name = "Radio"
ITEM.model = "models/gibs/shield_scanner_gib1.mdl"
ITEM.desc = "A handheld radio, used to communicate with other people over long distances%s."
ITEM.category = "Communication"
ITEM.price = 80
ITEM.permit = "elec"

function ITEM:getDesc()
    if self:getData("freq") then
        return string.format(self.desc, " it's tuned to the frequency \""..self:getData("freq", "000.0").."\"")
    end
    return string.format(self.desc, "")
end

if CLIENT then
    function ITEM:paintOver(item, w, h)
        if item:getData("active") then
            surface.SetDrawColor(0, 255, 0, 255)
            surface.DrawRect(w - 10, h - 10, 8, 8)
        end
    end
end

function ITEM.postHooks.drop(item)
	item:setData("active", false)
end

ITEM.functions.Toggle = {
    name = "Toggle",
    tip = "Toggle the radio on and off",
    icon = "icon16/arrow_refresh.png",
    onRun = function(item)
        item:setData("active", !item:getData("active", false))
        return false
    end,
    onCanRun = function(item)
        return (!IsValid(item.entity))
    end
}

ITEM.functions.Freq = {
    name = "Frequency",
    tip = "Set the frequency of the radio",
    icon = "icon16/transmit.png",
    onRun = function(item)
        net.Start("nutRadioFreq")
            net.WriteString(item:getData("freq", "000.0"))
        net.Send(item.player)
        return false
    end,
    onCanRun = function(item)
        return (!IsValid(item.entity))
    end
}