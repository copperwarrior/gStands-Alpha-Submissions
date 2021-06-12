function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	self.Normal = data:GetNormal()
    self.Sparks = data:GetFlags()
    self.Mag = data:GetMagnitude() or 1
    local owner = data:GetEntity()

	local emitter = ParticleEmitter( self.Position, true )
    local particle1 = emitter:Add( "particle/particle_ring_wave_additive.vmt", self.Position)
    local particle4 = emitter:Add( "pp/dof", self.Position)
    if owner:IsValid() and !owner:GetNoDraw() then 
    if self.Sparks == 2 then
        for i=1, 3 do
            local particle5 = emitter:Add( "engine/lightsprite", self.Position)
            particle5:SetDieTime(math.Rand(0.15, 0.25))
            particle5:SetVelocity((self.Normal + (VectorRand() * 0.85)):GetNormalized() * (math.Rand(150, 500)))
            particle5:SetAirResistance(150)
            particle5:SetStartSize(1)
            particle5:SetEndSize(0)
            particle5:SetStartLength(50)
            particle5:SetEndLength(5)
            particle5:SetStartAlpha(255)
            particle5:SetEndAlpha(0)
            particle5:SetColor(255, 220, 200)

        end
    end
    particle1:SetPos(self.Position + (self.Normal * 5))
    particle1:SetDieTime(0.2)
    particle1:SetStartAlpha(255)
    particle1:SetEndAlpha(0)
    particle1:SetEndSize(15 * self.Mag)
    particle1:SetStartSize(0)
    particle1:SetAngles(self.Normal:Angle() or self.Owner:GetAimVector())
    particle1:SetVelocity(self.Normal * 5)
    
    particle4:SetPos(self.Position + (self.Normal * 5))
    particle4:SetDieTime(0.2)
    particle4:SetStartAlpha(255)
    particle4:SetEndAlpha(0)
    particle4:SetEndSize(15 * self.Mag)
    particle4:SetStartSize(0)
    particle4:SetAngles(self.Normal:Angle() or self.Owner:GetAimVector())
    particle4:SetVelocity(self.Normal * 5)
    
	emitter:Finish()
end
end


function EFFECT:Think( )
	return false	
end

function EFFECT:Render()

end



