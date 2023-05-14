-- "gamemodes\\1942rp\\plugins\\points\\sh_plugin.lua"
-- Retrieved by https://github.com/c4fe/glua-steal
PLUGIN.name = "Loyalism"
PLUGIN.author = "Chancer"
PLUGIN.desc = "System for loyalist points."
 
 
if (SERVER) then
    function PLUGIN:PlayerLoadedChar(client)
        --this just makes sure everything is properly networked to clients.
        --kind of annoying and gross, but won't work otherwise.
        for k, v in pairs(player.GetAll()) do
            local char = v:getChar()
            if(char) then
                local point = char:getData("loyalPoint", 0)
                char:setData("loyalPoint", point, false, player.GetAll())
            end
        end
    end
end
   
--main command for loyalist points
nut.command.add("pointupdate", {
    adminOnly = false,
    syntax = "<string name> <string number>",
    onRun = function(client, arguments)
        local facts = { --need to be in one of these factions
            FACTION_waffen,
            FACTION_heer,
            FACTION_ssver,
            FACTION_sd,
            FACTION_police,
            FACTION_rsha,
            FACTION_heer,
            FACTION_feldgendar,
			FACTION_staff
        }
       
        local names = { --anyone with these names can do it if they're in the right faction
            "offizier",
            "führer",
            "Leutnant",
            "Major",
            "General",
            "sleiter",
            "Hauptman",
            "feldwebel",
            "Feldwebel",
            "Oberst",
            "jäger"
        }
   
        local char = client:getChar()
        local fact = false
        local name = false
       
		if (!char) then
			return "You must be on a character to use this"
		end
		
        for k, v in pairs(facts) do --checks if the player is in the right faction for this
            if(char:getFaction() == v) then
                fact = true
                break
            end
        end
       
        if(!fact && char:getFaction() != FACTION_staff) then --if they arent in the right faction
            client:notify("Your faction can't do that.")
            return
        end
       
        for k, v in pairs(names) do --checks if the player has any of the proper names for this
            if(string.find(client:Name(), v)) then
                name = true
                break
            end
        end
       
        if(!name && char:getFaction() != FACTION_staff) then --if they don't have the right rank in their name
            client:notify("You are not the proper rank for that.")
            return
        end
 
        local target = nut.command.findPlayer(client, arguments[1])
        if(!target) then
            client:notify("Invalid target.")
            return
        end
       
        local tChar = target:getChar()
       
        if(tChar) then
            if(tChar:getFaction() == FACTION_civy) then
                tChar:setData("loyalPoint", tChar:getData("loyalPoint", 0) + tonumber(arguments[2]), false, player.GetAll())
           
                client:notify("You have updated ".. target:Name() .. "'s loyalist points, they now have " .. tChar:getData("loyalPoint", 0) .. " loyalist points.")
       
                if(tonumber(arguments[2]) > 0) then --for
                    target:notify("You have received ".. arguments[2] .. " loyalist points from " .. client:Name() .. ".")
                else
                    target:notify(client:Name().. " has removed " .. arguments[2] .. " of your loyalist points.")
                end
            else
                client:notify("Target is not a member of the right faction.")
            end
        end
    end
})
 
if(CLIENT) then
    local COLOR_LEVEL = Color(200, 130, 80)
 
    function PLUGIN:DrawCharInfo(client, character, info)
        local level = math.Round(character:getData("loyalPoint", 0) / 5)
       
        level = math.Clamp(level, 0, 5)
       
        if(level > 0) then
            info[#info + 1] = {"Tier " .. level .. " Party Member.", COLOR_LEVEL}
        end
    end
end

