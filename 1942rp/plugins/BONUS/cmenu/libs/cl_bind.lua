local PLUGIN = PLUGIN

function PLUGIN:PlayerBindPress(ply, bind, down)
    local tr = util.TraceLine(util.GetPlayerTrace(ply))
    local target = tr.Entity
    if not target:IsPlayer() then return end
    if target == ply then return end

    if down and string.find(bind, "+menu_context") then
        if target:IsHandcuffed() then
            if ply:GetActiveWeapon():GetClass() ~= "gmod_tool" then
                net.Start("cmenu_tying")
                net.WriteEntity(LocalPlayer())
                net.SendToServer()
            elseif ply:GetActiveWeapon():GetClass() == "gmod_tool" then
                hook.Run("OnContextMenuOpen")

                return true
            end
        else
            if ply:GetActiveWeapon():GetClass() ~= "gmod_tool" then
                net.Start("cmenu")
                net.WriteEntity(LocalPlayer())
                net.SendToServer()
            elseif ply:GetActiveWeapon():GetClass() == "gmod_tool" then
                hook.Run("OnContextMenuOpen")

                return true
            end
        end
    end

    if string.find(bind, "gm_showhelp") and IsValid(ply.nutRagdoll) then return true end
    if string.find(bind, "+speed") and ply:getNetVar("restricted") or (string.find(bind, "gm_showhelp") and ply:getNetVar("restricted")) or (string.find(bind, "+jump") and ply:getNetVar("restricted") and not IsValid(ply.nutRagdoll)) or (string.find(bind, "+walk") and ply:getNetVar("restricted")) or (string.find(bind, "+use") and ply:getNetVar("restricted")) then return true end
end

netstream.Hook("startcmenu", function()
    vgui.Create("cmenu")
end)

netstream.Hook("startcmenutying", function()
    vgui.Create("cmenu_tying")
end)