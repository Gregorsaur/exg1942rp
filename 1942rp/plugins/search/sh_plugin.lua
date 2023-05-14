-- "gamemodes\\1942rp\\plugins\\search\\sh_plugin.lua"
-- Retrieved by https://github.com/c4fe/glua-steal
FactionCantDoSearch = { FACTION_civy, FACTION_mafia, FACTION_staff, FACTION_ssver }
FactionCanBeSearched = { FACTION_civy, FACTION_mafia }
MinimumSearchDistance = 100
SearchTime = 5 // Seconds how long it takes to search
IllegalItems = { // Full Item Names
	["Zip Tie"] = 50, // How much money the cop gets
	["Drug Lab"] = 1000,
	["Generic Ammo"] = 25,
	["Poppy Seeds"] = 100,
	["Marijuana Seeds"] = 50,
	["Fake ID"] = 150,
	["Karabiner 98 Kurz"] = 1300,
	["Mauser C96"] = 800,
	["Maschinenpistole 40"] = 1900,
	["Walther P38"] = 920,
	["Sturmgewehr 44"] = 2750,
	["Marijuana"] = 400,
	["Meth"] = 410,
	["Heroin"] = 250,
	["Cocaine"] = 400,
}

nut.util.include("cl_searchvgui.lua")

nut.command.add("confiscate", {
	syntax = "",
	onRun = function(client, arguments)

		if (!client:getChar() || table.HasValue(FactionCantDoSearch, client:getChar():getFaction())) then
			nut.util.notify("Your character can't use this command.", client)
			return
		end
		
		local target
		local tr = client:GetEyeTrace()
		if (tr && IsValid(tr.Entity) && tr.Entity:IsPlayer() && tr.Entity:GetPos():DistToSqr(client:GetPos()) <= MinimumSearchDistance * MinimumSearchDistance) then
			target = tr.Entity
		else
			nut.util.notify("You aren't looking at a valid player.", client)
			return
		end
		
		if (!table.HasValue(FactionCanBeSearched, target:getChar():getFaction())) then
			nut.util.notify("You cannot search this faction.", client)
			return
		end
		
		if (!target:getNetVar("restricted")) then
			nut.util.notify("You can only search tied players.", client)
			return
		end
		
		if (IsValid(target) and target:getChar()) then
			if (IsValid(target.beingSearched)) then
				nut.util.notify("They are already being searched by someone else.", client)
				return
			end
			
			target.beingSearched = client
			client.searchingPlayer = target
			client:EmitSound("physics/plastic/plastic_barrel_strain"..math.random(1, 3)..".wav")
			client:setAction("Searching...", SearchTime)
			target:setAction("Being searched...", SearchTime)
			client:doStaredAction(target, function()
				nut.util.notify("You have been searched.", target)
				local chatPrint = nil
				local confiscated = {}
				local inv = target:getChar():getInv()
				inv:sync(client)
				inv.oldGetReceiver = inv.getReceiver
				inv.getReceiver = function(invSelf)
					return {target, client}
				end
				inv.oldAccess = inv.onCheckAccess
				inv.onCheckAccess = function(accessingInv, accessor)
					if (accessor == client) then return true end
				end
				netstream.Start(client, "DoPlayerSearch", target, target:getChar():getInv():getID())
				
			end, SearchTime, function()
				target:setAction()
				client:setAction()
				target.beingSearched = nil
			end, MinimumSearchDistance)
		end
	end
})

if (CLIENT) then
	netstream.Hook("DoPlayerSearch", function(target, index)
		local panel = vgui.Create("nutSearch")
		panel:ShowCloseButton(true)
		print(index, nut.item.inventories[index])
		panel:setInventory(nut.item.inventories[index])
		panel.searching = target
		panel.OnClose = function()
			netstream.Start("endSearch")
		end
		panel.oldThink = panel.Think
		
		panel.Think = function(self)
			self:oldThink()
			if (self.noThnk) then return end
			if (!IsValid(self.searching) || !self.searching:Alive()) then
				self.noThnk = true
				self:Close()
				return
			end
			
			local tr = LocalPlayer():GetEyeTrace()
			if (!IsValid(tr.Entity) || tr.Entity != self.searching || !tr.Entity:getNetVar("restricted") || tr.Entity:GetPos():DistToSqr(LocalPlayer():GetPos()) > MinimumSearchDistance* MinimumSearchDistance || !LocalPlayer():Alive() || !LocalPlayer():getChar() || !self.searching:getChar()) then
				self.noThnk = true
				self:Close()
				return
			end
		end
	end)
else
	netstream.Hook("endSearch", function(ply)
		local target = ply.searchingPlayer
		if (IsValid(target)) then
			local inv = target:getChar():getInv()
			inv.getReceiver = inv.oldGetReceiver
			inv.onCheckAccess = inv.oldAccess
			inv.oldGetReceiver = nil
			inv.oldAccess = nil
			target.beingSearched = nil
		end
		ply.searchingPlayer = nil
	end)
	
	netstream.Hook("confiscateItem", function(ply, itemID)
		if (IsValid(ply.searchingPlayer) && ply.searchingPlayer.beingSearched == ply) then
			local item = nut.item.instances[itemID]
			if (item && IllegalItems[item:getName()]) then
				local reward = (item:getData("boughtFor") or 0)/2
				nut.util.notify("You've received "..reward.." RM for confiscating "..item:getName(), ply)
				nut.util.notify("Your "..item:getName().. " has been confiscated.", ply.searchingPlayer)
				ply:getChar():giveMoney(reward)
				item:remove()
				netstream.Start(ply, "searchUpdate", itemID)
			end
		end
	end)
end

