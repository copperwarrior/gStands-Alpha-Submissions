
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot			 = 1
end

SWEP.Power				= 2
SWEP.Speed				= 1
SWEP.Range				= 500
SWEP.Durability		   = 1000
SWEP.Precision			= A
SWEP.DevPos			   = A

SWEP.Author			   = "Copper"
SWEP.Purpose			  = "#gstands.slc.purpose"
SWEP.Instructions		 = "#gstands.slc.instructions"
SWEP.Spawnable			= true
SWEP.Base				 = "weapon_fists"   
SWEP.Category			 = "gStands"
SWEP.PrintName			= "#gstands.names.slc"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos			  = 2
SWEP.DrawCrosshair		= true

SWEP.WorldModel		   = "models/player/whitesnake/disc.mdl"
SWEP.ViewModelFOV		 = 54
SWEP.UseHands			 = true

SWEP.Primary.ClipSize	 = -1
SWEP.Primary.DefaultClip  = -1
SWEP.Primary.Automatic	= true
SWEP.Primary.Ammo		 = "none"

SWEP.Secondary.ClipSize   = -1
SWEP.Secondary.DefaultClip= -1
SWEP.Secondary.Automatic  = true
SWEP.Secondary.Ammo	   = "none"

SWEP.DrawAmmo			 = false
SWEP.CanZoom			  = false
SWEP.HitDistance		  = 48
SWEP.ArmorSpeed		   = 0.02
SWEP.Armor				= true

SWEP.RushLoop			 = nil
SWEP.StandModel		   = "models/player/slc/slc.mdl"
SWEP.StandModelP		  = "models/player/slc/slc.mdl"
if CLIENT then
	SWEP.StandModel	   = "models/player/slc/slc.mdl"
end
SWEP.gStands_IsThirdPerson = true
game.AddParticles("particles/mgrtrail.pcf")

PrecacheParticleSystem("chariotflame")



