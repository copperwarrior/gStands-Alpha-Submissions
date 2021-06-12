ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName= "#gstands.names.ed"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "Ebony Devil"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
ENT.Animated = true
ENT.ImageID = 1
ENT.Rate = 0
ENT.Health = 1
ENT.CurrentAnim = "idle"
ENT.State = false
ENT.Color = Color(255,255,255,75)
ENT.Mass = 100
ENT.Prop = self
function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Prop")
	self:NetworkVar("Float", 1, "pcl2life")
	self:NetworkVar("Float", 3, "pcl3life")
	self:NetworkVar("Vector", 2, "pcl2dir")
	self:NetworkVar("Vector", 4, "pcl3dir")
end
function ENT:Initialize()
	if SERVER then
		self:SetSolid( SOLID_OBB )
		self:SetMoveType( MOVETYPE_NOCLIP )
		self:SetSolidFlags( FSOLID_NOT_STANDABLE )
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:SetModelScale(1.1)
		self:SetModelScale(1, 1)
		self:DrawShadow(false)
		if self.Type == "prop_physics" then
			self:SetProp(ents.Create("prop_physics"))
			else
			self:SetProp(ents.Create("prop_ragdoll"))
		end
		self.Prop = self:GetProp()
		self.Prop:SetPos(self:GetPos())
		self.Prop:SetModel(self:GetModel())
		self.Prop:SetAngles(self:GetAngles())
		self.Prop:SetVelocity(self:GetVelocity())
		self.Prop:Spawn()
		if IsValid(self.Prop:GetPhysicsObject()) then
			self.Prop:GetPhysicsObject():SetMass(25)
			for i=0, self.Prop:GetPhysicsObjectCount() - 1 do
				self.Prop:GetPhysicsObjectNum(i):AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			end
		end
		self:SetParent(self.Prop)
		self:SetHealth(self.Owner:Health())
	end
	if SERVER then
		undo.Create( "Ebony Devil" )
		undo.AddEntity( self.Prop )
		undo.SetPlayer( self.Owner )
		undo.Finish()
	end
	hook.Add("SetupPlayerVisibility", "ebdevnocullbreak"..self.Owner:GetName(), function(ply, ent) 
		if self:IsValid() and self.Owner:IsValid() and self:IsValid() then
			AddOriginToPVS( self:WorldSpaceCenter() + Vector(0,0,50) )
		end
	end)
	self.pcllife = CurTime() + 1
end
function ENT:DropItem()
	if self.ItemPickedUp:IsValid() and self.ItemPickedUp != self then
		if self.ItemPickedUp:GetPhysicsObject():IsValid() then
			self.ItemPickedUp:GetPhysicsObject():Wake()
			self.ItemPickedUp:GetPhysicsObject():EnableGravity(true)
			self.ItemPickedUp:GetPhysicsObject():ClearGameFlag(FVPHYSICS_PLAYER_HELD)
			self.ItemPickedUp:GetPhysicsObject():SetDragCoefficient(0)
		end
		self.ItemPickedUp = self
	end
end
function ENT:DoSlashAttack(ent)
	self:Setpcl2life(CurTime() + 0.1)
	self:Setpcl2dir((ent:WorldSpaceCenter() - self:WorldSpaceCenter()):GetNormalized())
end
function ENT:DoDashAttack(ent)
	if ent and ent:IsValid() then
	self:Setpcl3life(CurTime() + 0.5)
	self:Setpcl3dir((ent:WorldSpaceCenter() - self:WorldSpaceCenter()):GetNormalized())
	end
