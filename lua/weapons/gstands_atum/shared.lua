--Send file to clients
if SERVER then
AddCSLuaFile( "shared.lua" )
end
if CLIENT then
SWEP.Slot      = 1
end

SWEP.Power = 1
SWEP.Speed = .5
SWEP.Range = 250
SWEP.Durability = 1000
SWEP.Precision = D
SWEP.DevPos = D

SWEP.Author        = "Copper"
SWEP.Purpose       = "#gstands.atum.purpose"
SWEP.Instructions  = "#gstands.atum.instructions"
SWEP.Spawnable     = true
SWEP.Base          = "weapon_fists"   
SWEP.Category      = "gStands"
SWEP.PrintName     = "#gstands.names.atum"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos            = 2
SWEP.DrawCrosshair      = true

SWEP.WorldModel     = "models/player/whitesnake/disc.mdl"
SWEP.ViewModelFOV   = 54
SWEP.UseHands       = true

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"

SWEP.DrawAmmo       = true
SWEP.CanZoom       = false
SWEP.HitDistance    = 48
SWEP.ChargeStart = 0
SWEP.ChargeEnd = 0
SWEP.LatchedEnt = nil
SWEP.BarrierNum = 0
SWEP.BarrierList = {}
SWEP.BarrierAvg = Vector(0,0,0)
SWEP.Delay3 = 0
SWEP.WaxOn = false
SWEP.Spikes = {}
SWEP.StandModel = "models/player/atm/atm.mdl"
SWEP.StandModelP = "models/player/atm/atm.mdl"
SWEP.gStands_IsThirdPerson = true

if CLIENT then
SWEP.StandModel = "models/player/atm/atm.mdl"
end
--Define swing and hit sounds. Might change these later.
--local SwingSound = Sound( "WeaponFrag.Throw" )
local Deploy = Sound("weapons/atum/deploy.wav")
local View = Sound("weapons/atum/view.wav")
local No = Sound("weapons/atum/no.wav")
local Yes = Sound("weapons/atum/yes.wav")


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
	[ "stando" ]		= ACT_HL2MP_IDLE_KNIFE
	
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
	self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_standing_02"))
	self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_HL2MP_IDLE + 1
	self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
	self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("pose_ducking_01"))
	self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
	self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_fists_r"))
	self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_fists_r"))
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

function SWEP:SetupDataTables()
		self:NetworkVar("Entity", 0, "Stand")
end

function SWEP:Initialize()
	--Set the third person hold type to fists
	if CLIENT then
	end
	self:DrawShadow(false)
	self.CanZoom = false

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
function SWEP:CalcView( ply, pos, ang )
	if not self.gStands_IsThirdPerson or ply:GetViewEntity() ~= ply then return end	if IsValid(self:GetStand()) and self:GetStand().GetInDoDoDo and self:GetStand():GetInDoDoDo() then
		pos = self:GetStand():GetEyePos()
	end
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
		local color = gStands.GetStandColorTable(self.Stand:GetModel(), self.Stand:GetSkin())
		local height = ScrH()
		local width = ScrW()
		local mult = ScrW() / 1920
		local tcolor = Color(color.r + 75, color.g + 75, color.b + 75, 255)
		gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
		local nocompletegstands = Color(255,0,0, 255)
		draw.TextShadow({
			text = "No Complete!",
			font = "gStandsFont",
			pos = {width - 1500 * mult, height - 265 * mult},
			color = nocompletegstands,
		}, 2 * mult, 250)

		draw.TextShadow({
			text = "This Stand is incomplete!",
			font = "gStandsFont",
			pos = {width - 1550 * mult, height - 235 * mult},
			color = nocompletegstands,
		}, 2 * mult, 250)
	end
