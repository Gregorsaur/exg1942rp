PLUGIN.name = "Limb severing"
PLUGIN.author = "DoopieWop"
PLUGIN.desc = "Adds commands for severing limbs off players."

local parts = {
	["head"] = "ValveBiped.Bip01_Head1",
	["left_arm"] = {"ValveBiped.Bip01_L_Forearm", "ValveBiped.Bip01_L_Elbow", "ValveBiped.Bip01_L_Pectoral", "ValveBiped.Bip01_L_Bicep", "ValveBiped.Bip01_L_Hand", "ValveBiped.Bip01_L_Wrist", "ValveBiped.Bip01_L_Finger0", "ValveBiped.Bip01_L_Finger01", "ValveBiped.Bip01_L_Finger02", "ValveBiped.Bip01_L_Finger1", "ValveBiped.Bip01_L_Finger11", "ValveBiped.Bip01_L_Finger12", "ValveBiped.Bip01_L_Finger2", "ValveBiped.Bip01_L_Finger21", "ValveBiped.Bip01_L_Finger22", "ValveBiped.Bip01_L_Finger3", "ValveBiped.Bip01_L_Finger31", "ValveBiped.Bip01_L_Finger32", "ValveBiped.Bip01_L_Finger4", "ValveBiped.Bip01_L_Finger41", "ValveBiped.Bip01_L_Finger42", "ValveBiped.Bip01_L_Ulna", "ValveBiped.Anim_attachment_RH"},
	["right_arm"] = {"ValveBiped.Bip01_R_Forearm", "ValveBiped.Bip01_R_Elbow", "ValveBiped.Bip01_R_Pectoral", "ValveBiped.Bip01_R_Bicep", "ValveBiped.Bip01_R_Hand", "ValveBiped.Bip01_R_Wrist", "ValveBiped.Bip01_R_Finger0", "ValveBiped.Bip01_R_Finger01", "ValveBiped.Bip01_R_Finger02", "ValveBiped.Bip01_R_Finger1", "ValveBiped.Bip01_R_Finger11", "ValveBiped.Bip01_R_Finger12", "ValveBiped.Bip01_R_Finger2", "ValveBiped.Bip01_R_Finger21", "ValveBiped.Bip01_R_Finger22", "ValveBiped.Bip01_R_Finger3", "ValveBiped.Bip01_R_Finger31", "ValveBiped.Bip01_R_Finger32", "ValveBiped.Bip01_R_Finger4", "ValveBiped.Bip01_R_Finger41", "ValveBiped.Bip01_R_Finger42","ValveBiped.Bip01_R_Ulna", "ValveBiped.Anim_attachment_RH"},
	["left_leg"] = {"ValveBiped.Bip01_L_Calf", "ValveBiped.Bip01_L_Foot", "ValveBiped.Bip01_L_Toe0"},
	["right_leg"] = {"ValveBiped.Bip01_R_Calf", "ValveBiped.Bip01_R_Foot", "ValveBiped.Bip01_R_Toe0"}
}

function PLUGIN:InitializedPlugins()
	for k, v in pairs(parts) do
		nut.command.add("sever" .. string.Replace(k, "_", ""), {
			isAdmin = true,
			syntax = "<string target>",
			onRun = function(client, arguments)
				local target = nut.command.findPlayer(client, arguments[1])

				if istable(v) then
					for k2, v2 in pairs(v) do
						local thing = DoBoneStuff(client, target, v2, k, false)
						if k2 == #v then
							if thing == "sever" then
								target:notify(string.format("%s has severed your %s.", client:Name(), string.Replace(k, "_", " ")))
							else
								target:notify(string.format("%s has re-attached your %s.", client:Name(), string.Replace(k, "_", " ")))
							end
						end
					end
				else
					DoBoneStuff(client, target, v, k)
				end
				target:EmitSound(string.format("physics/body/body_medium_break%d.wav", math.random(2, 4)))
			end
		})
	end
end

function DoBoneStuff(client, target, bone, name, shouldnotify)
	if target:LookupBone(bone) != nil then
		if target:GetManipulateBoneScale(target:LookupBone(bone)) == Vector(1, 1, 1) then
			target:ManipulateBoneScale(target:LookupBone(bone), vector_origin)
			if shouldnotify != false then
				target:notify(string.format("%s has severed your %s.", client:Name(), string.Replace(name, "_", " ")))
			end
			return "sever"
		else
			target:ManipulateBoneScale(target:LookupBone(bone), Vector(1, 1, 1))
			if shouldnotify != false then
				target:notify(string.format("%s has re-attached your %s.", client:Name(), string.Replace(name, "_", " ")))
			end
			return "reattach"
		end
	end
end