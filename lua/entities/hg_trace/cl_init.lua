
include('shared.lua')
ENT.matBeam		 		= Material( "effects/gstands_htentg_.vtf" )

ENT.RenderGroup         = RENDERGROUP_BOTH

function ENT:Initialize()		
    self:SetRenderMode(RENDERMODE_WORLDGLOW)

	self.Size = 0
	self.MainStart = self.Entity:GetPos()
	self.MainEnd = self:GetEndPos()
    self.SecStart = self.Entity:GetPos()
	self.SecEnd = self.Owner:GetPos()
	self.dAng = (self.MainEnd - self.MainStart):Angle()
	self.dAng2 = (self.SecEnd - self.SecStart):Angle()
	self.speed = 0
	self.startTime = CurTime()
	self.enditime = CurTime() + self.speed
	self.dit = 1
	self.wep = self.Owner:GetActiveWeapon()
	if self.wep:GetStand() then
    if self.wep:GetStand():GetSkin() == 0 then
    self.matBeam		 		= Material( "effects/gstands_htentg_.vtf" )
    elseif self.wep:GetStand():GetSkin() == 1 then
    self.matBeam		 		= Material( "effects/gstands_htentb_.vtf" )
    elseif self.wep:GetStand():GetSkin() == 2 then
    self.matBeam		 		= Material( "effects/gstands_htentp_.vtf" )
    elseif self.wep:GetStand():GetSkin() == 3 then
    self.matBeam		 		= Material( "effects/gstands_htenty_.vtf" )
    end
    end

end

function ENT:Think()

	self.Entity:SetRenderBoundsWS( self:GetEndPos(), self.Entity:GetPos(), Vector()*8 )
	
	self.Size = math.Approach( self.Size, 1, 10*FrameTime() )
end


function ENT:DrawMainBeam( StartPos, EndPos, dit, dist )

	local TexOffset = 0//CurTime() * -2.0
	
	local ca = Color(255,255,255,255)


	render.SetMaterial( self.matBeam )
	render.DrawBeam( EndPos, StartPos, 8, TexOffset, TexOffset + StartPos:Distance(EndPos)/24, ca )


end

function ENT:Draw()
    if !self.Owner:GetNoDraw() then
		if CLIENT and LocalPlayer():GetActiveWeapon() then
		if LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then
	local Owner = self.Entity:GetOwner()
	if (!IsValid(Owner)) then return end
	
    local StartPos 		= Owner:GetBonePosition(Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
	if Owner:LookupBone("ValveBiped.Bip01_R_Hand") == -1 then
		local StartPos = self.Owner:GetShootPos()
	end
    local StartPos2 		= Owner:EyePos()
    if self.wep:GetStand():IsValid() then
        StartPos = self.wep:GetStand():GetBonePosition(Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
        StartPos2 = self.wep:GetStand():GetBonePosition(Owner:LookupBone("ValveBiped.Bip01_R_Calf")) or self.wep:GetStand():GetBonePosition(0)
    end
	local EndPos 		= self:GetEndPos()
	local ViewModel 	= Owner == LocalPlayer()

	if (EndPos == Vector(0,0,0)) then return end

	
	local TexOffset = CurTime() * -2
	
	local Distance = EndPos:Distance( StartPos ) * self.Size

	local et = (self.startTime + (Distance/self.speed))
	if(self.dit != 0) then
		self.dit = (et - CurTime()) / (et - self.startTime)
	end
	if(self.dit < 0) then
		self.dit = 0
	end
	self.dAng = (EndPos - StartPos):Angle():Forward()

	gbAngle = (EndPos - StartPos):Angle()
	local Normal 	= gbAngle:Forward()

	// Draw the beam
	self:DrawMainBeam( StartPos, StartPos + Normal * Distance, self.dit, Distance )
	self:DrawMainBeam( StartPos2, Owner:GetBonePosition(Owner:LookupBone("ValveBiped.Bip01_R_Hand")), self.dit, Distance )

	 
end
end
end
end

