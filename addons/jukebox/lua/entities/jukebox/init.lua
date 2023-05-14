include('shared.lua')
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

-- First called to initialize the Jukebox
function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
end

-- List of songs
local songs = {"music/music1.wav", "music/music2.wav", "music/music3.wav", "music/music4.wav", "music/music5.wav", "music/music6.wav", "music/music7.wav"}

-- Load Jukebox content when joining the server
for k, v in pairs(songs) do
    resource.AddSingleFile("sound/" .. v)
end

-- Variables which are used in the functions below
local switch_delay = 0
local delay = 0
local cur = 0
local maximum = #songs

-- Gets called when player interacts with the Jukebox
function ENT:Use(ply)
    if CurTime() < delay then return end
    delay = CurTime() + 7.5

    if cur ~= 0 then
        self:StopSound(songs[cur])
    end

    cur = cur + 1

    timer.Simple(6, function()
        if cur > maximum then
            cur = 1

            return
        end

        self:EmitSound(songs[cur])
    end)
end

-- Gets called when the entity gets removed, to stop the sound
function ENT:OnRemove()
    if (songs[cur]) then
        self:StopSound(songs[cur])
    end
end