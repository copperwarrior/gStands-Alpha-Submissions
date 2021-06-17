--Send file to clients
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot      = 1
end

SWEP.Power = 1
SWEP.Speed = 2.25
SWEP.Range = A
SWEP.Durability = 1500
SWEP.Precision = nil
SWEP.DevPos = nil

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.d13.purpose"
SWEP.Instructions  = "#gstands.d13.instructions"
SWEP.Spawnable     = true
SWEP.AdminSpawnable = false
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.d13"

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
SWEP.HitDistance = 74

SWEP.StandModel = "models/d13/d13.mdl"
SWEP.StandModelP = "models/d13/d13.mdl"
if CLIENT then
	SWEP.StandModel = "models/hpworld2/hpworld2.mdl"
end
SWEP.gStands_IsThirdPerson = true

local PrevHealth = nil

local SwingSound = Sound( "WeaponFrag.Throw" )

local Deploy = Sound("d13.laliho")
local Slash = Sound("weapons/d13/slash.wav")
local Enter = Sound("weapons/d13/enter.wav")
local Laugh = Sound("d13.laugh")
local Shine = Sound("weapons/d13/shine.wav")
local Romantic = Sound("weapons/d13/romantic-to-die.wav")
local Throw = Sound("weapons/d13/throw.wav")


hook.Add("PlayerSwitchWeapon", "SleptPlayersSwapNoThings", function(ply, owep, newep)
	if IsFirstTimePredicted() and Dreamland and Dreamland:IsValid() and Dreamland.PositionInside and Dreamland:PositionInside(ply:GetPos()) then
		return true
	end
end)
local function GetDreamland(ply)
	if SERVER then
		if IsValid(Dreamland) then
			return Dreamland
		end
		local DreamlandWidth = 8000
		local DreamlandLength = 8000
		local DreamlandHeight = 4000
		
		local DreamlandBounds = Vector(-DreamlandWidth/2,-DreamlandLength/2,-DreamlandHeight/2)
		local maxs = -DreamlandBounds
		
		--16384 is the "bounds" for the max map size, so we search between it, taking into account Dreamland s.
		local worldBounds = Vector(-16384+DreamlandWidth,-16384+DreamlandLength,-16384+DreamlandHeight)
		local DreamlandPos = Vector(0,0,-worldBounds.z)
		local tr = {
			mins = DreamlandBounds,
			maxs = maxs,
		}
		
		while tr != nil and DreamlandWidth > 500 and DreamlandLength > 500 and DreamlandHeight > 500 do
			while DreamlandPos.z > -16384 do
				tr.start = Vector(math.random(worldBounds.x,-worldBounds.x),math.random(worldBounds.x,-worldBounds.x),DreamlandPos.z)
				tr.endpos = tr.start
				if util.IsInWorld(tr.start) and !util.TraceHull(tr).Hit then
					DreamlandPos = tr.start
					tr = nil
					break
				end
				DreamlandPos.z = DreamlandPos.z - 1
			end
			DreamlandWidth = DreamlandWidth-100
			DreamlandLength = DreamlandLength-100
			DreamlandHeight = DreamlandHeight-100
		end
		if tr then
			return NULL
		end
		
		local floor = ents.Create("d13wall")
		floor:SetWidth(DreamlandWidth)
		floor:SetLength(DreamlandLength)
		floor:SetHeight(100)
		floor:SetPos(DreamlandPos+vector_up*-(DreamlandHeight/2+floor:GetHeight()/2))
		floor:Spawn()
		floor:Activate()
		
		local DreamlandRoom = ents.Create("d13room")
		DreamlandRoom:SetWidth(DreamlandWidth)
		DreamlandRoom:SetLength(DreamlandLength)
		DreamlandRoom:SetHeight(DreamlandHeight)
		DreamlandRoom:SetPos(DreamlandPos)
		DreamlandRoom:Spawn()
		DreamlandRoom.Owner = ply
		DreamlandRoom:Activate()
		DreamlandRoom:AddWall(floor)
		
		Dreamland = DreamlandRoom
		return Dreamland
	end
end
TELEPORT_QUEUE = {}

hook.Add("FinishMove", "PlayerTeleport", function(ply, mv)
	local tpData = TELEPORT_QUEUE[ply]
	if tpData ~= nil then
		ply:SetPos(tpData.Pos)
		ply:SetAngles(tpData.Angles)
		ply:SetVelocity(tpData.Velocity)
		TELEPORT_QUEUE[ply] = nil
		return true
	end
end)

