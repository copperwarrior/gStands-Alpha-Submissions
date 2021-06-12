--Send file to clients
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot      = 1
end

SWEP.Power = 2.5
SWEP.Speed = 2.25
SWEP.Range = D
SWEP.Durability = 1500
SWEP.Precision = nil
SWEP.DevPos = nil

SWEP.Targets = {}

SWEP.Author        = "Zaygh, Copper"
SWEP.Purpose       = "#gstands.strength.purpose"
SWEP.Instructions  = "#gstands.strength.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.strength"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos            = 2
SWEP.DrawCrosshair      = true

SWEP.WorldModel = "models/player/whitesnake/disc.mdl"
SWEP.ViewModelFOV = 54
SWEP.UseHands = true
SWEP.StandModel 				= "models/sun/gstands_sun.mdl"
SWEP.StandModelP 				= "models/sun/gstands_sun.mdl"
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
SWEP.gStands_IsThirdPerson = true

local PrevHealth = nil

--Define swing and hit sounds. Might change these later.
local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )
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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= ACT_HL2MP_IDLE_SUITCASE
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE_SLAM + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_01"))
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_becon"))
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_becon"))
		self.ActivityTranslate[ ACT_MP_JUMP ]						= ACT_HL2MP_IDLE_SLAM + 7
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
	self:NetworkVar( "Entity", 0, "Camera" )
end

