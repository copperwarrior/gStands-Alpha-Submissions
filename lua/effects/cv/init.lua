function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
    local owner = data:GetEntity()

	local emitter = ParticleEmitter( self.Position )
	local particle3 = emitter:Add( "effects/strider_pinch_dudv", self.Position)
    local particle4 = emitter:Add( "effects/strider_pinch_dudv", self.Position)
    local particle = emitter:Add( "effects/gstands_cream_void", self.Position)
	local particle2 = emitter:Add( "refract_ring", self.Position)
    local s = owner:GetAngles().y

    
    particle:SetDieTime(0.6)
    particle:SetStartSize(62)
    particle:SetEndSize(1)
    particle:SetStartAlpha(1)
	particle:SetEndAlpha(2)
    particle:SetRollDelta(0.2)
    particle:SetPos(owner:LocalToWorld(owner:OBBCenter()))
    
    particle2:SetDieTime(0.6)
    particle2:SetStartSize(31)
    particle2:SetEndSize(31)
    particle2:SetStartAlpha(45)
	particle2:SetEndAlpha(255)
    particle2:SetColor( 0, 0, 0)	
    particle2:SetPos(owner:LocalToWorld(owner:OBBCenter()))    
    
    particle3:SetDieTime(0.6)
    particle3:SetStartSize(31)
    particle3:SetEndSize(31)
    particle3:SetStartAlpha(45)
	particle3:SetEndAlpha(255)
    particle3:SetColor( 0, 0, 0)	
    particle3:SetRollDelta(-0.2)
    particle3:SetPos(owner:LocalToWorld(owner:OBBCenter()))    
    
    particle4:SetDieTime(0.6)
    particle4:SetStartSize(31)
    particle4:SetEndSize(31)
    particle4:SetStartAlpha(45)
	particle4:SetEndAlpha(255)
    particle4:SetColor( 0, 0, 0)	
    particle4:SetRollDelta(0.2)
    particle4:SetPos(owner:LocalToWorld(owner:OBBCenter()))
   
    particle2:SetNextThink( CurTime() )
    particle3:SetNextThink( CurTime() )
    particle4:SetNextThink( CurTime() )
    particle:SetNextThink( CurTime() )
	local wep = owner:GetActiveWeapon()
    particle2:SetThinkFunction(function()
        if wep:GetStand():IsValid() and wep:GetStand():GetModelScale() < 1 then
            particle2:SetLifeTime(0)
            else
            particle2:SetLifeTime(100)
        end 
        particle2:SetPos(owner:LocalToWorld(owner:OBBCenter())) 
        particle2:SetNextThink( CurTime() ) end)
        
        particle3:SetThinkFunction(function()
        if wep:GetStand():IsValid() and wep:GetStand():GetModelScale() < 1 then
            particle3:SetLifeTime(0)
            else
            particle3:SetLifeTime(100)
        end
        particle3:SetPos(owner:LocalToWorld(owner:OBBCenter())) 
        particle3:SetNextThink( CurTime() ) end)
        
        particle4:SetThinkFunction(function()
        if wep:GetStand():IsValid() and wep:GetStand():GetModelScale() < 1 then
            particle4:SetLifeTime(0)
            else
            particle4:SetLifeTime(100)
        end
        particle4:SetPos(owner:LocalToWorld(owner:OBBCenter())) 
        particle4:SetNextThink( CurTime() ) end)
        
        particle:SetThinkFunction(function() 
        if wep:GetStand():IsValid() and wep:GetStand():GetModelScale() < 1 then
            particle:SetLifeTime(0)
        end
        particle:SetPos(owner:LocalToWorld(owner:OBBCenter())) 
        particle:SetNextThink( CurTime() ) end)

    
	emitter:Finish()
end


function EFFECT:Think( )
	return false	
end

function EFFECT:Render()

end