local PLAYER_META = FindMetaTable("Player")

function PLAYER_META:SendToDreamland()
	local data = {}
	local rand = VectorRand()
	rand.z = 1
	local tr = util.TraceLine({
		start = Dreamland:GetPos() + Vector(0,0,500),
		endpos = Dreamland:GetPos() - rand * 800,
		filter = function(ent) if ent == Dreamland then return true else return false end end
		})
	data.Pos = tr.HitPos - tr.Normal * 100
	data.Angles = self:GetAngles()
	data.Velocity = self:GetVelocity()
	data.Ent = self
	TELEPORT_QUEUE[self] = data
end

function PLAYER_META:SendToCorpse(ent)
	local data = {}
	data.Pos = ent:GetPos()
	data.Angles = self:GetAngles()
	data.Velocity = self:GetVelocity()
	data.Ent = self
	TELEPORT_QUEUE[self] = data
end

function SWEP:InitDreamland()	
	local Dreamland = GetDreamland(self.Owner)
	self:SetDream(Dreamland)
	if !Dreamland:IsValid() then
		self.Owner:ChatPrint("#gstands.d13.error")
		return
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
	if GetConVar("gstands_draw_hud"):GetBool() then
		local color = gStands.GetStandColorTable(self:GetStand():GetModel(), self:GetStand():GetSkin())
		local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
	end
end
hook.Add( "HUDShouldDraw", "DeathHud", function(elem)
	if IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_death" and (elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") and GetConVar("gstands_draw_hud"):GetBool() then
		return false
	end
end)
local material = Material( "sprites/hud/v_crosshair1" )
function SWEP:DoDrawCrosshair(x,y)
	if IsValid(self.Stand) then
		local tr = util.TraceLine( {
			start = self:GetStand():WorldSpaceCenter(),
			endpos = self:GetStand():WorldSpaceCenter() + self.Owner:GetAimVector() * 1500,
			filter = {self.Owner, self:GetStand()},
			mask = MASK_SHOT_HULL
		} )
		local pos = tr.HitPos
		
		local pos2d = pos:ToScreen()
		if pos2d.visible then
			surface.SetMaterial( material	)
			surface.SetDrawColor( gStands.GetStandColorTable(self:GetStand():GetModel(), self:GetStand():GetSkin()) )
			surface.DrawTexturedRect( pos2d.x - 8, pos2d.y - 8, 16, 16 )
		end
		return true
	end
end

function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Dream")
	self:NetworkVar("Entity", 1, "Stand")
	self:NetworkVar("Bool", 2, "InDoDoDo")
end
hook.Add("PlayerDeath", "SleptPlayersDieInSleep", function(ply)
	if SERVER and ply.IsSlept then
		ply:SetPos(ply.d13rag:GetPos()) 
		ply.d13rag:Remove() 
		ply.IsSlept = false
		ply:ScreenFade( SCREENFADE.IN , Color(0,0,0,255) , 0.3, 0.2 )
	end
end)
hook.Add("EntityTakeDamage", "Death13Knockouts", function(ent, dmg)
    if ent:IsPlayer() and dmg:GetDamage() > 5 and (ent:GetActiveWeapon() and ent:GetActiveWeapon():IsValid() and !ent:HasWeapon("gstands_death")) then
        local DeathInPlay = false
        
		if Dreamland and Dreamland:IsValid() then
			DeathInPlay = true
		end
        if DeathInPlay then
			local attacker = dmg:GetAttacker()
			local hit = false
			if math.abs(attacker:GetAngles().y - ent:GetAngles().y) < 90 and attacker:GetPos():Distance(ent:GetPos()) < 250 and !ent.IsSlept and attacker != ent then
				hit = true
			end
            if hit then
				for k, ply in pairs( player.GetAll() ) do
					ply:ChatPrintFormatted( "#gstands.d13.knockout", ent:Name() )
				end
				ent:ScreenFade( SCREENFADE.IN , Color(255,255,255,255) , 0.3, 0.2 )
                ent.d13rag = ents.Create("prop_ragdoll")
                ent.d13rag:SetPos(ent:GetPos())
                ent.d13rag:SetAngles(ent:GetAngles())
                ent.d13rag:SetVelocity(ent:GetVelocity())
                ent.d13rag:SetModel(ent:GetModel())
                ent.d13rag:Spawn()
                ent.d13rag:Activate()
                ent.d13rag:SetUseType(SIMPLE_USE)
				ent:EmitSound(Enter)
                ent.d13rag.IsD13Rag = true
				ent.d13rag.Owner = ent
                ent.d13rag.UseBox = ents.Create("d13raguse")
                ent.d13rag.UseBox.Entity = ent.d13rag
				ent.d13rag.UseBox:SetPos(ent:WorldSpaceCenter())
                
				ent.d13rag.UseBox:SetParent(ent.d13rag)
				ent.d13rag.UseBox:SetOwner(ent)
                ent.d13rag.UseBox:Spawn()
                ent.d13rag.UseBox:Activate()
				ent.IsSlept = true
				ent:SendToDreamland()
                local lastcolgroup = ent:GetCollisionGroup()
                ent.d13rag:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				
				
                local WakeMeUp = function()
                    ent:SetNotSolid(false)
                    ent:SetNoDraw(false) 
					ent:SendToCorpse(ent.d13rag)
                    ent.d13rag:Remove() 
					ent.IsSlept = false
					ent:ScreenFade( SCREENFADE.IN , Color(0,0,0,255) , 0.3, 0.2 )
				end
				
                ent.d13rag:CallOnRemove("WakeMeUp", function() WakeMeUp() end)
			end
		end
	end
end)


