--Howdy! This is Copper gStands here, to remind you that this addon is unfinished.
--
--As the addon is an alpha state, it is still considered "all rights reserved".
--Therefore, any reuploads of this addon, in full or in part, without direct permission from me, are considered in violation.
--
--Do you really like some of the code in here and want to use it? Just ask me, it's way less of a headache.
--
--That being said, everything here is probably riddled with bugs and incorrect abilities. Hell, most of them I've
--already fixed on newer versions of gStands as I'm writing this.
--
--Why release this alpha addon, Mr "never-gonna-release-an-unfinished-product"?
--Let's just say my hand was forced, I thought about it a whole awful lot, and realised I really don't have
--anything to lose by doing this. Besides, most of this code even now is outdated anyways.
--
--If you have any bugs to report, my gitlab is available at https://gitlab.com/TheCopperWarrior/gStands/issues
--If you want to play the newest versions, my patreon is https://www.patreon.com/gStands
--The discord where you can talk with my community is https://discord.gg/E63y942CY7
--
--Any more questions? Ask me directly, as long as I'm not busy I'll try and respond.


AddCSLuaFile()
include('cl_init.lua')
--Convars
CreateConVar( "gstands_star_platinum_limit", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "#gstands.general.sptimelimit" ) 
CreateConVar( "gstands_the_world_limit", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "#gstands.general.wotimelimit" ) 
CreateConVar( "gstands_stand_see_stands", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "#gstands.general.standusersight" ) 
CreateConVar( "gstands_stand_hurt_stands", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "#gstands.general.standuserharm" ) 
CreateConVar( "gstands_the_world_timestop_length", 10, {FCVAR_REPLICATED, FCVAR_ARCHIVE},"#gstands.general.wolength")
CreateConVar( "gstands_star_platinum_timestop_length", 5, {FCVAR_REPLICATED, FCVAR_ARCHIVE},"#gstands.general.splength")
CreateConVar( "gstands_the_world_next_timestop", 30, {FCVAR_REPLICATED, FCVAR_ARCHIVE},"#gstands.general.wonextstop")
CreateConVar( "gstands_star_platinum_next_timestop", 15, {FCVAR_REPLICATED, FCVAR_ARCHIVE},"#gstands.general.spnextstop")
CreateConVar( "gstands_unlimited_stand_range", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE},"#gstands.general.standrange")
CreateConVar( "gstands_tohth_page_timer", 120, {FCVAR_REPLICATED, FCVAR_ARCHIVE},"#gstands.general.tohthpagetimer")
CreateConVar( "gstands_the_sun_range", 5000, {FCVAR_REPLICATED, FCVAR_ARCHIVE},"#gstands.general.sunrange")
CreateConVar( "gstands_deploy_sounds", 1, {FCVAR_CHEAT, FCVAR_ARCHIVE},"#gstands.general.deploysounds")
CreateConVar( "gstands_user_id_stands", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE},"#gstands.general.steamidstands")

CreateClientConVar( "gstands_time_stop", 0, false, false, "Is time stopped? (IGNORE)" ) 
CreateClientConVar( "gstands_time_stopping", 0, false, false, "Is time stopping? (IGNORE)" ) 
function StandSkinConVars() 
	for k, v in pairs( weapons.GetList() ) do
		if ( !string.StartWith( v.ClassName, "gstands_" ) ) then continue end
		if v.PrintName and v.StandModel then
			CreateConVar( "gstands_standskin_"..v.ClassName, "0",{FCVAR_USERINFO, FCVAR_ARCHIVE} )
		end
	end
end
CreateConVar( "gstands_binds_modeswap", KEY_R,{FCVAR_USERINFO, FCVAR_ARCHIVE} )
CreateConVar( "gstands_binds_modifierkey1", KEY_LSHIFT,{FCVAR_USERINFO, FCVAR_ARCHIVE} )
CreateConVar( "gstands_binds_modifierkey2", KEY_E,{FCVAR_USERINFO, FCVAR_ARCHIVE} )
CreateConVar( "gstands_binds_taunt", KEY_G,{FCVAR_USERINFO, FCVAR_ARCHIVE} )
CreateConVar( "gstands_binds_tertattack", MOUSE_MIDDLE,{FCVAR_USERINFO, FCVAR_ARCHIVE} )
CreateConVar( "gstands_binds_dododo", KEY_LALT,{FCVAR_USERINFO, FCVAR_ARCHIVE} )
CreateConVar( "gstands_binds_standleap", KEY_X,{FCVAR_USERINFO, FCVAR_ARCHIVE} )
CreateConVar( "gstands_binds_defensivemode", KEY_B,{FCVAR_USERINFO, FCVAR_ARCHIVE} )
CreateConVar( "gstands_binds_block", KEY_T,{FCVAR_USERINFO, FCVAR_ARCHIVE} )
CreateConVar( "gstands_binds_standvoice", KEY_H,{FCVAR_USERINFO, FCVAR_ARCHIVE} )

CreateConVar( "gstands_wof_color_r", "255",{FCVAR_USERINFO, FCVAR_ARCHIVE} )
CreateConVar( "gstands_wof_color_g", "255",{FCVAR_USERINFO, FCVAR_ARCHIVE} )
CreateConVar( "gstands_wof_color_b", "255",{FCVAR_USERINFO, FCVAR_ARCHIVE} )
CreateConVar( "gstands_time_stop", 0, {FCVAR_REPLICATED, FCVAR_NONE}, "Is time stopped? (IGNORE)" ) 
CreateConVar( "gstands_can_time_stop", 1, {FCVAR_REPLICATED, FCVAR_NONE}, "#gstands.general.cantimestop" ) 
CreateConVar( "gstands_show_hitboxes", 0, {FCVAR_NONE, FCVAR_CHEAT}, "#gstands.general.hitboxes" ) 
CreateClientConVar( "gstands_opaque_stands", 0, true, false, "#gstands.general.opaque" ) 
CreateClientConVar( "gstands_draw_hud", 1, true, false, "#gstands.general.drawhud" ) 
CreateClientConVar( "gstands_draw_hud_background", 1, true, false, "#gstands.general.drawhudback" ) 
CreateClientConVar( "gstands_draw_avatar", 1, true, false, "#gstands.general.liveavatar" ) 
CreateClientConVar( "gstands_draw_halos", 1, true, false, "#gstands.general.halos" ) 
CreateClientConVar( "gstands_barrage_arms", 3, true, true, "#gstands.general.arms" ) 
CreateClientConVar( "gstands_thirdperson_offset", "0,0,0", true, false, "#gstands.general.tpoffset" ) 
CreateClientConVar( "gstands_firstperson", "0", true, false, "#gstands.general.fp" ) 
CreateClientConVar( "gstands_lights", "1", true, true, "#gstands.general.lights" ) 
CreateClientConVar( "gstands_active_dododo_toggle", "1", true, true, "#gstands.general.dododotog" ) 
CreateClientConVar( "gstands_draw_hdm_mirror", "1", true, true, "#gstands.general.drawhdmmirror" )
CreateClientConVar( "gstands_replacement_gstands_the_world", "models/player/worldjf/world.mdl", true, true, "" )
CreateClientConVar( "gstands_replacement_gstands_star_platinum", "models/player/starpjf/spjf.mdl", true, true, "" )

game.AddParticles("particles/menacing.pcf")

PrecacheParticleSystem("menacing")

hook.Add("AllowPlayerPickup", "PreventStandPickup", function(ply, ent)
	if ply:GetActiveWeapon():IsValid() and string.StartWith(ply:GetActiveWeapon():GetClass(), "gstands_") then
		return false
	end
end)
hook.Add("PlayerSwitchWeapon", "StandInACar", function(ply, owep, wep)
	if SERVER and wep:IsValid() and string.StartWith(wep:GetClass(), "gstands_") then
		ply:SetAllowWeaponsInVehicle(true)
		elseif SERVER then
		ply:SetAllowWeaponsInVehicle(false)
	end
end)
hook.Add("PlayerLeaveVehicle", "StandInACarButNotDoubleOut", function(ply, veh)
	if SERVER and IsValid(ply) and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon().GetStand and IsValid(ply:GetActiveWeapon():GetStand()) then
		if !ply:GetActiveWeapon():GetStand():IsVehicle() then
			ply:GetActiveWeapon():GetStand():Remove()
		end
		end
end)
function math.ClampVector(vec1, min, max)
		local x = math.Clamp(vec1.x, min.x, max.x)
		local y = math.Clamp(vec1.y, min.y, max.y)
		local z = math.Clamp(vec1.z, min.z, max.z)
		return Vector(x,y,z)
end
StandEntTable = StandEntTable or {}
local part3standenttable = {
	"bastent",
	"bearing",
	"bounddevilprop",
	"cfhurricane",
	"chariot_sword",
	"d13raguse",
	"d13room",
	"d13wall",
	"death",
	"dummyplayer",
	"emerald_splash_proj",
	"emperor_bullet",
	"fool_stand",
	"geb",
	"gstands_dbm_whirl",
	"gstands_ragdoll",
	"gstands_tscontroller",
	"hermit_purple_2_camera",
	"hermit_purple_2_trace",
	"hermit_purple_camera",
	"hermit_purple_trace",
	"hg_barrier",
	"hg_trace",
	"highpriestess",
	"horus_ice_spike",
	"kfarose",
	"kfaspores",
	"khnum_orange",
	"mgrlifedetector",
	"sanddome",
	"soul",
	"stand",
	"stand_arrow",
	"stand_player_base",
	"stand_useable",
	"sun_laser",
	"thrown_knife",
	"gstands_sun_entity"
}
table.Merge(StandEntTable, part3standenttable)
AStandEntTable = AStandEntTable or {}
local part3standtable = {
	"bastent",
	"bounddevilprop",
	"death",
	"fool_stand",
	"geb",
	"highpriestess",
	"stand",
	"stand_player_base",
	"stand_useable",
	"lovers",
	"gstands_sun_entity"
}
table.Merge(AStandEntTable, part3standtable)
hook.Add("CanProperty", "DontTouchStands", function(ply, property, ent)
	if table.HasValue(StandEntTable, ent:GetClass()) then
		return false
	end
end)
hook.Add("CanTool", "DontTouchStands", function(ply, tr, tool)
	if IsValid(tr.Entity) and table.HasValue(StandEntTable, tr.Entity:GetClass()) then
		return false
	end
end)


local ModelCheckTable = {
	["models/player/atm/atm.mdl"] = true,
	["models/player/creamrv/crm.mdl"] = true,
	["models/player/dbm/dbm.mdl"] = true,
	["models/player/heg/heg.mdl"] = true,
	["models/hipriestess/highpriestess.mdl"] = true,
	["models/player/jgm/jgm.mdl"] = true,
	["models/player/mgr/mgr.mdl"] = true,
	["models/player/osi/osi.mdl"] = true,
	["models/player/slc/slc.mdl"] = true,
	["models/player/starpjf/spjf.mdl"] = true,
	["models/gstands/stands/thefool.mdl"] = true,
	["models/player/worldjf/world.mdl"] = true,
	["models/player/dio/knifejf.mdl"] = true
}
local CheckModelTable = function()
	local ret = false
	for k,v in pairs(ModelCheckTable) do
		if not ret then
			util.PrecacheModel(k)
			ret = util.IsValidModel(k)
			if false then print(k) end
		end
	end
	return ret
