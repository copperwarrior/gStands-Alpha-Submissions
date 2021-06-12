--Send file to clients
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot      = 1
end

SWEP.Power = 2.5
SWEP.Speed = 1.25
SWEP.Range = 250
SWEP.Durability = 800
SWEP.Precision = B
SWEP.DevPos = B

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.cream.purpose"
SWEP.Instructions  = "#gstands.cream.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.cream"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos            = 2
SWEP.DrawCrosshair      = true

SWEP.WorldModel     = "models/player/whitesnake/disc.mdl"
SWEP.ViewModel 		= ""
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

SWEP.DrawAmmo       = false
SWEP.Void       = true
SWEP.HitDistance    = 48
SWEP.StandModel = "models/player/creamrv/crm.mdl"
SWEP.StandModelP = "models/player/creamrv/crm.mdl"
SWEP.gStands_IsThirdPerson = true

--Define swing and hit sounds. Might change these later.
local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )
local BitSound = Sound( "weapons/cream/bitsound.mp3" )
local StopVoid = Sound("weapons/cream/void_stop.mp3")
local StartVoid = Sound("weapons/cream/bitsound.mp3")
local Consume = Sound("weapons/cream/consume.mp3")
local Deploy = Sound("weapons/cream/deploy.mp3")

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
	[ "stando" ]		= ACT_HL2MP_IDLE
	
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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("idle_all_angry"))
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE_SUITCASE + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_01"))
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_melee_shove_1hand"))
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_melee_shove_1hand"))
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
	if CLIENT then
	end
	self:DrawShadow(false)
end

local VoidMat = Material("effects/gstands_cream_void")
function SWEP:DrawWorldModel()
	if IsValid(self.Owner) then
		return false
		else
		self:DrawModel()
	end
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

local thirdperson_offset = GetConVar("gstands_thirdperson_offset")
function SWEP:CalcView( ply, pos, ang )
if not self.gStands_IsThirdPerson or ply:GetViewEntity() ~= ply then return end	if IsValid(self:GetStand()) and self:GetStand().GetInDoDoDo and self:GetStand():GetInDoDoDo() then
		pos = self:GetStand():GetEyePos()
	end
	local convar = thirdperson_offset:GetString()
	local strtab = string.Split(convar, ",")
	local offset = Vector(strtab[1], strtab[2], strtab[3])
	offset:Rotate(ang)

	local trace = util.TraceHull( {
		start = pos,
		endpos = pos - ang:Forward() * 100,
		filter = { ply:GetActiveWeapon(), ply, ply:GetVehicle() },
		mins = Vector( -4, -4, -4 ),
		maxs = Vector( 4, 4, 4 ),
	} )


	if ( trace.Hit ) then pos = trace.HitPos else pos = trace.HitPos end
	if self.GetActive and self:GetActive() then
		pos = (ply:WorldSpaceCenter() - ang:Forward() * 100) - Vector(0,ply:WorldToLocal(ply:GetPos()), 0 )
	end
	if ply:GetNWBool("InConsume") then
		pos = LocalPlayer():GetPos() + Vector(0,0,10000)
	end
	return pos + offset,ang
end
function SWEP:DrawHUD()
	draw.SimpleTextOutlined( "MODE:", "HudSelectionText", ScrW() / 2 - 25,15, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0,0,0,255)) 
	draw.RoundedBox( 3, ScrW() / 2 - 50, 35, 50, 50, Color(0,0,0,255) )
	draw.RoundedBox( 3, ScrW() / 2, 35, 50, 50, Color(0,0,0,255) ) 
	if self.Stand and self.Stand:IsValid() then
		if self:GetActive() then
			draw.RoundedBox( 3, ScrW() / 2, 35, 50, 50, Color(gStands.GetStandColor(self.Stand:GetModel(), self.Stand:GetSkin()).x * 255,gStands.GetStandColor(self.Stand:GetModel(), self.Stand:GetSkin()).y * 255,gStands.GetStandColor(self.Stand:GetModel(), self.Stand:GetSkin()).z * 255,255) ) 
			draw.SimpleText( "V", "DermaLarge", ScrW() / 2 + 16,45, Color( 0, 0, 0, 255 )) 
			else
			draw.RoundedBox( 3, ScrW() / 2 - 50, 35, 50, 50, Color(gStands.GetStandColor(self.Stand:GetModel(), self.Stand:GetSkin()).x * 255,gStands.GetStandColor(self.Stand:GetModel(), self.Stand:GetSkin()).y * 255,gStands.GetStandColor(self.Stand:GetModel(), self.Stand:GetSkin()).z * 255,255) )
			draw.SimpleText( "N", "DermaLarge", ScrW() / 2 - 32,45, Color( 0, 0, 0, 255 )) 
		end
	end
