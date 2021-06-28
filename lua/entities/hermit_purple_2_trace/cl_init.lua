
include('shared.lua')

local matBeam		 		= Material( "effects/gstands_hermit_purple" )

ENT.RenderGroup		 = RENDERGROUP_BOTH

function ENT:Initialize()		
	self:SetRenderMode(RENDERMODE_WORLDGLOW)
	self.Size = 0
	self.MainStart = self.Entity:GetPos()
	self.MainEnd = self:GetEndPos()
	self.dAng = (self.MainEnd - self.MainStart):Angle()
	self.speed = 2000
	self.startTime = CurTime()
	self.endTime = CurTime() + self.speed
	self.dt = -1
	self.Color = Color(255,0,255,255)
	self.OwnerWep = self.Owner:GetActiveWeapon()
	self.clent = ClientsideModel("models/hpworld/hprope.mdl")
	self.clent:Spawn()
	self.clent:SetNoDraw(true)
end


function ENT:Think()
	if self.Owner:GetNWBool("Hamon_"..self.Owner:GetName()) then
		self.Color = Color(255,105,0,255)
	end
	self.Entity:SetRenderBoundsWS( self:GetEndPos(), self.Entity:GetPos(), Vector()*8 )
	if IsValid(self) and self.Size then
		self.Size = math.Approach( self.Size, 1, 10*FrameTime() )
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
				ang1 = Angle(ang1.p + dt * ((randomvec.y + i) * 15) + (math.sin(CurTime() + (i * 5 + randomvec.x) * 5) * 15), ang1.y + dt * 15, ang1.r)
			else
				ang1 = Angle(ang1.p + dt * ((randomvec.y + i) * 15) + (math.sin(CurTime() + (i * 5 + randomvec.x) * 5) * 15), ang1.y - dt * 15, ang1.r)
			end
		end
	self.clent:SetBonePosition(i, LerpVector(math.Clamp(((11 - i) * 0.1) + randomvec.x/100, 0, 1), EndPos, self.clent:GetPos()), ang1)
	end
					render.SetColorModulation(1,0.1,0.05)
	self.clent:DrawModel()
	
end
function ENT:OnRemove()
	if IsValid(self.clent) then
		self.clent:Remove()
	end
end
function ENT:Draw()
	if !self.Owner:GetNoDraw() then
		local Owner = self.Entity:GetOwner()
		if (!Owner || Owner == NULL) then return end
		
		local StartPos 		= Owner:GetBonePosition(Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		local EndPos 		= self:GetEndPos()
		local ViewModel 	= Owner == LocalPlayer()
		
		if (EndPos == Vector(0,0,0)) then return end
		
		
		local TexOffset = CurTime() * -2
		
		local Distance = EndPos:Distance( StartPos ) * self.Size
		
		local et = (self.startTime + (Distance/self.speed))
		if(self.dt != 0) then
			self.dt = (et - CurTime()) / (et - self.startTime)
		end
		if(self.dt < 0) then
			self.dt = 0
		end
		self.dAng = (EndPos - StartPos):Angle():Forward()
		
		gbAngle = (EndPos - StartPos):Angle()
		local Normal 	= gbAngle:Forward()
		
		// Draw the beam
		self:DrawMainBeam( StartPos, EndPos, self.dt, Distance )
		
		else
	end
end

/*---------------------------------------------------------
Name: IsTranslucent
---------------------------------------------------------*/
function ENT:IsTranslucent()
	return true
end