end
if CLIENT then
	gameevent.Listen("player_spawn")
	local Checked = false
	hook.Add("player_spawn", "CheckMissingModels", function(data)
		if not Checked and not CheckModelTable() then
			LocalPlayer():ChatPrint(language.GetPhrase("gstands.general.missingmodels"))
			Checked = true
		end
	end)
end
if SERVER then
	if not CheckModelTable() then
		timer.Simple(5, function()
			MsgN("[gStands] Missing models detected! Please ensure you are subscribed to the whole gStands Alpha Collection here: https://steamcommunity.com/workshop/filedetails/?id=2428229265")
		end)
	end
end
StandTable = StandTable or {}
local part3mdls = {
	--Cream
	["models/player/creamrv/crm.mdl0"] = Vector(0.5,0.5,0.6),
	["models/player/creamrv/crm.mdl1"] = Vector(0.6,0.5,0.5),
	["models/player/creamrv/crm.mdl2"] = Vector(0.6,0.5,0.5),
	["models/player/creamrv/crm.mdl3"] = Vector(0.6,0,0.5),
	--Dark Blue Moon
	["models/player/dbm/dbm.mdl0"] = Vector(0.3,0.6,1),
	["models/player/dbm/dbm.mdl1"] = Vector(0.6,0.3,1),
	["models/player/dbm/dbm.mdl2"] = Vector(1,0.6,0),
	["models/player/dbm/dbm.mdl3"] = Vector(0, 0.6, 0),
	["models/player/dbm/dbm.mdl4"] = Vector(1, 0, 0),
    --Geb
	["models/gstands/stands/geb.mdl0"] = Vector(0.5,0.5,0.6),
	["models/gstands/stands/geb.mdl1"] = Vector(0.7,0.5,0.6),
	["models/gstands/stands/geb.mdl2"] = Vector(0.4,0.7,0.3),
	["models/gstands/stands/geb.mdl3"] = Vector(0.7,0.3,0.8),
	["models/gstands/stands/geb.mdl4"] = Vector(0.1,0.1,0.1),
	["models/gstands/stands/geb.mdl5"] = Vector(1,1,0.9),
	["models/gstands/stands/geb.mdl6"] = Vector(1,1,0),
	["models/gstands/stands/geb.mdl7"] = Vector(0.1,1,0.8),
	["models/gstands/stands/geb_dash.mdl0"] = Vector(0.5,0.5,0.6),
	["models/gstands/stands/geb_dash.mdl1"] = Vector(0.7,0.5,0.6),
	["models/gstands/stands/geb_dash.mdl2"] = Vector(0.4,0.7,0.3),
	["models/gstands/stands/geb_dash.mdl3"] = Vector(0.7,0.3,0.8),
	["models/gstands/stands/geb_dash.mdl4"] = Vector(0.1,0.1,0.1),
	["models/gstands/stands/geb_dash.mdl5"] = Vector(1,1,0.9),
	["models/gstands/stands/geb_dash.mdl6"] = Vector(1,1,0),
	["models/gstands/stands/geb_dash.mdl7"] = Vector(0.1,1,0.8),
	--Hierophant Green
	["models/player/heg/heg.mdl0"] = Vector(0,1,0),
	["models/player/heg/heg.mdl1"] = Vector(0.1,0.3,1),
	["models/player/heg/heg.mdl2"] = Vector(1,0.3,0.5),
	["models/player/heg/heg.mdl3"] = Vector(1,1,0),
	["models/player/heg/heg.mdl4"] = Vector(0,1,0),
	["models/player/heg/heg.mdl5"] = Vector(0.1,0.3,1),
	["models/player/heg/heg.mdl6"] = Vector(1,0.3,0.5),
	["models/player/heg/heg.mdl7"] = Vector(1,1,0),
	--Kiss From a Rose
	["models/kfar/kfar.mdl0"] = Vector(0,1,0),
	--Hermit Purple
	["models/hpworld/hpworld.mdl0"] = Vector(1,1,0,1),
	--Hermit Purple2
	["models/hpworld2/hpworld2.mdl0"] = Vector(1,0,1),
	--Emperor
	["models/emperor/models/emperor.mdl0"] = Vector(1,0.4,1),
	--Horus
	["models/horus/horus.mdl0"] = Vector(0.607843137,0.803921569,0.776470588),  --rgb(155,205,198)
	["models/horus/horus.mdl1"] = Vector(0.5,0.6,0.6),
	["models/horus/horus.mdl2"] = Vector(0.5,0.3,0.5),
	["models/horus/horus.mdl3"] = Vector(0.5,0.5,0.4),
	--Tohth
	["models/tohth/thoth.mdl0"] = Vector(1,0.733333333,1),
	--Justice
	["models/jst/jst.mdl0"] = Vector(0.3,0.3,0.3),
	--Magician's Red
	["models/player/mgr/mgr.mdl0"] = Vector(1,0.4,0),
	["models/player/mgr/mgr.mdl1"] = Vector(1,0.3,0),
	["models/player/mgr/mgr.mdl2"] = Vector(0.3,1,0.3),
	["models/player/mgr/mgr.mdl3"] = Vector(0.3,0.6,1),
	["models/player/mgr/mgr.mdl4"] = Vector(0.6,0,0.7),
	["models/player/mgr/mgr.mdl5"] = Vector(0.6,0.5,0),
	["models/player/mgr/mgr.mdl6"] = Vector(0,1,0),
	["models/player/mgr/mgr.mdl7"] = Vector(0,0.3,0.8),
	
	--Silver Chariot
	["models/player/slc/slc.mdl0"] = Vector(0.5,0.5,0.5),
	["models/player/slc/slc.mdl1"] = Vector(1,1,0.5),
	["models/player/slc/slc.mdl2"] = Vector(0.9,0.6,0.1),
	["models/player/slc/slc.mdl3"] = Vector(0.9,1,0.5),
	["models/player/slc/slc.mdl4"] = Vector(0.3, 0.3, 0.35),
	["models/player/slc/slc.mdl5"] = Vector(0.4,0.4,0.4),
	["models/player/slc/slc.mdl6"] = Vector(0,0.4,1),
	["models/player/slc/slc.mdl7"] = Vector(1,0.1,0.4),
	["models/player/slc/slc_un.mdl0"] = Vector(0.5,0.5,0.5),
	["models/player/slc/slc_un.mdl1"] = Vector(1,1,0.5),
	["models/player/slc/slc_un.mdl2"] = Vector(0.9,0.6,0.3),
	["models/player/slc/slc_un.mdl3"] = Vector(0.9,1,0.5),
	["models/player/slc/slc_un.mdl4"] = Vector(0.3, 0.3, 0.35),
	["models/player/slc/slc_un.mdl5"] = Vector(0.4,0.4,0.4),
	["models/player/slc/slc_un.mdl6"] = Vector(0,0.4,1),
	["models/player/slc/slc_un.mdl7"] = Vector(1,0.1,0.4),
	--Star Platinum
	["models/player/starprv/sp.mdl0"] = Vector(0.6,0.4,1),
	["models/player/starprv/sp.mdl1"] = Vector(0.5,0.9,0.5),
	["models/player/starprv/sp.mdl2"] = Vector(0.8,0.4,1),
	["models/player/starprv/sp.mdl3"] = Vector(0,0.4,1),
	["models/player/starprv/sp.mdl4"] = Vector(0.6,0.4,1),
	["models/player/starprv/sp.mdl5"] = Vector(0.3,0.4,1),
	["models/player/starprv/sp.mdl6"] = Vector(1,1,0),
	["models/player/starprv/sp.mdl7"] = Vector(0.5,0,1),
	["models/player/starprv/sparms.mdl1"] = Vector(0.5,0,1),
	--Star Platinum JF
	["models/player/starpjf/spjf.mdl0"] = Vector(0.8,0.4,1),
	["models/player/starpjf/spjf.mdl1"] = Vector(0.2,0.6,1),
	["models/player/starpjf/spjf.mdl2"] = Vector(0.8,0.4,1),
	["models/player/starpjf/spjf.mdl3"] = Vector(0.5,0.9,0.5),
	["models/player/starpjf/spjf.mdl4"] = Vector(0.6,0.6,0),
	["models/player/starpjf/spjf.mdl5"] = Vector(1,0.2,0),
	["models/player/starpjf/spjfarms.mdl1"] = Vector(1,0.2,0),
	--World
	["models/player/worldrv/world.mdl0"] = Vector(1,0.8,0),
	["models/player/worldrv/world.mdl1"] = Vector(0.9,0.9,0.5),
	["models/player/worldrv/world.mdl2"] = Vector(1,0.3,0.3),
	["models/player/worldrv/world.mdl3"] = Vector(0,1,1),
	["models/player/worldrv/world.mdl4"] = Vector(1,0.8,0),
	["models/player/worldrv/world.mdl5"] = Vector(0.9,0.9,0.5),
	["models/player/worldrv/world.mdl6"] = Vector(1,0.3,0.3),
	["models/player/worldrv/world.mdl7"] = Vector(0.3,0,1),
	["models/player/worldrv/worldarms.mdl1"] = Vector(0.3,0,1),
	--WorldJF
	["models/player/worldjf/world.mdl0"] = Vector(0.6,0.5,0),
	["models/player/worldjf/world.mdl1"] = Vector(0.9,0.9,0.5),
	["models/player/worldjf/world.mdl2"] = Vector(0.5,0.7,0.5),
	["models/player/worldjf/world.mdl3"] = Vector(0,0.6,0.6),
	["models/player/worldjf/world.mdl4"] = Vector(0.6,0,0),
	["models/player/worldjf/world.mdl5"] = Vector(0.8,0,0.5),
	["models/player/worldjf/world.mdl6"] = Vector(0.6,0,0.7),
	["models/player/worldjf/world.mdl7"] = Vector(0,0.6,0.7),
	["models/player/worldjf/worldarms.mdl1"] = Vector(0,0.6,0.7),
	--Tower of Gray
	["models/tgray/tgray.mdl0"] = Vector(0.35,0.40,0.35),
	--Death 13
	["models/d13/d13.mdl0"] = Vector(0.5, 0, 0.5),
	["models/d13/d13.mdl1"] = Vector(0.5, 0.3,  0.5),
	["models/d13/balloon.mdl0"] = Vector(0.5, 0, 0.5),
	--Kiss From a Rose
	["models/kfar/kfar.mdl"] = Vector(0.1,1,0.1),
	--Osiris
	["models/player/osi/osi.mdl0"] = Vector(0.29,0.40,0.28),
	--Atum
	["models/player/atm/atm.mdl0"] = Vector(0.5,0.1,0.3),
	["models/player/atm/atm.mdl1"] = Vector(0.1,0.3,0.5),
	["models/player/atm/atm.mdl2"] = Vector(0.5,0.5,0.1),
	["models/player/atm/atm.mdl3"] = Vector(0.8,0.6,0.3),
	["models/player/atm/atm.mdl4"] = Vector(0.6,0.1,1),
	--High Priestess
	["models/hipriestess/highpriestess.mdl0"] = Vector(0.5, 0.5, 0.5),
	["models/hipriestess/highpriestess.mdl1"] = Vector(1, 0.9, 0.4),
	["models/hipriestess/highpriestess.mdl2"] = Vector(0.3,1,0.3),
	["models/hipriestess/highpriestess.mdl3"] = Vector(0.6,0.1,1),
	--Judgement
	["models/player/jgm/jgm.mdl0"] = Vector(1, 1, 1),
	["models/player/jgm/jgm.mdl1"] = Vector(1, 0.9, 0.4),
	["models/player/jgm/jgm.mdl2"] = Vector(0.670588235, 0.780382157, 0.964705882),
	["models/player/jgm/jgm.mdl3"] = Vector(0.788235294, 0.694117647, 0.980392157),
	["models/player/jgm/jgm.mdl4"] = Vector(0.301960784, 0.51372549, 0.870588235),
	--Anubis
	["models/anubis/w_anubis.mdl"] = Vector(1, 1, 1),
	["models/anubis/w_anubis.mdl0"] = Vector(1, 1, 1),
	--Fool
	["models/gstands/stands/thefool.mdl0"] = Vector(0.5, 0.5, 0.5),
	["models/gstands/stands/thefool.mdl1"] = Vector(1, 1, 0.5),
	["models/gstands/stands/thefool.mdl2"] = Vector(1, 0.3, 0),
	["models/gstands/stands/thefool.mdl3"] = Vector(0.8, 0.8, 0.5),
	["models/gstands/stands/thefool.mdl4"] = Vector(1, 0.5, 0),
	["models/gstands/stands/thefool.mdl5"] = Vector(0.8, 0.8, 1),
	["models/gstands/stands/dome.mdl0"] = Vector(0.5, 0.5, 0.5),
	["models/gstands/stands/dome.mdl1"] = Vector(1, 1, 0.5),
	["models/gstands/stands/dome.mdl2"] = Vector(1, 0.3, 0),
	["models/gstands/stands/dome.mdl3"] = Vector(1, 0.5, 0),
	["models/gstands/stands/dome.mdl4"] = Vector(0.5, 0.5, 0.5),
	["models/gstands/stands/dome.mdl5"] = Vector(0.8, 0.8, 1),
	["models/gstands/stand_acc/foolsand_effect.mdl0"] = Vector(0.5, 0.5, 0.5),
	["models/gstands/stand_acc/foolsand_effect.mdl1"] = Vector(1, 1, 0.5),
	["models/gstands/stand_acc/foolsand_effect.mdl2"] = Vector(1, 0.3, 0),
	["models/gstands/stand_acc/foolsand_effect.mdl3"] = Vector(1, 0.5, 0),
	["models/gstands/stand_acc/foolsand_effect.mdl4"] = Vector(0.5, 0.5, 0.5),
	["models/gstands/stand_acc/foolsand_effect.mdl5"] = Vector(0.8, 0.8, 1),
	--Copper
	["models/player/copper/copper.mdl0"] = Vector(0.6,0.4,0.2),
	["models/player/copper/copper.mdl1"] = Vector(0.6,0.4,0.2),
	["models/player/copper/copper.mdl2"] = Vector(0.6,0.4,0.2),
	--Wheel of Fortune
	["models/wof/wof.mdl0"] = Vector(1,0.1,1),
	["models/buggy.mdl0"] = Vector(1,0.1,1),
	--Hanged Man
	["models/hdm/hdm.mdl0"] = Vector(1, 0, 1),
	["models/hdm/hdm.mdl1"] = Vector(0.3, 0, 1),
	["models/hdm/hdm.mdl2"] = Vector(1, 1, 0.5),
	["models/hdm/hdm.mdl3"] = Vector(1, 0.3, 1),
	--Lovers
	["models/lovers/lovers.mdl0"] = Vector(1, 0.7, 0.3),
	["models/lovers/lovers.mdl2"] = Vector(0.3, 0, 1),
	["models/lovers/lovers.mdl1"] = Vector(1, 1, 0.5),
	["models/lovers/lovers.mdl3"] = Vector(0.3, 1, 0.3),
	--Empress
	["models/empress/empress.mdl0"] = Vector(1, 0.7, 0.3),
	--The sun
	["models/sun/gstands_sun.mdl0"] = Vector(0.6,0.5,0),
	--Temperance
	["models/yellowtemperance/yellowtemperance.mdl0"] = Vector(1,1,0),
}
table.Merge(StandTable, part3mdls)
function IsPlayerStandUser(ply)
	if !GetConVar("gstands_stand_see_stands"):GetBool() then
		return true
	end
	if ply["StandUser"] then return true else
	local ret = false
	for k,v in ipairs(ply:GetWeapons()) do
		if string.StartWith(v:GetClass(), "gstands_") or string.StartWith(v:GetClass(), "jjgma_") or string.StartWith(v:GetClass(), "fres_") then
			ret = true
			ply["StandUser"] = true
		end
	end
	return ret
	end
