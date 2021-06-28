ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Blast"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Trail")
end
local Waterblast = Sound("weapons/dbm/waterblast.wav")
local WaterImpact = Sound("weapons/dbm/waterimpact.wav")
if SERVER then
	
	AddCSLuaFile("shared.lua")
	
	function ENT:Initialize()
		self:SetModel("models/heg/emerald.mdl")
		self:SetSolid(SOLID_OBB)
		self:SetMoveType(MOVETYPE_NOCLIP)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		self:DrawShadow(false)
		self.wep = self.Owner:GetActiveWeapon()
		self:SetVelocity(self:GetForward() * 5000)
		local color = Color(0, 150, 0, 175)
		if self.wep.GetStand then
			color = gStands.GetStandColorTable("models/player/dbm/dbm.mdl", self.wep:GetStand():GetSkin())
			self:SetColor(color ) 
		end
		self.Owner:EmitSound(Waterblast)
		self:SetTrail(util.SpriteTrail(self, 0, color, true, 85,0, 0.5, 1/(85) * 0.5, "effects/beam_generic01.vmt" ))
		self:NextThink(CurTime())
		self:Think()
	end
	/*---------------------------------------------------------
	Name: ENT:Think()
	---------------------------------------------------------*/
	function ENT:Think()
		if not IsValid(self) then return end
		if not IsValid(self.Entity) then return end
		if GetConVar("phys_timescale"):GetInt() == 0 then
			
			self.lifetime =  CurTime() + 1
			else
			self.lifetime = self.lifetime or CurTime() + 1
		end
		if CurTime() > self.lifetime or self:WaterLevel() < 1 then
			self:Disable()
			return true
		end
		self.wep = self.wep or self.Owner:GetActiveWeapon() or NULL
		local notarger = NULL
		if self.wep.GetStand then
			notarger = self.wep:GetStand() 
		end		
		if self:GetVelocity():LengthSqr() < 5550000 then
		self:SetVelocity(self:GetForward() * 300)
		end
		local HitEnts = {self, self.Owner, notarger}

				local td = {
					start = self:GetPos(),
					endpos = self:GetPos(),
					mins = Vector(-155,-155,-155),
					maxs = Vector(155,155,155),
					filter = HitEnts,
					mask = MASK_SHOT_HULL,
					collisiongroup = COLLISION_GROUP_PROJECTILE,
					ignoreworld = true
				}
				debugoverlay.SweptBox(td.start, td.endpos, td.mins, td.maxs, Angle())
				local tr = util.TraceHull(td)
				local twd = {
					start = self:GetPos(),
					endpos = self:GetPos() + self:GetForward() * 50,
					mins = Vector(-1,-1,-1),
					maxs = Vector(1,1,1),
					filter = HitEnts,
					mask = MASK_NPCWORLDSTATIC,
				}
				local tw = util.TraceLine(twd)
				if tw.HitWorld then
					self:Disable()
				end
				self.targets = self.targets or {}
				if tr.Entity:IsValid() and tr.Entity:GetClass() != self:GetClass() then
					local Ent = tr.Entity
					dmgInfo = DamageInfo()
					dmgInfo:SetAttacker(self.Owner or self)
					dmgInfo:SetDamage(1)
					dmgInfo:SetInflictor( self.wep or self )
					Ent:TakeDamageInfo(dmgInfo)
					table.insert(self.targets, Ent)
			end
			for k,v in pairs(self.targets) do
				if v:IsValid() then
					if v:IsPlayer() then
						v:SetVelocity(v:GetVelocity() * -2)
					end
					v:SetVelocity(self:GetVelocity() * 0.05)
					if v:GetPhysicsObject():IsValid() and !v:IsPlayer() then
						v:GetPhysicsObject():SetVelocity(self:GetVelocity())
					end
				end
			end
				
		self:NextThink(CurTime())
		return true
	end
	
	function ENT:Disable()
		self:Remove()
	end
	
	function ENT:OnRemove()
		self.targets = self.targets or {}
		for k,v in pairs(self.targets) do
			local mins, maxs = v:GetCollisionBounds()
			local tr = util.TraceHull({
				start = self:GetPos(),
				endpos = self:GetPos(),
				mins = mins * 2,
				maxs = maxs * 2,
				filter = v,
				mask = MASK_NPCWORLDSTATIC
			})
			if v:IsPlayer() then
					v:SetVelocity(-v:GetVelocity() * 0.9)
				end
			if tr.Hit and v:GetPos():Distance(self:GetPos()) < 500 then
				dmgInfo = DamageInfo()
				dmgInfo:SetAttacker(self.Owner or self)
				dmgInfo:SetDamage(150)
				dmgInfo:SetInflictor( self.wep or self )
				v:TakeDamageInfo(dmgInfo)
				v:EmitSound(WaterImpact)
			end
		end
	end
end

if CLIENT then
	/*---------------------------------------------------------
	Name: ENT:Draw()
	---------------------------------------------------------*/
	function ENT:Draw()
		self.wep = self.wep or self.Owner:GetActiveWeapon()
		if LocalPlayer():GetActiveWeapon() and LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then
			self.Aura = self.Aura or CreateParticleSystem(self, "blast", PATTACH_POINT_FOLLOW, 1)
			self.Aura:SetControlPoint(1, gStands.GetStandColor("models/player/dbm/dbm.mdl", self.wep:GetStand():GetSkin()))
			self.Aura:SetControlPointUpVector(0, self:GetForward())
		end
		if GetConVar("gstands_show_hitboxes"):GetBool() then
			local cpos, cang = self:GetPos()
			render.DrawWireframeBox(cpos, Angle(0,0,0), Vector(-2,-2,-2), Vector(2,2,2), Color(0,255,0,255), true)
		end
	end
end		