--Send file to clients
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot      = 1
end

SWEP.DevPos = D 
SWEP.Power = 2 
SWEP.Speed = 0.75 
SWEP.Range = 155000000
SWEP.Durability = 1500 
SWEP.Precision = D 

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.hip.purpose"
SWEP.Instructions  = "#gstands.hip.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.hip"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos            = 2
SWEP.DrawCrosshair      = true

SWEP.WorldModel = "models/player/whitesnake/disc.mdl"
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.HitDistance = 74
SWEP.StandModel = "models/hipriestess/highpriestess.mdl"
SWEP.StandModelP = "models/hipriestess/highpriestess.mdl"
SWEP.gStands_IsThirdPerson = true

local PrevHealth = nil

local Scream1 = Sound( "weapons/hip/scream1.wav" )
local Laugh = Sound( "weapons/hip/laugh.wav" )
local Slice1 = Sound( "weapons/hip/slice1.wav" )
local Slice1S = Sound( "weapons/hip/slice1short.wav" )
local BiteHit = Sound( "weapons/hip/clang.wav" )
local Scream2 = Sound("weapons/hip/scream2.wav")
local Slice2 = Sound("weapons/hip/slice2.wav")
local Deploy = Sound("weapons/hip/deploy.wav")
local Transform = Sound("hip.morph")

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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= index + 1
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_WALK
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= index + 3
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_slam"))
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_slam"))
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

--Define swing and hit sounds. Might change these later.
local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )

function SWEP:Initialize()
	--Set the third person hold type to fists
end

function SWEP:DrawWorldModel()
	if IsValid(self.Owner) then
		return false
		else
		self:DrawModel()
	end
end
function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Stand")
	self:NetworkVar("Bool", 1, "InDoDoDo")
end

local thirdperson_offset = GetConVar("gstands_thirdperson_offset")
function SWEP:CalcView( ply, pos, ang )
if not self.gStands_IsThirdPerson or ply:GetViewEntity() ~= ply then return end	if IsValid(self:GetStand()) and self.GetInDoDoDo and self:GetInDoDoDo() then
		pos = self:GetStand():GetEyePos()
	end
	local stand = NULL
	if self.GetStand then
		stand = self:GetStand()
	end
	local prop = NULL
	if stand.GetProp then
		prop = stand:GetProp()
	end
	local convar = thirdperson_offset:GetString()
	local strtab = string.Split(convar, ",")
	local offset = Vector(strtab[1], strtab[2], strtab[3])
	offset:Rotate(ang)

	local trace = util.TraceHull( {
		start = pos,
		endpos = pos - ang:Forward() * 100,
		filter = { ply:GetActiveWeapon(), ply, self.Stand, ply:GetVehicle(), prop },
		mins = Vector( -4, -4, -4 ),
		maxs = Vector( 4, 4, 4 ),
	} )


	if ( trace.Hit ) then pos = trace.HitPos else pos = trace.HitPos end
	return pos + offset,ang
