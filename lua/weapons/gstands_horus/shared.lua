--Send file to clients
if SERVER then
   AddCSLuaFile( "shared.lua" )
end
if CLIENT then
   SWEP.Slot      = 1
end

SWEP.Power = 1.75
SWEP.Speed = 1.25
SWEP.Range = 250
SWEP.Durability = 800
SWEP.Precision = A
SWEP.DevPos = A

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.horus.purpose"
SWEP.Instructions  = "#gstands.horus.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.horus"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos            = 2
SWEP.DrawCrosshair      = true

SWEP.WorldModel = "models/player/whitesnake/disc.mdl"
SWEP.ViewModelFOV   = 54
SWEP.UseHands       = true

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"

SWEP.DrawAmmo       = true
SWEP.CanZoom       = false
SWEP.HitDistance    = 48
SWEP.ChargeStart = 0
SWEP.ChargeEnd = 0
SWEP.LatchedEnt = nil
SWEP.BarrierNum = 0
SWEP.BarrierList = {}
SWEP.BarrierAvg = Vector(0,0,0)
SWEP.Delay3 = 0
SWEP.WaxOn = false
SWEP.Spikes = {}
SWEP.Block = NUL
game.AddParticles("particles/horus.pcf")
PrecacheParticleSystem("horus")
PrecacheParticleSystem("horus2")
SWEP.StandModel = "models/horus/horus.mdl"
SWEP.StandModelP = "models/horus/horus.mdl"
SWEP.gStands_IsThirdPerson = true
if CLIENT then
		SWEP.StandModel = "models/horus/horus.mdl"
end
--Define swing and hit sounds. Might change these later.
--local SwingSound = Sound( "WeaponFrag.Throw" )
local Deploy = Sound("weapons/horus/deploy.wav")
local ActIndex = {
	[ "pistol" ]		= ACT_HL2MP_IDLE_PISTOL,
	[ "smg" ]			= ACT_HL2MP_IDLE_SMG1,
	[ "grenade" ]		= ACT_HL2MP_IDLE_GRENADE,
	[ "ar2" ]			= ACT_HL2MP_IDLE_AR2,
	[ "shotgun" ]		= ACT_HL2MP_IDLE_SHOTGUN,
	[ "rpg" ]			= ACT_HL2MP_IDLE_RPG,
	[ "physgun" ]		= ACT_HL2MP_IDLE_PHYSGUN,
	[ "crossbow" ]		= ACT_HL2MP_IDLE_CROSSBOW,
	[ "melee" ]			= ACT_HL2MP_IDLE_MELEE,
	[ "slam" ]			= ACT_HL2MP_IDLE_SLAM,
	[ "normal" ]		= ACT_HL2MP_IDLE,
	[ "fist" ]			= ACT_HL2MP_IDLE_FIST,
	[ "melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
	[ "passive" ]		= ACT_HL2MP_IDLE_PASSIVE,
	[ "knife" ]			= ACT_HL2MP_IDLE_KNIFE,
	[ "duel" ]			= ACT_HL2MP_IDLE_DUEL,
	[ "camera" ]		= ACT_HL2MP_IDLE_CAMERA,
	[ "magic" ]			= ACT_HL2MP_IDLE_MAGIC,
	[ "revolver" ]		= ACT_HL2MP_IDLE_REVOLVER,
	[ "stando" ]		= ACT_HL2MP_IDLE_KNIFE
	
}

function SWEP:SetWeaponHoldType( t )

	t = string.lower( t )
	local index = ActIndex[ t ]

	if ( index == nil ) then
		Msg( "SWEP:SetWeaponHoldType - ActIndex[ \"" .. t .. "\" ] isn't set! (defaulting to normal)\n" )
		t = "normal"
		index = ActIndex[ t ]
	end
if ( t == "stando" ) then
	self.ActivityTranslate = {}
	self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_standing_02"))
	self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE + 1
	self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
	self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_01"))
	self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
	self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_fists_r"))
	self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_fists_r"))
	self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_item_place"))
	self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_item_place"))
	self.ActivityTranslate[ ACT_MP_JUMP ]						= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("jump_knife"))
	self.ActivityTranslate[ ACT_RANGE_ATTACK1 ]					= index + 8
	self.ActivityTranslate[ ACT_MP_SWIM ]						= index + 9
