--Send file to clients
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot	  = 1
end

SWEP.Power = 2.5
SWEP.Speed = 0.5
SWEP.Range = 250
SWEP.Durability = 800
SWEP.Precision = A
SWEP.DevPos = A

SWEP.Author		= "Copper"
SWEP.Purpose	   = "#gstands.fool.purpose"
SWEP.Instructions  = "#gstands.fool.instructions"
SWEP.Spawnable	 = true
SWEP.Base		  = "weapon_fists"   
SWEP.Category	  = "gStands"
SWEP.PrintName	 = "#gstands.names.fool"
SWEP.ScriptedEntityType	 = "gStands"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos			= 2
SWEP.DrawCrosshair	  = true

SWEP.WorldModel = "models/player/whitesnake/disc.mdl"
SWEP.ViewModelFOV   = 54
SWEP.UseHands	   = true

SWEP.Primary.ClipSize	   = -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic	  = true
SWEP.Primary.Ammo		   = "none"

SWEP.Secondary.ClipSize	 = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo		 = "none"

SWEP.DrawAmmo	   = false
SWEP.CanZoom		= false
SWEP.HitDistance	= 48
SWEP.ArmorSpeed	 = 0.02
SWEP.Armor		  = true

SWEP.RushLoop	   = nil
SWEP.StandModel = "models/gstands/stands/thefool.mdl"
SWEP.StandModelP = "models/gstands/stands/thefool.mdl"
SWEP.gStands_IsThirdPerson = true

--Define swing and hit sounds. Might change these later.
--local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )
local Deploy = Sound("weapons/fool/deploy.wav")
local SDeploy = Sound("weapons/fool/Sdeploy.wav")
local SwooshDunk = Sound("weapons/fool/swoosh/swooshdunk.wav")
local SwooshDetail = Sound("weapons/fool/swoosh/swooshdetail.wav")
local SwooshLong = Sound("weapons/fool/swoosh/swooshlong.wav")
local SwooshDeep = Sound("weapons/fool/swoosh/deepswoosh.wav")
local Swoosh = Sound("weapons/fool/swoosh/swoosh.wav")
local DemonScreech = Sound("weapons/fool/voicelines/demon.wav")
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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("idle_all_angry"))
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE_SLAM + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_01"))
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_becon"))
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("gesture_becon"))
		self.ActivityTranslate[ ACT_MP_JUMP ]						= ACT_HL2MP_IDLE_DUEL + 7
		self.ActivityTranslate[ ACT_RANGE_ATTACK1 ]					= index + 8
		self.ActivityTranslate[ ACT_MP_SWIM ]						= ACT_HL2MP_IDLE_DUEL + 9
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
	timer.Simple(0.1, function() 
		if self:GetOwner() != nil then
			if self:GetOwner():IsValid() and SERVER then
				self:GetOwner():SetHealth(GetConVar("gstands_the_fool_heal"):GetInt())
				self:GetOwner():SetMaxHealth(GetConVar("gstands_the_fool_heal"):GetInt())
			end
		end
	end)
	if CLIENT then
	end
	self:DrawShadow(false)
end

function SWEP:DrawWorldModel()
	if IsValid(self.Owner) then
		return false
		else
		self:DrawModel()
	end
end
function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Stand")
	self:NetworkVar("Bool", 0, "AMode")
	self:NetworkVar("Bool", 1, "InRange")
	self:NetworkVar("Float", 1, "Delay2")
	self:NetworkVar("Bool", 2, "Ended")
