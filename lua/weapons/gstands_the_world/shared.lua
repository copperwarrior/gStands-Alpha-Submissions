--Send file to clients
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot	  = 1
end

SWEP.Power = 3
SWEP.Speed = 1
SWEP.Range = 500
SWEP.Durability = 1500
SWEP.Precision = B
SWEP.DevPos = B

SWEP.Author		= "Copper"
SWEP.Purpose	   = "#gstands.world.purpose"
SWEP.Instructions  = "#gstands.world.instructions"
SWEP.Spawnable	 = true
SWEP.Base		  = "weapon_fists"   
SWEP.Category	  = "gStands"
SWEP.PrintName	 = "#gstands.names.world"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos			= 2
SWEP.DrawCrosshair	  = true

SWEP.WorldModel	 = "models/player/whitesnake/disc.mdl"
SWEP.ViewModelFOV   = 54
SWEP.UseHands	   = true

SWEP.Primary.ClipSize	   = 50
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic	  = true
SWEP.Primary.Ammo		  	= "ammo_ball_bearing"

SWEP.Secondary.ClipSize	 = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo		 = "none"

SWEP.DrawAmmo	   = true
SWEP.HitDistance	= 5
SWEP.TimeStopped	= false
SWEP.Checkmate	= true
SWEP.AccurateCrosshair = false
SWEP.StandModel = "models/player/worldjf/world.mdl"
SWEP.StandModelP = "models/player/worldjf/world.mdl"
SWEP.CanZoom = true
SWEP.gStands_IsThirdPerson = true

SWEP.CanTimeStop = true
SWEP.TSConvarLimit = GetConVar("gstands_the_world_limit")
SWEP.TSConvarLength = GetConVar("gstands_the_world_timestop_length")

--Define swing and hit sounds. Might change these later.
local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )
local MudaBig = Sound("weapons/world/muda.wav")
local MudaLoop = Sound("world.muda_loop")
local StopTime = Sound("weapons/world/time_stop.wav")
local StartTime = Sound("weapons/world/start_time.wav")
local Deploy = Sound("weapons/world/deploy.wav")
local KnifeThrow = Sound("weapons/world/knife_throw.mp3")
local Wry = Sound("weapons/world/wry.wav")
local RoadRoller = {Sound("weapons/world/roller.wav"), Sound("weapons/world/tankerjp.mp3")}
local Checkmate = Sound("weapons/world/checkmate.wav")
local Shine = Sound("weapons/world/shine.wav")
local Bakana = Sound("weapons/world/bakana.wav")
local zawarudoda = Sound("weapons/world/deploy-02.wav")
local SDeploy = Sound("weapons/world/sdep.wav")
local Deploy = Sound("weapons/world/deploy_01.wav")
local Tomanei = Sound("weapons/world/stoptimes.wav")
local STEffect = Sound("weapons/world/stop_time_effect_.wav")
local hahaha = Sound("weapons/world/hahaha.wav")


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

		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_standing_01"))

		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE + 1

		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST

		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_01"))

		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4

		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("taunt_zombie"))

		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("taunt_zombie"))

		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("taunt_zombie"))

		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("taunt_zombie"))

		self.ActivityTranslate[ ACT_MP_JUMP ]						= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("jump_knife"))

		self.ActivityTranslate[ ACT_RANGE_ATTACK1 ]					= index + 8

		self.ActivityTranslate[ ACT_MP_SWIM ]						= index + 9

		if self.Owner:GetModel() == "models/player/dio/dio.mdl" then

			self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= ACT_VM_CRAWL

			self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= ACT_VM_CRAWL_EMPTY

			self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= ACT_VM_CRAWL_EMPTY

			self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= ACT_VM_CRAWL_EMPTY

			self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= ACT_VM_CRAWL_EMPTY

		end

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
function SWEP:SetupDataTables()
	self:NetworkVar( "Entity", 0, "Stand" )
	self:NetworkVar( "Bool", 0, "AMode" )
	self:NetworkVar( "Float", 1, "TimeStopDelay" )
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
if CLIENT then
	function SWEP:DrawHUD()
		if GetConVar("gstands_draw_hud"):GetBool() and IsValid(self.Stand) then
			if IsValid(self.Stand) then
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
				local nocompletegstands = Color(255,0,0, 255)
				draw.TextShadow({
					text = "No Complete!",
					font = "gStandsFont",
					pos = {width - 1500 * mult, height - 265 * mult},
					color = nocompletegstands,
				}, 2 * mult, 250)

				draw.TextShadow({
					text = "This Stand is incomplete!",
					font = "gStandsFont",
					pos = {width - 1550 * mult, height - 235 * mult},
					color = nocompletegstands,
				}, 2 * mult, 250)

				draw.TextShadow({
					text = self:Clip1().."/"..self:GetMaxClip1(),
					font = "gStandsFontLarge",
					pos = {width - 160 * mult, height - 120 * mult},
					color = tcolor,
					xalign = TEXT_ALIGN_CENTER
				}, 2 * mult, 250)
				
				surface.SetMaterial(cooldown_box)
				if !IsValid(GetGlobalEntity("Time Stop")) then
					surface.DrawRect(width - (56 * mult) - 32 * mult, height - (56 * mult) - 340 * mult, 40 * mult, math.Clamp(0, 40 * mult, math.Remap(self:GetTimeStopDelay() - CurTime(), GetConVar( "gstands_the_world_next_timestop" ):GetFloat(), 0, 0, 40 * mult)))
					else
					surface.DrawRect(width - (56 * mult) - 32 * mult, height - (56 * mult) - 340 * mult, 40 * mult, math.Clamp(0, 40 * mult, math.Remap(self:GetTimeStopDelay() - CurTime(), 0, GetConVar( "gstands_the_world_timestop_length" ):GetFloat(), 0, 40 * mult)))
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
	end
	hook.Add( "HUDShouldDraw", "TheWorldHud", function(elem)
		if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_the_world" and (((elem == "CHudWeaponSelection" ) and LocalPlayer().SPInZoom) or elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
			return false
		end
	end)
