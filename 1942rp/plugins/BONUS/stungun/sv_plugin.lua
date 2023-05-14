local playerMeta = FindMetaTable("Player")
util.AddNetworkString("tase_character")

net.Receive("tase_character", function()
    local ply = net.ReadEntity()
    local target = net.ReadEntity()
    target:Freeze(true)
    target:SetNoDraw(true)
    target:setRagdolledTase(true, 5, 0)
    target:notify("You have been tased by " .. ply:Nick())

    timer.Simple(10, function()
        ply:notify("Target is too stunned to react! You have time to tie him up!")
        target:notify("You have been been able to stand up but you are now too stunned to move!")
        target:SetNoDraw(false)

        timer.Simple(5, function()
            target:notify("You are now able to move!")
            ply:notify("Target is now able to move!")
            target:Freeze(false)
        end)
    end)
end)

function playerMeta:setRagdolledTase(state, time, nm)
    getUpGrace = 0

    if state then
        if IsValid(self.nutRagdoll) then
            self.nutRagdoll:Remove()
        end

        local entity = self:createRagdoll()
        entity:setNetVar("player", self)

        entity:CallOnRemove("fixer", function()
            if IsValid(self) then
                self:setLocalVar("blur", nil)
                self:setLocalVar("ragdoll", nil)

                if not entity.nutNoReset then
                    self:SetPos(entity:GetPos())
                end

                self:SetNoDraw(false)
                self:SetNotSolid(false)
                self:SetMoveType(MOVETYPE_WALK)
                self:SetLocalVelocity(IsValid(entity) and entity.nutLastVelocity or vector_origin)
            end

            if IsValid(self) and not entity.nutIgnoreDelete then
                if entity.nutWeapons then
                    for k, v in ipairs(entity.nutWeapons) do
                        self:Give(v)

                        if entity.nutAmmo then
                            for k2, v2 in ipairs(entity.nutAmmo) do
                                if v == v2[1] then
                                    self:SetAmmo(v2[2], tostring(k2))
                                end
                            end
                        end
                    end

                    for k, v in ipairs(self:GetWeapons()) do
                        v:SetClip1(0)
                    end
                end

                if self:isStuck() then
                    entity:DropToFloor()
                    self:SetPos(entity:GetPos() + Vector(0, 0, 16))

                    local positions = nut.util.findEmptySpace(self, {entity, self})

                    for k, v in ipairs(positions) do
                        self:SetPos(v)
                        if not self:isStuck() then return end
                    end
                end
            end
        end)

        self:setLocalVar("blur", 25)
        self.nutRagdoll = entity
        entity.nutWeapons = {}
        entity.nutAmmo = {}
        entity.nutPlayer = self

        if getUpGrace then
            entity.nutGrace = CurTime() + getUpGrace
        end

        if time and time > 0 then
            entity.nutStart = CurTime()
            entity.nutFinish = entity.nutStart + time
            self:setAction("@wakingUp", nil, nil, entity.nutStart, entity.nutFinish)
        end

        for k, v in ipairs(self:GetWeapons()) do
            entity.nutWeapons[#entity.nutWeapons + 1] = v:GetClass()
            local clip = v:Clip1()
            local reserve = self:GetAmmoCount(v:GetPrimaryAmmoType())
            local ammo = clip + reserve

            entity.nutAmmo[v:GetPrimaryAmmoType()] = {v:GetClass(), ammo}
        end

        self:GodDisable()
        self:StripWeapons()
        self:SetNoDraw(true)
        self:SetNotSolid(true)
        self:SetMoveType(MOVETYPE_NONE)

        if time then
            local time2 = time
            local uniqueID = "nutUnRagdoll" .. self:SteamID()

            timer.Create(uniqueID, 0.33, 0, function()
                if IsValid(entity) and IsValid(self) then
                    local velocity = entity:GetVelocity()
                    entity.nutLastVelocity = velocity
                    self:SetPos(entity:GetPos())

                    if velocity:Length2D() >= 8 then
                        if not entity.nutPausing then
                            self:setAction()
                            entity.nutPausing = true
                        end

                        return
                    elseif entity.nutPausing then
                        self:setAction("@wakingUp", time)
                        entity.nutPausing = false
                    end

                    time = time - 0.33

                    if time <= 0 then
                        entity:Remove()
                    end
                else
                    timer.Remove(uniqueID)
                end
            end)
        end

        self:setLocalVar("ragdoll", entity:EntIndex())
        hook.Run("OnCharFallover", self, entity, true)
    elseif IsValid(self.nutRagdoll) then
        self.nutRagdoll:Remove()
        hook.Run("OnCharFallover", self, entity, false)
    end
end