
if SERVER then
   AddCSLuaFile( "shared.lua" )
end
if CLIENT then
   SWEP.Slot      = 1
end

SWEP.Power = 1
SWEP.Speed = 0.25
SWEP.Range = 5000
SWEP.Durability = 1500
SWEP.Precision = nil
SWEP.DevPos = nil

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.lovers.purpose"
SWEP.Instructions  = "#gstands.lovers.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.lovers"

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
SWEP.HitDistance = 48

SWEP.StandModel = "models/lovers/lovers.mdl"
SWEP.StandModelP = "models/lovers/lovers.mdl"
SWEP.gStands_IsThirdPerson = true

local PrevHealth = nil


game.AddParticles("particles/lovers.pcf")

PrecacheParticleSystem("loverstentacles_full")

local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )
local Transfer = Sound( "weapons/lovers/hitsound.wav" )
local Deploy = Sound( "weapons/lovers/sdeploy.wav" )
local Clone = Sound( "weapons/lovers/clone.wav" )
local Screech = Sound( "weapons/lovers/screech.wav" )
local Fleshbud = Sound( "weapons/lovers/fleshbud.wav" )
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
	[ "stando" ]		= ACT_HL2MP_IDLE_FIST
    
}

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
		surface.DrawTexturedRect(width - (256 * mult) - 30 * mult, height - (128 * mult) - 30 * mult, 256 * mult, 128 * mult)
		
		draw.TextShadow({
			text = math.Round(self:GetBrainMatter()),
			font = "gStandsFontLarge",
			pos = {width - 160 * mult, height - 120 * mult},
			color = tcolor,
			xalign = TEXT_ALIGN_CENTER
		}, 2 * mult, 250)
		
		draw.TextShadow({
			text = "#gstands.lovers.brainmatter",
			font = "gStandsFont",
			pos = {width - 200 * mult, height - 180 * mult},
			color = tcolor,
			xalign = TEXT_ALIGN_CENTER
		}, 2 * mult, 250)
		
	end
end
hook.Add( "HUDShouldDraw", "LoversHud", function(elem)
	if IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_lovers" and (elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") and GetConVar("gstands_draw_hud"):GetBool() then
		return false
	end
