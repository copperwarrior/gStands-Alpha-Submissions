--Send file to clients
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot      = 1
end

SWEP.Power = 1.5
SWEP.Speed = 2.25
SWEP.Range = A
SWEP.Durability = 800
SWEP.Precision = nil
SWEP.DevPos = nil

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.sethan.purpose"
SWEP.Instructions  = "#gstands.sethan.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.sethan"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos            = 2
SWEP.DrawCrosshair      = true

SWEP.WorldModel = "models/sethan/w_sethax.mdl"
SWEP.ViewModelFOV = 54
SWEP.UseHands = true
SWEP.StandModel = "models/sethan/w_sethax.mdl"
SWEP.StandModelP = "models/sethan/w_sethax.mdl"
if CLIENT then
	SWEP.StandModel = "models/hdm/hdm.mdl"
end

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
SWEP.targets = {}
SWEP.gStands_IsThirdPerson = true
local PrevHealth = nil

--Define swing and hit sounds. Might change these later.
local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )
local Deploy = Sound( "weapons/sethan/deploy.mp3" )
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
	[ "stando" ]		= ACT_HL2MP_IDLE_MELEE
	
}
function SWEP:DrawWorldModel()
	if IsValid(self.Owner) then
		self.WorldModel = "models/sethan/w_sethax.mdl"
		if !self.Owner:GetNoDraw() then
			self:DrawModel()
		end
		else
		self.WorldModel = "models/player/whitesnake/disc.mdl"
		self:DrawModel()
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
	-- "normal" jump animation doesn't exist
	if ( t == "normal" ) then
		self.ActivityTranslate[ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end
	
	
end
function SWEP:Initialize()
	--Set the third person hold type to fists
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
		local color = gStands.GetStandColorTable("models/hdm/hdm.mdl", "0")
		local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
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
	end
end
hook.Add( "HUDShouldDraw", "SethanHud", function(elem)
	if IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_sethan" and (elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") and GetConVar("gstands_draw_hud"):GetBool() then
		return false
	end
end)
local material = Material( "vgui/hud/gstands_hud/crosshair" )
function SWEP:DoDrawCrosshair(x,y)
	if IsValid(self.Owner) and IsValid(LocalPlayer()) then
		local tr = util.TraceLine( {
			start = self.Owner:EyePos(),
			endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 1500,
			filter = {self.Owner},
			mask = MASK_SHOT_HULL
		} )
		local pos = tr.HitPos
		
		local pos2d = pos:ToScreen()
		if pos2d.visible then
			surface.SetMaterial( material )
			local clr = self.Color
			local h,s,v = ColorToHSV(clr)
			h = h - 180
			clr = HSVToColor(h,1,1)
			surface.SetDrawColor( clr )
			surface.DrawTexturedRect( pos2d.x - 16, pos2d.y - 16, 32, 32 )
		end
		return true
	end
end
--Third Person View
local thirdperson_offset = GetConVar("gstands_thirdperson_offset")
function SWEP:CalcView( ply, pos, ang )
if not self.gStands_IsThirdPerson or ply:GetViewEntity() ~= ply then return end

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
--Deploy starts up the stand
function SWEP:Deploy()
	self:SetHoldType( "stando" )
	
	if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitStandSound(Deploy)
		end
	end
	--As is standard with stand addons, set health to 1000
	if self.Owner:Health() == 100  then
		self.Owner:SetMaxHealth( self.Durability )
		self.Owner:SetHealth( self.Durability )
	end
	
	--Create some networked variables, solves some issues where multiple people had the same stand
	self.Owner:SetCanZoom(false)
	local hooktag = self.Owner:Name()
	hook.Add("EntityTakeDamage", "SethanCutsDamage"..hooktag, function(targ, dmg)
		if IsValid(self) and IsValid(self.Owner) then
		
			if table.HasValue(self.targets, dmg:GetAttacker()) then
				dmg:SetDamage(dmg:GetDamage()*math.Clamp(dmg:GetAttacker():GetModelScale()/2,0,1))
			end
		else
			hook.Remove("EntityTakeDamage", "SethanCutsDamage"..hooktag)
		end
	end)
end