if CLIENT then
    net.Receive("Death.Invis", function() 
		net.ReadEntity():SetNoDraw(true)
	end)
    net.Receive("Death.NoInvis", function() 
		net.ReadEntity():SetNoDraw(false)
	end)
end
if SERVER then
    util.AddNetworkString("Death.Invis")
    util.AddNetworkString("Death.NoInvis")
    util.AddNetworkString("Death.RedownloadLightmaps")
end
function SWEP:Initialize()
    --Set the third person hold type to fists
    self:SetHoldType( "fist" )
end

function SWEP:DrawWorldModel()
	if IsValid(self.Owner) then
		return false
		else
		self:DrawModel()
	end
end

local thirdperson_offset = GetConVar("gstands_thirdperson_offset")
function SWEP:CalcView( ply, pos, ang )
if not self.gStands_IsThirdPerson or ply:GetViewEntity() ~= ply then return end	if IsValid(self:GetStand()) and self.GetInDoDoDo and self:GetInDoDoDo() then
		pos = self:GetStand():WorldSpaceCenter() - ang:Forward() * 100
	end
	local Dreams = NULL
	local DreamsP = NULL
	if self and self.GetDream and self:GetDream() then
		Dreams = self:GetDream()
		if self:GetDream().GetDreamProp then
			DreamsP = self:GetDream():GetDreamProp()
		end
	end
	local convar = thirdperson_offset:GetString()
	local strtab = string.Split(convar, ",")
	local offset = Vector(strtab[1], strtab[2], strtab[3])
	offset:Rotate(ang)

	local trace = util.TraceHull( {
		start = pos,
		endpos = pos - ang:Forward() * 100,
		filter = { ply:GetActiveWeapon(), ply, ply:GetVehicle(), Dreams, DreamsP },
		mins = Vector( -4, -4, -4 ),
		maxs = Vector( 4, 4, 4 ),
	} )


	if ( trace.Hit ) then pos = trace.HitPos else pos = trace.HitPos end
	return pos + offset,ang
end
--Deploy starts up the stand
function SWEP:Deploy()
    --As is standard with stand addons, set health to 1000
    if self.Owner:Health() == 100  then
        self.Owner:SetMaxHealth( self.Durability )
        self.Owner:SetHealth( self.Durability )
	end
	if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitSound(Deploy)
		end
		self:InitDreamland()
		if Dreamland and Dreamland:IsValid() then
			self:SetStand(ents.Create("death"))
			self:GetStand():SetOwner(self.Owner)
			self:GetStand():SetPos(Dreamland:GetPos())
			self:GetStand():DrawShadow(false)
			self:GetStand():Spawn()
			self:GetStand():EmitStandSound(Deploy)

		end
	end
    --Create some networked variables, solves some issues where multiple people had the same stand
    self.Owner:SetCanZoom(false)
