
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot	  = 1
end

SWEP.Power= 2
SWEP.Speed = 1.25
SWEP.Range = 1500
SWEP.Durability = 1000
SWEP.Precision = A
SWEP.DevPos = A

SWEP.Author		= "Copper"
SWEP.Purpose	   = "#gstands.heg.purpose"
SWEP.Instructions  = "#gstands.heg.instructions"
SWEP.Spawnable	 = true
SWEP.Base		  = "weapon_fists"   
SWEP.Category	  = "gStands"
SWEP.PrintName	 = "#gstands.names.heg"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos			= 2
SWEP.DrawCrosshair	  = true

SWEP.WorldModel = "models/player/whitesnake/disc.mdl"
SWEP.ViewModelFOV   = 54
SWEP.UseHands	   = true

SWEP.Primary.ClipSize	   = -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic	  = true
SWEP.Primary.Ammo		   = "none"

SWEP.Secondary.ClipSize	 = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo		 = "none"

SWEP.DrawAmmo	   = true
SWEP.HitDistance	= 48
SWEP.ChargeStart = 0
SWEP.ChargeEnd = 0
SWEP.LatchedEnt = nil
SWEP.BarrierNum = 0
SWEP.BarrierList = {}
SWEP.BarrierAvg = Vector(0,0,0)
SWEP.Delay3 = 0
SWEP.WaxOn = false
SWEP.Range = 2500

SWEP.StandModel = "models/player/heg/heg.mdl"
SWEP.StandModelP = "models/player/heg/heg.mdl"
if CLIENT then
	SWEP.StandModel = "models/player/heg.mdl"
end
SWEP.gStands_IsThirdPerson = true



local Deploy = Sound("heg.deploy")
local SDeploy = Sound("weapons/hierophant/sdeploy.wav")
local Withdraw = Sound("weapons/hierophant/withdraw.wav")
local Splash = Sound("weapons/hierophant/splash.mp3")
local SplashQuick = Sound("heg.splashquick")
local SplashStart = Sound("heg.splashstart")
local SplashEnd = Sound("heg.splashend")
local Possess = Sound("weapons/hierophant/drip.wav")
local DripSmall = Sound("weapons/hierophant/dripsmall.wav")
local TwentSplash = Sound("heg.splashbig")
local Kekkai = Sound("heg.kekkai")
local Grapple = Sound("weapons/hierophant/grapple.mp3")
local Kurei = Sound("weapons/hierophant/kurei.wav")
local Ripout = Sound("weapons/hierophant/ripout.wav")
local Hmpf = Sound("heg.rero")
local NoOneCanDeflect = Sound("weapons/hierophant/noonecanjustdeflecttheemeraldsplash.wav")

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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= ACT_HL2MP_IDLE_SUITCASE
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= index + 3
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_signal_forward"))
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_signal_forward"))
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= index + 6
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= index + 6
		self.ActivityTranslate[ ACT_MP_JUMP ]						= ACT_HL2MP_JUMP_SLAM
		self.ActivityTranslate[ ACT_RANGE_ATTACK1 ]					= index + 8
		self.ActivityTranslate[ ACT_MP_SWIM ]						= index + 9
		else
		self.ActivityTranslate = {}
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= ACT_GMOD_SHOWOFF_STAND_02
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
	
	if CLIENT then
	end
	self:DrawShadow(false)
	
end

if CLIENT then
end

if SERVER then
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
	local postarget
	if self.GetPossessionTarget and IsValid(self:GetPossessionTarget()) then
		postarget = self:GetPossessionTarget()
		pos = self:GetPossessionTarget():EyePos()
	end
	local trace = util.TraceHull( {
		start = pos,
		endpos = pos - ang:Forward() * 100,
		filter = { ply:GetActiveWeapon(), ply, ply:GetVehicle(), postarget },
		mins = Vector( -4, -4, -4 ),
		maxs = Vector( 4, 4, 4 ),
	} )


	if ( trace.Hit ) then pos = trace.HitPos else pos = trace.HitPos end
	return pos + offset,ang
