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

SWEP.Author        = "Zaygh, Copper"
SWEP.Purpose       = "#gstands.tsax.purpose"
SWEP.Instructions  = "#gstands.tsax.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.tsax"

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
SWEP.Illusions = {}
SWEP.gStands_IsThirdPerson = true

game.AddParticles("particles/tenoresax.pcf")
PrecacheParticleSystem("tsbuff2")

--Define swing and hit sounds. Might change these later.
local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )
local Deploy = Sound( "ambient/wind/smallgust.wav" )
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
	self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_standing_01"))
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
function SWEP:Initialize()
    --Set the third person hold type to fists
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

    --As is standard with stand addons, set health to 1000
    if self.Owner:Health() == 100  then
        self.Owner:SetMaxHealth( self.Durability )
        self.Owner:SetHealth( self.Durability )
	end
    if SERVER and GetConVar("gstands_deploy_sounds"):GetBool() then
		self.Owner:EmitSound(Deploy)
	end
    --Create some networked variables, solves some issues where multiple people had the same stand
    self.Owner:SetCanZoom(false)
    
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
    if self.Illusions != nil then
    for k,v in pairs(self.Illusions) do

        if v:IsValid() and v:GetModel() == self.Owner:GetModel() then
            for i = 0, self.Owner:GetNumPoseParameters() - 1 do
                local sPose = self.Owner:GetPoseParameterName( i )
                v:SetPoseParameter( sPose, self.Owner:GetPoseParameter( sPose ) )
                v:SetSequence(self.Owner:GetSequence())
                end
            end
		end
    end
	self.Delay = self.Delay or CurTime()
    if self.Owner:gStandsKeyDown("modeswap") and self.Delay <= CurTime() then
    local tr = util.TraceLine( {
            start = self.Owner:EyePos(),
            endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 150,
            filter = self.Owner
            } )
	if IsValid(tr.Entity) and tr.Entity.GetModel then
    self.ActiveModel = tr.Entity:GetModel()
    end
    end
    self:NextThink(CurTime())
    return true
end

function SWEP:PrimaryAttack()
if SERVER then
	if self.Owner:gStandsKeyDown("modifierkey2") then
        local tr = util.TraceLine( {
        start = self.Owner:EyePos(),
        endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 74,
        filter = self.Owner
        } )
        if tr.Entity:IsValid() and tr.Entity:GetModel() != nil then
        self.ActiveModel = tr.Entity:GetModel()
        if tr.Entity:GetSequence() != nil then
        self.ActiveSequence = tr.Entity:GetSequence()
        self.ActiveCycle = tr.Entity:GetCycle()
        self.ActiveSkin = tr.Entity:GetSkin()
        end
        end
    
    elseif self.Owner:gStandsKeyDown("dododo") then
        if self.Owner:IsValid() and self.Owner:GetModel() != nil then
        self.ActiveModel = self.Owner:GetModel()
        if self.Owner:GetSequence() != nil then
        self.ActiveSequence = self.Owner:GetSequence()
        self.ActiveCycle = self.Owner:GetCycle()
        self.ActiveSkin = self.Owner:GetSkin()
        end
        end
	elseif !self.Owner.IsKnockedOut then
		self:SetNextPrimaryFire(CurTime() + 0.5)
		self:IllusionProp()
	end
end
end

function SWEP:SecondaryAttack()
self:SetNextSecondaryFire(CurTime() + 0.1)
if SERVER then
    for k,v in pairs(self.Illusions) do
        local randval = table.Random(self.Illusions)
        if v:IsValid() and randval:IsValid() then
            local temp = randval:GetPos()
            randval:SetPos(v:GetPos())
            v:SetPos(temp)
        end
        end
end
end

function SWEP:Reload()
    
end

function SWEP:IllusionProp()
	if SERVER then
		local tr = util.TraceLine( {
			start = self.Owner:EyePos(),
			endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 74,
			filter = self.Owner
			} )
		local illusion = ents.Create( "prop_physics" )
		illusion:SetOwner(self.Owner)
		illusion:SetModel( self.ActiveModel or "models/props_c17/oildrum001.mdl" )
        if tr.HitNormal != Vector(0,0,0) then
        illusion:SetAngles( tr.HitNormal:Angle() )
        else
		illusion:SetAngles( self.Owner:GetAimVector():Angle() )
        end
        		illusion:SetPos( tr.HitPos )
                if !tr.Hit then
        		illusion:SetPos( illusion:GetPos() - (illusion:WorldSpaceCenter() - tr.HitPos) )
                end
        if self.ActiveModel == self.Owner:GetModel() then
        illusion:SetPos(self.Owner:GetPos())
        illusion:SetAngles(self.Owner:EyeAngles())
        end
		illusion:Spawn()
		illusion:Activate()
        illusion:EmitSound("ambient/wind/wind_hit"..math.random(1,2)..".wav", 65, math.random(50,95))
		illusion:SetMoveType(MOVETYPE_NONE)
		if illusion:IsValid() then
		hook.Add("EntityTakeDamage", illusion:EntIndex()..self.Owner:GetName().."TenoreSaxBuff", function(ent, dmg)
				if illusion:IsValid() and ent:IsPlayer() and ent:WorldSpaceCenter():Distance(illusion:WorldSpaceCenter()) <= 125 and dmg:GetDamage() >= 1 then
					dmg:ScaleDamage(0.5)
				end
			end)
		end
		if IsValid(illusion) then
        local effectdata = EffectData()
			effectdata:SetOrigin(illusion:WorldSpaceCenter())
			effectdata:SetEntity(illusion)
			util.Effect("gstands_tenoresax", effectdata, true, true)    
		end
		illusion:CallOnRemove("RemoveBuffHook", function() hook.Remove("EntityTakeDamage", illusion:EntIndex()..self.Owner:GetName().."TenoreSaxBuff") end)
        if self.ActiveSequence and self.ActiveCycle then
        illusion:SetSequence(self.ActiveSequence)
        illusion:SetCycle(self.ActiveCycle)
        illusion:SetSkin(self.ActiveSkin)
        end
        for i = 0, self.Owner:GetNumPoseParameters() - 1 do
                local sPose = self.Owner:GetPoseParameterName( i )
                illusion:SetPoseParameter( sPose, self.Owner:GetPoseParameter( sPose ) )
                end
        if illusion:IsValid() then
            table.insert(self.Illusions, illusion)
        end
		cleanup.Add( self.Owner, "props", illusion )

		undo.Create( "Illusion Prop" )
			undo.AddEntity( illusion )
			undo.SetPlayer( self.Owner )
		undo.Finish()
	end
end
function SWEP:OnDrop()
    for k,v in pairs(self.Illusions) do
        if v:IsValid() then
            v:Remove()
        end
    end
    return true
end

function SWEP:OnRemove()
 for k,v in pairs(self.Illusions) do
        if v:IsValid() then
            v:Remove()
        end
    end

    return true
end

function SWEP:Holster()
    return true
end