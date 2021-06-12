
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot	  				= 1
end

SWEP.Power 						= 1.5
SWEP.Speed 						= 0.75
SWEP.Range 						= 500
SWEP.Durability 				= 1000
SWEP.Precision 					= D
SWEP.DevPos 					= E

SWEP.Author						= "Copper"
SWEP.Purpose	   				= "#gstands.mgr.purpose"
SWEP.Instructions  				= "#gstands.mgr.instructions"
SWEP.Spawnable	 				= true
SWEP.Base		  				= "weapon_fists"   
SWEP.Category	  				= "gStands"
SWEP.PrintName	 				= "#gstands.names.mgr"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos					= 2
SWEP.DrawCrosshair	  		= true

SWEP.WorldModel 				= "models/player/whitesnake/disc.mdl"
SWEP.ViewModelFOV   			= 54
SWEP.UseHands	   			= true

SWEP.Primary.ClipSize	   	= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic	  	= true
SWEP.Primary.Ammo		   	= "none"

SWEP.Secondary.ClipSize	 	= -1
SWEP.Secondary.DefaultClip  	= -1
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo		 	= "none"

SWEP.DrawAmmo	   			= false
SWEP.HitDistance				= 55
SWEP.TimeStopped				= false

SWEP.StartCharge				= 0
SWEP.LifeDetector				= NULL
SWEP.StandModel 				= "models/player/mgr/mgr.mdl"
SWEP.StandModelP 				= "models/player/mgr/mgr.mdl"
if CLIENT then
	SWEP.StandModel = "models/player/mgr.mdl"
end
SWEP.gStands_IsThirdPerson = true

local HitSound 					= Sound( "platinum.hit" )
local SwingSound 				= Sound( "WeaponFrag.Throw" )

local Flame 					= Sound("ambient/fire/fire_big_loop1.wav")
local CFHurric 					= Sound("mgr.cfhurric")
local Deploy 					= Sound("mgr.deploy")
local RedBind 					= Sound("mgr.redbind")
local Whip 						= Sound("mgr.whip")
local tsk 						= Sound("mgr.tsktsk")
local NoForgive 				= Sound("weapons/mgr/no_forgive.wav")
local Mun 						= Sound("weapons/mgr/mu-n.wav")
local SDeploy1 					= Sound("weapons/mgr/sdeploy1.wav")
local SDeploy2 					= Sound("weapons/mgr/sdeploy2.wav")
local Withdraw 					= Sound("weapons/mgr/withdraw.wav")
local Screech 					= Sound("mgr.screech")
local Crack 					= Sound("mgr.crack")
local Explosive 				= Sound("mgr.explosive")

game.AddParticles("particles/mgrtrail.pcf")
game.AddParticles("particles/mgrthrow.pcf")

PrecacheParticleSystem("mgrtrails")
PrecacheParticleSystem("cfh")
PrecacheParticleSystem("mgrflamefull")
PrecacheParticleSystem("flameexplode")
PrecacheParticleSystem("mgrtraillifedetect")
PrecacheParticleSystem("mgr_redbind")
PrecacheParticleSystem("ambientheat")
PrecacheParticleSystem("cfhcharge")
PrecacheParticleSystem("flameshield")


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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= ACT_HL2MP_IDLE_MAGIC
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_01"))
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_disagree"))
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_disagree"))
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_signal_group"))
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_signal_group"))
		self.ActivityTranslate[ ACT_MP_JUMP ]						= ACT_HL2MP_JUMP_MAGIC
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
			text = self:GetBombs(),
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
		surface.DrawRect(width - (56 * mult) - 32 * mult, height - (56 * mult) - 340 * mult, 40 * mult, math.Clamp(0, 40 * mult, math.Remap(CurTime() - self.StartCharge, 0, 3, 0, 40 * mult)))
		surface.DrawTexturedRect(width - (64 * mult) - 32 * mult, height - (64 * mult) - 340 * mult, 64 * mult, 64 * mult)
		draw.TextShadow({
			text = "#gstands.mgr.cfhr",
			font = "gStandsFont",
			pos = {width - 100 * mult, height - 390 * mult},
			color = tcolor,
			xalign = TEXT_ALIGN_RIGHT
		}, 2 * mult, 250)
		
		surface.SetMaterial(cooldown_box)
		surface.DrawRect(width - (56 * mult) - 32 * mult, height - (56 * mult) - 440 * mult, 40 * mult, math.Clamp(0, 40 * mult, math.Remap((self:GetFlamePower()), 0, 5, 0, 40 * mult)))
		surface.DrawTexturedRect(width - (64 * mult) - 32 * mult, height - (64 * mult) - 440 * mult, 64 * mult, 64 * mult)
		draw.TextShadow({
			text = "#gstands.mgr.flame",
			font = "gStandsFont",
			pos = {width - 100 * mult, height - 490 * mult},
			color = tcolor,
			xalign = TEXT_ALIGN_RIGHT
		}, 2 * mult, 250)
		
	end
