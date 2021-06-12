ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Hermit Purple DoDo"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 
ENT.AutomaticFrameAdvance = true
ENT.Animated = true


AddCSLuaFile("shared.lua")
	
function ENT:Initialize()
		self.wep = self.Owner:GetActiveWeapon()
		if SERVER then
			self:SetModel("models/hpworld/hprope.mdl")
			self:SetPos(self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")))
			self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
			self:DrawShadow(false)
			local ang = self:GetAngles()
			ang:RotateAroundAxis(self.Owner:GetAimVector(), 180)
			self:SetAngles(ang)
			self:SetPosition(self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")))
		end
		if CLIENT then
			self:SetRenderBounds(Vector(-1500, -1500, -1500), Vector(1500, 1500, 1500))
		end
end
function ENT:OnRemove()
	self.Owner:RemoveFlags(FL_ATCONTROLS)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
function ENT:SetupDataTables()
	self:NetworkVar("Vector", 1, "Position")
end
function ENT:Think()
	if not IsValid(self) then return end
	if not IsValid(self.Entity) then return end
	self.StandVelocity = self.StandVelocity or Vector(0,0,0)
	self.Position = self.Position or self:GetPos()
	self.Angles = self.Angles or {self:GetAngles()}
	if self.Owner:KeyDown(IN_FORWARD) then
		self.StandVelocity = (self.StandVelocity + self.Owner:GetAimVector()):GetNormalized()
	end
	if self.Owner:KeyDown(IN_BACK) then
		self.StandVelocity = (self.StandVelocity - self.Owner:GetAimVector()):GetNormalized()
	end
	if self.Owner:KeyDown(IN_MOVELEFT) then
		self.StandVelocity = (self.StandVelocity - self.Owner:GetRight()):GetNormalized()
	end
	if self.Owner:KeyDown(IN_MOVERIGHT) then
		self.StandVelocity = (self.StandVelocity + self.Owner:GetRight()):GetNormalized()
	end
	if self.Owner:KeyDown(IN_JUMP) then
		self.StandVelocity = (self.StandVelocity + self.Owner:GetUp()):GetNormalized()
	end
	if self.Owner:KeyDown(IN_DUCK) then
		self.StandVelocity = (self.StandVelocity - self.Owner:GetUp()):GetNormalized()
	end
	local FTr = util.TraceLine({
				start = self.Position,
				endpos = self.Position + self.StandVelocity * 15,
				filter = {self, self.Owner},
				collisiongroup = self:GetCollisionGroup()
				})
	self.StandVelocity = self.StandVelocity / 1.1
	if SERVER and self.Owner:GetPos():Distance(self.Position + self.StandVelocity * 15) < 1500 then
		if FTr.Hit then
			self.StandVelocity = self.StandVelocity + FTr.HitNormal/5
		end
		self:SetPosition(self:GetPosition() + self.StandVelocity * 15)
	end
	self.Owner:AddFlags(FL_ATCONTROLS)
	self:NextThink(CurTime())
	return true
end
	
if CLIENT then
	function ENT:Draw()
		if IsPlayerStandUser(LocalPlayer()) then
			local StartPos = self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
			local EndPos = self:GetPosition()
			self.LastPos = EndPos
			self:SetPos(self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")))
			self:SetAngles((EndPos - StartPos):GetNormalized():Angle())
			self:SetupBones()
			for i=1, self:GetBoneCount() - 1 do
				local pos1, ang1 = self:GetBonePosition(i)
				pos1 = LerpVector(math.Clamp(((9 - i) * 0.1), 0, 1), LerpVector(0.000000001, self.LastPos, EndPos), self:GetPos())
				local rotate = Vector(pos1.x + (math.sin(CurTime() + (i)) * 5), pos1.y + (math.cos(CurTime() + (i)) * 5), pos1.z + (math.sin(CurTime() + (i)) * 5))
				self:SetBonePosition(i, rotate, ang1)
				if i == 10 then
					self.Position = pos1
				end
			end
			self:DrawModel()
		end
		if GetConVar("gstands_show_hitboxes"):GetBool() then
			for i = 0, self:GetHitBoxCount(0) - 1 do
				local cmins, cmaxs = self:GetHitBoxBounds(i, 0)
				local cpos, cang = self:GetBonePosition(self:GetHitBoxBone(i, 0))
				render.DrawWireframeBox(cpos, cang, cmins, cmaxs, Color(255,0,0,255), true)
			end
		end
	end
end		