function SWEP:Think()
	local curtime = CurTime()
	self.Menacing = self.Menacing or CurTime()
	if self.Owner:gStandsKeyDown("dododo") then
		if CurTime() > self.Menacing then
			self.Menacing = CurTime() + 0.5
			local effectdata = EffectData()
			effectdata:SetStart(self.Owner:GetPos())
			effectdata:SetOrigin(self.Owner:GetPos())
			effectdata:SetEntity(self.Owner)
			util.Effect("menacing", effectdata)
		end
	end
	if self.Owner:KeyDown(IN_FORWARD) then
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= ACT_HL2MP_IDLE_KNIFE + 5
		else
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= ACT_HL2MP_IDLE_MELEE + 5
	end
end
function SWEP:PrimaryAttack()
	self.Delay = self.Delay or CurTime()
	if !self.Owner.IsKnockedOut and SERVER and IsFirstTimePredicted() and CurTime() > self.Delay then
		self.Delay = CurTime() + 1
		self:SetNextSecondaryFire( CurTime() + (0.1 * self.Power) )
		local tr = util.TraceLine( {
			start = self.Owner:EyePos(),
			endpos = self.Owner:GetPos() - self.Owner:GetUp() * self.HitDistance * 50,
			filter = self.Owner,
			mask = MASK_SHOT_HULL
		} )
		local trH = util.TraceHull( {
			start = self.Owner:EyePos(),
			endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * self.HitDistance * 8,
			filter = self.Owner ,
			mask = MASK_SHOT_HULL,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 40, 40, 8 ),
			collisiongroup = COLLISION_GROUP_PROJECTILE
		} )
		if trH.Entity:IsValid() and (trH.Entity:IsPlayer() or trH.Entity:IsNPC()) and trH.Entity:OnGround() and !(trH.Entity:GetActiveWeapon() and trH.Entity:GetActiveWeapon().GetActive and trH.Entity:GetActiveWeapon():GetActive()) then
			trH.Entity:SetModelScale(trH.Entity:GetModelScale() * 0.9, 1)
			if !table.HasValue(self.targets, trH.Entity) then
				self.targets[#self.targets+1] = trH.Entity
			end
			for k,v in pairs(self.targets) do
				if !v:IsValid() then
					table.RemoveByValue(self.targets, v)
				end
			end
			if trH.Entity:IsPlayer() then
				trH.Entity:SetViewOffset(Vector(0,0,64)*trH.Entity:GetModelScale())
				trH.Entity:SetViewOffsetDucked(Vector(0,0,28)*trH.Entity:GetModelScale())
				trH.Entity:SetWalkSpeed(trH.Entity:GetWalkSpeed() * 0.9)
				trH.Entity:SetRunSpeed(trH.Entity:GetRunSpeed() * 0.9)
				trH.Entity:SetJumpPower(trH.Entity:GetJumpPower() * 0.9)
				local tag = trH.Entity:Name()
				hook.Add("PostPlayerDeath", "ResetSethanSizeOnDeath"..tag, function(ply)
					if ply == trH.Entity then
						ply:SetModelScale(1, 1)
						ply:SetViewOffset(Vector(0,0,64))
						ply:SetViewOffsetDucked(Vector(0,0,28))
						ply:SetWalkSpeed(190)
						ply:SetRunSpeed(320)
						ply:SetJumpPower(200)
					end
					hook.Remove("PostPlayerDeath", "ResetSethanSizeOnDeath"..tag)
				end)
				local wep = trH.Entity:GetActiveWeapon()
				if wep:IsValid() and wep.GetStand and wep:GetStand():IsValid() then
					wep:GetStand():SetModelScale(wep:GetStand():GetModelScale() * 0.9, 1)
				end
				if wep:IsValid() and wep.GetStand1 and wep:GetStand1():IsValid() then
					wep:GetStand1():SetModelScale(wep:GetStand1():GetModelScale() * 0.9, 1)
				end
				if wep:IsValid() and wep.GetStand2 and wep:GetStand2():IsValid() then
					wep:GetStand2():SetModelScale(wep:GetStand2():GetModelScale() * 0.9, 1)
				end
			end
			if trH.Entity:Health() > 1 then
				trH.Entity:SetHealth(trH.Entity:Health() * 0.9)
			end
			local fxData = EffectData()
			fxData:SetOrigin(self.Owner:GetPos())
			fxData:SetEntity(self.Owner)
			fxData:SetAngles(tr.HitNormal:Angle())
			fxData:SetNormal(self.Owner:GetForward())
			util.Effect("gstands_sethan", fxData, true, true)
			self.Owner:DrawShadow(false)
			timer.Simple(0.5, function() self.Owner:DrawShadow(true) end)
		end
	end
end

function SWEP:SecondaryAttack()
	--Punch mode
	self:SetNextSecondaryFire( CurTime() + (0.4 * self.Power) )
	
	if SERVER then
		self.Owner:EmitSound(SwingSound)
	end
	local tr = util.TraceHull( {
		start = self.Owner:EyePos(),
		endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner ,
		mask = MASK_SHOT_HULL,
		mins = Vector( -10, -10, -8 ),
		maxs = Vector( 40, 40, 8 ),
		ignoreworld = false,
		collisiongroup = COLLISION_GROUP_PROJECTILE
	} )
	if SERVER and tr.HitWorld then
		self:SetNextSecondaryFire( CurTime() + (0.8 * self.Power) )
		self.Owner:EmitSound(GetStandImpactSfx(tr.MatType))
		
		else
		if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
			local dmginfo = DamageInfo()
			
			local attacker = self.Owner
			if ( !IsValid( attacker ) ) then attacker = self end
			dmginfo:SetAttacker( attacker )
			
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( 16 * self.Power )
			
			tr.Entity:TakeDamageInfo( dmginfo )
			if SERVER then
				self.Owner:EmitSound("physics/body/body_medium_break"..math.random(2,3)..".wav")
			end
			
			hit = true
			
		end
	end
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	--No spamming the donut punch.
	self:SetNextPrimaryFire( CurTime() + (0.1 * self.Power) )
end

function SWEP:Reload()
	
end

--Screw this entire section, it only works like 20% of the time. Basically, meant to catch every time the weapon is not in your hands in order to remove the stand.
function SWEP:OnDrop()
	self.WorldModel = "models/player/whitesnake/disc.mdl"
	local hooktag = self.Owner:Name()
	hook.Remove("EntityTakeDamage", "SethanCutsDamage"..hooktag)
	for k,v in pairs(self.targets) do
		local wep = v:GetActiveWeapon()
		if wep:IsValid() and wep.GetStand and wep:GetStand():IsValid() then
			wep:GetStand():SetModelScale(1,1)
		end
		v:SetModelScale(1, 1)
		if v:IsPlayer() then
			v:SetViewOffset(Vector(0,0,64))
			v:SetViewOffsetDucked(Vector(0,0,28))
			v:SetWalkSpeed(190)
			v:SetRunSpeed(320)
			v:SetJumpPower(200)
		end
	end
	if self.Owner:IsValid() then
		self.Owner:DrawShadow(true)
	end
	return true
end

function SWEP:OnRemove()
	if IsValid(self.Owner) then
		local hooktag = self.Owner:Name()
		hook.Remove("EntityTakeDamage", "SethanCutsDamage"..hooktag)
		for k,v in pairs(self.targets) do
			local wep = v:GetActiveWeapon()
			if wep:IsValid() and wep.GetStand and wep:GetStand():IsValid() then
				wep:GetStand():SetModelScale(1,1)
			end
			if wep:IsValid() and wep.GetStand1 and wep:GetStand1():IsValid() then
				wep:GetStand1():SetModelScale(1,1)
			end
			if wep:IsValid() and wep.GetStand2 and wep:GetStand2():IsValid() then
				wep:GetStand2():SetModelScale(1,1)
			end
			v:SetModelScale(1, 1)
			if v:IsPlayer() then
				v:SetViewOffset(Vector(0,0,64))
				v:SetViewOffsetDucked(Vector(0,0,28))
				v:SetWalkSpeed(190)
				v:SetRunSpeed(320)
				v:SetJumpPower(200)
			end
		end
		self.Owner:DrawShadow(true)
	end
	return true
end

function SWEP:Holster()
	return true
end