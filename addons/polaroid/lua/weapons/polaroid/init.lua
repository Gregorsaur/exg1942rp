-- developed for gmod.store
-- from incredible-gmod.ru with love <3

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

util.AddNetworkString("incredible-gmod.ru/polaroid")

net.Receive("incredible-gmod.ru/polaroid", function(len, ply)
	local swep = ply:GetActiveWeapon()
	if not (swep.IsPolaroidCamera and swep.IsBusy) then return end

	local wanna_print = net.ReadBool()
	if not wanna_print then
		swep.IsBusy = false
		return
	end

	local img_id = net.ReadString()
	if swep.DeveloperMode == false and (ply.LastSpawnPhoto or "") == img_id then swep.IsBusy = false return end

	if hook.Run("Polaroid/CanSpawnPhoto", ply, img_id) == false then swep.IsBusy = false return end

	ply.LastSpawnPhoto = img_id

	local CT = CurTime()
	if (ply.NextSpawnPhotoT or 0) > CT then swep.IsBusy = false return end
	ply.NextSpawnPhotoT = CT + 2

	swep:SpawnPhoto(ply, img_id)
end)

function SWEP:SpawnPhoto(ply, img_id)
	if self.IsUnlimited == false then
		if self:Clip1() < 1 then return end
		self:TakePrimaryAmmo(1)
	end

	self:EmitSound("polaroid/camera.mp3")

	timer.Simple(1, function()
		if IsValid(self) == false then return end
		self.IsBusy = false

		if hook.Run("Polaroid/RewritePhotoSpawn", ply, img_id) then return end

		local ent = ents.Create("polaroid_photo")
		if self.DeveloperMode then
			ent:RandomDefaultImage()
		else
			ent:SetImage(ply, img_id)
		end
		ent:SetPos(self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector()*32)
		ent:Spawn()

		hook.Run("Polaroid/PhotoSpawned", ply, ent, img_id)
	end)
end

function SWEP:Initialize()
	self:SetColor(HSVToColor(math.random() * 360, 1, 1))
end