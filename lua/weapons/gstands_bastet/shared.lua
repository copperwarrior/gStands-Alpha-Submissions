--Send file to clients
if SERVER then
   AddCSLuaFile( "shared.lua" )
end
if CLIENT then
   SWEP.Slot      = 1
end

SWEP.Power = 2.5
SWEP.Speed = 1.95
SWEP.Range = 1500
SWEP.Durability = 1500
SWEP.Precision = nil
SWEP.DevPos = nil

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.bastet.purpose"
SWEP.Instructions  = "#gstands.bastet.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.bastet"

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

SWEP.StandModel 			= "models/props_lab/tpplugholder_single.mdl"
SWEP.StandModelP 			= "models/props_lab/tpplugholder_single.mdl"
if CLIENT then
	SWEP.StandModel = "models/empress/empress.mdl"
end
dLight = nil

local Shoot = Sound( "weapons/sun/shoot.mp3" )
local Deploy = Sound("weapons/sun/deploy.mp3")

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
	self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_standing_02"))
	self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE + 1
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
	-- "normal" jump animation doesn't exist
	if ( t == "normal" ) then
		self.ActivityTranslate[ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end
    
    
end
function SWEP:SetupDataTables()
		self:NetworkVar("Entity", 0, "Bastet")
		self:NetworkVar("Bool", 0, "Active")
		self:NetworkVar("Bool", 0, "BastAct")
end
--Define swing and hit sounds. Might change these later.
function SWEP:Initialize()
	timer.Simple(0.1, function() 
		if self:GetOwner() != nil then
			if self:GetOwner():IsValid() and SERVER then
				self:GetOwner():SetHealth(GetConVar("gstands_bastet_heal"):GetInt())
				self:GetOwner():SetMaxHealth(GetConVar("gstands_bastet_heal"):GetInt())
			end
		end
	end)
    self:SetNextPrimaryFire( CurTime() + 1 )
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
local pos, material, white = Vector( 0, 0, 0 ), Material( "vgui/hud/gstands_hud/crosshair" ), Color( 141, 123, 71, 255 )
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
		local color = Color(143,123,71,255) 
		local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
		if self:GetActive() then
			surface.SetMaterial(boxdis)
			else
			surface.SetMaterial(boxend)
		end
		surface.DrawTexturedRect(width - (192 * mult) - 135 * mult, height - (192 * mult) - 10 * mult, 192 * mult, 192 * mult)
		if self:GetActive() then
			surface.SetMaterial(boxend)
			else
			surface.SetMaterial(boxdis)
		end
		surface.DrawTexturedRect(width - (192 * mult), height - (192 * mult) - 10 * mult, 192 * mult, 192 * mult)
		draw.TextShadow({
			text = "gstands.hud.standart",
			font = "gStandsFont",
			pos = {width - 290 * mult, height - 190 * mult},
			color = tcolor,
		}, 2 * mult, 250)
		draw.TextShadow({
			text = "gstands.hud.rozetka",
			font = "gStandsFont",
			pos = {width - 145 * mult, height - 190 * mult},
			color = tcolor,
		}, 2 * mult, 250)
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
hook.Add( "HUDShouldDraw", "BastetHud", function(elem)
	if IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_bastet" and (elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") and GetConVar("gstands_draw_hud"):GetBool() then
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
			clr = HSVToColor(141,123,71)
			surface.SetDrawColor( clr )
			surface.DrawTexturedRect( pos2d.x - 16, pos2d.y - 16, 32, 32 )
		end
		return true
	end
end
--Deploy starts up the stand
function SWEP:Deploy()
    self:SetHoldType( "stando" )
    if SERVER then
    end
end

function SWEP:Think()
    self.Bastet = self:GetBastet()
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
	if self.Owner:gStandsKeyDown("modeswap") then
		--Mode changing
		self.Delay = self.Delay or CurTime()
			if CurTime() > self.Delay then
				self.Owner:SetAnimation(PLAYER_RELOAD)
						self.Delay = CurTime() + 1

				timer.Simple(1, function()
				--Flip the mode bool
				self:SetBastAct( !self:GetBastAct())
				
				if SERVER then
					if(self:GetBastAct()) then 

						local tr = util.TraceLine( {
						start = self.Owner:EyePos(),
						endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * self.HitDistance * 5,
						filter = self.Owner,
						collisiongroup = COLLISION_GROUP_DEBRIS
						} )
						if tr.Hit then
						self:SetBastet( ents.Create("bastent"))
						self.Bastet = self:GetBastet()
						self.Bastet:SetPos(tr.HitPos + Vector( 0,0,0 ))
						self.Bastet:SetModel("models/props_lab/tpplugholder_single.mdl")
						self.Bastet:SetOwner(self.Owner)
						self.Bastet:SetAngles(tr.HitNormal:Angle())
						self.Bastet:SetModelScale(0.5)
						self.Bastet:Spawn()
						self.Bastet:Activate()
						timer.Simple(0.001, function() 
							if self.Bastet:IsValid() then
								self.Owner:ChatPrint("#gstands.bastet.place")
							else
								self:SetBastAct( !self:GetBastAct())
							end
						end)
						if tr.Entity:IsValid() then
							self.Bastet:SetParent(tr.Entity)
						end
						else
						self.Owner:ChatPrint("#gstands.bastet.toofar")
						self:SetBastAct( false)
						end
					else
						self.Owner:ChatPrint("#gstands.bastet.remove") 
						self.Bastet:Remove()
				end
			end
				end)
		end
	end
end

   
function SWEP:PrimaryAttack()
        self.Owner:SetAnimation(PLAYER_ATTACK1)
        timer.Simple(0.2, function()
            for i=0, 5 do
                self:Throw()
            end
        end)
        --Miniscule delay
        self:SetNextPrimaryFire( CurTime() + 1 )
    end
    
function SWEP:Throw()
    self.Owner:EmitSound("WeaponFrag.Throw")
	if IsFirstTimePredicted() then
		if (SERVER) then
			local bolt = ents.Create("prop_physics")
			if IsValid(bolt) then
				bolt:SetAngles(self.Owner:EyeAngles() + Angle(0,180,0))
                bolt:SetPos(self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")) + Vector(math.random(-10,10),math.random(-10,10),math.random(-10,10)))
                bolt:SetOwner(self.Owner)
				bolt:SetPhysicsAttacker(self.Owner)
                bolt:SetModel("models/bastet/nail.mdl")
                bolt:SetModelScale(math.Rand(0.3,0.5))
				bolt:Spawn()
				bolt:Activate()
                bolt:GetPhysicsObject():SetMaterial("metal")
                bolt:GetPhysicsObject():SetMass(2)
                timer.Simple(2, function() bolt:Remove() end)
			end
		end
	end
end

function SWEP:SecondaryAttack()
		        self.Owner:SetAnimation(PLAYER_ATTACK1)

 self.Owner:EmitSound("WeaponFrag.Throw")
	if IsFirstTimePredicted() then
		if (SERVER) then
			local bolt = ents.Create("prop_physics")
			if IsValid(bolt) then
				bolt:SetAngles(self.Owner:EyeAngles() + Angle(0,180,0))
                bolt:SetPos(self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")) + Vector(math.random(-10,10),math.random(-10,10),math.random(-10,10)))
                bolt:SetOwner(self.Owner)
				bolt:SetPhysicsAttacker(self.Owner)
                bolt:SetModel("models/player/dio/knifejf.mdl")
				bolt:Spawn()
				bolt:Activate()
                bolt:GetPhysicsObject():SetMaterial("metal")
                bolt:GetPhysicsObject():SetMass(2)
                timer.Simple(2, function() if IsValid(bolt) then bolt:Remove() end end)
			end
		end
	end
	self:SetNextSecondaryFire( CurTime() + 3 )
end


function SWEP:Reload()
end

function SWEP:OnDrop()
    if SERVER and self.Bastet and self.Bastet:IsValid() then
    self:SetBastAct( false)
    self.Bastet:Remove()
    end
    return true
end

function SWEP:OnRemove()
    if SERVER and self.Bastet and self.Bastet:IsValid() then
    self:SetBastAct( false)
    self.Bastet:Remove()
    end
    return true
end

function SWEP:Holster()
    return true
end