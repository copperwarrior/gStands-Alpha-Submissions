
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot      = 1
end

SWEP.Power = 1.5
SWEP.Speed = 2
SWEP.Range = 250
SWEP.Durability = 1500
SWEP.Precision = nil
SWEP.DevPos = nil

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.kfar.purpose"
SWEP.Instructions  = "#gstands.kfar.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.kfar"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos            = 2
SWEP.DrawCrosshair      = true

SWEP.WorldModel = "models/kfar/kfar.mdl"
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

game.AddParticles("particles/kfar.pcf")
PrecacheParticleSystem("kfartarget")

SWEP.Latched = false
SWEP.Color = Color(10,150,10,100)
SWEP.gStands_IsThirdPerson = true

local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )
local Deploy = Sound("weapons/kfar/deploy.wav")
local SDeploy = Sound("weapons/kfar/sdeploy.wav")
local Withdraw = Sound("weapons/kfar/withdraw.wav")
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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= ACT_HL2MP_IDLE_FIST
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE_KNIFE + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_01"))
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_fists_r"))
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_fists_r"))
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= ACT_HL2MP_IDLE_CAMERA + 1
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= ACT_HL2MP_IDLE_CAMERA + 3
		self.ActivityTranslate[ ACT_MP_JUMP ]						= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("jump_suitcase"))
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

function SWEP:DrawHUD()
	if GetConVar("gstands_draw_hud"):GetBool() then
		local color = Color(self.Color.r, self.Color.g, self.Color.b, 255)
		local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
	end
end
hook.Add( "HUDShouldDraw", "KissFromARoseHud", function(elem)
	if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_kfar" and (((elem == "CHudWeaponSelection" ) and LocalPlayer().SPInZoom) or elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
		return false
	end
end)
local material = Material( "vgui/hud/gstands_hud/crosshair" )
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
function SWEP:DrawWorldModel()
	if IsValid(self.Owner) then
		self.WorldModel = "models/kfar/kfar.mdl"
		if !self.Owner:GetNoDraw() then
			self.Color = Color(10,150,10,100)
			if self.Owner:GetNoDraw() and self.Aura and !(LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer())) then
				self.Aura:StopEmission()
				self.Aura = nil
			end
			if !self.Owner:GetNoDraw() and CLIENT and LocalPlayer():GetActiveWeapon() then
				if LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then
					
					self.Aura = self.Aura or CreateParticleSystem(self.Owner, "auraeffect", PATTACH_POINT_FOLLOW, 1)
					self.Aura:SetControlPoint(1, Vector(self.Color.r / 255, self.Color.g / 255, self.Color.b / 255))
					
					local selfT = { Ents = self }
					local haloInfo = 
					{
						Ents = selfT,
						Color = Color(200,0,100,255),
						Hidden = when_hidden,
						BlurX = math.sin(CurTime()) * 5,
						BlurY = math.sin(CurTime()) * 5,
						DrawPasses = 5,
						Additive = true,
						IgnoreZ = false
					}
					self:DrawModel() 
					if GetConVar("gstands_draw_halos"):GetBool() and self.Owner:WaterLevel() < 1 and render.SupportsHDR and !LocalPlayer():IsWorldClicking() then
						
						halo.Render(haloInfo)
					end
				end
			end
			elseif self.Aura then
			self.Aura:StopEmission()
			self.Aura = nil
		end
		else
		self.WorldModel = "models/player/whitesnake/disc.mdl"
		self:DrawModel()
	end
end
local thirdperson_offset = GetConVar("gstands_thirdperson_offset")
function SWEP:CalcView( ply, pos, ang, fov )
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
function SWEP:Deploy()
	self:SetHoldType( "stando" )
	
	
	if self.Owner:Health() == 100  then
        self.Owner:SetMaxHealth( self.Durability )
        self.Owner:SetHealth( self.Durability )
	end
	if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitStandSound(Deploy)
			self.Owner:EmitStandSound(SDeploy)
		end
	end
	self.Aura = nil
	
	self.Owner:SetCanZoom(false)
