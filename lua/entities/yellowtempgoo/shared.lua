ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Goo"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local gooloop = Sound( "weapons/temperance/goo_loop.wav" )
local Dissipate2 = Sound( "yt.dissipate" )


function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Target")
	self:NetworkVar("Int", 1, "Level")
end

AddCSLuaFile("shared.lua")

function ENT:Initialize()
	self:SetModel("models/yellowtemperance/ytgoo.mdl")
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:DrawShadow(true)
	self.wep = self.Owner:GetActiveWeapon()
	self.StartTime = CurTime()
	if CLIENT then 
		self:SetRenderBounds(self:GetTarget():GetRenderBounds())
	end
	self:NextThink(CurTime())
	self:Think()
end
/*---------------------------------------------------------
Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
	if SERVER and IsValid(self:GetTarget()) then
		local targ = self:GetTarget()
		if targ:IsStand() then
			targ = self:GetTarget().Owner
		end
		if (IsValid(self:GetTarget()) and self:GetTarget():Health() < 1) or !IsValid(self.Owner) or (IsValid(self.Owner) and self.Owner:Health() < 1) then
			self:Remove()
		end
		self.DelayDmg = self.DelayDmg or CurTime()
		if targ:Health() and SERVER and self.DelayDmg <= CurTime() then
			local dmg = DamageInfo()
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self.wep)
			dmg:SetDamage(self:GetLevel())
			if self:GetTarget():IsOnFire() or (self:GetTarget():IsPlayer() and self:GetTarget():IsFrozen()) then
				dmg:SetDamage(self:GetLevel() * 2)
			end
			dmg:SetDamageType(DMG_DIRECT)
			self:GetTarget():TakeDamageInfo(dmg)
			self:SetLevel(self:GetLevel() + 1)
			if self.DelayInterval then
				self.DelayInterval = math.max(self.DelayInterval - 0.5, 0.5)
				else
				self.DelayInterval = 3
			end
			self.DelayDmg = CurTime() + self.DelayInterval
		end
		if self:GetTarget():WaterLevel() > 0 then
			self:EmitSound(Dissipate2)
			self:Remove()
		end
		
	end
	self.looptimer = self.looptimer or CurTime()
	if CurTime() >= self.looptimer then
		self:EmitSound(gooloop)
		self.looptimer = CurTime() + 5
	end
	if SERVER then
		self:NextThink(CurTime())
	end
	return true
end

function ENT:CalcNewPosition(override)
	local pos
	if IsValid(self:GetTarget()) then
		if self.LastPos then
			pos = self:GetTarget():WorldSpaceCenter() + self.LastPos * self:GetTarget():BoundingRadius()
		else
			pos = self:GetTarget():WorldSpaceCenter() + VectorRand() * self:GetTarget():BoundingRadius()
		end
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
		ret = self:GetTarget():WorldToLocal(trace.HitPos + trace.Normal * 5)
	else
		ret = self:GetTarget():WorldToLocal(self:GetTarget():WorldSpaceCenter())
	end
	self.LastPos = (trace.Normal * 15 + VectorRand()):GetNormalized()
	return ret
end

function ENT:Disable()
	self:Remove()
end
function ENT:OnRemove()
end
if CLIENT then
	function ENT:DrawTranslucent()
		if !gmod.GetGamemode():ShouldDrawLocalPlayer(LocalPlayer()) then
			for i = 1, self:GetLevel() do
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
					self.Scales[k] = Lerp(0.01, v, 0.3)
				end
				self:SetPos(self:GetTarget():LocalToWorld(self.Positions[i]))
				self:SetAngles(self.Angles[i])
				self:SetModelScale(self.Scales[i])
				self:SetupBones()
				self:DrawModel()
			end
		end
	end
end		