AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
//----------------------------//
util.AddNetworkString( "pyrozooka_bricklet_FX" )
function ENT:CreateEffect_Table(effect,sound,parent,angle,position)
	net.Start("pyrozooka_bricklet_FX")
	local effectInfo = {}
	effectInfo.effect = effect
	effectInfo.sound = sound
	effectInfo.pos = position
	effectInfo.ang = angle
	effectInfo.parent = parent
	net.WriteTable(effectInfo)
	net.SendPVS(self:GetPos())
end

function ENT:Initialize()
	self.effect = "pyrozooka_explosion_01_red"
	self:SetModel(self.Model)
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON  )

	timer.Simple(0.1,function()
		if(IsValid(self))then
			self:CreateEffect_Table("pyrozooka_brickletfuse","pyrozooka_fuse",self,self:GetAttachment(1).Ang,self:GetAttachment(1).Pos)
		end
	end)

	local explodetime = math.random(0.5,1)

	if(pyrozooka.config.PyroBricklet_Bounce)then
		timer.Simple(explodetime,function()
			if(IsValid(self))then
				local shootForce = math.random(1000,2000)
				local phys = self:GetPhysicsObject()
					if (phys:IsValid()) then
						phys:Wake()
						phys:EnableMotion(true)
						phys:AddAngleVelocity( Vector(math.random(-25,25),math.random(-25,25),math.random(-25,25))*shootForce )
						phys:ApplyForceCenter(Vector(0,0,1)* shootForce )
					end
			end
		end)
	end

	timer.Simple(explodetime+0.5,function()
		if(IsValid(self))then
			self:SpawnEffect()
		end
	end)
end
function ENT:SpawnEffect()
	/*
	local ent = ents.Create( "env_physexplosion" )
	ent:SetParent(self)
	ent:SetKeyValue( "spawnflags", 1 )
	ent:SetKeyValue( "magnitude", 300 )
	ent:SetKeyValue( "radius", pyrozooka.config.PyroBricklet_BlastRadius )
	ent:SetPos(self:GetPos())
	ent:Spawn()
	ent:Fire("explode")
	*/
	if(pyrozooka.config.PyroBricklet_Damage > 0)then
		local players = ents.FindInSphere( self:GetPos(), pyrozooka.config.PyroBricklet_BlastRadius )
		for k,v in pairs(players) do
			if (v:IsPlayer() && IsValid(v) && v:Alive()) then
				local dmg = DamageInfo()
				dmg:SetAttacker(self:GetOwner())
				dmg:SetInflictor(self)
				dmg:SetDamage(pyrozooka.config.PyroBricklet_Damage)
				v:TakeDamageInfo( dmg )
			end
		end
	end

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(false)
	end
	self:SetNoDraw(true)

	self:CreateEffect_Table(nil,"pyrozooka_shot",self,self:GetAngles(),self:GetPos())
	self:CreateEffect_Table(self.effect,"pyrozooka_crackling",self,self:GetAngles(),self:GetPos())
	timer.Simple(2,function()
		if(IsValid(self))then
			self:Remove()
		end
	end)
end
