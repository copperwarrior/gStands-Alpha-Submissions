ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "The Fool Sand Move"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 
ENT.AutomaticFrameAdvance = true
ENT.Animated = true


AddCSLuaFile("shared.lua")

local Loop = Sound("weapons/fool/flyloop.wav")
local Dissipate = Sound("weapons/fool/swoosh/swooshdunk.wav")

function ENT:Initialize()
	self.wep = self.Owner:GetActiveWeapon()
	if SERVER then
		self:SetModel("models/gstands/stand_acc/foolsand_effect.mdl")
		self:ResetSequence(2)
		self:SetCycle(0)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:DrawShadow(false)
		self:SetModelScale(2)
		timer.Simple((self:SequenceDuration()) - 0.5, function() if IsValid(self) then self:GrabPlayers() end end)
		timer.Simple((self:SequenceDuration())+ 0.1, function() if IsValid(self) then self:ResetSequence(3)self:SetModelScale(1) end end)
	end
	self:SetSkin(self.wep:GetStand():GetSkin())
	self.PlayersCaught = {}
	self.snd = self:StartLoopingSound(Loop)

end

function ENT:GrabPlayers()
	local mins, maxs = self:GetRotatedAABB(self:GetCollisionBounds())
	maxs.z = maxs.z * 20
	self.LocalDirs = {}
	for k,v in pairs(ents.FindInBox(self:LocalToWorld(mins), self:LocalToWorld(maxs))) do
		if v:IsPlayer() and v:Alive() then
			self.PlayersCaught[k] = v
			v.fool_OldHealth = v:Health()
			v.fool_OldMaxHealth = v:GetMaxHealth()
			v:Spectate(OBS_MODE_CHASE)
			v:SpectateEntity(self)
			v.fool_OldWeapons = {}
			v.fool_ActiveWeapon = v:GetActiveWeapon():GetClass()
			for i,j in pairs(v:GetWeapons()) do
				table.insert(v.fool_OldWeapons, j:GetClass())
			end
			v:StripWeapons()
			self.LocalDirs[k] = self:WorldToLocal(v:GetPos())
			v:ScreenFade(SCREENFADE.OUT, Color(0,0,0), 0.5, 0.1)
			timer.Simple(0.6, function() if IsValid(v) and v:Alive() and v:GetObserverMode() == OBS_MODE_CHASE then v:ScreenFade(SCREENFADE.IN, Color(0,0,0), 0.5, 0.1) end end)
		end
	end
	if not table.HasValue(self.PlayersCaught, self.Owner) then
		table.insert(self.PlayersCaught, self.Owner)
		self.Owner:Spectate(OBS_MODE_CHASE)
		self.Owner:SpectateEntity(self)
		self.Owner.fool_OldWeapons = {}
		for i,j in pairs(self.Owner:GetWeapons()) do
			table.insert(self.Owner.fool_OldWeapons, j:GetClass())
		end
		self.Owner:StripWeapons()
		table.insert(self.LocalDirs, self:WorldToLocal(self.Owner:GetPos()))
	end
end

function ENT:ReleasePlayers()
	for k,v in pairs(self.PlayersCaught) do
		if v:IsValid() and v:IsPlayer() and v:GetObserverMode() == OBS_MODE_CHASE then
			v:UnSpectate(OBS_MODE_CHASE)
			v:Spawn()
			for i,j in pairs(v.fool_OldWeapons) do
				v:Give(j)
			end
			v:SetHealth(v.fool_OldHealth)
			v:SetMaxHealth(v.fool_OldMaxHealth)
			v:SelectWeapon(v.fool_ActiveWeapon)
			local rand = VectorRand()
			rand.z = -math.abs(rand.z)
			local tr = util.TraceLine({
				start=self:GetPos() + Vector(0,0,155),
				endpos = self:LocalToWorld(self.LocalDirs[k])
			})
			v:SetPos(tr.HitPos)
		end
	end
end

