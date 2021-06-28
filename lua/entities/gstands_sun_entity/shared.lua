ENT.Type 			= "anim"
ENT.PrintName		= "Sun"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 
ENT.AutomaticFrameAdvance = true
ENT.Animated = true
ENT.Color = Color(150,150,150,1)
ENT.ForceOnce = false
ready = false
ENT.ImageID = 1
ENT.Rate = 0
ENT.Health = 1
ENT.rgl = 1.3
ENT.ggl = 1.3
ENT.bgl = 1.3
ENT.rglm = 1.3
ENT.gglm = 1.3
ENT.bglm = 1.3
ENT.FlameFX = nil
ENT.PhysgunDisabled = true
ENT.Range = 150
ENT.ItemPickedUp = NUL
ENT.Speed = 1
ENT.POWER = 1
ENT.Flashlight = self
ENT.Model = ""
ENT.OwnerName = ""
ENT.RotateSpeed = 1
ENT.DisableDuplicator = true
ENT.DoNotDuplicate = true

game.AddParticles("particles/sun.pcf")

PrecacheParticleSystem("gstands_sunbeams")
PrecacheParticleSystem("sunlaser_impact")

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 1, "InDoDoDo")
end
if SERVER then
local suncooldowntimer = CurTime()
hook.Add("Think", "gStandsSunCooldown", function()
	if CurTime() > suncooldowntimer then
		for k,v in pairs(player.GetAll()) do
			if !v:GetNWBool("gStandsInTheSun") then
				v:SetNWFloat("gStandsSunStroke", math.max(0, v:GetNWFloat("gStandsSunStroke") - 1))
			end
		end
		suncooldowntimer = CurTime() + 0.2
	end
end)	
hook.Add("SetupMove", "gStandsSunStroke", function(ply, mv, cmd)
		if ply:IsValid() then
			if ply:GetNWFloat("gStandsSunStroke") >= 10 then
				mv:SetMaxSpeed( 200 )
				mv:SetMaxClientSpeed( 200 )
			end
			if ply:GetNWFloat("gStandsSunStroke") >= 20 then
				mv:SetMaxSpeed( 128 )
				mv:SetMaxClientSpeed( 128 )
			end
			if ply:GetNWFloat("gStandsSunStroke") >= 30 then
				mv:SetMaxSpeed( 64 )
				mv:SetMaxClientSpeed( 64 )
			end
		end
	end)
hook.Add("EntityTakeDamage", "gStandsSunStroke", function(ply, dmg)
		local att = dmg:GetAttacker()
		if ply:IsValid() and att:IsPlayer() then
			if att:GetNWFloat("gStandsSunStroke") >= 20 then
				dmg:SetDamage(dmg:GetDamage() / 2)
			end
			if att:GetNWFloat("gStandsSunStroke") >= 30 then
				dmg:SetDamage(dmg:GetDamage() / 5)
			end
		end
	end)
hook.Add("PlayerDeath", "gStandsSunStroke", function(ply, dmg)
		ply:SetNWFloat("gStandsSunStroke", 0)
	end)
AddCSLuaFile("shared.lua")
function ENT:Initialize()
	self:SetModel("models/sun/gstands_sun.mdl")
	self:SetModelScale(175)
	self.Entity:SetMoveType(MOVETYPE_NOCLIP)
	self.Entity:SetSolid(SOLID_OBB)
	self.NextThink = CurTime()
	self.Range = GetConVar("gstands_the_sun_range"):GetFloat()
	self.Rangesqrd = GetConVar("gstands_the_sun_range"):GetFloat() ^ 2
	self.CanTool = false
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
local PhaseMessagesHot = {
	["10"] = "#gstands.sun.heatstroke.one",
	["20"] = "#gstands.sun.heatstroke.two",
	["30"] = "#gstands.sun.heatstroke.three"
	}
