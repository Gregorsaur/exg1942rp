
ITEM.name = "Lockpick"
ITEM.desc = "A tool used to open doors."
ITEM.price = 50
ITEM.model = "models/weapons/w_crowbar.mdl"
ITEM.flag = "v"
ITEM.category = "Black Market"

ITEM.functions.Use = {
	onRun = function(item)
		if (item.beingUsed) then
			return false
		end

		local ply = item.player
		local target = ply:GetEyeTrace().Entity
		if (!ply:getNetVar("restricted") && IsValid(target) and ((target:isDoor() && target:getNetVar("faction") != FACTION_staff) or target:IsVehicle())) then
			item.beingUsed = true
			local timerID = "Lockpicksnd"..ply:SteamID()
			timer.Create(timerID, 1, 30, function()
				if (!ply || !ply:getNetVar("isPicking")) then
					timer.Remove(timerID)
				else
					local snd = {1,3,4}
					ply:EmitSound("weapons/357/357_reload".. tostring(snd[math.random(1, #snd)]) ..".wav", 75, 100)
				end
			end)
			ply:setNetVar("isPicking", true)
			ply:setAction("Lockpicking", 30)
			ply:doStaredAction(target, function()
				item:remove()
				ply:EmitSound("doors/door_latch3.wav")
				target:Fire("unlock")
				if (target:IsVehicle() && target.IsSimfphyscar) then
					target.IsLocked = false
				end
				ply:setNetVar("isPicking")
				timer.Remove(timerID)
			end, 30, function()
				ply:setNetVar("isPicking")
				ply:setAction()
				item.beingUsed = false
				timer.Remove(timerID)
			end)
		else
			item.player:notifyLocalized("You can't lockpick that.")
		end

		return false
	end,
	onCanRun = function(item)
		return !IsValid(item.entity)
	end
}

function ITEM:onCanBeTransfered(inventory, newInventory)
	return !self.beingUsed
end