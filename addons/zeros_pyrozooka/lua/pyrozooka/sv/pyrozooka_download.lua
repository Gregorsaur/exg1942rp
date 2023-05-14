if CLIENT then return end

if pyrozooka.config.EnableResourceAddfile then

	pyrozooka = pyrozooka || {}
	pyrozooka.force = pyrozooka.force || {}

	function pyrozooka.force.AddDir( path )
				local files, folders = file.Find( path .. "/*", "GAME" )
				for k, v in pairs( files ) do
						resource.AddFile( path .. "/" .. v )
				end
				for k, v in pairs( folders ) do
						pyrozooka.force.AddDir( path .. "/" .. v )
				end
	end

	pyrozooka.force.AddDir("materials/particle")
	pyrozooka.force.AddDir("materials/pd_particles")
	pyrozooka.force.AddDir("materials/vgui")
	pyrozooka.force.AddDir("materials/zerochain/pyrozooka")
	pyrozooka.force.AddDir("models/zerochain/pyrozooka")
	pyrozooka.force.AddDir("particles")
	pyrozooka.force.AddDir("sound/pyrozooka")
else
	resource.AddWorkshop( "1241782764" ) //Pyrozooka Contentpack
end
