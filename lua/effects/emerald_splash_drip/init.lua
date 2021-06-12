function EFFECT:Init( data )
	if LocalPlayer():GetActiveWeapon() and LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then

	local Pos = data:GetOrigin()
	local owner = data:GetEntity()
	
	local emitter = ParticleEmitter( Pos )
	if !owner:GetNoDraw() then
	for i = 1,1 do

		local particle = emitter:Add( "effects/gstands_emeraldsplash_drip", Pos + Vector( math.random(0,0),math.random(0,0),math.random(0,0) ) ) 
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
		particle:SetVelocity(Vector(math.random(-5,5),math.random(-4,5),math.random(-5,0)))
		particle:SetLifeTime(0) 
		particle:SetDieTime(3) 
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(2)
		particle:SetStartSize(2) 
		particle:SetEndSize(0)
		particle:SetAngles( Angle(0,0,0) )
		particle:SetAngleVelocity( Angle(0,0,0) ) 
		particle:SetGravity( Vector(0,-0,-55) ) 
		particle:SetAirResistance(-20 )  
		particle:SetCollide(false)
		particle:SetBounce(0)
		 particle:SetNextThink( CurTime() )
 
        particle:SetThinkFunction(function() 
			if owner:IsValid() then
            particle:SetLifeTime(0)
        
        particle:SetNextThink( CurTime() ) else particle:SetLifeTime(100) return true end end)

	end

	
end
	emitter:Finish()

end

end

function EFFECT:Think()		
	return false
end

function EFFECT:Render()
end