end
function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Stand")
	self:NetworkVar("Bool", 0, "Active")
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
	self.Owner:SetCanZoom(false)
	self:Think()
	local name = self.Owner:GetName()
	hook.Add("PlayerNoClip", "CreamNoclipPrevent"..name, function(ply, bool)
		if self:IsValid() and self.Owner:IsValid() then 
			if self.Owner == ply then
				if self:GetActive() then
					return !bool
				end
			end
		end
	end)
	if CLIENT then
		hook.Add( "EntityEmitSound", "KillAudioforCream", function(dat)
			if ( !IsValid( ply ) ) then return end
			if ( !IsValid( self ) ) then return end
			if LocalPlayer():GetNWBool("InConsume") then
			
				RunConsoleCommand("stopsound")
				return false
			end
		end )
	end
end

--Creates stand and adds attributes to the stand.
function SWEP:DefineStand()
	if SERVER then
		self:SetStand(ents.Create("Stand"))
		self.Stand = self:GetStand()
		self.Stand:SetOwner(self.Owner)
		self.Stand:SetModel(self.StandModel)
		self.Stand:SetMoveType( MOVETYPE_NOCLIP )
		self.Stand:SetAngles(self.Owner:GetAngles())
		self.Stand:SetPos(self.Owner:GetBonePosition(0)+Vector(0, 0, 0))
		self.Stand:DrawShadow(false)
		self.Stand.Range = self.Range
		self.Stand.Speed = 20 * self.Speed
		self.Stand.AnimSet = {
			"SWIMMING_ALL", 1,
			"GMOD_BREATH_LAYER", 1,
			"AIMLAYER_CAMERA", 0,
			"IDLE_MELEE_ANGRY", 0.5,
			"FIST_BLOCK", 0.6,
		}
		self.Stand:Spawn()
	end
	timer.Simple(0.1, function()
		if self.Stand then
			if self.Stand:GetSkin() == 0 then
				self.Stand.rgl = 1.7
				self.Stand.ggl = 1.7
				self.Stand.bgl = 1.8
				self.Stand.rglm = 1.3
				self.Stand.gglm = 1.3
				self.Stand.bglm = 1.3
				elseif self.Stand:GetSkin() == 1 then
				self.Stand.rgl = 1.8
				self.Stand.ggl = 1.7
				self.Stand.bgl = 1.8
				self.Stand.rglm = 1.3
				self.Stand.gglm = 1.3
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
	if self.Owner:KeyPressed(IN_JUMP) and self.Stand:GetBodygroup(0) == 1 and self.Stand:GetModelScale() == 1 then
		self:ExitVoid()
	end
	local curtime = CurTime()
	
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
	
	if (self:GetActive() and !timer.Exists("creamVoidStart"..self.Owner:GetName())) then
		if self.Stand:GetModelScale() == 0 then
			self.Stand:SetParent()
			self.Owner:ScreenFade(SCREENFADE.PURGE, Color(0,0,0,255), 0.01, 0.1)
			self:VoidConsume()
			else
			self.Owner:SetMoveType(MOVETYPE_NOCLIP)
			self.Stand:SetPos((self.Owner:GetPos() - Vector(0,0,50)))
			-- if !self.Stand:GetParent():IsValid() then
			-- self.Stand:SetParent(self.Owner, self.Owner:LookupAttachment("forward"))
			
			-- end
			self:SetVelocity(Vector(0,0,0))
			--self.Stand:SetAngles(self.Owner:GetAimVector():Angle())
			
		end
	end
	if timer.Exists("creamVoidStart"..self.Owner:GetName()) and timer.TimeLeft("creamVoidStart"..self.Owner:GetName()) > 0.01 and SERVER then
		self.Owner:SetMoveType(MOVETYPE_NONE)
		self.Owner:SetPos(self.Owner:GetPos() + Vector(0, 0,timer.TimeLeft("creamVoidStart"..self.Owner:GetName())) * 2)
	end
	self.Delay = self.Delay or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("modeswap") and CurTime() >= self.Delay then
		--Delay the change, can't have it flip too fast
		self.Delay = CurTime() + 1
		--Lots of checks here. All ends in making sure you can't break it easily.
		if self.Void then 
			self:EnterVoid()
			else
			
			self:ExitVoidPart() 
		end
	end
	self:NextThink(CurTime())
	return true
end

function SWEP:VoidConsume()
	if SERVER then
		tr = util.TraceHull( {
			start = self.Owner:GetPos(),
			endpos = self.Owner:GetPos(),
			filter = {self.Owner, self.Stand },
			mins = Vector( -80, -80, -80 ),
			maxs = Vector( 80, 80, 80 ),
			mask = MASK_SHOT_HULL,
		} )
		tr2 = util.TraceHull( {
			start = self.Owner:GetPos(),
			endpos = self.Owner:GetPos(),
			filter = {self.Owner, self.Stand },
			mins = Vector( -80, -80, -80 ),
			maxs = Vector( 80, 80, 80 ),
			mask = MASK_SHOT_HULL,
			ignoreworld = true
		} )
		self.CBEDelay = self.CBEDelay or CurTime()
		if CurTime() > self.CBEDelay then
			--Delay the change, can't have it flip too fast
			self.CBEDelay = CurTime()
			if tr.Hit and tr.HitPos != nil then 
				local effectdata = EffectData()
				effectdata:SetOrigin(self.Stand:WorldSpaceCenter())
				local filter = RecipientFilter()
				filter:AddAllPlayers()
				util.Effect("gstands_cbe", effectdata, true, filter)
				
			end
			if tr2.Entity:IsValid() then
				self.Owner:EmitStandSound(BitSound)
			end
			for k,v in pairs(ents.FindInSphere(self.Stand:WorldSpaceCenter() - self.Owner:GetAimVector() * 55, 80)) do
				if v != self.Owner and v != self.Stand then
					if ( SERVER && IsValid( v ) && ( v:Health() > 0 ) ) then
						local dmginfo = DamageInfo()
						local attacker = self.Owner
						if ( !IsValid( attacker ) ) then attacker = self.Owner end
						dmginfo:SetAttacker( attacker )
						
						dmginfo:SetInflictor( self )
						dmginfo:SetDamage( 35 * self.Power )
						v:TakeDamageInfo( dmginfo )
						v:SetVelocity(-v:GetVelocity())
						hit = true
					end
				end
			end
			for k,v in pairs(ents.FindInSphere(self.Stand:WorldSpaceCenter(), 60)) do
				if v:IsPlayer() or v:IsNPC() or (v:GetPhysicsObject():IsValid() and v:GetPhysicsObject():GetMass() >= 1 and v:EntIndex() > 0 and v != self.Owner) or v:GetClass() == "geb" or (v:GetClass() == "stand" and v != self.Stand) then
					if (v:GetClass() == "geb" or v:GetClass() == "stand") and !v.UnEatable and v != self:GetStand() then
						v:Disable(true)
						self.Owner:AddFrags(1)
						elseif !v.UnEatable and v != self.Owner then
						v:Remove()
					end
					
					if (v:IsPlayer() and v:Health() > 0 and !v.UnEatable and v != self.Owner )then
						v:KillSilent()
						self.Owner:AddFrags(1)
						if v:GetModel() == "models/player/jojo3/abd.mdl" then
							local rag = ents.Create("prop_ragdoll")
							local arm = ents.Create("prop_physics")
							rag:SetModel(v:GetModel())
							rag.UnEatable = true
							arm.UnEatable = true
							rag:SetSkin(v:GetSkin())
							rag:SetPos(v:GetPos())
							rag:SetMaterial("models/effects/comball_glow2")
							rag:Spawn()
							rag:Activate()
							rag:DrawShadow(false)
							arm:SetModel("models/player/jojo3/abdarms.mdl")
							arm:Spawn()
							arm:SetParent(rag)
							arm:AddEffects( EF_BONEMERGE || EF_BONEMERGE_FASTCULL || EF_PARENT_ANIMATES)
						end
					end
				end
			end
		end
	end
end

function SWEP:PrimaryAttack()
	--Check the mode. Is it ability mode?
	if IsFirstTimePredicted() and SERVER then
		self:SetHoldType("pistol")
		self.Stand:ResetSequence(self.Stand:LookupSequence("bite"))
		self.Stand:RemoveAllGestures()
		self.Stand:SetCycle( 0 )
		self.Stand:SetPlaybackRate( 1.2 )
		
		
		timer.Simple(0.7, function() self:SetHoldType("stando") 
			self.Stand:ResetSequence( self.Stand:LookupSequence(self.Owner:GetSequenceName(self.Owner:GetSequence())) )
		end)
		timer.Simple(0.1, function()
			self:Nom()
		end)
	end
	self:SetNextPrimaryFire( CurTime() + 1 )
	
end


function SWEP:SecondaryAttack()
	if SERVER then
		self:SetHoldType("pistol")
		self.Stand:RemoveAllGestures()
		self.Stand:ResetSequence(self.Stand:LookupSequence("chop"))
		self.Stand:SetCycle( 0 )
		timer.Simple(1, function() self:SetHoldType("stando") 
			self.Stand:ResetSequence( self.Stand:LookupSequence(self.Owner:GetSequenceName(self.Owner:GetSequence())) )
		end)
	end
	--Punch with the donutting hand
	local anim = "punch2"
	if SERVER then
		timer.Simple(0.4, function() self.Stand:EmitStandSound(SwingSound) end)
		timer.Simple(0.4, function()
			timer.Create("DonutChop"..self.Owner:GetName(), 0.04, 7, function()
			self:DonutPunch() end)
		end)
	end
	--No spamming the donut punch.
	self:SetNextPrimaryFire( CurTime() + (0.02 * self.Speed) )
	self:SetNextSecondaryFire( CurTime() + 3 )
end

function SWEP:DonutPunch()
	
	--Most of this is from the default fists swep, sped up and adapted to fit high speed stand rushes.
	local anim = self.Owner:GetSequenceName(self.Owner:GetSequence())
	self.Owner:LagCompensation( true )
	
	local mins = Vector( -10, -10, -10 )
	local maxs = Vector( 10, 10, 10 )
	local pos = self.Stand:GetBonePosition(self.Stand:LookupBone("ValveBiped.Bip01_R_Hand"))
	local pos2 = self.Stand:WorldSpaceCenter()
	local dir = (pos - pos2):GetNormalized()
	debugoverlay.SweptBox(pos2, pos + dir * self.HitDistance, mins, maxs, Angle())
	local tr = util.TraceHull( {
		start = pos2,
		endpos = pos + dir * self.HitDistance,
		filter = {self.Owner, self.Stand },
		mins = mins,
		maxs = maxs,
		mask = MASK_SHOT_HULL
	} )
	
	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self.Owner:EmitSound( GetStandImpactSfx(tr.MatType) )
	end
	
	local hit = false
	if SERVER and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue("explosion", "2") tr.Entity:SetKeyValue("gibdir", tostring(self.Stand:GetAngles())) tr.Entity:Fire("Break") end
	
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 || tr.Entity:GetClass() == "stand") ) then
		local dmginfo = DamageInfo()
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self.Owner end
		dmginfo:SetAttacker( attacker )
		
		dmginfo:SetInflictor( self )
		--High damage, but not quite enough to kill.
		dmginfo:SetDamage( 25 * self.Power )
		
		if ( anim == "punch1" ) then
			dmginfo:SetDamageForce( (self.Owner:GetRight() * 4912 + self.Owner:GetEyeAngles() * 9998 ) )
		end
		
		tr.Entity:TakeDamageInfo( dmginfo )
		--Fllllling your enemies.
		--tr.Entity:SetVelocity( self.Owner:GetAimVector() * (170.66 * self.Power) + Vector( 0, 0, (170.66 * self.Power) ) )
		
		hit = true
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
function SWEP:Nom()
	--Most of this is from the default fists swep, sped up and adapted to fit high speed stand rushes.
	local anim = self.Owner:GetSequenceName(self.Owner:GetSequence())
	local pos = self.Stand:WorldSpaceCenter()
	local dir = self.Owner:GetAimVector()
	local mins = Vector( -25, -25, -25 )
	local maxs = Vector( 25, 25, 25 )
	local tr = util.TraceHull( {
		start = pos,
		endpos = pos + dir * self.HitDistance,
		filter = {self.Owner, self.Stand },
		mins = mins,
		maxs = maxs,
		mask = MASK_SHOT_HULL
	} )
	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self.Owner:EmitStandSound( BitSound )
	end
	
	local hit = false
	if !tr.Entity.Invincible then
		if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() ) ) then
			local dmginfo = DamageInfo()
			
			local attacker = self.Owner
			if ( !IsValid( attacker ) ) then attacker = self.Owner end
			dmginfo:SetAttacker( attacker )
			
			dmginfo:SetInflictor( self )
			--High damage, but not quite enough to kill.
			dmginfo:SetDamage( 30 * self.Power )
			tr.Entity:TakeDamageInfo( dmginfo )
			--Fllllling your enemies.
			
			hit = true
		end
		
		if ( tr.Entity:EntIndex() > 0 ) then
			local phys = tr.Entity:GetPhysicsObject()
			if (( IsValid( phys )  ) and phys:GetMass() <= 50) or tr.Entity.UnEatable
				then
				if SERVER then
					local bitefx = EffectData()
					bitefx:SetOrigin(phys:GetMassCenter())
					dumdum = ents.Create("base_entity")
					dumdum:SetPos(tr.Entity:WorldSpaceCenter())
					bitefx:SetEntity(dumdum)
					util.Effect("cb", bitefx, true, true)
					tr.Entity:Remove()
				end
				timer.Simple(0.5, function() dumdum:Remove() end)
			end
			
		end
	end
