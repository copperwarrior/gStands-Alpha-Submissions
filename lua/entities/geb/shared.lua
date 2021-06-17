ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName= "Geb"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "Geb"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true
ENT.Animated = true
ENT.ImageID = 1
ENT.Rate = 0
ENT.Health = 1
ENT.CurrentAnim = "standidle"
ENT.State = false
ENT.PhysgunDisabled = true
ENT.Color = Color(255,255,255,75)

local block = Sound("weapons/geb/block.wav")
local boost1 = Sound("weapons/geb/boost1.wav")
local boost2 = Sound("weapons/geb/boost2.wav")
local boost3 = Sound("weapons/geb/boost3.wav")
local boost4 = Sound("weapons/geb/boost4.wav")
local drips1 = Sound("weapons/geb/drips1.wav")
local sdeploy = Sound("weapons/geb/sdeploy.wav")
local stab1 = Sound("weapons/geb/stab1.wav")
local stab2 = Sound("weapons/geb/stab2.wav")
local stab3 = Sound("weapons/geb/stab3.wav")
local thump = Sound("weapons/geb/thump.wav")

function ENT:Initialize()
    	self.Wep = self.Owner:GetWeapon("gstands_geb")
    --Initial animation base
    if SERVER then
        self:ResetSequence( self:LookupSequence(self.CurrentAnim) )
		self:SetModel("models/gstands/stands/geb.mdl")
	self:SetSolid( SOLID_OBB )
	self:SetMoveType( MOVETYPE_NOCLIP )
	self:SetSolidFlags( FSOLID_NOT_STANDABLE )
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    self:SetPos(self.Owner:GetPos())
    end
	self:SetSkin(self.Owner:GetInfoNum("gstands_standskin_"..self.Wep.ClassName, math.random(0, self:SkinCount() - 1)))
    self:Think( )
    self:SetHealth(self.Owner:Health())
	self.loop = CreateSound(self, "ambient/weather/water_run1.wav")
	self.loop:SetSoundLevel(55)
	self.loop:ChangePitch(15, 1)
	self.loop:Play()
	local hooktag = self.Owner:GetName()..self:EntIndex()
	hook.Add("EntityTakeDamage", "StandBlock"..hooktag, function(targ, dmg)
		if !self:IsValid() or !self.Owner:IsValid() then
			hook.Remove("EntityTakeDamage", "StandBlock"..hooktag)
		end
		if self:IsValid() and self.Owner:IsValid() and (targ == self.Owner or targ == self) then
			if self:GetSequence() != -1 and self:GetSequence() == self:LookupSequence("standblock") and dmg:GetDamageType() != DMG_DIRECT then
				dmg:SetDamage(dmg:GetDamage() * 0.1)
			end
		end
		if self:IsValid() and self.Owner:IsValid() then
			local mins, maxs = self:GetCollisionBounds()
			if targ.GebProtected and targ:GetPos():WithinAABox(self:GetPos() + mins * 2, self:GetPos() + maxs * 2) then
				dmg:SetDamage(dmg:GetDamage() * 0.1)
			end
		end
	end)
	
end

function ENT:GetEyePos(head)
	if self.Wep:GetState() or head then
		local pos = nil
		if self:GetModel() == "models/gstands/stands/geb_dash.mdl" then
			pos = self:GetBonePosition(0) + Vector(0,0,15)
		end
		return pos or self:WorldSpaceCenter()
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
function ENT:Disable(silent)
    if silent then
        self.Owner:KillSilent()
    else
        self.Owner:Kill()
    end
    self:Remove()
end

function ENT:OnRemove()
		if self.loop then
			self.loop:Stop()
		end
    if CLIENT and self.Aura then
        self.Aura:StopEmission()
    end
end

local softmats = {
[MAT_DIRT] = true,
[MAT_SNOW] = true,
[MAT_SAND] = true,
[MAT_FOLIAGE] = true,
[MAT_SLOSH] = true,
[MAT_GRASS] = true
}

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 1, "InJump")
end

