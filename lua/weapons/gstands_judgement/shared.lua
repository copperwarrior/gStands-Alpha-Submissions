--Send file to clients
if SERVER then
AddCSLuaFile( "shared.lua" )
end
if CLIENT then
SWEP.Slot      = 1
end

SWEP.Power = 2.5
SWEP.Speed = 1.75
SWEP.Range = 500
SWEP.Durability = 1000
SWEP.Precision = A
SWEP.DevPos = A

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.jgm.purpose"
SWEP.Instructions  = "#gstands.jgm.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.jgm"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos            = 2
SWEP.DrawCrosshair      = true

SWEP.WorldModel = "models/player/whitesnake/disc.mdl"
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

SWEP.DrawAmmo       = true
SWEP.CanZoom       = false
SWEP.HitDistance    = 48
SWEP.ChargeStart = 0
SWEP.ChargeEnd = 0
SWEP.LatchedEnt = nil
SWEP.BarrierNum = 0
SWEP.BarrierList = {}
SWEP.BarrierAvg = Vector(0,0,0)
SWEP.Delay3 = 0
SWEP.WaxOn = false
SWEP.Spikes = {}

SWEP.StandModel = "models/player/jgm/jgm.mdl"
SWEP.StandModelP = "models/player/jgm/jgm.mdl"
SWEP.gStands_IsThirdPerson = true
if CLIENT then
		SWEP.StandModel = "models/player/jgm.mdl"
end
--Define swing and hit sounds. Might change these later.
--local SwingSound = Sound( "WeaponFrag.Throw" )
local Deploy = Sound("weapons/jgm/deploy.wav")
local SDeploy = Sound("weapons/jgm/sdeploy.wav")
local robo1 = Sound("weapons/jgm/robo/robo_1.wav")
local robo2 = Sound("weapons/jgm/robo/robo_2.wav")
local robo3 = Sound("weapons/jgm/robo/robo_3.wav")
local robo4 = Sound("weapons/jgm/robo/robo_4.wav")
local robo5 = Sound("weapons/jgm/robo/robo_5.wav")
local laugh = Sound("jgm.laugh")
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
	[ "stando" ]		= ACT_HL2MP_IDLE_KNIFE
	
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
	self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_fists_r"))
	self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_fists_r"))
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
				text = "#gstands.jgm.malicious",
				font = "gStandsFont",
				pos = {width - 295 * mult, height - 295 * mult},
				color = tcolor,
			}, 2 * mult, 250)
			
			draw.TextShadow({
				text = "#gstands.jgm.benevolent",
				font = "gStandsFont",
				pos = {width - 165 * mult, height - 295 * mult},
				color = tcolor,
			}, 2 * mult, 250)
			
		
		end
	end
hook.Add( "HUDShouldDraw", "JudgementHud", function(elem)
	if IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_judgement" and (elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") and GetConVar("gstands_draw_hud"):GetBool() and GetConVar("gstands_draw_hud"):GetBool() then
		return false
	end
end)
	local material = Material( "vgui/hud/gstands_hud/crosshair" )
	function SWEP:DoDrawCrosshair(x,y)
		if IsValid(self.Stand) and IsValid(self.Owner) then
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
	
function SWEP:SetupDataTables()
		self:NetworkVar("Entity", 0, "Stand")
		self:NetworkVar("Bool", 0, "AMode")
		self:NetworkVar("Bool", 1, "InRange")
		self:NetworkVar("Float", 1, "Delay2")
		self:NetworkVar("Bool", 2, "Ended")
end

function SWEP:Initialize()
	--Set the third person hold type to fists
	if CLIENT then
	end
	self:DrawShadow(false)
	self.CanZoom = false

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
local material = Material( "sprites/hud/v_crosshair1" )
function SWEP:DoDrawCrosshair(x,y)
	if IsValid(self.Stand) then
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
			surface.SetDrawColor( gStands.GetStandColorTable(self.Stand:GetModel(), self.Stand:GetSkin()) )
			surface.DrawTexturedRect( pos2d.x - 8, pos2d.y - 8, 16, 16 )
		end
		return true
	end
