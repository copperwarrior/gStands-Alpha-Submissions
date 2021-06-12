ENT.Type                 = "anim"
ENT.Base                 = "base_anim"

ENT.PrintName            = "FoolStand"
ENT.Author               = "Copper"
ENT.Contact              = ""
ENT.Purpose              = "To stand"
ENT.Instructions         = "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable            = false
ENT.AdminSpawnable       = false
ENT.RenderGroup          = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance= true
ENT.Animated             = true
ENT.Color                = Color(150,150,150,1)
ENT.ForceOnce            = false
ready                    = false
ENT.ImageID              = 1
ENT.Rate                 = 0
ENT.Health               = 1
ENT.rgl                  = 1.3
ENT.ggl                  = 1.3
ENT.bgl                  = 1.3
ENT.rglm                 = 1.3
ENT.gglm                 = 1.3
ENT.bglm                 = 1.3
ENT.FlameFX              = nil
ENT.PhysgunDisabled      = true
ENT.Range                = 150
ENT.ItemPickedUp         = NUL
ENT.Speed                = 1
ENT.Flashlight           = self
game.AddParticles("particles/stand_deploys.pcf")
game.AddParticles("particles/fool.pcf")
PrecacheParticleSystem("sanddrip")
local Impact = Sound("fool.impact")
local Fly = Sound("weapons/fool/flyloop.wav")
function ENT:GetEyePos()
		local att = self:LookupAttachment("anim_attachment_head")
		local tab = self:GetAttachment(att)
		if !tab then
			tab = {}
			tab.Pos = self:WorldSpaceCenter()
		end
		return tab.Pos or self:WorldSpaceCenter()
end
function ENT:SetupDataTables()
	self:NetworkVar("Angle", 3, "IdealAngles")
	self:NetworkVar("Vector", 4, "IdealPos")
	self:NetworkVar("Float", 5, "Range")
	self:NetworkVar("Bool", 8, "MarkedToFade")
	self:NetworkVar("Bool", 10, "InDoDoDo")
	self:NetworkVar("Bool", 11, "InStill")
	self:NetworkVar("Bool", 12, "Frozen")
	self:NetworkVar("Float", 13, "DomeHealth")
end

function ENT:DomeModeEnable()
	self:SetModel("models/gstands/stand_acc/foolsand_effect.mdl")
	self:ResetSequence(2)
	self:SetModelScale(1.5, 0.5)
	self:SetCycle(0)
	self.DomeMode = true
	timer.Simple(self:SequenceDuration()/2, function()
		if IsValid(self) then
			self:SetSolid(SOLID_VPHYSICS)
			self:SetModelScale(1, 0.1)
			self:SetModel("models/gstands/stands/dome.mdl")
			self:SetCollisionGroup(COLLISION_GROUP_NONE)
			self:SetMoveType(MOVETYPE_NONE)
			local tr = util.TraceLine({
				start = self.Owner:GetPos(),
				endpos = self.Owner:GetPos() - Vector(0,0,38675),
				mask = MASK_SOLID_BRUSHONLY
			})
			self.DomePos = tr.HitPos
			local ang = self:GetAngles()
			ang.p = 0
			self:SetAngles(ang)
			self.DomeMode = true
			self.Owner:AddFlags(FL_ATCONTROLS)
			self:SetDomeHealth(3500)
			self:PhysicsInit(SOLID_VPHYSICS)
			if IsValid(self:GetPhysicsObject()) then
				self:GetPhysicsObject():EnableMotion(false)
			end
		end
	end)
end

function ENT:DomeModeDisable()
	self:SetModel("models/gstands/stand_acc/foolsand_effect.mdl")
	self:ResetSequence(2)
	self:SetModelScale(1.5, 0.5)
	self:SetCycle(0)
	self.DomeMode = true
	timer.Simple(self:SequenceDuration()/3, function()
	if IsValid(self) then
		self:SetModelScale(1, 0.1)
		self:SetSolid( SOLID_OBB )
		self:PhysicsDestroy()
		self:SetModel("models/gstands/stands/thefool.mdl")
		self:SetMoveType( MOVETYPE_NOCLIP )
		self:SetSolidFlags( FSOLID_NOT_STANDABLE )
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self.DomeMode = false
		self.Owner:RemoveFlags(FL_ATCONTROLS)
	end
	end)
