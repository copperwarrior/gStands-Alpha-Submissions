ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "The Fool Sand Wave"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 
ENT.AutomaticFrameAdvance = true
ENT.Animated = true


AddCSLuaFile("shared.lua")

local Loop = Sound("weapons/fool/flyloop.wav")

function ENT:Initialize()
		self.wep = self.Owner:GetActiveWeapon()
		self:SetSolid(SOLID_OBB)
		if SERVER then
			self:SetModel("models/gstands/stand_acc/foolsand_effect.mdl")
			self:ResetSequence(1)
			self:SetCycle(0)
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			self:SetTrigger(true)
			self:DrawShadow(false)
			self:SetPlaybackRate(0.75)
			timer.Simple((self:SequenceDuration() * 1.5)+ 0.1, function() if IsValid(self) then self:Remove() end end)
		end
		self:SetModelScale(2)
		self:SetSkin(self.wep:GetStand():GetSkin())
		local info = self:GetSequenceInfo(1)
		self.mins = info.bbmin
		self.maxs = info.bbmax
		self:UseTriggerBounds(self.mins, self.maxs)
		self:Think()
		self.snd = self:StartLoopingSound(Loop)
end

function ENT:Think()
	if not IsValid(self) then return end
	if not IsValid(self.Entity) then return end
	if not SERVER then return end
	local lastpos = self:GetPos()
	local tr = util.TraceLine({
		start = self:GetPos() + self:GetForward() * 15 + Vector(0,0,55),
		endpos = self:GetPos() + self:GetForward() * 15 - Vector(0,0,55),
		collisiongroup = COLLISION_GROUP_DEBRIS,
		mask=MASK_SOLID_BRUSHONLY
	})
	if tr.HitWorld then
		self:SetPos(tr.HitPos)
		else
		self:Remove()
		return
	end
	local ang = self.Owner:EyeAngles()
	ang.p = 0--tr.HitNormal:Angle().p
	self:SetAngles(ang)
	self.Owner:LagCompensation(true)

	self.Owner:LagCompensation(false)
	self:NextThink(CurTime())
	local mins, maxs = self:GetRotatedAABB(self.mins, self.maxs)
	for k,v in pairs(ents.FindInBox(self:LocalToWorld(mins), self:LocalToWorld(maxs))) do
		if IsValid(v:GetPhysicsObject()) then
			v:GetPhysicsObject():Wake()
		end
	end
	return true
end

local SandTable = {
	["models/gstands/stands/thefool.mdl0"] = Vector(0.9, 0.9, 0.5),
	["models/gstands/stands/thefool.mdl1"] = Vector(0.5, 0.5, 1),
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

function ENT:Touch(ent)
	if ent == self.Owner then return end
	if (ent:IsPlayer() or ent:IsNPC()) and ent ~= self.Owner then
		ent:SetVelocity(self:GetForward() * 135)
		if ent:IsNPC() then
			ent:SetPos(ent:GetPos() + self:GetForward() * 15)
		end
		if self:GetCycle() > 0.7 then
			local dmginfo = DamageInfo()
			local attacker = self.Owner
			dmginfo:SetAttacker( attacker )
			dmginfo:SetDamageType(DMG_CRUSH)
			
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage(GetConVar("gstands_the_fool_sand_wave"):GetInt())
			ent:TakeDamageInfo( dmginfo )
		end
	end
	if IsValid(ent:GetPhysicsObject()) and (ent:GetPhysicsObject():IsMotionEnabled()) then
		ent:GetPhysicsObject():Wake()
		ent:GetPhysicsObject():ApplyForceOffset(self:GetForward() * 1555, self:GetPos())
		if self:GetCycle() > 0.7 then
			local dmginfo = DamageInfo()
			local attacker = self.Owner
			dmginfo:SetAttacker( attacker )
			dmginfo:SetDamageType(DMG_CRUSH)
			
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage(GetConVar("gstands_the_fool_sand_wave"):GetInt())
			ent:TakeDamageInfo( dmginfo )
		end
	end
end
	
	
function ENT:OnRemove()
	self:StopLoopingSound(self.snd)
end
if CLIENT then
	/*---------------------------------------------------------
	Name: ENT:Draw()
	---------------------------------------------------------*/
	function ENT:Draw()
	
		if IsPlayerStandUser(LocalPlayer()) then
			self:SetupBones()
			self.StandAura = self.StandAura or CreateParticleSystem(self, "sand_wave", PATTACH_POINT, 1)
			if self.StandAura then
				self.StandAura:SetControlPoint(1, self:GetSandColor("models/gstands/stands/thefool.mdl", self:GetSkin()))
				self.StandAura:SetControlPoint(0, self:GetPos())
			end
			
		if self.StandAura then
			self:SetupBones()
		end
			local oldpos = self:GetPos()
			local oldang = self:GetAngles()
			self:DrawModel()
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