end
hook.Add( "HUDShouldDraw", "MagiciansRedHud", function(elem)
	if IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_magicians_red" and (elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") and GetConVar("gstands_draw_hud"):GetBool() and GetConVar("gstands_draw_hud"):GetBool() then
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

function SWEP:Initialize()
	self:DrawShadow(false)
end

function SWEP:DrawWorldModel()
	if IsValid(self.Owner) then
		if self:GetFlaming() and IsValid(self:GetStand()) then
			if !self.Flames then
				self.Flames = CreateParticleSystem(self:GetStand(), "mgrflamefull", PATTACH_POINT, 1)
			end
			if self.Flames and IsValid(self:GetStand()) and self:GetStand():GetAttachment(1).Pos then
				self.Flames:SetControlPoint(1, gStands.GetStandColor(self:GetStand():GetModel(), self:GetStand():GetSkin()))
				self.Flames:SetControlPoint(0, self:GetStand():GetAttachment(1).Pos)
				self.Flames:SetControlPoint(2, Vector(self:GetFlamePower(),0,0))
				self.Flames:SetControlPointForwardVector(0, self:GetStand():GetForward())
			end
			else
			if self.Flames then
				self.Flames:StopEmission()
				self.Flames = nil
			end
		end
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
function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Stand")
	self:NetworkVar("Entity", 1, "Aim")
	self:NetworkVar("Bool", 2, "AMode")
	self:NetworkVar("Bool", 3, "InRange")
	self:NetworkVar("Float", 1, "Delay2")
	self:NetworkVar("Bool", 4, "Ended")
	self:NetworkVar("Bool", 5, "Flaming")
	self:NetworkVar("Int", 6, "Bombs")
	self:NetworkVar("Float", 2, "FlamePower")
end

function SWEP:Deploy()
	self:SetHoldType( "stando" )
	
	if self.Owner:Health() == 100 then
		self.Owner:SetMaxHealth( self.Durability )
		self.Owner:SetHealth( self.Durability )
	end
	
	self:DefineStand()
	
	if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitSound(Deploy)
		end
	end
	
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
		self.Stand:Spawn()
		self.Owner:EmitStandSound(SDeploy1)
		timer.Simple(0.2, function()
			self.Stand:EmitStandSound(SDeploy2)
		end)
		self.Stand:ResetSequence(self.Stand:LookupSequence("standdeploy"))
		self.Stand.AnimDelay = CurTime() + self.Stand:SequenceDuration()
		self.Stand.AnimSet = {
			"SWIMMING_MAGIC", 0,
			"GMOD_BREATH_LAYER", 1,
			"AIMLAYER_CAMERA", 0,
			"IDLE_ALL_ANGRY", 0,
			"FIST_BLOCK", 0,
		}
		timer.Simple(0, function()
			local effectdata = EffectData()
			effectdata:SetEntity(self.Stand)
			effectdata:SetFlags(15)
			util.Effect("gstands_mgrflames", effectdata)
		end)
		self.Stand.Range = self.Range
		self.Stand.Speed = 20*self.Speed
		self.Stand.Ignite = function() return end
		self.Stand.HeadRotOffset = -75
	end
end

