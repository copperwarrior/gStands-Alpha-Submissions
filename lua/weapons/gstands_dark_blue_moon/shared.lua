
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot      = 1
end

SWEP.Power = 2
SWEP.Speed = 0.5
SWEP.Range = 800
SWEP.Durability = 1000
SWEP.Precision = A
SWEP.DevPos = A

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.dbm.purpose"
SWEP.Instructions  = "#gstands.dbm.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.dbm"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos            = 2
SWEP.DrawCrosshair      = true

SWEP.WorldModel     = "models/player/whitesnake/disc.mdl"
SWEP.ViewModelFOV   = 54
SWEP.UseHands       = true

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"

SWEP.DrawAmmo       = false
SWEP.HitDistance    = 48
SWEP.sub = false

SWEP.ShootFX = NUL
SWEP.StandModel = "models/player/dbm/dbm.mdl"
SWEP.StandModelP = "models/player/dbm/dbm.mdl"
if CLIENT then
	SWEP.StandModel = "models/player/dbm/dbm.mdl"
end
SWEP.gStands_IsThirdPerson = true

game.AddParticles("particles/whirl.pcf")
PrecacheParticleSystem("whirl")
PrecacheParticleSystem("sawblade")
PrecacheParticleSystem("blast")

local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )

local Deploy = Sound("weapons/dbm/deploy.wav")
local SDeploy = Sound("weapons/dbm/sdeploy.wav")
local Death = Sound("weapons/dbm/death.wav")
local Sashimi = Sound("weapons/dbm/sashimi.wav")
local Lightly = Sound("weapons/dbm/lightly.wav")
local Grab = Sound( "weapons/platinum/grab.wav" )


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
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE_SUITCASE + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_01"))
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_melee_shove_1hand"))
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_melee_shove_1hand"))
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_item_place"))
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_item_place"))
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
	
	if ( t == "normal" ) then
		self.ActivityTranslate[ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end
    
    
end

function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Stand")
	self:NetworkVar("Bool", 1, "Vortex")
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
	if GetConVar("gstands_draw_hud"):GetBool() then
		local color = gStands.GetStandColorTable(self.Stand:GetModel(), self.Stand:GetSkin())
		local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
		
		surface.SetMaterial(generic_rect)
		surface.DrawTexturedRect(width - (256 * mult) - 30 * mult, height - (128 * mult) - 30 * mult, 256 * mult, 128 * mult)
		
		self.WaterLevelZ = self.WaterLevelZ or self.Owner:GetPos().z
		local lvl = math.Round(((self.WaterLevelZ - self.Owner:GetPos().z))/300 + 1)
		if LocalPlayer():WaterLevel() < 1 then
			lvl = 0
		end
		draw.TextShadow({
			text = Format(language.GetPhrase("gstands.dbm.waterlevel"), lvl),
			font = "gStandsFont",
			pos = {width - 160 * mult, height - 120 * mult},
			color = tcolor,
			xalign = TEXT_ALIGN_CENTER
		}, 2 * mult, 250)
		
	end
end
hook.Add( "HUDShouldDraw", "DarkBlueMoonHud", function(elem)
	if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_dark_blue_moon" and (((elem == "CHudWeaponSelection" ) and LocalPlayer().SPInZoom) or elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
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
if CLIENT then
    net.Receive("DBM.Decal", function() 
		local target = net.ReadEntity()
		local owner = net.ReadEntity()
		local normal = (owner.Owner:WorldSpaceCenter() - target:WorldSpaceCenter()):GetNormalized()
        util.DecalEx(owner.mat, target, target:WorldSpaceCenter(), normal, Color(0,0,0), 0.07,0.07)
	end)
    net.Receive("DBM.DecalRemove", function() 
		local target = net.ReadEntity()
		target:RemoveAllDecals()
	end)
end
if SERVER then
    util.AddNetworkString("DBM.Decal")
    util.AddNetworkString("DBM.DecalRemove")
end


local thirdperson_offset = GetConVar("gstands_thirdperson_offset")
function SWEP:CalcView( ply, pos, ang )
if not self.gStands_IsThirdPerson or ply:GetViewEntity() ~= ply then return end	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid(self:GetStand()) and self:GetStand().GetInDoDoDo and self:GetStand():GetInDoDoDo() then
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
    self:SetHoldType( "stando" )
	
    
    if self.Owner:Health() == 100  then
        self.Owner:SetMaxHealth( self.Durability )
        self.Owner:SetHealth( self.Durability )
	end
    
    
    self:DefineStand()
    
    
    if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitSound(Deploy)
			self.Owner:EmitStandSound(SDeploy)
		end
	end
    self.DelayDmg = CurTime()
	local hooktag = self.Owner:GetName()
	hook.Add("PreDrawEffects","DBMSeeUnderWater"..hooktag,
		function()
			if !(self:IsValid() and self.Owner:IsValid()) then 
				hook.Remove("PreDrawEffects","DBMSeeUnderWater"..hooktag) return 
			end
			if self.Owner:WaterLevel() > 0 and (self:IsValid() and self.Owner:IsValid() and IsValid(self:GetStand()) ) then
				local ang = EyeAngles()
				ang = Angle(ang.p+90,ang.y,0)
				
				cam.Start3D2D(EyePos()+EyeAngles():Forward()*10,ang,1)
				render.SetBlend(1)
				render.ClearStencil()
				render.SetStencilEnable(true)
				render.SetStencilWriteMask(255)
				render.SetStencilTestMask(255)
				render.SetStencilReferenceValue(15)
				render.SetStencilFailOperation(STENCILOPERATION_KEEP)
				render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
				render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
				local clr = gStands.GetStandColor("models/player/dbm/dbm.mdl", self:GetStand():GetSkin()) * 255
				
				surface.SetDrawColor(clr.x, clr.y, clr.z,150)
				local w,h = ScrW(), ScrH()
				for _,v in pairs(player.GetAll()) do
					if v:WaterLevel() > 0 and v != self.Owner then
						render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
						
						local prevNoDraw = v:GetNoDraw()
						v:SetNoDraw(false)
						local prevRenderMode = v:GetRenderMode()
						v:SetRenderMode(RENDERMODE_TRANSALPHADD)
						v:DrawModel()
						v:SetRenderMode(prevRenderMode)
						v:SetNoDraw(prevNoDraw)
						
						render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
						
						surface.DrawRect(-w,-h,w*2,h*2)
					end
				end
				
				render.SetStencilEnable(false)
				render.SetBlend(1)
				cam.End3D2D()
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
			"SWIMMING_ALL", 0,
			"GMOD_BREATH_LAYER", 0,
			"AIMLAYER_CAMERA", 0,
			"IDLE_SUITCASE", 0,
			"FIST_BLOCK", 0,
		}
        self.Stand:Spawn()
	end
	timer.Simple(0.1, function()
		self.Stand.rgl = 1.7
		self.Stand.ggl = 1.7
		self.Stand.bgl = 3
		self.Stand.rglm = 1.3
		self.Stand.gglm = 1.3
		self.Stand.bglm = 1.3
	end)
end
local water = Material("effects/water_warp01")
DBM_Water1 = DBM_Water1 or Material("nature/water_warp01_dx8")
DBM_Water2 = DBM_Water2 or {Material("nature/water_coast01_beneath")}
hook.Add("Think", "LoadWater", function()
	if game.GetWorld():IsWorld() and !DBM_WaterMatLoad then
		for k,v in pairs(game.GetWorld():GetMaterials()) do
			
			local mat = Material(v)
			if string.StartWith(mat:GetShader(), "Water") then
				table.insert(DBM_Water2, mat)
			end
		end
		DBM_WaterMatLoad = true
	end
end)
if game.GetWorld():IsWorld() then
	for k,v in pairs(game.GetWorld():GetMaterials()) do
		
		local mat = Material(v)
		if string.StartWith(mat:GetShader(), "Water") then
			table.insert(DBM_Water2, mat)
		end
	end
end
function SWEP:DrawWorldModel()
	if IsValid(self.Owner) then
		if self:GetVortex() and IsValid(self:GetStand()) then
			if !self.Flames then
				self.Flames = CreateParticleSystem(self:GetStand(), "whirl", PATTACH_POINT, 1)
			end
			if self.Flames and IsValid(self:GetStand()) and self:GetStand():GetAttachment(1).Pos then
				local trW = util.TraceLine( {
					start = self:GetStand():GetEyePos(true) + Vector(0,0,1000),
					endpos = self:GetStand():GetEyePos(true),
					filter = self.Owner,
					mask = CONTENTS_WATER,
				} )
				self.Flames:SetControlPoint(2, gStands.GetStandColor(self:GetStand():GetModel(), self:GetStand():GetSkin()))
				self.Flames:SetControlPoint(1, self:GetStand():GetEyePos(true))
				self.Flames:SetControlPoint(0, trW.HitPos)
				self.Flames:SetControlPointForwardVector(0, self:GetStand():GetForward())
			end
			else
			if self.Flames then
				self.Flames:StopEmission()
				self.Flames = nil
			end
		end
		if LocalPlayer() == self.Owner and LocalPlayer():WaterLevel() > 0 and #DBM_Water2 != 0 then
			self.WaterInfo = self.WaterInfo or
			{ 
				{
					water:GetFloat("$bluramount"),
					water:GetFloat("$refractamount"),
				},
				{
					DBM_Water1:GetFloat("$bluramount"),
					DBM_Water1:GetFloat("$refractamount"),
				},
			}
			local waters = {}
			for k,v in pairs(DBM_Water2) do
				if !isnumber(v) then
					table.insert(waters, 
						{
							v:GetInt("$fogenable"),
							v:GetFloat("$fogstart"),
							v:GetFloat("$fogend"),
						})
				end
			end
			table.insert(self.WaterInfo, waters)
			water:SetFloat("$bluramount", 0)
			water:SetFloat("$refractamount", 0)
			DBM_Water1:SetFloat("$bluramount", 0)
			DBM_Water1:SetFloat("$refractamount", 0)
			local i = 1
			for k,v in pairs(DBM_Water2) do
				if !isnumber(v) then
					v:SetInt("$fogenable", "1")
					v:SetFloat("$fogstart", "0")
					v:SetFloat("$fogend", self.WaterInfo[3][i][3] * 5)
					i = i + 1
				end
			end
			elseif self.WaterInfo then
			water:SetFloat("$bluramount", self.WaterInfo[1][1])
			water:SetFloat("$refractamount", self.WaterInfo[1][2])
			DBM_Water1:SetFloat("$bluramount", self.WaterInfo[2][1])
			DBM_Water1:SetFloat("$refractamount", self.WaterInfo[2][2])
			local i = 1
			for k,v in pairs(DBM_Water2) do
				if !isnumber(v) then
					v:SetInt("$fogenable", self.WaterInfo[3][i][1])
					v:SetFloat("$fogstart", self.WaterInfo[3][i][2])
					v:SetFloat("$fogend", self.WaterInfo[3][i][3])
					i = i + 1
				end
			end
		end
		else
		self:DrawModel()
	end
end

function SWEP:Think()
	self.Stand = self:GetStand()
    if !self.Stand:IsValid() then
        self:DefineStand()
	end
    if self.Owner:IsOnFire() and self.Owner:WaterLevel() > 2 then
        self.Owner:Extinguish()
	end
	self.LastHealth = self.LastHealth or self.Owner:Health()
	if SERVER and self.Owner:Health() < self.LastHealth then
		for k,v in pairs(ents.FindInSphere(self:GetStand():WorldSpaceCenter(), 100)) do
			if v:Health() > 0 and v != self.Owner and v != self:GetStand() then
				if !v.Barnacled then
					local trace = util.TraceLine( {
						start = self:GetStand():WorldSpaceCenter(),
						endpos = v:WorldSpaceCenter(),
						filter = function(ent) if ent != v then return false end return true end,
						mask = MASK_SHOT_HULL,
						ignoreworld = true
					} )
					print(v)
					local barnacle = ents.Create("dbm_barnacle")
					barnacle:SetTarget(v)
					barnacle:SetPos(trace.HitPos)
					barnacle:SetParent(v)
					barnacle:SetOwner(self.Owner)
					v.Barnacled = true
					barnacle:Spawn()
					barnacle:Activate()
				end
			end
		end
	end
	self.LastHealth = self.Owner:Health()
	self.HealTimer = self.HealTimer or CurTime()
	if CurTime() > self.HealTimer and self.Owner:Health() < self.Owner:GetMaxHealth() and self.Owner:WaterLevel() > 0 then
		self.Owner:SetHealth(math.Clamp(self.Owner:Health() + 1, 0, self.Owner:GetMaxHealth())) 
		self.HealTimer = CurTime() + 1
	end
	if SERVER and self.Owner:KeyDown(IN_SPEED) and self.Stand:WaterLevel() > 1 and self.Owner:GetVelocity():Length() > 55 then
		for k,v in pairs(ents.FindInSphere(self:GetStand():WorldSpaceCenter(), 100)) do
			if v:Health() and v != self.Owner and v != self:GetStand() then
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker( self.Owner )
				
				dmginfo:SetInflictor( self )
				dmginfo:SetDamage( 5 )
				
				v:TakeDamageInfo( dmginfo )
			end
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
    if self.LastWatLev and self.LastWatLev > 0 and self.LastWatLev > self.Owner:WaterLevel() then
        self.Owner:SetVelocity(Vector(0,0,100))
	end
    self.LastWatLev = self.Owner:WaterLevel()
	
    if self.Owner:WaterLevel() > 0 then
		self.Owner:SetDSP(0)
        if SERVER then
			self.Stand:RemoveAllGestures()
		end
        if !self.sub then
			self.PrevWS = self.Owner:GetWalkSpeed()
			self.PrevRS = self.Owner:GetRunSpeed()
			self.PrevJP = self.Owner:GetJumpPower()
			self.WaterLevelZ = self.Owner:GetPos().z
			self.sub = true
		end
		if SERVER then
			self:SetPhysAttributes(((self.WaterLevelZ - self.Owner:GetPos().z))/300 + 1)
		end
		else
		if SERVER then
			self:ResetPhysAttributes()
		end
        self.sub = false
	end
    if self.Owner:gStandsKeyPressed("modeswap") and self.Stand:WaterLevel() > 2 then
        if SERVER then
            self.Stand:RemoveAllGestures()
		end
		self:SetVortex(true)
        self.WhirlSFX = CreateSound(self.Owner, "ambient/weather/rumble_rain.wav")
        self.WhirlSFX:PlayEx(1, math.random(38,41))
        timer.Create("DBMSound"..self.Owner:GetName(), 2.426, 0, function()
			self.WhirlSFX:PlayEx(1, math.random(38,41))
		end)
        local trW = util.TraceLine( {
			start = self.Stand:GetEyePos() + Vector(0,0,1) * 1000,
			endpos = self.Stand:GetEyePos(),
			filter = self.Owner,
			mask = CONTENTS_WATER,
		} )
		self:SetHoldType("pistol")
	end
    if !self.Owner:gStandsKeyDown("modeswap") or self.Stand:WaterLevel() <= 2 then
        if self.WhirlSFX then
			timer.Remove("DBMSound"..self.Owner:GetName())
			self.WhirlSFX:FadeOut(2)
		end
		self:SetVortex(false)
        self:StopParticles()
	end
    if self.Owner:gStandsKeyDown("modeswap") and self.Stand:WaterLevel() > 2 and !self.Owner.IsKnockedOut then
		self.Stand:ResetSequence(self.Stand:LookupSequence("whirlpool"))
        self:Vortex()
	end
    if self.Owner:gStandsKeyReleased("modeswap") then
		self:SetVortex(false)
		self:SetHoldType("stando")
	end
	self.StandBlockTimer = self.StandBlockTimer or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("block") and CurTime() > self.StandBlockTimer then
		self.Stand.HeadRotOffset = -5
		self:SetHoldType("pistol")
		self.Stand:ResetSequence(self.Stand:LookupSequence( "standblock" ))
		self.Stand:SetCycle(0)
		timer.Simple(self.Stand:SequenceDuration("standblock"), function() self:SetHoldType("stando") self.Stand.HeadRotOffset = -75 end)
		self.StandBlockTimer = CurTime() + self.Stand:SequenceDuration("standblock") + 0.5
	end
end

function SWEP:ResetPhysAttributes()
	if IsValid(self.Owner) then
		self.Owner:SetWalkSpeed(self.PrevWS or 190)
		self.Owner:SetRunSpeed(self.PrevRS or 320)
		self.Owner:SetJumpPower(self.PrevJP or 200)
	end
end
function SWEP:SetPhysAttributes(wl)
	wl = math.max(wl, 1)
	self.Owner:SetWalkSpeed(190 * (wl + 0.3))
	self.Owner:SetRunSpeed(620 * (wl + 0.3))
	self.Owner:SetJumpPower(200 * (wl + 0.3))
end

function SWEP:Vortex()
	local trW = util.TraceLine( {
		start = self.Stand:GetEyePos() + self.Owner:GetUp() * 1000,
		endpos = self.Stand:GetEyePos(),
		filter = self.Owner,
		mask = CONTENTS_WATER,
	} )
	local entities = ents.FindInCone(self.Owner:GetPos() - Vector(0,0,40), Vector(0,0,1), self.Owner:GetPos():Distance(trW.HitPos) + 40, 0.2)
	local selfpos_norm = Vector(self:GetPos().x, self:GetPos().y, 0)
	
	for k, v in ipairs(entities) do
		if v != self.Owner and v != self.Stand then
			if v:GetPhysicsObject():IsValid() and v:WaterLevel() > 0 then
				local basevel = v:GetVelocity()
				local norm = -(v:GetPos() - self.Stand:GetEyePos(true)):GetNormalized() * 750
				norm.z = norm.z / 500
				local ang = norm:Angle()
				local norm2 = ang:Right() * 250
				phys = v:GetPhysicsObject()
				if v:IsPlayer() or v:IsNPC() then
					
					v:SetVelocity((norm + norm2):GetNormalized() * 500)
					else
					phys:SetVelocity((norm + norm2):GetNormalized() * 500)
				end
			end
			self.DamageTickVortex = self.DamageTickVortex or CurTime()
			if SERVER and CurTime() > self.DamageTickVortex then
				local dmg = DamageInfo()
				dmg:SetAttacker(self.Owner)
				dmg:SetInflictor(self)
				dmg:SetDamage(55)
				if v:Health() <= 1 then
					self.WithdrawSpecial = true
					timer.Simple(3, function() if IsValid(self) then self.WithdrawSpecial = false end end)
				end
				dmg:SetDamageType(DMG_SLASH)
				v:TakeDamageInfo(dmg)
				self.DamageTickVortex = CurTime() + 0.5
			end
		end
	end
end
function SWEP:PrimaryAttack()
    if self.Owner:WaterLevel() > 2 and self.Owner:gStandsKeyDown("modifierkey1") then
		self:SetHoldType("pistol")
		self.Owner:EmitSound(Sashimi)
        self.Stand:ResetSequence( self.Stand:LookupSequence("sawblade") )
		self.Stand:SetCycle( 0 )
		timer.Simple(self.Stand:SequenceDuration(), function() self:SetHoldType("stando") end)
        timer.Create("dbmAttack"..self.Owner:GetName(), 0.3, 1, function()
			if SERVER then
				local sword = ents.Create("dbm_sawblade")
				if IsValid(sword) then
					local ang = self.Owner:EyeAngles()
					ang.r = 90
					sword:SetAngles(ang)
					sword:SetPos(self.Stand:GetAttachment(self.Stand:LookupAttachment("sawblade")).Pos)
					sword:SetOwner(self.Owner)
					sword.Owner = (self.Owner)
					sword:Spawn()
					sword:Activate()
				end
			end
		end)
		self:SetNextPrimaryFire( CurTime() + self.Stand:SequenceDuration() + 4 )
		else
		self:SetHoldType("pistol")
		if self.Stand:GetSequence() != self.Stand:LookupSequence("chop") then
			self.Stand:ResetSequence(self.Stand:LookupSequence("chop"))
			self.Stand:SetCycle(0)
			timer.Simple(0.1, function()
				self.Stand:EmitStandSound(SwingSound)
			end)
			timer.Simple(0.4, function()
				self:BarnaclePunch()
			end)
			timer.Simple(self.Stand:SequenceDuration(), function()
				self:SetHoldType("stando")
			end)
		end
		self:SetNextPrimaryFire( CurTime() + self.Stand:SequenceDuration() + 0.1 )
	end
end
SWEP.mat = Material("decals/gstands_barnaclev.vmt")
function SWEP:SecondaryAttack()
	if SERVER and !self.Owner:gStandsKeyDown("modifierkey1") then
		self:SetHoldType("pistol")
        self.Stand:ResetSequence( self.Stand:LookupSequence("waterblast") )
		self.Stand:SetCycle( 0 )
		timer.Simple(self.Stand:SequenceDuration(), function() self:SetHoldType("stando") end)
        timer.Create("dbmAttack"..self.Owner:GetName(), 0.3, 1, function()
			if SERVER then
				local blast = ents.Create("dbm_waterblast")
				if IsValid(blast) then
					local blast = ents.Create("dbm_waterblast")
					blast:SetPos(self:GetStand():WorldSpaceCenter())
					blast:SetOwner(self.Owner)
					blast:SetAngles(self.Owner:EyeAngles())
					blast:Spawn()
					blast:Activate()
				end
			end
		end)
		self:SetNextSecondaryFire(CurTime() + 1)
	end
	if SERVER and self.Owner:gStandsKeyDown("modifierkey1") then
		self:SetHoldType("pistol")
		
        self.Stand:ResetSequence( self.Stand:LookupSequence("waterpull") )
		self.Stand:SetCycle( 0 )
		timer.Simple(self.Stand:SequenceDuration(), function() self:SetHoldType("stando") end)
        timer.Create("dbmAttack"..self.Owner:GetName(), 0.3, 1, function()
			if SERVER then
				local trW = util.TraceLine( {
					start = self.Stand:GetEyePos(),
					endpos = self.Stand:GetEyePos() + self.Stand:GetForward() * 500,
					filter = {self.Owner, self.Stand},
					mask = MASK_NPCWORLDSTATIC,
				} )
				local blast = ents.Create("dbm_waterblast")
				if IsValid(blast) then
					blast:SetPos(trW.HitPos - self.Stand:GetForward() * 5)
					blast:SetOwner(self.Owner)
					blast:SetAngles((-trW.Normal):Angle())
					blast:Spawn()
					blast.lifetime = CurTime() + 0.3
					blast:Activate()
				end
			end
		end)
		self:SetNextSecondaryFire(CurTime() + 1)
	end
	
end

function SWEP:Reload()
	
end

function SWEP:BarnaclePunch()
    local anim = self.Owner:GetSequenceName(self.Owner:GetSequence())
    self.Owner:LagCompensation( true )
	local startpos = self.Stand:WorldSpaceCenter()
	local pos = self.Stand:GetAttachment(self.Stand:LookupAttachment("anim_attachment_rh")).Pos + self.Owner:GetAimVector() * 35
	local mins = Vector(-15, -15, -15)
	local maxs = Vector(15, 15, 15)
    local tr = util.TraceHull( {
		start = startpos,
		endpos = pos,
		filter = {self.Owner, self.Stand },
		mins = mins,
		maxs = maxs,
		mask = MASK_SHOT_HULL, 
		ignoreworld = true
	} )
	if SERVER and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue("explosion", "2") tr.Entity:SetKeyValue("gibdir", tostring(self.Stand:GetAngles())) tr.Entity:Fire("Break") end
	
    if ( SERVER && IsValid( tr.Entity ) ) then
		local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self.Owner end
		dmginfo:SetAttacker( attacker )
		
		dmginfo:SetInflictor( self.Owner )
		dmginfo:SetDamage( 55 * self.Power)
		
		self.Stand:EmitStandSound(Grab)
		tr.Entity:TakeDamageInfo( dmginfo )
		tr.Entity:SetVelocity( self.Owner:GetAimVector() * 100 + Vector( 0, 0, 100 ) )
		if !tr.Entity.Barnacled then
			local barnacle = ents.Create("dbm_barnacle")
			barnacle:SetTarget(tr.Entity)
			barnacle:SetPos(tr.HitPos)
			barnacle:SetParent(tr.Entity)
			barnacle:SetOwner(self.Owner)
			tr.Entity.Barnacled = true
			barnacle:Spawn()
			barnacle:Activate()
		end
	end
    
    if tr.Entity:IsPlayer() and !self.Owner.IsKnockedOut then
		tr.Entity:ViewPunch( Angle( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) ) )
	end
	
    self.Owner:LagCompensation( false )
    
end

function SWEP:OnDrop()
    if SERVER and self.Stand:IsValid() then
        self.Stand:Withdraw()
	end
	
	if SERVER then
		self:ResetPhysAttributes()
	end
    return true
end

function SWEP:OnRemove()
    if SERVER and self.Stand:IsValid() then
        self.Stand:Withdraw()
	end
    if SERVER and self.Owner:WaterLevel() > 0 and self.Owner:Health() < 1 and self.Owner:GetActiveWeapon() == self then
		self.Owner:EmitSound(Death)
	end
	if SERVER then
		self:ResetPhysAttributes()
	end
    return true
end

function SWEP:Holster()
    if SERVER and self.Stand:IsValid() then
        self.Stand:Withdraw()
		if self.WithdrawSpecial then
			self.Owner:EmitSound(Lightly)
		end
	end
	if CLIENT and self.WaterInfo then
		water:SetFloat("$bluramount", self.WaterInfo[1][1])
		water:SetFloat("$refractamount", self.WaterInfo[1][2])
		DBM_Water1:SetFloat("$bluramount", self.WaterInfo[2][1])
		DBM_Water1:SetFloat("$refractamount", self.WaterInfo[2][2])
		local i = 1
		for k,v in pairs(DBM_Water2) do
			if !isnumber(v) then
				v:SetInt("$fogenable", self.WaterInfo[3][i][1])
				v:SetFloat("$fogstart", self.WaterInfo[3][i][2])
				v:SetFloat("$fogend", self.WaterInfo[3][i][3])
				i = i + 1
			end
		end
	end
	if SERVER then
		self:ResetPhysAttributes()
	end
	
    return true
end