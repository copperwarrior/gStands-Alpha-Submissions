if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot	 			= 1
end
SWEP.Power 					= 3
SWEP.Speed 					= 1
SWEP.Range 					= 500
SWEP.Durability 			= 1500
SWEP.Precision 				= A
SWEP.DevPos 				= A
SWEP.Author					= "Copper"
SWEP.Purpose	  			= "#gstands.star_platinum.purpose"
SWEP.Instructions 			= "#gstands.star_platinum.instructions"
SWEP.Spawnable	 			= true
SWEP.Base		 			= "weapon_fists"  
SWEP.Category	 			= "gStands"
SWEP.PrintName	 			= "#gstands.names.star_platinum"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos				= 2
SWEP.DrawCrosshair			= true
SWEP.WorldModel				= "models/player/whitesnake/disc.mdl"
SWEP.ViewModelFOV			= 54
SWEP.UseHands				= true

game.AddAmmoType( {
	name 		= "ammo_ball_bearing",
	dmgtype 	= DMG_BULLET,
	tracer 		= TRACER_LINE,
	plydmg 		= 0,
	npcdmg 		= 0,
	force 		= 2000,
	minsplash 	= 10,
	maxsplash 	= 5	
})
SWEP.Primary.ClipSize	  	= 50
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic	 	= true
SWEP.Primary.Ammo		  	= "ammo_ball_bearing"

SWEP.Secondary.ClipSize	 	= 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo		 	= "none"

SWEP.DrawAmmo				= true
SWEP.HitDistance			= 5
SWEP.TimeStopped			= false

SWEP.StandModel 			= "models/player/starpjf/spjf.mdl"
SWEP.StandModelP 			= "models/player/starpjf/spjf.mdl"

SWEP.AccurateCrosshair 		= true
SWEP.CanZoom 		= true
SWEP.gStands_IsThirdPerson = true


SWEP.CanTimeStop = true
SWEP.TSConvarLimit = GetConVar("gstands_star_platinum_limit")
SWEP.TSConvarLength = GetConVar("gstands_star_platinum_timestop_length")

local SwingSound = Sound( "platinum.miss" )
local SwingSound2 = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "platinum.hit" )
local Ora = Sound( "platinum.ora" )
local OraLoop = Sound( "platinum.ora_loop" )
local StopTime = Sound( "weapons/platinum/stop_time.wav" )
local StartTime = Sound( "weapons/platinum/start_time.wav" )
local Deploy = Sound( "platinum.deploy" )
local SDeploy = Sound( "weapons/platinum/deploy.wav" )
local Withdraw = Sound( "weapons/platinum/withdraw.wav" )
local Withdraugh = Sound( "weapons/platinum/augh.wav" )
local StarFinger = Sound( "platinum.star_finger" )
local YareYare = Sound( "platinum.yareyare" )
local Nani = Sound( "platinum.nani" )
local Flick = Sound( "weapons/platinum/flick.wav" )
local Ore = Sound( "weapons/platinum/sabuke.wav" )
local Standoda = Sound( "weapons/platinum/orenostandoda.wav" )
local Grab = Sound( "weapons/platinum/grab.wav" )
local Zoom = Sound( "weapons/platinum/zoom.wav" )
local Break = Sound( "weapons/platinum/break.wav" )
local Huagh = Sound( "weapons/platinum/huagh.wav" )

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

