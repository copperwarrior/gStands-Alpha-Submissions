--Send file to clients
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot	  = 1
end

SWEP.DevPos = D 
SWEP.Power = 2.5 
SWEP.Speed = 0.25 
SWEP.Range = 250 
SWEP.Durability = 1500 
SWEP.Precision = E 

SWEP.Author		= "Copper"
SWEP.Purpose	   = "#gstands.wof.purpose"
SWEP.Instructions  = "#gstands.wof.instructions"
SWEP.Spawnable	 = true
SWEP.Base		  = "weapon_fists"   
SWEP.Category	  = "gStands"
SWEP.PrintName	 = "#gstands.names.wof"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos			= 2
SWEP.DrawCrosshair	  = true

SWEP.WorldModel = "models/player/whitesnake/disc.mdl"
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

SWEP.StandModel = "models/wof/wof.mdl"
SWEP.StandModelP = "models/wof/wof.mdl"
SWEP.DrawAmmo = false
SWEP.HitDistance = 48
SWEP.red = GetConVar("gstands_wof_color_r")
SWEP.green = GetConVar("gstands_wof_color_g")
SWEP.blue = GetConVar("gstands_wof_color_b")
SWEP.gStands_IsThirdPerson = true
local PrevHealth = nil

game.AddParticles("particles/wof.pcf")

PrecacheParticleSystem("gasoline_tracer")

--Define swing and hit sounds. Might change these later.
local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )
local Deploy = Sound( "weapons/wof/deploy.wav" )
local Shoot = Sound( "weapons/wof/shoot.wav" )
local Transform = Sound( "weapons/wof/transform.wav" )
local Trample = Sound( "weapons/wof/trample.wav" )
local Smart = Sound( "weapons/wof/yourenotsmart.wav" )


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
	--if IsValid(self.Stand) then
		if GetConVar("gstands_draw_hud"):GetBool() then
			local color = gStands.GetStandColorTable(self.Stand:GetModel(), self.Stand:GetSkin())
			local height = ScrH()
			local width = ScrW()
			local mult = ScrW() / 1920
			local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
			gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
		end
	--end
end
hook.Add( "HUDShouldDraw", "WofHud", function(elem)
    if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_wheel_of_fortune" and (((elem == "CHudWeaponSelection" ) and LocalPlayer().SPInZoom) or elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
        return false
    end
end)
local material = Material( "vgui/hud/gstands_hud/crosshair" )
function SWEP:DoDrawCrosshair(x,y)
	if IsValid(self.Stand) then 
		local dir = self.Owner:GetAimVector()
		dir.z = dir.z
		dir.x = dir.x
		dir.y = dir.y
		dir = dir:GetNormalized()
		local pos = self.Owner:EyePos() + Vector(0,0,150)
		local tr = util.TraceLine( {
			start = pos,
			endpos = pos + dir * 1500,
			filter = {self.Owner, self:GetStand(), self:GetStand():GetChildren()},
			mask = MASK_SHOT_HULL
		} )
		local pos = tr.HitPos
		local pos2d = pos:ToScreen()
		if pos2d.visible then
			surface.SetMaterial( material	)
			surface.SetDrawColor( gStands.GetStandColorTable("models/wof.mdl", 0) )
			surface.DrawTexturedRect( pos2d.x - 8, pos2d.y - 8, 16, 16 )
		end
		return true
	end
end
function SWEP:CalcCollisions( ent, data)
	if data.HitEntity:Health() and self.Stand.State and data.HitEntity != self.Owner then 
		local dmginfo = DamageInfo()
		local attacker = self.Owner
		dmginfo:SetAttacker( attacker )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 15 * self:GetConfidence() )
		data.HitEntity:TakeDamageInfo(dmginfo)
		self:SetConfidence(self:GetConfidence() + 0.02)
	end 
	if data.HitEntity:IsWorld() and self.Owner:gStandsKeyDown("dododo") then
		if self:GetStand():GetMoveType() != MOVETYPE_NONE and (data.HitNormal:Dot(self:GetStand():GetForward()) >= 0.6) then
			self.Throttle = 0
			self.angle = data.HitNormal:Angle()
			self.angle:RotateAroundAxis(data.HitNormal, 90)
			self.WallDir = data.HitNormal:Angle():Up()
			--	self:GetStand():SetAngles(angle)
			self.angle:RotateAroundAxis(self.WallDir, -90)
			--self:GetStand():SetAngles(angle)
			self.Pos = (data.HitPos + self.WallDir * 155)
			self:GetStand():SetMoveType(MOVETYPE_NONE)
			self.ClimbState = 1
		end
	end
