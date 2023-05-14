PLUGIN.name = "PK Command"
PLUGIN.author = "Calloway & Bok"
PLUGIN.desc = "Adds a command to PK certain people after they die."

nut.util.include("sv_permakill.lua")

local burstTrustedRanks = {
	["root"] = true,
	["communitymanager"] = true,
	["superadmin"] = true,
	["senioradmin"] = true,
	["admin"] = true,
	["moderator"] = true
}

nut.command.add("pkenable", {
	syntax = "<string name>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])

		local uniqueID = client:GetUserGroup()
		if(!burstTrustedRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end

		if (IsValid(target) && target:getChar()) then
			target:getChar():enablePK(target:getChar())
			client:notify("Setting "..(target:getChar():getName()).."\'s PK status to "..tostring(target:getChar():getData("pkCom")))
		end
	end
})