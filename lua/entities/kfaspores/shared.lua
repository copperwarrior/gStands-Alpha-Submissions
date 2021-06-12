AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName= "KFASpores"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "To stand"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true
ENT.Animated = true

game.AddParticles("particles/kfar.pcf")
PrecacheParticleSystem("kfar")

local sporeloop = Sound("weapons/kfar/sporeloop.wav")
local sCrackle  = Sound("hrp.small-crackle")

function ENT:Initialize()    --Initial animation base
	self:DrawShadow(false)
	local name = self:EntIndex()
	self:SetRenderMode(RENDERMODE_TRANSADD)
	hook.Add("SetupMove", "SlowSpores"..name, function(ply, mv, cmd)
		if ply:IsValid() and self:IsValid() and ply != self.Owner then
			local dist = ply:GetPos():Distance(self:GetPos())
			if dist <= 256 then
				mv:SetMaxSpeed( dist / 2 )
				mv:SetMaxClientSpeed( dist / 2 )
				ply:ScreenFade(SCREENFADE.IN, Color(0,255,0,150 - dist / 2), 1, 0)
			end
			elseif ply:IsValid() and (self:IsValid() and ply != self.Owner) then
			hook.Remove("SetupMove", "SlowSpores"..name)
		end
	end)
	if CLIENT then
		self:SetRenderBounds(-Vector(250, 250, 250), Vector(250,250,250))
	end
	ParticleEffectAttach("kfar", PATTACH_POINT_FOLLOW, self, 1)
	if SERVER then
		local light = ents.Create("light_dynamic")
		light:SetPos(self:WorldSpaceCenter())
		light:SetParent(self)
		light:Spawn()
		light:Activate()
		light:SetKeyValue("distance", 514)
		light:SetKeyValue("brightness", 5)
		light:SetKeyValue("_light", "0 100 0 100")
		light:Fire("TurnOn")
	end
	local hooktag = self:EntIndex()
	hook.Add("EntityTakeDamage", "KFARSporeDamageLowerer"..hooktag, function(targ, dmg)
		if IsValid(self) and self.HasFlower then
			dmg:SetDamage(dmg:GetDamage() * 0.01)
		elseif !IsValid(self) then
			hook.Remove("EntityTakeDamage", "KFARSporeDamageLowerer"..hooktag)
		end
	end)
end

function ENT:OnRemove()
	if self.SFX then
		self.SFX:FadeOut(0.1)
	end
end
local mat = Material("models/kfar/dome")
function ENT:DrawTranslucent()
	render.SetMaterial(mat)
	render.SetBlend(1)
	render.DrawSphere(self:GetPos(), 250 + math.sin(CurTime() * 5), 30, 30, Color(12,255,12,15))
	if GetConVar("gstands_show_hitboxes"):GetBool() then
		local cmins, cmaxs = -Vector(200, 200, 200), Vector(200, 200, 200)
		render.DrawWireframeBox(self:GetPos(), Angle(0,0,0), cmins, cmaxs, Color(255,0,0,255), true)
	end
end
function ENT:Think()
	if SERVER then
		if !self.Owner:Alive() or !self.Owner:IsValid() then
			self:Remove()
		end
	end
	self.HealSFXTimer = self.HealSFXTimer or CurTime()
	if CLIENT and CurTime() >= self.HealSFXTimer then
		self.HealSFXTimer = CurTime() + SoundDuration(sporeloop) - 0.5
		if self.SFX then
			self.SFX:Stop()
		end
		self.SFX = nil
		self.SFX = CreateSound(self, sporeloop)
		self.SFX:Play()
	end
	self.lifetime = self.lifetime or CurTime() + 10
	if SERVER and CurTime() >= self.lifetime then
		self:Remove()
		if self.SFX then
			self.SFX:FadeOut(0.1)
		end
	end
	self.HasFlower = false
	local Slows = ents.FindInBox(self:GetPos() - Vector(200, 200, 200),self:GetPos() + Vector(200, 200, 200))
	for k,v in pairs(Slows) do
		if IsValid(v) then
			if v:GetClass() == "kfarose" then
				self.HasFlower = true
				if SERVER then
					self:EmitSound(sCrackle)
				end
			end
		end
	end
	for k,v in pairs(Slows) do
		if IsValid(v) then
			if !self.HasFlower then
				local phys = v:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocity(phys:GetVelocity()-phys:GetVelocity() * 0.5)
					if v:GetClass() == "emperor_bullet" then
						phys:SetVelocity(phys:GetVelocity()-phys:GetVelocity() * 0.5)
						phys:SetAngles(-phys:GetAngles())
					end
				else
					v:SetVelocity(v:GetVelocity()-v:GetVelocity() * 0.5)
				end
			end
		end
	end
	
	self:NextThink(CurTime())
	return true
end