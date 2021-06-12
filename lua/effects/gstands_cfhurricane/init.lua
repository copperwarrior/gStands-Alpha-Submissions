function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	local owner = data:GetEntity()
	local color, stand
	if IsValid(owner) and IsValid(owner.Owner) and IsValid(owner.Owner:GetActiveWeapon()) and IsValid(owner.Owner:GetActiveWeapon():GetStand()) then
		stand = owner.Owner:GetActiveWeapon():GetStand()
		if IsValid(stand) then
			color = gStands.GetStandColorTable(stand:GetModel(), stand:GetSkin())
		end
	end
	local emitter = ParticleEmitter( self.Position, true )
	local particle = emitter:Add( "effects/gstands_cfhurricane", self.Position)

	particle:SetDieTime(0.5)
	particle:SetStartSize(50)
	particle:SetEndSize(50)
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(255)
	particle:SetColor(color.r, color.g, color.b)	
	particle:SetAngles(owner:GetAngles() + Angle(0,0,-90))
	if owner:IsValid() then
	particle:SetPos(owner:LocalToWorld(owner:OBBCenter()) + Vector(0,0,5))
	end
	particle:SetNextThink( CurTime() )
 
		particle:SetThinkFunction(function() 
		if owner:IsValid() then
			particle:SetLifeTime(0)
		if IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and !string.StartWith(LocalPlayer():GetActiveWeapon():GetClass(), "gstands_") then particle:SetLifeTime(100) end
		particle:SetPos(owner:LocalToWorld(owner:OBBCenter()) + Vector(0,0,5)) 
			particle:SetAngles(owner:GetAngles() + Angle(0,0,-90))

		particle:SetNextThink( CurTime() ) return true else particle:SetLifeTime(100) end end)
   
	emitter:Finish()
end


function EFFECT:Think( )
	return false	
end

function EFFECT:Render()

end



