
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot			 		= 1
end

SWEP.Power						= 1.5
SWEP.Speed						= 2
SWEP.Range						= 1500
SWEP.Durability		   		= 1500
SWEP.Precision					= nil
SWEP.DevPos			   		= nil

SWEP.Author			   		= "Copper"
SWEP.Purpose			  	= "#gstands.hp.purpose"
SWEP.Instructions		 	= "#gstands.hp.instructions"
SWEP.Spawnable				= true
SWEP.Base					 = "weapon_fists" 
SWEP.Category			 	= "gStands"
SWEP.PrintName		   	 	= "#gstands.names.hp"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos			  		= 2
SWEP.DrawCrosshair				= true
SWEP.StandModel 				= "models/hpworld/hpworld.mdl"
SWEP.StandModelP 				= "models/hpworld/hpworld.mdl"

SWEP.WorldModel		   		= "models/hpworld/hpworld.mdl"
SWEP.ViewModelFOV		 		= 54
SWEP.UseHands			 		= true

SWEP.Primary.ClipSize	 		= -1
SWEP.Primary.DefaultClip  		= -1
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo			 	= "none"

SWEP.Secondary.ClipSize   		= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic  		= true
SWEP.Secondary.Ammo	   		= "none"

SWEP.DrawAmmo			 		= false
SWEP.HitDistance		  		= 85

rtTex = "phoenix_storms/rt_camera"
game.AddParticles("particles/hpurple.pcf")
game.AddParticles("particles/auraeffect.pcf")
PrecacheParticleSystem("hpurple")

PrecacheParticleSystem("auraeffect")

SWEP.Latched 					= false
SWEP.Color 						= Color(255,0,255,255)
SWEP.gStands_IsThirdPerson = true

local SwingSound				= Sound( "WeaponFrag.Throw" )
local HitSound  				= Sound( "Flesh.ImpactHard" )
local Grapple   				= Sound( "weapons/hermit/grapple.mp3" )
local SpiritTV  				= Sound("weapons/hermit/spirittv.mp3")
local Hamon	 				= Sound("hrp.overdrive")
local HamonNoise				= Sound("weapons/hermit/hamon-noise.wav")
local Deploy					= Sound("hrp.deploy")
local SDeploy   				= Sound("weapons/hermit/sdeploy.wav")
local Flicker   				= Sound("weapons/hermit/flicker.wav")
local Trail	 				= Sound("weapons/hermit/trail-hamon.wav")
local Crackle   				= Sound("weapons/hermit/crackle-small-01.wav")
local sCrackle  				= Sound("hrp.small-crackle")
local mCrackle  				= Sound("hrp.med-crackle")
local Whip	  				= Sound("hrp.whip")
local Omg	   				= Sound("hrp.omg")

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
	[ "stando" ]		= ACT_HL2MP_IDLE_SLAM
	
}
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

function SWEP:DrawHUD()
	if GetConVar("gstands_draw_hud"):GetBool() then
		local color = Color(self:GetHColor().r, self:GetHColor().g, self:GetHColor().b)
		if self:GetHamon() then
			color = Color(255,105,0,255)
		else
			color = Color(255,0,255,255)
		end
		local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
		
		if !self:GetHamon() then
			surface.SetMaterial(boxend)
			else
			surface.SetMaterial(boxdis)
		end
		surface.DrawTexturedRect(width - (192 * mult) - 135 * mult, height - (192 * mult) - 10 * mult, 192 * mult, 192 * mult)
		
		if !self:GetHamon() then
			surface.SetMaterial(boxdis)
			else
			surface.SetMaterial(boxend)
		end
		surface.DrawTexturedRect(width - (192 * mult), height - (192 * mult) - 10 * mult, 192 * mult, 192 * mult)
		
		draw.TextShadow({
			text = "#gstands.hp.hamoff",
			font = "gStandsFont",
			pos = {width - 305 * mult, height - 190 * mult},
			color = tcolor,
		}, 2 * mult, 250)
		
		draw.TextShadow({
			text = "#gstands.hp.hamon",
			font = "gStandsFont",
			pos = {width - 175 * mult, height - 190 * mult},
			color = tcolor,
		}, 2 * mult, 250)
		
	end
