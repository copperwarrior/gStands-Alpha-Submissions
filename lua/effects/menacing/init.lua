
game.AddParticles("particles/menacing.pcf")

PrecacheParticleSystem("menacinggstands")

function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
    local owner = data:GetEntity()

	-- local emitter = ParticleEmitter( self.Position )
    -- local particle = emitter:Add( "effects/menacing", self.Position)
  
    -- particle:SetDieTime(4)
    -- particle:SetStartSize(15)
    -- particle:SetEndSize(5)
    -- particle:SetStartAlpha(255)
	-- particle:SetEndAlpha(255)
    -- particle:SetRollDelta(math.Rand(-0.1,0.1))
    -- particle:SetColor(255, 255, 255)	
    -- particle:SetPos(self.Position + Vector(math.random(-5,5),math.random(-5,5),math.random(-5,5)))
    -- particle:SetVelocity(Vector(math.random(-10,10),math.random(-10,10),20))
    ParticleEffectAttach("menacing", PATTACH_POINT_FOLLOW, owner, 1)
    sound.Play("ambient/machines/thumper_hit.wav", self.Position, 75, math.random(49, 57), 0.3)
	--emitter:Finish()
end


function EFFECT:Think( )
	return false	
end

function EFFECT:Render()

end



