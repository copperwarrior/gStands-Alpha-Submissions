ENT.Type = "anim"
ENT.Base = "stand"

ENT.PrintName= "Hanged Man"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "To stand"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
if !GetConVar("gstands_opaque_stands"):GetBool() then
	ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
	else
	ENT.RenderGroup = RENDERGROUP_OPAQUE
end
ENT.AutomaticFrameAdvance = true
ENT.Animated = true
local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "E3_Phystown.Slicer" )
local Pew = Sound( "hdm.pew" )
local Stab = Sound( "hdm.stab" )
local FlickOut = Sound( "weapons/hdm/stab/stab_01.wav" )
local PullOut = Sound( "weapons/hdm/stab/stab_03.wav" )
local Grab = Sound( "weapons/hdm/grab.wav" )
local Deploy = Sound( "weapons/hdm/deploy.wav" )
local FadeIn = Sound( "weapons/hdm/fade_in.wav" )
local FadeOut = Sound( "weapons/hdm/fade_out.wav" )
local BackstabInsults = Sound( "hdm.stabinsults" )
function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "ActiveWeapon")
	self:NetworkVar("Entity", 1, "CenterImage")
	self:NetworkVar("Int", 2, "ImageID")
	self:NetworkVar("Angle", 3, "IdealAngles")
	self:NetworkVar("Vector", 4, "IdealPos")
	self:NetworkVar("Float", 5, "Range")
	self:NetworkVar("Entity", 6, "AITarget")
	self:NetworkVar("Bool", 7, "BlockCap")
	self:NetworkVar("Bool", 8, "MarkedToFade")
	self:NetworkVar("Entity", 9, "Image")
	self:NetworkVar("Bool", 10, "InDoDoDo")
	self:NetworkVar("Bool", 11, "InStill")
	self:NetworkVar("Bool", 12, "Frozen")
	self:NetworkVar("Vector", 13, "HEGEndPos")
	self:NetworkVar("Entity", 14, "BackstabTarget")
end

function ENT:Disable(silent)
	if silent then
		self.Owner:KillSilent()
		else
		self.Owner:Kill()
	end
	self:Remove()
end

function ENT:Withdraw()
	self:SetMarkedToFade(true)
	timer.Simple(0.3, function()
		if SERVER and IsValid(self) then
			self:Remove()
		end
	end)
end
function ENT:DoImpactEffect()
	return true
end
function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
function ENT:Initialize()
	if SERVER then
		self:SetLagCompensated(true)
	end
	self:DrawShadow(false)
	self.Wep = self.Owner:GetActiveWeapon()
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.OwnerPos = self.Owner:GetPos()
	self.OwnerCenterPos = self.Owner:WorldSpaceCenter()
	self.CenterPos = self:WorldSpaceCenter()
	self.Pos = self:GetPos()
	self.Forward = self:GetForward()
	self.InStill = self.Owner:KeyDown(IN_USE)
	self.DistToOwner = self.Pos:Distance(self.OwnerPos)
	self.StandId = GetgStandsID(self:GetModel())
	if SERVER then
		self:SetImageID(self.ImageID)
	end
	self:SetSolid( SOLID_NONE )
	self:SetMoveType( MOVETYPE_NOCLIP )
	
	self:SetSolidFlags( FSOLID_NOT_STANDABLE )
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self.Model = self:GetModel()
	self:SetRenderMode(RENDERMODE_WORLDGLOW)
	self.OwnerName = self.Owner:GetName()
	self.Color = self:GetColor()
	if SERVER then
		self:SetSkin(self.Owner:GetInfoNum("gstands_standskin_"..self.Wep.ClassName, math.random(0, self:SkinCount() - 1)))
		self:SetHealth(self.Owner:Health())
	end
	self.Delay = CurTime() + 0.1
	self.OwnerPos = self.Owner:GetPos()
	self:SetPos(self.OwnerPos)
	self.Pos = self:GetPos()
	local hooktag = self.OwnerName..self:EntIndex()
	hook.Add("SetupPlayerVisibility", "standnocullbreak"..hooktag, function(ply, ent) 
		if self:IsValid() and self.Owner:IsValid() and self:GetInDoDoDo() then
			AddOriginToPVS( self:WorldSpaceCenter() )
		end
	end)
	hook.Add("PlayerShouldTaunt", "standtaunt"..hooktag, function(ply, act) 
		if self:IsValid() and self.Owner:IsValid() and ply == self.Owner then
			self.TauntACT = act
		end
	end)
	
	if CLIENT then
		self:SetIK(true)
	end
	if SERVER then
		timer.Simple(0, function()
			if IsValid(self) then
				self.ReadytoAnimate = true
				self:RemoveAllGestures()
				if !self.AnimDelay or CurTime() >= self.AnimDelay then
					self:DoAnimations()
				end
			end
		end)
	end
		offset = Vector(-20,20,30)

	self:Think()
