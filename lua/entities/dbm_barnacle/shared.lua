ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Barnacles"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Target")
end

local Attach = Sound("weapons/dbm/barnacleattach.wav")
local Crack = Sound("dbm.crack")
local Welcome = Sound("weapons/dbm/welcome.wav")
AddCSLuaFile("shared.lua")

function ENT:Initialize()
	self:SetModel("models/dbm/dbm_barnacle.mdl")
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:DrawShadow(true)
	self.wep = self.Owner:GetActiveWeapon()
	self.StartTime = CurTime()
	self:GetTarget():EmitSound(Attach)
	if CLIENT then
		self:SetRenderBounds(self:GetTarget():GetRenderBounds())
	end
	if self:GetTarget():IsPlayer() then
		local name = self:GetTarget():GetName()
		hook.Add("SetupMove", "BarnaclesSlowing"..name, function(ply, mv, cmd)
			if ply:IsValid() and self:IsValid() and ply == self:GetTarget() then
				mv:SetMaxSpeed( mv:GetMaxSpeed() / self:CalcLevel() )
				mv:SetMaxClientSpeed( mv:GetMaxClientSpeed() / self:CalcLevel() )
				elseif ply:IsValid() and (self:IsValid()) then
				hook.Remove("SetupMove", "BarnaclesSlowing"..name)
			end
		end)
	end
	
	if self:GetTarget():IsStand() then
		local name = self:GetTarget():GetName()
		hook.Add("SetupMove", "BarnaclesSlowing"..name, function(ply, mv, cmd)
			if ply:IsValid() and self:IsValid() and ply == self:GetTarget().Owner then
				mv:SetMaxSpeed( mv:GetMaxSpeed() / self:CalcLevel() )
				mv:SetMaxClientSpeed( mv:GetMaxClientSpeed() / self:CalcLevel() )
				elseif ply:IsValid() and (self:IsValid()) then
				hook.Remove("SetupMove", "BarnaclesSlowing"..name)
			end
		end)
	end
	local hooktag = self:EntIndex()
	hook.Add("EntityTakeDamage", "OhBarnaclesCutsDamage"..hooktag, function(targ, dmg)
		if IsValid(self) and IsValid(self) then
			if dmg:GetAttacker() == self:GetTarget() then
				dmg:SetDamage(dmg:GetDamage()/(self:CalcLevel()/10))
			end
		else
			hook.Remove("EntityTakeDamage", "OhBarnaclesCutsDamage"..hooktag)
		end
	end)
	self:NextThink(CurTime())
	self:Think()
end
/*---------------------------------------------------------
Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
	self.Level = self:CalcLevel()
	if SERVER and IsValid(self:GetTarget()) then
		local targ = self:GetTarget()
		if targ:IsStand() then
			targ = self:GetTarget().Owner
		end
		if (IsValid(self:GetTarget()) and self:GetTarget():Health() < 1) or !IsValid(self.Owner) or (IsValid(self.Owner) and self.Owner:Health() < 1) then
			self:Remove()
		end
		targ:SetVelocity((self.Owner:WorldSpaceCenter() - targ:WorldSpaceCenter()):GetNormalized() * math.max(math.min(self.Level * 5, 50), 10))
		if targ:GetPhysicsObject():IsValid() then
		targ:GetPhysicsObject():SetVelocity((self.Owner:WorldSpaceCenter() - targ:WorldSpaceCenter()):GetNormalized() * math.max(math.min(self.Level * 5, 50), 10))
		end
		if targ:IsPlayer() and targ:InVehicle() and targ:GetVehicle():GetPhysicsObject():IsValid() and SERVER then
			targ:GetVehicle():GetPhysicsObject():SetVelocity((self.Owner:WorldSpaceCenter() - targ:WorldSpaceCenter()):GetNormalized() * math.max(math.min((self.Level)/10, 25), 10) * 2)
		end
		self.DelayDmg = self.DelayDmg or CurTime()
		if targ:Health() and SERVER and self.DelayDmg < CurTime() then
			local dmg = DamageInfo()
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self.wep)
			dmg:SetDamage(self.Level/10, 25)
			dmg:SetDamageType(DMG_SLASH)
			self:GetTarget():TakeDamageInfo(dmg)
			if self.DelayInterval then
				self.DelayInterval = math.max(self.DelayInterval - 0.5, 0.5)
				else
				self.DelayInterval = 5
			end
			self.DelayDmg = CurTime() + self.DelayInterval
		end
		if self:GetTarget():WaterLevel() > 0 and !self.Welcomed then
			self.Welcomed = true
			self.Owner:EmitSound(Welcome)
		end
		
	end
	if SERVER then
		self:NextThink(CurTime())
	end
	return true
end

function ENT:CalcLevel()
	local lv = CurTime() - self.StartTime
	lv = math.Round(lv)/2
	lv = math.Clamp(lv, 1, 100)
	return lv
end

function ENT:CalcNewPosition(override)
	local pos
	if IsValid(self:GetTarget()) then
	pos = self:GetTarget():WorldSpaceCenter() + VectorRand() * self:GetTarget():BoundingRadius()
	end
	if override then
		pos = override
	end
	local trace = util.TraceLine( {
		start = pos,
		endpos = self:GetTarget():WorldSpaceCenter(),
		filter = function(ent) if ent != self:GetTarget() then return false end return true end,
		mask = MASK_SHOT_HULL,
		ignoreworld = true
	} )
	local ret = Vector(0,0,0)
	if trace.Hit then
		ret = self:GetTarget():WorldToLocal(trace.HitPos)
	else
		ret = self:GetTarget():WorldToLocal(self:GetTarget():WorldSpaceCenter())
	end
	self:EmitSound(Crack)
	return ret
end

function ENT:Disable()
	self:Remove()
end
function ENT:OnRemove()
	self:GetTarget().Barnacled = false
end
if CLIENT then
	function ENT:Draw()
		for i = 1, self:CalcLevel() do
			self.Positions = self.Positions or {}
			self.Angles = self.Angles or {}
			self.Scales = self.Scales or {}
			if !self.Positions[i] then
				local override = nil
				if i == 1 then
					override = self:GetPos()
				end
				self.Positions[i] = self:CalcNewPosition(override)
				self.Scales[i] = 0
			end
			if !self.Angles[i] then
				self.Angles[i] = AngleRand()
			end
			for k,v in pairs(self.Scales) do
				self.Scales[k] = Lerp(0.01, v, 1)
			end
			self:SetPos(self:GetTarget():LocalToWorld(self.Positions[i]))
			self:SetAngles(self.Angles[i])
			self:SetModelScale(self.Scales[i])
			self:SetupBones()
			self:DrawModel()
		end
	end
end		