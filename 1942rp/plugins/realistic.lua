PLUGIN.name = "First Person Effects"
PLUGIN.author = "Itzjoker."
PLUGIN.desc = "Realistic first person effects."

PLUGIN.currAng = PLUGIN.currAng or Angle( 0, 0, 0 )
PLUGIN.currPos = PLUGIN.currPos or Vector( 0, 0, 0 )
PLUGIN.targetAng = PLUGIN.targetAng or Angle( 0, 0, 0 )
PLUGIN.targetPos = PLUGIN.targetPos or Vector( 0, 0, 0 )
PLUGIN.resultAng = PLUGIN.resultAng or Angle( 0, 0, 0 )

if (CLIENT) then
	
	NUT_CVAR_HEADBOB = CreateClientConVar("nut_headbob", 0, true)
	local headBob = NUT_CVAR_HEADBOB:GetBool()
	cvars.AddChangeCallback("nut_headbob", function(name, old, new)
		headBob = (tonumber(new) or 1) > 0
	end)
	function PLUGIN:SetupQuickMenu(menu)
		menu:addCheck("firstperson effects", function(panel, state)
			if (state) then
				LocalPlayer():ConCommand("nut_headbob 1")
			else
				LocalPlayer():ConCommand("nut_headbob 0")
			end
		end, NUT_CVAR_HEADBOB:GetBool())
	end


	local velo = FindMetaTable( "Entity" ).GetVelocity
	local twoD = FindMetaTable( "Vector" ).Length2D
	local math_Clamp = math.Clamp

	function PLUGIN:CalcView( pl, pos, ang, fov )
		if !IsValid(LocalPlayer()) or (IsValid(nut.gui.char)) then return end
		if ( pl:CanOverrideView( ) or pl:GetViewEntity( ) != pl ) then return end
		if !headBob then return end
		if pl:GetNWBool("in pac3 editor") == true then return end

		local wep = pl:GetActiveWeapon( )
		
		local mouseSmoothingScale = 0	

		mouseSmoothingScale = 10
		
		local realTime = RealTime( )
		local frameTime = FrameTime( )
		local vel = math.floor( twoD( velo( pl ) ) )
		
		if ( pl:OnGround( ) ) then
			local walkSpeed = nut.config.get("walkSpeed")
			
			if ( vel > walkSpeed + 40) and !pl.nutBreathing then
				local runSpeed = nut.config.get("runSpeed")
				
				local perc = math_Clamp( vel / runSpeed * 100, 0.5, 5 )
				self.targetAng = Angle( math.abs( math.cos( realTime * ( runSpeed / 33 ) ) * 0.4 * perc ), math.sin( realTime * ( runSpeed / 29 ) ) * 0.5 * perc, 0 )
				self.targetPos = Vector( 0, 0, math.sin( realTime * ( runSpeed / 30 ) ) * 0.4 * perc )
			else
				local perc = math_Clamp( ( vel / walkSpeed * 100 ) / 60, 0, 10 )
				self.targetAng = Angle( math.cos( realTime * ( walkSpeed / 8 ) ) * 0.2 * perc, 0, 0 )
				self.targetPos = Vector( 0, 0, ( math.sin( realTime * ( walkSpeed / 8 ) ) * 0.5 ) * perc )
			end
		else
			if (!pl:OnGround( ) ) then
				self.targetPos = Vector( 0, 0, 0 )
				self.targetAng = Angle( 0, 0, 0 )
			else
				if ( pl:WaterLevel( ) >= 2 ) then
					self.targetPos = Vector( 0, 0, 0 )
					self.targetAng = Angle( 0, 0, 0 )
				else
					vel = math.abs( pl:GetVelocity( ).z )
					local af = 0
					local perc = math_Clamp( vel / 200, 0.1, 8 )
					
					if ( perc > 1 ) then
						af = perc
					end
					
					self.targetAng = Angle( math.cos( realTime * 15 ) * 2 * perc + math.Rand( -af * 2, af * 2 ), math.sin( realTime * 15 ) * 2 * perc + math.Rand( -af * 2, af * 2 ) ,math.Rand( -af * 5, af * 5 ) )
					self.targetPos = Vector( math.cos( realTime * 15 ) * 0.5 * perc, math.sin( realTime * 15 ) * 0.5 * perc, 0 )
				end
			end
		end
		
		if ( mouseSmoothingScale != 0 ) then
			self.resultAng = LerpAngle( math_Clamp( math_Clamp( frameTime, 1 / 120, 1 ) * mouseSmoothingScale, 0, 5 ), self.resultAng, ang )
		else
			self.resultAng = ang
		end
		
		self.currAng = LerpAngle( frameTime * 10, self.currAng, self.targetAng )
		self.currPos = LerpVector( frameTime * 10, self.currPos, self.targetPos )
		
		return {
			origin = pos + self.currPos,
			angles = self.resultAng + self.currAng,
			fov = fov
		}
	end
end