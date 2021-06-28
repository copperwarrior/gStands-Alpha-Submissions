AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName= "KFARose"
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
PrecacheParticleSystem("kfarose2")

local healloop = Sound("weapons/kfar/heal.wav")
local healenter = Sound("weapons/kfar/healenter.wav")
local healexit = Sound("weapons/kfar/healexit.wav")

function ENT:Initialize()    --Initial animation base
    if SERVER then
    self:SetUseType(CONTINUOUS_USE)
    self:SetSolid(SOLID_OBB)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS )
	end
	self:SetModel("models/kfar/kfarose.mdl")
	self:ResetSequence(1)
	self:SetRenderMode(RENDERMODE_WORLDGLOW)
	ParticleEffectAttach("kfarose2", PATTACH_POINT_FOLLOW, self, 1)

end
function ENT:OnRemove()
	if self.SFX then
		self.SFX:FadeOut(1)
	end
end

function ENT:DrawTranslucent()
        if !self.Owner:GetNoDraw() then
        self.Color = Color(10,150,10,250)
    if !self.Owner:GetNoDraw() and CLIENT and LocalPlayer():GetActiveWeapon() then
        if LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then
		self.Aura = self.Aura or CreateParticleSystem(self, "auraeffect", PATTACH_POINT_FOLLOW, 1)
        self.Aura:SetControlPoint(1, Vector(self.Color.r / 255, self.Color.g / 255, self.Color.b / 255))

		local selfT = { Ents = self }
		local haloInfo = 
		{
			Ents = selfT,
			Color = Color(200,0,100,255),
			Hidden = when_hidden,
			BlurX = math.sin(CurTime()) * 5,
			BlurY = math.sin(CurTime()) * 5,
			DrawPasses = 5,
			Additive = true,
			IgnoreZ = false
		}
		self:DrawModel() -- Draws Model Client Side
         if GetConVar("gstands_draw_halos"):GetBool() and self:WaterLevel() < 1 and render.SupportsHDR and !LocalPlayer():IsWorldClicking() then

		halo.Render(haloInfo)
	end
	end
	end
	elseif self.Aura then
		self.Aura:StopEmission()
				self.Aura = nil
	end
	if GetConVar("gstands_show_hitboxes"):GetBool() then
		local cmins, cmaxs = -Vector(100, 100, 100), Vector(100, 100, 100)
		render.DrawWireframeBox(self:GetPos(), Angle(0,0,0), cmins, cmaxs, Color(255,0,0,255), true)
	end
end

function ENT:Draw()
end
function ENT:Think()
		if (SERVER and self.Owner:IsValid() and !self.Owner:Alive()) or (SERVER and !self.Owner:IsValid()) then
			self:Remove()
		end
		self.HealSFXTimer = self.HealSFXTimer or CurTime()
		if CLIENT and CurTime() >= self.HealSFXTimer then
				self.HealSFXTimer = CurTime() + SoundDuration(healloop) - 0.5
				if self.SFX then
					self.SFX:Stop()
				end
				self.SFX = nil
				self.SFX = CreateSound(self, healloop)
				self.SFX:Play()
		end
	self.HealTick = self.HealTick or CurTime()
	self.AlphaTick = self.AlphaTick or CurTime()
	if SERVER then
		if self:GetColor().a > 0 and CurTime() >= self.AlphaTick then
				local coltable = self:GetColor()
				coltable.a = coltable.a - 1
				self:SetColor(coltable)
				self.AlphaTick = CurTime() + 0.1
			elseif CurTime() >= self.AlphaTick then
				self:Remove()
				if self.SFX then
					self.SFX:FadeOut(0.05)
				end
			end
		self.HealTargets = self.HealTargets or {}
		local alltargets = {}
		if CurTime() >= self.HealTick then
			for k,v in pairs(ents.FindInBox(self:GetPos() - Vector(100, 100, 100), self:GetPos() + Vector(100, 100, 100))) do
				if SERVER and (v:IsPlayer() or v:IsNPC()) then
					if v.Spored then
						self:Heal(v, v.Spored)
					else
						self:Heal(v, false)
					end
					table.insert(alltargets, v)
					if !table.HasValue(self.HealTargets, v) then
						table.insert(self.HealTargets, v)
						self.Owner:ChatPrintFormatted("gstands.kfar.enter", v:GetName())
					end
				end
			self.HealTick = CurTime() + 1
			end
		for k,v in pairs(self.HealTargets) do
			if !table.HasValue(alltargets, v) then
				table.RemoveByValue(self.HealTargets, v)
				self.Owner:ChatPrintFormatted("gstands.kfar.exit", v:GetName())
			end
		end
		self.LastAmount = self.LastAmount or 0
		if #self.HealTargets > self.LastAmount then
			self:EmitStandSound(healenter)
		end
		if #self.HealTargets < self.LastAmount then
			self:EmitStandSound(healexit)
		end
		self.LastAmount = #self.HealTargets
		end
		if self.Owner:GetPos():DistToSqr(self:GetPos()) < 200 ^ 2 then
		if self.Owner:gStandsKeyDown("standleap") then
			self.Owner:SetVelocity(Vector(0,0,20))
		end
	end
		self:NextThink(CurTime())
		return true
	end
end
function ENT:Heal(ent, spored)
    if ent:Health() < ent:GetMaxHealth() then
	local mult = 3
	if spored then
		mult = 6
	end
	ent:SetHealth(math.Clamp(ent:Health() + 2 * mult, 0, ent:GetMaxHealth()))
	end
end