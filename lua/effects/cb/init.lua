function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()

	local emitter = ParticleEmitter( self.Position )
	local particle = emitter:Add( "particle/particle_ring_wave_additive", self.Position)
	local particle2 = emitter:Add( "pp/dof", self.Position)

    
    particle:SetDieTime(0.2)
    particle:SetStartSize(35)
    particle:SetEndSize(0)
    particle:SetStartAlpha(255)
	particle:SetEndAlpha(255)
	particle:SetColor( 255, 0, 200)	
    particle:SetPos(data:GetEntity():GetPos())

    particle2:SetDieTime(0.2)
    particle2:SetStartSize(31)
    particle2:SetEndSize(0)
    particle2:SetStartAlpha(255)
	particle2:SetEndAlpha(255)

	particle2:SetColor( 0, 0, 0)	
    particle2:SetPos(data:GetEntity():GetPos())
    
	emitter:Finish()
end


function EFFECT:Think( )
	return false	
end

function EFFECT:Render()

end