end				 

function ENT:DoAnimations()
	if SERVER then
		if self.Wep:GetHoldType() != "pistol" then
			self:ResetSequence("standidle")
		end
	end

end

function ENT:DoMovement()
	if !self:GetMarkedToFade() then
		local Active = false
		if self.Wep.GetActive then
			Active = self.Wep:GetActive()
		end
		if !self:GetInDoDoDo() and !self.InStill then
			
			for i = 0, self.Owner:GetNumPoseParameters() - 1 do
				if SERVER then
					local sPose = self.Owner:GetPoseParameterName( i )
					if self.Owner:GetPoseParameterName( i ) != "head_yaw" and self.Owner:GetPoseParameterName( i ) != "head_pitch" and self.Owner:GetPoseParameterName( i ) != "move_y" and self.Owner:GetPoseParameterName( i ) != "move_x" then
						self:SetPoseParameter( sPose, Lerp(0.1, self:GetPoseParameter(sPose), self.Owner:GetPoseParameter( sPose )  ))
						else
						self:SetPoseParameter( sPose, Lerp(0.1, self:GetPoseParameter(sPose), self.Owner:GetPoseParameter( sPose )  ))
					end
					else
					local flMin, flMax = self:GetPoseParameterRange( i )
					local sPose = self.Owner:GetPoseParameterName( i )
					local sPose2 = self:GetPoseParameterName( i )
					if sPose == sPose2 then
						if self.Owner:GetPoseParameterName( i ) != "head_yaw" and self.Owner:GetPoseParameterName( i ) != "head_pitch" and self.Owner:GetPoseParameterName( i ) != "move_y" and self.Owner:GetPoseParameterName( i ) != "move_x" then
							self:SetPoseParameter( sPose, Lerp(0.1, self:GetPoseParameter(sPose), self.Owner:GetPoseParameter( sPose )  ))
						end
					end
				end
			end
			
			elseif SERVER and self.InStill then
			self:SetPoseParameter("move_x", Lerp(0.1, self:GetPoseParameter("move_x"), 0))
			self:SetPoseParameter("move_y", Lerp(0.1, self:GetPoseParameter("move_y"), 0))
		end
		
		if SERVER then
			local etr = util.TraceLine( {
				start = self:GetEyePos(true),
				endpos = self.Owner:GetEyeTrace().HitPos,
				filter = {self.Owner, self},
			})
			local ang = self.Owner:EyeAngles() - self:GetAngles()
			if IsValid(self:GetAITarget()) then
				etr = util.TraceLine( {
					start = self:GetEyePos(true),
					endpos = self.AITarget:EyePos(),
					filter = {self.Owner, self},
				})
				if self:GetAITarget():GetClass() == "stand" then
					etr = util.TraceLine( {
						start = self:GetEyePos(true),
						endpos = self.AITarget:GetEyePos(true),
						filter = {self.Owner, self},
					})
				end
				ang = etr.Normal:Angle() - self:GetAngles()
			end
			ang:Normalize()
			if self.HeadRotOffset then
				ang:RotateAroundAxis(self:GetUp(), self.HeadRotOffset)
			end
			local flMin, flMax = self:GetPoseParameterRange( 6 )
			self:SetPoseParameter("head_yaw", ang.y)
			flMin, flMax = self:GetPoseParameterRange( 7 )
			self:SetPoseParameter("head_pitch", ang.p)
		end
		
		if self:GetParent() != nil and !self:GetParent():IsValid() then
			if SERVER and (self:GetSequence() != self:LookupSequence("IDLE_PISTOL")) and (!self.InStill and !self:GetInDoDoDo()) then
				if !IsValid(self.Image1) then
					self:SetIdealAngles(Angle(0, self.Owner:GetAngles().y, self.Owner:GetAngles().r ))
				end
				if IsValid(self.Image1) then
					local norm = -(self.Owner:GetPos() - self:GetPos()):GetNormalized()
					if self.RotateSpeed != 1 then
						norm = norm
					end
					local ang = norm:Angle()
					self:SetIdealAngles(Angle(0,ang.y,ang.r))
					self:SetAngles(Angle(0,ang.y,ang.r))
				end
				if IsValid(self.Image2) then
					local norm = -(self.Owner:GetPos() - self:GetPos()):GetNormalized()
					if self.RotateSpeed != 1 then
						norm = norm
					end
					local ang = norm:Angle()
					self:SetAngles(Angle(0,ang.y,ang.r))
					self:SetIdealAngles(Angle(0,ang.y,ang.r))
				end
			end
			if !(self:GetInDoDoDo()) and self.Wep.GetMirror and IsValid(self.Wep:GetMirror()) then
					self:SetPos(self.Wep:GetMirror():GetPos() + self.Wep:GetMirror():GetUp() * 55)
					self.Pos = self:GetPos()
			end
		end
		self.StandVelocity = self.StandVelocity or Vector(0,0,0)
		if self:GetInDoDoDo() then
			self.Owner:AddFlags(FL_ATCONTROLS)
			self:SetIdealAngles((self.Owner:GetAimVector():Angle()))
			if !((self.StandId == GSTANDS_TGRAY) and self.Owner:KeyDown(IN_SPEED) and IsValid(self.Wep) and IsValid(self.Wep:GetLockTarget())) and self.Owner:KeyDown(IN_FORWARD) then
				self.StandVelocity = (self.StandVelocity + self.Owner:GetAimVector()):GetNormalized()
				if SERVER then
					self:SetPoseParameter( "move_x", Lerp(0.2, self:GetPoseParameter( "move_x" ), 1 ))
				end
				else
				if SERVER then
					self:SetPoseParameter( "move_x", Lerp(0.01, self:GetPoseParameter( "move_x" ), 0 ))
				end
			end
			if self.Owner:KeyDown(IN_BACK) then
				self.StandVelocity = (self.StandVelocity - self.Owner:GetAimVector()):GetNormalized()
				if SERVER then
					self:SetPoseParameter( "move_x", Lerp(0.2, self:GetPoseParameter( "move_x" ), -1 ))
				end
				else
				if SERVER then
					self:SetPoseParameter( "move_x", Lerp(0.01, self:GetPoseParameter( "move_x" ), 0 ))
				end
			end
			if self.Owner:KeyDown(IN_MOVELEFT) then
				self.StandVelocity = (self.StandVelocity - self.Owner:GetAimVector():Angle():Right()):GetNormalized()
				self.Pos = self:GetPos()
				if SERVER then
					self:SetPoseParameter( "move_y", Lerp(0.2, self:GetPoseParameter( "move_y" ), -1 ))
				end
				else
				if SERVER then
					self:SetPoseParameter( "move_y", Lerp(0.01, self:GetPoseParameter( "move_y" ), 0 ))
				end
			end
			if self.Owner:KeyDown(IN_MOVERIGHT) then
				self.StandVelocity = (self.StandVelocity + self.Owner:GetAimVector():Angle():Right()):GetNormalized()
				self.Pos = self:GetPos()
				if SERVER then
					self:SetPoseParameter( "move_y", Lerp(0.2, self:GetPoseParameter( "move_y" ), 1 ))
				end
				else
				if SERVER then
					self:SetPoseParameter( "move_y", Lerp(0.01, self:GetPoseParameter( "move_y" ), 0 ))
				end
			end
			if self.Owner:KeyDown(IN_JUMP) then
				self.StandVelocity = (self.StandVelocity + Vector(0,0,1)):GetNormalized()
				self.Pos = self:GetPos()
			end
			if !self.Owner:KeyDown(IN_USE) and self.Owner:KeyDown(IN_DUCK) then
				self.StandVelocity = (self.StandVelocity - Vector(0,0,1)):GetNormalized()
				self.Pos = self:GetPos()
			end
			elseif !self:GetInDoDoDo() then
			self.Owner:RemoveFlags(FL_ATCONTROLS)
			if self:GetBlockCap() then
				if SERVER then
					self:SetAITarget(self:GetNPCThreat())
				end
				self.Blocking = self:BlockAI()
			end
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
	if self.RotateSpeed == 1 and (!IsValid(self:GetBackstabTarget()) or (IsValid(self:GetBackstabTarget()) and self:GetBackstabTarget() == self.Owner)) then
		self:SetAngles(LerpAngle(0.3, self:GetAngles(), self:GetIdealAngles()))
	end
	if SERVER then
		if (self:GetPos() != self:GetIdealPos() or (IsValid(self:GetBackstabTarget()) and self:GetBackstabTarget():Health() > 0)) and IsValid(self.Wep:GetMirror()) then
			local tr = util.TraceLine({
				start=self.Wep:GetMirror():GetPos(),
			endpos=self:GetIdealPos(),
			filter=function(ent) if ent:IsPlayer() or ent:IsNPC() then return false else return true end end})
			if !tr.Hit and tr.Normal:Dot(self.Wep:GetMirror():GetUp()) > 0 then
			
			local LastPos = self:GetPos()
			self:SetPos(LerpVector(0.7, self:GetPos(), self:GetIdealPos()))
			local dir = (self:GetPos() - LastPos):GetNormalized()
			self:SetIdealPos(LerpVector(0.7, self:GetPos(), self:GetIdealPos()))
			elseif tr.Normal:Dot(self.Wep:GetMirror():GetUp()) < 0 then
				for i=0, 55 do
					local newnorm = (self:GetPos() - self.Wep:GetMirror():GetPos()):GetNormalized()
					if newnorm:Dot(self.Wep:GetMirror():GetUp()) < 0 then
						self:SetIdealPos(self:GetPos() + self.Wep:GetMirror():GetUp())
						self:SetPos(self:GetPos() + self.Wep:GetMirror():GetUp())
						else
						continue
					end
				end
			end
			if IsValid(self:GetBackstabTarget()) and self:GetBackstabTarget() == self.Owner then

				if self.PreBackstab then
					self:SetIdealPos(self:GetPos() + Vector(0,0,55))
					self:SetPos(self:GetPos() + Vector(0,0,55))
					self.PreBackstab = nil
				end
			end
			if IsValid(self:GetBackstabTarget()) and self:GetBackstabTarget() != self.Owner and self:GetBackstabTarget():Health() > 0 then
				self.PreBackstab = 1
				local ang = self:GetBackstabTarget():GetAngles()
				ang.p = 0
				self:SetIdealPos(self:GetBackstabTarget():GetPos() - ang:Forward() * 18)
				self:SetPos(self:GetIdealPos())
				self:SetAngles(ang)
				self:SetIdealAngles(ang)
			end
			
		end
	end
	
