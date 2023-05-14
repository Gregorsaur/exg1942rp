PLUGIN.name = "Lockers"
PLUGIN.author = "Joshpai & Rook"
PLUGIN.desc = "Port of rook_lockers to a nutscript plugin."

Locker_List = {}

Locker_List[ "Kar98k" ] = { 
Name = "Kar98k",
Description = "Standard issue bolt action rifle.",
Model = "models/khrcw2/doipack/w_kar98k.mdl",
LockerFunction = function( ply ) 
	ply:Give("doi_atow_k98k")
	end,
}

Locker_List[ "Walther p38" ] = { 
Name = "Walther p38",
Description = "Standard issue sidearm.",
Model = "models/khrcw2/doipack/w_p38.mdl",
LockerFunction = function( ply ) 
	ply:Give("doi_atow_p38")
	end,
}

Locker_List[ "mp34" ] = { 
Name = "mp34",
Description = "Standard issue submachine gun.",
Model = "models/khrcw2/doipack/w_mp34.mdl",
LockerFunction = function( ply ) 
	ply:Give("doi_ws_atow_mp34")
	end,
}

Locker_List[ "ppk" ] = { 
Name = "ppk",
Description = "Standard issue sidearm.",
Model = "models/khrcw2/doipack/w_ppk.mdl",
LockerFunction = function( ply ) 
	ply:Give("doi_atow_ppk")
	end,
}


Locker_List[ "radio" ] = { 
Name = "Radio",
Description = "A Radio used for long distance communicating via radio waves.",
Model = "models/gibs/shield_scanner_gib1.mdl",
LockerFunction = function( ply ) 
  local char = ply:getChar()
  local inv = char:getInv()

  if (IsValid(ply) and char) then
    inv:add("radio")
  end
end
}

Locker_List[ "zipties" ] = { 
Name = "Zip Ties",
Description = "A pair of Zip Ties used in the process of restraining individuals.",
Model = "models/items/crossbowrounds.mdl",
LockerFunction = function( ply ) 
  local char = ply:getChar()
  local inv = char:getInv()

  if (IsValid(ply) and char) then
    inv:add("tie")
  end
end
}

Locker_List[ "Ammo" ] = { 
Name = "Ammo",
Description = "Ammunition for Guns.",
Model = "models/items/boxmrounds.mdl",
LockerFunction = function( ply ) 
  local char = ply:getChar()
  local inv = char:getInv()

  if (IsValid(ply) and char) then
    inv:add("ammo_generic")
  end
end
}


Locker_List_Swat = {}

Locker_List_Swat[ "Kar98k" ] = { 
Name = "Kar98k",
Description = "Standard issue bolt action rifle.",
Model = "models/khrcw2/doipack/w_kar98k.mdl",
LockerFunction = function( ply ) 
	ply:Give("doi_atow_k98k")
	end,
}

Locker_List_Swat[ "Walther p38" ] = { 
Name = "Walther p38",
Description = "Standard issue sidearm.",
Model = "models/khrcw2/doipack/w_p38.mdl",
LockerFunction = function( ply ) 
	ply:Give("doi_atow_p38")
	end,
}

Locker_List_Swat[ "p08 Luger" ] = { 
Name = "p08 Luger",
Description = "Standard issue sidearm.",
Model = "models/khrcw2/doipack/w_lugerp08.mdl",
LockerFunction = function( ply ) 
	ply:Give("doi_atow_p08")
	end,
}

Locker_List_Swat[ "mp34" ] = { 
Name = "mp34",
Description = "Standard issue submachine gun.",
Model = "models/khrcw2/doipack/w_mp34.mdl",
LockerFunction = function( ply ) 
	ply:Give("doi_ws_atow_mp34")
	end,
}

Locker_List_Swat[ "MG34" ] = { 
Name = "MG34",
Description = "Standard Heavy Machine Gun.",
Model = "models/khrcw2/doipack/w_mg34.mdl",
LockerFunction = function( ply ) 
	ply:Give("doi_atow_mg34")
	end,
}


Locker_List_Swat[ "radio" ] = { 
Name = "Radio",
Description = "A Radio used for long distance communicating via radio waves.",
Model = "models/gibs/shield_scanner_gib1.mdl",
LockerFunction = function( ply ) 
  local char = ply:getChar()
  local inv = char:getInv()

  if (IsValid(ply) and char) then
    inv:add("radio")
  end
end
}

