
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot      = 1
end

SWEP.Power = 1.5
SWEP.Speed = 2
SWEP.Range = 1500
SWEP.Durability = 1500
SWEP.Precision = nil
SWEP.DevPos = nil

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.hp2.purpose"
SWEP.Instructions  = "#gstands.hp2.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.hp2"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos            = 2
SWEP.DrawCrosshair      = true

SWEP.WorldModel = "models/hpworld/hpworld.mdl"
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
SWEP.StandModel 				= "models/hpworld/hpworld.mdl"
SWEP.StandModelP 				= "models/hpworld/hpworld.mdl"
if CLIENT then
	SWEP.StandModel = "models/hpworld2/hpworld2.mdl"
end
SWEP.DrawAmmo = false
SWEP.HitDistance = 48

rtTex = "phoenix_storms/rt_camera"
game.AddParticles("particles/auraeffect.pcf")
PrecacheParticleSystem("auraeffect")

SWEP.Latched = false
SWEP.Color = Color(255,0,255,255)
SWEP.Range = 1500
SWEP.gStands_IsThirdPerson = true

local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )
local Grapple = Sound( "weapons/hermit/grapple.mp3" )
local SpiritTV = Sound("weapons/hermit/spirittv.mp3")
local Deploy = Sound("weapons/hermit2/deploy.wav")
local Notify = Sound("weapons/hermit2/notify.wav")
local Withdraw = Sound("weapons/hermit2/withdraw.wav")
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
		local color = self.Color
		local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
	end
end
hook.Add( "HUDShouldDraw", "HermitPurple2Hud", function(elem)
	if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_hermit_purple_2" and (((elem == "CHudWeaponSelection" ) and LocalPlayer().SPInZoom) or elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
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
			local clr = self:GetHColor()
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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= ACT_HL2MP_IDLE_FIST
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE_KNIFE + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_01"))
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_fists_r"))
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_fists_r"))
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= ACT_HL2MP_IDLE_CAMERA + 1
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= ACT_HL2MP_IDLE_CAMERA + 3
		self.ActivityTranslate[ ACT_MP_JUMP ]						= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("jump_suitcase"))
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
	
	if ( t == "normal" ) then
		self.ActivityTranslate[ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end
    
    
end
function SWEP:Initialize()
	timer.Simple(0.1, function() 
		if self:GetOwner() != nil then
			if self:GetOwner():IsValid() and SERVER then
				self:GetOwner():SetHealth(GetConVar("gstands_hermit_purple_two_heal"):GetInt())
				self:GetOwner():SetMaxHealth(GetConVar("gstands_hermit_purple_two_heal"):GetInt())
			end
		end
	end)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 1, "InRange")
	self:NetworkVar("Float", 1, "Delay2")
	self:NetworkVar("Bool", 2, "Ended")
	self:NetworkVar("Bool", 3, "Latched")
	self:NetworkVar("Vector", 0, "HColor")
	self:NetworkVar("Entity", 0, "Target")
end

function SWEP:DrawWorldModel()
	if IsValid(self.Owner) then
		self.WorldModel = "models/hpworld/hpworld.mdl"
		if !self.Owner:GetNoDraw() then
			self.Color = Color(255, 0, 150)
			if self.Owner:GetNoDraw() and self.Aura and !(LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer())) then
				self.Aura:StopEmission()
				self.Aura = nil
			end
			if !self.Owner:GetNoDraw() and CLIENT and LocalPlayer():GetActiveWeapon() then
				if LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then
					self.Aura = self.Aura or CreateParticleSystem(self.Owner, "auraeffect", PATTACH_POINT_FOLLOW, 1)
					self.Aura:SetControlPoint(1, Vector(self.Color.r / 255, self.Color.g / 255, self.Color.b / 255))
					
					local selfT = { Ents = self }
					local haloInfo = 
					{
						Ents = selfT,
						Color = self.Color,
						Hidden = when_hidden,
						BlurX = math.sin(CurTime()) * 5,
						BlurY = math.sin(CurTime()) * 5,
						DrawPasses = 5,
						Additive = true,
						IgnoreZ = false
					}
					local r, g, b = render.GetColorModulation()
					render.SetColorModulation(1,0.1,0.05)
					self:DrawModel() 
					render.SetColorModulation(r, g, b)
					if GetConVar("gstands_draw_halos"):GetBool() and self:WaterLevel() < 1 and render.SupportsHDR and !LocalPlayer():IsWorldClicking() then
						halo.Render(haloInfo)
					end
				end
			end
			elseif self.Aura then
			self.Aura:StopEmission()
			self.Aura = nil
		end
		else
		self.WorldModel = "models/player/whitesnake/disc.mdl"
		self:DrawModel()
	end
