
PLUGIN.name = "Deck of Cards"
PLUGIN.author = "Rework of Old Stuff by Rhoboingo"
PLUGIN.desc = "Randomized Cards."

nut.command.add("cards", {
	syntax = "<none>",
	onRun = function(client, arguments)
		local inventory = client:getChar():getInv()
		if (!inventory:hasItem("carddeck")) then
			client:notify("You do not have a deck of cards.")
			return
		end

		local family = {"An Ace", "A Two", "A Three", "A Four", "A Five", "A Six", "A Seven", "An Eight", "A Nine", "A Ten", "A Jack", "A Queen", "A King",}
		local fam2 = {"of Spades", "of Diamonds", "of Hearts", "of Clubs"}
		
		local msg = "draws " ..table.Random(family).. " of " ..table.Random(fam2)
		
		nut.chat.send(client, "cards", msg)
	end
})

nut.chat.register("cards", {
	format = "%s %s.",
	color = Color(155, 155, 255),
	filter = "actions",
	font = "nutChatFontItalics",
	onCanHear = nut.config.get("chatRange", 280),
	deadCanChat = true
})