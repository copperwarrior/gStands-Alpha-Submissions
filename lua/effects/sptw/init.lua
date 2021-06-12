function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()

	local emitter = ParticleEmitter( self.Position )
	local particle = emitter:Add( "effects/strider_pinch_dudv", self.Position)
    local ent = data:GetEntity()
    if data:GetMagnitude() == 3 then
        particle:SetDieTime(0.6)
        particle:SetStartSize(0)
        particle:SetEndSize(500)
	else
        particle:SetDieTime(1.7)
        particle:SetStartSize(500)
        particle:SetEndSize(0)
    end
    
    particle:SetStartAlpha(255)
	particle:SetEndAlpha(255)

	particle:SetColor( 0, 0, 0)	
    particle:SetNextThink( CurTime() )
    particle:SetThinkFunction(function() if IsValid(ent) then particle:SetPos(ent:GetBonePosition(6)) particle:SetNextThink( CurTime() ) end end)

	emitter:Finish()
end


function EFFECT:Think( )
	return false	
end

function EFFECT:Render()

end



