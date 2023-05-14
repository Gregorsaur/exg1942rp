local PLUGIN = PLUGIN
PLUGIN.name = "Super Admin Commands"
PLUGIN.author = "Chancer"
PLUGIN.desc = "Changes some default NS commands into SA only commands for ServerGuard."

local founderRanks = {
	founder = true
}

local superRanks = {
	founder = true,
	superadmin = true
}

local adminRanks = {
	founder = true,
	superadmin = true,
	management = true,
	senioradmin = true,
	admin = true,
	junioradmin = true
}

local modRanks = {
	founder = true,
	superadmin = true,
	management = true,
	senioradmin = true,
	admin = true,
	junioradmin = true,
	moderator = true,
	juniormoderator = true
}

local trustedRanks = {
	founder = true,
	superadmin = true,
	management = true,
	senioradmin = true,
	admin = true,
	junioradmin = true,
	moderator = true,
	juniormoderator = true,
	plat = true,
	trusted = true

}

nut.command.add("chargiveitem", {
	adminOnly = true,
	syntax = "<string name> <string item>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!superRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		
		if (!arguments[2]) then
			return L("invalidArg", client, 2)
		end

		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) and target:getChar()) then
			local uniqueID = arguments[2]:lower()

			if (!nut.item.list[uniqueID]) then
				for k, v in SortedPairs(nut.item.list) do
					if (nut.util.stringMatches(v.name, uniqueID)) then
						uniqueID = k

						break
					end
				end
			end

			local inv = target:getChar():getInv()
			local succ, err = target:getChar():getInv():add(uniqueID)

			if (succ) then
				target:notifyLocalized("itemCreated")
				if(target != client) then
					client:notifyLocalized("itemCreated")
				end
			else
				target:notify(tostring(succ))
				target:notify(tostring(err))
			end
		end
	end
})

nut.command.add("cleanitems", {
    adminOnly = true,
    onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!modRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
 
    for k, v in pairs(ents.FindByClass("nut_item")) do
       
        v:Remove()
       
    end
        client:notify("All items have been cleaned up from the map.")
    end
})

nut.command.add("textadd", {
	adminOnly = true,
	syntax = "<string text> [number scale]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!founderRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		
		-- Get the position and angles of the text.
		local trace = client:GetEyeTrace()
		local position = trace.HitPos
		local angles = trace.HitNormal:Angle()
		angles:RotateAroundAxis(angles:Up(), 90)
		angles:RotateAroundAxis(angles:Forward(), 90)
		
		-- Add the text.
		PLUGIN:addText(position + angles:Up()*0.1, angles, arguments[1], tonumber(arguments[2]))

		-- Tell the player the text was added.
		return L("textAdded", client)
	end
})

nut.command.add("textremove", {
	adminOnly = true,
	syntax = "[number radius]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!founderRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
	
		-- Get the origin to remove text.
		local trace = client:GetEyeTrace()
		local position = trace.HitPos + trace.HitNormal*2
		-- Remove the text(s) and get the amount removed.
		local amount = PLUGIN:removeText(position, tonumber(arguments[1]))

		-- Tell the player how many texts got removed.
		return L("textRemoved", client, amount)
	end
})

nut.command.add("charsetdesc", {
	syntax = "<string name> <string desc>",
	adminOnly = true,
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!modRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])
		if (!IsValid(target)) then return end
		if (!target:getChar()) then
			return "No character loaded"
		end
		
		local arg = table.concat(arguments, " ", 2)

		if (!arg:find("%S")) then
			return client:requestString("Change " .. target:Nick() .. "'s Description", "Enter new description", function(text)
				nut.command.run(client, "charsetdesc", {arguments[1], text})
			end, target:getChar():getDesc())
		end

		local info = nut.char.vars.desc
		local result, fault, count = info.onValidate(arg)

		if (result == false) then
			return "@"..fault, count
		end

		target:getChar():setDesc(arg)

		return "Successfully changed " .. target:Nick() .. "'s description"
	end
})

nut.command.add("charsetattrib", {
	adminOnly = true,
	syntax = "<string charname> <string attribname> <number level>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!founderRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local attribName = arguments[2]
		if (!attribName) then
			return L("invalidArg", client, 2)
		end

		local attribNumber = arguments[3]
		attribNumber = tonumber(attribNumber)
		if (!attribNumber or !isnumber(attribNumber)) then
			return L("invalidArg", client, 3)
		end

		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target)) then
			local char = target:getChar()
			if (char) then
				for k, v in pairs(nut.attribs.list) do
					if (nut.util.stringMatches(L(v.name, client), attribName) or nut.util.stringMatches(k, attribName)) then
						char:setAttrib(k, math.abs(attribNumber))
						client:notifyLocalized("attribSet", target:Name(), L(v.name, client), math.abs(attribNumber))

						return
					end
				end
			end
		end
	end
})

