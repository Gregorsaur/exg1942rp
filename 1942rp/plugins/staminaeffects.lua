PLUGIN.name = "Depleted Stamina Effects"
PLUGIN.author = "Barata"
PLUGIN.desc = "Adds screen effects and sounds when the player's stamina is depleted."

-- Called whenever the player depleted their stamina
function PLUGIN:PlayerStaminaLost(client)
    if (client.isBreathing) then return end -- Bail out if the player is already breathing
    client:EmitSound("player/breathe1.wav", 35, 100)
    client.isBreathing = true

    -- Stop breathing heavily when the player has recharged his stamina
    timer.Create("nutStamBreathCheck" .. client:SteamID(), 1, 0, function()
        if (client:getLocalVar("stm", 0) < 50) then return end
        client:StopSound("player/breathe1.wav")
        client.isBreathing = nil
        timer.Remove("nutStamBreathCheck" .. client:SteamID())
    end)
end

if (CLIENT) then
    local stmBlurAlpha = 0
    local stmBlurAmount = 0

    -- Called whenever the HUD should be drawn.
    function PLUGIN:HUDPaintBackground()
        local frametime = RealFrameTime()

        -- Account for blurring effects when the player stamina is depleted
        if (LocalPlayer():getLocalVar("stm", 50) <= 5) then
            stmBlurAlpha = Lerp(frametime / 2, stmBlurAlpha, 255)
            stmBlurAmount = Lerp(frametime / 2, stmBlurAmount, 5)
            nut.util.drawBlurAt(0, 0, ScrW(), ScrH(), stmBlurAmount, 0.2, stmBlurAlpha)
        end
    end
end