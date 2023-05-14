if !SERVER then return end
include("pyrozooka/sh/pyrozooka_config.lua")
pyrozooka = pyrozooka || {}


hook.Add("loadCustomDarkRPItems", "pyrozooka_INIT", function()

	if pyrozooka.config.enablebuydarkrp == true then

		AddEntity("Pyrozooka", {
			ent = "pyrozooka",
			model = "models/zerochain/pyrozooka/w_pyrozooka.mdl",
			price = 6000,
			max = 1,
			cmd = "buypyrozooka",
		})

	end

end)