function SWEP:CustomAmmoDisplay()
	
	self.AmmoDisplay = self.AmmoDisplay or {}
	
	self.AmmoDisplay.Draw = true
	
	if self.Primary.ClipSize and self.Primary.ClipSize > 0 then
		self.AmmoDisplay.PrimaryClip = self:Clip1()
	end
	
	return self.AmmoDisplay
	
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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= self.Owner:GetSequenceActivity(self.Owner:LookupSequence( "pose_standing_02" ))
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence( "pose_ducking_01" ))
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence( "gesture_salute" ))
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence( "gesture_salute" ))
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence( "gesture_salute" ))
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence( "gesture_salute" ))
		if IsValid(self) and IsValid(self.Owner) and self.Owner:GetModel() == "models/player/jotaro/jotaro.mdl" then
			self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= ACT_VM_CRAWL
			self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= ACT_VM_CRAWL
			self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= ACT_VM_CRAWL
			self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= ACT_VM_CRAWL
		end
		self.ActivityTranslate[ ACT_MP_JUMP ]						= self.Owner:GetSequenceActivity(self.Owner:LookupSequence( "jump_knife" ))
		self.ActivityTranslate[ ACT_RANGE_ATTACK1 ]					= index + 8
		self.ActivityTranslate[ ACT_MP_SWIM ]						= index + 9
		else
		self.ActivityTranslate = {}
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= index
		self.ActivityTranslate[ ACT_MP_WALK ]						= index + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= index + 2
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= index + 3
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence( "gesture_salute" ))
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence( "gesture_salute" ))
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence( "gesture_salute" ))
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence( "gesture_salute" ))
		if IsValid(self) and IsValid(self.Owner) and self.Owner:GetModel() == "models/player/jotaro/jotaro.mdl" then
			self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= ACT_VM_CRAWL
			self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= ACT_VM_CRAWL
			self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= ACT_VM_CRAWL
			self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= ACT_VM_CRAWL
		end
		self.ActivityTranslate[ ACT_MP_JUMP ]						= index + 7
		self.ActivityTranslate[ ACT_RANGE_ATTACK1 ]					= index + 8
		self.ActivityTranslate[ ACT_MP_SWIM ]						= index + 9
	end
	if ( t == "normal" ) then
		self.ActivityTranslate[ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end
	
	
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Entity", 0, "Stand" )
	self:NetworkVar( "Bool", 0, "AMode" )
	self:NetworkVar( "Float", 1, "TimeStopDelay" )
end

function SWEP:Initialize()
	self.traces = self:FindTraces(128)
	self:DrawShadow(false)
end

if CLIENT then
	net.Receive( "platinum.PlaySound", function()
		if IsValid(LocalPlayer()) then
			LocalPlayer():EmitSound(StopTime) 
		end
	end)
	
	net.Receive( "platinum.PlaySound2", function()
		if IsValid(LocalPlayer()) then
			LocalPlayer():EmitSound(StartTime) 
		end
	end)
	
	
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
			
			if !self:GetAMode() then
				surface.SetMaterial(boxend)
				else
				surface.SetMaterial(boxdis)
			end
			surface.DrawTexturedRect(width - (192 * mult) - 135 * mult, height - (192 * mult) - 120 * mult, 192 * mult, 192 * mult)
			
			if !self:GetAMode() then
				surface.SetMaterial(boxdis)
				else
				surface.SetMaterial(boxend)
			end
			surface.DrawTexturedRect(width - (192 * mult), height - (192 * mult) - 120 * mult, 192 * mult, 192 * mult)
			
			
			draw.TextShadow({
				text = self:Clip1().."/"..self:GetMaxClip1(),
				font = "gStandsFontLarge",
				pos = {width - 160 * mult, height - 120 * mult},
				color = tcolor,
				xalign = TEXT_ALIGN_CENTER
			}, 2 * mult, 250)
			
			draw.TextShadow({
				text = "#gstands.general.punch",
				font = "gStandsFont",
				pos = {width - 295 * mult, height - 295 * mult},
				color = tcolor,
			}, 2 * mult, 250)
			
			draw.TextShadow({
				text = "#gstands.general.ability",
				font = "gStandsFont",
				pos = {width - 165 * mult, height - 295 * mult},
				color = tcolor,
			}, 2 * mult, 250)
			
			surface.SetMaterial(cooldown_box)
			if !IsValid(GetGlobalEntity("Time Stop")) then
				surface.DrawRect(width - (56 * mult) - 32 * mult, height - (56 * mult) - 340 * mult, 40 * mult, math.Clamp(0, 40 * mult, math.Remap(self:GetTimeStopDelay() - CurTime(), 15, 0, 0, 40 * mult)))
				else
				surface.DrawRect(width - (56 * mult) - 32 * mult, height - (56 * mult) - 340 * mult, 40 * mult, math.Clamp(0, 40 * mult, math.Remap(self:GetTimeStopDelay() - CurTime(), 0, GetConVar( "gstands_star_platinum_timestop_length" ):GetFloat(), 0, 40 * mult)))
			end
			surface.DrawTexturedRect(width - (64 * mult) - 32 * mult, height - (64 * mult) - 340 * mult, 64 * mult, 64 * mult)
			draw.TextShadow({
				text = "#gstands.star_platinum.timestop",
				font = "gStandsFont",
				pos = {width - 100 * mult, height - 390 * mult},
				color = tcolor,
				xalign = TEXT_ALIGN_RIGHT
			}, 2 * mult, 250)
		end
	end
	hook.Add( "HUDShouldDraw", "StarPlatinumHud", function(elem)
		if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_star_platinum" and (((elem == "CHudWeaponSelection" ) and LocalPlayer().SPInZoom) or elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
			return false
		end
	end)
	local material = Material( "vgui/hud/gstands_hud/crosshair" )
	function SWEP:DoDrawCrosshair(x,y)
		if IsValid(self.Stand) and IsValid(self.Owner) and IsValid(LocalPlayer()) then
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
	
	function SWEP:DrawWorldModel()
		if IsValid(self.Owner) then
			return false
			else
			self:DrawModel()
		end
	end
	
end
local thirdperson_offset = GetConVar("gstands_thirdperson_offset")
function SWEP:CalcView( ply, pos, ang, fov )
	if ply:GetViewEntity() ~= ply then return end
	if self.gStands_IsThirdPerson and IsValid(self:GetStand()) and self:GetStand().GetInDoDoDo and self:GetStand():GetInDoDoDo() then
		pos = self:GetStand():GetEyePos()
	end
	local convar = thirdperson_offset:GetString()
	local strtab = string.Split(convar, ",")
	local offset = Vector(strtab[1], strtab[2], strtab[3])
	offset:Rotate(ang)
	local dist = ang:Forward() * 100
	if not self.gStands_IsThirdPerson then
		dist = Vector()
	end
	local trace = util.TraceHull( {
		start = pos,
		endpos = pos - dist,
		filter = { ply:GetActiveWeapon(), ply, ply:GetVehicle() },
		mins = Vector( -4, -4, -4 ),
		maxs = Vector( 4, 4, 4 ),
	} )
	if LocalPlayer().SPInZoom and self.GetStand then
		trace = util.TraceHull( {
			start = self:GetStand():GetEyePos(true),
			endpos = self:GetStand():GetEyePos(true) + LocalPlayer():GetAimVector() * 35,
			filter = { ply:GetActiveWeapon(), ply },
			mins = Vector( -15, -15, -15 ),
			maxs = Vector( 15, 15, 15 ),
		} )
		LocalPlayer().SPzoom = LocalPlayer().SPzoom or 75
		fov = math.Clamp(LocalPlayer().SPzoom, 1, 90)
		orth = true
	end

	if ( trace.Hit ) then pos = trace.HitPos else pos = trace.HitPos end
	return pos + offset, ang, fov
end
if SERVER then
	util.AddNetworkString( "platinum.PlaySound" )
	util.AddNetworkString( "platinum.PlaySound2" )
end

function SWEP:AdjustMouseSensitivity()
	if LocalPlayer().SPInZoom then
		return math.Clamp(LocalPlayer().SPzoom, 1, 90)/90
	end
end
function SWEP:FindTraces(numPoints)
		local traces = {}
		for i = 0, numPoints do
			local t = i / (numPoints - 1.0)
			local inclination = math.acos(1 - 2 * t)
			local azimuth = 2 * math.pi * 1.6180339887499 * i
			local x = math.sin(inclination) * math.cos(azimuth)
			local y = math.sin(inclination) * math.sin(azimuth)
			local z = math.cos(inclination)
			traces[i] = Vector(z, y, x)
		end
		return traces
	end
function SWEP:Deploy()
	self:SetHoldType( "stando" )
	self.FlexOverride = false
	
	if IsValid(self) and IsValid(self.Owner) then
		
		if self.Owner:Health() == 100 then
			self.Owner:SetMaxHealth( self.Durability )
			self.Owner:SetHealth( self.Durability )
		end
		self.Owner:SetCanZoom(false)
		
		self:DefineStand()
		
		self:SetAMode( false)
		
		if SERVER then
			if GetConVar( "gstands_deploy_sounds" ):GetBool() then
				self.Owner:EmitSound(Deploy)
				self:EmitStandSound(SDeploy)
			end
		end
		local hooktag = self.Owner:Name()
		hook.Add( "EntityTakeDamage", "SPGrabDrop"..hooktag, function(ent, dmg)
			if IsValid(self) and IsValid(self.Stand) and IsValid(self.Stand.GrabbedPlayer) and ent == self.Owner then
				if self.Stand.GrabbedThresh then
					self.Stand.GrabbedThresh = self.Stand.GrabbedThresh + dmg:GetDamage()
				end
				self.Stand.GrabbedThresh = self.Stand.GrabbedThresh or dmg:GetDamage()
				if self.Stand.GrabbedThresh >= 300 then
					self:SetHoldType( "stando" )
					self.Stand:ResetSequence( "standidle" )
					self:GrabThrow(false)
					self.Stand.GrabbedPlayer = nil
					self.Stand.GrabbedThresh = nil
				end
				else
				hook.Remove( "EntityTakeDamage", "SPGrabDrop"..hooktag)
			end
		end)
	end
	
end

function SWEP:DefineStand()
	if SERVER then
		if IsValid(self.Stand) then
			self.Stand:Remove()
		end
		self:SetStand( ents.Create( "Stand" ))
		self.Stand = self:GetStand()
		if IsValid(self.Stand) then
			self.Stand:SetOwner(self.Owner)
			self.Stand:SetModel(self.StandModel)
			self.Stand.Range = self.Range
			self.Stand.POWER = self.Power
			self.Stand.Speed = 20*self.Speed
			self.Stand:Spawn()
			self.Stand:SetMoveType( MOVETYPE_NOCLIP )
			self.Stand:ResetSequence(self.Stand:LookupSequence( "standdeploy" ))
			self.Stand.AnimSet = {
				"JUMP_FIST", 0,
				"GMOD_BREATH_LAYER", 1,
				"AIMLAYER_CAMERA", 0,
				"IDLE_ALL_02", 0,
				"FIST_BLOCK", 0,
			}
			self.Stand.HeadRotOffset = -75
			end
	end
end

function SWEP:Think()
	self.Stand = self:GetStand()
	if !IsValid(self.Stand) then
		self:DefineStand()
	end
	if CLIENT then
		hook.Add( "StartCommand", "StarPlatinumZoom", function(ply, cmd)
			if IsValid(self) and IsValid(self.Owner) and IsValid(LocalPlayer()) then
				LocalPlayer().SPzoom = LocalPlayer().SPzoom or 75
				if LocalPlayer().SPzoom - math.Clamp(LocalPlayer().SPzoom - cmd:GetMouseWheel(), 1, 90) >= 2 then
					if IsValid(self:GetStand()) then
						self:GetStand():EmitSound(Zoom)
					end
				end
				LocalPlayer().SPzoom = math.Clamp(LocalPlayer().SPzoom - cmd:GetMouseWheel(), 1, 90)
				else
				hook.Remove( "StartCommand", "StarPlatinumZoom" )
			end
		end)
	end
	self.AmmoTimer = self.AmmoTimer or CurTime()
	if CurTime() > self.AmmoTimer and self:Clip1() < 50 then
		self:SetClip1( self:Clip1() + 1 )
		self.AmmoTimer = CurTime() + 5
	end
	if IsValid( self.Stand ) and IsValid( self.Stand.GrabbedPlayer ) then
				self.GrabbedOldMoveType = self.GrabbedOldMoveType or self.Stand.GrabbedPlayer:GetMoveType()
		if self.Stand.GrabbedPlayer:IsPlayer() and self.Stand.GrabbedPlayer:Alive() then
			self.Stand.GrabbedPlayer:SetMoveType(MOVETYPE_NONE)
			local mult = 1
			if self.Stand.GrabbedPlayer:LookupBone( "ValveBiped.Bip01_Head1" ) and self.Stand.GrabbedPlayer:GetClass() != "lovers" then
				mult = 55
			end
			local mins, maxs = self.Stand.GrabbedPlayer:GetCollisionBounds()
				local trhull = util.TraceHull({
				start = self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )) - (self.Owner:GetAimVector() * 3 ) - self.Stand:GetUp() * mult,
				endpos = self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )) - (self.Owner:GetAimVector() * 3 ) - self.Stand:GetUp() * mult,
				mins=mins,
				maxs=maxs,
				collisiongroup=COLLISION_GROUP_WORLD
			})
			if !trhull.HitWorld then
			self.Stand.GrabbedPlayer:SetPos(self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )) - (self.Owner:GetAimVector() * 3 ) - self.Stand:GetUp() * mult)
			end
			elseif !self.Stand.GrabbedPlayer:IsPlayer() then
			self.Stand.GrabbedPlayer:SetMoveType(MOVETYPE_NONE)
			local mult = 1
			if self.Stand.GrabbedPlayer:LookupBone( "ValveBiped.Bip01_Head1" ) and self.Stand.GrabbedPlayer:GetClass() != "lovers" then
				mult = 55
			end
			local mins, maxs = self.Stand.GrabbedPlayer:GetCollisionBounds()
				local trhull = util.TraceHull({
				start = self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )) - (self.Owner:GetAimVector() * 3 ) - self.Stand:GetUp() * mult,
				endpos = self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )) - (self.Owner:GetAimVector() * 3 ) - self.Stand:GetUp() * mult,
				mins=mins,
				maxs=maxs,
				collisiongroup=COLLISION_GROUP_WORLD
			})
			if !trhull.HitWorld then
				self.Stand.GrabbedPlayer:SetPos(self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )) - (self.Owner:GetAimVector() * 3 ) - self.Stand:GetUp() * mult)
			end
		end
	end
	if (IsValid(self.Stand) and IsValid(self.Stand.GrabbedPlayer) and (self.Stand.GrabbedPlayer:IsPlayer() and !self.Stand.GrabbedPlayer:Alive() or !IsValid(self.Stand.GrabbedPlayer))) then
		self:SetHoldType( "stando" )
		self:GrabThrow(false)
		self.Stand.GrabbedPlayer = nil
	end
	if (IsValid(self.Stand) and IsValid(self.Stand.GrabbedPlayer) and !(self.Stand:GetSequence() == self.Stand:LookupSequence( "grab_idle" ) or self.Stand:GetSequence() == self.Stand:LookupSequence( "grab_start" ) or self.Stand:GetSequence() == self.Stand:LookupSequence( "grab_throw" ))) then
		self:GrabThrow(false)
		if self.Stand:GetSequence() == self.Stand:LookupSequence( "Donut" ) then
			self.Owner:EmitSound(Standoda)
			self.SkipOra = true
		end
		self.Stand.GrabbedPlayer = nil
	end
	self.ZoomDelay = self.ZoomDelay or CurTime()
	if !self.Owner:gStandsKeyDown("modifierkey1") and self.Owner:gStandsKeyPressed("tertattack") and CurTime() >= self.ZoomDelay then
		local ply = self.Owner
		if CLIENT then
			ply = LocalPlayer()
		end
		ply.SPInZoom = !ply.SPInZoom
		self.ZoomDelay = CurTime() + 0.5
	end
	
	self.BearingTimer = self.BearingTimer or CurTime()
	if CurTime() >= self.BearingTimer and self.Owner:gStandsKeyDown("modifierkey1") and self.Owner:gStandsKeyPressed("tertattack") then
		self.BearingTimer = CurTime() + 0.1
		self:FireBearing()
	end
	if self.GetStand and self:GetStand().GetInDoDoDo and self:GetStand():GetInDoDoDo() then
		self.Menacing = self.Menacing or CurTime()
		if CurTime() > self.Menacing then
			self.Menacing = CurTime() + 0.5
			local effectdata = EffectData()
			effectdata:SetStart(self.Owner:GetPos())
			effectdata:SetOrigin(self.Owner:GetPos())
			effectdata:SetEntity(self.Owner)
			util.Effect( "menacing", effectdata)
		end
	end
	if SERVER then
		if GetConVar( "gstands_time_stop" ):GetBool() and IsValid(GetGlobalEntity( "Time Stop" )) and self.Owner:IsOnGround() then
			self.Owner:SetMoveType( MOVETYPE_WALK )
			elseif GetConVar( "gstands_time_stop" ):GetBool() and IsValid(GetGlobalEntity( "Time Stop" )) then
			self.Owner:SetMoveType( MOVETYPE_FLY)
		end
		if self.LastTSValue != GetConVar( "gstands_time_stop" ):GetBool() then
			if !GetConVar( "gstands_time_stop" ):GetBool() then
				self.Owner:SetMoveType( MOVETYPE_WALK )
			end
		end
		self.LastTSValue = GetConVar( "gstands_time_stop" ):GetBool()
	end
	if SERVER and self.Succ then
		self.Stand:EmitStandSound( "succ_loop" ) 
		self.Stand.HeadRotOffset = 0
		for k,v in pairs(ents.FindInCone(self.Stand:GetEyePos(true), self.Stand:GetForward(), 1500, 0.55)) do
			if SERVER and IsValid(v) and v.GetActiveWeapon and IsValid(v:GetActiveWeapon()) and v:GetActiveWeapon():GetClass() == "gstands_justice" then
				
				local dmginfo = DamageInfo()
				local attacker = self.Owner
				dmginfo:SetAttacker( attacker )						
				dmginfo:SetInflictor( self )
				dmginfo:SetDamage( 2 )
				
				v:TakeDamageInfo( dmginfo )
			end
		end
		for k,v in pairs(ents.FindInCone(self.Stand:GetEyePos(true), self.Owner:GetForward(), 350, 0.55)) do
			if SERVER and IsValid(v) and (v:IsPlayer() or v:IsNPC()) then
				local tr = util.TraceLine( {
					start = self.Stand:GetEyePos(true),
					endpos = v:WorldSpaceCenter(),
					filter = {self.Owner, self.Stand},
					mask = MASK_SHOT_HULL,
					collisiongroup = COLLISION_GROUP_NONE
				} )
				self.Stand:SetFlexWeight(1, 0)
				self.Stand:SetFlexWeight(0, Lerp(0.5, math.Rand(0.3,0.7), 0.5))
				
				if tr.Entity == v and (v:IsPlayer() or v:IsNPC()) then
					local mult = 25
					if !v:OnGround() then
						mult = 45
					end
					v:SetVelocity(-v:GetVelocity())
					v:SetVelocity((self.Stand:GetEyePos(true) - v:GetPos()):GetNormalized() * mult)
					if IsValid(v:GetPhysicsObject()) then
						v:GetPhysicsObject():SetVelocity((self.Stand:GetEyePos(true) - v:GetPos()):GetNormalized() * 25)
					end
				end
				
			end
			
		end
	end
	if SERVER and IsValid(self.Stand) and self.Stand:GetSequence() != self.Stand:LookupSequence( "Succ" ) then
		self.Succ = false
		self.Stand.HeadRotOffset = -75
		self.Stand:StopSound( "succ_loop" )
	end
	if SERVER and IsValid(self.Stand) and self.Stand:GetSequence() == self.Stand:LookupSequence( "starfinger" ) then
		self:StarFingerDMG()
	end
	if SERVER and !self.FlexOverride then
		self.Stand:SetFlexWeight(0, Lerp(0.05, self.Stand:GetFlexWeight(0), 0))
		self.Stand:SetFlexWeight(1, Lerp(0.05, self.Stand:GetFlexWeight(1), 0))
		self.Stand:SetFlexWeight(2, Lerp(0.05, self.Stand:GetFlexWeight(2), 0))
	end
	if SERVER and not self:GetAMode() then
		if self.Owner:KeyPressed(IN_ATTACK) and !self:GetAMode() and self.Owner:GetMoveType( ) != MOVETYPE_NONE then
			self.Owner:EmitStandSound( "platinum.ora_loop" )
		end
		if self.Owner:KeyDown(IN_ATTACK) and !self:GetAMode() and self.Owner:GetMoveType( ) != MOVETYPE_NONE then
			self.Stand:SetFlexWeight(0, math.abs(math.sin((CurTime()*20))))
			self.Stand.HeadRotOffset = -5
		end
		if self.Owner:KeyReleased(IN_ATTACK) and !self:GetAMode() or self.Owner:IsFlagSet(FL_FROZEN) then
			self.Owner:StopSound( "platinum.ora_loop" )
			self.Stand:EmitStandSound(Ora)
			self:SetHoldType( "stando" )
			self.Stand:SetFlexWeight(0,1.5)
			self.Stand.HeadRotOffset = -75
		end
		if !self.Owner:KeyDown(IN_ATTACK) and !self:GetAMode() and self.Stand:GetSequence() == self.Stand:LookupSequence( "Barrage" ) then
			self.Owner:StopSound( "platinum.ora_loop" )
			self:SetHoldType( "stando" )
		end
		if (self:GetAMode() and timer.Exists( "oraora"..self.Owner:GetName())) or (timer.Exists( "oraora"..self.Owner:GetName()) and self.Owner:IsFlagSet(FL_FROZEN)) then
			self.Owner:StopSound( "platinum.ora_loop" )
			self:SetHoldType( "stando" )
			self.Stand:SetFlexWeight(0,1.5)
		end
		
		if self.Owner:IsFlagSet(FL_FROZEN) then
			self.Owner:StopSound( "platinum.ora_loop" )
			self:SetHoldType( "stando" )
		end
		
	end
	self.TauntTimer = self.TauntTimer or CurTime()
	if self.Owner:gStandsKeyDown("taunt") and CurTime() >= self.TauntTimer then
		local delay = 1
		if self.Owner:GetModel() == "models/player/jotaro/jotaro.mdl" then
			delay = 0
		end
		timer.Simple(delay, function() if SERVER then self.Owner:EmitSound(YareYare) end end)
		if self.Owner:GetModel() != "models/player/jotaro/jotaro.mdl" then
			timer.Simple(2.4, function() 
				self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Hand" ), Angle(0,0,0)) 
				self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger2" ), Angle(0,0,0)) 
				self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger21" ), Angle(0,0,0)) 
				self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger22" ), Angle(0,0,0)) 
				if self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger3" ) and
					self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger31" ) and
					self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger32" ) and
					self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger4" ) and
					self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger41" ) and
					self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger42" )
					then
					self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger3" ), Angle(0,0,0)) 
					self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger31" ), Angle(0,0,0)) 
					self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger32" ), Angle(0,0,0)) 
					self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger4" ), Angle(0,0,0)) 
					self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger41" ), Angle(0,0,0)) 
					self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger42" ), Angle(0,0,0)) 
				end
			end)
			self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Hand" ), Angle(0,-25,0)) 
			self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger2" ), Angle(0,-75,0))
			self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger21" ), Angle(0,-75,0))
			self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger22" ), Angle(0,-75,0))
			if self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger3" ) and
				self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger31" ) and
				self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger32" ) and
				self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger4" ) and
				self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger41" ) and
				self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger42" )
				then
				self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger3" ), Angle(0,-75,0))
				self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger31" ), Angle(0,-75,0))
				self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger32" ), Angle(0,-75,0))
				self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger4" ), Angle(0,-75,0))
				self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger41" ), Angle(0,-75,0))
				self.Owner:ManipulateBoneAngles(self.Owner:LookupBone( "ValveBiped.Bip01_L_Finger42" ), Angle(0,-75,0))
			end
		end
		self.Owner:SetAnimation(PLAYER_RELOAD)
		self.TauntTimer = CurTime() + 2.4
	end
	self.Delay = self.Delay or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("modeswap") and CurTime() > self.Delay then
		self.Delay = CurTime() + 1
		self:SetAMode( !self:GetAMode())
		if SERVER then
			if(self:GetAMode()) then 
				self.Owner:ChatPrint( "#gstands.general.abilitym" )
				self:SetNextPrimaryFire(CurTime())
				self:SetNextSecondaryFire( CurTime() )
				else
				self.Owner:ChatPrint( "#gstands.general.punchm" ) 
				self:SetNextPrimaryFire( CurTime() + 0.02 )
				self:SetNextSecondaryFire( CurTime() + 0.1 )
			end
		end
	end
	self.StandBlockTimer = self.StandBlockTimer or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("block") and CurTime() > self.StandBlockTimer then
		self.Stand.HeadRotOffset = -5
		self:SetHoldType("pistol")
		self.Stand:ResetSequence(self.Stand:LookupSequence( "standblock" ))
		self.Stand:SetCycle(0)
		self.Stand:EmitStandSound(Huagh)
		timer.Simple(self.Stand:SequenceDuration("standblock"), function() self:SetHoldType("stando") self.Stand.HeadRotOffset = -75 end)
		self.StandBlockTimer = CurTime() + self.Stand:SequenceDuration("standblock") + 0.5
	end
