ENT.Type 			= "anim"
ENT.Base 			= "base_entity"
ENT.PrintName		= "Firebomb"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Spawnable		= false
ENT.AdminOnly 		= true 
ENT.DrawShadow	  	= false

local HitSound = Sound( "physics/flesh/flesh_impact_bullet"..math.random(1,5)..".wav" )
local Kurei = Sound("weapons/mgr/kurei.wav")
local Explosive = Sound("mgr.explosive")


if SERVER then

AddCSLuaFile("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	local phys = self.Entity:GetPhysicsObject()
	self.NextThink = CurTime()
	self.OwnerWep = self.Owner:GetActiveWeapon()
	local tr = util.TraceHull( { 
			start = self:GetPos(),
			endpos = self:GetPos(),
			mins = Vector(-5,-5,-5),
			maxs = Vector(5,5,5),
			filter = {self, self.Owner, self.OwnerWep:GetStand()},
			mask = MASK_SHOT_HULL
			} )
	if IsValid(tr.Entity) then
		self:SetParent(tr.Entity)
	end
	self.CanTool = false
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
	if not IsValid(self) then return end
	if not IsValid(self.Entity) then return end
	if not IsValid(self.OwnerWep.Stand) then self:Disable() return end
	
	if !self.OwnerWep:GetAMode() and self.Owner:gStandsKeyDown("modifierkey1") and self.Owner:KeyDown(IN_ATTACK2) then
		self:Detonate()
	end
	if IsValid(self:GetParent()) and self:GetParent():GetPos():Distance(self.Owner:GetPos()) >= 500 then
		self:SetParent()
	end
	if self.Owner:GetPos():Distance(self:GetPos()) >= 500 then
		self:SetPos(LerpVector(0.01, self:GetPos(), self.Owner:WorldSpaceCenter()))
	end
	self:NextThink(CurTime())
	return true
end

function ENT:Disable()
	self:Remove()
end

function ENT:Detonate()
		self.Owner:EmitSound(Kurei)
		self:EmitStandSound(Explosive)
		self:EmitStandSound("ambient/fire/ignite.wav")
		if IsValid(self.Owner:GetWeapon("gstands_magicians_red")) then
			self.Owner:GetWeapon("gstands_magicians_red"):SetBombs(self.Owner:GetWeapon("gstands_magicians_red"):GetBombs() - 1)
		end
		self:Disable()
		local dmg = DamageInfo()
		local attacker = self.Owner
		dmg:SetAttacker( attacker )
		dmg:SetInflictor( self.OwnerWep )
		dmg:SetDamageType(DMG_BURN)
		ParticleEffect("flameexplode", self:GetPos(), self:GetAngles())
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 155)) do
			if v.Health and v:Health() > 0 and v != self.Owner and v != self.Owner:GetActiveWeapon():GetStand() then
				local mult = (self:GetPos():Distance(v:GetPos())/155)
				dmg:SetDamage( 50/mult )
				v:TakeDamageInfo( dmg )
				v:Ignite(5/mult)
			end
		end
	end
end
