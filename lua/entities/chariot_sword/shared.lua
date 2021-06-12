ENT.Type 			= "anim"
ENT.Base 			= "base_entity"
ENT.PrintName		= "Chariot Sword"
ENT.Author			= "Worshipper, well, sort of. most of it is his anyway"
ENT.Contact			= "Josephcadieux@hotmail.com"
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 
ENT.Own = NUL 
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Trail")
	self:NetworkVar("Bool", 1, "SwordFlame")
end
local Bounce = Sound("chariot.ting")
if SERVER then

AddCSLuaFile("shared.lua")

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()
	self.wep = self.Owner:GetActiveWeapon()
	self:SetModel("models/slc/swordproj.mdl")
	self:SetTrigger(true)
    --self:PhysicsInitSphere(25, "metal_bouncy")
    self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetFriction(0)
	local phys = self.Entity:GetPhysicsObject()
	phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
    phys:SetMaterial("metal_bouncy")
	self:GetPhysicsObject():SetVelocity(self:GetForward():GetNormalized() * 3500)
	self:SetNoDraw(false)
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(10)
	end
	local color = Color(255,255,255,255)
	if IsValid(self.wep) and IsValid(self.wep:GetStand()) then
		color = gStands.GetStandColorTable("models/player/slc/slc.mdl", self.wep:GetStand():GetSkin())
	end
	self:SetTrail(util.SpriteTrail(self, 0, color, true, 3,0, 0.5, 1/(3) * 0.5, "effects/beam_generic01.vmt" ))
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard3.wav")
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard2.wav")
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet2.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet3.wav")

	self.Hit = { 
	Sound("physics/metal/metal_grenade_impact_hard1.wav"),
	Sound("physics/metal/metal_grenade_impact_hard2.wav"),
	Sound("physics/metal/metal_grenade_impact_hard3.wav")};

	self.FleshHit = { 
	Sound("physics/flesh/flesh_impact_bullet1.wav"),
	Sound("physics/flesh/flesh_impact_bullet2.wav"),
	Sound("physics/flesh/flesh_impact_bullet3.wav")}

	self:GetPhysicsObject():EnableGravity(true)	

	self.CanTool = false
    	self.Entity:SetCollisionGroup(COLLISION_GROUP_NONE)
			self:Think()
	self.NPCTable = {}
	for k,v in pairs(ents.GetAll()) do
		if v:IsNPC() or v:IsPlayer() then
			table.insert(self.NPCTable, v)
		end
	end
end

function ENT:GetClosest(ply, vec)
	local closestply
	local closestdist
	
	for k, v in pairs(self.NPCTable or player.GetAll()) do
		if IsValid(v) and v != ply and v:Health() > 0 then
			local dist = vec:Distance(v:GetPos())
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

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
    self:GetPhysicsObject():SetMaterial("metal_bouncy")
	if not IsValid(self) then return end
	if not IsValid(self.Entity) then return end

    if GetConVar("phys_timescale"):GetInt() == 0 then
    
        self.lifetime = 40000
    else
        self.lifetime = self.lifetime or CurTime() + 2
    end
	if CurTime() > self.lifetime then
		self:Remove()
	end
	self:NextThink(CurTime())
	return true
end
function ENT:PhysicsCollide(data, obj)
	self:EmitStandSound(Bounce)
	self:GetPhysicsObject():SetVelocity(self:GetPhysicsObject():GetVelocity():GetNormalized() * 3500)
		local angleOfAttack = self:GetPhysicsObject():GetVelocity()
		local closest = self:GetClosest(self.Owner, self:GetPos(), angleOfAttack)
		if IsValid(closest) then
			local normal = (closest:WorldSpaceCenter() - self:GetPos()):GetNormalized()
			local tr = util.TraceLine({
				start = self:GetPos(),
				endpos = closest:WorldSpaceCenter(),
				filter = {self, self.Owner}
			})
		if angleOfAttack:Dot(normal) < 0.5 and tr.Entity == closest then
			self:GetPhysicsObject():SetVelocity(normal * 3500)
			self:GetPhysicsObject():SetAngles(self:GetPhysicsObject():GetVelocity():Angle())

		end
	end
	self.Bounces = self.Bounces or 1
	if data.HitEntity:IsWorld() then
		self.Bounces = self.Bounces + 1
	end
	
end
/*---------------------------------------------------------
   Name: ENT:Disable()
---------------------------------------------------------*/
function ENT:Disable()
    self:Remove()
end

function ENT:StartTouch(Ent)
	self.DontHit = {}
	local damager
	if  IsValid(self.Owner) then
		damager = self.Owner
		else
		damager = self.Entity
		return
	end
	
	if !(Ent:IsValid() or Ent:IsWorld()) or table.HasValue(self.DontHit, Ent) then return end
	
	if Ent.Health then
		if (Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") and Ent != self.Owner then 
			dmginfo = DamageInfo()
			local effectdata = EffectData()
			effectdata:SetStart(Ent:GetPos())
			effectdata:SetOrigin(Ent:GetPos())
			effectdata:SetScale(1)
			util.Effect("BloodImpact", effectdata)
			self:EmitSound(self.FleshHit[math.random(1,#self.Hit)])
			dmginfo:SetDamageType(DMG_SLASH)
			dmginfo:SetAttacker(self.Owner)
			dmginfo:SetInflictor(self.Owner:GetWeapon("gstands_silver_chariot"))
			self.Bounces = self.Bounces or 1
			dmginfo:SetDamage(200/(self.Bounces))
			if self:GetSwordFlame() then
				dmginfo:SetDamageType(DMG_BURN)
				dmginfo:AddDamage(50)
				tr.Entity:Ignite(5)
			end
			local tr = util.QuickTrace(self:GetPos(), self:GetPos() + self:GetForward(), {self})
			if tr.HitGroup == HITGROUP_HEAD then
				dmginfo:AddDamage(50)
			end
			Ent:TakeDamageInfo(dmginfo)
			self.wep:DoBleed(Ent)
			table.insert(self.DontHit, Ent)
		end
		
	end
    if IsValid(self) and self.Owner != nil and self.Owner:IsValid() and Ent == self.Owner then
        if self and self.wep and self.wep.GetStand and IsValid(self.wep:GetStand()) then
            self.wep:GetStand():SetBodygroup(1, 1)
            self.Owner:GetActiveWeapon():SetNextSecondaryFire( CurTime() )
            self:Remove()
        end
    end
    end

end
function ENT:Draw()
	if IsPlayerStandUser(LocalPlayer()) then
		self:SetAngles(self:GetVelocity():GetNormalized():Angle())
		self:DrawModel()
		if self:GetSwordFlame() then
			self.FlameFX1 = self.FlameFX1 or CreateParticleSystem(self, "chariotflame", PATTACH_POINT_FOLLOW, 1)
		end
		if !self:GetSwordFlame() and self.FlameFX1 then
			self.FlameFX1:StopEmission()
			self.FlameFX1 = nil
		end
	end
	if !(LocalPlayer():GetActiveWeapon() and LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer())) and IsValid(self:GetTrail()) then
		self:GetTrail():SetNoDraw(true)
	end
end