end
hook.Add( "HUDShouldDraw", "HermitPurpleHud", function(elem)
	if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_hermit_purple" and (((elem == "CHudWeaponSelection" ) and LocalPlayer().SPInZoom) or elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
		return false
	end
end)
local material = Material( "vgui/hud/gstands_hud/crosshair" )
function SWEP:DoDrawCrosshair(x,y)
	if IsValid(self.Owner) then
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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= ACT_HL2MP_IDLE_SLAM
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE_SLAM + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_01") )
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_fists_r") )
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_fists_r") )
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= ACT_HL2MP_IDLE_CAMERA + 1
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= ACT_HL2MP_IDLE_CAMERA + 3
		self.ActivityTranslate[ ACT_MP_JUMP ]						= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("jump_suitcase") )
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
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Hamon")
	self:NetworkVar("Bool", 1, "InRange")
	self:NetworkVar("Float", 1, "Delay2")
	self:NetworkVar("Bool", 2, "Ended")
	self:NetworkVar("Bool", 3, "Latched")
	self:NetworkVar("Vector", 0, "HColor")
	self:NetworkVar("Vector", 1, "EndPos")
	self:NetworkVar("Entity", 4, "Stand")
	self:NetworkVar("Vector", 5, "Normal")
end

function SWEP:DrawWorldModel()
	if GetConVar("gstands_show_hitboxes"):GetBool() then
		for i = 0, self:GetHitBoxCount(0) - 1 do
			local cmins, cmaxs = self:GetHitBoxBounds(i, 0)
			local cpos, cang = self:GetBonePosition(self:GetHitBoxBone(i, 0) )
			render.DrawWireframeBox(cpos, cang, cmins, cmaxs, Color(255,0,0,255), true)
		end
		local cmins, cmaxs = self.Owner:GetCollisionBounds()
		cmins.x = cmins.x * 2
		cmins.y = cmins.y * 2
		cmaxs.x = cmaxs.x * 2
		cmaxs.y = cmaxs.y * 2
		render.DrawWireframeBox(self.Owner:GetPos(), Angle(0,0,0), cmins, cmaxs, Color(0,255,0,255), true)
	end
	if IsValid(self.Owner) then
		self.WorldModel = "models/hpworld/hpworld.mdl"
		if self.Owner:KeyDown(IN_ATTACK) then
			
		end
		if !self.Owner:GetNoDraw() then
			self.Color = Color(self:GetHColor().r, self:GetHColor().g, self:GetHColor().b)
			if self.Aura then
				if IsPlayerStandUser(LocalPlayer() ) or self:GetHamon() then
					self.Aura:SetShouldDraw(true)
					if self:GetHamon() then
						self.Aura:SetControlPoint(1, Vector(self.Color.r / 255, self.Color.g / 255, self.Color.b / 255) )
					end
					else
					self.Aura:SetShouldDraw(false)
				end
			end
			if !self.Owner:GetNoDraw() and CLIENT and LocalPlayer():GetActiveWeapon() then
				if IsValid(LocalPlayer()) and IsPlayerStandUser(LocalPlayer() ) then
					if !self.Aura then
						self.Owner:StopParticles()
					end
					self.Aura = self.Aura or CreateParticleSystem(self.Owner, "auraeffect", PATTACH_POINT_FOLLOW, 1)
					if self:GetHamon() then
						local clr = Color(255,105,0,255)
						self.Aura:SetControlPoint(1, Vector(clr.r / 255, clr.g / 255, clr.b / 255) )
						else
						local clr = Color(255,0,255,255)
						self.Aura:SetControlPoint(1, Vector(clr.r / 255, clr.g / 255, clr.b / 255) )
					end
					local selfT = { Ents = self }
					local haloInfo = 
					{
						Ents = selfT,
						Color = self.Color,
						Hidden = when_hidden,
						BlurX = math.sin(CurTime() ) * 5,
						BlurY = math.sin(CurTime() ) * 5,
						DrawPasses = 5,
						Additive = true,
						IgnoreZ = false
					}
					self:SetupBones()
					self:DrawModel()
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
	if self.Owner:GetMaxHealth() == 100 then
		self.Owner:SetHealth( self.Owner:Health() * self.Durability / 100 )
		self.Owner:SetMaxHealth( self.Durability )
	end
	if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitSound(Deploy)
			self.Owner:EmitStandSound(SDeploy)
		end
	end
	
	self.Aura = nil
	
	self.Owner:SetCanZoom(false)
	
