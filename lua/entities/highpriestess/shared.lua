ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName= "High Priestess"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "High Priestess"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
ENT.Animated = true
ENT.ImageID = 1
ENT.Rate = 0
ENT.Health = 1
ENT.CurrentAnim = "idle"
ENT.State = false
ENT.Color = Color(255,255,255,75)
ENT.PhysgunDisabled = true

local Slice1 = Sound("weapons/hip/slice1short.wav")
local Bang = Sound("weapons/hip/bang.wav")
local Clang = Sound("hip.clang")
local Swing = Sound( "WeaponFrag.Throw" )
function ENT:Initialize()
	self:SetModel("models/hipriestess/highpriestess.mdl")
	self:SetPos(self.Owner:WorldSpaceCenter())
	self:SetSolid( SOLID_OBB )
	self:SetMoveType( MOVETYPE_NOCLIP )
	self.Wep = self.Owner:GetActiveWeapon()
	if CLIENT then
		self:SetRenderBounds( Vector(-1256, -1256,-1256), Vector(1256, 1256,1256))
	end
	self:SetSolidFlags( FSOLID_NOT_STANDABLE )
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	--Initial animation base
	if SERVER then
		self:ResetSequence( self:LookupSequence("idle2") )
	end
	self:Think( )
	self:SetHealth(self.Owner:Health())
	if SERVER then
		self:SetSkin(self.Owner:GetInfoNum("gstands_standskin_"..self.Wep.ClassName, math.random(0, self:SkinCount() - 1)))
	end
	local hooktag = self.Owner:Name()..self:EntIndex()
	hook.Add("SetupPlayerVisibility", "standnocullbreak"..hooktag, function(ply, ent) 
		if self:IsValid() and self.Owner:IsValid() and self.Wep:GetInDoDoDo() then
			AddOriginToPVS( self:WorldSpaceCenter() )
		end
	end)
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
	self.Owner:RemoveFlags(FL_ATCONTROLS)
	if self.loop then
		self.loop:Stop()
	end
	if CLIENT and self.Aura then
		self.Aura:StopEmission()
	end
end

