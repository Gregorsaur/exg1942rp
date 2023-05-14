
if true then return end

local PLUGIN = PLUGIN
PLUGIN.name = "Waypoints"
PLUGIN.author = "rusty"

PLUGIN.Waypoints = {
	["Bank"] = Vector(-6540.177246 5712.160645 7468.211426),
	["Mines"] = Vector(-6858.966309 1489.044556 7400.961426),
	["Fishing Docks"] = Vector(-9349.157227 600.745056 7302.007813),
	["Hospital"] = Vector(-12027.667969 9120.570313 7350.854492),
	["Car Dealership"] = Vector(-9732.826172 4483.673828 7347.456055),
	["General Store"] = Vector(-4260.866211 6527.079102 7461.604980),
	["Clothing Store"] = Vector(-4260.866211 6527.079102 7461.604980),
	["Reichstag"] = Vector(-6527.303711 8465.141602 7649.557617),
	["LSS Compound"] = Vector(1034.889038 13684.739258 7477.281250),
	["Bendlerblock"] = Vector(-8703.869141 7355.637207 7462.375488),
	["Wehrkries III Compound"] = Vector(-8775.737305 -3129.312256 7922.744629),
	["Polizei Station"] = Vector(-4245.365723 9490.360352 7522.859863),
	["Innenministerium (MOI)"] = Vector(-2251.775635 12058.197266 7465.580078),
	["RSHA Building"] = Vector(1485.208252 9085.128906 7520.303223),
}

if CLIENT then
	function PLUGIN:CreateMenuButtons(tabs)
		tabs["Waypoints"] = function(panel)
			panel:Add("nutWaypoints")
		end
	end

	/*
		Panel
	*/

	local PANEL = {}

	function PANEL:Init()
		self:SetSize(self:GetParent():GetSize())

		self.list = vgui.Create("DPanelList", self)
		self.list:Dock(FILL)
		self.list:EnableVerticalScrollbar()
		self.list:SetSpacing(5)
		self.list:SetPadding(5)

		for name,vec in next, PLUGIN.Waypoints do
			local btn = self.list:Add("DButton")
			btn:SetText(name)
			btn:Dock(TOP)
			function btn:DoClick()
				for hookName,func in next, hook.GetTable().HUDPaint do
					if isstring(hookName) and hookName:find("WeighPoint") then
						hook.Remove("HUDPaint", hookName)
					end
				end
				
				nut.util.notify(name.. " has been marked on your screen. Follow the waypoint to get to the destination.")
				LocalPlayer():SetWeighPoint(name, vec, function()
					nut.util.notify("You have arrived at the "..name..".")
				end)
			end
		end

		local removeWaypoints = self.list:Add("DButton")
		removeWaypoints:SetText("Remove Waypoint")
		removeWaypoints:Dock(TOP)
		function removeWaypoints:DoClick()
			for hookName,func in next, hook.GetTable().HUDPaint do
				if isstring(hookName) and hookName:find("WeighPoint") then
					hook.Remove("HUDPaint", hookName)
				end
			end
		end
	end

	vgui.Register("nutWaypoints", PANEL, "EditablePanel")
end