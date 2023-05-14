local PLUGIN = PLUGIN

PLUGIN.name = "Chatbox Character Limit"
PLUGIN.author = "DoopieWop"
PLUGIN.desc = "Limits the amount of characters players can send in one message."

nut.config.add("maxchatcharacters", 256, "The amount of characters a player can send in one message.", nil, {
	data = {min = 1, max = 1024},
	category = "Chat"
})

if SERVER then
    netstream.Hook("msg", function(client, text)
        local charlimit = nut.config.get("maxchatcharacters", 256)
        
        if utf8.len(text) > charlimit then
            text = utf8.sub(text, 1, 256)
            client:notify(string.format("Your message has been shortened due to being longer than %s characters!", charlimit))
        end
    
		if ((client.nutNextChat or 0) < CurTime() and text:find("%S")) then
			hook.Run("PlayerSay", client, text)
			client.nutNextChat = CurTime() + math.max(#text / 250, 0.4)
		end
	end)
end