end

function ENT:Initialize()
	self.Wep = self.Owner:GetActiveWeapon()
	self:SetSolid( SOLID_OBB )
	self:SetMoveType( MOVETYPE_NOCLIP )
	self:SetSolidFlags( FSOLID_NOT_STANDABLE )
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.Owner:SetNWBool("Active_"..self.Owner:GetName(), false)
	--Initial animation base
	--Default offset. Made for when stands were planned to move on their own.
	offset = Vector(-20,20,30)
	self.Rate = math.random(0,5)
		if SERVER and self.ImageID == 1 then
		self:SetSkin(self.Owner:GetInfoNum("gstands_standskin_"..self.Wep.ClassName, math.random(0, self:SkinCount() - 1))
		)
		self:SetHealth(self.Owner:Health())
	end
	
	self:Think( )
	self.Flashlight = self.Flashlight or self
	self.Delay = CurTime() + 0.1
	ParticleEffectAttach("stand_basic", PATTACH_ABSORIGIN_FOLLOW, self.Owner, 0)
	self:SetPos(self.Owner:GetPos())
	hook.Add("SetupPlayerVisibility", "standnocullbreak"..self.Owner:GetName()..self:EntIndex(), function(ply, ent)
		if self:IsValid() and self.Owner:IsValid() and self:IsValid() then
			AddOriginToPVS( self:WorldSpaceCenter() )
			
		end
	end)
	hook.Add("PlayerSwitchFlashlight", "StandFlashlightsareCool"..self.Owner:GetName()..self:EntIndex(), function(ply, boolian)
		if ply == self.Owner then
			if self.Flashlight == self and self.Flashlight:IsValid() then
				self.Flashlight = ents.Create("env_projectedtexture")
				if self.Flashlight != self and self.Flashlight:IsValid() then
					self.Flashlight:SetPos(self:WorldSpaceCenter())
					self.Flashlight:SetAngles(self:GetAngles())
					self.Flashlight:SetParent(self)
					self.Flashlight:SetKeyValue("lightfov", 75)
					self.Flashlight:SetKeyValue("enableshadows", "true" )
					self:EmitStandSound("items/flashlight1.wav")
				end
				elseif self.Flashlight:IsValid() then
				self.Flashlight:Remove()
				self.Flashlight = self
				self:EmitStandSound("items/flashlight1.wav")
				
			end
			return false
		end
		
	end)
	hook.Add("EntityTakeDamage", "OwnerTakesNoBlastDamage"..self:EntIndex(), function(targ, dmg)
		
		if self:IsValid() and self.Owner:IsValid() and targ == self.Owner then
			if dmg:GetDamageType() == DMG_BLAST then
				if !string.StartWith(dmg:GetInflictor():GetClass(), "gstands_") then
					local tr = util.TraceLine( {
						start = dmg:GetReportedPosition(),
						endpos = self.Owner:WorldSpaceCenter(),
						filter = {self.Owner},
						mask = MASK_SHOT_HULL
					} )
					if tr.Entity == self then
						return true
					end
				end
			end
			if dmg:IsFallDamage() and self:GetBodygroup(1) == 1 then
				return true
			end
		end
		if IsValid(self) and IsValid(self.Owner) and targ == self.Owner then
			if self.DomeMode then
				self:TakeDamageInfo(dmg)
				return true
			end
		end
	end)
	if SERVER then
		self:EmitSound("sand_idle")
		local name = self:EntIndex()..self.Owner:GetName()
		timer.Create("Foolidle"..name, 9.2, 0, function() if self:IsValid() and !GetConVar("gstands_time_stop"):GetBool() then self:EmitSound("sand_idle") else timer.Remove("FoolLoop"..name) end end)
	end
end

