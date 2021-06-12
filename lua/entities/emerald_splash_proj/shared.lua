ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Emerald"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Trail")
end
local Hit = Sound("weapons/hierophant/splashimpact.wav")
local Stab = Sound("weapons/hierophant/tentaclestab.wav")

function ENT:Initialize()
		
		self:SetModel("models/heg/emerald.mdl")
		
		self:SetSolid(SOLID_OBB)
		
		self:SetMoveType(MOVETYPE_NOCLIP)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		self:DrawShadow(false)
		self.wep = self.Owner:GetActiveWeapon()
		self:SetHealth(1)
		self:SetVelocity(self:GetForward() * 2000)
		
		local color = Color(0, 150, 0, 175)
		if self.wep.GetStand then
			color = gStands.GetStandColorTable("models/player/heg/heg.mdl", self.wep:GetStand():GetSkin())
			self:SetColor(color ) 
		end
					
	self:NextThink(CurTime())
end
	
if SERVER then
	
	AddCSLuaFile("shared.lua")
	
	/*---------------------------------------------------------
	Name: ENT:Think()
	---------------------------------------------------------*/
	local timescale = GetConVar("phys_timescale")
	local trdata = {
		mins = Vector(-5,-5,-5),
		maxs = Vector(5,5,5),
		mask = MASK_ALL,
		collisiongroup = COLLISION_GROUP_PROJECTILE,
		ignoreworld = true,
	}
	function ENT:Think()
		if not IsValid(self) then return end
		if not IsValid(self.Entity) then return end
		
		if timescale:GetBool() then
			
			self.lifetime =  CurTime() + 2
			else
			self.lifetime = self.lifetime or CurTime() + 2
			self.cooldown = true
		end
		if self.cooldown and CurTime() - self.lifetime >= -1.5 then
			self.cooldown = false
		end
		if CurTime() > self.lifetime then
			self:Remove()
		end
		
		self.wep = self.wep or self.Owner:GetActiveWeapon() or NULL
		local notarger = NULL
		if self.wep.GetStand and IsValid(self.wep:GetStand()) then
			notarger = self.wep:GetStand() 
			else
			self:Remove()
		end
		self.Owner.SplashTrace = self.Owner.SplashTrace or {}
		self.HitEnts = self.HitEnts or {self, self.Owner, notarger}
		trdata.start = self:GetPos()
		trdata.endpos = self:GetPos() + self:GetVelocity() * FrameTime()
		trdata.filter = self.HitEnts
		trdata.output = self.Owner.SplashTrace
		
		util.TraceHull(trdata)
		if self.Owner.SplashTrace.Entity:IsValid() and self.Owner.SplashTrace.Entity:GetClass() != self:GetClass() then
			if SERVER and !IsValid(GetGlobalEntity( "Time Stop" )) and IsValid(self.Owner.SplashTrace.Entity) and !self.Owner.SplashTrace.Entity:IsNPC() and !self.Owner.SplashTrace.Entity:IsPlayer() and self.Owner.SplashTrace.Entity:GetKeyValues()["health"] > 0 then self.Owner.SplashTrace.Entity:SetKeyValue( "explosion", "2" ) self.Owner.SplashTrace.Entity:SetKeyValue( "gibdir", tostring(self:GetAngles())) self.Owner.SplashTrace.Entity:Fire( "Break" ) end
			local Ent = self.Owner.SplashTrace.Entity
			dmgInfo = DamageInfo()
			dmgInfo:SetAttacker(self.Owner or self)
			dmgInfo:SetDamage(25)
			dmgInfo:SetInflictor( self or self )
			Ent:TakeDamageInfo(dmgInfo)
			self:Remove()
			self:EmitStandSound("physics/glass/glass_impact_bullet"..math.random(1,4)..".wav")
			self:EmitStandSound(Hit)
			self:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav")
		end
		if self.lifetime - CurTime() >= 0.1 and bit.band( util.PointContents( self:GetPos() ), CONTENTS_SOLID ) == CONTENTS_SOLID then
			self:Remove()
			if self.quick and math.random(0,1) == 1 then
				local tr = table.Copy(self.Owner.SplashTrace)
				self.wep:Barrier(tr, true)
				self.wep.BarrierList[#self.wep.BarrierList]:EmitStandSound(Stab)
			end
			self:EmitStandSound("physics/glass/glass_impact_bullet"..math.random(1,4)..".wav")
		end 
		if !self.Fast then
			self:NextThink(CurTime())
			else
			self:NextThink(CurTime() + 0.4)
		end
		return true
	end
	
	function ENT:Disable()
		self:Remove()
	end
	
	function ENT:OnTakeDamage()
		self:Remove()
		self:EmitStandSound("physics/glass/glass_impact_bullet"..math.random(1,4)..".wav")
	end
end

if CLIENT then
	/*---------------------------------------------------------
	Name: ENT:Draw()
	---------------------------------------------------------*/
	local convar = GetConVar("gstands_show_hitboxes")
	function ENT:Draw()
		self.skin = self.skin or self.Owner:GetActiveWeapon():GetStand():GetSkin()
		self.startpos = self.startpos or self:GetPos()
		if LocalPlayer():GetActiveWeapon() and LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then
			if !self.Owner:GetNoDraw() then
				self.Entity:DrawModel()
				self.Aura = self.Aura or CreateParticleSystem(self, "emerald_trail", PATTACH_POINT_FOLLOW, 1)
				if self.Aura then
					self.Aura:SetControlPoint(1, gStands.GetStandColor("models/player/heg/heg.mdl", self.skin))
				end
			end
		end 
		self:SetupBones()
		
		if convar:GetBool() then
			local cpos, cang = self:GetPos()
			render.DrawWireframeBox(cpos, Angle(0,0,0), Vector(-2,-2,-2), Vector(2,2,2), Color(0,255,0,255), true)
		end
	end
	function ENT:OnRemove()
		if self.Aura then
		self.Aura:StopEmission()
		end
		end
end		