end
function SWEP:DefineStand(target)
	if SERVER then
		self:SetStand(ents.Create(target:GetClass()))
		self.Stand = self:GetStand()
		self.Stand.IsWheelOfFortune = true
		self.TargetScript = target:GetKeyValues()["VehicleScript"]
		self.TargetModel = target:GetModel()
		self.TargetClass = target:GetClass()
		self.Stand:SetModel(self.TargetModel)
		if self.TargetScript then
			self.Stand:SetKeyValue("vehiclescript",self.TargetScript)
			else
			self.TargetScript = target:GetKeyValues()["vehiclescript"]
			if self.TargetScript then
				self.Stand:SetKeyValue("vehiclescript",self.TargetScript)
			end
		end
		local pos = target:GetPos()
		local ang = target:GetAngles()
		self.Stand:SetPos(pos)
		self.Stand:SetAngles(ang)
		target:Remove()
		self.Stand:Spawn()
		self.Stand:Activate()
		self.Stand:SetHealth(self.Owner:Health())
		
		timer.Simple(0, function()
			self.Owner:EnterVehicle(self.Stand)
		end)
		
	end
end
function SWEP:UnDefineStand()
	if SERVER and IsValid(self:GetStand()) and !self:GetStand().Undefined then
		local jeep = ents.Create(self.TargetClass)
		jeep:SetPos(self:GetStand():GetPos())
		jeep:SetAngles(self:GetStand():GetAngles())
		jeep:SetModel(self.TargetModel) 
		if self.TargetScript then
			jeep:SetKeyValue("vehiclescript",self.TargetScript)
		end
		jeep:Spawn()
		jeep:Activate()
		self.Owner:ExitVehicle()
		self:GetStand():Remove()
		self:GetStand().Undefined = true
	end
end
function SWEP:Initialize()
	timer.Simple(0.1, function() 
		if self:GetOwner() != nil then
			if self:GetOwner():IsValid() and SERVER then
				self:GetOwner():SetHealth(GetConVar("gstands_wheel_of_fortune_heal"):GetInt())
				self:GetOwner():SetMaxHealth(GetConVar("gstands_wheel_of_fortune_heal"):GetInt())
			end
		end
	end)
end
function SWEP:DrawWorldModel()
	if IsValid(self.Owner) then
		return false
		else
		self:DrawModel()
	end
end
--Third Person View
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
	self:NetworkVar("Entity", 1, "Target")
	self:NetworkVar("Entity", 2, "Light1")
	self:NetworkVar("Entity", 3, "Light2")
	self:NetworkVar("Float", 4, "Confidence")
end
hook.Add("EntityTakeDamage", "WheelOfFortuneIgnition", function(ent, dmg)
	if ent.Gasolined and dmg:GetInflictor():GetClass() != "gstands_wheel_of_fortune" then
		ent:Ignite(15)
		ent.Gasolined = false
	end
	if ent:IsPlayer() and ent:GetVehicle().IsWheelOfFortune and !string.StartWith(dmg:GetInflictor():GetClass(), "gstands_") then
		return true
	end
	if (!GetConVar("gstands_stand_hurt_stands"):GetBool() or (IsValid(dmg:GetInflictor()) and string.StartWith(dmg:GetInflictor():GetClass(), "gstands_"))) and ent.IsWheelOfFortune and ent:IsVehicle() and IsValid(ent:GetDriver()) then
		ent:GetDriver().CanTakeDamageInWOF = true
		ent:GetDriver():TakeDamageInfo(dmg)
		ent:GetDriver().CanTakeDamageInWOF = false
		return false
	end
end)
function SWEP:Deploy()
	self:SetHoldType( "stando" )
	
	if self.Owner:Health() == 100  then
		self.Owner:SetMaxHealth( self.Durability )
		self.Owner:SetHealth( self.Durability )
	end
	if SERVER then
		self.Owner:SetAllowWeaponsInVehicle(true)
		self.Owner:EmitSound(Deploy)
	end
	self.Owner:SetCanZoom(false)
	self.ClimbState = 5