end
function ENT:OnRemove()
	if IsValid(self.Owner) then
		self.Owner:RemoveFlags(FL_ATCONTROLS)
	end
	if CLIENT and self.Aura then
		self.Aura:StopEmission()
	end
	return false
end
function ENT:DropItem()
	
	if self.ItemPickedUp:IsValid() and self.ItemPickedUp != self then
		if self.ItemPickedUp:GetPhysicsObject():IsValid() then
			for i = 0, self.ItemPickedUp:GetPhysicsObjectCount() - 1 do
				self.ItemPickedUp:GetPhysicsObjectNum(i):Wake()
				self.ItemPickedUp:GetPhysicsObjectNum(i):EnableGravity(true)
				self.ItemPickedUp:GetPhysicsObjectNum(i):ClearGameFlag(FVPHYSICS_PLAYER_HELD)
				self.ItemPickedUp:GetPhysicsObjectNum(i):SetDragCoefficient(0)
				self:RemoveAllGestures()
				
			end
		end
		self.ItemPickedUp = self
	end
end
function ENT:Think()
	if SERVER and !IsValid(self.Owner) then
		self:Remove()
		return true
	end
	if SERVER then
		self:SetRange(10000000)
	end
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
	if self.Owner:GetInfoNum("gstands_active_dododo_toggle", 1) == 1 and SERVER and CurTime() > self.DoDoDoTimer and self.StandId != GSTANDS_JST then
		self.DoDoDoTimer = CurTime() + 0.3
		self:SetInDoDoDo(self.Wep:GetState() == 2)
		if self.Wep:GetState() == 2 and self.Wep:GetState() != self.OldState then
			self:ResetSequence("standdeploy")
			self:SetCycle(0)
			self.AnimDelay = CurTime() + self:SequenceDuration()
			self:EmitStandSound(FadeIn)
			timer.Simple(1.8, function() if IsValid(self) then self:EmitStandSound(FlickOut) end end)
		end
		if self.Wep:GetState() != 2 and self.OldState == 2 then
			self:EmitStandSound(FadeOut)
			self.Owner:EmitStandSound(FadeOut)
		end
		self.OldState = self.Wep:GetState()
	end
	if self.Owner:GetInfoNum("gstands_active_dododo_toggle", 1) == 0 then
		self:SetInDoDoDo(self.Wep:GetState() == 2)
	end
	self.InStill = self.Owner:KeyDown(IN_USE)
	self.DistToOwner = self.Pos:Distance(self.OwnerPos)
	self.Model = self:GetModel()
	self.Image = self:GetImage()
	self.Wep = self.Wep or self.Owner:GetActiveWeapon()
	if SERVER and self.Wep.GetStand and self != self.Wep:GetStand() and self:GetImageID() == 1 then
		self:Remove()
	end
	if SERVER and self.Wep.GetStand1 and self != self.Wep:GetStand1() and self:GetImageID() == 2 then
		self:Remove()
	end
	if SERVER and self.Wep.GetStand2 and self != self.Wep:GetStand2() and self:GetImageID() == 3 then
		self:Remove()
	end
	--Define initial value of the picked up item
	self.ItemPickedUp = self.ItemPickedUp or self
	if self.Owner and self.Owner:GetActiveWeapon():IsValid() and self.Owner:GetActiveWeapon():GetHoldType() != "stando" then
		self:DropItem()
	end
	
	
	--grabbin stuff and usin doors
	if self.InStill and self:GetInDoDoDo() and self.ItemPickedUp == self and !self.Throwing then
		local tra = ents.FindInCone(self.CenterPos - self.Forward * 12, self.Forward, 100, 0.55)
		for k,v in pairs(tra) do
			if v:GetPhysicsObject():IsValid() or v:IsPlayer() then
				tra.Entity = v
			end
		end
		if tra.Entity and tra.Entity:IsValid() and SERVER then
			if !tra.Entity:IsVehicle() then
				tra.Entity:Use(self.Owner, self, USE_TOGGLE, 1)
			end
			if gmod.GetGamemode():PlayerCanPickupItem(self.Owner, tra.Entity) and IsValid(tra.Entity:GetPhysicsObject()) and tra.Entity:GetPhysicsObject():GetMass() <= 500 * self.POWER and !tra.Entity:IsPlayer() or (GetConVar("gstands_time_stop"):GetBool() and tra.Entity:IsPlayer() and tra.Entity != self.Owner and !table.HasValue(GetGlobalEntity("Time Stop").StoppedUsers, tra.Entity)) then
				self.ItemPickedUp = tra.Entity
				self.PickupTimer = CurTime() + 0.5
				--self:RemoveAllGestures()
			end
		end
	end
	
	--holdin stuff
	self.PickupTimer = self.PickupTimer or CurTime()
	if SERVER and self.ItemPickedUp and self.ItemPickedUp:IsValid() and self.ItemPickedUp != self then
		local nextpos = math.ApproachVector(self.ItemPickedUp:GetPos(), self.ItemPickedUp:GetPos() - (self.ItemPickedUp:WorldSpaceCenter() - ((self.CenterPos + self.Forward * 24))), 25)
		self.ItemPickedUp.GSTSStopped = false
		self.ItemPickedUp.GSTSFactor = 1
		if !self.ItemPickedUp:IsPlayer() then
			self.ItemPickedUp:SetMoveType(MOVETYPE_VPHYSICS)
		end
		if util.PointContents(nextpos) != CONTENTS_SOLID then
			if self.ItemPickedUp:IsPlayer() then
				self.ItemPickedUp:SetPos(nextpos)
			end
			if GetConVar("gstands_time_stop"):GetBool() then
				self.ItemPickedUp:SetPos(nextpos)
				self.ItemPickedUp:SetAngles(self:GetAngles())
			end
			if !self.ItemPickedUp:IsPlayer() then
				for i = 0, self.ItemPickedUp:GetPhysicsObjectCount() - 1 do
					self.ItemPickedUp:GetPhysicsObjectNum(i):AddGameFlag(FVPHYSICS_PLAYER_HELD)
					self.ItemPickedUp:GetPhysicsObjectNum(i):AddGameFlag(FVPHYSICS_WAS_THROWN)
					self.ItemPickedUp:GetPhysicsObjectNum(i):Wake()
					self.ItemPickedUp:SetPhysicsAttacker(self.Owner)
					local pos, ang = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_R_Hand"))
					local ShadowParams = {}
					ShadowParams.secondstoarrive = 0.1 
					ShadowParams.pos = pos + ang:Right() + ang:Forward() * 3
					ShadowParams.angle = ang + Angle(0,0,180)
					ShadowParams.maxangular = 1000
					ShadowParams.maxangulardamp = 10000 
					ShadowParams.maxspeed = 1000
					ShadowParams.maxspeeddamp = 10000
					ShadowParams.dampfactor = 0.8
					ShadowParams.teleportdistance = 0
					ShadowParams.deltatime = FrameTime()
					
					self.ItemPickedUp:GetPhysicsObjectNum(i):EnableMotion(true)
					self.ItemPickedUp:GetPhysicsObjectNum(i):ComputeShadowControl( ShadowParams )
				end
				if (self.CenterPos + self.Forward * 24):Distance(self.ItemPickedUp:WorldSpaceCenter()) >= 500 then
					self:DropItem()
				end
			end
			else
			self:DropItem()
		end
	end
	self:SetVelocity(-self:GetVelocity())
	if SERVER and self.Owner:KeyDown(IN_USE) and self.ItemPickedUp and self.ItemPickedUp:IsValid() and self.ItemPickedUp != self and CurTime() > self.PickupTimer then
		self:DropItem()
	end
	if self.Owner:IsValid() and self.Owner:Alive() then
		
		
		if self.Owner:IsFlagSet(FL_FROZEN) or self:GetMoveType() == MOVETYPE_NONE then
			self.StoppedAnimTime = self.StoppedAnimTime or self:GetCycle()
			else
			self.StoppedAnimTime = nil
		end
		if !self.AnimDelay or CurTime() >= self.AnimDelay then
			self:DoAnimations()
		end
		self.LastSequence = self.LastSequence or self:GetSequence()
		self.LastSequence = self:GetSequence()
		self.LastPos = self:GetPos()
		if !self:GetFrozen() then
			self:DoMovement()
		end
		
		local etr = util.TraceLine( {
			start = self:GetEyePos(true),
			endpos = self:GetEyePos(true) + self.Owner:GetAimVector() * 500,
			filter = {self.Owner, self},
		})
		
		local attachment = self:GetAttachment( self:LookupAttachment( "eyes" ) )
		if SERVER and attachment then
			local LocalPos, LocalAng = WorldToLocal( self:GetClosest(self.Owner, self:GetEyePos(true)) , Angle( 0, 0, 0 ), attachment.Pos, attachment.Ang )
			if LocalAng:Forward():Distance(self:GetForward()) <= 0.2 then
				self:SetEyeTarget(LocalPos)
			end
		end
		
		if SERVER and (self.Owner:IsFlagSet(FL_FROZEN) or (self:GetMoveType() == MOVETYPE_NONE and !Active)) then
			self:SetCycle(self.StoppedAnimTime)
			self:SetPlaybackRate(0)
			self:RemoveAllGestures()
			for i = 0, 14 do 
				if self:IsValidLayer(i) then
					self:SetLayerCycle(i,1)
				end
			end
			
			else
			self:SetPlaybackRate(1)
		end
		elseif SERVER then
		self:Remove()
	end
				self:SetPlaybackRate(1)

	self:NextThink( CurTime() ) 
	return true
