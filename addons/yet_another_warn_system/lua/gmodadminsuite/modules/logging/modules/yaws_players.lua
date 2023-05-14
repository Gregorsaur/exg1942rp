local MODULE = GAS.Logging:MODULE() 

MODULE.Category = "Yet Another Warning System"
MODULE.Name = "Players"
MODULE.Colour = Color(77, 216, 179)

MODULE:Setup(function()
    -- Admin Notes
    MODULE:Hook("yaws.adminnotes.updatenotes", "plynotes", function(admin, steamid)
        MODULE:Log("{1} updated the admin notes for {2}.", GAS.Logging:FormatPlayer(admin), GAS.Logging:FormatPlayer(steamid))
    end)
    -- Punishment hook.Run("yaws.punishments.executed", steamid, admin, punishment.type)
    MODULE:Hook("yaws.punishments.executed", "plypubishned", function(steamid, admin, punishment)
        MODULE:Log("{1} was punished using {2} from a warning submitted by {3}.", GAS.Logging:FormatPlayer(steamid), GAS.Logging:Highlight(punishment), GAS.Logging:FormatPlayer(admin))
    end)
end)

GAS.Logging:AddModule(MODULE)