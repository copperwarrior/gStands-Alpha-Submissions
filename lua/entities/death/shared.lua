ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName= "#gstands.names.d13"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "Geb"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
ENT.Animated = true
ENT.ImageID = 1
ENT.Rate = 0
ENT.Health = 1
ENT.CurrentAnim = "standidle"
ENT.State = false
ENT.Color = Color(255,255,255,75)
ENT.PhysgunDisabled = true
local Slash = Sound("weapons/d13/slash.wav")

local snd = false
function ENT:Slash()	
	local pos, ang = self:GetBonePosition(self:LookupBone("hand_l"))
	local tr = util.TraceHull({
		start=pos,
		endpos=pos,
		mins=Vector(-50,-50,-25),
		maxs=Vector(50,50,25),
		filter=function(ent) if ent:IsPlayer() then return true else return false end end
	})
	
	if ( SERVER and tr.Entity:IsValid() and (tr.Entity:IsPlayer())) then
		local dmginfo = DamageInfo()
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self.Owner end
		dmginfo:SetAttacker( attacker )
		dmginfo:SetInflictor( self.Owner:GetActiveWeapon() or self )
		dmginfo:SetDamage( 25 )
		tr.Entity:TakeDamageInfo( dmginfo )
		tr.Entity:SetVelocity( self.Owner:GetAimVector() * 1 + Vector( 0, 0, 5 ) )
		
		if !snd then
		local tra = util.TraceLine( {
			start = pos,
			endpos = tr.Entity:WorldSpaceCenter(),
			filter = {self},
			mask = MASK_SHOT_HULL
		} )
		tra.Entity:EmitStandSound(Slash)
		snd = true
	end
	
	if tr.Entity:IsPlayer() then
		tr.Entity:ViewPunch( Angle( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) ) )
	end
	
end
end

function ENT:Initialize()
	self:SetModel("models/d13/d13.mdl")
	self:Activate()
		self:SetSolid( SOLID_OBB )
		self:SetMoveType( MOVETYPE_NOCLIP )
		
		
		self:SetSolidFlags( FSOLID_NOT_STANDABLE )
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	if SERVER then
	self:SetPos(Dreamland:GetPos() + Vector(0,0, 1790))
	end
	--Initial animation base
	if SERVER then
		self:ResetSequence( self:LookupSequence(self.CurrentAnim) )
	end
	if self.Owner then
	self:SetHealth(self.Owner:Health())

	end
	local hooktag = self:EntIndex()
	hook.Add("SetupPlayerVisibility", "standnocullbreak"..hooktag, function(ply, ent) 
		if self:IsValid() and self.Owner:IsValid() then
			AddOriginToPVS( self:WorldSpaceCenter() )
		end
	end)
	self:SetSkin(self.Owner:GetInfoNum("gstands_standskin_gstands_death", math.random(0, self:SkinCount() - 1)))
end

function ENT:Disable(silent)
	if silent then
		self.Owner:KillSilent()
	else
		self.Owner:Kill()
	end
	self:Remove()
end

function ENT:OnRemove()
	if CLIENT and self.Aura then
		self.Aura:StopEmission()
	end
end

local speeds = {
	["models/d13/d13.mdl"] = 8,
	["models/d13/balloon.mdl"] = 6.6,
}

