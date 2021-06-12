function EFFECT:Init( data )
  if CLIENT and LocalPlayer():GetActiveWeapon() then
        if LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then

	self.Position = data:GetOrigin()
    local target = data:GetEntity()
	if IsValid(target) then
    self.particle = CreateParticleSystem(target, "tsbuff2", PATTACH_POINT_FOLLOW ,0 )
	if self.particle then
		self.particle:SetControlPoint(1, target:WorldSpaceCenter() + Vector(0,0,100))
	end
end
end
end
end


function EFFECT:Think( )
    return true	
end

function EFFECT:Render()

end