end
local thirdperson_offset = GetConVar("gstands_thirdperson_offset")
function SWEP:CalcView( ply, pos, ang )
if not self.gStands_IsThirdPerson or ply:GetViewEntity() ~= ply then return end	if IsValid(self:GetStand()) and self:GetStand().GetInDoDoDo and self:GetStand():GetInDoDoDo() then
		pos = self:GetStand():GetEyePos() - LocalPlayer():GetAimVector() * 55
	end
	local convar = thirdperson_offset:GetString()
	local strtab = string.Split(convar, ",")
	local offset = Vector(strtab[1], strtab[2], strtab[3])
	offset:Rotate(ang)

	local stand = self:GetStand()
	local trace = util.TraceHull( {
		start = pos,
		endpos = pos - ang:Forward() * 100,
		filter = { ply:GetActiveWeapon(), ply, ply:GetVehicle(), stand},
		mins = Vector( -4, -4, -4 ),
		maxs = Vector( 4, 4, 4 ),
	} )


	if ( trace.Hit ) then pos = trace.HitPos else pos = trace.HitPos end
	return pos + offset,ang
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
	if GetConVar("gstands_draw_hud"):GetBool() and IsValid(self.Stand) then
		local color = gStands.GetStandColorTable(self.Stand:GetModel(), self.Stand:GetSkin())
		local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
	end