end)
local material = Material( "vgui/hud/gstands_hud/crosshair" )
function SWEP:DoDrawCrosshair(x,y)
	if IsValid(self.Stand) and IsValid(self.Owner) then
		local tr = util.TraceLine( {
			start = self.Stand:GetEyePos(true),
			endpos = self.Stand:GetEyePos(true) + self.Owner:GetAimVector() * 1500,
			filter = {self.Owner, self.Stand},
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
	self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= index
	self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE + 1
	self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
	self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_01"))
	self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
	self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= index + 5
	self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= index + 5
	self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_item_place"))
	self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_item_place"))
	self.ActivityTranslate[ ACT_MP_JUMP ]						= ACT_HL2MP_JUMP_SLAM
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
	
	if ( t == "normal" ) then
		self.ActivityTranslate[ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end
    
    
end
function SWEP:Initialize()
    
end
function SWEP:DrawWorldModel()
	if IsValid(self.Owner) then
		return false
		else
		self:DrawModel()
	end
end
local thirdperson_offset = GetConVar("gstands_thirdperson_offset")
if CLIENT then
    hook.Add( "CalcView", "stand_3rdperson_lovers", 
        function( ply, pos, ang, fov, znear )
			if ( !IsValid( ply ) or !ply:Alive() or ply:GetViewEntity() != ply ) then return end
			if ( !LocalPlayer().GetActiveWeapon or !IsValid( LocalPlayer():GetActiveWeapon() ) or LocalPlayer():GetActiveWeapon():GetClass() != "gstands_lovers") then return end
			local wep = LocalPlayer():GetActiveWeapon()
			
			if wep.GetStand and wep:GetStand().GetInDoDoDo and wep:GetStand():GetInDoDoDo() then
				znear = 1
			end
    end )
end
local thirdperson_offset = GetConVar("gstands_thirdperson_offset")
function SWEP:CalcView( ply, pos, ang )
if not self.gStands_IsThirdPerson or ply:GetViewEntity() ~= ply then return end	if self:GetStand().GetInDoDoDo and self:GetStand():GetInDoDoDo() then
		pos = self:GetStand():GetEyePos()
	end
	local convar = thirdperson_offset:GetString()
	local strtab = string.Split(convar, ",")
	local offset = Vector(strtab[1], strtab[2], strtab[3])
	offset:Rotate(ang)

	local length = 100
	if self:GetStand().GetInDoDoDo and self:GetStand():GetInDoDoDo() then length = 5 end
	local trace = util.TraceHull( {
		start = pos,
		endpos = pos - ang:Forward() * length,
		filter = { ply:GetActiveWeapon(), ply, ply:GetVehicle() },
		mins = Vector( -0.1, -0.1, -0.1 ),
		maxs = Vector( 0.1, 0.1, 0.1 ),
	} )


	if ( trace.Hit ) then pos = trace.HitPos else pos = trace.HitPos end
	return pos + offset,ang
end
function SWEP:SetupDataTables()
		self:NetworkVar("Entity", 0, "Target")
		self:NetworkVar("Entity", 2, "Stand")
		self:NetworkVar("Float", 1, "BrainMatter")
		self:NetworkVar("Bool", 0, "Fleshbud")
end
function SWEP:DefineStand()
	if SERVER then
		self:SetStand( ents.Create("lovers"))
		self.Stand = self:GetStand()
		self.Stand:SetOwner(self.Owner)
		self.Stand:SetModel("models/lovers/lovers.mdl")
		self.Stand:SetMoveType( MOVETYPE_NOCLIP )
		self.Stand:SetAngles(self.Owner:GetAngles())
		self.Stand:SetPos(self.Owner:GetBonePosition(0)+Vector(0, 0, 0))
		self.Stand:DrawShadow(false)
		self.Stand.Range = self.Range
		self.Stand.Speed = 20 * self.Speed
		self.Stand.Wep = self
		self.Stand.AnimSet = {
			"SWIMMING_all", 1,
			"GMOD_BREATH_LAYER", 1,
			"AIMLAYER_CAMERA", 0,
			"IDLE_ALL_02", 0.5,
			"FIST_BLOCK", 0.6,
		}
		self.Stand:Spawn()
	end
end
function SWEP:DefineClone()
	if SERVER then
		local fake = ents.Create("fakelovers")
		fake:SetOwner(self.Owner)
		fake:SetModel("models/lovers/lovers.mdl")
		fake:SetAngles(self.Stand:GetAngles())
		fake:SetPos(self.Stand:GetPos())
		fake:DrawShadow(false)
		fake.Range = self.Range
		fake.MaxSpeed = 20 * self.Speed
		fake.Speed = 0.05
		fake.Wep = self
		fake.AnimSet = {
			"SWIMMING_all", 1,
			"GMOD_BREATH_LAYER", 1,
			"AIMLAYER_CAMERA", 0,
			"IDLE_ALL_02", 0.5,
			"FIST_BLOCK", 0.6,
		}
		fake:Spawn()
		self:SetBrainMatter(self:GetBrainMatter() - 10 ) 
		fake:EmitStandSound(Clone)
	end
end
function SWEP:Deploy()
    self:SetHoldType( "stando" )
	local hooktag = self.Owner:GetName()
    hook.Add("EntityTakeDamage", "LoversReturnDamage"..hooktag, function(ent, dmg)
		if IsValid(self) and IsValid(self.Owner) and IsValid(self:GetTarget()) then
			self.lastDamageTick = self.lastDamageTick or CurTime() - 1
			if self.lastDamageTick ~= CurTime() and ent == self.Owner and dmg:GetDamage() < ent:Health() then

			local damage = dmg:GetDamage()
			local entt = ent
			local attack = dmg:GetAttacker()
			local inflict = dmg:GetInflictor()
			
			dmg:SetDamage(damage * 3)
			dmg:SetInflictor(self)
			dmg:SetAttacker(self.Owner)
			timer.Simple(0,function() if IsValid(self) and IsValid(self.Owner) and IsValid(self:GetTarget()) then self:GetTarget():SetVelocity(self.Owner:GetVelocity()) end end)
			self:GetTarget():TakeDamageInfo(dmg)
				if SERVER then
					self:GetTarget():EmitStandSound(Transfer)
				end
			end
			self.lastDamageTick = CurTime()
		end
	end)
	if SERVER then
			if GetConVar( "gstands_deploy_sounds" ):GetBool() then
				self.Owner:EmitSound(Deploy)
			end
		end
    if self.Owner:Health() == 100  then
        self.Owner:SetMaxHealth( self.Durability )
        self.Owner:SetHealth( self.Durability )
	end
        
    self:DefineStand()
	
    self.Owner:SetCanZoom(false)
end

function SWEP:Think()
    self.Stand = self:GetStand()
	if !IsValid(self.Stand) then
		self:DefineStand()
	end
	local curtime = CurTime()

    -- if self:GetStand().GetInDoDoDo and self:GetStand():GetInDoDoDo() then
			-- self.Menacing = self.Menacing or CurTime()
            -- if CurTime() > self.Menacing then
				-- self.Menacing = CurTime() + 0.5
                -- local effectdata = EffectData()
				-- effectdata:SetStart(self.Owner:GetPos())
				-- effectdata:SetOrigin(self.Owner:GetPos())
				-- effectdata:SetEntity(self.Owner)
                -- util.Effect("menacing", effectdata)
                -- end
    -- end
    if SERVER then
	if self:GetTarget():IsValid() then
		self:SetBrainMatter(math.min(100, self:GetBrainMatter() + 0.1))
	end
    if self:GetTarget():IsValid() and self:GetTarget():Health() <= 0 then
    self:SetTarget( NULL )
    self:SetFleshbud( false)
    end
    
    if IsFirstTimePredicted() and self.Owner:gStandsKeyPressed("tertattack") and self:GetTarget():IsValid() and self:GetBrainMatter() >= 100 then
        self.Stand:EmitStandSound(Screech)
		self:SetFleshbud(true)
		self:SetBrainMatter(self:GetBrainMatter() - 100)
    end
    
    if SERVER and self:GetTarget():IsValid() and self:GetFleshbud() then
        self.Delay2 = self.Delay2 or CurTime()
        if CurTime() > self.Delay2 then
            self:GetTarget():TakeDamage(15, self.Owner, self)
            local fxdata = EffectData()
            fxdata:SetOrigin(self:GetTarget():GetBonePosition(self:GetTarget():LookupBone("ValveBiped.Bip01_Head1")))
            fxdata:SetEntity(self:GetTarget())
            util.Effect("BloodImpact", fxdata, true, true)
			ParticleEffect("loverstentacles_full", self:GetTarget():EyePos(), Angle(0,0,0))
			self:GetTarget():EmitSound(Fleshbud)
			self.Delay2 = CurTime() + 1
        end
    end
    end
	self.clonetimer = self.clonetimer or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("modeswap") and CurTime() >= self.clonetimer and self:GetBrainMatter() >= 10 then
		self:DefineClone()
		self.clonetimer = CurTime() + 1
	end
	if self:GetTarget():IsValid() and self:GetFleshbud() then
        self.Delay2 = self.Delay2 or CurTime()
        if CurTime() > self.Delay2 then
			ParticleEffectAttach("loverstentacles_full", PATTACH_POINT_FOLLOW, self:GetTarget(), 1)
			self.Delay2 = CurTime() + 1
        end
    end
	
end
    
   
function SWEP:PrimaryAttack()

        
        self.Owner:SetAnimation( PLAYER_ATTACK1 )
        
        self:EmitSound( SwingSound )
        
        self:Barrage()
		self:SetNextPrimaryFire( CurTime() + (0.5) )
end


function SWEP:SecondaryAttack()
    
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
    
	local anim = "punch2"
    
	self:EmitSound( SwingSound )
    self:DonutPunch()
    
    
	self:SetNextSecondaryFire( CurTime() + 3 )
end

function SWEP:Barrage()
    
    
	local anim = self.Owner:GetSequenceName(self.Owner:GetSequence())

	self.Owner:LagCompensation( true )

	local tr = util.TraceLine( {
		start = self.Owner:EyePos(),
		endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 100,
		filter = self.Owner,
	} )

	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( GetStandImpactSfx(tr.MatType) )
	end

	local hit = false

	if ( SERVER and tr.Hit) then
		local dmginfo = DamageInfo()

		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 2 )

		if ( anim == "punch1" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * 4912 + self.Owner:GetForward() * 9998 ) 
		elseif ( anim == "punch1" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * -4912 + self.Owner:GetForward() * 9989 )
		end

		self.Owner:TakeDamageInfo( dmginfo )
        if tr.Entity:IsValid() then
            tr.Entity:TakeDamageInfo( dmginfo )
        end
       
		hit = true

	end    
    
    if tr.Entity:IsPlayer() then
           tr.Entity:ViewPunch( Angle( math.random( -3, 3 ), math.random( -3, 3 ), math.random( -3, 3 ) ) )
    end

	self.Owner:LagCompensation( false )
    
end

function SWEP:DonutPunch()

    
	local anim = self.Owner:GetSequenceName(self.Owner:GetSequence())

	self.Owner:LagCompensation( true )

	local tr = util.TraceLine( {
		start = self.Owner:EyePos(),
		endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 100,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )
	
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self.Owner:EmitSound( GetStandImpactSfx(tr.MatType) )
	end

	local hit = false

	if ( SERVER && tr.Hit) then
		local dmginfo = DamageInfo()

		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self.Owner end
		dmginfo:SetAttacker( attacker )

		dmginfo:SetInflictor( self.Owner )
        
		dmginfo:SetDamage( 25 * self.Power )

		if ( anim == "punch1" ) then
			dmginfo:SetDamageForce( (self.Owner:GetRight() * 4912 + self.Owner:GetEyeAngles() * 9998 ) )
		end

		self.Owner:TakeDamageInfo( dmginfo )
        if IsValid( tr.Entity ) then
            tr.Entity:TakeDamageInfo( dmginfo )
        end
		hit = true

	end

	self.Owner:LagCompensation( false )
    
end

function SWEP:Reload()

end


function SWEP:OnDrop()
	if SERVER and IsValid(self.Stand) then
		self.Stand:Remove()
	end
    return true
end

function SWEP:OnRemove()
	if SERVER and IsValid(self.Stand) then
		self.Stand:Remove()
	end
    return true
end

function SWEP:Holster()
	if SERVER and IsValid(self.Stand) then
		self.Stand:Remove()
	end
    return true
end