end
function SWEP:EnterVoid()

	if SERVER then
		self:SetActive( true )
		self.Owner:EmitStandSound(StartVoid)
		self:SetHoldType("pistol")
		self.Stand:RemoveAllGestures()
		self.Stand:SetSequence(self.Stand:LookupSequence("eat"))
		self.Stand:SetCycle(0)
		self.Stand:SetPlaybackRate(2)
		
		self.Owner:SetModelScale(0.01, 0.75)
		timer.Simple(0.5, function() self.Stand:SetBodygroup(0,1) self.Stand:SetModelScale(0, 1) self.Owner:AddFlags(FL_NOTARGET)
			self.Owner:GodEnable()
			self.Owner:AddEffects(EF_NODRAW )
			
		end)
	end
	self.Void = false
	self.Owner:ScreenFade(SCREENFADE.OUT, Color(0,0,0,255), 0.85, 0)
	self.StartTime = CurTime()
	timer.Create("creamVoidStart"..self.Owner:GetName(), 0.75, 1, function()
		self.Owner:ScreenFade(SCREENFADE.PURGE, Color(0,0,0,255), 0.01, 1)
		self.Owner:SetNWBool("InConsume", true)
		self.Owner:SetDSP(133, false)
		hook.Add( "PostDrawHUD", "CreamVoid", function()
			local tab = {
				[ "$pp_colour_addr" ] = 0,
				[ "$pp_colour_addg" ] = 0,
				[ "$pp_colour_addb" ] = 0,
				[ "$pp_colour_brightness" ] = -1,
				[ "$pp_colour_contrast" ] = 1,
				[ "$pp_colour_colour" ] = 0,
				[ "$pp_colour_mulr" ] = 0,
				[ "$pp_colour_mulg" ] = 0,
				[ "$pp_colour_mulb" ] = 0
			}
			DrawColorModify( tab )
			self.Owner:SetDSP(133, false)
		end)
		if SERVER then
			self.Owner:AddFlags(FL_NOTARGET)
			self.Owner:GodEnable()
			self.Owner:AddEffects(EF_NODRAW )
			-- local fxdata = EffectData()
			-- fxdata:SetOrigin(self.Owner:GetPos())
			-- fxdata:SetEntity(self.Owner)
			-- util.Effect("cv", fxdata, true, true)
			self.Stand:SetNoDraw(true)
			self.Owner:ChatPrint("#gstands.cream.voidenter")
			timer.Remove("creamVoidStart"..self.Owner:GetName())
		end
	end)