end

function SWEP:Think()
	self.LastOwner = self.Owner
	self.GrappleStartDelay = self.GrappleStartDelay or CurTime()
	self:SetHColor( Vector(self.Color.r, self.Color.g, self.Color.b) )
	local name = self.Owner:GetName()
	if SERVER and ( self.Owner:gStandsKeyDown("modifierkey1") and self.Owner:KeyPressed( IN_ATTACK ) ) and self.GrappleStartDelay <= CurTime() then
		self.Owner:LagCompensation(true)
		self:StartAttack()
		self.Owner:LagCompensation(false)
		hook.Add("SetupMove", "HermitPurpleStun"..name, function(ply, mv, cmd)
			if IsValid(ply) and IsValid(self) and IsValid(self.HPTrace.Entity) and (ply == self.HPTrace.Entity or (IsValid(ply:GetActiveWeapon() ) and ply:GetActiveWeapon().GetStand and IsValid(ply:GetActiveWeapon():GetStand() ) and ply:GetActiveWeapon():GetStand() == self.HPTrace.Entity) ) then
				mv:SetMaxSpeed( mv:GetMaxSpeed() / 2 )
				mv:SetMaxClientSpeed( mv:GetMaxClientSpeed() / 2 )
				elseif IsValid(ply) and (!(IsValid(self) and IsValid(self.Owner) ) or !ply:Alive() ) then
				hook.Remove("SetupMove", "HermitPurpleStun"..name)
			end
		end)
		
		self.GrappleStartDelay = CurTime() + 0.3
		elseif SERVER and !self.Owner:gStandsKeyDown("tertattack") and ( self.Owner:gStandsKeyDown("modifierkey1") and self.Owner:KeyDown( IN_ATTACK ) and self:GetInRange() and !self:GetEnded() ) then
		self.Owner:LagCompensation(true)
		self:UpdateAttack()
		self.Owner:LagCompensation(false)
		self.speed = self.speed + 150
		elseif SERVER and !self.Owner:gStandsKeyDown("tertattack") and ( (self.Owner:KeyReleased( IN_ATTACK ) or self.Owner:gStandsKeyReleased( "modifierkey1" ) ) and self:GetInRange() and !self:GetEnded() ) then
		self.Owner:LagCompensation(true)
		self:EndAttack()
		self.Owner:LagCompensation(false)
		hook.Remove("SetupMove", "HermitPurpleStun"..name)
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
	
	self.HamonHealDelay = self.HamonHealDelay or CurTime()
	if self:GetHamon() and self.Owner:Health() < self.Durability and CurTime() > self.HamonHealDelay then
		self.Owner:SetHealth(self.Owner:Health() + 1)
		self.Owner:EmitSound(sCrackle)
		self.HamonHealDelay = CurTime() + 1
		for k,v in ipairs(player.GetAll() ) do
			if v:HasWeapon("gstands_lovers") and v:GetActiveWeapon() and v:GetActiveWeapon().GetTarget and v:GetActiveWeapon():GetTarget() == self.Owner and v:GetActiveWeapon().GetFleshbud then
				v:GetActiveWeapon():SetFleshbud( false )	 
			end
		end 
		
	end
	if self:GetHamon() then
		local cmins, cmaxs = self.Owner:GetCollisionBounds()
		cmins.x = cmins.x * 2
		cmins.y = cmins.y * 2
		cmaxs.x = cmaxs.x * 2
		cmaxs.y = cmaxs.y * 2
		local tr = util.TraceHull( {
			start = self.Owner:GetPos(),
			endpos = self.Owner:GetPos(),
			filter = { self.Owner },
			mins = cmins, 
			maxs = cmaxs,
		} )
		if SERVER and (tr.Entity:IsPlayer() or tr.Entity:IsNPC() ) then
			local dmginfo = DamageInfo()
			local attacker = self.Owner
			dmginfo:SetAttacker( attacker )
			dmginfo:SetDamageType(DMG_SHOCK)
			
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( 5 )
			
			tr.Entity:TakeDamageInfo( dmginfo )
			tr.Entity:EmitSound(Crackle)
		end
	end
	self.TauntTimer = self.TauntTimer or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("taunt") and CurTime() >= self.TauntTimer then
		self:SetHoldType("camera")
		if SERVER then self.Owner:EmitSound(Omg) end 
		timer.Simple(1, function() 
			if IsValid(self) then 
				self:SetHoldType("stando") 
			end
		end)
		self.TauntTimer = CurTime() + 2.5
	end
	if self.Owner:gStandsKeyDown("modeswap") then
		self.Delay = self.Delay or CurTime()
		if SERVER and CurTime() > self.Delay then
			self.Delay = CurTime() + 0.5
			self:SetHamon(!self:GetHamon() )
			if(self:GetHamon() ) then 
				self.Color = Color(255,105,0,255)
				if SERVER then
					self.Owner:ChatPrint("#gstands.hp.hamon")
					self.Owner:EmitSound(Hamon)
					self.Owner:EmitSound(HamonNoise)
				end
				else
				self.Color = Color(255,0,255,255)
				if SERVER then
					if self.Owner:GetWeapon("hamon"):IsValid() and self.Owner:GetWeapon("hamon"):GetHamonCharge() < 1 then
					self.Owner:ChatPrint("#gstands.hp.hamoff") 
					self.Owner:EmitStandSound(SpiritTV, 75, math.random(96,107) )
					end
				end
			end
		end
	end
	if self.Owner:GetWeapon("hamon"):IsValid() and self.Owner:GetWeapon("hamon"):GetHamonCharge() > 0 then
		self:SetHamon(true)
			if(self:GetHamon() ) then 
				self.Color = Color(255,195,0,255)
			end
	end

	self:NextThink(CurTime() )

	return true