end
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
function SWEP:Equip()
end
function SWEP:OwnerChanged()
end
function SWEP:Initialize()
	timer.Simple(0.1, function() 
		if self:GetOwner() != nil then
			if self:GetOwner():IsValid() and SERVER then
				self:GetOwner():SetHealth(1500)
				self:GetOwner():SetMaxHealth(1500)
			end
		end
	end)
	self:DrawShadow(false)
end


if CLIENT then
	net.Receive("world.PlaySound", 
		function()
			timer.Simple(0.2, function()
				LocalPlayer():EmitSound("weapons/world/stop_time_"..math.random(1, 2)..".wav", 75, 100 )
				LocalPlayer():ChatPrint( "『The World!』" )   
			end)
			timer.Simple(2, function()
				LocalPlayer():ChatPrint( "『Takiyo Tomaney!』" ) 
				LocalPlayer():EmitSound(STEffect)
			end)
		end)
		net.Receive("world.PlaySound2", 
			function()
				LocalPlayer():ChatPrint( "『Tokiwa Mukidas』" )
				LocalPlayer():EmitSound(StartTime) 
			end)
			net.Receive("world.Enter", function() 
				local tab = {
					["$pp_colour_addr"]		 = 0/255,
					["$pp_colour_addg"]		 = 0/255,
					["$pp_colour_addb"]		 = 0/255,
					["$pp_colour_brightness"]	 = 0.3,
					["$pp_colour_contrast"]	 = 1,
					["$pp_colour_colour"]		 = -5,
					["$pp_colour_mulr"]		 = -5,
				["$pp_colour_mulg"]		 = -5,
				["$pp_colour_mulb"]		 = -5,
				}
				local StartTime = CurTime()
				hook.Add( "RenderScreenspaceEffects", "StopTimeColour"..LocalPlayer():GetName(), function()
					local tabI = {
						[ "$pp_colour_addr" ] = Lerp(0.01, (CurTime() % 10)/512, 0),
						[ "$pp_colour_addg" ] = Lerp(0.01, ((CurTime() + 200) % 10)/512, 0),
						[ "$pp_colour_addb" ] = Lerp(0.01, ((CurTime() + 400) % 10)/512, 0),
						[ "$pp_colour_brightness" ] = Lerp(0.1, tab[ "$pp_colour_brightness" ],0),
						[ "$pp_colour_contrast" ] = Lerp(0.1, tab[ "$pp_colour_contrast" ], 0.4),
						[ "$pp_colour_colour" ] = Lerp(0.1, tab[ "$pp_colour_colour" ], 0.01),
						[ "$pp_colour_mulr" ] = Lerp(0.1, math.Rand(tab[ "$pp_colour_mulr" ], 0.5), 0.5),
						[ "$pp_colour_mulg" ] = Lerp(0.1, math.Rand(tab[ "$pp_colour_mulg" ], 0.5), 0.5),
						[ "$pp_colour_mulb" ] = Lerp(0.1, math.Rand(tab[ "$pp_colour_mulb" ], 0.5), 0.5)
					}
					tab = tabI
					DrawColorModify( tabI )
					
				end)
			end)
			net.Receive("world.Exit", function( ply ) 
				hook.Remove( "RenderScreenspaceEffects", "StopTimeColour"..LocalPlayer():GetName() )
			end)

end

