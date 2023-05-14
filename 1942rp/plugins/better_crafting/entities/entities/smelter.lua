-- Please don't touch this
AddCSLuaFile()

ENT.Base                	  = "nut_craftingbase"
ENT.Author					  = "Ernie"
ENT.Contact					  = "ernie"
ENT.Instructions			  = "Press USE whilst looking at table to open crafting menu."
ENT.Spawnable				  = true
ENT.AdminOnly				  = true
ENT.DisableDuplicator		  = true
ENT.Category				  = "EXG - Crafting"

-- Config ->

ENT.PrintName           	  = "Smelter"
ENT.Purpose					  = "Use this table to smelt ores."
ENT.Model               	  = "models/props_wasteland/laundry_washer003.mdl"
ENT.InvWidth            	  = 9
ENT.InvHeight           	  = 8
ENT.CraftSound          	  = "player/shove_01.wav"
ENT.WeaponAttachments   	  = true
ENT.AllowedBlueprints   	  = {
	b_cartonrecipe      	  = false,
	b_cigrecipe         	  = false,
	b_cylinder          	  = true,
	b_foreend           	  = true,
	b_foregrip          	  = true,
	b_grip              	  = true,
	b_gunbolt           	  = true,
	b_highgradebeer     	  = false,
	b_highgradecase     	  = false,
	b_highgradeshipment 	  = false,
	b_highunpack        	  = false,
	b_lowgradebeer      	  = false,
	b_lowgradecase      	  = false,
	b_lowgradeshipment  	  = false,
	b_lowunpack         	  = false,
	b_mediumgradebeer   	  = false,
	b_mediumgradecase		  = false,
	b_mediumgradeshipment	  = false,
	b_mediumunpack      	  = false,
	b_receiver           	  = true,
	b_revolverbarrel     	  = true,
	b_riflebarrel        	  = true,
	b_riflecraft         	  = true,
	b_riflestock         	  = true,
	b_slingswivel        	  = true,
	b_smgbarrel          	  = true,
	b_smgcraft           	  = true,
  	b_revolvercraft           = true,
	b_smgforegrip        	  = true,
	b_smgstock           	  = true,
	b_swill              	  = false,
	b_trigger            	  = true,
	b_refined_iron            = true,
  --clothes
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
	b_winewhitecaserecipe				= false,
	b_wineredcaserecipe					= false,
}

-- End of config

CraftingTables = CraftingTables or {}
CraftingTables[ENT.PrintName] = ENT.AllowedBlueprints