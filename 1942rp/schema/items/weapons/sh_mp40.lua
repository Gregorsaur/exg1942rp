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

ITEM.name = "Maschinenpistole 40"
ITEM.desc = "A popular and well-made submachine gun, used by all branches and institutions."
ITEM.model = "models/khrcw2/doipack/w_mp40.mdl"
ITEM.class = "doi_atow_mp40"
ITEM.weaponCategory = "primary"
ITEM.uniqueID = "mp40"
ITEM.width = 3
ITEM.height = 2
ITEM.price = 2800
ITEM.iconCam = {
	ang	= Angle(-0.020070368424058, 270.40155029297, 0),
	fov	= 7.2253324508038,
	pos	= Vector(0, 200, -1)
}
HOLSTER_DRAWINFO["doi_atow_mp40"] = {
	pos = Vector(3, 2, -3),
	ang = Angle(0, 0, 180),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/khrcw2/doipack/w_mp40.mdl"
}
ITEM.flag = "v"
ITEM.category = "Black Market"