end


function SWEP:PrimaryAttack()
	if !self.Owner:gStandsKeyDown("modifierkey1") then
		if SERVER then
			local whip = ents.Create("hermit_whip")
			whip:SetPos(self.Owner:GetPos() )
			whip:SetOwner(self.Owner)
			whip:SetAngles(self.Owner:GetAngles() )
			whip:SetParent(self.Owner)
			whip:Spawn()
			self:EmitSound( SwingSound )
			self:SetNextPrimaryFire( CurTime() + 0.5 )
		end
		self:SetHoldType("melee")
		
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_melee") )
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_melee") )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		
		timer.Simple(0.3, function() if IsValid(self) and IsValid(self.Owner) then
			self:SetHoldType("stando")
		end end)
	end
	
end

function SWEP:DonutPunch()
	
	self.Owner:LagCompensation( true )
	
	local tr = util.TraceHull( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = { self.Owner },
		mins = Vector( -15, -15, -15 ), 
		maxs = Vector( 15, 15, 15 ),
		ignoreworld = false,
		mask = MASK_SHOT_HULL
	} )
	
	if ( SERVER and IsValid( tr.Entity ) and ( tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:Health() > 0) ) then
		self.Owner:EmitSound( GetStandImpactSfx(tr.MatType) )
		local dmginfo = DamageInfo()
		local attacker = self.Owner
		dmginfo:SetAttacker( attacker )
		dmginfo:SetDamageType(DMG_SHOCK)
		
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 35 * self.Power )
		self.Owner:EmitSound(mCrackle)
		tr.Entity:EmitSound(Trail)
		tr.Entity:EmitSound(Crackle)
		tr.Entity:TakeDamageInfo( dmginfo )
		timer.Create("Hamon"..self.Owner:GetName()..tr.Entity:GetName(), 0.3, 3, function()
			dmginfo:ScaleDamage(0.50) 
			if IsValid(tr.Entity) then
				tr.Entity:TakeDamageInfo( dmginfo )
			end
		end)
	end
	if tr.Hit and !( (tr.Entity:IsPlayer() or tr.Entity:IsNPC() )) then
		self.Owner:EmitSound( GetStandImpactSfx(tr.MatType) )
	end
	if ( SERVER and IsValid(tr.Entity) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 15 * phys:GetMass(), tr.HitPos )
		end
	end
	
	if tr.Entity:IsPlayer() then
		tr.Entity:ViewPunch( Angle( math.random( -3, 3 ), math.random( -3, 3 ), math.random( -3, 3 ) ) )
	end
	
	self.Owner:LagCompensation( false )
