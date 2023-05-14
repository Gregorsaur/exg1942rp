PLUGIN.name = "PK Command"
PLUGIN.author = "Calloway & Bok"
PLUGIN.desc = "Adds a command to PK certain people after they die."
local characterMeta = nut.meta.character

nut.command.add("pkenable", {
    adminOnly = true,
    syntax = "<string name>",
    onRun = function(client, arguments)
        local target = nut.command.findPlayer(client, arguments[1])

        if (IsValid(target) and target:getChar()) then
            target:getChar():enablePK(target:getChar())
            client:notify("Setting " .. (target:getChar():getName()) .. "\'s PK status to " .. tostring(target:getChar():getData("pkCom")))
        end
    end
})

-- Prevents death glitch
hook.Add("PlayerLoadedChar", "pkvarset", function(client, character)
    character:setData("pkCom", false, false, player.GetAll())
end)

if SERVER then
    function characterMeta:enablePK(char)
        if (char:getData("pkCom")) then
            char:setData("pkCom", false, false, player.GetAll())
        else
            char:setData("pkCom", true, false, player.GetAll())
        end
    end

    hook.Add("PlayerDeath", "pkCommand", function(victim, inflictor, attacker)
        local char = victim:getChar()

        if (victim:getChar() and victim:getChar():getData("pkCom")) then
            --if nut.config.get("deathTimer") then
            char:ban()
            victim:notify("You have been Permakilled. If you wish to appeal this PK, you may go to the discord.")
        end
    end)
end