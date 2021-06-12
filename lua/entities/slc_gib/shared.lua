AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName= "gib"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "To stand"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_OPAQUE

local Whistle = Sound("weapons/chariot/armorwhistle.wav")

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Trail")
end
function ENT:Initialize()    --Initial animation base
    if SERVER then
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS )
	self:PhysicsInit(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject() 
	if IsValid(phys) then
		phys:Wake()
		phys:ApplyForceCenter(VectorRand() * 1555)
	end
	self:SetMoveType(MOVETYPE_VPHYSICS)
	if SERVER then
		timer.Simple(10,function() self:Remove() end)
	end
	self:DrawShadow(false)
	if SERVER then
		self:SetTrail(util.SpriteTrail(self, 0, Color(255,255,255,100), true, 10,10, 0.5, 0.5, "trails/smoke" ))
	end
end
	self:EmitStandSound(Whistle)

end
function ENT:OnRemove()
end

function ENT:Draw() 
	if IsPlayerStandUser(LocalPlayer()) then
		self.LastBlend = self.LastBlend or 5
		render.SetBlend(self.LastBlend)
		self.LastBlend = self.LastBlend - 0.01
		self:DrawModel()
	end 
	--if IsValid(IsPlayerStandUser(LocalPlayer())) then
		if IsPlayerStandUser(LocalPlayer()) then
			self:GetTrail():SetNoDraw(false)
		else
			self:GetTrail():SetNoDraw(true)
		end
	--end
end