end
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
function SWEP:Deploy()
    self:SetHoldType( "stando" )
	
    if self.Owner:Health() == 100  then
        self.Owner:SetMaxHealth( self.Durability )
        self.Owner:SetHealth( self.Durability )
	end
    if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitStandSound(Deploy)
		end
	end
    self.Aura = nil
	
end

function SWEP:Think()
	self.LastOwner = self.Owner
	local curtime = CurTime()
    self.GrappleDelay = self.GrappleDelay or CurTime()
    if ( self.Owner:KeyPressed( IN_ATTACK ) ) and self.GrappleDelay <= CurTime() then
		
		self:StartAttack()
		self.GrappleDelay = CurTime() + 0.3
		elseif ( self.Owner:KeyDown( IN_ATTACK ) and self:GetInRange() and !self:GetEnded()) then
		
		self:UpdateAttack()
		
		elseif ( self.Owner:KeyReleased( IN_ATTACK ) and self:GetInRange() ) then
		
		self:EndAttack()
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
	self.Delay2 = self.Delay2 or CurTime()
	self.RelDelay = self.RelDelay or CurTime()
	if self.Owner:gStandsKeyDown("modeswap") and SERVER and self:GetTarget() and self:GetTarget():IsPlayer() and self.RelDelay <= CurTime() then
		self.RelDelay = CurTime() + 3
		self:GetTarget():SetDSP(35, false)
		self:GetTarget():SetDSP(35, false)
		self:GetTarget():EmitStandSound(Notify)
		clr = Color(255,255,255, 255)
		self:GetTarget():ScreenFade( SCREENFADE.IN , clr , 0.5, 0.5 )
		local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 20 )
		
        if SERVER and self:GetTarget():IsValid() and (self:GetTarget():IsPlayer()) and self:GetTarget():Health() then
            self:GetTarget():TakeDamageInfo( dmginfo )
		end
	end
end


function SWEP:PrimaryAttack()
	
end


function SWEP:SecondaryAttack()
	
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
    
    
	local anim = "punch2"
    
	self:EmitSound( SwingSound )
	timer.Simple(2, function() hook.Remove("PreDrawEffects","HP2MindRead2"..self.Owner:GetName()) end)
	if self.LastViewed then 
		self.LastViewed:EmitStandSound(Notify)
	end
	local timer = 255
    hook.Add("PreDrawEffects","HP2MindRead2"..self.Owner:GetName(),function()
		local ang = EyeAngles()
		ang = Angle(ang.p+90,ang.y,0)
		
		cam.Start3D2D(EyePos()+EyeAngles():Forward()*10,ang,1)
		render.SetBlend(0)
		render.ClearStencil()
		render.SetStencilEnable(true)
		render.SetStencilWriteMask(255)
		render.SetStencilTestMask(255)
		render.SetStencilReferenceValue(15)
		render.SetStencilFailOperation(STENCILOPERATION_KEEP)
		render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
		render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
		timer = timer - 7
		surface.SetDrawColor(255,50,150,timer)
		
		local w,h = ScrW(),ScrH()
		if (self.LastViewed and self.LastViewed:IsValid()) and self.LastViewed:Health() > 0 and self.LastViewed != self.Owner then
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
			
			local prevNoDraw = self.LastViewed:GetNoDraw()
			self.LastViewed:SetNoDraw(false)
			local prevRenderMode = self.LastViewed:GetRenderMode()
			self.LastViewed:SetRenderMode(RENDERMODE_TRANSALPHADD)
			self.LastViewed:DrawModel()
			self.LastViewed:SetRenderMode(prevRenderMode)
			self.LastViewed:SetNoDraw(prevNoDraw)
			
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
			
			surface.DrawRect(-w,-h,w*2,h*2)
		end
		render.SetStencilEnable(false)
		render.SetBlend(1)
		cam.End3D2D()
		if !(self.Owner:Alive()) then
			hook.Remove("PreDrawEffects","HP2MindRead2"..self.Owner:GetName())
		end
	end)
    self:SetNextSecondaryFire( CurTime() + 3 )
