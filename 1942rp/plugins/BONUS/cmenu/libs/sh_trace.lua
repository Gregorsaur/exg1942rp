local PLUGIN = PLUGIN

function PLUGIN:GetTrace(ply)
    local tr = util.TraceLine({
        start = ply:EyePos(),
        endpos = ply:EyePos() + (ply:GetAimVector() * 100),
        filter = ply
    })

    if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
        local cuffed, wep = tr.Entity:IsHandcuffed()
        if cuffed then return tr, wep end
    end
end