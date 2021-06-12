AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName= "Death Ragdoll Use Box"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "To stand"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
ENT.Animated = true

function ENT:Initialize()
    if SERVER then
		self:SetUseType(SIMPLE_USE)
		self:SetSolid(SOLID_OBB)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS )
		self:DrawShadow(false)
	end
	self:SetModel("models/props_c17/FurnitureFridge001a.mdl")
end
function ENT:Think()
   return true
end
function ENT:Use()
		self.Owner:SetNotSolid(false)
		self.Owner:SetNoDraw(false) 
		self.Owner:SendToCorpse(self.Entity)
		self.Entity:Remove() 
	
end
function ENT:Draw()
	return
end