hook.Add("SetupMove", "HighPriestessFan", function(ply, mv)
	if IsValid(ply) and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "gstands_highpriestess" then
		local self = ply:GetActiveWeapon():GetStand()
		if not self.Wep:GetInDoDoDo() and self.Model == "models/xqm/helicopterrotorbig.mdl" then
			local dir = (ply:EyePos() - (ply:EyePos() + ply:GetAimVector() * 55)):GetNormalized()
			ang = dir:Angle()
			mv:SetVelocity(mv:GetVelocity() - (dir * 9.5))
		end
	end
end)
local dir = {
	Vector(1,0,0),
	Vector(0,1,0),
	Vector(0,0,1),
	-Vector(1,0,0),
	-Vector(0,1,0),
	-Vector(0,0,1),
}
local abilities = {
	["models/props_junk/sawblade001a.mdl"] = function(self)
		self:Slash(false, 1)
		local dir = (self.LastPos - self:GetPos() ):GetNormalized()
		if self.LastPos:Distance(self:GetPos()) <= 5 then
			dir = self.Owner:GetAimVector()
		end
		local ang = self.Owner:EyeAngles():Forward():Angle()
		ang:RotateAroundAxis(dir:Angle():Forward(), -90)
		ang:RotateAroundAxis(dir:Angle():Right(), CurTime() * -5590)
		self:SetAngles(ang)
		self.LastPos = self:GetPos()
	end,
	
	["models/props_junk/meathook001a.mdl"] = function(self)
		self.HookTimer = self.HookTimer or CurTime()
		dir = self.Owner:GetAimVector()
		local ang = self.Owner:EyeAngles():Forward():Angle()
		ang:RotateAroundAxis(dir:Angle():Up(), 90)
		ang:RotateAroundAxis(dir:Angle():Right(), CurTime() * 1555)
		self:SetAngles(ang)
		self:Slash(false, 1, 1000, self.Owner:GetAimVector() + self.Owner:GetUp())
		self.HookTimer = CurTime() + 2
	end,
	["models/props_junk/harpoon002a.mdl"] = function(self)
		if self.Wep:GetInDoDoDo() and self.Velocity:LengthSqr() > 15 then
			self:Slash(false, 5)
		end
		if self.Owner:GetPos():Distance((self:GetPos() + self:GetForward() * 15)) <= self.Range then
			self.Velocity = self.Velocity + self:GetForward() * 5
		end
	end,
	["models/xqm/helicopterrotorbig.mdl"] = function(self)
		local dir = self.Owner:GetAimVector()
		ang = dir:Angle()
		self:Slash(false, 1)
		ang:RotateAroundAxis(dir, CurTime() * 1550)
		--ang.y = self.Angl.y + 90
		self:SetAngles(ang)
		for k,v in pairs(ents.FindInCone(self.Pos, dir, 800, 0.606)) do
			if v ~= self and v ~= self.Owner then
				v:SetVelocity(-dir * 9.5)
				if IsValid(v:GetPhysicsObject()) then
					v:GetPhysicsObject():ApplyForceOffset(-dir * 155, self:GetPos())
				end
			end
		end
	end,
}
local primaryabilities = {
	["models/props_junk/harpoon002a.mdl"] = function(self)
		if not self.Wep:GetInDoDoDo() then
			if not self:GetHooked() then
				local tr = util.TraceHull({
					start=self:GetEyePos(),
					endpos = self:GetEyePos() + self.Owner:GetAimVector() * 2500,
					mins=Vector(-15,-15,-15),
					maxs=Vector(15,15,15),
					filter = {self, self.Owner}
				})
				if tr.Hit then
					if tr.HitWorld then
						self:SetHookPos(tr.HitPos)
						self:SetHooked(true)
						self:SetHookWorld(true)
					elseif tr.Entity:IsPlayer() or tr.Entity:IsStand() then
						self:SetHookEntity(tr.Entity)
						self:SetHooked(true)
						self:SetHookWorld(false)
					end
					if self:GetHooked() then
						self:EmitStandSound(Bang)
					end
				end
				else
				self:EmitStandSound(Clang)
				self.FullHook = false
				self:SetHooked(false)
			end
		end
	end
}
local passiveabilities = {
	["models/xqm/helicopterrotorbig.mdl"] = function(self)
		self:SetPos(self.Owner:EyePos() + self.Owner:GetAimVector() * 55)
		self.Pos = (self.Owner:EyePos() + self.Owner:GetAimVector() * 55)
		local dir = (self.Owner:EyePos() - (self.Owner:EyePos() + self.Owner:GetAimVector() * 55)):GetNormalized()
		ang = dir:Angle()
		self:Slash(false, 1)
		ang:RotateAroundAxis(dir, CurTime() * 1550)
		--ang.y = self.Angl.y + 90
		self:SetAngles(ang)
		for k,v in pairs(ents.FindInCone(self.Pos, dir, 800, 0.606)) do
			if v ~= self and v ~= self.Owner then
				v:SetVelocity(-dir * 9.5)
				if IsValid(v:GetPhysicsObject()) then
					v:GetPhysicsObject():ApplyForceOffset(-dir * 155, self:GetPos())
				end
			end
		end
	end,
	["models/props_junk/sawblade001a.mdl"] = function(self)
		self:Slash(false, 0.5)
		local dir = (self.Owner:WorldSpaceCenter() - (self.Owner:EyePos() + Vector(math.sin(CurTime() * 25), math.cos(CurTime() * 25), 0))):GetNormalized()
		local ang = dir:Angle()
		self:SetAngles(ang)

		self:SetPos(self.Owner:WorldSpaceCenter() + Vector(math.sin(CurTime() * 25), math.cos(CurTime() * 25), 0) * 55)
				self:Slash(false, 0.5)

		self.Pos = self:GetPos()
		self.LastPos = self:GetPos()
		self.SawSoundTimer = self.SawSoundTimer or CurTime()
		if CurTime() >= self.SawSoundTimer then
			self:EmitStandSound(Swing)
			self.SawSoundTimer = CurTime() + 0.2
		end
	end,
	["models/props_junk/meathook001a.mdl"] = abilities["models/props_junk/meathook001a.mdl"]
}
function ENT:Think() 
	
	self.OwnerPos = self.Owner:GetPos()
	self.OwnerCenterPos = self.Owner:WorldSpaceCenter()
	self.CenterPos = self:WorldSpaceCenter()
	self.Pos = self:GetPos()
	self.Forward = self:GetForward()
	self.InStill = self.Owner:gStandsKeyDown("modifierkey2")
	self.DistToOwner = self.Pos:Distance(self.OwnerPos)
	self.PullOut = self.PullOut or 0
	self.PullOut = math.Clamp(self.PullOut + 0.1,0, 0.9)
	self.Model = self:GetModel()
	if self.Wep:GetStand() ~= self then
		self:Remove()
		return
	end
	if SERVER then
		self:SetHPModel(self:GetModel())
	end
	self.Prop = self:GetProp()
	local offset = Vector(0,0,0)
	offset.z = 0
	offset.x = -20
	offset.y = 20
	
	self:SetVelocity(-self:GetVelocity())
	if self:GetHooked() then
		if self:GetHookWorld() then
			if self:GetPos():DistToSqr(self:GetHookPos()) > 3000 then
				local aimdir = (self:GetHookPos() - self:GetPos()):GetNormalized()
				self:SetPos(self:GetPos() + aimdir * 55)
			else
				if not self.FullHook then
					self:EmitStandSound(Clang)
					self.FullHook = true
				end
				self:SetPos(self:GetHookPos())
			end
		end
		if not self:GetHookWorld() and self:GetHookEntity():IsValid() then
			self:SetHookPos(self:GetHookEntity():WorldSpaceCenter())
		end
		if not self:GetHookWorld() and self:GetPos():DistToSqr(self:GetHookPos()) > 3000 then
			local aimdir = (self:GetHookPos() - self:GetPos()):GetNormalized()
			if self:GetPos():DistToSqr(self:GetHookPos()) > 3000 then
				self:SetPos(self:GetPos() + aimdir * 55)
			else
				if not self.FullHook then
					self:EmitStandSound(Clang)
					self.FullHook = true
				end
				self:SetPos(self:GetHookPos())
			end
			self:SetAngles((-aimdir):Angle())
		end
		
		if self:GetHookWorld() and self:GetPos():DistToSqr(self:GetHookPos()) < 1000 then
			local dir = (self:GetHookPos() - self.Owner:WorldSpaceCenter()):GetNormalized()
			self.Owner:SetVelocity(dir * 51)
		end
		if not self:GetHookWorld() and self:GetPos():DistToSqr(self:GetHookEntity():WorldSpaceCenter()) < 1000 then
			local dir = -(self:GetHookEntity():WorldSpaceCenter() - self.Owner:WorldSpaceCenter()):GetNormalized()
			self:GetHookEntity():SetVelocity(dir * self:GetHookPos():Distance(self.Owner:WorldSpaceCenter()))
		end
	end
	if IsFirstTimePredicted() then
		if self.Owner:IsValid() and self.Owner:Alive() then
			if self:GetGround() then
				local ang = self:GetAngles()
				ang.p = -90
				self:SetAngles(ang)
				
			end
			if !self:GetGround() and not self:GetHooked() then
				if SERVER and (!self:GetGround() and !self.InStill and !self.Wep:GetInDoDoDo() and self.Model != "models/xqm/helicopterrotorbig.mdl" and self.Model != "models/props_junk/meathook001a.mdl") then
					self:SetAngles(LerpAngle(0.3, self:GetAngles(), self.Owner:GetAimVector():Angle()))
				end
				if !(self:GetGround() or self.Wep:GetInDoDoDo() or self.InStill) and (self.Owner:GetActiveWeapon():IsValid() and self.Owner:GetActiveWeapon():GetHoldType() != "pistol") and self.Model != "models/props_vehicles/car004a_physics.mdl" then
					if SERVER then
						self:SetPos(LerpVector(self.PullOut, self.Pos, self.Owner:EyePos() + (self.Owner:GetForward() * offset.x) + (self.Owner:GetRight() * offset.y) - Vector(0,0,offset.z)))
						self.Pos = self:GetPos()
					end
					
					elseif SERVER and !((self.InStill or self.Wep:GetInDoDoDo() or self:GetGround() ) and self.DistToOwner <= self.Range) then
					if CLIENT and self.Owner == LocalPlayer() then
						self:SetPos(LerpVector(0.7, self.Pos, self.OwnerCenterPos + (self.Owner:GetAimVector() * (45 - self.Owner:EyeAngles().p / 2))))
						self.Pos = self:GetPos()
					end
					if SERVER then
						self:SetPos(LerpVector(0.9, self.Pos, self.OwnerCenterPos + (self.Owner:GetAimVector() * (45 - self.Owner:EyeAngles().p / 2))))
						self.Pos = self:GetPos()
					end
					local _, ang = self.Owner:EyePos()
					if SERVER and !self.InStill and !self.Wep:GetInDoDoDo() and !self:GetGround() and self.Model != "models/xqm/helicopterrotorbig.mdl" and self.Model != "models/props_junk/sawblade001a.mdl" and self.Model != "models/props_junk/meathook001a.mdl" then
						self:SetAngles(LerpAngle(0.3, self:GetAngles(), self.Owner:EyeAngles()))
					end
					self.Delay = CurTime() + 0.1
				end
			end
			
			self.Velocity = self.Velocity or Vector()
			if SERVER and not self:GetHooked() and self.Wep:GetInDoDoDo() and self.Model != "models/props_vehicles/car004a_physics.mdl" and self.Model != "models/props_junk/garbage_coffeemug001a.mdl" then
				self.Owner:AddFlags(FL_ATCONTROLS)
				if !self:GetGround() and self.Model != "models/props_junk/sawblade001a.mdl" and self.Model != "models/props_junk/meathook001a.mdl" and self.Model != "models/xqm/helicopterrotorbig.mdl" then
					self:SetAngles(LerpAngle(0.3, self:GetAngles(), (self.Owner:GetAimVector():Angle())))
				end
				if self.Model ~= "models/props_junk/harpoon002a.mdl" and self.Owner:KeyDown(IN_FORWARD) and (self.Pos + self.Owner:GetAimVector() *  math.max(5, (20 - self.DistToOwner/(self.Range / 10)) )):Distance(self.OwnerPos) <= self.Range and util.PointContents(self.CenterPos + self.Owner:GetAimVector() * 1) != CONTENTS_SOLID then
					self.Velocity = self.Velocity + self.Owner:GetAimVector() * 2
					self.Pos = self:GetPos()
					
				end
				if self.Model ~= "models/props_junk/harpoon002a.mdl" and self.Owner:KeyDown(IN_BACK) and (self.Pos - self.Owner:GetAimVector() * math.max(5, (20 - self.DistToOwner/(self.Range / 10)) )):Distance(self.OwnerPos) <= self.Range and util.PointContents(self.CenterPos - self.Owner:GetAimVector() * 1) != CONTENTS_SOLID then
					self.Velocity = self.Velocity - self.Owner:GetAimVector() * 2
					self.Pos = self:GetPos()
					
				end
				if self.Model ~= "models/props_junk/harpoon002a.mdl" and self.Owner:KeyDown(IN_MOVELEFT) and (self.Pos - self.Owner:GetRight() * math.max(5, (20 - self.DistToOwner/(self.Range / 10)) )):Distance(self.OwnerPos) <= self.Range and util.PointContents(self.CenterPos - self.Owner:GetRight() * 1) != CONTENTS_SOLID then
					self.Velocity = self.Velocity - self.Owner:GetAimVector():Angle():Right() * 2
					self.Pos = self:GetPos()
					
				end
				if self.Model ~= "models/props_junk/harpoon002a.mdl" and self.Owner:KeyDown(IN_MOVERIGHT) and (self.Pos + self.Owner:GetRight() * math.max(5, (20 - self.DistToOwner/(self.Range / 10)) )):Distance(self.OwnerPos) <= self.Range and util.PointContents(self.CenterPos + self.Owner:GetRight() * 1) != CONTENTS_SOLID then
					self.Velocity = self.Velocity + self.Owner:GetAimVector():Angle():Right() * 2
					self.Pos = self:GetPos()
					
				end
				
				elseif !self.Wep:GetInDoDoDo() then
				self.Owner:RemoveFlags(FL_ATCONTROLS)
				if SERVER and self.BlockCap then
					self.AITarget = self:GetNPCThreat() or NULL
					self.Blocking = self:BlockAI()
				end
				
			end				
			self.LastPos = self.LastPos or self:GetPos()
			
			
			local tra
			self.Speed = self.Speed or 1
			if self:GetGround() then
				tra = util.TraceHull( {
				start = self:GetPos() + self.Owner:GetAngles():Up() * 55,
				endpos = self:GetPos() - self.Owner:GetAngles():Up() * 1500,
				filter = {self.Owner, self, self},
				mins=Vector(-15,-15,-1),
				maxs=Vector(15,15,1)
				})
				if tra.HitWorld then
					self:SetPos(tra.HitPos)
				end
				if not tra.Hit then
					self:SetGround(false)
				end
			end
			if not self:GetHooked() and self.Wep:GetInDoDoDo() and not self:GetGround() then
				local tr = util.TraceLine({
					start=self:GetPos(),
					endpos = self:GetPos() + self.Velocity:GetNormalized() * self:BoundingRadius(),
					filter={self, self.Owner},
					collisiongroup = COLLISION_GROUP_DEBRIS
				})
				if tr.HitWorld then
					self.Velocity = self.Velocity + tr.HitNormal * self.Velocity:Length()
					if self.Velocity:Length() > 10 and self:GetHPModel() != "models/hipriestess/highpriestess.mdl" then
						local str = util.TraceLine({
							start=self:GetPos(),
							endpos = self:GetPos() + self:GetForward(),
							mask=MASK_SHOT_HULL,
							filter = function(ent) if ent == self then return true end return false end
						})
						self:EmitStandSound(util.GetSurfaceData(str.SurfaceProps).impactHardSound)
					end
				end
				self:SetPos(LerpVector(0.5, self.Pos,self.Pos + self.Velocity))
				if self.Model == "models/props_junk/harpoon002a.mdl" then
					self:SetAngles(LerpAngle(0.5, self:GetAngles(), self.Velocity:Angle()))
				end
				elseif self.Wep:GetInDoDoDo() and self:GetGround() then
				if self.Owner:KeyDown(IN_FORWARD) and (self.Pos + self.Owner:GetAimVector() *  math.max(5, (20 - self.DistToOwner/(self.Range / 10)) )):Distance(self.OwnerPos) <= self.Range then
					self.Velocity = self.Velocity + self.Owner:GetAimVector()
					self.Pos = self:GetPos()
					
				end
				if self.Owner:KeyDown(IN_BACK) and (self.Pos - self.Owner:GetAimVector() * math.max(5, (20 - self.DistToOwner/(self.Range / 10)) )):Distance(self.OwnerPos) <= self.Range then
					self.Velocity = self.Velocity - self.Owner:GetAimVector()
					self.Pos = self:GetPos()
					
				end
				if self.Owner:KeyDown(IN_MOVELEFT) and (self.Pos - self.Owner:GetRight() * math.max(5, (20 - self.DistToOwner/(self.Range / 10)) )):Distance(self.OwnerPos) <= self.Range then
					self.Velocity = self.Velocity - self.Owner:GetAimVector():Angle():Right()
					self.Pos = self:GetPos()
					
				end
				if self.Owner:KeyDown(IN_MOVERIGHT) and (self.Pos + self.Owner:GetRight() * math.max(5, (20 - self.DistToOwner/(self.Range / 10)) )):Distance(self.OwnerPos) <= self.Range then
					self.Velocity = self.Velocity + self.Owner:GetAimVector():Angle():Right()
					self.Pos = self:GetPos()
					
				end
				self.Velocity = self.Velocity:Cross(tra.HitNormal)
				self.Velocity:Rotate(Angle(0,90,0))
				local tr = util.TraceLine({
					start=self:GetPos() + Vector(0,0,15),
					endpos = self:GetPos() + Vector(0,0,15) + self.Velocity:GetNormalized() * self:BoundingRadius(),
					filter={self, self.Owner},
					collisiongroup = COLLISION_GROUP_DEBRIS
				})
				if tr.HitWorld then
					self.Velocity = self.Velocity + tr.HitNormal * self.Velocity:Length()
					if self.Velocity:Length() > 10 then
						local str = util.TraceLine({
							start=self:GetPos() - self:GetForward(),
							endpos = self:GetPos() + self:GetForward(),
							filter = function(ent) if ent == self then return true end return false end
						})
						self:EmitStandSound(util.GetSurfaceData(str.SurfaceProps).impactHardSound)
					end
				end
				self:SetPos(LerpVector(0.5, self.Pos,self.Pos + self.Velocity/3 * self.Speed))
				self:SetAngles(LerpAngle(0.3, self:GetAngles(), (self.Owner:GetAimVector():Angle())))
				end
			self.Velocity = self.Velocity * 0.9
			if IsValid(self.Prop) then
				self:SetPos(self.Prop:GetPos())
			end
			if self.Wep:GetInDoDoDo() and abilities[self.Model] then abilities[self.Model](self) end
			if self.Owner:KeyPressed(IN_ATTACK) and primaryabilities[self.Model] then primaryabilities[self.Model](self) end
			if not self.Wep:GetInDoDoDo() and passiveabilities[self.Model] then passiveabilities[self.Model](self) end

			elseif SERVER then
			self:Remove()
		end
		self:NextThink( CurTime() )
		return true
	end
