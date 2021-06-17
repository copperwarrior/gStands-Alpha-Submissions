--Send file to clients
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot	  = 1
end

SWEP.Power = 1
SWEP.Range = 1500
SWEP.Speed = 1
SWEP.Durability = 1000
SWEP.Precision = nil
SWEP.DevPos = nil

SWEP.Author		= "Copper"
SWEP.Purpose	   = "#gstands.ed.purpose"
SWEP.Instructions  = "#gstands.ed.instructions"
SWEP.Spawnable	 = true
SWEP.Base		  = "weapon_fists"   
SWEP.Category	  = "gStands"
SWEP.PrintName	 = "#gstands.names.ed"

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

SWEP.DrawAmmo = false
SWEP.HitDistance = 100
SWEP.gStands_IsThirdPerson = true

local PrevHealth = nil

--Define swing and hit sounds. Might change these later.
local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )
local Deploy = Sound("weapons/ebonydevil/deploy.wav")
local Kekeke = Sound("weapons/ebonydevil/kekeke.wav")
local Screech = Sound("weapons/ebonydevil/screech.wav")
local StabCharge = Sound("weapons/ebonydevil/stabcharge_01.wav")
local Swing = Sound("ed.swing")
local Stab = Sound("ed.stab")
local Grudge = Sound("weapons/ebonydevil/grudge.wav")
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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("zombie_idle_01"))
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
function SWEP:Initialize()
	--Set the third person hold type to fists
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
		local color = Color(255,255,255,255)
		local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
		surface.SetMaterial(generic_rect)
		surface.DrawTexturedRect(width - (256 * mult) - 30 * mult, height - (128 * mult) - 30 * mult, 256 * mult, 128 * mult)
		
		draw.TextShadow({
			text = IsValid(self.Stand) and "#gstands.ed.bound" or "#gstands.ed.nbound",
			font = "gStandsFont",
			pos = {width - 160 * mult, height - 120 * mult},
			color = tcolor,
			xalign = TEXT_ALIGN_CENTER
		}, 2 * mult, 250)
		
	end
end
hook.Add( "HUDShouldDraw", "EbonyDevilHud", function(elem)
	if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_ebonydevil" and (((elem == "CHudWeaponSelection" ) and LocalPlayer().SPInZoom) or elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
		return false
	end
end)
local EdPclMat = Material("effects/ed_glimpse")

function SWEP:DrawWorldModel()
	if IsValid(self.Owner) then
		if IsPlayerStandUser(LocalPlayer()) and self.pcllife and CurTime() <= self.pcllife then
			render.SetMaterial(EdPclMat)
			render.DrawQuadEasy(self.Owner:EyePos() + (EyeAngles():Up() * 25) + (EyeAngles():Up() * 25) * ((CurTime() - self.pcllife)), -EyeAngles():Forward(), 55, 55, Color(255,255,255,(self.pcllife - CurTime()) * 255), 180)
		end
		else
		self:DrawModel()
	end
end

local thirdperson_offset = GetConVar("gstands_thirdperson_offset")
function SWEP:CalcView( ply, pos, ang )
if not self.gStands_IsThirdPerson or ply:GetViewEntity() ~= ply then return end	if self:GetInDoDoDo() and self:GetStand().GetProp and self:GetStand():GetProp():IsValid() then
		pos = self:GetStand():GetProp():WorldSpaceCenter()
	end
	local stand = NULL
	if self.GetStand then
		stand = self:GetStand()
	end
	local prop = NULL
	if self.GetStand and self:GetStand().GetProp then
		prop = self:GetStand():GetProp()
	end
	local convar = thirdperson_offset:GetString()
	local strtab = string.Split(convar, ",")
	local offset = Vector(strtab[1], strtab[2], strtab[3])
	offset:Rotate(ang)

	local trace = util.TraceHull( {
		start = pos,
		endpos = pos - ang:Forward() * 100,
		filter = { ply:GetActiveWeapon(), ply, ply:GetVehicle(), stand, prop },
		mins = Vector( -4, -4, -4 ),
		maxs = Vector( 4, 4, 4 ),
	} )

	if ( trace.Hit ) then pos = trace.HitPos else pos = trace.HitPos end
	return pos + offset,ang
end

function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Stand")
	self:NetworkVar("Bool", 1, "InDoDoDo")
