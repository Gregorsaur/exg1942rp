nut.command.add("CharPK", {
    syntax = "[character name]",
    onRun = function(client, arguments)
        local target = nut.command.findPlayer(client, arguments[1])
        local uniqueID = client:GetUserGroup()

        if not UserGroups.modRanks[uniqueID] then
            client:notify("Your rank is not high enough to use this command.")

            return false
        end

        if IsValid(target) and target:getChar() then
            local targetchar = target:getChar()

            if not targetchar:getData("permakilled") then
                client:notify("Perma killed " .. target:Name())

                timer.Simple(1.5, function()
                    targetchar:ban()
                    target:Kill()
                    target:Spawn()
                end)
            end
        end
    end
})

nut.command.add("staff", {
    onRun = function(client, arguments)
        for _, ply in ipairs(player.GetAll()) do
            if UserGroups.StaffRanks[ply:GetUserGroup()] then
                staffCount = staffCount + 1

                if staffCount > 0 then
                    client:ChatPrint("Staff Name: " .. ply:Name())
                else
                    client:ChatPrint("No Staff On!")
                end
            end
        end
    end
})

nut.command.add("flagpet", {
    syntax = "[character name]",
    onRun = function(client, arguments)
        local target = nut.command.findPlayer(client, arguments[1])
        local uniqueID = client:GetUserGroup()

        if not UserGroups.modRanks[uniqueID] then
            client:notify("Your rank is not high enough to use this command.")

            return false
        end

        if target:getChar():hasFlags("pet") then
            target:getChar():takeFlags("pet")
            client:notify("Taken pet Flags!")
        else
            target:getChar():giveFlags("pet")
            client:notify("Given pet Flags!")
        end
    end
})

nut.command.add("charkick", {
    syntax = "<string name>",
    onRun = function(client, arguments)
        local target = nut.command.findPlayer(client, arguments[1])
        local uniqueID = client:GetUserGroup()

        if not UserGroups.modRanks[uniqueID] then
            client:notify("Your rank is not high enough to use this command.")

            return false
        end

        if IsValid(target) then
            local char = target:getChar()

            if char then
                for k, v in ipairs(player.GetAll()) do
                    v:notifyLocalized("charKick", client:Name(), target:Name())
                end

                char:kick()
            end
        end
    end
})