ENT.Type 				= "anim"
ENT.Base 				= "base_entity"
ENT.PrintName			= "Crossfire Hurricane"
ENT.Author				= "Copper"
ENT.Contact				= ""
ENT.Purpose				= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly		 	= true 
ENT.DrawShadow	  	= false

local HitSound = Sound( "physics/flesh/flesh_impact_bullet"..math.random(1,5)..".wav" )
local Explosive = Sound("mgr.explosive")
local Crack = Sound("mgr.crack")

if SERVER then
	
	AddCSLuaFile("shared.lua")
	
	function ENT:Initialize()
		self:EmitSound("ambient/fire/mtov_flame2.wav", 75, 100)
		self:DrawShadow(false)
		self:SetModel("models/mgr/ankh_collision.mdl")
		self:PhysicsInitSphere(15, "metal")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		local phys = self.Entity:GetPhysicsObject()
		self.NextThink = CurTime()
		
		if (phys:IsValid()) then
			phys:Wake()
			phys:SetMass(10)
		end
		self:GetPhysicsObject():SetMass(2)	
		self:GetPhysicsObject():EnableGravity(false)	
		
		self.CanTool = false
		self:GetPhysicsObject():SetVelocity(self:GetForward() * 300)
		self:SetTrigger(true)
		local fxdata = EffectData()
		fxdata:SetOrigin(self.Owner:GetPos())
		fxdata:SetStart(self:GetPos())
		fxdata:SetEntity(self)
		fxdata:SetRadius(1)
		fxdata:SetScale(5000)
		fxdata:SetMagnitude(10)
		fxdata:SetAttachment(-1)
		util.Effect("gstands_cfhurricane", fxdata, true, true)
		self.FlameLoop = CreateSound(self, "ambient/fire/firebig.wav")
		self.FlameLoop:Play()
		self.Owner:StopParticles()
	end
	
	/*---------------------------------------------------------
	Name: ENT:Think()
	---------------------------------------------------------*/
	function ENT:Think()
		if not IsValid(self) then return end
		if not IsValid(self.Entity) then return end
		if GetConVar("phys_timescale"):GetInt() == 0 then
			
			self.lifetime = 40000
			else
			self.lifetime = self.lifetime or CurTime() + 5
		end
		if CurTime() > self.lifetime then
			self:Remove()
		end
		self.OwnerWep = self.Owner:GetActiveWeapon()
		self:SetAngles(LerpAngle(0.1, self:GetAngles(), self.Owner:EyeAngles()))
		self:GetPhysicsObject():SetVelocity(self:GetForward() * 750 )
		
		self:NextThink(CurTime())
		return true
	end
	
	function ENT:Disable()
		self:Remove()
	end
	
	function ENT:PhysicsCollide(colDat, obj)
		
		local object = colDat.HitEntity
		if object.Health and object:GetClass() != "physical_bullet" then
			self:Disable()
			local dmg = DamageInfo()
			local attacker = self.Owner
			dmg:SetAttacker( attacker )
			dmg:SetInflictor( self )
			dmg:SetDamageType(DMG_BURN)
			self:EmitStandSound(Explosive)
			ParticleEffect("flameexplode", colDat.HitPos, colDat.HitNormal:Angle())
			for k,v in pairs(ents.FindInSphere(colDat.HitPos, 155)) do
				if v != self.Owner and v != self.Owner:GetActiveWeapon():GetStand() then
					dmg:SetDamage( 100/(self:GetPos():Distance(v:GetPos())/155))
					v:TakeDamageInfo( dmg )
					v:EmitStandSound(Crack)
				end
			end
		end
	end
	function ENT:OnRemove()
		self.FlameLoop:Stop()
		return true
	end
	function ENT:Touch(Ent)
		local damager
		if  IsValid(self.Owner) then
			damager = self.Owner
			else
			damager = self.Entity
		end
		
		if !(Ent:IsValid() or Ent:IsWorld()) then return end
		if Ent.Health and Ent:GetClass() != "physical_bullet" then
			if not(Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") and Ent != self.Owner then 
				dmgInfo = DamageInfo()
				dmgInfo:SetAttacker(damager)
				dmgInfo:SetDamage(45)
				dmgInfo:SetInflictor( self )
				Ent:TakeDamageInfo(dmgInfo)
			end
			
			if (Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") and Ent != self.Owner then 
				dmgInfo = DamageInfo()
				dmgInfo:SetAttacker(damager)
				dmgInfo:SetDamage(45)
				dmgInfo:SetDamageType(DMG_BURN)
				dmgInfo:SetInflictor( self )
				Ent:TakeDamageInfo(dmgInfo)
				Ent:Ignite(15)
				self:EmitSound("physics/flesh/flesh_impact_bullet"..math.random(1,5)..".wav")
				self:EmitStandSound(Explosive)
			end
			
		end
		
		
	end
end


if CLIENT then
	/*---------------------------------------------------------
	Name: ENT:Draw()
	---------------------------------------------------------*/
	function ENT:Draw()
	end
end