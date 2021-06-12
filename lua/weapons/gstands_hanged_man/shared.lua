--Send file to clients
if SERVER then
AddCSLuaFile( "shared.lua" )
end
if CLIENT then
SWEP.Slot      = 1
end

SWEP.Power = 1.5
SWEP.Speed = 0.5
SWEP.Range = 1500
SWEP.Durability = 1000
SWEP.Precision = nil
SWEP.DevPos = nil

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.hdm.purpose"
SWEP.Instructions  = "#gstands.hdm.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.hdm"

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

local PrevHealth = nil
game.AddParticles( "particles/hangedman.pcf" )
PrecacheParticleSystem( "hangedman" )


SWEP.StandModel = "models/hdm/hdm.mdl"
SWEP.StandModelP = "models/hdm/hdm.mdl"
SWEP.gStands_IsThirdPerson = true

--Define swing and hit sounds. Might change these later.
local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "E3_Phystown.Slicer" )
local Pew = Sound( "hdm.pew" )
local Stab = Sound( "hdm.stab" )
local FlickOut = Sound( "weapons/hdm/stab/stab_01.wav" )
local PullOut = Sound( "weapons/hdm/stab/stab_03.wav" )
local Grab = Sound( "weapons/hdm/grab.wav" )
local Deploy = Sound( "weapons/hdm/deploy.wav" )
local BackstabInsults = Sound( "hdm.stabinsults" )
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
        local color = gStands.GetStandColorTable(self.Stand:GetModel(), self.Stand:GetSkin())
        local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
    end
