-- Inspired by xAdmin's solution to console entities :)
YAWS.ConsoleEnt = {}
YAWS.ConsoleEnt.IsConsole = true 

function YAWS.ConsoleEnt:GetUserGroup() 
    return "Console"
end 
function YAWS.ConsoleEnt:Name() 
    return "Console"
end 
function YAWS.ConsoleEnt:SteamID() 
    return "STEAM_0:0:0"
end 
function YAWS.ConsoleEnt:SteamID64() 
    return "0"
end 