ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Bees"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Target")
end
AddCSLuaFile("shared.lua")

function ENT:Initialize()
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self.StartTime = CurTime()
	self.wep = self.Owner:GetActiveWeapon()
	if CLIENT then
		self:SetRenderBounds(self:GetTarget():GetRenderBounds())
	end
	self:GetTarget().Beed = true
	self:NextThink(CurTime())
	self:GetTarget():EmitStandSound("ambient/creatures/flies"..math.random(1,5)..".wav", 75, 65)
	self.Lifetime = CurTime() + 3
	self:Think()
end
/*---------------------------------------------------------
Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
		self:GetTarget():EmitStandSound("ambient/creatures/flies"..math.random(1,5)..".wav", 75, 65)

	self.Lifetime = self.Lifetime or CurTime()
	if SERVER and CurTime() > self.Lifetime then self:Disable() end
	if SERVER and IsValid(self:GetTarget()) then
		local targ = self:GetTarget()
		
		if (IsValid(self:GetTarget()) and self:GetTarget():Health() < 1) or (IsValid(self.Owner) and self.Owner:Health() < 1) then
			self:Remove()
		end
		
		self.DelayDmg = self.DelayDmg or CurTime()
		if targ:Health() and SERVER then
			local dmg = DamageInfo()
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self.wep)
			dmg:SetDamage(25)
			dmg:SetDamageType(DMG_SLASH)
			self:GetTarget():TakeDamageInfo(dmg)
		end
		
	end
	if SERVER then
		self:NextThink(CurTime() + 0.3)
	end
	return true
end


function ENT:Disable()
	self:Remove()
end
function ENT:OnRemove()
	self:GetTarget().Beed = false
	if CLIENT and self.Aura then
		self.Aura:StopEmission()
	end
end
if CLIENT then
	function ENT:Draw()
		self.Aura = self.Aura or CreateParticleSystem(self:GetTarget(), "d13beesfollow", PATTACH_POINT_FOLLOW, 1)
	end
end		