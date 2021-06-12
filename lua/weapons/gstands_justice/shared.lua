--Send file to clients
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot      = 1
end

SWEP.Power = 1.5
SWEP.Speed = 2.25
SWEP.Range = 1500
SWEP.Durability = 1500
SWEP.Precision = nil
SWEP.DevPos = nil

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.jst.purpose"
SWEP.Instructions  = "#gstands.jst.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.justice"

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
SWEP.dolls = {}
SWEP.plrHitBone = {}
SWEP.playerRefs = {}
SWEP.wepTable = {}
SWEP.wepTable2 = {}
SWEP.actwep = {}
SWEP.PlayerHealths = {}
SWEP.Props = {}
SWEP.Hooked = false
SWEP.gStands_IsThirdPerson = true

local PrevHealth = nil
game.AddParticles("particles/justice.pcf")
PrecacheParticleSystem("justice")
PrecacheParticleSystem("justicetendril")
PrecacheParticleSystem("justicemodelfog")
PrecacheParticleSystem("justicefogblock")

--Define swing and hit sounds. Might change these later.
local Drain = Sound( "weapons/justice/drain.mp3" )
local SDeploy = Sound( "weapons/justice/deploy.wav" )
local Deploy = Sound( "weapons/justice/deployvoice.wav" )
local Deploy2 = Sound( "weapons/justice/deployvoice2.wav" )
local Fogloop = Sound( "weapons/justice/fogloop.wav" )
local Kurei = Sound( "weapons/justice/kurei.wav" )
local Kekeke = Sound( "weapons/justice/kekeke.wav" )
local Laugh = Sound( "weapons/justice/justicelaugh.wav" )

local distsqrd = SWEP.Range * SWEP.Range

if CLIENT then 
	net.Receive("jst.StartSpectate", function()
		local ply = net.ReadEntity()
		local rag = net.ReadEntity()
		ply.JSTRagdoll = rag
		ply.JSTRagdolled = true
	end)
	net.Receive("jst.EndSpectate", function()
		local ply = net.ReadEntity()
		ply.JSTRagdoll = nil
		ply.JSTRagdolled = false
	end)
end
if SERVER then
	util.AddNetworkString("jst.StartSpectate")
	util.AddNetworkString("jst.EndSpectate")
