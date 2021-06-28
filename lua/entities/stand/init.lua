AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside 
AddCSLuaFile( "shared.lua" ) -- and shared scripts are sent.

include('shared.lua')
ENT.Type = "anim"
ENT.Base = "stand_player_base"

ENT.Author= "Copper"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.DisableDuplicator = true
ENT.DoNotDuplicate = true
ENT.Animated = true
ENT.Color = Color(150,150,150,1)
ENT.ForceOnce = false
ready = false
ENT.ImageID = 1
ENT.Rate = 0
ENT.Health = 1
ENT.rgl = 1.3
ENT.ggl = 1.3
ENT.bgl = 1.3
ENT.rglm = 1.3
ENT.gglm = 1.3
ENT.bglm = 1.3
ENT.FlameFX = nil
ENT.PhysgunDisabled = true
ENT.Range = 150
ENT.ItemPickedUp = NUL
ENT.Speed = 1
ENT.POWER = 1
ENT.Flashlight = self
ENT.Model = ""
ENT.OwnerName = ""
ENT.RotateSpeed = 1
ENT.AnimSet = {
	"SWIMMING_FIST", 1,
	"GMOD_BREATH_LAYER", 0.5,
	"AIMLAYER_CAMERA", 0.1,
	"JUMP_FIST", 0.1,
	"FIST_BLOCK", 0.6,
}

local NonStandard = {
	"models/jst/jst.mdl", 
	"models/jst/jst.mdl", 
	"models/player/osi/osi.mdl",
	"models/horus/horus.mdl",
	"models/tgray/tgray.mdl"
	}

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
	if IsValid(self.Owner) then
		self:SetIdealPos(self.Owner:GetPos())
	end
	end
function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
local JumpPowerTable = {
	["models/player/starpjf/spjf.mdl"] = 1,
	["models/player/starprv/sp.mdl"] = 1,
	["models/player/worldrv/world.mdl"] = 1,
	["models/player/worldjf/world.mdl"] = 1,
	["models/player/copper/copper.mdl"] = 3,
	["models/player/creamrv/crm.mdl"] = 0.1,
	["models/player/atm/atm.mdl"] = 0.1,
	["models/player/dbm/dbm.mdl"] = 0.2,
	["models/player/heg/heg.mdl"] = 0.2,
	["models/horus/horus.mdl"] = 0.05,
	["models/player/jgm/jgm.mdl"] = 0.2,
	["models/jst/jst.mdl"] = 0.02,
	["models/player/mgr/mgr.mdl"] = 0.5,
	["models/player/osi/osi.mdl"] = 0.1,
	["models/player/slc/slc_un.mdl"] = 0.5,
	["models/player/slc/slc.mdl"] = 0.2,
	["models/tgray/tgray.mdl"] = 0.05,
}
function gStands.AddToJumpPowerTable(model, power)
	JumpPowerTable[model] = power
