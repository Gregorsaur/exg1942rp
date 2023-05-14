
PLUGIN.name = "Vehicle Locker"
PLUGIN.desc = "Allows players to lock their cars."
PLUGIN.author = ""

nut.command.add("carlock", {
	syntax = "",
	onRun = function( client, arguments )
		local trace = client:GetEyeTraceNoCursor()
		local ent = trace.Entity

		if ( ent and ent:IsValid() and ent:IsVehicle() ) then
			if ( ent.__WCDOwner == client or ent:GetOwner() == client or ( ent.CPPIGetOwner and ent:CPPIGetOwner() == client ) ) then
				ent.PluginLocked = true

				for k, v in pairs( ent:GetChildren() ) do
					v.PluginLocked = true
				end

				return "You've successfully locked your car"
			else
				return "You do not own this vehicle"
			end
		else
			return "This is not a vehicle"
		end
	end
})

nut.command.add("carunlock", {
	syntax = "",
	onRun = function( client, arguments )
		local trace = client:GetEyeTraceNoCursor()
		local ent = trace.Entity

		if ( ent and ent:IsValid() and ent:IsVehicle() ) then
			if ( ent.__WCDOwner == client or ent:GetOwner() == client or ( ent.CPPIGetOwner and ent:CPPIGetOwner() == client ) ) then
				ent.PluginLocked = false

				for k, v in pairs( ent:GetChildren() ) do
					v.PluginLocked = false
				end

				return "You've successfully unlocked your car"
			else
				return "You do not own this vehicle"
			end
		else
			return "This is not a vehicle"
		end
	end
})

if ( SERVER ) then
	hook.Add( "CanPlayerEnterVehicle", "kek", function( ply, veh )
		if ( veh.PluginLocked ) then
			return false
		end
	end )

	hook.Add( "PlayerUse", "some_unique_name2", function( ply, ent )
		if ( ent.PluginLocked ) then
			return false
		end
	end )
end