function ENT:Slash(knockback, hand)
	knockback = knockback or 1
		local tr = util.TraceHull( {
		start = self:GetBonePosition(0),
		endpos = self:GetBonePosition(self:LookupBone(hand or "r_hand")),
		filter = {self.Owner, self},
		mins=-Vector(25,25,25),
		maxs=Vector(25,25,25),
		ignoreworld = true,
		mask = MASK_SHOT_HULL
	} )
	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Entity && tr.Entity:IsValid() && !tr.Entity:IsWorld() && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound(Impact)
	end
		local hit = false
	if SERVER and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue("explosion", "2") tr.Entity:SetKeyValue("gibdir", tostring(self:GetAngles())) tr.Entity:Fire("Break") end
		if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self.Owner end
		dmginfo:SetAttacker( attacker )
		
		dmginfo:SetInflictor( self.Owner:GetActiveWeapon() or self )
		dmginfo:SetDamage(GetConVar("gstands_the_fool_slash_punch"):GetInt())
		tr.Entity:TakeDamageInfo( dmginfo )
		
		tr.Entity:SetVelocity( (self.Owner:GetAimVector() + Vector( 0, 0, 5 )) * (knockback ^ 2.2))
		
	end
		if tr.Entity:IsPlayer() then
		tr.Entity:ViewPunch( Angle( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) ) )
	end
		if ( SERVER && IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 800 * phys:GetMass(), tr.HitPos )
		end
	end
		--Stand leaps! Punch the ground, go flying back. Donut punch is high power.
	if ( tr.HitWorld ) then
		self.Owner:SetVelocity( self.Owner:GetAimVector() * -32 + Vector( 0, 0, 32 ) )
	end
		self.Owner:LagCompensation( false )
end
function ENT:OnRemove()
	hook.Remove("PlayerSwitchFlashlight", "StandFlashlightsareCool"..self.Owner:GetName()..self:EntIndex())
	if CLIENT and self.Aura then
		self.Aura:StopEmission()
	end
	return false
end
function ENT:DropItem()
	if self.ItemPickedUp:IsValid() and self.ItemPickedUp != self then
		if self.ItemPickedUp:GetPhysicsObject():IsValid() then
			self.ItemPickedUp:GetPhysicsObject():Wake()
			self.ItemPickedUp:GetPhysicsObject():EnableGravity(true)
			self.ItemPickedUp:GetPhysicsObject():ClearGameFlag(FVPHYSICS_PLAYER_HELD)
			self.ItemPickedUp:GetPhysicsObject():SetDragCoefficient(0)
		end
		self.ItemPickedUp = self
	end
end

function ENT:OnTakeDamage(dmg)
	if self.DomeMode then
		self:SetDomeHealth(self:GetDomeHealth() - dmg:GetDamage())
		if self:GetDomeHealth()  < 0 then
			self:DomeModeDisable()
		end
	end
end

function ENT:DoAnimations()
	if SERVER then
		if (self.Owner:GetActiveWeapon():IsValid() and self.Owner:GetActiveWeapon():GetHoldType() != "pistol") then
			if self:LookupSequence("standidle") != -1 and self:GetSequence() != self:LookupSequence("standidle") then
				self:ResetSequence( self:LookupSequence("standidle"))
			end
			elseif SERVER then
			self:SetPlaybackRate(1)
		end
	end
end

hook.Add("SetupMove", "FoolFly", function(ply, mv)
	if IsValid(ply) and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "gstands_fool" then
		if IsValid(ply:GetActiveWeapon()) then
			local self = ply:GetActiveWeapon():GetStand()
			if self:GetSequence() == self:LookupSequence("fly") then
			local vel = 65
			velf = self:GetForward()
			local absoluteforward = Vector(velf.x, velf.y, 0)
			velf.z = 5 + ( 5 * math.abs(velf:Dot(absoluteforward)))
			velf.z = math.min(velf.z, 8.7)

			velf = velf + mv:GetVelocity()
				mv:SetVelocity(velf)
			end
		end
	end
end)