end
function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Prop")
	self:NetworkVar("Bool", 1, "Ground")
	self:NetworkVar("Bool", 2, "InBlock")
	self:NetworkVar("String", 3, "HPModel")
	self:NetworkVar("Float", 4, "HeadScale")
	self:NetworkVar("Vector", 5, "HookPos")
	self:NetworkVar("Bool", 6, "Hooked")
	self:NetworkVar("Bool", 7, "HookWorld")
	self:NetworkVar("Entity", 8, "HookEntity")
end

function ENT:Slash(side, mult, knockbackmult, knockbackdir)
	local mult = mult or 1
	local knockbackmult = knockbackmult or 1
	local knockbackdir = knockbackdir or self.Owner:GetAimVector() + Vector( 0, 0, 5 )
	local hand = "ValveBiped.Bip01_R_Hand"
	if side then
		hand = "ValveBiped.Bip01_L_Hand"
	end
	pos = self:WorldSpaceCenter()
	if self.Model == "models/hipriestess/highpriestess.mdl" then
		local pos = self:GetBonePosition(self:LookupBone(hand))
	end
	local tr = util.TraceHull( {
		start = self:GetEyePos(),
		endpos = self:GetEyePos() + self:GetForward() * 75,
		filter = { self.Owner, self, self.Prop },
		mins = Vector( -15, -15, -15 ), 
		maxs = Vector( 15, 15, 15 ),
		ignoreworld = true,
		mask = MASK_SHOT_HULL
	} )
	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Entity && tr.Entity:IsValid() && !tr.Entity:IsWorld() && !( game.SinglePlayer() && CLIENT ) ) then
		--self.HitFX = self.HitFX or CreateSound( self, Impact )
		--self.HitFX:Play()
	end
	local hit = false
	if SERVER and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue("explosion", "2") tr.Entity:SetKeyValue("gibdir", tostring(self:GetAngles())) tr.Entity:Fire("Break") end
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self.Owner end
		dmginfo:SetAttacker( attacker )
		
		dmginfo:SetInflictor( self.Owner:GetActiveWeapon() or self )
		dmginfo:SetDamage( 15 * mult )
		tr.Entity:TakeDamageInfo( dmginfo )
		tr.Entity:SetVelocity( knockbackdir * knockbackmult )
		hit = true
		self:EmitStandSound(Slice1)
		if self.Model == "models/props_junk/sawblade001a.mdl" then
			self:EmitStandSound("Metal.SawbladeStick")
		end
	end
	if tr.Entity:IsPlayer() then
		tr.Entity:ViewPunch( Angle( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) ) )
	end
	if ( SERVER && IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 800 * phys:GetMass(), tr.HitPos )
		end
	end
	
	self.Owner:LagCompensation( false )
