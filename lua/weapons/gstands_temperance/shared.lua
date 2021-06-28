--Send file to clients
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot      = 1
end

SWEP.Power = 1
SWEP.Speed = 2.25
SWEP.Range = A
SWEP.Durability = 1500
SWEP.Precision = nil
SWEP.DevPos = nil

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.yt.purpose"
SWEP.Instructions  = "#gstands.yt.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.yt"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos            = 2
SWEP.DrawCrosshair      = true

SWEP.WorldModel = "models/yellowtemperance/yellowtemperance.mdl"
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.StandModel 				= "models/yellowtemperance/yellowtemperance.mdl"
SWEP.StandModelP 				= "models/yellowtemperance/yellowtemperance.mdl"
if CLIENT then
	SWEP.StandModel = "models/yellowtemperance/yellowtemperance.mdl"
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

SWEP.RenderGroup = RENDERGROUP_BOTH

SWEP.AutomaticFrameAdvance = true
SWEP.gStands_IsThirdPerson = true
local PrevHealth = nil

--Define swing and hit sounds. Might change these later.
local Shoot = Sound( "yt.shoot" )
local SDeploy = Sound( "weapons/temperance/deploy.mp3" )
local Deploy = Sound( "weapons/temperance/deploy.wav" )
local Grow = Sound( "yt.grow" )
local EatYou = Sound( "weapons/temperance/eatyou.wav" )
local NoWin = Sound( "weapons/temperance/nowin.wav" )
local Block = Sound( "weapons/temperance/block1.wav" )
local Handsome = Sound( "weapons/temperance/handsome.wav" )
local gooloop = Sound( "weapons/temperance/goo_loop.wav" )
local Dissipate = Sound( "weapons/temperance/dissipate/dissipate2.wav" )
local Dissipate2 = Sound( "yt.dissipate" )
local Insults = Sound( "yt.blockinsults" )

game.AddParticles("particles/yt.pcf")

PrecacheParticleSystem("ytdrips")
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
local pos, material, white = Vector( 0, 0, 0 ), Material( "sprites/hud/v_crosshair1" ), Color( 255, 255, 255, 255 )
local base          = "vgui/hud/gstands_hud/"
local armor_bar     = Material(base.."armor_bar")
local bar_border    = Material(base.."bar_border")
local boxdis        = Material(base.."boxdis")
local boxend        = Material(base.."boxend")
local cooldown_box  = Material(base.."cooldown_box")
local generic_rect  = Material(base.."generic_rect")
local health_bar    = Material(base.."health_bar")
local pfpback       = Material(base.."pfpback")
local pfpfront      = Material(base.."pfpfront")
local corner_left   = Material(base.."corner_left")
local corner_right  = Material(base.."corner_right")

function SWEP:DrawHUD()
    if GetConVar("gstands_draw_hud"):GetBool() then
        local color = Color(255,255,0)
        local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
	end
