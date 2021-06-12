--Send file to clients
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot	  = 1
end

SWEP.Power = 2.5
SWEP.Speed = 1.95
SWEP.Range = 1500
SWEP.Durability = 1500
SWEP.Precision = nil
SWEP.DevPos = nil

SWEP.Author		= "Copper"
SWEP.Purpose	   = "#gstands.sun.purpose"
SWEP.Instructions  = "#gstands.sun.instructions"
SWEP.Spawnable	 = true
SWEP.Base		  = "weapon_fists"   
SWEP.Category	  = "gStands"
SWEP.PrintName	 = "#gstands.names.sun"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos			= 2
SWEP.DrawCrosshair	  = true

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
SWEP.gStands_IsThirdPerson = true

local Shoot = Sound( "weapons/sun/shoot.mp3" )
local Deploy = Sound("weapons/sun/deploy.mp3")
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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= ACT_HL2MP_IDLE_MAGIC
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE_SLAM + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_01"))
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= ACT_HL2MP_IDLE_PISTOL + 5
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= ACT_HL2MP_IDLE_PISTOL + 5
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= ACT_HL2MP_IDLE_FIST + 5
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= ACT_HL2MP_IDLE_FIST + 5
		self.ActivityTranslate[ ACT_MP_JUMP ]						= ACT_HL2MP_IDLE_DUEL + 7
		self.ActivityTranslate[ ACT_RANGE_ATTACK1 ]					= index + 8
		self.ActivityTranslate[ ACT_MP_SWIM ]						= ACT_HL2MP_IDLE_DUEL + 9
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
function SWEP:Initialize()
	--Set the third person hold type to fists
	self:SetNextPrimaryFire( CurTime() + 1 )
	
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
if not self.gStands_IsThirdPerson or ply:GetViewEntity() ~= ply then return end	if self.GetSun and self:GetSun().GetInDoDoDo and self:GetSun():GetInDoDoDo() then
		pos = self:GetSun():GetPos()
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
	if self.GetSun and IsValid(self:GetSun()) and self:GetSun().GetInDoDoDo and self:GetSun():GetInDoDoDo() then
		trace = util.TraceHull( {
			start = self:GetSun():GetPos(),
			endpos = self:GetSun():GetPos() + LocalPlayer():GetAimVector() * 15500,
			filter = { ply:GetActiveWeapon(), ply },
			mins = Vector( -15, -15, -15 ),
			maxs = Vector( 15, 15, 15 ),
		} )
		pos = self:GetSun():GetPos() + LocalPlayer():GetAimVector() * 500 + Vector(0,0,10)
	end

	if ( trace.Hit ) then pos = trace.HitPos else pos = trace.HitPos end
	return pos + offset,ang
end
function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Sun")
	self:NetworkVar("Bool", 0, "AMode")
	self:NetworkVar("Bool", 1, "SunState")
	self:NetworkVar("Float", 1, "Delay2")
	self:NetworkVar("Bool", 2, "Ended")
end
--Deploy starts up the stand
function SWEP:Deploy()
	self:SetHoldType( "stando" )
	
	if self.Owner:Health() == 100  then
		self.Owner:SetMaxHealth( self.Durability )
		self.Owner:SetHealth( self.Durability )
	end
	if SERVER then
	end
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

local bones = {
	"ValveBiped.Bip01_Spine",
	"ValveBiped.Bip01_Spine1",
	"ValveBiped.Bip01_Spine2",
	"ValveBiped.Bip01_Spine4"
}
function SWEP:DrawHUD()
	if GetConVar("gstands_draw_hud"):GetBool() then
		local color = Color(255,255,50)
		local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
	end
end
hook.Add( "HUDShouldDraw", "SunHud", function(elem)
	if IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_sun" and (elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") and GetConVar("gstands_draw_hud"):GetBool() then
		return false
	end
end)

local material = Material( "sprites/hud/v_crosshair1" )
function SWEP:DoDrawCrosshair(x,y)
		if IsValid(self:GetSun()) then
		local tr = util.TraceLine( {
			start = self.Owner:EyePos(),
			endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * self.HitDistance * 50000,
			filter = {self.Owner, self:GetSun()},
			mask = MASK_SHOT_HULL,
		} )
		if self:GetSun():GetInDoDoDo() then
		tr = util.TraceLine( {
			start = self:GetSun():GetPos(),
			endpos = self:GetSun():GetPos() + self.Owner:GetAimVector() * self.HitDistance * 50000,
			filter = {self.Owner, self:GetSun()},
			mask = MASK_SHOT_HULL,
			collisiongroup = COLLISION_GROUP_PROJECTILE
		} )
		end
		local pos = tr.HitPos

		local pos2d = pos:ToScreen()
		if pos2d.visible then
			surface.SetMaterial( material	)
			surface.SetDrawColor( Color(255,150,150) )
			surface.DrawTexturedRect( pos2d.x - 8, pos2d.y - 8, 16, 16 )
		end
		return true
	end