end

function SWEP:Think()
	self.LastOwner = self.Owner
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
	end
	self.HealTimer = self.HealTimer or CurTime()
	if CurTime() >= self.HealTimer then
		local heals = ents.FindInSphere(self.Owner:WorldSpaceCenter(), self.Range)
		for k,v in pairs(heals) do
			self:Heal(v, v.Spored)
		end
		self.HealTimer = CurTime() + 0.4
	end
	self.RelDelay = self.RelDelay or CurTime()
	if self.Owner:gStandsKeyDown("modeswap") and SERVER and CurTime() >= self.RelDelay then
		local tr = util.TraceLine( {
			start = self.Owner:EyePos(),
			endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * self.Range,
			filter = { self.Owner, self },
			mask = MASK_SHOT_HULL
		} )
		if tr.Hit then
			local flower = ents.Create("kfarose")
			flower:SetPos(tr.HitPos)
			flower:SetOwner(self.Owner)
			flower:SetAngles(tr.HitNormal:Angle() + Angle(90, 0, 0))
			flower:Spawn()
			if flower:IsValid() then
				self.RelDelay = CurTime() + 5
			end
		end
	end
end

function SWEP:Heal(ent, spored)
    if ent:Health() < ent:GetMaxHealth() then
		local mult = 1
		if spored then
			mult = 2
		end
		ent:SetHealth(math.Clamp(ent:Health() + 1 * mult, 0, ent:GetMaxHealth()))
	end
end

function SWEP:SecondaryAttack()
	local tr = util.TraceLine( {
		start = self.Owner:EyePos(),
		endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 55,
		filter = { self.Owner, self },
		ignoreworld = true,
		mask = MASK_SHOT_HULL
	} )
	if tr.Hit and tr.Entity:IsValid() and (tr.Entity:IsPlayer() or tr.Entity:IsNPC()) then
		tr.Entity.Spored = true
		ParticleEffectAttach("kfartarget", PATTACH_POINT_FOLLOW, tr.Entity, 1)
		timer.Simple(5, function()
			if tr.Entity:IsValid() then
				tr.Entity.Spored = false
				tr.Entity:StopParticles()
			end
		end)
	end
	self:SetNextSecondaryFire(CurTime() + 5)
end
function SWEP:PrimaryAttack()
	if SERVER then
		local tr = util.TraceLine( {
			start = self.Owner:EyePos(),
			endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * self.Range,
			filter = { self.Owner, self },
			mask = MASK_SHOT_HULL
		} )
		local flower = ents.Create("kfaspores")
		flower:SetPos(tr.HitPos)
		flower:SetOwner(self.Owner)
		flower:SetAngles(self.Owner:GetEyeTrace().HitNormal:Angle() + Angle(90, 0, 0))
		flower:Spawn()
		if flower:IsValid() then
			self:SetNextPrimaryFire(CurTime() + 10)
		end
	end
end

function SWEP:Reload()
	
end


function SWEP:OnDrop()
	if IsValid(self.LastOwner) then
		self.LastOwner:StopParticles()
	end
	self.WorldModel = "models/player/whitesnake/disc.mdl"
	if CLIENT and self.Aura then
		self.Aura:StopEmission()
		self.Aura = nil
	end
	return true
end

function SWEP:OnRemove()
	if IsValid(self.Owner) then
		self.Owner:StopParticles()
	end
	if CLIENT and self.Aura then
		self.Aura:StopEmission()
		self.Aura = nil
	end
	return true
end
function SWEP:Holster()
	self.Owner:StopParticles()
	if SERVER then
		self.Owner:EmitStandSound(Withdraw)
	end
	if CLIENT and self.Aura then
		self.Aura:StopEmission()
		self.Aura = nil
	end
	return true
	
end