end
hook.Add( "HUDShouldDraw", "YellowTemperanceHud", function(elem)
    if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_temperance" and (((elem == "CHudWeaponSelection" ) and LocalPlayer().SPInZoom) or elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
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
            local clr = Color(255,255,0)
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
	self:NetworkVar("Bool", 0, "Blocking")
	self:NetworkVar("Entity", 1, "FakeWeapon")
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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= ACT_HL2MP_IDLE
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_01"))
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= ACT_HL2MP_IDLE_SLAM + 5
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= ACT_HL2MP_IDLE_SLAM + 5
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= ACT_HL2MP_IDLE_SLAM + 5
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= ACT_HL2MP_IDLE_SLAM + 5
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
	-- "normal" jump animation doesn't exist
	if ( t == "normal" ) then
		self.ActivityTranslate[ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end
    
    
end
function SWEP:Initialize()
end

function SWEP:DrawWorldModel()
	self.Start = self.Start or 0
	if self.IsDisguised and not IsValid(self:GetFakeWeapon()) then return end
	if IsValid(self:GetFakeWeapon()) and self:GetFakeWeapon():GetOwner() != LocalPlayer() and self:GetFakeWeapon():GetOwner():GetActiveWeapon() == self:GetFakeWeapon() then
		local parent = self:GetFakeWeapon():GetParent()
		self:GetFakeWeapon():SetParent(self.Owner)
		self:GetFakeWeapon():SetupBones()
		self:GetFakeWeapon():DrawModel()
		self:GetFakeWeapon():SetParent(parent)
		self:DrawShadow(false)
		return
	end
	if IsValid(self:GetFakeWeapon()) and (self:GetFakeWeapon():GetOwner() == LocalPlayer() or self:GetFakeWeapon():GetOwner():GetActiveWeapon() != self:GetFakeWeapon()) then
		local model = self:GetModel()
		if self:GetFakeWeapon():GetModel() == "" then
			return
		end
		self:SetModel(self:GetFakeWeapon():GetModel())
		self:SetupBones()
		self:DrawModel()
		self:SetModel(model)
		self:DrawShadow(false)
		return
	end
	if self.Owner:GetNWString("DisguisedAs") != "" then
		return
	end
	if IsValid(self.Owner) and !self.IsDisguised and self:GetBlocking() and self.Owner:GetNWString("DisguisedAs") == "" then
		local perc = math.Remap(self.Start, 0.1, 0.2, 0, 1)
		self:DrawShadow(true)
		if self:GetCycle() < 0.9 then
			self:DrawModel()
		end
		
		self.Owner:SetupBones()
		
	end
	
	if IsValid(self.Owner) and !self.IsDisguised and !self:GetBlocking() and self.Owner:GetNWString("DisguisedAs") == "" then
		self:DrawModel()
		self.Start = 0
		if GetConVar("gstands_show_hitboxes"):GetBool() and (self:GetSequence() == 3 or self:GetSequence() == 2) then
			render.DrawWireframeBox(self.Owner:EyePos() + self:GetForward() * 55*self.Owner:GetModelScale(), Angle(0,0,0), Vector(-35,-35,-25)*self.Owner:GetModelScale(), Vector(35,35,25)*self.Owner:GetModelScale(), Color(255,0,0,255), true)
			
		end
		
		if GetConVar("gstands_show_hitboxes"):GetBool() and self:GetSequence() == 1 then
			render.DrawWireframeBox(self.Owner:EyePos() + self.Owner:GetAimVector() * 145 * self:GetModelScale(), Angle(0,0,0), Vector(-75,-75,-75) * self:GetModelScale(), Vector(75,75,75) * self:GetModelScale(), Color(255,0,0,255), true)
			render.DrawWireframeBox(self.Owner:EyePos() + self.Owner:GetAimVector() * 145 * self:GetModelScale() - Vector( 75, 75, 75 ) * self:GetModelScale(), Angle(0,0,0), Vector(-5,-5,-5), Vector(5,5,5), Color(0,255,0,255), true)
			render.DrawWireframeBox(self.Owner:EyePos() + self.Owner:GetAimVector() * 145 * self:GetModelScale() + Vector( 75, 75, 75 ) * self:GetModelScale(), Angle(0,0,0), Vector(-5,-5,-5), Vector(5,5,5), Color(0,255,0,255), true)
		end
	end
end
function SWEP:DrawWorldModelTranslucent()
	
	if self.IsDisguised and not IsValid(self:GetFakeWeapon()) then return end
	self.Start = self.Start or 0
	if IsValid(self:GetFakeWeapon()) and self:GetFakeWeapon():GetOwner() != LocalPlayer() and self:GetFakeWeapon():GetOwner():GetActiveWeapon() == self:GetFakeWeapon() then
		local parent = self:GetFakeWeapon():GetParent()
		self:GetFakeWeapon():SetParent(self.Owner)
		self:GetFakeWeapon():SetupBones()
		self:GetFakeWeapon():DrawModel()
		self:GetFakeWeapon():SetParent(parent)
		return
	end
	if IsValid(self:GetFakeWeapon()) and (self:GetFakeWeapon():GetOwner() == LocalPlayer() or self:GetFakeWeapon():GetOwner():GetActiveWeapon() != self:GetFakeWeapon()) then
		local model = self:GetModel()
		if self:GetFakeWeapon():GetModel() == "" then
			return
		end
		self:SetModel(self:GetFakeWeapon():GetModel())
		self:SetupBones()
		self:DrawModel()
		self:SetModel(model)
		return
	end
	if self.Owner:GetNWString("DisguisedAs") != "" then
		return
	end
	if IsValid(self.Owner) and self:GetBlocking() and self.Owner:GetNWString("DisguisedAs") == "" then
		local perc = math.Remap(self.Start, 0.1, 0.2, 0, 1)
		
		if self:GetCycle() < 0.9 then
			self:DrawModel()
		end
		for i=0, self.Owner:GetBoneCount() - 1 do
			self.Owner:ManipulateBoneScale(i, Vector(1 + self.Start, 1 + self.Start, 1 + self.Start))
		end
		self.Start = math.min(0.2, self.Start + 0.005)
		render.SetBlend(perc)
		self.Owner:SetupBones()
		self.Owner:SetMaterial("models/yellowtemperance/goo_bottom.vmt")
		self.Owner:DrawModel()
		self.Owner:SetMaterial("models/yellowtemperance/goo.vmt")
		self.Owner:DrawModel()
		self.Owner:DrawModel()
		self.Owner:DrawModel()
		self.Owner:SetMaterial("")
		render.SetBlend(1)
		for i=0, self.Owner:GetBoneCount() - 1 do
			self.Owner:ManipulateBoneScale(i, Vector(1,1,1))
		end
		self.Owner:SetupBones()
	end
	
	if IsValid(self.Owner) and !self:GetBlocking() and self.Owner:GetNWString("DisguisedAs") == "" then
		self:DrawModel()
		self.Start = 0
	end
	if self.Owner:GetActiveWeapon() == self and self.Owner:GetNWString("DisguisedAs") == "" then
		self.drips = self.drips or CreateParticleSystem(self, "ytdrips", PATTACH_POINT_FOLLOW, 1)
		elseif self.drips then
		self.drips:StopEmission()
		self.drips = nil
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
	self.drips = nil
    if SERVER then
        if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitSound(SDeploy)
			self.Owner:EmitSound(Deploy)
		end
	end
    --As is standard with stand addons, set health to 1000
    if self.Owner:Health() == 100  then
        self.Owner:SetMaxHealth( self.Durability )
        self.Owner:SetHealth( self.Durability )
	end
	
    self.Owner:SetNWFloat("Delay_"..self.Owner:GetName(), 0)
    self.Owner:SetNWFloat("Size_"..self.Owner:GetName(), 1)
    self.Owner:SetNWFloat("PrevHealth"..self.Owner:GetName(), self.Owner:Health())
    self.Owner:SetCanZoom(false)
	self:ResetSequence(0)
	self:SetPlaybackRate(0.01)
	hook.Add("EntityTakeDamage", "YellowTemperanceDamageHandler"..self.Owner:EntIndex(), function(ent, dmg)
		if IsValid(self) and IsValid(self.Owner) and ent == self.Owner and self.Owner:GetActiveWeapon() == self then
			if self.Owner:gStandsKeyDown("modeswap") then
				dmg:SetDamage(dmg:GetDamage()/10)
				self.insulttimer = self.insulttimer or CurTime()
				if CurTime() >= self.insulttimer then
					self.insulttimer = CurTime() + 3
					self.Owner:EmitSound(Insults)
				end
			end
			if (dmg:GetAttacker():IsPlayer() or dmg:GetAttacker():IsNPC()) and CurTime() >= self.GooDelay and (dmg:GetAttacker():IsNPC() or dmg:GetAttacker():GetActiveWeapon():GetClass() != self:GetClass()) and self.Owner:GetPos():Distance(dmg:GetAttacker():GetPos()) < 200 then
				self:DoTemperanceGooing(dmg:GetAttacker())
			end
		end
	end)
end

function GetTemperanceClosest(ply)
	local closestply
	local closestdist
	for k, v in pairs(player.GetAll()) do
		if v != ply and v:GetPos():Distance(ply:GetPos()) <= 50 then
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

function SWEP:DoTemperanceGooing(Target)
	local barnacle = ents.Create("yellowtempgoo")
	barnacle:SetTarget(Target)
	barnacle:SetPos(Target:GetPos())
	barnacle:SetParent(Target)
	barnacle:SetOwner(self.Owner)
	barnacle:Spawn()
	self.GooDelay = CurTime() + 1
end
function SWEP:Think()
	local curtime = CurTime()
	
	local pmins, pmaxs = self.Owner:GetHull()
	self.playermins = self.playermins or pmins
	self.playermaxs = self.playermaxs or pmaxs
    if string.lower(self.Owner:GetModel()) != string.lower(player_manager.TranslatePlayerModel(self.Owner:GetInfo("cl_playermodel"))) then
        if self.Owner:WaterLevel() == 3 then
            self:ResetTemperance()
		end
	end
    if self.Owner:gStandsKeyDown("dododo") then
		if CurTime() > self.Owner:GetNWFloat("DelayMenacing_"..self.Owner:GetName()) then
			self.Owner:SetNWFloat("DelayMenacing_"..self.Owner:GetName(), CurTime() + 0.5)
			local effectdata = EffectData()
			effectdata:SetStart(self.Owner:GetPos())
			effectdata:SetOrigin(self.Owner:GetPos())
			effectdata:SetEntity(self.Owner)
			util.Effect("menacing", effectdata)
		end
	end
	local lastpos = self:GetPos()
	self.hitDelay = self.hitDelay or CurTime()
	self.GooDelay = self.GooDelay or CurTime()
	if SERVER and (self:GetSequence() == 3 or self:GetSequence() == 2) and CurTime() >= self.hitDelay then
		local cpos = Vector(0,0,0)
		local forward = self.Owner:GetAngles()
		forward.p = 0
		local tr2 = util.TraceHull( {
			start = self.Owner:EyePos() + forward:Forward() * 55*self.Owner:GetModelScale(),
			endpos = self.Owner:EyePos() + forward:Forward() * 55*self.Owner:GetModelScale(),
			filter = {self.Owner, self},
			mask = MASK_SHOT_HULL,
			mins = Vector(-35,-35,-35)*self.Owner:GetModelScale(),
			maxs = Vector(35,35,35)*self.Owner:GetModelScale(),
		} )
		if SERVER and tr2.Entity:IsValid() then
			local dmginfo = DamageInfo()
			local attacker = self.Owner
			dmginfo:SetAttacker( attacker )
			local mult = 1
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( 5 * mult )
			
			tr2.Entity:TakeDamageInfo( dmginfo )
			if (tr2.Entity:IsPlayer() or tr2.Entity:IsNPC()) and CurTime() >= self.GooDelay then
				self:DoTemperanceGooing(tr2.Entity)
				self.GooDelay = CurTime() + 1
			end
		end
	end
    
    if self.Owner:gStandsKeyPressed("modeswap") then
        self:ResetSequence(5)
		self:SetPlaybackRate(2)
		self:EmitSound(Block)
	end
	if self.Owner:gStandsKeyReleased("modeswap") and self:GetSequence() == 5 then
		self:ResetSequence(0)
		self:SetPlaybackRate(0.01)
		self:EmitSound(Dissipate)
	end
    if self.Owner:gStandsKeyDown("modeswap") then
		self:SetBlocking(true)
	end
    if !self.Owner:gStandsKeyDown("modeswap") then
		self:SetBlocking(false)
	end
	self:SetFlexWeight(0, math.abs(math.sin(CurTime()) / 5))
	self.looptimer = self.looptimer or CurTime()
	if CurTime() >= self.looptimer then
		self:EmitSound(gooloop)
		self.looptimer = CurTime() + 5
	end
	if self.Owner:IsOnFire() then
		self.Owner:SetNWFloat("Size_"..self.Owner:GetName(), self.Owner:GetNWFloat("Size_"..self.Owner:GetName()) + 1/550)
		self.Owner:SetModelScale(self.Owner:GetNWFloat("Size_"..self.Owner:GetName()))
		self.Owner:SetWalkSpeed(190 * self.Owner:GetNWFloat("Size_"..self.Owner:GetName()))
		self.Owner:SetRunSpeed(320 * self.Owner:GetNWFloat("Size_"..self.Owner:GetName()))
		self.Owner:SetJumpPower(200 * self.Owner:GetNWFloat("Size_"..self.Owner:GetName()))
		self.Owner:SetViewOffset(Vector(0,0,64) * self.Owner:GetModelScale())
		self.Owner:SetViewOffsetDucked(Vector(0,0,32) * self.Owner:GetModelScale())
		self.Owner:SetHealth(self.Owner:Health() + 0.01)
		self.Owner:SetHull(self.playermins, self.playermaxs)
	end
	if self.Owner:IsFrozen() then
		local mins = self.Owner:OBBMins()
		local maxs = self.Owner:OBBMaxs()
		mins = mins * 3
		maxs = maxs * 3
		local dmginfo = DamageInfo()
		local attacker = self.Owner
		dmginfo:SetAttacker( attacker )
		local mult = 1
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 5 * mult )
		
		
		for k,v in pairs(ents.FindInBox(self.Owner:LocalToWorld(mins),self.Owner:LocalToWorld(maxs))) do
			if (v:IsPlayer() or v:IsNPC()) and v != self.Owner then
				v:TakeDamageInfo( dmginfo )
			end
		end
	end
	self:NextThink(CurTime())
	return true
end
if SERVER then
	util.AddNetworkString("yt.SendTheActTable")
end
if CLIENT then
	net.Receive("yt.SendTheActTable", function()
		local ent = net.ReadEntity()
		local tab = net.ReadTable()
		ent.ActivityTranslate = tab
	end)
end
function SWEP:ResetTemperance()
	if SERVER then
		self.Owner:EmitSound(Dissipate2)
		self:SetNoDraw(false)
		self:ResetSequence(0)
		self:SetPlaybackRate(0.01)
		self.Owner:SetModel(player_manager.TranslatePlayerModel(self.Owner:GetInfo("cl_playermodel")))
		self.Owner:SetSkin(self.Owner:GetInfo("cl_playerskin"))
		self.Owner:SetBodyGroups(self.Owner:GetInfo("cl_playerbodygroups"))
		self.Owner:SetNWString("DisguisedAs", "")
		local color = self.Owner:GetInfo("cl_playercolor")
		self.Owner:SetPlayerColor(Vector(color))
		self.Owner:SetHealth(self.Owner:Health() / self.Owner:GetModelScale())
		self.Owner:SetModelScale(1)
		self.Owner:SetNWFloat("Size_"..self.Owner:GetName(), 1)
		self.Owner:SetWalkSpeed(190)
		self.Owner:SetRunSpeed(320)
		self.Owner:SetJumpPower(200)
		self:SetFakeWeapon(nil)
		self:SetWeaponHoldType("stando")
		self:SetHoldType("stando")
		self.Owner:SetViewOffset(Vector(0,0,64)*self.Owner:GetModelScale())
		self.Owner:SetViewOffsetDucked(Vector(0,0,28)*self.Owner:GetModelScale())
		---16.000000 -16.000000 0.000000	16.000000 16.000000 72.000000
		if self.playermins and self.playermaxs then
			self.Owner:SetHull(self.playermins, self.playermaxs)
		end
	end
end
function SWEP:PrimaryAttack()
	self.Delay = self.Delay or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("modifierkey1") and CurTime() >= self.Delay then
        self.Owner:SetAnimation(PLAYER_ATTACK1)
		self.Delay = CurTime() + 1
		self:ResetTemperance()
		local tr = util.TraceLine( {
			start = self.Owner:EyePos(),
			endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * self.HitDistance * 5000,
			filter = self.Owner ,
			mask = MASK_SHOT_HULL,
			ignoreworld = true,
			collisiongroup = COLLISION_GROUP_PROJECTILE
		} )
        if tr.Entity:IsValid() and (tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:IsRagdoll()) and IsFirstTimePredicted() then
			self:ResetSequence(5)
			self:SetPlaybackRate(4)
			self:SetCycle(0)
			if SERVER then
				self.Owner:EmitSound(Shoot)
			end
			timer.Simple(0.15, function() if IsValid(self) then
				self.Owner:SetModel(tr.Entity:GetModel()) 
				if tr.Entity.Nick then
					self.Owner:SetNWString("DisguisedAs", tr.Entity:Nick())
					self.Owner:SetPlayerColor(tr.Entity:GetPlayerColor())
					elseif tr.Entity:GetModel() == "models/player/kleiner.mdl" or player_manager.TranslateToPlayerModelName( tr.Entity:GetModel() ) ~= "kleiner" then
					self.Owner:SetNWString("DisguisedAs", player_manager.TranslateToPlayerModelName( tr.Entity:GetModel() ))
					else
					local mdl = tr.Entity:GetModel()
					local tab = string.Split(mdl, "/")
					mdl = tab[#tab]
					mdl = string.StripExtension(mdl)
					self.Owner:SetNWString("DisguisedAs", mdl)
				end
				for k,v in pairs(tr.Entity:GetBodyGroups()) do
					self.Owner:SetBodygroup(v.id, tr.Entity:GetBodygroup(v.id))
				end
				self.Owner:SetSkin(tr.Entity:GetSkin())
				local wep
				if tr.Entity:IsPlayer() then
					 wep = tr.Entity:GetActiveWeapon()
				end
				if (SERVER or CLIENT and LocalPlayer() == self.Owner) and IsValid(wep) and wep.ActivityTranslate then
					self.ActivityTranslate = wep.ActivityTranslate
					self:SetFakeWeapon(wep)
					if SERVER then
						net.Start("yt.SendTheActTable")
						net.WriteEntity(self)
						net.WriteTable(self.ActivityTranslate)
						net.Broadcast()
					end
					elseif IsValid(wep) then
					self:SetHoldType(wep:GetHoldType())
					self:SetFakeWeapon(wep)
				end
			end
			end)
		end
		if !(tr.Entity:IsValid() and (tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:IsRagdoll())) then
			self.Owner:EmitSound(Handsome)
		end
	end
	if SERVER and !self.Owner:gStandsKeyDown("modifierkey1") and CurTime() >= self.Delay then
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self.Delay = CurTime() + 1
        if SERVER then
			if string.lower(self.Owner:GetModel()) != string.lower(player_manager.TranslatePlayerModel(self.Owner:GetInfo("cl_playermodel"))) then
				self:ResetTemperance()
			end
			self:ResetSequence(math.random(2, 3))
			self:SetPlaybackRate(2)
			self:SetCycle(0)
			if SERVER then
				self.Owner:EmitSound(Shoot)
			end
			self.hitDelay = CurTime() + 0.2
			timer.Simple(self:SequenceDuration(3), function() self:ResetSequence(0) self:SetPlaybackRate(0.01) end)
		end
	end
	
	self:SetNextPrimaryFire( CurTime() + (0.1 * self.Speed) )
end

function SWEP:SecondaryAttack()
	--Punch mode
	--self.Owner:SetAnimation(PLAYER_ATTACK1)
	local mins = (self.Owner:WorldSpaceCenter() + self.Owner:GetAimVector() * 145 * self:GetModelScale()) - (Vector( 75, 75, 75 ) * self:GetModelScale())
	local maxs = (self.Owner:WorldSpaceCenter() + self.Owner:GetAimVector() * 145 * self:GetModelScale()) + (Vector( 75, 75, 75 ) * self:GetModelScale())
	
	if string.lower(self.Owner:GetModel()) != string.lower(player_manager.TranslatePlayerModel(self.Owner:GetInfo("cl_playermodel"))) then
		self:ResetTemperance()
	end
	self:ResetSequence(1)
	self:SetCycle(0)
	self:SetPlaybackRate(10)
	self:EmitSound(Shoot)
	local pmins, pmaxs = 			self.Owner:GetHull()
	self.playermins = self.playermins or pmins
	self.playermaxs = self.playermaxs or pmaxs
	timer.Simple(0.1, function()
		for k,v in pairs(ents.FindInBox(mins, maxs)) do
			if self:IsValid() and self.Owner:IsValid() and v:IsValid() and (v:IsRagdoll()) then
				self.Owner:SetNWFloat("Size_"..self.Owner:GetName(), self.Owner:GetNWFloat("Size_"..self.Owner:GetName()) + v:GetModelScale()/5)
				self.Owner:SetModelScale(self.Owner:GetNWFloat("Size_"..self.Owner:GetName()))
				self.Owner:SetHull(self.playermins * self.Owner:GetNWFloat("Size_"..self.Owner:GetName())/2, self.playermaxs * self.Owner:GetNWFloat("Size_"..self.Owner:GetName())/2)
				self.Owner:SetWalkSpeed(190 * self.Owner:GetNWFloat("Size_"..self.Owner:GetName()))
				self.Owner:SetRunSpeed(320 * self.Owner:GetNWFloat("Size_"..self.Owner:GetName()))
				self.Owner:SetJumpPower(200 * self.Owner:GetNWFloat("Size_"..self.Owner:GetName()))
				self.Owner:SetViewOffset(Vector(0,0,64) * self.Owner:GetModelScale())
				self.Owner:SetViewOffsetDucked(Vector(0,0,32) * self.Owner:GetModelScale())
				self.Owner:SetHealth(self.Owner:Health() + 100)
				if SERVER then
					self.Owner:SetMaxHealth(math.max(self.Owner:GetMaxHealth(), self.Owner:Health()))
					v:Remove()
				end
				if SERVER then
					self.Owner:EmitSound(Grow)
				end
				elseif SERVER and v:IsValid() and (v:IsNPC() or v:IsPlayer()) and v != self.Owner then
				self:DoTemperanceGooing(v)
				self.Owner:EmitSound(EatYou)
				
			end
		end
	end)
	self:SetNextSecondaryFire( CurTime() + 3 )
end

function SWEP:Reload()
	
end

--Screw this entire section, it only works like 20% of the time. Basically, meant to catch every time the weapon is not in your hands in order to remove the stand.
function SWEP:OnDrop()
	self:ResetTemperance()
	if CLIENT and self.drips then
		self.drips:StopEmission()
		self.drips = nil
	end
	return true
end

function SWEP:OnRemove()
	self:ResetTemperance()
	
	if CLIENT and self.drips then
		self.drips:StopEmission()
		self.drips = nil
	end
	return true
end

function SWEP:Holster()
	self:ResetTemperance()
	if CLIENT and self.drips then
		self.drips:StopEmission()
		self.drips = nil
	end
	return true
end		