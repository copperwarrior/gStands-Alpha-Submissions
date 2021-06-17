--Send file to clients
if SERVER then
   AddCSLuaFile( "shared.lua" )
end
if CLIENT then
   SWEP.Slot      = 1
end

SWEP.Power = 1
SWEP.Speed = 2.75
SWEP.Range = E
SWEP.Durability = 1500
SWEP.Precision = nil
SWEP.DevPos = nil

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.khnum.purpose"
SWEP.Instructions  = "#gstands.khnum.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.khnum"

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

local PrevHealth = nil

--Define swing and hit sounds. Might change these later.
local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )

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
--Deploy starts up the stand
function SWEP:Deploy()
    self:SetHoldType( "normal" )

    --As is standard with stand addons, set health to 1000
    if self.Owner:Health() == 100  then
        self.Owner:SetMaxHealth( self.Durability )
        self.Owner:SetHealth( self.Durability )
	end
        
    --Create some networked variables, solves some issues where multiple people had the same stand
    self.Owner:SetCanZoom(false)
end

function SWEP:Think()
    
	local curtime = CurTime()
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
	self.Delay = self.Delay or CurTime()
		if self.Owner:gStandsKeyDown("modeswap") and CurTime() > self.Delay then
			self.Delay = CurTime() + 1
		if SERVER and IsFirstTimePredicted() then
			--self.Owner:SetModel()
			self.Owner:SetModel(table.ClearKeys(player_manager.AllValidModels())[math.random(1,#table.ClearKeys(player_manager.AllValidModels()))])
			self.Owner:SetModelScale(1)
		end
    end
end
    
   
function SWEP:PrimaryAttack()
            local tr = util.TraceLine( {
                start = self.Owner:EyePos(),
                endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * self.HitDistance * 5000,
                filter = self.Owner ,
                mask = MASK_SHOT_HULL,
                ignoreworld = true,
                collisiongroup = COLLISION_GROUP_PROJECTILE
            } )
        --Punch mode
        if !self.Owner:gStandsKeyDown("modifierkey2") then
        if SERVER and tr.Entity:IsValid() and (tr.Entity:IsNPC() or tr.Entity:IsPlayer()) and IsFirstTimePredicted() then
        self.Owner:SetModel(tr.Entity:GetModel())
        self:SetHoldType(tr.Entity:GetActiveWeapon():GetHoldType())
        self.Owner:SetModelScale(tr.Entity:GetModelScale())
        end
        --Set time until power punch.
        self:SetNextSecondaryFire( CurTime() + (0.1 * self.Speed) )
    else
        local lastHoldType = self:GetHoldType()
        self:SetHoldType("grenade")
        if SERVER then
        timer.Simple(0.05, function() self.Owner:SetAnimation( PLAYER_ATTACK1 ) end)
        timer.Simple(0.1, function()
        local bomb = ents.Create("khnum_orange")
        bomb:SetPos(self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")))
        bomb:SetOwner(self.Owner)
        bomb:Spawn()
        bomb:Activate()
        bomb:SetVelocity(self.Owner:GetAimVector() * 5 + Vector(0,0,10))
        end)
        end
        timer.Simple(1, function() self:SetHoldType(lastHoldType) end)
    end
    self:SetNextPrimaryFire( CurTime() + (1 * self.Speed) )
end

function SWEP:SecondaryAttack()
    --Punch mode
        if SERVER and IsFirstTimePredicted() then
        self.Owner:SetModel(player_manager.TranslatePlayerModel(self.Owner:GetInfo("cl_playermodel")))
        self.Owner:SetModelScale(1)
        end
    --No spamming the donut punch.
	self:SetNextPrimaryFire( CurTime() + (0.1 * self.Speed) )
	self:SetNextSecondaryFire( CurTime() + 3 )
end

function SWEP:Reload()
	
end

--Screw this entire section, it only works like 20% of the time. Basically, meant to catch every time the weapon is not in your hands in order to remove the stand.
function SWEP:OnDrop()
    return true
end

function SWEP:OnRemove()
    return true
end

function SWEP:Holster()
    return true
end