function SWEP:Think()
	self.Stand = self:GetStand()
	if !self.Stand:IsValid() then
		self:DefineStand()
		self.Flames = nil
	end
	self.FlameStartTime = self.FlameStartTime or 0
	if SERVER and self:GetAMode() and self.Owner:KeyPressed(IN_ATTACK) then
		if SERVER then
			self.Stand:EmitStandSound(Screech)
			self.Stand:EmitStandSound(Crack)
		end
		self.Stand:ResetSequence(self.Stand:LookupSequence("flame_start"))
		self.Flame = CreateSound(self.Stand, Flame)
		self.Flame:Play()
		self.Flame:ChangeVolume(100)
		self:SetFlaming(true)
		self:SetHoldType("pistol")
		self:SetFlamePower(math.max(0, self:GetFlamePower() - 0.1))
		self.Stand.HeadRotOffset = 0
	end
	if SERVER and not self:GetFlaming() then
		self:SetFlamePower(math.min(5, self:GetFlamePower() + 0.01))
	end
	if SERVER and self:GetFlaming() then
		self:SetFlamePower(math.max(0, self:GetFlamePower() - 0.01))
	end
	if SERVER and self:GetAMode() and self.Owner:KeyReleased(IN_ATTACK) then
		self:SetHoldType("stando")
		self.Flame:Stop()
		self.Flame:Stop()
		self:SetFlaming(false)
		self.Stand.HeadRotOffset = -75
	end
	
	self.LastInRoom = self.LastInRoom or false
	local ent = self:GetStand()
	if IsValid(ent) then
		local pos = ent:WorldSpaceCenter()
		local mult = 1055
		local tr = {}
		local mods = {
			ent:GetUp() * mult,
			-(ent:GetUp() * mult),
		}
		local InRoom = true
		for i = 1,2 do
			tr[i] = util.TraceLine( {
				start = pos,
				endpos = pos + mods[i],
				filter = {ent, self.Owner},
				mask = MASK_SHOT_HULL,
				collisiongroup = COLLISION_GROUP_DEBRIS
			} )
			if !tr[i].Hit or tr[i].StartSolid then
				InRoom = false
			end
		end
		
		if self.LastInRoom ~= InRoom then
			if InRoom then
				ParticleEffectAttach("ambientheat", PATTACH_POINT_FOLLOW, self.Stand, 1)
				else
				self.Stand:StopParticles()
			end
		end
		if InRoom then
			for k,v in pairs(ents.FindInSphere(self:GetStand():GetPos(), 500)) do
				if v:IsPlayer() or v:IsNPC() then
					local trp = util.TraceLine( {
						start = self:GetStand():WorldSpaceCenter(),
						endpos = self:GetStand():WorldSpaceCenter() + (v:WorldSpaceCenter() - self:GetStand():WorldSpaceCenter()):GetNormalized() * 550,
						filter = {self.Owner, self:GetStand()},
						mask = MASK_SHOT_HULL,
						collisiongroup = COLLISION_GROUP_NONE
					} )
					if trp.Entity == v and SERVER then
						
						local dmg = DamageInfo()
						
						local attacker = self.Owner
						dmg:SetAttacker( attacker )
						
						dmg:SetInflictor( self )
						dmg:SetDamage( 0.1 * (1 - trp.Fraction) )
						dmg:SetDamageType(DMG_SLOWBURN)
						v:TakeDamageInfo( dmg )
						
					end
				end
			end
		end
		self.LastInRoom = InRoom
		
	end
	
	self.RedBindFXTimer = self.RedBindFXTimer or CurTime()
	if SERVER and CurTime() > self.RedBindFXTimer and self.Target != nil and self.Target:IsValid() and self.TargetPos != nil then
		self.RedBindFXTimer = CurTime() + 0.1
		self.fxData1 = self.fxData1 or EffectData()
		self.fxData1:SetEntity(self.Owner)
		self.fxData1:SetNormal(Vector(0,0,0))
		self.fxData1:SetOrigin(self.Target:GetBonePosition(self.Target:LookupBone("ValveBiped.Bip01_R_Hand")))
		if SERVER then
			util.Effect("gstands_mgrflame", self.fxData1, true, true)
		end
		self.fxData1:SetOrigin(self.Target:GetBonePosition(self.Target:LookupBone("ValveBiped.Bip01_L_Hand")))
		if SERVER then
			util.Effect("gstands_mgrflame", self.fxData1, true, true)
		end
		self.fxData1:SetOrigin(self.Target:GetBonePosition(self.Target:LookupBone("ValveBiped.Bip01_R_Foot")))
		if SERVER then
			util.Effect("gstands_mgrflame", self.fxData1, true, true)
		end
		self.fxData1:SetOrigin(self.Target:GetBonePosition(self.Target:LookupBone("ValveBiped.Bip01_L_Foot")))
		if SERVER then
			util.Effect("gstands_mgrflame", self.fxData1, true, true)
		end
		self.fxData1:SetOrigin(self.Target:GetBonePosition(self.Target:LookupBone("ValveBiped.Bip01_Neck1")) + self.Target:GetAimVector() * 5)
		if SERVER then
			util.Effect("gstands_mgrflame", self.fxData1, true, true)
		end
		self.Target:SetPos(self.TargetPos)
		if self.Target:GetMoveType() != MOVETYPE_NONE and self.Target:IsPlayer() then 
			self.Target:SetMoveType(MOVETYPE_NONE)
			elseif !self.Target:IsPlayer() then
			self.Target:SetFrozen(true)
		end
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
	self.CFHurricDelay = self.CFHurricDelay or CurTime()
	if CurTime() >= self.CFHurricDelay and self:GetAMode() and self.Owner:gStandsKeyDown("modifierkey1") and self.Owner:KeyPressed(IN_ATTACK2) then
		self.StartCharge = CurTime()
		self.SoundDelay = self.SoundDelay or CurTime()
		ParticleEffectAttach("cfhcharge", PATTACH_POINT_FOLLOW, self.Owner, 1)
		if SERVER and CurTime() >= self.SoundDelay then
			self.Stand:RemoveAllGestures()
			self.Stand.AnimSet = {
				"life_detector", 0,
				"succ", 1,
				"AIMLAYER_CAMERA", 0,
				"IDLE_ALL_ANGRY", 0,
				"FIST_BLOCK", 0,
			}
			self.Owner:EmitSound(CFHurric)
			self.SoundDelay = CurTime() + 2
		end
	end
	
	if self:GetAMode() and ((self.Owner:gStandsKeyDown("modifierkey1") and self.Owner:KeyReleased(IN_ATTACK2)) or (self.Owner:KeyDown(IN_ATTACK2) and self.Owner:gStandsKeyReleased("modifierkey1"))) then
		self.Owner:StopParticles()
		if SERVER and CurTime() >= self.CFHurricDelay then
			self.Stand:EmitStandSound(Screech)
		end
		if CurTime() >= self.CFHurricDelay then
			self:CrossFire(CurTime() - self.StartCharge)
			self.CFHurricDelay = CurTime() + 1
		end
		self.StartCharge = CurTime()
		if SERVER then
			self.Stand:RemoveAllGestures()
			self.Stand.AnimSet = {
				"SWIMMING_MAGIC", 0,
				"GMOD_BREATH_LAYER", 1,
				"AIMLAYER_CAMERA", 0,
				"IDLE_ALL_ANGRY", 0,
				"FIST_BLOCK", 0,
			}
		end
		self.Stand:ResetSequence(self.Stand:LookupSequence("flame_idle"))
		self:SetHoldType("pistol")
		timer.Simple(1, function() if IsValid(self) then self:SetHoldType("stando") end end)
	end
	self.LDTimer = self.LDTimer or CurTime()
	if SERVER and self.Owner:gStandsKeyPressed("tertattack") and CurTime() > self.LDTimer then
		self.Stand:RemoveAllGestures()
		self.Stand.AnimSet = {
			"life_detector", 0,
			"life_detector", 1,
			"AIMLAYER_CAMERA", 0,
			"IDLE_ALL_ANGRY", 0,
			"FIST_BLOCK", 0,
		}
		timer.Simple(1, function()
			self.Stand.AnimSet = {
				"SWIMMING_MAGIC", 0,
				"GMOD_BREATH_LAYER", 1,
				"AIMLAYER_CAMERA", 0,
				"IDLE_ALL_ANGRY", 0,
				"FIST_BLOCK", 0,
			}
			self.Stand:RemoveAllGestures()
		end)
		
		if self.LifeDetector and self.LifeDetector:IsValid() then
			self.LifeDetector:Remove()
			else
			self.LifeDetector = ents.Create("mgrlifedetector")
			self.LifeDetector:SetOwner(self.Owner)
			self.LifeDetector:SetPos((self.Stand:GetEyePos(true)))
			if self.Owner:gStandsKeyDown("modifierkey1") then
				self.LifeDetector.Velocity = self.Owner:GetAimVector() * 55
			end
			self.LifeDetector:Spawn()
			timer.Simple(0, function()
				ParticleEffectAttach("mgrtraillifedetect", PATTACH_ABSORIGIN_FOLLOW, self.LifeDetector, 1)
			end)
		end
		self.LDTimer = CurTime() + 1
	end
	
	self.RedBindtimer = self.RedBindtimer or CurTime()
	if IsValid(self.Target) and self.TargetPos and CurTime() >= self.RedBindtimer then
		if self.Target:IsPlayer() then
			self.Target:SetMoveType(MOVETYPE_WALK)
			elseif IsValid(self.Target.Owner) then
			self.Target.Owner:SetMoveType(MOVETYPE_WALK)
			self.Target:SetFrozen(false)
		end
		self.Target = NUL
		self.TargetPos = nil
		self.TargetNorm = nil
	end
	self.TauntTimer = self.TauntTimer or CurTime()
	if self.Owner:gStandsKeyDown("taunt") and CurTime() >= self.TauntTimer then
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		if SERVER then
			self.Owner:EmitSound(tsk)
		end
		self.TauntTimer = CurTime() + 1
	end
	self.Delay = self.Delay or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("modeswap") and CurTime() > self.Delay then
		self.Delay = CurTime() + 0.2
		self:SetAMode( !self:GetAMode() )
		self.StartCharge = CurTime()
		if SERVER then
			if (self:GetAMode()) then 
				self.Owner:ChatPrint("#gstands.general.abilitym")
				else
				self.Owner:ChatPrint("#gstands.general.punchm")
			end
		end
	end
	self.StandBlockTimer = self.StandBlockTimer or CurTime()
	if self.Owner:gStandsKeyDown("block") and CurTime() > self.StandBlockTimer then
		if SERVER then
		self.Stand.HeadRotOffset = -5
		self:SetHoldType("pistol")
		self.Stand:ResetSequence(self.Stand:LookupSequence( "standblock" ))
		self.Stand:SetCycle(0)
		self.Stand:EmitStandSound(Screech)
		timer.Simple(self.Stand:SequenceDuration("standblock"), function() self:SetHoldType("stando") self.Stand.HeadRotOffset = -75 end)
		end
		self.StandBlockTimer = CurTime() + self.Stand:SequenceDuration("standblock") + 0.5
		timer.Simple(0.1, function()
		ParticleEffectAttach("flameshield", PATTACH_ABSORIGIN_FOLLOW, self.Stand, 1)
		end)
	end
	self:NextThink(CurTime())
	return true