end
function ENT:Think() 
	self.ItemPickedUp = self.ItemPickedUp or self
	self.Wep = self.Wep or self.Owner:GetWeapon("gstands_ebonydevil")
	if self:IsValid() and self.Owner:IsValid() and !self.Wep:GetInDoDoDo() and self.ItemPickedUp:IsValid() and self.ItemPickedUp != self then
		self:DropItem()
	end
	if IsValid(self.Owner) and self.Owner:KeyPressed(IN_USE) and self.Wep:GetInDoDoDo() then
		local tra = util.TraceHull( {
			start = self:WorldSpaceCenter(),
			mins = Vector(-5,-5,-5),
			maxs = Vector(5,5,5),
			endpos = self:WorldSpaceCenter() + self.Owner:GetAimVector() * 74,
			ignoreworld = true,
			filter = {self.Owner, self, self.Prop},
		} )
		if tra.Entity:IsValid() and SERVER and !tra.Entity:IsVehicle() then
			tra.Entity:Use(self.Owner, self, USE_TOGGLE, 1)
			if gmod.GetGamemode():PlayerCanPickupItem(self.Owner, tra.Entity) and tra.Entity:GetPhysicsObject():GetMass() <= 500 and !tra.Entity:IsPlayer() or (GetConVar("gstands_time_stop"):GetBool() and tra.Entity:IsPlayer()) then
				self.ItemPickedUp = tra.Entity
			end
		end
	end
	if SERVER and self.ItemPickedUp and self.ItemPickedUp:IsValid() and self.ItemPickedUp != self  then
		if util.PointContents(LerpVector(0.5, self.ItemPickedUp:GetPos(), self.ItemPickedUp:GetPos() - (self.ItemPickedUp:WorldSpaceCenter() - ((self:WorldSpaceCenter() + self:GetForward() * 24))))) != CONTENTS_SOLID then
			self.ItemPickedUp:GetPhysicsObject():EnableGravity(false)
			self.ItemPickedUp:GetPhysicsObject():ApplyForceCenter((((self:WorldSpaceCenter() + self:GetForward() * 24)) - self.ItemPickedUp:WorldSpaceCenter()) * self.ItemPickedUp:GetPhysicsObject():GetMass() * 2)
			self.ItemPickedUp:GetPhysicsObject():AddGameFlag(FVPHYSICS_PLAYER_HELD)
			self.ItemPickedUp:GetPhysicsObject():SetDragCoefficient(2500 / (self:WorldSpaceCenter() + self:GetForward() * 24):Distance(self.ItemPickedUp:WorldSpaceCenter()))
			if (self:WorldSpaceCenter() + self:GetForward() * 24):Distance(self.ItemPickedUp:WorldSpaceCenter()) >= 500 then
				self:DropItem()
			end
			else
			self:DropItem()
		end
	end
	if self.Owner:KeyReleased(IN_USE) and self.ItemPickedUp and self.ItemPickedUp:IsValid() and self.ItemPickedUp != self then
		self:DropItem()
	end
	if SERVER then		
		if self.Owner:IsValid() and self.Owner:Alive() then
			if self:IsOnFire() then
				self.Owner:Ignite(2, 1)
				self:Extinguish()
			end
			for i = 0, self:GetProp():GetPhysicsObjectCount() do
			local phys = self:GetProp():GetPhysicsObjectNum(i)
			if IsValid(phys) then
			if self.Wep:GetInDoDoDo() then 
				self.Owner:AddFlags(FL_ATCONTROLS)
				local mins, maxs = self:GetCollisionBounds()
				local tr = util.TraceHull( {
					start = self.Prop:GetPos(),
					endpos = self.Prop:GetPos() - maxs * 1.05,
					mins = mins,
					maxs = maxs,
					filter = {self.Owner, self, self.Prop},
					mask = MASK_SHOT_HULL
				} )
				self.jumpTimer = self.jumpTimer or CurTime()
				self.Velocity = self.Velocity or Vector(0,0,0)
				if self:OnGround() or tr.Hit and CurTime() >= self.jumpTimer then
					if self.Owner:KeyDown( IN_FORWARD ) then
						self.Velocity = self.Velocity + self.Owner:GetAimVector() * 15/((self:GetProp():GetPhysicsObjectCount()/5))
					end
					if self.Owner:KeyDown( IN_BACK ) then
						self.Velocity = self.Velocity + -self.Owner:GetAimVector() * 15/((self:GetProp():GetPhysicsObjectCount()/5))
					end
					if self.Owner:KeyDown( IN_MOVELEFT ) then
						self.Velocity = self.Velocity + -self.Owner:GetAimVector():Angle():Right() * 15/((self:GetProp():GetPhysicsObjectCount()/5) / (2 * (1 - tr.Fraction)))
					end
					if self.Owner:KeyDown( IN_MOVERIGHT ) then
						self.Velocity = self.Velocity + self.Owner:GetAimVector():Angle():Right() * 15/((self:GetProp():GetPhysicsObjectCount()/5) / (2 * (1 - tr.Fraction)))
					end
					if self.Owner:KeyDown( IN_JUMP ) and CurTime() >= self.jumpTimer then
					self.Velocity = self.Velocity + Vector(0,0,1) * 55/(self:GetProp():GetPhysicsObjectCount()/5)
					end
				end
				
				phys:ApplyForceCenter(self.Velocity)
				self.Velocity = self.Velocity * 0.9
				elseif !self.Wep:GetInDoDoDo() then
				self.Owner:RemoveFlags(FL_ATCONTROLS)
			end
			end
			
		end
		end
		self:NextThink( CurTime() )
		return true
	end
