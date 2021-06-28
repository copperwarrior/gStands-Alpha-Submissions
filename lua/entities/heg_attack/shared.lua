ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Tentacle Attack"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 
ENT.AutomaticFrameAdvance = true


AddCSLuaFile("shared.lua")

local Rip = Sound("weapons/hierophant/tentaclerip.wav")
local Stab = Sound("weapons/hierophant/tentaclestab.wav")
local Stab2 = Sound("weapons/hierophant/tentaclestab2.wav")

function ENT:Initialize()
	self:SetModel("models/heg/tentattack.mdl")
	self:SetPos(self:GetPos() - Vector(0,0,5))
	self:SetMoveType(MOVETYPE_NOCLIP)
	self:DrawShadow(false)
	self.wep = self.Owner:GetActiveWeapon()
	self:SetHealth(1)
	if self.wep.GetStand then
		self:SetSkin(self.wep:GetStand():GetSkin())
	end
	self:NextThink(CurTime())
	self:EmitStandSound(Stab)
	self:ResetSequence(1)
	self:SetModelScale(1.5)
	self.Lifetime = CurTime() + self:SequenceDuration()
end
/*---------------------------------------------------------
Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
	
	if not IsValid(self) then return end
	if not IsValid(self.Entity) then return end
	if SERVER and CurTime() >= self.Lifetime then
		self:Disable()
	end
	
	if self:GetCycle() < 0.3 and self:GetCycle() > 0.1 then
		self:SetPlaybackRate(0.8)
		local ply = self.Owner
		
		local trace = util.TraceHull( {
				start = self:GetPos() + Vector(0,0,45),
				endpos = self:GetPos() + Vector(0,0,45),
				filter = { self, ply:GetActiveWeapon(), ply:GetActiveWeapon():GetStand(), ply, ply:GetVehicle() },
				mins = Vector( -100, -100, -100 ),
				maxs = Vector( 100, 100, 100 ),
				mask = MASK_SHOT_HULL,
				ignoreworld = true
			} )
		self.Ent = self.Ent or trace.Entity
		if SERVER and IsValid(self.Ent) and !self.Movetype then
			self.Movetype = self.Ent:GetMoveType()
			self.Velocity = self.Ent:GetVelocity()
			self.Pos = self.Ent:GetPos()
			dmgInfo = DamageInfo()
			dmgInfo:SetAttacker(self.Owner or self)
			dmgInfo:SetDamage(15)
			dmgInfo:SetInflictor( self.wep )
			self.Ent:TakeDamageInfo(dmgInfo)
			self:EmitStandSound(Stab2)
		end
	end
	if SERVER and IsValid(self.Ent) and !self.Finished then
		dmgInfo = DamageInfo()
		dmgInfo:SetAttacker(self.Owner or self)
		dmgInfo:SetInflictor( self.wep )
		self.Ent:TakeDamageInfo(dmgInfo)
		if self.Ent:IsPlayer() then
			self.Ent:gStandsStunLock(1, 0.1)
			self.Ent:SetVelocity(-self.Ent:GetVelocity())
			self.Ent:SetPos(self.Pos)
		end
		if self.Ent:IsStand() then
			self.Ent:SetFrozen(true)
		end
	end
	if SERVER and CurTime() - self.Lifetime > -0.3 and !self.Finished then
		self.Finished = true
		if IsValid(self.Ent) then
			self.Ent:SetVelocity(self.Velocity)
			self.Ent:SetPos(self.Pos)
			dmgInfo = DamageInfo()
			dmgInfo:SetAttacker(self.Owner or self)
			dmgInfo:SetDamage(85)
			dmgInfo:SetInflictor( self.wep )
			self.Ent:TakeDamageInfo(dmgInfo)
			if self.Ent:IsStand() then
				self.Ent:SetFrozen(false)
			end
			self:EmitStandSound(Rip)
		end
	end
	self:NextThink(CurTime())
	return true
end

function ENT:Disable()
	
	self:Remove()
end

function ENT:OnTakeDamage()
	self:Remove()
end

if CLIENT then
	/*---------------------------------------------------------
	Name: ENT:Draw()
	---------------------------------------------------------*/
	function ENT:Draw()
		if LocalPlayer():GetActiveWeapon() and LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then
			if !self.Owner:GetNoDraw() then
				self.Entity:DrawModel()
			end
		end
		if GetConVar("gstands_show_hitboxes"):GetBool() then
			local cpos, cang = self:GetPos()
			render.DrawWireframeBox(cpos + Vector(0,0,45), Angle(0,0,0), Vector(-35,-35,-25), Vector(35,35,35), Color(0,255,0,255), true)
		end
	end
end		