end
function ENT:GetClosest(ply, vec)
	local closestply
	local closestdist
	for k, v in pairs(player.GetAll()) do
		if v != ply then
			local dist = vec:Distance(v:GetPos())
			if not closestdist then
				closestdist = dist
				closestply = v
			end
			if dist < closestdist then
				closestdist = dist
				closestply = v
			end
		end
	end
	if closestply and closestply:WorldSpaceCenter():Distance(self.Owner:WorldSpaceCenter()) <= 1500 then
		return closestply:EyePos()
		else
		return self:GetEyePos(true) + self:GetForward() * 55
	end
end
function ENT:GetEyePos(head)
	if !head then head = false end
	if self.Wep:GetInDoDoDo() or head then
		local att = self:LookupAttachment("anim_attachment_head")
		local tab = self:GetAttachment(att)
		if !tab then
			tab = {}
			tab.Pos = self:WorldSpaceCenter()
		end
		return tab.Pos or self:WorldSpaceCenter()
		else
		return self.Owner:EyePos()
	end
	
end

function ENT:OnTakeDamage(dmg)
	if string.StartWith(dmg:GetInflictor():GetClass(), "gstands_") then
		if self:GetInBlock() then
			dmg:SetDamage(dmg:GetDamage()/5)
			if SERVER then
				self:EmitStandSound("MetalGrate.BulletImpact")
			end
		end
		self.Owner:TakeDamageInfo(dmg)
		return false
	end
