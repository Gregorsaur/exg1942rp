-- developed for gmod.store
-- from incredible-gmod.ru with love <3
-- https://www.gmodstore.com/market/view/7624 ok

POLAROID_CONFIG = {}

hook.Add("Polaroid/ConfigLoaded", "Polaroid/InitLoading", function()
	local files = file.Find("polaroid_langs/*.lua", "LUA")
	local langs = {}

	for i, fname in pairs(files) do
		langs[fname:sub(1, #fname - 4)] = true
	end

	local LANG = langs[POLAROID_CONFIG.Language] and POLAROID_CONFIG.Language or "default"
	local path = "polaroid_langs/".. LANG ..".lua"
	AddCSLuaFile(path)
	LANG = include(path) or {}

	function PolaroidLANG(str)
		return LANG[str] or str
	end

	hook.Run("Polaroid/LangsLoaded")
end)

if CLIENT then
	POLAROID_CONFIG.Stickers = {}
	
	function POLAROID_CONFIG:AddStickers(name, stickers, customcheck)
		self.Stickers[name] = {
			Stickers = stickers,
			CustomCheck = customcheck,
		}
	end
else
	function POLAROID_CONFIG:AddStickers() end
end

AddCSLuaFile("polaroid/cl_menu.lua")
AddCSLuaFile("polaroid/cl_editor.lua")
AddCSLuaFile("polaroid_cfg.lua")
include("polaroid_cfg.lua")

if SERVER then
	resource.AddWorkshop("2456881554") -- content (sounds, materials, models)
else
	include("polaroid/cl_menu.lua")
	include("polaroid/cl_editor.lua")
end

hook.Run("Polaroid/Loaded")

-- temporary detour until Slawer adds a fix to his addon.
-- I found a solution to fix this incompatibility issue with many addons and informed Slawer, so he will add this fix to his addon soon.

if SERVER then return end

local function Fix(identifier)
	local hooks = hook.GetTable().GUIMousePressed
	if not hooks then return end

	local cback = hooks[identifier]
	if cback then
		hook.Add("VGUIMousePressed", identifier, function(_, key)
			cback(key)
		end)
		hook.Remove("GUIMousePressed", identifier)
	end
end

hook.Add("InitPostEntity", "incredible-gmod.ru/FixСompatibilityIssueWithSlaverMayorSystem", function()
	Fix("Slawer.Mayor:VGUI3D2DMousePress")
	Fix("Slawer.Mayor:VGUI3D2DMouseRelease")
end)