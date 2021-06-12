function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	local Entity = data:GetEntity()
    
	local emitter = ParticleEmitter( self.Position )
	particle = emitter:Add( "effects/strider_pinch_dudv", self.Position)
    
    if data:GetMagnitude() == 3 then
        particle:SetDieTime(0.9)
        particle:SetStartSize(0)
        particle:SetEndSize(500)
	else
        particle:SetDieTime(1.4)
        particle:SetStartSize(500)
        particle:SetEndSize(0)
    end
    
    particle:SetStartAlpha(255)
	particle:SetEndAlpha(255)

	particle:SetColor( 1, 255, 255)	
    particle:SetNextThink( CurTime() )
    particle:SetThinkFunction(function() 
		if IsValid(Entity) then
			particle:SetPos(Entity:GetBonePosition(3))
		end
		particle:SetNextThink( CurTime() ) end)
        
	emitter:Finish()
end


function EFFECT:Think( )
	return false	
end

function EFFECT:Render()
           
end