function SWEP:Initialize()
	timer.Simple(0.1, function() 
		if self:GetOwner() != nil then
			if self:GetOwner():IsValid() and SERVER then
				self:GetOwner():SetHealth(GetConVar("gstands_strength_heal"):GetInt())
				self:GetOwner():SetMaxHealth(GetConVar("gstands_strength_heal"):GetInt())
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
		local color = Color(255,150,255, 255)
		local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
	end
end
hook.Add( "HUDShouldDraw", "StrengthHud", function(elem)
	if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_strength" and (((elem == "CHudWeaponSelection" ) and LocalPlayer().SPInZoom) or elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
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
	if LocalPlayer():gStandsKeyDown("dododo") and IsValid(self:GetCamera()) then
		pos = self:GetCamera():GetAttachment(1).Pos + self:GetCamera():GetAttachment(1).Ang:Forward() * 105
		ang = self:GetCamera():GetAttachment(1).Ang
	end

	if ( trace.Hit ) then pos = trace.HitPos else pos = trace.HitPos end
	return pos + offset,ang
end
--Deploy starts up the stand
function SWEP:Deploy()
    self:SetHoldType( "stando" )
	
    if self.Owner:Health() == 100  then
        self.Owner:SetMaxHealth( self.Durability )
        self.Owner:SetHealth( self.Durability )
	end
	
	
    self.Owner:SetCanZoom(false)
    if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitStandSound("physics/metal/metal_break"..math.random(1,2)..".wav")
		end
	end
end

function SWEP:Think()
	
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
	self.Cameras = self.Cameras or {}
	for k,v in pairs(self.Targets) do
		if v:IsValid() then
			v.ColorOffsetStrength = v.ColorOffsetStrength or math.random(1,100)
			v:SetColor(HSVToColor((CurTime() + v.ColorOffsetStrength) * 15 % 360, 0.2, 1))
			v:SetOwner(nil)
		end
		if v:IsValid() and v:WorldSpaceCenter():Distance(self.Owner:WorldSpaceCenter()) >= 2500 then
			v:SetModelScale(1, 1)
			v:SetColor(Color(255,255,255,255))
			v:EmitSound("physics/metal/metal_solid_strain"..math.random(1,5)..".wav")
			
			timer.Simple(1, function() if v:IsValid() then v:Activate() end end)
			table.remove(self.Targets, k)
		end
		if IsValid(v) and v:GetClass() == "npc_combine_camera" then
			if !table.HasValue(self.Cameras, v) then
				table.insert(self.Cameras, v)
				self:SetCamera(v)
			end
		end
		
	end
    if SERVER and self.Targets and self.Owner:gStandsKeyDown("modeswap") then
        for k,v in pairs(self.Targets) do
            if v and v:IsValid() then
                v.LastColGroup = v:GetCollisionGroup()
                v:SetCollisionGroup(COLLISION_GROUP_WEAPON)
                if SERVER then
					v:EmitStandSound("physics/body/body_medium_strain"..math.random(1,3)..".wav", 60, 50)
				end
				
			end
		end
		elseif self.Targets then
        for k,v in pairs(self.Targets) do
            if v and v:IsValid() then
				local phys = v:GetPhysicsObject()
				if IsValid(phys) and !phys:IsMotionEnabled() then
					phys:EnableMotion(true)
					phys:Wake()
				end
				local mins, maxs = v:GetCollisionBounds()
				mins = v:LocalToWorld(mins)
				maxs = v:LocalToWorld(maxs)
                v:SetCollisionGroup(COLLISION_GROUP_NONE)
				for i, j in pairs(ents.FindInBox(mins, maxs)) do
					if j:IsPlayer() and j != self.Owner then
						local tr = util.TraceLine({
							start = j:EyePos(),
							endpos = j:EyePos(),
							filter = {j, self, self.Owner}
						})
						if tr.Entity == v then
							local dmginfo = DamageInfo()			
							local attacker = self.Owner
							dmginfo:SetAttacker( attacker )
							
							dmginfo:SetInflictor( self )
							dmginfo:SetDamage( 1 )
							
							dmginfo:SetDamageType(DMG_DIRECT)
							j:TakeDamageInfo( dmginfo )
							v:SetVelocity(-v:GetVelocity())
						end
						elseif j == self.Owner and IsValid(phys) then
						phys:EnableMotion(false)
						
					end
				end
				
			end
		end
		for k,v in pairs(self.Targets) do
			if !v:IsValid() then
				table.remove(self.Targets, k)
			end
		end
	end
	self:NextThink(CurTime())
	return true
end

function SWEP:PrimaryAttack()
	local trE = util.TraceLine( {
        start = self.Owner:EyePos(),
        endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 500,
		filter = {self.Owner},
		mask = MASK_SHOT_HULL,
	} )
	for k,v in pairs(ents.FindInBox(trE.HitPos - Vector(10,10,10), trE.HitPos + Vector(10, 10, 10))) do
		if SERVER and IsValid(v) and !v.Tagged and !v:IsWorld() and !table.HasValue(self.Targets, v) and (string.StartWith(v:GetClass(), "prop") or string.StartWith(v:GetClass(), "func") or v:GetClass() == "npc_combine_camera") then
			table.insert(self.Targets, v)
			v:EmitStandSound("physics/metal/metal_box_strain"..math.random(1,4)..".wav")
			if v:GetClass() == "prop_vehicle_crane" then
				table.insert(self.Targets, ents.FindByName(v:GetKeyValues()["magnetname"])[1])
				v.Tagged = true
			end
			self.Owner:ChatPrint(v:GetClass())
		end
	end
	
	self:SetNextPrimaryFire(CurTime() + 0.5)
end

function SWEP:SecondaryAttack()
	local ownerdir = self.Owner:GetAimVector()
	local notarg = table.Copy(self.Targets)
	table.insert(notarg, self.Owner)
	self.TargRemove = {}
	self.strengthResizeTimer = self.strengthResizeTimer or CurTime()
	local trE = util.TraceLine( {
        start = self.Owner:EyePos(),
        endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 500,
		filter = notarg,
		mask = MASK_SHOT_HULL,
	} )
	local ShadowParams = {}
	ShadowParams.secondstoarrive = 1 
	ShadowParams.pos = trE.HitPos
	ShadowParams.angle = self.Owner:EyeAngles()
	ShadowParams.maxangular = 1000
	ShadowParams.maxangulardamp = 10000 
	ShadowParams.maxspeed = 1000
	ShadowParams.maxspeeddamp = 10000
	ShadowParams.dampfactor = 0.1
	ShadowParams.teleportdistance = 0
	ShadowParams.deltatime = FrameTime()
	if !self.Owner:gStandsKeyDown("dododo") then
		for k,v in pairs(self.Targets) do
		v:EmitSound("physics/metal/metal_box_strain"..math.random(1,4)..".wav", 75, math.random(90, 110), 0.8)
			if SERVER and IsValid(v) and !self.Owner:gStandsKeyDown("modifierkey1") then
				local norm = (v:WorldSpaceCenter() - self.Owner:EyePos()):GetNormalized()
				if v:GetKeyValues()["health"] > 0 and norm:Dot(ownerdir) > 0.8 then
						v:SetKeyValue( "explosion", "2" ) 
						v:SetKeyValue( "gibdir", tostring(-ownerdir:Angle()) )
						v:Fire( "Break" )
						local mins, maxs = v:GetCollisionBounds()
						maxs = maxs - ownerdir * 55
						mins = v:LocalToWorld(mins)
						maxs = v:LocalToWorld(maxs)
						for i, j in pairs(ents.FindInBox(mins, maxs)) do
							if IsValid(j) and j:Health() > 0 then
								local dmginfo = DamageInfo()
								local attacker = self.Owner
								dmginfo:SetAttacker( attacker )
								dmginfo:SetInflictor( self )
								dmginfo:SetDamage( 65 )
								j:TakeDamageInfo( dmginfo )
							end
						end
						table.insert(self.TargRemove, v)
				elseif (string.StartWith(v:GetClass(), "prop_physics") )then
				
					if CurTime() >= self.strengthResizeTimer then
						local scale = v:GetModelScale() + 0.5 
						timer.Create("strengthScaling"..v:EntIndex(),  0.1, 0, function()
							if v:IsValid() and v:GetModelScale() < scale and v:GetModelScale() < 5 then
								v:SetModelScale( v:GetModelScale() +0.05, 0 )
								v:Activate()
								if SERVER then
									v:EmitStandSound("physics/metal/metal_box_strain"..math.random(1,4)..".wav")
								end
								else
								timer.Remove("strengthScaling"..v:EntIndex())
							end
						end)
					end
				elseif v:GetClass() == "prop_door_rotating" or v:GetClass() == "func_door" then
					v:Input("toggle", self.Owner, self)
				elseif v:GetClass() == "func_useableladder" then
					local mins, maxs = v:GetCollisionBounds()
					mins = v:LocalToWorld(mins * 2)
					maxs = v:LocalToWorld(maxs * 2)
					for i, j in pairs(ents.FindInBox(mins, maxs)) do
						if IsValid(j) and j:IsPlayer() then
							print(j)
							local normJ = (v:GetForward()):GetNormalized()
							normJ.z = 0
							v:Input("disable", self.Owner, self)
							j:SetMoveType(MOVETYPE_WALK)
							j:SetVelocity(normJ * 700)
						end
					end
				elseif v:GetClass() == "func_button" then
					for i,j in pairs(ents.FindInSphere(v:GetPos(), 125)) do
						if j:IsPlayer() or j:IsNPC() then
							if j != self.Owner and SERVER and j:Health() > 0 then
								local dmginfo = DamageInfo()			
								local attacker = self.Owner
								dmginfo:SetAttacker( attacker )
								
								dmginfo:SetInflictor( self )
								dmginfo:SetDamage( 35 )
								
								dmginfo:SetDamageType(DMG_SHOCK)
								j:TakeDamageInfo( dmginfo )
								j:SetVelocity(tr.Normal * 275)
								j:EmitSound("ambient/energy/newspark0"..math.random(1,9)..".wav")
								if IsFirstTimePredicted() then
									local fxd = EffectData()
									fxd:SetOrigin(j:GetPos())
									fxd:SetEntity(v)
									fxd:SetMagnitude(10)
									fxd:SetScale(10)
									util.Effect("TeslaZap", fxd, true, true)
								end
							end
						end
					end
				elseif v:GetClass() == "prop_vehicle_crane" then
					if IsValid(v) and v:GetClass() == "prop_vehicle_crane" then
						local magnet = ents.FindByName(v:GetKeyValues()["magnetname"])[1]
						local phys = magnet:GetPhysicsObject()
						magnet:SetOwner(self.Owner)
						phys:Wake()
						phys:EnableMotion(true)
						phys:ComputeShadowControl( ShadowParams )
						local normJ = (ShadowParams.pos - v:WorldSpaceCenter()):GetNormalized()
						local ang = normJ:Angle()
						ang.p = 0
						ang.r = 0
						ang.y = ang.y - 90
						v:Input("turnon")
						v:SetKeyValue("gmod_allowphysgun", "true")
						v:EnableEngine(true)
						v:StartEngine(true)
					end
				end
		end
		self.LockTimer = self.LockTimer or CurTime()
		self.MagnetTimer = self.MagnetTimer or CurTime()
		if SERVER and IsValid(v) and self.Owner:gStandsKeyDown("modifierkey1") then
			local norm = (v:WorldSpaceCenter() - self.Owner:EyePos()):GetNormalized()
			if string.StartWith(v:GetClass(), "prop_physics")  and norm:Dot(ownerdir) > 0.8 then
				local phys = v:GetPhysicsObject()
				if phys:IsValid() then
					v:SetOwner(self.Owner)
					phys:Wake()
					phys:EnableMotion(true)
					phys:ComputeShadowControl( ShadowParams )
				end
				elseif (v:GetClass() == "prop_door_rotating" or v:GetClass() == "func_door") and CurTime() >= self.LockTimer then
				if !self.Lock then
					v:Input("lock", self.Owner, self)
					self.Owner:ChatPrint("#gstands.strength.doors.lock")
					self.Lock = true
					else
					v:Input("unlock", self.Owner, self)
					self.Owner:ChatPrint("#gstands.strength.doors.unlock")
					self.Lock = false
				end
				self.LockTimer = CurTime() + 1
				elseif v:GetClass() == "prop_vehicle_crane" and CurTime() >= self.MagnetTimer then
				if IsValid(v) and v:GetClass() == "prop_vehicle_crane" then
					local magnet = ents.FindByName(v:GetKeyValues()["magnetname"])[1]
					if !self.MagnetOn then
						magnet:Input("turnon")
						self.MagnetOn = true
						self.Owner:ChatPrint("#gstands.strength.magnet.on")
						else
						magnet:Input("turnoff")
						self.MagnetOn = false
						self.Owner:ChatPrint("#gstands.strength.magnet.off")
					end
					self.MagnetTimer = CurTime() + 1
				end
			end
		end
	end
	end
	if SERVER and self.Owner:gStandsKeyDown("dododo") then
		self.CameraIndex = self.CameraIndex or 1
		self:SetCamera(self.Cameras[self.CameraIndex % #self.Cameras + 1])
		self.CameraIndex = self.CameraIndex + 1
		self:SetNextSecondaryFire(CurTime() + 0.5)
		
	end
	self.strengthResizeTimer = CurTime() + 1
	
	for k,v in pairs(self.TargRemove) do
		table.RemoveByValue(self.Targets, v)
	end
	self.TargRemove = {}
	self:SetNextPrimaryFire(CurTime() + 0.01)
end

function SWEP:Reload()
	
	
end
--Screw this entire section, it only works like 20% of the time. Basically, meant to catch every time the weapon is not in your hands in order to remove the stand.
function SWEP:OnDrop()
    for k,v in pairs(self.Targets) do
		v.Tagged = false
		v:SetColor(Color(255,255,255,255))
		v:SetModelScale(1, 1)
		v:EmitStandSound("physics/metal/metal_box_strain"..math.random(1,5)..".wav")
		timer.Simple(1, function() if v:IsValid() then v:Activate() v:EmitStandSound("physics/metal/metal_box_strain"..math.random(1,5)..".wav") end end)
	end
	self.Targets = {}
    return true
end

function SWEP:OnRemove()
	for k,v in pairs(self.Targets) do
		v.Tagged = false
		v:SetColor(Color(255,255,255,255))
		v:SetModelScale(1, 1)
		v:EmitStandSound("physics/metal/metal_box_strain"..math.random(1,5)..".wav")
		timer.Simple(1, function() if v:IsValid() then v:Activate() v:EmitStandSound("physics/metal/metal_box_strain"..math.random(1,5)..".wav")end end)
	end
	self.Targets = {}
    return true
end

function SWEP:Holster()
	for k,v in pairs(self.Targets) do
		v.Tagged = false
		v:SetColor(Color(255,255,255,255))
		
		v:SetModelScale(1, 1)
		v:EmitStandSound("physics/metal/metal_box_strain"..math.random(1,5)..".wav")
	timer.Simple(1, function() if v:IsValid() then v:Activate() v:EmitStandSound("physics/metal/metal_box_strain"..math.random(1,5)..".wav") end end)    end
	self.Targets = {}
    return true
end