nut.command.add("charaddattrib", {
	adminOnly = true,
	syntax = "<string charname> <string attribname> <number level>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!founderRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local attribName = arguments[2]
		if (!attribName) then
			return L("invalidArg", client, 2)
		end

		local attribNumber = arguments[3]
		attribNumber = tonumber(attribNumber)
		if (!attribNumber or !isnumber(attribNumber)) then
			return L("invalidArg", client, 3)
		end

		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target)) then
			local char = target:getChar()
			if (char) then
				for k, v in pairs(nut.attribs.list) do
					if (nut.util.stringMatches(L(v.name, client), attribName) or nut.util.stringMatches(k, attribName)) then
						char:updateAttrib(k, math.abs(attribNumber))
						client:notifyLocalized("attribUpdate", target:Name(), L(v.name, client), math.abs(attribNumber))

						return
					end
				end
			end
		end
	end
})

nut.command.add("charsetmoney", {
	adminOnly = true,
	syntax = "<string target> <number amount>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!superRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end		
	
		local amount = tonumber(arguments[2])

		if (!amount or !isnumber(amount) or amount < 0) then
			return "@invalidArg", 2
		end

		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target)) then
			local char = target:getChar()
			
			if (char and amount) then
				amount = math.Round(amount)
				char:setMoney(amount)
				client:notifyLocalized("setMoney", target:Name(), nut.currency.get(amount))
			end
		end
	end
})

nut.command.add("mapsceneremove", {
	adminOnly = true,
	syntax = "[number radius]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!founderRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end			
	
		local radius = tonumber(arguments[1]) or 280
		local position = client:GetPos()
		local i = 0

		for k, v in pairs(PLUGIN.scenes) do
			local delete = false

			if (type(k) == "Vector") then
				if (k:Distance(position) <= radius or v[1]:Distance(position) <= radius) then
					delete = true
				end
			elseif (v[1]:Distance(position) <= radius) then
				delete = true
			end

			if (delete) then
				netstream.Start(nil, "mapScnDel", k)
				PLUGIN.scenes[k] = nil

				i = i + 1
			end
		end

		if (i > 0) then
			PLUGIN:SaveScenes()
		end

		return L("mapDel", client, i)
	end
})

nut.command.add("areaadd", {
	adminOnly = true,
	syntax = "<string name>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!founderRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end			
	
		local name = table.concat(arguments, " ") or "Area"

		local pos = client:GetEyeTraceNoCursor().HitPos

		if (!client:getNetVar("areaMin")) then
			if (!name) then
				nut.util.Notify(nut.lang.Get("missing_arg", 1), client)

				return
			end
			netstream.Start(client, "displayPosition", pos)

			client:setNetVar("areaMin", pos, client)
			client:setNetVar("areaName", name, client)

			return "@areaCommand"
		else
			local min = client:getNetVar("areaMin")
			local max = pos
			local name = client:getNetVar("areaName")

			netstream.Start(client, "displayPosition", pos)

			client:setNetVar("areaMin", nil, client)
			client:setNetVar("areaName", nil, client)

			nut.area.addArea(name, min, max)
			
			return "@areaAdded", name
		end
	end
})

nut.command.add("arearemove", {
	adminOnly = true,
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!founderRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end			
	
		local areaID = client:getArea()

		if (!areaID) then
			return
		end

		local areaData = nut.area.getArea(areaID)

		if (areaData) then
			table.remove(PLUGIN.areaTable, areaID)
			PLUGIN:saveAreas()

			return "@areaRemoved", areaData.name
		end
	end
})

nut.command.add("areachange", {
	adminOnly = true,
	syntax = "<string name>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!founderRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end			
	
		local name = table.concat(arguments, " ") or "Area"
		local areaID = client:getArea()

		if (!areaID) then
			return
		end

		local areaData = nut.area.getArea(areaID)

		if (areaData) then
			areaData.name = name
			PLUGIN:saveAreas()

			return "@areaChanged", name, areaData.name
		end
	end
})

nut.command.add("areamanager", {
	adminOnly = true,
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!founderRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end			
	
		if (client:Alive()) then
			netstream.Start(client, "nutAreaManager", nut.area.getAllArea())
		end
	end
})