end

function SWEP:StopTime()
	if !GetConVar("gstands_can_time_stop"):GetBool() then
		return true
	end
	if IsValid(self.Stand) then
		if GetConVar( "gstands_time_stop" ):GetInt() == 0 then
			if SERVER then
				GetConVar( "gstands_time_stop" ):SetInt(1)
			end
			timer.Remove( "sutahprachina"..self.Owner:GetName())
			if GetConVar( "gstands_star_platinum_limit" ):GetInt() == 1 then
				timer.Create( "stopMax"..self.Owner:GetName(), GetConVar( "gstands_star_platinum_timestop_length" ):GetFloat(), 1,
					function() 
						if GetConVar( "gstands_star_platinum_limit" ):GetInt() == 1 then
							self:StartTime()
							self.Owner.WasFrozen = true
						end
					end)
			end
			self.Owner.WasFrozen = true
			self:SetNextPrimaryFire(CurTime()+1)
			self:SetNextSecondaryFire(CurTime()+1)
			if SERVER then
				local zawa = EffectData()
				zawa:SetEntity(self.Stand)
				zawa:SetOrigin(self.Stand:GetBonePosition(6))
				zawa:SetMagnitude(1)
				util.Effect( "sptw", zawa, true, true)
			end
			MsgC(Color(255,0,0), self.Owner:GetName().." is trying to stop time with Star Platinum!\n" )
			
			if !IsValid(GetGlobalEntity( "Time Stop" )) then
				SetGlobalEntity( "Time Stop", ents.Create( "gstands_tscontroller" ))
				self.TimeStopperController = GetGlobalEntity( "Time Stop" )
				self.TimeStopperController.Owner = self.Owner
			end
			self.TimeStopperController = GetGlobalEntity( "Time Stop" )
			self.TimeStopperController:Spawn()
			table.insert(self.TimeStopperController.StoppedUsers, self.Owner)
			self.TimeStopperController:Activate()
			self:SetTimeStopDelay(CurTime() + GetConVar( "gstands_star_platinum_timestop_length" ):GetFloat())
		end
	end
