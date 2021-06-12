--Send file to clients
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot	  = 1
end

SWEP.Power = 1
SWEP.Speed = 2.25
SWEP.Range = A
SWEP.Durability = 1500
SWEP.Precision = nil
SWEP.DevPos = nil

SWEP.Author		= "Copper"
SWEP.Purpose	   = "#gstands.geb.purpose"
SWEP.Instructions  = "#gstands.geb.instructions"
SWEP.Spawnable	 = true
SWEP.Base		  = "weapon_fists"   
SWEP.Category	  = "gStands"
SWEP.PrintName	 = "#gstands.names.geb"

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
SWEP.HitDistance = 74
SWEP.gStands_IsThirdPerson = true

SWEP.StandModel 			= "models/gstands/stands/geb.mdl"
SWEP.StandModelP 			= "models/gstands/stands/geb.mdl"
if CLIENT then
	SWEP.StandModel = "models/player/dbm/dbm.mdl"
end
local PrevHealth = nil

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

local block = Sound("weapons/geb/block.wav")
local boost1 = Sound("weapons/geb/boost1.wav")
local boost2 = Sound("weapons/geb/boost2.wav")
local boost3 = Sound("weapons/geb/boost3.wav")
local boost4 = Sound("weapons/geb/boost4.wav")
local drips1 = Sound("weapons/geb/drips1.wav")
local sdeploy = Sound("weapons/geb/sdeploy.wav")
local stab1 = Sound("weapons/geb/stab1.wav")
local stab2 = Sound("weapons/geb/stab2.wav")
local stab3 = Sound("weapons/geb/stab3.wav")
local thump = Sound("weapons/geb/thump.wav")

local canhear = Sound("weapons/geb/voice/canhear.wav")
local deploy = Sound("weapons/geb/voice/deploy.wav")
local thisisend = Sound("weapons/geb/voice/end.wav")
local laugh1 = Sound("weapons/geb/voice/laugh1.wav")
local laugh2 = Sound("weapons/geb/voice/laugh2.wav")
local laugh3 = Sound("weapons/geb/voice/laugh3.wav")
local pierce = Sound("weapons/geb/voice/pierce.wav")
local shoot = Sound("weapons/geb/voice/shoot.wav")
local surprise = Sound("weapons/geb/voice/surprise.wav")

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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_02"))
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_WALK
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= index + 3
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_slam"))
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_slam"))
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
game.AddParticles("particles/geb.pcf")
PrecacheParticleSystem("dashsplash")

--Define swing and hit sounds. Might change these later.
local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )

function SWEP:Initialize()
	timer.Simple(0.1, function() 
		if self:GetOwner() != nil then
			if self:GetOwner():IsValid() and SERVER then
				self:GetOwner():SetHealth(GetConVar("gstands_geb_heal"):GetInt())
				self:GetOwner():SetMaxHealth(GetConVar("gstands_geb_heal"):GetInt())
			end
		end
	end)
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
	self:NetworkVar("Bool", 0, "State")
	self:NetworkVar("Entity", 1, "Bottle")
end
--Third Person View

local thirdperson_offset = GetConVar("gstands_thirdperson_offset")
function SWEP:CalcView( ply, pos, ang )
if not self.gStands_IsThirdPerson or ply:GetViewEntity() ~= ply then return end	if IsValid(self:GetStand()) and self:GetStand().GetInDoDoDo and self:GetStand():GetInDoDoDo() then
		pos = self:GetStand():GetEyePos() - LocalPlayer():GetAimVector() * 55
	end
	local stand = NULL
	local dist = 100
	if self.GetStand then
		stand = self:GetStand()
	end
	if IsValid(stand) and self:GetState() then
		pos = stand:GetEyePos(true)
		dist = 200
	end
	local convar = thirdperson_offset:GetString()
	local strtab = string.Split(convar, ",")
	local offset = Vector(strtab[1], strtab[2], strtab[3])
	offset:Rotate(ang)

	local trace = util.TraceHull( {
		start = pos,
		endpos = pos - ang:Forward() * dist,
		filter = { ply:GetActiveWeapon(), ply,stand, ply:GetVehicle() },
		mins = Vector( -4, -4, -4 ),
		maxs = Vector( 4, 4, 4 ),
	} )


	if ( trace.Hit ) then pos = trace.HitPos else pos = trace.HitPos end
	return pos + offset,ang