end

function SWEP:SecondaryAttack()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )	
	if !self:GetHamon() then
		self:DoTrace()
		if IsValid(self.HPTrace.Entity) then
			self:SpiritTV()
			self:StartAttack()
			timer.Simple(2, function() 
				if IsValid(self) then
					self:EndAttack() 
				end 
			end)
		end
		self:SetNextSecondaryFire( CurTime() + 3 )
		else
		self:EmitSound( SwingSound )
		self:DonutPunch()
		self:SetNextSecondaryFire( CurTime() + 0.5 )
	end
end

function SWEP:DoTrace( endpos )
	local trace = {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 1500),
		filter = { self.Owner, self, self.Beam },
		mask = MASK_SHOT_HULL,
	}
	if endpos then 
		trace.endpos = endpos - self.HPTrace.HitNormal * 7
	end
	if self.Owner:gStandsKeyDown("modifierkey2") then
		trace.endpos = trace.start
		local cmins, cmaxs = self.Owner:GetCollisionBounds()
		cmins.x = cmins.x * 4
		cmins.y = cmins.y * 4
		cmaxs.x = cmaxs.x * 4
		cmaxs.y = cmaxs.y * 4
		trace.mins = cmins
		trace.maxs = cmaxs
		trace.ignoreworld = true
		self.HPTrace = nil
		self.HPTrace = util.TraceHull( trace )
		else
		self.HPTrace = nil
		self.HPTrace = util.TraceLine( trace )
	end
end

function SWEP:StartAttack()
	self:SetLatched( false)
	self:SetInRange( false)
	self:DoTrace()
	if self.HPTrace and self.HPTrace.Hit then
		self:SetInRange( true)
		self.startTime = CurTime()
		self.speed = 5
		self.dat = 5
		if SERVER then
			if (!IsValid(self.Beam) ) then 
				self.Beam = ents.Create( "hermit_purple_trace" )
				self.Beam:SetPos( self.Owner:GetShootPos() )
				self.Beam:Spawn()
			end
			self.Beam:SetParent( self.Owner )
			self.Beam:SetOwner( self.Owner )
			if SERVER and self.Beam then
				self.Beam:SetEndPos( self.HPTrace.HitPos )
				self:SetEndPos(self.HPTrace.HitPos)
			end
		end
		
		local dmginfo = DamageInfo()
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 5 )
		
		if SERVER and IsValid(self.HPTrace.Entity) and (self.HPTrace.Entity:IsPlayer() or self.HPTrace.Entity:IsNPC() or self.HPTrace.Entity:IsStand()) and self.HPTrace.Entity:Health() then
			if self.HPTrace.Entity:IsStand() then
				self.HPTrace.Entity.LastSpeed = self.HPTrace.Entity.Speed
				self.HPTrace.Entity.Speed = self.HPTrace.Entity.Speed/5
			end
			self.Beam:SetHPEntity(self.HPTrace.Entity)
			self:SetLatched(true)
			self.HPTrace.Entity:TakeDamageInfo( dmginfo )
		end
		local phys
		if IsValid(self.HPTrace.Entity) then
			phys = self.HPTrace.Entity:GetPhysicsObject()
		end
		if self:GetHamon() then
			self.Owner:EmitSound(Trail)
		end
		if SERVER and ( IsValid( phys ) and !self.HPTrace.Entity:IsVehicle() and !self.HPTrace.Entity.PhysgunDisabled and self.HPTrace.Entity:GetMoveType() == MOVETYPE_VPHYSICS) and phys:GetMass() <= 800 then
			self.Beam:SetHPEntity(self.HPTrace.Entity)
			self:SetLatched(true)
		end
		
		if self.HPTrace.Entity:IsPlayer() then 
			self.HPTrace.Entity:SetVelocity( -(self.HPTrace.Normal * 500) + Vector( 0, 0, 200 ) )
		end
		if SERVER then
			self.Owner:EmitStandSound(Grapple)
		end
		self:SetHoldType("magic")
	end
	if self:GetInRange() then
		if SERVER then
			self.Owner:EmitStandSound(Grapple)
		end
		self:SetHoldType("magic")
	end
	self:SetEnded( false)
