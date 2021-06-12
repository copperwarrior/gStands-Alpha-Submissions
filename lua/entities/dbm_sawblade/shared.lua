ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Saw"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Trail")
end
local Saw = Sound("weapons/dbm/saw.wav")
if SERVER then
	
	AddCSLuaFile("shared.lua")
	
	function ENT:Initialize()
		self:SetModel("models/heg/emerald.mdl")
		self:SetSolid(SOLID_OBB)
		self:SetMoveType(MOVETYPE_NOCLIP)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		self:DrawShadow(false)
		self.wep = self.Owner:GetActiveWeapon()
		self:SetVelocity(self:GetForward() * 2000)
		local color = Color(0, 150, 0, 175)
		if self.wep.GetStand then
			color = gStands.GetStandColorTable("models/player/dbm/dbm.mdl", self.wep:GetStand():GetSkin())
			self:SetColor(color ) 
			color.a = 75
		end
		self.Owner:EmitStandSound(Saw)
		self:SetTrail(util.SpriteTrail(self, 0, color, true, 85,0, 0.5, 1/(85) * 0.5, "effects/beam_generic01.vmt" ))
		self.NPCTable = {}
		for k,v in pairs(ents.GetAll()) do
			if v:IsNPC() or v:IsPlayer() then
				table.insert(self.NPCTable, v)
			end
		end
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
			
			self.lifetime =  CurTime() + 3
			else
			self.lifetime = self.lifetime or CurTime() + 3
		end
		if CurTime() > self.lifetime then
			self:Disable()
		end
		self.wep = self.wep or self.Owner:GetActiveWeapon() or NULL
		local notarger = NULL
		if self.wep.GetStand then
			notarger = self.wep:GetStand() 
		end
		local closest = self:GetClosest(self.Owner, self:GetPos())
		if IsValid(closest) then
		local norm = (closest:WorldSpaceCenter() - self:GetPos()):GetNormalized()
		local ang = norm:Angle()
		ang.r = 90
		self:SetAngles(LerpAngle(0.2, self:GetAngles(), ang ))
		end
		if self:GetVelocity():LengthSqr() < 1550000 then
			self:SetVelocity(self:GetForward() * 50)
		end
		local HitEnts = {self, self.Owner, notarger}

				local td = {
					start = self:GetPos(),
					endpos = self:GetPos(),
					mins = Vector(-55,-55,-55),
					maxs = Vector(55,55,55),
					filter = HitEnts,
					mask = MASK_SHOT_HULL,
					collisiongroup = COLLISION_GROUP_PROJECTILE,
				}
				local tr = util.TraceHull(td)
				local twd = {
					start = self:GetPos(),
					endpos = self:GetPos() + self:GetForward() * 50,
					mins = Vector(-1,-1,-1),
					maxs = Vector(1,1,1),
					filter = HitEnts,
					mask = MASK_SHOT_HULL,
					collisiongroup = COLLISION_GROUP_PROJECTILE,
				}
				local tw = util.TraceLine(twd)
				if tw.HitWorld then
					self:Disable()
				end
				table.insert(HitEnts, tr.Entity)
				if tr.Entity:IsValid() and tr.Entity:GetClass() != self:GetClass() then
					if SERVER and !IsValid(GetGlobalEntity( "Time Stop" )) and IsValid(tr.Entity) and !tr.Entity:IsNPC() and !tr.Entity:IsPlayer() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue( "explosion", "2" ) tr.Entity:SetKeyValue( "gibdir", tostring(self:GetAngles())) tr.Entity:Fire( "Break" ) end
					local Ent = tr.Entity
					dmgInfo = DamageInfo()
					dmgInfo:SetAttacker(self.Owner or self)
					dmgInfo:SetDamage(200)
					dmgInfo:SetInflictor( self.wep or self )
					Ent:TakeDamageInfo(dmgInfo)
					self:Disable()
			end
	
				
		self:NextThink(CurTime())
		return true
	end
	
	function ENT:Disable()
		self:Remove()
	end
	
	function ENT:OnTakeDamage()
	end
end

function ENT:GetClosest(ply, vec)
	local closestply
	local closestdist
	
	for k, v in pairs(self.NPCTable or player.GetAll()) do
		if IsValid(v) and v:WaterLevel() > 0 and v != ply and v:Health() > 0 and v:GetPos():Distance(self:GetPos()) < 1500 then
			local dist = vec:DistToSqr(v:GetPos())
			if not closestdist then
				closestdist = dist
				closestply = v
			end
			if dist < closestdist then
				closestdist = dist
				closestply = v
			end
		end
	end
    if closestply then
		return closestply
	end
end

if CLIENT then
	/*---------------------------------------------------------
	Name: ENT:Draw()
	---------------------------------------------------------*/
	function ENT:Draw()
		self.wep = self.wep or self.Owner:GetActiveWeapon()
		if LocalPlayer():GetActiveWeapon() and LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then
			self.Aura = self.Aura or CreateParticleSystem(self, "sawblade", PATTACH_POINT_FOLLOW, 1)
			self.Aura:SetControlPoint(1, gStands.GetStandColor("models/player/dbm/dbm.mdl", self.wep:GetStand():GetSkin()))
		end
		if GetConVar("gstands_show_hitboxes"):GetBool() then
			local cpos, cang = self:GetPos()
			render.DrawWireframeBox(cpos, Angle(0,0,0), Vector(-2,-2,-2), Vector(2,2,2), Color(0,255,0,255), true)
		end
	end
end		