end

function SWEP:StartTime()
	self.Owner:StopSound( "platinum.ora_loop" )
	if IsValid(GetGlobalEntity("Time Stop")) and #GetGlobalEntity( "Time Stop" ).StoppedUsers > 1 and GetConVar( "gstands_star_platinum_limit" ):GetBool() then
		table.RemoveByValue(GetGlobalEntity( "Time Stop" ).StoppedUsers, self.Owner)
		self.Owner:EmitSound(Nani)
		self:SetNextSecondaryFire( CurTime() + 4 )
		self.TSExitBuffer = CurTime() + 1
		elseif !self.Owner:IsFlagSet(FL_FROZEN) then
		self:SetNextSecondaryFire( CurTime() + 4 )
		self:SetTimeStopDelay(CurTime() + 15)
		if SERVER then
			GetConVar( "gstands_time_stop" ):SetInt(0)
		end
		self:SetNextPrimaryFire(CurTime())
		self.Owner.WasFrozen = false
		if SERVER and IsValid(self.Stand) then
			local zawa = EffectData()
			zawa:SetEntity(self.Stand)
			zawa:SetOrigin(self.Stand:GetBonePosition(6))
			zawa:SetMagnitude(3)
			util.Effect( "sptw", zawa, true, true)	  
		end
		
		if SERVER then
			GetConVar( "gstands_time_stop" ):SetInt(0)
		end
		
		if SERVER and self.Stand and IsValid(self.Stand) then
			local zawa = EffectData()
			zawa:SetEntity(self.Stand)
			zawa:SetOrigin(self.Stand:GetBonePosition(6))
			zawa:SetMagnitude(3)
			util.Effect( "tw", zawa)	  
		end
		
		if IsValid(GetGlobalEntity( "Time Stop" )) then
			GetGlobalEntity( "Time Stop" ):Remove()
		end
		if(SERVER) then
			net.Start( "platinum.PlaySound2" )
			net.Broadcast()
			
			for k,v in ipairs(player.GetAll()) do
				if self.PlayerMoveType != nil then
					if self.PlayerMoveType[k] != nil then
						v:SetMoveType( self.PlayerMoveType[k] )
					end
				end
				if v == self.Owner then
					v:SetDSP(0, false)
				end
				if v != self.Owner then
					v:UnLock()
					if SERVER then
						v:SetDSP(0, false)
						timer.Remove( "stopPlatinum1" )
						timer.Remove( "stopPlatinum2" )
					end
				end
			end
		end 
		if timer.Exists( "stopMax"..self.Owner:GetName()) then
			timer.Remove( "stopMax"..self.Owner:GetName())
		end
	end
