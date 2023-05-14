--[[
    NutScript is free software you can redistribute it andor modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    NutScript is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with NutScript.  If not, see httpwww.gnu.orglicenses.
--]]
ITEM.name = "Maschinengewehr 34"
ITEM.desc = "Known as the spandau by the allies. This fast firing machine gun has a lower ammo capacity than its counterpart."
ITEM.model = "models/khrcw2/doipack/w_mg34.mdl"
ITEM.class = "doi_atow_mg34"
ITEM.weaponCategory = "primary"
ITEM.uniqueID = "mg34"
ITEM.width = 4
ITEM.height = 3
ITEM.price = 8500

ITEM.iconCam = {
    ang = Angle(-0.020070368424058, 270.40155029297, 0),
    fov = 7.2253324508038,
    pos = Vector(0, 200, -1)
}
HOLSTER_DRAWINFO["doi_atow_mg34"] = {
	pos = Vector(3, 2, -3),
	ang = Angle(0, 0, 180),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/khrcw2/doipack/w_mg34.mdl"
}

ITEM.flag = "v"
ITEM.category = "Black Market"