end
--Deploy starts up the stand
function SWEP:Deploy()
	self:SetHoldType( "stando" )

	--As is standard with stand addons, set health to 1000
	if self.Owner:Health() == 100  then
		self.Owner:SetMaxHealth( self.Durability )
		self.Owner:SetHealth( self.Durability )
	end
	
	--Create the stand
	self:DefineStand()
	
	--Create some networked variables, solves some issues where multiple people had the same stand
	if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitStandSound(Deploy)
			self.Owner:EmitStandSound(SDeploy)
		end
		timer.Simple(0.5, function() if IsValid(self) and IsValid(self.Stand) then self.Stand:EmitStandSound(robo1) end end)
		timer.Simple(0.7, function() if IsValid(self) and IsValid(self.Stand) then self.Stand:EmitStandSound(robo5) end end)
	end
end
local HoldPunch = false
--Creates stand and adds attributes to the stand.
function SWEP:DefineStand()
	if SERVER then
		self:SetStand( ents.Create("stand_useable"))
		self.Stand = self:GetStand()
		self.Stand:SetOwner(self.Owner)
		self.Stand:SetModel(self.StandModel)
		self.Stand:SetMoveType( MOVETYPE_NOCLIP )
		self.Stand:SetAngles(self.Owner:GetAngles())
		self.Stand:SetPos(self.Owner:GetBonePosition(0)+Vector(0, 0, 0))
		self.Stand:DrawShadow(false)
		self.Stand.Range = self.Range
		self.Stand.Speed = 20 * self.Speed
		self.Stand:Spawn()
		self.Stand:ResetSequence(self.Stand:LookupSequence("standdeploy"))
		self.Stand.AnimDelay = CurTime() + self.Stand:SequenceDuration()
	end
end

function SWEP:Think()
	self.Stand = self:GetStand()
	if !self.Stand:IsValid() then
		self:DefineStand()
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
	self.BlockSet = self.BlockSet or false
	if SERVER and self.Owner:gStandsKeyDown("block") then
		self:SetHoldType("pistol")
		if not self.BlockSet then
			self.Stand:ResetSequence(self.Stand:LookupSequence("standblock"))
			self.Stand:SetCycle(0)
			self.Stand:SetPlaybackRate(1)
			timer.Simple(0, function()
				if IsValid(self) and IsValid(self.Stand) then
					self.Stand:EmitStandSound(robo1)
				end
			end)
			timer.Simple(0.2, function()
				if IsValid(self) and IsValid(self.Stand) then
					self.Stand:EmitStandSound(robo5)
				end
			end)
			self.BlockSet = true
		end
		elseif SERVER and self.BlockSet then
		self:SetHoldType("stando")
		self.Stand.HeadRotOffset = -75
		self.BlockSet = false
	end
	if SERVER and self.Stand:GetSequence() == self.Stand:LookupSequence("attack2_end_succeed") and IsValid(self.GrabTarget) then
		if self.Stand:GetCycle() < 0.5 then
		local dist = self.GrabTarget:WorldSpaceCenter() - self.GrabTarget:GetPos()
		self.GrabTarget:SetPos(self.Stand:GetAttachment(self.Stand:LookupAttachment("anim_attachment_rh")).Pos - dist)
		end
		if self.Stand:GetCycle() > 0.5 then
			if IsValid(self.GrabTarget:GetPhysicsObject()) and !self.GrabTarget:IsPlayer() then
				self.GrabTarget:GetPhysicsObject():SetVelocity((self.Owner:GetAimVector() * 2 + self.GrabTarget:GetUp()):GetNormalized() * 2000)
			elseif self.GrabTarget:IsStand() then
				self.GrabTarget.Owner:SetVelocity((self.Owner:GetAimVector() * 2 + self.GrabTarget:GetUp()):GetNormalized() * 2000)
			else
				self.GrabTarget:SetVelocity((self.Owner:GetAimVector() * 2 + self.GrabTarget:GetUp()):GetNormalized() * 2000)
			end
		self.GrabTarget = nil
		end
	end
	self.Delay = self.Delay or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("modeswap") and CurTime() > self.Delay then
		self.Delay = CurTime() + 1
		self:SetAMode( !self:GetAMode())
		if SERVER then
			if(self:GetAMode()) then 
				self.Owner:ChatPrint( "#gstands.jgm.benevolentm" )
				else
				self.Owner:ChatPrint( "#gstands.jgm.maliciousm" ) 
			end
		end
	end
	self:NextThink(CurTime())
	return true
end

function SWEP:PrimaryAttack()
	if SERVER then
		self:SetHoldType("pistol")
		self.Stand:ResetSequence(self.Stand:LookupSequence("attack"))
        self.Stand:SetCycle( 0 )
		self.Stand:EmitStandSound(robo1)
		timer.Simple(0.75, function() self:SetHoldType("stando") self.Block = false end)
		timer.Simple(0.15, function() self:DonutPunch() self.Stand:EmitStandSound(robo2) end)
		timer.Simple(0.17, function() self:DonutPunch() end)
		timer.Simple(0.25, function() self:DonutPunch() end)
		self:SetNextPrimaryFire(CurTime() + 2)
		
	end