function ENT:Think() 
if IsFirstTimePredicted() then
    if self.Owner:IsValid() and self.Owner:Alive() then
		self.Wep = self.Owner:GetWeapon("gstands_geb")
		if IsValid(self.Wep) and IsValid(self.Wep:GetBottle()) then
			self:SetPos(self.Wep:GetBottle():WorldSpaceCenter())
			self:SetNotSolid(true)
			self:NextThink( CurTime() )
			return true
			else
			self:SetNotSolid(false)
		end
        if self:IsOnFire() then
            self.Owner:Ignite(2, 1)
            self:Extinguish()
        end
		self:SetVelocity(-self:GetVelocity())
		if self:GetInJump() then
			self:SetPos(self:GetPos() + self.JumpForward * 10 + Vector(0,0,self.UpVelocity))
			self.UpVelocity = math.Clamp(self.UpVelocity - 1, -100, 100)
			local norm = (self.JumpForward * 10 + Vector(0,0,self.UpVelocity)):GetNormalized()
			self:SetAngles(LerpAngle(0.1, self:GetAngles(), norm:Angle()))
			local trT = util.TraceLine( {
					start = self:GetPos(),
					endpos = self:GetPos() + self.JumpForward * 10 + Vector(0,0,self.UpVelocity),
					filter = {self, self.Owner},
					collisiongroup = COLLISION_GROUP_DEBRIS
				} )
				if trT.HitWorld then
					self:SetPos(trT.HitPos - trT.Normal * 50)
					self:SetInJump(false)
				end
			if self.UpVelocity < 0 then
				local trW = util.TraceLine( {
					start = self:GetPos(),
					endpos = self:GetPos() + self.JumpForward * 10 - Vector(0,0,self.UpVelocity),
					filter = {self, self.Owner},
					collisiongroup = COLLISION_GROUP_DEBRIS
				} )
				if trW.HitWorld then
					self:SetInJump(false)
				end
			end
			self:NextThink( CurTime() )
			return true
		end
            local trT = util.TraceLine( {
                start = self:WorldSpaceCenter(),
                endpos = self:GetPos() + Vector(0,0,1000),
                filter = {self, self.Owner},
				mask = MASK_SOLID_BRUSHONLY,
				collisiongroup = COLLISION_GROUP_DEBRIS
            } )
            local trW = util.TraceLine( {
                start = trT.HitPos,
                endpos = self:GetPos() - Vector(0,0,100),
                filter = {self, self.Owner},
				mask = MASK_SOLID_BRUSHONLY,
				collisiongroup = COLLISION_GROUP_DEBRIS
            } )
		self:SetBodygroup(0,0)
        if !(self.CurrentAnim == "standdeploy" or self.CurrentAnim == "sinkhole" or self.CurrentAnim == "slash" or self.CurrentAnim == "slice" or self.CurrentAnim == "standblock") and (self:GetPos():DistToSqr(self.LastPos or self:GetPos()) > 0  ) then
            self.CurrentAnim = "move"
            self:SetBodygroup(0,1)
        elseif !(self.CurrentAnim == "standdeploy" or self.CurrentAnim == "sinkhole" or self.CurrentAnim == "slash" or self.CurrentAnim == "slice" or self.CurrentAnim == "standblock") then
            self.CurrentAnim = "standidle"
        end
		if self.slice then
			self.CurrentAnim = "bounce"
		end
		if self.CurrentAnim == "standblock" then
			local mins, maxs = self:GetCollisionBounds()
			local tr = util.TraceHull({
				start=self:WorldSpaceCenter(),
				endpos = self:WorldSpaceCenter(),
				mins = mins,
				maxs = maxs,
				filter = {self, self.Owner}
			})
			if IsValid(tr.Entity) and not tr.Entity.GebProtected then
				tr.Entity.GebProtected = true
			end
		end
		if self.CurrentAnim == "sinkhole" then
			self:SetBodygroup(0,1)
			self.SinkDripTimer = self.SinkDripTimer or CurTime()
			if SERVER and CurTime() > self.SinkDripTimer then
			self:EmitStandSound(drips1)
			self.SinkDripTimer = CurTime() + 1.2
			end
			local mins = Vector(-125, -125, 10)
			local maxs = Vector(125,125,125)

			for k,v in pairs(ents.FindInBox(self:GetPos() + mins, self:GetPos() + maxs)) do
				if v ~= self and v ~= self.Owner and v.Owner ~= self.Owner then
					local tr = util.TraceLine({
						start = v:WorldSpaceCenter(),
						endpos = v:GetPos() - Vector(0,0,10),
						filter = {v},
						collisiongroup = COLLISION_GROUP_DEBRIS
					})
					if tr.Hit and softmats[tr.MatType] and (v:GetMoveType() == MOVETYPE_WALK or v:GetMoveType() == MOVETYPE_VPHYSICS) then
						v:SetPos(v:GetPos() - Vector(0,0,1))
						if v:IsOnFire() then
							v:Extinguish()
						end
						if IsValid(v:GetPhysicsObject()) then
							for i=0, v:GetPhysicsObjectCount() - 1 do 
								local phys = v:GetPhysicsObjectNum(i)
								phys:SetPos( phys:GetPos() - Vector(0,0,1) )
								phys:EnableMotion(false)
							end
						end
					end
				end
			end
		end
        self.LastPos = self:GetPos()
		if self:GetSequence() ~= self:LookupSequence(self.CurrentAnim) then
        self:ResetSequence( self:LookupSequence(self.CurrentAnim) )  
		end
        if self.CurrentAnim  == "move" and !self.Wep:GetState() then
            self:SetAngles(Angle(0, (self.Owner:GetPos() - self:GetPos()):GetNormalized():Angle().y,(self.Owner:GetPos() - self:GetPos()):GetNormalized():Angle().r ))
        else
            self:SetAngles(Angle(0, self.Owner:GetAngles().y, self.Owner:GetAngles().r ))
        end
        if self.Wep:GetState() then
           self:SetAngles(Angle(0, self.Owner:EyeAngles().y, self.Owner:EyeAngles().r ))
        end
        if self.CurrentAnim == "slash" then
		
        local tr = util.TraceHull( {
            start = self:GetBonePosition(self:LookupBone("Hand")),
            endpos = self:GetBonePosition(self:LookupBone("Hand")),
            filter =  {self.Owner, self},
            mins = Vector( -25, -25, -25 ), 
            maxs = Vector( 25, 25, 25 ),
            ignoreworld = true,
            mask = MASK_SHOT_HULL
        } )
    if ( tr.Entity and tr.Entity:IsValid()) then
   
                            if SERVER and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:Fire("Break") end
    if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() )) then
        local dmginfo = DamageInfo()

        local attacker = self.Owner
        if ( !IsValid( attacker ) ) then attacker = self.Owner end
        dmginfo:SetAttacker( attacker )

        dmginfo:SetInflictor( self.Wep )

        if self.Wep:GetState() then
        dmginfo:SetDamage( 45 )
        else
        dmginfo:SetDamage( 15 )
        end
        dmginfo:SetDamageType(DMG_SLASH)
        tr.Entity:TakeDamageInfo( dmginfo )
		self.SoundTimer = self.SoundTimer or CurTime()
		if CurTime() > self.SoundTimer then
			self:EmitStandSound(stab2)	
			self:EmitStandSound(stab3)	
			self.SoundTimer = CurTime() + 0.2
		end
    end
    
    if tr.Entity:IsPlayer() then
        tr.Entity:ViewPunch( Angle( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) ) )
    end
    end
    end
    if self.CurrentAnim == "slice" then
        local tr = util.TraceHull( {
            start = self:GetPos(),
            endpos = self:GetBonePosition(self:LookupBone("Hand")),
            filter =  {self.Owner, self},
            mins = Vector( -55, -55, -25 ), 
            maxs = Vector( 55, 55, 25 ),
            ignoreworld = true,
            mask = MASK_SHOT_HULL
        } )
    if ( tr.Entity and tr.Entity:IsValid()) then

                            if SERVER and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue("explosion", "2") tr.Entity:SetKeyValue("gibdir", tostring(self:GetAngles())) tr.Entity:Fire("Break") end

    if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 )) then
        local dmginfo = DamageInfo()

        local attacker = self.Owner
        if ( !IsValid( attacker ) ) then attacker = self.Owner end
        dmginfo:SetAttacker( attacker )

        dmginfo:SetInflictor( self.Wep )
        --High damage, but not quite enough to kill.
        dmginfo:SetDamage( 45 )
        dmginfo:SetDamageType(DMG_SLASH)
        tr.Entity:TakeDamageInfo( dmginfo )
		self.SoundTimer = self.SoundTimer or CurTime()
		if CurTime() > self.SoundTimer then
			self:EmitStandSound(stab2)	
			self:EmitStandSound(stab3)	
			self.SoundTimer = CurTime() + 0.2
		end
        
    end
    
    if tr.Entity:IsPlayer() then
        tr.Entity:ViewPunch( Angle( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) ) )
    end
    end
    end
    if not self.Owner:gStandsKeyDown("modifierkey2") and !self.Wep:GetState() then
        self:SetPos(LerpVector(0.5, self.Owner:GetPos() - Vector(0,0,4), self:GetPos()))
		self.slice = false
    else
            self.Owner:AnimRestartGesture(GESTURE_SLOT_CUSTOM, self.Owner:GetSequenceActivity(self.Owner:LookupSequence("sit_zen")))

        local speed = 5
        self.loop:ChangePitch(15, 0.5)
        if self.Owner:KeyDown(IN_SPEED) then
            speed = 15
            self.speed = 125
            self.loop:ChangePitch(105, 0.5)
        end
        if not self.Owner:gStandsKeyDown("modifierkey2") and not (self.Owner:KeyDown( IN_JUMP ) and self.Owner:KeyDown(IN_SPEED)) and self.Owner:KeyDown( IN_FORWARD ) and util.PointContents((self:GetPos() + (self:GetForward() * speed)) + Vector(0,0,17)) != CONTENTS_SOLID then
            self:SetPos(self:GetPos() + (self:GetForward() * speed))
        end
        if not self.Owner:gStandsKeyDown("modifierkey2") and not (self.Owner:KeyDown( IN_JUMP ) and self.Owner:KeyDown(IN_SPEED)) and self.Owner:KeyDown( IN_BACK ) and util.PointContents((self:GetPos() - (self:GetForward() * speed)) + Vector(0,0,17)) != CONTENTS_SOLID then
            self:SetPos(self:GetPos() - (self:GetForward() * speed))
        end
        if self.Owner:KeyDown( IN_JUMP ) and self.Owner:KeyDown(IN_SPEED) and util.PointContents((self:GetPos() + (self:GetForward() * speed)) + Vector(0,0,17)) != CONTENTS_SOLID then
            self:SetPos(self:GetPos() + (self:GetForward() * speed * 2))
            self.slice = true
            self.speed = 250
        else
            self.slice = false
        end
        
        self:SetPos(Vector(self:GetPos().x, self:GetPos().y, trW.HitPos.z))
		self:SetAngles(Angle(0, self:GetAngles().y, self:GetAngles().r))
    end
    if SERVER and self.slice then
		if self:GetModel() ~= "models/gstands/stands/geb_dash.mdl" then
			self:SetModel("models/gstands/stands/geb_dash.mdl")
			self:EmitStandSound("geb.boost")
			self.ThumpSoundTimer = CurTime() + 0.3
		end
		if CurTime() > self.ThumpSoundTimer and math.Round(self:GetCycle(), 2) == 0.65 then
			self:EmitStandSound(thump)
			self.ThumpSoundTimer = CurTime() + 0.3
		end
		local tr = util.TraceHull( {
				start = self:GetPos(),
				endpos = self:GetPos(),
				filter = {self, self.Owner},
				mins = Vector( -45, -45, -45 ), 
				maxs = Vector( 45, 45, 45 ),
				ignoreworld = true,
				mask = MASK_SHOT_HULL
			} )
		if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 )) then
			local dmginfo = DamageInfo()

			local attacker = self.Owner
			if ( !IsValid( attacker ) ) then attacker = self.Owner end
			dmginfo:SetAttacker( attacker )

			dmginfo:SetInflictor( self.Wep )
			--High damage, but not quite enough to kill.
			dmginfo:SetDamage( 70 )
			dmginfo:SetDamageType(DMG_SLASH)
			tr.Entity:TakeDamageInfo( dmginfo )
			self.SoundTimer = self.SoundTimer or CurTime()
			if CurTime() > self.SoundTimer then
				self:EmitStandSound(stab2)	
				self:EmitStandSound(stab3)	
				self.SoundTimer = CurTime() + 0.2
			end
		end
    
		if tr.Entity:IsPlayer() then
			tr.Entity:ViewPunch( Angle( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) ) )
		end
	else
		if SERVER and self:GetModel() ~= "models/gstands/stands/geb.mdl" then
			self:SetModel("models/gstands/stands/geb.mdl")
		end
    end
    elseif SERVER then
        self:Remove()
    end
    self:SetNoDraw(false)
    self:NextThink( CurTime() )
    return true
