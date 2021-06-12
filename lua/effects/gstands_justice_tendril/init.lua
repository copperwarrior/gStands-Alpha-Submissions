function EFFECT:Init( data )
	self.Position = data:GetOrigin()
    self.target = data:GetEntity()
    self.attach = math.random(1,2)
    self.owner = Entity(data:GetAttachment())
    self.particle = CreateParticleSystem(self.target, "justicetendril", PATTACH_POINT_FOLLOW ,0 )
    self.particle:SetControlPoint(1, self.owner:WorldSpaceCenter() + Vector(0,0,100))
    self.particle:SetControlPointEntity(1, self.owner)
	self.wep = self.owner:GetActiveWeapon()
end


function EFFECT:Think( )
	if not (IsValid(self.wep) and IsValid(self.wep:GetStand() and IsValid(self.target))) then
		if self.particle then
			self.particle:StopEmissionAndDestroyImmediately()
		end
		self:Remove()
		return true
	end
	if self.wep and IsValid(self.wep:GetStand()) then
		local att1 = self.wep:GetStand():GetAttachment(self.wep:GetStand():LookupAttachment("handR")).Pos
		local att2 = self.wep:GetStand():GetAttachment(self.wep:GetStand():LookupAttachment("handL")).Pos
		if att1:DistToSqr(self.target:GetPos()) < att2:DistToSqr(self.target:GetPos()) then
			self.attach = 1
			else
			self.attach = 2
		end
	end
    if self.attach == 1 and self.wep:GetStand():IsValid() then
	self.clr = self.clr or Vector(1,0,0)
    self.particle:SetControlPoint(1, self.wep:GetStand():GetAttachment(self.wep:GetStand():LookupAttachment("handR")).Pos)
    self.particle:SetControlPoint(2, self.clr + Vector(0.1,0.1,0.1))
    elseif self.wep and self.wep.GetStand and self.wep:GetStand():IsValid() then
	self.clr = self.clr or Vector(1,0,0)
    self.particle:SetControlPoint(1, self.wep:GetStand():GetAttachment(self.wep:GetStand():LookupAttachment("handL")).Pos)
	self.particle:SetControlPoint(2, self.clr + Vector(0.1,0.1,0.1))

	else
		if self.particle then
			self.particle:StopEmissionAndDestroyImmediately()
		end
		self:Remove()
	end
    return true	
end

function EFFECT:Render()

end



