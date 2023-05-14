-- Please don't touch this
AddCSLuaFile()

ENT.Base                      = "nut_craftingbase"
ENT.Author				      = "Ernie"
ENT.Contact				      = "ernie"
ENT.Instructions		      = "Press USE whilst looking at table to open crafting menu."
ENT.Spawnable			      = true
ENT.AdminOnly			      = true
ENT.DisableDuplicator		  = true
ENT.Category				  = "EXG - Crafting"

-- Config ->

ENT.PrintName          		  = "Packaging Station"
ENT.Purpose					  = "Use this to package items."
ENT.Model             		  = "models/props/cs_militia/wood_table.mdl"
ENT.InvWidth          		  = 6
ENT.InvHeight          		  = 8
ENT.CraftSound          	  = "player/shove_01.wav"
ENT.WeaponAttachments   	  = true
ENT.AllowedBlueprints  	 	  = {
	--weapons
	b_cartonrecipe      	  = false,
	b_cigrecipe         	  = false,
	b_cylinder          	  = false,
	b_foreend           	  = false,
	b_foregrip          	  = false,
	b_grip              	  = false,
	b_gunbolt           	  = false,
	--beer
	b_highgradebeer     	  = false,
	b_highgradecase     	  = true,
	b_highgradeshipment 	  = true,
	b_highunpack        	  = true,
	b_lowgradebeer      	  = false,
	b_lowgradecase      	  = true,
	b_lowgradeshipment  	  = true,
	b_lowunpack         	  = true,
	b_mediumgradebeer   	  = false,
	b_mediumgradecase		  = true,
	b_mediumgradeshipment	  = true,
	b_mediumunpack      	  = true,
	--weapons
	b_receiver           	  = false,
	b_revolverbarrel     	  = false,
	b_riflebarrel        	  = false,
	b_riflecraft         	  = false,
	b_riflestock         	  = false,
	b_slingswivel        	  = false,
	b_smgbarrel          	  = false,
	b_smgcraft           	  = false,
	b_smgforegrip        	  = false,
	b_smgstock           	  = false,
	--swill
	b_swill              	  = false,
	--weapons
	b_trigger            	  = false,
	--clothing
	b_opensuittie        	  = false,
	b_closedsuit          	  = false,
	b_waistcoat           	  = false,
	b_trenchcoat        	  = false,
	b_shirtnotie           	  = false,
	b_shirttie                = false,
	--food
	b_chickenpotpierecipe    			= false,
	b_clamchowderrecipe      			= false,
	b_deviledeggsrecipe      			= false,
	b_flapjacksrecipe         			= false,
	b_germanpotatosaladrecipe 			= false,
	b_hamdinnerrecipe         			= false,
	b_hotdogrecipe            			= false,
	b_lobsterdinnerrecipe     			= false,
	b_oystersrockefellerrecipe			= false,
	b_salmonrecipe     					= false,
	b_shrimpcocktailrecipe     			= false,
	b_spaghettiandmeatballsrecipe     	= false,
	b_steakdinnerrecipe     			= false,
	b_turkeydinnerrecipe    			= false,
		  --guns
	b_kar98			  = false,
	b_mp30			  = false,
	b_mg34			  = false,
	b_mg42			  = false,
	b_p08			  = false,
	b_p38			  = false,
	--coffee
	b_coffeecuprecipe    				= false,
	b_coffeebeantumblerecipe     		= false,
	b_coffeebeanroastrecipe     		= false,
	b_coffeebeangrindrecipe    			= false,
	--heroin
	b_heroinrecipe    					= false,
	b_morphinerecipe     				= false,
	b_needleofheroinrecipe     			= false,
	b_opiumrecipe    					= false,
    --cocaine
	b_cocaineleafrecipe					= false,
	b_cocainerecipe						= false,
	--tonics
	b_healthcurerecipe					= false,
	--wine
	b_redmashrecipe						= false,
	b_redwinebarrelrecipe				= false,
	b_whitemashrecipe					= false,
	b_whitewinebarrelrecipe				= false,
	b_wineredrecipe						= false,
	b_winewhiterecipe					= false,
	b_winewhitecaserecipe				= true,
	b_wineredcaserecipe					= true,
	
}

-- End of config

CraftingTables = CraftingTables or {}
CraftingTables[ENT.PrintName] = ENT.AllowedBlueprints