function ENT:DoMovement()
	if !self:GetMarkedToFade() then
	local Active = false
	if self.Wep.GetActive then
		Active = self.Wep:GetActive()
	end
	local offset = Vector()
	offset.z = -15
	offset.x = -40
	offset.y = 40
	if self.DomeMode and self.DomePos then
		self.Owner:SetPos(self.DomePos)
		self:SetPos(self.DomePos)
		return
	end
	if self:GetParent() != nil and !self:GetParent():IsValid() then
		if (self:GetSequence() != self:LookupSequence("IDLE_PISTOL")) and (!self.InStill and !self:GetInDoDoDo()) then
			self:SetIdealAngles(Angle(0, self.Owner:GetAngles().y, self.Owner:GetAngles().r ))
		end
		if !(self:GetInDoDoDo() or self.InStill) and (self.Owner:GetActiveWeapon():IsValid() and self.Owner:GetActiveWeapon():GetHoldType() != "pistol") then
				self:SetIdealPos(self.Owner:GetPos() + (self.Owner:GetForward() * offset.x) + (self.Owner:GetRight() * offset.y) - Vector(0,0,offset.z))
				self.Pos = self:GetPos()
			elseif !((self.InStill or self:GetInDoDoDo()) and self.DistToOwner <= self.Range) then
					self:SetIdealPos(self.OwnerCenterPos + (self.Owner:GetAimVector() * (45 - self.Owner:EyeAngles().p / 2)))
					self.Pos = self:GetPos()
			local _, ang = self.Owner:EyePos()
			if !self.InStill and !self:GetInDoDoDo() then
				self:SetIdealAngles(self.Owner:EyeAngles())
			end
			self.Delay = CurTime() + 0.1
			elseif Active then
			self:SetPos((self.OwnerPos - Vector(0,0,50)))
			self:SetIdealPos((self.OwnerPos - Vector(0,0,50)))
			self.Pos = self:GetPos()
			if !self:GetMoveParent():IsValid() then
				self:GetMoveParent(self.Owner)
			end
			elseif self:GetSequence() == self:LookupSequence("timestop") or self:GetSequence() == self:LookupSequence("flick") then
			self:SetIdealPos(self.Owner:EyePos() + (self.Owner:GetForward() * offset.x) + (self.Owner:GetRight() * offset.y) - Vector(0,0,offset.z))
			self.Pos = self:GetPos()
	end
		elseif Active then
		self:SetPos((self.OwnerPos - Vector(0,0,50)))
		self:SetIdealPos((self.OwnerPos - Vector(0,0,50)))
		self.Pos = self:GetPos()
	end
	if self:GetInDoDoDo() and (self.StandId == GSTANDS_TGRAY) and !self.Owner:KeyDown(IN_ATTACK2) then
		self:SetPlaybackRate(1)
		elseif (self.StandId == GSTANDS_TGRAY ) and !self.Wep:GetHoldType() == "pistol" then
		self:ResetSequence(self:LookupSequence("idle"))
		elseif self:GetInDoDoDo() and (self.StandId == GSTANDS_TGRAY ) and !self.Wep:GetHoldType() == "pistol" then
		self:ResetSequence(self:LookupSequence("idle"))
	end
	self.StandVelocity = self.StandVelocity or Vector(0,0,0)
	if self:GetInDoDoDo() and self.StandId != GSTANDS_JST then
			self.Owner:AddFlags(FL_ATCONTROLS)
			self:SetIdealAngles((self.Owner:GetAimVector():Angle()))
			if !((self.StandId == GSTANDS_TGRAY) and self.Owner:KeyDown(IN_SPEED) and IsValid(self.Wep) and IsValid(self.Wep:GetLockTarget())) and self.Owner:KeyDown(IN_FORWARD) then
				self.StandVelocity = (self.StandVelocity + self.Owner:GetAimVector()):GetNormalized()
				self:SetPoseParameter( "move_x", Lerp(0.2, self:GetPoseParameter( "move_x" ), 1 ))
				else
				self:SetPoseParameter( "move_x", Lerp(0.01, self:GetPoseParameter( "move_x" ), 0 ))
			end
			if self.Owner:KeyDown(IN_BACK) then
				self.StandVelocity = (self.StandVelocity - self.Owner:GetAimVector()):GetNormalized()
					self:SetPoseParameter( "move_x", Lerp(0.2, self:GetPoseParameter( "move_x" ), -1 ))
				else
					self:SetPoseParameter( "move_x", Lerp(0.01, self:GetPoseParameter( "move_x" ), 0 ))
			end
			if self.Owner:KeyDown(IN_MOVELEFT) then
				self.StandVelocity = (self.StandVelocity - self.Owner:GetAimVector():Angle():Right()):GetNormalized()
				self.Pos = self:GetPos()
					self:SetPoseParameter( "move_y", Lerp(0.2, self:GetPoseParameter( "move_y" ), -1 ))
				else
					self:SetPoseParameter( "move_y", Lerp(0.01, self:GetPoseParameter( "move_y" ), 0 ))
			end
			if self.Owner:KeyDown(IN_MOVERIGHT) then
				self.StandVelocity = (self.StandVelocity + self.Owner:GetAimVector():Angle():Right()):GetNormalized()
				self.Pos = self:GetPos()
					self:SetPoseParameter( "move_y", Lerp(0.2, self:GetPoseParameter( "move_y" ), 1 ))
				else
					self:SetPoseParameter( "move_y", Lerp(0.01, self:GetPoseParameter( "move_y" ), 0 ))
			end
			if self.Owner:KeyDown(IN_JUMP) then
				self.StandVelocity = (self.StandVelocity + Vector(0,0,1)):GetNormalized()
				self.Pos = self:GetPos()
			end
			if !self.Owner:gStandsKeyDown("modifierkey2") and self.Owner:KeyDown(IN_DUCK) then
				self.StandVelocity = (self.StandVelocity - Vector(0,0,1)):GetNormalized()
				self.Pos = self:GetPos()
			end
		elseif !self:GetInDoDoDo() and not self.DomeMode then
			self.Owner:RemoveFlags(FL_ATCONTROLS)
			
		end
		local FTr = util.TraceLine({
				start = self.Pos,
				endpos = self.Pos + self.StandVelocity * self.Speed * 5,
				filter = {self, self.Owner},
				collisiongroup = self:GetCollisionGroup()
				})
		if self.OwnerPos:Distance(self.Pos + self.StandVelocity * self.Speed) < self.Range then
			if FTr.Hit then
				self.StandVelocity = self.StandVelocity + FTr.HitNormal/5
			end
			if self:GetInDoDoDo() then
				self:SetIdealPos((self.Pos + self.StandVelocity * FTr.Fraction * self.Speed))
			end
		end
		self.StandVelocity = self.StandVelocity / 1.1
		if (self.StandId == GSTANDS_TGRAY) then
			self.StandVelocity = self.StandVelocity / 1.5
		end
		
	
	end
	if (self.StandId == GSTANDS_TGRAY) and self.Owner:KeyDown(IN_SPEED) and IsValid(self.Wep) and IsValid(self.Wep:GetLockTarget()) then
		self:SetIdealAngles((LerpVector(0.1, self.Wep:GetLockTarget():EyePos(), self.Wep:GetLockTarget():WorldSpaceCenter()) - self:GetPos()):Angle())
		if self.Owner:KeyDown(IN_FORWARD) then
		self.StandVelocity = ((self.Wep:GetLockTarget():EyePos() - self.Wep:GetLockTarget():GetAimVector() * 75) - self:GetPos()):GetNormalized()
		end
	end
		self:SetAngles(LerpAngle(0.3, self:GetAngles(), self:GetIdealAngles()))
		if self:GetPos() != self:GetIdealPos() and !self.SendForward then
		local LastPos = self:GetPos()
		self:SetPos(LerpVector(0.7, self:GetPos(), self:GetIdealPos()))
		local dir = (self:GetPos() - LastPos):GetNormalized()
		self:SetIdealPos(LerpVector(0.7, self:GetPos(), self:GetIdealPos()))
		end
	if self.SendForward and (self.Pos + self.StandVelocity * self.Speed):Distance(self.OwnerPos) <= self.Range then
		self:SetPos((self.Pos + self.StandVelocity * self.Speed))
		self:SetIdealPos((self.Pos + self.StandVelocity * self.Speed))
		self.Pos = self:GetPos()
	end 