end

function SWEP:Think()
    if SERVER and !self:GetStand():IsValid() and Dreamland and Dreamland:IsValid() then
		self:InitDreamland()
		if Dreamland and Dreamland:IsValid() then
			self:SetStand(ents.Create("death"))
			self:GetStand():SetOwner(self.Owner)
			self:GetStand():SetPos(self.Owner:GetPos())
			self:GetStand():DrawShadow(false)
			self:GetStand():Spawn()
		end
	end
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
	self.SpinDamageTimer = self.SpinDamageTimer or CurTime()
	if SERVER and self.Owner:KeyPressed(IN_ATTACK2) and !self.Owner:gStandsKeyDown("modifierkey1") then
		Dreamland:EmitSound(Enter, 85, math.random(125, 200), 0.5)
		Dreamland:EmitStandSound(Enter, 85, math.random(125, 200), 0.5)
	end
    if SERVER and self.Owner:KeyDown(IN_ATTACK2) and !self.Owner:gStandsKeyDown("modifierkey1") then
		local notarg = { Dreamland, self:GetStand()  }
		if notarg and Dreamland.walls then
			table.Merge(notarg, Dreamland.walls)
		end		
			Dreamland.anim1act = self.anim1act or Dreamland:GetSequenceActivity(Dreamland:LookupSequence("cupspin"))
			Dreamland.anim1 = self.anim1 or Dreamland:AddGesture( Dreamland.anim1act , false )
			-- SWIMMING_FIST self.AnimSet[1]
			Dreamland:SetLayerWeight(Dreamland.anim1, 1)
			Dreamland:SetLayerPlaybackRate(Dreamland.anim1, 1)
			Dreamland:SetLayerBlendOut(Dreamland.anim1, 0)
		local trace = util.TraceHull( {
			start = Dreamland:GetAttachment(1).Pos,
			endpos = Dreamland:GetAttachment(1).Pos,
			filter = notarg,
			mins = Vector( -160.233124,-160.471848,0  ) * 2,
			maxs = Vector( 160.673721, 160.435013, 87.057724 ) * 2,
		} )
		if ( IsValid( trace.Entity ) && ( trace.Entity:IsNPC() || trace.Entity:IsPlayer() || trace.Entity:Health() > 0) )  and CurTime() >= self.SpinDamageTimer then
			local dmginfo = DamageInfo()
			local attacker = self.Owner
			dmginfo:SetAttacker( attacker )
			dmginfo:SetInflictor( self )
			
			dmginfo:SetDamage( 5 )
			local dir = -(trace.Entity:GetPos() - Dreamland:GetAttachment(1).Pos):GetNormalized():Angle():Right()
			local dir2 = (trace.Entity:GetPos() - Dreamland:GetAttachment(1).Pos):GetNormalized()
			dir = (dir - dir2/1.5):GetNormalized()
			trace.Entity:SetVelocity(dir * 550)
			
			trace.Entity:TakeDamageInfo( dmginfo )
			self.SpinDamageTimer = CurTime() + 0.1
		end
		elseif SERVER and Dreamland and Dreamland:IsValid() and Dreamland.anim1act then
		Dreamland:RemoveGesture(Dreamland.anim1act)
	end
	if SERVER and self.Owner:gStandsKeyDown("modifierkey1") and self.Owner:KeyDown(IN_ATTACK2) then
		for k,v in ipairs(player.GetAll()) do 
			if Dreamland:PositionInside(v:GetPos()) then
				local tr = util.TraceLine({
					start = v:EyePos(),
					endpos = v:GetPos(),
					filter = function(ent) if ent == Dreamland then return true else return false end end
				})
				if tr.Fraction > 0.1 then
				v:SetPos(v:GetPos() - (v:GetUp()))
				v:SetVelocity(-v:GetVelocity())
				end
			end
		end
	end
	self.MenacingDelay = self.MenacingDelay or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("dododo") then
		--Mode changing
		if CurTime() > self.MenacingDelay then
			self.MenacingDelay = CurTime() + 1
			self:SetInDoDoDo(!self:GetInDoDoDo())
			if !self:GetInDoDoDo() then
				if SERVER then
					self.Owner:AddFlags(FL_ATCONTROLS)
				end
				if SERVER then
					hook.Add("SetupPlayerVisibility", "gebnocullbreak"..self.Owner:GetName(), function(ply, ent) 
						if self:IsValid() and self.Owner:IsValid() and self:GetStand():IsValid() then
							AddOriginToPVS( self:GetStand():GetPos() + Vector(0,0,50) )
						end
					end)
				end
				else
				if SERVER then
					self.Owner:SetJumpPower(200)
					hook.Remove("SetupPlayerVisibility", "gebnocullbreak"..self.Owner:GetName())
					timer.Simple(1, function()
						self.Owner:SetMoveType(MOVETYPE_WALK)
						self.Owner:SetObserverMode(OBS_MODE_NONE)
						self.Owner:UnSpectate()
						self.Owner:RemoveFlags(FL_ATCONTROLS)
					end)
				end
			end
		end
	end
	self.HotDogDelay = self.HotDogDelay or CurTime()
	if SERVER and self.Owner:gStandsKeyDown("modeswap") then
		--Mode changing
		if CurTime() > self.HotDogDelay then
			self.HotDogDelay = CurTime() + 2
			Dreamland.anim2act = Dreamland:GetSequenceActivity(Dreamland:LookupSequence("standspit"))
			Dreamland.anim2 = Dreamland:AddGesture( Dreamland.anim2act , false )
			-- SWIMMING_FIST self.AnimSet[1]
			Dreamland:SetLayerWeight(Dreamland.anim2, 1)
			Dreamland:SetLayerPlaybackRate(Dreamland.anim2, 1)
			Dreamland:SetLayerBlendOut(Dreamland.anim2, 0)
			timer.Simple(0.5, function()
				ParticleEffectAttach("icecream", PATTACH_POINT_FOLLOW, Dreamland, 3)
				ParticleEffectAttach("d13fire", PATTACH_POINT_FOLLOW, Dreamland, 2)
				ParticleEffectAttach("flowerspray", PATTACH_POINT_FOLLOW, Dreamland, 4)
				ParticleEffectAttach("flowerspray", PATTACH_POINT_FOLLOW, Dreamland, 5)
				ParticleEffectAttach("flowerspray", PATTACH_POINT_FOLLOW, Dreamland, 6)
				ParticleEffectAttach("flowerspray", PATTACH_POINT_FOLLOW, Dreamland, 7)
				ParticleEffectAttach("flowerspray", PATTACH_POINT_FOLLOW, Dreamland, 8)
				ParticleEffectAttach("flowerspray", PATTACH_POINT_FOLLOW, Dreamland, 9)
				ParticleEffectAttach("flowerspray", PATTACH_POINT_FOLLOW, Dreamland, 10)
				ParticleEffectAttach("flowerspray", PATTACH_POINT_FOLLOW, Dreamland, 11)
				for k,v in pairs(player.GetAll()) do
					if Dreamland:PositionInside(v:GetPos()) then
						v:EmitStandSound(Laugh)
					end
				end
			end)
		end
		elseif SERVER and Dreamland and Dreamland:IsValid() and Dreamland.anim2act and CurTime() > self.HotDogDelay then
		Dreamland:RemoveGesture(Dreamland.anim2act)
	end
	if SERVER and Dreamland.anim2act and Dreamland:IsPlayingGesture(Dreamland.anim2act) and Dreamland:GetLayerCycle(Dreamland.anim2) > 0.1 and Dreamland:GetLayerCycle(Dreamland.anim2) < 0.2 then
		local tab = Dreamland:GetAttachment(2)
		local cmins = Vector(-50,-300,-50)
		local cmaxs = Vector(50,50,50)
		local tr = util.TraceHull({
			start = tab.Pos,
			endpos = tab.Pos,
			mins = cmins,
			maxs = cmaxs,
			filter = {Dreamland},
			mask=MASH_SHOT_HULL
		})
		Dreamland:EmitSound("ambient/fire/mtov_flame2.wav", 75, 100)
		Dreamland:EmitStandSound("ambient/fire/mtov_flame2.wav", 75, 100)
		if IsValid(tr.Entity) then
			local dmg = DamageInfo()
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self)
			dmg:SetDamage(25)
			dmg:SetDamageType(DMG_BURN)
			tr.Entity:EmitSound("ambient/fire/mtov_flame2.wav", 75, 100)
			tr.Entity:TakeDamageInfo(dmg)
			tr.Entity:Ignite(5)
		end
		local tab = Dreamland:GetAttachment(3)
		local cmins = Vector(-50,-50,-50)
		local cmaxs = Vector(50,300,50)
		local tr = util.TraceHull({
			start = tab.Pos,
			endpos = tab.Pos,
			mins = cmins,
			maxs = cmaxs,
			filter = function(ent) if ent:IsPlayer() then return true else return false end end,
			mask=MASH_SHOT_HULL
		})
		if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
			tr.Entity:EmitSound("weapons/d13/icecreamsplat.wav", 75, 100)
			tr.Entity:EmitSound("weapons/d13/icecreamed.wav", 75, 100)
			tr.Entity:Freeze(true)
			timer.Simple(5, function()
				if IsValid(tr.Entity) and IsValid(Dreamland) then
					tr.Entity:Freeze(false)
				end
			end)
		end
		for i=0, 5 do
			local tab = Dreamland:GetAttachment(4 + i)
			for k,v in pairs(ents.FindInCone(tab.Pos - Vector(0,0,50), -tab.Ang:Right(), 350, 0.505)) do
				if v:IsPlayer() and !v.Beed then
					local bees = ents.Create("d13bees")
					bees:SetTarget(v)
					bees:SetOwner(self.Owner)
					bees:Spawn()
				end
			end
		end
		
	end