end
function ENT:Initialize()
	self:SetLagCompensated(true)
	self.Wep = self.Owner:GetActiveWeapon()
	self.OwnerPos = self.Owner:GetPos()
	self.OwnerCenterPos = self.Owner:WorldSpaceCenter()
	self.CenterPos = self:WorldSpaceCenter()
	self.Pos = self:GetPos()
	self.Forward = self:GetForward()
	self.InStill = self.Owner:gStandsKeyDown("modifierkey2")
	self.DistToOwner = self.Pos:Distance(self.OwnerPos)
	self:SetPoseParameter("move_y", 1)
	self:SetPoseParameter("move_X", -1)
	self.BarrageAnimIndex = self:LookupSequence("barrage")
	self.kBarrageAnimIndex = self:LookupSequence("kbarrage")
	if self.BarrageAnimIndex == -1 then
		self.BarrageAnimIndex = self:LookupSequence("stab")
	end
	self.StandId = GetgStandsID(self:GetModel())
	self:SetPoseParameter("move_y", 1)
	self:SetPoseParameter("move_X", -1)
	self.StandId = GetgStandsID(self:GetModel())
	self:SetImageID(self.ImageID)
	self:SetSolid( SOLID_OBB )
	self:SetMoveType( MOVETYPE_NOCLIP )
	self:SetSolidFlags( FSOLID_NOT_STANDABLE )
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetUseType(SIMPLE_USE)
	self.OwnerName = self.Owner:GetName()
	self.Color = self:GetColor()
	self.offset = Vector(-20,20,30)
	if self.StandId == GSTANDS_JST then
		self:ResetSequence(self:LookupSequence("float"))
	end
	self.Rate = math.random(0,5)
	if self:GetImageID() == 1 then
		self:SetSkin(self.Owner:GetInfoNum("gstands_standskin_"..self.Wep.ClassName, math.random(0, self:SkinCount() - 1)))
		self:SetHealth(self.Owner:Health())
	end
	self.FlashLight = self.FlashLight or self
	ParticleEffectAttach("stand_basic", PATTACH_ABSORIGIN_FOLLOW, self.Owner, 0)
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
	
	hook.Add("PlayerSwitchFlashlight", "StandFlashlightsareCool"..hooktag, function(ply, boolian)
		if self and ply and self:IsValid() and ply:IsValid() and ply == self.Owner then
			if self.FlashLight == self and self.FlashLight:IsValid() then
				self.FlashLight = ents.Create("env_projectedtexture")
				if self.FlashLight != self and self.FlashLight:IsValid() then
					self.FlashLight:SetPos(self.CenterPos)
					self.FlashLight:SetAngles(self:GetAngles())
					self.FlashLight:SetParent(self)
					self.FlashLight:SetKeyValue("lightfov", 75)
					self.FlashLight:SetKeyValue("enableshadows", "true" )
					self:EmitStandSound("items/flashlight1.wav")
				end
				elseif IsValid(self) and IsValid(self.FlashLight) then
				self.FlashLight:Remove()
				self.FlashLight = self
				self:EmitStandSound("items/flashlight1.wav")
			end
			return false
		end
	end)
	hook.Add("EntityTakeDamage", "OwnerTakesNoBlastDamage"..self:EntIndex(), function(targ, dmg)
		if self:IsValid() and self.Owner:IsValid() and targ == self.Owner and dmg:GetDamageType() == DMG_BLAST then
			if !string.StartWith(dmg:GetInflictor():GetClass(), "gstands_") then
				local startpos = dmg:GetInflictor():WorldSpaceCenter()
				local tr1 = util.TraceLine( {
					start = startpos,
					endpos = self.OwnerCenterPos,
					mask = MASK_ALL,
				} )
				local tr2 = util.TraceLine( {
					start = startpos - Vector(0,0,5),
					endpos = self.OwnerCenterPos,
					mask = MASK_ALL,
				} )
				local tr3 = util.TraceLine( {
					start = startpos + Vector(0,0,5),
					endpos = self.OwnerCenterPos,
					mask = MASK_ALL,
				} )
				local tr4 = util.TraceLine( {
					start = startpos - Vector(5,0,0),
					endpos = self.OwnerCenterPos,
					mask = MASK_ALL,
				} )
				local tr5 = util.TraceLine( {
					start = startpos + Vector(5,0,0),
					endpos = self.OwnerCenterPos,
					mask = MASK_ALL,
				} )
				local tr6 = util.TraceLine( {
					start = startpos - Vector(0,5,0),
					endpos = self.OwnerCenterPos,
					mask = MASK_ALL,
				} )
				local tr7 = util.TraceLine( {
					start = startpos + Vector(0,5,0),
					endpos = self.OwnerCenterPos,
					mask = MASK_ALL,
				} )
				if tr1.Entity != self.Owner or tr2.Entity != self.Owner or tr3.Entity != self.Owner or tr4.Entity != self.Owner or tr5.Entity != self.Owner or tr6.Entity != self.Owner or tr7.Entity != self.Owner then
					return true
				end
			end
		end
	end)
	hook.Add("EntityTakeDamage", "OwnerAICheck"..hooktag, function(targ, dmg)
		if self:IsValid() and self.Owner:IsValid() and targ == self.Owner then
			self.IdealAITarget = dmg:GetAttacker()
			if dmg:GetInflictor().GetStand then
				self.IdealAITarget = dmg:GetInflictor():GetStand()
			end
			self:RemoveAllGestures()
			local name = self:EntIndex()
			timer.Create("EntityTakeDamageOwnerAICheck"..hooktag, 2, 1, function() if self:IsValid() then self:RemoveAllGestures() self.IdealAITarget = nil end end)
			elseif !self:IsValid() or !self.Owner:IsValid() then
			hook.Remove("EntityTakeDamage", "OwnerAICheck"..hooktag)
		end
	end)
	hook.Add("EntityTakeDamage", "StandFallDamagePrevent"..hooktag, function(targ, dmg)
		if self:IsValid() and self.Owner:IsValid() and targ == self.Owner and dmg:IsFallDamage() then
			dmg:SetDamage(dmg:GetDamage()/(JumpPowerTable[self.Model] + 2))
			elseif !self:IsValid() or !self.Owner:IsValid() then
			hook.Remove("EntityTakeDamage", "StandFallDamagePrevent"..hooktag)
		end
		if self:IsValid() and self.Owner:IsValid() and (targ == self.Owner or targ == self) then
			if self:GetSequence() != -1 and self:GetSequence() == self:LookupSequence("standblock") and dmg:GetDamageType() != DMG_DIRECT then
			if SERVER and self.StandId == GSTANDS_PLATINUM and dmg:IsBulletDamage() then
				self.Wep:SetClip1( math.min(50, self.Wep:Clip1() + 1 ))
			end
			if self.StandId == GSTANDS_JUDGEMENT then
				self.NextBlock = self.NextBlock or CurTime()
				dmg:SetDamage(dmg:GetDamage() * 0.01)
								self:SetCycle(0)
				if CurTime() >= self.NextBlock then
				self.NextBlock = CurTime() + 0.2
				self:EmitStandSound("MetalGrate.BulletImpact")
				local layer = self:AddGestureSequence(self:LookupSequence("standblock"))
				self:SetLayerWeight(layer, 1)
				else
				end
			end
			if self:GetCycle() <= 0.25 then
				dmg:SetDamage(dmg:GetDamage() * 0.9)
				elseif self:GetCycle() <= 0.75 then
				dmg:SetDamage(dmg:GetDamage() * 0.01)
				self:EmitStandSound("MetalGrate.BulletImpact")
				local pos = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_L_ForeArm"))
				ParticleEffect("standblock", pos, Angle(0,0,0))
				self.NoOneCanDeflect = self.NoOneCanDeflect or CurTime()
				if SERVER and self.StandId == GSTANDS_PLATINUM and dmg:GetInflictor():GetClass() == "emerald_splash_proj" and CurTime() >= self.NoOneCanDeflect then
					dmg:GetAttacker():EmitSound("weapons/hierophant/noonecanjustdeflecttheemeraldsplash.wav")
					self.NoOneCanDeflect = CurTime() + 5
					
				end
				if SERVER and self.StandId == GSTANDS_MAGICIANS then
					if dmg:GetAttacker():WorldSpaceCenter():DistToSqr(self:WorldSpaceCenter()) < 35500 then
						dmg:GetAttacker():Ignite(1)
					end
				end
				if SERVER and self.StandId == GSTANDS_HIEROPHANT then
					local inflictor = dmg:GetInflictor()
					timer.Simple(0, function() if IsValid(self) and IsValid(self.Owner) then
						self.Owner:SetVelocity(inflictor:GetForward() * 550)
					end
					end)
				end
				if SERVER and self.StandId == GSTANDS_DBM and !dmg:GetAttacker().Barnacled then
					local barnacle = ents.Create("dbm_barnacle")
					barnacle:SetTarget(dmg:GetAttacker())
					barnacle:SetPos(dmg:GetAttacker():WorldSpaceCenter())
					barnacle:SetParent(dmg:GetAttacker())
					barnacle:SetOwner(self.Owner)
					dmg:GetAttacker().Barnacled = true
					barnacle:Spawn()
					barnacle:Activate()
				end
				if SERVER and self.StandId == GSTANDS_CHARIOT then
					local attacker = dmg:GetAttacker()
					timer.Simple(0, function() if IsValid(attacker) then
						local dmginfo = DamageInfo()
		
						dmginfo:SetAttacker( self.Owner )
						dmginfo:SetDamageType(DMG_DIRECT)
						
						dmginfo:SetInflictor( self )
						
						dmginfo:SetDamage( 25 )
						if self.Wep:GetSwordFlame() then
							dmginfo:SetDamageType(DMG_DIRECT)
							dmginfo:SetDamage(35)
							attacker:Ignite(1)
						end
						attacker:TakeDamageInfo( dmginfo )
					end
					end)
				end
			end
		end
		end
	end)
	timer.Simple(0, function()
		if IsValid(self) then
			self.ReadytoAnimate = true
			self:RemoveAllGestures()
			if !self.AnimDelay or CurTime() >= self.AnimDelay then
				self:DoAnimations()
			end
		end
	end)
	self:Think()
	
