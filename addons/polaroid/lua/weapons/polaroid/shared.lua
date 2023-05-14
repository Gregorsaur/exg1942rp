-- developed for gmod.store
-- from incredible-gmod.ru with love <3

SWEP.MaxZoom = 5
SWEP.IsUnlimited = false -- infinity photos (CONFIG.InfinityPhotos)

SWEP.DeveloperMode = false -- used for debugging when you need to take a large number of photos to test some feature (the camera stops taking actual photos and spawns random photos for debugging)

SWEP.IsPolaroidCamera = true

SWEP.ViewModel = Model("models/weapons/c_arms_animations.mdl")
SWEP.WorldModel = Model("models/polaroid/camera.mdl")

SWEP.Primary.ClipSize		= SWEP.IsUnlimited and -1 or POLAROID_CONFIG.CartrigeSize
SWEP.Primary.DefaultClip	= SWEP.IsUnlimited and -1 or POLAROID_CONFIG.CartrigeSize
SWEP.Primary.Automatic		= false

game.AddAmmoType({name = "polaroid"})
SWEP.Primary.Ammo = SWEP.IsUnlimited and "none" or "polaroid"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.Category  	= "Incredible GMod"
SWEP.PrintName	= "Polaroid Camera"
SWEP.Author 	= "Beelzebub"
SWEP.Instructions = "LMB: Take Photo\nRMB: Zoom\nReload: DOF\nRMB+ALT: Auto Dolly Zoom"

SWEP.Slot		= 5
SWEP.SlotPos	= 1

SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.Spawnable		= true

SWEP.ShootSound = Sound("NPC_CScanner.TakePhoto")

function SWEP:Think() -- hack (Initialize hook for some reason is not called in the server-side, perhaps this is a bug of the p2p server)
	self:_Initialize()
	self.Think = nil
end

function SWEP:_Initialize()
	self:SetHoldType("camera")

	self.IsUnlimited = tobool(POLAROID_CONFIG.InfinityPhotos)
	self.Primary.Ammo 			= self.IsUnlimited and "none" or "polaroid"
	self.Primary.ClipSize		= self.IsUnlimited and -1 or POLAROID_CONFIG.CartrigeSize
	self.Primary.DefaultClip	= self.IsUnlimited and -1 or POLAROID_CONFIG.CartrigeSize

	hook.Add("Polaroid/ConfigLoaded", self, function()
		self.IsUnlimited = tobool(POLAROID_CONFIG.InfinityPhotos)
		self.Primary.Ammo 			= self.IsUnlimited and "none" or "polaroid"
		self.Primary.ClipSize		= self.IsUnlimited and -1 or POLAROID_CONFIG.CartrigeSize
		self.Primary.DefaultClip	= self.IsUnlimited and -1 or POLAROID_CONFIG.CartrigeSize

		if self.IsUnlimited then
			self:SetClip1(9999)
		elseif self:Clip1() < 0 or self:Clip1() > 3 then
			self:SetClip1(3)
		end
	end)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "Zoom")

	if SERVER then
		self:SetZoom(70)
	end
end

function SWEP:Deploy()
	return true
end

function SWEP:Equip()
	local ply = self:GetOwner()

	if self:GetZoom() == 70 and ply:IsPlayer() and ply:IsBot() == false then
		self:SetZoom(88)
	end
end

function SWEP:TranslateFOV()
	local ply = self:GetOwner()

	if ply:GetViewEntity() ~= ply then return end
	return self:GetZoom()
end

function SWEP:SecondaryAttack() end

local chat_message = CLIENT and {
	Color(227, 68, 47),
	"[P",
	Color(243, 131, 23),
	"OL",
	Color(232, 164, 37),
	"AR",
	Color(127, 178, 60),
	"OI",
	Color(18, 143, 201),
	"D]: ",
	Color(225, 225, 225),
	PolaroidLANG("Replace the cartridge with a new one.")
} or nil

SWEP.IsBusy = false

function SWEP:PrimaryAttack()
	if self.IsBusy then return end

	if self:Clip1() < 1 and self.IsUnlimited == false then
		if CLIENT and IsFirstTimePredicted() then
			chat.AddText(unpack(chat_message))
		end
		return
	end

	self.IsBusy = true

	if hook.Run("Polaroid/CanTakePhoto", self:GetOwner(), self) == false then return end

	self:DoShootEffect()

	if SERVER or IsFirstTimePredicted() == false then return end

	self:DoScreenshoot()
end

hook.Add("PlayerSwitchWeapon", "PolaroidCamera", function(ply, swep)
	if swep.IsPolaroidCamera and swep.IsBusy then
		return true
	end
end)

function SWEP:DoShootEffect()
	local ply = self:GetOwner()

	self:EmitSound(self.ShootSound)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	ply:SetAnimation(PLAYER_ATTACK1)

	if SERVER and game.SinglePlayer() == false then
		local vPos = ply:GetShootPos()
		local vForward = ply:GetAimVector()

		local trace = {}
		trace.start = vPos
		trace.endpos = vPos + vForward * 256
		trace.filter = ply

		local tr = util.TraceLine(trace)

		local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		util.Effect("camera_flash", effectdata, true)
	end
end

function SWEP:Tick()
	local ply = self:GetOwner()

	if CLIENT and ply ~= LocalPlayer() then return end -- spectate fix

	local cmd = ply:GetCurrentCommand()

	if CLIENT and cmd:KeyDown(IN_RELOAD) then
		self.DOF = math.Clamp(self:GetDOF() - cmd:GetMouseY() * 0.005, 0, 5)
	end

	if cmd:KeyDown(IN_ATTACK2) == false then return end

	if cmd:KeyDown(IN_WALK) then -- AUTO Dolly ZOOM (idk why i do this, but its fun)
		self:SetZoom( math.Clamp(
			math.Approach(self:GetZoom(), 90, ply:GetVelocity():Length() * 0.001),--0.0005),
			20, 90
		))
	else
		self:SetZoom(
			math.Clamp(self:GetZoom() + cmd:GetMouseY() * 0.01, 20, 90)
		)
	end
end