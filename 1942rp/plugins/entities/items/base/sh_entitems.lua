
ITEM.name = "Entity Dropper"
ITEM.desc = "Drops an Entity. You probably shouldnt be seeing this. tell a developer please."
ITEM.model = "models/weapons/w_package.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.entdrop = ""
ITEM.permit = "admin"
ITEM.limits = false
ITEM.limit = 1

ITEM.functions.Use = {
	name = "Use",
	icon = "icon16/cursor.png",
	onRun = function(item, player, client)
	local client = item.player
	
if item.limits == true then
	local NumEnts = 0
	
	for k, v in pairs( ents.FindByClass( item.entdrop ) ) do
		if v.SteamID == client:SteamID() then
			NumEnts = NumEnts + 1
		end
	end

		if NumEnts >= item.limit then
			client:notify("You have reached maximum amount of " .. item.name .. "s." )
			return false
		end
		
		item.player:EmitSound( "physics/flesh/flesh_bloody_break.wav", 75, 200 )
				
		local ent = ents.Create( item.entdrop )
		ent:SetPos(item.player:EyePos() + ( item.player:GetAimVector() * 50))
		ent:Spawn()
		ent.Owner = client
		ent.SteamID = client:SteamID()
		--ent:Activate()
				
		--mayoritem:SetPos( ply:EyePos() + ( ply:GetAimVector() * 50) )
		return true
		
	else

	

			item.player:EmitSound( "physics/flesh/flesh_bloody_break.wav", 75, 200 )
				
				local ent = ents.Create( item.entdrop )
				ent:SetPos(item.player:EyePos() + ( item.player:GetAimVector() * 50))
				ent:Spawn()
				ent.Owner = client
				ent.SteamID = client:SteamID()
				--ent:Activate()
				
				--mayoritem:SetPos( ply:EyePos() + ( ply:GetAimVector() * 50) )
			
		return true
		end
	end
}