end
function ENT:Think()
	self:RemoveAllDecals()
	self:SetRange(self.Range)
	self.Range = self:GetRange()
	if GetConVar("gstands_unlimited_stand_range"):GetBool() then
		self.Range = 100000000000
	end
	self.OwnerPos = self.Owner:GetPos()
	self.OwnerCenterPos = self.Owner:WorldSpaceCenter()
	self.CenterPos = self:WorldSpaceCenter()
	self.Pos = self:GetPos()
	self.Forward = self:GetForward()
	self.DoDoDoTimer = self.DoDoDoTimer or CurTime()
	if self.Owner:GetInfoNum("gstands_active_dododo_toggle", 1) == 1 and SERVER and CurTime() > self.DoDoDoTimer and self.Owner:gStandsKeyDown("dododo") and self.StandId != GSTANDS_JST then
		self.DoDoDoTimer = CurTime() + 0.3
		self:SetInDoDoDo(!self:GetInDoDoDo())
	end
	if self.Owner:GetInfoNum("gstands_active_dododo_toggle", 1) == 0 then
		self:SetInDoDoDo(self.Owner:gStandsKeyDown("dododo"))
		end
	self.InStill = self.Owner:gStandsKeyDown("modifierkey2")
	self.DistToOwner = self.Pos:Distance(self.OwnerPos)
	self.Model = self:GetModel()
	self.Wep = self.Wep or self.Owner:GetActiveWeapon()
	if self:GetParent():IsValid() and self:GetModel() != "models/gstands/stands/thefool.mdl" then
		self:SetBodygroup(1,0)
		self:SetParent()
	end
	self.AnimDelay = self.AnimDelay or CurTime() + 1
	if SERVER and (!self.AnimDelay or CurTime() >= self.AnimDelay) then
		self:DoAnimations()
	end
	if SERVER and !self:GetFrozen() then
		self:DoMovement()
	end
	if self:GetModel() == "models/gstands/stands/thefool.mdl" then
		self.ItemPickedUp = self.ItemPickedUp or self
		if self.Owner and self.Owner:GetActiveWeapon():IsValid() and self.Owner:GetActiveWeapon():GetHoldType() != "fist" then
			self:DropItem()
		end
		if !self.Owner:gStandsKeyDown("dododo") and self.ItemPickedUp:IsValid() and self.ItemPickedUp != self then
			self:DropItem()
		end
		if self.Owner:KeyPressed(IN_USE) and self.Owner:gStandsKeyDown("dododo") then
			local tra = util.TraceHull( {
				start = self:WorldSpaceCenter() - self:GetForward() * 12,
				mins = Vector(-5,-5,-5),
				maxs = Vector(5,5,5),
				endpos = self:WorldSpaceCenter() + self:GetForward() * 100,
				filter = {self.Owner, self},
				ignoreworld = true,
			} )
			if tra.Entity:IsValid() and SERVER then
				if !tra.Entity:IsVehicle() then
					tra.Entity:Use(self.Owner, self, USE_TOGGLE, 1)
				end
				if gmod.GetGamemode():PlayerCanPickupItem(self.Owner, tra.Entity) and tra.Entity:GetPhysicsObject():GetMass() <= 500 and !tra.Entity:IsPlayer() or (GetConVar("gstands_time_stop"):GetBool() and tra.Entity:IsPlayer()) then
					self.ItemPickedUp = tra.Entity
				end
			end
		end
		self:SetVelocity(-self:GetVelocity())
		
		if SERVER and self.Owner:KeyPressed(IN_JUMP) then
			self:EmitSound("sand_loop")
			local name = self:EntIndex()..self.Owner:GetName()
			timer.Create("FoolLoop"..name, 9.2, 0, function() if self:IsValid() and self.Owner:KeyDown(IN_JUMP) and !GetConVar("gstands_time_stop"):GetBool() then self:EmitSound("sand_loop") else timer.Remove("FoolLoop"..name) end end)
			self:ResetSequence(self:LookupSequence("flystart"))
			self.AnimDelay = CurTime() + 1
		end
		if SERVER and (self.Owner:KeyReleased(IN_JUMP) or GetConVar("gstands_time_stop"):GetBool()) then
			self:StopSound("sand_loop")
			self:ResetSequence(self:LookupSequence("flyend"))
			self.AnimDelay = CurTime() + 1
		end
		if SERVER and GetConVar("gstands_time_stop"):GetBool() then
			self:StopSound("sand_idle")
		end
		if self.Owner:KeyDown(IN_JUMP) then
			if (self:GetSequence() == self:LookupSequence("flystart") and self:GetCycle() > 0.9) or self:GetSequence() == self:LookupSequence("fly") then
			self:ResetSequence(self:LookupSequence("fly"))
			end
			if  (self:GetSequence() == self:LookupSequence("flystart")) or self:GetSequence() == self:LookupSequence("fly") then
				offset.z = -82
				offset.x = -20
				offset.y = 0
				self.AnimDelay = CurTime() + 1
				self:SetBodygroup(1,1)
				self:SetPos(self.Owner:GetPos() + (self.Owner:GetForward() * offset.x) + (self.Owner:GetRight() * offset.y) - Vector(0,0,offset.z))
				--if self.Owner:GetVelocity().z >= 200 then
				self:SetAngles(self.Owner:EyeAngles())
				--else
				--self.Owner:SetVelocity(((self.Owner:GetUp()) * 7.3) + self.Owner:GetAimVector())
				--end
				if !self:GetMoveParent():IsValid() then
					self:SetAngles(self.Owner:EyeAngles())
				end
				elseif self:GetMoveParent():IsValid() then
				self:SetBodygroup(1,0)
				self:SetMoveParent()
			end
		end
		if self:GetMoveParent():IsValid() and !self.Owner:KeyDown(IN_JUMP) then
			self:SetBodygroup(1,0)
			self:SetParent()
		end
		else
		self:SetVelocity(-self:GetVelocity())
		
		
	end
	if CLIENT then
	end
	--Call the next think manually too because why not
	self:NextThink( CurTime() + 0.000001)
	if CLIENT then
		self:SetNextClientThink( CurTime() )
	end
		return true
