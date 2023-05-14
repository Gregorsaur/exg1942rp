netstream.Hook("radioChangeFreq", function(itemID)
    local item = nut.item.instances[itemID]
    Empty_Popup(function(frame)
        frame:SetTitle("")

        local hint = frame:Add("DLabel")
        hint:SetText("Change the frequency")
        hint:SetFont("WB_Medium")
        hint:SetColor(color_white)
        hint:SizeToContents()
        hint:CenterHorizontal()
        hint:CenterVertical(0.25)

        local dnum = vgui.Create( "DNumSlider", frame )
        dnum:SetSize(300, 100)
        dnum:Center()
        dnum:SetText("Frequency")
        dnum:SetMin(1)
        dnum:SetMax(100)
        dnum:SetDecimals(1)
        dnum.TextArea:SetTextColor(color_white)

        local cont = frame:Add("WButton")
        cont:SetText("Continue")
        cont:SetAccentColor(BC_NEUTRAL)
        cont:SetSize(frame:GetWide()-50, 40)
        cont:Dock(BOTTOM)
        cont:SetFont("WB_Medium")
        function cont:DoClick()
            local val = dnum:GetValue()

            netstream.Start("setRadioFreq", itemID, val)
            frame:Close()
        end
    end)
end)

netstream.Hook("radioChangeKeybind", function(itemID)
    local item = nut.item.instances[itemID]
    Empty_Popup(function(frame)
        frame:SetTitle("")

        local bound = LocalPlayer():getNutData("radioIO", nil)

        local hint = frame:Add("DLabel")
        hint:SetText("Bind a new key for turning on/off the radio")
        hint:SetFont("WB_Medium")
        hint:SetColor(color_white)
        hint:SizeToContents()
        hint:CenterHorizontal()
        hint:CenterVertical(0.25)

        local binder = frame:Add("DBinder")
        binder:SetSize( 200, 50 )
        binder:SetPos( 25, 35 )
        binder:Center()
        if bound then binder:SetValue(bound) end
        function binder:OnChange(inum)
            frame:Close()

            local keyName = input.GetKeyName(inum)
            keyName = language.GetPhrase(keyName)
            netstream.Start("playerSetRadioIOBind", inum, keyName)
        end
    end)
end)

local RIOC = CurTime()
hook.Add("Think", "CheckForRadioIOBind", function()
    local ply = LocalPlayer()
    local bind = ply:getNutData("radioIO", nil)
    if not bind then return end

    if input.IsKeyDown(bind) and RIOC <= CurTime() then
        netstream.Start("radioToggleIO")
        RIOC = CurTime() + 5
    end
end)