else
	self.ActivityTranslate = {}
	self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= index
	self.ActivityTranslate[ ACT_MP_WALK ]						= index + 1
	self.ActivityTranslate[ ACT_MP_RUN ]						= index + 2
	self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= index + 3
	self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
	self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= index + 5
	self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= index + 5
	self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= index + 6
	self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= index + 6
	self.ActivityTranslate[ ACT_MP_JUMP ]						= index + 7
	self.ActivityTranslate[ ACT_RANGE_ATTACK1 ]					= index + 8
	self.ActivityTranslate[ ACT_MP_SWIM ]						= index + 9
end
	-- "normal" jump animation doesn't exist
	if ( t == "normal" ) then
		self.ActivityTranslate[ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end
	
	
end
function SWEP:Initialize()
	--Set the third person hold type to fists
	timer.Simple(0.1, function() 
		if self:GetOwner() != nil then
			if self:GetOwner():IsValid() and SERVER then
				self:GetOwner():SetHealth(GetConVar("gstands_horus_heal"):GetInt())
				self:GetOwner():SetMaxHealth(GetConVar("gstands_horus_heal"):GetInt())
			end
		end
	end)
	if CLIENT then
	end
	self:DrawShadow(false)
	self.CanZoom = false
end

local material = Material( "sprites/hud/v_crosshair1" )
function SWEP:DoDrawCrosshair(x,y)
		if IsValid(self.Stand) then
			local tr = util.TraceLine( {
				start = self.Stand:GetEyePos(true),
				endpos = self.Stand:GetEyePos(true) + self.Owner:GetAimVector() * 1500,
				filter = {self.Owner, self.Stand},
				mask = MASK_SHOT_HULL
			} )
			local pos = tr.HitPos

			local pos2d = pos:ToScreen()
			if pos2d.visible then
				surface.SetMaterial( material	)
				surface.SetDrawColor( gStands.GetStandColorTable(self.Stand:GetModel(), self.Stand:GetSkin()) )
				surface.DrawTexturedRect( pos2d.x - 8, pos2d.y - 8, 16, 16 )
			end
			return true
	end
end
function SWEP:DrawWorldModel()
	if IsValid(self.Owner) then
		return false
		else
		self:DrawModel()
	end
end
--Third Person View
local thirdperson_offset = GetConVar("gstands_thirdperson_offset")
function SWEP:CalcView( ply, pos, ang )
if not self.gStands_IsThirdPerson or ply:GetViewEntity() ~= ply then return end	if IsValid(self:GetStand()) and self:GetStand().GetInDoDoDo and self:GetStand():GetInDoDoDo() then
		pos = self:GetStand():GetEyePos()
	end
	local convar = thirdperson_offset:GetString()
	local strtab = string.Split(convar, ",")
	local offset = Vector(strtab[1], strtab[2], strtab[3])
	offset:Rotate(ang)
	local notarg = {
			ply:GetActiveWeapon(),
			ply,
			ply:GetVehicle()
			}
	table.Add(notarg, LocalPlayer():GetActiveWeapon().Spikes)
	local trace = util.TraceHull( {
		start = pos,
		endpos = pos - ang:Forward() * 100,
		filter = notarg,
		mins = Vector( -4, -4, -4 ),
		maxs = Vector( 4, 4, 4 ),
	} )

	if ( trace.Hit ) then pos = trace.HitPos else pos = trace.HitPos end
	return pos + offset,ang
end
function SWEP:DrawHUD()
	draw.SimpleText( "#gstands.horus.charge", "HudSelectionText", ScrW() / 49, ScrH() / 1.18, Color( 255, 255, 255, 255 )) 
	draw.RoundedBox( 5, ScrW() / 53, ScrH() / 1.155, 230, 23, Color(0,0,0,255) ) 
	if self.Stand and self.Stand:IsValid() then
		if self.Owner:KeyDown(IN_ATTACK) and CurTime() - self.ChargeStart <= 4 then
			draw.RoundedBox( 5, ScrW() / 49, ScrH() / 1.15, (CurTime() - self.ChargeStart) * 51, 15, Color(0,125,205 + ((CurTime() - self.ChargeStart) * 10),255) ) 
		elseif self.Owner:KeyDown(IN_ATTACK) then
			draw.RoundedBox( 5, ScrW() / 49, ScrH() / 1.15, 223, 15, Color(0,225,255,255) ) 
		end
	end
	
end
function SWEP:SetupDataTables()
		self:NetworkVar("Entity", 0, "Stand")
		self:NetworkVar("Bool", 0, "AMode")
		self:NetworkVar("Bool", 1, "InRange")
		self:NetworkVar("Float", 1, "Delay2")
		self:NetworkVar("Bool", 2, "Ended")
end
--Deploy starts up the stand
function SWEP:Deploy()
	self:SetHoldType( "stando" )

	--As is standard with stand addons, set health to 1000
	if self.Owner:Health() == 100  then
		self.Owner:SetMaxHealth( self.Durability )
		self.Owner:SetHealth( self.Durability )
	end
	
	--Create the stand
	self:DefineStand()
	
	--Create some networked variables, solves some issues where multiple people had the same stand

	if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitStandSound(Deploy)
		end
	 end
end
local HoldPunch = false
--Creates stand and adds attributes to the stand.
function SWEP:DefineStand()
	if SERVER then
		self:SetStand( ents.Create("Stand") )
		self.Stand = self:GetStand()
		self.Stand:SetOwner(self.Owner)
		self.Stand:SetModel(self.StandModel)
		self.Stand:SetModelScale(0.75)
		self.Stand:SetMoveType( MOVETYPE_NOCLIP )
		self.Stand:SetAngles(self.Owner:GetAngles())
		self.Stand:SetPos(self.Owner:GetBonePosition(0)+Vector(0, 0, 0))
		self.Stand:DrawShadow(false)
		self.Stand.Range = self.Range
		self.Stand.Speed = 20 * self.Speed
		self.Stand:Spawn()
	end
	timer.Simple(0.1, function()
	if self.Stand:IsValid() then
		if self.Stand:GetSkin() == 0 then
			self.Stand.rgl = 1
			self.Stand.ggl = 1
			self.Stand.bgl = 1
			self.Stand.rglm = 1.3
			self.Stand.gglm = 1.3
			self.Stand.bglm = 1.3
		elseif self.Stand:GetSkin() == 1 then
			self.Stand.rgl = 1.7
			self.Stand.ggl = 1.7
			self.Stand.bgl = 2
			self.Stand.rglm = 1.3
			self.Stand.gglm = 1.3
			self.Stand.bglm = 1.1
		elseif self.Stand:GetSkin() == 2 then
			self.Stand.rgl = 2.1
			self.Stand.ggl = 1.7
			self.Stand.bgl = 1.8
			self.Stand.rglm = 1.5
			self.Stand.gglm = 1.3
			self.Stand.bglm = 1.4
		elseif self.Stand:GetSkin() == 3 then
			self.Stand.rgl = 2
			self.Stand.ggl = 2.1
			self.Stand.bgl = 1.7
			self.Stand.rglm = 1.4
			self.Stand.gglm = 1.5
			self.Stand.bglm = 1.3
		end
	end
	end)
end

function SWEP:Think()
	self.Stand = self:GetStand()
	if !self.Stand:IsValid() then
		self:DefineStand()
	end
	local skip = false
	local trG
	if IsValid(self.Stand) then
		trG = util.TraceLine( {
			start = self.Stand:GetPos(),
			endpos = self.Stand:GetPos() - self.Stand:GetUp() * 48,
			filter = {self, self.Owner}
		} )
	end
	if SERVER and self.Owner:KeyDown(IN_ATTACK2) and (!self.IceFreezeFX or !self.IceFreezeFX:IsValid()) and trG.HitWorld then
		if self.IceFreezeFX and !self.IceFreezeFX:IsValid() then
			self.IceFreezeFX = nil
		end
		self.IceFreezeFX = self.IceFreezeFX or ents.Create("prop_dynamic")
		self.IceFreezeFX:SetModel("models/horus/freeze.mdl")
		self.IceFreezeFX:SetPos(self.Stand:GetPos())
		self.IceFreezeFX:SetParent(self.Stand)
		self.IceFreezeFX:Spawn()
		self.IceFreezeFX:SetModelScale(10, 3)
		skip = true
	elseif SERVER and !self.Owner:KeyDown(IN_ATTACK2) and self.IceFreezeFX and self.IceFreezeFX:IsValid() then
		self.IceFreezeFX:Remove()
	end
	if self.GetStand and self:GetStand().GetInDoDoDo and self:GetStand():GetInDoDoDo() then
		self.Menacing = self.Menacing or CurTime()
			if CurTime() > self.Menacing then
				self.Menacing = CurTime() + 0.5
				local effectdata = EffectData()
				effectdata:SetStart(self.Owner:GetPos())
				effectdata:SetOrigin(self.Owner:GetPos())
				effectdata:SetEntity(self.Owner)
				util.Effect("menacing", effectdata)
				end
	end
	if self.Owner:KeyPressed(IN_ATTACK) and self:GetHoldType() == "stando" then
		self.ChargeStart = CurTime()
		if SERVER then
			self:SetHoldType("pistol")
			self.Stand:ResetSequence(2)
			self.Stand:SetCycle(0)
			self.Stand:SetPlaybackRate(1)
			timer.Create("ChargeIceSpikeHorus"..self.Owner:GetName()..self:EntIndex(), 0.5, 7, function() if self.Owner:KeyDown(IN_ATTACK) then self:CreateIceSpike(7-timer.RepsLeft("ChargeIceSpikeHorus"..self.Owner:GetName()..self:EntIndex())) end end)
			timer.Create("IceSpikeRelease"..self.Owner:GetName()..self:EntIndex(), 5.5, 1, function() 
			self:IceSpikeThrow()
					timer.Remove("ChargeRelease"..self.Owner:GetName()..self:EntIndex())

				timer.Create("ChargeRelease"..self.Owner:GetName()..self:EntIndex(), 1, 1, function() self:SetHoldType("stando") self.Stand:ResetSequence(1) 
				end) 
			end)
		end
	end
	if self.Owner:KeyDown(IN_ATTACK) and self:GetHoldType() != "pistol" then
	self:SetHoldType("pistol")
	self.Stand:ResetSequence(2)
		self.Stand:SetCycle(0)
		self.Stand:SetPlaybackRate(1)
		
	end
	if self.Owner:KeyPressed(IN_ATTACK2) and trG.HitWorld then
		ParticleEffectAttach("horus", PATTACH_POINT_FOLLOW, self.Stand,1)
	end
	if self.Owner:KeyReleased(IN_ATTACK2) then
		self.Stand:StopParticles()
	end
	if self.Owner:KeyReleased(IN_ATTACK) then
		self.ChargeEnd = CurTime()
		self.ChargeStart = CurTime()
		if SERVER then
		self.Stand:ResetSequence(2)
		self.Stand:SetCycle(0.87)
		self.Stand:SetPlaybackRate(1)
		self:IceSpikeThrow()
		timer.Create("ChargeRelease"..self.Owner:GetName()..self:EntIndex(), 1, 1, function() self:SetHoldType("stando") self.Stand:ResetSequence(1) end)
		end
	end
	if !self.Owner:KeyDown(IN_ATTACK) then
	   self:IceSpikeThrow()
	end
		self.Delay = self.Delay or CurTime()
	if self.Owner:gStandsKeyDown("modeswap") then
	if !self.Owner.IsKnockedOut and SERVER and (CurTime() > self.Delay or (self.Block and !self.Block:IsValid())) then
		--Delay the change, can't have it flip too fast
		self.Delay = CurTime() + 15
		if SERVER then
			self.Block = ents.Create("prop_physics")
			self.Block:SetPos(self.Stand:GetEyePos() + (self.Owner:GetAimVector() * 147) + Vector(0,0,400))
			self.Block:SetAngles(Angle(0, 0, 90))
			self.Block:SetModel("models/horus/iceblock.mdl")
			self.Block:Spawn()
			self.Block:EmitSound("weapons/horus/icecrack-0"..math.random(1,5)..".wav", 75, 75, 1, CHAN_AUTO)
			self.Block:EmitSound("physics/glass/glass_strain"..math.random(1,4)..".wav", 75, 75, 1, CHAN_VOICE)
			self.Block:EmitSound("physics/glass/glass_strain"..math.random(1,4)..".wav", 75, 75, 1, CHAN_ITEM)
			self.Block:EmitSound("physics/glass/glass_strain"..math.random(1,4)..".wav", 75, 75, 1, CHAN_BODY)
			self.Block:SetModelScale(0.1)
			self.Block:SetModelScale(1, 1)
			self.Block:SetMoveType(MOVETYPE_NONE)
			timer.Simple(1, function()
			if self.Block then
			self.Block:EmitSound("weapons/horus/icecrack-0"..math.random(1,5)..".wav", 75, 75, 1, CHAN_AUTO)
			self.Block:EmitSound("physics/glass/glass_strain"..math.random(1,4)..".wav", 75, 75, 1, CHAN_VOICE)
			self.Block:EmitSound("physics/glass/glass_strain"..math.random(1,4)..".wav", 75, 75, 1, CHAN_ITEM)
			self.Block:EmitSound("physics/glass/glass_strain"..math.random(1,4)..".wav", 75, 75, 1, CHAN_BODY)
			self.Block:Activate()
			self.Block:SetMoveType(MOVETYPE_VPHYSICS)
			end
			end)
			self.Block:DrawShadow(false)
			self.Block:SetPhysicsAttacker(self.Owner)
			self.Block:GetPhysicsObject():SetMass(15090)
			self.Block:GetPhysicsObject():SetDragCoefficient(0)
			local block = self.Block
			timer.Simple(5, function() if IsValid(block) then block:Remove() end end)
		end
		end
	end
end

function SWEP:PrimaryAttack()

end


function SWEP:SecondaryAttack()
	local trG = util.TraceLine( {
		start = self.Stand:GetPos(),
		endpos = self.Stand:GetPos() - Vector(0,0,1) * 48,
		filter = {self, self.Owner, self.Stand}
	} )
	if trG.HitWorld then
		self.Stand:SetIdealPos(trG.HitPos)
		self.Stand.InStill = true
		if SERVER then
			for k,v in ipairs(ents.FindInSphere(self.Stand:GetEyePos(), self.Range/1.3)) do
				if v:IsValid() and v:IsPlayer() and v != self.Owner then
				v.LastWalkSpeed = v.LastWalkSpeed or v:GetWalkSpeed()
				v.LastRunSpeed = v.LastRunSpeed or v:GetRunSpeed()
				v:SetWalkSpeed(v:GetWalkSpeed() / 1.2)
				v:SetRunSpeed(v:GetRunSpeed() / 1.2)
				local mi,ma = v:GetCollisionBounds()
				local pos = v:GetBonePosition(math.random(0,v:GetBoneCount() - 1))
				local trace = util.TraceLine( {
					start = pos + VectorRand() * 50,
					endpos = pos,
					filter = function(ent) if ent != v then return false end return true end
				} )
				
				local ice = ents.Create("prop_dynamic")
				ice:SetModel("models/horus/icechunk.mdl")
				ice:SetPos(trace.HitPos)
				ice:SetParent(v)
				ice:Spawn()
				ice:SetModelScale(math.Rand(0.2, 0.3))
				ice:SetModelScale(0, 4)
				timer.Simple(4, function() if ice and ice:IsValid() then ice:Remove() end end)
				ice:SetAngles(trace.HitNormal:Angle():Up():Angle())
				v:EmitSound("weapons/horus/icecrack-0"..math.random(1,5)..".wav", 75, (100 - v:GetWalkSpeed()/2), math.min(0.1, math.max(1, (1 - v:GetWalkSpeed()/100))), CHAN_AUTO)
				self.Stand:EmitSound("ambient/wind/wind_gust_10.wav")
				timer.Create("FreezingHorus"..v:GetName(), 0.2, 0, function() if v:GetWalkSpeed() < v.LastWalkSpeed then v:SetWalkSpeed(v.LastWalkSpeed * 1.2) v:SetRunSpeed(v.LastRunSpeed * 1.2) else timer.Remove("FreezingHorus"..v:GetName()) end end)
				if v:GetWalkSpeed() <= 10 then
					v:Freeze(true)
					v:SetMaterial("models/player/shared/ice_player")
					v:EmitSound("weapons/horus/icecrack-0"..math.random(1,5)..".wav", 75, 100, 1, CHAN_AUTO)
					timer.Simple(5, function() v:SetMaterial("") v:Freeze(false) v:SetWalkSpeed(v.LastWalkSpeed) v:SetRunSpeed(v.LastRunSpeed) end) 
				end
				end
			end
			self:SetNextSecondaryFire(CurTime())
		end
	end
end

function SWEP:CreateIceSpike(id)
		if (SERVER) then
			local spike = ents.Create("horus_ice_spike")
			if IsValid(spike) then
				local tab = {
					"tongue1",
					"bip_lowerArm_R32",
					"bip_lowerArm_R22",
					"bip_lowerArm_R12",
					"bip_lowerArm_L32",
					"bip_lowerArm_L22",
					"bip_lowerArm_L12"
					}
				if id == 1 then
				spike:SetPos((self.Stand:GetBonePosition(self.Stand:LookupBone(tab[id]) ) + Vector(0,0,6)))
				else
				spike:SetPos((self.Stand:GetBonePosition(self.Stand:LookupBone(tab[id]) ) - Vector(0,0,0)))
				end
				spike:SetOwner(self.Owner)
				spike:SetPhysicsAttacker(self.Owner)
				spike:SetParent(self.Stand)
				spike:SetAngles(self.Stand:GetForward():Angle() + Angle(270,0,0))
				spike:EmitSound("weapons/horus/icecrack-0"..math.random(1,5)..".wav", 75, 150, 1, CHAN_AUTO)

				table.insert(self.Spikes, spike)
			spike:Spawn()
			
			if id == 1 then
				spike.id = 2
				spike:SetModelScale(0.2)
			end
			spike:Activate()
		end
	end
end

function SWEP:IceSpikeThrow()
	if (SERVER) then
		for k,v in ipairs(self.Spikes) do
			if v:IsValid() then
				v:SetParent()
				v:Spawn()
				v:Activate()
				v:GetPhysicsObject():SetVelocityInstantaneous(self.Stand:GetForward() * 2500)
			end
		end
		self.Spikes = {}
		timer.Remove("IceSpikeRelease"..self.Owner:GetName()..self:EntIndex())
	end
end

function SWEP:Reload()
--Mode changing
	
end

function SWEP:OnDrop()
	if SERVER and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	return true
end
function SWEP:OnRemove()
	if SERVER and self.Owner and self.Owner:IsValid() and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	return true
end
function SWEP:Holster()
	if SERVER and self.Owner and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	return true
end