end



function SWEP:PrimaryAttack()
	if SERVER and (self:GetAMode()) then
		if !self.Owner:gStandsKeyDown("modifierkey1") then
			self:StarFinger()
			self:SetNextPrimaryFire( CurTime() + self.Stand:SequenceDuration() + 0.5 )
			else
			if SERVER then
				self.Succ = !self.Succ
			end
			
			if self.Succ then
				self.Stand:EmitSound( "succ_loop" ) 
				self.Stand.HeadRotOffset = 0
				self:SetHoldType( "pistol" )
				self.Stand:ResetSequence(self.Stand:LookupSequence( "succ" ))
				self:SetNextPrimaryFire( CurTime() + 1 )
				
				elseif SERVER then
				self:SetHoldType( "stando" )
				self:SetNextPrimaryFire( CurTime() + 1 )
				
			end
		end
		
		else
		self:SetHoldType( "pistol" )
		if self.Stand:GetSequence() != self.Stand:LookupSequence( "barrage" ) then
			
			self.Stand:ResetSequence(self.Stand:LookupSequence( "barrage" ))
			self.Stand:SetCycle(0)
		end
		self:Barrage()
		
		self:SetNextPrimaryFire( CurTime() + 0.02 )
		self:SetNextSecondaryFire( CurTime() + 0.1 )
	end
end


function SWEP:SecondaryAttack()
	self.TimeStopDelay = self.TimeStopDelay or CurTime()
	if( self:GetAMode() ) and CurTime() > self:GetTimeStopDelay() then
		self:SetNextSecondaryFire( CurTime() + 3 )
		if !GetConVar( "gstands_time_stop" ):GetBool() and !IsValid(GetGlobalEntity( "Time Stop" )) and self.Owner:KeyPressed(IN_ATTACK2) then
			if SERVER and self.Stand:GetSequence() != self.Stand:LookupSequence( "timestop" ) then
				self:SetHoldType( "pistol" )
				self.Stand:SetPlaybackRate( 1 )
				self.Stand:SetCycle( 0 )
				self.Stand:ResetSequence( self.Stand:LookupSequence( "timestop" ) )
				timer.Simple(4, function() self:SetHoldType( "stando" ) self.Stand:SetPlaybackRate( 1 ) self.Stand:ResetSequence( "standidle" ) end)
				timer.Create( "sutahprachina"..self.Owner:GetName(), 2.2, 1, function() 
					self:StopTime()
				end)
			end
			if SERVER then
				net.Start( "platinum.PlaySound" )
				net.Broadcast()
			end
			self.TSReleaseDelay = self.TSReleaseDelay or CurTime()
			elseif SERVER and IsValid(GetGlobalEntity( "Time Stop" )) and ((GetConVar( "gstands_time_stop" ):GetInt() == 1 and CurTime() >= self.TSReleaseDelay) or (!GetConVar( "gstands_star_platinum_limit" ):GetBool() and GetGlobalEntity( "Time Stop" ).Owner and CurTime() >= self.TSReleaseDelay)) then
			self:StartTime()
			
		end
		else
		if !self.Owner:gStandsKeyDown("modifierkey1") then
			self:SetHoldType( "pistol" )
			
			if SERVER and self.Stand:GetSequence() != self.Stand:LookupSequence( "donut" ) then
				self.Stand:EmitStandSound( SwingSound )
				self.Stand:EmitStandSound( SwingSound2 )
				self.Stand:ResetSequence( self.Stand:LookupSequence( "donut" ) ) 
				self.Stand:SetCycle( 0 )
				self.Stand:SetPlaybackRate( 1 )
			end
			
			if SERVER and !self.SkipOra then
				self.Stand:SetFlexWeight(0,1.5)
				self.Owner:EmitStandSound( Ora )
			end
			self.SkipOra = false
			timer.Simple(self.Stand:SequenceDuration()/3, function()
				if IsValid(self) then
					self:DonutPunch()
				end
			end)
			timer.Simple(self.Stand:SequenceDuration(), function()
				if IsValid(self) then
					self:SetHoldType( "stando" )
				end
			end)
			
			self:SetNextSecondaryFire( CurTime() + 3 )
			else
			if !IsValid(self.Stand.GrabbedPlayer) then
				if SERVER then
				end
				self:SetHoldType( "pistol" )
				
				if SERVER and self.Stand:GetSequence() != self.Stand:LookupSequence( "grab_start" ) then
					
					self.Stand:ResetSequence( self.Stand:LookupSequence( "grab_start" ) ) 
					self.Stand:SetCycle( 0 )
					self.Stand:SetPlaybackRate( 1 )
				end
				local NextAnim = false
				if SERVER then
					self.Stand:EmitStandSound( SwingSound )
					self.Stand:EmitStandSound( SwingSound2 )
					timer.Simple(self.Stand:SequenceDuration()/3, function()
						self.Owner:EmitSound( Ore )
						NextAnim = self:Grab()
					end)
					timer.Simple(self.Stand:SequenceDuration(), function()
						if NextAnim and IsValid(self.Stand) then
							self.Stand:ResetSequence( self.Stand:LookupSequence( "grab_idle" ) ) 
							self.Stand:SetCycle( 0 )
							self.Stand:SetPlaybackRate( 1 )
							else
							self:SetHoldType( "stando" )
						end
					end)
				end
				
				self:SetNextSecondaryFire( CurTime() + 3 )
				else
				self:SetHoldType( "pistol" )
				
				if SERVER and self.Stand:GetSequence() != self.Stand:LookupSequence( "grab_throw" ) then
					
					self.Stand:ResetSequence( self.Stand:LookupSequence( "grab_throw" ) ) 
					self.Stand:SetCycle( 0 )
					self.Stand:SetPlaybackRate( 1 )
				end
				if SERVER then
					timer.Simple(self.Stand:SequenceDuration()/5, function()
						self.Owner:EmitStandSound( Ora )
						self:GrabThrow(true)
					end)
					timer.Simple(self.Stand:SequenceDuration(), function()
						self:SetHoldType( "stando" )
					end)
				end
			end
			self:SetNextSecondaryFire( CurTime() + 1 )
			
		end
	end
