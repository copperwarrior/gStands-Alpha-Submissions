AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	
	local bound = self:GetWallBounds()
	self:PhysicsInitConvex({
		-bound,
		Vector(-bound.x,-bound.y,bound.z),
		Vector(-bound.x,bound.y,-bound.z),
		Vector(-bound.x,bound.y,bound.z),
		Vector(bound.x,-bound.y,-bound.z),
		Vector(bound.x,-bound.y,bound.z),
		Vector(bound.x,bound.y,-bound.z),
		bound
	})
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:DrawShadow(false)
	self:EnableCustomCollisions(true)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("gmod_silent")
		phys:AddGameFlag(bit.bor(FVPHYSICS_NO_PLAYER_PICKUP,FVPHYSICS_NO_SELF_COLLISIONS,FVPHYSICS_NO_NPC_IMPACT_DMG,FVPHYSICS_NO_IMPACT_DMG))
		phys:EnableMotion(false)
	end
	self.Invincible = true
self.BalloonList = {}
	for i=0, 10 do
		self.BalloonList[i] = ents.Create("d13balloon")
		self.BalloonList[i]:Spawn()
		self.BalloonList[i]:Activate()
	end
end

function ENT:OnRemove()
	if self:GetDreamlandDimension():IsValid() then
		self:GetDreamlandDimension():Remove()
	end
	for k,v in pairs(self.BalloonList) do
		if v:IsValid() then
			v:Remove()
		end
	end
end