end

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
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= index
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_01"))
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_fists_r"))
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_fists_r"))
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
function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Stand")
	self:NetworkVar("Bool", 0, "AMode")
	self:NetworkVar("Bool", 1, "InRange")
	self:NetworkVar("Float", 1, "Delay2")
	self:NetworkVar("Bool", 2, "Ended")
	self:NetworkVar("Vector",3,"DoDoDoPosition")
	self:NetworkVar("Bool",3,"InDoDoDo")
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
		if GetConVar("gstands_draw_hud"):GetBool() and IsValid(self.Stand) then
			local color = Color(95,100,95,255)
			local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
			
		end
	end
	hook.Add( "HUDShouldDraw", "JusticeHud", function(elem)
		if GetConVar("gstands_draw_hud"):GetBool() and IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_justice" and (((elem == "CHudWeaponSelection" ) and LocalPlayer().SPInZoom) or elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") then
			return false
		end
	end)
	local material = Material( "vgui/hud/gstands_hud/crosshair" )
	function SWEP:DoDrawCrosshair(x,y)
		if IsValid(self.Stand) and IsValid(self.Owner) and IsValid(LocalPlayer()) then
			local tr = util.TraceLine( {
				start = self.Stand:GetEyePos(true),
				endpos = self.Stand:GetEyePos(true) + self.Owner:GetAimVector() * 1500,
				filter = {self.Owner, self.Stand},
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
function SWEP:DefineStand()
    if SERVER then
        self:SetStand( ents.Create("Stand"))
		self.Stand = self:GetStand()
        self.Stand:SetOwner(self.Owner)
        self.Stand:SetModel("models/jst/jst.mdl")
        self.Stand:SetMoveType( MOVETYPE_NOCLIP )
        self.Stand:SetAngles(self.Owner:GetAngles())
        self.Stand:SetPos(self.Owner:GetBonePosition(0)+Vector(0, 0, 0))
        self.Stand:DrawShadow(false)
        self.Stand:SetModelScale(10,1)
        self.Stand:Spawn()
		self.Stand:SetNotSolid(true)
	end
    timer.Simple(0.1, function()
		self.Stand.rgl = 1.3
		self.Stand.ggl = 1.3
		self.Stand.bgl = 1.4
		self.Stand.rglm = 0.8
		self.Stand.gglm = 0.8
		self.Stand.bglm = 0.9
	end)
end

function SWEP:DrawWorldModel()
	if IsValid(self.Owner) then
		return false
		else
		self:DrawModel()
	end
end
--Third Person View
if CLIENT then
		hook.Add( "CalcView", "justiceragdollspectate", 
			function( ply, pos, ang )
				
				if ( !IsValid( ply ) or !ply:Alive() ) then return end
				
				if ( !IsValid( ply.JSTRagdoll )) then return end
				local p, ang = ply.JSTRagdoll:GetBonePosition(ply.JSTRagdoll:LookupBone("ValveBiped.Bip01_Head1"))
				local trace = util.TraceHull( {
					start = p,
					endpos = p + ang:Forward() * 3,
					filter = { ply.JSTRagdoll, ply },
					mins = Vector( -4, -4, -4 ),
					maxs = Vector( 4, 4, 4 ),
				} )
				
				
				if ( trace.Hit ) then pos = trace.HitPos else pos = trace.HitPos end
				return {
					origin = pos,
					angles = ang,
					drawviewer = fp
				}
			end )
end
local thirdperson_offset = GetConVar("gstands_thirdperson_offset")
function SWEP:CalcView( ply, pos, ang )
if not self.gStands_IsThirdPerson or ply:GetViewEntity() ~= ply then return end	if IsValid(self:GetStand()) and self:GetStand().GetInDoDoDo and self:GetStand():GetInDoDoDo() then
		pos = self:GetStand():GetEyePos()
	end
	local convar = thirdperson_offset:GetString()
	local strtab = string.Split(convar, ",")
	local offset = Vector(strtab[1], strtab[2], strtab[3])
	offset:Rotate(ang)
	
	if self.GetInDoDoDo and self:GetInDoDoDo() then
		pos = self:GetDoDoDoPosition() + Vector(0,0,100)
	end
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
	
    if SERVER then
        if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitStandSound(SDeploy)
			if math.random(1,2) == 1 then
			self.Owner:EmitSound(Deploy)
			else
			self.Owner:EmitSound(Deploy2)
			end
		end
	end
    --As is standard with stand addons, set health to 1000
    if self.Owner:Health() == 100  then
        self.Owner:SetMaxHealth( self.Durability )
        self.Owner:SetHealth( self.Durability )
	end
    self:DefineStand()
	
    self.Owner:SetCanZoom(false)
    ParticleEffectAttach("justice", PATTACH_ABSORIGIN_FOLLOW, self.Owner, 0)
    timer.Simple(0.1, function()
        ParticleEffectAttach("justicemodelfog", PATTACH_ABSORIGIN_FOLLOW, self.Stand, 1)
	end)
end
function SWEP:KillNPC(n)
	local rag = ents.Create("prop_ragdoll")
	rag:SetModel(n:GetModel())
	rag:SetColor(n:GetColor())
	rag:SetSkin(n:GetSkin())
	rag:SetPos(n:GetPos())
	rag:Spawn()
	rag:Activate()
	rag:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	n:Remove()
end
function SWEP:WakePlayer(ply)
	ply:DrawViewModel(true)
	ply:SetNoDraw(false)
	ply:SetNotSolid(false)
	ply:UnSpectate()
	net.Start("jst.EndSpectate")
	net.WriteEntity(ply)
	net.Send(ply)
	if ply:Alive() then
		local health = ply:Health()
		ply:Spawn()
		ply:SetHealth(health)
	end
	ply:SetPos(ply.JusticeRagdoll:GetPos())
	for i,j in pairs(ply.wepTable2) do
		if j then
			ply:Give(j)
		end
	end
	if ply:HasWeapon(ply.actwep) then
		ply:SelectWeapon(ply.actwep)
	end
end
function SWEP:Think()
	self.LastOwner = self.Owner
	self.Stand = self:GetStand()
	if !self.Hooked then
		local hooktag = self.Owner:GetName()
		self.drainfx = self.drainfx or {}
		hook.Add("SetupMove", "JusticeDrainSlowdown"..hooktag, function(ply, mv)
			if IsValid(self) and self.drainfx then
				if self.drainfx[ply] then
					ply.JusticeSpeed = math.max(1, ply.JusticeSpeed / 1.01)
					mv:SetMaxSpeed(ply.JusticeSpeed)
					mv:SetMaxClientSpeed(ply.JusticeSpeed)
				end
				else
				hook.Remove("SetupMove", "JusticeDrainSlowdown"..hooktag)
			end
		end)
		hook.Add("EntityTakeDamage", "PreventBulletsInFogJustice"..hooktag, function(ent, data)
			if IsValid(self) and IsValid(self.Owner) then
				if IsValid(self.Stand) and ent:GetPos():DistToSqr(self.Owner:WorldSpaceCenter()) < distsqrd and data:IsBulletDamage() then
					return true
				end
				else
				hook.Remove("EntityTakeDamage", "PreventBulletsInFogJustice"..hooktag)
			end
		end)
		hook.Add("EntityTakeDamage", "JusticeWatchForDamage"..hooktag, function(ent, data)
			if IsValid(self) and IsValid(self.Owner) then
				if ent:IsPlayer() and ent:GetPos():DistToSqr(self.Owner:GetPos()) < distsqrd and IsValid(self.Stand) then
					if ent and ent:IsValid() then
						local plr = ent
						if plr:IsValid() and plr != self.Owner and plr:Health() > 1 and plr:Alive() and (plr.GetActiveWeapon and plr:GetActiveWeapon():IsValid() and plr:GetActiveWeapon():GetClass() != "gstands_justice") then
							if SERVER and plr and plr:IsValid() and plr:IsPlayer() and !IsValid(plr.JusticeRagdoll) and !self.drainfx[plr] then
								local attacker = data:GetAttacker()
								local position = data:GetDamagePosition()
								timer.Simple(5, function()
									local jst = self.Stand
									if SERVER and IsValid(self) and IsValid(jst) and plr and plr:IsValid() and plr:IsPlayer() and !IsValid(plr.JusticeRagdoll) then
										self.drainfx[plr] = false
										plr.JusticeRagdoll = ents.Create("prop_ragdoll")
										plr.JusticeRagdoll.PlayerRef = plr
										plr.JusticeRagdoll:SetModel(plr:GetModel())
										plr.JusticeRagdoll:SetColor(plr:GetColor())
										plr.JusticeRagdoll:SetSkin(plr:GetSkin())
										plr.JusticeRagdoll:SetPos(plr:WorldSpaceCenter())
										plr.JusticeRagdoll:SetHealth(plr:Health())
										plr.JusticeRagdoll:Spawn()
										plr.JusticeRagdoll:Activate()
										self.Stand:EmitStandSound(Laugh)
										table.insert(self.dolls, plr.JusticeRagdoll)
										local deathHook = "gstands_justicerag_death" .. plr.JusticeRagdoll:EntIndex()
										local damageHook = "gstands_justicerag_dmgsaver" .. plr.JusticeRagdoll:EntIndex()
										hook.Add("DoPlayerDeath", deathHook, function(victim)
											if not IsValid(plr.JusticeRagdoll) then hook.Remove("DoPlayerDeath", deathHook) return end
											if victim == plr then plr.JusticeRagdoll:Remove() end
										end)
										hook.Add("EntityTakeDamage", damageHook, function(ent, dmg)
											if IsValid(ent.PlayerRef) then 
												ent.PlayerRef:TakeDamageInfo(dmg, lastAttacker, self)
												local damage = dmg:GetDamage()
											end
										end)
										plr.JusticeRagdoll:CallOnRemove("Respawner", function()
											hook.Remove("EntityTakeDamage", damageHook)            
											hook.Remove("EntityTakeDamage", deathHook)            
											if IsValid(self) and IsValid(plr) and IsValid(plr.JusticeRagdoll) and plr.JusticeRagdoll.PlayerRef == plr then
												self:WakePlayer(plr)
											end
										end)
										plr:SetNotSolid(true)
										plr:DrawViewModel(false)
										timer.Simple(0.1, function()
											if IsValid(plr) and IsValid(plr.JusticeRagdoll) then
												net.Start("jst.StartSpectate")
												net.WriteEntity(plr)
												net.WriteEntity(plr.JusticeRagdoll)
												net.Send(plr)
											end
										end)
										plr:SetNoDraw(true)
										local hitgrouptable = {
											"ValveBiped.Bip01_Head1",
											"ValveBiped.Bip01_Head1",
											"ValveBiped.Bip01_Spine2",
											"ValveBiped.Bip01_L_Hand",
											"ValveBiped.Bip01_R_Hand",
											"ValveBiped.Bip01_L_Foot",
											"ValveBiped.Bip01_R_Foot",
											"ValveBiped.Bip01_Head1",
											"ValveBiped.Bip01_Head1",
										}
										plr.plrHitBone = plr:TranslateBoneToPhysBone(plr:LookupBone(table.Random(hitgrouptable)))
										plr.wepTable = plr:GetWeapons()
										for k,v in pairs(plr.wepTable) do
											plr.wepTable2 = {}
											plr.wepTable2[k] = v:GetClass()
										end
										plr.actwep = plr:GetActiveWeapon():GetClass()
										plr:StripWeapons()
									end
								end)
								self.drainfx = self.drainfx or {}
								self.drainfx[plr] = true
								plr.JusticeSpeed = plr:GetMaxSpeed()
								plr:EmitStandSound( Drain )
								self.Owner:EmitSound( Kekeke )
								local effectdata = EffectData()
								effectdata:SetEntity(plr)
								effectdata:SetAttachment(self.Owner:EntIndex())
								util.Effect("gstands_justice_tendril", effectdata, true, true)
							end
						end
					end
				end
				else
				hook.Remove("EntityTakeDamage", "JusticeWatchForDamage"..hooktag)
			end
		end)
		self.Hooked = true
	end
    if !self.Stand:IsValid() then
        self:DefineStand()
	end
    for k,v in ipairs(player.GetAll()) do
        if v.JusticeRagdoll and v.JusticeRagdoll.PlayerRef and v.JusticeRagdoll.PlayerRef != v then
			table.remove(self.playerRefs, k)
		end
	end
	if self:GetInDoDoDo() then
		self.Owner:AddFlags(FL_ATCONTROLS)
		else
		self.Owner:RemoveFlags(FL_ATCONTROLS)
	end
	self.DoDoDoTimer = self.DoDoDoTimer or CurTime()
	if self.Owner:GetInfoNum("gstands_active_dododo_toggle", 1) == 1 and SERVER and CurTime() > self.DoDoDoTimer and self.Owner:gStandsKeyDown("dododo") then
		self.DoDoDoTimer = CurTime() + 0.3
		self:SetInDoDoDo(!self:GetInDoDoDo())
	end
	if self.Owner:GetInfoNum("gstands_active_dododo_toggle", 1) == 0 then
		self:SetInDoDoDo(self.Owner:gStandsKeyDown("dododo"))
	end
	if self:GetInDoDoDo() then
		self.Menacing = self.Menacing or CurTime()
		self.Owner:AddFlags(FL_ATCONTROLS)
		if CurTime() > self.Menacing then
			self.Menacing = CurTime() + 0.5
			local effectdata = EffectData()
			effectdata:SetStart(self.Owner:GetPos())
			effectdata:SetOrigin(self.Owner:GetPos())
			effectdata:SetEntity(self.Owner)
			util.Effect("menacing", effectdata)
			for k,v in ipairs(self.dolls) do
				if v:IsValid() then
                    local fxdat = EffectData()
                    fxdat:SetStart(v:GetPos())
                    fxdat:SetOrigin(v:GetPos())
                    util.Effect("menacing", fxdat, true, true)
				end
			end
		end
		if self.Owner:KeyDown(IN_FORWARD) then
			self:SetDoDoDoPosition(self:GetDoDoDoPosition() + self.Owner:GetAimVector() * 2)
		end
		if self.Owner:KeyDown(IN_BACK) then
			self:SetDoDoDoPosition(self:GetDoDoDoPosition() - self.Owner:GetAimVector() * 2)
		end
		if self.Owner:KeyDown(IN_MOVELEFT) then
			self:SetDoDoDoPosition(self:GetDoDoDoPosition() - self.Owner:GetAimVector():Angle():Right() * 2)
		end
		if self.Owner:KeyDown(IN_MOVERIGHT) then
			self:SetDoDoDoPosition(self:GetDoDoDoPosition() + self.Owner:GetAimVector():Angle():Right() * 2)
		end
		local tr = util.TraceLine({
			start = self:GetDoDoDoPosition() + Vector(0,0,500),
			endpos = self:GetDoDoDoPosition() - Vector(0,0,500),
			mask = MASK_NPCWORLDSTATIC
		})
		self:SetDoDoDoPosition(tr.HitPos)
		for k,v in ipairs(self.dolls) do
			if v:IsNPC() and v:IsValid() and v:GetActiveWeapon():GetClass() != "weapon_medkit" then
				v:SetSchedule(SCHED_FORCED_GO_RUN)
				v:SetLastPosition(self:GetDoDoDoPosition())
			end
		end
		else
		local count = 1
		local pos
		for k,v in ipairs(self.dolls) do
			if IsValid(v) and v.GetActiveWeapon and IsValid(v:GetActiveWeapon()) and v:IsNPC() and v:IsValid() and v:GetActiveWeapon():GetClass() != "weapon_medkit" then
				if !pos then
					pos = v:GetPos()
					else
					pos = pos + v:GetPos()
					count = count + 1
				end
				if IsValid(self.Target) then
					v:SetLastPosition(self.Target:GetPos())
					v:SetSchedule(SCHED_FORCED_GO_RUN)
				end
			end
		end
		if pos and count then
			pos = pos / count
			self:SetDoDoDoPosition(pos)
		end
	end
    local tr = util.TraceLine( {
		start = self.Owner:EyePos(),
		endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * self.Range / 1.5,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )
	if self.dolls then
		for k,v in ipairs(self.dolls) do

			if !IsValid(v) then
				table.RemoveByValue(self.dolls, v)
			end
			if v:IsNPC() and v:IsValid() and IsValid(v:GetActiveWeapon()) and v:GetActiveWeapon():GetClass() == "weapon_medkit" then
				v.WanderTimer = v.WanderTimer or CurTime() 
				if CurTime() > v.WanderTimer then
					-- -- local goal = self.Owner:GetPos() + VectorRand() * 1000
					-- -- v:SetLastPosition(goal)
					v.WanderTimer = CurTime() + 15
					v:SetLastPosition(self.Owner:WorldSpaceCenter() + Vector(0,0,100))
					v:Fire("StopPatrolling")
					v:SetSchedule(SCHED_FORCED_GO_RUN)
				end
			end
			-- if v:IsNPC() and v:IsValid() and v:GetPos():Distance(self.Owner:GetPos()) > 1000 then
			-- v:Fire("StopPatrolling")
			-- v:SetLastPosition(self.Owner:WorldSpaceCenter() + Vector(0,0,100))
			-- v:SetSchedule(SCHED_FORCED_GO_RUN)
			-- timer.Simple(1, function() 	
			-- if IsValid(v) then
			-- v:NavSetWanderGoal(1000, 1000)
			-- v:SetSchedule(SCHED_IDLE_WANDER)
			-- v:SetNPCState(NPC_STATE_ALERT)
			-- v:Fire("startpatrolling")
			-- end
			-- end)
			-- end

			if v and v:IsValid() and v:GetClass() == "prop_ragdoll" then
				local ang = Angle(0,0,0)
				local physbone = v.PlayerRef.plrHitBone
				if v.PlayerRef.plrHitBone then
					-- local pbone = v:TranslateBoneToPhysBone()
					-- if pbone != -1 then
						-- physbone = pbone
					-- end
				end
				if IsValid(v:GetPhysicsObjectNum(physbone)) then
					local dir = (tr.HitPos - v:GetPhysicsObjectNum(physbone):GetPos()):GetNormalized()
					v:GetPhysicsObjectNum(physbone):ApplyForceCenter( dir * 1200 )
				end
			end
			if v:IsValid() and v:GetPos():DistToSqr(self.Owner:GetPos()) >= distsqrd + (150 * 150) then
				if IsValid(v) and v:IsNPC() and v:IsValid() and SERVER and IsFirstTimePredicted() then
					self:KillNPC(v)
					elseif IsValid(v.PlayerRef) then
					self:WakePlayer(v.PlayerRef)
					table.remove(self.playerRefs, k)
					
					v:Remove() 
				end
			end
		end
	end
	for k,v in ipairs(self.playerRefs) do
		if v:IsValid() then
			if v.JusticeRagdoll and v.JusticeRagdoll:IsValid() and v.JusticeRagdoll.PlayerRef == v then
				v:SetPos(v.JusticeRagdoll:GetPos())
			end
		end
	end
	for k,v in ipairs(player.GetAll()) do
		if SERVER and v != self.Owner and v:GetPos():DistToSqr(self.Owner:GetPos()) < distsqrd then
			if !v.JusticeDSPSet then
				v:SetDSP(25)
				v.JusticeDSPSet = true
			end
			elseif SERVER and v != self.Owner then
			if v.JusticeDSPSet then
				v:SetDSP(1)
				v.JusticeDSPSet = nil
			end
		end
	end
	if self.Props then
		for k,v in ipairs(self.Props) do
			if !v:IsValid() then
				table.remove(self.Props, k)
			end
			if v:IsValid() and v:WorldSpaceCenter():Distance(self.Owner:WorldSpaceCenter()) > self.Range then
				v:Remove()
			end
			
		end
	end
	self.DelayIll = self.DelayIll or CurTime()
	if self.Owner:gStandsKeyDown("modeswap") and self.DelayIll < CurTime() and SERVER and #self.Props <= 15 then
		self.DelayIll = CurTime() + 1
		local tr = util.TraceLine( {
			start = self.Owner:EyePos(),
			endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 125 + Vector(0,0,10),
			filter = self.Owner,
			mask = MASK_SHOT_HULL
		} )
		if self.Owner:gStandsKeyDown("modifierkey2") then
			if tr.Entity:IsValid() and tr.Entity:GetClass() == "prop_physics" then
				self.IllModel = tr.Entity:GetModel()
			end
		end
		if !self.Owner:gStandsKeyDown("modifierkey2") then
			local prop = ents.Create("prop_physics")
			prop:SetModel(self.IllModel or "models/props_c17/oildrum001.mdl")
			prop:SetPos(tr.HitPos)
			prop:SetAngles(tr.Normal:Angle())
			prop:Spawn()
			prop:Activate()
			prop:SetColor(Color(255,255,255,245))
			prop:SetRenderMode(RENDERMODE_WORLDGLOW)
			local sound = CreateSound(prop, Fogloop)
			timer.Create("sound"..prop:EntIndex(), 2.318, 0, function() if prop:IsValid() then
				sound:Play()
				else
				sound:Stop()
				timer.Remove("sound"..prop:EntIndex())
			end
			end)
			timer.Simple(0.1, function()
				ParticleEffectAttach("justicemodelfog", PATTACH_ABSORIGIN_FOLLOW, prop, 1)
			end)
			table.insert(self.Props, prop)
			constraint.Keepupright(prop, tr.Normal:Angle(), 0, 1000)
			cleanup.Add(self.Owner, "Illusory Props", prop)
			undo.Create( "Justice Illusion" )
			undo.AddEntity( prop )
			undo.SetPlayer( self.Owner )
			undo.Finish()
		end
	end
	self.StandBlockTimer = self.StandBlockTimer or CurTime()
	if self.Owner:gStandsKeyDown("block") and CurTime() > self.StandBlockTimer then
		local tr = util.TraceLine({
			start=self.Owner:EyePos(),
			endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 1500,
			mask = MASK_NPCWORLDSTATIC
		})
		ParticleEffect("justicefogblock", tr.HitPos, tr.Normal:Angle())
		self.StandBlockTimer = CurTime() + 5
		self.Owner:EmitSound(Kurei)
	end
	self:NextThink(CurTime())
	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 1)
    local tr = util.TraceLine( {
        start = self.Owner:EyePos(),
        endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * self.Range * 2,
        filter = self.Owner,
        mask = MASK_SHOT_HULL
	} )
    -- if !self.Owner.IsKnockedOut and SERVER and tr.Entity and tr.Entity:IsValid() and tr.Entity:GetClass() == "prop_ragdoll" and !IsValid(tr.Entity.PlayerRef) then
	-- local npc = ents.Create("npc_citizen")
	-- npc:Spawn()
	-- npc:Activate()
	
	-- npc:SetModel(tr.Entity:GetModel())
	-- npc:SetPos(tr.Entity:WorldSpaceCenter() + Vector(0,0,10))
	-- for k,v in ipairs(player.GetAll()) do
	-- npc:AddEntityRelationship(v, 1, 99)
	-- end
	-- for k,v in ipairs(ents.GetAll()) do
	-- if v:IsNPC() and !IsValid(v.PlayerRef) then
	-- npc:AddEntityRelationship(v, 1, 99)
	-- end
	-- end
	-- npc:Give("weapon_crowbar")
	-- npc:AddEntityRelationship(self.Owner, 3, 45)
	-- npc:EmitSound( Drain )
	
	-- local effectdata = EffectData()
	-- effectdata:SetEntity(npc)
	-- effectdata:SetAttachment(self.Owner:EntIndex())
	-- util.Effect("gstands_justice_tendril", effectdata, true, true)
	-- tr.Entity:Remove()
	-- table.insert(self.dolls, npc)
	-- self:SetNextPrimaryFire( CurTime() + 1 )
	-- self:SetNextSecondaryFire( CurTime() + (0.1 * self.Speed) )
	-- end
	if IsValid(self.Target) then
		self.Target:Remove()
	end
	if SERVER and !IsValid(self.Target) then
		self.Target = ents.Create("npc_bullseye")
	end
	if SERVER then
		self.Target:SetPos(tr.HitPos)
		--self.Target:SetParent(tr.Entity)
		self.Target:Spawn()
		--targ:Activate()
		self.Target:SetNotSolid(true)
	end
	for k,v in pairs(self.dolls) do
		if !v:IsNPC() or v:GetActiveWeapon():GetClass() == "weapon_medkit" then
			continue
		end
		if tr.Entity and !tr.HitWorld and (tr.Entity:IsPlayer() or tr.Entity:IsNPC()) then
			if IsValid(self.Target) then
				self.Target:Remove()
			end
			v:SetTarget(tr.Entity)
			v:AddEntityRelationship(tr.Entity, 1, 99)
			self.Target:AddEntityRelationship(v, 1, 99)
			v:SetEnemy(tr.Entity)
			v:SetSchedule(SCHED_FORCED_GO_RUN)
			local cmins, cmaxs = tr.Entity:GetModelBounds()
			local hulltr = util.TraceHull({
				start = tr.Entity:GetPos(),
				endpos = tr.Entity:GetPos(),
				mins = cmins * 1.1,
				maxs = cmaxs * 1.1,
				mask = MASK_NPCWORLDSTATIC
			})
			v:SetLastPosition(hulltr.HitPos)
		end
		if tr.Entity and !tr.HitWorld and !(tr.Entity:IsPlayer() or tr.Entity:IsNPC()) then
			v:SetTarget(self.Target)
			v:AddEntityRelationship(self.Target, 1, 99)
			self.Target:AddEntityRelationship(v, 1, 99)
			v:SetEnemy(self.Target)
			v:SetSchedule(SCHED_FORCED_GO_RUN)
			local cmins, cmaxs = tr.Entity:GetModelBounds()
			local hulltr = util.TraceHull({
				start = tr.Entity:GetPos(),
				endpos = tr.Entity:GetPos(),
				mins = cmins * 1.1,
				maxs = cmaxs * 1.1,
				mask = MASK_NPCWORLDSTATIC
			})
			v:SetLastPosition(hulltr.HitPos)
			self.Target:SetPos(tr.HitPos - tr.Normal * 15)
			self.Target:SetParent(tr.Entity)
			v:SetNPCState(NPC_STATE_COMBAT)
		end
		if tr.HitWorld then
			v:SetLastPosition(tr.HitPos)
			v:SetSchedule(SCHED_FORCED_GO_RUN)
			
		end
	end
end

function SWEP:SecondaryAttack()
	for k,v in pairs(ents.FindInSphere(self.Owner:WorldSpaceCenter(), self.Range)) do
		if SERVER and v and v:IsValid() and v:GetClass() == "prop_ragdoll" and !IsValid(v.PlayerRef) and #self.dolls < 25 then
			local npc = ents.Create("npc_citizen")
			npc:Spawn()
			npc.Owner = self.Owner
			npc:Activate()
			
			--local goal = self.Owner:GetPos() + VectorRand() * 1000
			npc:SetKeyValue("spawnflags", bit.bor(8192, 256))
			local rand = math.random(0,4)
			if rand == 1 then
				npc:SetKeyValue("spawnflags", bit.bor(8192, 256, SF_CITIZEN_MEDIC))
				npc:SetKeyValue("sk_citizen_player_stare_time", 0.01)
				npc:SetKeyValue("sk_citizen_heal_player", 200)
				npc:SetKeyValue("sk_citizen_heal_player_delay", 0)
				npc:Give("weapon_medkit")
				npc:NavSetWanderGoal(1000, 1000)
				elseif rand == 2 then
				npc:NavSetWanderGoal(-1000, -1000)
				elseif rand == 3 then
				npc:NavSetWanderGoal(1000, -1000)
				elseif rand == 4 then
				npc:NavSetWanderGoal(-1000, 1000)
				else
				npc:NavSetWanderGoal(-1000, 1000)
			end
			
			npc:SetSchedule(SCHED_IDLE_WANDER)
			--npc:SetNPCState(NPC_STATE_COMBAT)
			npc:CapabilitiesAdd(CAP_USE)
			npc:CapabilitiesAdd(CAP_MOVE_SHOOT)
			npc:CapabilitiesAdd(CAP_SQUAD)
			npc:CapabilitiesAdd(CAP_ANIMATEDFACE)
			npc:CapabilitiesAdd(CAP_MOVE_JUMP)
			npc:CapabilitiesAdd(CAP_MOVE_CLIMB)
			npc:SetKeyValue("expressiontype", 3)
			npc:SetCurrentWeaponProficiency(4)
			
			--npc:Fire("startpatrolling")
			
			npc:Fire("wake")
			if v:GetModel() then
				npc:SetModel(v:GetModel())
				else
				npc:Remove()
			end
			
			npc:SetPos(v:WorldSpaceCenter() + Vector(0,0,10))
			for k,v in ipairs(player.GetAll()) do
				npc:AddEntityRelationship(v, 1, 99)
			end
			for k,v in ipairs(ents.GetAll()) do
				if v:IsNPC() and !table.HasValue(self.dolls, v) then
					npc:AddEntityRelationship(v, 1, 99)
				end
			end
			
			npc:Give("weapon_crowbar")
			if rand == 1 then
				npc:Give("weapon_medkit")
			end
			npc:AddEntityRelationship(self.Owner, 3, 45)
			npc:EmitStandSound( Drain )
			
			local effectdata = EffectData()
			effectdata:SetEntity(npc)
			effectdata:SetAttachment(self.Owner:EntIndex())
			util.Effect("gstands_justice_tendril", effectdata, true, true)
			
			v:Remove()
			table.insert(self.dolls, npc)
			self:SetNextPrimaryFire( CurTime() + 1 )
			self:SetNextSecondaryFire( CurTime() + (0.1 * self.Speed) )
			
		end
	end
	self:SetNextSecondaryFire( CurTime() + 10 )
end

function SWEP:Reload()
	
end

--Screw this entire section, it only works like 20% of the time. Basically, meant to catch every time the weapon is not in your hands in order to remove the stand.
function SWEP:OnDrop()
    for k,v in ipairs(self.Props) do
		if IsValid(v) then
			v:Remove()
		end
	end
    if SERVER and self.Stand:IsValid() then
        self.Stand:Remove()
	end
	if IsValid(self.Target) then
		self.Target:Remove()
	end
    for k,v in pairs(self.dolls) do
		if v:IsNPC() and v:IsValid() then
			self:KillNPC(v)
		end
	end
    for k,v in ipairs(player.GetAll()) do
		if v:IsValid() and v.JusticeRagdoll:IsValid() and v.JusticeRagdoll.PlayerRef == v then
			v.JusticeRagdoll:Remove()
			self:WakePlayer(v)
		end
	end
    for k,v in ipairs(self.dolls) do
		if v:IsValid() and v:GetClass() == "prop_ragdoll" then
			v:Remove()
		end
	end
    self.playerRefs = {}
    self.PlayerHealths = {}
	
    self.dolls = {}
    self.LastOwner:StopParticles()
    return true
end

function SWEP:OnRemove()
    for k,v in ipairs(self.Props) do
		v:Remove()
	end
    if SERVER and self.Stand:IsValid() then
        self.Stand:Remove()
	end
	if IsValid(self.Target) then
		self.Target:Remove()
	end
    for k,v in pairs(self.dolls) do
		if v:IsNPC() and v:IsValid() then
			self:KillNPC(v)
		end
	end
    for k,v in ipairs(player.GetAll()) do
		if v:IsValid() and v.JusticeRagdoll and v.JusticeRagdoll:IsValid() and v.JusticeRagdoll.PlayerRef == v then
			v.JusticeRagdoll:Remove()
			self:WakePlayer(v)
		end
	end
    for k,v in ipairs(self.dolls) do
		if v:IsValid() and v:GetClass() == "prop_ragdoll" then
			v:Remove()
		end
	end
    self.playerRefs = {}
    self.PlayerHealths = {}
	
    self.dolls = {}
	if self.Owner:IsValid() then
		self.Owner:StopParticles()
	end
    return true
end

function SWEP:Holster()
	for k,v in ipairs(self.Props) do
		v:Remove()
	end
	if SERVER and self.Stand:IsValid() then
		self.Stand:Remove()
	end
	for k,v in pairs(self.dolls) do
		if v:IsNPC() and v:IsValid() then
			self:KillNPC(v)
		end
	end
	for k,v in ipairs(player.GetAll()) do
		if SERVER and v:IsValid() and IsValid(v.JusticeRagdoll) and v.JusticeRagdoll.PlayerRef == v then
			v.JusticeRagdoll:Remove()
			self:WakePlayer(v)
		end
		v:SetDSP(1)
	end
	for k,v in ipairs(self.dolls) do
		if v:IsValid() and v:GetClass() == "prop_ragdoll" then
			v:Remove()
		end
	end
	self.playerRefs = {}
	self.PlayerHealths = {}
	self.dolls = {}
	self.Owner:StopParticles()
	return true
end