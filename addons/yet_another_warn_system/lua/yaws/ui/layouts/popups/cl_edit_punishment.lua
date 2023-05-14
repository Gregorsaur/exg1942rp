function YAWS.UI.EditPunishment(punshishmentData)
    local frame = vgui.Create("yaws.frame")
    frame:SetSize(ScrW() * 0.5, ScrH() * 0.3)
    frame:Center()
    frame:MakePopup()
    frame.bgColor = Color(0, 0, 0, 200)
    -- frame:DoModal()
    local oldThreshold = punshishmentData.threshold

    local master = vgui.Create("DPanel", frame)
    frame.PerformLayout = function(self, w, h)
        master:Dock(FILL)

        if(!YAWS.UserSettings.GetValue("disable_fades")) then 
            frame:FadeIn()
        end
    end 

    local top = vgui.Create("yaws.panel", master)
    
    local selectType = vgui.Create("yaws.combo", top)
    -- selectType:SetText(punshishmentData.typeInfo.name)
    for k,v in pairs(YAWS.Punishments.Types) do
        selectType:AddChoice(v.name, k, (k == punshishmentData.type))
    end

    local pointCount = vgui.Create("yaws.wang", top)
    pointCount:SetText("")
    pointCount:SetPlaceholder(YAWS.Language.GetTranslation("generic_point_count"))
    pointCount:SetMin(0)
    pointCount:SetMax(4096)
    pointCount:SetValue(punshishmentData.threshold)


    local options = vgui.Create("yaws.panel", master)
    local scroll = vgui.Create("yaws.scroll", options)

    local optionList = {}
    local function updateOptionList(newType)
        scroll:Clear()
        
        optionList = {}
        local type = YAWS.Punishments.Types[newType]
        for k,v in pairs(type.params) do 
            optionList[k] = punshishmentData.params[k] or v.default
            -- Create a panel for each param and dock it to the top of the scroll panel. Make it display the name and description of the parameter in the paint function.
            local panel = vgui.Create("DPanel", scroll)
            panel:Dock(TOP)
            panel:SetTall(scroll:GetTall() * 0.6)
            panel:DockMargin(0, 1, 0, 0)
            panel.Paint = function(self, w, h)
                -- draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0))
                -- draw.RoundedBox(0, 0, 0, w, 1, Color(0, 255, 0))
                local colors = YAWS.UI.ColorScheme() 
                -- Parameter name
                local _,nextY = draw.SimpleText(v.name, "yaws.8", 10, 10, colors['text_header'], 0, 0)

                -- Parameter description
                draw.SimpleText(v.description, "yaws.7", 10, nextY + 10, colors['text_main'], 0, 0)
            end
            
            if(v.type == "string") then 
                local textEntry = vgui.Create("yaws.text_entry", panel)
                textEntry:SetValue(punshishmentData.params[k] or v.default)
                textEntry.OnChange = function(self)
                    optionList[k] = self:GetValue()
                end
                    
                panel.PerformLayout = function(self, w, h)
                    textEntry:Dock(BOTTOM)
                    textEntry:SetHeight(h * 0.33)
                    textEntry:DockMargin(10, 0, 10, 10)
                end
            end 
            if(v.type == "number") then 
                local wang = vgui.Create("yaws.wang", panel)
                wang:SetValue(punshishmentData.params[k] or v.default)
                wang.OnChange = function(self)
                    optionList[k] = self:GetValue()
                end
                wang:SetMin(0)
                wang:SetMax(4294967296)
                    
                panel.PerformLayout = function(self, w, h)
                    wang:Dock(BOTTOM)
                    wang:SetHeight(h * 0.33)
                    wang:DockMargin(10, 0, 10, 10)
                end
            end 
        end
    end 

    selectType.OnSelect = function(self, index, value, data)
        updateOptionList(data)
    end 

    local buttonPanel = vgui.Create("DPanel", master)
    buttonPanel.Paint = function(self, w, h)
        -- draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0))
    end 

    local cancel = vgui.Create("yaws.button", buttonPanel)
    cancel:SetLabel(YAWS.Language.GetTranslation("generic_cancel"))
    cancel:SetColors('button_warn_base', 'button_warn_hover')
    cancel.DoClick = function() 
        frame:Close()
    end 

    local save = vgui.Create("yaws.button", buttonPanel)
    save:SetLabel(YAWS.Language.GetTranslation("generic_save"))
    save.DoClick = function() 
        YAWS.UI.CurrentData.WaitingForServerResponse = true 
        YAWS.UI.DisplayLoading(YAWS.UI.CurrentData.MasterCache)

        local typeKey = selectType:GetOptionData(selectType:GetSelectedID())
        net.Start("yaws.punishments.editpunishment")
        net.WriteUInt(oldThreshold, 12)
        net.WriteString(typeKey)
        net.WriteUInt(pointCount:GetValue(), 12)
        
        net.WriteUInt(table.Count(optionList), 16)
        for k,v in pairs(optionList) do 
            net.WriteString(k)
            net.WriteString(YAWS.Punishments.Types[typeKey].params[k].type)
            if(YAWS.Punishments.Types[typeKey].params[k].type == "string") then 
                net.WriteString(v)
            end 
            if(YAWS.Punishments.Types[typeKey].params[k].type == "number") then 
                net.WriteUInt(v, 32)
            end
        end

        net.SendToServer()

        YAWS.UI.LoadingCache = {
            panel = "edit_punishment",
            type = typeKey,
            pointValue = pointCount:GetValue(),
            params = optionList,
            oldValue = oldThreshold
        }

        frame:Close()
    end 
    
    master.Paint = function(self, w, h) end 
    master.PerformLayout = function(self, w, h) 
        buttonPanel:Dock(BOTTOM)
        buttonPanel:DockPadding(10, 10, 10, 10)
        buttonPanel:SetTall(h * 0.18)

        save:Dock(RIGHT)
        save:SetWide(w * 0.25)
        save:DockMargin(0, 0, 10, 0)

        cancel:Dock(RIGHT)
        cancel:SetWide(w * 0.25)


        top:Dock(TOP)
        top:DockMargin(10, 10, 10, 10)
        top:DockPadding(10, 10, 10, 10)
        top:SetTall(h * 0.18)

        pointCount:Dock(RIGHT)
        pointCount:SetWide(w * 0.25)
        pointCount:DockMargin(10, 0, 0, 0)

        selectType:Dock(FILL)


        options:Dock(FILL)
        options:DockMargin(10, 0, 10, 0)

        scroll:Dock(FILL)
        updateOptionList(punshishmentData.type)
    end
    master:InvalidateLayout()
end