end


function SWEP:PrimaryAttack()
    if SERVER and !self.Owner:gStandsKeyDown("modifierkey1") and self:GetStand():GetModel() != "models/d13/balloon.mdl" then
        self:SetNextPrimaryFire( CurTime() + 2 )
        self:GetStand():ResetSequence(self:GetStand():LookupSequence("scytheattack"))
        self:GetStand():ResetSequenceInfo()  
		self:GetStand():SetCycle(0)  
		self:GetStand().Timer = CurTime() + 0.2
		timer.Simple(0.2, function() if IsValid(self:GetStand()) then self:GetStand():EmitStandSound(SwingSound) end end)
		self:GetStand():EmitStandSound(Shine)
	end
	if SERVER and self.Owner:gStandsKeyDown("modifierkey1") and self:GetStand():GetModel() != "models/d13/balloon.mdl" then
        self:SetNextPrimaryFire( CurTime() + 2 )
        self:GetStand():ResetSequence(self:GetStand():LookupSequence("scythethrow"))
        self:GetStand():ResetSequenceInfo()  
		self:GetStand():SetCycle(0)  
		timer.Simple(0.4, function() 
			if IsValid(self:GetStand()) then 
				local scythe = ents.Create("d13scythe")
				scythe:SetPos(self:GetStand():GetPos())
				scythe:SetOwner(self.Owner)
				scythe:Spawn()
			end 
		end)
        self:GetStand():EmitStandSound(Romantic)
        self:GetStand():EmitStandSound(Throw)
	end
