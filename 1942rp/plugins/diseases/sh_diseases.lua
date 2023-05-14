local PLUGIN = PLUGIN
//
local DISEASE = {}
DISEASE.uid = "dis_cold"
DISEASE.name = "Common Cold"
DISEASE.category = "Illness"
DISEASE.duration = 0 --2 hours
DISEASE.spreadChance = 0 --this is really high
DISEASE.phase = {
	"Your body feels heavy, and you feel exhausted.",
	"You throat itches, and you have the urge to cough.",
	"You feel slightly nauseous.",
	"You feel cold.",
	"You feel congested, and your nose won't stop running.",
	"You have a sore throat, it is quite painful.",
	"You have a sudden urge to sneeze.",
	"Your head hurts slightly."
}
DISEASE.cure = {
	"Your cold goes away.",
}

DISEASES:Register( DISEASE )
//
local DISEASE = {}
DISEASE.uid = "dis_flu"
DISEASE.name = "Flu"
DISEASE.category = "Illness"
DISEASE.duration = 0 --2 hours
DISEASE.spreadChance = 0
DISEASE.phase = {
	"You feel incredibly nauseous, you have the urge to vomit.",
	"You feel like shit.",
	"Your body aches.",
	"You feel congested, and your nose won't stop running.",
	"You feel light-headed.",
	"You have a sudden urge to sneeze.",
	"You throat itches, and you have the urge to cough."
}
DISEASE.cure = {
	"Your flu goes away.",
}

DISEASES:Register( DISEASE )
//