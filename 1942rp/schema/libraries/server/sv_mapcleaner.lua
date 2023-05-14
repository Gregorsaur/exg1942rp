local resetTime = (60 * 60) -- 1 Hour

function SCHEMA:InitializedPlugins()
    timer.Create("clearWorldItemsWarning", resetTime - (60 * 10), 0, function()
        for i, v in pairs(player.GetAll()) do
            v:ChatPrint("[ WARNING ]  World items will be cleared in 10 Minutes!")
            v:notify("World items will be cleared in 10 Minutes!")
        end
    end)

    timer.Create("clearWorldItemsWarningFinal", resetTime - 60, 0, function()
        for i, v in pairs(player.GetAll()) do
            v:ChatPrint("[ WARNING ]  World items will be cleared in 60 Seconds!")
            v:notify("World items will be cleared in 60 Seconds!")
        end
    end)

    timer.Create("clearWorldItems", resetTime, 0, function()
        for i, v in pairs(ents.FindByClass("nut_item")) do
            v:Remove()
        end
    end)

    timer.Create("clearniggus", 60 * 15, 0, function()
        RunConsoleCommand("sam cleardecals")
    end)
end