end
function SWEP:ExitVoidPart()
	self.Owner:SetNWBool("InConsume", false)
	self.Owner:SetDSP(0, false)
	--self.Stand:SetSequence(self.Stand:LookupSequence(self.Owner:GetSequenceName(self.Owner:GetSequence())))
	self.Void = true
	self:SetActive(true)
	hook.Remove( "PostDrawHUD", "CreamVoid")
	if SERVER then
		timer.Simple(0, function()
			self.Owner:EmitStandSound(StopVoid)
		end)
		self.Stand:SetModelScale(1, 0.5)
		self.Stand:SetBodygroup(0,1)
		self.Owner:RemoveFlags(FL_NOTARGET)
		self.Owner:GodDisable()
		self.Stand:SetNoDraw(false)
		self:SetHoldType("stando")
		self.Owner:ScreenFade(SCREENFADE.IN, Color(0,0,0,255), 0.85, 0)
		self.Owner:ChatPrint("#gstands.cream.voidexit")
		self:SetNextPrimaryFire( CurTime() + 0.02 )
	end
end
function SWEP:ExitVoid()
	self.Owner:SetNWBool("InConsume", false)
	self.Void = true
	hook.Remove( "PostDrawHUD", "CreamVoid")
	self:SetActive(false)
	self.Stand:SetModelScale(1)
	--self.Stand:SetParent()
	self.Stand:SetSequence(self.Stand:LookupSequence(self.Owner:GetSequenceName(self.Owner:GetSequence())))
	self.Owner:SetModelScale(1)
	if SERVER then
		self.Owner:RemoveFlags(FL_NOTARGET)
		self.Owner:GodDisable()
		if !self.Owner.IsKnockedOut then
			self.Owner:RemoveEffects(EF_NODRAW )
		end
		self.Stand:RemoveEffects(EF_NODRAW )
		self.Stand:SetBodygroup(0,0)
		self.Owner:SetMoveType(MOVETYPE_WALK)
		self:SetHoldType("stando")
		self:SetNextPrimaryFire( CurTime() + 0.02 )
	end
end

function SWEP:Reload()
	
end

--Screw this entire section, it only works like 20% of the time. Basically, meant to catch every time the weapon is not in your hands in order to remove the stand.
function SWEP:OnDrop()
	if SERVER and self.Stand:IsValid() then
		self.Stand:Remove()
		self:ExitVoid()
		
	end
	hook.Remove( "PostDrawHUD", "CreamVoid")
	
	return true
end

function SWEP:OnRemove()
	if SERVER and self.Stand and self.Stand:IsValid() then
		self.Stand:Remove()
		self:ExitVoid()
	end
	hook.Remove( "PostDrawHUD", "CreamVoid")
	return true
end

function SWEP:Holster()
	if SERVER and self.Stand:IsValid() then
		self.Stand:Remove()
		hook.Remove( "PostDrawHUD", "CreamVoid")
		
		self:ExitVoid()
	end
	hook.Remove( "PostDrawHUD", "CreamVoid")
	
	if (self:GetActive()) then
		return false
	end
	return true
end