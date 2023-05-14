local PLUGIN = PLUGIN

local DISEASE = {}
DISEASE.uid = "leg_injury"
DISEASE.name = "Leg Injury"
DISEASE.category = "Body"
DISEASE.phase = {
	"Your leg is in great pain.",
	"You should seek medical treatment for your damaged leg.",
}
DISEASE.cure = {
	"Your leg has been healed.",
}
DISEASE.effect = function(client, char) --use effect
	client:SetRunSpeed( nut.config.get("runSpeed") * 0.4 )
	client:SetWalkSpeed( nut.config.get("walkSpeed") * 0.4 )
end
DISEASE.effectC = function(client, char) --cure effect
	client:SetRunSpeed( nut.config.get("runSpeed"))
	client:SetWalkSpeed( nut.config.get("walkSpeed"))
end

DISEASES:Register( DISEASE )