end

function SWEP:FireBearing()
	if IsFirstTimePredicted() and self:Clip1() > 0 then
		if (SERVER) then
			
			self:SetHoldType( "pistol" )
			
			if SERVER then
				self.Stand:EmitStandSound(SwingSound2)
				self.Stand:EmitStandSound(SwingSound)
				
				self.Stand:ResetSequence( self.Stand:LookupSequence( "flick" ) ) 
				self.Stand:SetCycle( 0 )
				self.Stand:SetPlaybackRate( 1 )
			end
			if SERVER and self:Clip1() > 0 then
				self:TakePrimaryAmmo(1)
				timer.Simple(self.Stand:SequenceDuration(self.Stand:LookupSequence( "flick" ))/2, function()
					local bearing = ents.Create( "bearing" )
					if IsValid(bearing) and IsValid(self.Stand) then
						self.Stand:EmitStandSound(Flick)
						local pos = self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )) 
						if self.Owner.SPInZoom then
							pos = self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_Head1" )) 
						end
						bearing:SetPos(pos)
						bearing:SetModel("models/starp/bearing.mdl")
						bearing:SetMaterial( "models/shiny" )
						bearing:SetOwner(self.Owner)
						bearing:SetPhysicsAttacker(self.Owner)
						bearing:Spawn()
						bearing:Activate()
						local phys = bearing:GetPhysicsObject()
						local vec = self.Owner:GetAimVector()
						if self.Stand:GetBlockCap() and IsValid(self.Stand:GetAITarget()) then
							vec = (self.Stand.AITarget:WorldSpaceCenter() - bearing:GetPos()):GetNormalized()
						end
						phys:SetVelocity(vec * 5200)
						
					end
				end)
				timer.Simple(self.Stand:SequenceDuration(self.Stand:LookupSequence( "flick" )), function()
					if IsValid(self) then
						self:SetHoldType( "stando" )
					end
				end)
			end
		end
	end
end

function SWEP:Barrage()
	
	local bone = "ValveBiped.Bip01_R_Hand"
	if math.random(1,2) == 1 then
		bone = "ValveBiped.Bip01_L_Hand"
	end
	self.Owner:LagCompensation( true ) 

	local tr = util.TraceHull( {
		start = self.Stand:GetEyePos(true),
		endpos = self.Stand:GetBonePosition(self.Stand:LookupBone(bone)) + self.Stand:GetForward() * 35,
		filter = {self.Owner, self.Stand},
		mins = Vector( -15, -15, -15 ), 
		maxs = Vector( 15, 15, 15 ),
		mask = MASK_SHOT_HULL
		
	} )
	if SERVER and math.random(0, 2) == 0 then
		self.Stand:EmitStandSound(SwingSound2)
	end
	if SERVER and math.random(0, 5) == 0 and tr.Hit then
		self.Stand:EmitStandSound(SwingSound)
		
	end
	if SERVER and math.random(0, 1) == 0 and tr.Hit then
		self.Stand:EmitSound( HitSound )
	end
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
	end
	if SERVER and !IsValid(GetGlobalEntity( "Time Stop" )) and IsValid(tr.Entity) and !tr.Entity:IsNPC() and !tr.Entity:IsPlayer() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue( "explosion", "2" ) tr.Entity:SetKeyValue( "gibdir", tostring(self.Stand:GetAngles())) tr.Entity:Fire( "Break" ) tr.Entity:EmitSound(Break) end
	if SERVER and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetClass() == "prop_door_rotating" then tr.Entity:Fire( "Unlock" ) tr.Entity:Fire( "SetSpeed", 1000) tr.Entity:Fire( "Open" ) tr.Entity:EmitSound(Break) end
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0) ) then
		
		local dmginfo = DamageInfo()
		local attacker = self.Owner
		dmginfo:SetAttacker( attacker )
		dmginfo:SetDamageForce(LerpVector(0.5, self.Stand:GetForward(), VectorRand()))
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 7 * self.Power )
				
		tr.Entity:TakeDamageInfo( dmginfo )
		
		if tr.Entity:GetClass() != "stand" then
			local vel = tr.Entity:GetAbsVelocity()
			tr.Entity:TakeDamageInfo( dmginfo )
			vel = vel + ( tr.Entity:GetVelocity() - vel)
			tr.Entity:SetVelocity(-vel/2)
			else
			local vel = tr.Entity.Owner:GetAbsVelocity()
			tr.Entity:TakeDamageInfo( dmginfo )
			vel = vel + ( tr.Entity.Owner:GetVelocity() - vel)
			vel.z = 0
			tr.Entity.Owner:SetVelocity(-vel/2)
		end
		if self.Owner:gStandsKeyDown("modifierkey1") and tr.Entity:GetSequence() != tr.Entity:LookupSequence("barrage") and !self.Owner.IsKnockedOut then
			tr.Entity:SetVelocity(dmginfo:GetDamageForce() * -75)
			tr.Entity:SetVelocity(self.Stand:GetAngles():Forward() * 750)
		end
	end
	if tr.Hit and !((tr.Entity:IsPlayer() or tr.Entity:IsNPC())) then
		self.Stand:EmitSound( GetStandImpactSfx(tr.MatType) )
		local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(-self.Stand:GetForward())
		effectdata:SetFlags(1)
		effectdata:SetMagnitude(1)
		
		if tr.Entity:IsStand() then
			effectdata:SetFlags(2)
		end
		util.Effect( "gstands_stand_impact", effectdata)
	end
	
	if ( SERVER && tr.Entity:IsValid( ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Stand:GetForward() * 15 * phys:GetMass(), tr.HitPos )
			local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			effectdata:SetFlags(1)
			
			if tr.Entity:IsStand() then
				effectdata:SetFlags(2)
			end
			util.Effect( "gstands_stand_impact", effectdata)
			
		end
	end
	
	if tr.Entity:IsPlayer() then
		tr.Entity:ViewPunch( Angle( math.random( -3, 3 ), math.random( -3, 3 ), math.random( -3, 3 ) ) )
	end
	
	
	if SERVER and ( tr.HitWorld ) then
		local mult = 128
		if !self.Owner:OnGround() then
			self.Owner:SetVelocity( self.Owner:GetAimVector() * -mult + Vector( 0, 0, mult ) )
		end
	end
	
	self.Owner:LagCompensation( false )
	
end
function SWEP:DonutPunch()
	if IsValid(self.Stand) then
		self.Owner:LagCompensation( true )
		local tr = util.TraceHull( {
			start = self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )),
			endpos = self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )) + self.Owner:GetAimVector() * 55,
			filter = { self.Owner, self.Stand },
			mins = Vector( -25, -25, -25 ), 
			maxs = Vector( 25, 25, 25 ),
			ignoreworld = false,
			mask = MASK_SHOT_HULL
			
		} )
		
		if ( SERVER and tr.Hit ) then
			self.Stand:EmitSound( HitSound )
		end
		
		local trD = util.TraceLine( {
			start = self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )),
			endpos = self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )) + self.Owner:GetAimVector() * (self.HitDistance + 25),
			filter = {self.Owner, self.Stand},
			mask = MASK_SHOT_HULL
		} )
		
		if SERVER and trD.HitWorld then
			util.Decal( "Impact.Concrete", self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )), self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )) + self.Owner:GetAimVector() * (self.HitDistance + 25), {self.Stand, self.Owner})
			util.Decal( "Impact.Sand", self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )), self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )) + self.Owner:GetAimVector() * (self.HitDistance + 25), {self.Stand, self.Owner})
			util.Decal( "FadingScorch", self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )), self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )) + self.Owner:GetAimVector() * (self.HitDistance + 25), {self.Stand, self.Owner})
		end
		
		if SERVER then
			self.Stand:SetName( "DoorOpeningBoy" )
			if SERVER and !IsValid(GetGlobalEntity( "Time Stop" )) and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue( "explosion", "2" ) tr.Entity:SetKeyValue( "gibdir", tostring(self.Stand:GetAngles())) tr.Entity:Fire( "Break" ) tr.Entity:EmitSound(Break) end
			if SERVER and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetClass() == "prop_door_rotating" then tr.Entity:Fire( "Unlock" ) tr.Entity:Fire( "SetSpeed", 1000) tr.Entity:Use(self.Owner, self.Stand, USE_TOGGLE, 1) tr.Entity:EmitSound(Break) tr.Entity:Fire( "Setself.Speed", 200) end
			self.Stand:SetName( "" )
		end
		if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0) ) then
			
			local dmginfo = DamageInfo()
			dmginfo:SetDamageForce(self.Stand:GetAngles():Forward())
			
			local attacker = self.Owner
			dmginfo:SetAttacker( attacker )
			
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( 100 * self.Power )
			
				dmginfo:SetDamageType( DMG_CLUB )
				dmginfo:SetDamagePosition(tr.HitPos)
			
			tr.Entity:TakeDamageInfo( dmginfo )
			if 100 * self.Power >= tr.Entity:Health() then
				self.KillstreakTimer = CurTime() + 5
			end
			tr.Entity:SetVelocity(self.Stand:GetAngles():Forward() * 1550)
		end
		if tr.Hit and !((tr.Entity:IsPlayer() or tr.Entity:IsNPC())) then
			
			if tr.Entity:GetModel() == "models/props_c17/gate_door01a.mdl" then
				tr.Entity:GetPhysicsObject():EnableMotion(true)
				tr.Entity:Remove()
			end
			self.Stand:EmitSound( GetStandImpactSfx(tr.MatType) )
			local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(-self.Owner:GetAimVector())
			effectdata:SetFlags(1)
			
			if tr.Entity:IsStand() then
				effectdata:SetFlags(2)
			end
			util.Effect( "gstands_stand_impact", effectdata)
		end
		if ( SERVER && tr.Entity:IsValid( ) ) then
			local phys = tr.Entity:GetPhysicsObject()
			if ( IsValid( phys ) ) then
				phys:ApplyForceOffset( self.Owner:GetAimVector() * 15 * phys:GetMass(), tr.HitPos )
				local effectdata = EffectData()
				effectdata:SetOrigin(tr.HitPos)
				effectdata:SetNormal(tr.HitNormal)
				effectdata:SetFlags(1)
				
				if tr.Entity:IsStand() then
					effectdata:SetFlags(2)
				end
				util.Effect( "gstands_stand_impact", effectdata)
			end
		end
		
		if tr.Entity:IsPlayer() then
			tr.Entity:ViewPunch( Angle( math.random( -3, 3 ), math.random( -3, 3 ), math.random( -3, 3 ) ) )
		end
		
		if ( tr.HitWorld ) then
			if !self.Owner:OnGround() then
				self.Owner:SetVelocity( self.Owner:GetAimVector() * -(170.66 * self.Power) + Vector( 0, 0, (170.66 * self.Power) ) )
			end
		end
		
		self.Owner:LagCompensation( false )
		
	end
