--[[
Server Name: Bootlegger's Boardwalk: Blood and Beer | Exclusive RP Server
Server IP:   172.93.101.67:27025
File Path:   gamemodes/prohibitionrp/plugins/better_crafting/items/blueprints/sh_b_morphinerecipe.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

ITEM.name = "Morphine Recipe"
ITEM.desc = "How to make Morphine."
ITEM.price = 2.16
ITEM.noBusiness = true

ITEM.requirements = {
	{"opium", 4},
}
ITEM.result = {
    {"morphine", 2},
}