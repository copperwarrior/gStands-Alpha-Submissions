--Send file to clients
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot      = 1
end

SWEP.DevPos = D 
SWEP.Power = 2 
SWEP.Speed = E 
SWEP.Range = 1500 
SWEP.Durability = 1500 
SWEP.Precision = D 

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.empress.purpose"
SWEP.Instructions  = "#gstands.empress.instructions"
SWEP.Spawnable     = true
SWEP.AdminSpawnable= false
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.empress"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos            = 2
SWEP.DrawCrosshair      = true

SWEP.WorldModel = ""
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
local Deploy = Sound( "weapons/empress/deploy.wav" )

function SWEP:Initialize()
    --Set the third person hold type to fists
    self:SetHoldType( "normal" )
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
    if GetConVar("gstands_draw_hud"):GetBool() then
		local color = Color(150,75,0)
        local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
       
		surface.SetMaterial(generic_rect)
		surface.DrawTexturedRect(width - (256 * mult) - 30 * mult, height - (128 * mult) - 30 * mult, 256 * mult, 128 * mult)
		
		local name = "No target!"
		if self:GetTarget():IsValid() then
			name = self:GetTarget():GetClass()
		end
		if self:GetTarget():IsValid() and self:GetTarget():IsPlayer() then
			name = self:GetTarget():GetName()
		end
		draw.TextShadow({
			text = name,
			font = "gStandsFont",
			pos = {width - 160 * mult, height - 120 * mult},
			color = tcolor,
			xalign = TEXT_ALIGN_CENTER
		}, 2 * mult, 250)
    end
end
hook.Add( "HUDShouldDraw", "EmpressHud", function(elem)
    if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_empress" and (((elem == "CHudWeaponSelection" ) and LocalPlayer().SPInZoom) or elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
        return false
    end
end)

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
if not self.gStands_IsThirdPerson or ply:GetViewEntity() ~= ply then return end	if IsValid(self:GetStand()) and self.GetInDoDoDo and self:GetInDoDoDo() then
		pos = self:GetStand():GetBonePosition(self:GetStand():LookupBone("spine4.001")) + LocalPlayer():GetAimVector() * 55
	end
	local convar = thirdperson_offset:GetString()
	local strtab = string.Split(convar, ",")
	local offset = Vector(strtab[1], strtab[2], strtab[3])
	offset:Rotate(ang)

	local trace = util.TraceHull( {
		start = pos,
		endpos = pos - ang:Forward() * 100,
		filter = { ply:GetActiveWeapon(), ply, ply:GetVehicle(), self:GetTarget()},
		mins = Vector( -4, -4, -4 ),
		maxs = Vector( 4, 4, 4 ),
	} )

	if ( trace.Hit ) then pos = trace.HitPos else pos = trace.HitPos end
	return pos + offset,ang
end

function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Target")
	self:NetworkVar("Entity", 1, "Stand")
	self:NetworkVar("Float", 2, "PrevHealth")
	self:NetworkVar("Bool", 3, "InDoDoDo")
end
hook.Add("PlayerSay", "EmpressSpeak", function(sender, text, teamChat)
	if !teamChat and IsValid(sender) and sender.GetActiveWeapon and IsValid(sender:GetActiveWeapon()) and sender:GetActiveWeapon():GetClass() == "gstands_empress" and IsValid(sender:GetActiveWeapon():GetStand()) and sender:GetActiveWeapon():GetTarget():IsPlayer() then
		sender:GetActiveWeapon():GetTarget():Say(text, false)
		return ""
	end
end)
--Deploy starts up the stand
function SWEP:Deploy()
	
    --As is standard with stand addons, set health to 1000
    if self.Owner:Health() == 100  then
        self.Owner:SetMaxHealth( self.Durability )
        self.Owner:SetHealth( self.Durability )
	end
	
    self.Owner:SetCanZoom(false)
end

--Creates stand and adds attributes to the stand.
function SWEP:DefineStand(target)
    if SERVER then
        self:SetStand( ents.Create("empress_stand"))
		self.Stand = self:GetStand()
        self.Stand:SetOwner(self.Owner)
        self.Stand:SetMoveType( MOVETYPE_NOCLIP )
        self.Stand:DrawShadow(false)
		self.Stand:SetTarget(target)
        self.Stand:Spawn()
        self.Stand.Range = self.Range
        self.Stand.Speed = self.Speed
		self.Stand:SetModelScale(0)
		self.Owner:ChatPrintFormatted("#gstands.empress.target", target:Name())
	end    
end