end

function SWEP:DonutPunch()
	local anim = self.Owner:GetSequenceName(self.Owner:GetSequence())
	self.Stand:EmitStandSound(SwingSound)
	self.Stand:EmitStandSound(Screech)
	self.Owner:LagCompensation( true )
	bone = self.Stand:LookupBone("ValveBiped.Bip01_L_Foot")
	local tr = util.TraceHull( {
		start = self.Stand:GetBonePosition(bone),
		endpos = self.Stand:GetBonePosition(bone) + self.Owner:GetAimVector() * self.HitDistance,
		filter = { self.Owner, self.Stand },
		mins = Vector( -25, -25, -25 ), 
		maxs = Vector( 25, 25, 25 ),
		ignoreworld = false,
		mask = MASK_SHOT_HULL
	} )
	if SERVER and !IsValid(GetGlobalEntity("Time Stop")) and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue("explosion", "2") tr.Entity:SetKeyValue("gibdir", tostring(self.Stand:GetAngles())) tr.Entity:Fire("Break") end
	
	if IsValid(tr.Entity) and !((tr.Entity:IsPlayer() or tr.Entity:IsNPC())) and IsValid(tr.Entity:GetPhysicsObject()) then
		tr.Entity:GetPhysicsObject():SetVelocity(self.Stand:GetAngles():Forward() * 1550)
	end
	
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity.Health) ) then
		
		self.Stand:EmitSound( HitSound )
		local dmginfo = DamageInfo()		
		dmginfo:SetAttacker( self.Owner )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 150 )
		dmginfo:SetDamageType(DMG_BURN)
		
		local vel = tr.Entity:GetAbsVelocity()
		local pos = tr.Entity:GetPos()
		tr.Entity:TakeDamageInfo( dmginfo )
		if dmginfo:GetDamage() >= tr.Entity:Health() then
			self.KillstreakTimer = CurTime() + 5
		end
		
		dmginfo:SetDamage( 100 )
		
		self:EmitStandSound(Explosive)
		ParticleEffect("flameexplode", tr.HitPos, tr.Normal:Angle())
		for k,v in pairs(ents.FindInSphere(tr.HitPos, 55)) do
			if v != self.Owner and v != self:GetStand() then
				if v:IsStand() then
					if v.ImageID == 1 then
						v:TakeDamageInfo( dmginfo )
					end
					else
					v:TakeDamageInfo( dmginfo )
				end
			end
		end
	end
	if IsValid(tr.Entity) then
		if tr.Hit and !((tr.Entity:IsPlayer() or tr.Entity:IsNPC())) then
			self.Stand:EmitSound( GetStandImpactSfx(tr.MatType) )
			local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(-self.Owner:GetAimVector())
			effectdata:SetFlags(1)
			util.Effect("gstands_stand_impact", effectdata)
		end
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
			util.Effect("gstands_stand_impact", effectdata)
		end
		if tr.Entity:IsPlayer() then
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
	end
	self.Owner:LagCompensation( false )
	
