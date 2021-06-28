ENT.Type 			= "anim"
ENT.PrintName		= "Sunlaser"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 

function ENT:SetupDataTables()
	self:NetworkVar("Float", 1, "DisLifetime")
end
local Impact = Sound("sun.impact")
if SERVER then

AddCSLuaFile("shared.lua")
function ENT:Initialize()
	
	self:SetModel("models/heg/emerald.mdl")
			self:SetSolid(SOLID_OBB)
			self:SetMoveType(MOVETYPE_NOCLIP)
			self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
			self:DrawShadow(false)
			self.wep = self.Owner:GetActiveWeapon()
			self:SetHealth(1)
			self:SetVelocity(self:GetForward() * 8000)
            util.SpriteTrail(self, 0, Color(255,200,100,255), true, 13,0, 0.5, 1/(15) * 0.5, "effects/beam_generic01.vmt" )
	self:NextThink(CurTime())
	--self:SetColor(Color(0,0,0))
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
	
	if not IsValid(self) then return end
		if not IsValid(self.Entity) then return end
		if not self.wep and not self.wep.GetSun and not IsValid(self.wep:GetSun()) then self:Remove() return end
		if GetConVar("phys_timescale"):GetInt() == 0 then
			
			self.lifetime =  CurTime() + 5
			else
			self.lifetime = self.lifetime or CurTime() + 5
			self.cooldown = true
		end
		if self.cooldown and CurTime() - self.lifetime >= -1.5 then
			self.cooldown = false
		end
		self.StartPos = self:GetPos()
		if CurTime() > self.lifetime then
			self:Disable(self:GetPos())
			self:SetMoveType(MOVETYPE_NONE)
		end
		if !self.Disabled then
		self.wep = self.wep or self.Owner:GetActiveWeapon() or NULL
		local notarger = NULL
		if IsValid(self.wep) and self.wep.GetSun and IsValid(self.wep:GetSun()) then
			notarger = self.wep:GetSun()
		end
		local HitEnts = {self, self.Owner, notarger}

				local td = {
					start = self:GetPos(),
					endpos = self:GetPos(),
					mins = Vector(-15,-15,-15),
					maxs = Vector(15,15,15),
					filter = HitEnts,
					mask = MASK_SHOT_HULL,
					collisiongroup = COLLISION_GROUP_PROJECTILE,
				}
				local tr = util.TraceHull(td)
				if tr.HitWorld and !self.Disabled then
				util.Decal("Scorch", self:GetPos() - self:GetVelocity(), tr.HitPos + self:GetVelocity())
				end
				table.insert(HitEnts, tr.Entity)
				if tr.Entity:IsValid() and tr.Entity:GetClass() != self:GetClass() then
					if SERVER and !IsValid(GetGlobalEntity( "Time Stop" )) and IsValid(tr.Entity) and !tr.Entity:IsNPC() and !tr.Entity:IsPlayer() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue( "explosion", "2" ) tr.Entity:SetKeyValue( "gibdir", tostring(self:GetAngles())) tr.Entity:Fire( "Break" ) end
					local Ent = tr.Entity
					dmgInfo = DamageInfo()
					dmgInfo:SetAttacker(self.Owner or self)
					dmgInfo:SetDamage(35)
					dmgInfo:SetInflictor( self.wep)
					Ent:TakeDamageInfo(dmgInfo)
					if Ent:IsPlayer() then
						Ent:SetNWFloat("gStandsSunStroke", Ent:GetNWFloat("gStandsSunStroke") + 1)
					end
					Ent:Ignite(15, 15)
					self:Disable(tr.HitPos)
					self:SetMoveType(MOVETYPE_NONE)
					self:EmitStandSound(Impact)
			end
		if self.lifetime - CurTime() >= 0.1 and bit.band( util.PointContents( self:GetPos() ), CONTENTS_SOLID ) == CONTENTS_SOLID then
			self:Disable(self:GetPos())
			self:SetMoveType(MOVETYPE_NONE)
			self:EmitStandSound(Impact)
		end 
		end 
		if self.Disabled then
			local mult = self:GetDisLifetime() - CurTime()
			local td = {
					start = self:GetPos(),
					endpos = self:GetPos(),
					mins = Vector(-17 * mult,-17 * mult,-17 * mult),
					maxs = Vector(17 * mult,17 * mult,17 * mult),
					filter = HitEnts,
					mask = MASK_ALL,
					collisiongroup = COLLISION_GROUP_PROJECTILE,
					ignoreworld = true
				}
				local tr = util.TraceHull(td)
				if tr.Hit then
					local Ent = tr.Entity
					dmgInfo = DamageInfo()
					dmgInfo:SetAttacker(self.Owner or self)
					dmgInfo:SetDamage(10 * mult)
					dmgInfo:SetInflictor( self or self )
					Ent:TakeDamageInfo(dmgInfo)
					Ent:Ignite(7 * mult, 15)
				end
			self:SetPos(self.DisablePos)
		end
		self:NextThink(CurTime())
		return true