end
local SandTable = {
	["models/gstands/stands/thefool.mdl0"] = Vector(0.8, 0.8, 0.5),
	["models/gstands/stands/thefool.mdl1"] = Vector(1, 1, 0.5),
	["models/gstands/stands/thefool.mdl2"] = Vector(1, 0.3, 0),
	["models/gstands/stands/thefool.mdl3"] = Vector(0.8, 0.8, 0.5),
	["models/gstands/stands/thefool.mdl4"] = Vector(1, 0.5, 0),
	["models/gstands/stands/thefool.mdl5"] = Vector(0.8, 0.8, 1),
}
local SandSkinTable = {
	["models/gstands/stands/thefool.mdl0"] = Material("models/gstands/stands/foolsand/foolsand"),
	["models/gstands/stands/thefool.mdl1"] = Material("models/gstands/stands/foolsand/foolsand_blue"),
	["models/gstands/stands/thefool.mdl2"] = Material("models/gstands/stands/foolsand/foolsand_red"),
	["models/gstands/stands/thefool.mdl3"] = Material("models/gstands/stands/foolsand/foolsand_brown"),
	["models/gstands/stands/thefool.mdl4"] = Material("models/gstands/stands/foolsand/foolsand_violet"),
	["models/gstands/stands/thefool.mdl5"] = Material("models/gstands/stands/foolsand/foolsand_lightblue"),
}
function ENT:GetSandColor(mdl, skin)
	index = mdl..skin
	return SandTable[index] or Vector(255,255,255)
