PLUGIN.name = "ID System"
PLUGIN.desc = "Adds an important document with all the information about the player."
PLUGIN.author = "Barata"
nut.util.include("sv_plugin.lua")

function PLUGIN:ConfigureCharacterCreationSteps(panel)
    panel:addStep(vgui.Create("nutCharacterDocuments"), 99)
end