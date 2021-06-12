function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
    local owner = data:GetEntity()

	local emitter = ParticleEmitter( self.Position )
    local particle1 = emitter:Add( "effects/gstands_tgray_vomit", self.Position)
    for i = 0, 5 do
        particle1:SetPos(self.Position + Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1)))
        particle1:SetCollide(false)
        particle1:SetColor(255,255,255)
        particle1:SetDieTime(1)
        particle1:SetStartAlpha(255)
        particle1:SetEndAlpha(0)
        particle1:SetEndSize(0)
        particle1:SetStartSize(5)
        particle1:SetGravity(Vector(0,0,-100))
        particle1:SetVelocity(Vector(math.Rand(-0.1,0.1),math.Rand(-0.1,0.1),math.Rand(-0.5,0.5)) * 50)

        particle1:SetRollDelta(math.random(-1,1))
    end
    
	emitter:Finish()
end


function EFFECT:Think( )
	return false	
end

function EFFECT:Render()

end



