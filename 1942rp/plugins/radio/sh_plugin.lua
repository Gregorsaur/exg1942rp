local PLUGIN = PLUGIN

PLUGIN.name = "Radio"
PLUGIN.author = "DoopieWop"

-- radio item
-- stationary radio item
-- chat type radio
-- chat type eavesdrop ? maybe not
-- set freq
-- enable/disable radio

nut.config.add("radioRange", 96, "The range in which players can hear radios from by standing near someone using a radio.", nil, {
    data = {min = 64, max = 256},
    category = "Radio"
})

nut.config.add("radioColor", Color(100, 175, 100), "The color for radio messages.", nil, {
    category = "Radio"
})

nut.util.include("cl_plugin.lua")
nut.util.include("sv_plugin.lua")
nut.util.include("sv_net.lua")

function PLUGIN:GetRadio(ply, isnear, nostationary)
    local char = ply:getChar()
    
    if not char then return end

    local inv = char:getInv()
    local radio = inv:getFirstItemOfType("radio")
    if not nostationary then
        local ent = ply:GetEyeTraceNoCursor().Entity
        if ent:GetClass() == "nut_item" and (ent:getItemTable() and ent:getItemTable().uniqueID == "sradio") then
            radio = ent:getItemTable()
        end
    end
    if isnear then
        for k, v in pairs(ents.FindInSphere(ply:GetPos(), nut.config.get("radioRange", 96))) do
            if v:GetClass() == "nut_item" and (v:getItemTable() and v:getItemTable().uniqueID == "sradio") then
                radio = v:getItemTable()
            end
        end
    end
    return radio
end

nut.command.add("setfrequency", {
    syntax = "<string freq>",
	onRun = function(client, arguments)
        local freq = arguments[1]
        local radio = PLUGIN:GetRadio(client)

        if radio then
            if string.match(freq, "^%d%d%d%.%d$") then
                radio:setData("freq", freq)
                client:notify("You have set the radio frequency to " .. freq .. ".")
            else
                client:notify("Invalid frequency format. (Correct format: XXX.X)!")
            end
        else
            client:notify("You do not have a radio!")
        end
    end
})

nut.chat.register("radio", {
    onGetColor = function(speaker, text)
        if speaker != LocalPlayer() and speaker:GetPos():Distance(LocalPlayer():GetPos()) < nut.config.get("radioRange", 96) then
            return nut.config.get("chatColor")
        end
        return nut.config.get("radioColor", Color(100, 175, 100))
    end,
    onCanSay = function(speaker, text)
        local radio = PLUGIN:GetRadio(speaker)

        if not radio then
            speaker:notify("You do not have a radio!")
            return false
        end
        
        if not radio:getData("active") then
            speaker:notify("You must turn on the radio!")
            return false
        end

        if radio:getData("freq", "000.0") == "000.0" then
            speaker:notify("You must change you frequency!")
            return false
        end
    end,
    onCanHear = function(speaker, listener)
        local radio = PLUGIN:GetRadio(listener, true)
        local radio2 = PLUGIN:GetRadio(speaker)

        if listener:GetPos():Distance(speaker:GetPos()) < nut.config.get("radioRange", 96) then
            return true
        end

        for k, v in pairs(player.GetAll()) do
            if v:GetPos():Distance(listener:GetPos()) < nut.config.get("radioRange", 96) then
                local radio3 = PLUGIN:GetRadio(v, true)
                if radio3 and radio3:getData("freq") == radio2:getData("freq") then
                    return true
                end
            end
        end

        if (radio and radio2) and radio:getData("active", false) and radio:getData("freq", "000.0") == radio2:getData("freq", "000.0") then
            return true
        end
        return false
    end,
    format = "%s radios \"%s\"",
    prefix = {"/radio", "/r"},
    filter = "radio"
})