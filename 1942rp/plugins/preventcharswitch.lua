local PLUGIN = PLUGIN
PLUGIN.name = "Prevent Character Switch"
PLUGIN.author = "rusty"
PLUGIN.desc = "Prevent players from switching characters after being damaged."

function PLUGIN:CanPlayerUseChar(client, character)
	if client.LastDamaged and client.LastDamaged > CurTime() - 120 and character:getFaction() != FACTION_STAFF and client:getChar() then
		return false, "You took damage too recently to switch characters!"	
	end
end

function PLUGIN:EntityTakeDamage(ent, dmg)
	if !IsValid(ent) or !ent:IsPlayer() then return end

	local attacker = dmg:GetAttacker()

	if !dmg:IsFallDamage() and IsValid(attacker) and attacker:IsPlayer() and attacker != ent and ent:Team() != FACTION_STAFF then
		ent.LastDamaged = CurTime()
	end
end