end


function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	
end
function SWEP:CheckPlayersForDeath(exclusion)
	local DeathExists = false
	for k,v in pairs(player.GetAll()) do
		if v:HasWeapon("gstands_death") and v:Alive() and v ~= exclusion then
			DeathExists = true
		end
	end
	return DeathExists
end

--Screw this entire section, it only works like 20% of the time. Basically, meant to catch every time the weapon is not in your hands in order to remove the stand.
function SWEP:OnDrop()
	if SERVER and self:GetStand():IsValid() then
		self:GetStand():Remove()
	end
	if SERVER and Dreamland and Dreamland:IsValid() and !self:CheckPlayersForDeath(self.Owner) then
		Dreamland:Remove()
	end
	self:SetInDoDoDo(false)
	self.Owner:RemoveFlags(FL_ATCONTROLS)
	return true
end

function SWEP:OnRemove()
	if SERVER and self:GetStand():IsValid() then
		self:GetStand():Remove()
	end
	if SERVER and Dreamland and Dreamland:IsValid() and !self:CheckPlayersForDeath(self.Owner) then
		Dreamland:Remove()
	end
	self:SetInDoDoDo(false)
	self.Owner:RemoveFlags(FL_ATCONTROLS)
	return true
end

function SWEP:Holster()
	if SERVER and self:GetStand():IsValid() then
		self:GetStand():Remove()
	end
	self:SetInDoDoDo(false)
	self.Owner:RemoveFlags(FL_ATCONTROLS)
	return true
end			