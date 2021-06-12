--Send file to clients
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot      = 1
end

SWEP.Power = 2.25
SWEP.Speed = 1.25
SWEP.Range = 1000
SWEP.Durability = 800
SWEP.Precision = nil
SWEP.DevPos = nil

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.emperor.purpose"
SWEP.Instructions  = "#gstands.emperor.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_base"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.emperor"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos            = 2
SWEP.DrawCrosshair      = true

SWEP.WorldModel = "models/emperor/models/emperor.mdl"
SWEP.ViewModel = "models/emperor/models/c_emperor.mdl"
SWEP.ViewModelFOV = 100
SWEP.UseHands = true

SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "emp_bul"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = true
SWEP.HitDistance = 48


SWEP.StandModel = "models/emperor/models/emperor.mdl"
SWEP.StandModelP = "models/emperor/models/emperor.mdl"

game.AddParticles("particles/emperor.pcf")
SWEP.RenderGroup = RENDERGROUP_TRANSLUCENT
PrecacheParticleSystem("emperor_muzzleflash")
local thirdperson_offset = GetConVar("gstands_thirdperson_offset")
function SWEP:CalcView( ply, pos, ang, fov )
	if ply:GetViewEntity() ~= ply then return end
	local self = LocalPlayer():GetActiveWeapon()
	self.gStands_IsThirdPerson = false
	if ply:gStandsKeyDown("dododo") and self.GetLastBull and self:GetLastBull():IsValid() then
		pos = self:GetLastBull():WorldSpaceCenter() - ply:GetAimVector() * 55 + Vector(0,0,3)
		self.gStands_IsThirdPerson = true
	end
	return pos, ang
end

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
	[ "stando" ]		= ACT_HL2MP_IDLE_PISTOL
    
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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= index
		self.ActivityTranslate[ ACT_MP_WALK ]						= index + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
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

local pos, material, white = Vector( 0, 0, 0 ), Material( "sprites/hud/v_crosshair1" ), Color( 255, 255, 255, 255 )
local base          = "vgui/hud/gstands_hud/"
local armor_bar     = Material(base.."armor_bar")
local bar_border    = Material(base.."bar_border")
local boxdis        = Material(base.."boxdis")
local boxend        = Material(base.."boxend")
local cooldown_box  = Material(base.."cooldown_box")
local generic_rect  = Material(base.."generic_rect")
local health_bar    = Material(base.."health_bar")
local pfpback       = Material(base.."pfpback")
local pfpfront      = Material(base.."pfpfront")
local corner_left   = Material(base.."corner_left")
local corner_right  = Material(base.."corner_right")

function SWEP:DrawHUD()
    if GetConVar("gstands_draw_hud"):GetBool() then
        local color = gStands.GetStandColorTable(self.StandModel, self:GetSkin())
        local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
		surface.SetMaterial(generic_rect)
		surface.DrawTexturedRect(width - (256 * mult) - 30 * mult, height - (128 * mult) - 30 * mult, 256 * mult, 128 * mult)
		
		local name = "#gstands.emperor.notarget"
		if self:GetTarget():IsValid() then
			name = self:GetTarget():GetClass()
		end
		if self:GetTarget():IsValid() and self:GetTarget():IsPlayer() then
			name = self:GetTarget():GetName()
		end
		draw.TextShadow({
			text = name,
			font = "gStandsFont",
			pos = {width - 160 * mult, height - 120 * mult},
			color = tcolor,
			xalign = TEXT_ALIGN_CENTER
		}, 2 * mult, 250)
	end
end
hook.Add( "HUDShouldDraw", "EmperorHud", function(elem)
    if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_emperor" and (((elem == "CHudWeaponSelection" ) and LocalPlayer().SPInZoom) or elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
        return false
	end
end)

hook.Add("ShouldDrawLocalPlayer", "EmperorDrawLocalPlayer", function()
	return InHudDrawEmperor
end)
--Define swing and hit sounds. Might change these later.
local Shoot = Sound( "emp.bang" )
local Deploy = Sound( "weapons/emperor/deploy/deploy_01.wav" )
local SDeploy = Sound( "weapons/emperor/sdeploy.wav" )
local Voice = Sound( "emp.firinglines" )
function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Target")
	self:NetworkVar("Entity", 1, "AimDummy")
	self:NetworkVar("Entity", 2, "LastBull")
	self:NetworkVar("Bool", 3, "InDoDoDo")
	self:NetworkVar("Entity", 4, "Stand") --Compatibility
end
function SWEP:Initialize()
    --Set the third person hold type to fists
end

