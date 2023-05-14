if (SERVER) then 
	include("jetboom/boneanimlib.lua")
else
	include("jetboom/cl_boneanimlib.lua")
	--include("jetboom/cl_animeditor.lua")
end

RegisterLuaAnimation("surrender", util.JSONToTable([[{"Type":2.0,"FrameData":[{"FrameRate":5.0,"BoneInfo":{"ValveBiped.Bip01_R_UpperArm":{"RU":0.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":0.0,"RF":0.0},"ValveBiped.Bip01_R_Forearm":{"RU":0.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":0.0,"RF":0.0},"ValveBiped.Bip01_L_UpperArm":{"RU":0.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":0.0,"RF":0.0},"ValveBiped.Bip01_L_Forearm":{"RU":0.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":0.0,"RF":0.0}}},{"FrameRate":3.0,"BoneInfo":{"ValveBiped.Bip01_R_UpperArm":{"RU":1.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":87.1936,"RF":-7.2892},"ValveBiped.Bip01_L_Forearm":{"RU":-80.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_L_UpperArm":{"RU":1.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":-87.0,"RF":-90.0},"ValveBiped.Bip01_R_Forearm":{"RU":-90.0,"MU":0.0,"RR":100.0,"MR":0.0,"MF":0.0,"RF":-10.0}}},{"FrameRate":1.0,"BoneInfo":{"ValveBiped.Bip01_R_UpperArm":{"RU":1.0,"MU":0.0,"RR":87.1936,"MR":0.0,"MF":0.0,"RF":-7.2892},"ValveBiped.Bip01_R_Forearm":{"RU":-90.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":100.0,"RF":-10.0},"ValveBiped.Bip01_L_UpperArm":{"RU":1.0,"MU":0.0,"RR":-87.0,"MR":0.0,"MF":0.0,"RF":-90.0},"ValveBiped.Bip01_L_Forearm":{"RU":-80.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":0.0,"RF":0.0}}},{"FrameRate":2.0,"BoneInfo":{"ValveBiped.Bip01_R_UpperArm":{"RU":1.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":87.1936,"RF":-7.2892},"ValveBiped.Bip01_L_Forearm":{"RU":-80.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_L_UpperArm":{"RU":1.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":-87.0,"RF":-90.0},"ValveBiped.Bip01_R_Forearm":{"RU":-90.0,"MU":0.0,"RR":100.0,"MR":0.0,"MF":0.0,"RF":-10.0}}}],"RestartFrame":4.0}]]))

RegisterLuaAnimation("heil", util.JSONToTable(
[[
{"Type":0.0,"FrameData":[{"FrameRate":3.5,"BoneInfo":{"ValveBiped.Bip01_R_Calf":{"RU":120.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_Thigh":{"RU":-90.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_Forearm":{"RU":-80.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_UpperArm":{"RU":-70.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":20.0,"RF":-50.0},"ValveBiped.Bip01_L_Forearm":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0}}},{"FrameRate":5.0,"BoneInfo":{"ValveBiped.Bip01_R_Calf":{"RU":0.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":0.0,"RF":0.0},"ValveBiped.Bip01_R_Thigh":{"RU":0.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":0.0,"RF":0.0},"ValveBiped.Bip01_L_Forearm":{"RU":0.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":0.0,"RF":0.0},"ValveBiped.Bip01_R_UpperArm":{"RU":-130.0,"MU":0.0,"RR":30.0,"MR":0.0,"MF":0.0,"RF":-80.0},"ValveBiped.Bip01_R_Forearm":{"RU":0.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":0.0,"RF":0.0}}},{"FrameRate":1.0,"BoneInfo":{"ValveBiped.Bip01_R_Calf":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_Thigh":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_Forearm":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_UpperArm":{"RU":-130.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":30.0,"RF":-80.0},"ValveBiped.Bip01_L_Forearm":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0}}},{"FrameRate":2.0,"BoneInfo":{"ValveBiped.Bip01_R_Calf":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_Thigh":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_Forearm":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_UpperArm":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_L_Forearm":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0}}}]}
]]
))

RegisterLuaAnimation("heilfrozen", util.JSONToTable(
[[
{"Type":2.0,"FrameData":[{"FrameRate":3.5,"BoneInfo":{"ValveBiped.Bip01_R_Calf":{"RU":120.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_Thigh":{"RU":-90.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_Forearm":{"RU":-80.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_UpperArm":{"RU":-70.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":20.0,"RF":-50.0},"ValveBiped.Bip01_L_Forearm":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0}}},{"FrameRate":5.0,"BoneInfo":{"ValveBiped.Bip01_R_Calf":{"RU":0.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":0.0,"RF":0.0},"ValveBiped.Bip01_R_Thigh":{"RU":0.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":0.0,"RF":0.0},"ValveBiped.Bip01_L_Forearm":{"RU":0.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":0.0,"RF":0.0},"ValveBiped.Bip01_R_UpperArm":{"RU":-130.0,"MU":0.0,"RR":30.0,"MR":0.0,"MF":0.0,"RF":-80.0},"ValveBiped.Bip01_R_Forearm":{"RU":0.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":0.0,"RF":0.0}}},{"FrameRate":5.0,"BoneInfo":{"ValveBiped.Bip01_R_Calf":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_Thigh":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_Forearm":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_UpperArm":{"RU":-130.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":30.0,"RF":-80.0},"ValveBiped.Bip01_L_Forearm":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0}}}],"RestartFrame":3.0}
]]
))