end
--Deploy starts up the stand
function SWEP:Deploy()
	self:SetStand(NULL)
	self.Stand = self:GetStand()
	self:SetHoldType( "stando" )
	
	--As is standard with stand addons, set health to 1000
	if self.Owner:Health() == 100  then
		self.Owner:SetMaxHealth( self.Durability )
		self.Owner:SetHealth( self.Durability )
	end
	--Create some networked variables, solves some issues where multiple people had the same stand
	self.Owner:SetCanZoom(false)
	self.EnemyDamages = {}
	if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitSound(Deploy)
			timer.Simple(1, function() 
				if IsValid(self.Owner) then
					self.Owner:EmitStandSound(Screech)
				end
			end)
		end
	end
	timer.Simple(1, function() 
		if IsValid(self.Owner) then
			self.pcllife = CurTime() + 1
		end
	end)

	hook.Add("EntityTakeDamage", "EbonyDevilGrudge"..self.Owner:GetName(), function(ent, dmg)
		if self:IsValid() and self.Owner:IsValid() and ent == self.Owner and dmg:GetAttacker():IsPlayer() then
			self.EnemyDamages[dmg:GetAttacker():EntIndex()] = (self.EnemyDamages[dmg:GetAttacker():EntIndex()] or 0) + dmg:GetDamage()
		end
		if self:IsValid() and self.Owner:IsValid() and self.Stand and self.Stand.GetProp and self.Stand:GetProp():IsValid() and ent == self.Stand:GetProp() and dmg:GetDamageType() != DMG_CRUSH then
			self.Owner:TakeDamageInfo(dmg)
		end
		if self:IsValid() and self.Owner:IsValid() and ent == self.lastHit and self.EnemyDamages[ent:EntIndex()] and dmg:GetAttacker() == self.Owner and IsValid(self.Stand) and dmg:GetDamage() >= ent:Health() then
			timer.Simple(1, function() if IsValid(self) and IsValid(self.Stand) then 
				self.Stand:EmitSound(Grudge)
				self.EnemyDamages[ent:EntIndex()] = 0
				end
			end)
		end
	end)
end

function SWEP:Think()
	self.Stand = self:GetStand()
	if self:GetInDoDoDo() then
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
	self.MenacingDelay = self.MenacingDelay or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("dododo") then
		--Mode changing
		if CurTime() > self.MenacingDelay then
			self.MenacingDelay = CurTime() + 1
			self:SetInDoDoDo(!self:GetInDoDoDo())
		end
	end
	if SERVER and self.Owner.IsKnockedOut and self.Stand:IsValid() then
		self.Stand:Remove()
		self.Stand:GetProp():Remove()
	end
	--Mode changing
	if self.Owner:gStandsKeyDown("modeswap") and CurTime() > self.Owner:GetNWFloat("Delay_"..self.Owner:GetName()) then
		self.Owner:SetNWFloat("Delay_"..self.Owner:GetName(), CurTime() + 1)
		local tr = util.TraceLine( {
			start = self.Owner:EyePos(),
			endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 100,
			filter = self.Owner
		} )
		self.pcllife = 0
		if SERVER and tr.Entity:IsValid() and tr.Entity:GetPhysicsObject():IsValid() and (tr.Entity:GetClass() == "prop_physics" or tr.Entity:GetClass() == "prop_ragdoll")then
			if self.Stand:IsValid() then self.Stand:Remove() end
			self:SetStand(ents.Create("bounddevilprop"))
			self.Stand = self:GetStand()
			self.Stand:SetOwner(self.Owner)
			self.Stand:SetModel(tr.Entity:GetModel())
			self.Stand:SetAngles(tr.Entity:GetAngles())
			self.Stand:SetPos(tr.Entity:GetPos())
			self.Stand.Type = tr.Entity:GetClass()
			self.Stand:Spawn()
			self.Owner:EmitStandSound(Screech)
			tr.Entity:Remove()
		end
	end
end


function SWEP:PrimaryAttack()
	if self.Stand.GetProp and self.Stand:GetProp():IsValid() then
		self:DonutPunch()
	end
	self:SetNextPrimaryFire(CurTime() + 0.5)
end

