function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
    local owner = data:GetEntity()

	local emitter = ParticleEmitter( self.Position )
    local particle = emitter:Add( "effects/brightglow_y_nomodel", self.Position)
    local particle2 = emitter:Add( "effects/brightglow_y_nomodel", self.Position)

    
    particle:SetDieTime(0.3)
    particle:SetStartSize(25)
    particle:SetEndSize(1)
    particle:SetStartAlpha(255)
	particle:SetEndAlpha(2)
    particle:SetRollDelta(0.2)
    particle:SetColor(255, 255, 255)	
    if owner:IsValid() then
    particle:SetPos(owner:LocalToWorld(owner:OBBCenter()))
    end
    particle:SetNextThink( CurTime() )
 
        particle:SetThinkFunction(function() 
        if owner:IsValid() then
            particle:SetLifeTime(0)
        
        particle:SetPos(owner:LocalToWorld(owner:OBBCenter())) 
        particle:SetNextThink( CurTime() ) else particle2:SetLifeTime(100) end end)

    particle2:SetDieTime(0.1)
    particle2:SetStartSize(25)
    particle2:SetEndSize(0)
    particle2:SetStartAlpha(255)
	particle2:SetEndAlpha(0)
    particle2:SetRollDelta(0.2)
    particle2:SetColor(255, 255, 255)	
    if owner:IsValid() then
    particle2:SetPos(owner:LocalToWorld(owner:OBBCenter()))
    end
    particle2:SetNextThink( CurTime() )
 
        particle2:SetThinkFunction(function() 
        if owner:IsValid() then
        particle2:SetLifeTime(0)
        particle2:SetPos(owner:LocalToWorld(owner:OBBCenter())) 
        particle2:SetNextThink( CurTime() + 0.09 ) else particle2:SetLifeTime(100) end end)
        
    
	emitter:Finish()
end


function EFFECT:Think( )
	return false	
end

function EFFECT:Render()

end