end


function SWEP:SecondaryAttack()
	if SERVER then
		self:SetHoldType("pistol")
		self.Stand:ResetSequence(self.Stand:LookupSequence("attack2_start"))
        self.Stand:SetCycle( 0 )
		self.Stand:EmitStandSound(robo4)
		timer.Simple(self.Stand:SequenceDuration(), function() if IsValid(self.Stand) then self:CheckGrab() timer.Simple(self.Stand:SequenceDuration(), function() if IsValid(self.Stand) then self:SetHoldType("stando") end end) end end)
		self:SetNextSecondaryFire(CurTime() + 2)
	end
end

function SWEP:DonutPunch()
    
    if SERVER then
    --Most of this is from the default fists swep, sped up and adapted to fit high speed stand rushes.
    self.Owner:LagCompensation( true )
    local tr = util.TraceHull( {
            start = self.Stand:GetBonePosition(self.Stand:LookupBone("ValveBiped.Bip01_L_Hand")),
            endpos = self.Stand:GetBonePosition(self.Stand:LookupBone("ValveBiped.Bip01_L_Hand")) + self.Owner:GetAimVector() * self.HitDistance,
            filter = {self.Owner, self.Stand },
            mins = Vector( -25, -25, -25 ), 
            maxs = Vector( 25, 25, 25 ),
            mask = MASK_SHOT_HULL, 
           
        } )
    -- We need the second part for single player because SWEP:Think is ran shared in SP
    if SERVER and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue("explosion", "2") tr.Entity:SetKeyValue("gibdir", tostring(self.Stand:GetAngles())) tr.Entity:Fire("Break") end

    local hit = false
    if SERVER && IsValid( tr.Entity ) then
        local dmginfo = DamageInfo()

        local attacker = self.Owner
        if ( !IsValid( attacker ) ) then attacker = self.Owner end
        dmginfo:SetAttacker( attacker )
        dmginfo:SetInflictor( self )
        dmginfo:SetDamage( 25  * self.Power )
        dmginfo:SetReportedPosition( self.Stand:GetEyePos() )
        tr.Entity:TakeDamageInfo( dmginfo )
		tr.Entity:SetVelocity((self.Owner:GetAimVector() + tr.Entity:GetUp()):GetNormalized() * 400)
        hit = true
		self.Stand:EmitSound( GetStandImpactSfx(tr.MatType) )
    end
    
    if tr.Entity:IsPlayer() then
        tr.Entity:ViewPunch( Angle( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) ) )
    end
    
    self.Owner:LagCompensation( false )
    
end
end
function SWEP:CheckGrab()
    
    if SERVER then
		self.Owner:LagCompensation( true )
		local tr = util.TraceHull( {
				start = self.Stand:WorldSpaceCenter() + self.Owner:GetAimVector() * 100,
				endpos = self.Stand:WorldSpaceCenter(),
				filter = {self.Owner, self.Stand },
				mins = Vector( -100, -100, -100 ), 
				maxs = Vector( 100,100, 100 ),
				mask = MASK_SHOT_HULL, 
				ignoreworld = true
			} )
		local hit = false
		
		if SERVER && IsValid( tr.Entity ) then
			local cmins, cmaxs = tr.Entity:GetCollisionBounds()
			local cminsl = cmins:Length()
			local cmaxsl = cmaxs:Length()
			local size = cminsl + cmaxsl
			if size <= 100 then
				self.Stand:ResetSequence("attack2_end_succeed")
				self.GrabTarget = tr.Entity
				self.Stand:EmitStandSound(robo3)
				self.Stand:EmitStandSound(laugh)
			else
				self.Stand:ResetSequence("attack2_end_fail")
			end
			elseif SERVER then
			self.Stand:ResetSequence("attack2_end_fail")
		
		end
		
		
		self.Owner:LagCompensation( false )
	end
end

function SWEP:Reload()
end
function SWEP:OnDrop()
    if SERVER and self.Stand:IsValid() then
        self.Stand:Remove()
    end
    return true
end
function SWEP:OnRemove()
	if SERVER and self.Owner and self.Owner:IsValid() and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	return true
end
function SWEP:Holster()
	if SERVER and self.Owner and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	return true
end