function ENT:Think() 
	if self.Owner then
		self:SetHealth(self.Owner:Health())
		self.Wep = self.Wep or self.Owner:GetWeapon("gstands_death")
	else
		self:Remove()
	end
	self:SetVelocity(-self:GetVelocity())
	offset = Vector()
	if SERVER and IsValid(Dreamland) and self.Owner:IsValid() and self.Owner:Alive() then
			self.DefPos = Dreamland:GetPos() + Vector(0,0, 1600)
				offset.z = 0
				offset.x = 0
				offset.y = 0
		if self:GetSequence() != self:LookupSequence("scytheattack") and self:GetSequence() != self:LookupSequence("scythethrow") then
			snd = false
			self:ResetSequence(self:LookupSequence("standidle"))
		end
		if self:GetSequence() != self:LookupSequence("standidle") and self:GetCycle() >= 0.99 then
			self:ResetSequence(self:LookupSequence("standidle"))
		end
			if (!self.Wep:GetInDoDoDo()) then
			self:SetPos(LerpVector(0.01, self:GetPos(), self.DefPos))
			end
			if self:GetModel() == "models/d13/balloon.mdl" then
				local ang = self:GetAngles()
				ang.p = 0
				ang.y = ang.y + 1
				self:SetAngles(ang)
				else
				self:SetAngles(LerpAngle(0.3, self:GetAngles(), self.Owner:EyeAngles()))
			end
		if self.Wep:GetInDoDoDo() then
			self.Owner:AddFlags(FL_ATCONTROLS)
			if self:GetModel() == "models/d13/d13.mdl" then
				if self:GetPos().x > self.DefPos.x + 2700 or self:GetPos().x < self.DefPos.x - 800
				or self:GetPos().y > self.DefPos.y + 1500 or self:GetPos().y < self.DefPos.y - 800
				or self:GetPos().z > self.DefPos.z or self:GetPos().z < self.DefPos.z - 1600 then
							self:SetPos(LerpVector(0.1, self:GetPos(), self.DefPos))
				end
			end
			if self:GetModel() == "models/d13/balloon.mdl" then
				if self:GetPos().x > self.DefPos.x + 4700 or self:GetPos().x < self.DefPos.x - 1800
				or self:GetPos().y > self.DefPos.y + 3500 or self:GetPos().y < self.DefPos.y - 1800
				or self:GetPos().z > self.DefPos.z or self:GetPos().z < self.DefPos.z - 1600 then
							self:SetPos(LerpVector(0.1, self:GetPos(), self.DefPos))
				end
			end			
			local speed = speeds[self:GetModel()]
			if self.Owner:KeyDown(IN_SPEED) then
				speed = speed * 2
			end
			if self.Owner:KeyDown(IN_FORWARD) and util.PointContents(self:WorldSpaceCenter() + self.Owner:GetAimVector() * 1) != CONTENTS_SOLID then
				self:SetPos(LerpVector(0.5, self:GetPos(),self:GetPos() + self.Owner:GetAimVector() * speed))
			end
			if self.Owner:KeyDown(IN_BACK) and util.PointContents(self:WorldSpaceCenter() - self.Owner:GetAimVector() * 1) != CONTENTS_SOLID then
				self:SetPos(LerpVector(0.5, self:GetPos(),self:GetPos() - self.Owner:GetAimVector() * speed))
			end
			if self.Owner:KeyDown(IN_MOVELEFT) and util.PointContents(self:WorldSpaceCenter() - self.Owner:GetRight() * 1) != CONTENTS_SOLID then
				self:SetPos(LerpVector(0.5, self:GetPos(),self:GetPos() - self.Owner:GetAimVector():Angle():Right() * speed))
			end
			if self.Owner:KeyDown(IN_MOVERIGHT) and util.PointContents(self:WorldSpaceCenter() + self.Owner:GetRight() * 1) != CONTENTS_SOLID then
				self:SetPos(LerpVector(0.5, self:GetPos(),self:GetPos() + self.Owner:GetAimVector():Angle():Right() * speed))
			end
			if self.Owner:KeyDown(IN_DUCK) and self:GetModel() != "models/d13/balloon.mdl" then
			self:SetModel("models/d13/balloon.mdl")
			elseif !self.Owner:KeyDown(IN_DUCK) and self:GetModel() == "models/d13/balloon.mdl" then
			self:SetModel("models/d13/d13.mdl")
			self:ResetSequence( self:LookupSequence(self.CurrentAnim) )
			end
			elseif !self.Wep:GetInDoDoDo() then
			self.Owner:RemoveFlags(FL_ATCONTROLS)
		end
		if self:GetSequence() == self:LookupSequence("scytheattack") and CurTime() > self.Timer and self:GetCycle() < 0.7 then
			self:Slash()
		end
		if self.Owner:IsFlagSet(FL_FROZEN) or (self:GetMoveType() == MOVETYPE_NONE and !self.Owner:GetNWBool("Active_"..self.Owner:GetName())) then
			self:SetPlaybackRate(0)
			self:RemoveAllGestures()
			elseif !self.Owner:KeyDown(IN_ATTACK2) then
			self:SetPlaybackRate(1)
		end
		elseif SERVER then
		self:Remove()
		end
	if CLIENT then
		self:SetNextClientThink( CurTime() )
	end
	self:NextThink( CurTime() + 0.00001) 
	return true
end
				
function ENT:OnTakeDamage(dmg)
	if string.StartWith(dmg:GetInflictor():GetClass(), "gstands_") then
		self.Owner:TakeDamageInfo(dmg)
		return false
	end
end

function ENT:Draw()
return false
end
function ENT:DrawTranslucent()
	if CLIENT and LocalPlayer():GetActiveWeapon()  then
	if LocalPlayer():IsValid() and LocalPlayer():GetActiveWeapon():IsValid() and string.StartWith(LocalPlayer():GetActiveWeapon():GetClass(), "gstands_") then
		self.Aura = self.Aura or CreateParticleSystem(self.Owner, "auraeffect", PATTACH_POINT_FOLLOW, 0)
		self.Aura:SetControlPoint(1, gStands.GetStandColor(self:GetModel(), self:GetSkin()))
		self.StandAura = self.StandAura or CreateParticleSystem(self, "auraeffect", PATTACH_POINT_FOLLOW, 0)
		self.StandAura:SetControlPoint(1, gStands.GetStandColor(self:GetModel(), self:GetSkin()))
		
		self:DrawModel() -- Draws Model Client Side

	end
	elseif self.Aura and self.StandAura then
		self.Aura:StopEmission()
		self.StandAura:StopEmission()
		self.Aura = nil
		self.StandAura = nil
	end
	
	if GetConVar("gstands_show_hitboxes"):GetBool() then
		for i = 0, self:GetHitBoxCount(0) - 1 do
			local cmins, cmaxs = self:GetHitBoxBounds(i, 0)
			local cpos, cang = self:GetBonePosition(self:GetHitBoxBone(i, 0))
			render.DrawWireframeBox(cpos, cang, cmins, cmaxs, Color(255,0,0,255), true)
		end
		local cmins, cmaxs = self:GetCollisionBounds()
		render.DrawWireframeBox(self:GetPos(), self:GetAngles(), cmins, cmaxs, Color(0,255,0,255), true)
		local pos = self:GetPos()
		render.DrawWireframeBox(pos, self:GetAngles(), Vector(-35, -35, 0), Vector(5, 45, 65), Color(255,255,0,255), false)
		end

end
