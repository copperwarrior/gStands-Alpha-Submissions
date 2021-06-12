ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Red Bind"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 
ENT.AutomaticFrameAdvance = true
ENT.Animated = true


AddCSLuaFile("shared.lua")
local HitSound = Sound( "platinum.hit" )
local Whip = Sound( "mgr.whip" )

function ENT:Initialize()
		self.wep = self.Owner:GetActiveWeapon()
		if SERVER then
		self:SetModel("models/mgr/redbind.mdl")
		self:ResetSequence(1)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		self:DrawShadow(false)
		self:SetCycle( 0 )
		timer.Simple(self:SequenceDuration() - 0.3, function() if IsValid(self) then self:Remove() end end)
		end
		self.Color = gStands.GetStandColor(self.wep:GetStand():GetModel(), self.wep:GetStand():GetSkin())
end

function ENT:Think()
	if not IsValid(self) then return end
	if not IsValid(self.Entity) then return end
	local lastpos = self:GetPos()
	local tr1 = util.TraceLine( {
			start = self.wep:GetStand():GetEyePos(true),
			endpos = self.wep:GetStand():GetEyePos(true) + self.Owner:GetAimVector() * 250,
			filter = {self.Owner, self, self.wep:GetStand()},
		} )
	if (tr1.Hit and tr1.HitNormal:Dot(Vector(0,0,1)) <= 0.6) then
		local tr2 = util.TraceLine( {
			start = (tr1.HitPos + tr1.Normal * 55) + Vector(0,0,150),
			endpos = (tr1.HitPos + tr1.Normal * 55) - Vector(0,0,550),
			filter = {self.Owner, self, self.wep, self.wep:GetStand()},
		} )
		if !tr2.StartSolid and tr2.HitNormal:Dot(Vector(0,1,0)) <= 0.6 then
			if SERVER and !self.Hit then
				self.Hit = true
				self:EmitStandSound(Whip)
			end
		self.Owner:SetVelocity(((tr2.HitPos + Vector(0,0,150)) - self.Owner:GetPos())/5)
		end
	end
	self.Owner:LagCompensation(true)
	for i = 0, self:GetHitBoxCount(0) - 1 do
		local cmins, cmaxs = self:GetHitBoxBounds(i, 0)
		local cpos, cang = self:GetBonePosition(self:GetHitBoxBone(i, 0))
		local tr2 = util.TraceHull( {
			start = lastpos,
			endpos = cpos,
			filter = {self.Owner, self, self.wep, self.wep:GetStand()},
			mask = MASK_SHOT_HULL,
			mins = Vector(-5,-5,-5),
			maxs = Vector(5,5,5),
		} )
		lastpos = cpos
		if SERVER and tr2.Entity:IsValid() and tr2.Entity:IsPlayer() and tr2.Entity:GetMoveType() != MOVETYPE_NONE then
			tr2.Entity:EmitStandSound("ambient/fire/ignite.wav")
			tr2.Entity:EmitSound( HitSound )
			tr2.Entity:EmitSound( Whip )
			tr2.Entity:SetPos(tr2.Entity:GetPos())
			self.wep.Target = tr2.Entity
			self.wep.TargetPos = tr2.Entity:GetPos()
			self.wep.RedBindtimer = CurTime() + 5
		end
		if SERVER and tr2.Entity:IsValid() and tr2.Entity:GetClass() == "stand" and tr2.Entity:GetMoveType() != MOVETYPE_NONE then
			tr2.Entity.Owner:EmitStandSound("ambient/fire/ignite.wav")
			tr2.Entity:EmitSound( HitSound )
			tr2.Entity:EmitSound( Whip )
			tr2.Entity.Owner:SetMoveType( MOVETYPE_NONE )
			self.wep.Target = tr2.Entity
			self.wep.TargetPos = tr2.Entity:GetPos()
			self.wep.LastMoveType = tr2.Entity:GetMoveType()
			self.wep.RedBindtimer = CurTime() + 5
		end
	end
	self.Owner:LagCompensation(false)
	self:NextThink(CurTime())
	return true
end
	
if CLIENT then
	/*---------------------------------------------------------
	Name: ENT:Draw()
	---------------------------------------------------------*/
	function ENT:Draw()
		if IsPlayerStandUser(LocalPlayer()) then
			self.StandAura = self.StandAura or CreateParticleSystem(self, "mgr_redbind", PATTACH_POINT_FOLLOW, 1)
			if self.StandAura then
				self.StandAura:Restart()
				if IsValid(self.wep:GetStand()) then
					local cpos, cang = self.wep:GetStand():GetBonePosition(self.wep:GetStand():LookupBone("ValveBiped.Bip01_R_Hand"))
					self.StandAura:SetControlPoint(0, cpos)
					self.StandAura:SetControlPoint(1, self.Color)
					self.StandAura:Render()
				end
			end
		end
		if GetConVar("gstands_show_hitboxes"):GetBool() then
			for i = 0, self:GetHitBoxCount(0) - 1 do
				local cmins, cmaxs = self:GetHitBoxBounds(i, 0)
				local cpos, cang = self:GetBonePosition(self:GetHitBoxBone(i, 0))
				render.DrawWireframeBox(cpos, cang, cmins, cmaxs, Color(255,0,0,255), true)
			end
			
		end
	end
end		