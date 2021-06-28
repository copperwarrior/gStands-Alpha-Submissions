
include('shared.lua')

local matBeam		 		= Material( "effects/gstands_hermit_purple" )

ENT.RenderGroup		 = RENDERGROUP_BOTH

function ENT:Initialize()		
	self.pfx = CreateParticleSystem( self.Owner, "hpurple", PATTACH_POINT_FOLLOW, self.Owner:LookupAttachment("anim_attachment_RH"), Vector(0,0,0))
	if !self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") or self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") == -1 then
		return 
	end
	self.pfx:SetControlPoint( 0, self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")) )
	self.pfx:SetControlPointEntity( 0, self.Owner )
	self.pfx:SetControlPoint( 1, self:GetPos() )
	self:SetRenderMode(RENDERMODE_WORLDGLOW)
	self.Size = 0
	self.MainStart = self.Entity:GetPos()
	self.MainEnd = self:GetEndPos()
	self.dAng = (self.MainEnd - self.MainStart):Angle()
	self.speed = 5
	self.startTime = CurTime()
	self.endTime = CurTime() + self.speed
	self.dst = -1
	self.Color = Color(255,0,255,255)
	self.OwnerWep = self.Owner:GetActiveWeapon()
   
	self.clent = ClientsideModel("models/hpworld/hprope.mdl")
	self.clent:Spawn()
	self.clent:SetNoDraw(true)
	
end


function ENT:Think()

	if IsValid(self:GetHPEntity()) then
		self:SetEndPos(self:GetHPEntity():WorldSpaceCenter())
	end
	if self.Owner:GetNWBool("Hamon_"..self.Owner:GetName()) then
		self.Color = Color(255,105,0,255)
	end
	if self.dst == 0 and !IsValid(self.csent) and IsValid(self:GetHPEntity()) then
		self.csent = ClientsideModel("models/hpworld/hpworld.mdl", RENDERGROUP_BOTH)
		self.csent:SetPos(self:GetEndPos() - Vector(0, 0, 32))
		self.csent:SetAngles(Angle(0,0,-90))
		self.csent:SetModelScale(5)
		self.csentcreatetime = CurTime()
		self.csent:SetNoDraw(true)
	end
	self.Entity:SetRenderBoundsWS( self:GetEndPos(), self.Entity:GetPos(), Vector()*8 )
	if self.csent and self.csentcreatetime then
		self.csent:SetPos(self:GetEndPos() - Vector(0, 0, 32))
		self.csent:SetAngles(self.csent:GetAngles() + Angle(0,math.max(1,  25 - ((CurTime() - self.csentcreatetime) * 25)),0))
		self.csent:ManipulateBoneAngles(0, Angle(0,0,math.max(1,  35 + ((CurTime() - self.csentcreatetime) * 335))))
		self.csent:ManipulateBoneAngles(1, Angle(0,0,math.max(1,  1 + ((CurTime() - self.csentcreatetime) * 335))))
		self.csent:ManipulateBoneAngles(2, Angle(0,0,math.max(1,  12 + ((CurTime() - self.csentcreatetime) * 335))))
	end
	if IsValid(self) and self.Size then
		self.Size = math.Approach( self.Size, 1, 10*FrameTime() )
	end
	if self.OwnerWep then
		self.pfx:SetShouldDraw(self.OwnerWep:GetHamon())
	end
	self.pfx:Restart()
	if self.speed then
		self.speed = self.speed + 50
	end
	self:NextThink(CurTime() )
	
	return true
end


function ENT:DrawMainBeam( StartPos, EndPos, dt, dist )
	
	EndPos = LerpVector(dt, EndPos, StartPos)
	
	self.randvecs = self.randvecs or {
		Vector(math.random(-96,96) / 5 + dt,math.random(-96,96) / 5 + dt,math.random(-96,96) / 5 + dt),
		Vector(math.random(-96,96) / 5 + dt,math.random(-96,96) / 5 + dt,math.random(-96,96) / 5 + dt),
		Vector(math.random(-96,96) / 5 + dt,math.random(-96,96) / 5 + dt,math.random(-96,96) / 5 + dt),
		Vector(math.random(-96,96) / 5 + dt,math.random(-96,96) / 5 + dt,math.random(-96,96) / 5 + dt),
		Vector(math.random(-96,96) / 5 + dt,math.random(-96,96) / 5 + dt,math.random(-96,96) / 5 + dt),
		Vector(math.random(-96,96) / 5 + dt,math.random(-96,96) / 5 + dt,math.random(-96,96) / 5 + dt),
		Vector(math.random(-155,155) / 7 + dt,math.random(-155,155) / 7 + dt,math.random(-155,155) / 7 + dt),
		Vector(math.random(-155,155) / 7 + dt,math.random(-155,155) / 7 + dt,math.random(-155,155) / 7 + dt),
		Vector(math.random(-155,155) / 7 + dt,math.random(-155,155) / 7 + dt,math.random(-155,155) / 7 + dt),
		Vector(math.random(-155,155) / 7 + dt,math.random(-155,155) / 7 + dt,math.random(-155,155) / 7 + dt),
		Vector(math.random(-155,155) / 7 + dt,math.random(-155,155) / 7 + dt,math.random(-155,155) / 7 + dt),
		Vector(math.random(-155,155) / 7 + dt,math.random(-155,155) / 7 + dt,math.random(-155,155) / 7 + dt),
	}
	if CLIENT and LocalPlayer():GetActiveWeapon() then
		if LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then
			for k,v in pairs(self.randvecs) do
			self:DrawRope( EndPos + v, StartPos + v / 7, v, dt)
			end
		end
	end
end
function ENT:DrawRope(EndPos, StartPos, randomvec, dt)
	self.clent:SetPos(StartPos)
	self.clent:SetAngles((EndPos - StartPos):GetNormalized():Angle())
	self.clent:SetupBones()
	for i = 1, self.clent:GetBoneCount() - 1 do
		local pos1, ang1 = self.clent:GetBonePosition(i)
		if i != 1 and i != 12  and i != 11 then
			if math.random(0,1) == 1 then
				ang1 = Angle(ang1.p + dt * ((randomvec.y + i) * 15) + (math.sin(CurTime() + (i * 5 + randomvec.x) * 5) * 15), ang1.y + dt * 15, ang1.r + dt * 15)
			else
				ang1 = Angle(ang1.p + dt * ((randomvec.y + i) * 15) + (math.sin(CurTime() + (i * 5 + randomvec.x) * 5) * 15), ang1.y - dt * 15, ang1.r - dt * 15)
			end
			self:ManipulateBoneJiggle(i, 1)
		end
	self.clent:SetBonePosition(i, LerpVector(math.Clamp(((11 - i) * 0.1) + randomvec.x/100, 0, 1), EndPos, self.clent:GetPos()), ang1)
	end
	self.clent:DrawModel()
	if IsValid(self.csent) then
		self.csent:SetupBones()
		self.csent:DrawModel()
	end
end
function ENT:OnRemove()
	self.pfx:StopEmission()
	if self.csent then
		self.csent:Remove()
	end
	if IsValid(self.clent) then
		self.clent:Remove()
	end
end
function ENT:Draw()
	if !self.Owner:GetNoDraw() then
		if !self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") then return end
		self.pfx:SetControlPoint( 0, self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")) )
		self.pfx:SetControlPoint( 1, self:GetEndPos() )
		local Owner = self.Entity:GetOwner()
		if (!Owner || Owner == NULL) then return end
		
		local StartPos 		= Owner:GetBonePosition(Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		local EndPos 		= self:GetEndPos()
		local ViewModel 	= Owner == LocalPlayer()
		
		if (EndPos == Vector(0,0,0)) then return end
		
		
		local TexOffset = CurTime() * -2
		
		local Distance = EndPos:Distance( StartPos ) * self.Size
		
		local et = (self.startTime + (Distance/self.speed))
		if(self.dst != 0) then
			self.dst = (et - CurTime()) / (et - self.startTime)
		end
		if(self.dst < 0) then
			self.dst = 0
		end
		self.dAng = (EndPos - StartPos):Angle():Forward()
		
		gbAngle = (EndPos - StartPos):Angle()
		local Normal 	= gbAngle:Forward()
		
		// Draw the beam
		self:DrawMainBeam( StartPos, EndPos, self.dst, Distance )
		
		else
		self.pfx:StopEmission()
	end
end

/*---------------------------------------------------------
Name: IsTranslucent
---------------------------------------------------------*/
function ENT:IsTranslucent()
	return true
end