end
hook.Add( "HUDShouldDraw", "HangedManHud", function(elem)
    if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_hanged_man" and (((elem == "CHudWeaponSelection" ) and LocalPlayer().SPInZoom) or elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
        return false
    end
end)
local material = Material( "vgui/hud/gstands_hud/crosshair" )
function SWEP:DoDrawCrosshair(x,y)
    if IsValid(self.Owner) and IsValid(LocalPlayer()) and self:GetState() == 2 then
        local tr = util.TraceLine( {
            start = self:GetStand():GetEyePos(),
            endpos = self:GetStand():GetEyePos() + self.Owner:GetAimVector() * 1500,
            filter = {self.Owner},
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
function SWEP:Initialize()
	--Set the third person hold type to fists
end

function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Stand")
	self:NetworkVar("Entity", 2, "Mirror")
	self:NetworkVar("Int", 1, "State")
end
function SWEP:DrawWorldModel()
	if IsValid(self.Owner) then
		return false
		else
		self:DrawModel()
	end
end
function math.ClampVector(vec, min, max)
		return Vector(math.Clamp(vec.x, min.x, max.x), math.Clamp(vec.y, min.y, max.y), math.Clamp(vec.z, min.z, max.z))
end
--Third Person View
local thirdperson_offset = GetConVar("gstands_thirdperson_offset")
function SWEP:CalcView( ply, pos, ang )
if not self.gStands_IsThirdPerson or ply:GetViewEntity() ~= ply then return end	if IsValid(self:GetStand()) and self:GetStand().GetInDoDoDo and self:GetStand():GetInDoDoDo() then
		pos = self:GetStand():GetEyePos() - LocalPlayer():GetAimVector() * 55
	end
	local targ 
	local stand 
	if IsValid(self:GetStand()) then
	targ = self:GetStand():GetBackstabTarget()
		if IsValid(targ) and IsValid(targ:GetActiveWeapon()) and targ:GetActiveWeapon().GetStand then
			stand = targ:GetActiveWeapon():GetStand()
		end
	end
	local trace = util.TraceHull( {
		start = pos,
		endpos = pos - ang:Forward() * 100,
		filter=function(ent) if ent:IsPlayer() or ent:IsNPC() then return false else return true end end,

		mins = Vector( -4, -4, -4 ),
		maxs = Vector( 4, 4, 4 ),
	} )
	local convar = thirdperson_offset:GetString()
	local strtab = string.Split(convar, ",")
	local offset = Vector(strtab[1], strtab[2], strtab[3])
	offset:Rotate(ang)

	local trace = util.TraceHull( {
		start = pos,
		endpos = pos - ang:Forward() * 100,
		filter = function(ent) if ent:IsPlayer() or ent:IsNPC() then return false else return true end end,
		mins = Vector( -4, -4, -4 ),
		maxs = Vector( 4, 4, 4 ),
	} )


	if ( trace.Hit ) then pos = trace.HitPos else pos = trace.HitPos end
	if self:GetState() == 1 and IsValid(self:GetMirror()) then
		pos = self:GetMirror():GetPos()
	end
	return pos + offset,ang
end
function SWEP:DefineStand()
    if SERVER then
        self:SetStand(ents.Create("hangedman"))
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
end
--Deploy starts up the stand
function SWEP:Deploy()
	self:SetHoldType( "stando" )

	--As is standard with stand addons, set health to 1000
	if self.Owner:Health() == 100  then
		self.Owner:SetMaxHealth( self.Durability )
		self.Owner:SetHealth( self.Durability )
	end
	if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitSound(Deploy)
		end
	end
	self.Owner:SetCanZoom(false)
	
	self.Stand = self:GetStand()
    if !self.Stand:IsValid() then
        self:DefineStand()
	end
end

function SWEP:Think()
	self.Stand = self:GetStand()
	if CLIENT and !self.Hooked then
		hook.Add("RenderScreenspaceEffects", "DrawHangedManMirrorColor", function()
			if IsValid(self) and self:GetState() != 0 and self.Owner:GetActiveWeapon() == self then
				DrawColorModify({
					[ "$pp_colour_addr" ] = 0.15,
					[ "$pp_colour_addg" ] = 0,
					[ "$pp_colour_addb" ] = 0.15,
					[ "$pp_colour_brightness" ] = -0.1,
					[ "$pp_colour_contrast" ] = 1,
					[ "$pp_colour_colour" ] = 0.6,
					[ "$pp_colour_mulr" ] = 0.02,
					[ "$pp_colour_mulg" ] = 0,
					[ "$pp_colour_mulb" ] = 0.02
				})
			end
		end)
		local oldclip
		
		hook.Add("SetupWorldFog", "DrawHangedManFog", function()
			if IsValid(self) and self:GetState() != 0 and self.Owner:GetActiveWeapon() == self then
				render.FogStart(1)
				render.FogEnd(3000)
				render.FogColor(15,0,15)
				render.FogMaxDensity(0.9)
				render.FogMode(MATERIAL_FOG_LINEAR)
				return true
			end
		end)
		hook.Add("SetupSkyboxFog", "DrawHangedManFog", function()
			if IsValid(self) and self:GetState() != 0 and self.Owner:GetActiveWeapon() == self then
				render.FogStart(0)
				render.FogEnd(1)
				render.FogColor(15,0,15)
				render.FogMaxDensity(1)
				render.FogMode(MATERIAL_FOG_LINEAR)
				return true
			end
		end)
		hook.Add("PostDrawTranslucentRenderables", "DrawHangedManSurfaceClip", function()
			if IsValid(self) and IsValid(self:GetMirror()) and self:GetState() != 0 and self.Owner:GetActiveWeapon() == self then
			render.SetColorMaterial()
			render.SetBlend(1)
			render.OverrideAlphaWriteEnable(true, false)
				render.DrawQuadEasy(self:GetMirror():GetPos() - self:GetMirror():GetUp() * 5, self:GetMirror():GetUp(), 50000,50000, Color(0,0,0,255), 0)
				
				render.DrawQuadEasy(Vector(0,0,0) - Vector(0,0,1) * 20000, Vector(0,0,1), 80000,80000, Color(0,0,0,255), 0)
				render.DrawQuadEasy(Vector(0,0,0) + Vector(0,0,1) * 20000, Vector(0,0,-1), 80000,80000, Color(0,0,0,255), 0)
				render.DrawQuadEasy(Vector(0,0,0) - Vector(0,1,0) * 20000, Vector(0,1,0), 80000,80000, Color(0,0,0,255), 0)
				render.DrawQuadEasy(Vector(0,0,0) + Vector(0,1,0) * 20000, Vector(0,-1,0), 80000,80000, Color(0,0,0,255), 0)
				render.DrawQuadEasy(Vector(0,0,0) - Vector(1,0,0) * 20000, Vector(1,0,0), 80000,80000, Color(0,0,0,255), 0)
				render.DrawQuadEasy(Vector(0,0,0) + Vector(1,0,0) * 20000, Vector(-1,0,0), 80000,80000, Color(0,0,0,255), 0)
				render.SetBlend(1)
				render.OverrideAlphaWriteEnable(false)
			end
		end)
		self.Hooked = true
	end
	if self:GetState() != 0 then
			if CurTime() > self.Owner:GetNWFloat("DelayMenacing_"..self.Owner:GetName()) then
				self.Owner:SetNWFloat("DelayMenacing_"..self.Owner:GetName(), CurTime() + 0.5)
				local effectdata = EffectData()
				effectdata:SetStart(self.Owner:GetPos())
				effectdata:SetOrigin(self.Owner:GetPos())
				effectdata:SetEntity(self.Owner)
				util.Effect("menacing", effectdata)
				end
	end
	self.SwapTimer = self.SwapTimer or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("dododo") and IsValid(self:GetMirror()) and CurTime() > self.SwapTimer then
	self:SetState((self:GetState() + 1) % 3)
	self.SwapTimer = CurTime() + 0.2
	end
	if self:GetState() != 0 and !IsValid(self:GetMirror()) then
		self:SetState(0)
	end
	self:NextThink(CurTime())
	return true
end
	

function SWEP:PrimaryAttack()

	if SERVER and self:GetState() == 2 then
		self:Barrage()
	end
	self:SetNextPrimaryFire( CurTime() + 0.5 )
end
local reflectmats = {
		MAT_TILE,
		MAT_SLOSH,
		MAT_GLASS,
		MAT_METAL
}
function SWEP:CheckReflectivityOfSurface(tab)
	local refl = false
	if (tab.Entity:IsPlayer() or tab.Entity:IsNPC()) then return true end
	if tab.HitTexture and tab.HitTexture != "**studio**" and tab.HitTexture != "**displacement**" and tab.HitTexture != "**empty**" then
		local mat = Material(tab.HitTexture)
			
		if mat and mat:GetVector("$envmaptint") and mat:GetVector("$envmaptint"):Length() > 1 then
				return true
		end
	elseif tab.Hit and IsValid(tab.Entity) then
		for k,v in pairs(tab.Entity:GetMaterials()) do
		if v != "" then
		local mat = Material(v)
			if v and mat and mat.GetTexture and mat:GetVector("$envmaptint"):Length() >= 1.6 then
					return true
			end
			end
		end
	end
	return false
end
function SWEP:SecondaryAttack()
	if (self:GetState() == 1 or self:GetState() == 0) and !self.Owner:KeyDown(IN_SPEED) then
		local start = self.Owner:EyePos()
		if IsValid(self:GetMirror()) then
			start = self:GetMirror():GetPos()
		end
		local parent
		if IsValid(self:GetMirror()) and IsValid(self:GetMirror():GetParent()) then
			parent = self:GetMirror():GetParent()
		end
		local tr = util.TraceLine( {
			start = start,
			endpos = start + self.Owner:GetAimVector() * 5000,
			filter = {self.Owner, self:GetMirror(), parent},
			mask = MASK_ALL
		} )
		local oldmirror = self:GetMirror()
		if SERVER and (self:CheckReflectivityOfSurface(tr) or bit.band( util.PointContents( tr.HitPos + tr.Normal ), CONTENTS_WATER ) == CONTENTS_WATER) then
			local pos = self.Owner:EyePos()
			if IsValid(self:GetMirror()) then
				pos = self:GetMirror():GetPos()
				self:GetMirror():Remove()
				sound.Play(Pew, pos, 511)
			end
			self:SetMirror(ents.Create("hangedmansurface"))
			self:GetMirror():SetPos(tr.HitPos)
			self:GetMirror():SetOwner(self.Owner)
			self:GetMirror():SetAngles(tr.HitNormal:Angle() + Angle(90, 0, 0))
			if tr.Entity:IsValid() and (tr.Entity:IsPlayer() or tr.Entity:IsNPC()) then
				self:GetMirror():SetPos(tr.Entity:WorldSpaceCenter())
				self:GetMirror():SetAngles(tr.Entity:GetAngles() + Angle(90, 0, 0))
			end
			self:GetMirror():Spawn()
			self:GetMirror():SetOldMirror(pos)
			self:GetMirror():EmitStandSound(Pew, 511)
			self.Owner:EmitStandSound(Pew, 511)
		end
		if CLIENT and self:GetMirror():IsValid() then
			surface.PlaySound(Pew)
		end
		self:SetNextSecondaryFire( CurTime() + 0.5 )

	end
	self.TeleDelay = self.TeleDelay or CurTime()
	if SERVER and IsValid(self:GetMirror()) and IsValid(self:GetStand()) and self.Owner:KeyDown(IN_SPEED) and CurTime() >= self.TeleDelay then
		sound.Play(Pew, self:GetMirror():GetPos(), 511)
		self.Owner:EmitStandSound(Pew, 511)
		self:GetMirror():Remove()
		self:GetMirror():FindNewLocation()
		self:GetMirror():EmitStandSound(Pew, 511)
		self.TeleDelay = CurTime() + 0.1
	end
	
	if SERVER and self:GetState() == 2 then
		local parent
		if IsValid(self:GetMirror()) and IsValid(self:GetMirror():GetParent()) then
			parent = self:GetMirror():GetParent()
		end
		local stand 
		if IsValid(self:GetStand()) then
			if IsValid(parent) and parent.GetActiveWeapon and IsValid(parent:GetActiveWeapon()) and parent:GetActiveWeapon().GetStand then
				stand = parent:GetActiveWeapon():GetStand()
			end
		end
		local tr = util.TraceHull( {
			start = self:GetStand():GetEyePos(),
			endpos = self:GetStand():WorldSpaceCenter() + self.Owner:GetAimVector() * 75,
			mins = Vector(-55,-55,-55),
			maxs = Vector(55,55,55),
			filter = {self.Owner, self:GetStand(), self:GetMirror(), parent, stand},
			mask = MASK_SHOT_HULL,
			ignoreworld = true,
		} )
		if IsValid(tr.Entity) and (tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsStand()) and tr.Entity:GetForward():Dot(self:GetStand():GetForward()) >= 0.5 then
			local movetype = tr.Entity:GetMoveType()
			self:GetStand():ResetSequence("backstab")
			self:GetStand():SetCycle(0)
			tr.Entity:SetMoveType(MOVETYPE_NONE)
			self:GetStand():SetBackstabTarget(tr.Entity)
			self:SetHoldType("pistol")
			self.Stand:EmitStandSound(BackstabInsults)
														self:GetStand():EmitStandSound(SwingSound)

			timer.Simple(0.35, function() if IsValid(tr.Entity) and IsValid(self) and IsValid(self.Stand) then 
										self:GetStand():EmitStandSound(Grab)

			end
			end)
			timer.Simple(0.3, function() if IsValid(tr.Entity) and IsValid(self) and IsValid(self.Stand) then 
										self:GetStand():EmitStandSound(FlickOut)


			end
			end)
			timer.Simple(1.05, function() if IsValid(tr.Entity) and IsValid(self) and IsValid(self.Stand) then 
							self:GetStand():EmitStandSound(Stab)
							self:GetStand():EmitStandSound(HitSound)

			end
			end)
			timer.Simple(1.1, function() if IsValid(tr.Entity) and IsValid(self) and IsValid(self.Stand) then 
				local dmginfo = DamageInfo()
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )
		dmginfo:SetDamageType(DMG_SLASH)
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 350 )
				tr.Entity:TakeDamageInfo( dmginfo ) 
				local fx = EffectData()
				fx:SetOrigin(self:GetStand():GetBonePosition(self:GetStand():LookupBone("ValveBiped.Bip01_R_Hand")))
				fx:SetScale(5)
				fx:SetNormal(tr.HitNormal)
				fx:SetMagnitude(1)
				fx:SetColor(0)
				fx:SetFlags(3)
				util.Effect("bloodspray", fx, true, true)
				util.Effect("BloodImpact", fx, true, true)
				end end)
			timer.Simple(self:GetStand():SequenceDuration() - 0.4, function() if IsValid(tr.Entity) and IsValid(self) and IsValid(self.Stand) then self:GetStand():SetBackstabTarget(self.Owner) end end)
			timer.Simple(self:GetStand():SequenceDuration() - 0.7, function() if IsValid(tr.Entity) then tr.Entity:SetMoveType(movetype) self:GetStand():EmitStandSound(PullOut) end end)		
			timer.Simple(self:GetStand():SequenceDuration(), function() if IsValid(tr.Entity) then self:SetHoldType("stando") end end)		
			end
				self:SetNextSecondaryFire( CurTime() + 2 )

	end
	