function SWEP:GetMomentumMult()
	local ret = self.Stand:GetProp():GetVelocity():Length() + 1
	ret = ret * 0.05
	ret = math.Clamp(ret, 1, 35)
	if ret == 35 then
		self.Stand:EmitSound(Kekeke)
	end
	return ret
end

function SWEP:GetMins()
	local ret = self.Stand:OBBMins() * 4
	return ret
end

function SWEP:GetMaxs()
	local ret = self.Stand:OBBMaxs() * 4
	return ret
end

function SWEP:DonutPunch()
	if !self.Owner.IsKnockedOut then
		local anim = self.Owner:GetSequenceName(self.Owner:GetSequence())
		
		self.Owner:LagCompensation( true )
		local tr
		if self.Stand:GetProp():LookupBone("ValveBiped.Bip01_Head1") then
			tr = util.TraceHull( {
				start = self.Stand:GetProp():GetBonePosition(self.Stand:GetProp():LookupBone("ValveBiped.Bip01_Head1")),
				endpos = self.Stand:GetProp():GetBonePosition(self.Stand:GetProp():LookupBone("ValveBiped.Bip01_Head1")) + self.Owner:GetAimVector() * self.HitDistance,
				filter = { self.Owner, self.Stand, self.Stand:GetProp() },
				mins = self:GetMins(), 
				maxs = self:GetMaxs(),
				ignoreworld = true,
				mask = MASK_SHOT_HULL
				
			} )
			else
			tr = util.TraceHull( {
				start = self.Stand:WorldSpaceCenter(),
				endpos = self.Stand:WorldSpaceCenter() + self.Owner:GetAimVector() * self.HitDistance,
				filter = { self.Owner, self.Stand, self.Stand:GetProp() },
				mins = self:GetMins(), 
				maxs = self:GetMaxs(),
				ignoreworld = true,
				mask = MASK_SHOT_HULL
				
			} )
		end
		-- We need the second part for single player because SWEP:Think is ran shared in SP
		if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		end
		if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0) ) then
			self.Stand:EmitSound( "physics/flesh/flesh_impact_bullet"..math.random(1,5)..".wav" )
			local dmginfo = DamageInfo()
			dmginfo:SetDamageForce(self.Stand:GetAngles():Forward())
			
			local attacker = self.Owner
			dmginfo:SetAttacker( attacker )
			
			dmginfo:SetInflictor( self )
			--High damage, but not quite enough to kill.
			if self.EnemyDamages and self.EnemyDamages[tr.Entity:EntIndex()] and self.EnemyDamages[tr.Entity:EntIndex()] >= 0 then
				dmginfo:SetDamage( (self.EnemyDamages[tr.Entity:EntIndex()] / 1.5) * self:GetMomentumMult())
				else
				dmginfo:SetDamage( 2 * self.Power * self:GetMomentumMult() )
			end
			self.Stand:DoSlashAttack(tr.Entity)
			self.Stand:EmitSound(Swing)
			self.Stand:EmitSound(Stab)
			tr.Entity:TakeDamageInfo( dmginfo )
			self.lastHit = tr.Entity
		end
		if tr.Hit and !((tr.Entity:IsPlayer() or tr.Entity:IsNPC())) then
			self.Stand:EmitSound( GetStandImpactSfx(tr.MatType) )
		end
		
		--Target's view gets knocked around. I thought it was a cool effect.
		if tr.Entity:IsPlayer() then
			tr.Entity:ViewPunch( Angle( math.random( -3, 3 ), math.random( -3, 3 ), math.random( -3, 3 ) ) )
		end
		
		
		self.Owner:LagCompensation( false )
		
	end
end

function SWEP:GetClosest(ply)
	local closestply
	local closestdist
	for k, v in pairs(player.GetAll()) do
		if v != self.Owner and v:GetPos():Distance(ply:GetPos()) <= 550 then
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