end
local sand = Material("models/gstands/stands/foolsand/foolsand")
function ENT:GetSandSkinColor(mdl, skin)
	index = mdl..skin
	return SandSkinTable[index] or sand
end

function ENT:Draw()
	if !IsValid(self.Owner) then
		return true 
	end
	local LOD = self.Pos:Distance(EyePos())
	self.LOD = 0
	if LOD >= 100 then
		self.LOD = 1
	end
	if LOD >= 300 then
		self.LOD = 2
	end
	if LOD >= 500 then
		self.LOD = 3
	end
	if CLIENT and !self.Owner:GetNoDraw() and LocalPlayer():GetActiveWeapon() then
		if (LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer())) then
			--self.BaseClass.Draw(self) -- Overrides Draw
				
				if !self.OwnerNoDraw and self.LOD < 2 and !(self.StandId == GSTANDS_CREAM and self.Wep:GetActive())  then
					self:SetupBones()
					self.Aura = self.Aura or CreateParticleSystem(self.Owner, "auraeffect", PATTACH_POINT_FOLLOW, 1)
					if self.Aura then
						self.Aura:SetControlPoint(1, gStands.GetStandColor(self.Model, self:GetSkin()))
					end
					if self.LOD < 2 then
						self.StandAura = self.StandAura or CreateParticleSystem(self, "sanddrip", PATTACH_POINT, 1)
						if self.StandAura then
							self.StandAura:SetControlPoint(1, self:GetSandColor("models/gstands/stands/thefool.mdl", self:GetSkin()))
							self.StandAura:SetControlPoint(0, self:GetIdealPos())
							self.StandAura:SetShouldDraw(false)
						end
					end
					elseif (self.Aura and self.StandAura) or self.OwnerNoDraw or (self.Aura and self.StandAura and self.StandId == GSTANDS_CREAM and self.Wep:GetActive()) then
					self.Aura:StopEmission()
					self.StandAura:StopEmission()
					self.Aura = nil
					self.StandAura = nil
				end
				if self.StandAura then
					self:SetupBones()
					self.StandAura:Render()
				end
				if self:GetSequence() == self:LookupSequence("standdeploy") and self:GetCycle() < 0.8 then
					render.MaterialOverride(self:GetSandSkinColor("models/gstands/stands/thefool.mdl", self:GetSkin()))
					self:DrawModel()
					render.MaterialOverride()
					render.SetBlend(self:GetCycle() + 0.5)
				end
			if !self:GetNoDraw() then
				self:DrawModel() -- Draws Model Client Side
				if self:GetModel() == "models/gstands/stands/dome.mdl" then
					if self:GetDomeHealth() < 3500 then
						self:SetMaterial("models/gstands/stands/thefool/dome_crack1.vmt")
						render.SetBlend(math.Remap(self:GetDomeHealth(), 750, 3500, 1, 0))
						self:DrawModel()
					end
					if self:GetDomeHealth() < 3500 * 0.5 then
						self:SetMaterial("models/gstands/stands/thefool/dome_crack2.vmt")
						render.SetBlend(math.Remap(self:GetDomeHealth(), 0, 750, 1, 0))
						self:DrawModel()
					end
					self:SetMaterial("")
					render.SetBlend(1)
				end
			end
			
			else
			render.MaterialOverride(self:GetSandColor("models/gstands/stands/thefool.mdl", self:GetSkin()))
					self:DrawModel()
		end
		if GetConVar("gstands_show_hitboxes"):GetBool() then
			for i = 0, self:GetHitBoxCount(0) - 1 do
				local cmins, cmaxs = self:GetHitBoxBounds(i, 0)
				local cpos, cang = self:GetBonePosition(self:GetHitBoxBone(i, 0))
				render.DrawWireframeBox(cpos, cang, cmins, cmaxs, Color(255,0,0,255), true)
			end
			local cmins, cmaxs = self:GetCollisionBounds()
			render.DrawWireframeBox(self:GetPos(), self:GetAngles(), cmins, cmaxs, Color(0,255,0,255), true)
		end

		
	end
end
