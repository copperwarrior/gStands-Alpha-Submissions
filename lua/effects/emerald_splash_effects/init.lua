function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
    local owner = data:GetEntity()

	local emitter = ParticleEmitter( self.Position )
    local particle = emitter:Add( "effects/gstands_emeraldsplash", self.Position)    
    if owner != nil and owner:IsValid() and !owner:GetNoDraw() then
    		local wep = owner:GetActiveWeapon()

    if wep:GetStand():GetSkin() == 0 then
            particle:SetColor(0, 150, 0)
        elseif wep:GetStand():GetSkin() == 1 then
            particle:SetColor(0, 0, 255)
        elseif wep:GetStand():GetSkin() == 2 then
            particle:SetColor(250, 0, 150)
        elseif wep:GetStand():GetSkin() == 3 then
            particle:SetColor(255, 150, 0)
        end
    
    particle:SetDieTime(0.7)
    particle:SetStartSize(1)
    particle:SetEndSize(16)
    particle:SetStartAlpha(100)
	particle:SetEndAlpha(2)
    particle:SetRollDelta(math.random(-11,21))
    particle:SetNextThink( CurTime() )
 
        particle:SetThinkFunction(function() 
        if owner:IsValid() then
        particle:SetPos((wep:GetStand():GetBonePosition(wep:GetStand():LookupBone("ValveBiped.Bip01_R_Hand")) + wep:GetStand():GetBonePosition(wep:GetStand():LookupBone("ValveBiped.Bip01_L_Hand")))/2)
        
        particle:SetNextThink( CurTime() ) else particle2:SetLifeTime(100) return true end end)

        

end
	emitter:Finish()

end


function EFFECT:Think( )
	return false	
end

function EFFECT:Render()

end





