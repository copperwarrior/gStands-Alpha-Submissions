include('shared.lua')
ENT.Type = "anim"
ENT.Base = "stand_player_base"

ENT.PrintName= "Stand"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "To stand"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
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
	"models/player/jgm/jgm.mdl",
	"models/player/osi/osi.mdl",
	"models/horus/horus.mdl",
	"models/tgray/tgray.mdl"
	}

function ENT:Initialize()
	self:DrawShadow(false)
	self:UseClientSideAnimation()
	self.Owner:SetRenderMode(RENDERGROUP_BOTH)
	for k,v in pairs(self:GetMaterials()) do
		local mat = Material(v)
		if string.StartWith(mat:GetShader(),"Eyes") then
			self:SetSubMaterial(k - 1, "color")
		end
	end
		self.StandId = GetgStandsID(self:GetModel())

	if self:GetModel() == "models/player/starpjf/spjf.mdl" and self.NewModel ~= "models/player/starpjf/spjf.mdl" then
		self.NewModel = GetConVar("gstands_replacement_gstands_star_platinum"):GetString()
		local animid = self:LookupSequence("Barrage")
		--self:SetModel(NewModel)
		local animid2 = self:LookupSequence("Barrage")
		if animid != animid2 then
			self.Owner:ChatPrint("#gstands.general.errors.repincompat")
			if animid2 != -1 then
				self.Owner:ChatPrint("#gstands.general.errors.repincompat.index")
			end
			if animid2 == -1 then
				self.Owner:ChatPrint("#gstands.general.errors.repincompat.anims")
			end
		end
		if self.NewModel ~= "" then
			local pmodelname = player_manager.TranslateToPlayerModelName(self.NewModel)
			self.OverrideArms = player_manager.TranslatePlayerHands(pmodelname).model
		end
	end
	if self:GetModel() == "models/player/worldjf/world.mdl" then
		self.NewModel = GetConVar("gstands_replacement_gstands_the_world"):GetString()
		local animid = self:LookupSequence("Barrage")
		--self:SetModel(NewModel)
		local animid2 = self:LookupSequence("Barrage")
		if animid != animid2 then
			self.Owner:ChatPrint("#gstands.general.errors.repincompat")
			if animid2 != -1 then
				self.Owner:ChatPrint("#gstands.general.errors.repincompat.index")
			end
			if animid2 == -1 then
				self.Owner:ChatPrint("#gstands.general.errors.repincompat.anims")
			end
		end
		if self.NewModel ~= "" and self.NewModel ~= "models/player/worldjf/world.mdl" then
			local pmodelname = player_manager.TranslateToPlayerModelName(self.NewModel)
			self.OverrideArms = player_manager.TranslatePlayerHands(pmodelname).model
		end
	end
	self.Wep = self.Owner:GetActiveWeapon()
	self:SetRenderMode(RENDERGROUP_BOTH)
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
	self.offset = Vector(-20,20,30)
	if CLIENT and self.StandId == GSTANDS_JST then
		local tag = self:EntIndex()
		hook.Add("SetupWorldFog", "justicefog"..tag, function()
			if IsValid(self) then
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
				
				render.FogStart(0)
				if LocalPlayer() != self.Owner then
					render.FogMaxDensity(math.Clamp((500/LOD), 0, 0.9))
					else
					render.FogMaxDensity(math.Clamp((500/LOD), 0, 0.5))
				end
				local clor = gStands.GetStandColor(self:GetModel(), self:GetSkin()) * 255
				render.FogColor(clor.x, clor.y, clor.z)
				render.FogEnd(0)
				render.FogMode(MATERIAL_FOG_LINEAR)
				return true
				else
				hook.Remove("SetupWorldFog", "justicefog"..tag)
			end
		end)
	end
	self.Model = self:GetModel()
	self:SetRenderMode(RENDERGROUP_BOTH)
	self.OwnerName = self.Owner:GetName()
	self.Color = self:GetColor()
		self.StandId = GetgStandsID(self:GetModel())

	if self.StandId == GSTANDS_JST then
		self:ResetSequence(self:LookupSequence("float"))
	end
	self.Rate = math.random(0,5)
	self.FlashLight = self.FlashLight or self
	self.Delay = CurTime() + 0.1
	self.OwnerPos = self.Owner:GetPos()
	self:SetPos(self.OwnerPos)
	self.Pos = self:GetPos()
	self:SetIK(true)
	self:Think()
end			 

local FTr = {}

function ENT:DoMovement()
	if CLIENT and !LocalPlayer() == self.Owner then return true end
	if !self:GetMarkedToFade() then
	local Active = false
	if self.Wep.GetActive then
		Active = self.Wep:GetActive()
	end
	if !self:GetInDoDoDo() and !self.InStill then

		for i = 0, self.Owner:GetNumPoseParameters() - 1 do
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
	local etr = util.TraceLine( {
		start = self:GetEyePos(true),
		endpos = self.Owner:GetEyeTrace().HitPos,
		filter = {self.Owner, self},
	})
	local ang = self.Owner:EyeAngles() - self:GetAngles()
	
	ang:Normalize()
	if self.HeadRotOffset and !self.NewModel then
	ang:RotateAroundAxis(self:GetUp(), self.HeadRotOffset)
	end
	local flMin, flMax = self:GetPoseParameterRange( 6 )
	self:SetPoseParameter("head_yaw", ang.y)
	self:SetPoseParameter("aim_yaw", ang.y)
	flMin, flMax = self:GetPoseParameterRange( 7 )
	self:SetPoseParameter("head_pitch", ang.p)
	self:SetPoseParameter("aim_pitch", ang.p)
	if self:GetParent() != nil and !self:GetParent():IsValid() then
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
			self.StandVelocity = (self.StandVelocity + self.Owner:GetAimVector():Angle():Up()):GetNormalized()
			self.Pos = self:GetPos()
		end
		if !self.Owner:gStandsKeyDown("modifierkey2") and self.Owner:KeyDown(IN_DUCK) then
			self.StandVelocity = (self.StandVelocity - self.Owner:GetAimVector():Angle():Up()):GetNormalized()
			self.Pos = self:GetPos()
		end
	elseif !self:GetInDoDoDo() and self.StandId != GSTANDS_JST then
		self.Owner:RemoveFlags(FL_ATCONTROLS)
		if self:GetBlockCap() then
			if SERVER then
				self:SetAITarget(self:GetNPCThreat())
			end
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
	if self.RotateSpeed == 1 then
		self:SetAngles(LerpAngle(0.3, self:GetAngles(), self:GetIdealAngles()))
	end
	if self.SendForward then
		self:SetPos((self.Pos + self.StandVelocity * self.Speed))
		self:SetIdealPos((self.Pos + self.StandVelocity * self.Speed))
		self.Pos = self:GetPos()
	end 
