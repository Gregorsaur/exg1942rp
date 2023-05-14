PLUGIN.name = "Staff Blocker"
PLUGIN.desc = "Blocks staff from using their power if they are not on the 'Staff' faction."
PLUGIN.author = ""

nut.config.add("staffblocker", true, "Whether or not Staff Blocker is activated on the server.", nil, {
	category = "Staff Blocker"
})

local ignoreCommands = {
	"sam",
	"xgui",
	"sam menu",
	"sam help",
	"sam asay",
	"sam psay",
	"sam tsay",
	"sam csay"
}

hook.Add( "ULibCommandCalled", "StaffBlocker", function( ply, cmd )
	if ( table.HasValue( ignoreCommands, cmd ) ) then return end

	if ( nut.config.get( "staffblocker" ) ) then
		if ( ply.getChar ) then
			local character = ply:getChar()

			if ( character and character:getFaction() ~= FACTION_STAFF ) then
				ULib.tsayError( ply, "You cannot use this command while being in a non-staff faction." )

				return false
			end
		end
	end
end )

if ( SERVER ) then
	-- Force these commands to be blocked (Probably because we cannot automatically determine whether or not one should be blocked.)
	local forceCommands = {
		"plytransfer",
		"announce",
		"charsetmoney",
		"charsetmodel",
		"noclip",
		"cloak",
		"charsetname"
	}

	-- Ignore these commands (Well, made that just in case you would suddenly need this.)
	local ignoreCommands = {}

	hook.Add( "Think", "StaffBlocker", function()
		if ( not nut ) then return end
		if ( not nut.command ) then return end
		if ( not nut.command.list ) then return end
		if ( table.Count( nut.command.list ) < 1 ) then return end

		for k, v in pairs( nut.command.list ) do
			if ( table.HasValue( ignoreCommands, k  ) ) then
				continue
			end

			if ( table.HasValue( forceCommands, k ) or v.adminOnly or v.superAdminOnly or v.group ) then
				local onRun = v.onRun

				v.onRun = function(client, arguments)
					local character = client:getChar()

					if ( nut.config.get( "staffblocker" ) and character and character:getFaction() ~= FACTION_STAFF ) then
						return "You cannot use this command while being in a non-staff faction."
					else
						return onRun( client, arguments )
					end
				end
			end
		end

		hook.Remove( "Think", "StaffBlocker" )
	end )
end

hook.Add( "PlayerNoClip", "StaffBlocker", function( ply )
	if ( nut.config.get( "staffblocker" ) ) then
		if ( ply.getChar ) then
			local character = ply:getChar()

			if ( character and character:getFaction() ~= FACTION_STAFF ) then
				if ( SERVER ) then
					--ULib.tsayError( ply, "You cannot use this command while being in a non-staff faction." )

					ply.nutObsData = nil

					ply:SetNoDraw(false)
					ply:SetNotSolid(false)
					ply:DrawWorldModel(true)
					ply:DrawShadow(true)
					ply:GodDisable()
					ply:SetNoTarget(false)
				end

				return false
			end
		end
	end
end )


--[[ hook.Add( ( ulx and ulx.HOOK_ULXDONELOADING or "ULXLoaded" ), "StaffBlocker", function()
	hook.Add( "PhysgunPickup", "StaffBlocker", function( ply, ent )
		if ( IsValid( ent ) and ent:IsPlayer() ) then
			if ( ply.getChar ) then
				local character = ply:getChar()

				if ( character and character:getFaction() ~= FACTION_STAFF ) then
					return false
				end
			end
		end
	end, -19 )
end ) ]]