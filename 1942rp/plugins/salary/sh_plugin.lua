local PLUGIN = PLUGIN
PLUGIN.name = "Salaries"
PLUGIN.author = "Chancer & Baid"
PLUGIN.desc = "An NPC that gives you money when you deserve it."
PLUGIN.nextPayment = 0

if SERVER then
	local rankModels = { --the models and what payment people receive for having them
		--MISC Models | 50 RM/h
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/casual_s1_01.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/casual_s1_02.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/casual_s1_03.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/casual_s1_04.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/casual_s1_05.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/casual_s1_06.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/drill_s1_01.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/drill_s1_02.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/drill_s1_03.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/drill_s1_04.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/drill_s1_05.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/drill_s1_06.mdl"] = 100,
		-- Enlisted Models 75RM/h
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_01.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_02.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_03.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_04.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_05.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_06.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m38greatcoat_w1_01.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m38greatcoat_w1_02.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m38greatcoat_w1_03.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m38greatcoat_w1_04.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m38greatcoat_w1_05.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m38greatcoat_w1_06.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m40_s1_01.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m40_s1_02.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m40_s1_03.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m40_s1_04.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m40_s1_05.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/infantry/en/m40_s1_06.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/medic/en/m36_s1_01.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/medic/en/m36_s1_02.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/medic/en/m36_s1_03.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/medic/en/m36_s1_04.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/medic/en/m36_s1_05.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/medic/en/m36_s1_06.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/medic/en/m40_s1_01.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/medic/en/m40_s1_02.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/medic/en/m40_s1_03.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/medic/en/m40_s1_04.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/medic/en/m40_s1_05.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/medic/en/m40_s1_06.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/pioneer/en/m36_s1_01.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/pioneer/en/m36_s1_02.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/pioneer/en/m36_s1_03.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/pioneer/en/m36_s1_04.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/pioneer/en/m36_s1_05.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/pioneer/en/m36_s1_06.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/pioneer/en/m40_s1_01.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/pioneer/en/m40_s1_02.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/pioneer/en/m40_s1_03.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/pioneer/en/m40_s1_04.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/pioneer/en/m40_s1_05.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/heer/pioneer/en/m40_s1_06.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m40formal_s1_01.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m40formal_s1_02.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m40formal_s1_03.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m40formal_s1_04.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m40formal_s1_05.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m40formal_s1_06.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m42smock_s1_01.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m42smock_s1_02.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m42smock_s1_03.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m42smock_s1_04.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m42smock_s1_05.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m42smock_s1_06.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/feldgendarmerie/en/m40_s1_01.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/feldgendarmerie/en/m40_s1_02.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/feldgendarmerie/en/m40_s1_03.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/feldgendarmerie/en/m40_s1_04.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/feldgendarmerie/en/m40_s1_05.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/feldgendarmerie/en/m40_s1_06.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m40_s1_01.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m40_s1_02.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m40_s1_03.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m40_s1_04.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m40_s1_05.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/infantry/en/m40_s1_06.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/panzer/en/panzerwrap_s1_01.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/panzer/en/panzerwrap_s1_02.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/panzer/en/panzerwrap_s1_03.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/panzer/en/panzerwrap_s1_04.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/panzer/en/panzerwrap_s1_05.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/panzer/en/panzerwrap_s1_06.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/signals/en/m40_s1_01.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/signals/en/m40_s1_02.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/signals/en/m40_s1_03.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/signals/en/m40_s1_04.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/signals/en/m40_s1_05.mdl"] = 100,
		["models/hts/comradebear/pm0v3/player/wss/signals/en/m40_s1_06.mdl"] = 100,
		["models/marines/sailor/marine01.mdl"] = 100,
		["models/marines/sailor/marine02.mdl"] = 100,
		["models/marines/sailor/marine03.mdl"] = 100,
		["models/marines/sailor/marine04.mdl"] = 100,
		["models/marines/sailor/marine05.mdl"] = 100,
		["models/marines/sailor/marine06.mdl"] = 100,
		["models/seaservice/sailor/sailor01.mdl"] = 100,
		["models/seaservice/sailor/sailor02.mdl"] = 100,
		["models/seaservice/sailor/sailor03.mdl"] = 100,
		["models/seaservice/sailor/sailor04.mdl"] = 100,
		["models/seaservice/sailor/sailor05.mdl"] = 100,
		["models/seaservice/sailor/sailor06.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,
		["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 100,

			}
	
	

	function PLUGIN:Think()
		if CurTime() > self.nextPayment then
			for _, v in pairs(player.GetAll()) do
				if IsValid(v) and v:getChar() then
					local char = v:getChar()
					local modelValue = rankModels[v:GetModel()]
					
					local amount = (modelValue or 0)
					
					char:setData("earnings", char:getData("earnings", 0) + amount)
					if modelValue then
						v:notify("You have been paid " .. amount .. " Dollars. Go to the bank to retrieve it.")
					end
				end
			end
			
			self.nextPayment = CurTime() + 600
		end
	end

	function PLUGIN:SaveData()
		local data = {}
			for k, v in ipairs(ents.FindByClass("nut_salary")) do
				data[#data + 1] = {
					name = v:getNetVar("name"),
					desc = v:getNetVar("desc"),
					pos = v:GetPos(),
					angles = v:GetAngles(),
					model = v:GetModel(),
					material = v:GetMaterial()
				}
			end
		self:setData(data)
	end

	function PLUGIN:LoadData()
		for k, v in ipairs(ents.FindByClass("nut_salary")) do
			v:Remove()
		end	
		for k, v in ipairs(self:getData() or {}) do
			local entity = ents.Create("nut_salary")
			entity:SetPos(v.pos)
			entity:SetAngles(v.angles)
			entity:Spawn()
			entity:SetModel(v.model)
			entity:SetMaterial(v.material)
		end
	end
end