end
function ENT:OnRemove()
	if CLIENT and self.Aura then
		self.Aura:StopEmission()
	end
	return false
end

local unlimitrange = GetConVar("gstands_unlimited_stand_range")

function ENT:Think()
	self.Owner:SetRenderMode(RENDERGROUP_BOTH)
	if not IsValid(self.Owner) then return end

	self.Range = self:GetRange()
	if unlimitrange:GetBool() then
		self.Range = 100000000000
	end
	self.OwnerPos = self.Owner:GetPos()
	self.OwnerCenterPos = self.Owner:WorldSpaceCenter()
	self.CenterPos = self:WorldSpaceCenter()
	self.Pos = self:GetPos()
	self.Forward = self:GetForward()
	self.DoDoDoTimer = self.DoDoDoTimer or CurTime()
	
	self.InStill = self.Owner:gStandsKeyDown("modifierkey2")
	self.DistToOwner = self.Pos:Distance(self.OwnerPos)
	self.Model = self:GetModel()
	self.Image = self:GetImage()
	self.Wep = self.Wep or self.Owner:GetActiveWeapon()
	if self.StandId == GSTANDS_HIEROPHANT and self.HEGEndPos != self:GetHEGEndPos() then
		self.HEGEndPos = self:GetHEGEndPos()
	end
	if (self.StandId == GSTANDS_HORUS) and self.Owner:KeyDown(IN_ATTACK2) then
		self.InStill = true
	end
	self:SetVelocity(-self:GetVelocity())
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
		self.LastPos = self:GetPos()
		if !self:GetFrozen() then
			self:DoMovement()
		end
	end
	self:NextThink(  math.Round(CurTime()) )
	self:SetNextClientThink( CurTime())
	return true
end
ArmsTable = ArmsTable or {}
local part3armstable = {
	["models/player/starpjf/spjf.mdl"] = "models/player/starpjf/spjfarms.mdl",
	["models/player/worldrv/world.mdl"] = "models/player/worldrv/worldarms.mdl",
	["models/player/worldjf/world.mdl"] = "models/player/worldjf/worldarms.mdl",
	["models/player/copper/copper.mdl"] = "models/player/copper/c_copper.mdl",
	["models/player/slc/slc.mdl"] = "models/slc/c_slc.mdl",
	["models/player/slc/slc_un.mdl"] = "models/slc/c_slc.mdl",
}
table.Merge(ArmsTable, part3armstable)
local mat = Material("effects/gstands_aura")
local blur = Material("pp/blurscreen")

local SwordTrail = Material( "effects/chariot_trail" )
local JusticeFogMat = Material( "models/jst/smokestack_nofog.vmt" )
local JusticeFogMatNoz = Material( "models/jst/smokestack_nofognoz.vmt" )
local shine = Material("sprites/light_glow02_add.vmt")
local transmat = Material("models/transfilter.vmt")

function ENT:Draw()
	self.Owner:SetRenderMode(RENDERGROUP_BOTH)
end

