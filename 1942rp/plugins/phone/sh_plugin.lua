PLUGIN.name = "Realistic Phone"
PLUGIN.author = "AngryBaldMan"
PLUGIN.desc = "Adds realism to the bland pm system."

nut.util.include("cl_phone.lua", "client")
nut.util.include("sv_phone.lua", "server")

nut.chat.register("publicphone", {
	format = "[Public Phone] %s: %s.",
	color = Color(249, 211, 89),
	filter = "pm",
	deadCanChat = true
})

nut.command.add("publicphone", {
	syntax = "<string target> <string message>",
	onRun = function(client, arguments)
		local message = table.concat(arguments, " ", 2)
		local target = nut.command.findPlayer(client, arguments[1])
			
		local char = client:getChar()
			if char:hasMoney(2) then
				
			local ent1 = "phone_public"

			for k,v in pairs( ents.FindByClass( ent1 ) ) do

				if(client:GetPos():Distance(v:GetPos()) < 75) then
				
					nut.chat.send(client, "publicphone", message, false, {client, target})
					char:takeMoney(2)
					client:notify("1RM has been deducted from your account for calling.")
					
				--elseif not (client:GetPos():Distance(v:GetPos()) < 75) then
				else
				--client:notify("You must be near a public phone")
				end
			end
			
			else
			client:notify("You cannot afford this!")
		end
	end
})

nut.command.add("pm", {
	syntax = "<string target> <string message>",
	onRun = function(client, arguments)
		local message = table.concat(arguments, " ", 2)
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target)) then
			local voiceMail = target:getNutData("vm")

			if (voiceMail and voiceMail:find("%S")) then
				return target:Name()..": "..voiceMail
			end
			
			local char = client:getChar()

			if ((client.nutNextPM or 0) < CurTime()) then
				
			local ent1 = "phone_private*"

			for k,v in pairs( ents.FindByClass( ent1 ) ) do

				if(client:GetPos():Distance(v:GetPos()) < 75) then
				
					nut.chat.send(client, "pm", message, false, {client, target})
					client.nutNextPM = CurTime() + 0.5
					target.nutLastPM = client
				elseif not (client:GetPos():Distance(v:GetPos()) < 75) then
				--client:notify("You must be near a phone")
				end
				end
			end
		end
	end
})

concommand.Add("distance_test", function()

local ent1 = "public_phone"

for k,v in pairs( ents.FindByClass( ent1 ) ) do

if(LocalPlayer():GetPos():Distance(v:GetPos()) < 50) then
print("gay")
end
end

end)