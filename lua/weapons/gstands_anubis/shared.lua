--Send file to clients
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot      = 1
end

SWEP.Power = 2.5
SWEP.Speed = 1.25
SWEP.Range = 100
SWEP.Durability = 1500
SWEP.Precision = nil
SWEP.DevPos = nil

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.anubis.purpose"
SWEP.Instructions  = "#gstands.anubis.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.anubis"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos            = 2
SWEP.DrawCrosshair      = true

SWEP.WorldModel = "models/anubis/w_anubis.mdl"
SWEP.ViewModelFOV = 54
SWEP.UseHands = true
SWEP.ScriptedEntityType = "gStands"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.HitDistance = 145
SWEP.gStands_IsThirdPerson = true

local PrevHealth = nil

local Deploy = Sound( "weapons/anubis/deploy.wav" )

--Define swing and hit sounds. Might change these later.

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
	[ "stando" ]		= ACT_HL2MP_IDLE_MELEE2
    
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
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE_KNIFE + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_CHARGING
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_01"))
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_fists_r"))
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_fists_r"))
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

function SWEP:SetupDataTables()
		self:NetworkVar("Bool", 0, "Broken")
end

function SWEP:Initialize()
    --Set the third person hold type to fists    
end

function SWEP:ResetPhysAttributes()
	self.Owner:SetWalkSpeed(190)
	self.Owner:SetRunSpeed(320)
	self.Owner:SetJumpPower(200)
end
function SWEP:SetPhysAttributes()
	self.Owner:SetWalkSpeed(440)
	self.Owner:SetRunSpeed(750)
	self.Owner:SetJumpPower(400)
end

--Third Person View
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
		local color = gStands.GetStandColorTable("models/anubis/anubis.mdl", "0")
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
hook.Add( "HUDShouldDraw", "AnubisHud", function(elem)
	if IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_anubis" and (elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") and GetConVar("gstands_draw_hud"):GetBool() then
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

