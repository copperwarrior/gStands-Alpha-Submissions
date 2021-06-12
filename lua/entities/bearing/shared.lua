ENT.Type 			= "anim"
ENT.PrintName		= "Bearing"
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
	self:SetModel("models/starp/bearing.mdl")
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
	local color = Color(50,50,50)
	if IsValid(self.Owner) and IsValid(self.Owner:GetActiveWeapon()) and IsValid(self.Owner:GetActiveWeapon():GetStand()) then
		local colorv = gStands.GetStandColor(self.Owner:GetActiveWeapon():GetStand():GetModel(), self.Owner:GetActiveWeapon():GetStand():GetSkin())
		color = Color(colorv.x * 255, colorv.y * 255, colorv.z * 255)
	end
	self:GetPhysicsObject():SetMass(2)	
	util.SpriteTrail(self, 0, color, true, 5,0, 0.1, 1/(5) * 0.5, "effects/beam_generic01.vmt" )

	self.CanTool = false
		self.lifetime = self.lifetime or CurTime() + 1

end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
	self.lifetime = self.lifetime or CurTime() + 1
	if not IsValid(self) then return end
	if not IsValid(self.Entity) then return end
	self.LastTimeScale = self.LastTimeScale or GetConVar("gstands_time_stop"):GetBool() 
	if self.LastTimeScale != GetConVar("gstands_time_stop"):GetBool() then
		if GetConVar("gstands_time_stop"):GetBool() then
			self.lifetime = CurTime() + 1
		else
			self.lifetime = CurTime() + 1
		end
	end
	if CurTime() > self.lifetime then
		self:Remove()
	end
	self.LastTimeScale = GetConVar("gstands_time_stop"):GetBool() 
	self:NextThink(CurTime())
	return true
end

/*---------------------------------------------------------
   Name: ENT:PhysicsCollided()
---------------------------------------------------------*/
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
	local mult = (self.lifetime or CurTime()) - CurTime()
		
		if (Ent:IsPlayer() or Ent:IsNPC() or Ent.Health) then 
			Ent:TakeDamage(55 * mult, damager, self.Entity)
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