PLUGIN.name = "Bodygroup Closet"
PLUGIN.author = "Barata"
PLUGIN.desc = "Adds a bodygroup closet entity, inspired by BodygroupR."

nut.config.add("closet_health", 100, "Set the health of the bodygroup closet.", nil, {
    category = "Bodygroup Closet",
    data = {
        min = 1,
        max = 1000
    }
})

nut.config.add("closet_name", "Bodygroup Closet", "Set the name of the bodygroup closet.", nil, {
    category = "Bodygroup Closet"
})

nut.config.add("closet_close_sound", "items/ammocrate_close.wav", "Set the closing sound of the bodygroup closet.", nil, {
    category = "Bodygroup Closet"
})

nut.config.add("closet_open_sound", "items/ammocrate_open.wav", "Set the closing sound of the bodygroup closet.", nil, {
    category = "Bodygroup Closet"
})

nut.config.add("closet_breaking_enabled", false, "Set if bodygroup closets can break.", nil, {
    category = "Bodygroup Closet"
})

nut.util.include("sv_hooks.lua")

if CLIENT then
    netstream.Hook("nut_bodygroupclosetopenmenu", function()
        vgui.Create("nut_bodygroupcloset")
    end)
end