end
hook.Add( "HUDShouldDraw", "FoolHud", function(elem)
		if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_fool" and (elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
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
			timer.Simple(0.4, function() if IsValid(self) and IsValid(self.Stand) then self.Owner:EmitSound(Deploy) end end)
			self.Stand:EmitSound(SDeploy)
			self.Stand:EmitSound(SwooshDeep)
		end
	end
end
--Creates stand and adds attributes to the stand.
function SWEP:DefineStand()
	if SERVER then
		self:SetStand( ents.Create("fool_stand"))
		self.Stand = self:GetStand()
		self.Stand:SetOwner(self.Owner)
		self.Stand:SetModel(self.StandModel)
		self.Stand:SetBodygroup(1, 0)
		self.Stand:SetMoveType( MOVETYPE_NOCLIP )
		self.Stand:SetAngles(self.Owner:GetAngles())
		self.Stand:SetPos(self.Owner:GetBonePosition(0)+Vector(0, 0, 0))
		self.Stand:DrawShadow(false)
		self.Stand.Color = Color(150,150,150,1)
		self.Stand:Spawn()
		self.Stand:ResetSequence(self.Stand:LookupSequence( "standdeploy" ))
		self.Stand.Range = self.Range
		self.Stand.POWER = self.Power
		self.Stand.Speed = 20*self.Speed
	end
end

function SWEP:Think()  
	self.Stand = self:GetStand()
	local slf = self.Stand
	if !self.Owner:KeyDown(IN_JUMP) and self.Stand:IsValid() then
		self.Stand:SetBodygroup(1,0)
	end

	if !self.Stand:IsValid() then
		self:DefineStand()
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
	
	if SERVER and self.Owner:gStandsKeyDown("block") then
		self.DomeSwapTimer = self.DomeSwapTimer or CurTime()
		if IsValid(self:GetStand()) and CurTime() > self.DomeSwapTimer then
			if not self.Stand.DomeMode then
				self.Stand:DomeModeEnable()
				else
				self.Stand:DomeModeDisable()
			end
			self.DomeSwapTimer = CurTime() + 1
		end
	end
	
	--Mode changing
	-- self.Delay = self.Delay or CurTime()
	-- if self.Owner:gStandsKeyDown("modeswap") and CurTime() > self.Delay then
		-- --Delay the change, can't have it flip too fast
		-- self.Delay = CurTime() + 1
		-- local tr = util.TraceHull( {
			-- start = self.Stand:GetEyePos(),
			-- endpos = self.Stand:GetEyePos() + self.Stand:GetForward() * 128,
			-- filter = {self.Stand },
			-- mins = Vector( -5, -5, -8 ), 
			-- maxs = Vector( 15, 15, 8 ),
			-- mask = MASK_SHOT_HULL, 
			
		-- } )
		-- if SERVER and tr.Entity:IsValid() and (tr.Entity != self.Dome or !self.Dome:IsValid()) and tr.Entity:GetModel() != self.Stand:GetModel() then
			-- self.Stand:SetModel(tr.Entity:GetModel())
			-- self.Stand:SetSkin(tr.Entity:GetSkin())
			-- self.Stand:SetSequence(tr.Entity:GetSequence())
			-- self.Stand:SetColor(tr.Entity:GetColor())
			-- self.Stand:SetModelScale(tr.Entity:GetModelScale())
			-- if self.Dome:IsValid() then
				-- self.Dome:Remove()
				-- self.Stand:SetSolid( SOLID_OBB )
			-- end
			-- self.Stand:SetNoDraw(false)
			
			-- elseif SERVER then
			-- self.Stand:SetModel(self.StandModel)
			-- self.Stand:SetModelScale(1)
			-- self.Stand:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			-- if self.Dome and self.Dome:IsValid() then
				-- self.Dome:Remove()
				-- self.Stand:SetSolid( SOLID_OBB )
			-- end
			
			-- self.Stand:SetMoveType(MOVETYPE_NOCLIP)
			-- self.Stand:SetNoDraw(false)
			
			
		-- end
	-- end
end

function SWEP:PrimaryAttack()
	--Check the mode. Is it ability mode?
	--Punch mode 
	if SERVER and not self.Stand.DomeMode and self.Stand:GetSequence() != self.Stand:LookupSequence("slashleft") then
		self.Stand:ResetSequence(self.Stand:LookupSequence("slashleft"))
		self.Stand:SetCycle(0)
		self:SetHoldType("pistol")
		self:GetStand():EmitStandSound(SwooshDunk)
		timer.Simple(1, function()
			if IsValid(self) and IsValid(self.Stand) then
				self:SetHoldType("stando")
			end
		end)
		timer.Simple(0.2, function()
			if IsValid(self) and IsValid(self.Stand) then
				self.Stand:Slash()
			end
		end)
		timer.Simple(0.25, function()
			if IsValid(self) and IsValid(self.Stand) then
				self.Stand:Slash()
			end
		end)
		timer.Simple(0.4, function()
			if IsValid(self) and IsValid(self.Stand) then
				self.Stand:Slash()
			end
		end)
		self:SetNextPrimaryFire( CurTime() + 0.5)

	end
	if SERVER and not self.Stand.DomeMode and self.Owner:gStandsKeyDown("modifierkey1") then
		local whip = ents.Create("sandwave")
		whip:SetPos( self:GetStand():GetPos() )
		whip:SetOwner(self.Owner)
		whip:Spawn()
		self:SetNextPrimaryFire( CurTime() + 5 )
	end
	if SERVER and self.Stand.DomeMode then
		local aim = self.Owner:GetAimVector()
		local dot1 = aim:Dot(self.Stand:GetForward())
		local dot2 = aim:Dot(-self.Stand:GetRight())
		local dot3 = aim:Dot(self.Stand:GetRight())
		if dot1 > dot2 and dot1 > dot3 then
			self.Stand:ResetSequence(self.Stand:LookupSequence("smack_both"))
			local tr = util.TraceHull({
				start=self.Stand:GetPos() + self.Stand:GetUp() * 25 - self.Stand:GetRight() * 150,
				endpos=self.Stand:GetPos() + self.Stand:GetUp() * 25 + self.Stand:GetRight() * 150,
				mins=-Vector(100,100,100),
				maxs=Vector(100,100,100),
				filter={self.Owner, self.Stand},
				ignoreworld=true,
				mask=MASK_ALL
			})
			if IsValid(tr.Entity) then
				local dmginfo = DamageInfo()
				
				local attacker = self.Owner
				if ( !IsValid( attacker ) ) then attacker = self.Owner end
				dmginfo:SetAttacker( attacker )
				
				dmginfo:SetInflictor( self.Owner:GetActiveWeapon() or self )
				dmginfo:SetDamage(GetConVar("gstands_the_fool_dome_punch"):GetInt())
				tr.Entity:TakeDamageInfo( dmginfo )
				
				tr.Entity:SetVelocity( (self.Owner:GetAimVector() + Vector( 0, 0, 5 )) * 355)
				local phys = tr.Entity:GetPhysicsObject()
				if ( IsValid( phys ) ) then
					phys:ApplyForceOffset( self.Owner:GetAimVector() * 1800 * phys:GetMass(), tr.HitPos )
				end
			end
		end
		if dot2 > dot1 and dot2 > dot3 then
			self.Stand:ResetSequence(self.Stand:LookupSequence("smack_left"))
			local tr = util.TraceHull({
				start=self.Stand:GetPos() - self.Stand:GetRight() * 95,
				endpos=self.Stand:GetPos() + self.Stand:GetUp() * 25 - self.Stand:GetRight() * 150,
				mins=-Vector(100,100,100),
				maxs=Vector(100,100,100),
				filter={self.Owner, self.Stand},
				ignoreworld=true,
				mask=MASK_ALL
			})
			if IsValid(tr.Entity) then
				local dmginfo = DamageInfo()
				
				local attacker = self.Owner
				if ( !IsValid( attacker ) ) then attacker = self.Owner end
				dmginfo:SetAttacker( attacker )
				
				dmginfo:SetInflictor( self.Owner:GetActiveWeapon() or self )
				dmginfo:SetDamage(GetConVar("gstands_the_fool_dome_punch"):GetInt())
				tr.Entity:TakeDamageInfo( dmginfo )
				
				tr.Entity:SetVelocity( (self.Owner:GetAimVector() + Vector( 0, 0, 5 )) * 425)
				local phys = tr.Entity:GetPhysicsObject()
				if ( IsValid( phys ) ) then
					phys:ApplyForceOffset( self.Owner:GetAimVector() * 1800 * phys:GetMass(), tr.HitPos )
				end
			end
		end
		if dot3 > dot2 and dot3 > dot1 then
			self.Stand:ResetSequence(self.Stand:LookupSequence("smack_right"))
			local tr = util.TraceHull({
				start=self.Stand:GetPos() + self.Stand:GetRight() * 95,
				endpos=self.Stand:GetPos() + self.Stand:GetUp() * 25 + self.Stand:GetRight() * 150,
				mins=-Vector(100,100,100),
				maxs=Vector(100,100,100),
				filter={self.Owner, self.Stand},
				ignoreworld=true,
				mask=MASK_ALL
			})
			if IsValid(tr.Entity) then
				local dmginfo = DamageInfo()
				
				local attacker = self.Owner
				if ( !IsValid( attacker ) ) then attacker = self.Owner end
				dmginfo:SetAttacker( attacker )
				
				dmginfo:SetInflictor( self.Owner:GetActiveWeapon() or self )
				dmginfo:SetDamage(GetConVar("gstands_the_fool_dome_punch"):GetInt())
				tr.Entity:TakeDamageInfo( dmginfo )
				
				tr.Entity:SetVelocity( (self.Owner:GetAimVector() + Vector( 0, 0, 5 )) * 425)
				local phys = tr.Entity:GetPhysicsObject()
				if ( IsValid( phys ) ) then
					phys:ApplyForceOffset( self.Owner:GetAimVector() * 1800 * phys:GetMass(), tr.HitPos )
				end
			end
		end
		self.Stand:SetCycle(0)
		self:GetStand():EmitStandSound(SwooshDetail)
		
		self:SetNextPrimaryFire( CurTime() + 1 )
	end
	--Miniscule delay
end

function SWEP:SecondaryAttack()
	--Ability mode
	if SERVER and not self.Stand.DomeMode then
		if not self.Owner:gStandsKeyDown("modifierkey1") and self.Stand:GetSequence() != self.Stand:LookupSequence("pounce") then
			self.Stand:ResetSequence(self.Stand:LookupSequence("pounce"))
			self.Stand:SetCycle(0)
			self:SetHoldType("pistol")
			self:GetStand():EmitStandSound(SwooshDetail)
			self:GetStand():EmitStandSound(DemonScreech)

			timer.Simple(self.Stand:SequenceDuration() + 0.1, function()
				if IsValid(self) and IsValid(self.Stand) then
					self:SetHoldType("stando")
				end
			end)
			timer.Simple(0.2, function()
				if IsValid(self) and IsValid(self.Stand) then
					self.Stand:Slash(5)
				end
			end)
			timer.Simple(0.3, function()
				if IsValid(self) and IsValid(self.Stand) then
					self.Stand:Slash(5)
				end
			end)
			timer.Simple(0.4, function()
				if IsValid(self) and IsValid(self.Stand) then
					self.Stand:Slash(5)
				end
			end)
			timer.Simple(0.5, function()
				if IsValid(self) and IsValid(self.Stand) then
					self.Stand:Slash(5)
				end
			end)
			timer.Simple(0.6, function()
				if IsValid(self) and IsValid(self.Stand) then
					self.Stand:Slash(5)
				end
			end)
			timer.Simple(0.7, function()
				if IsValid(self) and IsValid(self.Stand) then
					self.Stand:Slash(5)
				end
			end)
			
		end
		if self.Owner:gStandsKeyDown("modifierkey1") then
			local tr = util.TraceLine({
				start=self.Owner:GetPos(),
				endpos=self.Owner:GetPos() - Vector(0,0,55),
				mask = MASK_SOLID_BRUSHONLY,
			})
			if tr.HitWorld then
				if SERVER then
					local sand = ents.Create("sandmove")
					sand:SetPos( tr.HitPos )
					sand:SetOwner(self.Owner)
					sand:Spawn()
					self.Owner:EmitSound(SwooshDetail)
				end
			end
		end
	end
	--No spamming the donut punch.
	self:SetNextSecondaryFire( CurTime() + 1 )
end

function SWEP:DonutPunch()
	
	--Most of this is from the default fists swep, sped up and adapted to fit high speed stand rushes.
	local anim = self.Owner:GetSequenceName(self.Owner:GetSequence())
	self.Owner:LagCompensation( true )
	local tr
	tr = util.TraceHull( {
		start = self.Stand:GetBonePosition(self.Stand:LookupBone("Hand_L")),
		endpos = self.Stand:GetBonePosition(self.Stand:LookupBone("Hand_L")) + self.Owner:GetAimVector() * self.HitDistance,
		filter = {self.Owner, self.Stand },
		mins = Vector( -5, -5, -8 ), 
		maxs = Vector( 15, 15, 8 ),
		mask = MASK_SHOT_HULL, 
		
	} )
	
	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self.Owner:EmitSound( HitSound )
	end
	
	local hit = false
	if SERVER and tr.Entity:IsValid() and !tr.Entity:IsNPC() and tr.Entity:GetKeyValues()["health"] > 0 then tr.Entity:SetKeyValue("explosion", "2") tr.Entity:SetKeyValue("gibdir", tostring(self.Stand:GetAngles())) tr.Entity:Fire("Break") end
	
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 )) then
		local dmginfo = DamageInfo()
		
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self.Owner end
		dmginfo:SetAttacker( attacker )
		
		dmginfo:SetInflictor( self.Owner )
		--High damage, but not quite enough to kill.
		dmginfo:SetDamage( 25 * self.Power )
		dmginfo:SetDamageType(DMG_SLASH)
		tr.Entity:TakeDamageInfo( dmginfo )
		--Fllllling your enemies.
		if !self.Owner.IsKnockedOut then
			tr.Entity:SetVelocity( self.Owner:GetAimVector() * 100 + Vector( 0, 0, 100 ) )
		end
		hit = true
		
	end
	
	if tr.Entity:IsPlayer() and !self.Owner.IsKnockedOut then
		tr.Entity:ViewPunch( Angle( math.random( -10, 10 ), math.random( -10, 10 ), math.random( -10, 10 ) ) )
	end
	
	if ( SERVER && IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 800 * phys:GetMass(), tr.HitPos )
		end
	end
	
	self.Owner:LagCompensation( false )
	
end

function SWEP:Reload()
	
end

--Screw this entire section, it only works like 20% of the time. Basically, meant to catch every time the weapon is not in your hands in order to remove the stand.
function SWEP:OnDrop()
	if SERVER and self.Owner and self.Stand:IsValid() then
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