end
function CanPlayerTimeStop(ply)
	if !IsPlayerStandUser(ply) then
		return false
	end
	if ply["CanTimeStop"] then return true else
	local ret = false
	for k,v in ipairs(ply:GetWeapons()) do
		if v.CanTimeStop then
			ret = true
			ply["CanTimeStop"] = true
		end
	end
	return ret
	end
end
function GetPlayerTimeStopWep(ply)
	if !CanPlayerTimeStop(ply) then
		return false
	end
	local ret = false
	for k,v in ipairs(ply:GetWeapons()) do
		if v.CanTimeStop then
			ret = v
		end
	end
	return ret
end
hook.Add("PostPlayerDeath", "RemoveStandUserStatus", function(ply)
	ply["StandUser"] = false
	ply["CanTimeStop"] = false
	net.Start("ClearStandUserStatus")
	net.WriteEntity(ply)
	net.Broadcast()
end)
if SERVER then
	util.AddNetworkString("ClearStandUserStatus")
end
if CLIENT then
	net.Receive("ClearStandUserStatus", function()
		local ent = net.ReadEntity()
		ent["StandUser"] = false
		ent["CanTimeStop"] = false
	end)
end
	
local steamlock = GetConVar("gstands_user_id_stands")
local Weapons = weapons.GetList()
local standList = {
}
for k, weapon in pairs( Weapons ) do

	if ( !string.StartWith( weapon.ClassName, "gstands_" ) or weapon.ClassName == "gstands_copper" ) then continue end
	table.insert( standList, weapon.ClassName )