end
function SWEP:DrawHUD()
	if GetConVar("gstands_draw_hud"):GetBool() then
		local color = Color(255,255,255,255)
		local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
		
	end
end
hook.Add( "HUDShouldDraw", "GebHud", function(elem)
    if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_geb" and (((elem == "CHudWeaponSelection" ) and LocalPlayer().SPInZoom) or elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
        return false
    end
end)
--Deploy starts up the stand
function SWEP:Deploy()
	self:SetHoldType( "stando" )
	
	--As is standard with stand addons, set health to 1000
	if self.Owner:Health() == 100  then
		self.Owner:SetMaxHealth( self.Durability )
		self.Owner:SetHealth( self.Durability )
	end
	if SERVER then
		self:SetStand(ents.Create("geb"))
		self.Stand = self:GetStand()
		self.Stand:SetOwner(self.Owner)
		self.Stand:SetPos(self.Owner:GetPos())
		self.Stand:DrawShadow(false)
		self.Stand:Spawn()
		self.Stand:ResetSequence(self.Stand:LookupSequence( "standdeploy" ))
		self.Stand.CurrentAnim = "standdeploy"
		timer.Simple(self.Stand:SequenceDuration(), function() 
		if IsValid(self.Stand) then
			self.Stand:ResetSequence(self.Stand:LookupSequence( "standidle" ))
			self.Stand.CurrentAnim = "standidle"
		end
		end)
	end
	--Create some networked variables, solves some issues where multiple people had the same stand
	self.Owner:SetCanZoom(false)
	if SERVER and GetConVar("gstands_deploy_sounds"):GetBool() then
		self.Owner:EmitSound(deploy)
		self.Owner:EmitStandSound(sdeploy)
		self.Owner:EmitStandSound(drips1)
	end
end
local soundtable = {}
local datatable = {
	data = {},
	timer = 0
}
if SERVER then
util.AddNetworkString("Geb.SoundData")
end
hook.Add("EntityEmitSound", "GebCatchSounds", function(data)
	if CLIENT then
		local owner = LocalPlayer()
		datatable.data = data
		datatable.timer = CurTime() + 5 * data.Volume
		table.insert(soundtable, table.Copy(datatable))
	end
	if SERVER then
		net.Start("Geb.SoundData")
		net.WriteTable(data)
		net.Broadcast()
	end
end)
if CLIENT then
for i=0, 2048 do
	soundtable[i] = nil