--Deploy starts up the stand
function SWEP:Deploy()
    self:SetHoldType( "stando" )
	self:SetSkin(self.Owner:GetInfoNum("gstands_standskin_gstands_emperor", math.random(0, self:SkinCount() - 1)))
	self.Owner:GetViewModel():SetSkin(self.Owner:GetInfoNum("gstands_standskin_gstands_emperor", math.random(0, self:SkinCount() - 1)))
    if SERVER then
		self:EmitStandSound(SDeploy)
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitSound(Deploy)
		end
		self:SendWeaponAnim(ACT_VM_DRAW)
	end
    --As is standard with stand addons, set health to 1000
    if SERVER and self.Owner:Health() == 100  then
        self.Owner:SetMaxHealth( self.Durability )
        self.Owner:SetHealth( self.Durability )
	end
	self.PullOut = 0
end

function SWEP:Think()
    if not IsValid(self:GetStand()) then
		self:SetStand(self)
	end
	local curtime = CurTime()
    if self.GetTarget and self:GetTarget():IsValid() and self:GetTarget():GetPhysicsObject():IsValid() and self:GetAimDummy():IsValid() then
        if self:GetTarget():IsPlayer() and self:GetTarget():Alive() then
			
			self:GetAimDummy():SetPos(self:GetTarget():LocalToWorld(self:GetTarget():GetPhysicsObject():GetMassCenter()))
			elseif self:GetTarget():IsPlayer() and !self:GetTarget():Alive() then
			self:SetTarget(NULL)
			else
			self:GetAimDummy():SetPos(self:GetTarget():LocalToWorld(self:GetTarget():GetPhysicsObject():GetMassCenter()))
		end
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
		self:SetHoldType("revolver")
		else
		self:SetHoldType("stando")
	end
	if SERVER and self.Owner:GetActiveWeapon() == self and self.Owner:GetViewModel():GetSequence() != self.Owner:GetViewModel():LookupSequence("idle") and self.Owner:GetViewModel():GetCycle() >= 1 then
		self.Owner:GetViewModel():ResetSequence("idle")
	end
	self:NextThink(CurTime())
	return true
end

function SWEP:ShootGun(multiple)
	if IsFirstTimePredicted() then
		self:SetClip1(math.min(6, self:Clip1()))
		if self:Clip1() > 0 and (SERVER) and !self.Owner:gStandsKeyDown("defensivemode") then
		    self:SetClip1(self:Clip1() - 1)
		    self.Owner:EmitStandSound(Shoot)
			local boolet = ents.Create("emperor_bullet")
			if IsValid(boolet) then
				boolet:SetAngles(self.Owner:EyeAngles())
				if multiple then
					local norm = self.Owner:GetAimVector() * 5 + VectorRand()
					boolet:SetAngles(norm:Angle())
				end
				boolet:SetPos(self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")))
                boolet:SetOwner(self.Owner)
				boolet:SetPhysicsAttacker(self.Owner)
				boolet:Spawn()
				boolet.Preference = self.Preference
				self.Preference = self.Preference or 1
				self.Preference = self.Preference * -1
				boolet.OwnerWep = self
				boolet:Activate()
				boolet:SetVelocity(boolet:GetForward() * 1)
				self:SetLastBull(boolet)
			end
		end
		if (SERVER) and self.Owner:gStandsKeyDown("defensivemode") then
			local dist = 1000000000
			local hasone
			for k,v in pairs(ents.FindInSphere(self.Owner:WorldSpaceCenter(), 1500)) do
				if v:GetClass() != "emperor_bullet" and (v:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE or v:GetClass() == "rpg_missile" or v:GetClass() == "npc_grenade_frag" or v:GetClass() == "weapon_slam") and v:GetPos():DistToSqr(self.Owner:WorldSpaceCenter()) < dist then
					self:SetTarget(v)
					dist = v:GetPos():DistToSqr(self.Owner:WorldSpaceCenter())
					hasone = true
				end
			end
		    self:SetClip1(self:Clip1() - 1)
		    self.Owner:EmitStandSound(Shoot)
			local boolet = ents.Create("emperor_bullet")
			if IsValid(boolet) then
				boolet:SetAngles(self.Owner:EyeAngles())
				if multiple then
					local norm = self.Owner:GetAimVector() * 5 + VectorRand()
					boolet:SetAngles(norm:Angle())
				end
				boolet:SetPos(self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")))
                boolet:SetOwner(self.Owner)
				boolet:SetPhysicsAttacker(self.Owner)
				if hasone then
					boolet.TargettingProjectile = self:GetTarget()
				end
				boolet:Spawn()
				boolet.Preference = self.Preference
				self.Preference = self.Preference or 1
				self.Preference = self.Preference * -1
				boolet.OwnerWep = self
				boolet:Activate()
				boolet:SetVelocity(boolet:GetForward() * 1)
				self:SetLastBull(boolet)
			end
		end
	end
end

function SWEP:FireAnimationEvent()
	return true
end

function SWEP:PrimaryAttack()
    if self:Clip1() > 0 and !self.Owner:gStandsKeyDown("modifierkey1") then
		if SERVER then
			local tr = util.TraceLine( {
				start = self.Owner:EyePos(),
				endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * self.HitDistance * 5000,
				filter = self.Owner ,
				mask = MASK_SHOT_HULL,
				ignoreworld = false,
				collisiongroup = COLLISION_GROUP_PROJECTILE
			} )
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
		end
		--Punch mode
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		if SERVER then
			self:ShootGun()
			--Swingy swingy
			
			
			--Miniscule delay
			self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() + 0.05)
			self.Owner:ViewPunch( Angle( -5, 0, 0 ) )
		end
	end
	if self:Clip1() > 0 and self.Owner:gStandsKeyDown("modifierkey1") then
		if SERVER then
			self.Owner:GetViewModel():ResetSequence("shootlots")
			self.Owner:GetViewModel():SetCycle(0)
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			self.Owner:EmitSound(Voice)
			--Punch mode
		end
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self:ShootGun(true)
		self.Owner:AddFlags(FL_ATCONTROLS)
		timer.Simple(0.1, function()
			self:ShootGun(true)
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
		end)
		timer.Simple(0.2, function()
			self:ShootGun(true)
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
		end)
		timer.Simple(0.3, function()
			self.Owner:RemoveFlags(FL_ATCONTROLS)
		end)
		if SERVER then
			--Swingy swingy
			
			--Miniscule delay
			self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() + 0.05)
			self.Owner:ViewPunch( Angle( -5, 0, 0 ) )
		end
	end