SWEP.blocked = {}
--Deploy starts up the stand
function SWEP:Deploy()
	self:SetHoldType( "stando" )
    if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitSound(Deploy)
		end
		hook.Add("KeyPress", "AnubisCheckForKeys", function(ply, key)
		if key == IN_ATTACK or key == IN_ATTACK2 or key == IN_RELOAD or key == IN_WEAPON1 or key == IN_WEAPON2 or key == IN_BULLRUSH or key == IN_GRENADE1 or key == IN_GRENADE2 then
			ply.AnubisLastKey = key
		end
		if ply.GetActiveWeapon and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon().GetAMode then
			local mode = ply:GetActiveWeapon():GetAMode()
			if mode then
				ply.AnubisLastMode = 1
			else
				ply.AnubisLastMode = -1
			end
		end
		end)
		local function CheckIfBlocked(ply, inflictor)
			local mode = 0
			if ply.GetActiveWeapon and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon().GetAMode and ply:GetActiveWeapon():GetAMode() then
				mode = 1
				elseif ply.GetActiveWeapon and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon().GetAMode and !ply:GetActiveWeapon():GetAMode() then
				mode = -1
			end
			if self.blocked[ply] then
				if !inflictor:IsWeapon() and table.HasValue(self.blocked[ply], inflictor:GetClass()) then
					return true
				end
				if self.blocked[ply][ply:GetActiveWeapon()] and table.HasValue(self.blocked[ply][ply:GetActiveWeapon()], ply.AnubisLastKey + mode) then
					return true
				else 
					return false
				end
			else
			return false
			end
		end
		hook.Add("EntityTakeDamage", "AnubisBlock_"..self.Owner:GetName(), function(target, dmginfo)
			
			if IsValid(target) and IsValid(self.Owner) and target == self.Owner and dmginfo:GetAttacker() != self.Owner and dmginfo:GetAttacker():GetClass() != "entityflame" and !target.TSDamage then
				if !self:GetBroken() and (dmginfo:GetAttacker():IsPlayer()) and CheckIfBlocked(dmginfo:GetAttacker(), dmginfo:GetInflictor()) then
                    target:SetAnimation(PLAYER_RELOAD)
					
					target:EmitSound("physics/metal/metal_solid_impact_bullet"..math.random(1,4)..".wav")
					local fx = EffectData()
						fx:SetOrigin(dmginfo:GetReportedPosition())
						util.Effect("ManhackSparks", fx, true, true)
					return true
					elseif !self:GetBroken() and CheckIfBlocked(dmginfo:GetAttacker(), dmginfo:GetInflictor()) then 
					target:EmitSound("physics/metal/metal_solid_impact_bullet"..math.random(1,4)..".wav")
                    target:SetAnimation(PLAYER_RELOAD)
					local fx = EffectData()
						fx:SetOrigin(dmginfo:GetReportedPosition())
						util.Effect("ManhackSparks", fx, true, true)
					return true
					elseif self:GetBroken() and target:KeyDown(IN_ATTACK2) and (dmginfo:GetAttacker():IsPlayer()) and CheckIfBlocked(dmginfo:GetAttacker(), dmginfo:GetInflictor()) then
                    target:SetAnimation(PLAYER_RELOAD)
					
					target:EmitSound("physics/metal/metal_solid_impact_bullet"..math.random(1,4)..".wav")
					local fx = EffectData()
						fx:SetOrigin(dmginfo:GetReportedPosition())
						util.Effect("ManhackSparks", fx, true, true)
					return true
					elseif self:GetBroken() and target:KeyDown(IN_ATTACK2) and CheckIfBlocked(dmginfo:GetAttacker(), dmginfo:GetInflictor()) then 
					target:EmitSound("physics/metal/metal_solid_impact_bullet"..math.random(1,4)..".wav")
                    target:SetAnimation(PLAYER_RELOAD)
					local fx = EffectData()
						fx:SetOrigin(dmginfo:GetReportedPosition())
						util.Effect("ManhackSparks", fx, true, true)
					return true
					elseif IsValid(target) and target:KeyDown(IN_ATTACK2) and dmginfo:GetAttacker():IsPlayer() then
                    if dmginfo:GetDamage() >= 150 then
						self:SetBroken(true)
						target:EmitSound("physics/metal/metal_break2.wav", 75, 200)
						else
						target:EmitSound("physics/metal/metal_grate_impact_hard"..math.random(1,3)..".wav")
					end
					if SERVER then
						local light = ents.Create("light_dynamic")
						light:SetPos(self.Owner:EyePos())
						light:Spawn()
						light:Activate()
						light:SetKeyValue("distance", 100)
						light:SetKeyValue("brightness", 8)
						light:SetKeyValue("_light", "255 15 255 255")
						light:Fire("TurnOn")
						light:SetParent(self)
						timer.Simple(0.1, function() light:SetKeyValue("brightness", 0) end)
						timer.Simple(0.35, function() light:Remove() end)
						local fx = EffectData()
						fx:SetOrigin(dmginfo:GetReportedPosition())
						util.Effect("ManhackSparks", fx, true, true)
					end
                    target:SetAnimation(PLAYER_RELOAD)
					self.blocked[dmginfo:GetAttacker()] = self.blocked[dmginfo:GetAttacker()] or {}
					self.blocked[dmginfo:GetAttacker()][dmginfo:GetInflictor()] = self.blocked[dmginfo:GetAttacker()][dmginfo:GetInflictor()] or {}
					if dmginfo:GetInflictor():IsWeapon() then
					dmginfo:GetAttacker().AnubisLastMode = dmginfo:GetAttacker().AnubisLastMode or 0
					table.insert(self.blocked[dmginfo:GetAttacker()][dmginfo:GetAttacker():GetActiveWeapon()], dmginfo:GetAttacker().AnubisLastKey + dmginfo:GetAttacker().AnubisLastMode)
					dmginfo:GetAttacker().AnubisLastKey = 0
					else
					table.insert(self.blocked[dmginfo:GetAttacker()], dmginfo:GetInflictor():GetClass())
					end
					elseif IsValid(target) and target:KeyDown(IN_ATTACK2) then
					if dmginfo:GetDamage() >= 150 then
						self:SetBroken(true)
						target:EmitSound("physics/metal/metal_break2.wav", 75, 200)
						else
						target:EmitSound("physics/metal/metal_grate_impact_hard"..math.random(1,3)..".wav")
					end
					if SERVER then
						local light = ents.Create("light_dynamic")
						light:SetPos(self.Owner:EyePos())
						light:Spawn()
						light:Activate()
						light:SetKeyValue("distance", 100)
						light:SetKeyValue("brightness", 8)
						light:SetKeyValue("_light", "255 15 255 255")
						light:Fire("TurnOn")
						light:SetParent(self)
						timer.Simple(0.1, function() light:SetKeyValue("brightness", 0) end)
						timer.Simple(0.35, function() light:Remove() end)
					end
                    target:SetAnimation(PLAYER_RELOAD)
					self.blocked[dmginfo:GetAttacker()] = self.blocked[dmginfo:GetAttacker()] or {}
					self.blocked[dmginfo:GetAttacker()][dmginfo:GetInflictor()] = self.blocked[dmginfo:GetAttacker()][dmginfo:GetInflictor()] or {}
					if dmginfo:GetInflictor():IsWeapon() then
					table.insert(self.blocked[dmginfo:GetAttacker()][dmginfo:GetAttacker():GetActiveWeapon()], dmginfo:GetAttacker().AnubisLastKey + dmginfo:GetAttacker().AnubisLastMode)
					dmginfo:GetAttacker().AnubisLastKey = 0
					else
					table.insert(self.blocked[dmginfo:GetAttacker()], dmginfo:GetInflictor():GetClass())
					end
				end
			end
		end)
	end
    --As is standard with stand addons, set health to 1000
    if self.Owner:Health() == 100  then
        self.Owner:SetMaxHealth( self.Durability )
        self.Owner:SetHealth( self.Durability )
	end
    if SERVER then
		self:SetPhysAttributes()
	end
    --Create some networked variables, solves some issues where multiple people had the same stand
	self.Owner:SetCanZoom(false)
    owner = self.Owner