end
function SWEP:Think()
	
	if IsValid(self:GetSun()) and self:GetSun():GetInDoDoDo() then
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
	
	--Mode changing
	self.Delay = self.Delay or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("modeswap") and CurTime() > self.Delay then
		self.Delay = CurTime() + 1
		self.SunTimer = CurTime()
		self.SunInterval = 2
		self.IntervalChanger = CurTime()
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		--Flip the mode bool
		self:SetSunState( !self:GetSunState())
		
		if SERVER then
			if SERVER and (self:GetSunState()) then 
				
				local tr = util.TraceLine( {
					start = self.Owner:EyePos(),
					endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * self.HitDistance * 5000,
					filter = {self.Owner, self:GetSun()},
					mask = MASK_SHOT_HULL
				} )
				self.Owner:ChatPrint("#gstands.sun.on")
				local trUp = util.TraceLine( {
					start = tr.HitPos,
					endpos = tr.HitPos + Vector(0,0,3000),
					filter = {self.Owner, self:GetSun()},
					mask = MASK_SHOT_HULL
				} )
				self:SetSun( ents.Create("gstands_sun_entity"))
				self:GetSun():SetPos(trUp.HitPos)
				self:GetSun():SetOwner(self.Owner)
				self:GetSun():Spawn()
				local fxdata = EffectData()
				fxdata:SetOrigin(self:GetSun():GetPos())
				fxdata:SetEntity(self:GetSun())
				util.Effect("gstands_sun", fxdata, true, true)
							self:GetSun().light = ents.Create("light_dynamic")

				self:GetSun().light:SetPos(self:GetSun():GetPos())
				self:GetSun().light:SetParent(self:GetSun())
				self:GetSun().light:Spawn()
				self:GetSun().light:Activate()
				self.Owner:EmitStandSound(Deploy, 511, 100, 1)
				
				
				self:GetSun().light:SetKeyValue("distance", 5500)
				self:GetSun().light:SetKeyValue("brightness", 1)
				self:GetSun().light:SetKeyValue("_light", "255 100 50 255")
				self:GetSun().light:Fire("TurnOn")
				self:GetSun().light:SetParent(self:GetSun())
				else
				self:GetSun().light:Remove()
				self.Owner:ChatPrint("#gstands.sun.off")
				if SERVER then
					self:GetSun():Remove()
					self.Owner:RemoveFlags(FL_ATCONTROLS)
				end
			end
		end
	end
end

function SWEP:PrimaryAttack()
	
	if self:GetSunState() then
		self.Owner:SetAnimation(PLAYER_RELOAD)
		local tr = util.TraceLine( {
			start = self.Owner:EyePos(),
			endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * self.HitDistance * 50000,
			filter = {self.Owner, self:GetSun()},
			mask = MASK_SHOT_HULL
		} )
		if self:GetSun():GetInDoDoDo() then
		tr = util.TraceLine( {
			start = self:GetSun():GetPos(),
			endpos = self:GetSun():GetPos() + self.Owner:GetAimVector() * self.HitDistance * 50000,
			filter = {self.Owner, self:GetSun()},
			mask = MASK_SHOT_HULL
		} )
		end
		if tr.Hit then
			self:ShootLaser(tr.HitPos)
		end
		
		--Miniscule delay
		self:SetNextPrimaryFire( CurTime() + 0.3 )
	end
end

function SWEP:ShootLaser(target)
local dir = -(self:GetSun():GetPos() - target):GetNormalized()
	if IsFirstTimePredicted() then
		if (SERVER) then
			self:GetSun():EmitStandSound(Shoot)

			local laser = ents.Create("sun_laser")
			if IsValid(laser) then
				laser:SetAngles(dir:Angle())
				laser:SetPos(self:GetSun():GetPos())
				laser:SetOwner(self.Owner)
				laser:Spawn()
				laser:Activate()
			end
		end
	end
end

function SWEP:SecondaryAttack()
	
	if self:GetSunState() then
		self.Owner:SetAnimation(PLAYER_RELOAD)
		
		timer.Create("sunburst", 0.1, 12, function()
			for i = 0, 5 do
				local tr = util.TraceLine( {
					start = self.Owner:EyePos(),
					endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * self.HitDistance * 50000,
					filter = {self.Owner, self:GetSun()},
					mask = MASK_SHOT_HULL,
					collisiongroup = COLLISION_GROUP_PROJECTILE
				} )
				if self:GetSun():GetInDoDoDo() then
				tr = util.TraceLine( {
					start = self:GetSun():GetPos(),
					endpos = self:GetSun():GetPos() + self.Owner:GetAimVector() * self.HitDistance * 50000,
					filter = {self.Owner, self:GetSun()},
					mask = MASK_SHOT_HULL,
					collisiongroup = COLLISION_GROUP_PROJECTILE
				} )
				end
				if tr.Hit then
					self:ShootLaser(tr.HitPos + Vector(math.random(-256,256),math.random(-256,256),math.random(-256,256)))
				end
			end
		end)
		self:SetNextPrimaryFire( CurTime() + 8 )
		self:SetNextSecondaryFire( CurTime() + 8 )
	end
end

function SWEP:Reload()
	
end

function SWEP:OnDrop()
	if SERVER and self:GetSun():IsValid() then
		self:GetSun():Remove()
		self:SetSunState( false)
		self.Owner:RemoveFlags(FL_ATCONTROLS)
	end
	return true
end

function SWEP:OnRemove()
	if SERVER and self:GetSun():IsValid() then
		self:GetSun():Remove()
		self:SetSunState( false)
		self.Owner:RemoveFlags(FL_ATCONTROLS)
	end
	return true
end

function SWEP:Holster()
	if SERVER and self:GetSun():IsValid() then
		self:GetSun():Remove()
		self:SetSunState( false)
		self.Owner:RemoveFlags(FL_ATCONTROLS)
	end
	return true
end