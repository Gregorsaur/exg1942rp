local mClamp = math.Clamp
local HealthID = "saveHealth"

function SCHEMA:CharacterPreSave(character)
    local client = character:getPlayer()
    local savedHealth = client:Health()
    local maxHealth = client:GetMaxHealth()
    character:setData(HealthID, mClamp(savedHealth, 0, maxHealth))
end

function SCHEMA:PlayerLoadedChar(client, character)
    local hpData = character:getData(HealthID)
    local hpAmount = client:GetMaxHealth()

    if (hpData) then
        if (hpData <= 0) then
            client:SetHealth(hpAmount)

            return
        end

        client:SetHealth(mClamp(hpData, 0, hpAmount))
    end
end

-------------------------------------------------------------------------------------------------------------------------
function SCHEMA:InitializedSCHEMAs()
    timer.Simple(3, function()
        RunConsoleCommand("ai_serverragdolls", "1")
    end)
end
------------------------------------------------------------------------------------------------------------------------