function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
    local owner = data:GetEntity()
    local normal = data:GetNormal()
    local mag = data:GetMagnitude() or 5

	local emitter = ParticleEmitter( self.Position, true)
    for i=0, 15 do    
    local particle = emitter:Add( "effects/gstands_dbm/whirl"..math.random(1,2)..".vtf", self.Position)  
    if owner != nil and owner:IsValid() then
        owner:EmitStandSound("weapons/dbm/saw.wav")
        particle:SetVelocity(((normal * 75)) * mag + owner:GetVelocity())
        particle:SetDieTime(0.8)
        particle:SetPos(self.Position)
        particle:SetColor(150,150,200)
        particle:SetStartSize(math.random(45,25))
        particle:SetEndSize(15)
        particle:SetAngles(normal:Angle() + Angle(0, 90, 90))
        particle:SetStartAlpha(255)
        particle:SetEndAlpha(0)
        particle:SetCollide(true) 
        particle:SetThinkFunction(function() 
                particle:SetAngles(particle:GetAngles() + Angle(0,0,35))
                        particle:SetNextThink(CurTime())

                end)
        particle:SetNextThink(CurTime())

end
end
end


function EFFECT:Think( )
	return false	
end


function EFFECT:Render()

end