end

function SWEP:UpdateAttack()
	local endpos = self.HPTrace.HitPos
	local vVel = (endpos - self.Owner:GetPos() )
	local Distance = endpos:Distance(self.Owner:GetPos() )
	if self:GetLatched() and (!IsValid(self.HPTrace.Entity) or (self.HPTrace.Entity:IsPlayer() and !self.HPTrace.Entity:Alive() ))then
		self:EndAttack()
		self:SetEnded( true )
	end
	local et = (self.startTime + ( Distance / self.speed) )
	if self.dat != 0 then
		self.dat = (et - CurTime() ) / (et - self.startTime)
	end
	if self.dat < 0 then
		self.dat = 0
	end
	if !self:GetLatched() then
		if SERVER and self.dat < 0.2 and self.dat > 0 and self.Beam then
			self.Beam:EmitStandSound(Whip)
		end
		if self.dat == 0 then
			zVel = self.Owner:GetVelocity().z
			vVel = vVel:GetNormalized() * (math.Clamp(Distance,20,20) )
			if( SERVER ) then
				local gravity = GetConVar("sv_gravity"):GetFloat()
				vVel:Add(Vector( 0, 0, ( gravity / 100) * 1.2 ) )
				self.Owner:SetVelocity(vVel)
				self:SetNormal((self.Owner:GetPos() - endpos):GetNormalized())
			end
		end
		elseif self:GetHamon() then 
		self.HamonGrappleTimer = self.HamonGrappleTimer or CurTime() + 1
		if SERVER and IsValid(self.HPTrace.Entity) and (self.HPTrace.Entity:IsPlayer() or self.HPTrace.Entity:IsNPC() ) and self.HPTrace.Entity:Health() > 0 then
			local dmginfo = DamageInfo()
			
			local attacker = self.Owner
			if ( !IsValid( attacker ) ) then attacker = self end
			dmginfo:SetAttacker( attacker )
			
			dmginfo:SetDamageType(DMG_SHOCK)
			dmginfo:SetInflictor( self )
			self.HPTrace.Entity:EmitSound(mCrackle)
			dmginfo:SetDamage( 1 )
			if IsValid(self.HPTrace.Entity) then
				self.HPTrace.Entity:TakeDamageInfo( dmginfo )
			end
		end
		
	end
	if IsValid(self.HPTrace.Entity) and !self.HPTrace.HitWorld then
		self.HPTrace.HitPos = self.HPTrace.Entity:WorldSpaceCenter()
		if IsValid(self.Beam) then
			self.Beam:SetEndPos(self.HPTrace.Entity:WorldSpaceCenter() )
		end
		if self.HPTrace.Entity:IsVehicle() then
			local a = self.Owner:EyeAngles()
			local b = self.HPTrace.Entity:GetForward():Angle()
			local c = (a - b)
			c:Normalize()
			local d = math.Clamp(math.Remap( (c.y), -90, 90, 1, -1), -1, 1)
			self.HPTrace.Entity:SetSteering(d, 0)
			
			if self.Owner:KeyDown(IN_SPEED) then
				self.HPTrace.Entity:EnableEngine(true)
				self.HPTrace.Entity:StartEngine(true)
				self.HPTrace.Entity:SetBoost(1000)
			end
			if self.Owner:KeyDown(IN_DUCK) then
				self.HPTrace.Entity:SetHandbrake(true)
			end
		end
		local tr = util.TraceLine({
			start = self.Owner:GetShootPos(),
			endpos = self.HPTrace.HitPos,
			filter = { self.HPTrace.Entity, self, self.Owner, self:GetStand(), self.Beam },
		})
		if tr.Hit then
			local dmginfo = DamageInfo()
			
			local attacker = self.Owner
			if ( !IsValid( attacker ) ) then attacker = self end
			dmginfo:SetAttacker( attacker )
			
			dmginfo:SetDamageType(DMG_SHOCK)
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( 1 )
			if IsValid(tr.Entity) then
				tr.Entity:EmitSound(mCrackle)
				tr.Entity:TakeDamageInfo( dmginfo )
			end
		end
	end
	if self:GetLatched() and IsValid(self.HPTrace.Entity) then
		local dist = self.HPTrace.Entity:WorldSpaceCenter():Distance(self.Owner:GetPos() )
		if SERVER and self.dat < 0.2 and self.dat > 0 and IsValid(self.Beam) then
			self.Beam:EmitStandSound(Whip)
		end
		if dist >= self.Range then
			self:EndAttack()
			self:SetEnded(true)
		end
		local phys = self.HPTrace.Entity:GetPhysicsObject()
		if SERVER and ( IsValid( phys ) and !self.HPTrace.Entity:IsVehicle() and !self.HPTrace.Entity.PhysgunDisabled and self.HPTrace.Entity:GetMoveType() == MOVETYPE_VPHYSICS ) then
			if self:GetHamon() then
				local tr = util.TraceEntity({
					start = phys:GetPos(),
					endpos = phys:GetPos(),
					filter = { self.HPTrace.Entity, self, self.Owner, self:GetStand(), self.Beam },
				}, self.HPTrace.Entity)
				local dmginfo = DamageInfo()
				local attacker = self.Owner
				dmginfo:SetAttacker( attacker )
				dmginfo:SetDamageType(DMG_SHOCK)
				dmginfo:SetInflictor( self )
				dmginfo:SetDamage( 15 )
				if IsValid(tr.Entity) then
					self.Owner:EmitSound(Trail)
					tr.Entity:EmitSound(mCrackle)
					tr.Entity:TakeDamageInfo( dmginfo )
				end
			end
			local ShadowParams = {}
			ShadowParams.secondstoarrive = 1 
			if self.Owner:gStandsKeyDown("modifierkey2") then
				self.ShadowPos = self.ShadowPos or phys:GetPos()
				ShadowParams.pos = self.ShadowPos
				else
				self.ShadowPos = nil
				ShadowParams.pos = self.Owner:EyePos() + self.Owner:GetAimVector() * 155
			end
			ShadowParams.angle = self.Owner:EyeAngles()
			ShadowParams.maxangular = 1000
			ShadowParams.maxangulardamp = 10000 
			ShadowParams.maxspeed = 1000
			ShadowParams.maxspeeddamp = 10000
			ShadowParams.dampfactor = 0.1
			ShadowParams.teleportdistance = 0
			ShadowParams.deltatime = FrameTime()
			phys:Wake()
			phys:EnableMotion(true)
			phys:ComputeShadowControl( ShadowParams )
		end
	end
	if Distance > self.Range then
		self:EndAttack()
		self:SetEnded( true)
	end
	self.Owner:LagCompensation( false )
