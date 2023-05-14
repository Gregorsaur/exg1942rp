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

ENT.PrintName          		  = "Drying Rack"
ENT.Purpose					  = "Use this to dry very legal products."
ENT.Model             		  = "models/props_wasteland/kitchen_shelf001a.mdl"
ENT.InvWidth          		  = 4
ENT.InvHeight          		  = 3
ENT.CraftSound          	  = "ambient/water/drip1.wav"
ENT.WeaponAttachments   	  = true
ENT.AllowedBlueprints  	 	  = {
	b_cartonrecipe      	  = false,
	b_cigrecipe         	  = false,
	b_cylinder          	  = false,
	b_foreend           	  = false,
	b_foregrip          	  = false,
	b_grip              	  = false,
	b_gunbolt           	  = false,
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
	b_receiver           	  = false,
	b_revolverbarrel     	  = false,
	b_riflebarrel        	  = false,
	b_riflecraft         	  = false,
    b_revolvercraft           = false,
	b_riflestock         	  = false,
	b_slingswivel        	  = false,
	b_smgbarrel          	  = false,
	b_smgcraft           	  = false,
	b_smgforegrip        	  = false,
	b_smgstock           	  = false,
	b_swill              	  = true,
	b_trigger            	  = false,
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
  --poppy
    b_driedpoppy                        = true,
}

-- End of config

CraftingTables = CraftingTables or {}
CraftingTables[ENT.PrintName] = ENT.AllowedBlueprints