end
function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Stand")
	self:NetworkVar("Bool", 1, "AMode")
	self:NetworkVar("Bool", 2, "InRange")
	self:NetworkVar("Float", 3, "Delay2")
	self:NetworkVar("Bool", 4, "Ended")
	self:NetworkVar("Bool", 5, "Latched")
	self:NetworkVar("Vector", 6, "EndPos")
	self:NetworkVar("Vector", 7, "Normal")
	self:NetworkVar("Entity", 8, "PossessionTarget")
	self:NetworkVar("Int", 8, "BarrierCount")
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
		
		
		draw.TextShadow({
			text = self:GetBarrierCount(),
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
		surface.DrawRect(width - (56 * mult) - 32 * mult, height - (56 * mult) - 340 * mult, 40 * mult, math.Clamp(0, 40 * mult, math.Remap((CurTime() - self.ChargeStart), 0, 2, 0, 40 * mult)))
		surface.DrawTexturedRect(width - (64 * mult) - 32 * mult, height - (64 * mult) - 340 * mult, 64 * mult, 64 * mult)
		draw.TextShadow({
			text = "#gstands.heg.splash",
			font = "gStandsFont",
			pos = {width - 100 * mult, height - 390 * mult},
			color = tcolor,
			xalign = TEXT_ALIGN_RIGHT
		}, 2 * mult, 250)
		
	end
end
hook.Add( "HUDShouldDraw", "HierophantHud", function(elem)
	if IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_hierophant" and (elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") and GetConVar("gstands_draw_hud"):GetBool() and GetConVar("gstands_draw_hud"):GetBool() then
		return false
	end
end)
local material = Material( "vgui/hud/gstands_hud/crosshair" )
function SWEP:DoDrawCrosshair(x,y)
	if IsValid(self.Stand) then
		local tr = util.TraceLine( {
			start = self.Stand:WorldSpaceCenter(),
			endpos = self.Stand:WorldSpaceCenter() + self.Stand:GetAimVector() * 1500,
			filter = {self.Owner, self.Stand},
			mask = MASK_SHOT_HULL
		} )
		if self.GetPossessionTarget and IsValid(self:GetPossessionTarget()) then
			tr = util.TraceLine( {
				start = self:GetPossessionTarget():GetShootPos(),
				endpos = self:GetPossessionTarget():GetShootPos() + self:GetPossessionTarget():GetAimVector() * 1500,
				filter = {self.Owner, self.Stand, self:GetPossessionTarget()},
				mask = MASK_SHOT_HULL
			} )	
		end
		local pos = tr.HitPos
		
		local pos2d = pos:ToScreen()
		if pos2d.visible then
			surface.SetMaterial( material	)
			surface.SetDrawColor( gStands.GetStandColorTable(self.Stand:GetModel(), self.Stand:GetSkin()) )
			surface.DrawTexturedRect( pos2d.x - 8, pos2d.y - 8, 16, 16 )
		end
		if self.Owner:KeyDown(IN_ATTACK) and self:GetAMode() and self.WaxOn then
			local clr = gStands.GetStandColorTable(self.Stand:GetModel(), self.Stand:GetSkin())
			surface.DrawCircle(pos2d.x, pos2d.y, Lerp((CurTime() - self.ChargeStart)/2, 250, 55), clr.r, clr.g, clr.b, clr.a )
		end
		local pos = self.Stand:GetPos()
		local trD = util.TraceLine( {
			start = self.Stand:GetPos(),
			endpos = self.Stand:GetPos() - self.Stand:GetUp() * 100,
			filter = { self.Owner, self.Stand },
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
		if self.TentChargeStart then
			local norm = self.Owner:GetAimVector() * 300 * math.Clamp(CurTime() - self.TentChargeStart, 0, 5)
			norm.z = 0
			pos = trD.HitPos + norm
			pos.z = self.Owner:GetPos().z - 5
			local pos2d = pos:ToScreen()
			if self.Owner:KeyDown(IN_ATTACK2) and !self:GetAMode() then
				surface.SetDrawColor( gStands.GetStandColorTable(self.Stand:GetModel(), self.Stand:GetSkin()) )
				if util.PointContents(pos) != CONTENTS_SOLID then
					local clr = gStands.GetStandColorTable(self.Stand:GetModel(), self.Stand:GetSkin())
					local h,s,v = ColorToHSV(clr)
					h = h + 180
					clr = HSVToColor(h,s,v)
					surface.SetDrawColor( clr )
				end
				surface.DrawTexturedRect( pos2d.x - 16, pos2d.y - 16, 32, 32 )
			end
		end
		
		return true
	end
end

function SWEP:Deploy()
	self:SetHoldType( "stando")
	
	
	if self.Owner:Health() == 100  then
		self.Owner:SetMaxHealth( self.Durability )
		self.Owner:SetHealth( self.Durability )
	end
	
	
	self:DefineStand()
	
	self.Owner:SetCanZoom(true)
	if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitSound(Deploy)
			self.Owner:EmitStandSound(SDeploy)
		end
	end
	local hooktag = self.Owner:EntIndex()
	hook.Add("StartCommand", "HierophantGreenPossession"..hooktag, function(ply, cmd)
		if IsValid(self) and IsValid(self.Owner) then 
			if ply == self.Owner then
				self.CMD = {
					cmd:GetForwardMove(),
					cmd:GetSideMove(),
					cmd:GetUpMove(),
					cmd:GetViewAngles(),
					cmd:GetButtons()
				}
			end
			if ply == self:GetPossessionTarget() then
				cmd:SetForwardMove(self.CMD[1])
				cmd:SetSideMove(self.CMD[2])
				cmd:SetUpMove(self.CMD[3])
				cmd:SetViewAngles(self.CMD[4])
				if !IsPlayerStandUser(ply) then
					cmd:SetButtons(self.CMD[5])
				end
			end
			else
			hook.Remove("StartCommand", "HierophantGreenPossession"..hooktag)
		end
	end)
	hook.Add("EntityTakeDamage", "BreakPossession"..hooktag, function(ent, dmg)
		if IsValid(self) and IsValid(self.Owner) then 
			if ent == self:GetPossessionTarget() and dmg:GetDamage() >= 50 then
				self:DePossess()
			end
			else
			hook.Remove("StartCommand", "HierophantGreenPossession"..hooktag)
		end
	end)
end
local HoldPunch = false

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
		self.Stand:ResetSequence(self.Stand:LookupSequence("standdeploy"))
		self.Stand.AnimDelay = CurTime() + self.Stand:SequenceDuration()
		self.Stand.AnimSet = {
			"SWIMMING_all", 0,
			"GMOD_BREATH_LAYER", 1,
			"AIMLAYER_CAMERA", 0,
			"IDLE", 0,
			"FIST_BLOCK", 0,
		}
		
		self.Stand:Spawn()
	end
	
end

function SWEP:Think()
	self.Stand = self:GetStand()
	if !self.Stand:IsValid() then
		self:DefineStand()
	end
	if SERVER and self.GetStand and self:GetStand().GetInDoDoDo and self:GetStand():GetInDoDoDo() then
		self.Menacing = self.Menacing or CurTime()
		if CurTime() > self.Menacing then
			self.Menacing = CurTime() + 0.5
			local effectdata = EffectData()
			effectdata:SetStart(self.Owner:GetPos())
			effectdata:SetOrigin(self.Owner:GetPos())
			effectdata:SetEntity(self.Owner)
			util.Effect("menacing", effectdata)
		end
		if !IsValid(self:GetPossessionTarget()) then
			local tr = util.TraceEntity({ 
				start = self.Stand:GetPos(),
				endpos = self.Stand:GetPos(),
				mask = MASK_SHOT_HULL,
				filter = {self, self.Owner, self.Stand}
			}, self.Stand)
			if IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity:GetForward():Dot(self.Stand:GetForward()) >= 0.5 then
				self:Possess(tr.Entity)
			end
		end
		elseif SERVER and IsValid(self:GetPossessionTarget()) then
		self:DePossess()
	end
	if SERVER and IsValid(self:GetPossessionTarget()) and (self:GetPossessionTarget():GetPos():Distance(self.Owner:GetPos()) >= self.Range or !self:GetPossessionTarget():Alive() or (IsValid(self:GetPossessionTarget():GetActiveWeapon()) and self:GetPossessionTarget():GetActiveWeapon().GetActive and self:GetPossessionTarget():GetActiveWeapon():GetActive())) then
		self:DePossess(true)
	end
	if IsValid(self:GetPossessionTarget()) and self.GetStand and self:GetStand().GetInDoDoDo and self:GetStand():GetInDoDoDo() then
		self.Stand:SetFrozen(true)
		self.Stand:SetPos(self:GetPossessionTarget():GetPos())
		self.Stand:SetIdealPos(self:GetPossessionTarget():GetPos())
		self.Stand:SetNoDraw(true)
		self.Stand:SetNotSolid(true)
		self.Stand:SetAngles(self:GetPossessionTarget():EyeAngles())
		self:NextThink(CurTime())
		return true
	end
	if self.Owner:KeyPressed(IN_ATTACK) and self:GetAMode() and CurTime() > self.Delay3 and self.ChargeStart != CurTime() then
		self.WaxOn = true
		self.SoundStarted = false
		self.ChargeStart = CurTime()
		self:SetHoldType("pistol")
		if SERVER then
			self.Stand:ResetSequence(self.Stand:LookupSequence("splash_charge"))
			self.Stand:SetCycle(0)
			self.Stand:SetPlaybackRate(1)
			timer.Simple(self.Stand:SequenceDuration()/3, function()
				if IsValid(self.Stand) then self.Stand:SetBodygroup(2,1) end
			end)
			timer.Simple(self.Stand:SequenceDuration(), function() 
				if IsValid(self.Stand) and self.WaxOn then 
					self.Stand:ResetSequence(self.Stand:LookupSequence("splash_idle")) 
					self.Stand:SetCycle(0)
					self.Stand:SetPlaybackRate(1)
				end 
			end)
			self.Stand:EmitStandSound(Possess, 75, 100, 0.5)
		end
	end
	self.TentTimer = self.TentTimer or CurTime()
	if !self.Owner:KeyDown(IN_ZOOM) and self.Owner:KeyPressed(IN_ATTACK2) and !self:GetAMode() and self.TentChargeStart != CurTime() and !self.Owner:gStandsKeyDown("modifierkey2") then
		self.TentChargeStart = CurTime()
		if SERVER  and CurTime() >= self.TentTimer then
			self.Stand:EmitStandSound(Possess)
		end
	end
	if !self.Owner:KeyDown(IN_ZOOM) and self.Owner:KeyReleased(IN_ATTACK2) and !self:GetAMode() and self.TentChargeStart != CurTime() and CurTime() >= self.TentTimer and !self.Owner:gStandsKeyDown("modifierkey2") then
		self:Stab(CurTime() - self.TentChargeStart)
		self.TentTimer = CurTime() + 1
		if SERVER then
			self.Owner:EmitSound(Kurei)
		end
	end
	if !self.Owner:KeyDown(IN_ZOOM) and self.WaxOn and (self.Owner:KeyReleased(IN_ATTACK)) and self:GetAMode() and CurTime() > self.Delay3 then
		self.Delay3 = CurTime() + 2
		if SERVER then
			if self.SoundStarted then
				self.Owner:StopSound(TwentSplash)
				self.Owner:StopSound(SplashQuick)
				self.Owner:StopSound(SplashStart)
				self.Owner:EmitSound(SplashEnd)
				else
				self.Owner:StopSound(TwentSplash)
				self.Owner:StopSound(SplashEnd)
				self.Owner:StopSound(SplashStart)
				self.Owner:EmitSound(SplashQuick)
			end
			self.Owner:EmitStandSound(Splash)
		end
		timer.Remove("emeraldsplashdrip")
		self.ChargeEnd = CurTime()
		if self.Owner:gStandsKeyDown("modifierkey1") then
			self:Splash(true)
			else
			self:Splash(false)
		end
		if SERVER then
			self.Stand:ResetSequence(self.Stand:LookupSequence("splash_release"))
			self.Stand:SetCycle(0)
			self.Stand:SetPlaybackRate(1)
			timer.Simple(self.Stand:SequenceDuration()/1.1, function()
				if IsValid(self.Stand) then self.Stand:SetBodygroup(2,0) end
			end)
			timer.Simple(self.Stand:SequenceDuration(), function()
				if IsValid(self) then
					
					self:SetHoldType("stando")
				end
			end)
		end
		self:SetHoldType("pistol")
		self.WaxOn = false
	end
	if !self.Owner:KeyDown(IN_ZOOM) and CurTime() - self.ChargeStart >= 0.3 and !self.SoundStarted and self.WaxOn and SERVER then
		self.Owner:EmitSound(SplashStart)
		self.SoundStarted = true
	end
	
	if !self.Owner:KeyDown(IN_ZOOM) and ( self.Owner:KeyPressed( IN_ATTACK ) ) and !self:GetAMode() and CurTime() > self:GetDelay2() then
		self:StartAttack()
		elseif !self.Owner:KeyDown(IN_ZOOM) and ( self.Stand != nil and self.Owner:KeyDown( IN_ATTACK ) && self:GetInRange() && !self:GetEnded()) and !self:GetAMode() then
		self:UpdateAttack()
		self.speed = self.speed + 150
		elseif !self.Owner:KeyDown(IN_ZOOM) and (( self.Owner:KeyReleased( IN_ATTACK ) && self:GetInRange()) or self:GetAMode()) and CurTime() > self:GetDelay2() then
		self:EndAttack()
		self:SetNextPrimaryFire( CurTime() + (0.01) )
	end
	self.Delay4 = self.Delay4 or CurTime()
	if !self.Owner:KeyDown(IN_ZOOM) and ( self.Owner:gStandsKeyDown( "modifierkey1" ) and self.Owner:KeyDown(IN_ATTACK2) ) and self:GetAMode() and CurTime() > self.Delay4 then
		self:BigSplash()
		self.Delay4 = CurTime() + 4
	end
	if !self.Owner:KeyDown(IN_ZOOM) and self.LatchedEnt and self.LatchedEnt:IsValid() and ((self.LatchedEnt:GetActiveWeapon().GetActive and self.LatchedEnt:GetActiveWeapon():GetActive()) or !self.LatchedEnt:Alive()) then
		self:EndAttack(true)
	end
	local m = 0
	local TBR = {}
	for k,v in pairs(self.BarrierList) do
		if !IsValid(v) then
			table.remove(self.BarrierList, k)
		end
	end
	if SERVER then
		self:SetBarrierCount(#self.BarrierList)
	end
	self.TauntTimer = self.TauntTimer or CurTime()
	if self.Owner:gStandsKeyDown("taunt") and CurTime() >= self.TauntTimer then
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		if SERVER then
			self.Owner:EmitSound(Hmpf)
		end
		self.TauntTimer = CurTime() + 1
	end
	
	self.DelayR = self.DelayR or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("modeswap") and CurTime() > self.DelayR then
		
		self.DelayR = CurTime() + 1
		
		self:SetAMode(!self:GetAMode())
		
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
	if SERVER and self.Owner:gStandsKeyDown("block") and CurTime() > self.StandBlockTimer then
		self.Stand.HeadRotOffset = -5
		self:SetHoldType("pistol")
		self.Stand:ResetSequence(self.Stand:LookupSequence( "standblock" ))
		self.Stand:SetCycle(0)
		--self.Stand:EmitStandSound(Huagh)
		timer.Simple(self.Stand:SequenceDuration("standblock"), function() self:SetHoldType("stando") self.Stand.HeadRotOffset = -75 end)
		self.StandBlockTimer = CurTime() + self.Stand:SequenceDuration("standblock") + 0.5
	end
	self:NextThink(CurTime())
	return true
end

function SWEP:PrimaryAttack()
	
	if (self:GetAMode()) then
		self:SetNextPrimaryFire( CurTime() + 1 )
		else
		
	end
end


function SWEP:SecondaryAttack()
	if !self.Owner:gStandsKeyDown("modifierkey1") and (self:GetAMode()) then
		local tr = util.TraceLine( {
			start = self.Stand:GetEyePos(),
			endpos = self.Stand:GetEyePos() + self.Stand:GetAimVector() * self.Range, 
			filter = {self, self.Owner, self.Stand},
			ignoreworld = false,
			mask = MASK_SOLID,
			collisiongroup = COLLISION_GROUP_DEBRIS
		} )
		if tr.Hit then
			self:Barrier(tr)
		end
		self:SetNextSecondaryFire(CurTime() + 0.6)
		else
	end
end
function SWEP:Possess(ent)
	self:SetPossessionTarget(ent)
	if SERVER then
		self.Stand:EmitStandSound(Possess)
	end
end
function SWEP:DePossess(soft)
	if IsValid(self:GetPossessionTarget()) then
		local ent = self:GetPossessionTarget()
		self:SetPossessionTarget(NULL)
		self.Stand:SetFrozen(false)
		self.Stand:SetNoDraw(false)
		self.Stand:SetNotSolid(false)
		if !soft then
			local dmginfo = DamageInfo()
			local attacker = self.Owner
			if ( !IsValid( attacker ) ) then attacker = self end
			dmginfo:SetAttacker( attacker )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( 50 )
			ent:TakeDamageInfo(dmginfo)
		end
		if SERVER then
			self.Stand:EmitStandSound(Ripout)
		end
	end
end
function SWEP:Splash(quick)
	if (SERVER) then
		local Spread = math.Clamp(self.ChargeEnd - self.ChargeStart, 0, 2)
		timer.Create("splash", 0.005, 10, function()
			
			Spread = Spread / 1.2
			local pos = self.Stand:GetAttachment(self.Stand:LookupAttachment("anim_attachment_rh")).Pos - self.Stand:GetForward() * 25
			local iter = 3
			for i = 0, 3 do
				local laser = ents.Create("emerald_splash_proj")
				if IsValid(laser) then
					laser.quick = quick
					laser:SetPos(pos )
					laser:SetOwner(self.Owner)
					laser.Owner = self.Owner
					laser.wep = self
					local ang = (self.Stand:GetAimVector() * 500 + (VectorRand() * 15) / Spread):GetNormalized():Angle()
					laser:SetAngles(ang)
					laser:Spawn()
					laser:Activate()
				end
			end
		end)
	end
end

function SWEP:Stab(length)
	if (SERVER) then
		length = math.Clamp(length, 0, 5)
		local pos = self.Stand:GetPos()
		local trD = util.TraceLine( {
			start = self.Stand:GetPos(),
			endpos = self.Stand:GetPos() - self.Stand:GetUp() * 100,
			filter = { self.Owner, self.Stand },
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
		
		local norm = self.Owner:GetAimVector() * 300 * length
		norm.z = 0
		pos = trD.HitPos + norm
		pos.z = self.Owner:GetPos().z - 5
		if trD.HitWorld and ( util.PointContents(pos) == CONTENTS_SOLID )then
			local laser = ents.Create("heg_attack")
			if IsValid(laser) then
				laser.quick = quick
				laser:SetPos(pos)
				laser:SetOwner(self.Owner)
				laser:Spawn()
				laser:Activate()
			end
		end
	end
end

function SWEP:Reload()
	
end

function SWEP:BigSplash()
	local tr = util.TraceLine( {
		start = self.Stand:WorldSpaceCenter(),
		endpos = self.Stand:WorldSpaceCenter() + self.Stand:GetAimVector() * 1500,
		filter = { self.Owner, self.Stand },
		mask = MASK_ALL
	} )
	for k,v in pairs(self.BarrierList) do
		if IsValid(v) then
			v:Splash(tr, 0, true)
		end
	end
	if SERVER then
		self.Owner:StopSound(SplashQuick)
		self.Owner:StopSound(SplashEnd)
		self.Owner:StopSound(SplashStart)
		self.Owner:EmitSound(TwentSplash)
	end
end

function SWEP:Barrier( trace, quick )
	quick = quick or false
	if CLIENT then
		self.Stand:EmitStandSound(DripSmall, 75, math.random(95,105))
	end
	if SERVER and trace then
		if #self.BarrierList < 1 then
			self.Owner:EmitSound(Kekkai)
		end
		local bar = ents.Create("hg_barrier")
		table.insert(self.BarrierList, bar)
		bar.quick = quick
		bar:SetPos(trace.HitPos)
		bar:SetAngles(trace.Normal:Angle())
		bar:SetOwner(self.Owner)
		local pos = bar:GetPos()
		if IsValid(self.BarrierList[#self.BarrierList - 1]) then
			pos = self.BarrierList[#self.BarrierList - 1]:GetPos()
		end
		bar:SetEndPos(pos)
		bar:Spawn()
	end
	
end

function SWEP:DoTrace( endpos )
	local trace = {
		start = self.Stand:GetEyePos(),
		endpos = self.Stand:GetEyePos() + (self.Stand:GetAimVector() * 1500),
		filter = { self.Owner, self, self.Stand},
		mask = MASK_SHOT_HULL,
	}
	if endpos then 
		trace.endpos = endpos - self.HEGTrace.HitNormal * 7
	end
	if self.Owner:gStandsKeyDown("modifierkey2") then
		trace.endpos = trace.start
		local cmins, cmaxs = self.Owner:GetCollisionBounds()
		cmins.x = cmins.x * 4
		cmins.y = cmins.y * 4
		cmaxs.x = cmaxs.x * 4
		cmaxs.y = cmaxs.y * 4
		trace.mins = cmins
		trace.maxs = cmaxs
		trace.ignoreworld = true
		self.HEGTrace = nil
		self.HEGTrace = util.TraceHull( trace )
		else
		self.HEGTrace = nil
		self.HEGTrace = util.TraceLine( trace )
	end
end

function SWEP:StartAttack()
	self:SetLatched( false)
	self:SetInRange( false)
	self:DoTrace()
	if self.HEGTrace and self.HEGTrace.Hit then
		self:SetInRange( true)
		self.startTime = CurTime()
		self.speed = 5
		self.dat = 5
		if SERVER then
			if SERVER and self.Stand then
				self.Stand:SetHEGEndPos( LerpVector(self.dat, self.Stand:GetPos(), self.HEGTrace.HitPos ) )
				self.Stand:SetBodygroup( 1, 1 )
				self:SetEndPos(self.HEGTrace.HitPos)
			end
		end
		
		local dmginfo = DamageInfo()
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 5 )
		
		if SERVER and IsValid(self.HEGTrace.Entity) and (self.HEGTrace.Entity:IsPlayer() or self.HEGTrace.Entity:IsNPC() or self.HEGTrace.Entity:IsStand()) and self.HEGTrace.Entity:Health() then
			if self.HEGTrace.Entity:IsStand() then
				self.HEGTrace.Entity.LastSpeed = self.HEGTrace.Entity.Speed
				self.HEGTrace.Entity.Speed = self.HEGTrace.Entity.Speed/5
			end
			self:SetLatched(true)
			self.HEGTrace.Entity:TakeDamageInfo( dmginfo )
		end
		local phys
		if IsValid(self.HEGTrace.Entity) then
			phys = self.HEGTrace.Entity:GetPhysicsObject()
		end
		if SERVER and ( IsValid( phys ) and !self.HEGTrace.Entity:IsVehicle() and !self.HEGTrace.Entity.PhysgunDisabled and self.HEGTrace.Entity:GetMoveType() == MOVETYPE_VPHYSICS) and phys:GetMass() <= 800 then
			self:SetLatched(true)
		end
		
		if self.HEGTrace.Entity:IsPlayer() then 
			self.HEGTrace.Entity:SetVelocity( -(self.HEGTrace.Normal * 500) + Vector( 0, 0, 200 ) )
		end
		if SERVER then
			self.Owner:EmitStandSound(Grapple)
		end
	end
	if self:GetInRange() then
		if SERVER then
			self.Owner:EmitStandSound(Grapple)
		end
	end
	self:SetEnded( false)
end

function SWEP:UpdateAttack()
	local endpos = self.HEGTrace.HitPos
	local vVel = (endpos - self.Owner:GetPos() )
	local Distance = endpos:Distance(self.Owner:GetPos() )
	if self:GetLatched() and (!IsValid(self.HEGTrace.Entity) or (self.HEGTrace.Entity:IsPlayer() and !self.HEGTrace.Entity:Alive() ))then
		self:EndAttack()
		self:SetEnded( true )
	end
	local et = (self.startTime + ( Distance / self.speed) )
	if self.dat != 0 then
		self.dat = (et - CurTime() ) / (et - self.startTime)
	end
	if self.dat < 0 then
		self.dat = 0
	end
	if self.HEGTrace.HitPos != self.Stand:GetHEGEndPos() then
		self.Stand:SetHEGEndPos(LerpVector(self.dat,  self.HEGTrace.HitPos, self.Stand:GetPos()))
	end
	if !self:GetLatched() then
		if self.dat == 0 then
			zVel = self.Owner:GetVelocity().z
			vVel = vVel:GetNormalized() * (math.Clamp(Distance,0,35) )
			if( SERVER ) then
				local gravity = GetConVar("sv_gravity"):GetFloat()
				vVel:Add(Vector( 0, 0, ( gravity / 100) * 1.2 ) )
				self.Owner:SetVelocity(vVel)
				self:SetNormal((self.Owner:GetPos() - endpos):GetNormalized())
			end
		end
	end
	
	if IsValid(self.HEGTrace.Entity) and !self.HEGTrace.HitWorld then
		self.HEGTrace.HitPos = self.HEGTrace.Entity:WorldSpaceCenter()
		if IsValid(self.Stand) then
			self.Stand:SetHEGEndPos(self.HEGTrace.Entity:WorldSpaceCenter() )
		end
		if self.HEGTrace.Entity:IsVehicle() then
			local a = self.Owner:EyeAngles()
			local b = self.HEGTrace.Entity:GetForward():Angle()
			local c = (a - b)
			c:Normalize()
			local d = math.Clamp(math.Remap( (c.y), -90, 90, 1, -1), -1, 1)
			self.HEGTrace.Entity:SetSteering(d, 0)
			
			if self.Owner:KeyDown(IN_SPEED) then
				self.HEGTrace.Entity:EnableEngine(true)
				self.HEGTrace.Entity:StartEngine(true)
				self.HEGTrace.Entity:SetBoost(1000)
			end
			if self.Owner:KeyDown(IN_DUCK) then
				self.HEGTrace.Entity:SetHandbrake(true)
			end
		end
		
	end
	if self:GetLatched() and IsValid(self.HEGTrace.Entity) then
		local dist = self.HEGTrace.Entity:WorldSpaceCenter():Distance(self.Owner:GetPos() )
		if dist >= self.Range then
			self:EndAttack()
			self:SetEnded(true)
		end
		local phys = self.HEGTrace.Entity:GetPhysicsObject()
		if SERVER and ( IsValid( phys ) and !self.HEGTrace.Entity:IsVehicle() and !self.HEGTrace.Entity.PhysgunDisabled and self.HEGTrace.Entity:GetMoveType() == MOVETYPE_VPHYSICS ) then
			local ShadowParams = {}
			ShadowParams.secondstoarrive = 1 
			if self.Owner:gStandsKeyDown("modifierkey2") then
				self.ShadowPos = self.ShadowPos or phys:GetPos()
				ShadowParams.pos = self.ShadowPos
				else
				self.ShadowPos = nil
				ShadowParams.pos = self.Stand:WorldSpaceCenter() + self.Stand:GetForward() * 155
			end
			ShadowParams.angle = self.Owner:EyeAngles()
			ShadowParams.maxangular = 1000
			ShadowParams.maxangulardamp = 10000 
			ShadowParams.maxspeed = 1000
			ShadowParams.maxspeeddamp = 10000
			ShadowParams.dampfactor = 0.1
			ShadowParams.teleportdistance = 0
			ShadowParams.deltatime = FrameTime()
			phys:Wake()
			phys:EnableMotion(true)
			phys:ComputeShadowControl( ShadowParams )
		end
	end
	if Distance > self.Range then
		self:EndAttack()
		self:SetEnded( true)
	end
end

function SWEP:EndAttack()
	if self.HEGTrace and IsValid(self.HEGTrace.Entity) then
		local phys = self.HEGTrace.Entity:GetPhysicsObject()
		if self.HEGTrace.Entity.LastSpeed then
			self.HEGTrace.Entity.Speed = self.HEGTrace.Entity.LastSpeed
		end
	end
	
	if IsValid(self.Stand) then
		self.Stand:SetBodygroup( 1, 0 )
	end
end	


function SWEP:OnDrop()
	if SERVER then
		for k,v in pairs(self.BarrierList) do
			v:Remove()
		end
		self.BarrierList = {}
		self.BarrierNum = 0
		self.BarrierAvg = Vector(0,0,0)
	end
	self:EndAttack()
	if self.Owner and IsValid(self.Stand) then
		self.Stand:Withdraw()
	end
	self:DePossess()
	return true
end

function SWEP:OnRemove()
	if SERVER then
		for k,v in pairs(self.BarrierList) do
			v:Remove()
		end
		self.BarrierList = {}
		self.BarrierNum = 0
		self.BarrierAvg = Vector(0,0,0)
	end
	self:EndAttack()
	if self.Owner and IsValid(self.Stand) then
		self.Stand:Withdraw()
	end
	self:DePossess()
	return true
end

function SWEP:Holster()
	if SERVER and self.Owner and IsValid(self.Stand) then
		if self.Owner:Alive() then
			self.Stand:EmitStandSound(Withdraw)
		end
		self.Stand:Withdraw()
	end
	if SERVER then
		for k,v in pairs(self.BarrierList) do
			if v:IsValid() then
				v:Remove()
			end
		end
	end
	self.BarrierList = {}
	self.BarrierNum = 0
	self.BarrierAvg = Vector(0,0,0)
	
	self:EndAttack()
	self:DePossess()
	return true
end