function ENT:Think()
	
	if not IsValid(self) then return end
	if not IsValid(self.Owner) then return end
	if not IsValid(self.Entity) then return end
	self.DoDoDoTimer = self.DoDoDoTimer or CurTime()
	if self.Owner:GetInfoNum("gstands_active_dododo_toggle", 1) == 1 and SERVER and CurTime() > self.DoDoDoTimer and self.Owner:gStandsKeyDown("dododo") and self.StandId != GSTANDS_JST then
		self.DoDoDoTimer = CurTime() + 0.3
		self:SetInDoDoDo(!self:GetInDoDoDo())
	end
	if self.Owner:GetInfoNum("gstands_active_dododo_toggle", 1) == 0 then
		self:SetInDoDoDo(self.Owner:gStandsKeyDown("dododo"))
	end
	self:SetVelocity(-self:GetVelocity())
	self.StandVelocity = self.StandVelocity or Vector(0,0,0)
	self.Pos = self:GetPos()
	if SERVER and self:GetInDoDoDo() then
			self.Owner:AddFlags(FL_ATCONTROLS)
			if !((self.StandId == GSTANDS_TGRAY) and self.Owner:KeyDown(IN_SPEED) and IsValid(self.Wep) and IsValid(self.Wep:GetLockTarget())) and self.Owner:KeyDown(IN_FORWARD) then
				self.StandVelocity = (self.StandVelocity + self.Owner:GetAimVector()):GetNormalized()
			end
			if self.Owner:KeyDown(IN_BACK) then
				self.StandVelocity = (self.StandVelocity - self.Owner:GetAimVector()):GetNormalized()
			end
			if self.Owner:KeyDown(IN_MOVELEFT) then
				self.StandVelocity = (self.StandVelocity - self.Owner:GetAimVector():Angle():Right()):GetNormalized()
				self.Pos = self:GetPos()
			end
			if self.Owner:KeyDown(IN_MOVERIGHT) then
				self.StandVelocity = (self.StandVelocity + self.Owner:GetAimVector():Angle():Right()):GetNormalized()
				self.Pos = self:GetPos()
			end
		elseif !self:GetInDoDoDo() and self.StandId != GSTANDS_JST then
			self.Owner:RemoveFlags(FL_ATCONTROLS)
			
		end
		self.StandVelocity.Z = 0
		local FTr = util.TraceLine({
				start = self.Pos,
				endpos = self.Pos + self.StandVelocity * self.Speed * 5,
				filter = {self, self.Owner},
				collisiongroup = self:GetCollisionGroup()
				})
			if FTr.Hit then
				self.StandVelocity = self.StandVelocity + FTr.HitNormal/5
			end
			if self:GetInDoDoDo() then
				self:SetPos((self.Pos + self.StandVelocity * FTr.Fraction * self.Speed))
			end
		self.StandVelocity = self.StandVelocity / 1.1
		if (self.StandId == GSTANDS_TGRAY) then
			self.StandVelocity = self.StandVelocity / 1.5
		end
		
		local curtime = CurTime()
		self.SunTimer = self.SunTimer or CurTime()
		self.SunInterval = self.SunInterval or 1
	if SERVER and CurTime() > self.SunTimer then
		self.SunTimer = CurTime() + self.SunInterval
		self.light:SetKeyValue("brightness", math.Clamp(10 - self.SunInterval * 2, 0.1, 10))
		local InSphere = {}
		for k,v in pairs(player.GetAll()) do
				local tr = util.TraceLine( {
					start = self:GetPos(),
					endpos = v:WorldSpaceCenter(),
					filter = self,
					mask = MASK_SHOT_HULL
				} )
				if (tr.Entity == v) and v:GetPos():DistToSqr(self:GetPos()) <= self.Rangesqrd then
					v:SetNWBool("gStandsInTheSun", true)
					v:SetNWFloat("gStandsSunStroke", math.min(75, v:GetNWFloat("gStandsSunStroke") + 1))
					if PhaseMessagesHot[tostring(v:GetNWFloat("gStandsSunStroke"))] then
					v:ChatPrint(PhaseMessagesHot[tostring(v:GetNWFloat("gStandsSunStroke"))])
					end
					--10
					--20
					--30
					if v:GetNWFloat("gStandsSunStroke") >= 30 then
						local dmginfo = DamageInfo()
						
						local attacker = self.Owner
						dmginfo:SetAttacker( attacker )
						dmginfo:SetDamageType(DMG_SLOWBURN)
						dmginfo:SetInflictor( self )
						--High damage, but not quite enough to kill.
						dmginfo:SetDamage( 15 )
						
						tr.Entity:TakeDamageInfo( dmginfo )
					end
					
			else
			v:SetNWBool("gStandsInTheSun", false)
				end
		end
	end
	self:NextThink(CurTime())
	return true
end

function ENT:Disable()
	self:Remove()
end

function ENT:OnRemove()
	for k,v in pairs(player.GetAll()) do
		v:SetNWBool("gStandsInTheSun", false)
	end
	self.Owner:RemoveFlags(FL_ATCONTROLS)
end
function ENT:OnTakeDamage(dmg)
	if dmg:GetAttacker() ~= self.Owner then
		self.Owner:TakeDamageInfo(dmg)
		return false
	end
end
end

if CLIENT then
/*---------------------------------------------------------
   Name: ENT:Draw()
---------------------------------------------------------*/
hook.Add("RenderScreenspaceEffects", "TheSunHeat", function()
	if LocalPlayer():GetNWInt("gStandsSunStroke") >= 20 then
		DrawMaterialOverlay("models/shadertest/predator", 0.01 * LocalPlayer():GetNWInt("gStandsSunStroke") / 10)
	end
	if LocalPlayer():GetNWInt("gStandsSunStroke") >= 30 then
		local mult = (LocalPlayer():GetNWInt("gStandsSunStroke") - 30) / (75 - 30)
		local tabL = {
		[ "$pp_colour_addr"] = 0,
		[ "$pp_colour_addg"] = 0,
		[ "$pp_colour_addb"] = 0,
		[ "$pp_colour_brightness" ] = math.max(0, 0.1 * mult),
		[ "$pp_colour_contrast" ] = math.max(1, 1.3 * mult),
		[ "$pp_colour_colour" ] = math.max(1, 1 * mult),
		[ "$pp_colour_mulr" ] = math.max(0, 1.5 * mult),
		[ "$pp_colour_mulg" ] = math.max(0, 1.1 * mult),
		[ "$pp_colour_mulb" ] = math.max(0, 1.1 * mult)
		}
		tab = tabL
		DrawColorModify( tabL )
	end
	
end)
function ENT:Initialize()
local hooktag = self.Owner:GetName()
	
	
end
local pinch = Material("effects/strider_pinch_dudv")
local sun = Material("effects/gstands_sun")
local ring = Material("particle/particle_ring_refract_01")
local heat = Material("sprites/heatwave")
function ENT:Draw()
	self.StandAura = self.StandAura or CreateParticleSystem(self, "gstands_sunbeams", PATTACH_POINT_FOLLOW, 1)
		if self.StandAura then
			self.StandAura:SetControlPoint(0, self:GetPos())
			self.StandAura:SetShouldDraw(true)
		end
	render.SetMaterial(sun)
	 self.StandAura:Render()
	 render.DrawSprite(self:GetPos(), 512, 512, Color(255,255,255))
		 self:DrawModel()
end
end