end
hook.Add( "HUDShouldDraw", "AtumHud", function(elem)
	if IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gstands_atum" and (elem == "CHudHealth" or elem == "CHudAmmo" or elem == "CHudBattery" or elem == "CLHudSecondaryAmmo") and GetConVar("gstands_draw_hud"):GetBool() then
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
			self.Owner:EmitSound(Deploy)
		end
	end
end
local HoldPunch = false
--Creates stand and adds attributes to the stand.
function SWEP:DefineStand()
	if SERVER then
		self:SetStand( ents.Create("Stand_useable"))
		self.Stand = self:GetStand()
		self.Stand:SetOwner(self.Owner)
		self.Stand:SetModel(self.StandModel)
		self.Stand:SetMoveType( MOVETYPE_NOCLIP )
		self.Stand:SetAngles(self.Owner:GetAngles())
		self.Stand:SetPos(self.Owner:GetBonePosition(0)+Vector(0, 0, 0))
		self.Stand:DrawShadow(false)
		self.Stand.Range = self.Range
		self.Stand.Speed = 20 * self.Speed
		self.Stand.Wep = self
		self.Stand.AnimSet = {
			"SWIMMING_all", 1,
			"GMOD_BREATH_LAYER", 1,
			"AIMLAYER_CAMERA", 0,
			"IDLE_ALL_02", 0.5,
			"FIST_BLOCK", 0.6,
		}
		self.Stand:Spawn()
	end
	timer.Simple(0.1, function()
		if self.Stand:IsValid() then
				self.Stand.rgl = 1
				self.Stand.ggl = 1
				self.Stand.bgl = 1
				self.Stand.rglm = 1.3
				self.Stand.gglm = 1.3
				self.Stand.bglm = 1.3
		end
	end)
end

function SWEP:Think()
		self.Stand = self:GetStand()

	if !self.Stand:IsValid() then
		self:DefineStand()
	end
	if self.GetStand and self:GetStand().GetInDoDoDo and self:GetStand():GetInDoDoDo() then
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
end

function SWEP:PrimaryAttack()
	if SERVER and self.Owner and self.Owner:IsValid() and self.Stand:IsValid() then
		self.Stand:ReleaseSoulsATM(false)
	end
end

function SWEP:GetAtumClosest(ply, ply2, vec)
	local closestply
	local closestdist
	for k, v in pairs(player.GetAll()) do
		if v != ply and v != ply2 then
			local dist = vec:Distance(v:GetPos())
			if not closestdist then
				closestdist = dist
				closestply = v
			end
			if dist < closestdist then
				closestdist = dist
				closestply = v
			end
		end
	end
    if closestply and closestply:WorldSpaceCenter():Distance(self.Owner:WorldSpaceCenter()) <= 500 and IsPlayerStandUser(closestply) then
	return closestply
    else
    return NULL
    end
end

if SERVER then
	util.AddNetworkString("atm.quest")
	util.AddNetworkString("atm.questlook")
	local names = {
		"#gstands.atum.chat.q1",
		"#gstands.atum.chat.q2",
		"#gstands.atum.chat.q3",
		"#gstands.atum.chat.q4",
		"#gstands.atum.chat.q5",
		"#gstands.atum.chat.q6",
		"#gstands.atum.chat.q7",
		"#gstands.atum.chat.q8",
		"#gstands.atum.chat.q9",
		"#gstands.atum.chat.q10",
		"#gstands.atum.chat.q11",
		"#gstands.atum.chat.q12",
	}
	local tab = {
		function(ent, user)
			if IsPlayerStandUser(ent) then
				user:ChatPrint("Yes Yes Yes")
				net.Start("atm.questlook")
					net.WriteInt(1, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			else
				user:ChatPrint("No No No")
				net.Start("atm.questlook")
					net.WriteInt(0, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			end
		end,
		function(ent, user)
			if ent:GetActiveWeapon():GetClass() == "gstands_star_platinum" then
				user:ChatPrint("Yes Yes Yes")
				net.Start("atm.questlook")
					net.WriteInt(1, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			else
				user:ChatPrint("No No No")
				net.Start("atm.questlook")
					net.WriteInt(0, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			end
		end,
		function(ent, user)
			if #ent:GetWeapons() > 0 then
				user:ChatPrint("Yes Yes Yes")
				net.Start("atm.questlook")
					net.WriteInt(1, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			else
				user:ChatPrint("No No No")
				net.Start("atm.questlook")
					net.WriteInt(0, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			end
		end,
		function(ent, user)
			if ent:GetMaxHealth() > ent:Health() then
				user:ChatPrint("Yes Yes Yes")
				net.Start("atm.questlook")
					net.WriteInt(1, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			else
				user:ChatPrint("No No No")
				net.Start("atm.questlook")
					net.WriteInt(0, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			end
		end,
		function(ent, user)
			if ent:Frags() > 0 then
				user:ChatPrint("Yes Yes Yes")
				net.Start("atm.questlook")
					net.WriteInt(1, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			else
				user:ChatPrint("No No No")
				net.Start("atm.questlook")
					net.WriteInt(0, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			end
		end,
		function(ent, user)
			if ent:IsAdmin() then
				user:ChatPrint("Yes Yes Yes")
				net.Start("atm.questlook")
					net.WriteInt(1, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			else
				user:ChatPrint("No No No")
				net.Start("atm.questlook")
					net.WriteInt(0, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			end
		end,
		function(ent, user)
			if IsPlayerStandUser(ent) and ent:GetActiveWeapon():IsValid() and string.StartWith(ent:GetActiveWeapon():GetClass(), "gstands_") and ent:GetActiveWeapon().Stand and ent:GetActiveWeapon().Stand.Range >= 800 then
				user:ChatPrint("Yes Yes Yes")
				net.Start("atm.questlook")
					net.WriteInt(1, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			else
				user:ChatPrint("No No No")
				net.Start("atm.questlook")
					net.WriteInt(0, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			end
		end,
		function(ent, user)
			if user:Team() == ent:Team() then
				user:ChatPrint("Yes Yes Yes")
				net.Start("atm.questlook")
					net.WriteInt(1, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			else
				user:ChatPrint("No No No")
				net.Start("atm.questlook")
					net.WriteInt(0, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			end
		end,
		function(ent, user)
			if ent:GetActiveWeapon():IsValid() and ent:GetModel() != ent:GetActiveWeapon().OldModel and ent:GetActiveWeapon().OldModel then
				user:ChatPrint("Yes Yes Yes")
				net.Start("atm.questlook")
					net.WriteInt(1, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			else
				user:ChatPrint("No No No")
				net.Start("atm.questlook")
					net.WriteInt(0, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			end
		end,
		function(ent, user)
			if ent:GetActiveWeapon():GetClass() == "gstands_star_platinum" or ent:GetActiveWeapon():GetClass() == "gstands_the_world" then
				user:ChatPrint("Yes Yes Yes")
				net.Start("atm.questlook")
					net.WriteInt(1, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			else
				user:ChatPrint("No No No")
				net.Start("atm.questlook")
					net.WriteInt(0, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			end
		end,
		function(ent, user)
			if ent:Armor() > 0 then
				user:ChatPrint("Yes Yes Yes")
				net.Start("atm.questlook")
					net.WriteInt(1, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			else
				user:ChatPrint("No No No")
				net.Start("atm.questlook")
					net.WriteInt(0, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			end
		end,
		function(ent, user)
			if user:GetActiveWeapon():GetAtumClosest(user, ent, user:EyePos()):IsValid() then
				user:ChatPrint("Yes Yes Yes")
				net.Start("atm.questlook")
					net.WriteInt(1, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			else
				user:ChatPrint("No No No")
				net.Start("atm.questlook")
					net.WriteInt(0, 5)
					net.WriteEntity(ent)
					net.WriteEntity(user)
				net.Send(user)
			end
		end,
	}
	net.Receive("atm.quest", function()
	local id = net.ReadInt(5)
	local ent = net.ReadEntity()
	local user = net.ReadEntity()
	user:SayFormatted(names[id], ent:GetName())
	tab[id](ent, user)
	end)
	end
if CLIENT then
	net.Receive("atm.questlook", function()
	local response = net.ReadInt(5)
	local ent = net.ReadEntity()
	local user = net.ReadEntity()
	if CLIENT then
	InView = true
	timer.Simple(3, function() InView = false hook.Remove("PreDrawEffects","SoulReadAtum") ent.AtumTextOffset = nil end)
	timer.Simple(0.5, function() ent.AtumTextOffset = nil end)
	timer.Simple(1, function() ent.AtumTextOffset = nil end)
	timer.Simple(1.5, function() ent.AtumTextOffset = nil end)
	timer.Simple(2, function() ent.AtumTextOffset = nil end)
	timer.Simple(2.5, function() ent.AtumTextOffset = nil end)
	surface.PlaySound(View)
	if response == 0 then
		surface.PlaySound(No)
	else
		surface.PlaySound(Yes)
	end
	hook.Add("PreDrawEffects","SoulReadAtum",function()
	if InView then
		local darken = {
		["$pp_colour_addr"] 		= 150/255,
		["$pp_colour_addg"] 		= 150/255,
		["$pp_colour_addb"] 		= 175/255,
		["$pp_colour_brightness"] 	= -.85,
		["$pp_colour_contrast"] 	= .4,
		["$pp_colour_colour"] 		= 0,
		["$pp_colour_mulr"] 		= 1,
		["$pp_colour_mulg"] 		= 1,
		["$pp_colour_mulb"] 		= 1,
		}  
		local darken2 = {
		["$pp_colour_addr"] 		= 0/255,
		["$pp_colour_addg"] 		= 0/255,
		["$pp_colour_addb"] 		= 0/255,
		["$pp_colour_brightness"] 	= 0.3,
		["$pp_colour_contrast"] 	= 1,
		["$pp_colour_colour"] 		= -1,
		["$pp_colour_mulr"] 		= -3,
		["$pp_colour_mulg"] 		= -1,
		["$pp_colour_mulb"] 		= 10,
		}  
		DrawColorModify(darken)
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
		-- surface.SetDrawColor(0,255,255,0)
		-- if response == 0 then
		surface.SetDrawColor(255,255,255,0)
		-- end
		local w,h = ScrW(),ScrH()
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
		
		local prevNoDraw = ent:GetNoDraw()
		ent:SetNoDraw(false)
		local prevRenderMode = ent:GetRenderMode()
		--ent:SetRenderMode(RENDERMODE_TRANSALPHADD)
		ent:SetModelScale(1.0+math.Rand(0.01,0.013),0) 
		ent:DrawModel()
		ent:SetModelScale(1,0) 
		render.SetBlend(1)
		ent:SetRenderMode(prevRenderMode)
		ent:SetNoDraw(prevNoDraw)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
		
				DrawColorModify(darken2)
		DrawMaterialOverlay("models/shadertest/predator", 0.1)

		render.SetStencilEnable(false)
		render.SetBlend(1)
		cam.End3D2D()
		ent.AtumTextOffset = ent.AtumTextOffset or VectorRand() * 20
		local ang = LocalPlayer():EyeAngles()
		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( ang:Right(), 90 )
		cam.Start3D2D( ent:EyePos() + ent.AtumTextOffset, Angle( 0, ang.y, 90 ), 0.25 )
		if response == 0 then
		draw.DrawText( "NO!", "DermaLarge", 2, 2, Color( 255, 0, 155, 205 ), TEXT_ALIGN_CENTER )

		else
		draw.DrawText( "YES!", "DermaLarge", 2, 2, Color( 0, 255, 155, 205 ), TEXT_ALIGN_CENTER )
		end
		cam.End3D2D()
		DrawMaterialOverlay("models/shadertest/predator", 0.05)
	end
	end)
	end
	end)

end
function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 1)
	if CLIENT and IsFirstTimePredicted() then
		local tr = util.TraceLine( {
			start = self.Stand:GetEyePos(),
			endpos = self.Stand:GetEyePos() + self.Owner:GetAimVector() * self.HitDistance * 15,
			filter = {self.Owner,self.Stand},
			mask = MASK_SHOT_HULL
		} )
		if tr.Entity:IsPlayer() then
		local dPanel = vgui.Create("DFrame")
		dPanel:SetSize(250, 250)
		dPanel:Center()
		dPanel:SetDraggable(false)
		dPanel:MakePopup()
		dPanel:SetTitle(" ")
		dPanel:SetBackgroundBlur(true)
		dPanel:ShowCloseButton(false)
		dPanel:SetPaintShadow(false)
		
		local dOp1 = vgui.Create("DListView", dPanel)
		dOp1:Dock(FILL)
		dOp1:SetMultiSelect(false)
		dOp1:AddColumn(tr.Entity:Name().."..")
		dOp1:AddLine("#gstands.atum.question.q1")
		dOp1:AddLine("#gstands.atum.question.q2")
		dOp1:AddLine("#gstands.atum.question.q3")
		dOp1:AddLine("#gstands.atum.question.q4")
		dOp1:AddLine("#gstands.atum.question.q5")
		dOp1:AddLine("#gstands.atum.question.q6")
		dOp1:AddLine("#gstands.atum.question.q7")
		dOp1:AddLine("#gstands.atum.question.q8")
		dOp1:AddLine("#gstands.atum.question.q9")
		dOp1:AddLine("#gstands.atum.question.q10")
		dOp1:AddLine("#gstands.atum.question.q11")
		dOp1:AddLine("#gstands.atum.question.q12")
		dOp1.OnRowSelected = function( lst, index, pnl )
		dPanel:Close()
		
			net.Start("atm.quest")
			net.WriteInt(index, 5)
			net.WriteEntity(tr.Entity)
			net.WriteEntity(self.Owner)
			net.SendToServer()
		end
		end
	end
end

function SWEP:Reload()
end

function SWEP:OnDrop()
	if SERVER and IsValid(self.Stand) then
		self.Stand:ReleaseSouls(true)
		self.Stand:Remove()
	end
end
function SWEP:OnRemove()
	if SERVER and self.Owner and self.Owner:IsValid() and self.Stand:IsValid() then
		self.Stand:ReleaseSouls(true)
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