end

function SWEP:PrimaryAttack()
	if self:GetAMode() then
		self:SetHoldType("pistol")
		self.Stand:ResetSequence(self.Stand:LookupSequence("flame_idle"))
		local trL = util.TraceLine( {
			start = self.Stand:GetEyePos(true),
			endpos = self.Stand:GetEyePos(true) + self.Stand:GetForward() * 350,
			filter = {self.Owner, self.Stand},
			mask = MASK_SHOT_HULL,
			collisiongroup = COLLISION_GROUP_NONE
		} )
		if trL.Hit and (trL.HitNormal.z >= 0.5 or trL.HitNormal.z <= -0.5)then
			self.Owner:SetVelocity(-self.Owner:GetAimVector() * (75 - (trL.Fraction * 75)))
		end
		self.Owner:LagCompensation(true)
		local mult = math.min(1, self:GetFlamePower())
		local length = 550 * mult
		for k,v in pairs(ents.FindInCone(self.Stand:GetEyePos(true), (trL.HitPos - self.Stand:GetEyePos(true)):GetNormalized(), length, 0.95)) do
			if SERVER and v:IsValid() and v:WaterLevel() < 2 then
				local tr = util.TraceLine( {
					start = self.Stand:GetEyePos(true),
					endpos = v:WorldSpaceCenter(),
					filter = {self.Owner, self.Stand},
					mask = MASK_SHOT_HULL,
					collisiongroup = COLLISION_GROUP_NONE
				} )
				if tr.Entity == v or v:GetClass() == "geb" then
					if (v:GetModel() == "models/player/slc/slc.mdl" or v:GetModel() == "models/player/slc/slc_un.mdl") and v:GetSequence() == v:LookupSequence("block") then
						v.Owner:GetActiveWeapon():LightSword()
						continue
					end
					if v.GetActiveWeapon and IsValid(v:GetActiveWeapon()) and v:GetActiveWeapon().GetStand and IsValid(v:GetActiveWeapon():GetStand()) and  (v:GetActiveWeapon():GetStand():GetModel() == "models/player/slc/slc.mdl" or v:GetActiveWeapon():GetStand():GetModel() == "models/player/slc/slc_un.mdl") and v:GetActiveWeapon():GetStand():GetSequence() == v:GetActiveWeapon():GetStand():LookupSequence("block") then
						v:GetActiveWeapon():LightSword()
						continue
					end
					if !v:IsOnFire() then
						v:Ignite((10 - (self.Owner:GetPos():Distance(v:GetPos()) / 55)) * mult)
						
					end
					if v:Health() then
						local dmg = DamageInfo()
						dmg:SetAttacker(self.Owner)
						dmg:SetInflictor(self)
						dmg:SetDamage(10 * mult)
						dmg:SetDamageType(DMG_BURN)
						v:EmitSound("ambient/fire/mtov_flame2.wav", 75, 100)
						v:TakeDamageInfo(dmg)
					end
					if v:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE or v:GetClass() == "physical_bullet" or (v:GetPhysicsObject():IsValid() and string.StartWith(v:GetPhysicsObject():GetMaterial(), "metal") and v:GetPhysicsObject():GetMass() <= 100) then
						v:Remove()
					end
					elseif SERVER and v:IsValid() then
					local tr = util.TraceLine( {
						start = self.Stand:GetEyePos(true),
						endpos = v:WorldSpaceCenter(),
						filter = {self.Owner, self.Stand},
						mask = MASK_SHOT_HULL,
						collisiongroup = COLLISION_GROUP_NONE
					} )
					if tr.Entity == v or v:GetClass() == "geb" then
						if !v:IsOnFire() then
							v:Ignite((10 - (self.Owner:GetPos():Distance(v:GetPos()) / 25)) * mult)
						end
						if v:Health() then
							local dmg = DamageInfo()
							dmg:SetAttacker(self.Owner)
							dmg:SetInflictor(self)
							dmg:SetDamage(10 * mult)
							dmg:SetDamageType(DMG_BURN)
							v:EmitSound("ambient/fire/mtov_flame2.wav", 75, 100)
							v:TakeDamageInfo(dmg)
						end
						if v:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE or v:GetClass() == "physical_bullet" or (v:GetPhysicsObject():IsValid() and string.StartWith(v:GetPhysicsObject():GetMaterial(), "metal") and v:GetPhysicsObject():GetMass() <= 100) then
							v:Remove()
						end
					end
				end
				self:SetNextPrimaryFire( CurTime() + 0.03 )
			end
		end
		self.Owner:LagCompensation(false)
		else
		self:SetHoldType("pistol")
		if self.Stand:GetSequence() != self.Stand:LookupSequence("kick") then
			self.Stand:ResetSequence( self.Stand:LookupSequence("kick") )
			self.Stand:SetPlaybackRate( 1 )
			self.Stand:SetCycle( 0 )
		end
		
		if SERVER then
			self.Stand:EmitStandSound(SwingSound)
			timer.Simple(self.Stand:SequenceDuration()/6, function()
				self:DonutPunch()
			end)
			timer.Simple(self.Stand:SequenceDuration(), function()
				self:SetHoldType( "stando")
			end)
		end
		self:SetNextPrimaryFire( CurTime() + 1 )
		self:SetNextSecondaryFire( CurTime() + 2 )
	end
