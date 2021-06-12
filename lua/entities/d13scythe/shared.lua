ENT.Type 			= "anim"
ENT.PrintName		= "Scythe"
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 
ENT.Rendergroup = RENDERGROUP_BOTH

if SERVER then

AddCSLuaFile("shared.lua")
local scythe = Model("models/d13/d13scythe.mdl")
local SwingSound = Sound( "WeaponFrag.Throw" )
local Slash = Sound("weapons/d13/slash.wav")
local Grab = Sound("weapons/d13/grabscythe.wav")

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()
	self:SetModel(scythe)
self:SetAngles((self.Owner:GetAimVector()):Angle() + Angle(-90,90,0))
	local players = {}
	for k,v in pairs(player.GetAll()) do
		if Dreamland:PositionInside(v:GetPos()) then
			table.insert(players, v)
		end
	end
	self.Target = table.Random(players)
	self.Lifetime = CurTime() + 5
	self.OwnerStand = self.Owner:GetActiveWeapon():GetStand()
	self.OwnerStand:SetBodygroup(1, 1)
	self.Velocity = self.Owner:GetAimVector() * 15
	self:SetSkin(self.Owner:GetInfoNum("gstands_standskin_gstands_death", math.random(0, self:SkinCount() - 1)))
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
	if not IsValid(self) then return end
	if not IsValid(Dreamland) then return end
	if CurTime() > self.Lifetime then self:Remove() self.OwnerStand:SetBodygroup(1, 0) self.OwnerStand:SetCycle(0.8) self.OwnerStand:EmitStandSound(Grab) return end
	local percent = -(CurTime() - self.Lifetime)/5
	local dir
	if !IsValid(self.Target) then
		dir = self.Owner:GetAimVector()
		else
		dir = (self.Target:WorldSpaceCenter() - self:GetPos()):GetNormalized()
	end
	local ang = dir:Angle() + Angle(-90,90,0)
	
	self.Velocity = self.Velocity or Vector(0,0,0)
	if percent > 0.3 then
	self.Velocity = (self.Velocity + dir)
	self:SetPos(self:GetPos() + self.Velocity * 5)
	self.Velocity = self.Velocity * 0.5
	ang:RotateAroundAxis(dir:Angle():Right(), percent * 6000)
	self:SetAngles(ang)
	local cmins, cmaxs = self:GetModelBounds()
	local tr = util.TraceHull({
		start = self:GetPos(),
	endpos = self:GetPos(),
	mins = cmins,
	maxs = cmaxs,
	filter = function(ent) if ent:IsPlayer() then return true else return false end end})
	if tr.Hit then
		self.Lifetime = CurTime() + 1
		local dmginfo = DamageInfo()
		local attacker = self.Owner
		dmginfo:SetAttacker( attacker )
		dmginfo:SetInflictor( self.Owner:GetActiveWeapon() or self )
		dmginfo:SetDamage( 300 )
		tr.Entity:TakeDamageInfo( dmginfo )
		self.Velocity = (self.Velocity + self.Velocity:Angle():Right())
		self:EmitStandSound(Slash)
	end
	else
	local pos, angl = self.OwnerStand:GetBonePosition(self.OwnerStand:LookupBone("hand_l"))
	local dir = (pos - self:GetPos()):GetNormalized()

	self.Velocity = (self.Velocity + dir)
	local dist = self:GetPos():Distance(pos) / 1500
	self.Velocity = (self.Velocity - self.Velocity:Angle():Right())
	self:SetPos(self:GetPos() + self.Velocity * 55 * dist)
	self.Velocity = self.Velocity * 0.5
		ang:RotateAroundAxis(dir:Angle():Right(), percent * 2000)

		self:SetAngles(ang)

	--self:SetAngles(LerpAngle(0.1, self:GetAngles(), angl + Angle(-90,-90,-45)))
	if self:GetPos():DistToSqr(pos) < 2500 then
		self:Remove()
		self.OwnerStand:SetCycle(0.9)
		self.OwnerStand:SetBodygroup(1, 0) 
		self.OwnerStand:EmitStandSound(Grab)
	end
	end
	self.SwingTimer = self.SwingTimer or CurTime()
	if CurTime() >= self.SwingTimer then
		self:EmitStandSound(SwingSound)
		self.SwingTimer = CurTime() + 0.2
	end
	self:NextThink(CurTime())
	return true
end
end

if CLIENT then
/*---------------------------------------------------------
   Name: ENT:Draw()
---------------------------------------------------------*/
function ENT:Initialize()
	self.Rand = VectorRand()
	self.Rand.z = math.abs(self.Rand.z * 2)
	self.Rand:Normalize()
		self.OwnerStand = self.Owner:GetActiveWeapon():GetStand()

end
function ENT:Draw()
	if Dreamland:IsValid() and !Dreamland:ShouldRenderInterior() then
		return
	end
	self:SetupBones()
	
		self.StandAura = self.StandAura or CreateParticleSystem(self, "d13foghand", PATTACH_POINT, 1)
		self.StandAura2 = self.StandAura2 or CreateParticleSystem(self, "d13fogarm", PATTACH_POINT, 1)
		if self.StandAura then
			self.StandAura:SetControlPoint(0, self:GetPos())
			self.StandAura:SetShouldDraw(true)
			self.StandAura2:SetControlPoint(0, self.OwnerStand:GetPos() + Vector(0,0,120))
			self.StandAura2:SetControlPoint(1, self:GetPos())
			self.StandAura2:SetControlPointForwardVector(1, -self:GetRight())
			self.StandAura2:SetShouldDraw(true)
		end
	self:DrawModel()
	self.StandAura:Render()
end
end