nut.command.add("paneladd", {
	adminOnly = true,
	syntax = "<string url> [number w] [number h] [number scale]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!founderRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end			
	
		if (!arguments[1]) then
			return L("invalidArg", 1)
		end

		-- Get the position and angles of the panel.
		local trace = client:GetEyeTrace()
		local position = trace.HitPos
		local angles = trace.HitNormal:Angle()
		angles:RotateAroundAxis(angles:Up(), 90)
		angles:RotateAroundAxis(angles:Forward(), 90)
		
		-- Add the panel.
		PLUGIN:addPanel(position + angles:Up()*0.1, angles, arguments[1], tonumber(arguments[2]), tonumber(arguments[3]), tonumber(arguments[4]))

		-- Tell the player the panel was added.
		return L("panelAdded", client)
	end
})

nut.command.add("panelremove", {
	adminOnly = true,
	syntax = "[number radius]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!founderRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end			
	
		-- Get the origin to remove panel.
		local trace = client:GetEyeTrace()
		local position = trace.HitPos
		-- Remove the panel(s) and get the amount removed.
		local amount = PLUGIN:removePanel(position, tonumber(arguments[1]))

		-- Tell the player how many panels got removed.
		return L("panelRemoved", client, amount)
	end
})

nut.command.add("plytransfer", {
	syntax = "<string name> <string faction>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!trustedRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])
		local name = table.concat(arguments, " ", 2)

		if (IsValid(target) && target == client && uniqueID == "plat") then
			return "Your rank cannot target itself with these commands."
		end
		
		if (IsValid(target) and target:getChar()) then
			local faction = nut.faction.teams[name]

			if (!faction) then
				for k, v in pairs(nut.faction.indices) do
					if (nut.util.stringMatches(L(v.name, client), name)) then
						faction = v

						break
					end
				end
			end

			if (faction) then
				target:getChar().vars.faction = faction.uniqueID
				target:getChar():setFaction(faction.index)

				if (faction.onTransfered) then
					faction:onTransfered(target)
				end

				client:notify("You have transferred " .. target:Name() .. " to " .. faction.name)
				target:notify("You have been transferred to " .. faction.name .. " by " .. client:Name())
			else
				return "@invalidFaction"
			end
		end
	end
})

nut.command.add("charsetname", {
	syntax = "<string name> [string newName]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!trustedRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) && target == client && uniqueID == "plat") then
			return "Your rank cannot target itself with these commands."
		end
		
		if (IsValid(target) and !arguments[2]) then
			return client:requestString("@chgName", "@chgNameDesc", function(text)
				nut.command.run(client, "charsetname", {target:Name(), text})
			end, target:Name())
		end

		table.remove(arguments, 1)

		local targetName = table.concat(arguments, " ")

		if (IsValid(target) and target:getChar()) then
			nut.util.notifyLocalized("cChangeName", client:Name(), target:Name(), targetName)

			target:getChar():setName(targetName:gsub("#", "#?"))
		end
	end
})

nut.command.add("charsetmodel", {
	syntax = "<string name> <string model>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!trustedRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		
		if (!arguments[2]) then
			return L("invalidArg", client, 2)
		end

		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) && target == client && uniqueID == "plat") then
			return "Your rank cannot target itself with these commands."
		end
		
		if (IsValid(target) and target:getChar()) then
			target:getChar():setModel(arguments[2])
			target:SetupHands()

			nut.util.notifyLocalized("cChangeModel", {client, target}, client:Name(), target:Name(), arguments[2])
		end
	end
})

nut.command.add("charsetskin", {
	syntax = "<string name> [number skin]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!trustedRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		
		local skin = tonumber(arguments[2])
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) && target == client && uniqueID == "plat") then
			return "Your rank cannot target itself with these commands."
		end
		
		if (IsValid(target) and target:getChar()) then
			target:getChar():setData("skin", skin)
			target:SetSkin(skin or 0)

			nut.util.notifyLocalized("cChangeSkin", {client, target}, client:Name(), target:Name(), skin or 0)
		end
	end
})

nut.command.add("charsetbodygroup", {
	syntax = "<string name> <string bodyGroup> [number value]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!trustedRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		
		local value = tonumber(arguments[3])
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) && target == client && uniqueID == "plat") then
			return "Your rank cannot target itself with these commands."
		end
		
		if (IsValid(target) and target:getChar()) then
			local index = target:FindBodygroupByName(arguments[2])

			if (index > -1) then
				if (value and value < 1) then
					value = nil
				end

				local groups = target:getChar():getData("groups", {})
					groups[index] = value
				target:getChar():setData("groups", groups)
				target:SetBodygroup(index, value or 0)

				nut.util.notifyLocalized("cChangeGroups", {client, target}, client:Name(), target:Name(), arguments[2], value or 0)
			else
				return "@invalidArg", 2
			end
		end
	end
})

