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

ENT.PrintName           	  = "Drugmaking Table"
ENT.Purpose					  = "Use this table to craft drug related products."
ENT.Model               	  = "models/mosi/fallout4/furniture/workstations/chemistrystation01.mdl"
ENT.InvWidth           	 	  = 7
ENT.InvHeight         	  	  = 7
ENT.CraftSound        	  	  = "player/shove_01.wav"
ENT.WeaponAttachments         = true
ENT.AllowedBlueprints 	      = {
	b_cartonrecipe      	  = true,
	b_cigrecipe         	  = true,
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
	b_riflestock         	  = false,
	b_slingswivel        	  = false,
	b_smgbarrel          	  = false,
	b_smgcraft           	  = false,
    b_revolvercraft           = false,
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
    b_opium                             = true,
	b_heroinrecipe    					= true,
	b_morphinerecipe     				= false,
	b_needleofheroinrecipe     			= true,
	b_opiumrecipe    					= false,
  	--cocaine
	b_mulchedleaves					    = true,
	b_cocainerecipe						= true,
	--tonics
	b_healthcurerecipe					= true,
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