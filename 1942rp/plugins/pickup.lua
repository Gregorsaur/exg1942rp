local PLUGIN = PLUGIN
PLUGIN.name = "Pickup entities"
PLUGIN.desc = "Turns entities into nut_items."
PLUGIN.author = ""

if (SERVER) then
    -- Format:
    -- ["entity_class"] = "nut_item"
    PLUGIN.Conversion = {
        ["vm_vending"] = "vendingmachine",
        ["bathtub_bench"] = "bathtub_table",
        ["bottlingstation_bench"] = "bottlingstation",
        ["beanroaster_bench"] = "beanroaster",
        ["beantumbler_bench"] = "beantumbler",
        ["coffeegrinder_bench"] = "beangrinder",
        ["coffeemachine_bench"] = "coffeemaker",
        ["distillery_bench"] = "distillery_table",
        ["medical_bench"] = "drug_table",
        ["fermentingbarrel_bench"] = "fermentingbarrel",
        ["grapepress_bench"] = "grapepress",
        ["opiumrefinery_bench"] = "opiumrefinery",
        ["packagingstation_bench"] = "packagingstation",
        ["grill_bench"] = "grill",
        ["sewing_bench"] = "sewing_table",
        ["stove_bench"] = "stove",
        ["weapons_bench"] = "weapon_table",
        ["generic_bench"] = "generic_table",
        ["phone_private_1"] = "deskphone",
        ["phone_private_2"] = "wallphone",
        ["signs_large"] = "largesign",
        ["signs_large_wide"] = "largesignwide",
        ["signs_ticker_large"] = "largetickersign",
        ["signs_small"] = "smallsign",
        ["signs_small_wide"] = "smallwidesign",
        ["signs_ticker_small"] = "smalltickersign",
        ["tbfy_stocks_display_1"] = "stock_long",
        ["tbfy_stocks_display_2"] = "stock_tall",
        ["bb_wardrobe"] = "wardrobe",
        ["gramophone"] = "gramophone",
        ["pot"] = "potuni",
        ["mediumpot"] = "mediumpotuni",
        ["vat_bench"] = "vat_table",
        ["flask_bench"] = "flask_table",
        ["coolingrack_bench"] = "coolingrack_table",
        ["chemicalmixer_bench"] = "chemicalmixer_table",
        ["storage1_bench"] = "storage1_table",
        ["storage2_bench"] = "storage2_table",
        ["storage3_bench"] = "storage3_table",
        ["storage4_bench"] = "storage4_table",
        ["moonshine_bench"] = "moonshine_table",
    }

    -- Just in case people accidentally pressed 'G' and had something valuable in their entities
    PLUGIN.SafetyCheck = {
        ["vm_vending"] = function(self, ply)
            if (table.Count(self:getInv():getItems()) > 0) then
                ply:notify("Collect all the items before converting this entity!")

                return false
            end

            if (self.info.cash > 0) then
                ply:notify("Collect the profit before converting this entity!")

                return false
            end

            return true
        end,
        ["bb_wardrobe"] = function(self, ply)
            if (self:GetProfit() > 0) then
                ply:notify("Collect the profit before converting this entity!")

                return false
            end

            return true
        end
    }

    netstream.Hook("ItemConversion", function(ply, ent)
        if (not IsValid(ply)) then return end
        if (not IsValid(ent)) then return end
        local class = ent:GetClass()
        if (not PLUGIN.Conversion[class]) then return end
        if (ply:GetPos():DistToSqr(ent:GetPos()) >= 16384) then return end

        if (ent:GetOwner() == ply or ent.Owner == ply or ent.SteamID == ply:SteamID() or (ent.isOwner and ent:isOwner(ply)) or ent:GetNWEntity("Owner", NULL) == ply or ent:GetNWString("OwnerSteamID", "") == ply:SteamID()) then
            local success = true

            if (PLUGIN.SafetyCheck[class]) then
                success = PLUGIN.SafetyCheck[class](ent, ply)
            end

            if (success) then
                nut.item.spawn(PLUGIN.Conversion[class], ent:GetPos() + Vector(0, 0, 16), nil, Angle(0, 0, 0))
                ent:Remove()
            end
        end
    end)
else
    local wait = 0

    hook.Add("CreateMove", "PLUGIN.Pickup", function()
        if (wait > CurTime()) then return end

        if (input.WasKeyPressed(KEY_G)) then
            local ply = LocalPlayer()
            if (ply:IsWorldClicking()) then return end
            if (gui.IsConsoleVisible()) then return end
            if (vgui.CursorVisible()) then return end
            local ent = ply:GetEyeTrace().Entity

            if (IsValid(ent) and ply:GetPos():DistToSqr(ent:GetPos()) < 16384) then
                netstream.Start("ItemConversion", ent)
            end

            wait = CurTime() + 0.2
        end
    end)
end