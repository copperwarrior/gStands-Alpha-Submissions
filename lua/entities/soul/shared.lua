AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName= "Soul"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "To stand"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true
ENT.Animated = true

function ENT:Initialize()    --Initial animation base
    if SERVER then
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS )
	end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetRenderMode(RENDERMODE_WORLDGLOW)
	self:SetGravity(0)
	self:GetPhysicsObject():EnableGravity(false)
	self:GetPhysicsObject():EnableCollisions(false)
	--self:GetPhysicsObject():AddVelocity(Vector(0,0,50))
	if !self.OwningOsiris then self.OwningOsiris = self end
	if SERVER then
	timer.Simple(2, function() self:Remove() end)
	self:SetModelScale(0.1, 2)
	end
	end
function ENT:OnRemove()
end

function ENT:Think()
	if !IsValid(self.OwningOsiris) then return end
	local interhand = LerpVector(0.5, 
	self.OwningOsiris:GetBonePosition(self.OwningOsiris:LookupBone("ValveBiped.Bip01_R_Hand")),
	self.OwningOsiris:GetBonePosition(self.OwningOsiris:LookupBone("ValveBiped.Bip01_L_Hand")))
	if SERVER then
	self:SetPos(LerpVector(0.05, self:GetPos(), interhand))
	end
	self:NextThink(CurTime())
	return true
end