end
end

function ENT:Jump()
	if SERVER then
		self.UpVelocity = 50
		self.JumpForward = self.Owner:GetAimVector()
		self:SetModel("models/gstands/stands/geb_dash.mdl")
		self:ResetSequence("bounce")
		self:EmitStandSound(stab1)
		self:EmitStandSound(drips1)
	end
end

local typemods = {
	[DMG_GENERIC] = 0.5,
	[DMG_CRUSH] = 0.1,
	[DMG_BULLET] = 0.4,
	[DMG_SLASH] = 0.6,
	[DMG_BURN] = 1.1,
	[DMG_VEHICLE] = 0.1,
	[DMG_FALL] = 0,
	[DMG_BLAST] = 0.9,
	[DMG_CLUB] = 0.7,
	[DMG_SHOCK] = 1,
	[DMG_SONIC] = 1,
	[DMG_ENERGYBEAM] = 1,
	[DMG_PREVENT_PHYSICS_FORCE] = 0,
	[DMG_NEVERGIB] = 0,
	[DMG_ALWAYSGIB] = 1,
	[DMG_DROWN] = 0,
	[DMG_PARALYZE] = 1,
	[DMG_NERVEGAS] = 1,
	[DMG_POISON] = 1,
	[DMG_RADIATION] = 1,
	[DMG_DROWNRECOVER] = 0,
	[DMG_ACID] = 1,
	[DMG_SLOWBURN] = 1.1,
	[DMG_REMOVENORAGDOLL] = 1,
	[DMG_PHYSGUN] = 0.5,
	[DMG_PLASMA] = 1,
	[DMG_AIRBOAT] = 0.3,
	[DMG_DISSOLVE] = 1.1,
	[DMG_BLAST_SURFACE] = 1,
	[DMG_DIRECT] = 1,
	[DMG_BUCKSHOT] = 0.4,
	[DMG_SNIPER] = 0.4,
	[DMG_MISSILEDEFENSE] = 1
}