end
if SERVER then
	hook.Add("PlayerLoadout", "StandSteamIDLock", function(ply)
		if steamlock:GetBool() then
			timer.Simple(0, function() 
				if IsValid(ply) then 
					ply:Give(standList[tonumber(ply:AccountID()) % (#standList)]) 
					if not ply.BoundStand then 
						ply.BoundStand = standList[tonumber(ply:AccountID()) % (#standList - 1)] 
						ply:ChatPrint("#gstands.general.steamlockbind")
					end 	
				end 	
			end)
		end
	end)
	hook.Add("WeaponEquip", "StandSteamIDLock", function(wep, ply)
		if steamlock:GetBool() and ply.BoundStand and string.StartWith(wep:GetClass(), "gstands_") and wep:GetClass() ~= ply.BoundStand then
			ply:ChatPrint("#gstands.general.steamlockbindfail")
			ply:DropWeapon(wep)
			wep:Remove()
			ply:SelectWeapon(ply.BoundStand)
		end
	end)
end

gStands = {}
for i=0, 100 do
	gStands[i] = nil
end
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

local ply_should_draw = false

hook.Add("ShouldDrawLocalPlayer", "HudAvatarCheck", function(ply)
	if ply_should_draw then
		cam.Start3D()
		cam.End3D()
		return true
	end
end)

function gStands.DrawBaseHud(self, color, width, height, mult, tcolor)
	if GetConVar("gstands_draw_hud_background"):GetBool() then
		surface.SetMaterial(corner_left)
		surface.SetDrawColor(color)
		surface.DrawTexturedRect(0, height - 512 * mult, 1024 * mult, 512 * mult)
		
		surface.SetMaterial(corner_right)
		surface.SetDrawColor(color)
		surface.DrawTexturedRect(width - 512 * mult, height - 1024 * mult, 512 * mult, 1024 * mult)
	end
	surface.SetMaterial(pfpback)
	surface.SetDrawColor(color)
	surface.DrawTexturedRect(58.975 * mult, height - (225.6 * mult) - 80 * mult, 225.6 * mult, 225.6 * mult)
	if GetConVar("gstands_draw_avatar"):GetBool() then
		LocalPlayer():SetupBones()
		local ownerOGPos = LocalPlayer():GetPos()
		local ppos, pang = LocalPlayer():GetBonePosition(0)
		local _,bounds = LocalPlayer():GetModelBounds() 
		local plyheight = (bounds.z/72) * LocalPlayer():GetModelScale()
		local eyepos = LocalPlayer():GetPos() + Vector(0, 0, 61 * plyheight)
		if LocalPlayer().m_bJumping and !LocalPlayer():IsFlagSet( FL_ANIMDUCKING ) then
			eyepos = eyepos - pang:Forward() * 5 - pang:Up() * 3
		end
		if !LocalPlayer().m_bJumping and LocalPlayer():IsFlagSet( FL_ANIMDUCKING ) then
			eyepos = eyepos - Vector(0,0,20) - pang:Forward() * 5
		end
		local ownerOGAngles = LocalPlayer():GetRenderAngles()
		local camang = EyeVector():Angle()
		camang.p = 0
		
		render.SetStencilWriteMask( 0xFF )
		render.SetStencilTestMask( 0xFF )
		render.SetStencilReferenceValue( 0 )
		render.SetStencilCompareFunction( STENCIL_ALWAYS )
		render.SetStencilPassOperation( STENCIL_KEEP )
		render.SetStencilFailOperation( STENCIL_KEEP )
		render.SetStencilZFailOperation( STENCIL_KEEP )
		render.ClearStencil()
		
		
		render.SetStencilEnable( true )
		
		render.SetStencilReferenceValue( 1 )
		
		render.SetStencilCompareFunction( STENCIL_EQUAL )
		
		local w, h = ScrW() / 3, ScrH() / 3
		local x_start, y_start = w, h
		local x_end, y_end = x_start + w, y_start + h
		render.ClearStencilBufferRectangle( 58.975 * mult + (40 * mult), height - (128 * mult) - (388 * mult), 58.975 * mult + (388 * mult), height - (125 * mult), 1 )
		ply_should_draw = true
		cam.Start3D(eyepos - Vector(0,0,3) + camang:Right() * 5 - camang:Forward() * (18* LocalPlayer():GetModelScale()), camang, nil, 58.975 * mult, height - (300 * mult) - 80 * mult, 300 * mult, 300 * mult, 1, 225.6) 
		local normal = Vector(0,0,1)
		local position = normal:Dot(LocalPlayer():WorldSpaceCenter() + normal * 9 )
		for i = 0, LocalPlayer():GetNumPoseParameters() - 1 do
			local sPose = LocalPlayer():GetPoseParameterName( i )
			if sPose == "move_y" or sPose == "move_x" then
				LocalPlayer():SetPoseParameter( sPose, 0 )
			end
		end
		local seq = LocalPlayer():GetSequence()
		local cycl = LocalPlayer():GetCycle()
		LocalPlayer():SetCycle(0)
		local ang = ownerOGAngles
		ang.y = (-LocalPlayer():GetAimVector()):Angle().y + 48
		if self:GetHoldType() == "pistol" then
			ang.y = (-LocalPlayer():GetAimVector()):Angle().y + 5
		end
		render.SetColorModulation(1, 1, 1)
		render.SetBlend(1)
		LocalPlayer():InvalidateBoneCache()
		LocalPlayer():SetupBones()
		LocalPlayer():SetRenderAngles(ang)
		LocalPlayer():SetupBones()
		LocalPlayer():SetEyeTarget(LocalPlayer():EyePos() + LocalPlayer():GetForward())
		LocalPlayer():SetPos(ownerOGPos)
		LocalPlayer():SetupBones()
		LocalPlayer():DrawModel()
		LocalPlayer():SetRenderAngles(ownerOGAngles)
		LocalPlayer():SetCycle(cycl)
		
		cam.End3D()
		ply_should_draw = false
		render.SetStencilEnable( false )
	end
	surface.SetMaterial(pfpfront)
	surface.DrawTexturedRect(58.975 * mult, height - (225.6 * mult) - 80 * mult, 225.6 * mult, 225.6 * mult)
	surface.SetDrawColor(255,255,255,255)
	surface.SetMaterial(health_bar)
	surface.DrawTexturedRectUV(250 * mult, height - (65 * mult) - 80 * mult, math.Clamp(math.Remap(LocalPlayer():Health(), 0, LocalPlayer():GetMaxHealth(), 0, 512 * mult), 0, 512 * mult), 64 * mult, 0, 0, math.Remap(LocalPlayer():Health(), 0, LocalPlayer():GetMaxHealth(), 0, 1), 1)
	surface.SetMaterial(bar_border)
	surface.DrawTexturedRect(250 * mult, height - (65 * mult) - 80 * mult, 512 * mult, 64 * mult)
	local str = language.GetPhrase("gstands.hud.health")
	draw.TextShadow({
		text = string.format(str,LocalPlayer():Health(),LocalPlayer():GetMaxHealth()),
		font = "gStandsFont",
		pos = {290 * mult, height - 170 * mult},
		color = tcolor
	}, 2 * mult, 250)
	
	surface.SetMaterial(armor_bar)
	surface.DrawTexturedRectUV(150 * mult, height - (32 * mult) - 55 * mult,  math.Clamp(math.Remap(LocalPlayer():Armor(), 0, 100, 0, 256 * mult), 0, 256 * mult), 32 * mult, 0, 0, math.Remap(LocalPlayer():Armor(), 0, 100, 0, 1), 1)
	surface.SetMaterial(bar_border)
	surface.DrawTexturedRect(150 * mult, height - (32 * mult) - 55 * mult, 256 * mult, 32 * mult)
	surface.SetDrawColor(color)
	
	str = language.GetPhrase("gstands.hud.armor")
	draw.TextShadow({
		text = string.format(str,LocalPlayer():Armor()),
		font = "gStandsFont",
		pos = {120 * mult, height - 55 * mult},
		color = tcolor
	}, 2 * mult, 250)
	local font = "gStandsFontLarge"
	local name = LocalPlayer():GetName()
	if #name > 10 then
		font = "gStandsFont"
	end
	draw.TextShadow({
		text = name,
		font = font,
		pos = {20 * mult, height - 200 * mult},
		color = tcolor
		}, 2 * mult, 250)
end

for k,v in pairs(StandTable) do
   util.PrecacheModel(string.Trim(k, string.Right(k, 1)))
   --MsgC(Color(v.X * 255, v.Y * 255, v.Z * 255), "gStands: Cached ", string.Trim(k, string.Right(k, 1)), "\n")
end
local ColorTable = StandTable
function gStands.GetStandColor(mdl, skin)
	index = mdl..skin
	return ColorTable[index] or Vector(255,255,255)
end
function gStands.GetStandColorTable(mdl, skin)
	index = mdl..skin
	local clr = Color(255, 255, 255)
	if ColorTable[index] then clr = ColorTable[index]:ToColor() end
	return clr
end
StandSoundsTable = StandSoundsTable or {}
local part3snds = {
	[MAT_ANTLION] = "Strider.Impact",
	[MAT_BLOODYFLESH] = "Flesh.ImpactHard",
	[MAT_CONCRETE] = "Bounce.Concrete",
	[MAT_DIRT] = "Dirt.Impact",
	[MAT_EGGSHELL] = "Concrete.ImpactSoft",
	[MAT_FLESH] = "Flesh.ImpactHard",
	[MAT_GRATE] = "MetalGrate.BulletImpact",
	[MAT_ALIENFLESH] = "Flesh.ImpactHard",
	[MAT_CLIP] = "Flesh.ImpactHard",
	[MAT_SNOW] = "Dirt.Impact",
	[MAT_PLASTIC] = "Plastic_Box.ImpactHard",
	[MAT_METAL] = "Metal_Barrel.ImpactHard",
	[MAT_SAND] = "Sand.BulletImpact",
	[MAT_COMPUTER] = "Computer.ImpactHard",
	[MAT_SLOSH] = "Physics.WaterSplash",
	[MAT_TILE] = "Tile.BulletImpact",
	[MAT_GRASS] = "Dirt.Impact",
	[MAT_VENT] = "MetalGrate.ImpactHard",
	[MAT_WOOD] = "Wood_Crate.ImpactHard",
	[MAT_DEFAULT] = "Flesh.ImpactHard",
	[MAT_GLASS] = "Glass.ImpactHard",
	[MAT_WARPSHIELD] = "physics/flesh/flesh_bloody_impact_hard1.wav",
	
	
}
table.Merge(StandSoundsTable, part3snds)
for k,v in pairs(StandSoundsTable) do
	util.PrecacheSound(k)
	--MsgC(Color(255, 0.8 * 255, 0), "gStands: Cached ", v, ", the sound for MAT: ", k, "\n")
end
function GetStandImpactSfx(mat)
	return StandSoundsTable[mat] or "Flesh.ImpactHard"
end

local ENTITY_META = FindMetaTable("Entity")
local PLAYER_META = FindMetaTable("Player")
GAMEMODE = gmod.GetGamemode()

if CLIENT then
	hook.Add("ShouldDrawLocalPlayer", "DrawgStandsThirdPersonPlayers", function(ply)
		if ply:GetActiveWeapon().gStands_IsThirdPerson then
			return true
		end
	end)
	local firstperson = GetConVar("gstands_firstperson")
	hook.Add("Think", "gStands_ThirdPersonSetting", function()
		local wep = LocalPlayer():GetActiveWeapon()
		if firstperson:GetBool() and IsValid(wep) and string.StartWith(wep:GetClass(), "gstands_") then
			wep.gStands_IsThirdPerson = false
		end
	end)

	local modeswap = GetConVar("gstands_binds_modeswap")
	local modifierkey1 = GetConVar("gstands_binds_modifierkey1")
	local modifierkey2 = GetConVar("gstands_binds_modifierkey2")
	local taunt = GetConVar("gstands_binds_taunt")
	local tertattack = GetConVar("gstands_binds_tertattack")
	local dododo = GetConVar("gstands_binds_dododo")
	local standleap = GetConVar("gstands_binds_standleap")
	local defensivemode = GetConVar("gstands_binds_defensivemode")
	local block = GetConVar("gstands_binds_block")
	local standvoice = GetConVar("gstands_binds_standvoice")
	
	LocalPlayer().gStandsControlsTable = {
		["modeswap"] = modeswap:GetInt(),
		["modifierkey1"] = modifierkey1:GetInt(),
		["modifierkey2"] = modifierkey2:GetInt(),
		["taunt"] = taunt:GetInt(),
		["tertattack"] = tertattack:GetInt(),
		["dododo"] = dododo:GetInt(),
		["standleap"] = standleap:GetInt(),
		["defensivemode"] = defensivemode:GetInt(),
		["block"] = block:GetInt(),
		["standvoice"] = standvoice:GetInt(),
	}
	
	local gStandsKeyBindings = function(ply, mv)
		local ply = LocalPlayer()
		ply.gStandsKeyState = ply.gStandsKeyState or {}
		ply.gStandsOKeyState = ply.gStandsKeyState
		ply["omodeswap"] = ply["modeswap"]
		ply["omodifierkey1"] = ply["modifierkey1"]
		ply["omodifierkey2"] = ply["modifierkey2"]
		ply["otaunt"] = ply["taunt"]
		ply["otertattack"] = ply["tertattack"]
		ply["odododo"] = ply["dododo"]
		ply["ostandleap"] = ply["standleap"]
		ply["odefensivemode"] = ply["defensivemode"]
		ply["oblock"] = ply["block"]
		ply["ostandvoice"] = ply["standvoice"]
		if IsValid(ply) and ply.GetActiveWeapon and ply:GetActiveWeapon():IsValid() then
		local wep = ply:GetActiveWeapon()
			if wep:IsValid() and string.StartWith(wep:GetClass(), "gstands_") then
				ply.gStandsControlsTable = {}
				ply.gStandsControlsTable = {
					["modeswap"] = modeswap:GetInt(),
					["modifierkey1"] = modifierkey1:GetInt(),
					["modifierkey2"] = modifierkey2:GetInt(),
					["taunt"] = taunt:GetInt(),
					["tertattack"] = tertattack:GetInt(),
					["dododo"] = dododo:GetInt(),
					["standleap"] = standleap:GetInt(),
					["defensivemode"] = defensivemode:GetInt(),
					["block"] = block:GetInt(),
					["standvoice"] = standvoice:GetInt(),
				}
				for k,v in pairs(ply.gStandsControlsTable) do
					if input.IsButtonDown(v) then
						ply.gStandsKeyState[k] = math.min((ply.gStandsKeyState[k] or 1) + 1, 3)
						else
						ply.gStandsKeyState[k] = 1
					end
				end
				for k,v in pairs(ply.gStandsKeyState) do
					ply[k] = v
				end
			end
		end
	end
	hook.Remove("PlayerTick", "gStandsCheckBindings", gStandsKeyBindings)
	hook.Add("Tick", "gStandsCheckBindings", gStandsKeyBindings)
	timer.Simple(1, function()
		function GAMEMODE:MouthMoveAnimation(ply)
			if IsPlayerStandUser(ply) and ply:GetNWBool("IsStandTalking") then
				local wep = ply:GetActiveWeapon()
				if IsValid(wep) and wep.GetStand and IsValid(wep:GetStand()) then
					local stand = wep:GetStand()
					local flexes = {
						stand:GetFlexIDByName( "ora" ),
						stand:GetFlexIDByName( "jaw_drop" ),
						stand:GetFlexIDByName( "left_part" ),
						stand:GetFlexIDByName( "right_part" ),
						stand:GetFlexIDByName( "left_mouth_drop" ),
						stand:GetFlexIDByName( "right_mouth_drop" )
					}

					local weight = ply:IsSpeaking() && math.Clamp( ply:VoiceVolume() * 2, 0, 2 ) || 0
					for k, v in pairs( flexes ) do
						stand:SetFlexWeight( v, weight )

					end
				end
				else
				local flexes = {
				ply:GetFlexIDByName( "jaw_drop" ),
				ply:GetFlexIDByName( "left_part" ),
				ply:GetFlexIDByName( "right_part" ),
				ply:GetFlexIDByName( "left_mouth_drop" ),
				ply:GetFlexIDByName( "right_mouth_drop" )
			}

			local weight = ply:IsSpeaking() && math.Clamp( ply:VoiceVolume() * 2, 0, 2 ) || 0

			for k, v in pairs( flexes ) do

				ply:SetFlexWeight( v, weight )

			end
			end
		end
	end)
end

if SERVER then
	hook.Add("PlayerPostThink", "StandVoiceChat", function(ply)
		if IsPlayerStandUser(ply) then
			ply["NextStandTalkCheck"] = ply["NextStandTalkCheck"] or CurTime()
			if CurTime() >= ply["NextStandTalkCheck"] and ply:gStandsKeyDown("standvoice") then
				ply:SetNWBool("IsStandTalking", !ply:GetNWBool("IsStandTalking"))
				if ply:GetNWBool("IsStandTalking") then ply:ChatPrint("#gstands.general.standtalkon") else ply:ChatPrint("#gstands.general.standtalkoff") end
				ply["NextStandTalkCheck"] = CurTime() + 0.2
			end
		end
	end)
	hook.Add("PlayerCanHearPlayersVoice", "StandVoiceChat", function(list, talk)
		if IsPlayerStandUser(talk) and talk:GetNWBool("IsStandTalking") then
			if !IsPlayerStandUser(list) then
				return false
			end
			
		end
	end)
	
	local gStandsKeyBindingsDown = function(ply, btn)
		ply.gStandsKeyState = ply.gStandsKeyState or {}
		ply.gStandsOKeyState = ply.gStandsKeyState
		local modeswap = ply:GetInfoNum("gstands_binds_modeswap", 0)
		local modifierkey1 = ply:GetInfoNum("gstands_binds_modifierkey1", 0)
		local modifierkey2 = ply:GetInfoNum("gstands_binds_modifierkey2", 0)
		local taunt = ply:GetInfoNum("gstands_binds_taunt", 0)
		local tertattack = ply:GetInfoNum("gstands_binds_tertattack", 0)
		local dododo = ply:GetInfoNum("gstands_binds_dododo", 0)
		local standleap = ply:GetInfoNum("gstands_binds_standleap", 0)
		local defensivemode = ply:GetInfoNum("gstands_binds_defensivemode", 0)
		local block = ply:GetInfoNum("gstands_binds_block", 0)
		local standvoice = ply:GetInfoNum("gstands_binds_standvoice", 0)
		ply["omodeswap"] = ply["modeswap"]
		ply["omodifierkey1"] = ply["modifierkey1"]
		ply["omodifierkey2"] = ply["modifierkey2"]
		ply["otaunt"] = ply["taunt"]
		ply["otertattack"] = ply["tertattack"]
		ply["odododo"] = ply["dododo"]
		ply["ostandleap"] = ply["standleap"]
		ply["odefensivemode"] = ply["defensivemode"]
		ply["oblock"] = ply["block"]
		ply["ostandvoice"] = ply["standvoice"]
		timer.Simple(0, function()
			ply["omodeswap"] = ply["modeswap"]
			ply["omodifierkey1"] = ply["modifierkey1"]
			ply["omodifierkey2"] = ply["modifierkey2"]
			ply["otaunt"] = ply["taunt"]
			ply["otertattack"] = ply["tertattack"]
			ply["odododo"] = ply["dododo"]
			ply["ostandleap"] = ply["standleap"]
			ply["odefensivemode"] = ply["defensivemode"]
			ply["oblock"] = ply["block"]
			ply["ostandvoice"] = ply["standvoice"]
		end)
		ply.gStandsControlsTable = {
			["modeswap"] = modeswap,
			["modifierkey1"] = modifierkey1,
			["modifierkey2"] = modifierkey2,
			["taunt"] = taunt,
			["tertattack"] = tertattack,
			["dododo"] = dododo,
			["standleap"] = standleap,
			["defensivemode"] = defensivemode,
			["block"] = block,
			["standvoice"] = standvoice,
		}
		if IsValid(ply) and ply.GetActiveWeapon and ply:GetActiveWeapon():IsValid() then
		local wep = ply:GetActiveWeapon()
			if wep:IsValid() and string.StartWith(wep:GetClass(), "gstands_") then
			for k,v in pairs(ply.gStandsControlsTable) do
				if v == btn then
					ply.gStandsKeyState[k] = math.min((ply.gStandsKeyState[k] or 1) + 1, 3)
					ply[k] = ply.gStandsKeyState[k]
					end
				end
			end
		end
	end
	local gStandsKeyBindingsUp = function(ply, btn)
		ply.gStandsKeyState = ply.gStandsKeyState or {}
		ply.gStandsOKeyState = ply.gStandsKeyState
		local modeswap = ply:GetInfoNum("gstands_binds_modeswap", 0)
		local modifierkey1 = ply:GetInfoNum("gstands_binds_modifierkey1", 0)
		local modifierkey2 = ply:GetInfoNum("gstands_binds_modifierkey2", 0)
		local taunt = ply:GetInfoNum("gstands_binds_taunt", 0)
		local tertattack = ply:GetInfoNum("gstands_binds_tertattack", 0)
		local dododo = ply:GetInfoNum("gstands_binds_dododo", 0)
		local standleap = ply:GetInfoNum("gstands_binds_standleap", 0)
		local defensivemode = ply:GetInfoNum("gstands_binds_defensivemode", 0)
		local block = ply:GetInfoNum("gstands_binds_block", 0)
		local standvoice = ply:GetInfoNum("gstands_binds_standvoice", 0)
		ply["omodeswap"] = ply["modeswap"]
		ply["omodifierkey1"] = ply["modifierkey1"]
		ply["omodifierkey2"] = ply["modifierkey2"]
		ply["otaunt"] = ply["taunt"]
		ply["otertattack"] = ply["tertattack"]
		ply["odododo"] = ply["dododo"]
		ply["ostandleap"] = ply["standleap"]
		ply["odefensivemode"] = ply["defensivemode"]
		ply["oblock"] = ply["block"]
		ply["ostandvoice"] = ply["standvoice"]
		ply.gStandsControlsTable = {
			["modeswap"] = modeswap,
			["modifierkey1"] = modifierkey1,
			["modifierkey2"] = modifierkey2,
			["taunt"] = taunt,
			["tertattack"] = tertattack,
			["dododo"] = dododo,
			["standleap"] = standleap,
			["defensivemode"] = defensivemode,
			["block"] = block,
			["standvoice"] = standvoice,
		}
		if IsValid(ply) and ply.GetActiveWeapon and ply:GetActiveWeapon():IsValid() then
		local wep = ply:GetActiveWeapon()
			if wep:IsValid() and string.StartWith(wep:GetClass(), "gstands_") then
			for k,v in pairs(ply.gStandsControlsTable) do
				if v == btn then
					ply.gStandsKeyState[k] = 1
					ply[k] = ply.gStandsKeyState[k]
					end
				end
			end
		end
	end
	hook.Add("PlayerButtonUp", "gStandsCheckBindings", gStandsKeyBindingsUp)
	hook.Add("PlayerButtonDown", "gStandsCheckBindings", gStandsKeyBindingsDown)
end
function PLAYER_META:gStandsKeyPressed(key)
	if CLIENT and gui.IsGameUIVisible() then return end
	if !self:IsTyping() and self[key] and self["o"..key] == 1 and self[key] >= 2 then
		self["o"..key] = self[key]
		return true
	end
	return false
end
function PLAYER_META:gStandsKeyReleased(key)
	if CLIENT and gui.IsGameUIVisible() then return end
	if !self:IsTyping() and self[key] and self["o"..key] and self["o"..key] >= 2 and self[key] == 1 then
	return true end
	return false
end
function PLAYER_META:gStandsKeyDown(key)
	if CLIENT and gui.IsGameUIVisible() then return end
	if !self:IsTyping() and self[key] and self[key] >= 2 then
	return true end
	return false
end
hook.Remove("SetupMove", "HandleStunLock")
hook.Add("Move", "HandleStunLock", function(ent, mv)
	if ent:GetNetworkedBool("IsgStandsStunLocked") then
		local power = ent:GetNetworkedFloat("gStandsStunLockPower")
		mv:SetVelocity(mv:GetVelocity() * power)
		mv:SetForwardSpeed(mv:GetForwardSpeed() * power)
		mv:SetUpSpeed(mv:GetUpSpeed() * power)
		mv:SetSideSpeed(mv:GetSideSpeed() * power)
	end
end)
hook.Add("PlayerDeath", "HandleStunLock", function(ent, inflictor, attacker)
	if ent:GetNetworkedBool("IsgStandsStunLocked") then
		ent:SetNetworkedBool("IsgStandsStunLocked", false)
		timer.Remove(ent:Name().."gStandsStunLockTime")
	end
end)
hook.Add("CalcMainActivity", "HandleStunLock", function(ply, vel)
	if ply:GetNetworkedBool("IsgStandsStunLocked") and ply:GetNetworkedFloat("gStandsStunLockPower") == 0 then
		ply:SetCycle(0.5)
		return ply.CalcIdeal, ply:LookupSequence("Death_04")
	end
end)
function PLAYER_META:gStandsStunLock(power, duration)
	power = power or 1
	duration = duration or 1
	self:SetNetworkedBool("IsgStandsStunLocked", true)
	self:SetNetworkedFloat("gStandsStunLockPower", math.Clamp(1 - power, 0, 1))
	local timername = self:Name().."gStandsStunLockTime"
	if timer.Exists(timername) then
		timer.Adjust(timername, duration, 1)
	else
		timer.Create(timername, duration, 1, function()
			if IsValid(self) then
				self:SetNetworkedBool("IsgStandsStunLocked", false)
				self:SetNetworkedFloat("gStandsStunLockPower", 1)
			end
		end)
	end
end

if SERVER then
	util.AddNetworkString("EmitStandSound")
	util.AddNetworkString("EmitSoundLocal")
	util.AddNetworkString("gstands.ChatPrintFormatted")
	util.AddNetworkString("gstands.SayFormatted")
end
function ENTITY_META:EmitStandSound(soundName, soundLevel, pitchPercent, volume, channel)
	soundLevel = soundLevel or 75
	pitchPercent = pitchPercent or 100
	volume = volume or 1
	channel = channel or CHAN_AUTO
	if CLIENT and IsValid(self) and IsPlayerStandUser(LocalPlayer()) then
		self:EmitSound(soundName, soundLevel, pitchPercent, volume, channel)
	end
	if SERVER then
		net.Start("EmitStandSound")
		net.WriteEntity(self)
		net.WriteString(soundName)
		net.WriteFloat(soundLevel)
		net.WriteFloat(pitchPercent)
		net.WriteFloat(volume)
		net.WriteInt(channel, 32)
		net.Broadcast()
	end
end
function ENTITY_META:EmitSoundLocal(data, entOverride)
	soundName = data.SoundName or ""
	soundLevel = data.SoundLevel or 75
	pitchPercent = data.Pitch or 100
	volume = data.Volume or 1
	channel = data.Channel or CHAN_AUTO
	entOverride = entOverride or self
	
	if CLIENT and IsValid(entOverride) and IsPlayerStandUser(LocalPlayer()) then
		EmitSound(soundName, entOverride:GetPos(), entOverride:EntIndex(), channel, volume, soundLevel, data.Flags, pitchPercent)
	end
	if SERVER then
		net.Start("EmitSoundLocal")
		net.WriteTable(data)
		net.WriteEntity(entOverride)
		net.Send(self)
	end
end

if CLIENT then
	net.Receive("gstands.ChatPrintFormatted", function()
		local str = language.GetPhrase(net.ReadString())
		local num = net.ReadUInt(4)
		local args = {}
		for i=0,num do
			table.insert(args, net.ReadString())
		end
		LocalPlayer():ChatPrint(Format(str, unpack(args)))
	end)
	net.Receive("gstands.SayFormatted", function()
		local str = language.GetPhrase(net.ReadString())
		local ply = net.ReadEntity()
		local num = net.ReadUInt(4)
		local args = {}
		for i=0,num do
			table.insert(args, net.ReadString())
		end
		gmod.GetGamemode():OnPlayerChat(ply, Format(str, unpack(args)), false, false)
	end)
end
if SERVER then
	function PLAYER_META:ChatPrintFormatted(str, ...)
		local args = { ... }
		net.Start("gstands.ChatPrintFormatted")
		net.WriteString(str)
		net.WriteUInt(#args, 4)
		for k,v in pairs(args) do
			net.WriteString(tostring(v))
		end
		net.Send(self)
	end
	function PLAYER_META:SayFormatted(str, ...)
		local args = { ... }
		net.Start("gstands.SayFormatted")
		net.WriteString(str)
		net.WriteEntity(self)
		net.WriteUInt(#args, 4)
		for k,v in pairs(args) do
			net.WriteString(tostring(v))
		end
		net.Broadcast()
	end
end
function ENTITY_META:IsStand()
	if table.HasValue(AStandEntTable, self:GetClass()) then
		return true
	else
		return false
	end
end

hook.Add("CreateMove", "PreventZoom", function(cmd)
	if IsValid(LocalPlayer():GetActiveWeapon()) and string.StartWith(LocalPlayer():GetActiveWeapon():GetClass(), "gstands_") and !LocalPlayer():GetActiveWeapon().CanZoom then
		cmd:RemoveKey(IN_ZOOM)
	end
end)
	
function NiceDuration(inSoundDuration)
	local dur = inSoundDuration * 4.5 --Gives us minutes:second notation in decimal
	dur = dur/100 --Separates minutes and seconds where minutes is whole and seconds is decimal
	durM = math.floor(dur)
	durS = (dur - durM) * 100
	return (durM * 60) + durS
end
local clTab = {
	["models/player/atm/atm.mdl"]			="models/player/atm/atm.mdl",
	["models/player/copper/copper.mdl"]	  ="models/player/copper/copper.mdl",
	["models/player/creamrv/crm.mdl"]		="models/player/creamrv/crm.mdl",
	["models/player/dbm/dbm.mdl"]			="models/player/dbm/dbm.mdl",
	["models/gstands/stands/thefool.mdl"]					  ="models/gstands/stands/thefool.mdl",
	["models/player/heg/heg.mdl"]			="models/player/heg/heg.mdl",
	["models/hipriestess/highpriestess.mdl"] ="models/hipriestess/highpriestess.mdl",
	["models/horus/horus.mdl"]			   ="models/horus/horus.mdl",
	["models/player/jgm/jgm.mdl"]			="models/player/jgm/jgm.mdl",
	["models/player/mgr/mgr.mdl"]		   ="models/player/mgr/mgr.mdl",
	["models/player/osi/osi.mdl"]		   ="models/player/osi/osi.mdl",
	["models/player/slc/slc.mdl"]		   ="models/player/slc/slc.mdl",
	["models/player/slc/slc_un.mdl"]		="models/player/slc/slc_un.mdl",
	["models/player/starpjf/spjf.mdl"]	  ="models/player/starpjf/spjf.mdl",
	["models/player/worldjf/world.mdl"]	 ="models/player/worldjf/world.mdl",
	["models/jst/jst.mdl"]				 	="models/jst/jst.mdl",
	["models/tgray/tgray.mdl"]				="models/tgray/tgray.mdl",
}
function TranslateServersideModelName(mdl)
	if SERVER then return mdl end
	if !isstring(mdl) then
		error("Not a string!")
	end

	return clTab[mdl]
end

GSTANDS_STANDS = 
{
	[TranslateServersideModelName("models/player/atm/atm.mdl")]			=1,
	[TranslateServersideModelName("models/player/copper/copper.mdl")]	  =2,
	[TranslateServersideModelName("models/player/creamrv/crm.mdl")]		=3,
	[TranslateServersideModelName("models/player/dbm/dbm.mdl")]			=4,
	[TranslateServersideModelName("models/gstands/stands/thefool.mdl")]					  =5,
	[TranslateServersideModelName("models/player/heg/heg.mdl")]			=6,
	[TranslateServersideModelName("models/hipriestess/highpriestess.mdl")] =7,
	[TranslateServersideModelName("models/horus/horus.mdl")]			   =8,
	[TranslateServersideModelName("models/player/jgm/jgm.mdl")]			=9,
	[TranslateServersideModelName("models/player/mgr/mgr.mdl")]		   =10,
	[TranslateServersideModelName("models/player/osi/osi.mdl")]		   =11,
	[TranslateServersideModelName("models/player/slc/slc.mdl")]		   =12,
	[TranslateServersideModelName("models/player/slc/slc_un.mdl")]		=13,
	[TranslateServersideModelName("models/player/starpjf/spjf.mdl")]	  =14,
	[TranslateServersideModelName("models/player/worldjf/world.mdl")]	 =15,
	[TranslateServersideModelName("models/jst/jst.mdl")]	 			  =16,
	[TranslateServersideModelName("models/tgray/tgray.mdl")]	 		  =17,
}
GSTANDS_ATUM	  = GSTANDS_STANDS[TranslateServersideModelName("models/player/atm/atm.mdl")]
GSTANDS_COPPER	= GSTANDS_STANDS[TranslateServersideModelName("models/player/copper/copper.mdl")]
GSTANDS_CREAM	 = GSTANDS_STANDS[TranslateServersideModelName("models/player/creamrv/crm.mdl")]
GSTANDS_DBM	   = GSTANDS_STANDS[TranslateServersideModelName("models/player/dbm/dbm.mdl")]
GSTANDS_FOOL	  = GSTANDS_STANDS[TranslateServersideModelName("models/gstands/stands/thefool.mdl")]
GSTANDS_HIEROPHANT= GSTANDS_STANDS[TranslateServersideModelName("models/player/heg/heg.mdl")]
GSTANDS_PRIESTESS = GSTANDS_STANDS[TranslateServersideModelName("models/hipriestess/highpriestess.mdl")]
GSTANDS_HORUS	 = GSTANDS_STANDS[TranslateServersideModelName("models/horus/horus.mdl")]
GSTANDS_JUDGEMENT = GSTANDS_STANDS[TranslateServersideModelName("models/player/jgm/jgm.mdl")]
GSTANDS_MAGICIANS = GSTANDS_STANDS[TranslateServersideModelName("models/player/mgr/mgr.mdl")]
GSTANDS_OSIRIS	= GSTANDS_STANDS[TranslateServersideModelName("models/player/osi/osi.mdl")]
GSTANDS_CHARIOT   = GSTANDS_STANDS[TranslateServersideModelName("models/player/slc/slc.mdl")]
GSTANDS_CHARIOTUN = GSTANDS_STANDS[TranslateServersideModelName("models/player/slc/slc_un.mdl")]
GSTANDS_PLATINUM  = GSTANDS_STANDS[TranslateServersideModelName("models/player/starpjf/spjf.mdl")]
GSTANDS_WORLD	 = GSTANDS_STANDS[TranslateServersideModelName("models/player/worldjf/world.mdl")]
GSTANDS_JST	   = GSTANDS_STANDS[TranslateServersideModelName("models/jst/jst.mdl")]
GSTANDS_TGRAY	 = GSTANDS_STANDS[TranslateServersideModelName("models/tgray/tgray.mdl")]
function GetgStandsID(mdl)
	return GSTANDS_STANDS[mdl] or -1
end
--Nombat Compatibility

if CLIENT then
	net.Receive("gStands.LoadNombat", function()
			hook.Add("PlayerSwitchWeapon", "gStandsNombatCompatibility", function(ply, owep, wep)
				if NOMBAT and wep:IsValid() and string.StartWith(wep:GetClass(), "gstands_") then
					NOMBAT:SetCombatSong( "nombat/gstands/"..wep:GetClass()..".mp3", NiceDuration(SoundDuration("nombat/gstands/"..wep:GetClass()..".mp3")) )
					NOMBAT.GetCombatTimeout = CurTime() + NiceDuration(SoundDuration("nombat/gstands/"..wep:GetClass()..".mp3"))
				end
			end)
			hook.Add("HUDWeaponPickedUp", "gStandsNombatCompatibility", function(wep)
				if NOMBAT and wep:IsValid() and string.StartWith(wep:GetClass(), "gstands_") then
					NOMBAT:SetCombatSong( "nombat/gstands/"..wep:GetClass()..".mp3", NiceDuration(SoundDuration("nombat/gstands/"..wep:GetClass()..".mp3")) )
					NOMBAT.GetCombatTimeout = CurTime() + NiceDuration(SoundDuration("nombat/gstands/"..wep:GetClass()..".mp3"))
				end
			end)
			hook.Add("Think", "gStandsNombatCompatibility", function(ply)
				local wep = LocalPlayer():GetActiveWeapon()
				if NOMBAT and wep:IsValid() and string.StartWith(wep:GetClass(), "gstands_") and CurTime() >= NOMBAT.GetCombatTimeout then
					NOMBAT:SetCombatSong( "nombat/gstands/"..wep:GetClass()..".mp3", NiceDuration(SoundDuration("nombat/gstands/"..wep:GetClass()..".mp3")) )
					NOMBAT.GetCombatTimeout = CurTime() + NiceDuration(SoundDuration("nombat/gstands/"..wep:GetClass()..".mp3"))
				end
			end)
	end)
end
if SERVER then
	util.AddNetworkString("gStands.LoadNombat")
	hook.Add("PlayerTick", "gStandsNombatCompatibility", function(ply)
		local wep = ply:GetActiveWeapon()
		if NOMBAT and wep:IsValid() and string.StartWith(wep:GetClass(), "gstands_") then
			ply:ConCommand("nombat.client.has.hostiles")
		end
	end)
	local function RecursivePlayerCheck(ply)
		timer.Simple(5, function() 
			if ply:GetModel() != "player/default.mdl" then
				net.Start("gStands.LoadNombat")
				net.Send(ply)
				ply.NombatLoaded = true
			else 
				RecursivePlayerCheck(ply)
			end
		end)
	end
	hook.Add("PlayerSpawn", "LoadgStandsNombatCompat", function(ply, transition)
		if NOMBAT then
			if !ply.NombatLoaded and ply:GetModel() != "player/default.mdl" then
				net.Start("gStands.LoadNombat")
				net.Send(ply)
				ply.NombatLoaded = true
				elseif !ply.NombatLoaded then
				RecursivePlayerCheck(ply)
			end
		end
	end)
end

-- Disguise Handler
hook.Add("HUDDrawTargetID", "HandlegStandsDisguises", function()
local tr = util.GetPlayerTrace( LocalPlayer() )
	local trace = util.TraceLine( tr )
	if ( !trace.Hit ) then return end
	if ( !trace.HitNonWorld ) then return end
	
	local text = "ERROR"
	local font = "TargetID"
	
	if ( trace.Entity:IsPlayer() ) then
		text = trace.Entity:Nick()
		if trace.Entity:GetNWString("DisguisedAs") != "" then
			text = trace.Entity:GetNWString("DisguisedAs")
		end
	else
		return
		--text = trace.Entity:GetClass()
	end
	
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	
	local MouseX, MouseY = gui.MousePos()
	
	if ( MouseX == 0 && MouseY == 0 ) then
	
		MouseX = ScrW() / 2
		MouseY = ScrH() / 2
	
	end
	
	local x = MouseX
	local y = MouseY
	
	x = x - w / 2
	y = y + 30
	
	-- The fonts internal drop shadow looks lousy with AA on
	draw.SimpleText( text, font, x + 1, y + 1, Color( 0, 0, 0, 120 ) )
	draw.SimpleText( text, font, x + 2, y + 2, Color( 0, 0, 0, 50 ) )
	draw.SimpleText( text, font, x, y, GAMEMODE:GetTeamColor( trace.Entity ) )
	
	y = y + h + 5
	
	local text = trace.Entity:Health() .. "%"
	local font = "TargetIDSmall"
	
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	local x = MouseX - w / 2
	
	draw.SimpleText( text, font, x + 1, y + 1, Color( 0, 0, 0, 120 ) )
	draw.SimpleText( text, font, x + 2, y + 2, Color( 0, 0, 0, 50 ) )
	draw.SimpleText( text, font, x, y, GAMEMODE:GetTeamColor( trace.Entity ) )
	return true
end)


if CLIENT then
	net.Receive("EmitStandSound", 
		function()
			net.ReadEntity():EmitStandSound(
				net.ReadString(),
				net.ReadFloat(), 
				net.ReadFloat(), 
				net.ReadFloat(), 
			net.ReadInt(32))
		end)
	net.Receive("EmitSoundLocal", 
		function()
			LocalPlayer():EmitSoundLocal(net.ReadTable(), net.ReadEntity())
		end)
end
gStandsMounted = true

if CLIENT then
local mult = ScrW() / 1920
surface.CreateFont("gStandsFont", {
	font = "Arial",
	size = 27.33 * mult,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline= false,
	italic = true,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false })

surface.CreateFont("gStandsFontLarge", {
	font = "Arial",
	size = 45 * mult,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline= false,
	italic = true,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false })
end
if CLIENT then
	local gradient_mat = Material( "vgui/hud/gradient_dododo" )
	hook.Add("HUDPaintBackground", "DrawDoDoDoGradient", function()
		local ply = LocalPlayer()
		if IsValid(ply) and ply.GetActiveWeapon then
			local wep = ply:GetActiveWeapon()
			if IsValid(wep) and (wep.GetStand or wep.GetInDoDoDo) then
				local indododo = wep.GetStand and IsValid(wep:GetStand()) and wep:GetStand().GetInDoDoDo and wep:GetStand():GetInDoDoDo()
				local dist = 255
				local clr = color_white
				if wep.GetStand and IsValid(wep:GetStand()) then
					clr = gStands.GetStandColorTable(wep:GetStand():GetModel(), wep:GetStand():GetSkin())
					if wep:GetStand().GetRange then
						dist = (wep:GetStand():GetPos():Distance(LocalPlayer():WorldSpaceCenter()) / wep:GetStand():GetRange()) * 255
					end
				end
				surface.SetDrawColor(clr.r,clr.g,clr.b, dist)
				surface.SetMaterial(gradient_mat)
				if indododo then
					surface.DrawTexturedRect(0,0, ScrW(), ScrH())
					elseif wep.GetInDoDoDo then
					indododo = wep:GetInDoDoDo()
					if indododo then
						surface.DrawTexturedRect(0,0, ScrW(), ScrH())
					end
				end
			end
		end
	end)
	local matOverlay_Normal = Material( "gui/gstands-contenticon-normal.png" )
	local matOverlay_Hovered = Material( "gui/gstands-contenticon-hovered.png" )
	local matOverlay_AdminOnly = Material( "icon16/shield.png" )
	spawnmenu.AddContentType( "gStands", function( container, obj )
		if ( !obj.material ) then return end
		if ( !obj.nicename ) then return end
		if ( !obj.spawnname ) then return end
		
		local icon = vgui.Create( "ContentIcon", container )
		icon:SetContentType( "gStands" )
		icon:SetSpawnName( obj.spawnname )
		icon.Label:SetText( obj.nicename )
		icon.m_NiceName = obj.nicename 
		icon:SetMaterial( obj.material )
		icon:SetAdminOnly( obj.admin )
		icon:SetSize( 128, 128 )
		local clr = Color( 135, 206, 250, 255 )
		if obj.standmodel then
			index = obj.standmodel..0
			if StandTable[index] then
				clr = gStands.GetStandColorTable(obj.standmodel, 0)
			end
		end
		icon:SetTextColor( clr )
		icon.Label:SetExpensiveShadow(0,Color(0,0,0,0))
		icon.Label:SetFont("Trebuchet18")
		icon.Paint = function( self, w, h )

				surface.SetDrawColor( clr.r, clr.g, clr.b, 255 )

				if ( self.Depressed && !self.Dragging ) then
					if ( self.Border != 8 ) then
						self.Border = 8
						self:OnDepressionChanged( true )
					end
				else
					if ( self.Border != 0 ) then
						self.Border = 0
						self:OnDepressionChanged( false )
					end
				end

				render.PushFilterMag( TEXFILTER.ANISOTROPIC )
				render.PushFilterMin( TEXFILTER.ANISOTROPIC )

				self.Image:PaintAt( 3 + self.Border, 3 + self.Border, 128 - 8 - self.Border * 2, 128 - 8 - self.Border * 2 )

				render.PopFilterMin()
				render.PopFilterMag()


				if ( !dragndrop.IsDragging() && ( self:IsHovered() || self.Depressed || self:IsChildHovered() ) ) then

					surface.SetMaterial( matOverlay_Hovered )
					self.Label:Hide()

				else

					surface.SetMaterial( matOverlay_Normal )
					self.Label:Show()

				end
				
				surface.SetDrawColor( clr.r, clr.g, clr.b, 255 )
				surface.DrawTexturedRect( self.Border, self.Border, w-self.Border*2, h-self.Border*2 )

				if ( self.AdminOnly ) then
					surface.SetMaterial( matOverlay_AdminOnly )
					--surface.DrawTexturedRect( self.Border + 8, self.Border + 8, 16, 16 )
				end

			end
		icon.DoClick = function()
			
			RunConsoleCommand( "gm_giveswep", obj.spawnname )
			surface.PlaySound( "ui/buttonclickrelease.wav" )
			
		end
		icon.DoMiddleClick = function()
			
			RunConsoleCommand( "gm_spawnswep", obj.spawnname )
			surface.PlaySound( "ui/buttonclickrelease.wav" )
			
		end
		
		icon.OpenMenu = function( icon )
			
		end
		
		if ( IsValid( container ) ) then
			container:Add( icon )
		end
		
		return icon
		
	end )
	
	function gStandsGeneral(panel)
		local box = panel:CheckBox("#gstands.general.wotimelimit", "gstands_the_world_limit")
		box:SetValue(true)
		box = panel:CheckBox("#gstands.general.sptimelimit", "gstands_star_platinum_limit")
		box:SetValue(true)
		box = panel:CheckBox("#gstands.general.cantimestop", "gstands_can_time_stop")
		box:SetValue(true)
		box = panel:CheckBox("#gstands.general.standrange", "gstands_unlimited_stand_range")
		box:SetValue(false)
		box = panel:CheckBox("#gstands.general.fp", "gstands_firstperson")
		box:SetValue(false)
		box = panel:CheckBox("#gstands.general.standusersight", "gstands_stand_see_stands")
		box:SetValue(true)
		box = panel:TextEntry("#gstands.general.tpoffset", "gstands_thirdperson_offset")
		box:SetValue("0,0,0")
		box = panel:NumSlider( "#gstands.general.wolength", "gstands_the_world_timestop_length", 1, 25, 10) 
		box = panel:NumSlider( "#gstands.general.splength", "gstands_star_platinum_timestop_length", 1, 25, 5) 
		box = panel:TextEntry( "#gstands.general.tohthpagetimer", "gstands_tohth_page_timer") 
		box:SetValue(120)
		box = panel:TextEntry( "#gstands.general.sunrange", "gstands_the_sun_range") 
		box:SetValue(5000)
		box = panel:CheckBox( "#gstands.general.dododotog", "gstands_active_dododo_toggle") 
		box:SetValue(true)
		
	end
	function gStandsPerformance(panel)
		local box = panel:CheckBox("#gstands.general.hitboxes", "gstands_show_hitboxes")
		box:SetValue(false)
		box = panel:CheckBox("#gstands.general.opaque", "gstands_opaque_stands")
		box:SetValue(false)
		box = panel:CheckBox("#gstands.general.drawhud", "gstands_draw_hud")
		box:SetValue(true)
		box = panel:CheckBox("#gstands.general.drawhudback", "gstands_draw_hud_background")
		box:SetValue(true)
		box = panel:CheckBox("#gstands.general.liveavatar", "gstands_draw_avatar")
		box:SetValue(true)
		box = panel:CheckBox("#gstands.general.halos", "gstands_draw_halos")
		box:SetValue(false)
		box = panel:CheckBox("#gstands.general.lights", "gstands_lights")
		box:SetValue(true)
		box = panel:CheckBox("#gstands.general.drawhdmmirror", "gstands_draw_hdm_mirror")
		box:SetValue(true)
		box = panel:NumSlider( "#gstands.general.arms", "gstands_barrage_arms", 0, 5, 3, 0) 
	end
	--TODO: Add in stand stat adjustments
	local BdygrpTable = {
		["models/player/slc/slc.mdl"] = Vector(2,1),
		["models/player/heg.mdl"] = Vector(0,1),
	}
	local ReplaceableTable = {
		["The World"] = true,
		["Star Platinum"] = true
	}
	function gStandsSkins(panel)
		StandSkinConVars()
		panel:SetName( "#gstands.general.skinselector" )
		local AppList = vgui.Create( "DComboBox" )
		AppList.ModelAtLine = {}
		AppList.ClassAtLine = {}
		AppList:SetValue("#gstands.general.skinselector.selection")
		for k, v in pairs( weapons.GetList() ) do
			if ( !string.StartWith( v.ClassName, "gstands_" ) ) then continue end
			if v.PrintName and v.StandModel then
				AppList:AddChoice( v.PrintName )
				AppList.ModelAtLine[v.PrintName] = v.StandModelP
				AppList.ClassAtLine[v.PrintName] = v.ClassName
			end
		end
		local skin = nil
		local Mixer = nil
		local model = nil
		local box = nil
		AppList.OnSelect = function(self, index, value)
			if skin then
				skin:Remove()
			end
			if Mixer then
				Mixer:Remove()
			end
			if model then
				model:Remove()
			end
			if box then
				box:Remove()
			end
			AppList.CurrentSelectedConVar = "gstands_standskin_"..AppList.ClassAtLine[value]
			AppList.CurrentSelected = value
			model = vgui.Create( "DModelPanel", panel)
			model:CopyWidth(panel)
			model:SetPos(0, 200)
			model:SetHeight(250)
			model:SetDirectionalLight( BOX_RIGHT, Color( 255, 160, 80, 255 ) )
			model:SetDirectionalLight( BOX_LEFT, Color( 80, 160, 255, 255 ) )
			model:SetAmbientLight( Vector( -64, -64, -64 ) )
			model:SetModel(AppList.ModelAtLine[value])
			model:SetAnimated(true)
			local anim = model:GetEntity():LookupSequence("standidle")
			local mn, mx = model.Entity:GetRenderBounds()
			local size = 0
			size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
			size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
			size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
			
			model:SetFOV( 45 )
			model:SetCamPos( Vector( size, size, size ) )
			model:SetLookAt( ( mn + mx ) * 0.5 )
			
			if anim == -1 then
				anim = 1
			end
			model:GetEntity():SetSequence(anim)
			local bdgVec = Vector(0)
			if BdygrpTable[AppList.ModelAtLine[value]] then
				bdgVec = BdygrpTable[AppList.ModelAtLine[value]]
			end
			local mat
			model:GetEntity():SetBodygroup(bdgVec.X, bdgVec.Y)
			if model:GetModel() != "models/wof.mdl" then
				skin = panel:NumSlider( "#skin", AppList.CurrentSelectedConVar, 0,model:GetEntity():SkinCount() - 1, 0) 
				skin.OnValueChanged = function(self, val)
					model:GetEntity():SetSkin(math.Round(val))
				end
				else
				Mixer = vgui.Create( "DColorMixer", panel )
				Mixer:Dock( TOP )			--Make Mixer fill place of Frame
				Mixer:SetHeight(150)
				Mixer:SetPalette( false ) 		--Show/hide the palette			DEF:true
				Mixer:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
				Mixer:SetWangs( true )			--Show/hide the R G B A indicators 	DEF:true
				Mixer:SetColor( Color( 255, 255, 255 ) )	--Set the default color
				Mixer:SetConVarR("gstands_wof_color_r")
				Mixer:SetConVarG("gstands_wof_color_g")
				Mixer:SetConVarB("gstands_wof_color_b")
				Mixer.OnValueChanged = function(self, val)
					model:GetEntity():SetColor(Mixer:GetColor())
				end
			end
			if ReplaceableTable[value] then
				box = panel:TextEntry( "#gstands.general.skinselector.model", "gstands_replacement_"..AppList.ClassAtLine[value])
				box:SetValue(AppList.ModelAtLine[value])
				box.OnEnter = function()
					model:SetModel(GetConVar("gstands_replacement_"..AppList.ClassAtLine[value]):GetString())
					local anim = model:GetEntity():LookupSequence("standidle")
					if anim == -1 then
						anim = 1
					end
					model:GetEntity():SetSequence(anim)
				end
			end
			render.SetScissorRect( 0, 0, 0, 0, false )
			if model.SetBackgroundColor then
				model:SetBackgroundColor(Color(15,15,15))
			end
		end
		panel:AddItem(AppList)
	end
	
	function gStandsControls(panel)
		panel:SetName( "#gstands.general.keybindings" )
		local AppList = vgui.Create( "DListView" )
		AppList:SetHeight(250)
		AppList:Dock( FILL )
		AppList:SetMultiSelect( false )
		
		local modeswap = GetConVar("gstands_binds_modeswap")
		local modifierkey1 = GetConVar("gstands_binds_modifierkey1")
		local modifierkey2 = GetConVar("gstands_binds_modifierkey2")
		local taunt = GetConVar("gstands_binds_taunt")
		local tertattack = GetConVar("gstands_binds_tertattack")
		local dododo = GetConVar("gstands_binds_dododo")
		local standleap = GetConVar("gstands_binds_standleap")
		local defensivemode = GetConVar("gstands_binds_defensivemode")
		local block = GetConVar("gstands_binds_block")
		local standvoice = GetConVar("gstands_binds_standvoice")
		local vars = {
			["#gstands.general.keybindings.taunt"] = taunt,
			["#gstands.general.keybindings.defensive"] = defensivemode,
			["#gstands.general.keybindings.dododo"] = dododo,
			["#gstands.general.keybindings.standleap"] = standleap,
			["#gstands.general.keybindings.modeswap"] = modeswap,
			["#gstands.general.keybindings.modkey1"] = modifierkey1,
			["#gstands.general.keybindings.modkey2"] = modifierkey2,
			["#gstands.general.keybindings.zoom"] = tertattack,
			["#gstands.general.keybindings.block"] = block,
			["#gstands.general.keybindings.svc"] = standvoice,
		}
		AppList:AddColumn("#gstands.general.keybindings.control")
		AppList:AddColumn("#gstands.general.keybindings.key")
		AppList:AddLine( "#gstands.general.keybindings.taunt", input.GetKeyName(taunt:GetInt()) )
		AppList:AddLine( "#gstands.general.keybindings.defensive", input.GetKeyName(defensivemode:GetInt()) )
		AppList:AddLine( "#gstands.general.keybindings.dododo", input.GetKeyName(dododo:GetInt()) )
		AppList:AddLine( "#gstands.general.keybindings.standleap", input.GetKeyName(standleap:GetInt()) )
		AppList:AddLine( "#gstands.general.keybindings.modeswap", input.GetKeyName(modeswap:GetInt()) )
		AppList:AddLine( "#gstands.general.keybindings.modkey1", input.GetKeyName(modifierkey1:GetInt()) )
		AppList:AddLine( "#gstands.general.keybindings.modkey2", input.GetKeyName(modifierkey2:GetInt()) )
		AppList:AddLine( "#gstands.general.keybindings.zoom", input.GetKeyName(tertattack:GetInt()) )
		AppList:AddLine( "#gstands.general.keybindings.block", input.GetKeyName(block:GetInt()) )
		AppList:AddLine( "#gstands.general.keybindings.svc", input.GetKeyName(standvoice:GetInt()) )
		function AppList:DoDoubleClick(lineID, line)
			input.StartKeyTrapping()
			self.Trapping = true
			self.selectedline = line
		end
		function AppList:Think()
			if input.IsKeyTrapping() and self.Trapping then
				local key =	input.CheckKeyTrapping()
				if key then
				if key != KEY_ESCAPE then
				local _, line = self:GetSelectedLine()
					LocalPlayer():ConCommand(vars[line:GetColumnText(1)]:GetName().." "..tostring(key))
					self.selectedline:SetColumnText(2, input.GetKeyName(key))
					LocalPlayer().gStandsControlsTable = {
						["modeswap"] = modeswap:GetInt(),
						["modifierkey1"] = modifierkey1:GetInt(),
						["modifierkey2"] = modifierkey2:GetInt(),
						["taunt"] = taunt:GetInt(),
						["tertattack"] = tertattack:GetInt(),
						["dododo"] = dododo:GetInt(),
						["standleap"] = standleap:GetInt(),
						["defensivemode"] = defensivemode:GetInt(),
						["block"] = block:GetInt(),
						["standvoice"] = standvoice:GetInt(),
					}
				end
				self.Trapping = false
				end
			end
		end
		panel:AddItem(AppList)
		
	end
	
	function gStandsMenu()
		StandSkinConVars()
		spawnmenu.AddToolMenuOption("Options", "gStands", "gStandsGameplay", "#gstands.general.options.gameplay", "", "", gStandsGeneral)
		spawnmenu.AddToolMenuOption("Options", "gStands", "gStandsSkins", "#gstands.general.options.skins", "", "", gStandsSkins)
		spawnmenu.AddToolMenuOption("Options", "gStands", "gStandsPerformance", "#gstands.general.options.performance", "", "", gStandsPerformance)
		spawnmenu.AddToolMenuOption("Options", "gStands", "gStandsControls", "#gstands.general.options.controls", "", "", gStandsControls)
	end
	
	hook.Add("PopulateToolMenu", "gStandsMenu", gStandsMenu)
	
	hook.Add( "PopulateStands", "AddStandContent", function( pnlContent, tree, node )
		
		-- Loop through the weapons and add them to the menu
		local Weapons = weapons.GetList()
		local Categorised = {}
		
		-- Build into categories
		for k, weapon in pairs( Weapons ) do
			
			--if ( !weapon.Spawnable ) then continue end
			if ( !string.StartWith( weapon.ClassName, "gstands_" ) or (weapon.AdminSpawnable)) then continue end
			weapon.SubCategory = weapon.SubCategory or "#gstands.general.part3"
			Categorised[ weapon.SubCategory ] = Categorised[ weapon.SubCategory ] or {}
			table.insert( Categorised[ weapon.SubCategory ], weapon )
			
		end
		Weapons = nil
		
		-- Loop through each category
		for CategoryName, v in SortedPairs( Categorised ) do
			
			-- Add a node to the tree
			local node = tree:AddNode( CategoryName, "icon16/standarrow.png" )
			
			-- When we click on the node - populate it using this function
			node.DoPopulate = function( self )
				
				-- If we've already populated it - forget it.
				if ( self.PropPanel ) then return end
				
				-- Create the container panel
				self.PropPanel = vgui.Create( "ContentContainer", self.PropPanel )
				self.PropPanel:SetVisible( false )
				self.PropPanel:SetTriggerSpawnlistChange( false )

				for k, ent in SortedPairsByMemberValue( v, "PrintName" ) do
					
					local pnl = spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "gStands", self.PropPanel, {
						nicename	= ent.PrintName or ent.ClassName,
						spawnname	= ent.ClassName,
						material	= "entities/" .. ent.ClassName .. ".png",
						standmodel	= ent.StandModel,
						instructions	= ent.Instructions,
						admin		= ent.AdminSpawnable
					} )
					pnl:SetTooltip(ent.Instructions)
					end
			end
			
			-- If we click on the node populate it and switch to it.
			node.DoClick = function( self )
				
				self:DoPopulate()
				pnlContent:SwitchPanel( self.PropPanel )
				
			end
			
		end
		
		-- Select the first node
		local FirstNode = tree:Root():GetChildNode( 0 )
		if ( IsValid( FirstNode ) ) then
			FirstNode:InternalDoClick()
		end
		
	end )
	
	spawnmenu.AddCreationTab("gStands", function() 
		local ctrl = vgui.Create( "SpawnmenuContentPanel" )
		ctrl:EnableSearch( "stands", "PopulateStands" )
		ctrl:CallPopulateHook( "PopulateStands" )
		return ctrl
	end
	,"icon16/standarrow.png", 21, "gStands")
end