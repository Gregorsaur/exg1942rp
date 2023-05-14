--[[
gamemodes/1942rp/plugins/genericammo/items/sh_ammo_generic.lua
--]]
--[[
    NutScript is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    NutScript is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with NutScript.  If not, see <http://www.gnu.org/licenses/>.
--]]

ITEM.name = "Generic Ammo"
ITEM.model = "models/items/boxmrounds.mdl"
ITEM.ammoAmount = 60 // amount of the ammo
ITEM.price = 30
ITEM.desc = "A box that contains sixty bullets.\nUse items with the gun you want loaded out."
ITEM.category = "Ammunition"
ITEM.flag = "v"

local ignoreTable = {
        "weapon_crowbar",
        "weapon_stunstick",
        "weapon_physcannon",
        "weapon_physgun",
        "weapon_bugbait",
        "gmod_tool",
        "gmod_camera",
        "weapon_extinguisher",
        "swep_flamethrower",
        "weapon_gascan",
        "weapon_midascannon",
        "riotshield",
        "spiderman_swep",
        "m_cyclonetrap",
        "m_electrobolt",
        "m_incinerate",
        "m_insectswarm",
        "m_winterblast",
        "bb_css_knife",
        "weapon_axe",
        "weapon_bat",
        "weapon_keyboard",
        "weapon_shovel",
        "weapon_sledgehammer",
        "weapon_fists",
        "cutter",
        "weapon_glowstick",
        "weapon_glowstick_blu",
        "weapon_glowstick_lblu",
        "weapon_glowstick_rng",
        "weapon_glowstick_pnk",
        "weapon_glowstick_red",
        "weapon_glowstick_wht",
        "weapon_glowstick_ylw",
        "m9k_ied_detonator",
        "nut_hands",
        "nut_keys",
        "super_aug"
}

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		draw.SimpleText(item.ammoAmount, "DermaDefault", w , h - 5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)
	end
end

// On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.use = { -- sorry, for name order.
	name = "Load",
	tip = "useTip",
	icon = "icon16/add.png",
	onRun = function(item)
		local client = item.player
		
        weapon = client:GetActiveWeapon()
 
        if !IsValid(weapon) then return false end
       
        for p, q in pairs(ignoreTable) do
                if weapon:GetClass() == q then
                        client:PrintMessage(HUD_PRINTTALK, "This weapon may not be resupplied." )
                        client:EmitSound("Player.DenyWeaponSelection")
                return false end
        end
                       
        client:GiveAmmo( item.ammoAmount ,  weapon:GetPrimaryAmmoType(), false)
        client:PrintMessage(HUD_PRINTTALK, "You picked up some ammo." )
		client:EmitSound("items/ammo_pickup.wav", 110)
		
		return true
	end,
}

