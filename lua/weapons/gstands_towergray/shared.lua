
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot			  	= 1
end

SWEP.Power                	= 1
SWEP.Speed                	= 1
SWEP.Range                	= 1500
SWEP.Durability           	= 800
SWEP.Precision            	= A
SWEP.DevPos               	= A

SWEP.Author               	= "Copper"
SWEP.Purpose              	= "#gstands.tgray.purpose"
SWEP.Instructions         	= "#gstands.tgray.instructions"
SWEP.Spawnable            	= true
SWEP.Base                 	= "weapon_fists" 
SWEP.Category             	= "gStands"
SWEP.PrintName            	= "#gstands.names.tgray"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos              	= 2
SWEP.DrawCrosshair        	= true
SWEP.StandModel 				= "models/tgray/tgray.mdl"
SWEP.StandModelP 				= "models/tgray/tgray.mdl"
if CLIENT then
	SWEP.StandModel = "models/tgray/tgray.mdl"
end

SWEP.WorldModel           	= "models/player/whitesnake/disc.mdl"
SWEP.ViewModelFOV         	= 54
SWEP.UseHands             	= true

SWEP.Primary.ClipSize     	= -1
SWEP.Primary.DefaultClip  	= -1
SWEP.Primary.Automatic    	= true
SWEP.Primary.Ammo         	= "none"

SWEP.Secondary.ClipSize   	= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic  	= true
SWEP.Secondary.Ammo       	= "none"

SWEP.DrawAmmo             	= false
SWEP.CanZoom              	= false
SWEP.HitDistance          	= 48
SWEP.gStands_IsThirdPerson = true

game.AddParticles("particles/tgray.pcf")

PrecacheParticleSystem("tgrayvomit")
PrecacheParticleSystem("tgrayhit")

local HitSound	= Sound( "Flesh.ImpactHard" )
local Tongue  	= Sound( "weapons/tgray/tongue.wav" )
local Bingo   	= Sound( "weapons/tgray/bingo.wav" )
local Whizz   	= Sound( "tgray.whizz" )

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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= ACT_HL2MP_IDLE
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_PANICKED
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_02"))
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= ACT_HL2MP_IDLE_PISTOL + 5
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= ACT_HL2MP_IDLE_PISTOL + 5
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= ACT_HL2MP_IDLE_FIST + 5
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= ACT_HL2MP_IDLE_FIST + 5
		self.ActivityTranslate[ ACT_MP_JUMP ]						= ACT_HL2MP_IDLE_SLAM + 7
		self.ActivityTranslate[ ACT_RANGE_ATTACK1 ]					= index + 8
		self.ActivityTranslate[ ACT_MP_SWIM ]						= ACT_HL2MP_IDLE + 9
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
	if !IsPlayerStandUser(LocalPlayer()) then
		self:GetTrail():SetNoDraw(true)
		else
		self:GetTrail():SetNoDraw(false)
	end
end
function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Stand")
	self:NetworkVar("Entity", 1, "LockTarget")
	self:NetworkVar("Entity", 2, "Trail")
	self:NetworkVar("Bool", 3, "AMode")
	self:NetworkVar("Int", 4, "Tongues")
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
local base        	= "vgui/hud/gstands_hud/"
local armor_bar   	= Material(base.."armor_bar")
local bar_border  	= Material(base.."bar_border")
local boxdis      	= Material(base.."boxdis")
local boxend      	= Material(base.."boxend")
local cooldown_box	= Material(base.."cooldown_box")
local generic_rect	= Material(base.."generic_rect")
local health_bar  	= Material(base.."health_bar")
local pfpback     	= Material(base.."pfpback")
local pfpfront    	= Material(base.."pfpfront")
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
			text = self:GetTongues() - 1,
			font = "gStandsFontLarge",
			pos = {width - 160 * mult, height - 120 * mult},
			color = tcolor,
			xalign = TEXT_ALIGN_CENTER
		}, 2 * mult, 250)
		
		
	end