local HitSound	= Sound( "chariot.hit" )
local Slash	   = Sound("chariot.slash")
local SlashLoop   = Sound("chariot_loop1")
local SpinLoop	= Sound("chariot_loop2")
local Deploy	  = Sound("chariot.deploy")
local SDeploy	 = Sound("weapons/chariot/sdeploy.wav")
local Bravo	   = Sound("weapons/chariot/bravo.wav")
local LetsGo	  = Sound("weapons/chariot/letsgo.wav")
local MyTrueSpeed = Sound("weapons/chariot/mytruespeed.wav")
local ComeAtMe	= Sound("weapons/chariot/comeatme.wav")
local YouSuck	 = Sound("weapons/chariot/yousuck.wav")
local TheDevil	= Sound("weapons/chariot/leavetherest.wav")
local Withdraw	= Sound("weapons/chariot/withdraw.wav")
local HoraHoraHora= Sound("weapons/chariot/horahorahora.wav")
local Non		 = Sound("chariot.non")
local BlowUp	  = Sound("chariot.armoroff")
local Swoosh1	 = Sound("weapons/chariot/swoosh/swoosh_01.wav")
local Swoosh2	 = Sound("weapons/chariot/swoosh/swoosh_02.wav")
local Swoosh3	 = Sound("weapons/chariot/swoosh/swoosh_03.wav")
local Swoosh4	 = Sound("weapons/chariot/swoosh/swoosh_04.wav")
local Schwing1	= Sound("weapons/chariot/schwing/schwing_01.wav")
local Schwing2	= Sound("weapons/chariot/schwing/schwing_02.wav")
local Schwing3	= Sound("weapons/chariot/schwing/schwing_03.wav")
local Schwing4	= Sound("weapons/chariot/schwing/schwing_04.wav")
local Schwing5	= Sound("weapons/chariot/schwing/schwing_05.wav")
local Schwing6	= Sound("weapons/chariot/schwing/schwing_06.wav")
local Schwing7	= Sound("weapons/chariot/schwing/schwing_07.wav")
local Schwing8	= Sound("weapons/chariot/schwing/schwing_08.wav")
local Dash		= Sound("chariot.dash")
local Slash1	  = Sound("weapons/chariot/slash/slash_05.wav")
local Slash2	  = Sound("weapons/chariot/slash/slash_02.wav")
local Slash3	  = Sound("weapons/chariot/slash/slash_03.wav")
local Slash4	  = Sound("weapons/chariot/slash/slash_04.wav")
local Slash5	  = Sound("weapons/chariot/slash/slash_05.wav")
local Slash6	  = Sound("weapons/chariot/slash/slash_06.wav")
local Slash7	  = Sound("weapons/chariot/slash/slash_07.wav")
local Slash8	  = Sound("weapons/chariot/slash/slash_08.wav")
local Slash9	  = Sound("weapons/chariot/slash/slash_09.wav")
local Ting		= Sound("chariot.ting")
local Ting1	   = Sound("weapons/chariot/extras/ting.wav")
local Ting2	   = Sound("weapons/chariot/extras/ting2.wav")
local Ting3	   = Sound("weapons/chariot/extras/ting3.wav")
local Ting4	   = Sound("weapons/chariot/extras/ting4.wav")
local Ting5	   = Sound("weapons/chariot/extras/ting5.wav")
local Ting6	   = Sound("weapons/chariot/extras/ting6.wav")
local SwordShoot  = Sound("chariot.swordshoot")
local FlameDeflect= Sound("weapons/chariot/extras/flamedeflect.wav")
local Afterimage  = Sound("weapons/chariot/extras/afterimage.wav")
local Afterimage2 = Sound("weapons/chariot/extras/afterimage2.wav")

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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_standing_03"))
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE_SLAM + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_01"))
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_becon"))
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_becon"))
		self.ActivityTranslate[ ACT_MP_JUMP ]						= ACT_HL2MP_IDLE_MAGIC + 7
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
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_becon"))
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_becon"))
		self.ActivityTranslate[ ACT_MP_JUMP ]						= index + 7
		self.ActivityTranslate[ ACT_RANGE_ATTACK1 ]					= index + 8
		self.ActivityTranslate[ ACT_MP_SWIM ]						= index + 9
	end
	
	if ( t == "normal" ) then
		self.ActivityTranslate[ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end
	
	
end
function SWEP:Initialize()
	timer.Simple(0.1, function() 
		if self:GetOwner():IsValid() then
			if self:GetOwner() != nil then
				if self:GetOwner():IsValid() and SERVER then
					self:GetOwner():SetHealth(GetConVar("gstands_silver_chariot_heal"):GetInt())
					self:GetOwner():SetMaxHealth(GetConVar("gstands_silver_chariot_heal"):GetInt())
				end
			end
		end
	end)
	if CLIENT then
	end
	self:DrawShadow(false)
end

function SWEP:DrawWorldModel()
	if IsValid(self.Owner) then
		return false
		else
		self:DrawModel()
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
		
		local txt1 = language.GetPhrase("gstands.slc.swordon")
		local txt2 = language.GetPhrase("gstands.slc.swordoff")
		draw.TextShadow({
			text = self.Stand:GetBodygroup(2) == 1 and txt1 or txt2,
			font = "gStandsFont",
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
		self.StartCharge = self.StartCharge or CurTime()
		
		
		surface.SetMaterial(cooldown_box)
		surface.DrawRect(width - (56 * mult) - 32 * mult, height - (56 * mult) - 340 * mult, 40 * mult, math.Clamp(0, 40 * mult, math.Remap((CurTime() - self.StartCharge), 0, 3, 0, 40 * mult)))
		surface.DrawTexturedRect(width - (64 * mult) - 32 * mult, height - (64 * mult) - 340 * mult, 64 * mult, 64 * mult)
		
		draw.TextShadow({
			text = "#gstands.slc.dash",
			font = "gStandsFont",
			pos = {width - 100 * mult, height - 390 * mult},
			color = tcolor,
			xalign = TEXT_ALIGN_RIGHT
		}, 2 * mult, 250)
		if IsValid(self:GetStand2()) then
			surface.DrawRect(width - (56 * mult) - 32 * mult, height - (56 * mult) - 440 * mult, 40 * mult, math.Clamp(0, 40 * mult, math.Remap((CurTime() ), 0, 3, 0, 40 * mult)))
		end
		surface.DrawTexturedRect(width - (64 * mult) - 32 * mult, height - (64 * mult) - 440 * mult, 64 * mult, 64 * mult)
		
		draw.TextShadow({
			text = "#gstands.slc.armoroff",
			font = "gStandsFont",
			pos = {width - 100 * mult, height - 490 * mult},
			color = tcolor,
			xalign = TEXT_ALIGN_RIGHT
		}, 2 * mult, 250)
	end
end
hook.Add( "HUDShouldDraw", "SilverChariotHud", function(elem)
	if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_silver_chariot" and (((elem == "CHudWeaponSelection" ) and LocalPlayer().SPInZoom) or elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
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
function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Stand")
	self:NetworkVar("Entity", 1, "Stand1")
	self:NetworkVar("Entity", 2, "Stand2")
	self:NetworkVar("Bool", 3, "AMode")
	self:NetworkVar("Bool", 4, "InRange")
	self:NetworkVar("Float", 5, "Delay2")
	self:NetworkVar("Bool", 6, "SwordFlame")
	self:NetworkVar("Int", 7, "StandIndex")
end


function SWEP:Deploy()
	self:SetHoldType( "stando" )
	
	if self.Owner:Health() == 100  then
		self.Owner:SetMaxHealth( self.Durability )
		self.Owner:SetHealth( self.Durability )
	end
	
	
	self:DefineStand()
	
	
	self:SetAMode( false )
	if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitSound(Deploy)
			self.Owner:EmitStandSound(SDeploy)
		end
	end
	local tag = self.Owner:GetName()
	hook.Add("EntityTakeDamage", "ChariotArmor"..tag, function(target, dmginfo)
		if IsValid(self) and IsValid(self.Stand) and !IsValid(self.Stand1) and target:IsValid() and IsValid(self.Owner)	and target == self.Owner and dmginfo:GetAttacker() != self.Owner then
			dmginfo:SetDamage(dmginfo:GetDamage()/2)
		end
		
		if !IsValid(self) or !IsValid(self.Owner) then
			hook.Remove("EntityTakeDamage", "ChariotNoArmor_"..tag)
		end
	end)
end

function SWEP:DefineStand()
	if SERVER then
		self:SetStand(ents.Create("Stand"))
		self.Stand = self:GetStand()
		self.Stand:SetOwner(self.Owner)
		self.Stand:SetModel(self.StandModel)
		self.Stand:SetBodygroup(2, 1)
		self.Stand:SetMoveType( MOVETYPE_NOCLIP )
		self.Stand:SetAngles(self.Owner:GetAngles())
		self.Stand:SetPos(self.Owner:GetBonePosition(0)+Vector(0, 0, 0))
		self.Stand:DrawShadow(false)
		self.Stand.Color = Color(150,150,150,1)
		self.Stand:Spawn()
		self.Stand.Range = self.Range
		self.Stand.Speed = 20 * self.Speed
		self.Stand:ResetSequence(self.Stand:LookupSequence( "standdeploy" ))
		self.Stand.AnimDelay = CurTime() + self.Stand:SequenceDuration( "standdeploy")
		self.Stand.AnimSet = {
			"STANDIDLE", 0,
			"Shoot", 0,
			"STANDIDLE", 0,
			"IDLE_ALL_02", 0,
			"FIST_BLOCK", 0,
		} 
		timer.Simple(0.1, function()
			if IsValid(self.Stand) then
				self.Stand:EmitStandSound(Swoosh3)
				end
		end)
		timer.Simple(0.3, function()
			if IsValid(self.Stand) then
				self.Stand:EmitStandSound(Swoosh4)
			end
		end)
		timer.Simple(0.6, function()
			if IsValid(self.Stand) then
				self.Stand:EmitStandSound(Ting3)
			end
		end)
		timer.Simple(1.2, function()
			if IsValid(self.Stand) then
				self.Stand:EmitStandSound(Swoosh1)
			end
		end)
		self.Stand.HeadRotOffset = -15
	end
	self:GetStand().Speed = 20 * self.Speed
	
end

function SWEP:DefineImages()
	if CLIENT and self.Stand.StandAura then
		self.Stand.StandAura:StopEmission()
		self.Stand.StandAura = nil
	end
	if SERVER then
		local dododo = self:GetStand():GetInDoDoDo()
		self:GetStand():Remove()
		self:SetStand(ents.Create("Stand"))
		self.Stand = self:GetStand()
		self.Stand:SetOwner(self.Owner)
		self.Stand:SetModel("models/player/slc/slc_un.mdl")
		self.Stand:SetBodygroup(2, 1)
		self.Stand:SetMoveType( MOVETYPE_NOCLIP )
		self.Stand:SetAngles(self.Owner:GetAngles())
		self.Stand:SetPos(self.Owner:GetBonePosition(0)+Vector(0, 0, 0))
		self.Stand:DrawShadow(false)
		self.Stand.Color = Color(150,150,150,1)
		self.Stand:Spawn()
		self.Stand.Range = self.Range
		self.Stand.Speed = 20 * self.Speed
		self.Stand.AnimDelay = CurTime() + 1.3166667045984
		self.Stand:ResetSequence(self.Stand:LookupSequence( "standdeploy" ))
		self.Stand.AnimSet = {
			"STANDIDLE", 0,
			"Shoot", 0,
			"STANDIDLE", 0,
			"IDLE_ALL_02", 0,
			"FIST_BLOCK", 0,
		} 
		self:SetStand1( ents.Create("Stand"))
		self.Stand1 = self:GetStand1()
		self.Stand1:SetOwner(self.Owner)
		self.Stand1:SetModel("models/player/slc/slc_un.mdl")
		self.Stand1:SetBodygroup(2, 1)
		self.Stand1:SetMoveType( MOVETYPE_NOCLIP )
		self.Stand1:SetAngles(self.Owner:GetAngles())
		self.Stand1:SetPos(self.Owner:GetBonePosition(0)+Vector(0, 0, 0))
		self.Stand1:DrawShadow(false)
		self.Stand1.Color = Color(150,150,150,1)
		self.Stand1.ImageID = 2
		self.Stand1:SetSkin(self.Owner:GetInfoNum("gstands_standskin_gstands_silver_chariot", math.random(0, self.Stand1:SkinCount() - 1)))
		self.Stand1:Spawn()
		self.Stand1:SetCycle(math.Rand(0,1))
		self.Stand1.Range = self.Range
		self.Stand1.Speed = 20 * self.Speed
		self.Stand1.AnimDelay = CurTime() + 1.3166667045984
		self.Stand1:ResetSequence(self.Stand1:LookupSequence( "standdeploy" ))
		self.Stand1.AnimSet = {
			"STANDIDLE", 0,
			"Shoot", 0,
			"STANDIDLE", 0,
			"IDLE_ALL_02", 0,
			"FIST_BLOCK", 0,
		} 
		self:SetStand2( ents.Create("Stand"))
		self.Stand2 = self:GetStand2()
		self.Stand2:SetOwner(self.Owner)
		self.Stand2:SetModel("models/player/slc/slc_un.mdl")
		self.Stand2:SetBodygroup(2, 1)
		self.Stand2:SetMoveType( MOVETYPE_NOCLIP )
		self.Stand2:SetAngles(self.Owner:GetAngles())
		self.Stand2:SetPos(self.Owner:GetBonePosition(0)+Vector(0, 0, 0))
		self.Stand2:DrawShadow(false)
		self.Stand2:SetSkin(self.Owner:GetInfoNum("gstands_standskin_gstands_silver_chariot", math.random(0, self.Stand2:SkinCount() - 1)))
		self.Stand2.Color = Color(150,150,150,1)
		self.Stand2.ImageID = 3
		self.Stand2:Spawn()
		self.Stand2:SetCycle(math.Rand(0,1))
		self.Stand2.Range = self.Range
		self.Stand2.Speed = 20 * self.Speed
		self.Stand2.AnimDelay = CurTime() + 1.3166667045984
		self.Stand2:ResetSequence(self.Stand2:LookupSequence( "standdeploy" ))
		self.Stand2.AnimSet = {
			"STANDIDLE", 0,
			"Shoot", 0,
			"STANDIDLE", 0,
			"IDLE_ALL_02", 0,
			"FIST_BLOCK", 0,
		} 
		self.Stand.Image1 = self.Stand1
		self.Stand.Image2 = self.Stand2
		self.Stand:SetImage(self.Stand)
		self.Stand1:SetImage(self.Stand)
		self.Stand1.Image2 = self.Stand2
		self.Stand2:SetImage(self.Stand)
		self.Stand2.Image1 = self.Stand1
		self.Stand:SetCenterImage(self.Stand1)
		self.Stand1:SetCenterImage(self.Stand2)
		self.Stand2:SetCenterImage(self.Stand)
		self.Stand:EmitStandSound(Afterimage)
		self.Stand1:EmitStandSound(Afterimage2)
		self.Stand2:EmitStandSound(Afterimage2)
		self.Stand:SetInDoDoDo(dododo)
		self.Stand1:SetInDoDoDo(dododo)
		self.Stand2:SetInDoDoDo(dododo)
		timer.Simple(0.1, function()
			if IsValid(self.Stand) then
				self.Stand:EmitStandSound(Swoosh3)
			end
		end)
		timer.Simple(0.3, function()
			if IsValid(self.Stand) then
				self.Stand:EmitStandSound(Swoosh4)
			end
		end)
		timer.Simple(0.6, function()
			if IsValid(self.Stand) then
				self.Stand:EmitStandSound(Ting3)
			end
		end)
		timer.Simple(1.2, function()
			if IsValid(self.Stand) then
				self.Stand:EmitStandSound(Afterimage)
			end
		end)
		timer.Simple(0.2, function()
			if IsValid(self.Stand1) then
				self.Stand1:EmitStandSound(Swoosh3)
			end
		end)
		timer.Simple(0.4, function()
			if IsValid(self.Stand1) then
				self.Stand1:EmitStandSound(Swoosh4)
			end
		end)
		timer.Simple(0.7, function()
			if IsValid(self.Stand1) then
				self.Stand1:EmitStandSound(Ting3)
			end
		end)
		timer.Simple(1.3, function()
			if IsValid(self.Stand1) then
				self.Stand1:EmitStandSound(Afterimage2)
			end
		end)
		timer.Simple(0.3, function()
			if IsValid(self.Stand2) then
				self.Stand2:EmitStandSound(Swoosh3)
			end
		end)
		timer.Simple(0.5, function()
			if IsValid(self.Stand2) then
				self.Stand2:EmitStandSound(Swoosh4)
			end
		end)
		timer.Simple(0.8, function()
			if IsValid(self.Stand2) then
				self.Stand2:EmitStandSound(Ting3)
			end
		end)
		timer.Simple(1.4, function()
			if IsValid(self.Stand2) then
				self.Stand2:EmitStandSound(Afterimage2)
			end
		end)
	end
	self:SetPhysAttributes()
end

function SWEP:ResetPhysAttributes()
	self.Owner:SetWalkSpeed(200)
	self.Owner:SetRunSpeed(320)
	self.Owner:SetJumpPower(200)
end
function SWEP:SetPhysAttributes()
	self.Owner:SetWalkSpeed(350)
	self.Owner:SetRunSpeed(550)
	self.Owner:SetJumpPower(300)
end

function SWEP:RemoveImages(redefine)
	redefine = redefine or falsr
	if CLIENT and self.Stand.StandAura then
		self.Stand.StandAura:StopEmission()
		self.Stand.StandAura = nil
	end
	if SERVER then
		self.Stand.Image1 = nil
		self.Stand.Image2 = nil
		local dododo = self.Stand:GetInDoDoDo()
		self.Stand:Remove()
		self.Stand:EmitStandSound(Afterimage2)
		self.Stand1:Withdraw()
		self.Stand2:Withdraw()
		if redefine then
			self:DefineStand()
		end
		self.Stand:SetInDoDoDo(dododo)
	end
	self:ResetPhysAttributes()
end

function SWEP:Think()   
	self.Stand = self:GetStand()
	self.Stand1 = self:GetStand1()
	self.Stand2 = self:GetStand2()
	if !self.Stand:IsValid() then
		self:DefineStand()
	end
	if !self.Stand1:IsValid() and !self.Armor then
		self:DefineImages()
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
	self.Sound = self.Sound or 0
	if SERVER then
		if (self.Sound == 2 or self.Sound == 0) and self.Owner:KeyDown(IN_ATTACK) and !self.Owner:gStandsKeyDown("modifierkey1") and !self:GetAMode() and self.Owner:GetMoveType( ) != MOVETYPE_NONE  then
			self.Stand:EmitStandSound(SlashLoop)
			self.Stand:EmitStandSound(Swoosh2)
			self.Owner:EmitSound(HoraHoraHora)
			self.Sound = 1
		end
		if (self.Sound == 1 or self.Sound == 0) and self.Owner:KeyDown(IN_ATTACK) and self.Owner:gStandsKeyDown("modifierkey1") and !self:GetAMode() and self.Owner:GetMoveType( ) != MOVETYPE_NONE  then
			self.Stand:EmitStandSound(SpinLoop)
			self.Owner:EmitSound(ComeAtMe)
			self.Stand:EmitStandSound(Slash5)
			self.Sound = 2
		end
		if self.Owner:KeyReleased(IN_ATTACK) and !self:GetAMode() or (self.Owner:KeyReleased(IN_RELOAD) and self:GetAMode()) then
			self.Sound = 0
			self.Stand:StopSound(SpinLoop)
			self.Stand:StopSound(SlashLoop)
			if self.Owner:KeyReleased(IN_ATTACK) and !self:GetAMode() then
				self.Stand:EmitStandSound(Swoosh4)
			end
			self:SetHoldType("stando")
		end
		
		
		if self.Owner:KeyReleased(IN_ATTACK) and !self:GetAMode() or (self.Owner:gStandsKeyReleased("modeswap") and self:GetAMode()) then
			self:SetHoldType("stando")
			self:ResetSequence(self:LookupSequence("idle"))
		end
		
	end
	
	if !self.Owner:gStandsKeyDown("modifierkey2") and self.Owner:KeyPressed(IN_ATTACK2) and !self:GetAMode() and self.Stand:GetBodygroup(2) == 1 then
		self.StartCharge = CurTime()
		self:SetHoldType("pistol")
	end
	if !self.Owner:gStandsKeyDown("modifierkey2") and self.Owner:KeyDown(IN_ATTACK2) and !self:GetAMode() and self.Stand:GetBodygroup(2) == 1 then
		if CurTime() - self.StartCharge > 0.2 then
			if SERVER and !self.ChargeStarted then
				self.Stand:EmitStandSound(Schwing8)
				self.ChargeStarted = true
			end
			self.Stand:ResetSequence(self.Stand:LookupSequence("stabcharge"))
			self.Stand:SetCycle( 0 )
			if self.Stand1:IsValid() then
				self.Stand1:ResetSequence(self.Stand1:LookupSequence("stabcharge"))
				self.Stand1:SetCycle( 0 )
			end
			if self.Stand2:IsValid() then
				self.Stand2:ResetSequence(self.Stand2:LookupSequence("stabcharge"))
				self.Stand2:SetCycle( 0 )
			end   
		end
	end
	if IsValid(self.Stand) then
		self.SlashTimer = self.SlashTimer or CurTime()
		if !self:GetAMode() and !self.Owner:gStandsKeyDown("modifierkey2") and self.Stand:GetBodygroup(2) == 1 and self.Owner:KeyReleased(IN_ATTACK2) and CurTime() >= self.SlashTimer then
			
			if CurTime() - self.StartCharge <= 0.2 then
				
				if SERVER then
					self.Owner:EmitSound(LetsGo)
				end
				self:SetHoldType("pistol")
				self.Stand:ResetSequence(self.Stand:LookupSequence("slash"))
				self.Stand:SetCycle( 0 )
				if self.Stand1:IsValid() then
					self.Stand1:ResetSequence(self.Stand1:LookupSequence("slash"))
					self.Stand1:SetCycle( 0 )
				end
				if self.Stand2:IsValid() then
					self.Stand2:ResetSequence(self.Stand2:LookupSequence("slash"))
					self.Stand2:SetCycle( 0 )
				end
				if SERVER and IsValid(self.Stand) then
					self.Stand:EmitStandSound(Schwing4)
					timer.Simple(0.1, function() if IsValid(self.Stand) then self.Stand:EmitStandSound(Slash1) end end)
					timer.Simple(0.3, function() if IsValid(self.Stand) then self.Stand:EmitStandSound(Slash5) end end)
					timer.Simple(0.5, function() if IsValid(self.Stand) then self.Stand:EmitStandSound(Slash6) end end)
					timer.Simple(0.6, function() if IsValid(self.Stand) then self.Stand:EmitStandSound(Slash4) end end)
					timer.Simple(0.8, function() if IsValid(self.Stand) then self.Stand:EmitStandSound(Swoosh3) end end)
					timer.Simple(1, function() if IsValid(self.Stand) then self.Stand:EmitStandSound(Swoosh2) end end)
				end
				timer.Simple(self.Stand:SequenceDuration("slash"), function() 
					if IsValid(self.Stand) then 
						self.Stand:EmitStandSound(Ting6) 
					end 
					if IsValid(self.Stand) then
						self:SetHoldType("stando") 
					end
				end)
				
				self.SlashTimer = CurTime() + self.Stand:SequenceDuration("slash") + 0.1
				
				else
				self:SetHoldType("pistol")
				self.StabHitTable = nil
				self.Stand:ResetSequence(self.Stand:LookupSequence("stabonce"))
				self.Stand:SetCycle( 0 )
				self.Stand:EmitStandSound(Dash)
				if self.Stand1:IsValid() then
					self.Stab1HitTable = nil
					self.Stand1:ResetSequence(self.Stand1:LookupSequence("stabonce"))
					self.Stand1:SetCycle( 0 )
					self.Stand1:EmitStandSound(Dash)
				end
				if self.Stand2:IsValid() then
					self.Stab2HitTable = nil
					self.Stand2:ResetSequence(self.Stand2:LookupSequence("stabonce"))
					self.Stand2:SetCycle( 0 )
					self.Stand2:EmitStandSound(Dash)
				end	
				self.ChargeStarted = false
				timer.Simple(self.Stand:SequenceDuration("stabonce"), function() 
					if IsValid(self.Stand) then
						self:SetHoldType("stando") 
						self.Stand.SendForward = false 
						self.Stand1.SendForward = false 
						self.Stand2.SendForward = false 
					end
				end)
				
				local anim = "punch2"
				self.SlashTimer = CurTime() + self.Stand:SequenceDuration("stabonce") + 0.1
				self.Stand.SendForward = true
				self.Stand.StandVelocity = self.Stand:GetForward() * math.Clamp(0, 3, (CurTime() - self.StartCharge)) * 2
				if IsValid(self.Stand1) then
					self.Stand1.SendForward = true
					self.Stand1.StandVelocity = self.Stand1:GetForward() * math.Clamp(0, 3, (CurTime() - self.StartCharge)) * 2
				end
				if IsValid(self.Stand1) then
					self.Stand2.SendForward = true
					self.Stand2.StandVelocity = self.Stand2:GetForward() * math.Clamp(0, 3, (CurTime() - self.StartCharge)) * 2
				end
				self.StartCharge = 1
			end
		end
		self.ThousandTimer = self.ThousandTimer or CurTime()
		self.Thousand2Timer = self.Thousand2Timer or CurTime()
		
		if self.Owner:gStandsKeyDown("modifierkey1") and IsValid(self.Stand1) and self:GetAMode() and !self.Owner:gStandsKeyDown("modifierkey2") and self.Stand:GetBodygroup(2) == 1 and self.Owner:KeyPressed(IN_ATTACK2) and CurTime() >= self.ThousandTimer then
			
			self:SetHoldType("pistol")
			if SERVER then
				self.Owner:EmitSound(Bravo)
			end
			self.Stand1:ResetSequence(self.Stand1:LookupSequence("slash"))
			self.Stand1:SetCycle( 0 )
			local OwnerVel = 1 + self.Owner:GetVelocity():Length() / 600
			timer.Simple(self.Stand1:SequenceDuration("slash"), function() self.Stand1.SendForward = false end)
			self.ThousandTimer = CurTime() + self.Stand1:SequenceDuration("slash") + 0.1
			self.Stand1.SendForward = true
			self.Stand1.StandVelocity = OwnerVel * self.Stand:GetAimVector() + self:GetRight()/3
			self.Stand:ResetSequence(self.Stand:LookupSequence("slash"))
			self.Stand:SetCycle( 0 )
			timer.Simple(self.Stand:SequenceDuration("slash"), function() self.Stand.SendForward = false end)
			self.ThousandTimer = CurTime() + self.Stand:SequenceDuration("slash") + 0.1
			self.Stand.SendForward = true
			self.Stand.StandVelocity = OwnerVel * self.Stand:GetAimVector() * 1.5
			self.Stand2:ResetSequence(self.Stand2:LookupSequence("slash"))
			self.Stand2:SetCycle( 0 )
			timer.Simple(self.Stand2:SequenceDuration("slash"), function() self.Stand2.SendForward = false end)
			self.ThousandTimer = CurTime() + self.Stand2:SequenceDuration("slash") + 0.1
			self.Stand2.SendForward = true
			self.Stand2.StandVelocity = OwnerVel * self.Stand:GetAimVector() - self:GetRight()/3
			timer.Simple(1.5, function() if !self.Stand2.SendForward then self:SetHoldType("stando") end end)
			self.ThousandTimer = CurTime() + 2
			self.Stand:EmitStandSound(Dash)
			self.Stand1:EmitStandSound(Dash)
			self.Stand2:EmitStandSound(Dash)
			timer.Simple(0.1, function() if IsValid(self.Stand) and IsValid(self.Stand1) and IsValid(self.Stand2) then self.Stand:EmitStandSound(Slash) self.Stand1:EmitStandSound(Slash) self.Stand2:EmitStandSound(Slash) end end)
			timer.Simple(0.3, function() if IsValid(self.Stand) and IsValid(self.Stand1) and IsValid(self.Stand2) then self.Stand:EmitStandSound(Slash) self.Stand1:EmitStandSound(Slash) self.Stand2:EmitStandSound(Slash) end end)
			timer.Simple(0.5, function() if IsValid(self.Stand) and IsValid(self.Stand1) and IsValid(self.Stand2) then self.Stand:EmitStandSound(Slash) self.Stand1:EmitStandSound(Slash) self.Stand2:EmitStandSound(Slash) end end)
			timer.Simple(0.6, function() if IsValid(self.Stand) and IsValid(self.Stand1) and IsValid(self.Stand2) then self.Stand:EmitStandSound(Slash) self.Stand1:EmitStandSound(Slash) self.Stand2:EmitStandSound(Slash) end end)
			timer.Simple(0.8, function() if IsValid(self.Stand) and IsValid(self.Stand1) and IsValid(self.Stand2) then self.Stand:EmitStandSound(Swoosh2) self.Stand1:EmitStandSound(Swoosh2) self.Stand2:EmitStandSound(Swoosh2) end end)
			timer.Simple(1, function() if IsValid(self.Stand) and IsValid(self.Stand1) and IsValid(self.Stand2) then self.Stand:EmitStandSound(Swoosh4) self.Stand1:EmitStandSound(Swoosh4) self.Stand2:EmitStandSound(Swoosh4) end end)
			timer.Simple(1.1, function() if IsValid(self.Stand) and IsValid(self.Stand1) and IsValid(self.Stand2) then self.Stand:EmitStandSound(Dash) self.Stand1:EmitStandSound(Dash) self.Stand2:EmitStandSound(Dash) end end)
		end
		if !self.Owner:gStandsKeyDown("modifierkey1") and IsValid(self.Stand1) and self:GetAMode() and !self.Owner:gStandsKeyDown("modifierkey2") and self.Stand:GetBodygroup(2) == 1 and self.Owner:KeyPressed(IN_ATTACK2) and CurTime() >= self.Thousand2Timer then
			self.Stand1:ResetSequence(self.Stand1:LookupSequence("slash"))
			self.Stand1:SetCycle( 0 )
			self.Stand:ResetSequence(self.Stand:LookupSequence("slash"))
			self.Stand:SetCycle( 0 )
			self.Stand2:ResetSequence(self.Stand2:LookupSequence("slash"))
			self.Stand2:SetCycle( 0 )
			self.Stand.AnimDelay = CurTime() + self.Stand:SequenceDuration()
			self.Stand1.AnimDelay = CurTime() + self.Stand1:SequenceDuration()
			self.Stand2.AnimDelay = CurTime() + self.Stand2:SequenceDuration()
			self.Stand.RotateSpeed = 2
			self.Stand1.RotateSpeed = 2
			self.Stand2.RotateSpeed = 2
			self.Thousand2Timer = CurTime() + 3
			timer.Simple(0.1, function() if IsValid(self.Stand) and IsValid(self.Stand1) and IsValid(self.Stand2) then self.Stand:EmitStandSound(Slash) self.Stand1:EmitStandSound(Slash) self.Stand2:EmitStandSound(Slash) end end)
			timer.Simple(0.3, function() if IsValid(self.Stand) and IsValid(self.Stand1) and IsValid(self.Stand2) then self.Stand:EmitStandSound(Slash) self.Stand1:EmitStandSound(Slash) self.Stand2:EmitStandSound(Slash) end end)
			timer.Simple(0.5, function() if IsValid(self.Stand) and IsValid(self.Stand1) and IsValid(self.Stand2) then self.Stand:EmitStandSound(Slash) self.Stand1:EmitStandSound(Slash) self.Stand2:EmitStandSound(Slash) end end)
			timer.Simple(0.6, function() if IsValid(self.Stand) and IsValid(self.Stand1) and IsValid(self.Stand2) then self.Stand:EmitStandSound(Slash) self.Stand1:EmitStandSound(Slash) self.Stand2:EmitStandSound(Slash) end end)
			timer.Simple(0.8, function() if IsValid(self.Stand) and IsValid(self.Stand1) and IsValid(self.Stand2) then self.Stand:EmitStandSound(Swoosh3) self.Stand1:EmitStandSound(Swoosh3) self.Stand2:EmitStandSound(Swoosh3) end end)
			timer.Simple(1, function() if IsValid(self.Stand) and IsValid(self.Stand1) and IsValid(self.Stand2) then self.Stand:EmitStandSound(Swoosh4) self.Stand1:EmitStandSound(Swoosh4) self.Stand2:EmitStandSound(Swoosh4) end end)
			
		end
		if SERVER and self.Stand:GetSequence() == self.Stand:LookupSequence("stabonce") then
			self:StabOnce()
		end
		self.SlashHitTimer = self.SlashHitTimer or CurTime()
		if SERVER and self.Stand:GetSequence() == self.Stand:LookupSequence("slash") and self.Stand:GetCycle() < 0.9 and self.Stand:GetCycle() > 0.15 and CurTime() >= self.SlashHitTimer then
			self:SlashAttack()
			self.SlashHitTimer = CurTime() + 0.05
			if self.Stand.RotateSpeed > 1 then
				self.SlashHitTimer = CurTime()
			end
		end
		if SERVER and IsValid(self.Stand1) and self.Stand1:GetSequence() == self.Stand1:LookupSequence("stabonce") then
			local mult = 1
			if self.Stand.SendForward then
				mult = math.Remap(math.Clamp(0, 3, (CurTime() - self.StartCharge)), 0, 3, 0.5, 1.5)
			end
			self:StabOnce(mult)
		end
		if SERVER and IsValid(self.Stand1) and self.Stand1:GetSequence() == self.Stand1:LookupSequence("slash") and self.Stand1:GetCycle() < 0.9 and self.Stand1:GetCycle() > 0.15 and CurTime() >= self.SlashHitTimer  then
			self:SlashAttack()
		end
		if SERVER and IsValid(self.Stand2) and self.Stand2:GetSequence() == self.Stand2:LookupSequence("stabonce") then
			self:StabOnce()
		end
		if SERVER and IsValid(self.Stand2) and self.Stand2:GetSequence() == self.Stand2:LookupSequence("slash") and self.Stand2:GetCycle() < 0.9 and self.Stand2:GetCycle() > 0.15 and CurTime() >= self.SlashHitTimer  then
			self:SlashAttack()
		end
		if self.Stand:GetSequence() != self.Stand:LookupSequence("slash") then
			self.Stand.RotateSpeed = 1
			self.Stand1.RotateSpeed = 1
			self.Stand2.RotateSpeed = 1
		end
		self.FireTimer = self.FireTimer or CurTime()
		if SERVER and CurTime() > self.FireTimer and self:GetSwordFlame() then
			self:UnlightSword()
		end
	end
	
	self.TauntTimer = self.TauntTimer or CurTime()
	if self.Owner:gStandsKeyDown("taunt") and CurTime() >= self.TauntTimer then
		self.Owner:SetAnimation(PLAYER_RELOAD)
		if SERVER then
			self.Owner:EmitSound(Non)
		end
		self.TauntTimer = CurTime() + 3
	end
	
	self.Delay = self.Delay or CurTime()
	if self.Owner:gStandsKeyDown("modeswap") and CurTime() > self.Delay then
		
		self.Delay = CurTime() + 0.3
		
		self:SetAMode( !self:GetAMode())
		
		if SERVER then
			if(self:GetAMode()) then 
				self.Owner:ChatPrint("#gstands.general.abilitym")
				if(skip) then
					self:SetNextPrimaryFire(CurTime()+1000000)
					self:SetNextSecondaryFire( CurTime() )
					else
					self:SetNextPrimaryFire(CurTime())
					self:SetNextSecondaryFire( CurTime() )
				end
				else
				self.Owner:ChatPrint("#gstands.general.punchm") 
				self:SetNextPrimaryFire( CurTime() + 0.02 )
				self:SetNextSecondaryFire( CurTime() + 3 )
			end
		end
	end
	self.StandBlockTimer = self.StandBlockTimer or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("block") and CurTime() > self.StandBlockTimer and self.Armor then
		if IsValid(self.Stand) then
			self.Stand.HeadRotOffset = -5
			self:SetHoldType("pistol")
			self.Stand:ResetSequence(self.Stand:LookupSequence( "standblock" ))
			self.Stand:SetCycle(0)
			self.Stand:EmitStandSound(Swoosh1)
			self.Stand:EmitStandSound(Schwing4)
			timer.Simple(self.Stand:SequenceDuration("standblock"), function() 
				if IsValid(self.Stand) then
					self.Stand:EmitStandSound(Ting3) 
					self:SetHoldType("stando") 
					self.Stand.HeadRotOffset = -75 
				end
			end)
			self.StandBlockTimer = CurTime() + self.Stand:SequenceDuration("standblock") + 0.2
		end
	end
end

function SWEP:PrimaryAttack()
	
	if SERVER and self:GetAMode() and self.Stand:GetBodygroup(2) == 1 and !self.Owner:gStandsKeyDown("modifierkey1") then
		if self.Armor then
			self:RemoveArmor()
			self:SetNextPrimaryFire( CurTime() + 1)
			else
			self:ReplaceArmor(true)
			self:SetNextPrimaryFire( CurTime() + 1)
		end
		elseif SERVER and !self:GetAMode() and self.Stand:GetBodygroup(2) == 1 and !self.Owner:gStandsKeyDown("modifierkey1") then
		
		self:SetHoldType("pistol")
		if self.Stand:GetSequence() != self.Stand:LookupSequence("stab") then
			self.Stand:ResetSequence(self.Stand:LookupSequence("stab"))
		end
		if self.Stand1:IsValid() and self.Stand1:GetSequence() != self.Stand1:LookupSequence("stab") then
			self.Stand1:ResetSequence(self.Stand1:LookupSequence("stab"))
		end
		if self.Stand2:IsValid() and self.Stand2:GetSequence() != self.Stand2:LookupSequence("stab") then
			self.Stand2:ResetSequence(self.Stand2:LookupSequence("stab"))
		end	
		self:Barrage()
		
		
		self:SetNextPrimaryFire( CurTime() )
	end
	if !self:GetAMode() and self.Owner:gStandsKeyDown("modifierkey1") and self.Stand:GetBodygroup(2) == 1 then
		self:SetHoldType("pistol")
		if self.Stand:GetSequence() != self.Stand:LookupSequence("block") then
			self.Stand:ResetSequence(self.Stand:LookupSequence("block"))
		end
		if self.Stand1:IsValid() and self.Stand1:GetSequence() != self.Stand1:LookupSequence("block") then
			self.Stand1:ResetSequence(self.Stand1:LookupSequence("block"))
		end
		if self.Stand2:IsValid() and self.Stand2:GetSequence() != self.Stand2:LookupSequence("block") then
			self.Stand2:ResetSequence(self.Stand2:LookupSequence("block"))
		end
		if !self.Stand1:IsValid() then
			for i = 0, 15 do
				self:Block()
			end
			else
			self:Block()
		end
		
		self:SetNextPrimaryFire( CurTime() )
	end
end

local gibs = {
	"models/slc_gibs/gib_01.mdl",
	"models/slc_gibs/gib_02.mdl",
	"models/slc_gibs/gib_04.mdl",
	"models/slc_gibs/gib_05.mdl",
	"models/slc_gibs/gib_06.mdl",
	"models/slc_gibs/gib_07.mdl",
	"models/slc_gibs/gib_08.mdl",
	"models/slc_gibs/gib_09.mdl",
	"models/slc_gibs/gib_10.mdl",
	"models/slc_gibs/gib_11.mdl",
	"models/slc_gibs/gib_12.mdl",
	"models/slc_gibs/gib_13.mdl",
	"models/slc_gibs/gib_14.mdl",
}

function SWEP:RemoveArmor()
	if SERVER then
		
		
		
		for k,v in pairs(gibs) do
			local gib = ents.Create("slc_gib")
			gib:SetModel(v)
			gib:SetPos(self.Stand:WorldSpaceCenter())
			gib:Spawn()
			gib:Activate()
		end
	end
	self.Armor = false
	self.ArmorSpeed = 0.005
	self:DefineImages()
	if SERVER then
		timer.Simple(0, function()
			if IsValid(self.Stand) then
				self.Stand:StopSound(BlowUp)
			end
			self.Owner:EmitStandSound(BlowUp)
			self.Owner:EmitSound(MyTrueSpeed)
		end)
	end
end

function SWEP:ReplaceArmor(redefine)
	self.ArmorSpeed = 0.005
	self.Armor = true
	if IsValid(self.Stand1) and self.Stand1:IsValid() then
		self:RemoveImages(redefine)
	end
end

function SWEP:ShootSword()
	if IsFirstTimePredicted() then
		if (SERVER) then
			local sword = ents.Create("chariot_sword")
			self.Stand:EmitStandSound("physics/metal/metal_solid_impact_bullet2.wav")
			self.Stand:EmitStandSound(SwordShoot)
			if IsValid(sword) then
				sword:SetAngles(self.Owner:EyeAngles())
				sword:SetSwordFlame(self:GetSwordFlame())
				self:UnlightSword()
				sword:SetPos(self.Stand:GetBonePosition(self.Stand:LookupBone("ValveBiped.Bip01_R_Hand")))
				sword:SetOwner(self.Owner)
				sword:SetModelScale(1)
				sword:Spawn()
				sword:Activate()
				local fx = EffectData()
				fx:SetOrigin(sword:GetPos())
				util.Effect("MetalSpark", fx, true, true)
				local phys = sword:GetPhysicsObject()
				phys:SetVelocity(sword:GetForward() * 5500)
				phys:AddAngleVelocity(Vector(0, 0, 0))				
			end
		end
	end
end

function SWEP:LightSword()
	if !self:GetSwordFlame() then
		self.Stand:EmitSound(FlameDeflect)
	end
	self:SetSwordFlame(true)	
	self.FireTimer = CurTime() + 10
end

function SWEP:UnlightSword()
	self:SetSwordFlame(false)
end
function SWEP:SecondaryAttack()
	
	
	if SERVER and (self:GetAMode()) and self.Armor and self.Stand:GetBodygroup(2) == 1 then
		if IsValid(self.Stand) then 
			self:SetNextSecondaryFire( CurTime() + 5 )
			self.Stand:RemoveAllGestures()
			self.Stand.AnimSet = {
				"STANDIDLE", 0,
				"Shoot", 1,
				"STANDIDLE", 0,
				"IDLE_ALL_02", 0,
				"FIST_BLOCK", 0,
			}
			timer.Simple(0.3, function() 
				if IsValid(self.Stand) then 
					self.Stand:SetBodygroup(2, 0) 
					self:ShootSword() 
				end
			end)
			timer.Simple(0.25, function()
				if IsValid(self.Stand) then 
					self.Stand.AnimSet = {
						"STANDIDLE", 0,
						"Shoot", 0,
						"STANDIDLE", 0,
						"IDLE_ALL_02", 0,
						"FIST_BLOCK", 0,
					} 
					self.Stand:RemoveAllGestures()
				end
			end)
		end
		timer.Simple(5, function() if IsValid(self.Stand) and self.Stand:GetBodygroup(2) == 0 then self.Stand:SetBodygroup(2, 1) end end)
	end
	
end
function SWEP:DoBleed(ent)
	if SERVER and ent:IsPlayer() then
		local ltag = ent:EntIndex()
		timer.Create("SilverChariotBleedDamage"..ltag, 0.75, 5, function() 
			if !ent:Alive() then
				timer.Remove("SilverChariotBleedDamage"..ltag)
				return
			end
			local dmginfo = DamageInfo()
			dmginfo:SetDamage(5)
			dmginfo:SetDamageType(DMG_DIRECT)
			dmginfo:SetInflictor(self)
			dmginfo:SetAttacker(self.Owner)
			ent:TakeDamageInfo(dmginfo)
			local fxdata = EffectData()
			fxdata:SetOrigin(ent:WorldSpaceCenter())
			fxdata:SetEntity(ent)
			util.Effect("BloodImpact", fxdata, true, true)
			
		end)
	end
end
hook.Add("PostPlayerDeath", "StoptheBleedfromChariot", function(ply) timer.Remove("SilverChariotBleedDamage"..ply:EntIndex()) end)
function SWEP:Barrage()
	
	
	local anim = self.Owner:GetSequenceName(self.Owner:GetSequence())
	local tr
	local tr1
	local tr2
	self.Owner:LagCompensation( true )
	
	tr = util.TraceHull( {
		start = self.Stand:GetAttachment(self.Stand:LookupAttachment("anim_attachment_rh")).Pos,
		endpos = self.Stand:GetAttachment(self.Stand:LookupAttachment("swordtip")).Pos,
		filter = {self.Owner, self.Stand, self.Stand1, self.Stand2 },
		mins = Vector( -15, -15, -25 ), 
		maxs = Vector( 15, 15, 25 ),
		mask = MASK_SHOT_HULL, 
		
	} )
	if self.Stand1:IsValid() and self.Stand2:IsValid() then
		tr1 = util.TraceHull( {
			start = self.Stand:GetAttachment(self.Stand:LookupAttachment("anim_attachment_rh")).Pos,
			endpos = self.Stand:GetAttachment(self.Stand:LookupAttachment("swordtip")).Pos,
			filter = {self.Owner, self.Stand, self.Stand1, self.Stand2 },
			mins = Vector( -15, -15, -25 ), 
			maxs = Vector( 15, 15, 25 ),
			mask = MASK_SHOT_HULL, 
			
		} )
		tr2 = util.TraceHull( {
			start = self.Stand:GetAttachment(self.Stand:LookupAttachment("anim_attachment_rh")).Pos,
			endpos = self.Stand:GetAttachment(self.Stand:LookupAttachment("swordtip")).Pos,
			filter = {self.Owner, self.Stand, self.Stand1, self.Stand2 },
			mins = Vector( -15, -15, -25 ), 
			maxs = Vector( 15, 15, 25 ),
			mask = MASK_SHOT_HULL, 
			
		} )
	end
	
	
	if ( tr.Hit and SERVER) then
	end
	if SERVER and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue("explosion", "2") tr.Entity:SetKeyValue("gibdir", tostring(self.Stand:GetAngles())) tr.Entity:Fire("Break") end
	if IsValid(tr.Entity) and tr.Entity:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE then
		tr.Entity:Remove()
	end
	if tr1 and IsValid(tr1.Entity) and tr1.Entity:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE then
		tr1.Entity:Remove()
	end
	if tr2 and IsValid(tr2.Entity) and tr2.Entity:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE then
		tr2.Entity:Remove()
	end
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0) ) then
		
		local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self.Owner end
		dmginfo:SetAttacker( attacker )
		dmginfo:SetDamageType(DMG_SLASH)
		
		dmginfo:SetInflictor( self )
		
		dmginfo:SetDamage(GetConVar("gstands_silver_chariot_barrage_no_flame"):GetInt())
		if tr.HitGroup == HITGROUP_HEAD then
			dmginfo:AddDamage(5)
		end
		if self:GetSwordFlame() then
			dmginfo:SetDamageType(DMG_BURN)
			dmginfo:SetDamage(GetConVar("gstands_silver_chariot_barrage_flame"):GetInt())
			tr.Entity:Ignite(1)
		end
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
		if self.Owner:gStandsKeyDown("modifierkey1") and tr.Entity:GetSequence() != tr.Entity:LookupSequence("barrage") then
			tr.Entity:SetVelocity(dmginfo:GetDamageForce() * -75)
			tr.Entity:SetVelocity(self.Stand:GetAngles():Forward() * 750)
		end
		timer.Simple(0, function() if !IsValid(tr.Entity) or tr.Entity:Health() < 1 then self.TheDevil = true timer.Simple(3, function() if IsValid(self) then self.TheDevil = false end end) end end)
		self:DoBleed(tr.Entity)
	end
	if tr1 and ( SERVER && IsValid( tr1.Entity ) && ( tr1.Entity:IsNPC() || tr1.Entity:IsPlayer() || tr1.Entity:Health() > 0) ) then
		
		local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self.Owner end
		dmginfo:SetAttacker( attacker )
		
		dmginfo:SetInflictor( self.Owner )
		dmginfo:SetDamageType(DMG_SLASH)
		
		dmginfo:SetDamage(GetConVar("gstands_silver_chariot_barrage_no_flame"):GetInt())
		if tr1.HitGroup == HITGROUP_HEAD then
			dmginfo:AddDamage(5)
		end
		if self:GetSwordFlame() then
			dmginfo:SetDamageType(DMG_BURN)
			dmginfo:SetDamage(GetConVar("gstands_silver_chariot_barrage_flame"):GetInt())
			tr.Entity:Ignite(1)
		end
		tr1.Entity:TakeDamageInfo( dmginfo )
		
		if tr1.Entity:GetClass() != "stand" then
			local vel = tr1.Entity:GetAbsVelocity()
			tr1.Entity:TakeDamageInfo( dmginfo )
			vel = vel + ( tr1.Entity:GetVelocity() - vel)
			tr1.Entity:SetVelocity(-vel/2)
			else
			local vel = tr1.Entity.Owner:GetAbsVelocity()
			tr1.Entity:TakeDamageInfo( dmginfo )
			vel = vel + ( tr1.Entity.Owner:GetVelocity() - vel)
			vel.z = 0
			tr1.Entity.Owner:SetVelocity(-vel/2)
		end
		if self.Owner:gStandsKeyDown("modifierkey1") and tr1.Entity:GetSequence() != tr1.Entity:LookupSequence("barrage") then
			tr1.Entity:SetVelocity(dmginfo:GetDamageForce() * -75)
			tr1.Entity:SetVelocity(self.Stand:GetAngles():Forward() * 750)
		end
		self:DoBleed(tr1.Entity)
	end
	if tr2 and ( SERVER && IsValid( tr2.Entity ) && ( tr2.Entity:IsNPC() || tr2.Entity:IsPlayer() || tr2.Entity:Health() > 0) ) then
		
		local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self.Owner end
		dmginfo:SetAttacker( attacker )
		
		dmginfo:SetInflictor( self.Owner )
		dmginfo:SetDamageType(DMG_SLASH)
		
		dmginfo:SetDamage(GetConVar("gstands_silver_chariot_barrage_no_flame"):GetInt())
		if tr2.HitGroup == HITGROUP_HEAD then
			dmginfo:AddDamage(5)
		end
		if self:GetSwordFlame() then
			dmginfo:SetDamageType(DMG_BURN)
			dmginfo:SetDamage(GetConVar("gstands_silver_chariot_barrage_flame"):GetInt())
			tr.Entity:Ignite(1)
		end
		tr2.Entity:TakeDamageInfo( dmginfo )
		
		if tr2.Entity:GetClass() != "stand" then
			local vel = tr2.Entity:GetAbsVelocity()
			tr2.Entity:TakeDamageInfo( dmginfo )
			vel = vel + ( tr2.Entity:GetVelocity() - vel)
			tr2.Entity:SetVelocity(-vel/2)
			else
			local vel = tr2.Entity.Owner:GetAbsVelocity()
			tr2.Entity:TakeDamageInfo( dmginfo )
			vel = vel + ( tr2.Entity.Owner:GetVelocity() - vel)
			vel.z = 0
			tr2.Entity.Owner:SetVelocity(-vel/2)
		end
		if self.Owner:gStandsKeyDown("modifierkey1") and tr2.Entity:GetSequence() != tr2.Entity:LookupSequence("barrage") then
			tr2.Entity:SetVelocity(dmginfo:GetDamageForce() * -75)
			tr2.Entity:SetVelocity(self.Stand:GetAngles():Forward() * 750)
		end
		self:DoBleed(tr2.Entity)
	end
	if tr.Hit and ((tr.Entity:IsPlayer() or tr.Entity:IsNPC())) and math.random(1,5) == 1 then
		self.Stand:EmitSound( HitSound )
	end
	
	if ( SERVER && IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 1 * phys:GetMass(), tr.HitPos )
		end
	end
	
	
	if tr.Entity:IsPlayer() and !self.Owner.IsKnockedOut then
		tr.Entity:ViewPunch( Angle( math.random( -3, 3 ), math.random( -3, 3 ), math.random( -3, 3 ) ) )
	end
	
	
	if ( tr.HitWorld ) then
		if self.Stand1:IsValid() and self.Stand2:IsValid() then
			self.Owner:SetVelocity( self.Owner:GetAimVector() * -50 + Vector( 0, 0, 50 ) )
			else
			self.Owner:SetVelocity( self.Owner:GetAimVector() * -10 + Vector( 0, 0, 10 ) )
		end
	end
	
	self.Owner:LagCompensation( false )
	
end
function SWEP:Block()
	
	local tr
	local tr1
	local tr2
	self.Owner:LagCompensation( true )
	self.HitTable = self.HitTable or {self.Owner, self.Stand, self.Stand1, self.Stand2 }
	
	tr = util.TraceHull( {
		start = self.Stand:GetAttachment(self.Stand:LookupAttachment("anim_attachment_rh")).Pos + self.Owner:GetAimVector() * 65,
		endpos = self.Stand:GetAttachment(self.Stand:LookupAttachment("anim_attachment_rh")).Pos + self.Owner:GetAimVector() * 65,
		filter = self.HitTable,
		mins = Vector( -65, -65, -65 ), 
		maxs = Vector( 65, 65, 65 ),
		mask = MASK_SHOT_HULL,
		ignoreworld = true
	} )
	if self.Stand1:IsValid() and self.Stand2:IsValid() then
		tr1= util.TraceHull( {
			start = self.Stand1:GetAttachment(self.Stand1:LookupAttachment("anim_attachment_rh")).Pos + self.Owner:GetAimVector() * 65,
			endpos = self.Stand1:GetAttachment(self.Stand1:LookupAttachment("anim_attachment_rh")).Pos + self.Owner:GetAimVector() * 65,
			filter = self.HitTable,
			mins = Vector( -65, -65, -65 ), 
			maxs = Vector( 65, 65, 65 ),
			mask = MASK_SHOT_HULL, 
			ignoreworld = true
		} )
		tr2 = util.TraceHull( {
			start = self.Stand2:GetAttachment(self.Stand2:LookupAttachment("anim_attachment_rh")).Pos + self.Owner:GetAimVector() * 65,
			endpos = self.Stand2:GetAttachment(self.Stand2:LookupAttachment("anim_attachment_rh")).Pos + self.Owner:GetAimVector() * 65,
			filter = self.HitTable,
			mins = Vector( -65, -65, -65 ), 
			maxs = Vector( 65, 65, 65 ),
			mask = MASK_SHOT_HULL, 
			ignoreworld = true
		} )
	end
	if SERVER and IsValid(tr.Entity) and (tr.Entity:GetPos() - self.Stand:WorldSpaceCenter()):GetNormalized():Dot(self.Stand:GetForward()) < 0.5 and tr.Entity:GetClass() != "emperor_bullet" then
		if IsValid(tr.Entity:GetPhysicsObject()) and tr.Entity:GetPhysicsObject():IsMotionEnabled() then
			local phys = tr.Entity:GetPhysicsObject()
			local n = self.Stand:GetForward()
			local d = phys:GetVelocity()
			local dot = n:Dot(d)
			local r = d - 2 * (dot) * n
			
			phys:SetVelocity(r * 2 + n * r:Length()/4)
			tr.Entity.flightvector = (r * 2 + n * r:Length()/4)
			tr.Entity.InFlight = true
			phys:SetAngles((r * 2 + n):Angle())
			tr.Entity.Owner = self:GetOwner()
			tr.Entity:SetOwner(self:GetOwner())
			tr.Entity:SetPhysicsAttacker(self:GetOwner())
			table.insert(self.HitTable, tr.Entity)
			elseif !IsValid(tr.Entity:GetPhysicsObject()) then
			local n = self.Stand:GetForward()
			local d = tr.Entity:GetVelocity()
			local dot = n:Dot(d)
			local r = d - 2 * (dot) * n
			
			tr.Entity:SetVelocity(r * 2 + n * r:Length()/4)
			tr.Entity:SetAngles((r * 2 + n):Angle())
			table.insert(self.HitTable, tr.Entity)
		end
		if tr.Entity:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE and !tr.Entity:IsStand() and tr.Entity:GetClass() != "emperor_bullet" then
			tr.Entity.Owner = self.Owner
			tr.Entity:SetOwner(self.Owner)
			tr.Entity:SetPhysicsAttacker(self.Owner)
		end
		self.Stand:EmitStandSound(Ting)
	end
	if tr1 and IsValid(tr1.Entity) then
		if IsValid(tr1.Entity:GetPhysicsObject()) then
			local phys = tr1.Entity:GetPhysicsObject()
			local n = self.Stand1:GetForward()
			local d = phys:GetVelocity()
			local dot = n:Dot(d)
			local r = d - 2 * (dot) * n
			
			phys:SetVelocity(r * 2)
			tr1.Entity.flightvector = (r * 2 + n * r:Length()/4)
			tr1.Entity.InFlight = true
			phys:SetAngles((r * 2 + n):Angle())
			table.insert(self.HitTable, tr1.Entity)
			
			else
			local n = self.Stand1:GetForward()
			local d = tr1.Entity:GetVelocity()
			local dot = n:Dot(d)
			local r = d - 2 * (dot) * n
			
			tr1.Entity:SetVelocity(r * 2 + n * r:Length()/4)
			tr1.Entity:SetAngles((r * 2 + n):Angle())
			table.insert(self.HitTable, tr1.Entity)
		end
		if tr1.Entity:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE and !tr1.Entity:IsStand() and !tr1.Entity:GetClass() == "emperor_bullet" then
			tr1.Entity.Owner = self:GetOwner()
			tr1.Entity:SetOwner(self:GetOwner())
			tr1.Entity:SetPhysicsAttacker(self:GetOwner())
		end
	end
	if tr2 and IsValid(tr2.Entity) then
		if IsValid(tr2.Entity:GetPhysicsObject()) then
			local phys = tr2.Entity:GetPhysicsObject()
			local n = self.Stand2:GetForward()
			local d = phys:GetVelocity()
			local dot = n:Dot(d)
			local r = d - 2 * (dot) * n
			
			phys:SetVelocity(r * 2)
			tr2.Entity.flightvector = (r * 2 + n * r:Length()/4)
			tr2.Entity.InFlight = true
			phys:SetAngles((r * 2 + n):Angle())
			table.insert(self.HitTable, tr2.Entity)
			
			else
			local n = self.Stand2:GetForward()
			local d = tr2.Entity:GetVelocity()
			local dot = n:Dot(d)
			local r = d - 2 * (dot) * n
			
			tr2.Entity:SetVelocity(r * 2 + n * r:Length()/4)
			tr2.Entity:SetAngles((r * 2 + n):Angle())
			table.insert(self.HitTable, tr2.Entity)
		end
		if tr2.Entity:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE and !tr2.Entity:IsStand() and !tr2.Entity:GetClass() == "emperor_bullet" then
			tr2.Entity.Owner = self:GetOwner()
			tr2.Entity:SetOwner(self:GetOwner())
			tr2.Entity:SetPhysicsAttacker(self:GetOwner())
		end
	end
	self.Owner:LagCompensation( false )
	
end

function SWEP:StabOnce(mult)
	self.StabHitTable = self.StabHitTable or {self.Owner, self.Stand, self.Stand1, self.Stand2 }
	self.Stab1HitTable = self.Stab1HitTable or {self.Owner, self.Stand, self.Stand1, self.Stand2 }
	self.Stab2HitTable = self.Stab2HitTable or {self.Owner, self.Stand, self.Stand1, self.Stand2 }
	
	local anim = self.Owner:GetSequenceName(self.Owner:GetSequence())
	self.Owner:LagCompensation( true )
	local tr
	local tr1
	local tr2
	mult = mult or 1
	
	tr = util.TraceHull( {
		start = self.Stand:GetAttachment(self.Stand:LookupAttachment("anim_attachment_rh")).Pos,
		endpos = self.Stand:GetAttachment(self.Stand:LookupAttachment("swordtip")).Pos,
		filter = self.StabHitTable,
		mins = Vector(-35, -35, -35),
		maxs = Vector(35, 35, 35),
		mask = MASK_SHOT_HULL, 
		ignoreworld = true
	} )
	if self.Stand1:IsValid() and self.Stand2:IsValid() then
		tr1 = util.TraceHull( {
			start = self.Stand1:GetAttachment(self.Stand1:LookupAttachment("anim_attachment_rh")).Pos,
			endpos = self.Stand1:GetAttachment(self.Stand1:LookupAttachment("swordtip")).Pos,
			filter = self.Stab1HitTable,
			mins = Vector(-35, -35, -35),
			maxs = Vector(35, 35, 35),
			mask = MASK_SHOT_HULL, 
			ignoreworld = true
		} )
		tr2 = util.TraceHull( {
			start = self.Stand2:GetAttachment(self.Stand2:LookupAttachment("anim_attachment_rh")).Pos,
			endpos = self.Stand2:GetAttachment(self.Stand2:LookupAttachment("swordtip")).Pos,
			filter = self.Stab2HitTable,
			mins = Vector(-35, -35, -35),
			maxs = Vector(35, 35, 35),
			mask = MASK_SHOT_HULL, 
			ignoreworld = true
		} )
	end
	if IsValid(tr.Entity) and tr.Entity:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE then
		tr.Entity:Remove()
	end
	if tr1 and IsValid(tr1.Entity) and tr1.Entity:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE then
		tr1.Entity:Remove()
	end
	if tr2 and IsValid(tr2.Entity) and tr2.Entity:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE then
		tr2.Entity:Remove()
	end
	
	if ( tr.Hit and SERVER) then
		self.Owner:EmitSound( HitSound )
	end
	
	local hit = false
	if SERVER and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue("explosion", "2") tr.Entity:SetKeyValue("gibdir", tostring(self.Stand:GetAngles())) tr.Entity:Fire("Break") end
	
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity.Health )) then
		local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self.Owner end
		dmginfo:SetAttacker( attacker )
		
		dmginfo:SetInflictor( self.Owner )
		
		dmginfo:SetDamage(GetConVar("gstands_silver_chriot_charge_dash_damage_not_flame"):GetInt() * mult)
		dmginfo:SetDamageType(DMG_SLASH)
		if self:GetSwordFlame() then
			dmginfo:SetDamageType(DMG_BURN)
			dmginfo:SetDamage(GetConVar("gstands_silver_chriot_charge_dash_damage_flame"):GetInt() * mult)
			tr.Entity:Ignite(5)
		end
		if tr.HitGroup == HITGROUP_HEAD then
			dmginfo:AddDamage(50)
			
		end
		table.insert(self.StabHitTable, tr.Entity)
		tr.Entity:TakeDamageInfo( dmginfo )
		self:DoBleed(tr.Entity)
		
		if !self.Owner.IsKnockedOut then
			tr.Entity:SetVelocity( self.Owner:GetAimVector() * 100 + Vector( 0, 0, 100 ) )
		end
		hit = true
		
	end
	
	if tr1 and ( SERVER && IsValid( tr1.Entity ) && ( tr1.Entity:IsNPC() || tr1.Entity:IsPlayer() || tr1.Entity:Health() > 0 )) then
		local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self.Owner end
		dmginfo:SetAttacker( attacker )
		
		dmginfo:SetInflictor( self.Owner )
		
		dmginfo:SetDamage(GetConVar("gstands_silver_chriot_charge_dash_damage_not_flame"):GetInt() * mult)
		dmginfo:SetDamageType(DMG_SLASH)
		if self:GetSwordFlame() then
			dmginfo:SetDamageType(DMG_BURN)
			dmginfo:SetDamage(GetConVar("gstands_silver_chriot_charge_dash_damage_flame"):GetInt() * mult)
			tr1.Entity:Ignite(5)
		end
		if tr1.HitGroup == HITGROUP_HEAD then
			dmginfo:AddDamage(50)
		end
		tr1.Entity:TakeDamageInfo( dmginfo )
		self:DoBleed(tr1.Entity)
		table.insert(self.Stab1HitTable, tr1.Entity)
		if !self.Owner.IsKnockedOut then
			
			tr1.Entity:SetVelocity( self.Owner:GetAimVector() * 100 + Vector( 0, 0, 100 ) )
		end
		hit = true
		
	end
	if tr2 and ( SERVER && IsValid( tr2.Entity ) && ( tr2.Entity:IsNPC() || tr2.Entity:IsPlayer() || tr2.Entity:Health() > 0 )) then
		local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self.Owner end
		dmginfo:SetAttacker( attacker )
		
		dmginfo:SetInflictor( self.Owner )
		
		dmginfo:SetDamage(GetConVar("gstands_silver_chriot_charge_dash_damage_not_flame"):GetInt() * mult)
		dmginfo:SetDamageType(DMG_SLASH)
		if self:GetSwordFlame() then
			dmginfo:SetDamageType(DMG_BURN)
			dmginfo:SetDamage(GetConVar("gstands_silver_chriot_charge_dash_damage_flame"):GetInt() * mult)
			tr2.Entity:Ignite(5)
		end
		if tr2.HitGroup == HITGROUP_HEAD then
			dmginfo:AddDamage(50)
		end
		tr2.Entity:TakeDamageInfo( dmginfo )
		self:DoBleed(tr2.Entity)
		table.insert(self.Stab2HitTable, tr2.Entity)
		if !self.Owner.IsKnockedOut then
			tr2.Entity:SetVelocity( self.Owner:GetAimVector() * 100 + Vector( 0, 0, 100 ) )
		end
		hit = true
		
	end
	
	if tr.Entity:IsPlayer() and !self.Owner.IsKnockedOut then
		tr.Entity:ViewPunch( Angle( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) ) )
	end
	if tr1 and tr1.Entity:IsPlayer() and !self.Owner.IsKnockedOut then
		tr1.Entity:ViewPunch( Angle( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) ) )
	end
	if tr2 and tr2.Entity:IsPlayer() and !self.Owner.IsKnockedOut then
		tr2.Entity:ViewPunch( Angle( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) ) )
	end
	
	self.Owner:LagCompensation( false )
	
