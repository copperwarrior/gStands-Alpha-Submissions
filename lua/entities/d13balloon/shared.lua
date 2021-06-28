ENT.Type 			= "anim"
ENT.PrintName		= "Balloon"
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 


if SERVER then

AddCSLuaFile("shared.lua")
local balloon = Model("models/d13/balloon.mdl")

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()
	self:SetHealth(5)
	self:SetModel(balloon)
	local color = ColorRand()
	self:SetColor(color)
	
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
	if not IsValid(self) then return end
	if not IsValid(Dreamland) then return end
		if Dreamland and !self.Rand1 then
	local StartPos = Dreamland:GetPos() + Vector(0,0,500)
	local Rand1 = VectorRand() * math.random(500, 1500)
	local tr = util.TraceLine({
		start = StartPos,
		endpos = StartPos + Rand1,
		mask = MASK_SHOT_HULL
	})
	self.Rand = tr.HitPos
	local Rand2 = VectorRand() * math.random(500, 1500)
	Rand2.z = math.abs(Rand2.z)
	local tr = util.TraceLine({
		start = StartPos,
		endpos = StartPos + Rand2,
		mask = MASK_SHOT_HULL
	})
	self.Rand1 = tr.HitPos
	local Rand3 = VectorRand() * math.random(500, 1500)
	Rand3.z = math.abs(Rand3.z)
	local tr = util.TraceLine({
		start = StartPos,
		endpos = StartPos + Rand3,
		mask = MASK_SHOT_HULL
	})
	self.Rand2 = tr.HitPos
	self.Rand3 = math.Rand(1,2)
	end
	if self.Rand then
		local pos = LerpVector(math.cos(CurTime() / 15), self.Rand, self.Rand1)
		self:SetPos(LerpVector(math.sin(CurTime() / 15), pos, self.Rand2))
	self:SetAngles(Angle(0,math.sin(CurTime() * (self.Rand3)) * 360,0))
	end
	self:NextThink(CurTime())
	return true
end
end

if CLIENT then
/*---------------------------------------------------------
   Name: ENT:Draw()
---------------------------------------------------------*/
function ENT:Draw()
	if Dreamland:IsValid() and !Dreamland:ShouldRenderInterior() then
		return
	end
	self:DrawModel()
end
end