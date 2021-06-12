AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName= "Sand Dome"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "To stand"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
ENT.Animated = true

function ENT:Initialize()    --Initial animation base
    if SERVER then
    self:SetCollisionGroup(COLLISION_GROUP_NONE )
	end
	self:SetModel("models/props_phx/construct/metal_dome360.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetHealth(1500)
	self:SetMaterial("effects/foolsand")
	self.PhysgunDisabled = true
	self:SetMoveType(MOVETYPE_NONE)
	
	hook.Add("EntityTakeDamage", "OwnerTakesNoBlastDamage"..self:EntIndex(), function(targ, dmg)
		if self:IsValid() and self.Own:IsValid() and targ == self.Own then
				local startpos = dmg:GetInflictor():WorldSpaceCenter()
				local tr1 = util.TraceLine( {
					start = startpos,
					endpos = self.Own:WorldSpaceCenter(),
					mask = MASK_ALL,
					filter = {dmg:GetAttacker(), dmg:GetInflictor()}
				} )
				if tr1.Entity != self.Own then
					self:TakeDamageInfo(dmg)
					return true
				end
		end
	end)
end
function ENT:OnRemove()
		hook.Remove("EntityTakeDamage", "OwnerTakesNoBlastDamage"..self:EntIndex())
end
function ENT:OnTakeDamage(dmg)

	if !GetConVar("gstands_stand_hurt_stands"):GetBool() or string.StartWith(dmg:GetInflictor():GetClass(), "gstands_") then
		self:SetHealth(self:Health() - dmg:GetDamage())
	else
		return true
	end
	if dmg:GetDamage() >= self:Health() then
		self:Remove()
	end
end
function ENT:Think()
	self:NextThink(CurTime())
	return true
end