end

function SWEP:Grab()
	if IsValid(self.Stand) then
		self.Owner:LagCompensation( true )
		debugoverlay.SweptBox(self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )),
		self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )) + self.Owner:GetAimVector() * 55,
		Vector(-25,-25,-25), Vector(25,25,25), Angle())
		local tr = util.TraceHull( {
			start = self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )),
			endpos = self.Stand:GetBonePosition(self.Stand:LookupBone( "ValveBiped.Bip01_R_Hand" )) + self.Owner:GetAimVector() * 55,
			filter = { self.Owner, self.Stand },
			mins = Vector( -25, -25, -25 ), 
			maxs = Vector( 25, 25, 25 ),
			ignoreworld = false,
			mask = MASK_SHOT_HULL
			
		} )
		if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		end
		if ( SERVER && IsValid( tr.Entity ) and !tr.Entity.IsGrabbed and ( tr.Entity:IsPlayer() or tr.Entity:IsNPC()) ) then
			
			self.Stand:EmitSound( "physics/flesh/flesh_impact_bullet"..math.random(1,5)..".wav" )
			self.Stand.GrabbedPlayer = tr.Entity
			self.Stand.GrabbedPlayer.IsGrabbed = true
			self.Stand.GrabbedPlayer:EmitSound( Grab )
			self.Stand.LastGrabbedMovetype = tr.Entity:GetMoveType()
		end
		if ( SERVER && IsValid( tr.Entity ) and !tr.Entity.IsGrabbed and !(tr.Entity.Owner and tr.Entity.Owner.IsGrabbed) and ( tr.Entity:IsStand() ) ) then
			if tr.Entity:GetPos():DistToSqr(tr.Entity.Owner:GetPos()) < 150000 then
				self.Stand:EmitSound( "physics/flesh/flesh_impact_bullet"..math.random(1,5)..".wav" )
				self.Stand.GrabbedPlayer = tr.Entity.Owner
				if tr.Entity:GetClass() == "lovers" then
					self.Stand.GrabbedPlayer = tr.Entity
				end
				self.Stand.GrabbedPlayer.IsGrabbed = true
				
				self.Stand.GrabbedPlayer:EmitSound( Grab )
				if tr.Entity.Owner:InVehicle() then
					tr.Entity.Owner:ExitVehicle()
				end
				self.Stand.LastGrabbedMovetype = tr.Entity.Owner:GetMoveType()
			end
		end
		
		if tr.Entity:IsPlayer() then
			tr.Entity:ViewPunch( Angle( math.random( -3, 3 ), math.random( -3, 3 ), math.random( -3, 3 ) ) )
		end
		
		self.Owner:LagCompensation( false )
		if ( SERVER && IsValid( self.Stand.GrabbedPlayer ) ) then
			return true
		end
	end
end

function SWEP:GetClosestPoint(tab, vec)
	local closestpoint
	local closestdist
	for k, v in pairs(tab) do
			local dist = vec:DistToSqr(v)
			if not closestdist then
				closestdist = dist
				closestpoint = v
			end
			if dist < closestdist then
				closestdist = dist
				closestpoint = v
			end
	end
    if closestpoint then
		return closestpoint
	end
end

