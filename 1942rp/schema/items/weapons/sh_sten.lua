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

ITEM.name = "Sten"
ITEM.desc = "A uniquely designed combact sub-machinegun from Britain."
ITEM.model = "models/khrcw2/doipack/w_stenmk2.mdl"
ITEM.class = "doi_atow_sten"
ITEM.weaponCategory = "primary"
ITEM.uniqueID = "sten"
ITEM.width = 3
ITEM.height = 2
ITEM.price = 3800
ITEM.noBusiness = true

ITEM.iconCam = {
	ang	= Angle(-0.020070368424058, 270.40155029297, 0),
	fov	= 7.2253324508038,
	pos	= Vector(0, 200, -1)
}
ITEM.holsterDrawInfo = {
    model = ITEM.model,
    bone = "ValveBiped.Bip01_Spine2",
    ang = Angle(20, 180, 0),
    pos = Vector(3, -4, -3),
}