end

function ENT:OnTakeDamage(dmg)
	if string.StartWith(dmg:GetInflictor():GetClass(), "gstands_") then
		self.Owner:TakeDamageInfo(dmg)
		return false
	end
	
end
function ENT:OnRemove()
	if SERVER then
		self.Owner:RemoveFlags(FL_ATCONTROLS)
	end
	if IsValid(self.Owner) then
		hook.Remove("SetupPlayerVisibility", "ebdevnocullbreak"..self.Owner:GetName())
	end
end
local EdPclMat = Material("effects/ed_glimpse")
local EdPclSlashMat = Material("effects/ed_slash")
function ENT:Draw()
	
end

function ENT:DrawTranslucent()	
	if IsPlayerStandUser(LocalPlayer()) and CurTime() <= self.pcllife then
	render.SetMaterial(EdPclMat)
	render.DrawQuadEasy(self:WorldSpaceCenter() + EyeAngles():Up() * ((self.pcllife - CurTime()) * 55), -EyeAngles():Forward(), 55, 55, Color(255,255,255,(self.pcllife - CurTime()) * 255), 180)
	end
	if CurTime() <= self:Getpcl2life() then
	render.SetMaterial(EdPclSlashMat)
	self.ang = (-self:Getpcl2dir()):Angle()
	self.ang.r = math.sin(CurTime()) * 360
	render.DrawQuadEasy(self:WorldSpaceCenter() + self:Getpcl2dir() * 5, self.ang:Up(), 55, 55, Color(255,255,255,(self:Getpcl2life() - CurTime()) * 2048), 400 * (CurTime() - self:Getpcl2life()) + 140)
	end
	if CurTime() <= self:Getpcl3life() then
		render.SetMaterial(EdPclSlashMat)
		self.ang = (-self:Getpcl3dir()):Angle()
		self.ang.r = math.Rand(0,360) + math.sin(CurTime()) * 360
		render.DrawQuadEasy(self:WorldSpaceCenter() + self:Getpcl3dir() * 25, self.ang:Up(), 75 + math.random(-35, 35), 75+ math.random(-15, -15), Color(255,255,255,math.random(1,255)), 2000 * (CurTime() - self:Getpcl2life()) + 140)
	
		self.ang = (-self:Getpcl3dir()):Angle()
		self.ang.r = math.Rand(0,360) + math.sin(CurTime()) * 360
		render.DrawQuadEasy(self:WorldSpaceCenter() + self:Getpcl3dir() * 25, self.ang:Up(), 75+ math.random(-35, 35), 75+ math.random(-15, -15), Color(255,255,255,math.random(1,255)), 2000 * (CurTime() - self:Getpcl2life()) + 140)
	
		self.ang = (-self:Getpcl3dir()):Angle()
		self.ang.r = math.Rand(0,360) + math.sin(CurTime()) * 360
		render.DrawQuadEasy(self:WorldSpaceCenter() + self:Getpcl3dir() * 25, self.ang:Up(), 75+ math.random(-35, 35), 75+ math.random(-15, -15), Color(255,255,255,math.random(1,255)), 2000 * (CurTime() - self:Getpcl2life()) + 140)
	end
end
