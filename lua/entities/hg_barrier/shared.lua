ENT.Type = "anim"

ENT.LastEnt = nil
ENT.matBeam		 		= Material( "effects/gstands_htentg_.vtf" )
ENT.RenderGroup		 = RENDERGROUP_TRANSLUCENT
ENT.CurTarg			 = nil
ENT.CaC				 = Color(255,255,255,10)
local Splash = Sound("weapons/hierophant/splash.mp3")
local DripSmall = Sound("weapons/hierophant/dripsmall.wav")

function ENT:SetupDataTables()
	self:NetworkVar("Vector", 1, "EndPos")
	self:NetworkVar("Float", 2, "Alph")
end
function ENT:Initialize()
	if SERVER then
	self.Entity:DrawShadow( false )
	self.Entity:SetCollisionBoundsWS( self.Entity:GetPos(), self:GetEndPos(), Vector() * 0.25 )
	end
	self:SetRenderMode(RENDERMODE_WORLDGLOW)
	self.Size = 0
	self.MainStart = self.Entity:GetEndPos()
	self.MainEnd = self:GetPos()
	self.Normal = (self.MainEnd - self.MainStart):GetNormalized()
	self.dAng = (self.MainEnd - self.MainStart):GetNormalized():Angle()
	self.speed = 2000
	self.startTime = CurTime()
	self.enditime = CurTime() + self.speed
	self.dit = -1
	self.wep = self.Owner:GetActiveWeapon()
	self.Length = self:GetEndPos():Distance(self:GetPos())
	self.CaC = Color(255,255,255,10)
	if CLIENT then
		self.clent = ClientsideModel("models/heg/barrier.mdl", RENDERGROUP_TRANSLUCENT)
		self.clent:Spawn()
		self.clent:SetNoDraw(true)
	end
	if CLIENT and self.wep.GetStand and IsValid(self.wep:GetStand()) then
		self.clent:SetSkin(self.wep:GetStand():GetSkin())
	end
	self.DefState = #ents.FindAlongRay(self:GetPos(),self:GetEndPos())
	timer.Simple(1, function() if IsValid(self) then self.DefState = math.min(#ents.FindAlongRay(self:GetPos(),self:GetEndPos()), self.DefState) end end)
end
function ENT:OnRemove()
	if IsValid(self.clent) then
		self.clent:Remove() 
	end
end
local trw1 = {}
local trw2 = {}
function ENT:Think()
	if !self.GetEndPos then return true end
	if !IsValid(self) then self.clent:Remove() return true end
	if SERVER and (!IsValid(self.Owner) or !IsValid(self.wep)) then
		self:Remove()
	end
	if SERVER then
		util.TraceHull({
			start = self:GetEndPos(),
			endpos = self:GetEndPos(),
			mins = Vector(-15,-15,-15),
			maxs = Vector(15,15,15),
			output = trw1
		})
		util.TraceHull({
			start = self:GetPos(),
			endpos = self:GetPos(),
			mins = Vector(-15,-15,-15),
			maxs = Vector(15,15,15),
			output = trw2
		})
		if !(trw1.HitWorld and trw2.HitWorld) then
			self:Remove()
		end
	end
	if CLIENT then
		
	self.Size = math.Approach( self.Size, 1, 10*FrameTime() )
	self.MainStart = self.Entity:GetEndPos()
	self.MainEnd = self:GetPos()
	self.Normal = (self.MainEnd - self.MainStart):GetNormalized()
	self.dAng = (self.MainEnd - self.MainStart):GetNormalized():Angle()
	self:SetRenderBoundsWS( self:GetPos(), self:GetEndPos())

	end
	if SERVER and #ents.FindAlongRay(self:GetPos(),self:GetEndPos()) > self.DefState then
	self.Owner.BarrierTraceTable = self.Owner.BarrierTraceTable or {}
	util.TraceLine( {
				start = self:GetPos(),
				endpos = self:GetEndPos(), 
				filter = function(ent) if ent:GetClass() == "emerald_splash_proj" or ent == self.wep.Stand then return false else return true end end,
				ignoreworld = true,
				mask = MASK_ALL,
				output = self.Owner.BarrierTraceTable
	} )
	
	if self.Owner.BarrierTraceTable.Entity:IsValid() and self.Owner.BarrierTraceTable.Entity:GetClass() == "stand" then
		self.Owner.BarrierTraceTable.Entity = self.Owner.BarrierTraceTable.Entity.Owner
	end
	self.SplashTimer = self.SplashTimer or CurTime()
	if self.Owner.BarrierTraceTable.Entity:IsValid() and (self.Owner.BarrierTraceTable.Entity:Health() > 0) and CurTime() >= self.SplashTimer and self.Owner.BarrierTraceTable.Entity != self.Owner then
	if(self.Owner.BarrierTraceTable.Entity:IsPlayer() and (self.Owner.BarrierTraceTable.Entity:GetActiveWeapon().GetActive and self.Owner.BarrierTraceTable.Entity:GetActiveWeapon():GetActive())) then 
		self:Remove()
	end
		if GetConVar("gstands_time_stop"):GetInt() != 1 then
		self.CaC.a = 255
		local dist = self:GetPos():Distance(self.Owner.BarrierTraceTable.HitPos)
		local vel = self.Owner.BarrierTraceTable.Entity:GetVelocity()/self.Length * dist
		vel = vel + self.dAng:Up() * 15
		self.BounceTimer = self.BounceTimer or CurTime()
		if CurTime() >= self.BounceTimer then
			self.Owner.BarrierTraceTable.Entity:SetVelocity(vel)
			self.BounceTimer = CurTime() + 0.2
		end
		self:Splash(self.Owner.BarrierTraceTable, 1, false, vel)
		self.SplashTimer = CurTime() + 0.05
		elseif SERVER then
			self.Owner.BarrierTraceTable.Entity:EmitStandSound("physics/glass/glass_bottle_break"..math.random(1,2)..".wav")
			self:Remove()
		end
	end
	end
		self:SetAlph(1)
	if SERVER and self.quick then
		self.lifetime = self.lifetime or CurTime() + 5
		self:SetAlph((self.lifetime - CurTime())/5)
		if CurTime() > self.lifetime then
			self:Remove()
		end
	end
	self:NextThink(CurTime())
	return true
end


function ENT:Splash(tr, iterate, location, velovr)
			local laser
			if SERVER then
			laser = ents.Create("emerald_splash_proj")
			end
			local barriers = ents.FindByClass("hg_barrier")
			local ths = table.KeyFromValue(barriers, self)
			local trWor = util.TraceLine( {
				start = tr.HitPos,
				endpos = self:GetPos(), 
				filter = function(ent) if ent:IsWorld() then return true else return false end end,
				ignoreworld = false,
				mask = MASK_ALL
			} )
			if IsValid(laser) then
				self:EmitStandSound(Splash)
				local td = {
					start = trWor.HitPos,
					endpos = trWor.HitPos,
					mins = Vector(-15,-15,-15),
					maxs = Vector(15,15,15),
				}
				local trw = util.TraceHull(td)
				if location then
					laser:SetPos(LerpVector(0.5, self:GetPos(), self:GetEndPos()))
				else
				local norm = (self:GetEndPos() - self:GetPos()):GetNormalized()
				laser:SetPos(trWor.HitPos)
				end
				laser:SetOwner(self.Owner)
				local vel = Vector(0,0,0)
				targ = tr.HitPos
				laser.cooldown = trw.Hit
				if IsValid(tr.Entity) then
					vel = tr.Entity:GetVelocity()/15
					if tr.Entity:GetPhysicsObject():IsValid() then
						vel = tr.Entity:GetPhysicsObject():GetVelocity()
					end
				end
				if velovr then
					vel = velovr
					tr.Fraction = 1
				end
			laser:SetAngles((((laser:GetPos() - (targ + (vel * (tr.Fraction)))) ):GetNormalized() * -1):Angle())
				laser:Spawn()
				laser:Activate()
			end
		end


function ENT:DrawMainBeamOtherClients( StartPos, EndPos, dist )

	if self.CaC.a >= 1 then
	self.CaC.a = self.CaC.a - 0.5
	end
	self:DrawRope(EndPos, StartPos, self.CaC.a/255)

end

function ENT:DrawRope(EndPos, StartPos, alpha)
		self.clent:SetupBones()

	self.clent:SetPos(StartPos)
	local norm = (EndPos - StartPos):GetNormalized()
	local ang = norm:Angle()

	ang:RotateAroundAxis(ang:Right(), -90)
	self.clent:SetAngles(ang)
	for i = 0, self.clent:GetBoneCount() - 1 do
		local pos1, ang1 = self.clent:GetBonePosition(i)
		self.clent:SetBonePosition(i, LerpVector(1 - i, EndPos + self.Normal * 10, self.clent:GetPos()), ang1)
		self.LastPos = {}
	end
	render.SetBlend(alpha)
	self.clent:DrawModel()

end
function ENT:Draw()
	if CLIENT and LocalPlayer():GetActiveWeapon() then
		if LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then
			if self.Owner and self.Owner:IsValid() then
				local Owner = self.Owner
				local StartPos = self.Entity:GetEndPos()
				if StartPos == Vector(0,0,0) then return end
				local EndPos = self:GetPos()
				if (EndPos == Vector(0,0,0)) then return end
				if (EndPos:Distance(StartPos)) <= 1 then return end

				local TexOffset = CurTime() * -2

				local Distance = EndPos:Distance( StartPos ) * self.Size
				local a = self:GetAlph()
				self.dAng = (EndPos - StartPos):Angle():Forward()
				if LocalPlayer() == Owner then
					self:DrawRope(EndPos, StartPos, a)
				else
					self:DrawMainBeamOtherClients( StartPos, EndPos, Distance )
				end
			end
		end
	end
end