end
function ENT:UpdateTransmitState()
	if self.Wep and self.Wep:GetInDoDoDo() or self:GetGround() then
		return TRANSMIT_ALWAYS
		else
		return TRANSMIT_PVS
	end
end
if CLIENT then

function ENT:Draw()
	return false
end
local mat = Material("models/highpriestess/metaltex")
local matlist = {}

local mat_cover = CreateMaterial("high_priestess_hide1", "VertexLitGeneric", {
	["$vertexcolor"] = 1,
	["$basetexture"] = "",
	["$translucent"] = 0,
	
})
local rope = Material( "effects/hip_cable.vmt" )
function ENT:DrawTranslucent()
	if self:GetHeadScale() == 0 then
		self:SetHeadScale(1)
	end
	if CLIENT and LocalPlayer():GetActiveWeapon() then
		if !self.Owner:GetNoDraw() and LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then
			
			self.Aura = self.Aura or CreateParticleSystem(self.Owner, "auraeffect", PATTACH_POINT_FOLLOW, 1)
			self.Aura:SetControlPoint(1, gStands.GetStandColor(self:GetModel(), self:GetSkin()))
			self.StandAura = self.StandAura or CreateParticleSystem(self, "auraeffect", PATTACH_POINT_FOLLOW, 1)
			self.StandAura:SetControlPoint(1, gStands.GetStandColor(self:GetModel(), self:GetSkin()))
			if not self.Wep:GetInDoDoDo() and self.Owner == LocalPlayer() and self:GetHPModel() == "models/xqm/helicopterrotorbig.mdl" then
				self:SetPos(self.Owner:EyePos() + self.Owner:GetAimVector() * 55)
				self.Pos = (self.Owner:EyePos() + self.Owner:GetAimVector() * 55)
				local dir = (self.Owner:EyePos() - (self.Owner:EyePos() + self.Owner:GetAimVector() * 55)):GetNormalized()
				ang = dir:Angle()
				ang:RotateAroundAxis(dir, CurTime() * 1550)
				--ang.y = self.Angl.y + 90
				self:SetAngles(ang)
				self:SetupBones()
			end
			self:SetMaterial("")
			if self:GetGround() then
				local tra = util.TraceLine({
					start=self:GetPos() + Vector(0,0,5),
					endpos=self:GetPos() - self.Owner:GetAngles():Up() * 55
				})
				matlist[tra.HitTexture] = matlist[tra.HitTexture] or Material(tra.HitTexture)
				mat_cover:SetTexture("$basetexture", matlist[tra.HitTexture]:GetTexture("$basetexture"))
				if tra.Hit and tra.HitTexture ~= "**empty**" and not matlist[tra.HitTexture]:GetTexture("$basetexture"):IsError() and not mat_cover:GetTexture("$basetexture"):IsError() then
					self:SetMaterial("!high_priestess_hide1")
				end
				render.SuppressEngineLighting(true)
			end
			if self:GetHPModel() == "models/hipriestess/highpriestess.mdl" then
				self:ManipulateBoneScale( self:LookupBone("ValveBiped.Bip01_Head1"), LerpVector(0.3, self:GetManipulateBoneScale(self:LookupBone("ValveBiped.Bip01_Head1")), Vector(1,1,1) * self:GetHeadScale()) )
			end
			self:DrawModel() -- Draws Model Client Side
			render.SuppressEngineLighting(false)
			self.Blend = self.Blend or 0
			render.MaterialOverride(mat)
			render.SetBlend(self.Blend)
			self:SetupBones()
			self:DrawModel()
			render.SetBlend(1)
			render.MaterialOverride()
			if self:GetInBlock() then
				self.Blend = math.min(1, self.Blend + 0.1)
				else
				self.Blend = math.max(0, self.Blend - 0.1)
			end
			if self:GetHooked() then
				self.StartVec = self.StartVec or self:GetForward()
				local startpos = self:GetPos() - self:GetForward() * 45
				local endpos = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh")).Pos
				local length = 800	
				local dt = startpos:Distance(endpos) - length
				self.randvecs = self.randvecs or {
					VectorRand() * 5,
					VectorRand() * 5,
					VectorRand() * 5,
					VectorRand() * 5,
					VectorRand() * 5,
					VectorRand() * 5,
					VectorRand() * 5,
					VectorRand() * 5,
					VectorRand() * 5,
					VectorRand() * 5,
				}
				render.SetMaterial(rope)
				for k,v in pairs(self.randvecs) do
					local i = (k - 1)/(table.Count(self.randvecs))
					if startpos:Distance(endpos) > length then
						length = 0
					end
					Scroll = math.max(0, (length - startpos:Distance(endpos)))/5
					local rand = -self:GetForward() * (Scroll + 15) / 2 + self.randvecs[1]
					local rand2 = -((self.StartVec * 5) + self.randvecs[table.Count(self.randvecs)]):GetNormalized() * Scroll
					local v1 = Bezier4(startpos, startpos + rand, endpos - rand2, endpos, i) + EyeAngles():Up()
					local v2 = Bezier4(startpos, startpos + rand, endpos - rand2, endpos, i) - EyeAngles():Up()
					local v3 = Bezier4(startpos, startpos + rand, endpos - rand2, endpos, i + 0.1) + EyeAngles():Up()
					local v4 = Bezier4(startpos, startpos + rand, endpos - rand2, endpos, i + 0.1) - EyeAngles():Up()
					Scroll = math.fmod(Scroll*15,128)
					if LocalPlayer() == self.FirstOwner then
						render.SetMaterial(rope)
					end
					render.DrawBeam(v1, v3, 2, Scroll, Scroll + 2, Color(255,255,255))
					--render.DrawQuad(v1, v2, v4, v3)
				end
			end
		end
		elseif (self.Aura and self.StandAura) or self.Owner:GetNoDraw() then
		self.Aura:StopEmission()
		self.StandAura:StopEmission()
		self.Aura = nil
		self.StandAura = nil
	end
	if (self.Aura and self.StandAura) and self.Owner:GetNoDraw() then
		self.Aura:StopEmission()
		self.StandAura:StopEmission()
		self.Aura = nil
		self.StandAura = nil
	end
end
	
	function Bezier4(P0, P1, P2, P3, Step)
		return P0 * ( 1 - Step ) ^ 3 + 3 * P1 * Step * ( 1 - Step ) ^ 2 + 3 * P2 * Step ^ 2 * ( 1 - Step ) + Step ^ 3 * P3
	end
	
end