end
function SWEP:SlashAttack(mult)
	
	
	local anim = self.Owner:GetSequenceName(self.Owner:GetSequence())
	self.Owner:LagCompensation( true )
	local tr
	local tr1
	local tr2
	mult = mult or 1

	tr = util.TraceHull( {
		start = self.Stand:GetAttachment(self.Stand:LookupAttachment("anim_attachment_rh")).Pos,
		endpos = self.Stand:GetAttachment(self.Stand:LookupAttachment("swordtip")).Pos + self.Owner:GetAimVector() * 55,
		filter = {self.Owner, self.Stand, self.Stand1, self.Stand2 },
		mins = Vector( -15, -15, -15 ), 
		maxs = Vector( 15, 15, 15 ),
		mask = MASK_SHOT_HULL, 
		ignoreworld = true
	} )
	if self.Stand1:IsValid() and self.Stand2:IsValid() then
		tr1 = util.TraceHull( {
			start = self.Stand1:GetAttachment(self.Stand1:LookupAttachment("anim_attachment_rh")).Pos,
			endpos = self.Stand1:GetAttachment(self.Stand1:LookupAttachment("swordtip")).Pos + self.Owner:GetAimVector() * 55,
			filter = {self.Owner, self.Stand, self.Stand1, self.Stand2 },
			mins = Vector( -15, -15, -15 ), 
			maxs = Vector( 15, 15, 15 ),
			mask = MASK_SHOT_HULL, 
			ignoreworld = true
		} )
		tr2 = util.TraceHull( {
			start = self.Stand2:GetAttachment(self.Stand2:LookupAttachment("anim_attachment_rh")).Pos,
			endpos = self.Stand2:GetAttachment(self.Stand2:LookupAttachment("swordtip")).Pos + self.Owner:GetAimVector() * 55,
			filter = {self.Owner, self.Stand, self.Stand1, self.Stand2 },
			mins = Vector( -15, -15, -15 ), 
			maxs = Vector( 15, 15, 15 ),
			mask = MASK_SHOT_HULL, 
			ignoreworld = true
			
		} )
	end
	
	if IsValid(tr.Entity) and tr.Entity:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE then
		tr.Entity:Remove()
	end
	if tr1 and IsValid(tr1.Entity) and tr1.Entity:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE then
		tr1.Entity:Remove()
	end
	if tr2 and IsValid(tr2.Entity) and tr2.Entity:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE then
		tr2.Entity:Remove()
	end
	
	
	if ( tr.Hit and SERVER) then
		tr.Entity:EmitSound( HitSound )
	end
	
	local hit = false
	if SERVER and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue("explosion", "2") tr.Entity:SetKeyValue("gibdir", tostring(self.Stand:GetAngles())) tr.Entity:Fire("Break") end
	
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity.Health )) then
		local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self.Owner end
		dmginfo:SetAttacker( attacker )
		
		dmginfo:SetInflictor( self.Owner )
		dmginfo:SetDamage(GetConVar("gstands_silver_chariot_slash_no_flame"):GetInt() * mult)
		dmginfo:SetDamageType(DMG_SLASH)
		if self:GetSwordFlame() then
			dmginfo:SetDamageType(DMG_BURN)
			dmginfo:SetDamage(GetConVar("gstands_silver_chariot_slash_flame"):GetInt() * mult)
			tr.Entity:Ignite(5)
		end
		if tr.HitGroup == HITGROUP_HEAD then
			dmginfo:AddDamage(50)
			
		end
		tr.Entity:TakeDamageInfo( dmginfo )
		timer.Simple(0, function() if !IsValid(tr.Entity) or tr.Entity:Health() < 1 then self.YouSuck = true timer.Simple(3, function() if IsValid(self) then self.YouSuck = false end end) end end)
		
		self:DoBleed(tr.Entity)
	end
	
	if tr1 and ( SERVER && IsValid( tr1.Entity ) && ( tr1.Entity:IsNPC() || tr1.Entity:IsPlayer() || tr1.Entity:Health() > 0 )) then
		local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self.Owner end
		dmginfo:SetAttacker( attacker )
		
		dmginfo:SetInflictor( self.Owner )
		dmginfo:SetDamage(GetConVar("gstands_silver_chariot_slash_no_flame"):GetInt() * mult)
		dmginfo:SetDamageType(DMG_SLASH)
		if self:GetSwordFlame() then
			dmginfo:SetDamageType(DMG_BURN)
			dmginfo:SetDamage(GetConVar("gstands_silver_chariot_slash_flame"):GetInt() * mult)
			tr1.Entity:Ignite(5)
		end
		if tr1.HitGroup == HITGROUP_HEAD then
			dmginfo:AddDamage(50)
		end
		tr1.Entity:TakeDamageInfo( dmginfo )
		self:DoBleed(tr1.Entity)
	end
	if tr2 and ( SERVER && IsValid( tr2.Entity ) && ( tr2.Entity:IsNPC() || tr2.Entity:IsPlayer() || tr2.Entity:Health() > 0 )) then
		local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self.Owner end
		dmginfo:SetAttacker( attacker )
		
		dmginfo:SetInflictor( self.Owner )
		
		local dist = tr.HitPos:Distance(self.Stand2:GetBonePosition(self.Stand2:LookupBone("ValveBiped.Bip01_R_Hand"))) 
		dmginfo:SetDamage(GetConVar("gstands_silver_chariot_slash_no_flame"):GetInt() * mult)
		dmginfo:SetDamageType(DMG_SLASH)
		if self:GetSwordFlame() then
			dmginfo:SetDamageType(DMG_BURN)
			dmginfo:SetDamage(GetConVar("gstands_silver_chariot_slash_flame"):GetInt() * mult)
			tr2.Entity:Ignite(5)
		end
		if tr2.HitGroup == HITGROUP_HEAD then
			dmginfo:AddDamage(50)
		end
		tr2.Entity:TakeDamageInfo( dmginfo )
		self:DoBleed(tr2.Entity)
		
	end
	
	if tr.Entity:IsPlayer() then
		tr.Entity:ViewPunch( Angle( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) ) )
	end
	if tr1 and tr1.Entity:IsPlayer() and !self.Owner.IsKnockedOut then
		tr1.Entity:ViewPunch( Angle( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) ) )
	end
	if tr2 and tr2.Entity:IsPlayer() and !self.Owner.IsKnockedOut then
		tr2.Entity:ViewPunch( Angle( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) ) )
	end
	
	
	self.Owner:LagCompensation( false )
	
end

function SWEP:Reload()
	
end


function SWEP:OnDrop()
	if SERVER and self.Owner and self.Stand:IsValid() then
		self.Stand:Withdraw()
		self.Stand:StopSound(SpinLoop)
		self.Stand:StopSound(SlashLoop)
	end
	
	self:ReplaceArmor(false)
	return true
end

function SWEP:OnRemove()
	if SERVER and self.Owner and self.Stand:IsValid() then
		self.Stand:Withdraw()
		self.Stand:StopSound(SpinLoop)
		self.Stand:StopSound(SlashLoop)
	end
	self:ReplaceArmor(false)
	return true
end

function SWEP:Holster()
	if SERVER and self.Owner and self.Stand:IsValid() then
		self.Stand:Withdraw()
		self.Stand:EmitStandSound(Withdraw)
		self.Stand:StopSound(SpinLoop)
		self.Stand:StopSound(SlashLoop)
		if self.YouSuck then
			self.Owner:EmitSound(YouSuck)
		end
		if self.TheDevil then
			self.Owner:EmitSound(TheDevil)
		end
	end
	self:ReplaceArmor(false)
	return true
end		
