AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("pyrozooka/sh/pyrozooka_config.lua")

//NetworkStuff
util.AddNetworkString( "pyrozooka_shot_FX" )
function SWEP:CreateEffect_Table(effect,sound,parent,angle,position)
	net.Start("pyrozooka_shot_FX")
	local effectInfo = {}
	effectInfo.effect = effect
	effectInfo.sound = sound
	effectInfo.pos = position
	effectInfo.ang = angle
	effectInfo.parent = parent
	net.WriteTable(effectInfo)
	net.SendPVS(self:GetPos())
end

local pyro_effects = {
	[1] = {
			[1] = "pyrozooka_red_shot",
			[2] = "pyrozooka_explosion_01_red",
			[3] = "Red",
			},
	[2] = {
			[1] = "pyrozooka_green_shot",
			[2] = "pyrozooka_explosion_01_green",
			[3] = "Green",
			},
	[3] = {
			[1] = "pyrozooka_blue_shot",
			[2] = "pyrozooka_explosion_01_blue",
			[3] = "Blue",
			},
	[4] = {
			[1] = "pyrozooka_yellow_shot",
			[2] = "pyrozooka_explosion_01_yellow",
			[3] = "Yellow",
			},
	[5] = {
			[1] = "pyrozooka_pink_shot",
			[2] = "pyrozooka_explosion_01_pink",
			[3] = "Pink",
		},
	[6] = {
			[1] = "",
			[2] = "",
			[3] = "Random",
			}
}

//SWEP:Initialize\\
function SWEP:Initialize() //Tells the script what to do when the player "Initializes" the SWEP.
	self:SetHoldType( self.HoldType )
	self.selectedEffect = 1
end

//SWEP:ShootBullet\\
function SWEP:ShootBullet( damage, num_bullets, aimcone )

	local bullet = {}
	bullet.Num 	= num_bullets
	bullet.Src 	= self.Owner:GetShootPos() -- Source
	bullet.Dir 	= self.Owner:GetAimVector() -- Dir of bullet
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )	-- Aim Cone
	bullet.Tracer	= 5 -- Show a tracer on every x bullets
	bullet.Force	= 1 -- Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"

	self.Owner:FireBullets( bullet )

	self:ShootEffects()
end

//SWEP:PrimaryFire\\
function SWEP:PrimaryAttack()
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) -- View model animation
	self.Owner:SetAnimation( ACT_VM_PRIMARYATTACK ) -- 3rd Person Animation

	local rnda = -self.Primary.Recoil
	local rndb = self.Primary.Recoil * math.random(-1, 1)
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) //Makes the gun have recoil

    local tr = self.Owner:GetEyeTrace()

	local effectPos = self:GetAttachment(self:LookupAttachment("effectpoint")).Pos

	local effectAngle = self.Owner:GetAimVector():Angle()
	effectAngle:RotateAroundAxis(self.Owner:GetRight(), -90)

	if(pyrozooka.config.PyroShot_Damage > 0)then
		self:ShootBullet( pyrozooka.config.PyroShot_Damage, 1, self.Primary.Cone )
	end

	if(self.selectedEffect == 6)then
		self:CreateEffect_Table(pyro_effects[math.random(1,5)][1],"pyrozooka_crackling",self,effectAngle,effectPos)
	else
		self:CreateEffect_Table(pyro_effects[self.selectedEffect][1],"pyrozooka_crackling",self,effectAngle,effectPos)
	end

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay)
end

//SWEP:SecondaryFire\\
function SWEP:SecondaryAttack()
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) -- View model animation
	self.Owner:SetAnimation( ACT_VM_PRIMARYATTACK ) -- 3rd Person Animation

	self:CreateEffect_Table(nil,"pyrozooka_brickelt",self,self:GetAngles(),self:GetPos())

	local tr = self.Owner:GetEyeTrace()

	local effectPos = self:GetAttachment(self:LookupAttachment("effectpoint")).Pos

	local shootForce = pyrozooka.config.PyroBricklet_ShotForce
	local bricklet = ents.Create( "pyrozooka_bricklet" )
	if ( IsValid( bricklet ) ) then
		bricklet:SetPos( effectPos )
		bricklet:SetAngles(self.Owner:GetAimVector():Angle())
		bricklet:SetOwner(self.Owner)
		bricklet:Spawn()
		bricklet:Activate()
		cleanup.Add(self.Owner, "pyrozooka_bricklet", bricklet)
		if(self.selectedEffect == 6)then
			bricklet.effect = pyro_effects[math.random(1,5)][2]
		else
			bricklet.effect = pyro_effects[self.selectedEffect][2]
		end

	    local phys = bricklet:GetPhysicsObject()
	    if (phys:IsValid()) then
	        phys:Wake()
	        phys:EnableMotion(true)
			phys:AddAngleVelocity( Vector(math.random(-25,25),math.random(-25,25),math.random(-25,25))*shootForce )
			phys:ApplyForceCenter( self.Owner:GetAimVector() * shootForce )
	    end
	end
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay)
end

function SWEP:Equip() //Tells the script what to do when the player "Initializes" the SWEP.
	self:SendWeaponAnim( ACT_VM_DRAW ) -- View model animation
	self.Owner:SetAnimation( PLAYER_IDLE ) -- 3rd Person Animation
end

function SWEP:Reload()
	if ( ( self.lastReload or CurTime() ) > CurTime() ) then return end
	self.lastReload = CurTime() + 1

	self.selectedEffect = self.selectedEffect + 1
	if(self.selectedEffect > 6)then
		self.selectedEffect = 1
	end
	pyrozooka_Notify( self.Owner, pyro_effects[self.selectedEffect][3], 0 )
	self:CreateEffect_Table(nil,"pyrozooka_switch",self,effectAngle,effectPos)
end

function SWEP:ShouldDropOnDie() return false end