end

function SWEP:DoTrace( endpos )
	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + (self.Owner:GetAimVector() * 14096) 
	if(endpos) then trace.endpos = (endpos - self.Tr.HitNormal * 7) end
	trace.filter = { self.Owner, self.Weapon }
	
	self.Tr = nil
	self.Tr = util.TraceLine( trace )
	self:SetTarget(self.Tr.Entity)
end

function SWEP:StartAttack()
	if SERVER then
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self:EmitSound( SwingSound )
	end
	local gunPos = self.Owner:GetShootPos()
	local disTrace = self.Owner:GetEyeTrace()
	local hitPos = disTrace.HitPos
    
	local x = (gunPos.x - hitPos.x)^2;
	local y = (gunPos.y - hitPos.y)^2;
	local z = (gunPos.z - hitPos.z)^2;
	local distance = math.sqrt(x + y + z);
	self:SetLatched( false)
	self:SetInRange( false)
	if distance <= self.Range and disTrace.HitWorld then
		self:SetInRange( true)
		elseif !self.Owner.IsKnockedOut and disTrace.Entity:IsValid() and distance <= self.Range then
        self:DoTrace()
		self.speed = 10000
		self.startTime = CurTime()
		self.endTime = CurTime() + self.speed
		self.dat = -1
        if SERVER then
			
			if (!self.Beam) then 
				self.Beam = ents.Create( "hermit_purple_2_trace" )
				self.Beam:SetPos( self.Owner:GetShootPos() )
				self.Beam.speed = 100
				self.Beam.HasEnt = true
				
				self.Beam:Spawn()
				
			end
			
			self.Beam:SetParent( self.Owner )
			self.Beam:SetOwner( self.Owner )
			
		end
        local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )
		
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 4 )
		
		if SERVER and self:GetTarget():IsValid() and !self:GetTarget():IsNPC() and self:GetTarget():GetKeyValues()["health"] > 0 then self:GetTarget():SetKeyValue("explosion", "2") self:GetTarget():SetKeyValue("gibdir", tostring(self.Tr.Normal:Angle())) self:GetTarget():Fire("Break") end
		
        if SERVER and !self.Owner.IsKnockedOut and self:GetTarget():IsValid() and (self:GetTarget():IsPlayer() or self:GetTarget():IsNPC()) and self:GetTarget():Health() then
            if self:GetTarget():GetClass() == "stand" then
				self:SetTarget(self:GetTarget().Owner)
			end
            self:GetTarget():TakeDamageInfo( dmginfo )
		end
        self:SpiritTV(self.Tr)
		
        
        if self:GetTarget():IsPlayer() then 
			self:GetTarget():SetVelocity( -(self.Owner:GetAimVector() * 500 * self.Power) + Vector( 0, 0, 200 ) )
			self.LastViewed = self:GetTarget()
			if CLIENT then
				hook.Add("PreDrawEffects","HP2MindRead"..self.Owner:GetName(),function()
					local ang = EyeAngles()
					ang = Angle(ang.p+90,ang.y,0)
					
					cam.Start3D2D(EyePos()+EyeAngles():Forward()*10,ang,1)
					render.SetBlend(1)
					render.ClearStencil()
					render.SetStencilEnable(true)
					render.SetStencilWriteMask(255)
					render.SetStencilTestMask(255)
					render.SetStencilReferenceValue(15)
					render.SetStencilFailOperation(STENCILOPERATION_KEEP)
					render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
					render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
					
					surface.SetDrawColor(255,50,150,255)
					local w,h = ScrW(),ScrH()
					for _,v in ipairs(ents.GetAll()) do
						if (v:IsPlayer()) and v:Health() > 0 and self:GetTarget() and self:GetTarget().Team and v:Team() == self:GetTarget():Team() and v != self.Owner then
							render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
							
							local prevNoDraw = v:GetNoDraw()
							v:SetNoDraw(false)
							local prevRenderMode = v:GetRenderMode()
							v:SetRenderMode(RENDERMODE_TRANSALPHADD)
							v:DrawModel()
							v:SetRenderMode(prevRenderMode)
							v:SetNoDraw(prevNoDraw)
							
							render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
							
							surface.DrawRect(-w,-h,w*2,h*2)
						end
					end
					render.SetStencilEnable(false)
					render.SetBlend(1)
					cam.End3D2D()
					if !(self.Owner:Alive()) then
						hook.Remove("PreDrawEffects","HP2MindRead"..wisher:GetName())
					end
				end)
			end
		end
		hit = true
        self:SetInRange( true)
        self:SetLatched( true)
        if SERVER then
            self.Owner:EmitStandSound(Grapple)
		end
        self:UpdateAttack()
		self:SetHoldType("magic")
		
	end
	
	if self:GetInRange() then
		if SERVER then
			if (!self.Beam) then
				self.Beam = ents.Create( "hermit_purple_2_trace" )
				self.Beam:SetPos( self.Owner:GetShootPos() )
				self.Beam:Spawn()
                
			end
			
			self.Beam:SetParent( self.Owner )
			self.Beam:SetOwner( self.Owner )
			
		end
	end
	self:DoTrace()
	self.speed = 10000
	self.startTime = CurTime()
	self.endTime = CurTime() + self.speed
	self.dat = -1
	if (SERVER and self.Beam) then
		self.Beam:SetEndPos( self.Tr.HitPos )
	end
	
	if SERVER then
		self.Owner:EmitStandSound(Grapple)
	end
	self:UpdateAttack()
	self:SetHoldType("magic")
	
    self:SetEnded( false)