end

function SWEP:SecondaryAttack()
	
		if self:GetAMode() and !self.Owner:gStandsKeyDown("modifierkey1") then
			self:SetHoldType("pistol")
			if self.Stand:GetSequence() != self.Stand:LookupSequence("redbind") then
				self.Stand:ResetSequence( self.Stand:LookupSequence("redbind") )
				self.Stand:SetPlaybackRate( 1 )
			end
			if SERVER then
				self.Owner:EmitSound(Whip)
				self.Owner:EmitSound(RedBind)
				local redbind = ents.Create("redbind")
				redbind:SetPos(self:GetStand():GetPos())
				redbind:SetOwner(self.Owner)
				redbind:SetAngles(self:GetStand():GetAngles())
				redbind:SetParent(self:GetStand())
				redbind:Spawn()
				redbind:EmitSound(SwingSound)
				self.Stand:SetCycle( 0 )
			end
			if self.Target == nil or !self.Target:IsValid() then
				self:SetNextSecondaryFire( CurTime() + self.Stand:SequenceDuration() + 0.1 )
				else
				self.Target:SetMoveType(MOVETYPE_WALK)
				self.Target = NUL
				self.TargetPos = nil
				self.TargetNorm = nil
			end
			self:SetNextSecondaryFire( CurTime() + self.Stand:SequenceDuration() + 0.1 )
			timer.Simple(self.Stand:SequenceDuration(), function()
				self:SetHoldType( "stando")
			end)
			elseif !self:GetAMode() and !self.Owner:gStandsKeyDown("modifierkey1") then
			self:SetNextSecondaryFire( CurTime() + 2 )
			self:SetHoldType("pistol")
			if self.Stand:GetSequence() != self.Stand:LookupSequence("place") then
				self.Stand:ResetSequence( self.Stand:LookupSequence("place") )
				self.Stand:SetPlaybackRate( 1 )
				self.Stand:SetCycle( 0 )
			end
			if SERVER then
				self.Owner:EmitSound(Mun)
				timer.Simple(self.Stand:SequenceDuration()/2, function()
					self.Bomb = self:PlaceFireBomb()
				end)
				timer.Simple(self.Stand:SequenceDuration(), function()
					self:SetHoldType("stando")
				end)
			end
			self:SetNextSecondaryFire( CurTime() + 2 )
		end
