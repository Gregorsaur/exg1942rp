ITEM.name = "Document Base"
ITEM.desc = "Document you can show to someone"
ITEM.uniqueID = "base_document"
ITEM.additionalArg = nil
ITEM.functions.Drop = nil

ITEM.functions.show = {
    icon = "icon16/user.png",
    name = "Show",
    onRun = function(item)
        local ply = item.player

        if (ply.NextDocumentCheck and ply.NextDocumentCheck > SysTime()) then
            ply:notify("You can't show documents that quickly...")

            return false
        end

        ply.NextDocumentCheck = SysTime() + 5
        local target = ply:GetEyeTrace().Entity
        if not target:IsPlayer() or not IsValid(target) or target:GetPos():Distance(ply:GetPos()) > 500 then return end

        if target:IsBot() then
            target = ply
        end

        netstream.Start(target, item.netUID, ply, item.additionalArg)

        return false
    end,
    onCanRun = function(item)
        local trEnt = item.player:GetEyeTrace().Entity

        return IsValid(trEnt) and trEnt:IsPlayer()
    end
}

ITEM.functions.showself = {
    icon = "icon16/user.png",
    name = "View",
    onRun = function(item)
        local ply = item.player

        if (ply.NextDocumentCheck and ply.NextDocumentCheck > SysTime()) then
            ply:notify("You can't view documents that quickly...")

            return false
        end

        ply.NextDocumentCheck = SysTime() + 5
        netstream.Start(ply, item.netUID, ply, item.additionalArg)

        return false
    end,
}

function ITEM:onCanBeTransfered(oldInventory, newInventory)
    return false
end