local PLUGIN = PLUGIN
local PANEL = {}

function PANEL:Init()
    local jailmenu = vgui.Create("DFrame")
    jailmenu:SetSize(665 * .5, 357 * .5)
    jailmenu:Center()
    jailmenu:SetTitle("")
    jailmenu:MakePopup()
    jailmenu:SetDraggable(false)
    jailmenu:ShowCloseButton(true)
    local player_picker = vgui.Create("DComboBox", jailmenu)
    player_picker:SetSize(100, 20)
    player_picker:SetPos(110, 60)
    player_picker:SetValue("Default Value!")

    for t, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 200)) do
        if v:IsPlayer() and v:getNetVar("restricted") and v ~= LocalPlayer() then
            player_picker:AddChoice(v:Nick())
        end
    end

    local pickbutton = vgui.Create("DButton", jailmenu)
    pickbutton:SetSize(239 * .5, 64 * .5)
    pickbutton:SetPos(100, 90)
    pickbutton:SetText("Arrest Player")

    function pickbutton:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255))
    end

    pickbutton.DoClick = function()
        for k, client in pairs(player.GetHumans()) do
            if client:Nick() == player_picker:GetValue() then
                player_picker:SetValue(client:getChar():getID())
            end
        end

        if tonumber(player_picker:GetValue()) == LocalPlayer():getChar():getID() then
            LocalPlayer():ChatPrint("Please select a valid player.")
        else
            Derma_StringRequest("Sentence Time", "[SECONDS] Write a sentence time from 0 to " .. PLUGIN.MaxSentenceTime, "", function(time)
                if tonumber(time) <= 0 or not time then
                    LocalPlayer():ChatPrint("[TOO SMALL] Invalid time value. Setting as default value of " .. PLUGIN.DefaultSentenceTime)
                    time = tostring(PLUGIN.DefaultSentenceTime)
                elseif tonumber(time) > PLUGIN.MaxSentenceTime then
                    LocalPlayer():ChatPrint("[TOO BIG] Invalid time value. Setting as default value of " .. PLUGIN.MaxSentenceTime)
                    time = tostring(PLUGIN.MaxSentenceTime)
                end

                Derma_StringRequest("Reason of Arrest", "Write a Reason for Arrest", "", function(reason)
                    if reason == "" then
                        reason = "A default reason."
                    end

                    net.Start("arrest_player")
                    net.WriteFloat(tonumber(player_picker:GetValue()))
                    net.WriteFloat(tonumber(time))
                    net.WriteString(reason)
                    net.WriteEntity(LocalPlayer())
                    net.SendToServer()
                    self:Remove()
                end, function(reason) end)
            end, function(time) end)
        end
    end
end

vgui.Register("arrest_player_menu", PANEL, "DFrame")