end
hook.Add( "HUDShouldDraw", "TowerOfGrayHud", function(elem)
	if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_towergray" and (((elem == "CHudWeaponSelection" ) and LocalPlayer().SPInZoom) or elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
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

function SWEP:Deploy()
	self:SetHoldType( "stando" )
	
	
	if self.Owner:Health() == 100	then
		self.Owner:SetMaxHealth( self.Durability )
		self.Owner:SetHealth( self.Durability )
	end
	
	
	self:DefineStand()
	
	
	if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitStandSound("ambient/creatures/flies"..math.random(1,5)..".wav", 75, 65)
		end
		self:SetTrail(util.SpriteTrail(self.Stand, 1, Color(255,255,255, 150), false, 15,15, 0.05, 0.01, "effects/gstands_tgray_blurtrail.vmt" ))
	end
end

function SWEP:DefineStand()
	if SERVER then
		self:SetStand( ents.Create("Stand"))
		self.Stand = self:GetStand()
		self.Stand:SetOwner(self.Owner)
		self.Stand:SetModel("models/tgray/tgray.mdl")
		self.Stand:SetBodygroup(1, 0)
		self.Stand:SetMoveType( MOVETYPE_NOCLIP )
		self.Stand:SetAngles(self.Owner:GetAngles())
		self.Stand:SetPos(self.Owner:GetBonePosition(0)+Vector(0, 0, 0))
		self.Stand:DrawShadow(false)
		self.Stand.Color = Color(150,150,150,1)
		self.Stand:SetModelScale(5)
		
		self.Stand:Spawn()
		self.Stand.Range = self.Range
		self.Stand.Speed = 20 / self.Speed
	end
	timer.Simple(0.1, function()
		if self.Stand:IsValid() then
			if self.Stand:GetSkin() == 0 then
				self.Stand.rgl = 1.7
				self.Stand.ggl = 1.7
				self.Stand.bgl = 1.7
				self.Stand.rglm = 1.3
				self.Stand.gglm = 1.3
				self.Stand.bglm = 1.3
			end
		end
	end)
end

function SWEP:Think()	
	self.Stand = self:GetStand()
	if !self.Stand:IsValid() then
		self:DefineStand()
	end
	if SERVER and !timer.Exists("towergrayloop"..self.Owner:GetName()) then
		self.Loop = CreateSound(self.Stand, "ambient/creatures/housefly_loop_01.wav")
		self.Loop:Play()
		self.Loop:ChangePitch(69)
		self.Loop:ChangeVolume(0.1)
		timer.Create("towergrayloop"..self.Owner:GetName(), 3.4, 0, function()
			if !GetConVar("gstands_time_stop"):GetBool() then
				if self.Stand:IsValid() then
					self.Loop:Play()
					self.Loop:ChangePitch(69)
					self.Loop:ChangeVolume(0.1)
				end
			end
			if !self.Stand:IsValid() then
				timer.Remove("towergrayloop"..self.Owner:GetName())
				self.Loop:Stop()
				self.Loop:ChangePitch(69)
				self.Loop:ChangeVolume(0.1)
			end
		end)
		else
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
	if self:GetTongues() == 0 then self:SetTongues(1) end
	if self.Owner:gStandsKeyDown("modifierkey1") then
		self.Stand.Speed = 20 / self.Speed * (1 + self:GetTongues()/15)
	end
	self.TargettingTimer = self.TargettingTimer or CurTime()
	if self.Owner:gStandsKeyDown("modeswap") and SERVER and CurTime() >= self.TargettingTimer then
		self.PlayerIndex = self.PlayerIndex or 0
		self.PlayerIndex = self.PlayerIndex + 1
		self:SetLockTarget(Entity((self.PlayerIndex) % #player.GetAll() + 1))
		if Entity((self.PlayerIndex) % #player.GetAll() + 1) == self.Owner then
			self:SetLockTarget(NULL)
		end
		if IsValid(self:GetLockTarget()) then
			self.Owner:ChatPrintFormatted("#gstands.tgray.target",self:GetLockTarget():GetName())
			else
			self.Owner:ChatPrint("#gstands.tgray.notarg")
		end
		
		self.TargettingTimer = CurTime() + 0.5
	end
end

function SWEP:PrimaryAttack()
	ParticleEffectAttach("tgrayvomit", PATTACH_POINT_FOLLOW, self.Stand, self.Stand:LookupAttachment("tongue_a"))
	if IsValid(self.Stand) then
		self:SetHoldType("pistol")
		self.Stand:SetBodygroup(1, 1)
		self.Stand:ResetSequence("attack")
		self.Stand:SetCycle(0)
		timer.Simple(self.Stand:SequenceDuration("attack") - 0.1, function() if IsValid(self.Stand) then self.Stand:SetBodygroup(1, 0) self:SetHoldType("stando") end end)
		self.GotTongue = false
		timer.Create("TowerofGrayAttackLoop"..self:EntIndex()..self.Owner:GetName(), 0.01, 30, function() 
			if IsValid(self.Stand) then
				self.HitHead = false
				self:DonutPunch()
			end
		end)
		self:SetNextPrimaryFire(CurTime() + self.Stand:SequenceDuration("attack"))
		if SERVER then
			self.Stand:EmitSound( "physics/flesh/flesh_squishy_impact_hard"..math.random(1,5)..".wav", 75, 110, 0.5)
			self.Stand:EmitSound( Tongue)
		end
	end
end

function SWEP:SecondaryAttack()
	
end

function SWEP:DonutPunch()
	
	if self.Stand:GetBodygroup(1) == 1 and SERVER then
		
		
		local anim = self.Owner:GetSequenceName(self.Owner:GetSequence())
		self.Owner:LagCompensation( true )
		local tr = util.TraceLine( {
			start = self.Stand:GetAttachment(self.Stand:LookupAttachment("tongue_a")).Pos,
			endpos = self.Stand:GetAttachment(self.Stand:LookupAttachment("tongue_b")).Pos,
			filter = {self.Owner, self.Stand },
			mins = Vector( -5, -5, -5 ), 
			maxs = Vector( 5, 5, 5 ),
			mask = MASK_SHOT_HULL, 
		} )
		
		
		if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) and !tr.HitWorld) then
			self.Stand:EmitSound( "physics/flesh/phys_bullet_impact_flesh_0"..math.random(0,8)..".wav", 75, 110, 0.2 )
		end
		if SERVER and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue("explosion", "2") tr.Entity:SetKeyValue("gibdir", tostring(self.Stand:GetAngles())) tr.Entity:Fire("Break") end
		if math.random(1,5) == 3 then
			self.Stand:EmitSound( "physics/flesh/flesh_squishy_impact_hard"..math.random(1,5)..".wav", 75, 110, 0.5)
		end
		local hit = false
		if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 )) then
			local dmginfo = DamageInfo()
			local attacker = self.Owner
			if ( !IsValid( attacker ) ) then attacker = self.Owner end
			dmginfo:SetAttacker( attacker )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( 15 * self.Power * self:GetTongues()/4 )
			if tr.HitGroup == HITGROUP_HEAD then
				dmginfo:SetDamage( 25 * self.Power * self:GetTongues()/4 )
				self.HitHead = true
			end
			if self.HitHead and !self.GotTongue and tr.Entity:Health() > 0 and dmginfo:GetDamage() >= tr.Entity:Health() then
				self:SetTongues(math.min(self:GetTongues() + 1, 15))
				self.GotTongue = true
				self.Stand:EmitStandSound(Bingo)
				ParticleEffect("tgrayhit", tr.HitPos, Angle())
				self.Owner:ChatPrintFormatted("#gstands.tgray.collect",self:GetTongues() - 1)
			end
			dmginfo:SetDamageType(DMG_SLASH)
			dmginfo:SetReportedPosition( self.Stand:WorldSpaceCenter() )
			tr.Entity:TakeDamageInfo( dmginfo )		
			hit = true
		end
		
		if tr.Entity:IsPlayer() and !self.Owner.IsKnockedOut then
			tr.Entity:ViewPunch( Angle( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) ) )
		end
		
		self.Owner:LagCompensation( false )
		
	end
end

function SWEP:Reload()
	
end

function SWEP:OnDrop()
	if SERVER and self.Owner and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	timer.Remove("towergrayloop"..self.Owner:GetName())
	if SERVER then
		self.Loop:Stop()
	end
	return true
end

function SWEP:OnRemove()
	if SERVER and self.Owner and self.Owner:IsValid() and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	timer.Remove("towergrayloop"..self.Owner:GetName())
	if SERVER then
		self.Loop:Stop()
	end
	return true
end

function SWEP:Holster()
	if SERVER and self.Owner and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	timer.Remove("towergrayloop"..self.Owner:GetName())
	if SERVER then
		self.Loop:Stop()
	end
	return true
end