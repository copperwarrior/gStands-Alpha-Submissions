ENT.Type 				= "anim"
ENT.Base 				= "base_entity"
ENT.PrintName			= "Life Detector"
ENT.Author				= "Copper"
ENT.Contact				= ""
ENT.Purpose				= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly      		= true 
ENT.DrawShadow      	= false



AddCSLuaFile("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/mgr/mgrlifedetect.mdl")
	self.NextThink = CurTime()
	self.CanTool = false
	self:SetSolid(SOLID_OBB)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.FlameLoop = CreateSound(self, "ambient/fire/fire_med_loop1.wav")
	self.FlameLoop:Play()
	self.Wep = self.Owner:GetActiveWeapon()
	if SERVER then
		self:SetTrigger(true)
		self.light = ents.Create("light_dynamic")
		self.light:SetPos(self:GetPos())
		self.light:SetParent(self)
		self.light:Spawn()
		self.light:Activate()
		self.light:SetKeyValue("distance", 514)
		self.light:SetKeyValue("brightness", 5)
		local color = gStands.GetStandColorTable("models/player/mgr/mgr.mdl", self.Owner:GetActiveWeapon():GetStand():GetSkin())
		self.light:SetKeyValue("_light", color.r..color.g..color.b..color.a)
		self.light:Fire("TurnOn")
	end
end

/*---------------------------------------------------------
Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
	if !self.Velocity then
		self:SetPos(LerpVector(0.01, self:GetPos(), self.Wep:GetStand():GetEyePos() + (self.Owner:GetAimVector() * 15 - self.Owner:GetRight() * 25 + self.Owner:GetUp() * 15) + Vector(0,0,math.sin(CurTime() * 2))))
		else
		local tr = util.TraceLine( {
			start = self:GetPos(),
			endpos = self:GetPos() + self.Velocity * 25,
			filter = {self, self.Owner, self.Wep:GetStand()}
		} )
		if tr.Hit then
		self.Velocity = (self.Velocity + (tr.HitNormal)/2):GetNormalized()
		end
		self.Velocity = self.Velocity:GetNormalized()
		self:SetPos(LerpVector(0.5, self:GetPos(), self:GetPos() + self.Velocity + Vector(0,0,math.sin(CurTime() * 2)/15)))
	end
	self.normal = {}
	
	local tbl = ents.FindInSphere(self:GetPos(), 1000)
	if tbl != {} and tbl != nil and tbl[1] != nil then
		local tblRem = {}
		for k,v in pairs(tbl) do
			if !(v:IsNPC() or v:IsPlayer()) or v == self.Owner or v:GetNoDraw() then
				tblRem[k] = v
			end
		end
		if tblRem != nil and tblRem != {} then
			for k,v in pairs(tblRem) do
				table.RemoveByValue(tbl, v)
			end
		end
		table.sort(tbl, function(a, b) return self:GetPos():Distance(a:GetPos()) < self:GetPos():Distance(b:GetPos()) end)
		if tbl != {} and tbl != nil and tbl[1] != nil then
			local dir = (self:WorldSpaceCenter() - tbl[1]:WorldSpaceCenter()):GetNormalized()
			if self.Velocity then
				self.Velocity = (self.Velocity - (dir)/355):GetNormalized()
			end
			local dot = {}
			dot[3] = self:GetForward():Dot(dir)
			dot[1] = (-self:GetForward()):Dot(dir)
			dot[5] = (-self:GetRight()):Dot(dir)
			dot[6] = self:GetRight():Dot(dir)
			dot[2] = self:GetUp():Dot(dir)
			dot[4] = (-self:GetUp()):Dot(dir)
			local min = dot[1]
			local ind = 1
			for i=1, 6 do
				if min > dot[i] then
					min = dot[i]
					ind = i
				end
			end
			self.normal[ind] = tbl[1]:WorldSpaceCenter()
		end
	end
	if SERVER then
		local tra = util.TraceHull( {
			start = self:GetPos(),
			endpos = self:GetPos(),
			filter = { self, self.Owner, self.Wep:GetStand() },
			mins = Vector( -25, -25, -25 ), 
			maxs = Vector( 25, 25, 25 ),
			ignoreworld = false,
			mask = MASK_SHOT_HULL
		} )
		local Ent = tra.Entity
		local damager
		if  IsValid(self.Owner) then
			damager = self.Owner
			else
			damager = self.Entity
		end
		if IsValid(Ent) and Ent.Health and Ent:GetClass() != "physical_bullet" then
			if not(Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") and Ent != self.Owner then 
				dmgInfo = DamageInfo()
				dmgInfo:SetAttacker(damager)
				dmgInfo:SetDamage(2)
				dmgInfo:SetInflictor( self )
				Ent:TakeDamageInfo(dmgInfo)
			end
			
			if (Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") and Ent != self.Owner then 
				dmgInfo = DamageInfo()
				dmgInfo:SetAttacker(damager)
				dmgInfo:SetDamage(2)
				dmgInfo:SetDamageType(DMG_BURN)
				dmgInfo:SetInflictor( self )
				Ent:TakeDamageInfo(dmgInfo)
			end
			
		end
	end
	self:NextThink(CurTime())
	return true
end
function ENT:OnRemove()
	self.FlameLoop:Stop()
	return true
end

if CLIENT then
	/*---------------------------------------------------------
	Name: ENT:Draw()
	---------------------------------------------------------*/
	function ENT:Draw()
		self.particle = self.particle or {}
		self.Positions = self.Positions or {}
		self.normal = self.normal or {}
		
		self.Positions[2] = self:GetBonePosition(self:LookupBone("ld.Top"))
		self.Positions[4] = self:GetBonePosition(self:LookupBone("ld.Bottom"))
		self.Positions[6] = self:GetBonePosition(self:LookupBone("ld.Left"))
		self.Positions[5] = self:GetBonePosition(self:LookupBone("ld.Right"))
		self.Positions[3] = self:GetBonePosition(self:LookupBone("ld.Front"))
		self.Positions[1] = self:GetBonePosition(self:LookupBone("ld.Back"))
		for i=1, 6 do
			self.particle[i] = self.particle[i] or CreateParticleSystem(self, "lifedetectaim", PATTACH_POINT ,1 )
			if self.particle[i] then
				self.particle[i]:SetControlPointEntity(0, self)
				self.particle[i]:SetControlPoint(0, self.Positions[i])
				self.particle[i]:SetControlPoint(1, self.Positions[i] + Vector(0,0,15))
				if self.normal[i] then
					self.particle[i]:SetControlPoint(1, self.normal[i])
				end
				local color = gStands.GetStandColor("models/player/mgr/mgr.mdl", self.Owner:GetActiveWeapon():GetStand():GetSkin())
				self.particle[i]:SetControlPoint(2, color)	
			end
		
		end
	end
end