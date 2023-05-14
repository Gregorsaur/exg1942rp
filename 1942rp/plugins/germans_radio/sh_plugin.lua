-- "gamemodes\\1942rp\\plugins\\germans_radio\\sh_plugin.lua"
-- Retrieved by https://github.com/c4fe/glua-steal
PLUGIN.name = "Germans Radio"
PLUGIN.author = "RobertLP"
PLUGIN.desc = "Let people use their portable radios & use of stationary radios too"

--Settings
RADIO = {}
RADIO.can_use_teams = {
FACTION_orpo,
FACTION_rhsa,
FACTION_waff,
FACTION_okw,
FACTION_propa,
FACTION_labour, 
FACTION_infa,
FACTION_maingov,
ACTION_affair,
FACTION_fina,
FACTION_nsdap,
FACTION_int,
FACTION_heer,
FACTION_alss

}
RADIO.can_view_teams = {
  FACTION_orpo,
FACTION_rhsa,
FACTION_waff,
FACTION_okw,
FACTION_propa,
FACTION_labour, 
FACTION_infa,
FACTION_maingov,
ACTION_affair,
FACTION_fina,
FACTION_nsdap,
FACTION_int,
FACTION_heer,
FACTION_alss

}
local chat_tag = "[RADIO]"
local format = " - %m" --Result: playername - the message
local tag_color = Color(214,36,36)
local message_color = Color(255,255,255)
local texts = {
  no_radio = "You do not have the required equipment.",
  no_arguments = "You must specify the message you want to transmit"
}

--Include
nut.util.include("cl_radio_typewriter.lua", "client")

--Radio Command
nut.command.add("radio", {
  syntax = "[message]",
  onRun = function(client, args)
    local inv = client:getChar():getInv()
    local radio = nut.item.list["radio"]

    if not inv:hasItem(radio.uniqueID) then
      client:notify(texts.no_radio)
      return
    end

    if #args <= 0 then
      client:notify(texts.no_arguments)
    else
      local msg = table.concat(args," ",1,#args)

      --NetMSG Everyone
      local pls = player.GetAll()
      for i=1, #pls do
        netstream.Start(pls[i], "radio_message", {
          msg = client:Nick() .. " - " .. msg,
          sent_by = client
        })
      end
    end
  end,
  onCanRun = function(ply, args)
    if not ply:Team() == can_use_team then
      return false
    end

    return true
  end
})

netstream.Hook("send_radio_msg", function(ply, data)
  local pls = player.GetAll()
  for i=1, #pls do
    netstream.Start(pls[i], "radio_message", {
      msg = data.msg,
      sent_by = data.sent_by
    })
  end
end)

if CLIENT then
  netstream.Hook("radio_message", function(data)
    for _,t in pairs(RADIO.can_view_teams) do
      local team = LocalPlayer():Team()
      local team_col = nut.faction.indices[team].color
      if team == t then
        chat.AddText(tag_color, chat_tag .. "  ", team_col, data.sent_by:Nick() .. " ", message_color, format:Replace("%m", data.msg))
      end
    end
  end)
end


