AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	
	self:SetModel("models/hunter/plates/plate32x32.mdl")
	self:SetModelScale("6")
	self:SetMaterial("models/shiny")
	self:SetAngles(Angle(180,0,0))
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:AddGameFlag(bit.bor(FVPHYSICS_NO_PLAYER_PICKUP,FVPHYSICS_NO_SELF_COLLISIONS,FVPHYSICS_NO_NPC_IMPACT_DMG,FVPHYSICS_NO_IMPACT_DMG))
		phys:EnableMotion(false)
	end
	local bound = self:GetWallBounds()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetColor( Color( 179, 153, 88 ) ) 
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	self:DrawShadow(false)
	self:EnableCustomCollisions(true)

	self.Invincible = true
	self.BalloonList = {}
	for i=0, 12 do
		self.BalloonList[i] = ents.Create("d13balloon")
		self.BalloonList[i]:Spawn()
		self.BalloonList[i]:Activate()
	end
end






function ENT:OnRemove()
	for k,v in pairs(self.BalloonList) do
		if v:IsValid() then
			v:Remove()
		end
	end
end