end

local lightsprite = Material("sprites/light_ignorez")
SWEP.red = GetConVar("gstands_wof_color_r")
SWEP.green = GetConVar("gstands_wof_color_g")
SWEP.blue = GetConVar("gstands_wof_color_b")
function SWEP:Think()
	self.TrampleTimer = self.TrampleTimer or CurTime()
	if SERVER and math.random(1,5) == 1 and IsValid(self:GetStand()) and self:GetStand():IsBoosting() and CurTime() >= self.TrampleTimer then
		self.Owner:EmitSound(Trample)
		self.TrampleTimer = CurTime() + 3
	end
	if self:GetConfidence() == 0 then
		self:SetConfidence(1)
		self.red = GetConVar("gstands_wof_color_r")
		self.green = GetConVar("gstands_wof_color_g")
		self.blue = GetConVar("gstands_wof_color_b")
	end
	self.ClimbState = self.ClimbState or 4
	self.Stand = self:GetStand()
	local phys
	if SERVER and IsValid(self.Stand) and self.ClimbState == 5 then
		phys = self:GetStand():GetPhysicsObject()
		if self.Owner:gStandsKeyDown("dododo") and self.Stand:GetForward():Dot(Vector(0,0,1)) > 0.7 then 
			local tr = util.TraceLine({
				start=self.Stand:WorldSpaceCenter(),
				endpos=self.Stand:WorldSpaceCenter() - self.Stand:GetUp() * 75,
				filter={self.Owner,self.Stand}
			})
			if tr.HitWorld then
				self.Throttle = 0
				self.angle = tr.HitNormal:Angle()
				self.angle:RotateAroundAxis(tr.HitNormal, 90)
				self.WallDir = tr.HitNormal:Angle():Up()
				self.angle:RotateAroundAxis(self.WallDir, -90)
				self.Pos = self.Stand:GetPos()
				self:GetStand():SetMoveType(MOVETYPE_NONE)
				self.ClimbState = 1
			end
		end
		-- local mins, maxs = self.Stand:GetCollisionBounds()
		-- local tr = util.TraceHull({
			-- start=self.Stand:GetPos(),
			-- endpos=self.Stand:GetPos(),
			-- mins=mins,
			-- maxs=maxs,
			-- filter={self.Owner, self.Stand},
			-- ignoreworld = true
		-- })
		-- if IsValid(tr.Entity) and tr.Entity:Health() > 0 then
			-- local dmginfo = DamageInfo()
			-- local attacker = self.Owner
			-- dmginfo:SetAttacker( attacker )
			-- dmginfo:SetInflictor( self )
			-- dmginfo:SetDamage( 15 * self:GetConfidence() )
			-- tr.Entity:TakeDamageInfo(dmginfo)
			-- self:SetConfidence(self:GetConfidence() + 0.02)
		-- end
	end
	if !self:GetStand().RenderOverride and CLIENT then
	local hand = util.GetPixelVisibleHandle()
		self:GetStand().RenderOverride = function(slf)
			local clr
			if slf:GetModel() == "models/wof.mdl" then
				slf.Material = slf.Material or Material(slf:GetMaterials()[1])
				clr = slf.Material:GetVector("$color2")
				self.red = self.red or GetConVar("gstands_wof_color_r")
				self.green = self.green or GetConVar("gstands_wof_color_g")
				self.blue = self.blue or GetConVar("gstands_wof_color_b")
				slf.Material:SetVector("$color2", Color(self.red:GetFloat(), self.green:GetFloat(), self.blue:GetFloat()):ToVector())
			end
			slf.StandAura = slf.StandAura or CreateParticleSystem(slf, "auraeffect", PATTACH_POINT_FOLLOW, 1)
			slf.StandAura:SetControlPoint(1, gStands.GetStandColor(slf:GetModel(), slf:GetSkin()))
			slf:DrawModel()
			if slf:GetModel() == "models/wof.mdl" then
				slf.Material = slf.Material or Material(slf:GetMaterials()[1])
				slf.Material:SetVector("$color2", clr)
			end
			if IsValid(self:GetLight1()) then
				local lightr = self:GetLight1():GetPos()
				local lightl = self:GetLight2():GetPos()
				render.SetMaterial(lightsprite)
				local radi = 100 * util.PixelVisible((self:GetLight1():GetPos() + self:GetLight2():GetPos())/2, 15, hand)
				render.DrawSprite(lightr, radi, radi)
				render.DrawSprite(lightl, radi, radi)
			end
		end
	end
	if IsValid(self:GetStand()) then
		self.shootpos = self:GetStand():WorldSpaceCenter()
		
	end
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
	if !self.Owner:gStandsKeyDown("dododo") and self.ClimbState != 5 then
		
			self.ClimbState = 5
			local phys = self:GetStand():GetPhysicsObject()
			self:GetStand():SetSolid(SOLID_OBB)
			if IsValid(phys) then
				for i=0, self:GetStand():GetPhysicsObjectCount() - 1 do
					local physn = self:GetStand():GetPhysicsObjectNum(i)
					physn:EnableCollisions(true)
					physn:RecheckCollisionFilter()
					phys:EnableCollisions(true)
					phys:RecheckCollisionFilter()
				end
			local pos = self:GetPos()
			self:GetStand():SetMoveType(MOVETYPE_VPHYSICS)
			self:GetStand():SetPos(pos)
			self:GetStand():SetThrottle(0)
	end
	end
	
	-- local mins, maxs = self:GetStand():GetCollisionBounds()
	-- local tab = {
	-- Vector(mins.x, mins.y, mins.z),
	-- Vector(maxs.x, mins.y, mins.z),
	-- Vector(maxs.x, maxs.y, mins.z),
	-- Vector(mins.x, maxs.y, mins.z),
	-- Vector(mins.x, mins.y, maxs.z),
	-- Vector(maxs.x, mins.y, maxs.z),
	-- Vector(maxs.x, maxs.y, maxs.z),
	-- Vector(mins.x, maxs.y, maxs.z)
	-- }
	-- local amtInWall = 0
	-- for k,v in pairs(tab) do
		-- local p = LerpVector(0.3, self:GetStand():WorldSpaceCenter(), self:GetStand():LocalToWorld(v))
		-- if util.PointContents(p) == CONTENTS_SOLID then
		-- amtInWall = amtInWall + 1
			-- if amtInWall > 4 then
			-- self:GetStand():SetAngles(LerpAngle(0.1, self:GetStand():GetAngles(), self:GetStand():GetUp():Angle()))
			-- self:GetStand():SetVelocity(Vector(0,0,0))
			-- self:GetStand():SetPos(self:GetStand():GetPos() + Vector(0,0,5))
			-- end
		-- end
	-- end
	if SERVER then
		if IsValid(self:GetStand()) and self.ClimbState < 5 then
			self:GetStand():SetMoveType(MOVETYPE_NONE)
			local phys = self:GetStand():GetPhysicsObject()
			self:GetStand():SetSolid(SOLID_NONE)
			if IsValid(phys) then
				for i=0, self:GetStand():GetPhysicsObjectCount() - 1 do
					local physn = self:GetStand():GetPhysicsObjectNum(i)
					physn:EnableCollisions(false)
					physn:SetVelocity(Vector(0,0,0))
					physn:RecheckCollisionFilter()
					phys:EnableCollisions(false)
					phys:SetVelocity(Vector(0,0,0))
					phys:RecheckCollisionFilter()
				end
			end
			local pos = self:GetStand():WorldSpaceCenter() - self:GetStand():GetForward() * 15
			if self.WallDir then
			self.WallDownDir = -self.WallDir
			end
			local dir = self:GetStand():GetUp()
			local tr = util.TraceLine( {
				start = pos + dir * 5,
				endpos = (pos + dir * 5) - (dir * 155),
				filter = {self.Owner, self:GetStand()}
			} )	
			-- local angle = tr.HitNormal:Angle()
			-- angle:RotateAroundAxis(tr.HitNormal, 90)
			self:GetStand():SetVelocity(Vector(0,0,0))
			self.WallDir = tr.HitNormal:Angle():Up()
			self.Throttle = self.Throttle or 0
			self.Throttle = math.Clamp(self.Throttle - 0.01, 0, 1)
			if !tr.HitWorld and self.ClimbState != 2 and self.ClimbState != 3 then 
				self.ClimbState = 5
				self:GetStand():SetSolid(SOLID_OBB)
				for i=0, self:GetStand():GetPhysicsObjectCount() - 1 do
					local physn = self:GetStand():GetPhysicsObjectNum(i)
					phys:EnableCollisions(true)
					physn:EnableCollisions(true)
					physn:RecheckCollisionFilter()
					phys:RecheckCollisionFilter()
				end
				local pos = self:GetPos()
				self:GetStand():SetMoveType(MOVETYPE_VPHYSICS)
				self:GetStand():SetPos(pos)
				self:GetStand():SetThrottle(0)
			end
			if self.Owner:KeyDown(IN_FORWARD) then
				self.Throttle = self.Throttle + 0.02
			end
			

			if self.Owner:gStandsKeyDown("dododo") then

				if self:GetStand():GetPos():Distance(self.Pos) > 5 and self.ClimbState == 1 then
				
					self:GetStand():SetPos(LerpVector( self.Throttle/10, self:GetStand():GetPos(), self.Pos))
					self:GetStand():SetAngles(LerpAngle(self.Throttle/10, self:GetStand():GetAngles(), self.angle))
					elseif self:GetStand():GetPos():Distance(self.Pos) < 5 then
					self.ClimbState = 2
				end
				if tr.HitWorld and self.ClimbState == 2 then
					self:GetStand():SetAbsVelocity(Vector(0,0,0))
					self:GetStand():SetVelocity(Vector(0,0,0))
					
					if IsValid(phys) then
						for i=0, self:GetStand():GetPhysicsObjectCount() - 1 do
							local physn = self:GetStand():GetPhysicsObjectNum(i)
							physn:SetVelocity(Vector(0,0,0))
							phys:SetVelocity(Vector(0,0,0))
						end
					end
					self:GetStand():SetPos(LerpVector( self.Throttle/10, self:GetStand():GetPos(), tr.HitPos + (self.WallDir * 155)))
					local backpos = self:GetStand():GetPos()
					local startp = (backpos) - (self:GetStand():GetUp() * 255) + Vector(0,0,555)
						local tr2 = util.TraceLine( {
						start = startp,
						endpos = startp - Vector(0,0,455),
						filter = {self.Owner, self:GetStand()}
					} )	
					if !self.WallDir == Vector(0,0,1) then
					local ang = self.WallDir:Angle()
					ang:RotateAroundAxis(tr.HitNormal, -90)
					self.Stand:SetAngles(LerpAngle(0.1, self.Stand:GetAngles(), ang))
					end
					elseif !tr.HitWorld and self.ClimbState == 2 then
					self.ClimbState = 3
					if IsValid(phys) then
					for i=0, self:GetStand():GetPhysicsObjectCount() - 1 do
							local physn = self:GetStand():GetPhysicsObjectNum(i)
							physn:EnableCollisions(true)
							physn:SetVelocity(Vector(0,0,0))
							phys:EnableCollisions(true)
							phys:SetVelocity(Vector(0,0,0))
						end
					end
					self:GetStand():SetVelocity(Vector(0,0,0))
					--local angle = self:GetStand():GetAngles()
					--angle:RotateAroundAxis(self:GetStand():GetRight(), -90)
					--self:GetStand():SetAngles(angle)
					--self:GetStand():SetSolid(SOLID_VPHYSICS)
					local backpos = self:GetStand():GetPos()
					local startp = (backpos) - (self:GetStand():GetUp() * 255) + Vector(0,0,555)
					local tr2 = util.TraceLine( {
						start = startp,
						endpos = startp - Vector(0,0,455),
						filter = {self.Owner, self:GetStand()}
					} )	
					self.Pos2 = tr2.HitPos
					local tempang = self:GetStand():GetAngles()
					local tempang2 = tr2.HitNormal:Angle()
					tempang:RotateAroundAxis(self:GetStand():GetRight(), -90)
					self.angle2 = tempang
					--self.angle2:RotateAroundAxis(self:GetStand():GetForward(), 90)
					self:GetStand():SetThrottle(0)
					elseif self.ClimbState == 3 then
					if self:GetStand():GetPos():Distance(self.Pos2) > 15 then
						for i=0, self:GetStand():GetPhysicsObjectCount() - 1 do
							local physn = self:GetStand():GetPhysicsObjectNum(i)
							physn:SetVelocity(Vector(0,0,0))
							phys:SetVelocity(Vector(0,0,0))
						end
						local backpos = self:GetStand():GetPos()
					
					self:GetStand():SetVelocity(Vector(0,0,0))
						self:GetStand():SetPos(LerpVector( 0.1, self:GetStand():GetPos(), self.Pos2))
						self:GetStand():SetAngles(LerpAngle(0.1, self:GetStand():GetAngles(), self.angle2))
						else
						self.ClimbState = 4
					end
					end
				end
			end
			if self.ClimbState == 4 then
			self.ClimbState = 5
			local phys = self:GetStand():GetPhysicsObject()
			self:GetStand():SetSolid(SOLID_OBB)
			if IsValid(phys) then
				for i=0, self:GetStand():GetPhysicsObjectCount() - 1 do
					local physn = self:GetStand():GetPhysicsObjectNum(i)
					physn:EnableCollisions(true)
					physn:RecheckCollisionFilter()
					phys:EnableCollisions(true)
					phys:RecheckCollisionFilter()
				end
			local pos = self:GetPos()
			self:GetStand():SetMoveType(MOVETYPE_VPHYSICS)
			self:GetStand():SetPos(pos)
			self:GetStand():SetThrottle(0)
			
			end
		end
		if IsValid(self.Stand) then
			local tr = util.TraceLine({start=self:GetStand():GetPos(), endpos=self:GetStand():GetPos() - Vector(0,0,155), filter={self:GetStand()}})
			if self.Owner:KeyDown(IN_DUCK) and self.Owner:KeyPressed(IN_JUMP) and tr.HitWorld then
				self:GetStand():GetPhysicsObject():SetVelocity(Vector(0,0,700) + self:GetStand():GetForward() * 700)
				local ang = self:GetStand():GetAngles()
				ang.p = -1
				self:GetStand():SetAngles(ang)
			end
			self:GetStand():SetThirdPersonMode(true)
		end
		if self.Owner:KeyDown(IN_JUMP) and self.Owner:KeyDown(IN_JUMP) and IsValid(self:GetStand()) then
			local ang = self:GetStand():GetAngles()
			ang.p = -1
			self:GetStand():GetPhysicsObject():AddAngleVelocity(Vector(15,0,0))
		end
	end
	--Mode changing
	self.Delay = self.Delay or CurTime()
	if self.Owner:gStandsKeyDown("modeswap") then
		if CurTime() > self.Delay and !IsValid(self:GetStand()) then
			self.Delay = CurTime() + 1
			local trLo = util.TraceLine( {
				start = self.Owner:EyePos(),
				endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * self.HitDistance * 65,
				filter = self.Owner,
				mask = MASK_SHOT_HULL
			} )
			if trLo.Entity:IsVehicle() then
				self:DefineStand(trLo.Entity)
			end
			self.HornTimer = CurTime() + 1
		end
		self.HornTimer = self.HornTimer or CurTime()
		if IsValid(self.Stand) and CurTime() >= self.HornTimer then
			self.Stand:EmitSound("vehicles/humvee_horn.wav")
			self.HornTimer = CurTime() + 1
		end
	end
	self:NextThink(CurTime())
	return true