end				 

function ENT:DoAnimations()
	if SERVER and !table.HasValue(NonStandard, self.Model) then
		if !self.TauntACT then
			if (self.Owner:GetActiveWeapon():IsValid() and self.Owner:GetActiveWeapon():GetHoldType() != "pistol") and !self.Throwing then
					if self:LookupSequence("standidle") != -1 and self:GetSequence() != self:LookupSequence("standidle") then
						self:ResetSequence( self:LookupSequence("standidle"))
					elseif self:LookupSequence("standidle") == -1 then
						self:ResetSequence( self:LookupSequence("swimming_fist"))
						self:SetPlaybackRate(0.3)
						if self.StandId == GSTANDS_CREAM then
							self:ResetSequence(self:LookupSequence("swimming_all"))
							self:SetPlaybackRate(0.3)
						end
						if self.StandId == GSTANDS_ATUM then
							self:ResetSequence(self:LookupSequence("swimming_all"))
							self:SetPlaybackRate(0.3)
						end
						if self.StandId == GSTANDS_HORUS then
							self:ResetSequence(self:LookupSequence("idle"))
							self:SetPlaybackRate(1)
						end
					end
				elseif SERVER and (self.StandId != GSTANDS_TGRAY ) and self.StandId == GSTANDS_HORUS and !self.Throwing then
				self:SetPlaybackRate(1)
			end
		end
		elseif SERVER and table.HasValue(NonStandard, self.Model) and self.StandId != GSTANDS_JST and (self.Owner:GetActiveWeapon():GetHoldType() != "pistol") then
		self:ResetSequence(self:LookupSequence("standidle"))
		if self.StandId == GSTANDS_JUDGEMENT then
			self:ResetSequence( self:LookupSequence("standidle"))
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
			local sPose = self.Owner:GetPoseParameterName( i )
			if self.Owner:GetPoseParameterName( i ) != "head_yaw" and self.Owner:GetPoseParameterName( i ) != "head_pitch" then
				self:SetPoseParameter( sPose, Lerp(0.1, self:GetPoseParameter(sPose), self.Owner:GetPoseParameter( sPose )  ))
				else
				self:SetPoseParameter( sPose, Lerp(0.1, self:GetPoseParameter(sPose), self.Owner:GetPoseParameter( sPose )  ))
			end
		end

		elseif self.InStill then
		self:SetPoseParameter("move_x", Lerp(0.1, self:GetPoseParameter("move_x"), 0))
		self:SetPoseParameter("move_y", Lerp(0.1, self:GetPoseParameter("move_y"), 0))
	end

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
	self:SetPoseParameter("aim_yaw", ang.y)
	flMin, flMax = self:GetPoseParameterRange( 7 )
	self:SetPoseParameter("head_pitch", ang.p)
	self:SetPoseParameter("aim_pitch", ang.p)

	if self:GetParent() != nil and !self:GetParent():IsValid() then
		if (self:GetSequence() != self:LookupSequence("IDLE_PISTOL")) and (!self.InStill and !self:GetInDoDoDo()) then
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
		if !(self:GetInDoDoDo() or self.InStill and self.StandId != GSTANDS_JST) and (self.Owner:GetActiveWeapon():IsValid() and self.Owner:GetActiveWeapon():GetHoldType() != "pistol") and !Active then
			if self:GetImageID() == 1 then
				if !IsValid(self.Image1) then
					self:SetIdealPos(self.Owner:EyePos() + (self.Owner:GetForward() * self.offset.x) + (self.Owner:GetRight() * self.offset.y) - Vector(0,0,self.offset.z))
					self.Pos = self:GetPos()
				end
				if self:GetImageID() == 1 and self.StandId == GSTANDS_CHARIOTUN then
					self:SetPos(self.OwnerCenterPos + Vector(math.sin((CurTime() * 3 * self.RotateSpeed)) * 20, math.cos((CurTime() * 3 * self.RotateSpeed))* 20,-30))
					self:SetIdealPos(self.OwnerCenterPos + Vector(math.sin((CurTime() * 3 * self.RotateSpeed)) * 20, math.cos((CurTime() * 3 * self.RotateSpeed))* 20,-30))
					self.Pos = self:GetPos()
				end
				elseif self:GetImageID() == 2 then
					self:SetPos(self.OwnerCenterPos + Vector(math.sin((CurTime() * 3 * self.RotateSpeed) + 42) * 20, math.cos((CurTime() * 3 * self.RotateSpeed) + 42)* 20,-30))
					self:SetIdealPos(self.OwnerCenterPos + Vector(math.sin((CurTime() * 3 * self.RotateSpeed) + 42) * 20, math.cos((CurTime() * 3 * self.RotateSpeed) + 42)* 20,-30))
					self.Pos = self:GetPos()
				elseif self:GetImageID() == 3 then
				self:SetPos(self.OwnerCenterPos + Vector(math.sin((CurTime() * 3 * self.RotateSpeed) - 42) * 20, math.cos((CurTime() * 3 * self.RotateSpeed) - 42)* 20,-30))
				self:SetIdealPos(self.OwnerCenterPos + Vector(math.sin((CurTime() * 3 * self.RotateSpeed) - 42) * 20, math.cos((CurTime() * 3 * self.RotateSpeed) - 42)* 20,-30))
					self.Pos = self:GetPos()
			end
			
			elseif !((self.InStill or self:GetInDoDoDo() and self.StandId != GSTANDS_JST) and self.DistToOwner <= self.Range) and !Active and self:GetSequence() != self:LookupSequence("timestop") and self:GetSequence() != self:LookupSequence("flick") and self:GetSequence() != self:LookupSequence("JUMP_FIST") then
			if self:GetImageID() == 1 and (self.StandId != GSTANDS_TGRAY ) then
					self:SetIdealPos(self.OwnerPos + (self.Owner:GetAimVector() * (45 - self.Owner:EyeAngles().p / 2)))
					self.Pos = self:GetPos()
				elseif self:GetImageID() == 1 and (self.StandId == GSTANDS_TGRAY ) then
					self:SetIdealPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * (45 - self.Owner:EyeAngles().p / 2)))
					self.Pos = self:GetPos()
				elseif IsValid(self.Image) and self.Image and self:GetImageID() == 2 then
					self:SetIdealPos(self.OwnerPos + (self.Owner:GetAimVector() * (45 - self.Owner:EyeAngles().p / 2)) + (self.Image:GetRight() * 25))
					self.Pos = self:GetPos()
				elseif IsValid(self.Image) and self.Image and self:GetImageID() == 3 then
					self:SetIdealPos(self.OwnerPos + (self.Owner:GetAimVector() * (45 - self.Owner:EyeAngles().p / 2)) - (self.Image:GetRight() * 25))
					self.Pos = self:GetPos()
			end
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
			self:SetIdealPos(self.Owner:EyePos() + (self.Owner:GetForward() * self.offset.x) + (self.Owner:GetRight() * self.offset.y) - Vector(0,0,self.offset.z))
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
		elseif !self:GetInDoDoDo() and self.StandId != GSTANDS_JST then
			self.Owner:RemoveFlags(FL_ATCONTROLS)
			if self:GetBlockCap() then
				self:SetAITarget(self:GetNPCThreat())
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
				local speed = self.Speed / 2
				if self.Owner:gStandsKeyDown("modifierkey1") then speed = self.Speed end
				self:SetIdealPos((self.Pos + self.StandVelocity * FTr.Fraction * (speed)))
			end
		end
		if not self.SendForward then
			self.StandVelocity = self.StandVelocity * 0.4
			if (self.StandId == GSTANDS_TGRAY) then
				self.StandVelocity = self.StandVelocity / 1.5
			end
		end
		
	
	end
	if (self.StandId == GSTANDS_TGRAY) and self.Owner:KeyDown(IN_SPEED) and IsValid(self.Wep) and IsValid(self.Wep:GetLockTarget()) then
		self:SetIdealAngles((LerpVector(0.1, self.Wep:GetLockTarget():EyePos(), self.Wep:GetLockTarget():WorldSpaceCenter()) - self:GetPos()):Angle())
		if self.Owner:KeyDown(IN_FORWARD) then
		self.StandVelocity = ((self.Wep:GetLockTarget():EyePos() - self.Wep:GetLockTarget():GetAimVector() * 75) - self:GetPos()):GetNormalized()
		end
	end
	if self.RotateSpeed == 1 then
		self:SetAngles(LerpAngle(0.3, self:GetAngles(), self:GetIdealAngles()))
	end
		if self:GetPos() != self:GetIdealPos() and !self.SendForward then
		local LastPos = self:GetPos()
		self:SetPos(LerpVector(0.7, self:GetPos(), self:GetIdealPos()))
		local dir = (self:GetPos() - LastPos):GetNormalized()
		self:SetIdealPos(LerpVector(0.7, self:GetPos(), self:GetIdealPos()))
		end
	if self.SendForward then
		self:SetPos((self.Pos + self.StandVelocity * 2))
		self:SetIdealPos((self.Pos + self.StandVelocity * 2))
		self.Pos = self:GetPos()
	end 
