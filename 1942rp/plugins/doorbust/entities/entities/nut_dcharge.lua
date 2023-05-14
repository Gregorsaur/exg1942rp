ENT.Type = "anim"
ENT.PrintName = "Dynamite"
ENT.Author = "Lanius (Edited from BT Doorbust)"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "PP- Explosives"
ENT.RenderGroup 		= RENDERGROUP_BOTH
ENT.radius = 32
ENT.burstTime = 4
ENT.doorRestore = 300

--- Resoruce

resource.AddFile("sound/ignite.mp3")

function ENT:SpawnFunction(client, trace, className)
	if (!trace.Hit or trace.HitSky) then return end

	local spawnPosition = trace.HitPos + trace.HitNormal * 16

	local ent = ents.Create(className)
	local target = trace.Entity

	if (target and IsValid(target)) then
		local angles = trace.HitNormal:Angle()
		local axis = Angle(angles[1], angles[2], angles[3])
		angles:RotateAroundAxis(axis:Right(), 90)
		ent:SetParent(target)
		ent:SetPos(spawnPosition - trace.HitNormal*13)
		ent:SetAngles(angles)
		ent:Spawn()
		ent:Activate()
		ent:ManipulateBoneScale(0, Vector(1, 1, 1)*.5)
	end
	
	return ent
end

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/dav0r/tnt/tnt.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetDTBool(0,true)
		self:SetUseType(SIMPLE_USE)
		self.lifetime = CurTime() + self.burstTime
		self:EmitSound("ignite.mp3")

		local physicsObject = self:GetPhysicsObject()
		if (IsValid(physicsObject)) then
			physicsObject:Wake()
		end
	end

	function ENT:Explode()
		self:EmitSound("ambient/explosions/explode_1.wav", 120, 200)

		local doors = ents.FindInSphere(self:GetPos(), self.radius)
		for k, v in ipairs(doors) do
			if (v:isDoor()) then
				local dir = v:GetPos() - self:GetPos()
				dir:Normalize()
				v:blastDoor(dir * 300, 20, true)
			end
		end

		local e = EffectData()
		e:SetStart(self:GetPos() + self:OBBCenter())
		util.Effect( "doorCharge", e )
	end

	function ENT:OnRemove()
	end

	function ENT:Think()
		if self.lifetime < CurTime() then
			self:Explode()
			self:Remove()
		end

		return CurTime()
	end
	function ENT:Use(activator)
	end
else
	function ENT:Initialize()
		self.schema = self:GetDTInt(0)
		self.lifetime = CurTime() + self.burstTime
		self.beep = 255
	end
	
	function ENT:Think()
		if self:GetDTBool(0) then
			local burst = self.burstTime + (CurTime() - self.lifetime)
			self.beep = self.beep - FrameTime()*450*burst

			if self.beep <= 0 then
				self.beep = 255
				local snd = "ignite.mp3"
				local rnd = { 150, 150 }
				self:EmitSound( snd, 70, math.random(rnd[1], rnd[2]) )
			end
		else
			self.beep = 0
		end
	end
end