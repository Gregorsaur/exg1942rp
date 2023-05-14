----------------------------------------------------------------------------------------------
nut.command.add("requestsearch", {
    onRun = function(client, arguments)
        if (client.LastSearchRequest or 0) > CurTime() - 30 then return "You can't send search requests this quickly!" end
        local data = {}
        data.start = client:GetShootPos()
        data.endpos = data.start + client:GetAimVector() * 96
        data.filter = client
        local target = util.TraceLine(data).Entity

        if client.delay and CurTime() < client.delay then
            client:notify("You need to wait a few seconds before using that command again!")

            return
        end

        if not target:IsPlayer() then
            client:notify("Invalid Target!!")

            return
        end

        local MAXDISTANCE_TARGET = 100 * 100 -- SQUARED FOR PERFORMANCE The distance the dragged player will try to achieve
        local TargetPos = target:GetPos()
        local myPos = client:GetPos()
        local dist2Sqr = (TargetPos.x - myPos.x) ^ 2 + (TargetPos.y - myPos.y) ^ 2

        if not target:IsPlayer() then
            client:notify("Invalid Target!!")
        elseif dist2Sqr > MAXDISTANCE_TARGET then
            client:notify("You can't use this from this distance!")

            return
        elseif not target:getNetVar("restricted") and not target.SearchRequested and not client.SearchRequested then
            net.Start("nutRequestSearch")
            net.Send(target)
            client:notify("Request to search sent.")
            target.SearchRequested = client
            client.SearchRequested = target
            client.LastSearchRequest = CurTime()
        end

        client.delay = CurTime() + 5
    end
})

----------------------------------------------------------------------------------------------
nut.command.add("tieplayer", {
    onRun = function(client, arguments)
        local data = {}
        data.start = client:GetShootPos()
        data.endpos = data.start + client:GetAimVector() * 96
        data.filter = client
        local target = util.TraceLine(data).Entity

        if not target:IsPlayer() then
            client:notify("Invalid Target!!")

            return
        end

        local MAXDISTANCE_TARGET = 100 * 100 -- SQUARED FOR PERFORMANCE The distance the dragged player will try to achieve
        local TargetPos = target:GetPos()
        local myPos = client:GetPos()
        local dist2Sqr = (TargetPos.x - myPos.x) ^ 2 + (TargetPos.y - myPos.y) ^ 2

        if dist2Sqr > MAXDISTANCE_TARGET then
            client:notify("You can't use this from this distance!")
        end

        if client:getChar():getInv():hasItem("tie") then
            local item = client:getChar():getInv():getFirstItemOfType("tie")
            item:interact("Use", client)
        elseif client:getChar():getInv():hasItem("zipties") then
            local item = client:getChar():getInv():getFirstItemOfType("zipties")
            item:interact("Use", client)
        else
            client:notify("You don't have a Tie!")
        end
    end
})

----------------------------------------------------------------------------------------------
nut.command.add("cmenugivemoney", {
    onRun = function(client, arguments)
        local data = {}
        data.start = client:GetShootPos()
        data.endpos = data.start + client:GetAimVector() * 96
        data.filter = client
        local target = util.TraceLine(data).Entity

        if not target:IsPlayer() then
            client:notify("Invalid Target!!")

            return
        end

        local MAXDISTANCE_TARGET = 100 * 100 -- SQUARED FOR PERFORMANCE The distance the dragged player will try to achieve
        local TargetPos = target:GetPos()
        local myPos = client:GetPos()
        local dist2Sqr = (TargetPos.x - myPos.x) ^ 2 + (TargetPos.y - myPos.y) ^ 2

        if dist2Sqr > MAXDISTANCE_TARGET then
            client:notify("You can't use this from this distance!")
        end

        net.Start("moneyprompt")
        net.Send(client)
    end
})

----------------------------------------------------------------------------------------------
nut.command.add("cmenumedkit", {
    onRun = function(client, arguments)
        local data = {}
        data.start = client:GetShootPos()
        data.endpos = data.start + client:GetAimVector() * 96
        data.filter = client
        local target = util.TraceLine(data).Entity

        if not target:IsPlayer() then
            client:notify("Invalid Target!!")

            return
        end

        local MAXDISTANCE_TARGET = 100 * 100 -- SQUARED FOR PERFORMANCE The distance the dragged player will try to achieve
        local TargetPos = target:GetPos()
        local myPos = client:GetPos()
        local dist2Sqr = (TargetPos.x - myPos.x) ^ 2 + (TargetPos.y - myPos.y) ^ 2

        if dist2Sqr > MAXDISTANCE_TARGET then
            client:notify("You can't use this from this distance!")
        end

        if client:getChar():getInv():hasItem("medkit") then
            local item = client:getChar():getInv():getFirstItemOfType("medkit")
            item:interact("target", client)
        else
            client:notify("You don't have Medkit!")
        end
    end
})

----------------------------------------------------------------------------------------------
nut.command.add("cmenubandage", {
    onRun = function(client, arguments)
        local data = {}
        data.start = client:GetShootPos()
        data.endpos = data.start + client:GetAimVector() * 96
        data.filter = client
        local target = util.TraceLine(data).Entity

        if not target:IsPlayer() then
            client:notify("Invalid Target!!")

            return
        end

        local MAXDISTANCE_TARGET = 100 * 100 -- SQUARED FOR PERFORMANCE The distance the dragged player will try to achieve
        local TargetPos = target:GetPos()
        local myPos = client:GetPos()
        local dist2Sqr = (TargetPos.x - myPos.x) ^ 2 + (TargetPos.y - myPos.y) ^ 2

        if dist2Sqr > MAXDISTANCE_TARGET then
            client:notify("You can't use this from this distance!")
        end

        if client:getChar():getInv():hasItem("bandages") then
            local item = client:getChar():getInv():getFirstItemOfType("bandages")
            item:interact("target", client)
        else
            client:notify("You don't have Bandages!")
        end
    end
})