function ENT:DrawTranslucent(flags, opaque)
	self.Owner:SetRenderMode(RENDERGROUP_BOTH)
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
	self.CenterImage = self:GetCenterImage()
	local rupper, lupper, rlower, llower = self:LookupBone("ValveBiped.Bip01_R_UpperArm"), self:LookupBone("ValveBiped.Bip01_L_UpperArm"), self:LookupBone("ValveBiped.Bip01_R_ForeArm"), self:LookupBone("ValveBiped.Bip01_L_ForeArm")
	local rupperh, lupperh = self:LookupBone("ValveBiped.Bip01_R_Hand"), self:LookupBone("ValveBiped.Bip01_L_Hand")
	local rupperleg, rlowerleg = self:LookupBone("ValveBiped.Bip01_R_Thigh"), self:LookupBone("ValveBiped.Bip01_R_Calf")
	self.Timescale = GetConVar("host_timescale"):GetFloat()
	self.OwnerNoDraw = false
	self.PullOut = self.PullOut or 0
	self.PullOut = math.Clamp(self.PullOut + 0.1,0, 0.7)
	local clr = Color(255,255,255)
	if !self.OwnerNoDraw then
		if self.PullOut < 0.7 or LocalPlayer() == self.Owner and self:GetPos():DistToSqr(self:GetIdealPos()) >= 300 and !self:GetInDoDoDo() then
			if self.PullOut < 0.7 then
				self:SetPos(LerpVector(self.PullOut, self.Owner:GetPos(), self:GetIdealPos())) 
			else
				self:SetPos(LerpVector(self.PullOut, self:GetPos(), self:GetIdealPos())) 
			end
			self:SetupBones()
		end
		if CLIENT and LocalPlayer():GetActiveWeapon() then
			if LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then
				
				if !self.OwnerNoDraw and self.LOD < 2 and !(self.StandId == GSTANDS_CREAM and self.Wep:GetActive())  then
					self:SetupBones()
					self.Aura = self.Aura or CreateParticleSystem(self.Owner, "auraeffect", PATTACH_POINT_FOLLOW, 1)
					if self.Aura then
						self.Aura:SetControlPoint(1, gStands.GetStandColor(self.Model, self:GetSkin()))
					end
					if self.StandId != GSTANDS_TGRAY and self.LOD < 2 then
						self.StandAura = self.StandAura or CreateParticleSystem(self, "auraeffect", PATTACH_POINT, 1)
						if self.StandAura then
							self.StandAura:SetControlPoint(1, gStands.GetStandColor(self.Model, self:GetSkin()))
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
				if self:GetSequence() == self:LookupSequence("succ") then
					self.Succ = self.Succ or CreateParticleSystem(self, "succ", PATTACH_POINT_FOLLOW, 1)
					if self.Succ then
						self.Succ:SetControlPoint(0, self:GetEyePos(true))
						self.Succ:SetControlPoint(1, self:GetEyePos(true) + self:GetForward() * 200)
						self.Succ:SetControlPoint(2, gStands.GetStandColor(self.Model, self:GetSkin()))
					end
					elseif self.Succ then 
					self.Succ:StopEmission(false, true)
					self.Succ = nil
				end
				if self:GetImageID() == 1 and self.StandId == GSTANDS_CHARIOTUN then
					if IsValid(self.CenterImage) then

						render.SetBlend(math.Rand(0.1,0.2))

						local OGPos = self:GetPos()

						self:SetPos(LerpVector(math.Rand(0.5,1.1), self.CenterImage:GetPos(), OGPos + VectorRand()/5 + self:GetRight() * math.Rand(1,3)))

						self:SetupBones()

						self:DrawModel()

						render.SetBlend(math.Rand(0.1,0.2))

						self:SetPos(LerpVector(math.Rand(0.5,1.1), self.CenterImage:GetPos(), OGPos - VectorRand()/5 - self:GetRight() * math.Rand(1,3)))

						self:SetupBones()

						self:DrawModel()

						render.SetBlend(math.Rand(0.05,0.1))

						self:SetPos(LerpVector(math.Rand(0.5,1.1), self.CenterImage:GetPos(), OGPos + VectorRand()/5 + self:GetRight() * math.Rand(2,4)))

						self:SetupBones()

						self:DrawModel()

						render.SetBlend(math.Rand(0.05,0.1))

						self:SetPos(LerpVector(math.Rand(0.5,1.1), self.CenterImage:GetPos(), OGPos - VectorRand()/5 -self:GetRight() * math.Rand(2,4)))

						self:SetupBones()

						self:DrawModel()
						self:SetPos(OGPos)
						self:SetupBones()
					end
					
				end

				if self:GetImageID() == 2 and self.StandId == GSTANDS_CHARIOTUN then
					if IsValid(self.CenterImage) then

						render.SetBlend(math.Rand(0.1,0.2))

						local OGPos = self:GetPos()

						self:SetPos(LerpVector(math.Rand(0.5,1.1), self.CenterImage:GetPos(), OGPos + VectorRand()/5 + self:GetRight() * math.Rand(1,3)))

						self:SetupBones()

						self:DrawModel()

						render.SetBlend(math.Rand(0.1,0.2))

						self:SetPos(LerpVector(math.Rand(0.5,1.1), self.CenterImage:GetPos(), OGPos - VectorRand()/5 - self:GetRight() * math.Rand(1,3)))

						self:SetupBones()

						self:DrawModel()

						render.SetBlend(math.Rand(0.05,0.1))

						self:SetPos(LerpVector(math.Rand(0.5,1.1), self.CenterImage:GetPos(), OGPos + VectorRand()/5 + self:GetRight() * math.Rand(2,4)))

						self:SetupBones()

						self:DrawModel()

						render.SetBlend(math.Rand(0.05,0.1))

						self:SetPos(LerpVector(math.Rand(0.5,1.1), self.CenterImage:GetPos(), OGPos - VectorRand()/5 -self:GetRight() * math.Rand(2,4)))

						self:SetupBones()

						self:DrawModel()
						self:SetPos(OGPos)
						self:SetupBones()
					end
					
				end

				
				if self:GetImageID() == 3 and self.StandId == GSTANDS_CHARIOTUN then

					if IsValid(self.CenterImage) then

						render.SetBlend(math.Rand(0.1,0.2))

						local OGPos = self:GetPos()

						self:SetPos(LerpVector(math.Rand(0.5,1.1), self.CenterImage:GetPos(), OGPos + VectorRand()/5 + self:GetRight() * math.Rand(1,3)))

						self:SetupBones()

						self:DrawModel()

						render.SetBlend(math.Rand(0.1,0.2))

						self:SetPos(LerpVector(math.Rand(0.5,1.1), self.CenterImage:GetPos(), OGPos - VectorRand()/5 - self:GetRight() * math.Rand(1,3)))

						self:SetupBones()

						self:DrawModel()

						render.SetBlend(math.Rand(0.05,0.1))

						self:SetPos(LerpVector(math.Rand(0.5,1.1), self.CenterImage:GetPos(), OGPos + VectorRand()/5 + self:GetRight() * math.Rand(2,4)))

						self:SetupBones()

						self:DrawModel()

						render.SetBlend(math.Rand(0.05,0.1))

						self:SetPos(LerpVector(math.Rand(0.5,1.1), self.CenterImage:GetPos(), OGPos - VectorRand()/5 -self:GetRight() * math.Rand(2,4)))

						self:SetupBones()

						self:DrawModel()
						self:SetPos(OGPos)
						self:SetupBones()
					end
					
				end
				
				if self.StandId == GSTANDS_JUDGEMENT and self:GetSequence() == self:LookupSequence("h2u") then
					render.SetMaterial(shine)
					render.DrawSprite(self:WorldSpaceCenter() + Vector(0,0,25), 235,235, Color(255,150,255))
				end
				if !self:GetNoDraw() then
					self:SetupBones()
					self.PullOut2 = self.PullOut2 or 0
					self.PullOut2 = math.Clamp(self.PullOut2 + 0.1, 0, 1)
					if self:GetMarkedToFade() then
						self.PullOut2 = math.Clamp(self.PullOut2 - 0.2, 0, 1)
						if self.EyesReady then
							for k,v in pairs(self:GetMaterials()) do
								local mat = Material(v)
								if string.StartWith(mat:GetShader(),"Eyes") then
									self:SetSubMaterial(k - 1, "color")
								end
							end
						end
					end
					if self.PullOut2 >= 1 and !self.EyesReady then
						for k,v in pairs(self:GetMaterials()) do
							local mat = Material(v)
							if string.StartWith(mat:GetShader(),"Eyes") then
								self:SetSubMaterial(k - 1)
								self.EyeIndex = k
								self.HasEyes = true
								end
							if self.EyeIndex and self:GetSubMaterial(self.EyeIndex - 1) == "" or !self.HasEyes then
								self.EyesReady = true
							end
						end
						
					end
					render.SetBlend(self.PullOut2)
					if self.StandId == GSTANDS_CHARIOTUN then
						render.SetBlend( 50 / LOD )
					end
					if IsValid(self.Wep) and (self.StandId == GSTANDS_CHARIOT or self.StandId == GSTANDS_CHARIOTUN) and self:GetSequence() != self:LookupSequence("stab") then
						local color = gStands.GetStandColorTable(self.Model, self:GetSkin())
						if self.Wep.GetSwordFlame and self.Wep:GetSwordFlame() then
							self.FlameFX1 = self.FlameFX1 or CreateParticleSystem(self, "chariotflame", PATTACH_POINT_FOLLOW, self:LookupAttachment("swordtip"))
							self.FlameFX2 = self.FlameFX2 or CreateParticleSystem(self, "chariotflame", PATTACH_POINT_FOLLOW, self:LookupAttachment("swordatt1"))
							self.FlameFX3 = self.FlameFX3 or CreateParticleSystem(self, "chariotflame", PATTACH_POINT_FOLLOW, self:LookupAttachment("swordatt2"))
							self.FlameFX4 = self.FlameFX4 or CreateParticleSystem(self, "chariotflame", PATTACH_POINT_FOLLOW, self:LookupAttachment("swordatt3"))						
							color = Color(255,150,0)
						end
						if !self.Wep:GetSwordFlame() and self.FlameFX1 then
							self.FlameFX1:StopEmission()
							self.FlameFX1 = nil
						end
						if !self.Wep:GetSwordFlame() and self.FlameFX2 then
							self.FlameFX2:StopEmission()
							self.FlameFX2 = nil
						end
						if !self.Wep:GetSwordFlame() and self.FlameFX3 then
							self.FlameFX3:StopEmission()
							self.FlameFX3 = nil
						end
						if !self.Wep:GetSwordFlame() and self.FlameFX4 then
							self.FlameFX4:StopEmission()
							self.FlameFX4 = nil
						end
						if self:GetBodygroup(2) == 1 then
							local posB = self:GetAttachment(self:LookupAttachment("swordatt3")).Pos
							local posT = self:GetAttachment(self:LookupAttachment("swordtip")).Pos
							self.prevB = self.prevB or {}
							self.prevT = self.prevT or {}
							self.prevCyc = self.prevCyc or self:GetCycle()
							render.SetMaterial( SwordTrail )
							local cyc = self:GetCycle()
							self:SetCycle(Lerp(0.5, cyc, self.prevCyc))
							table.insert(self.prevB, 1, LerpVector(0.4, posB, self:GetAttachment(self:LookupAttachment("swordatt3")).Pos))
							table.insert(self.prevT, 1, LerpVector(0.4, posT, self:GetAttachment(self:LookupAttachment("swordtip")).Pos))
							table.insert(self.prevB, 1, LerpVector(0.6, posB, self:GetAttachment(self:LookupAttachment("swordatt3")).Pos))
							table.insert(self.prevT, 1, LerpVector(0.6, posT, self:GetAttachment(self:LookupAttachment("swordtip")).Pos))
							self:SetCycle(cyc)
							for k,v in ipairs(self.prevB) do
								local base = self.prevB[(k + 1)]
								local tip = self.prevT[(k + 1)]
								if base then
									color.a = (15 * (5/k))
									local p = k/8
									render.DrawQuad( base, v, self.prevT[k], tip, color)
								end
							end
							table.insert(self.prevB, 1, posB)
							table.insert(self.prevT, 1, posT)
							table.remove(self.prevB, 8)
							table.remove(self.prevT, 8)
							table.remove(self.prevB, 8)
							table.remove(self.prevT, 8)
							table.remove(self.prevB, 8)
							table.remove(self.prevT, 8)
							self.prevCyc = self:GetCycle()
						end
					end
					
					if self.StandId == GSTANDS_TGRAY and self:GetBodygroup(1) == 0 then

						local OGPos = self:GetPos()

						local OGCycle = self:GetCycle()

						self.LastPosTG = self.LastPosTG or {}

						self.LastPosIndex = self.LastPosIndex or 1

						local mult = 1

						if self.Wep.GetTongues then

						mult = self.Wep:GetTongues()/3.75

						end

						for k,v in pairs(self.LastPosTG) do

							render.SetBlend((self.LastPosIndex % 5)/15)

							self:SetPos(v + VectorRand() * (mult))

							self:SetupBones()

							self:DrawModel()

							self:SetCycle(1 - (k/5))

						end

						self.LastPosTG[self.LastPosIndex % 6] = OGPos

						self.LastPosIndex = self.LastPosIndex + 1

						self:SetPos(OGPos)

						self:SetCycle(OGCycle)

						self:SetupBones()

						render.SetBlend( 1 )

					end
					if self.StandId == GSTANDS_CHARIOT and self:GetSequence() == self:LookupSequence("stabonce") then
						local OGPos = self:GetPos()
						local OGCycle = self:GetCycle()
						self.Start = self.Start or CurTime()
						for i = 0, 10 do
							render.SetBlend(0.1)
							self:SetPos(LerpVector(i/15 * (1 - ((CurTime() - self.Start))), OGPos, self.OwnerPos))
							self:SetupBones()
							self:DrawModel()
						end
						self:SetPos(OGPos)
						self:SetCycle(OGCycle)
						self:SetupBones()
						render.SetBlend( 1 )
					end
					if self.StandId == GSTANDS_CHARIOT and self:GetSequence() != self:LookupSequence("stabonce") then
						self.Start = nil
					end

					if self.StandId == GSTANDS_TGRAY and self.Owner:KeyDown(IN_ATTACK2) and self:GetBodygroup(1) != 1 then

						local OGPos = self:GetPos()

						local OGCycle = self:GetCycle()

						for i = 0, 5 do

							render.SetBlend(math.Rand(0.2,0.8))

							self:SetCycle(math.Rand(0,1))

							self:SetPos(OGPos + VectorRand() * 10 * (self.Wep:GetTongues()/3.75))

							self:SetupBones()

							self:DrawModel()

							self.LastPosTG[i] = OGPos + VectorRand() * 10

						end

						self:SetPos(OGPos)

						self:SetCycle(OGCycle)

						self:SetupBones()

						render.SetBlend( 0.1 )

					end
					
					if self.StandId == GSTANDS_HIEROPHANT then
						self:SetupBones()
						local bPos, cang = self:GetBonePosition(66)
						local cang = self:GetAngles()
						local percent = 0
						for i = 1, self:GetBoneCount() - 1 do
							local pos1, ang1 = self:GetBonePosition(i)
							if string.StartWith(self:GetBoneName(i), "Tent") and self:GetBoneName(i) != "Tent1" and self:GetBoneName(i) != "Tent2" and self:GetBoneName(i) != "Tent3" then
								percent = math.Clamp(percent + 0.075, 0, 1)
								local norm = self:GetBonePosition(i) - self:GetBonePosition(i - 1)
								norm:Normalize()
								ang = norm:Angle()
								ang = ang
								ang:Normalize()
								ang.r = 0
								local pos
								if i == 79 then percent = 1.1 end
								pos = LerpVector(percent - (79 - i)/125, bPos + norm * 25, self:GetHEGEndPos()  )
								self:SetBonePosition(i, pos, ang1)
								cang = ang1
							end
						end
					end
					if self.StandId == GSTANDS_JST then
						render.SetBlend(500/LOD)
					end
					local mdl = self:GetModel()
					if self.NewModel then
					self:SetModel(self.NewModel)
					
					self:DrawModel()
						--render.MaterialOverride(transmat)
						--self:DrawModel()
						--render.MaterialOverride()
					self:SetModel(mdl)
					else
						self:DrawModel() 
					end
					render.SetBlend(1)

					end
				util.TimerCycle()
				if self:GetPlaybackRate() >= 1 then   
					local zero = Vector(0,0,0)
					if !(IsValid(self.Image) or IsValid(self.Image1)) and self:GetSequence() == self.BarrageAnimIndex then
						local arms = ClientsideModel(ArmsTable[self:GetModel()])
						for i = 0, GetConVar("gstands_barrage_arms"):GetInt() do
							
							local resetAnim = self:GetCycle()
							self:SetCycle(self:GetCycle() + math.Rand(0.3,0.8))
							arms:SetSkin(self:GetSkin())
							
							arms:SetPos(self.Pos)
							arms:SetParent(self)
							arms:AddEffects( EF_BONEMERGE || EF_BONEMERGE_FASTCULL || EF_PARENT_ANIMATES)
							local randvec1 = VectorRand() * 10
							local randvec1 = Vector(randvec1.x/4, randvec1.y, randvec1.z)
							local randvec2 = VectorRand() * 10
							local randvec2 =  Vector(randvec2.x/4, randvec2.y, randvec2.z)
							if self:GetSequence() != self:LookupSequence("Stab") then
								self:ManipulateBonePosition(lupper,randvec1)
								self:ManipulateBonePosition(llower,self:GetManipulateBonePosition(lupper)/2)
								self:ManipulateBonePosition(rupper,randvec2)
								self:ManipulateBonePosition(rlower,self:GetManipulateBonePosition(rupper)/2)
								if self.FlameFX1 and self.FlameFX2 and self.FlameFX3 and self.FlameFX4 then
									self.FlameFX1:SetControlPoint(1, VectorRand() * 10)
									self.FlameFX2:SetControlPoint(1, VectorRand() * 10)
									self.FlameFX3:SetControlPoint(1, VectorRand() * 10)
									self.FlameFX4:SetControlPoint(1, VectorRand() * 10)
								end
							end
							local angadj = 35
							local angadj2 = 45
							local oldclip = false
							if self:GetSequence() == self:LookupSequence("stab") then
								angadj = 5
								oldclip = render.EnableClipping( true )
								local normal = self:GetForward()
								local position = normal:Dot( self:GetEyePos(true) )
								render.PushCustomClipPlane( normal, position )
							end
							
							self:ManipulateBoneAngles(lupper,Angle(math.random(-angadj,angadj), math.random(-angadj,angadj),math.random(-angadj,angadj)))
							self:ManipulateBoneAngles(rupper,Angle(math.random(-angadj,angadj), math.random(-angadj,angadj),math.random(-angadj,angadj)))
							arms:SetBodygroup(2,1)
							
							self:SetupBones()
							arms:SetupBones()
							render.SetBlend(math.Rand(0.1, 0.9))
							if self:GetSequence() == self:LookupSequence("Stab") then
								render.SetBlend(math.Rand(0.1, 0.8))
							end
							arms:DrawModel()
							arms:Remove()
							local tr1 = util.TraceLine( {
								start = self:GetBonePosition(rupperh),
								endpos = self:GetBonePosition(rupperh) + self.Owner:GetAimVector() * 10,
								filter = {self.Owner, self.Stand},
							} )
							local tr2 = util.TraceLine( {
								start = self:GetBonePosition(lupperh),
								endpos = self:GetBonePosition(lupperh) + self.Owner:GetAimVector() * 10,
								filter = {self.Owner, self.Stand},
							} )
							if tr1.HitWorld and math.random(0, 50) == 0 then
								util.Decal("Impact.Concrete", self:GetBonePosition(rupperh), self:GetBonePosition(rupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
								util.Decal("Impact.Sand", self:GetBonePosition(rupperh), self:GetBonePosition(rupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
								util.Decal("FadingScorch", self:GetBonePosition(rupperh), self:GetBonePosition(rupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
							end
							if tr2.HitWorld and math.random(0, 50) == 0 then
								util.Decal("Impact.Concrete", self:GetBonePosition(lupperh), self:GetBonePosition(lupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
								util.Decal("Impact.Sand", self:GetBonePosition(lupperh), self:GetBonePosition(lupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
								util.Decal("FadingScorch", self:GetBonePosition(lupperh), self:GetBonePosition(lupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
							end
							if self:GetSequence() == self:LookupSequence("Stab") then
								render.PopCustomClipPlane()
								oldclip = render.EnableClipping( oldclip )
							end
							self:SetCycle(resetAnim)
							self:ManipulateBonePosition(lupper,zero)
							self:ManipulateBonePosition(llower,zero)
							self:ManipulateBonePosition(rupper,zero)
							self:ManipulateBonePosition(rlower,zero)
							self:ManipulateBoneAngles(lupper,Angle(0,0,0))
							self:ManipulateBoneAngles(rupper,Angle(0,0,0))
						end
						arms:Remove()
					end

					if (IsValid(self.Image) or IsValid(self.Image1)) and self:GetSequence() == self.BarrageAnimIndex then
						local arms = ClientsideModel(ArmsTable[self:GetModel()])
						for i = 0, GetConVar("gstands_barrage_arms"):GetInt() do
							
							local resetAnim = self:GetCycle()
							self:SetCycle(self:GetCycle() + math.Rand(0.3,0.8))
							arms:SetSkin(self:GetSkin())
							
							arms:SetPos(self.Pos)
							arms:SetParent(self)
							arms:AddEffects( EF_BONEMERGE || EF_BONEMERGE_FASTCULL || EF_PARENT_ANIMATES)
							local randvec1 = VectorRand() * 10
							local randvec1 = Vector(randvec1.x/4, randvec1.y, randvec1.z)
							local randvec2 = VectorRand() * 10
							local randvec2 =  Vector(randvec2.x/4, randvec2.y, randvec2.z)
							if self:GetSequence() != self:LookupSequence("Stab") then
								self:ManipulateBonePosition(lupper,randvec1)
								self:ManipulateBonePosition(llower,self:GetManipulateBonePosition(lupper)/2)
								self:ManipulateBonePosition(rupper,randvec2)
								self:ManipulateBonePosition(rlower,self:GetManipulateBonePosition(rupper)/2)
								if self.FlameFX1 and self.FlameFX2 and self.FlameFX3 and self.FlameFX4 then
									self.FlameFX1:SetControlPoint(1, VectorRand() * 10)
									self.FlameFX2:SetControlPoint(1, VectorRand() * 10)
									self.FlameFX3:SetControlPoint(1, VectorRand() * 10)
									self.FlameFX4:SetControlPoint(1, VectorRand() * 10)
								end
							end
							local angadj = 35
							local angadj2 = 45
							local oldclip = false
							if self:GetSequence() == self:LookupSequence("stab") then
								angadj = 5
								oldclip = render.EnableClipping( true )
								local normal = self:GetForward()
								local position = normal:Dot( self:GetEyePos(true) )
								render.PushCustomClipPlane( normal, position )
							end
							
							self:ManipulateBoneAngles(lupper,Angle(math.random(-angadj,angadj), math.random(-angadj,angadj),math.random(-angadj,angadj)))
							self:ManipulateBoneAngles(rupper,Angle(math.random(-angadj,angadj), math.random(-angadj,angadj),math.random(-angadj,angadj)))
							arms:SetBodygroup(2,1)
							
							self:SetupBones()
							arms:SetupBones()
							render.SetBlend(math.Rand(0.1, 0.9))
							if self:GetSequence() == self:LookupSequence("Stab") then
								render.SetBlend(math.Rand(0.1, 0.2))
							end
							arms:DrawModel()
							arms:Remove()
							local tr1 = util.TraceLine( {
								start = self:GetBonePosition(rupperh),
								endpos = self:GetBonePosition(rupperh) + self.Owner:GetAimVector() * 10,
								filter = {self.Owner, self.Stand},
							} )
							local tr2 = util.TraceLine( {
								start = self:GetBonePosition(lupperh),
								endpos = self:GetBonePosition(lupperh) + self.Owner:GetAimVector() * 10,
								filter = {self.Owner, self.Stand},
							} )
							if tr1.HitWorld and math.random(0, 50) == 0 then
								util.Decal("Impact.Concrete", self:GetBonePosition(rupperh), self:GetBonePosition(rupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
								util.Decal("Impact.Sand", self:GetBonePosition(rupperh), self:GetBonePosition(rupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
								util.Decal("FadingScorch", self:GetBonePosition(rupperh), self:GetBonePosition(rupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
							end
							if tr2.HitWorld and math.random(0, 50) == 0 then
								util.Decal("Impact.Concrete", self:GetBonePosition(lupperh), self:GetBonePosition(lupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
								util.Decal("Impact.Sand", self:GetBonePosition(lupperh), self:GetBonePosition(lupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
								util.Decal("FadingScorch", self:GetBonePosition(lupperh), self:GetBonePosition(lupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
							end
							if self:GetSequence() == self:LookupSequence("Stab") then
								render.PopCustomClipPlane()
								oldclip = render.EnableClipping( oldclip )
							end
							self:SetCycle(resetAnim)
							self:ManipulateBonePosition(lupper,zero)
							self:ManipulateBonePosition(llower,zero)
							self:ManipulateBonePosition(rupper,zero)
							self:ManipulateBonePosition(rlower,zero)
							self:ManipulateBoneAngles(lupper,Angle(0,0,0))
							self:ManipulateBoneAngles(rupper,Angle(0,0,0))
						end
						arms:Remove()
					end

					

					if (IsValid(self.Image) or IsValid(self.Image1)) and self:GetSequence() == self.BarrageAnimIndex then
						local arms = ClientsideModel(self.OverrideArms or ArmsTable[self:GetModel()])
						for i = 0, 0 do
							
							local resetAnim = self:GetCycle()
							self:SetCycle(self:GetCycle() + math.Rand(0,9999))
							arms:SetSkin(self:GetSkin())
							
							arms:SetPos(self.Pos)
							arms:SetParent(self)
							arms:AddEffects( EF_BONEMERGE || EF_BONEMERGE_FASTCULL || EF_PARENT_ANIMATES)
							local randvec1 = VectorRand() * 10
							local randvec1 = Vector(randvec1.x/4, randvec1.y, randvec1.z)
							local randvec2 = VectorRand() * 10
							local randvec2 =  Vector(randvec2.x/4, randvec2.y, randvec2.z)
							if self:GetSequence() != self:LookupSequence("Stab") then
								self:ManipulateBonePosition(lupper,randvec1)
								self:ManipulateBonePosition(llower,self:GetManipulateBonePosition(lupper)/2)
								self:ManipulateBonePosition(rupper,randvec2)
								self:ManipulateBonePosition(rlower,self:GetManipulateBonePosition(rupper)/2)
								if self.FlameFX1 and self.FlameFX2 and self.FlameFX3 and self.FlameFX4 then
									self.FlameFX1:SetControlPoint(1, VectorRand() * 10)
									self.FlameFX2:SetControlPoint(1, VectorRand() * 10)
									self.FlameFX3:SetControlPoint(1, VectorRand() * 10)
									self.FlameFX4:SetControlPoint(1, VectorRand() * 10)
								end
							end
							render.SetBlend(math.Rand(1,1))
							local angadj = 1
							local angadj2 = 1
							local oldclip = false
							if self:GetSequence() == self:LookupSequence("stab") then
								angadj = 10
								angadj2 = 5
								oldclip = render.EnableClipping( false )
								local normal = self:GetForward()
								local position = normal:Dot( self:GetEyePos(false) )
								render.PushCustomClipPlane( normal, position )
								render.SetBlend(math.Rand(0.2, 0.2))
							end
							
							self:ManipulateBoneAngles(lupper,Angle(math.random(-angadj,angadj), math.random(-angadj,angadj),math.random(-angadj,angadj)))
							self:ManipulateBoneAngles(rupper,Angle(math.random(-angadj2,angadj2), math.random(-angadj2,angadj2),math.random(-angadj2,angadj2)))
							arms:SetBodygroup(2,1)
							
							self:SetupBones()
							arms:SetupBones()
							arms:DrawModel()
							arms:Remove()
							local tr1 = util.TraceLine( {
								start = self:GetBonePosition(rupperh),
								endpos = self:GetBonePosition(rupperh) + self.Owner:GetAimVector() *11110,
								filter = {self.Owner, self.Stand},
							} )
							local tr2 = util.TraceLine( {
								start = self:GetBonePosition(lupperh),
								endpos = self:GetBonePosition(lupperh) + self.Owner:GetAimVector() * 11110,
								filter = {self.Owner, self.Stand},
							} )
							if tr1.HitWorld and math.random(0, 0) == 0 then
								util.Decal("Impact.Concrete", self:GetBonePosition(rupperh), self:GetBonePosition(rupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
								util.Decal("Impact.Sand", self:GetBonePosition(rupperh), self:GetBonePosition(rupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
								util.Decal("FadingScorch", self:GetBonePosition(rupperh), self:GetBonePosition(rupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
							end
							if tr2.HitWorld and math.random(0, 0) == 0 then
								util.Decal("Impact.Concrete", self:GetBonePosition(lupperh), self:GetBonePosition(lupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
								util.Decal("Impact.Sand", self:GetBonePosition(lupperh), self:GetBonePosition(lupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
								util.Decal("FadingScorch", self:GetBonePosition(lupperh), self:GetBonePosition(lupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
							end
							if self:GetSequence() == self:LookupSequence("Stab") then
								render.PopCustomClipPlane()
								oldclip = render.EnableClipping( oldclip )
							end
							self:SetCycle(resetAnim)
							self:ManipulateBonePosition(lupper,zero)
							self:ManipulateBonePosition(llower,zero)
							self:ManipulateBonePosition(rupper,zero)
							self:ManipulateBonePosition(rlower,zero)
							self:ManipulateBoneAngles(lupper,Angle(0,0,0))
							self:ManipulateBoneAngles(rupper,Angle(0,0,0))
						end
						arms:Remove()
					end

					if self.StandId == GSTANDS_CHARIOT and self:GetSequence() == self.BarrageAnimIndex then
						local arms = ClientsideModel(self.OverrideArms or ArmsTable[self:GetModel()])
						for i = 0, 0 do
							
							local resetAnim = self:GetCycle()
							self:SetCycle(self:GetCycle() + math.Rand(0,9999))
							arms:SetSkin(self:GetSkin())
							
							arms:SetPos(self.Pos)
							arms:SetParent(self)
							arms:AddEffects( EF_BONEMERGE || EF_BONEMERGE_FASTCULL || EF_PARENT_ANIMATES)
							local randvec1 = VectorRand() * 10
							local randvec1 = Vector(randvec1.x/4, randvec1.y, randvec1.z)
							local randvec2 = VectorRand() * 10
							local randvec2 =  Vector(randvec2.x/4, randvec2.y, randvec2.z)
							if self:GetSequence() != self:LookupSequence("Stab") then
								self:ManipulateBonePosition(lupper,randvec1)
								self:ManipulateBonePosition(llower,self:GetManipulateBonePosition(lupper)/2)
								self:ManipulateBonePosition(rupper,randvec2)
								self:ManipulateBonePosition(rlower,self:GetManipulateBonePosition(rupper)/2)
								if self.FlameFX1 and self.FlameFX2 and self.FlameFX3 and self.FlameFX4 then
									self.FlameFX1:SetControlPoint(1, VectorRand() * 10)
									self.FlameFX2:SetControlPoint(1, VectorRand() * 10)
									self.FlameFX3:SetControlPoint(1, VectorRand() * 10)
									self.FlameFX4:SetControlPoint(1, VectorRand() * 10)
								end
							end
							render.SetBlend(math.Rand(1,1))
							local angadj = 1
							local angadj2 = 1
							local oldclip = false
							if self:GetSequence() == self:LookupSequence("stab") then
								angadj = 10
								angadj2 = 5
								oldclip = render.EnableClipping( false )
								local normal = self:GetForward()
								local position = normal:Dot( self:GetEyePos(false) )
								render.PushCustomClipPlane( normal, position )
								render.SetBlend(math.Rand(0.2, 0.4))
							end
							
							self:ManipulateBoneAngles(lupper,Angle(math.random(-angadj,angadj), math.random(-angadj,angadj),math.random(-angadj,angadj)))
							self:ManipulateBoneAngles(rupper,Angle(math.random(-angadj2,angadj2), math.random(-angadj2,angadj2),math.random(-angadj2,angadj2)))
							arms:SetBodygroup(2,1)
							
							self:SetupBones()
							arms:SetupBones()
							arms:DrawModel()
							arms:Remove()
							local tr1 = util.TraceLine( {
								start = self:GetBonePosition(rupperh),
								endpos = self:GetBonePosition(rupperh) + self.Owner:GetAimVector() *11110,
								filter = {self.Owner, self.Stand},
							} )
							local tr2 = util.TraceLine( {
								start = self:GetBonePosition(lupperh),
								endpos = self:GetBonePosition(lupperh) + self.Owner:GetAimVector() * 11110,
								filter = {self.Owner, self.Stand},
							} )
							if tr1.HitWorld and math.random(0, 0) == 0 then
								util.Decal("Impact.Concrete", self:GetBonePosition(rupperh), self:GetBonePosition(rupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
								util.Decal("Impact.Sand", self:GetBonePosition(rupperh), self:GetBonePosition(rupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
								util.Decal("FadingScorch", self:GetBonePosition(rupperh), self:GetBonePosition(rupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
							end
							if tr2.HitWorld and math.random(0, 0) == 0 then
								util.Decal("Impact.Concrete", self:GetBonePosition(lupperh), self:GetBonePosition(lupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
								util.Decal("Impact.Sand", self:GetBonePosition(lupperh), self:GetBonePosition(lupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
								util.Decal("FadingScorch", self:GetBonePosition(lupperh), self:GetBonePosition(lupperh) + self.Owner:GetAimVector() * 10, {self, self.Owner})
							end
							if self:GetSequence() == self:LookupSequence("Stab") then
								render.PopCustomClipPlane()
								oldclip = render.EnableClipping( oldclip )
							end
							self:SetCycle(resetAnim)
							self:ManipulateBonePosition(lupper,zero)
							self:ManipulateBonePosition(llower,zero)
							self:ManipulateBonePosition(rupper,zero)
							self:ManipulateBonePosition(rlower,zero)
							self:ManipulateBoneAngles(lupper,Angle(0,0,0))
							self:ManipulateBoneAngles(rupper,Angle(0,0,0))
						end
						arms:Remove()
					end
					if IsValid(self.CenterImage) and self:GetSequence() == self:LookupSequence("block") then
						local arms = ClientsideModel(self.OverrideArms or ArmsTable[self:GetModel()])
						for i = 0, 4 do
							render.SetBlend(1)
							self.ArmFrame = FrameNumber() + (5 - (5 * self.Timescale))
							local resetAnim = self:GetCycle()
							self:SetCycle(self:GetCycle() + math.Rand(0.3,0.8))
							arms:SetSkin(self:GetSkin())
							
							arms:SetPos(self.Pos)
							arms:SetParent(self)
							arms:AddEffects( EF_BONEMERGE || EF_BONEMERGE_FASTCULL || EF_PARENT_ANIMATES)
							
							local angadj = 180
							local oldclip = false
							oldclip = render.EnableClipping( true )
							local normal = self:GetForward()
							local position = normal:Dot( self:WorldSpaceCenter() + normal * 29)
							render.PushCustomClipPlane( normal, position )
							arms:SetBodygroup(2,1)
							self:ManipulateBoneAngles(rupperh,Angle(0,0,math.random(-angadj,angadj)))
							render.SetBlend(math.Rand(0.1, 0.4))

							self:SetupBones()
							arms:SetupBones()
							arms:DrawModel()
							render.SetBlend(1)

							render.PopCustomClipPlane()
							oldclip = render.EnableClipping( oldclip )
							self:SetCycle(resetAnim)
							self:ManipulateBoneAngles(rupperh,Angle(0,0,0))
						end
						arms:Remove()
					end
					if !IsValid(self.CenterImage) and self:GetSequence() == self:LookupSequence("block") then
						local arms = ClientsideModel(self.OverrideArms or ArmsTable[self:GetModel()])
						for i = 0, 4 do
							render.SetBlend(1)
							self.ArmFrame = FrameNumber() + (5 - (5 * self.Timescale))
							local resetAnim = self:GetCycle()
							self:SetCycle(self:GetCycle() + math.Rand(0.3,0.8))
							arms:SetSkin(self:GetSkin())
							
							arms:SetPos(self.Pos)
							arms:SetParent(self)
							arms:AddEffects( EF_BONEMERGE || EF_BONEMERGE_FASTCULL || EF_PARENT_ANIMATES)
							
							local angadj = 180
							local oldclip = false
							oldclip = render.EnableClipping( true )
							local normal = self:GetForward()
							local position = normal:Dot( self:WorldSpaceCenter() + normal * 29)
							render.PushCustomClipPlane( normal, position )
							arms:SetBodygroup(2,1)
							self:ManipulateBoneAngles(rupperh,Angle(0,0,math.random(-angadj,angadj)))
							render.SetBlend(math.Rand(0.1, 0.4))

							self:SetupBones()
							arms:SetupBones()
							arms:DrawModel()
							render.SetBlend(1)

							render.PopCustomClipPlane()
							oldclip = render.EnableClipping( oldclip )
							self:SetCycle(resetAnim)
							self:ManipulateBoneAngles(rupperh,Angle(0,0,0))
						end
						arms:Remove()
					end
					if self:GetSequence() == self:LookupSequence("kBarrage") and self:GetPlaybackRate() >= 1 then
						for i = 0, 4 do
							self.ArmFrame = FrameNumber() + (5 - (5 * self.Timescale))
							
							local resetAnim = self:GetCycle()
							self:SetCycle(self:GetCycle() + math.Rand(0.3,0.8))
							
							local randvec1 = VectorRand() * 1
							local randvec1 = Vector(randvec1.x/4, randvec1.y, randvec1.z)
							local randvec2 = VectorRand() * 1
							local randvec2 =  Vector(randvec2.x/4, randvec2.y, randvec2.z)
							self:ManipulateBonePosition(rupperleg,randvec2)
							self:ManipulateBonePosition(rlowerleg,self:GetManipulateBonePosition(rupperleg)/1)
							local angadj = 10
							local oldclip = true
							angadj = 10
							oldclip = render.EnableClipping( true )
							local normal = self:GetForward()
							local position = normal:Dot( self:WorldSpaceCenter() + self:GetForward() * 7 )
							render.PushCustomClipPlane( normal, position )
							
							self:ManipulateBoneAngles(rupperleg,Angle(math.random(-angadj,angadj), math.random(-angadj,angadj),math.random(-angadj,angadj)))
							
							self:SetupBones()
							render.SetBlend(math.Rand(0.1, 0.5))
							
							self:DrawModel()
							render.PopCustomClipPlane()
							oldclip = render.EnableClipping( oldclip )
							self:SetCycle(resetAnim)
							self:ManipulateBonePosition(rupperleg,zero)
							self:ManipulateBonePosition(rlowerleg,zero)
							self:ManipulateBoneAngles(rupperleg,Angle(0,0,0))
						end
						
					end
				end
				if self.LOD < 2 then
					render.SetBlend(0)
					local mat = 0
					if self:GetSequence() == self:LookupSequence("Barrage") then
						self:SetupBones()
						self:DrawModel()
					end
					
					render.SetBlend(1)
				end
				elseif (self.Aura and self.StandAura) then
				self.Aura:StopEmission()
				self.StandAura:StopEmission()
				self.Aura = nil
				self.StandAura = nil
				
			end
			if GetConVar("gstands_show_hitboxes"):GetBool() then
				for i = 0, self:GetHitBoxCount(0) - 1 do
					local cmins, cmaxs = self:GetHitBoxBounds(i, 0)
					local cpos, cang = self:GetBonePosition(self:GetHitBoxBone(i, 0))
					render.DrawWireframeBox(cpos, cang, cmins, cmaxs, Color(255,0,0,255), true)
				end
				local cmins, cmaxs = self:GetCollisionBounds()
				render.DrawWireframeBox(self.Pos, self:GetAngles(), cmins, cmaxs, Color(0,255,0,255), true)
				
			end
		end
		elseif (self.Aura and self.StandAura) then
		self.Aura:StopEmission()
		self.StandAura:StopEmission()
		self.Aura = nil
		self.StandAura = nil
	end
	if self.StandId == GSTANDS_JST then
		render.SetMaterial(JusticeFogMatNoz)
		render.DrawSprite(self:GetPos(), 1500 * 2, 1500 * 2, Color(70,70,70,150))
	end
	render.SetBlend(1)
end
