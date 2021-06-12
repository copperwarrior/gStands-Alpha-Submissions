function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	
    local owner = data:GetEntity()
    local wep = owner.Owner:GetActiveWeapon()
	local hooktag = owner.Owner:GetName()
	hook.Add("RenderScreenspaceEffects", "TheSunHeat"..hooktag, function()
		if IsValid(wep) and IsValid(wep:GetSun()) then
			local norm = (wep:GetSun():GetPos() - LocalPlayer():WorldSpaceCenter()):GetNormalized()
			local tr = util.TraceLine( {
				start = wep:GetSun():GetPos(),
				endpos = norm * GetConVar("gstands_the_sun_range"):GetFloat(),
				filter = wep:GetSun(),
				mask = MASK_SHOT_HULL
			} )
			if tr.Entity == LocalPlayer() then
				DrawMaterialOverlay("models/shadertest/predator", 1 - tr.Fraction)
			end
		else
			hook.Remove("DrawScreenspaceEffects", "TheSunHeat"..hooktag)
		end
	end)
	local emitter = ParticleEmitter( owner:GetPos() )
    local particle3 = emitter:Add( "particle/particle_ring_refract_01", owner:GetPos())
	--local particle2 = emitter:Add( "sprites/heatwave", self.Position)
	local particle4 = emitter:Add( "effects/brightglow_y_nomodel", owner:GetPos())
    
    -- particle2:SetDieTime(2.1)
    -- particle2:SetStartSize(4092)
    -- particle2:SetEndSize(4092)
    -- particle2:SetStartAlpha(100)
	-- particle2:SetEndAlpha(1)
    -- particle2:SetColor( 255, 255, 255)
    -- particle2:SetRollDelta(-0.2)
    -- if owner:IsValid() then	
    -- particle2:SetPos(owner:LocalToWorld(owner:OBBCenter()))    
    -- end 
	particle4:SetDieTime(2.1)
    particle4:SetStartSize(600)
    particle4:SetEndSize(600)
    particle4:SetStartAlpha(100)
	particle4:SetEndAlpha(100)
    particle4:SetColor( 255, 255, 255)
    particle4:SetRollDelta(-0.2)
    if owner:IsValid() then	
    particle4:SetPos(owner:GetPos())    
    end
    
    particle3:SetDieTime(2.1)
    particle3:SetStartSize(512)
    particle3:SetEndSize(4092)
    particle3:SetStartAlpha(255)
	particle3:SetEndAlpha(1)
    particle3:SetColor( 255, 255, 255)	
    particle3:SetRollDelta(-0.2)
    if owner:IsValid() then
    particle3:SetPos(owner:GetPos())    
    end
    
    --particle2:SetNextThink( CurTime() )
    particle3:SetNextThink( CurTime() )
    particle4:SetNextThink( CurTime() )
    
    -- particle2:SetThinkFunction(function()
        -- if owner:IsValid() and wep:GetSun() then
            -- particle2:SetLifeTime(0)
            -- else
            -- particle2:SetLifeTime(100)
        -- end 
        -- particle2:SetNextThink( CurTime() + 2 ) end)
        
        particle3:SetThinkFunction(function()
        if owner:IsValid() and wep:GetSun() then
            particle3:SetLifeTime(0)
			particle3:SetPos(owner:GetPos())    
            else
            particle3:SetLifeTime(100)
        end
        particle3:SetNextThink( CurTime() + 2 ) end)
		
        particle4:SetThinkFunction(function()
        if owner:IsValid() and wep:GetSun() then
            particle4:SetLifeTime(0)
			particle4:SetPos(owner:GetPos())    
            else
            particle4:SetLifeTime(100)
        end
        particle4:SetNextThink( CurTime() + 2 ) end)
        
    
	emitter:Finish()
end


function EFFECT:Think( )
	return false	
end

function EFFECT:Render()

end