if SERVER then
	util.AddNetworkString("world.PlaySound")
	util.AddNetworkString("world.PlaySound2")
	util.AddNetworkString("world.PlaySound3")
	util.AddNetworkString("world.Stop")
	util.AddNetworkString("world.Enter")
	util.AddNetworkString("world.Start")
	util.AddNetworkString("world.Exit")
	util.AddNetworkString("world.Blind")
	util.AddNetworkString("world.UnBlind")
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
function SWEP:Deploy()
	self:SetWeaponHoldType( "stando" )
	self:SetHoldType( "stando" )
	self:DefineStand()
	self.Checkmate = true
	self:SetAMode( false)
	timer.Simple(0.1, function() 
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitStandSound(SDeploy)
			self.Owner:EmitSound("weapons/world/deploy_01.wav")
		end
	end)
	self.Owner:SetCanZoom(false)
end
function SWEP:DefineStand()
	if SERVER then
		self:SetStand( ents.Create("Stand"))
		self.Stand = self:GetStand()
		self.Stand:SetOwner(self.Owner)
		self.Stand:SetModel(self.StandModel)
		self.Stand:SetMoveType( MOVETYPE_NOCLIP )
		self.Stand:SetAngles(self.Owner:GetAngles())
		self.Stand:SetPos(self.Owner:GetBonePosition(0)+Vector(0, 0, 0))
		self.Stand:DrawShadow(false)
		self.Stand.Range = self.Range
		self.Stand.Speed = 20 * self.Speed
		self.Stand:Spawn()
		--self.Stand.CurrentAnim = "swimming_fist"
	end
	timer.Simple(0.1, function()
		if self.Stand:IsValid() then
			if self.Stand:GetSkin() == 0 then
				self.Stand.rgl = 1.7
				self.Stand.ggl = 1.5
				self.Stand.bgl = 1.7
				self.Stand.rglm = 1.5
				self.Stand.gglm = 1.4
				self.Stand.bglm = 1.3
				elseif self.Stand:GetSkin() == 1 then
				self.Stand.rgl = 1.8
				self.Stand.ggl = 1.8
				self.Stand.bgl = 1.9
				self.Stand.rglm = 1.4
				self.Stand.gglm = 1.4
				self.Stand.bglm = 1.5
			end
		end
	end)
