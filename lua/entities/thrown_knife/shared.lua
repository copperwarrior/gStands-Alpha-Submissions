ENT.Type 			= "anim"
ENT.PrintName		= "Knife"
ENT.Author			= "Worshipper, well, sort of. most of it is his anyway"
ENT.Contact			= "Josephcadieux@hotmail.com"
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 


if SERVER then

AddCSLuaFile("shared.lua")

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()
	self:SetHealth(5)
	self:SetModel("models/player/dio/knifejf.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	local phys = self.Entity:GetPhysicsObject()
	self.NextThink = CurTime() +  1

	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(10)
	end

	util.PrecacheSound("physics/metal/metal_grenade_impact_hard3.wav")
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard2.wav")
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet2.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet3.wav")

	self.Hit = { 
	Sound("physics/metal/metal_grenade_impact_hard1.wav"),
	Sound("physics/metal/metal_grenade_impact_hard2.wav"),
	Sound("physics/metal/metal_grenade_impact_hard3.wav")};

	self.FleshHit = { 
	Sound("physics/flesh/flesh_impact_bullet1.wav"),
	Sound("physics/flesh/flesh_impact_bullet2.wav"),
	Sound("physics/flesh/flesh_impact_bullet3.wav")}

	self:GetPhysicsObject():SetMass(2)	

	self.CanTool = false
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
	
	if not IsValid(self) then return end
	if not IsValid(self.Entity) then return end
	if GetConVar("phys_timescale"):GetInt() == 0 or (self:GetPhysicsObject():IsValid() and !self:GetPhysicsObject():IsMotionEnabled()) then
	
		self.lifetime = 40000
	else
		self.lifetime = self.lifetime or CurTime() + 5
	end
	if CurTime() > self.lifetime or (self:GetParent():IsValid() and (self:GetParent():Health() <= 0 or self:GetParent():GetClass() == "thrown_knife" )) then
		self:Remove()
	end
	if self.MarkToDisable then
		self:SetAngles(self.DisableData.HitNormal:Angle() + Angle(0, 0, 0))
		self:SetPos(self.DisableData.HitPos - self.DisableData.HitNormal)
		local tr = util.TraceLine( {
			start = self.DisableData.HitPos,
			endpos = self.DisableData.HitPos - self.DisableData.HitNormal,
			filter = function(ent) if ent == self or ent:GetClass() == "thrown_knife" then return false end return true end,
			mask = MASK_ALL,
		} )

		self:Disable()
		if !(self.DisableData.HitEntity:IsWorld() ) then
			self:SetParent(self.DisableData.HitEntity)
		end
	end
	self:NextThink(CurTime())
	return true
end

/*---------------------------------------------------------
   Name: ENT:Disable()
---------------------------------------------------------*/
function ENT:Disable()
	self:PhysicsDestroy()
	self.lifetime = CurTime() + 5
	self:SetSolid(SOLID_NONE)
	self.MarkToDisable = false
end
function ENT:OnTakeDamage(dmg)
	if IsValid(self:GetPhysicsObject()) then
		self:GetPhysicsObject():SetVelocity(dmg:GetDamageForce() * self:GetVelocity():Length()/2)
		self:GetPhysicsObject():SetAngles(dmg:GetDamageForce():Angle())
	end
end
/*---------------------------------------------------------
   Name: ENT:PhysicsCollided()
---------------------------------------------------------*/
function ENT:SetDMGMult(x)
		self.DMG = x
end
function ENT:PhysicsCollide(data, phys)
	
	local damager
	if  IsValid(self.Owner) then
		damager = self.Owner
		else
		damager = self.Entity
		return
	end
	
	local Ent = data.HitEntity
	if !(Ent:IsValid() or Ent:IsWorld()) then return end
	if Ent:GetClass() == "thrown_knife" then return end
	
	if Ent:IsWorld() then
			util.Decal("ManhackCut", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
			self:EmitSound(Sound("weapons/blades/impact.mp3"))
			self.MarkToDisable = true
			self.DisableData = data

	else
		if !(Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") and Ent:GetClass() != "thrown_knife" then 
			util.Decal("ManhackCut", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
			self:EmitSound(Sound("weapons/blades/impact.mp3"))
			self.MarkToDisable = true
			self.DisableData = data
			self:SetParent(Ent)
		end

		if (Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") then 
			local effectdata = EffectData()
			effectdata:SetStart(data.HitPos)
			effectdata:SetOrigin(data.HitPos)
			effectdata:SetScale(1)
			util.Effect("BloodImpact", effectdata)

			self:EmitSound(self.FleshHit[math.random(1,#self.Hit)])
			self.MarkToDisable = true
			self.DisableData = data
			
			Ent:TakeDamage((GetConVar("gstands_the_world_knife_damage"):GetInt()) , damager, self.Entity)
		end
		
	end

end

end

if CLIENT then
/*---------------------------------------------------------
   Name: ENT:Draw()
---------------------------------------------------------*/
function ENT:Draw()
	self.Entity:DrawModel()
end
end