end

function SWEP:UpdateAttack()
	if (!endpos) and self.Tr.HitPos then endpos = self.Tr.HitPos end
	if (!endpos) then return false end
	if (self.Beam) then
		self.Beam:SetEndPos( endpos )
	end
	lastpos = endpos
	
	
	if ( self:GetTarget():IsValid() ) then
		endpos = self:GetTarget():WorldSpaceCenter()
		if ( SERVER ) and self.Beam then
			self.Beam:SetEndPos( endpos )
		end
		
	end
	
	local vVel = (endpos - self.Owner:GetPos())
	local Distance = endpos:Distance(self.Owner:GetPos())
	
	local et = (self.startTime + (Distance/self.speed))
	if(self.dat != 0) then
		self.dat = (et - CurTime()) / (et - self.startTime)
	end
	if(self.dat < 0) then
		self.dat = 0
	end
	
	endpos = nil
	if Distance > self.Range then
		self:EndAttack()
		self:SetEnded( true)
	end
	self.Owner:LagCompensation( false )
end

function SWEP:EndAttack()
	self:SetHoldType("stando")
	if CLIENT and IsValid(self.Owner) then
		hook.Remove("PreDrawEffects","HP2MindRead"..self.Owner:GetName())
	end
	if ( CLIENT ) then return end
	
	if ( !IsValid( self.Beam ) ) then return end
	self.Beam:Remove()
	self.Beam = nil
	
end