end
function ENT:OnRemove()
	if self.Owner then
		hook.Remove("PlayerSwitchFlashlight", "StandFlashlightsareCool"..self.OwnerName..self:EntIndex())
	end
	if IsValid(self.Owner) then
		self.Owner:RemoveFlags(FL_ATCONTROLS)
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

ENT.PredTimer = 0
function ENT:GetClosest(ply, vec)
	local closestply
	local closestdist
	for k, v in pairs(player.GetAll()) do
		if v != ply then
			local dist = vec:Distance(v:GetPos())
			if not closestdist then
				closestdist = dist
				closestply = v
			end
			if dist < closestdist then
				closestdist = dist
				closestply = v
			end
		end
	end
	if closestply and closestply:WorldSpaceCenter():Distance(self.Owner:WorldSpaceCenter()) <= 1500 then
		return closestply:EyePos()
		else
		return self:GetEyePos(true) + self:GetForward() * 55
	end
	end
function ENT:Think()
	if !IsValid(self.Owner) then
		self:Remove()
		return true
	end
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
	self.Image = self:GetImage()
	self.Wep = self.Wep or self.Owner:GetActiveWeapon()
	if self.StandId == GSTANDS_HIEROPHANT and self.HEGEndPos != self:GetHEGEndPos() then
		self.HEGEndPos = self:GetHEGEndPos()
	end
	if SERVER then
		self:SetRange(self.Range)
	end
	if self.Wep.GetStand and self != self.Wep:GetStand() and self:GetImageID() == 1 then
		self:Remove()
	end
	if self.Wep.GetStand1 and self != self.Wep:GetStand1() and self:GetImageID() == 2 then
		self:Remove()
	end
	if self.Wep.GetStand2 and self != self.Wep:GetStand2() and self:GetImageID() == 3 then
		self:Remove()
	end
	
	--Fix the bounds of Tower of Gray
	if (self.StandId == GSTANDS_TGRAY ) then
		self:SetCollisionBounds(Vector(-1,-1,-1), Vector(1,1,1))
	end
	--Define initial value of the picked up item
	self.ItemPickedUp = self.ItemPickedUp or self
	if self.Owner and self.Owner:GetActiveWeapon():IsValid() and self.Owner:GetActiveWeapon():GetHoldType() != "stando" then
		self:DropItem()
	end
	if not IsValid(self.ItemPickedUp) then 
		self.ItemPickedUp = self
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
	if SERVER and self.Owner:gStandsKeyDown("modifierkey2") and self.ItemPickedUp and self.ItemPickedUp:IsValid() and self.ItemPickedUp != self and CurTime() > self.PickupTimer then
		if self.Owner:KeyDown(IN_DUCK) then
			if self.StandId == GSTANDS_PLATINUM or self.StandId == GSTANDS_WORLD or self.StandId == GSTANDS_COPPER then
				if GetConVar("gstands_time_stop"):GetBool() then
					self.ItemPickedUp.OGVel = self.Forward * 1500
					self.ItemPickedUp.GSTSStopped = false
					self.ItemPickedUp.GSTSFactor = 1
					self.ItemPickedUp:SetAngles(self:GetAngles())
				end
				for i = 0, self.ItemPickedUp:GetPhysicsObjectCount() - 1 do
					local phys = self.ItemPickedUp:GetPhysicsObjectNum(i)
					phys:SetVelocity(self.Forward * 10000/math.Clamp((phys:GetMass()/50),1,5000))
					phys:ApplyTorqueCenter(self.ItemPickedUp:GetRight() * 20)
					phys:AddGameFlag(FVPHYSICS_WAS_THROWN)
					phys:ClearGameFlag(FVPHYSICS_PLAYER_HELD)
					phys:SetAngles(self:GetAngles())
					self.Throwing = true
					self:RemoveAllGestures()
					self:ResetSequence( self:LookupSequence("SEQ_THROW" ))
					self:SetPlaybackRate(2)  
					
					self:SetCycle(0.3)
					timer.Simple(self:SequenceDuration() - 1.5, function() self.Throwing = false self:RemoveAllGestures() self:SetPlaybackRate(1) end)
				end
				if self.StandId == GSTANDS_WORLD or self.StandId == GSTANDS_COPPER then
					self:EmitStandSound("weapons/world/muda.wav")
					elseif self.StandId == GSTANDS_PLATINUM then
					self:EmitStandSound("platinum.ora")
				end
				else
				if GetConVar("gstands_time_stop"):GetBool() then
					self.ItemPickedUp.OGVel = self.Forward * 1500
					self.ItemPickedUp.GSTSStopped = false
					self.ItemPickedUp.GSTSFactor = 1
					self.ItemPickedUp:SetAngles(self:GetAngles())
				end
				for i = 0, self.ItemPickedUp:GetPhysicsObjectCount() - 1 do
					self.ItemPickedUp:GetPhysicsObjectNum(i):SetVelocity(self.Forward * 2000)
					self.ItemPickedUp:GetPhysicsObjectNum(i):SetAngles(self:GetAngles())
					self:ResetSequence( self:LookupSequence("SEQ_THROW" ))
					self:SetPlaybackRate(2)  
					self.Throwing = true
					self:SetCycle(0.3)
					timer.Simple(self:SequenceDuration() - 1.5, function() self.Throwing = false self:RemoveAllGestures() self:SetPlaybackRate(1) end)
				
				end
			end
		end
		self:DropItem()
	end
	if self.Owner:IsValid() and self.Owner:Alive() then
		if SERVER and self.StandId == GSTANDS_CHARIOTUN then
			self.offset.z = 30 + self.Rate * (math.sin(CurTime()))
			elseif self.StandId != GSTANDS_JST and (self.StandId != GSTANDS_TGRAY )then
			self.offset.z = 30
			self.offset.x = -20
			self.offset.y = 20
			elseif self.StandId == GSTANDS_JST then
			self.offset.z = 150
			self.offset.x = -30
			self.offset.y = 5
			elseif (self.StandId == GSTANDS_TGRAY ) then
			self.offset.z = -math.cos(CurTime()) * 4 + math.sin(CurTime()) * 10
			self.offset.x = math.sin(CurTime()) * 4  + -math.cos(CurTime()) * 7
			self.offset.y = -math.cos(CurTime()) * 4  + math.sin(CurTime()) * 10
		end
		
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

		self.BlockTimer = self.BlockTimer or CurTime()
		if SERVER and CurTime() >= self.BlockTimer and self.Owner:gStandsKeyDown("defensivemode") then
			self:SetBlockCap(!self:GetBlockCap())
			if SERVER and self:GetBlockCap() and self.ImageID == 1 then
				self.Owner:ChatPrint("#gstands.general.defenseon")
			elseif SERVER and self.ImageID == 1  then
				self.Owner:ChatPrint("#gstands.general.defenseoff")
			end
			self.BlockTimer = CurTime() + 0.5
		end

		if self.Owner:gStandsKeyDown("standleap") then
			local trJu = util.TraceLine( {
				start = self.Owner:EyePos(),
				endpos = self.Owner:EyePos() - self.Owner:EyeAngles():Up() * 105,
				filter = {self.Owner, self},
				mask = MASK_SHOT_HULL
			} )
			self.nextHop = self.nextHop or CurTime()
			if SERVER and CurTime() >= self.nextHop and trJu.Hit then
				self.nextHop = CurTime() + 1
				self:SetCycle( 0 )
				self:SetPlaybackRate( 1 )
				local mult = 1000 * JumpPowerTable[self.Model]
				self.Owner:ConCommand("+jump")
				self.Owner:SetVelocity(self.Owner:EyeAngles():Up() + trJu.HitNormal * mult)
				timer.Simple(0.1, function()
					if IsValid(self.Owner) then
						self.Owner:ConCommand("-jump")
					end
				end)
				local effectdata = EffectData()
				effectdata:SetOrigin(trJu.HitPos)
				effectdata:SetNormal(trJu.HitNormal)
				effectdata:SetFlags(1)
				effectdata:SetMagnitude(3)
				util.Effect("gstands_stand_impact", effectdata, true, true)	
				if SERVER then
					self.Owner:EmitStandSound("weapons/airboat/airboat_gun_energy"..math.random(1,2)..".wav")
				end
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
			
			elseif (self.StandId == GSTANDS_TGRAY ) and self.StandId == GSTANDS_HORUS and !self.Owner:KeyDown(IN_ATTACK2) and self:GetSequence() != self:LookupSequence("eat") and self:GetSequence() != self:LookupSequence("bite") and !self.Throwing then
			self:SetPlaybackRate(1)
		end
		elseif SERVER then
		self:Remove()
	end
	if SERVER then
	self:NextThink( CurTime() ) 
	end
	return true