end


function SWEP:PrimaryAttack()
	if IsValid(self:GetStand()) and self.Stand.State then
		if SERVER then
			self:GetStand():EmitStandSound(Shoot)
		end
		timer.Simple(0.1, function()
			for i = 0, 25 do
				self:ShootBullet()
			end
		end)
		timer.Simple(0.2, function()
			for i = 0, 25 do
				self:ShootBullet()
			end
		end)
		for i = 0, 25 do
			self:ShootBullet()
		end
		self:SetNextPrimaryFire( CurTime() + 2)
	end
end

function SWEP:ShootBullet()
	local pos1 = self.Stand:WorldSpaceCenter() + self.Stand:GetForward() * 55
	local pos2 = self.Owner:EyePos() + Vector(0,0,150)
	local dir = self.Owner:GetAimVector()
	dir.z = dir.z + (math.Rand(-0.5, 0.5)  * 0.1)
	dir.x = dir.x + math.Rand(-0.2, 0.2) + (math.Rand(-0.5, 0.5) * 0.1)
	dir.y = dir.y + math.Rand(-0.2,0.2) + (math.Rand(-0.5, 0.5)  * 0.1)
	dir = dir:GetNormalized()
	
	local Pierced = {}
	local PiercedGroup = {}
	local tr = util.TraceLine( {
		start = pos2,
		endpos = pos2 + (dir * 150000),
		filter = {self.Owner, self:GetStand()}
	} )	
			local dir2 = (tr.HitPos - pos1):GetNormalized()
