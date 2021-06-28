ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Hermit Purple Whip"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 
ENT.AutomaticFrameAdvance = true
ENT.Animated = true


AddCSLuaFile("shared.lua")
local Whip = Sound("hrp.whip")
local Trail = Sound("weapons/hermit/trail-hamon.wav")
local Crackle = Sound("weapons/hermit/crackle-small-01.wav")

function ENT:Initialize()
		self.wep = self.Owner:GetActiveWeapon()
		if SERVER then
			self:SetModel("models/hpworld/hprope.mdl")
			self:ResetSequence(1)
			self:SetCycle(0)
			self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
			self:DrawShadow(false)
			self:SetModelScale(0.4)
			timer.Simple(self:SequenceDuration()+ 0.1, function() if IsValid(self) then self:Remove() end end)
			local ang = self:GetAngles()
			ang:RotateAroundAxis(self.Owner:GetAimVector(), 180)
			self:SetAngles(ang)
		end
		self.Rands = {
			VectorRand() * 5,
			VectorRand() * 5,
			VectorRand() * 5,
			VectorRand() * 5
		}
		self.RandAngs = {
			AngleRand(),
			AngleRand(),
			AngleRand(),
			AngleRand()
		}
		self:Think()
end

function ENT:Think()
if not SERVER then return end
if not IsValid(self) then return end
	if not IsValid(self.Entity) then return end
	local lastpos = self:GetPos()
	if !self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") or self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") == -1 then return end
	local StartPos = self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))

	self:SetPos(StartPos)
	self.Owner:LagCompensation(true)
	for i = 0, self:GetBoneCount(0) - 1 do
		local cpos, cang = self:GetBonePosition(i, 0)
		local tpos = self:WorldToLocal(cpos)
		tpos = tpos * 0.4
		cpos = self:LocalToWorld(tpos)
		local tr2 = util.TraceHull( {
			start = lastpos,
			endpos = cpos,
			filter = {self.Owner, self, self.wep},
			mask = MASK_SHOT_HULL,
			mins = Vector(-5,-5,-5),
			maxs = Vector(5,5,5),
		} )
		lastpos = cpos
		local tr1 = util.TraceLine( {
			start = self.Owner:WorldSpaceCenter(),
			endpos = tr2.HitPos,
			filter = {self.Owner, self, self.wep},
			mask = MASK_SHOT_HULL,
			mins = Vector(-5,-5,-5),
			maxs = Vector(5,5,5),
		} )
		if SERVER and tr2.Entity:IsValid() and !tr1.HitWorld then
			tr2.Entity:EmitSound( GetStandImpactSfx(tr2.MatType) )
			tr2.Entity:EmitStandSound( Whip )
			local dmginfo = DamageInfo()
			local attacker = self.Owner
			dmginfo:SetAttacker( attacker )
			local mult = 1
			if self.wep:GetHamon() then
				tr2.Entity:EmitSound(Trail)
				tr2.Entity:EmitSound(Crackle)
				dmginfo:SetDamageType(DMG_SHOCK)
				mult = 3
			end
			dmginfo:SetInflictor( self.wep )
			dmginfo:SetDamage((GetConVar("gstands_hermit_purple_slash"):GetInt()) * mult )
			
			tr2.Entity:TakeDamageInfo( dmginfo )
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
			local oldpos = self:GetPos()
			local oldang = self:GetAngles()
			for i = 0, 3 do
			self:SetPos(self:GetPos() + self.Rands[i+1])
			self:SetAngles(self:GetAngles() + self.RandAngs[i+1]/45)
			self:SetupBones()
			self:DrawModel()
			local cyc = self:GetCycle()
			self:SetCycle(self:GetCycle() - 0.1)
			self:SetupBones()
			render.SetBlend(0.5)
			self:DrawModel()
			self:SetCycle(cyc)
			render.SetBlend(1)
			self:SetPos(oldpos)
			self:SetAngles(oldang)
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