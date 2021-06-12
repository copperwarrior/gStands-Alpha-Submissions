function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
    local owner = data:GetEntity()
	local wep = owner.Owner:GetActiveWeapon()
	local emitter = ParticleEmitter( self.Position )
    local particle = emitter:Add( "effects/gstands_emeraldsplash", self.Position)
    local particle2 = emitter:Add( "effects/gstands_emeraldsplash", self.Position)
    if owner != nil and owner:IsValid() then
    
    if wep:GetStand():GetSkin() == 0 then
    particle:SetColor(150, 255, 255)
    elseif wep:GetStand():GetSkin() == 1 then
        particle:SetColor(150, 255, 255)

    elseif wep:GetStand():GetSkin() == 2 then
        particle:SetColor(150, 255, 255)

    elseif wep:GetStand():GetSkin() == 3 then
        particle:SetColor(150, 255, 255)
		
    end
    
    particle:SetDieTime(0.3)
    particle:SetStartSize(1)
    particle:SetEndSize(1)
    particle:SetStartAlpha(255)
	particle:SetEndAlpha(2)
    particle:SetRollDelta(0.2)
    if owner:IsValid() then
    particle:SetPos(owner:LocalToWorld(owner:OBBCenter()))
    end
    particle:SetNextThink( CurTime() )
 
        particle:SetThinkFunction(function() 
        if owner:IsValid() then
            particle:SetLifeTime(0)
        
        particle:SetPos(owner:LocalToWorld(owner:OBBCenter())) 
        particle:SetNextThink( CurTime() ) else particle2:SetLifeTime(100) return true end end)

        if wep:GetStand():GetSkin() == 0 then
    particle2:SetColor(0, 150, 0)
    elseif wep:GetStand():GetSkin() == 1 then
        particle2:SetColor(0, 0, 255)

    elseif wep:GetStand():GetSkin() == 2 then
        particle2:SetColor(255, 0, 150)

    elseif wep:GetStand():GetSkin() == 3 then
        particle2:SetColor(255, 150, 0)

    end	
    particle2:SetDieTime(0.1)
    particle2:SetStartSize(25)
    particle2:SetEndSize(0)
    particle2:SetStartAlpha(255)
	particle2:SetEndAlpha(0)
    particle2:SetRollDelta(0.2)
    if owner:IsValid() then
    particle2:SetPos(owner:LocalToWorld(owner:OBBCenter()))
    end
    particle2:SetNextThink( CurTime() )
 
        particle2:SetThinkFunction(function() 
        if owner:IsValid() then
        particle2:SetLifeTime(0)
        particle2:SetPos(owner:LocalToWorld(owner:OBBCenter())) 
        particle2:SetNextThink( CurTime() + 0.09 ) else particle2:SetLifeTime(100) return true end end)
        
    
	emitter:Finish()
end
end


function EFFECT:Think( )
	return false	
end

function EFFECT:Render()

end



