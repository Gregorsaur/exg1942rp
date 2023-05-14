local function nutRequestSearch(len)
    nut.util.notifQuery("A player is requesting to search your inventory.", "Accept", "Deny", true, NOT_CORRECT, function(code)
        if code == 1 then
            net.Start("nutApproveSearch")
            net.WriteBool(true)
            net.SendToServer()
        elseif code == 2 then
            net.Start("nutApproveSearch")
            net.WriteBool(false)
            net.SendToServer()
        end
    end)
end

net.Receive("nutRequestSearch", nutRequestSearch)

local function nutRequestID(len)
    nut.util.notifQuery("A player is requesting to see your ID.", "Accept", "Deny", true, NOT_CORRECT, function(code)
        if code == 1 then
            net.Start("nutApproveID")
            net.WriteBool(true)
            net.SendToServer()
        elseif code == 2 then
            net.Start("nutApproveID")
            net.WriteBool(false)
            net.SendToServer()
        end
    end)
end

net.Receive("nutRequestID", nutRequestID)

net.Receive("moneyprompt", function()
    Derma_StringRequest("Give money", "How much would you like to give?", "0", function(text)
        nut.command.send("givemoney", text)
    end, function()
        gui.EnableScreenClicker(false)
    end)
end)