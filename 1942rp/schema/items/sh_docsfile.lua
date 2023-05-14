ITEM.name = "Special Documents"
ITEM.desc = "Special documents that can be shown"
ITEM.model = "models/props_lab/clipboard.mdl"
ITEM.price = 10

ITEM.functions.show = {
    icon = "icon16/user.png",
    name = "Show",
    onRun = function(item)
        local client = item.player

        if (client.NextDocumentCheck and client.NextDocumentCheck > SysTime()) then
            client:notify("You can't show documents that quickly...")

            return false
        end

        client.NextDocumentCheck = SysTime() + 5
        local target = client:GetEyeTrace().Entity

        if (not target or not IsValid(target) or target:GetPos():Distance(client:GetPos()) > 100) then
            client:notify("Invalid target")

            return false
        end

        if (item.docLink) then
            local findString = "https://docs.google.com/"
            if (item.docLink:sub(1, #findString) ~= findString) then return end
            net.Start("SpecialDocumentsSendURL")
            net.WriteString(item.docLink)
            net.WriteString(client:Name())
            net.WriteString(item:getName())
            net.Send(target)
        end

        return false
    end,
    onCanRun = function(item)
        local trEnt = item.player:GetEyeTrace().Entity

        return (item.docLink and IsValid(trEnt) and trEnt:IsPlayer())
    end
}

ITEM.functions.set = {
    name = "Set Link",
    onRun = function(item)
        local client = item.player
        net.Start("SpecialDocumentsExchange")
        net.WriteDouble(item.id)
        net.Send(client)

        return false
    end
}

ITEM.getName = function(self) return self.overrideName or (CLIENT and L(self.name) or self.name) end

ITEM.getDesc = function(self)
    if (self.overrideDesc) then return self.overrideDesc end
    if (not self.desc) then return "ERROR" end

    return L(self.desc or "noDesc")
end

if (SERVER) then
    util.AddNetworkString("SpecialDocumentsExchange")
    util.AddNetworkString("SpecialDocumentsSendURL")
    util.AddNetworkString("SpecialDocumentsSetItemName")

    net.Receive("SpecialDocumentsExchange", function(len, ply)
        local itemID = net.ReadDouble()
        local str = net.ReadString()
        local overrideName = net.ReadString()
        local findString = "https://docs.google.com/"
        if (not ply:getChar()) then return end
        if (not nut.item.instances[itemID]) then return end
        if (str:sub(1, #findString) ~= findString) then return end
        local invID = nut.item.instances[itemID].invID
        if (not invID) then return end
        local charID = nut.item.inventories[invID].owner
        if (not charID) then return end
        local char = nut.char.loaded[charID]
        if (not char or char.id ~= ply:getChar().id) then return end -- down the rabbit hole, neo
        nut.item.instances[itemID].docLink = str
        nut.item.instances[itemID].overrideName = overrideName
        nut.item.instances[itemID].overrideDesc = str
        net.Start("SpecialDocumentsSetItemName")
        net.WriteDouble(itemID)
        net.WriteString(overrideName or "")
        net.WriteString(str)
        net.Broadcast()
    end)
else
    net.Receive("SpecialDocumentsExchange", function()
        local itemID = net.ReadDouble()

        Derma_StringRequest("Enter Special Document Link", "Input the link to a googledoc that is supposed to be shown (must start with https://docs.google.com/)", "https://docs.google.com/", function(str)
            local findString = "https://docs.google.com/"

            if (str:sub(1, #findString) ~= findString) then
                nut.util.notify("The link must start with https://docs.google.com/")

                return
            end

            http.Fetch(str, function(body, len, headers, code)
                local _, _, titleName = body:find("<title>(.*)</title>")
                net.Start("SpecialDocumentsExchange")
                net.WriteDouble(itemID)
                net.WriteString(str)
                net.WriteString(titleName or "No Title")
                net.SendToServer()
                nut.item.instances[itemID].overrideDesc = str
                nut.item.instances[itemID].overrideName = titleName

                if (nut.gui.menu and nut.gui.inv1) then
                    local oldPosX, oldPosY = nut.gui.inv1:GetPos()
                    nut.gui.inv1:Remove()
                    nut.gui.inv1 = nut.gui.menu.tabs:Add("nutInventory")
                    nut.gui.inv1.childPanels = {}
                    nut.gui.inv1:setInventory(LocalPlayer():getChar():getInv())
                    nut.gui.inv1:SetPos(oldPosX, oldPosY)
                end
            end)
        end)
    end)

    net.Receive("SpecialDocumentsSendURL", function()
        local openURL = net.ReadString()
        local clName = net.ReadString()
        local itemName = net.ReadString()
        local findString = "https://docs.google.com/"
        if (openURL:sub(1, #findString) ~= findString) then return end

        Derma_Query(clName .. " wants to show you Special Documents (" .. itemName .. ")\nThis will open a link (hopefully) to a google doc in vgui browser.\nWe are not responsible for the content of the page.\n\nLink: " .. openURL, "Special Documents being Shown", "Open Link", function()
            --[[local pnl = vgui.Create("DFrame")
				pnl:SetSize(ScrW() * 0.8, ScrH() * 0.8)
				pnl:Center()
				pnl:SetTitle("GoogleDocs: " .. itemName .. ": " .. openURL)
				local subPnl = vgui.Create("DHTML", pnl)
				subPnl:SetPos(0, 24)
				subPnl:SetSize(ScrW() * 0.8, ScrH() * 0.8 - 24 - 40)
				subPnl:OpenURL(openURL)
				subPnl:Refresh(true)
				local closeBtn = vgui.Create("DButton", pnl)
				closeBtn:SetSize(80, 40)
				closeBtn:SetPos(ScrW() * 0.4 - 40, ScrH() * 0.8 - 40)
				closeBtn:SetText("Close")
				closeBtn.DoClick = function() pnl:Close() end
				pnl:MakePopup()]]
            gui.OpenURL(openURL)
        end, "Cancel")
    end)

    net.Receive("SpecialDocumentsSetItemName", function()
        local itemID = net.ReadDouble()
        local setName = net.ReadString()
        local setDesc = net.ReadString()

        if (nut.item.instances[itemID]) then
            nut.item.instances[itemID].overrideName = setName
            nut.item.instances[itemID].overrideDesc = setDesc
        end
    end)
end