nut.command.add("charban", {
	syntax = "<string name>",
	adminOnly = true,
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!adminRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target)) then
			local char = target:getChar()

			if (char) then
				nut.util.notifyLocalized("charBan", client:Name(), target:Name())
				
				char:setData("banned", true)
				char:setData("charBanInfo", { name = client.SteamName and client:SteamName() or client:Nick(), steamID = client:SteamID(), rank = client:GetUserGroup() })
				char:save()
				char:kick()
			end
		end
	end
})

nut.command.add("charunban", {
	syntax = "<string name>",
	adminOnly = true,
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!superRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end

		if ((client.nutNextSearch or 0) >= CurTime()) then
			return L("charSearching", client)
		end

		local name = table.concat(arguments, " ")

		for k, v in pairs(nut.char.loaded) do
			if (nut.util.stringMatches(v:getName(), name)) then
				if (v:getData("banned")) then
					v:setData("banned")
					v:setData("charBanInfo")
				else
					return "@charNotBanned"
				end

				return nut.util.notifyLocalized("charUnBan", nil, client:Name(), v:getName())
			end
		end

		client.nutNextSearch = CurTime() + 15

		nut.db.query("SELECT _id, _name, _data FROM nut_characters WHERE _name LIKE \"%"..nut.db.escape(name).."%\" LIMIT 1", function(data)
			if (data and data[1]) then
				local charID = tonumber(data[1]._id)
				local name = data[1]._name
				local data = util.JSONToTable(data[1]._data or "[]")

				client.nutNextSearch = 0

				if (!data.banned) then
					return client:notifyLocalized("charNotBanned")
				end

				data.banned = nil
				
				nut.db.updateTable({_data = data}, nil, nil, "_id = "..charID)
				nut.util.notifyLocalized("charUnBan", nil, client:Name(), v:getName())
			end
		end)
	end
})

nut.command.add("clearinv", {
	adminOnly = true,
	syntax = "<string name>",
	onRun = function (client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!superRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])
		
		if (IsValid(target) and target:getChar()) then
			for k, v in pairs(target:getChar():getInv():getItems()) do
				v:remove()
			end

			client:notifyLocalized("resetInv", target:getChar():getName())
		end
	end
})

nut.command.add("logs", {
	adminOnly = false,
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!modRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		client:ConCommand("mlogs")
end
})

if (SERVER) then
	util.AddNetworkString("adminSpawnMenu")
	util.AddNetworkString("adminSpawnItem")

	net.Receive("adminSpawnItem", function(len, client)
		local name = net.ReadString()
		for k, v in pairs(nut.item.list) do
			if v.name == name then
				nut.item.spawn(v.uniqueID, client:GetShootPos() + client:GetAimVector()*84 + Vector(0, 0, 16))
				nut.log.add(client:getChar():getName(), "has spawned ", v.name)
			end
		end
	end)
end

nut.command.add("adminspawnmenu", {
    adminOnly = true,
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!superRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		net.Start("adminSpawnMenu")
		net.Send(client)
	end
})

if (CLIENT) then
	net.Receive("adminSpawnMenu",function()
		local background = vgui.Create("DFrame")
		background:SetSize(ScrW() / 2, ScrH() / 2)
		background:Center()
		background:SetTitle("Admin Spawn Menu")
		background:MakePopup()
		background:ShowCloseButton(true)

		scroll = background:Add("DScrollPanel")
		scroll:Dock(FILL)

		categoryPanels = {}

		for k, v in pairs(nut.item.list) do
			if (!categoryPanels[L(v.category)]) then
				categoryPanels[L(v.category)] = v.category
			end
		end
		
		for category, realName in SortedPairs(categoryPanels) do
			local collapsibleCategory = scroll:Add("DCollapsibleCategory")
			collapsibleCategory:SetTall(36)
			collapsibleCategory:SetLabel(category)
			collapsibleCategory:Dock(TOP)
			collapsibleCategory:SetExpanded(0)
			collapsibleCategory:DockMargin(5, 5, 5, 0)
			collapsibleCategory.category = realName

			for k, v in pairs(nut.item.list) do
				if v.category == collapsibleCategory.category then
					local item = collapsibleCategory:Add("DButton")
					item:SetText(v.name)
					item:SizeToContents()
					item.DoClick = function()
						net.Start("adminSpawnItem")
						net.WriteString(v.name)
						net.SendToServer()
						surface.PlaySound("buttons/button14.wav")
					end
				end
			end

			categoryPanels[realName] = collapsibleCategory
		end
	end)
end