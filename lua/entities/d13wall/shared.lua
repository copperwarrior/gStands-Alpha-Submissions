ENT.Type 		= "anim"
ENT.Base 		= "base_gmodentity"
ENT.Category 	= "other"
ENT.PrintName 	= "Dreamland Dimension Wall"
ENT.Author    	= "Xyz"
ENT.Spawnable 	= false
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.PhysgunDisabled = true
ENT.UnEatable = true

game.AddParticles("particles/d13.pcf")
PrecacheParticleSystem("d13mapfog")
PrecacheParticleSystem("icecream")
PrecacheParticleSystem("d13fire")
PrecacheParticleSystem("d13foghand")
PrecacheParticleSystem("d13beesfollow")
function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"Width")
	self:NetworkVar("Int",1,"Length")
	self:NetworkVar("Int",2,"Height")
	self:NetworkVar("Entity",0,"DreamlandDimension")
end

function ENT:GetWallBounds()
	return Vector(self:GetWidth()/2,self:GetLength()/2,self:GetHeight()/2)
end

function ENT:Think()

end
	