end
SWEP.PlayerMoveType = { }
SWEP.roller = NULL
function SWEP:Think()
	if self.Owner:HasWeapon("gstands_the_world") then
		self.Owner:SetWalkSpeed(450)
		self.Owner:SetRunSpeed(450)
		self.Owner:SetJumpPower(260)
	end
	self.AmmoTimer = self.AmmoTimer or CurTime()
	if CurTime() > self.AmmoTimer and self:Clip1() < 50 then
		self:SetClip1( self:Clip1() + 10 )
		self.AmmoTimer = CurTime() + 10
	end
	self.Stand = self:GetStand()
	if !self.Stand:IsValid() then
		self:DefineStand()
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
	if SERVER then
		for k,v in ipairs(player.GetAll()) do
			if GetConVar("gstands_time_stop"):GetInt() == 0 and !IsValid(GetGlobalEntity("Time Stop")) and v:GetMoveType() == MOVETYPE_FLY then
				v:SetMoveType(v.PlayerMoveType or MOVETYPE_WALK)
			end
		end
	end
	if SERVER then
		for k,v in ipairs(player.GetAll()) do
			if GetConVar("gstands_time_stop"):GetInt() == 1 and IsValid(GetGlobalEntity("Time Stop")) and self.Owner:IsOnGround() then
				self.Owner:SetMoveType(MOVETYPE_WALK)
				if !v:Alive() then
					v:Lock()
					net.Start("world.Blind")
					net.Send(v)
				end
				elseif GetConVar("gstands_time_stop"):GetInt() == 1 and IsValid(GetGlobalEntity("Time Stop")) then
				if !v:Alive() then
					v:Lock()
					net.Start("world.Blind")
					net.Send(v)
				end
				self.Owner:SetMoveType(MOVETYPE_FLY)
			end
		end
	end
	if SERVER then
		if self.Owner:KeyPressed(IN_ATTACK) and !self:GetAMode() and self.Owner:GetMoveType( ) != MOVETYPE_NONE then
			self.Owner:EmitStandSound("muda_loop")
			timer.Create("mudamuda"..self.Owner:GetName(), 3.4, 0, function() if self.GetAMode and !self:GetAMode() then self.Owner:EmitStandSound("muda_loop") end end)
		end
		if self.Owner:KeyReleased(IN_ATTACK) and !self:GetAMode() then
			timer.Remove("mudamuda"..self.Owner:GetName())
			self.Owner:StopSound("muda_loop")
			self.Owner:EmitStandSound( MudaBig )
			self:SetHoldType( "stando")
		end
		if (self.Owner:KeyDown(IN_ATTACK) and self.Owner:KeyDown(IN_ATTACK2)) then
			self:SetHoldType( "stando")
		end
		if self.Owner:KeyDown(IN_ATTACK) and !self:GetAMode() and self.Owner:GetMoveType( ) != MOVETYPE_NONE then
		end
		if self:GetAMode() and timer.Exists("mudamuda"..self.Owner:GetName()) then
			timer.Remove("mudamuda"..self.Owner:GetName())
			self.Owner:StopSound("muda_loop")
			self:SetHoldType( "stando")
		end
		if self.Owner:gStandsKeyPressed("tertattack") and self:GetAMode() and !self.RoadRoller then
			self.roller = ents.Create("prop_physics")
			self.RoadRoller = true
			if(self.Owner:GetMoveType() == MOVETYPE_FLY) then
				self.roller:SetPos(((self.Owner:WorldSpaceCenter()) - Vector(0, 0, 96)))
				else
				self.roller:SetPos(self.Stand:GetEyePos() + (self.Owner:GetForward() * 128))
			end
			if self.Stand:GetSkin() == 1 then
				
				self.roller:SetModel("models/props_trainstation/train002.mdl")
				self.Owner:EmitSound("weapons/world/road_roller-0"..math.random(1, 2)..".wav", 60, 100 )
			else 
				self.roller:SetModel("models/player/dio/roadroller.mdl")
				self.Owner:EmitSound("weapons/world/road_roller-0"..math.random(1, 2)..".wav", 60, 100 )
			end
			self.roller:SetHealth(1)
			self.roller:Spawn()
			self.roller:SetAngles(Angle(0, self.Owner:GetAngles().y, 0))
			self.roller:GetPhysicsObject():SetMass(1000)
			self.roller:SetPhysicsAttacker(self.Owner)
			undo.Create("Road Roller")
			undo.AddEntity(self.roller)
			undo.SetPlayer(self.Owner)
			undo.AddFunction(function() self.RoadRoller = false if timer.Exists("gstands_roadroller"..self.Owner:GetName()) then timer.Remove("gstands_roadroller"..self.Owner:GetName()) end end)
			undo.Finish()
			timer.Create("gstands_roadroller"..self.Owner:GetName(), 15, 1, function() if GetConVar("phys_timescale"):GetFloat() == 0 then timer.Start("gstands_roadroller"..self.Owner:GetName()) else self.RoadRoller = false self.roller:Remove() end end)
		end
	end
	if self.Owner:gStandsKeyPressed("modeswap") and !self:GetAMode() and IsValid(GetGlobalEntity("Time Stop")) then
		self.Owner:SetVelocity(self.Owner:GetVelocity() * -1) 
	end
	if !GetConVar("gstands_time_stop"):GetBool() then
		self.Checkmate = true
	end
	self.TauntTimer = self.TauntTimer or CurTime()
	if self.Owner:gStandsKeyDown("taunt") and CurTime() >= self.TauntTimer then
		local ang = self.Owner:GetAngles()
		self.Owner:SetAnimation( PLAYER_RELOAD )
		self.Owner:SetAngles(ang)
		if SERVER then
			self.Owner:EmitSound("weapons/world/wry-0"..math.random(1, 2)..".wav", 60, 100 )
		end
		self.TauntTimer = CurTime() + 2
	end
	self.Delay = self.Delay or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("modeswap") and CurTime() > self.Delay then
		self.Delay = CurTime() + 1
		self:SetAMode( !self:GetAMode())
		if SERVER then
			if(self:GetAMode()) then 
				self.Owner:ChatPrint("Режим способностей.")
				if(skip) then
					self:SetNextPrimaryFire(CurTime()+1000000)
					self:SetNextSecondaryFire( CurTime() )
					else
					self:SetNextPrimaryFire(CurTime())
					self:SetNextSecondaryFire( CurTime() )
				end
				else
				self.Owner:ChatPrint("Ударный режим.") 
				self:SetNextPrimaryFire( CurTime() + 0.02 )
				self:SetNextSecondaryFire( CurTime() + 0.2 )
			end
		end
	end
