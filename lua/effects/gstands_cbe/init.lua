function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()

	local emitter = ParticleEmitter( self.Position )
	local particle = emitter:Add( "particle/particle_ring_wave_additive", self.Position)
	local particle2 = emitter:Add( "pp/dof", self.Position)

    
    particle:SetDieTime(0.3)
    particle:SetStartSize(70)
    particle:SetEndSize(70)
    particle:SetStartAlpha(255)
	particle:SetEndAlpha(0)
	particle:SetColor( 255, 255, 255)
    particle:SetPos(self.Position)

    particle2:SetDieTime(1)
    particle2:SetStartSize(65)
    particle2:SetEndSize(65)
    particle2:SetStartAlpha(255)
	particle2:SetEndAlpha(0)

	particle2:SetColor( 0, 0, 0)	
    if data:GetEntity():IsValid() then
    particle2:SetPos(self.Position)
    end
	emitter:Finish()
end


function EFFECT:Think( )
	return false	
end

function EFFECT:Render()

end



