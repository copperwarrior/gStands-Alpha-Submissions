function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
    local owner = data:GetEntity()
    local normal = data:GetNormal()
    local mag = data:GetMagnitude() or 5

	local emitter = ParticleEmitter( self.Position )
    for i = 0, 1 do
    local particle2 = emitter:Add( "sprites/heatwave", self.Position)
    local particle = emitter:Add( "effects/gstands_fireball/fireballambient2", self.Position)  
	local wep = owner:GetActiveWeapon()
    if owner != nil and owner:IsValid() and !owner:GetNoDraw() then
		color = gStands.GetStandColor("models/player/mgr/mgr.mdl", wep:GetStand():GetSkin())
       
        particle:SetDieTime(0.5)
        particle:SetPos(self.Position)
        particle:SetColor(color.x * 255,color.y * 255,color.z * 255)
        particle:SetStartSize(15)
        particle:SetEndSize(1)
        particle:SetStartAlpha(50)
        particle:SetEndAlpha(0)
        local randVec = Vector(math.random(-15, 5),math.random(-15, 15),math.random(-15, 15)) + Vector(math.random(-15, 15),math.random(-15, 15),math.random(-15,15 ))/2
        particle:SetVelocity(randVec)
        particle:SetRollDelta(math.random(-3,3))
        particle:SetCollide(true)   
        particle2:SetDieTime(0.5)
        particle2:SetPos(self.Position)
        particle2:SetColor(color.x * 255,color.y * 255,color.z * 255)
        particle2:SetStartSize(9)
        particle2:SetEndSize(3)
        particle2:SetStartAlpha(50)
        particle2:SetEndAlpha(0)
        particle2:SetVelocity(randVec)
        particle2:SetRollDelta(math.random(-3,3))
        particle2:SetCollide(true)   
        particle:SetThinkFunction(function() if !IsPlayerStandUser(LocalPlayer()) then particle:SetLifeTime(100) end
        end)
        particle:SetNextThink(CurTime())
    end
    end
	emitter:Finish()
end


function EFFECT:Think( )
	return false	
end


function EFFECT:Render()

end