end

function SWEP:Reload()
	
end

function SWEP:CrossFire(charge)
	self.Owner:LagCompensation(true)
	if !self.Owner.IsKnockedOut and IsFirstTimePredicted() then
		if (SERVER) then
			local iter = 0
			if charge >= 1 then 
				iter = 1
			end
			if charge >= 2 then
				iter = 2
			end
			self.CFHs = {}
			for i = 0, iter do
				local boolet = ents.Create("cfhurricane")
				if IsValid(boolet) then
					local offset = (self.Stand:GetRight() * (i * 15))
					local offseta = (self.Stand:GetRight() + self.Owner:GetAimVector()):GetNormalized():Angle()
					local scale = 1
					if i == 0 then
						offset = (self.Owner:GetAimVector() * 2 + self.Stand:GetUp() * 15)
						scale = 1.1
						offseta = self.Owner:EyeAngles()
					end
					if i == 2 then
						offset = -(self.Stand:GetRight() * (i * 15))
						offseta = (-self.Stand:GetRight() + self.Owner:GetAimVector()):GetNormalized():Angle()
					end
					if !self.Owner:gStandsKeyDown("dododo") then
						boolet:SetPos(self.Stand:GetEyePos() + offset)
						else
						boolet:SetPos(self.Stand:GetEyePos() + offset)
					end
					boolet:SetAngles(offseta)
					boolet:SetOwner(self.Owner)
					local clrmod, clrskin = self:GetStand():GetModel(), self:GetStand():GetSkin()
					boolet.clr = {clrmod, clrskin}
					boolet:SetPhysicsAttacker(self.Owner)
					self.CFHs[i] = boolet
					boolet:Spawn()
					boolet:Activate()
					boolet:SetModelScale(scale)
					self.Stand:EmitStandSound(Crack)
					local effectdata = EffectData()
					effectdata:SetEntity(boolet)
					effectdata:SetFlags(1)
					util.Effect("gstands_mgrflames", effectdata, true, true)
					boolet:SetVelocity(boolet:GetForward() * 1)
				end
			end
		end
	end
	self.Owner:LagCompensation(false)