end

function SWEP:Barrage()
	
	self:SetHoldType("pistol")
	if !string.StartWith(self:GetStand():GetSequenceName(self:GetStand():GetSequence()), "attack") then
		self:GetStand():ResetSequence("attack1")
		self.Stand:ResetSequenceInfo()
				self.Stand:SetPlaybackRate( 1 )
		elseif self:GetStand():GetSequence() == self:GetStand():LookupSequence("attack1") then
		self:GetStand():ResetSequence("attack2")
		self.Stand:ResetSequenceInfo()
				self.Stand:SetPlaybackRate( 1 )
		elseif self:GetStand():GetSequence() == self:GetStand():LookupSequence("attack2") then
		self:GetStand():ResetSequence("attack3")
		self.Stand:ResetSequenceInfo()
				self.Stand:SetPlaybackRate( 1 )
		elseif self:GetStand():GetSequence() == self:GetStand():LookupSequence("attack3") then
		self:GetStand():ResetSequence("attack4")
		self.Stand:ResetSequenceInfo()
				self.Stand:SetPlaybackRate( 1 )
		elseif self:GetStand():GetSequence() == self:GetStand():LookupSequence("attack4") then
		self:GetStand():ResetSequence("attack2")
		self.Stand:ResetSequenceInfo()
				self.Stand:SetPlaybackRate( 1 )
	end
	timer.Simple(self.Stand:SequenceDuration() + 0.5, function() if IsValid(self) and self.Stand:GetCycle() > 0.9 then self:SetHoldType("stando") end end)
	local parent
	local stand
	if IsValid(self:GetMirror()) and IsValid(self:GetMirror():GetParent()) then
		parent = self:GetMirror():GetParent()
		if IsValid(parent) and parent.GetActiveWeapon and IsValid(parent:GetActiveWeapon()) and parent:GetActiveWeapon().GetStand then
			stand = parent:GetActiveWeapon():GetStand()
		end
	end
	
	local tr = util.TraceHull( {
		start = self:GetStand():GetEyePos(),
		endpos = self:GetStand():WorldSpaceCenter() + self.Owner:GetAimVector() * 75,
		mins = Vector(-55,-55,-55),
		maxs = Vector(55,55,55),
		filter = {self.Owner, self:GetStand(), self:GetMirror(), parent, stand},
		mask = MASK_SHOT_HULL
	} )
			self:GetStand():EmitStandSound(SwingSound)

	local hit = false

	if ( SERVER and tr.Hit) then
		local dmginfo = DamageInfo()

		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )
		dmginfo:SetDamageType(DMG_SLASH)
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 50 )
		local eftrace = util.TraceLine({
			start=self:GetStand():GetBonePosition(self:GetStand():LookupBone("ValveBiped.Bip01_R_Hand")),
			endpos = tr.Entity:WorldSpaceCenter(),
			filter=function(ent) if ent == tr.Entity then return true else return false end end
		})
		
		local fx = EffectData()
		fx:SetOrigin(eftrace.HitPos)
		fx:SetScale(5)
		fx:SetNormal(eftrace.HitNormal)
		fx:SetMagnitude(1)
		fx:SetColor(0)
		fx:SetFlags(3)
		util.Effect("bloodspray", fx, true, true)
		util.Effect("BloodImpact", fx, true, true)
		if tr.Entity:IsValid() and tr.Entity:Health() > 0 then
			tr.Entity:TakeDamageInfo( dmginfo )
			timer.Simple(0.01, function()
			self:GetStand():EmitStandSound(Stab)
										self:GetStand():EmitStandSound(HitSound)

			end)
		end
	
		hit = true

	end    
	--Target's view gets knocked around. I thought it was a cool effect.
	if tr.Entity:IsPlayer() then
		tr.Entity:ViewPunch( Angle( math.random( -3, 3 ), math.random( -3, 3 ), math.random( -3, 3 ) ) )
	end
	self:SetNextSecondaryFire( CurTime() + self.Stand:SequenceDuration() + 2 )

	
end


function SWEP:Reload()
--Mode changing
	if SERVER and IsValid(self:GetMirror()) and IsValid(self:GetStand()) then
		self:GetMirror():Remove()
		self:SetState(0)
		self:GetStand():SetInDoDoDo(false)
	end
	
end

--Screw this entire section, it only works like 20% of the time. Basically, meant to catch every time the weapon is not in your hands in order to remove the stand.
function SWEP:OnDrop()
	 if SERVER and self.Stand:IsValid() then
        self.Stand:Withdraw()
		if self.WithdrawSpecial then
			self.Owner:EmitSound(Lightly)
		end
	end
		
	return true
end

function SWEP:OnRemove()
	 if SERVER and self.Stand:IsValid() then
        self.Stand:Withdraw()
		if self.WithdrawSpecial then
			self.Owner:EmitSound(Lightly)
		end
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
		
	return true
end