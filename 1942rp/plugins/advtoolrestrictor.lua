PLUGIN.name = "ADV Dupe Restriction"
PLUGIN.desc = ""
PLUGIN.author = ""

nut.flag.add("d", "Access to the adv dupe")

hook.Add( "CanTool", "advduperestrict", function(ply,  trace, tool)
  local char = ply:getChar()
  if tool == "advdupe2" and not char:getFlags():find("d") then
    return false
  end
end )