function ENT:Think()
	if not IsValid(self) then return end
	if not IsValid(self.Entity) then return end
	if not IsValid(self.Owner) then self:ReleasePlayers() self:Remove() end
	if not self.Owner:Alive() then self:ReleasePlayers() self:Remove() end
	if self:GetSequence() == 2 then self:NextThink(CurTime()) return true end
	if not SERVER then return end
	local lastpos = self:GetPos()
	local tr = util.TraceLine({
		start = self:GetPos() + self:GetForward() * 5 + Vector(0,0,55),
		endpos = self:GetPos() + self:GetForward() * 5 - Vector(0,0,55),
		collisiongroup = COLLISION_GROUP_DEBRIS,
		mask=MASK_SOLID_BRUSHONLY
	})
	if tr.HitWorld then
		self:SetPos(tr.HitPos)
		else
		self:Remove()
		return
	end
	local ang = self.Owner:EyeAngles()
	ang.p = tr.HitNormal:Angle():Up():Angle().p
	self:SetAngles(ang)
	if self.Owner:KeyPressed(IN_JUMP) or self.Owner:KeyPressed(IN_USE) then
		self:ReleasePlayers()
		self:Remove()
	end
	self:NextThink(CurTime())
	
	return true
end

function ENT:OnRemove()
	self:ReleasePlayers()
	self:StopLoopingSound(self.snd)
	self:EmitSound(Dissipate)
end

local SandTable = {
	["models/gstands/stands/thefool.mdl0"] = Vector(0.9, 0.9, 0.5),
	["models/gstands/stands/thefool.mdl1"] = Vector(0.5, 0.5, 1),
	["models/gstands/stands/thefool.mdl2"] = Vector(1, 0.3, 0),
	["models/gstands/stands/thefool.mdl3"] = Vector(0.8, 0.8, 0.5),
	["models/gstands/stands/thefool.mdl4"] = Vector(1, 0.5, 0),
	["models/gstands/stands/thefool.mdl5"] = Vector(0.8, 0.8, 1),
}
local SandSkinTable = {
	["models/gstands/stands/thefool.mdl0"] = Material("models/gstands/stands/foolsand/foolsand"),
	["models/gstands/stands/thefool.mdl1"] = Material("models/gstands/stands/foolsand/foolsand_blue"),
	["models/gstands/stands/thefool.mdl2"] = Material("models/gstands/stands/foolsand/foolsand_red"),
	["models/gstands/stands/thefool.mdl3"] = Material("models/gstands/stands/foolsand/foolsand_brown"),
	["models/gstands/stands/thefool.mdl4"] = Material("models/gstands/stands/foolsand/foolsand_violet"),
	["models/gstands/stands/thefool.mdl5"] = Material("models/gstands/stands/foolsand/foolsand_lightblue"),
}
function ENT:GetSandColor(mdl, skin)
	index = mdl..skin
	return SandTable[index] or Vector(255,255,255)
end
local sand = Material("models/gstands/stands/foolsand/foolsand")
function ENT:GetSandSkinColor(mdl, skin)
	index = mdl..skin
	return SandSkinTable[index] or sand
end

if CLIENT then
	/*---------------------------------------------------------
	Name: ENT:Draw()
	---------------------------------------------------------*/
	function ENT:Draw()
	
		if IsPlayerStandUser(LocalPlayer()) then
			self:SetupBones()
			self.StandAura = self.StandAura or CreateParticleSystem(self, "sand_wave", PATTACH_POINT, 1)
			if self.StandAura then
				self.StandAura:SetControlPoint(1, self:GetSandColor("models/gstands/stands/thefool.mdl", self:GetSkin()))
				self.StandAura:SetControlPoint(0, self:GetPos())
			end
			
		if self.StandAura then
			self:SetupBones()
		end
			local oldpos = self:GetPos()
			local oldang = self:GetAngles()
			self:SetPos(self:GetPos() - Vector(0,0,1))
			self:SetupBones()
			local oldclip
			if self:GetSequence() == 3 then
				oldclip = render.EnableClipping(true)
				local normal = self:GetUp()
				local position = normal:Dot(oldpos)
				render.PushCustomClipPlane(normal, position)
			end
			self:DrawModel()
			if self:GetSequence() == 3 then
				render.PopCustomClipPlane()
				oldclip = render.EnableClipping(oldclip)
			end
			self:SetPos(self:GetPos() + Vector(0,0,1))
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