local dmginfo = DamageInfo()
	local attacker = self.Owner
	dmginfo:SetAttacker( attacker )
	dmginfo:SetInflictor( self )
	dmginfo:SetDamage( GetConVar("gstands_wheel_of_fortune_shoot"):GetInt() * self:GetConfidence())
		local tr1 = util.TraceLine( {
		start = pos1,
		endpos = pos1 + (dir2 * 150000),
		filter = {self.Owner, self:GetStand()}
	} )	
		if SERVER then
		tr1.Entity:TakeDamageInfo( dmginfo )
		self:SetConfidence(self:GetConfidence() + 0.01)
		end
		self.GasTimer = self.GasTimer or CurTime()
		if SERVER and math.random(1,5) == 1 and CurTime() >= self.GasTimer then
			self.Owner:EmitSound(Smart)
			self.GasTimer = CurTime() + 3
		end
		tr.Entity.Gasolined = true
		ParticleEffect("gasoline_tracer", pos1, dir2:Angle())
end


function SWEP:SecondaryAttack()
	if IsValid(self:GetStand()) and self.Owner:gStandsKeyDown("modifierkey1") then
		for k,v in pairs(ents.FindInSphere(self:GetStand():GetPos(), 500)) do
			
			if (v:IsPlayer() or v:IsNPC()) and v != self.Owner and v:Health() > 0 then
			if v.Gasolined then
				v.Gasolined = false
				v:Ignite(15)
			end
				local norm = (v:WorldSpaceCenter() - self:GetStand():WorldSpaceCenter() )
				self:EmitSound("ambient/energy/newspark0"..math.random(1,9)..".wav")
				local fxd = EffectData()
				if SERVER then
					local dmginfo = DamageInfo()
					local attacker = self.Owner
					dmginfo:SetAttacker( attacker )
					dmginfo:SetInflictor( self )
					dmginfo:SetDamage( 1  * self:GetConfidence() )					
					v:TakeDamageInfo( dmginfo )
					self:SetConfidence(self:GetConfidence() + 0.001)
				end
				for i=1, 3 do
					local pcnt = i/3
					fxd:SetStart(LerpVector(0.1, self:GetStand():WorldSpaceCenter(), v:WorldSpaceCenter()))
					fxd:SetOrigin(LerpVector(0.1, self:GetStand():WorldSpaceCenter(), v:WorldSpaceCenter()))
					fxd:SetEntity(v)
					fxd:SetNormal(norm/45)
					fxd:SetMagnitude(0.1)
					fxd:SetScale(0.01)
					fxd:SetRadius(5)
					util.Effect("Sparks", fxd, false, true)
				end
				fxd:SetMagnitude(1)
				fxd:SetScale(1)
				fxd:SetRadius(1)
				util.Effect("TeslaHitboxes", fxd, false, true)

			end
		end
		self:SetNextSecondaryFire(CurTime() + 1)
		return true
	end
	if SERVER and IsValid(self:GetStand()) then
		self:GetStand().State = !self:GetStand().State
		self:GetStand():EmitSound(Transform)
		if !self:GetStand().State then
			local state = self:GetStand().State
			local vel = self:GetStand():GetVelocity()
			local throttle = self:GetStand():GetThrottle()
			local pos, ang = self:GetStand():GetPos(), self:GetStand():GetAngles()
			local eyeang = self.Owner:EyeAngles()
			local invehicle = self.Owner:InVehicle() and self.Owner:GetVehicle() == self:GetStand()
			self:GetStand():Remove()
			self:SetStand(ents.Create(self.TargetClass))
			self:GetStand():SetHealth(self.Owner:Health())
			
			self:GetStand().IsWheelOfFortune = true
			self:GetStand().State = state
			self:GetStand():SetModel(self.TargetModel) 
			self:GetStand():SetKeyValue("vehiclescript",self.TargetScript)
			self:GetStand():SetPos(pos) 
			self:GetStand():SetAngles(ang) 
			self:GetStand():Spawn()
			self:GetStand():Activate()
			self:GetStand():SetVelocity(vel)
			self:GetStand():SetThrottle(throttle)
			self:GetStand():StartEngine(true)
			
			self.Owner:ExitVehicle()
			if invehicle then
			self.Owner:EnterVehicle(self:GetStand())
			local eyeang = (eyeang - ang)
			eyeang.r = 0
			self.Owner:SetEyeAngles(eyeang)
			end
			
			else
			local state = self:GetStand().State
			local vel = self:GetStand():GetVelocity()
			local throttle = self:GetStand():GetThrottle()
			local pos, ang = self:GetStand():GetPos(), self:GetStand():GetAngles()
			local eyeang = self.Owner:EyeAngles()
			local invehicle = self.Owner:InVehicle() and self.Owner:GetVehicle() == self:GetStand()

			self:GetStand():Remove()
			self:SetStand(ents.Create("prop_vehicle_jeep"))
			self:GetStand():SetHealth(self.Owner:Health())
			self:GetStand().IsWheelOfFortune = true
			self:GetStand():AddCallback("PhysicsCollide", function(ent, data) 
				self:CalcCollisions(ent, data)
			end)
			self.FlashLight1 = ents.Create("env_projectedtexture")
			if self.FlashLight1 and self.FlashLight1:IsValid() then
			self.FlashLight1:SetPos(self:GetStand():WorldSpaceCenter() + self:GetStand():GetUp() * 45 + self:GetStand():GetForward() * 55 + (self:GetStand():GetRight() * 55))
				self.FlashLight1:SetAngles(self:GetStand():GetForward():Angle())
							self:SetLight1(self.FlashLight1)

				self.FlashLight1:SetParent(self:GetStand())
				self.FlashLight1:SetKeyValue("lightfov", 75)
				self.FlashLight1:SetKeyValue("enableshadows", "true" )
			end
			self.FlashLight2 = ents.Create("env_projectedtexture")
			if self.FlashLight2 and self.FlashLight2:IsValid() then
				self.FlashLight2:SetPos(self:GetStand():WorldSpaceCenter() + self:GetStand():GetUp() * 45 + self:GetStand():GetForward() * 55 - (self:GetStand():GetRight() * 30))
				self.FlashLight2:SetAngles(self:GetStand():GetForward():Angle())
				self.FlashLight2:SetParent(self:GetStand())
							self:SetLight2(self.FlashLight2)

				self.FlashLight2:SetKeyValue("lightfov", 75)
				self.FlashLight2:SetKeyValue("enableshadows", "true" )
			end
			self:GetStand().State = state
			self:GetStand():SetModel("models/wof/wof.mdl") 
			self:GetStand():SetKeyValue("vehiclescript","scripts/vehicles/gstands/wof/wof.txt")
			self:GetStand():SetPos(pos) 
			self:GetStand():SetAngles(ang) 
			self:GetStand():Spawn()
			self:GetStand():Activate()
			self:GetStand():SetVelocity(vel)
			self:GetStand():SetThrottle(throttle)
			self:GetStand():StartEngine(true)
			self:GetStand():SetThirdPersonMode(true)
			
			self.Owner:ExitVehicle()
			if invehicle then
			self.Owner:EnterVehicle(self:GetStand())
			local eyeang = (eyeang - ang)
			eyeang.r = 0
			self.Owner:SetEyeAngles(eyeang)
			end
			
			
		end
	end
	self:SetNextSecondaryFire( CurTime() + 1 )
end

function SWEP:Reload()
	
end

--Screw this entire section, it only works like 20% of the time. Basically, meant to catch every time the weapon is not in your hands in order to remove the stand.
function SWEP:OnDrop()
	self:UnDefineStand()
	return true
end

function SWEP:OnRemove()
	self:UnDefineStand()
	return true
end

function SWEP:Holster()
	self:UnDefineStand()
	
	return true
end