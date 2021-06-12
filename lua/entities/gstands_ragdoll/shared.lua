ENT.Type 			= "anim"
ENT.Base            = "base_entity"
ENT.PrintName		= "Player Ragdoll"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 
ENT.PlayerRef   = nil


if SERVER then

AddCSLuaFile("shared.lua")

function ENT:Initialize()
self:SetHealth(self.PlayerRef:Health())
self:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
self.Entity:SetCollisionGroup(COLLISION_GROUP_NONE)
	local phys = self.Entity:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(200)
	end
end
function ENT:OnRemove()
    self.PlayerRef:SetHealth(self:Health())
    self.PlayerRef:Spawn()
    self.PlayerRef:SetPos(self:WorldSpaceCenter())
end
function ENT:Think()
if self:Health() <= 0 then
self.PlayerRef:Kill()
self:Remove()
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