end

function ENT:GetNPCThreat()
	if self.IdealAITarget and self.IdealAITarget:IsValid() and self.IdealAITarget:Health() > 0 and !(IsValid(self.Image) and self.IdealAITarget == self.Image.IdealAITarget) and !(IsValid(self.Image1) and self.IdealAITarget == self.Image1.IdealAITarget) then
		return self.IdealAITarget
	end
	local dangerous
	local high
	local ply = self.Owner
	local npctable = {}
	for k, v in pairs(ents.GetAll()) do
		local dist = ply:WorldSpaceCenter():Distance(v:WorldSpaceCenter()) 
		if v:IsNPC() and v:IsValid() and dist <= 1500 then
			table.insert(npctable, v)
		end
		if v:GetClass() == "npc_grenade_frag" and dist <= 1500 then
			table.insert(npctable, v)
		end
		if v:GetClass() == "rpg_missile" and dist <= 1500 then
			table.insert(npctable, v)
		end
	end
	for k, v in pairs(npctable) do
		if v:IsValid() then
			v.ranking = 1500 - self.OwnerCenterPos:Distance(v:WorldSpaceCenter())
			if v:IsNPC() then
				v.ranking = v.ranking - v:Disposition(ply)
				if v:GetEnemy() == self.Owner then
					v.ranking = v.ranking + 100
				end
				if v:GetTarget() == self.Owner then
					v.ranking = v.ranking + 100
				end
				if v:GetNPCState() == 2 then
					v.ranking = v.ranking + 100
				end
				if v:GetNPCState() == 3 then
					v.ranking = v.ranking + 200
				end
				if v:Disposition(ply) >= 3 then
					v.ranking = 0
				end
			end
			if v:GetClass() == "rpg_missile" then
				v.ranking = 3000
			end
			if v:GetClass() == "npc_grenade_frag" then
				v.ranking = 3000
			end
			if v.Alive and !v:Alive() then
				v.ranking = 0
			end
			if v:Health() < 1 then
				v.ranking = 0
			end
			if IsValid(self.Image) and self.Image:GetAITarget() == v then
				v.ranking = 0
			end
			if IsValid(self.Image1) and self.Image1:GetAITarget() == v then
				v.ranking = 0
			end
		end
		if !high then
			high = v.ranking
			dangerous = v
		end
		if v.ranking > high then
			high = v.ranking
			dangerous = v
		end
		v.ranking = nil
	end
	return dangerous