end
local pos, material, white = Vector( 0, 0, 0 ), Material( "sprites/hud/v_crosshair1" ), Color( 255, 255, 255, 255 )
	local base			= "vgui/hud/gstands_hud/"
	local armor_bar   	= Material(base.."armor_bar")
	local bar_border  	= Material(base.."bar_border")
	local boxdis	  	= Material(base.."boxdis")
	local boxend	  	= Material(base.."boxend")
	local cooldown_box	= Material(base.."cooldown_box")
	local generic_rect	= Material(base.."generic_rect")
	local health_bar  	= Material(base.."health_bar")
	local pfpback	 	= Material(base.."pfpback")
	local pfpfront		= Material(base.."pfpfront")
	local corner_left  	= Material(base.."corner_left")
	local corner_right  = Material(base.."corner_right")
	local swaplist = {
		["models/props_junk/sawblade001a.mdl"]          = 1,
		["models/props_junk/garbage_coffeemug001a.mdl"] = 2,
		["models/props_junk/harpoon002a.mdl"]           = 3,
		["models/props_vehicles/car004a_physics.mdl"]   = 4,
		["models/props_junk/meathook001a.mdl"]          = 5,
		["models/xqm/helicopterrotorbig.mdl"]           = 6,
		["models/hipriestess/highpriestess.mdl"]        = 7,
	}
	local swaplist_n = {
		"#gstands.hip.form1",
		"#gstands.hip.form2",
		"#gstands.hip.form3",
		"#gstands.hip.form4",
		"#gstands.hip.form5",
		"#gstands.hip.form6",
		"#gstands.hip.form7",
	}
	local bones = {
		"ValveBiped.Bip01_Spine",
		"ValveBiped.Bip01_Spine1",
		"ValveBiped.Bip01_Spine2",
		"ValveBiped.Bip01_Spine4"
	}
	function SWEP:DrawHUD()
		if GetConVar("gstands_draw_hud"):GetBool() and IsValid(self.Stand) then
			local color = gStands.GetStandColorTable(self.Stand:GetModel(), self.Stand:GetSkin())
			local height = ScrH()
			local width = ScrW()
			local mult = ScrW() / 1920
			local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
			gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
			
			surface.SetMaterial(generic_rect)
			surface.DrawTexturedRect(width - (475 * mult) - 30 * mult, height - (148 * mult) - 30 * mult, 307.2 * mult, 153.6 * mult)
			
			draw.TextShadow({
				text = swaplist_n[swaplist[self:GetStand():GetHPModel()]],
				font = "gStandsFontLarge",
				pos = {width - 355 * mult, height - 135 * mult},
				color = tcolor,
				xalign = TEXT_ALIGN_CENTER
			}, 2 * mult, 250)
			
			surface.DrawTexturedRect(width - (665 * mult) - 30 * mult, height - (120 * mult) - 30 * mult, 194.16 * mult, 97.08 * mult)
			
			draw.TextShadow({
				text = swaplist_n[((swaplist[self:GetStand():GetHPModel()] - 2) % #swaplist_n) + 1],
				font = "gStandsFont",
				pos = {width - 605 * mult, height - 120 * mult},
				color = tcolor,
				xalign = TEXT_ALIGN_CENTER
			}, 2 * mult, 250)
			
			surface.DrawTexturedRect(width - (180 * mult) - 30 * mult, height - (120 * mult) - 30 * mult, 194.16 * mult, 97.08 * mult)
			
			draw.TextShadow({
				text = swaplist_n[((swaplist[self:GetStand():GetHPModel()]) % #swaplist_n) + 1],
				font = "gStandsFont",
				pos = {width - 115 * mult, height - 120 * mult},
				color = tcolor,
				xalign = TEXT_ALIGN_CENTER
			}, 2 * mult, 250)
			
		end
	end
	hook.Add( "HUDShouldDraw", "HighPriestessHud", function(elem)
		if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_highpriestess" and (elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
			return false
		end
	end)
	local material = Material( "vgui/hud/gstands_hud/crosshair" )
	function SWEP:DoDrawCrosshair(x,y)
		if IsValid(self.Stand) and IsValid(self.Owner) then
			local tr = util.TraceLine( {
				start = self.Stand:GetEyePos(true),
				endpos = self.Stand:GetEyePos(true) + self.Owner:GetAimVector() * 1500,
				filter = {self.Owner, self:GetStand()},
				mask = MASK_SHOT_HULL
			} )
			local pos = tr.HitPos
			
			local pos2d = pos:ToScreen()
			if pos2d.visible then
				surface.SetMaterial( material )
				local clr = gStands.GetStandColorTable(self.Stand:GetModel(), self.Stand:GetSkin())
				local h,s,v = ColorToHSV(clr)
				h = h - 180
				clr = HSVToColor(h,1,1)
				surface.SetDrawColor( clr )
				surface.DrawTexturedRect( pos2d.x - 16, pos2d.y - 16, 32, 32 )
			end
			return true
		end
	end
--Deploy starts up the stand
function SWEP:Deploy()
	self:SetHoldType( "stando" )
	
	--As is standard with stand addons, set health to 1000
	if self.Owner:Health() == 100  then
		self.Owner:SetMaxHealth( self.Durability )
		self.Owner:SetHealth( self.Durability )
	end
	if SERVER then
		self:SetStand(ents.Create("highpriestess"))
		self.Stand = self:GetStand()
		self.Stand:SetOwner(self.Owner)
		self.Stand:SetPos(self.Owner:WorldSpaceCenter())
		self.Stand:DrawShadow(false)
		self.Stand.Range = self.Range
		self.Stand.Speed = self.Speed
		self.Stand:Spawn()
	end
	if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitSound(Deploy)
			self.Owner:EmitStandSound(Transform)
			
		end
	end
	--Create some networked variables, solves some issues where multiple people had the same stand
	self.Owner:SetCanZoom(false)
end

local models = {
		"models/props_junk/sawblade001a.mdl",
		"models/props_junk/garbage_coffeemug001a.mdl",
		"models/props_junk/harpoon002a.mdl",
		"models/props_vehicles/car004a_physics.mdl",
		"models/props_junk/meathook001a.mdl",
		"models/xqm/helicopterrotorbig.mdl",
		"models/hipriestess/highpriestess.mdl",
}
local modelsAreProp = {
		false,
		true,
		false,
		true,
		false,
		false,
		false,
}

function SWEP:Think()
	self.Stand = self:GetStand()
	if SERVER and !self.Stand:IsValid() then
		self:SetStand(ents.Create("highpriestess"))
		self.Stand = self:GetStand()
		self.Stand:SetOwner(self.Owner)
		self.Stand:SetPos(self.Owner:GetPos())
		self.Stand:DrawShadow(false)
		self.Stand.Range = self.Range
		self.Stand.Speed = self.Speed
		self.Stand:Spawn()
	end
	if self.Owner:gStandsKeyDown("dododo") then
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
	if self.Slashing then
		self.Stand:Slash(self.SlashingHand)	
	end
	if IsValid(self.Stand) then
	self.Stand:SetFlexWeight(0, Lerp(0.05, self.Stand:GetFlexWeight(0), 0))
	self.Stand:SetFlexWeight(2, Lerp(0.05, self.Stand:GetFlexWeight(0), 0))
	end
	if SERVER and self.Owner:gStandsKeyPressed("dododo") then
		--Mode changing
	self.Delay = self.Delay or 0
	if CurTime() > self.Delay then
		self.Delay = CurTime() + 1
		self:SetInDoDoDo(!self:GetInDoDoDo())
		if self:GetInDoDoDo() then
			if SERVER then
				hook.Add("SetupPlayerVisibility", "hipnocullbreak"..self.Owner:GetName(), function(ply, ent) 
					if self:IsValid() and self.Owner:IsValid() and self.Stand:IsValid() then
						AddOriginToPVS( self.Stand:GetPos() + Vector(0,0,50) )
					end
				end)
			end
			
			else
			if SERVER then
				hook.Remove("SetupPlayerVisibility", "hipnocullbreak"..self.Owner:GetName())
			end
		end
	end
	end
	self.RelDelay = self.RelDelay or 0
	if self.Owner:gStandsKeyDown("modeswap") and SERVER and CurTime() > self.RelDelay then
		self.Stand:EmitStandSound(Transform)
		self.Stand:SetHooked(false)
		if self.Stand:GetGround() and self.Stand:GetModel() == "models/hipriestess/highpriestess.mdl" then
			self.Stand:SetGround(!self.Stand:GetGround())
		end
		if IsValid(self.Stand.Prop) then
				self.Stand.Prop:Remove()
			end
		self.ModelIndex = self.ModelIndex or -1

		if self.Owner:gStandsKeyDown("modifierkey1") then
			self.ModelIndex = self.ModelIndex - 2 
		end
		self.RelDelay = CurTime() + 1
		self.ModelIndex = self.ModelIndex + 1
		self.Stand:SetNoDraw(modelsAreProp[self.ModelIndex % #models + 1])
		if !modelsAreProp[self.ModelIndex % #models + 1] then
			self.Stand:SetModel(models[self.ModelIndex % #models + 1])
		else
			self.Stand:SetModel(models[self.ModelIndex % #models + 1])
			if SERVER and IsValid(self.Stand.Prop) then
				self.Stand:GetProp():Remove()
			end
			if SERVER then
				self.Stand:SetProp(ents.Create("prop_physics"))
			end
			if SERVER then
			local prp = self.Stand:GetProp()
			prp:SetPos(self.Stand:GetPos())
			prp:SetModel(models[self.ModelIndex % #models + 1])
			prp:Spawn()
			prp:Activate()
			if IsValid(prp:GetPhysicsObject()) then
				if models[self.ModelIndex % #models + 1] == "models/props_vehicles/car004a_physics.mdl" then
					prp:GetPhysicsObject():SetVelocity((self.Owner:GetAimVector() + self.Owner:GetUp()) * 555)
					else
					prp:GetPhysicsObject():SetVelocity(Vector(0,0,0))
				end
			end
			prp:SetAngles((self.Owner:GetAimVector() + self.Owner:GetUp()):Angle())
			prp:SetOwner(self.Owner)
			prp:SetKeyValue("physdamagescale", 0)
			prp:SetKeyValue("spawnflags", 2)
			end
		end
		self.Stand:ResetSequence(self.Stand:LookupSequence("idle2"))
	end
	if SERVER and self.Owner:gStandsKeyPressed("block") then
		self.Stand:EmitStandSound("weapons/hip/morph/morph2.wav")
	end
	if SERVER and self.Owner:gStandsKeyDown("block") then
		self.Stand:SetInBlock(true)
	elseif SERVER and self.Stand:GetInBlock() then
		self.Stand:SetInBlock(false)
		self.Stand:EmitStandSound("weapons/hip/morph/morph2.wav")

	end
	self:NextThink(CurTime())
	return true
end


function SWEP:PrimaryAttack()
	if SERVER and self:GetStand():GetModel() == "models/hipriestess/highpriestess.mdl" then
		self:SetNextPrimaryFire( CurTime() + 1 )
		self.Stand:SetFlexWeight(0, 1)
		if !self.hand then
			self.hand = true
			self.Stand:AddLayeredSequence(self.Stand:LookupSequence("attackright"))
			self.SlashingHand = false
			self.Stand:EmitStandSound(Slice2)
			else
			self.hand = false
			self.Stand:AddLayeredSequence(self.Stand:LookupSequence("attackleft"))
			self.SlashingHand = true
			self.Stand:EmitStandSound(Slice2)
		end

		self:SetHoldType("pistol")
		self.Slashing = true
		timer.Simple(0.5, function() 
			self.Stand:RemoveAllGestures() 
			self:SetHoldType("stando")
			self.Slashing = false
		end)
	end
end

function SWEP:Bite()
	local tr = util.TraceHull( {
		start = self.Stand:GetEyePos(),
		endpos = self.Stand:GetEyePos() + self.Stand:GetForward() * 75,
		filter = { self.Owner, self.Stand },
		mins = Vector( -15, -15, -15 ), 
		maxs = Vector( 15, 15, 15 ),
		ignoreworld = false,
		mask = MASK_SHOT_HULL
	} )
	if !self.Stand:GetGround() then
	tr = util.TraceHull( {
		start = self.Stand:GetEyePos(),
		endpos = self.Stand:GetEyePos() + self.Stand:GetForward() * 75,
		filter = { self.Owner, self.Stand },
		mins = Vector( -15, -15, -15 ), 
		maxs = Vector( 15, 15, 15 ),
		ignoreworld = false,
		mask = MASK_SHOT_HULL
	} )
	else
	tr = util.TraceHull( {
		start = self.Stand:WorldSpaceCenter(),
		endpos = self.Stand:WorldSpaceCenter() + self.Stand:GetForward() * 75,
		filter = { self.Owner, self.Stand },
		mins = Vector( -100, -100, -55 ), 
		maxs = Vector( 100, 100, 100 ),
		ignoreworld = true,
		mask = MASK_SHOT_HULL
	} )
	end
	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Entity && tr.Entity:IsValid() && !tr.Entity:IsWorld() && !( game.SinglePlayer() && CLIENT ) ) then
		--self.HitFX = self.HitFX or CreateSound( self, Impact )
		--self.HitFX:Play()
	end
	if SERVER and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue("explosion", "2") tr.Entity:SetKeyValue("gibdir", tostring(self:GetAngles())) tr.Entity:Fire("Break") end
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self.Owner end
		dmginfo:SetAttacker( attacker )
		
		dmginfo:SetInflictor( self )
		if !self.Stand:GetGround() then
			dmginfo:SetDamage( 65 )
		else
			dmginfo:SetDamage( 650 )
			if tr.Entity:IsPlayer() or tr.Entity:IsStand() then
				local ent = tr.Entity
				if tr.Entity:IsStand() then
					ent = tr.Entity.Owner
				end
				ent:gStandsStunLock(1, 1)
			end
		end
		tr.Entity:TakeDamageInfo( dmginfo )
		tr.Entity:SetVelocity( self.Owner:GetAimVector() * 1 + Vector( 0, 0, 5 ) )
		self.Stand:EmitStandSound(BiteHit)
		
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
	--Stand leaps! Punch the ground, go flying back. Donut punch is high power.
	if ( tr.HitWorld ) then
		self.Owner:SetVelocity( self.Owner:GetAimVector() * -32 + Vector( 0, 0, 32 ) )
	end
	self.Owner:LagCompensation( false )
end

function SWEP:SecondaryAttack()
	if self.Owner:gStandsKeyDown("modifierkey1") and self:GetStand():GetModel() == "models/hipriestess/highpriestess.mdl" then
		self.Stand:SetGround(!self.Stand:GetGround())
		self:SetNextSecondaryFire( CurTime() + 1 )
		if SERVER then
		self.Stand:EmitStandSound(Transform)
			if self.Stand:GetGround() then
				self.Stand:EmitStandSound(Laugh)
				else
				self.Stand:EmitStandSound(Scream1)
				
			end
		end
	elseif self:GetStand():GetModel() == "models/hipriestess/highpriestess.mdl" then

		if SERVER then
			local pitch = 100
			if self:GetStand():GetGround() then
				pitch = 75
			end
			self.Stand:EmitStandSound(Scream2, 75, pitch)
			self:SetNextSecondaryFire( CurTime() + 1 )
				local seq = self.Stand:AddLayeredSequence(self.Stand:LookupSequence("bite"))
				local tim = 0.5
				self.Stand:SetFlexWeight(0, 1)
				self.Stand:SetFlexWeight(2, 2)
				if self:GetStand():GetGround() then
					self.Stand:SetLayerPlaybackRate(seq, 0.3)
					tim = 2.4
					self.Stand.Speed = 0.2
					
					self.Stand:SetHeadScale(10)
				end
				self:Bite()
			self:SetHoldType("pistol")
			timer.Simple(tim, function() 
				self.Stand:RemoveAllGestures() 
				self:SetHoldType("stando")
				self.Stand:SetHeadScale(1)
				self.Stand.Speed = 1
			end)
		end
	end
end


function SWEP:Reload()
	
end

--Screw this entire section, it only works like 20% of the time. Basically, meant to catch every time the weapon is not in your hands in order to remove the stand.
function SWEP:OnDrop()
	if SERVER and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	if SERVER and self.Stand.GetProp and IsValid(self.Stand:GetProp()) then
		self.Stand:GetProp():Remove()
	end
	
	return true
end

function SWEP:OnRemove()
		if SERVER and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	if SERVER and self.Stand.GetProp and IsValid(self.Stand:GetProp()) then
		self.Stand:GetProp():Remove()
	end
	
	return true
end

function SWEP:Holster()
	if SERVER and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	if SERVER and self.Stand.GetProp and IsValid(self.Stand:GetProp()) then
		self.Stand:GetProp():Remove()
	end
	
	return true
end