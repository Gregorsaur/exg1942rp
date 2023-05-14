if !SERVER then return end

pyrozooka = pyrozooka || {}

function pyrozooka_Notify( ply, msg, ntfType )
	if pyrozooka.config.RunOnDarkRP then
		DarkRP.notify( ply, ntfType, 5, msg )
	else
		ply:ChatPrint(msg)
	end
end