function SWEP:GrabThrow(throw)
	if IsValid(self.Stand) then
		local movetype = self.GrabbedOldMoveType or MOVETYPE_WALK
		
		self.Stand.GrabbedPlayer:SetMoveType(movetype)
		if self.Stand.GrabbedPlayer:IsNPC() and !IsValid(self.Stand.GrabbedPlayer:GetPhysicsObject()) then
			self.Stand.GrabbedPlayer:DropToFloor()
		end
		local mins, maxs = self.Stand.GrabbedPlayer:GetCollisionBounds()
		local trhull = util.TraceHull({
			start = self.Stand.GrabbedPlayer:GetPos(),
			endpos = self.Stand.GrabbedPlayer:GetPos(),
			mins=mins,
			maxs=maxs,
			collisiongroup=COLLISION_GROUP_WORLD
			})
			if trhull.HitWorld then
				-- for k,v in pairs(self.traces) do
					-- local norma = v
					-- local trOut = util.TraceLine( {
						-- start = self.Stand.GrabbedPlayer:GetPos(),
						-- endpos = self.Stand.GrabbedPlayer:GetPos() + norma * 500,
						-- filter = { self, self.Owner},
						-- mask=0
					-- } )
					-- if trOut.FractionLeftSolid > 0 then
						-- self.Stand.GrabbedPlayer:SetPos(self.Stand.GrabbedPlayer:GetPos() + v * 500)
					-- end
				-- end
				-- local norm = (self.Stand.GrabbedPlayer:WorldSpaceCenter() - trhull.HitPos):GetNormalized()
				-- for i=1, 55 do
					-- if bit.band(util.PointContents(self.Stand.GrabbedPlayer:GetPos() + norm * 5 * i), CONTENTS_SOLID) != CONTENTS_SOLID then
					-- self.Stand.GrabbedPlayer:SetPos(self.Stand.GrabbedPlayer:GetPos() + norm * 5 * i)
					-- self.Stand.GrabbedPlayer:DropToFloor()
					-- break
					-- end
				-- end
				-- trhull = util.TraceHull({
					-- start = self.Stand.GrabbedPlayer:GetPos(),
					-- endpos = self.Stand.GrabbedPlayer:GetPos(),
					-- mins=mins,
					-- maxs=maxs,
					-- collisiongroup=COLLISION_GROUP_WORLD
				-- })
				local positions = {}
				table.insert(self.traces,0,-self.Owner:GetAimVector())
				for k,v in pairs(self.traces) do
					for i=1, 55 do
						local norma = v
						if bit.band(util.PointContents(self.Stand.GrabbedPlayer:GetPos() + norma * 35 * i), CONTENTS_EMPTY) == CONTENTS_EMPTY then
						--table.insert(positions, self.Stand.GrabbedPlayer:GetPos() + norma * 35 * i)
						self.Stand.GrabbedPlayer:SetPos(self.Stand.GrabbedPlayer:GetPos() + norma * 35 * i)
						break
						end
						if bit.band(util.PointContents(self.Stand.GrabbedPlayer:GetPos()), CONTENTS_EMPTY) == CONTENTS_EMPTY then
						break
						end
					end
				end
				table.remove(self.traces, 0)
				--local endpos = self:GetClosestPoint(positions, self.Stand.GrabbedPlayer:GetPos())
				--self.Stand.GrabbedPlayer:SetPos(endpos)
									--self.Stand.GrabbedPlayer:DropToFloor()

			end
		self.Stand.GrabbedPlayer.IsGrabbed = false
		local mult = 1050
		if throw then
			self.Stand.GrabbedPlayer:SetVelocity(self.Owner:GetAimVector() * 1050)
			else
			self.Stand.GrabbedPlayer:SetVelocity(self.Stand.GrabbedPlayer:GetUp() * 250)
		end
		if IsValid(self.Stand.GrabbedPlayer:GetPhysicsObject()) then
			if throw then
				self.Stand.GrabbedPlayer:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector() * 1050)
				else
				self.Stand.GrabbedPlayer:GetPhysicsObject():SetVelocity(self.Stand.GrabbedPlayer:GetUp() * 250)
			end
		end
		self.Stand.GrabbedPlayer = nil
		self.GrabbedOldMoveType = nil
	end
end

function SWEP:ResetFingers()
	if IsValid(self.Stand) then
		self.Stand:ResetSequence( self.Stand:LookupSequence("standidle") )
		self:SetHoldType( "stando" )
	end
end

function SWEP:StarFinger()
	if IsValid(self.Stand) then
		if SERVER then
			self.Owner:EmitSound(StarFinger)
			self.Stand:EmitStandSound(SwingSound2)
			self.Stand:EmitStandSound(SwingSound)
		end
		self:SetHoldType( "pistol" )
		if self.Stand:GetSequence() != self.Stand:LookupSequence( "starfinger" ) then
			self.Stand:ResetSequence(self.Stand:LookupSequence( "starfinger" ))
			self.Stand:SetCycle(0)
			self.Stand:SetPlaybackRate(1)
		end
		timer.Simple(self.Stand:SequenceDuration(), function() self:ResetFingers() self.Hit = false end)
	end
end

function SWEP:StarFingerDMG() 
	if IsValid(self.Stand) then
		self.Hit = self.Hit or false
		local pos = self.Stand:GetAttachment(self.Stand:LookupAttachment("starfinger_a"))
		local dir = self.Stand:GetAttachment(self.Stand:LookupAttachment("starfinger_b"))
		self.Stand:SetPlaybackRate(1)
		if pos then
			local tr = util.TraceHull( {
				start = pos.Pos,
				endpos = dir.Pos,
				filter = {self.Stand.Owner, self.Stand},
				mask = MASK_SHOT_HULL,
				mins = Vector(-15,-15,-15),
				maxs = Vector(15,15,15)
			} )
			
			if SERVER and tr.Hit and !self.Hit then
				self.Hit = true
				self.Stand:EmitSound( GetStandImpactSfx(tr.MatType) )
				self.Stand:EmitSound( HitSound )
			end
			if SERVER and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue("explosion", "2") tr.Entity:SetKeyValue("gibdir", tostring(self.Stand:GetAngles())) tr.Entity:Fire("Break") end
			if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
				local dmginfo = DamageInfo()
				local attacker = self.Stand.Owner
				if ( !IsValid( attacker ) ) then attacker = self.Stand.Owner end
				dmginfo:SetAttacker( attacker )
				dmginfo:SetInflictor( self.Stand.Owner:GetActiveWeapon() or self.Stand )
				dmginfo:SetDamage( 25 )
				dmginfo:SetDamageType( DMG_SLASH )
				dmginfo:SetDamagePosition(tr.HitPos)
				
				tr.Entity:TakeDamageInfo( dmginfo )
				
			end
			
			if tr.Entity:IsPlayer() then
				tr.Entity:ViewPunch( Angle( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) ) )
			end
			
		end 
	end
end

function SWEP:Reload()
	
end

function SWEP:OnDrop()
	if GetConVar( "gstands_time_stop" ):GetInt() == 1 and IsValid(GetGlobalEntity( "Time Stop" )) then
		self:StartTime()
	end
	if IsValid(self.Stand) and IsValid(self.Stand.GrabbedPlayer) then
		self:GrabThrow(false)
	end
	if SERVER and self.Owner and self.Stand:IsValid() then
		self.Stand:Withdraw()
	end
	if IsValid(self.Owner) then
		self.Owner:StopSound(OraLoop)
	end
	return true
end

function SWEP:OnRemove()
	if GetConVar( "gstands_time_stop" ):GetInt() == 1 and IsValid(GetGlobalEntity( "Time Stop" )) then
		self:StartTime()
	end
	if IsValid(self.Stand) and IsValid(self.Stand.GrabbedPlayer) then
		self:GrabThrow(false)
	end
	if SERVER and self.Owner and self.Stand:IsValid() then
		self.Stand:Withdraw()
	end
	if IsValid(self.Owner) then
		self.Owner:StopSound(OraLoop)
	end
	return true
end

function SWEP:Holster(wep)
	if SERVER and self.Owner and self.Stand:IsValid() then
		self.KillstreakTimer = self.KillstreakTimer or CurTime()
		
		if self.Owner:Alive() and CurTime() < self.KillstreakTimer then
			self:SetHoldType( "pistol" )
			self.Stand:ResetSequence(self.Stand:LookupSequence( "timestop" ))
			self.Stand:SetFlexScale(1)
			self.Stand:SetFlexWeight(1, 1)
			self.Stand:SetFlexWeight(2, 1)
			self.FlexOverride = true
			self.Stand:SetCycle(0.4)
			self.KillstreakTimer = self.KillstreakTimer - 100
			timer.Simple(1.5, function() 
				if IsValid(self.Stand) then
					self.Stand:Withdraw()
					self.Owner:SelectWeapon(wep:GetClass())
				end
			end)
			timer.Simple(0.2, function() 
				if IsValid(self.Stand) then
					self.Stand:EmitStandSound(Withdraugh)
				end
			end)
			return false
			elseif self.Owner:Alive() then
			self.Stand:EmitStandSound(Withdraw)
		end
		self.Stand:Withdraw()
	end
	if IsValid(self.Stand) and IsValid(self.Stand.GrabbedPlayer) then
		self:GrabThrow(false)
	end
	if IsValid(self.Owner) then
		self.Owner:StopSound(OraLoop)
	end
	return true
end					