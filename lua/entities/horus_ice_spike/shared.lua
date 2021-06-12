ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Ice Spike"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 
ENT.id = 1


if SERVER then
	
	AddCSLuaFile("shared.lua")
	
	function ENT:Initialize()
		
		self:SetModel("models/horus/icespike.mdl")
		self:SetModelScale(0.1)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetTrigger(true)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		self:DrawShadow(false)
		local phys = self.Entity:GetPhysicsObject()
		self:SetHealth(1)
		phys:EnableGravity(false)	
		if self:GetParent():IsValid() then
			self:GetPhysicsObject():ApplyForceCenter(self:GetForward() * 10000)
		end
        phys:SetMass(0)
		phys:SetAngleDragCoefficient(10000000)
		phys:SetBuoyancyRatio(0)
        self:SetNWEntity("trail", util.SpriteTrail(self, 0, Color(150,150,255,255), true, 10,0, 0.1, 1/(15) * 0.5, "trails/smoke" ))
		
	end
	/*---------------------------------------------------------
	Name: ENT:Think()
	---------------------------------------------------------*/
	function ENT:Think()   
		local phys = self.Entity:GetPhysicsObject()
        phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		phys:EnableGravity(false)
		phys:SetAngleDragCoefficient(10000000)
		phys:SetBuoyancyRatio(0)
		if not IsValid(self) then return end
		if not IsValid(self.Entity) then return end
		if GetConVar("phys_timescale"):GetInt() == 0 or self:GetParent():IsValid() then
			
			self.lifetime = 9999999
			else
			self.lifetime = self.lifetime or CurTime() + 1
		end
		if CurTime() > self.lifetime then
			self:Disable()
		end
        if self:GetParent():IsValid() then
			--self:GetPhysicsObject():ApplyForceCenter(self:GetForward() * 10000)
		end
    	self:NextThink(CurTime() + 0.0001)
        return true
	end
	
	function ENT:Disable()
		self:Remove()
	end
	function ENT:PhysicsCollide(data)
		local Ent = data.HitEntity
		if SERVER and Ent:IsValid() and !Ent:IsNPC() and Ent:GetKeyValues()["health"] > 0 then Ent:SetKeyValue("explosion", "2") Ent:SetKeyValue("gibdir", tostring(data.HitNormal:Angle())) Ent:Fire("Break") end
		
		self:Disable()
		self:EmitSound("weapons/horus/icecrack-0"..math.random(1,5)..".wav", 75, 200, 1, CHAN_AUTO)
		self:EmitSound("physics/glass/core_glasstastrophe_splinter_0"..math.random(1,3)..".wav", 75, 150, 1, CHAN_AUTO)
		
	end
	
	function ENT:StartTouch(Ent)
		self.HitOnce = true
		if !self:GetParent():IsValid() then
			local damager
			if  IsValid(self.Owner) then
				damager = self.Owner
				else
				damager = self.Entity
				return
			end
	        if SERVER and Ent:IsValid() and Ent:GetKeyValues()["health"] > 0 then Ent:Fire("Break") end
			if !(Ent:IsValid()) or Ent:IsWorld() then
				self:Disable()
				self:EmitSound("weapons/horus/icecrack-0"..math.random(1,5)..".wav", 75, 150, 1, CHAN_AUTO)
				
				elseif Ent.Health or Ent:GetClass() == "stand" then
				if (Ent:IsPlayer() or Ent:IsNPC() or Ent.Health or Ent:GetClass() == "stand") and Ent != self.Owner and Ent != self.Owner:GetActiveWeapon():GetStand() then 
					dmgInfo = DamageInfo()
					dmgInfo:SetAttacker(damager)
					dmgInfo:SetDamage(56 * self.id)
					dmgInfo:SetInflictor( self.Owner:GetActiveWeapon() )
					dmgInfo:SetDamageForce( Vector(0,0,0) )
					dmgInfo:SetReportedPosition(self:WorldSpaceCenter())
					Ent:TakeDamageInfo(dmgInfo)
					Ent:SetMaterial("models/player/shared/ice_player")
					timer.Simple(0.5, function() if IsValid(Ent) then Ent:SetMaterial("")  end end) 
					if Ent:IsPlayer() then
						Ent:Freeze(true)
						timer.Simple(0.5, function() Ent:Freeze(false)  end) 
					end
					if self.HitOnce then
						self:Disable()
					end
					self:EmitSound("weapons/horus/icecrack-0"..math.random(1,5)..".wav", 75, 200, 1, CHAN_AUTO)
					self:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav")
					
					
				end
			
			end
		end
	end
	function ENT:OnTakeDamage()
		self:Remove()
		self:EmitSound("physics/glass/glass_impact_bullet"..math.random(1,4)..".wav")
	end
end

if CLIENT then
	/*---------------------------------------------------------
	Name: ENT:Draw()
	---------------------------------------------------------*/
	function ENT:Draw()
        if !self.Owner:GetNoDraw() then
			self.Entity:DrawModel()
			local selfT = { Ents = self }
			local haloInfo = 
			{
				Ents = selfT,
				Color = Color(150,150,150,150),
				Hidden = when_hidden,
				BlurX = math.sin(CurTime()) * 5,
				BlurY = math.sin(CurTime()) * 5,
				DrawPasses = 2,
				Additive = true,
				IgnoreZ = false
			}
            if GetConVar("gstands_draw_halos"):GetBool() and self:WaterLevel() < 1 and render.SupportsHDR and !LocalPlayer():IsWorldClicking() then
				halo.Render(haloInfo)
			end
			elseif self:GetNWEntity("trail") then
			self:GetNWEntity("trail"):SetNoDraw(true)
		end
	end
end