end
net.Receive("Geb.SoundData", function()
	local data = net.ReadTable()
	datatable.data = data
	datatable.timer = CurTime() + 5 * data.Volume
	table.insert(soundtable, table.Copy(datatable))
end)
local mat = Material("effects/gstands_aura2.vmt")
local hideaway = true
hook.Add("RenderScene", "SoundSightGeb", function(isDrawingDepth, isDrawingSkybox)
	local owner = LocalPlayer()
	if hideaway then
		if owner:HasWeapon("gstands_geb") and owner:GetActiveWeapon():GetClass() == "gstands_geb" then
			local self = owner:GetActiveWeapon()
			if self:GetState() then
				for k,v in pairs(ents.GetAll()) do
					v.Geb_LastDraw = v.Geb_LastDraw or {v:GetNoDraw()}
					if v:GetRenderGroup() ~= RENDERGROUP_STATIC and v:GetRenderGroup() ~= RENDERGROUP_OPAQUE_BRUSH and not v:GetNoDraw() then
						v:SetNoDraw(true)
					end
				end
			end
		end
	end
end)
local cover = Material("planetcover.vmt")
local showz = Material("debug/showz.vmt")
local blur_mat = Material( "pp/bokehblur" )
	hook.Add("PreDrawEffects","SoundSightGeb",function()
	local owner = LocalPlayer()
	hideaway = false
	for k,v in pairs(ents.GetAll()) do
		if v.Geb_LastDraw then
			v:SetNoDraw(v.Geb_LastDraw[1])
			v.Geb_LastDraw = nil
		end
	end
	if owner:HasWeapon("gstands_geb") and owner:GetActiveWeapon():GetClass() == "gstands_geb" then
		local self = owner:GetActiveWeapon()
		if self:GetState() then
		local darken = {
						["$pp_colour_addr"] 		= 0.5,
						["$pp_colour_addg"] 		= 0,
						["$pp_colour_addb"] 		= 0.9,
						["$pp_colour_brightness"] 	= -0.65,
						["$pp_colour_contrast"] 	= .4,
						["$pp_colour_colour"] 		= 0,
						["$pp_colour_mulr"] 		= 1,
						["$pp_colour_mulg"] 		= 0.1,
						["$pp_colour_mulb"] 		= 1,
					}  
					
					render.SetBlend(1)

					render.UpdateScreenEffectTexture()

					blur_mat:SetTexture( "$BASETEXTURE", render.GetScreenEffectTexture() )
					blur_mat:SetTexture( "$DEPTHTEXTURE", render.GetResolvedFullFrameDepth() )

					blur_mat:SetFloat( "$size", 155 )
					blur_mat:SetFloat( "$focus", 0.1 )
					blur_mat:SetFloat( "$focusradius", 1 )

					render.SetMaterial( blur_mat )
					render.DrawScreenQuad()
					for _,v in ipairs(ents.GetAll()) do
						v:SetNoDraw(false)
						if (v:GetRenderGroup() == RENDERGROUP_BOTH or v:GetRenderGroup() == RENDERGROUP_OPAQUE or v:GetRenderGroup() == RENDERGROUP_TRANSLUCENT) and v.Geb_Visible and CurTime() < v.Geb_Visible then
							local blend = (v.Geb_Visible - CurTime())
							render.SetBlend(blend)
							if v.DrawTranslucent then
							v:DrawTranslucent()
							else
							v:DrawModel()
							end
							render.SetBlend(1)
						end
						v:SetNoDraw(prevNoDraw)
					end
					render.OverrideBlend( true, BLEND_SRC_COLOR, BLEND_SRC_ALPHA, BLENDFUNC_SUBTRACT,  BLEND_ONE, BLEND_ZERO, BLENDFUNC_ADD )
					DrawColorModify(darken)
					render.OverrideBlend( false )


		self:GetStand():SetNoDraw(false)
		cam.IgnoreZ(true)
		local w,h = ScrW(),ScrH()
		for k,v in pairs(soundtable) do
			if v.timer then
				if CurTime() < v.timer then
					local pos = Vector()
					if v.data.Pos then
						pos = v.data.Pos
					end
					if (not pos or pos == Vector()) and IsValid(v.data.Entity) then
						pos = v.data.Entity:GetPos()
					end
					render.SetMaterial(mat)
					local mult = (v.timer - CurTime())/5
					render.DrawSprite(pos, 50 * mult, 50 * mult, Color(255,0,255))
					if IsValid(v.data.Entity) and v.data.Entity:Health() > 0 then
						v.data.Entity.Geb_Visible = v.data.Entity.Geb_Visible or CurTime()
						v.data.Entity.Geb_Visible = CurTime() + 1
					end
				end
			end
		end
		cam.IgnoreZ(false)
		
		self:GetStand():DrawTranslucent()
		--DrawMotionBlur(0.5, 1, 0.015)
	end
	end
	hideaway = true
end)
end
function SWEP:Think()
	self.Stand = self:GetStand()
	if SERVER and !self.Stand:IsValid() then
		self:SetStand(ents.Create("geb"))
		self.Stand = self:GetStand()
		self.Stand:SetOwner(self.Owner)
		self.Stand:SetPos(self.Owner:GetPos())
		self.Stand:DrawShadow(false)
		self.Stand:Spawn()
	end
	if self:GetState() then
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
	
	if self.Owner:KeyDown(IN_JUMP) then
		
		for k,v in pairs(ents.FindInCone(self.Stand:WorldSpaceCenter(), Vector(0,0,1), 1000, .404)) do
			local tr = util.TraceLine({
				start = self.Stand:WorldSpaceCenter() + Vector(0,0,35),
				endpos = v:WorldSpaceCenter() + (VectorRand() * 55),
				filter = {self.Owner, self.Stand}
			})
			if tr.Hit then
				local data = {
					Pos = tr.HitPos
				}
				if IsValid(tr.Entity) and not tr.HitWorld then
					data.Entity = tr.Entity
				end
				datatable.data = data
				datatable.timer = CurTime() + 5
				table.insert(soundtable, table.Copy(datatable))
			end
		end
	end
	
	if not IsValid(self:GetBottle()) then
		if self.Owner:gStandsKeyDown("standleap") and not self:GetStand():GetInJump() and self:GetState() then
			self:GetStand():SetInJump(true)
			self:GetStand():Jump()
		end
		--Mode changing
		self.Delay = self.Delay or CurTime()
		if SERVER and self.Owner:gStandsKeyDown("dododo") and CurTime() > self.Delay then
			self.Delay = CurTime() + 1
			self:SetState(!self:GetState())
			if self:GetState() then
				if SERVER then
					self.Owner:AddFlags(FL_ATCONTROLS)
					self.Owner:EmitSound(canhear)
				end
				if SERVER then
					hook.Add("SetupPlayerVisibility", "gebnocullbreak"..self.Owner:GetName(), function(ply, ent) 
						if self:IsValid() and self.Owner:IsValid() and self.Stand:IsValid() then
							AddOriginToPVS( self.Stand:GetPos() + Vector(0,0,50) )
						end
					end)
				end
				else
				if SERVER then
					hook.Remove("SetupPlayerVisibility", "gebnocullbreak"..self.Owner:GetName())
					self.Owner:SetMoveType(MOVETYPE_WALK)
					self.Owner:RemoveFlags(FL_ATCONTROLS)
				end
			end
		end
		self.StandBlockTimer = self.StandBlockTimer or CurTime()
		
		if SERVER and self.Owner:gStandsKeyDown("block") and CurTime() > self.StandBlockTimer then
			self.Stand:EmitStandSound(block)
			self.Stand.CurrentAnim = "standblock"
			self.Stand:ResetSequenceInfo()  
			self.Stand:ResetSequence( self.Stand:LookupSequence("standblock") )  
			self.Stand:SetCycle(0)  
			self.Owner:EmitSound(surprise)
			
			timer.Simple(self.Stand:SequenceDuration("standblock"), function() self.Stand.CurrentAnim = "standidle" end)

			self.StandBlockTimer = CurTime() + self.Stand:SequenceDuration("standblock") + 0.5
		end
		

		if SERVER and not self.Owner:gStandsKeyDown("modifierkey1") and self.Stand.CurrentAnim ~= "sinkhole"  and self.Owner:KeyDown(IN_RELOAD) then
		self.Stand.CurrentAnim = "sinkhole"
		self.Stand:ResetSequence( self.Stand:LookupSequence("sinkhole") )  
		self.Owner:EmitSound("geb.laugh")
		end
		if SERVER and self.Owner:KeyReleased(IN_RELOAD) and self.Stand.CurrentAnim == "sinkhole" then
		self.Stand.CurrentAnim = "standidle"
		self.Stand:ResetSequence( self.Stand:LookupSequence("standidle") )  
		end
		self.PierceSoundTimer = self.PierceSoundTimer or CurTime()
		if SERVER and CurTime() > self.PierceSoundTimer and self:GetState() and self.Owner:KeyDown(IN_SPEED) and self.Owner:KeyPressed(IN_JUMP) then
			self.PierceSoundTimer = CurTime() + 1
			self.Owner:EmitSound(pierce)
		end
	end