RegisterLuaAnimation("hitlerheil", util.JSONToTable(
[[
{"Type":0.0,"FrameData":[{"FrameRate":3.0,"BoneInfo":{"ValveBiped.Bip01_R_UpperArm":{"RU":-70.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":60.0,"RF":0.0},"ValveBiped.Bip01_R_Hand":{"RU":0.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":30.0,"RF":-60.0},"ValveBiped.Bip01_R_Forearm":{"RU":-130.0,"MU":0.0,"MF":0.0,"MR":0.0,"RR":15.0,"RF":-20.0}}},{"FrameRate":1.0,"BoneInfo":{"ValveBiped.Bip01_R_UpperArm":{"RU":-70.0,"MU":0.0,"RR":60.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_Forearm":{"RU":-130.0,"MU":0.0,"RR":15.0,"MR":0.0,"MF":0.0,"RF":-20.0},"ValveBiped.Bip01_R_Hand":{"RU":0.0,"MU":0.0,"RR":30.0,"MR":0.0,"MF":0.0,"RF":-60.0}}},{"FrameRate":2.5,"BoneInfo":{"ValveBiped.Bip01_R_UpperArm":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_Hand":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0},"ValveBiped.Bip01_R_Forearm":{"RU":0.0,"MU":0.0,"RR":0.0,"MR":0.0,"MF":0.0,"RF":0.0}}}]}
]]))

if (SERVER) then
	hook.Add("PlayerSpawn", "KTAnims::PlayerSpawn", function(ply) ply:setNetVar("surrendered") ply.changingSurrender = nil end)
	hook.Add("PlayerDeath", "KTAnims::PlayerDeath", function(ply) ply:setNetVar("surrendered") ply.changingSurrender = nil end)
	hook.Add("PlayerButtonDown", "KTAnims::PlayerButtonDown", function(ply, btn)
		if (ply:getChar() && ply:Alive() && btn == KEY_F7 && !ply.changingSurrender) then
			ply.changingSurrender = true
			if (ply:getNetVar("surrendered")) then
				ply:StopLuaAnimation("surrender", 0.2)
				timer.Simple(3, function()
					ply:setNetVar("surrendered")
					ply.changingSurrender = nil
				end)
			else
				ply:SelectWeapon("nut_hands")
				ply:SetLuaAnimation("surrender")
				ply:setNetVar("surrendered", true)
				timer.Simple(3, function()
					ply.changingSurrender = nil
				end)
			end
		end
	end)
end

hook.Add("PlayerSwitchWeapon", "KTAnims::SurrenderWepSwitch", function(ply, oldWep, newWep)
	if (ply:getNetVar("surrendered") && newWep:GetClass() != "nut_hands") then
		return true 
	end
end)

hook.Add("StartCommand", "KTAnims::WhyAreYouRunning", function (ply, cmd)
	if (ply.getNetVar && ply:getNetVar("surrendered")) then
		cmd:SetButtons(bit.band(cmd:GetButtons(), bit.bnot(bit.bor(IN_SPEED,IN_DUCK,IN_ATTACK,IN_ATTACK2,IN_USE))))
	end
end)

hook.Add("HUDPaint", "KTAnims::SurrenderHUD", function()
	if (LocalPlayer().getNetVar && LocalPlayer():getNetVar("surrendered")) then
		draw.SimpleTextOutlined("You have surrendered! Press F7 to lower your hands", "DermaLarge", ScrW() * 0.5, ScrH() * 0.5, Color(255, 100, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
	end
end)

if (SERVER) then
	local AllowedAct2s = { ["heil"] = true, ["hitlerheil"] = true}
	local Act2sExtras = {
		["heil"] = function(ply)
			timer.Simple((1/3.5)+(1/5), function()
				if (ply && IsValid(ply)) then
					ply:EmitSound("npc/combine_soldier/gear"..math.random(1, 6)..".wav")
				end
			end)
		end
	}
	concommand.Add("act2", function(ply, cmd, args)
		if (args && args[1] && AllowedAct2s[args[1]]) then
			ply:StopAllLuaAnimations()
			ply:SetLuaAnimation(args[1])
			if (Act2sExtras[args[1]]) then
				Act2sExtras[args[1]](ply)
			end
		end
	end)
end


 
local function AddKTNutCommands() 
	KTANIMATIONS_INITED = true
	nut.command.add("heil", {
		syntax = "",
		onRun = function(client, arguments)
			timer.Simple(0.5, function()
				if (client && IsValid(client)) then
					client:ConCommand('say "Heil Hitler!"')
				end
			end)
			client:ConCommand("act2 heil")
		end
	})

	nut.command.add("hitlerheil", {
		syntax = "",
		onRun = function(client, arguments)
			timer.Simple(0.2, function()
				if (client && IsValid(client)) then
					client:ConCommand('say "Heil."')
				end
			end)
			client:ConCommand("act2 hitlerheil")
		end
	})
	
	nut.command.add("heiltoggle", {
		syntax = "",
		onRun = function(client, arguments)
			if (!client.Heiling) then
				client:StopAllLuaAnimations()
				client:SetLuaAnimation("heilfrozen")
				client.Heiling = true
			else
				client:StopAllLuaAnimations(0.5)
				client.Heiling = false
			end
		end
	})
end

if (SERVER) then
	hook.Add("PlayerSpawn", "KTAnimations::ToggleHeilSet", function(ply)
		ply.Heiling = false
		ply:StopAllLuaAnimations()
	end)
end

hook.Add("Initialize", "KTAnimations::AddCMDS", AddKTNutCommands)

if (KTANIMATIONS_INITED) then 
	AddKTNutCommands()
end

