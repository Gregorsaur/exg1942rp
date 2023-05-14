local MODULE = GAS.Logging:MODULE() 

MODULE.Category = "Yet Another Warning System"
MODULE.Name = "Warnings"
MODULE.Colour = Color(77, 216, 179)

MODULE:Setup(function()
    -- Warned
    MODULE:Hook("yaws.warns.warned", "plywarned", function(steamid, admin, reason, points, id)
        MODULE:Log("{1} warned {2} for {3}, giving them {4} points.", GAS.Logging:FormatPlayer(admin), GAS.Logging:FormatPlayer(steamid), GAS.Logging:Highlight(reason), GAS.Logging:Highlight(points))
    end)
    -- Warning Deleted
    MODULE:Hook("yaws.warns.deleted", "plydeleted", function(admin, player, warningAdmin, reason, points)
        MODULE:Log("{1} deleted a warning to {2} by {3}, for the reason {4} with {5} points.", GAS.Logging:FormatPlayer(admin), GAS.Logging:FormatPlayer(player), GAS.Logging:FormatPlayer(warningAdmin), GAS.Logging:Highlight(reason), GAS.Logging:Highlight(points))
    end)
    -- Warningd Wiped  hook.Run("yaws.warns.wiped", ply, player.steamid)
    MODULE:Hook("yaws.warns.wiped", "plywiped", function(admin, steamid)
        MODULE:Log("{1} wiped all {2}'s warnings.", GAS.Logging:FormatPlayer(admin), GAS.Logging:FormatPlayer(steamid))
    end)
end)

GAS.Logging:AddModule(MODULE)