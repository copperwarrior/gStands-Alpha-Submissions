function EFFECT:Init( data )
    local target = data:GetEntity()
	local flag = data:GetFlags()
	if !IsValid(target) then return end
    if !target:GetNoDraw() and flag != 15 then
		self.particle = CreateParticleSystem(target, "cfh", PATTACH_POINT ,1 )
		if self.particle then
		self.particle:SetControlPointEntity(0, target)
		self.particle:SetControlPoint(0, target:WorldSpaceCenter())
		local color = gStands.GetStandColor("models/player/mgr/mgr.mdl", target.Owner:GetActiveWeapon():GetStand():GetSkin())
		self.particle:SetControlPoint(1, color)
		end
	end
	if !target:GetNoDraw() and flag == 15 then
		self.particle = CreateParticleSystem(target, "mgrtrails", PATTACH_POINT ,1 )
		if self.particle then
		self.particle:SetControlPointEntity(0, target)
		self.particle:SetControlPoint(0, target:WorldSpaceCenter())
		self.particle:SetControlPoint(1, target:WorldSpaceCenter())
		end
	end
end


function EFFECT:Think( )
        if self.particle and CLIENT and LocalPlayer():IsValid() and LocalPlayer():GetActiveWeapon() then
        if LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) and LocalPlayer():Alive() then
        self.particle:SetShouldDraw(true)
        else
        self.particle:SetShouldDraw(false)
        end
	elseif self.Particle then
        self.particle:SetShouldDraw(false)
        end
    return true	
end

function EFFECT:Render()

end



