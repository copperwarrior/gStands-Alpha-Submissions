ENT.Type 			= "anim"
ENT.PrintName		= "Judgement Clone"
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 
ENT.Rendergroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
if SERVER then

AddCSLuaFile("shared.lua")
local jgm = Model("models/player/jgm/jgm.mdl")
local SwingSound = Sound( "WeaponFrag.Throw" )
local laugh = Sound( "jgm.laugh" )

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()
	self:SetModel(jgm)
	self.Lifetime = CurTime() + 5
	self:SetMoveType(MOVETYPE_NOCLIP)
	self:SetSkin(self.Owner:GetInfoNum("gstands_standskin_gstands_judgement", math.random(0, self:SkinCount() - 1)))
	self:ResetSequence("attack")
	self:EmitSound(laugh)
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
	if not IsValid(self) then return end
	local dir = -(self:GetPos() - self.Target:GetPos()):GetNormalized()
	self:SetAngles(dir:Angle())
	self:SetVelocity(dir * 1)
	local cmins, cmaxs = self:GetModelBounds()
	local tr = util.TraceHull({
		start = self:GetPos() + dir * 55,
	endpos = self:GetPos() + dir * 55,
	mins = cmins,
	maxs = cmaxs,
	ignoreworld = true,
	filter = function(ent) if ent == self.Target then return true else return false end end})
	if tr.Hit then
		self.Lifetime = CurTime() + 1
		local dmginfo = DamageInfo()
		local attacker = self.Owner
		dmginfo:SetAttacker( attacker )
		dmginfo:SetInflictor( self.Owner:GetActiveWeapon() or self )
		dmginfo:SetDamage( 50 )
		tr.Entity:TakeDamageInfo( dmginfo )
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
	
	self:DrawModel()
end
end