end

function ENT:GetEyePos(head)
	if !head then head = false end
	if self:GetInDoDoDo() or head then
		local att = self:LookupAttachment("anim_attachment_head")
		local tab = self:GetAttachment(att)
		if !tab then
			tab = {}
			tab.Pos = self:WorldSpaceCenter()
		end
		return tab.Pos or self:WorldSpaceCenter()
		else
		return self.Owner:EyePos()
	end
end


function ENT:OnTakeDamage(dmg)
	return true
end
local mat = Material("effects/gstands_aura")
local blur = Material("pp/blurscreen")
function ENT:Draw()
end
function ENT:DrawTranslucent()
	if self:GetInDoDoDo() and DRAW_HANGED_MAN == self:EntIndex() or (self:GetInDoDoDo() and LocalPlayer() == self.Owner) then
	if !IsValid(self.Owner) then
		return true 
	end
	if IsValid(self:GetActiveWeapon()) and self:GetActiveWeapon().DrawWorldModel then
		self:GetActiveWeapon():DrawWorldModel()
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
	self.OwnerNoDraw = false
	if !self.OwnerNoDraw then
		if CLIENT and LocalPlayer():GetActiveWeapon() then
			if LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then
				
				if !Active and !self.OwnerNoDraw and self.LOD < 2 then
					self:SetupBones()
					self.Aura = self.Aura or CreateParticleSystem(self.Owner, "auraeffect", PATTACH_POINT_FOLLOW, 1)
					if self.Aura then
						self.Aura:SetControlPoint(1, gStands.GetStandColor(self.Model, self:GetSkin()))
					end
					if self.LOD < 2 then
						self.StandAura = self.StandAura or CreateParticleSystem(self, "auraeffect", PATTACH_POINT, 1)
						if self.StandAura then
							self.StandAura:SetControlPoint(1, gStands.GetStandColor(self.Model, self:GetSkin()))
							self.StandAura:SetControlPoint(0, self:GetIdealPos())
							self.StandAura:SetShouldDraw(false)
						end
					end
					elseif (self.Aura and self.StandAura) or self.OwnerNoDraw then
					self.Aura:StopEmission()
					self.StandAura:StopEmission()
					self.Aura = nil
					self.StandAura = nil
				end
				if self.StandAura then
					self:SetupBones()
					self.StandAura:Render()
				end
				if self:GetSequence() == self:LookupSequence("StandDeploy") then
					render.SetBlend(self:GetCycle() + 0.4)
				end
					self:DrawModel() 
					render.SetBlend(1)
				elseif (self.Aura and self.StandAura) then
				self.Aura:StopEmission()
				self.StandAura:StopEmission()
				self.Aura = nil
				self.StandAura = nil
			end
		end
		elseif (self.Aura and self.StandAura) then
		self.Aura:StopEmission()
		self.StandAura:StopEmission()
		self.Aura = nil
		self.StandAura = nil
	end
	end
	
end