end

function SWEP:GetEmperorClosest(ply, vec)
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
    if closestply and closestply:WorldSpaceCenter():Distance(self.Owner:WorldSpaceCenter()) <= 2390 then
		return closestply
		else
		return NULL
	end
end

function SWEP:SecondaryAttack()
    --Punch mode
    self.Owner:SetAnimation( PLAYER_RELOAD )
    
    local tr = util.TraceLine( {
		start = self.Owner:EyePos(),
		endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * self.HitDistance * 5000,
		filter = self.Owner ,
		mask = MASK_SHOT_HULL,
	} )
	
	self:SetTarget(self:GetEmperorClosest(self.Owner, tr.HitPos))
    if self:GetTarget():IsValid() and IsFirstTimePredicted() and SERVER then
        self.Owner:ChatPrintFormatted("#gstands.emperor.target",self:GetTarget():GetName())
	end
	if IsValid(tr.Entity) and !IsValid(self:GetEmperorClosest(self.Owner, tr.HitPos)) then
		self:SetTarget(tr.Entity)
	end
	if !self:GetTarget():IsValid() and SERVER then
		self.Owner:ChatPrint("#gstands.emperor.targetclear")
	end
    --No spamming the donut punch.
	self:SetNextSecondaryFire( CurTime() + 1 )
end

--Screw this entire section, it only works like 20% of the time. Basically, meant to catch every time the weapon is not in your hands in order to remove the stand.
function SWEP:OnDrop()
    if SERVER and self:GetAimDummy():IsValid() then
		self:GetAimDummy():Remove()
	end
    timer.Remove("EmperorAnim"..self:EntIndex())
	
    return true
end

function SWEP:OnRemove()
    if SERVER and self:GetAimDummy():IsValid() then
		self:GetAimDummy():Remove()
		
	end
	timer.Remove("EmperorAnim"..self:EntIndex())
	
    return true
end

function SWEP:Holster()
	if IsValid(self.Owner:GetViewModel()) then
		self.Owner:GetViewModel():SetSkin(0)
	end
    self.HolstTime = self.HolstTime or (CurTime() + 0.5)
    timer.Remove("EmperorAnim"..self:EntIndex())
    if SERVER and self:GetAimDummy():IsValid() then
		self:GetAimDummy():Remove()
	end
    return true
end

function SWEP:DrawWorldModelTranslucent()
	if IsValid(self.Owner) then
		self.WorldModel = "models/emperor/models/emperor.mdl"
		if CLIENT and LocalPlayer():GetActiveWeapon() and !self.Owner:GetNoDraw() then
			if LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then
				self.PullOut = self.PullOut or 0
				render.SetBlend(self.PullOut)
				self:DrawModel() -- Draws Model Client Side
				render.SetBlend(1)
				self.PullOut = self.PullOut + 0.006
			end
		end
		else
		self.WorldModel = "models/player/whitesnake/disc.mdl"
		self:DrawModel()
	end
	if self:GetNoDraw() then
		self.PullOut = 0
	end
end