Locker_List_Swat[ "zipties" ] = { 
Name = "Zip Ties",
Description = "A pair of Zip Ties used in the process of restraining individuals.",
Model = "models/items/crossbowrounds.mdl",
LockerFunction = function( ply ) 
  local char = ply:getChar()
  local inv = char:getInv()

  if (IsValid(ply) and char) then
    inv:add("tie")
  end
end
}

Locker_List_Swat[ "Ammo" ] = { 
Name = "Ammo",
Description = "Ammunition for Guns.",
Model = "models/items/boxmrounds.mdl",
LockerFunction = function( ply ) 
  local char = ply:getChar()
  local inv = char:getInv()

  if (IsValid(ply) and char) then
    inv:add("ammo_generic")
  end
end
}


Locker_List_Navy = {}


Locker_List_Navy[ "Kar98k" ] = { 
Name = "Kar98k",
Description = "Standard issue bolt action rifle.",
Model = "models/khrcw2/doipack/w_kar98k.mdl",
LockerFunction = function( ply ) 
	ply:Give("doi_atow_k98k")
	end,
}

Locker_List_Navy[ "Walther p38" ] = { 
Name = "Walther p38",
Description = "Standard issue sidearm.",
Model = "models/khrcw2/doipack/w_p38.mdl",
LockerFunction = function( ply ) 
	ply:Give("doi_atow_p38")
	end,
}

Locker_List_Navy[ "p08 Luger" ] = { 
Name = "p08 Luger",
Description = "Standard issue sidearm.",
Model = "models/khrcw2/doipack/w_lugerp08.mdl",
LockerFunction = function( ply ) 
	ply:Give("doi_atow_p08")
	end,
}

Locker_List_Navy[ "ppk" ] = { 
Name = "ppk",
Description = "Standard issue sidearm.",
Model = "models/khrcw2/doipack/w_ppk.mdl",
LockerFunction = function( ply ) 
	ply:Give("doi_atow_ppk")
	end,
}

Locker_List_Navy[ "mp40" ] = { 
Name = "mp40",
Description = "Standard issue submachine gun.",
Model = "models/khrcw2/doipack/w_mp40.mdl",
LockerFunction = function( ply ) 
	ply:Give("doi_atow_mp40")
	end,
}


Locker_List_Navy[ "radio" ] = { 
Name = "Radio",
Description = "A Radio used for long distance communicating via radio waves.",
Model = "models/gibs/shield_scanner_gib1.mdl",
LockerFunction = function( ply ) 
  local char = ply:getChar()
  local inv = char:getInv()

  if (IsValid(ply) and char) then
    inv:add("radio")
  end
end
}

Locker_List_Navy[ "zipties" ] = { 
Name = "Zip Ties",
Description = "A pair of Zip Ties used in the process of restraining individuals.",
Model = "models/items/crossbowrounds.mdl",
LockerFunction = function( ply ) 
  local char = ply:getChar()
  local inv = char:getInv()

  if (IsValid(ply) and char) then
    inv:add("tie")
  end
end
}

Locker_List_Navy[ "Ammo" ] = { 
Name = "Ammo",
Description = "Ammunition for Guns.",
Model = "models/items/boxmrounds.mdl",
LockerFunction = function( ply ) 
  local char = ply:getChar()
  local inv = char:getInv()

  if (IsValid(ply) and char) then
    inv:add("ammo_generic")
  end
end
}

if (SERVER) then
	util.AddNetworkString("Mission_Start_2")
	util.AddNetworkString("Mission_Start_22")
	util.AddNetworkString("Mission_Start_222")

	net.Receive('Mission_Start_2', function(length, ply)
	local locker = net.ReadString()
	Locker_List[locker].LockerFunction( ply, locker )

				
	ply:notify("You have taken a(n) " .. Locker_List[locker].Name .. " from the locker.")


	end)

	net.Receive('Mission_Start_22', function(length, ply)
	local locker = net.ReadString()
	Locker_List_Swat[locker].LockerFunction( ply, locker )

				
	ply:notify("You have taken a(n) " .. Locker_List_Swat[locker].Name .. " from the locker.")


	end)

	net.Receive('Mission_Start_222', function(length, ply)
	local locker = net.ReadString()
	Locker_List_Navy[locker].LockerFunction( ply, locker )

				
	ply:notify("You have taken a(n) " .. Locker_List_Navy[locker].Name .. " from the locker.")


	end)


	--hook.Add("OnNPCKilled", "NPCReward", function(npc, attacker, inflictor ) 
	--attacker:notify("Mission started, follow waypoint")

	--end)
end