end

function ENT:BlockAI()
	self.AITarget = self:GetAITarget() or NULL
	if self.AITarget:IsValid() then
		if SERVER and !self.Blocking then
			self:RemoveAllGestures()
		end
		local dropper = Vector(0,0,0)
		local aipos = self.AITarget:GetPos()
		local dir = (aipos - self.Owner:GetPos()):GetNormalized()
		local standdir = (aipos - self:GetPos()):GetNormalized()
		local mult = math.Clamp(aipos:Distance(self:GetPos()), 5, 55)
		self:SetPoseParameter("aim_pitch", 0)
		self:SetPoseParameter("aim_yaw", 0)
		if self.AITarget:GetClass() == "rpg_missile" then
			dropper = Vector(0,0,35)
		end
		local pos = self.Owner:GetPos() - dropper + dir * mult
		if (self.StandId == GSTANDS_TGRAY) then
			pos = self.Owner:WorldSpaceCenter() - dropper + dir * mult
		end
		if self.AITarget:GetClass() == "stand" then
			mult = mult / 5
		end
		self:SetIdealPos( pos )
		
		self:SetIdealAngles(Angle(0,standdir:Angle().y, 0))
		return true
	end
	return false
end

function ENT:OnTakeDamage(dmg)
	if (!GetConVar("gstands_stand_hurt_stands"):GetBool() or string.StartWith(dmg:GetInflictor():GetClass(), "gstands_")) and self.StandId != GSTANDS_JST and self.StandId != GSTANDS_COPPER then
		if (self.StandId == GSTANDS_TGRAY ) and self.Owner:KeyDown(IN_ATTACK2) and self:GetInDoDoDo() then
			self:EmitStandSound("tgray.whizz")
			return false
		end
		if self:GetSequenceName(self:GetSequence()) == "barrage" then
			self.HitAlternate = !self.HitAlternate
			if self.HitAlternate then return false end
			dmg:SetDamage(dmg:GetDamage()/2)
		end
		if self:GetSequenceName(self:GetSequence()) == "slash" and (self.StandId == GSTANDS_CHARIOT or self.StandId == GSTANDS_CHARIOTUN) then
			return true
		end
		if self:GetSequenceName(self:GetSequence()) == "idleblock" then
			dmg:SetDamage(dmg:GetDamage()/5)
			if SERVER then
				self:EmitStandSound("MetalGrate.BulletImpact")
			end
		end
		if self:GetSequenceName(self:GetSequence()) == "block" then
			if SERVER then
				self:EmitSound("MetalGrate.BulletImpact")
			end
			return true
		end
		if timer.Exists("zawarudo"..self.OwnerName) and dmg:GetDamage() >= 25 then
			timer.Remove("zawarudo"..self.OwnerName)
			self.Owner:GetActiveWeapon():SetHoldType("stando")
		end
		if timer.Exists("sutahprachina"..self.OwnerName) and dmg:GetDamage() >= 25 then
			timer.Remove("sutahprachina"..self.OwnerName)
			self.Owner:GetActiveWeapon():SetHoldType("stando")
		end
		self.Owner:TakeDamageInfo(dmg)
		return false
	end
end