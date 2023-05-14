ITEM.name = "Stationary Radio"
ITEM.model = "models/props_lab/citizenradio.mdl"
ITEM.desc = "A stationary radio, used to communicate with other people over long distances%s."
ITEM.category = "Communication"
ITEM.width = 2
ITEM.height = 2
ITEM.price = 250
ITEM.permit = "elec"

function ITEM:getDesc()
    if self:getData("freq") then
        return string.format(self.desc, " it's tuned to the frequency \""..self:getData("freq", "000.0").."\"")
    end
    return string.format(self.desc, "")
end

if CLIENT then
    local GLOW_MATERIAL = Material("sprites/glow04_noz.vmt")
	local COLOR_ACTIVE = Color(0, 255, 0)
	local COLOR_INACTIVE = Color(255, 0, 0)

	function ITEM:drawEntity(entity, item)
		entity:DrawModel()

		local position = entity:GetPos() + entity:GetForward() * 10 + entity:GetUp() * 11 + entity:GetRight() * 9.5

		render.SetMaterial(GLOW_MATERIAL)
		render.DrawSprite(position, 14, 14, entity:getData("active", false) and COLOR_ACTIVE or COLOR_INACTIVE)
	end
end

function ITEM.postHooks.take(item)
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
        return IsValid(item.entity)
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
        return IsValid(item.entity)
    end
}