end
function SWEP:StopTime()
	if IsValid(self.Stand) then
		if GetConVar( "gstands_time_stop" ):GetInt() == 0 then
			if SERVER then
				GetConVar( "gstands_time_stop" ):SetInt(1)
			end
			timer.Remove( "zawarudo"..self.Owner:GetName())
			if GetConVar( "gstands_the_world_limit" ):GetInt() == 1 then
				timer.Create( "stopMax"..self.Owner:GetName(), GetConVar( "gstands_the_world_timestop_length" ):GetFloat(), 1,
				function() 
				if GetConVar( "gstands_the_world_limit" ):GetInt() == 1 then
						self:StartTime()
						self.Owner.WasFrozen = true
					end
				end)
			end
			self.Owner.WasFrozen = true
			self:SetNextPrimaryFire(CurTime()+1)
			self:SetNextSecondaryFire(CurTime()+1)
			if SERVER and self.Stand:IsValid() then
				local zawa = EffectData()
				zawa:SetEntity(self.Stand)
				zawa:SetOrigin(self.Stand:GetBonePosition(6))
				zawa:SetMagnitude(3)
				util.Effect("tw2", zawa)
			end
			if SERVER and self.Stand:IsValid() then
				local zawa = EffectData()
				zawa:SetEntity(self.Stand)
				zawa:SetOrigin(self.Stand:GetBonePosition(6))
				zawa:SetMagnitude(3)
				util.Effect("tw", zawa)
			end
			if SERVER then
				local zawaeffect2 = EffectData()
				zawaeffect2:SetEntity(self.Stand)
				zawaeffect2:SetOrigin(self.Stand:GetBonePosition(6))
				zawaeffect2:SetMagnitude(1)
				util.Effect( "tweffect2", zawaeffect2, true, true)
			end
			timer.Simple(0.7, function()
				if SERVER then
					if IsValid(self.Stand) then
						local zawaeffect = EffectData()
						zawaeffect:SetEntity(self.Stand)
						zawaeffect:SetOrigin(self.Stand:GetBonePosition(6))
						zawaeffect:SetMagnitude(1)
						util.Effect( "tweffect", zawaeffect, true, true)
					end
				end
			end)
			MsgC(Color(255,0,0), self.Owner:GetName().." is trying to stop time with The World!\n")
			if !IsValid(GetGlobalEntity( "Time Stop" )) then
				SetGlobalEntity( "Time Stop", ents.Create( "gstands_tscontroller" ))
				self.TimeStopperController = GetGlobalEntity( "Time Stop" )
				self.TimeStopperController.Owner = self.Owner
			end
			self.TimeStopperController = GetGlobalEntity( "Time Stop" )
			self.TimeStopperController:Spawn()
			if IsValid(GetGlobalEntity( "gstands_tscontroller" )) then
				table.insert(self.TimeStopperController.StoppedUsers, self.Owner)
			end
			self.TimeStopperController:Activate()
			self:SetTimeStopDelay(CurTime() + GetConVar( "gstands_the_world_timestop_length" ):GetFloat())
		end
	end
end


function SWEP:StartTime()
	if IsValid(self.Stand) then
		self.Owner:StopSound( "muda_loop" )
	end
	timer.Remove("mudamuda"..self.Owner:GetName())
	if IsValid(GetGlobalEntity("Time Stop")) and #GetGlobalEntity( "Time Stop" ).StoppedUsers > 1 and GetConVar( "gstands_the_world_limit" ):GetBool() then
		table.RemoveByValue(GetGlobalEntity( "Time Stop" ).StoppedUsers, self.Owner)
		self.Owner:EmitSound(Bakana)
		self:SetNextSecondaryFire( CurTime() + 4 )
		self.TSExitBuffer = CurTime() + 1
		elseif !self.Owner:IsFlagSet(FL_FROZEN) then
		self:SetNextSecondaryFire( CurTime() + 4 )
		self:SetTimeStopDelay(CurTime() + GetConVar( "gstands_the_world_next_timestop" ):GetInt())
		if SERVER then
			GetConVar( "gstands_time_stop" ):SetInt(0)
		end
		self:SetNextPrimaryFire(CurTime())
		self.Owner.WasFrozen = false
		if SERVER then
			GetConVar( "gstands_time_stop" ):SetInt(0)
		end
		if IsValid(GetGlobalEntity( "Time Stop" )) then
			timer.Simple(1.3, function()
				GetGlobalEntity( "Time Stop" ):Remove()
				if SERVER and self.Stand and self.Stand:IsValid() then
					local zawa = EffectData()
					zawa:SetEntity(self.Stand)
					zawa:SetOrigin(self.Stand:GetBonePosition(6))
					zawa:SetMagnitude(3)
					util.Effect("tw", zawa)   
				end
				timer.Simple(0.1, function()
					if SERVER and self.Stand and self.Stand:IsValid() then
						local zawa = EffectData()
						zawa:SetEntity(self.Stand)
						zawa:SetOrigin(self.Stand:GetBonePosition(6))
						zawa:SetMagnitude(3)
						util.Effect("tw", zawa)   
					end
				end)
			end)
		end
		if(SERVER) then
			net.Start( "world.PlaySound2" )
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
						timer.Remove( "stopWorld1" )
						timer.Remove( "stopWorld1" )
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
	if (self:GetAMode()) then
		self.BearingTimer = self.BearingTimer or CurTime()
		if CurTime() >= self.BearingTimer then
			if self:Clip1() > 0 then
				self.Stand:EmitStandSound(KnifeThrow)
			end
			timer.Create("knifethrowtimer",0.02,10,function() self:KnifeThrow() end)
			self.BearingTimer = CurTime() + 1
		end
		self:SetNextPrimaryFire( CurTime() + 1 )
		else
		if SERVER then
			self.Stand:RemoveAllGestures()
		end
		self:SetHoldType("pistol")
		if !self.Owner:gStandsKeyDown("modifierkey1") and self.Stand:GetSequence() != self.Stand:LookupSequence("barrage") then
			self.Stand:ResetSequence(self.Stand:LookupSequence("barrage"))
			self.Stand:SetCycle( 0 )
			self.Stand:SetPlaybackRate( 1 )
		elseif self.Owner:gStandsKeyDown("modifierkey1") and self.Stand:GetSequence() != self.Stand:LookupSequence("kbarrage") then
			self.Stand:ResetSequence(self.Stand:LookupSequence("kbarrage"))
			self.Stand:SetCycle( 0 )
		end
		self:Barrage()
		self:SetNextPrimaryFire( CurTime() + 0.02 )
		right = !right
		self:SetNextSecondaryFire( CurTime() + 0.1 )
	end
