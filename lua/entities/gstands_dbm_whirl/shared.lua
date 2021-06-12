AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable		            	 = false        
ENT.AdminSpawnable		             = false 

ENT.PrintName		                 =  "Whirlpool"
ENT.Author			                 =  "Hmm"
ENT.Contact		                     =  "Hmm"
ENT.Category                         =  "Hmm"

ENT.Mass                             =  100
ENT.Model                            =  "models/props_junk/PopCan01a.mdl"                      
game.AddParticles("particles/whirl.pcf")
PrecacheParticleSystem("whirl")
function ENT:Initialize()	
	
	
	if (SERVER) then
		
		self:SetModel(self.Model)
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE  )
		self:SetUseType( ONOFF_USE )
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		local phys = self:GetPhysicsObject()
		

		if (phys:IsValid()) then
			phys:SetMass(self.Mass)
		end 		
		
		self:SetNoDraw(true)
		ParticleEffect("whirl", self:GetPos(), Angle(0,0,0), self)
		
	end
end


function ENT:Vortex()

	local entities = FindInCylinder(self:GetPos(), 340, 2,  -200, true)
	local selfpos_norm = Vector(self:GetPos().x, self:GetPos().y, 0)
	
	for k, v in pairs(entities) do
		if v:GetPhysicsObject():IsValid() then
		
			local pos      = v:GetPos()
			local vpos_norm = Vector(pos.x, pos.y, 0)
			
			local twoDDistance = selfpos_norm:Distance(vpos_norm)
			local height_diff  = math.abs( self:GetPos().z - pos.z )
			
			local phys         = v:GetPhysicsObject()
			local dir          = (v:GetPos() - self:GetPos()):GetNormalized() * -1
			local dir2_tangent = self:GetPos():Cross(v:GetPos()):GetNormalized()
			
			local vert_force   = (math.Clamp(340 / twoDDistance^2,0,1) * 70) * Vector(0,0,-1)
			local horiz_force  = (math.Clamp(340 / twoDDistance^1.5,0,1) * 66) * dir2_tangent
			
			if v:IsPlayer() or v:IsNPC() then
				v:SetVelocity( dir * 60 + (vert_force*6) + (horiz_force*0.2))

			else
				phys:AddVelocity( dir * 20 + vert_force + horiz_force)

			end
		
		
		
		end
		
		
		
	
	end
	
	--PrintTable(entities)

end

function ENT:Think()

	if (SERVER) then
		if !self:IsValid() then return end
		self:Vortex()
		self:NextThink(CurTime() + 0.1)
		return true
	end
end


function ENT:Draw()
	self:DrawModel()
end