end
function SWEP:PlaceFireBomb()
	local boolet = ents.Create("mgr_bomb")
	if IsValid(boolet) then
		boolet:SetPos(self.Stand:GetBonePosition(self.Stand:LookupBone("ValveBiped.Bip01_R_Hand")))
		boolet:SetOwner(self.Owner)
		boolet:SetModel("models/props_junk/PopCan01a.mdl")
		local clrmod, clrskin = self:GetStand():GetModel(), self:GetStand():GetSkin()
		boolet.clr = {clrmod, clrskin}
		boolet:SetPhysicsAttacker(self.Owner)
		boolet:Spawn()
		boolet:Activate()
		boolet:EmitSound("ambient/fire/mtov_flame2.wav")
		local effectdata = EffectData()
		effectdata:SetEntity(boolet)
		effectdata:SetFlags(15)
		util.Effect("gstands_mgrflames", effectdata, true, true)
		self:SetBombs(self:GetBombs() + 1)
	end
	return boolet
end


function SWEP:OnDrop()
	if SERVER and self.Stand:IsValid() then
		self.Stand:StopParticles()
		self.Stand:Remove()
	end
	if SERVER and self.LifeDetector != nil and self.LifeDetector:IsValid() then
		self.LifeDetector:Remove()
	end
	if self.Target then
		if !self.Target.SetFrozen then
			self.Target:SetMoveType(MOVETYPE_WALK)
			else
			self.Target.Owner:SetMoveType(MOVETYPE_WALK)
			self.Target:SetFrozen(false)
		end
		self.Target = NUL
		self.TargetPos = nil
		self.TargetNorm = nil
	end
	return true
end

function SWEP:OnRemove()
	if SERVER and self.Stand:IsValid() then
		self.Stand:StopParticles()
		
		self.Stand:Remove()
	end
	if SERVER and self.LifeDetector != nil and self.LifeDetector:IsValid() then
		self.LifeDetector:Remove()
	end
	if self.Target and self.TargetPos then
		if !self.Target.SetFrozen then
			self.Target:SetMoveType(MOVETYPE_WALK)
			else
			self.Target.Owner:SetMoveType(MOVETYPE_WALK)
			self.Target:SetFrozen(false)
		end
		self.Target = NUL
		self.TargetPos = nil
		self.TargetNorm = nil
	end
	return true
end

function SWEP:Holster()
	if SERVER and self.Stand:IsValid() then
		self.Stand:StopParticles()
		self.KillstreakTimer = self.KillstreakTimer or CurTime()
		if self.Owner:Alive() and CurTime() < self.KillstreakTimer then
			self.KillstreakTimer = self.KillstreakTimer - 100
			self.Owner:EmitSound(NoForgive)
		end
		self.Stand:Withdraw()
		self.Owner:EmitStandSound(Withdraw)
	end
	if SERVER and self.LifeDetector != nil and self.LifeDetector:IsValid() then
		self.LifeDetector:Remove()
	end
	if self.Target and self.TargetPos then
		if !self.Target.SetFrozen then
			self.Target:SetMoveType(MOVETYPE_WALK)
			else
			self.Target.Owner:SetMoveType(MOVETYPE_WALK)
			self.Target:SetFrozen(false)
		end
		self.Target = NUL
		self.TargetPos = nil
		self.TargetNorm = nil
	end
	return true
end