end
function SWEP:SecondaryAttack()
	self.TimeStopDelay = self.TimeStopDelay or CurTime()
	if( self:GetAMode() ) and CurTime() > self:GetTimeStopDelay() then
		self:SetNextSecondaryFire( CurTime() + 3 )
		if !GetConVar( "gstands_time_stop" ):GetBool() and !IsValid(GetGlobalEntity( "Time Stop" )) and self.Owner:KeyPressed(IN_ATTACK2) then
			if SERVER and self.Stand:GetSequence() != self.Stand:LookupSequence( "timestop" ) then
				self.Stand:SetPlaybackRate( 0.1 )
				self.Stand:SetCycle( 0 )
				self.Stand:ResetSequence(self.Stand:LookupSequence("timestop"))
				self.Stand.AnimDelay = CurTime() + self.Stand:SequenceDuration()
				timer.Simple(4.2, function() 
					if IsValid(self.Stand) then
						self:SetHoldType( "stando" ) 
						self.Stand:SetPlaybackRate( 1 ) 
						self.Stand:ResetSequence( "standidle" ) 
					end
				end)
				timer.Create( "sutahprachina"..self.Owner:GetName(), 2.2, 1, function() 
					self:StopTime()
				end)
			end
			if SERVER then
				net.Start( "world.PlaySound" )
				net.Broadcast()
			end
			self.TSReleaseDelay = self.TSReleaseDelay or CurTime()
			elseif SERVER and IsValid(GetGlobalEntity( "Time Stop" )) and ((GetConVar( "gstands_time_stop" ):GetInt() == 1 and CurTime() >= self.TSReleaseDelay) or (!GetConVar( "gstands_star_platinum_limit" ):GetBool() and GetGlobalEntity( "Time Stop" ).Owner and CurTime() >= self.TSReleaseDelay)) then
			self:StartTime()
			
		end
			else
			if SERVER then
				self.Stand:RemoveAllGestures()
			end
			self:SetHoldType("pistol")
			if SERVER and !self.Owner:gStandsKeyDown("modifierkey1") and self.Stand:GetSequence() != self.Stand:LookupSequence("donut") then
				for i = 0, 14 do
					self.Stand:SetLayerBlendOut(i, 0)
				end
				if IsValid(self.Stand) and self:GetOwner():Alive() then
					self.Stand:RemoveAllGestures()
					self.Stand:ResetSequence( self.Stand:LookupSequence("donut") )

					self.Stand:ResetSequenceInfo()
					self.Stand:SetPlaybackRate( 1 )
					self.Stand:SetCycle( 0 )
				end
			elseif SERVER and self.Owner:gStandsKeyDown("modifierkey1") and self.Stand:GetSequence() != self.Stand:LookupSequence("spinkick") then
				for i = 0, 14 do
					self.Stand:SetLayerBlendOut(i, 0)
				end
				self.Stand:RemoveAllGestures()
				self.Stand:ResetSequence( self.Stand:LookupSequence("spinkick") )
				self.Stand:ResetSequenceInfo()
				self.Stand:SetPlaybackRate( 1 )
				self.Stand:SetCycle( 0 )
			end
			local anim = "punch2"
			if SERVER then
				self.Owner:EmitSound("weapons/world/shine-0"..math.random(1, 2)..".wav", 60, 99 )
				if !self.Owner:gStandsKeyDown("modifierkey1") then
					timer.Simple(self.Stand:SequenceDuration()/3, function()
						if IsValid(self) then
							self:DonutPunch()
						end
					end)
				else
					timer.Simple(self.Stand:SequenceDuration()/2.5, function()
						if IsValid(self) then
							self:DonutPunch()
						end
					end)
				end
				timer.Simple(self.Stand:SequenceDuration(), function()
					if IsValid(self) then
						if IsValid(self.Stand) and self:GetOwner():Alive() then
							self:SetHoldType( "stando")
						end
					end
				end)
			end
			self:SetNextPrimaryFire( CurTime() + (0.02 * self.Speed) )
			self:SetNextSecondaryFire( CurTime() + 2 )
		end
