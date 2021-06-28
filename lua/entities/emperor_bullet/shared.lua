ENT.Type 			= "anim"
ENT.PrintName		= "Boolet"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 
ENT.RenderGroup = RENDERGROUP_BOTH
local HitSound = Sound( "physics/flesh/flesh_impact_bullet"..math.random(1,5)..".wav" )
local Hit = Sound( "emp.hit" )
function ENT:FindTraces(numPoints)
		local traces = {}
		for i = 0, numPoints do
			local t = i / (numPoints - 1.0)
			local inclination = math.acos(1 - 2 * t)
			local azimuth = 2 * math.pi * 1.6180339887499 * i
			local x = math.sin(inclination) * math.cos(azimuth)
			local y = math.sin(inclination) * math.sin(azimuth)
			local z = math.cos(inclination)
			traces[i] = Vector(z, y, x)
		end
		return traces
	end
if SERVER then
	
	AddCSLuaFile("shared.lua")
	function ENT:Initialize()
		ParticleEffect("emperor_muzzleflash", self:GetPos(), self.Owner:EyeAngles())
		self:SetModel("models/emperor/models/emperor_bullet.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		local phys = self.Entity:GetPhysicsObject()
		self.NextThink = CurTime()
		
		if (phys:IsValid()) then
			phys:Wake()
			phys:SetMass(10)
		end
		self:GetPhysicsObject():SetMass(2)	
		self:GetPhysicsObject():EnableGravity(false)	
		
		self.CanTool = false
		self:GetPhysicsObject():SetVelocity(self:GetForward() * 1000)
		self:GetPhysicsObject():SetAngleDragCoefficient(10000000)
		self:GetPhysicsObject():SetBuoyancyRatio(0)
		self:SetNWEntity("trail", util.SpriteTrail(self, 0, Color(255,0,255,175), true, 0.6,0, 1, 1/(15) * 0.5, "physgbeamb.vmt" ))
		self.traces = self:FindTraces(100)
		self.Dir = VectorRand()
		self.Dir2 = VectorRand()
		self:NextThink(CurTime())
	end
	
	/*---------------------------------------------------------
	Name: ENT:Think()
	---------------------------------------------------------*/
	function ENT:Think()
		self:GetPhysicsObject():SetAngles(self:GetAngles())
		self.Wep = self.Wep or self.Owner:GetWeapon("gstands_emperor")
		if not IsValid(self) then return end
		if not IsValid(self.Entity) then return end
		if  !(self.Owner:IsValid() and self.Owner:Health() > 0 and self.Owner:WorldSpaceCenter():Distance(self:WorldSpaceCenter()) <= 2390 ) then
			self:Remove()
		end
		if IsValid(self.OwnerWep:GetTarget()) then
			self.Targetted = self.Targetted or true
		end
		if self.Targetted and !IsValid(self.OwnerWep:GetTarget()) then
		self:Disable()
		end
		self.Wep:SetInDoDoDo(self.Owner:gStandsKeyDown("dododo"))
		if self.Owner:gStandsKeyDown("dododo") and IsValid(self.OwnerWep:GetLastBull()) then
			self:SetAngles(self.Owner:GetAimVector():Angle())
			if self.OwnerWep:GetLastBull() != self then
				local norm = ((self.OwnerWep:GetLastBull():GetPos() + ( self.OwnerWep:GetLastBull():GetForward() + (self.Dir * math.sin(CurTime())) + (self.Dir2 * math.cos(CurTime()))) * 15) - self:GetPos()):GetNormalized()
				self:SetAngles(norm:Angle())
			end
			else
			self:Aim(self.OwnerWep:GetTarget())
		end
		if IsValid(self.Owner) and IsValid(self.OwnerWep) and !IsValid(self.OwnerWep:GetLastBull()) then
		self.OwnerWep:SetLastBull(self)
		end
		local mult = 15
		if self.TargettingProjectile then
			local trh = util.TraceLine( {
				start = self:GetPos(),
				endpos = self:GetPos(),
				mins=Vector(-15,-15,-15),
				maxs=Vector(15,15,15),
				filter = { self, self.Owner},
			} )
			if IsValid(trh.Entity) and trh.Entity == self.OwnerWep:GetTarget() then
				trh.Entity:Remove()
				self:Disable()
			end
		end
		if IsValid(self.OwnerWep:GetTarget()) and !self.Owner:gStandsKeyDown("dododo") then
			local norm = -(self:GetPos() - self.OwnerWep:GetTarget():WorldSpaceCenter()):GetNormalized()
			local angle = norm:Angle()
			self.IsTrapped = self.IsTrapped or 1

			local trh = util.TraceLine( {
				start = self:GetPos(),
				endpos = self:GetPos() + norm * 75 ,
				filter = { self, self.Owner},
			} )
			if trh.Hit and trh.Entity != self.OwnerWep:GetTarget() then
				self.IsTrapped = self.IsTrapped + 1
				for k,v in pairs(self.traces) do
					local ang = v:Angle()
					local norma = self:WorldToLocalAngles(ang):Forward()
					local tr = util.TraceLine( {
						start = self:GetPos(),
						endpos = self:GetPos() + norma * (75),
						filter = { self, self.Owner},
					} )
					if !(tr.Hit and tr.Entity != self.OwnerWep:GetTarget()) then
						self:SetAngles( norma:Angle() )
						self:GetPhysicsObject():AddVelocity(norma * 1000)
					end
				end
				else
				self.IsTrapped = math.max(self.IsTrapped - 1, 1)
			end
			self.HitEntity = trh.Entity
		end
		self:GetPhysicsObject():AddVelocity(self:GetForward() * 1000)
		
		self.LastNoDraw = self.LastNoDraw or self:GetNoDraw()
		
		local td = {
					start = self.LastPos or self:GetPos(),
					endpos = self:GetPos() + self:GetForward(),
					filter = function(ent) if ent != self and ent != self.Owner and ent:GetClass() != self:GetClass() then return true else return false end end,
					mask = MASK_SHOT_HULL,
				}
		local tr = util.TraceLine(td)
				if IsValid(tr.Entity) then
					self:DoHit(tr)
				end
				if tr.HitWorld then
				self:Disable()
				end
				self.LastPos = self:GetPos()
		self:NextThink(CurTime())
		return true
	end
	
	
	function ENT:Disable()
		self.Wep:SetInDoDoDo(self.Owner:gStandsKeyDown("dododo"))
		self:Remove()
	end
	
	function ENT:Aim(Target)
		if !self.Owner:gStandsKeyDown("modifierkey2") and Target:IsValid() and (Target:Health() > 0 or !(Target:IsPlayer() or Target:IsNPC())) then
			if Target:IsValid() and !(Target.GetActiveWeapon and IsValid(Target:GetActiveWeapon()) and Target:GetActiveWeapon():GetClass() == "gstands_cream" and Target:GetActiveWeapon():GetActive() ) then
				local norm = (Target:EyePos() - self:GetPos()):GetNormalized()
				local dist = math.min(1, self.Owner:WorldSpaceCenter():Distance(Target:WorldSpaceCenter())/2390)
				self:SetAngles(LerpAngle(1 - dist, self:GetAngles(), norm:Angle()))
				else
				--self:Disable()
			end
		end
	end
	function ENT:DoHit(tr)
		local headshotmult = 1

		if tr.Entity:GetHitBoxBone(tr.HitBox, 1) == tr.Entity:LookupBone("ValveBiped.Bip01_Head") then headshotmult = 2 end
		if self.Wep:Clip1() < 6 then
			self.Wep:SetClip1(math.min(6, self.Wep:Clip1() + 1))
		end
		local damager
		if  IsValid(self.Owner) then
			damager = self.Owner
			else
			damager = self.Entity
		end
		
		local Ent = tr.Entity
		if self.TargettingProjectile then
			if IsValid(Ent) and Ent == self.TargettingProjectile then
				Ent:Remove()
				self:Disable()
			end
		end
		local HitMatType = tr.MatType
		if !(Ent:IsValid() or Ent:IsWorld()) then return end
		
		self:Disable()
		self:SetAngles(tr.HitNormal:Angle())
		self:GetPhysicsObject():EnableMotion(false)
		local dist = 1 - math.min(1, 0.5 - self.Owner:WorldSpaceCenter():Distance(Ent:WorldSpaceCenter())/2390)
		if SERVER and Ent:IsValid() and !Ent:IsNPC() and Ent:GetKeyValues()["health"] > 0 then Ent:SetKeyValue("explosion", "2") Ent:SetKeyValue("gibdir", tostring(tr.HitNormal:Angle())) Ent:Fire("Break") end
		if Ent.Health then
			if not(Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll" or Ent:GetClass() == "hg_barrier") then 
				util.Decal("Impact.Concrete", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
				self:EmitSound(GetStandImpactSfx(HitMatType))
				self:EmitStandSound(Hit)
				dmgInfo = DamageInfo()
				dmgInfo:SetAttacker(self.Owner)
				if self.Owner:gStandsKeyDown("dododo") then
					dmgInfo:SetDamage(200 * headshotmult)
					else
					dmgInfo:SetDamage(175 * dist)
				end
				dmgInfo:SetInflictor( damager )
				Ent:TakeDamageInfo(dmgInfo)
			end
			
			if (Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") then 
				dmgInfo = DamageInfo()
				dmgInfo:SetAttacker(self.Owner)
				if self.Owner:gStandsKeyDown("dododo") then
					dmgInfo:SetDamage(200 * headshotmult)
					elseif !self.Owner:gStandsKeyDown("dododo") then
					dmgInfo:SetDamage(175 * dist)
				end
				dmgInfo:SetInflictor( damager )
				Ent:TakeDamageInfo(dmgInfo)
				self:EmitSound(GetStandImpactSfx(HitMatType))
				self:EmitStandSound(Hit)
			end
			
		end
		
		
	end
	function ENT:PhysicsCollide(tr)
		local headshotmult = 1
		local headshottrace = util.TraceLine({
			start = self:GetPos(),
			endpos = tr.HitEntity:EyePos()
			})
		if tr.HitEntity:GetHitBoxBone(headshottrace.HitBox, 1) == tr.HitEntity:LookupBone("ValveBiped.Bip01_Head") then headshotmult = 2 end
		if IsValid(self.Wep) and self.Wep:Clip1() < 6 then
			self.Wep:SetClip1(math.min(self.Wep:Clip1() + 1))
		end
		local damager
		if  IsValid(self.Owner) then
			damager = self.Owner
			else
			damager = self.Entity
		end
		local Ent = tr.HitEntity
		if self.TargettingProjectile then
			if IsValid(Ent) and Ent == self.TargettingProjectile then
				Ent:Remove()
				self:Disable()
			end
		end
		local HitMatType = tr.MatType
		if !(Ent:IsValid() or Ent:IsWorld()) then return end
		local dist = 1 - math.min(1, 0.5 + self.Owner:WorldSpaceCenter():Distance(Ent:WorldSpaceCenter())/2390)
		self:Disable()
		self:SetAngles(tr.HitNormal:Angle())
		self:GetPhysicsObject():EnableMotion(false)
		if SERVER and Ent:IsValid() and !Ent:IsNPC() and Ent:GetKeyValues()["health"] > 0 then Ent:SetKeyValue("explosion", "2") Ent:SetKeyValue("gibdir", tostring(tr.HitNormal:Angle())) Ent:Fire("Break") end
		if Ent.Health then
			if not(Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll" or Ent:GetClass() == "hg_barrier") then 
				util.Decal("Impact.Concrete", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
				self:EmitSound(GetStandImpactSfx(HitMatType))
				self:EmitStandSound(Hit)
				dmgInfo = DamageInfo()
				dmgInfo:SetAttacker(self.Owner)
				if self.Owner:gStandsKeyDown("dododo") then
					dmgInfo:SetDamage(150 * headshotmult)
					else
					dmgInfo:SetDamage(100 * dist * headshotmult)
				end
				dmgInfo:SetInflictor( damager )
				Ent:TakeDamageInfo(dmgInfo)
			end
			
			if (Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") then 
				dmgInfo = DamageInfo()
				dmgInfo:SetAttacker(self.Owner)
				if self.Owner:gStandsKeyDown("dododo") then
					dmgInfo:SetDamage(150)
					elseif !self.Owner:gStandsKeyDown("dododo") then
					dmgInfo:SetDamage(100 * dist)
				end
				dmgInfo:SetInflictor( damager )
				Ent:TakeDamageInfo(dmgInfo)
				self:EmitStandSound(Hit)
				self:EmitSound(GetStandImpactSfx(HitMatType))
			end
			
		end
		
		
	end
	function ENT:OnRemove()
		if self.Wep:IsValid() and self.Wep:Clip1() < 6 then
			self.Wep:SetClip1(math.min(self.Wep:Clip1() + 1))
		end
		self.Wep:SetInDoDoDo(false)
	end
end

if CLIENT then
	function ENT:Initialize()
		self.traces = self:FindTraces(100)
		ParticleEffect("emperor_muzzleflash", self:GetPos(), self.Owner:EyeAngles())
		self:EmitSound("d3_breen.core_rift_wind1", 75, 255, 1)
	end
	function ENT:OnRemove()
		self:StopSound("d3_breen.core_rift_wind1")
	end
	function ENT:Think()
		self.LastAng = self.LastAng or 0
		self:SetAngles(self:GetAngles()+Angle(0,0,(self.LastAng + 1) % 360))
		self.LastAng = self:GetAngles().r
		self.Sounded = self.Sounded or CurTime()
		if CurTime() >= self.Sounded and LocalPlayer():GetPos():DistToSqr(self:GetPos()) <= 200 ^ 2 then
			self:EmitStandSound("Bullets.DefaultNearmiss")
			self.Sounded = CurTime() + SoundDuration("Bullets.DefaultNearmiss")
		end
		return true
	end
	/*---------------------------------------------------------
	Name: ENT:Draw()
	---------------------------------------------------------*/
	local ring = Material("effects/strider_pinch_dudv")
	local ring2 = Material("effects/select_ring")
	local mat_white = Material( "models/debug/debugwhite" )
	function ENT:DrawTranslucent()
		if CLIENT and LocalPlayer():GetActiveWeapon() then
			if LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then
				if self:GetNWEntity("trail"):IsValid() then
					self:GetNWEntity("trail"):SetNoDraw(false)
				end
				if GetConVar("gstands_show_hitboxes"):GetBool() then
					local r = self:GetAngles().r
					local angles = self:GetAngles()
					self:SetAngles(Angle(angles.p, angles.y, 0))
					for k,v in pairs(self.traces) do
						local tr = util.TraceLine( {
							start = self:GetPos(),
							endpos = self:GetPos() + v * 75,
							filter = { self, self.Owner},
						} )
						if tr.Hit then
							render.DrawLine(self:GetPos(), self:GetPos() + v * 75, Color(255,0,0), true)
						else
							render.DrawLine(self:GetPos(), self:GetPos() + v * 75, Color(0,255,0), true)
							break
						end
					end
					self:SetAngles(Angle(angles.p, angles.y, r))
					--self.BaseClass.Draw(self) -- Overrides Draw 
				end
				self.PosTable = self.PosTable or {}
				self.AngTable = self.AngTable or {}
				self.RandTable = self.RandTable or {}
				local rand = math.random(0,2)
				if rand == 1 then
				table.insert(self.PosTable, 1, self:GetPos())
				table.insert(self.AngTable,	1, self:GetAngles())
				table.insert(self.RandTable,1, math.Rand(0.1, 1))
				end
				for k,v in pairs(self.PosTable) do
					render.SetMaterial(ring)
					render.DrawQuadEasy(v, self.AngTable[k]:Forward(), k * self.RandTable[k] * 2, k * self.RandTable[k] * 2, Color(255,255,255,math.random(255,255)), 0)
					render.SetMaterial(ring2)
					render.DrawQuadEasy(v, self.AngTable[k]:Forward(), k * self.RandTable[k] * 2, k * self.RandTable[k] * 2, Color(255,255,255,math.random(35,64)), 0)
					render.SetMaterial(ring2)
					render.DrawQuadEasy(v, self.AngTable[k]:Forward(), k * self.RandTable[k] * 3, k * self.RandTable[k] * 3, Color(255,255,255,math.random(5,35)), 0)
					self.PosTable[k] = v - self.AngTable[k]:Forward()
				end
				if rand == 1 then
				table.remove(self.PosTable, 5)
				table.remove(self.AngTable, 5)
				table.remove(self.RandTable, 5)
				end
				self:DrawModel() -- Draws Model Client Side
				self:SetMaterial("models/debug/debugwhite")
				render.SetBlend(0.4)
				self:SetModelScale(1 + math.Rand(0,0.5))
				self:SetupBones()
				render.SetColorModulation(1,0,1)
				render.SuppressEngineLighting(true)
				self:DrawModel()
				render.SuppressEngineLighting(false)
				render.SetColorModulation(1,1,1)
				self:SetModelScale(1)
				self:SetupBones()
				self:SetMaterial("")
				elseif self:GetNWEntity("trail"):IsValid() then
				self:GetNWEntity("trail"):SetNoDraw(true)
			end
		end
	end
end	