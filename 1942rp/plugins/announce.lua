nut.command.add("adminannounce", {
	syntax = "<string message>",
	onRun = function(client, text)
	end,
	prefix = {"/adminannounce"},
})

if CLIENT then
    
	Announce = Announce or {}
	AnnounceNext = AnnounceNext or 1
	AnnounceLength = 20
	AnnounceSound = "buttons/button19.wav"
	
	net.Receive("sendAnnouncement", function()
		local announce = {
			admin = net.ReadString(),
			text = net.ReadString(),
			start = SysTime()
		}
		Announce[AnnounceNext] = announce
		AnnounceNext = AnnounceNext + 1
		
		if (AnnounceSound && AnnounceSound != "") then
			surface.PlaySound(AnnounceSound)
		end
	end)
	
	function string.wrapwords(Str,font,width)
		if( font ) then--Dr Magnusson's much less prone to failure and more optimized version
			surface.SetFont( font )  
		end 
		
		local tbl, len, Start, End = {}, string.len( Str ), 1, 1
		
		while ( End < len ) do  
			End = End + 1
			if ( surface.GetTextSize( string.sub( Str, Start, End ) ) > width ) then
			local n = string.sub( Str, End, End )  
			local I = 0
			for i = 1, 15
				do  
					I = i  
					if( n != " "and n != ","and n != "."and n != "\n" ) then  
						End = End - 1  
						n = string.sub( Str, End, End )  
					else
						break
					end
				end
				
				if( I == 15 ) then  
					End = End + 14
				end
				
				local FnlStr = string.Trim( string.sub( Str, Start, End ) )  
				table.insert( tbl, FnlStr )  
				Start = End + 1
			end
		end
		table.insert( tbl, string.sub( Str, Start, End ) )  
		return tbl
	end
	
	hook.Add("HUDPaint", "Announce::HUDPaint", function()
		local cols = {
			bg = Color( 37, 37, 37 ),
			purple = Color( 2, 79, 99 ),
		}
		
		local activeAnnouncements = {}
		local deadKeys = {}
		for i=1,AnnounceNext-1 do
			if (Announce[i]) then
				if (SysTime() - Announce[i].start >= AnnounceLength) then
					Announce[i] = nil
				else
					table.insert(activeAnnouncements, 1, Announce[i])
				end
			end
		end
		
		local buffer = 0
		local startPoint = ScrH()/2-200
		local announceWidth = 900
		for k,v in pairs(activeAnnouncements) do
			local textWrapped = string.wrapwords(v.text, "DermaLarge", announceWidth)
			
			local delta = SysTime() - v.start
			local alpha = 255
			if (delta < 0.5) then -- Animation
				alpha = Lerp(delta*2, 0, 255)
			elseif (delta > AnnounceLength - 0.5) then
				alpha = Lerp((delta - AnnounceLength + 0.5)*2, 255, 0)
			end
			
			surface.SetFont("DermaLarge")
			local t_w, t_h = surface.GetTextSize("Admin Announcement")
			
			surface.SetDrawColor(Color(cols.bg.r,cols.bg.g, cols.bg.b, alpha))
			surface.DrawRect(ScrW()/2 - announceWidth/2 - 4, startPoint + buffer - 4, announceWidth + 8, t_h * (#textWrapped + 1) + 8)
			
			surface.SetDrawColor(Color(cols.purple.r,cols.purple.g, cols.purple.b, alpha))
			surface.DrawRect(ScrW()/2 - announceWidth/2 - 2, startPoint + buffer - 2, announceWidth + 4, t_h)
			
			draw.SimpleText("Important Announcement:", "DermaLarge", ScrW()/2, startPoint + buffer, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			
			local localbuffer = t_h
			for k,v in pairs(textWrapped) do
				draw.SimpleText(v, "DermaLarge", ScrW()/2, startPoint + localbuffer + buffer, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
				localbuffer = localbuffer + t_h
			end
			
			v.buffer_add = t_h * (#textWrapped + 1) + 8 + 5
			buffer = buffer + Lerp(delta * 2, 0, v.buffer_add)
		end

	end)
end