function SWEP:Charge(target)
	if !self.Owner.IsKnockedOut then
		if self:GetClosest(self.Stand:GetProp()) != nil and self:GetClosest(self.Stand:GetProp()):IsValid() then
			target = self:GetClosest(self.Stand:GetProp())
			elseif !self:GetInDoDoDo() and self.Owner:GetEyeTrace().Entity:IsValid() and self.Owner:GetEyeTrace().Entity:WorldSpaceCenter():Distance(self.Stand:GetProp():WorldSpaceCenter()) <= 1000 then
			target = self.Owner:GetEyeTrace().Entity
		end
		self.Stand:DoDashAttack(target)
		if target and target:IsValid() and self.Stand:GetProp():GetPhysicsObject():IsValid() then
		self.SoundTimer = self.SoundTimer or CurTime()
		if SERVER and CurTime() >= self.SoundTimer then
			self.Stand:EmitStandSound(StabCharge)
			self.SoundTimer = CurTime() + SoundDuration(StabCharge)			
		end
			self.Stand:GetProp():GetPhysicsObject():ApplyForceCenter((
				target:WorldSpaceCenter()
			- self.Stand:GetProp():WorldSpaceCenter()) * 75)
			self.Stand:GetProp():GetPhysicsObject():AddAngleVelocity(self.Stand:GetProp():GetRight() * 15)
			timer.Create("Charge"..self:EntIndex(), 0.1, 5, function()
				local tr
				if self.Stand and self.Stand:GetProp():LookupBone("ValveBiped.Bip01_Head1") then
					tr = util.TraceHull( {
						start = self.Stand:GetProp():GetBonePosition(self.Stand:GetProp():LookupBone("ValveBiped.Bip01_Head1")),
						endpos = self.Stand:GetProp():GetBonePosition(self.Stand:GetProp():LookupBone("ValveBiped.Bip01_Head1")) + self.Owner:GetAimVector() * self.HitDistance,
						filter = { self.Owner, self.Stand, self.Stand:GetProp() },
						mins = Vector( -25, -25, -25 ), 
						maxs = Vector( 25, 25, 25 ),
						ignoreworld = true,
						mask = MASK_SHOT_HULL
						
					} )
					else
					tr = util.TraceHull( {
						start = self.Stand:WorldSpaceCenter(),
						endpos = self.Stand:WorldSpaceCenter() + self.Owner:GetAimVector() * self.HitDistance,
						filter = { self.Owner, self.Stand, self.Stand:GetProp() },
						mins = Vector( -25, -25, -25 ), 
						maxs = Vector( 25, 25, 25 ),
						ignoreworld = true,
						mask = MASK_SHOT_HULL
						
					} )
				end
				-- We need the second part for single player because SWEP:Think is ran shared in SP
				if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
				end
				if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0) ) then
					self.Stand:EmitSound( "physics/flesh/flesh_impact_bullet"..math.random(1,5)..".wav" )
					local dmginfo = DamageInfo()
					dmginfo:SetDamageForce(self.Stand:GetAngles():Forward())
					
					local attacker = self.Owner
					dmginfo:SetAttacker( attacker )
					
					dmginfo:SetInflictor( self )
					--High damage, but not quite enough to kill.
					if self.EnemyDamages and self.EnemyDamages[tr.Entity:EntIndex()] and self.EnemyDamages[tr.Entity:EntIndex()] >= 0 then
						dmginfo:SetDamage( self.EnemyDamages[tr.Entity:EntIndex()] / 4)
						else
						dmginfo:SetDamage( 2 * self.Power )
					end
					print(self.EnemyDamages[tr.Entity:EntIndex()])
					tr.Entity:TakeDamageInfo( dmginfo )
					self.lastHit = tr.Entity

				end
				if tr.Hit and !((tr.Entity:IsPlayer() or tr.Entity:IsNPC())) then
					self.Stand:EmitSound( GetStandImpactSfx(tr.MatType) )
				end
				
				--Target's view gets knocked around. I thought it was a cool effect.
				if tr.Entity:IsPlayer() then
					tr.Entity:ViewPunch( Angle( math.random( -3, 3 ), math.random( -3, 3 ), math.random( -3, 3 ) ) )
				end
				
			end)
		end
	end
end


function SWEP:SecondaryAttack()
	if self.Stand and self.Stand:IsValid() and self.Stand:GetProp():IsValid() then
		self:Charge()
	end
	self:SetNextSecondaryFire(CurTime() + 0.5)
end

function SWEP:Reload()
	
end

--Screw this entire section, it only works like 20% of the time. Basically, meant to catch every time the weapon is not in your hands in order to remove the stand.
function SWEP:OnDrop()
	if SERVER and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	
	return true
end

function SWEP:OnRemove()
	if SERVER and self.Stand and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	
	return true
end

function SWEP:Holster()
	if SERVER and self.Stand and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	
	return true
end