function ENT:OnTakeDamage(dmg)
	if (!GetConVar("gstands_stand_hurt_stands"):GetBool() or string.StartWith(dmg:GetInflictor():GetClass(), "gstands_")) then
		dmg:SetDamage(dmg:GetDamage() * (typemods[dmg:GetDamageType()] or 1))
		self.Owner:TakeDamageInfo(dmg)
		return false
	end
end

local bottles = { --Mark 1 for opaque, 2 for translucent--
["models/props_junk/garbage_coffeemug001a.mdl"] = 1,
["models/props_junk/garbage_glassbottle001a.mdl"] = 1,
["models/props_junk/garbage_glassbottle002a.mdl"] = 1,
["models/props_junk/garbage_glassbottle003a.mdl"] = 1,
["models/props_junk/garbage_milkcarton001a.mdl"] = 1,
["models/props_junk/garbage_milkcarton002a.mdl"] = 1,
["models/props_junk/garbage_plasticbottle001a.mdl"] = 1,
["models/props_junk/garbage_plasticbottle002a.mdl"] = 1,
["models/props_junk/garbage_plasticbottle003a.mdl"] = 1,
["models/props_junk/gascan001a.mdl"] = 1,
["models/props_junk/GlassBottle01a.mdl"] = 1,
["models/props_junk/glassjug01.mdl"] = 2,
["models/props_junk/PopCan01a.mdl"] = 1
}
local bottle_offsets = {
["models/props_junk/glassjug01.mdl"] = Vector(0,0,1),
}
local mats = {
	"models/gstands/stands/geb/geb",
	"models/gstands/stands/geb/geb_red",
	"models/gstands/stands/geb/geb_green",
	"models/gstands/stands/geb/geb_violet",
	"models/gstands/stands/geb/geb_black",
	"models/gstands/stands/geb/geb_white",
	"models/gstands/stands/geb/geb_yellow",
	"models/gstands/stands/geb/geb_turquoise",
	"models/gstands/stands/geb/geb_additive",
	"models/gstands/stands/geb/geb_red_additive",
	"models/gstands/stands/geb/geb_green_additive",
	"models/gstands/stands/geb/geb_violet_additive",
	"models/gstands/stands/geb/geb_black_additive",
	"models/gstands/stands/geb/geb_white_additive",
	"models/gstands/stands/geb/geb_yellow_additive",
	"models/gstands/stands/geb/geb_turquoise_additive",
}
function ENT:DrawTranslucent()
    if CLIENT and LocalPlayer():GetActiveWeapon() then
        if LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then
            if not IsValid(self.Wep:GetBottle()) then
				self.Aura = self.Aura or CreateParticleSystem(self.Owner, "auraeffect", PATTACH_POINT_FOLLOW, 1)
				self.Aura:SetControlPoint(1, gStands.GetStandColor(self:GetModel(), self:GetSkin()))
				self.StandAura = self.StandAura or CreateParticleSystem(self, "auraeffect", PATTACH_POINT_FOLLOW, 1)
				self.StandAura:SetControlPoint(1, gStands.GetStandColor(self:GetModel(), self:GetSkin()))
				self:DrawModel() -- Draws Model Client Side
				if self:GetModel() == "models/gstands/stands/geb_dash.mdl" then
					self.DashParticle = self.DashParticle or CreateParticleSystem(self, "dashsplash", PATTACH_POINT_FOLLOW, 1)
					self.DashParticle:SetControlPoint(1, gStands.GetStandColor("models/gstands/stands/geb.mdl", self:GetSkin()))
					elseif self.DashParticle then
					self.DashParticle:StopEmission()
					self.DashParticle = nil
				end
			else
				if self.StandAura then
					self.StandAura:StopEmission()
					self.StandAura = nil
				end
				if bottles[self.Wep:GetBottle():GetModel()] == 2 then
					local bottle = self.Wep:GetBottle()
					local pos = bottle:GetPos()
					bottle:SetMaterial(mats[self:GetSkin() + 1])
					bottle:SetModelScale(0.9)
					bottle:SetPos(pos + bottle_offsets[bottle:GetModel()])
					bottle:SetupBones()
					bottle:DrawModel()
					bottle:SetMaterial(mats[self:GetSkin() + 9])
					bottle:DrawModel()
					bottle:SetMaterial("")
					bottle:SetModelScale(1)
					bottle:SetPos(pos)
					bottle:SetupBones()
					bottle:DrawModel()
				end
			end
        end
        elseif (self.Aura and self.StandAura) then
        self.Aura:StopEmission()
        self.StandAura:StopEmission()
        self.Aura = nil
        self.StandAura = nil
		if self.DashParticle then
			self.DashParticle:StopEmission()
			self.DashParticle = nil
		end
    end
end