end


function SWEP:PrimaryAttack()
	if SERVER and not IsValid(self:GetBottle()) then
		self:SetNextPrimaryFire( CurTime() + 1 )
		self.Stand.CurrentAnim = "slash"
		self.Owner:EmitSound(thisisend)
		self.Stand:EmitStandSound(stab1)
		self.Stand:ResetSequenceInfo()  
		
		self.Stand:ResetSequence( self.Stand:LookupSequence("slash") )  
		self.Stand:SetCycle(0)  
		
		timer.Simple(0.8, function() 
			if IsValid(self.Stand) then
				self.Stand:ResetSequence( self.Stand:LookupSequence("standidle") )  
				self.Stand.CurrentAnim = "standidle" 
			end
		end)
	end
end
		
function SWEP:SecondaryAttack()
	if SERVER and not IsValid(self:GetBottle()) then
		self.Owner:EmitSound(shoot)
		self.Stand:EmitStandSound(boost4)
		self.Stand:EmitStandSound(drips1)
		self:SetNextSecondaryFire( CurTime() + self.Stand:SequenceDuration(self.Stand:LookupSequence("slash")) + 0.5 )
		
		self.Stand.CurrentAnim = "slice"
		self.Stand:ResetSequenceInfo() 
		self.Stand:ResetSequence( self.Stand:LookupSequence("slash") )  
		self.Stand:SetCycle(0)  
		timer.Simple(self.Stand:SequenceDuration(self.Stand:LookupSequence("slash")), function()
			if IsValid(self.Stand) then
				self.Stand:ResetSequence( self.Stand:LookupSequence("standidle") )  
				self.Stand.CurrentAnim = "standidle" 
			end
		end)
	end