end
function SWEP:Barrage()
	local bone = "ValveBiped.Bip01_R_Hand"
	if math.random(1,2) == 1 then
		bone = "ValveBiped.Bip01_L_Hand"
	end
	if self.Owner:gStandsKeyDown("modifierkey1") then
		bone = "ValveBiped.Bip01_R_Foot"
	end
	local anim = self.Owner:GetSequenceName(self.Owner:GetSequence())
	self.Owner:LagCompensation( true )  
	local tr = util.TraceHull( {
		start = self.Stand:GetBonePosition(self.Stand:LookupBone(bone)),
		endpos = self.Stand:GetBonePosition(self.Stand:LookupBone(bone)) + self.Stand:GetForward() * self.HitDistance,
		filter = {self.Owner, self.Stand},
		mins = Vector( -5, -5, -15 ), 
		maxs = Vector( 15, 15, 15 ),
		mask = MASK_SHOT_HULL
		
	} )
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
	end
	if SERVER and math.random(0, 2) == 0 and !tr.Hit then
		self.Stand:EmitStandSound(SwingSound)
	end
	if SERVER and !IsValid(GetGlobalEntity("Time Stop")) and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue("explosion", "2") tr.Entity:SetKeyValue("gibdir", tostring(self.Stand:GetAngles())) tr.Entity:Fire("Break") end
	if IsValid(tr.Entity) and !((tr.Entity:IsPlayer() or tr.Entity:IsNPC())) and IsValid(tr.Entity:GetPhysicsObject()) then
		tr.Entity:GetPhysicsObject():SetVelocity(self.Stand:GetAngles():Forward() * 550)
	end
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity.Health) ) then
		self.Stand:EmitSound( GetStandImpactSfx(tr.MatType) )
		local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		dmginfo:SetAttacker( attacker )
		dmginfo:SetDamageForce(self.Stand:GetAngles():Forward() * 750)
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage(21)
		if tr.Entity:GetClass() != "stand" then
			local vel = tr.Entity:GetAbsVelocity()
			tr.Entity:TakeDamageInfo( dmginfo )
			vel = vel + ( tr.Entity:GetVelocity() - vel)
			tr.Entity:SetVelocity(-vel)
		else
			local vel = tr.Entity.Owner:GetAbsVelocity()
			tr.Entity:TakeDamageInfo( dmginfo )
			vel = vel + ( tr.Entity.Owner:GetVelocity() - vel)
			vel.z = 0
			tr.Entity.Owner:SetVelocity(-vel)
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
		if tr.Entity:GetClass() == "stand" then
			effectdata:SetFlags(2)
		end
		util.Effect("gstands_stand_impact", effectdata)
	end
	if ( SERVER && tr.Entity:IsValid( ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Stand:GetForward() * 15 * phys:GetMass(), tr.HitPos )
			constraint.RemoveConstraints(tr.Entity, "Weld")
			local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			effectdata:SetFlags(1)
			if tr.Entity:GetClass() == "stand" then
				effectdata:SetFlags(2)
			end
			util.Effect("gstands_stand_impact", effectdata)
		end
	end
	if tr.Entity:IsPlayer() and !self.Owner.IsKnockedOut then
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
	local anim = self.Owner:GetSequenceName(self.Owner:GetSequence())
	self.Owner:LagCompensation( true )
	local bone = self.Stand:LookupBone("ValveBiped.Bip01_R_Hand")
	if self.Owner:gStandsKeyDown("modifierkey1") then
		bone = self.Stand:LookupBone("ValveBiped.Bip01_R_Foot")
	end
	local tr = util.TraceHull( {
		start = self.Stand:GetBonePosition(bone),
		endpos = self.Stand:GetBonePosition(bone) + self.Owner:GetAimVector() * self.HitDistance,
		filter = { self.Owner, self.Stand },
		mins = Vector( -25, -25, -25 ), 
		maxs = Vector( 25, 25, 25 ),
		ignoreworld = false,
		mask = MASK_SHOT_HULL
		
	} )
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
	end
	if SERVER and !IsValid(GetGlobalEntity("Time Stop")) and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue("explosion", "2") tr.Entity:SetKeyValue("gibdir", tostring(self.Stand:GetAngles())) tr.Entity:Fire("Break") end
	if IsValid(tr.Entity) and !((tr.Entity:IsPlayer() or tr.Entity:IsNPC())) and IsValid(tr.Entity:GetPhysicsObject()) then
		tr.Entity:GetPhysicsObject():SetVelocity(self.Stand:GetAngles():Forward() * 1550)
	end
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity.Health) ) then
		self.Stand:EmitSound( "physics/flesh/flesh_impact_bullet"..math.random(1,5)..".wav" )
		local dmginfo = DamageInfo()
		dmginfo:SetDamageForce(self.Stand:GetAngles():Forward() * 550)
		local attacker = self.Owner
		dmginfo:SetAttacker( attacker )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage(300)
		local vel = tr.Entity:GetAbsVelocity()
		local pos = tr.Entity:GetPos()
		tr.Entity:TakeDamageInfo( dmginfo )
		vel = vel + ( tr.Entity:GetVelocity() - vel)
		tr.Entity:SetVelocity(-vel)
		if tr.Entity:GetClass() != "stand" and self.Owner:gStandsKeyDown("modifierkey1") then
			tr.Entity:SetVelocity(self.Stand:GetAngles():Forward() * 1550)
		elseif tr.Entity:GetClass() != "stand" then
			tr.Entity:SetVelocity(self.Stand:GetAngles():Forward() * 550)
		end
		if tr.Entity:GetClass() == "stand" and self.Owner:gStandsKeyDown("modifierkey1") then
			tr.Entity.Owner:SetVelocity(self.Stand:GetAngles():Forward() * 1550)
		elseif tr.Entity:GetClass() == "stand" then
			tr.Entity.Owner:SetVelocity(self.Stand:GetAngles():Forward() * 550)
		end
	end
	if tr.Hit and !((tr.Entity:IsPlayer() or tr.Entity:IsNPC())) then
		self.Stand:EmitSound( GetStandImpactSfx(tr.MatType) )
		local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(-self.Owner:GetAimVector())
		effectdata:SetFlags(1)
		if tr.Entity:GetClass() == "stand" then
			effectdata:SetFlags(2)
		end
		util.Effect("gstands_stand_impact", effectdata)
	end
	if ( SERVER && tr.Entity:IsValid( ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 15 * phys:GetMass(), tr.HitPos )
			local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			effectdata:SetFlags(1)
			
			if tr.Entity:GetClass() == "stand" then
				effectdata:SetFlags(2)
			end
			util.Effect("gstands_stand_impact", effectdata)
		end
	end
	if tr.Entity:IsPlayer() and !self.Owner.IsKnockedOut then
		tr.Entity:ViewPunch( Angle( math.random( -3, 3 ), math.random( -3, 3 ), math.random( -3, 3 ) ) )
		local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
		effectdata:SetAngles(tr.HitNormal:Angle())
		effectdata:SetFlags(3)
		effectdata:SetColor(0)
		effectdata:SetScale(6)
		util.Effect("bloodspray", effectdata)
		util.Effect("bloodimpact", effectdata)
	end
	if ( tr.HitWorld ) then
		if !self.Owner:OnGround() then
			self.Owner:SetVelocity( self.Owner:GetAimVector() * -(17.66 * self.Power) + Vector( 0, 0, (170.66 * self.Power) ) )
		end
	end
	self.Owner:LagCompensation( false )
end
function SWEP:KnifeThrow()
	if IsFirstTimePredicted() and self:Clip1() > 0 then
		if (SERVER) then
			self:SetHoldType( "pistol" )
			if SERVER then
				self.Stand:ResetSequence( self.Stand:LookupSequence( "SEQ_BATON_SWING" ) ) 
				self.Stand:SetCycle( 0 )
				self.Stand:SetPlaybackRate( 2.5 )
			end
			if SERVER and self:Clip1() > 0 then
				self:TakePrimaryAmmo(1)
				local bearing = ents.Create( "thrown_knife" )
					if IsValid(bearing) and IsValid(self.Stand) then
						bearing:SetAngles(self.Owner:EyeAngles() + Angle(0,0,math.Rand(0,360)))
						if GetConVar("gstands_time_stop"):GetBool() and self.Checkmate then
							self.Owner:EmitSound(Checkmate)
							self.Checkmate = false
						end
						local pos = (self.Stand:GetBonePosition(self.Stand:LookupBone("ValveBiped.Bip01_R_Hand"))  + Vector(math.random(-40,40), math.random(-10,10), math.random(-30,30)))
						bearing:SetPos(pos)
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
				timer.Simple(0.6, function()
					if IsValid(self) then
						self:SetHoldType( "stando" )
					end
				end)
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
	if SERVER and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	if self.roller and self.roller:IsValid() then
		self.roller:Remove()
	end
end
function SWEP:OnRemove()
	if GetConVar( "gstands_time_stop" ):GetInt() == 1 and IsValid(GetGlobalEntity( "Time Stop" )) then
		self:StartTime()
	end
	if SERVER and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	if IsValid(self.Owner) and timer.Exists("gstands_roadroller"..self.Owner:GetName()) then
		timer.Remove("gstands_roadroller"..self.Owner:GetName())
	end
	if self.roller and self.roller:IsValid() then
		self.roller:Remove()
	end
	return true
end
function SWEP:Holster()
	if SERVER and self.Stand:IsValid() then
		self.Stand:Remove()
		self.Owner:EmitStandSound(SDeploy)
	end
	self.Checkmate = true
	return true
end