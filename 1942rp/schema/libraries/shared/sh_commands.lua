-------------------------------------------------------------------------------------------------------------------------
nut.command.add("clearworlditems", {
    syntax = "",
    superAdminOnly = true,
    onRun = function(client, arguments)
        local count = 0

        for i, v in pairs(ents.FindByClass("nut_item")) do
            count = count + 1
            v:Remove()
        end

        client:ChatPrint("Cleared " .. count .. " world items!")
    end;
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("factionbroadcast", {
    syntax = "[Message]",
    onCheckAccess = function(client) return client:getChar():hasFlags("O") end,
    onRun = function(client, arguments)
        for k, factionmember in pairs(player.GetHumans()) do
            if factionmember:Team() == client then
                client:ChatPrint("[FACTION BROADCAST] " .. arguments[1])
            end
        end
    end;
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("cleannpcs", {
    adminOnly = true,
    onRun = function(client, arguments)
        local count = 0

        if (not arguments[1]) then
            for k, v in pairs(ents.GetAll()) do
                if IsValid(v) and (v:IsNPC() or v.chance) and not IsFriendEntityName(v:GetClass()) then
                    count = count + 1
                    v:Remove()
                end
            end
        else
            local trace = client:GetEyeTraceNoCursor()
            local hitpos = trace.HitPos + trace.HitNormal * 5

            for k, v in pairs(ents.FindInSphere(hitpos, arguments[1] or 100)) do
                if IsValid(v) and (v:IsNPC() or v.chance) and not IsFriendEntityName(v:GetClass()) then
                    count = count + 1
                    v:Remove()
                end
            end
        end

        client:notify(count .. " NPCs and Nextbots have been cleaned up from the map.")
    end
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("doorname", {
    adminOnly = true,
    onRun = function(client, arguments)
        local tr = util.TraceLine(util.GetPlayerTrace(client))

        if IsValid(tr.Entity) then
            print("I saw a " .. tr.Entity:GetName())
        end
    end
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("clearinv", {
    adminOnly = true,
    syntax = "<string name>",
    onRun = function(client, arguments)
        local target = nut.command.findPlayer(client, arguments[1])

        if (IsValid(target) and target:getChar()) then
            for k, v in pairs(target:getChar():getInv():getItems()) do
                v:remove()
            end

            client:notifyLocalized("resetInv", target:getChar():getName())
        end
    end
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("announce", {
    syntax = "<string msg>",
    adminOnly = true,
    onRun = function(ply, args, msg)
        if ply:IsSuperAdmin() then
            nut.util.notify("ANNOUNCEMENT: " .. args[1])
        else
            ply:ChatPrint("You need to be SuperAdmin")
        end
    end
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("setclass", {
    adminOnly = true,
    syntax = "<string target> <string class>",
    onRun = function(client, arguments)
        local target = nut.command.findPlayer(client, arguments[1])

        if (target and target:getChar()) then
            local character = target:getChar()
            local classFound

            if (nut.class.list[name]) then
                classFound = nut.class.list[name]
            end

            if (not classFound) then
                for k, v in ipairs(nut.class.list) do
                    if (nut.util.stringMatches(L(v.name, client), arguments[2])) then
                        classFound = v --This interrupt means we don't need an if statement below.
                        break
                    end
                end
            end

            if (classFound) then
                character:joinClass(classFound.index, true)
                target:notify("Your class was set to " .. classFound.name .. (client ~= target and "by " .. client:GetName() or "") .. ".")

                if (client ~= target) then
                    client:notify("You set " .. target:GetName() .. "'s class to " .. classFound.name .. ".")
                end
            else
                client:notify("Invalid class.")
            end
        end
    end,
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("chargetmoney", {
    adminOnly = true,
    syntax = "<string target>",
    onRun = function(client, arguments)
        local target = nut.command.findPlayer(client, arguments[1])
        local character = target:getChar()
        client:notifyLocalized(character:getName() .. " has " .. character:getMoney() .. " bullets.")
    end
})

-------------------------------------------------------------------------------------------------------------------------
--[[nut.command.add("charaddmoney", {
    superAdminOnly = true,
    syntax = "<string target> <number amount>",
    onRun = function(client, arguments)
        local amount = tonumber(arguments[2])
        if (not amount or not isnumber(amount) or amount < 0) then return "@invalidArg", 2 end
        local target = nut.command.findPlayer(client, arguments[1])

        if (IsValid(target)) then
            local char = target:getChar()

            if (char and amount) then
                amount = math.Round(amount)
                char:giveMoney(amount)
                client:notify("You gave " .. nut.currency.get(amount) .. " to " .. target:Name())
            end
        end
    end
})]]
--
-------------------------------------------------------------------------------------------------------------------------
nut.command.add("getpos", {
    adminOnly = true,
    onRun = function(client, arguments)
        client:ChatPrint(tostring(client:GetPos()))
    end
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("findallflags", {
    adminOnly = true,
    onRun = function(client, arguments)
        for k, v in pairs(player.GetAll()) do
            if IsValid(v) then
                if (v:getChar():getFlags() == "") then continue end
                client:ChatPrint(v:Name() .. " — " .. v:getChar():getFlags())
            end
        end
    end
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("checkallmoney", {
    adminOnly = true,
    syntax = "<string charname>",
    onRun = function(client, arguments)
        for k, v in pairs(player.GetAll()) do
            if v:getChar() then
                client:ChatPrint(v:Name() .. " has " .. v:getChar():getMoney())
            end
        end
    end
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("bringlostitems", {
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments)
        for k, v in pairs(ents.FindInSphere(client:GetPos(), 500)) do
            if v:GetClass() == "nut_item" then
                v:SetPos(client:GetPos())
            end
        end
    end
})

-------------------------------------------------------------------------------------------------------------------------
if (SERVER) then
    util.AddNetworkString("OpenInvMenu")

    function ItemCanEnterForEveryone(inventory, action, context)
        if (action == "transfer") then return true end
    end

    function CanReplicateItemsForEveryone(inventory, action, context)
        if (action == "repl") then return true end
    end
else
    net.Receive("OpenInvMenu", function()
        local target = net.ReadEntity()
        local index = net.ReadType()
        local targetInv = nut.inventory.instances[index]
        local myInv = LocalPlayer():getChar():getInv()
        local inventoryDerma = targetInv:show()
        inventoryDerma:SetTitle(target:getChar():getName() .. "'s Inventory")
        inventoryDerma:MakePopup()
        inventoryDerma:ShowCloseButton(true)
        local myInventoryDerma = myInv:show()
        myInventoryDerma:MakePopup()
        myInventoryDerma:ShowCloseButton(true)
        myInventoryDerma:SetParent(inventoryDerma)
        myInventoryDerma:MoveLeftOf(inventoryDerma, 4)
    end)
end

--[[-------------------------------------------------------------------------

	Purpose: Check other players inventory's

	---------------------------------------------------------------------------]]
nut.command.add("checkinventory", {
    adminOnly = true,
    syntax = "<string target>",
    onRun = function(client, arguments)
        local target = nut.command.findPlayer(client, arguments[1])

        if (IsValid(target) and target:getChar() and target ~= client) then
            local inventory = target:getChar():getInv()
            inventory:addAccessRule(ItemCanEnterForEveryone, 1)
            inventory:addAccessRule(CanReplicateItemsForEveryone, 1)
            inventory:sync(client)
            net.Start("OpenInvMenu")
            net.WriteEntity(target)
            net.WriteType(inventory:getID())
            net.Send(client)
        elseif (target == client) then
            client:notifyLocalized("This isn't meant for checking your own inventory.")
        end
    end
})

---------------------------------------------------------------------------]]
nut.chat.register("advert", {
    onCanSay = function(speaker, text)
        if speaker:getChar():hasMoney(10) then
            speaker:getChar():takeMoney(10)
            speaker:notify("10 Reichsmarks have been deducted from your wallet for advertising.")

            return true
        else
            speaker:notify("You lack sufficient funds to make an advertisement.")

            return false
        end
    end,
    onChatAdd = function(speaker, text)
        chat.AddText(Color(255, 238, 0), " [Advertisement] ", " ", speaker, ": ", color_white, text)
    end,
    prefix = {"/advert"},
    noSpaceAfter = true,
    filter = "advertisements"
})

nut.command.add("store", {
    syntax = "<No Input>",
    onRun = function(client, arguments)
        client:SendLua([[gui.OpenURL("https://externalgaming.noclip.me/")]])
    end
})

nut.command.add("discord", {
    syntax = "<No Input>",
    onRun = function(client, arguments)
        client:SendLua([[gui.OpenURL("https://discord.gg/msAWXK33KH")]])
    end
})

nut.command.add("steam", {
    syntax = "<No Input>",
    onRun = function(client, arguments)
        client:SendLua([[gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1645008597")]])
    end
})

nut.command.add("content", {
    syntax = "<No Input>",
    onRun = function(client, arguments)
        client:SendLua([[gui.OpenURL("https://steamcommunity.com/groups/externalgamingeu")]])
    end
})