end

function SWEP:Think()
    if self:GetBroken() then
		self.HitDistance = 48
		self.WorldModel = "models/anubis/w_anubis_broken.mdl"
	end
	local curtime = CurTime()
	table.RemoveByValue(self.blocked, nil)
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
	if self.Owner:gStandsKeyDown("tertattack") and 
		self:GetAnubisClosest(self.Owner) and self:GetAnubisClosest(self.Owner):IsValid() then
		local ang = (self:GetAnubisClosest(self.Owner):EyePos() - self.Owner:EyePos()):GetNormalized():Angle()
		self.Owner:SetEyeAngles(ang)
	end
    if self.Owner:KeyDown(IN_FORWARD) then
        self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] = self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_knife"))
        else
        self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] = ACT_HL2MP_IDLE_MELEE2 + 5
	end
    self:NextThink(CurTime())
    return true
end


function SWEP:PrimaryAttack()
    if !self.Owner:KeyDown(IN_ATTACK2) then
        self.Owner:SetAnimation( PLAYER_ATTACK1 )
        if SERVER then
			local pos = self.Owner:WorldSpaceCenter() + self.Owner:GetAimVector() * 15
			local endpos = self.Owner:WorldSpaceCenter() + self.Owner:GetAimVector() * self.HitDistance
			local mins, maxs = Vector(-25,-25,-35), Vector(25,25,35)
			local tr = util.TraceHull( {
				start = pos,
				endpos = endpos,
				filter = {self.Owner},
				mins = mins, 
				maxs = maxs,
				ignoreworld = false,
				mask = MASK_SHOT_HULL
				
			} )

			self.Owner:EmitSound("weapons/anubis/katana_swing_miss1.wav")
			if SERVER and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue("explosion", "2") tr.Entity:SetKeyValue("gibdir", tostring(self.Owner:GetAngles())) tr.Entity:Fire("Break") end
			
			if tr.Entity:IsValid() and (tr.Entity:GetClass() == "stand" )then
				local dmginfo = DamageInfo()
				
				local attacker = self.Owner
				dmginfo:SetAttacker( attacker )
				
				dmginfo:SetInflictor( self )
				--High damage, but not quite enough to kill.
				dmginfo:SetDamage( 35 * self.Power )
                tr.Entity:TakeDamageInfo( dmginfo )
				
			end
			
			
			local hit = self.Owner:TraceHullAttack(pos,endpos,mins, maxs,35 * self.Power,DMG_SLASH, 1, true)
			if IsValid(hit) then
				self.Owner:EmitSound("weapons/anubis/melee_katana_0"..math.random(1,3)..".wav" )
			end
		end
		if !self:GetBroken() then
			self:SetNextPrimaryFire( CurTime() + (0.4 * self.Speed) )
		else
		        self:SetNextPrimaryFire( CurTime() + (0.3 * self.Speed) )
		end
        --Set time until power punch.
        self:SetNextSecondaryFire( CurTime() + (0.1 * self.Speed) )
	end
