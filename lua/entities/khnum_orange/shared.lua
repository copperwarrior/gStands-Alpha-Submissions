ENT.Type 			= "anim"
ENT.Base 			= "base_entity"
ENT.PrintName		= "Khnum Orange"
ENT.Author			= ""
ENT.Contact			= ""
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
	
	self:SetModel("models/khnum/orange.mdl")

	self:SetTrigger(true)
    self:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
    self:SetPhysicsAttacker(self.Owner)
	local phys = self.Entity:GetPhysicsObject()
    phys:SetMaterial("metal_bouncy")
	self.NextThink = CurTime() +  1

	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(1)
	end
    phys:SetVelocity((self.Owner:GetAimVector() + Vector(0,0,0.2)) * 1425)
    phys:SetDragCoefficient(0)
	self:GetPhysicsObject():SetMass(1)	
	self.CanTool = false
    	self.Entity:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
    self:GetPhysicsObject():SetMaterial("metal_bouncy")
	if not IsValid(self) then return end
	if not IsValid(self.Entity) then return end
	
    if GetConVar("phys_timescale"):GetInt() == 0 then
    
        self.lifetime = 40000
    else
        self.lifetime = self.lifetime or CurTime() + 5
    end
	if CurTime() > self.lifetime or (self:GetParent():IsValid() and self:GetParent():Health() == 0) then
		self:Remove()
	end
end

/*---------------------------------------------------------
   Name: ENT:Disable()
---------------------------------------------------------*/
function ENT:Disable()
    self:Remove()
end

function ENT:PhysicsCollide(data)
	local fxdata = EffectData()
        fxdata:SetOrigin(self:GetPos())
        fxdata:SetScale(3)
        fxdata:SetNormal(data.HitNormal)
        util.Effect("explosion", fxdata, true, true)
    local dmginfo = DamageInfo()
        dmginfo:SetAttacker( self.Owner )
        dmginfo:SetInflictor( self.Owner:GetActiveWeapon() )
        dmginfo:SetReportedPosition(self:WorldSpaceCenter())
        --High damage, but not quite enough to kill.
        dmginfo:SetDamage( 90 )
        util.BlastDamageInfo( dmginfo, self:WorldSpaceCenter(), 250 )
   self:Remove()
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