end

function SWEP:EndAttack()
	self.HamonGrappleTimer = nil
	if self.HPTrace and IsValid(self.HPTrace.Entity) then
		local phys = self.HPTrace.Entity:GetPhysicsObject()
		if self.HPTrace.Entity.LastSpeed then
			self.HPTrace.Entity.Speed = self.HPTrace.Entity.LastSpeed
		end
	end
	self:SetHoldType("stando")
	
	if SERVER and IsValid(self.Beam) then
		self.Beam:Remove()
		self.Beam = nil
	end
end

function SWEP:GetMostDangerous(ply)
	local dangply
	local danglevel
	for k, v in pairs(player.GetAll() ) do
		if v != ply then
			local dist = v:Frags()
			if !danglevel then
				danglevel = dist
				dangply = v
			end
			if dist > danglevel then
				dangply = v
			end
		end
	end
	return dangply
end

function SWEP:SpiritTV()
	if SERVER then
		self.Owner:EmitStandSound(SpiritTV)
		self.Owner:EmitStandSound(Flicker)
	end
	for k,v in ipairs(self.HPTrace.Entity:GetMaterials() ) do
		if (v == rtTex or v == "models/rendertarget") or self.HPTrace.Entity:GetSubMaterial(k) == rtTex or self.HPTrace.Entity:GetSubMaterial(k) == "models/rendertarget" or self.HPTrace.Entity:GetMaterial() == "models/rendertarget" then
			if CLIENT then return end
			if #ents.FindByClass( "hermit_purple_camera" ) > 1 then
				for k,v in ipairs(ents.FindByClass( "hermit_purple_camera" ) ) do
					v:Remove()
				end
			end
			local plrdis = nil
			
			local ply = self:GetMostDangerous(self.Owner) or self.Owner
			local pid = ply:UniqueID()
			
			GAMEMODE.RTCameraList = GAMEMODE.RTCameraList or {}
			GAMEMODE.RTCameraList[ pid ] = GAMEMODE.RTCameraList[ pid ] or {}
			local CameraList = GAMEMODE.RTCameraList[ pid ]
			
			local Pos = ply:EyePos() - (self.Owner:GetAimVector() * 200)
			local tr = util.TraceLine({
				start = ply:EyePos(),
				endpos = ply:EyePos() - (Angle(16, -50, 0):Forward() * 200),
				filter = { ply },
			})
			Pos = tr.HitPos
			local camera = ents.Create( "hermit_purple_camera" )
			
			if !IsValid(camera) or !IsValid(ply) then return false end
			
			camera:SetAngles( Angle(16, -50, 0) )
			camera:SetPos( Pos )
			camera:Spawn()
			if SERVER then
				local hooktag = self.Owner:GetName()..camera:EntIndex()
				hook.Add("SetupPlayerVisibility", "HermitPurple2RTVis"..hooktag, function(ply, ent) 
					if IsValid(self) and IsValid(self.Owner) and IsValid(camera) then
						AddOriginToPVS( camera:GetPos() )
						else
						hook.Remove("SetupPlayerVisibility", "HermitPurple2RTVis"..hooktag)
					end
				end)
			end
			camera:SetPlayer( ply )
			
			camera:AddEffects(EF_NODRAW )
			camera:SetMoveType(MOVETYPE_NONE)
			
			key = key or 0
			CameraList[ key ] = camera
			
			
			if !RenderTargetCameraHP or #ents.FindByClass( "hermit_purple_camera" ) >= 1 then HPUpdateRenderTarget( camera ) end
		end
	end
end

function HPUpdateRenderTarget( ent )
	if ( !ent or !IsValid(ent) ) then return end
	if ( !RenderTargetCameraHP or !IsValid(RenderTargetCameraHP) ) then
		RenderTargetCameraHP = ents.Create( "point_camera" )
		RenderTargetCameraHP:SetKeyValue( "GlobalOverride", 1 )
		RenderTargetCameraHP:Spawn()
		RenderTargetCameraHP:Activate()
		RenderTargetCameraHP:Fire( "SetOn", "", 0.0 )
	end
	
	local Pos = ent:LocalToWorld( Vector( 12,0,0 ) )
	RenderTargetCameraHP:SetPos(Pos)
	RenderTargetCameraHP:SetAngles(ent:GetAngles() )
	RenderTargetCameraHP:SetParent(ent)
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
	end
	if CLIENT and self.Aura then
		self.Aura:StopEmission()
		self.Aura = nil
	end
	return true
	
end					 