end
function SWEP:GetAnubisClosest(ply)
	local closestply
	local closestdist
	for k, v in pairs(player.GetAll()) do
		if v != ply and v:GetPos():Distance(ply:GetPos()) <= 500 then
			local dist = ply:GetPos():DistToSqr(v:GetPos())
			if not closestdist then
				closestdist = dist
			end
			if dist <= closestdist then
				closestply = v
			end
		end
	end
	return closestply
end
function SWEP:SecondaryAttack()
	
    --No spamming the donut punch.
	self:SetNextPrimaryFire( CurTime() + (0.1 * self.Speed) )
	self:SetNextSecondaryFire( CurTime() )
end


--Screw this entire section, it only works like 20% of the time. Basically, meant to catch every time the weapon is not in your hands in order to remove the stand.
function SWEP:OnDrop()
    self.blocked = {}
    if SERVER then
		hook.Remove("EntityTakeDamage", "AnubisBlock_"..self.Owner:GetName())
		hook.Remove("EntityTakeDamage", "AnubisBlock")
		self:ResetPhysAttributes()
	end
    return true
end

function SWEP:OnRemove()
    self.blocked = {}
    if SERVER then
		hook.Remove("EntityTakeDamage", "AnubisBlock_"..self.Owner:GetName())
        hook.Remove("EntityTakeDamage", "AnubisBlock")
		self:ResetPhysAttributes()
		
	end
    return true
end

function SWEP:Holster()
    self.blocked = {}
	
    if SERVER then
		hook.Remove("EntityTakeDamage", "AnubisBlock_"..self.Owner:GetName())
        hook.Remove("EntityTakeDamage", "AnubisBlock")
		self:ResetPhysAttributes()
		
	end
    return true
end
function SWEP:DrawWorldModel()
		if self:GetBroken() then
			self.WorldModel = "models/anubis/w_anubis_broken.mdl"
		end
		--self.BaseClass.Draw(self) -- Overrides Draw 
		local selfT = { Ents = self }
		local haloInfo = 
		{
			Ents = selfT,
			Color = Color(150,100,255,255),
			Hidden = when_hidden,
			BlurX = math.sin(CurTime()) * 15,
			BlurY = math.sin(CurTime()) * 15,
			DrawPasses = 5,
			Additive = true,
			IgnoreZ = false
		}
		self:DrawModel() -- Draws Model Client Side
		if GetConVar("gstands_draw_halos"):GetBool() and self:WaterLevel() < 1 and render.SupportsHDR and !LocalPlayer():IsWorldClicking() then
			
			halo.Render(haloInfo)
		end
end