end

function ENT:Disable(pos)
	if self.wep and self.wep.GetSun and IsValid(self.wep:GetSun()) then
	local tr = util.TraceLine({
		start=self.wep:GetSun():GetPos(),
		endpos = pos,
		filter = {self, self.wep:GetSun()},
		collisiongroup = COLLISION_GROUP_PROJECTILE
		})
	if tr.HitWorld then
	self.Disabled = true
	self.DisablePos = tr.HitPos
	self:SetPos(pos)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetVelocity(self:GetVelocity():GetNormalized())
	self:SetDisLifetime(CurTime() + 2)
	timer.Simple(2, function()
	if IsValid(self) then
	self:Remove()
	if IsValid(self.LavaModel) then
		self.LavaModel:Remove()
	end
	end
	end)
	else
	self:Remove()
	end
	end
end

end

if CLIENT then
/*---------------------------------------------------------
   Name: ENT:Draw()
---------------------------------------------------------*/
local mat = Material("effects/brightglow_y_nomodel")
local mat2 = Material("models/gstands_sun/gstands_sunlava")
function ENT:Draw()
	local tr = util.TraceLine({
	start = self:GetPos(),
	endpos = self:GetPos() + self:GetForward() * 55,
	collisiongroup=COLLISION_GROUP_DEBRIS})
	local mult = 1
	
	--self:DrawModel()
	if tr.HitWorld then
		mult = (self:GetDisLifetime() - CurTime()) * 2
		if !self.PCFed then
			ParticleEffect("sunlaser_impact", tr.HitPos, tr.Normal:Angle())
					self.PCFed = true

		end
		else
		render.SetMaterial(mat)
	render.DrawSprite(self:GetPos(), 32 * mult,32 * mult, Color(255,255,255))
	end
	if tr.HitWorld then
		self.HitNormal = tr.HitNormal
		self.LavaModel = self.LavaModel or ClientsideModel("models/sun/gstands_sunlava.mdl", RENDERGROUP_OPAQUE)
		local ang = tr.HitNormal:Angle()
		ang:RotateAroundAxis(tr.HitNormal:Angle():Right(), -90)
		ang:RotateAroundAxis(tr.HitNormal, math.random(0,180))
		self.LavaModelAng = self.LavaModelAng or ang
		self.LavaModelScale = self.LavaModelScale or math.random(4,7)
		self.LavaModel:SetAngles(self.LavaModelAng)
		self.LavaModel:SetModelScale(self.LavaModelScale)
		self.LavaModel:SetParent(self)
	self.LavaModel:SetPos(self:GetPos() - Vector(0,0,13 - mult * 4))
		render.SuppressEngineLighting(true)
		self.LavaModel:DrawModel()
		self.LavaModel:SetNoDraw(true)
		render.SuppressEngineLighting(false)
		self.LavaModel:SetFlexWeight(0, Lerp(mult, 1, 0))
	end
end
function ENT:OnRemove()
	if IsValid(self.LavaModel) then
		self.LavaModel:Remove()
	end
end
end