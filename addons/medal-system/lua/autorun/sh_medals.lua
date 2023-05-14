
Medals = Medals or {}
Medals.PlayerMedals = Medals.PlayerMedals or {}
Medals.RequiredFlag = "m"
Medals.MaximumWearMedals = 4
Medals.Medals = {
	["iron_cross"] = {
		name = "Iron Cross 1st Class",
		desc = "A highly valued medal awarded to the bravest of soldiers.",
		size_w = 64,
		size_h = 128,
		icon = "medals/iron_cross_1st_class.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18", // Recommend not having different fonts & text heights. They end up not aligning all that well
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["iron_cross_2nd_class"] = {
		name = "Iron Cross 2nd Class",
		desc = "A highly valued medal awarded to the bravest of soldiers.",
		size_w = 64,
		size_h = 128,
		icon = "medals/iron_cross_2nd_class.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18", // Recommend not having different fonts & text heights. They end up not aligning all that well
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["iron_cross_knights_regular"] = {
		name = "Knights Cross of the Iron Cross",
		desc = "Awarded for Heroism and Valor in the German Military",
		size_w = 64,
		size_h = 128,
		icon = "medals/knights_cross.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18", // Recommend not having different fonts & text heights. They end up not aligning all that well
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["iron_cross_oak"] = {
		name = "Knights Cross of the Iron Cross, with Oak Leaves",
		desc = "Awarded for Heroism and Valor in the German Military",
		size_w = 64,
		size_h = 128,
		icon = "medals/knights_cross_oak.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18", // Recommend not having different fonts & text heights. They end up not aligning all that well
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["iron_cross_oak_swords"] = {
		name = "Knights Cross of the Iron Cross, with Oak Leaves and Swords",
		desc = "A highly valued medal awarded to the bravest of soldiers.",
		size_w = 64,
		size_h = 128,
		icon = "medals/knights_cross_oak_sword.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18", // Recommend not having different fonts & text heights. They end up not aligning all that well
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["iron_cross_oak_diamond_swords"] = {
		name = "Knights Cross of the Iron Cross, with Oak Leaves, Swords, and Diamonds",
		desc = "A highly valued medal awarded to the bravest of soldiers.",
		size_w = 64,
		size_h = 128,
		icon = "medals/knights_cross_oak_sword_diamonds.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18", // Recommend not having different fonts & text heights. They end up not aligning all that well
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["iron_cross_oak_diamond_swords_gold"] = {
		name = "Knights Cross of the Iron Cross, with Gold Oak Leaves, Swords, and Diamonds in Gold",
		desc = "A highly valued medal awarded to the bravest of soldiers.",
		size_w = 64,
		size_h = 128,
		icon = "medals/knights_cross_oak_sword_diamonds_gold.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18", // Recommend not having different fonts & text heights. They end up not aligning all that well
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["mothers_cross"] = {
		name = "Mothers Cross",
		desc = "Awarded to a German mother for exceptional merit to the German nation",
		size_w = 64,
		size_h = 128,
		icon = "medals/mothers_cross.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18", // Recommend not having different fonts & text heights. They end up not aligning all that well
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["naval_destroyer"] = {
		name = "Destroyer War Badge",
		desc = "Awarded to Officers and Crew for service on Kriegsmarine destroyers",
		size_w = 64,
		size_h = 128,
		icon = "medals/naval_destroyer.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18", // Recommend not having different fonts & text heights. They end up not aligning all that well
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["pickelhaube"] = {
		name = "Pickelhaube",
		desc = "Ceremonial Award for Service during WW1",
		size_w = 128,
		size_h = 128,
		icon = "medals/pickelhaube.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18", // Recommend not having different fonts & text heights. They end up not aligning all that well
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["pilot_badge"] = {
		name = "Luftwaffe Pilots Badge",
		desc = "Awarded to Luftwaffe Pilots for 100 Hours of Flight Service",
		size_w = 64,
		size_h = 128,
		icon = "medals/pilot_badge.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18", // Recommend not having different fonts & text heights. They end up not aligning all that well
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["pilot_badge_gold_diamonds"] = {
		name = "Luftwaffe Pilot Badge, in Gold with Diamonds",
		desc = "Awarded to Luftwaffe Pilots for valorous service",
		size_w = 64,
		size_h = 128,
		icon = "medals/pilot_badge_gold_diamonds.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18", // Recommend not having different fonts & text heights. They end up not aligning all that well
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["ss_dagger"] = {
		name = "SS Honor Dagger",
		desc = "Awarded to SS Members for Honorable Service",
		size_w = 64,
		size_h = 128,
		icon = "medals/ss_dagger.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18", // Recommend not having different fonts & text heights. They end up not aligning all that well
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["ss_sabre"] = {
		name = "SS Honor Sabre",
		desc = "Awarded to SS Members for Honorable Service",
		size_w = 64,
		size_h = 128,
		icon = "medals/ss_sabre.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18", // Recommend not having different fonts & text heights. They end up not aligning all that well
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["uboat_combat"] = {
		name = "U-Boat Combat Badge",
		desc = "Awarded to SS Members for Honorable Service",
		size_w = 64,
		size_h = 128,
		icon = "medals/uboat_combat.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18", // Recommend not having different fonts & text heights. They end up not aligning all that well
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["german_cross"] = {
		name = "German Cross",
		desc = "",
		size_w = 64,
		size_h = 64,
		icon = "medals/german_cross_fixed_3.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["german_cross_gold"] = {
		name = "German Cross in Gold",
		desc = "",
		size_w = 64,
		size_h = 128,
		icon = "medals/gold_german_cross.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["german_cross_gold_diamond"] = {
		name = "German Cross in Gold and Diamonds",
		desc = "",
		size_w = 64,
		size_h = 128,
		icon = "medals/gold_diamonds_german_cross.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["german_cross_silver"] = {
		name = "German Cross in Silver",
		desc = "",
		size_w = 64,
		size_h = 128,
		icon = "medals/silver_german_cross.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["ss_honor_ring"] = {
		name = "SS Honor Ring",
		desc = "",
		size_w = 64,
		size_h = 128,
		icon = "medals/ss_honor_ring.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["german_order"] = {
		name = "German Order Cross",
		desc = "",
		size_w = 64,
		size_h = 128,
		icon = "medals/german_order.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["blood_order"] = {
		name = "Blood Order Medal",
		desc = "",
		size_w = 64,
		size_h = 128,
		icon = "medals/blood_order.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["war_merit"] = {
		name = "War Merit 2nd Class with Swords",
		desc = "",
		size_w = 64,
		size_h = 128,
		icon = "medals/war_merit_2nd_class_swords.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["war_merit_no_swords"] = {
		name = "War Merit 2nd Class",
		desc = "",
		size_w = 64,
		size_h = 128,
		icon = "medals/war_merit_2nd_class.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["war_merit_knight"] = {
		name = "War Merit 1st Class",
		desc = "",
		size_w = 64,
		size_h = 128,
		icon = "medals/war_merit_1st_class.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["war_merit_knight_swords"] = {
		name = "War Merit 1st Class with Swords",
		desc = "",
		size_w = 64,
		size_h = 128,
		icon = "medals/war_merit_1st_class_swords.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["war_merit_gold"] = {
		name = "War Merit in Gold",
		desc = "",
		size_w = 64,
		size_h = 128,
		icon = "medals/warmeritgold.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["war_merit_gold_swords"] = {
		name = "War Merit in Gold with Swords",
		desc = "",
		size_w = 64,
		size_h = 128,
		icon = "medals/warmeritgoldswords.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["10yearservice"] = {
		name = "10 Year Party Long Service Award",
		desc = "Given to those who have been a party member for more than 10 years.",
		size_w = 64,
		size_h = 128,
		icon = "medals/10_year_party_service_award.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["15yearservice"] = {
		name = "15 Year Party Long Service Award",
		desc = "Given to those who have been a party member for more than 15 years.",
		size_w = 64,
		size_h = 128,
		icon = "medals/15_year_party_service_award.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["25yearservice"] = {
		name = "25 Year Party Long Service Award",
		desc = "Given to those who have been a party member for more than 25 years.",
		size_w = 64,
		size_h = 128,
		icon = "medals/25_year_party_service_award.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["berlingau"] = {
		name = "Berlin Gau Badge",
		desc = "Given by the Gauleiter to a person for their service to the Gau.",
		size_w = 64,
		size_h = 128,
		icon = "medals/gau_badge.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["closecombat"] = {
		name = "Close Combat Clasp",
		desc = "Given for killing an enemy in hand to hand combat.",
		size_w = 90,
		size_h = 128,
		icon = "medals/close_combat_clasp_silver.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["closecombat_gold"] = {
		name = "Close Combat Clasp in Gold",
		desc = "Given for killing an enemy in hand to hand combat.",
		size_w = 90,
		size_h = 128,
		icon = "medals/close_combat_clasp_gold.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["generalassault"] = {
		name = "General Assault Badge",
		desc = "Take part in a ground based attack as a non infantry element.",
		size_w = 64,
		size_h = 128,
		icon = "medals/general_assault.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["goldenparty"] = {
		name = "Golden Party Badge",
		desc = "Given to NSDAP Members with Membership numbers below 100,000 or awarded by the Fuhrer",
		size_w = 64,
		size_h = 128,
		icon = "medals/golden_party_badge.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["honor"] = {
		name = "Honor Chevron for the Old Guard",
		desc = "This award is for members of the  Allgemeine-SS who joined prior to 30 January 1933",
		size_w = 64,
		size_h = 128,
		icon = "medals/honor_chevron_old_guard.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["infantryassault"] = {
		name = "Infantry Assault Badge",
		desc = "Participate in an attack against the enemy as infantry.",
		size_w = 64,
		size_h = 128,
		icon = "medals/infantry_assault.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["panzercrew"] = {
		name = "Panzer Crew Badge",
		desc = "Serve as a panzer crewman with bravery.",
		size_w = 64,
		size_h = 128,
		icon = "medals/panzer_crewman.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["high_seas"] = {
		name = "High Seas Fleet Badge",
		desc = "",
		size_w = 64,
		size_h = 128,
		icon = "medals/high_seas_fleet.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["policeservice"] = {
		name = "Police Long Service Award",
		desc = "Given to members of the Police for long service",
		size_w = 64,
		size_h = 128,
		icon = "medals/policelongservice.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["policeservice_25"] = {
		name = "Police 25 Year Service Award",
		desc = "Given to members of the Police for long service",
		size_w = 64,
		size_h = 128,
		icon = "medals/policelongservice25thrice.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	}, // policelongservice25thrice
	["sslongservice"] = {
		name = "SS 4 Year Service Award",
		desc = "Given to Members of the SS for long standing service.",
		size_w = 64,
		size_h = 128,
		icon = "medals/ss_4_year.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["sslongservice_12"] = {
		name = "SS 12 Year Service Award",
		desc = "Given to Members of the SS for long standing service.",
		size_w = 64,
		size_h = 128,
		icon = "medals/ss_8_year.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["sslongservice_25"] = {
		name = "SS 25 Year Service Award",
		desc = "Given to Members of the SS for long standing service.",
		size_w = 64,
		size_h = 128,
		icon = "medals/ss_25_year.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["tankdestruction"] = {
		name = "Tank Destruction Badge",
		desc = "Awarded to infantry for destroying a tank in combat.",
		size_w = 64,
		size_h = 128,
		icon = "medals/tank_destruction.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["wehrmachtflak"] = {
		name = "Wehrmacht Flak Badge in Silver",
		desc = "Shoot down an enemy plane with a flak gun.",
		size_w = 64,
		size_h = 128,
		icon = "medals/flak_silver.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["wehrmachtflak_gold"] = {
		name = "Wehrmacht Flak Badge in Gold",
		desc = "Shoot down an enemy plane with a flak gun.",
		size_w = 64,
		size_h = 128,
		icon = "medals/flak_gold.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["wehrmachtlongservice"] = {
		name = "Wehrmacht Long Service Award",
		desc = "Given to members of the Wehrmacht for long service.",
		size_w = 64,
		size_h = 128,
		icon = "medals/wehrmacht_long_service.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["woundblack"] = {
		name = "Wound Badge",
		desc = "You get it for being wounded in Combat.",
		size_w = 64,
		size_h = 128,
		icon = "medals/black_wound.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["wound_silver"] = {
		name = "Wound Badge in Silver",
		desc = "You get it for being wounded in Combat.",
		size_w = 64,
		size_h = 128,
		icon = "medals/silver_wound.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["wound_gold"] = {
		name = "Wound Badge in Gold",
		desc = "You get it for being wounded in Combat.",
		size_w = 64,
		size_h = 128,
		icon = "medals/gold_wound.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["cordon"] = {
		name = "The Grand Cordon",
		desc = "The Grand Cordon Of the Order, also known as The First Class of the Order of the Rising Sun is typically awarded to foreign heads of government, chairpersons of prominent international organizations and leading politicians, business leaders and diplomats.",
		size_w = 128,
		size_h = 128,
		icon = "medals/order_rising_sun_fixed.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["blockade_runner"] = {
		name = "Blockade Runner Badge",
		desc = "Awarded for service on warships or merchant vessels",
		size_w = 64,
		size_h = 128,
		icon = "medals/blockade_runner.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["blue_max"] = {
		name = "Pour le Merite",
		desc = "Awarded for extraordinary personal achievement",
		size_w = 64,
		size_h = 128,
		icon = "medals/blue_max.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["fallschirmjaeger_gold"] = {
		name = "Fallschirmjäger Medal in Gold",
		desc = "Awarded after completion of the required number of six jumps as a Fallschirmjager",
		size_w = 64,
		size_h = 128,
		icon = "medals/fallschrimjager_badge_gold.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["hitler_youth_knife"] = {
		name = "Hitler Youth Knife",
		desc = "Awarded to Hitlerjugend after passing state examinations",
		size_w = 64,
		size_h = 128,
		icon = "medals/hitler_youth_knife.png",
		resourceAddFile = "", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["german_welfare_2nd"] = {
		name = "Social Welfare Medal 2nd Class",
		desc = "Awarded to DRK Members for their service to the Reich and the Citizens of Berlin.",
		size_w = 64,
		size_h = 128,
		icon = "medals/german_welfare.png",
		resourceAddFile = "true", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["german_welfare"] = {
		name = "Social Welfare Medal 1st Class",
		desc = "Awarded to DRK Members for their service to the Reich and the Citizens of Berlin.",
		size_w = 64,
		size_h = 128,
		icon = "medals/german_welfare_1st.png",
		resourceAddFile = "true", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},
	["noc_staff"] = {
		name = "Network of Champions Staff Team",
		desc = "Awarded to Members of the Network of Champions Staff Team.",
		size_w = 64,
		size_h = 128,
		icon = "materials/nocbanner.png",
		resourceAddFile = "true", // set to nil if you don't want this (if its already part of a content pack)
		TextFont = "Trebuchet18",
		TextColor = Color(255, 255, 255),
		TextHeight = 18
	},

}

for k,v in pairs(Medals.Medals) do
	if (v.resourceAddFile) then
		resource.AddFile(v.resourceAddFile)
	end
end

local plyMeta = FindMetaTable("Player")

function plyMeta:MedalsID()
	local steam = self:SteamID()
	if (self:IsBot()) then steam = "BOT" end
	return steam.."|"..self:getChar():getID()
end

function Medals.isValid(medalID)
	return Medals.Medals[medalID] != nil
end

if (SERVER) then
	util.AddNetworkString("Medals_Update")
	util.AddNetworkString("Medals_UpdateWear")
	util.AddNetworkString("OpenMedals")
	
	function Medals.updateAll()
		for k,v in pairs(player.GetAll()) do
			Medals.update(v)
		end
	end
	
	function Medals.update(ply)
		net.Start("Medals_Update")
		net.WriteTable(Medals.PlayerMedals)
		net.Send(ply)
	end
	
	
	function plyMeta:giveMedal(medalID)
		Medals.PlayerMedals[self:MedalsID()] = Medals.PlayerMedals[self:MedalsID()] or {}
		Medals.PlayerMedals[self:MedalsID()][medalID] = 1
		Medals.updateAll()
		Medals.save()
	end
	
	function plyMeta:giveMedalWorn(medalID)
		Medals.PlayerMedals[self:MedalsID()] = Medals.PlayerMedals[self:MedalsID()] or {}
		Medals.PlayerMedals[self:MedalsID()][medalID] = 2
		Medals.updateAll()
		Medals.save()
	end
	
	function plyMeta:takeMedal(medalID)
		if (Medals.PlayerMedals[self:MedalsID()]) then
			Medals.PlayerMedals[self:MedalsID()][medalID] = nil
		end
		Medals.updateAll()
		Medals.save()
	end
	
	function Medals.save()
		file.Write("medals.txt", util.TableToJSON(Medals.PlayerMedals, true))
	end
	
	function Medals.load()
		if (!file.Exists("medals.txt", "DATA")) then
			Medals.save()
		end
		
		Medals.PlayerMedals = util.JSONToTable(file.Read("medals.txt"))
	end
	
	hook.Add("Initialize", "PlayerMedals::Initialize", function()
		Medals.load()
		Medals.updateAll()
	end)
	
	hook.Add("PlayerInitialSpawn", "PlayerMedals::PlayerInitialSpawn", function(ply)
		Medals.update(ply)
	end)
	
	net.Receive("Medals_UpdateWear", function(len, ply)
		local wearMedals = net.ReadTable()
		if (!Medals.PlayerMedals[ply:MedalsID()]) then return end
		
		for k,v in pairs(Medals.PlayerMedals[ply:MedalsID()]) do
			Medals.PlayerMedals[ply:MedalsID()][k] = 1
		end
		
		if (table.Count(wearMedals) <= Medals.MaximumWearMedals) then
			for k,v in pairs(wearMedals) do
				if (Medals.PlayerMedals[ply:MedalsID()][v]) then
					Medals.PlayerMedals[ply:MedalsID()][v] = 2
				end
			end
		end
		
		Medals.updateAll()
	end)
end

if (CLIENT) then
	Medals.MaterialCache = Medals.MaterialCache or {}
	
	net.Receive("Medals_Update", function()
		Medals.PlayerMedals = net.ReadTable()
	end)
	hook.Add( "DrawEntityInfo", "DrawEntityInfoMedals", function( entity, alpha, position )
		if (entity:IsValid() && entity:IsPlayer()) then
			if (entity:getChar() && Medals.PlayerMedals[entity:MedalsID()]) then
				local OFFSET_NORMAL = Vector(0, 0, 80)
				local OFFSET_CROUCHING = Vector(0, 0, 48)
				local toScreen = FindMetaTable("Vector").ToScreen
				local drawposition2 = toScreen(entity.GetPos(entity) + (entity.Crouching(entity) and OFFSET_CROUCHING or OFFSET_NORMAL))
				local x = drawposition2.x
				local y = drawposition2.y
				local drawMedals = {}
				for k, v in pairs(Medals.PlayerMedals[entity:MedalsID()]) do
					local medalData = Medals.Medals[k]
					if (medalData && v == 2) then
						table.insert(drawMedals, medalData)
					end
				end
				
				local totalWidth = -20
				
				for k, v in pairs(drawMedals) do
					totalWidth = totalWidth + v.size_w + 20
				end
				
				local widthOffset = 0
				for k, v in pairs(drawMedals) do
					if (Medals.MaterialCache[v.icon] == nil) then
						Medals.MaterialCache[v.icon] = Material(v.icon)
					end
					surface.SetDrawColor(255, 255, 255, alpha)
					surface.SetMaterial(Medals.MaterialCache[v.icon])
					surface.DrawTexturedRect(x + widthOffset - totalWidth / 2, y - 10 - v.size_h, v.size_w, v.size_h)
					widthOffset = widthOffset + v.size_w + 20
					
				end
			end
		end
	end )

	net.Receive("OpenMedals", function()
		local MedalW = 100
		local MedalH = 100
		local frame = vgui.Create("DFrame")
		frame:SetSize(MedalW * 5 + 30, MedalH * 5 + 55)
		frame:Center()
		frame:MakePopup()
		frame:SetTitle("My Medals")
		local List = vgui.Create("DIconLayout", frame)
		List:Dock(FILL)
		List:SetSpaceX(5)
		List:SetSpaceY(5)
		
		local myMedals = {}
		local wornMedals = {}
		for k,v in pairs(Medals.PlayerMedals[LocalPlayer():MedalsID()] or {}) do
			if (Medals.isValid(k)) then
				if (v == 2) then wornMedals[k] = true end
				myMedals[#myMedals + 1] = k
			end
		end
		for i = 1, 25 do
			local ListItem = List:Add("DPanel")
			ListItem:SetSize(MedalW, MedalH)
			if (myMedals[i]) then
				ListItem.medal = myMedals[i]
				ListItem.oldPaint = ListItem.Paint
				ListItem.Paint = function(pnl, pnl_w, pnl_h)
					pnl:oldPaint(pnl_w, pnl_h)
					local med_w, med_h
					if (Medals.Medals[pnl.medal].size_w >= Medals.Medals[pnl.medal].size_h) then
						if (Medals.Medals[pnl.medal].size_w >= MedalW - 10) then
								med_w = Medals.Medals[pnl.medal].size_w * (MedalW - 10)/Medals.Medals[pnl.medal].size_w
								med_h = Medals.Medals[pnl.medal].size_h * (MedalW - 10)/Medals.Medals[pnl.medal].size_w
							else
								med_w = Medals.Medals[pnl.medal].size_w
								med_h = Medals.Medals[pnl.medal].size_h
						end
					else
						if (Medals.Medals[pnl.medal].size_h >= MedalW - 10) then
							med_w = Medals.Medals[pnl.medal].size_w * (MedalH - 10)/Medals.Medals[pnl.medal].size_h
							med_h = Medals.Medals[pnl.medal].size_h * (MedalH - 10)/Medals.Medals[pnl.medal].size_h
						else
							med_w = Medals.Medals[pnl.medal].size_w
							med_h = Medals.Medals[pnl.medal].size_h
						end
					end
					if (pnl.medal) then
						if (wornMedals[pnl.medal]) then
							surface.SetDrawColor(50, 255, 50, 50)
							surface.DrawRect(1, 1, pnl_w - 2, pnl_h - 2)
						end
						surface.SetDrawColor(255, 255, 255, 255)
						if (Medals.MaterialCache[Medals.Medals[pnl.medal].icon] == nil) then
							Medals.MaterialCache[Medals.Medals[pnl.medal].icon] = Material(Medals.Medals[pnl.medal].icon)
						end
						surface.SetMaterial(Medals.MaterialCache[Medals.Medals[pnl.medal].icon])
						surface.DrawTexturedRect(5 + (MedalW - 10)/2 - med_w/2, 5 + (MedalH - 10)/2 - med_h/2, med_w, med_h)
					end
				end
				local btn = vgui.Create("DButton", ListItem)
				btn:Dock(FILL)
				btn:SetText(" ")
				btn:SetFont("HUDHintTextLarge")
				btn.Paint = function() end
				btn.medal = myMedals[i]
				btn.DoClick = function(pnl)
					if (wornMedals[pnl.medal]) then
						wornMedals[pnl.medal] = nil
						local wearMedals = {}
						for k,v in pairs(wornMedals) do
							wearMedals[#wearMedals + 1] = k
						end
						net.Start("Medals_UpdateWear")
						net.WriteTable(wearMedals)
						net.SendToServer()
					else
						if (table.Count(wornMedals) < Medals.MaximumWearMedals) then
							wornMedals[pnl.medal] = true
							local wearMedals = {}
							for k,v in pairs(wornMedals) do
								wearMedals[#wearMedals + 1] = k
							end
							net.Start("Medals_UpdateWear")
							net.WriteTable(wearMedals)
							net.SendToServer()
						end
					end
				end
				btn:SetTextColor(Medals.Medals[myMedals[i]].TextColor)
				btn:SetTooltip(Medals.Medals[myMedals[i]].name.."\n"..Medals.Medals[myMedals[i]].desc)
			end
		end
	end)
	
end

timer.Simple(1, function()
	nut.flag.add(Medals.RequiredFlag, "Access to giving medals.")
	
	nut.command.add("medalgive", {
		syntax = "<string player> <string medal>",
		onRun = function(client, arguments)
			if (!client || !client:getChar()) then
				return
			end
			
			if (!client:getChar():hasFlags(Medals.RequiredFlag)) then
				nut.util.notify("You do not have the required flags to access this feature.", client)
				return
			end
			if (!arguments[2]) then
				return L("invalidArg", client, 2)
			end
			
			local target = nut.command.findPlayer(client, arguments[1])
			local medalid
			
			for k,v in pairs(Medals.Medals) do
				if (k == arguments[2] || nut.util.stringMatches(v.name, arguments[2])) then
					medalid = k
					break
				end
			end
			
			if (!medalid) then
				nut.util.notify("That medal does not exist.", client)
				return
			end
			
			if (target) then
				nut.util.notify(target:Nick() .. " has been decorated with the "..Medals.Medals[medalid].name)
				target:giveMedal(medalid)
			end
		end
	})
	
nut.command.add("medaltake", {
		syntax = "<string player> <string medal>",
		onRun = function(client, arguments)
			if (!client || !client:getChar()) then
				return
			end
			
			if (!client:getChar():hasFlags(Medals.RequiredFlag)) then
				nut.util.notify("Your character cannot use this command.", client)
				return
			end
			if (!arguments[2]) then
				return L("invalidArg", client, 2)
			end
			
			local target = nut.command.findPlayer(client, arguments[1])
			local medalid
			
			for k,v in pairs(Medals.Medals) do
				if (k == arguments[2] || nut.util.stringMatches(v.name, arguments[2])) then
					medalid = k
					break
				end
			end
			
			if (!medalid) then
				nut.util.notify("That medal does not exist.", client)
				return
			end
			
			if (target) then
				nut.util.notify(target:Nick() .. " has had their "..Medals.Medals[medalid].name.. " confiscated.")
				target:takeMedal(medalid)
			end
		end
	})
	
	nut.command.add("medals", {
		syntax = "",
		onRun = function(client, arguments)
			if (!client || !client:getChar()) then
				return
			end
			
			if (Medals.PlayerMedals[client:MedalsID()] != nil && table.Count(Medals.PlayerMedals[client:MedalsID()]) > 0) then
				net.Start("OpenMedals")
				net.Send(client)
			end
		end
	})
end)