function SWEP:SpiritTV(tr)
	self.Owner:LagCompensation( true )
	
    if IsValid(self:GetTarget()) and tr.Hit then
        self.Owner:EmitStandSound(SpiritTV)
	end
	if ( self:GetTarget():IsValid()) then
        for k,v in ipairs(self:GetTarget():GetMaterials()) do
			if (v == rtTex or v == "models/rendertarget") or self:GetTarget():GetSubMaterial(k) == rtTex or self:GetTarget():GetSubMaterial(k) == "models/rendertarget" or self:GetTarget():GetMaterial() == "models/rendertarget" then
				if CLIENT then return end
				if #ents.FindByClass( "hermit_purple_2_camera" ) > 1 then
					for k,v in ipairs(ents.FindByClass( "hermit_purple_2_camera" )) do
						v:Remove()
					end
				end
				local plrdis = nil
				self.plyIndex = self.plyIndex or 1
				self.plyIndex = (self.plyIndex + 1)
				local plTab = player.GetAll()
				local ply = plTab[(self.plyIndex) % (#plTab) + 1]
				local pid = ply:UniqueID()
				
				GAMEMODE.RTCameraList = GAMEMODE.RTCameraList or {}
				GAMEMODE.RTCameraList[ pid ] = GAMEMODE.RTCameraList[ pid ] or {}
				local CameraList = GAMEMODE.RTCameraList[ pid ]
				
				local Pos = ply:EyePos() - (ply:GetAimVector() * 200)
				
				local camera = ents.Create( "hermit_purple_2_camera" )
				
				if (!camera:IsValid()) or !ply:IsValid() then return false end
				
				camera:SetAngles( ply:EyeAngles() )
				camera:SetPos( Pos )
				camera:SetvecTrack( Pos )
				camera:SetentTrack( ply )
				camera:Spawn()
				if SERVER then
					hook.Add("SetupPlayerVisibility", "HermitPurple2RTVis"..self.Owner:GetName()..camera:EntIndex(), function(ply, ent) 
						if self:IsValid() and self.Owner:IsValid() and camera:IsValid() then
                            AddOriginToPVS( camera:GetPos() )
						end
					end)
				end
				camera:SetPlayer( ply )
				
				camera:AddEffects(EF_NODRAW )
				camera:SetMoveType(MOVETYPE_NONE)
				
				key = key or 0
				CameraList[ key ] = camera
				
				
				if !RenderTargetCameraHP2 or #ents.FindByClass( "hermit_purple_2_camera" ) >= 1 then HP2UpdateRenderTarget( camera ) end
			end
		end
		
		self.Owner:LagCompensation( false )
		
	end
end

function HP2UpdateRenderTarget( ent )
	if ( !ent or !ent:IsValid() ) then return end
	if ( !RenderTargetCameraHP2 or !RenderTargetCameraHP2:IsValid() ) then
		
		RenderTargetCameraHP2 = ents.Create( "point_camera" )
		RenderTargetCameraHP2:SetKeyValue( "GlobalOverride", 1 )
		RenderTargetCameraHP2:Spawn()
		RenderTargetCameraHP2:Activate()
		RenderTargetCameraHP2:Fire( "SetOn", "", 0.0 )
		
	end
	
	Pos = ent:LocalToWorld( Vector( 12,0,0 ) )
	RenderTargetCameraHP2:SetPos(Pos)
	RenderTargetCameraHP2:SetAngles(ent:GetAngles())
	RenderTargetCameraHP2:SetParent(ent)
	
	RenderTargetCameraHP2Prop = ent
end

function SWEP:Reload()
	
end


function SWEP:OnDrop()
	self.WorldModel = "models/player/whitesnake/disc.mdl"
	self:EndAttack()
	if IsValid(self.LastOwner) then
		self.LastOwner:StopParticles()
	end
	if CLIENT and self.Aura then
		self.Aura:StopEmission()
		self.Aura = nil
	end	
end

function SWEP:OnRemove()
	self:EndAttack()
	if IsValid(self.Owner) then
		self.Owner:StopParticles()
	end
	if CLIENT and self.Aura then
		self.Aura:StopEmission()
		self.Aura = nil
	end
	return true
	
end

function SWEP:Holster()
	self:EndAttack()
	if IsValid(self.Owner) then
		self.Owner:StopParticles()
		self.Owner:EmitSound(Withdraw)
	end
	if CLIENT and self.Aura then
		self.Aura:StopEmission()
		self.Aura = nil
	end
	return true
end					