function SWEP:Think()
    if self:GetInDoDoDo() then
		if CurTime() > self.Owner:GetNWFloat("DelayMenacing_"..self.Owner:GetName()) then
			self.Owner:SetNWFloat("DelayMenacing_"..self.Owner:GetName(), CurTime() + 0.5)
			local effectdata = EffectData()
			effectdata:SetStart(self.Owner:GetPos())
			effectdata:SetOrigin(self.Owner:GetPos())
			effectdata:SetEntity(self.Owner)
			util.Effect("menacing", effectdata)
		end
	end
	self.MenacingDelay = self.MenacingDelay or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("dododo") then
		--Mode changing
		if CurTime() > self.MenacingDelay then
			self.MenacingDelay = CurTime() + 1
			self:SetInDoDoDo(!self:GetInDoDoDo())
		end
	end
    if self.Owner:Health() < self:GetPrevHealth() and IsValid(self:GetClosest(self.Owner)) and SERVER then
		local targ = self:GetClosest(self.Owner)
		
		if targ != self:GetTarget() then
			if SERVER and IsValid(self:GetStand()) then
				self:GetStand():Remove()
			end
			self:SetTarget(targ)
			self:DefineStand(targ)
			local fxdata = EffectData()
			fxdata:SetOrigin(self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_Head1")))
			fxdata:SetEntity(self.Owner)
			util.Effect("BloodImpact", fxdata, true, true)
		end
	end
	if SERVER and IsValid(self:GetTarget()) and (self:GetTarget():Health() < 1 or (self:GetTarget():IsPlayer() and !self:GetTarget():Alive())) then
		self:SetTarget(NULL)
		if IsValid(self:GetStand()) then
			self:GetStand():Remove()
		end
	end
	if IsValid(self:GetStand()) and self:GetStand():GetReady() then
		if IsValid(self:GetStand()) and self.Owner:KeyDown(IN_ATTACK) then
			self:GetStand():ResetSequence(2)
		end
		if IsValid(self:GetStand()) and (self.Owner:KeyReleased(IN_ATTACK)) then
			self:GetStand():SetCycle(0)
			self:GetStand():ResetSequenceInfo()
			self:GetStand():SetSequence(1)
		end
		if SERVER and IsValid(self:GetStand()) and self.Owner:KeyPressed(IN_ATTACK2) then
			
		end
	end
	self:SetPrevHealth(self.Owner:Health())
	self:NextThink(CurTime())
	return true
end

function SWEP:GetClosest(ply)
	local closestply
	local closestdist
    local possibleTargets = player.GetAll()
    for k, v in pairs( ents.GetAll( ) ) do
		
        if( v:IsNPC( ) ) then
            possibleTargets[k + #possibleTargets] = v
		end
	end
	for k, v in pairs(possibleTargets) do
		if v != ply and v:GetPos():Distance(ply:GetPos()) <= 100 then
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

function SWEP:PrimaryAttack()
	
	if SERVER and IsValid(self:GetTarget()) and IsValid(self:GetStand()) and self:GetStand():GetReady() then
        --Swingy swingy
        self:GetStand():EmitStandSound( SwingSound )
		local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )
		
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 15 )
		self:GetTarget():EmitSound( "physics/flesh/flesh_impact_bullet"..math.random(1,5)..".wav" )
        self:GetTarget():SetVelocity(-self:GetTarget():GetAimVector())
		self:GetTarget():TakeDamageInfo( dmginfo )
	end
	--Miniscule delay
	self:SetNextPrimaryFire( CurTime() + (0.1) )
end


function SWEP:SecondaryAttack()
    --Punch mode
	
    if SERVER and IsValid(self:GetTarget()) and IsValid(self:GetStand()) and self:GetStand():GetReady() then
		--Swingy swingy
		self:GetStand():SetCycle(0)
		self:GetStand():ResetSequenceInfo()
		self:GetStand():SetSequence(3)
		timer.Simple(1, function() self:GetStand():SetCycle(0)
		self:GetStand():ResetSequenceInfo() self:GetStand():SetSequence(1) end)
        self:GetStand():EmitStandSound( SwingSound )
		local dmginfo = DamageInfo()
		self:GetTarget():EmitSound( "physics/flesh/flesh_impact_bullet"..math.random(1,5)..".wav" )
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )
		
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 55 )
		self:GetTarget():SetVelocity(-self:GetTarget():GetAimVector() * 555)
		
		self:GetTarget():TakeDamageInfo( dmginfo )
	end
    --No spamming the donut punch.
	self:SetNextSecondaryFire( CurTime() + (2) )
	
end

function SWEP:Reload()
	
end

--Screw this entire section, it only works like 20% of the time. Basically, meant to catch every time the weapon is not in your hands in order to remove the stand.
function SWEP:OnDrop()
	if SERVER and IsValid(self:GetStand()) then
		self:GetStand():Remove()
		self:SetTarget(NULL)
	end
    return true
end

function SWEP:OnRemove()
	if SERVER and IsValid(self:GetStand()) then
		self:GetStand():Remove()
		self:SetTarget(NULL)
	end
    return true
end

function SWEP:Holster()
	if SERVER and IsValid(self:GetStand()) then
		self:GetStand():Remove()
		self:SetTarget(NULL)
	end
    return true
end