end
local bottles = {
	["models/props_junk/garbage_coffeemug001a.mdl"] = true,
	["models/props_junk/garbage_glassbottle001a.mdl"] = true,
	["models/props_junk/garbage_glassbottle002a.mdl"] = true,
	["models/props_junk/garbage_glassbottle003a.mdl"] = true,
	["models/props_junk/garbage_milkcarton001a.mdl"] = true,
	["models/props_junk/garbage_milkcarton002a.mdl"] = true,
	["models/props_junk/garbage_plasticbottle001a.mdl"] = true,
	["models/props_junk/garbage_plasticbottle002a.mdl"] = true,
	["models/props_junk/garbage_plasticbottle003a.mdl"] = true,
	["models/props_junk/gascan001a.mdl"] = true,
	["models/props_junk/GlassBottle01a.mdl"] = true,
	["models/props_junk/glassjug01.mdl"] = true,
	["models/props_junk/PopCan01a.mdl"] = true
}

hook.Add("PlayerUse", "gStands_SharpDrink", function(ply, ent)
	if IsValid(ent.HasGeb) then
		local geb = ent.HasGeb
		ent:Fire( "Break" )
		local dmginfo = DamageInfo()

        local attacker = geb.Owner
        if ( not IsValid( attacker ) ) then attacker = geb.Owner end
        dmginfo:SetAttacker( attacker )

        dmginfo:SetInflictor( geb )

		dmginfo:SetDamage( 100 )
        dmginfo:SetDamageType(DMG_SLASH)
        ply:TakeDamageInfo( dmginfo )
		
	end
end)

hook.Add("EntityTakeDamage", "gStands_OilFloatsOnWater", function(ent, dmg)
	if dmg:GetInflictor():GetClass() == "geb" or dmg:GetInflictor():GetClass() == "gstands_geb" then
		if ent:IsPlayer() and ent:GetWeapon("inoil").WithOil then
			dmg:GetAttacker():ChatPrint("#gstands.geb.oil")
			return true
		end
	end
end)

function SWEP:Reload()
	self.HideTimer = self.HideTimer or CurTime()
	if SERVER and self:GetState() and CurTime() > self.HideTimer and self.Owner:KeyDown(IN_SPEED) then
		if not IsValid(self:GetBottle()) then
			local pos = self.Stand:GetPos()
			local mins, maxs = self.Stand:GetCollisionBounds()
			local tr = util.TraceHull({
				start = pos,
				endpos = pos,
				mins = mins,
				maxs = maxs,
				filter = function(ent) return bottles[ent:GetModel()] and not IsValid(ent.HasGeb) end,
				ignoreworld = true
			})
			if IsValid(tr.Entity) and bottles[tr.Entity:GetModel()] then
				self:SetBottle(tr.Entity)
				self.Stand:EmitStandSound(sdeploy)
				tr.Entity.HasGeb = self.Stand
			end
		else
			self:GetBottle().HasGeb = nil
			self:SetBottle(nil)
			self.Stand:EmitStandSound(sdeploy)
		end
		self.HideTimer = CurTime() + 1
	end
end

--Screw this entire section, it only works like 20% of the time. Basically, meant to catch every time the weapon is not in your hands in order to remove the stand.
function SWEP:OnDrop()
	if SERVER and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	if self:GetState() then
		self.Owner:SetJumpPower(200)
		hook.Remove("SetupPlayerVisibility", "gebnocullbreak"..self.Owner:GetName())
			self.Owner:SetMoveType(MOVETYPE_WALK)
			self.Owner:RemoveFlags(FL_ATCONTROLS)
			self.Owner:SetDSP(1)
	end
	return true
end

function SWEP:OnRemove()

	if self:GetState() then
		self.Owner:SetJumpPower(200)
		hook.Remove("SetupPlayerVisibility", "gebnocullbreak"..self.Owner:GetName())
			self.Owner:SetMoveType(MOVETYPE_WALK)
			self.Owner:RemoveFlags(FL_ATCONTROLS)
			self.Owner:SetDSP(1)
	end
	return true
end

function SWEP:Holster()
	if SERVER and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	if self:GetState() then
		self.Owner:SetJumpPower(200)
		hook.Remove("SetupPlayerVisibility", "gebnocullbreak"..self.Owner:GetName())
			self.Owner:SetMoveType(MOVETYPE_WALK)
			self.Owner:RemoveFlags(FL_ATCONTROLS)
			self.Owner:SetDSP(1)
			self:SetState(false)
	end
	return true
end