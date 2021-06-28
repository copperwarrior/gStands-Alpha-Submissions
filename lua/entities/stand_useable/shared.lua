ENT.Type = "anim"
ENT.Base = "stand"

ENT.PrintName= "Useable Stand"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "To stand"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
ENT.Animated = true
ENT.Color = Color(150,150,150,1)
ENT.ForceOnce = false
ready = false
ENT.ImageID = 1
ENT.Rate = 0
ENT.Health = 1
ENT.rgl = 1.3
ENT.ggl = 1.3
ENT.bgl = 1.3
ENT.rglm = 1.3
ENT.gglm = 1.3
ENT.bglm = 1.3
ENT.FlameFX = nil
ENT.PhysgunDisabled = true
ENT.Range = 150
ENT.ItemPickedUp = NUL
ENT.Speed = 1
ENT.Flashlight = self
game.AddParticles("particles/mblur.pcf")
game.AddParticles("particles/jgm.pcf")

PrecacheParticleSystem("jgmfull")
PrecacheParticleSystem("mud")
local H2U = Sound("jgm.h2u")
local nope = Sound("weapons/jgm/nope.wav")
local Nanda = Sound("weapons/jgm/what.wav")
local anything = Sound("weapons/jgm/anywish.wav")
local dirt = Sound("jgm.dirt")

local Deploy = Sound("weapons/osiris/deploy.wav")
local Clap = Sound("weapons/osiris/clap.wav")
local Rip = Sound("weapons/osiris/rip.wav")
local Open = Sound("weapons/osiris/openthegame.wav")
local Goodo = Sound("weapons/osiris/goodo.wav")

local Pong = Sound("weapons/atum/pong.wav")

local facts = {
		"#gstands.jgm.infknowledge.fact1",
		"#gstands.jgm.infknowledge.fact2",
		"#gstands.jgm.infknowledge.fact3",
		"#gstands.jgm.infknowledge.fact4",
		"#gstands.jgm.infknowledge.fact5",
		"#gstands.jgm.infknowledge.fact6",
		"#gstands.jgm.infknowledge.fact7",
		"#gstands.jgm.infknowledge.fact8",
		"#gstands.jgm.infknowledge.fact9",
		"#gstands.jgm.infknowledge.fact10",
		"#gstands.jgm.infknowledge.fact11",
		"#gstands.jgm.infknowledge.fact12",
		"#gstands.jgm.infknowledge.fact13",
		"#gstands.jgm.infknowledge.fact14"
}
if CLIENT then 
surface.CreateFont("JudgementExtraLarge", {
	font = "Roboto", 
	extended = false,
	size = 72,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
	net.Receive("jgm.wishmenu", function()
		local ent = net.ReadEntity()
		local user = net.ReadEntity()
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
		dOp1:AddColumn("gstands.jgm.wish")
		dOp1:AddLine("#gstands.jgm.wish.wish1")
		dOp1:AddLine("#gstands.jgm.wish.wish2")
		dOp1:AddLine("#gstands.jgm.wish.wish3")
		dOp1:AddLine("#gstands.jgm.wish.wish4")
		dOp1:AddLine("#gstands.jgm.wish.wish5")
		dOp1:AddLine("#gstands.jgm.wish.wish6")
		dOp1:AddLine("#gstands.jgm.wish.wish7")
		dOp1:AddLine("#gstands.jgm.wish.wish8")
		dOp1:AddLine("#gstands.jgm.wish.wish9")
		dOp1:AddLine("#gstands.jgm.wish.wish10")
		dOp1:AddLine("#gstands.jgm.wish.wish11")
		dOp1:AddLine("#gstands.jgm.wish.wish12")
		dOp1:AddLine("#gstands.jgm.wish.wish13")
		dOp1:AddLine("#gstands.jgm.wish.wish14")
		dOp1:AddLine("#gstands.jgm.wish.wish15")
		dOp1:AddLine("#gstands.jgm.wish.wish16")
		dOp1:AddLine("#gstands.jgm.wish.wish17")
		dOp1:AddLine("#gstands.jgm.wish.wish18")
		dOp1:AddLine("#gstands.jgm.wish.wish19")
		dOp1:AddLine("#gstands.jgm.wish.wish20")
		dOp1:AddLine("#gstands.jgm.wish.wish21")
		dOp1:AddLine("#gstands.jgm.wish.wish22")
		dOp1:AddLine("#gstands.jgm.wish.wish23")
		dOp1.OnRowSelected = function( lst, index, pnl )
		dPanel:Close()
			net.Start("jgm.wish")
			net.WriteInt(index, 6)
			net.WriteEntity(ent)
			net.WriteEntity(user)
			net.SendToServer()
		end
	end)
	net.Receive("jgm.knowledge", function()

		local ent = net.ReadEntity()
		local wisher = net.ReadEntity()
		hook.Add("PreDrawEffects","JudgementInfiniteKnowledge"..wisher:GetName(),function()
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
			
			surface.SetDrawColor(255,255,255,255)
			local w,h = ScrW(),ScrH()
			for _,v in ipairs(ents.GetAll()) do
				if (v:IsPlayer() or v:IsNPC()) and v:Health() > 0 then
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
			if !(wisher:Alive()) then
			hook.Remove("PreDrawEffects","JudgementInfiniteKnowledge"..wisher:GetName())
			end
		end)
		hook.Add("HUDPaint", "InfiniteKnowledge"..wisher:GetName(), function()
		wisher.KnowledgeCounter = wisher.KnowledgeCounter or 0
		wisher.KnowledgeCounter = math.Clamp(wisher.KnowledgeCounter + 0.01, 0, 100)
		for I = 0, wisher.KnowledgeCounter do 
				draw.DrawText(table.Random(facts), "JudgementExtraLarge", Lerp(math.Rand(0,1), 0, ScrW()), Lerp(math.Rand(0,1), 0, ScrH()), Color(255,255,255,255), math.random(0, 4))
		end
		if !(wisher:Alive()) then
			hook.Remove("HUDPaint", "InfiniteKnowledge"..wisher:GetName())
			wisher.KnowledgeCounter = 0
		end
		end)
	end)
	net.Receive("osi.Rolls", function() 
		
		local player1 = net.ReadEntity()
		local player2 = net.ReadEntity()
		local roll1 = net.ReadInt(4)
		local roll2 = net.ReadInt(4)
		local tab = {
			[roll1] = player1:Name(),
			[roll2] = player2:Name(),
		}
		
	end)
end
if SERVER then
	util.AddNetworkString("jgm.wishmenu")
	util.AddNetworkString("jgm.wish")
	util.AddNetworkString("jgm.knowledge")
	net.Receive("jgm.wish", function()
		local id = net.ReadInt(6)
		local ent = net.ReadEntity()
		local user = net.ReadEntity()
		if ent:GetSequence() != ent:LookupSequence("h2u") and id != 23 then
			ent:ResetSequence("h2u")
			ent:SetCycle(0)
			ent.Wep:SetHoldType("pistol")
			ent:EmitStandSound(H2U)
			local light = ents.Create("light_dynamic")
			light:SetPos(ent:WorldSpaceCenter())
			light:Spawn()
			light:Activate()
			light:SetKeyValue("distance", 55)
			light:SetKeyValue("brightness", 10)
			light:SetKeyValue("_light", "255 100 255 255")
			light:Fire("TurnOn")
			timer.Simple(2.4, function() ent.Wep:SetHoldType("stando") light:SetKeyValue("brightness", 12) 
				ParticleEffectAttach("jgmfull", PATTACH_POINT_FOLLOW, ent, 1)
			end)
			timer.Simple(3, function()
				if ent:IsValid() and user:IsValid() then
					ent:DoWish(id, user)
					light:SetKeyValue("brightness", 0)
					light:Remove()
				end
			end)
		end
		if id == 23 then
			ent:EmitStandSound(Nanda)
		end
	end)
	util.AddNetworkString("osi.Rolls")
end

if SERVER then
util.AddNetworkString("atum.InitMagPong")
util.AddNetworkString("atum.StartMagnumPong")
util.AddNetworkString("atum.StopMagnumPong")
net.Receive("atum.InitMagPong", function()
	
	local ply1 = net.ReadEntity()
	local ply2 = net.ReadEntity()
	local plrs = RecipientFilter()
		plrs:AddPlayer(ply1)
		plrs:AddPlayer(ply2)
	local gametag = ply1:Name()..ply2:Name()
	local function FreezePlayer(ply)
		ply:SetWalkSpeed(1)
		ply:SetCrouchedWalkSpeed(1)
		ply:SetMaxSpeed(1)
		ply:SetRunSpeed(1)
		ply:SetDuckSpeed(1)
		ply:SetUnDuckSpeed(1)
		ply:SetJumpPower(1)
		ply.InPong = true
	end
	local function UnFreezePlayer(ply)
		ply:SetWalkSpeed(200)
		ply:SetRunSpeed(400)
		ply:SetJumpPower(200)
		ply:SetCrouchedWalkSpeed(0.30000001192093)
		ply:SetMaxSpeed(200)
		ply:SetDuckSpeed(0.1)
		ply:SetUnDuckSpeed(0.1)
		ply.InPong = false
	end
	FreezePlayer(ply1)
	FreezePlayer(ply2)
	SetGlobalBool("PongStartup"..gametag, true)
	timer.Simple(3, function()
		SetGlobalFloat("PongScore"..ply1:Name(), 0)
		SetGlobalFloat("PongScore"..ply2:Name(), 0)
		SetGlobalVector("PongBallVelocity"..gametag, Vector(0,0,0))
		SetGlobalVector("PongBallPos"..gametag, Vector(248, 248, 0))
		SetGlobalFloat("PongPlayer1Pos"..ply1:Name(), 224)
		SetGlobalFloat("PongPlayer2Pos"..ply2:Name(), 224)
	local speed = 0
	local killsound = false
	local function PongBallReset()
		SetGlobalVector("PongBallPos"..gametag, Vector(248, 248, 0))
		SetGlobalVector("PongBallVelocity"..gametag, Vector(0,0,0))
		timer.Create("pongtimer"..gametag, 3.5,1, function()
			if math.random(1,2) > 1 then
				SetGlobalVector("PongBallVelocity"..gametag, Vector(-1, math.Rand(-1,1),0) * 2)
			else
				SetGlobalVector("PongBallVelocity"..gametag, Vector(1, math.Rand(-1,1),0) * 2)
			end
			SetGlobalVector("PongBallPos"..gametag, Vector(248, 248, 0))
		end)
		if !killsound then
			ply1:EmitSound("common/stuck1.wav", 75, 70)
			ply2:EmitSound("common/stuck1.wav", 75, 70)
		timer.Create("pongtimer2"..gametag, 1,3, function()
			if timer.RepsLeft("pongtimer2"..gametag) >= 1 then
				ply1:EmitSound("common/stuck1.wav", 75, 70)
				ply2:EmitSound("common/stuck1.wav", 75, 70)
			else
				ply1:EmitSound("common/stuck1.wav", 75, 150)
				ply2:EmitSound("common/stuck1.wav", 75, 150)
			end
		end)
		end
	end
	local function AddScore(ply)
		speed = 0
		SetGlobalFloat("PongScore"..ply:Name(), GetGlobalFloat("PongScore"..ply:Name()) + 1)
	end
	
	local function Win(player)
		killsound = true
		timer.Remove("pongtimer2"..gametag)
		hook.Remove("Tick", "MagnumPongThink"..gametag)
		net.Start("atum.StopMagnumPong")
		net.Send(plrs)
		SetGlobalFloat("PongScore"..ply1:Name(), 0)
		SetGlobalFloat("PongScore"..ply2:Name(), 0)
		SetGlobalVector("PongBallVelocity"..gametag, Vector(0,0,0))
		SetGlobalVector("PongBallPos"..gametag, Vector(256, 256, 0))
		SetGlobalFloat("PongPlayer1Pos"..ply1:Name(), 224)
		SetGlobalFloat("PongPlayer2Pos"..ply2:Name(), 224)
		ply1:GetActiveWeapon().Stand:AtumHandleWin(player, ply2)
		UnFreezePlayer(ply1)
		UnFreezePlayer(ply2)
	end
	PongBallReset()
	hook.Add("PlayerSwitchWeapon", "PongFreezePlayers", function(ply, wep, wep1)
		if ply.InPong then
			return true
		end
	end)
	hook.Add("CanPlayerSuicide", "PongFreezePlayers", function(ply)
		if ply.InPong then
			return false
		end
	end)
	
	hook.Add("Tick", "MagnumPongThink"..gametag, function()
	SetGlobalBool("PongStartup"..gametag, false)
	FreezePlayer(ply1)
	FreezePlayer(ply2)
	SetGlobalFloat("PongTimer"..gametag, timer.TimeLeft("pongtimer"..gametag))

	if GetGlobalFloat("PongScore"..ply1:Name()) > 3 then
		Win(ply1)
	end
	if GetGlobalFloat("PongScore"..ply2:Name()) > 3 then
		Win(ply2)
	end
	if GetGlobalVector("PongBallPos"..gametag) == Vector(0,0,0) then
		SetGlobalVector("PongBallPos"..gametag, Vector(256, 256, 0))
	end
	if ply1:KeyDown(IN_BACK) then
		SetGlobalFloat("PongPlayer1Pos"..ply1:Name(), math.Clamp(GetGlobalFloat("PongPlayer1Pos"..ply1:Name()) + 3, 0, 448))
	end
	if ply1:KeyDown(IN_FORWARD) then
		SetGlobalFloat("PongPlayer1Pos"..ply1:Name(), math.Clamp(GetGlobalFloat("PongPlayer1Pos"..ply1:Name()) - 3, 0, 448))
	end
	
	if ply2:KeyDown(IN_BACK) then
		SetGlobalFloat("PongPlayer2Pos"..ply2:Name(), math.Clamp(GetGlobalFloat("PongPlayer2Pos"..ply2:Name()) + 3, 0, 448))
	end
	if ply2:KeyDown(IN_FORWARD) then
		SetGlobalFloat("PongPlayer2Pos"..ply2:Name(), math.Clamp(GetGlobalFloat("PongPlayer2Pos"..ply2:Name()) - 3, 0, 448))
	end
	
	SetGlobalVector("PongBallPos"..gametag, GetGlobalVector("PongBallPos"..gametag) + GetGlobalVector("PongBallVelocity"..gametag))
	
	
	if GetGlobalVector("PongBallPos"..gametag).y < 0 then
		ply1:EmitSound("common/wpn_denyselect.wav", 75, 200)
		ply2:EmitSound("common/wpn_denyselect.wav", 75, 200)
		SetGlobalVector("PongBallVelocity"..gametag, Vector(GetGlobalVector("PongBallVelocity"..gametag).x,-GetGlobalVector("PongBallVelocity"..gametag).y, 0))
	end
	if GetGlobalVector("PongBallPos"..gametag).y > 504 then
		ply1:EmitSound("common/wpn_denyselect.wav", 75, 200)
		ply2:EmitSound("common/wpn_denyselect.wav", 75, 200)
		SetGlobalVector("PongBallVelocity"..gametag, Vector(GetGlobalVector("PongBallVelocity"..gametag).x,-GetGlobalVector("PongBallVelocity"..gametag).y, 0))
	end
	if GetGlobalVector("PongBallPos"..gametag).x < 0 then
		PongBallReset()
		ply1:EmitSound("common/stuck1.wav", 75, 200)
		ply2:EmitSound("common/stuck1.wav", 75, 200)
		AddScore(ply2)
	end
	if GetGlobalVector("PongBallPos"..gametag).x > 504 then
		PongBallReset()
		ply1:EmitSound("common/stuck1.wav", 75, 200)
		ply2:EmitSound("common/stuck1.wav", 75, 200)
		AddScore(ply1)
	end

	if GetGlobalVector("PongBallPos"..gametag).x > 15 and 
		GetGlobalVector("PongBallPos"..gametag).y > GetGlobalFloat("PongPlayer1Pos"..ply1:Name()) and 
		GetGlobalVector("PongBallPos"..gametag).y < GetGlobalFloat("PongPlayer1Pos"..ply1:Name()) + 64 and 
		GetGlobalVector("PongBallPos"..gametag).x < 15 + 16 
		then
		ply1:EmitSound("buttons/blip1.wav", 75, 225)
		ply2:EmitSound("buttons/blip1.wav", 75, 225)
		speed = speed + 0.1
		local factor = 0
		if GetGlobalVector("PongBallPos"..gametag).y > GetGlobalFloat("PongPlayer1Pos"..ply1:Name()) + 32 then
			factor = 0.4
		elseif GetGlobalVector("PongBallPos"..gametag).y < GetGlobalFloat("PongPlayer1Pos"..ply1:Name()) + 32 then
			factor = -0.4
		end
		SetGlobalVector("PongBallVelocity"..gametag, Vector(math.abs(GetGlobalVector("PongBallVelocity"..gametag).x) + speed,GetGlobalVector("PongBallVelocity"..gametag).y + factor, 0))
	end
	if GetGlobalVector("PongBallPos"..gametag).x > 481 and 
		GetGlobalVector("PongBallPos"..gametag).y > GetGlobalFloat("PongPlayer2Pos"..ply2:Name()) and 
		GetGlobalVector("PongBallPos"..gametag).y < GetGlobalFloat("PongPlayer2Pos"..ply2:Name()) + 64 and 
		GetGlobalVector("PongBallPos"..gametag).x < 481 + 16 
		then
		speed = speed + 0.1
		ply1:EmitSound("buttons/blip1.wav", 75, 200)
		ply2:EmitSound("buttons/blip1.wav", 75, 200)
		local factor = 0
		if GetGlobalVector("PongBallPos"..gametag).y > GetGlobalFloat("PongPlayer2Pos"..ply2:Name()) + 32 then
			factor = 0.4
		elseif GetGlobalVector("PongBallPos"..gametag).y < GetGlobalFloat("PongPlayer2Pos"..ply2:Name()) + 32 then
			factor = -0.4
		end
		SetGlobalVector("PongBallVelocity"..gametag, Vector(-math.abs(GetGlobalVector("PongBallVelocity"..gametag).x) - speed,GetGlobalVector("PongBallVelocity"..gametag).y + factor, 0))
	end
end)
end)
end)
end
function KillSwitchAtum()
	hook.Remove("Tick", "MagnumPongThinkCopperHEV Suit")
	hook.Remove("HUDPaint", "MagnumPong")
end
	
if CLIENT then
	local ballpos = Vector(256,256,0)
	local pos1 = 256
	local pos2 = 256
	local pos1v = 0
	local pos2v = 0
net.Receive("atum.StartMagnumPong", function()
	local player1 = net.ReadEntity()
	local player2 = net.ReadEntity()
		surface.PlaySound(Pong)
	net.Start("atum.InitMagPong")
	net.WriteEntity(player1)
	net.WriteEntity(player2)
	net.SendToServer()
	hook.Add("HUDPaint", "MagnumPong", function()
	local offsetx = ScrW()/2 - 256
	local offsety = ScrH()/2 - 256
	pos1v = GetGlobalFloat("PongPlayer1Pos"..player1:Name())
	pos2v = GetGlobalFloat("PongPlayer2Pos"..player2:Name())
	if player1:KeyDown(IN_BACK) then
		pos1v = math.Clamp(GetGlobalFloat("PongPlayer1Pos"..player1:Name()) + 3, 0, 448)
	end
	if player1:KeyDown(IN_FORWARD) then
		pos1v = math.Clamp(GetGlobalFloat("PongPlayer1Pos"..player1:Name()) - 3, 0, 448)
	end
	if player2:KeyDown(IN_BACK) then
		pos2v = math.Clamp(GetGlobalFloat("PongPlayer2Pos"..player2:Name()) + 3, 0, 448)
	end
	if player2:KeyDown(IN_FORWARD) then
		pos2v = math.Clamp(GetGlobalFloat("PongPlayer2Pos"..player2:Name()) - 3, 0, 448)
	end
	SetGlobalFloat("PongPlayer2Pos"..player2:Name(), pos2v)
	
	pos1 = Lerp(0.35, pos1, pos1v)
	pos2 = GetGlobalFloat("PongPlayer2Pos"..player2:Name())
	local ballvel = GetGlobalVector("PongBallVelocity"..player1:Name()..player2:Name())
	SetGlobalVector("PongBallPos"..player1:Name()..player2:Name(), GetGlobalVector("PongBallPos"..player1:Name()..player2:Name()) + (ballvel * (0.7)))
	local ballpos = GetGlobalVector("PongBallPos"..player1:Name()..player2:Name())
	surface.SetDrawColor(100,100,100,255)
	surface.DrawRect(-10 + offsetx, -10 + offsety, 532, 532)
	surface.SetDrawColor(0,0,0,255)
	surface.DrawRect(0 + offsetx, 0 + offsety, 512, 512)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawRect(15 + offsetx, pos1 + offsety, 16, 64)
	surface.DrawRect(481 + offsetx, pos2 + offsety, 16, 64)
	if GetGlobalBool("PongStartup"..player1:Name()..player2:Name()) then
	surface.SetFont("DermaLarge")
	surface.SetTextColor(230,230,230)
	surface.SetTextPos(190 + offsetx, 226 + offsety)
	surface.DrawText("MAGNUM")
	surface.SetTextPos(210 + offsetx, 256 + offsety)
	surface.DrawText("PONG")
	end
	if !GetGlobalBool("PongStartup"..player1:Name()..player2:Name()) then
	surface.SetFont("DermaLarge")
	surface.SetTextColor(230,230,230)
	surface.SetTextPos(225 + offsetx, 15 + offsety)
	surface.DrawText(GetGlobalFloat("PongScore"..player1:Name()))
	surface.SetTextPos(15 + offsetx, -45 + offsety)
	surface.DrawText(player1:Name().." VS "..player2:Name())
	surface.SetTextPos(263 + offsetx, 15 + offsety)
	
	surface.SetDrawColor(255,255,255,150)

	surface.DrawRect(250 + offsetx, 13 + offsety, 3, 35)
	surface.SetDrawColor(255,255,255,255)

	surface.DrawText(GetGlobalFloat("PongScore"..player2:Name()))
	surface.SetTextPos(245 + offsetx, 65 + offsety)
	if GetGlobalFloat("PongTimer"..player1:Name()..player2:Name()) >= 0.5 then
	surface.DrawText(math.Round(GetGlobalFloat("PongTimer"..player1:Name()..player2:Name())), 2)
	end
	surface.DrawRect(ballpos.x - 4 + offsetx, ballpos.y - 4 + offsety, 8, 8)
	surface.SetDrawColor(255,255,255,150)
	surface.DrawRect(ballpos.x - 4 + offsetx - ballvel.x, ballpos.y - 4 + offsety - ballvel.y, 8, 8)
	surface.SetDrawColor(255,255,255,50)
	surface.DrawRect(ballpos.x - 4 + offsetx - (ballvel.x * 2), ballpos.y - 4 + offsety - (ballvel.y * 2), 8, 8)
	end
end)
end)
net.Receive("atum.StopMagnumPong", function()
	hook.Remove("HUDPaint", "MagnumPong")
end)
end
function ENT:AtumHandleWin(winner, player2)
	self.Wep.Souls = self.Wep.Souls or {}
	self.Wep.SoulWeapons = self.Wep.SoulWeapons or {}
	if winner == self.Owner then
	table.insert(self.Wep.Souls, player2)
	self.Wep.SoulWeapons[player2] = {}
	for k,v in pairs(player2:GetWeapons()) do
		table.insert(self.Wep.SoulWeapons[player2], v:GetClass())
	end
	local tag = player2:GetName()
	hook.Add("PostPlayerDeath", "WatchDeathAtum"..tag, function(ply)
	if ply:IsValid() then
		if self:IsValid() then
			table.RemoveByValue(self.Wep.Souls, ply)
			if IsValid(ply.ATMDoll) then
			ply.ATMDoll:Remove()
		end
		end
	else
	hook.Remove("PostPlayerDeath", "WatchDeathAtum"..tag)
	end
	end)
	player2:ExitVehicle()
	player2:Spectate(OBS_MODE_CHASE)
	player2:SpectateEntity(winner)
	player2:StripWeapons()
	player2:SetNoDraw(true)
	timer.Simple(0.4, function() player2:SetNoDraw(true) end)
	player2.ATMDoll = ents.Create("prop_ragdoll")
	player2.ATMDoll:SetModel(player2:GetModel())
	player2.ATMDoll:SetColor(player2:GetColor())
	player2.ATMDoll:SetSkin(player2:GetSkin())
	player2.ATMDoll:SetPos(player2:GetPos())
	player2.ATMDoll:Spawn()
	player2.ATMDoll:Activate()
	
	timer.Simple(0.3, function()
	local Soul = ents.Create("soul")
	Soul:SetModel(player2:GetModel())
	Soul:SetMaterial("models/debug/debugwhite")
	Soul:SetColor(Color(214,193,0,250))
	Soul:SetSkin(player2:GetSkin())
	Soul:SetPos(player2:GetPos())
	Soul:ResetSequence(Soul:LookupSequence("swim_idle_all"))
	Soul.OwningOsiris = self
	Soul:Spawn()
	Soul:EmitStandSound(Rip)
	Soul:Activate()
	
	end)

	else
	self:ReleaseSoulsATM(false)
	end
	end
function ENT:Use(activate, user)
	if self:GetModel() == "models/player/jgm/jgm.mdl" and user != self.Owner then
		user.CountWishes = user.CountWishes or 0
		if user.CountWishes == 0 then
			hook.Add("PostPlayerDeath", "RefreshWishes"..user:GetName(), function(ply) if ply == user then user.CountWishes = nil hook.Remove("PostPlayerDeath", "RefreshWishes"..user:GetName()) end end)
		end
			if user.CountWishes < 3 then
				user.CountWishes = user.CountWishes + 1
				self.Owner:ChatPrintFormatted("#gstands.jgm.wishnotify", user:GetName())
				self:EmitStandSound(anything)
				net.Start("jgm.wishmenu")
				net.WriteEntity(self)
				net.WriteEntity(user)
				net.Send(user)
			elseif self:GetSequence() != self:LookupSequence("justdontget") and !(self.jgmanim1 and self:IsValidLayer(self.jgmanim1))then
				self.jgmanim1 = self:AddLayeredSequence(self:LookupSequence("justdontget"))
				self:EmitStandSound(nope)
				user:ChatPrint("#gstands.jgm.wishlast")
				timer.Simple(3, function() self:RemoveAllGestures() end)
			end
	end
	if self:GetModel() == "models/player/osi/osi.mdl" and user != self.Owner then
		self:DoRoll(user)
	end
	if self:GetModel() == "models/player/atm/atm.mdl" and user != self.Owner and !user.InPong and !self.Owner.InPong and !user:GetObserverTarget():IsValid() then
		local plrs = RecipientFilter()
		plrs:AddPlayer(self.Owner)
		plrs:AddPlayer(user)
		self.plrs = plrs
		net.Start("atum.StartMagnumPong")
			net.WriteEntity(self.Owner)
			net.WriteEntity(user)
		net.Send(plrs)
	end
end	

local props = {
		"models/props_c17/oildrum001.mdl",
		"models/props_c17/gravestone_cross001b.mdl",
		"models/props_c17/Lockers001a.mdl",
		"models/props_lab/blastdoor001c.mdl",
		"models/props_wasteland/kitchen_counter001a.mdl",
		"models/props_junk/TrashDumpster02.mdl"
}
function ENT:HandleAnimEvent(ID, Time, Frame, Type, Options)
	if ID == 3100 then
		self:EmitStandSound(Clap)
	end
end
local maliciouswishes = {
	function(self, wisher)
		local ent = ents.Create("prop_physics")
		ent:SetModel(props[math.random(1, #props - 1)])
		ent:SetPos(wisher:GetPos() + Vector(0,0,256))
		ent:Spawn()
		ent:Activate()
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, ent, 1)
		ent:EmitStandSound(dirt)
		ent:SetPhysicsAttacker(self.Owner)
		timer.Simple(2, function() ent:Remove() end)
	end,
	function(self, wisher)
	local dmginfo = DamageInfo()
	dmginfo:SetAttacker( self.Owner )
	dmginfo:SetInflictor( self.Owner:GetActiveWeapon() )
	dmginfo:SetDamage( wisher:GetMaxHealth() - wisher:Health() )
	wisher:TakeDamageInfo( dmginfo )
	ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
	wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
	wisher:SetArmor(100)
	wisher:SetCrouchedWalkSpeed(15)
	wisher:SetMaxSpeed(15)
	wisher:SetRunSpeed(15)
	wisher:SetWalkSpeed(15)
	wisher:SetJumpPower(150)
	ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
	wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
		local puppeteer = ents.Create("npc_barney")
		puppeteer:SetPos(self:GetPos() - Vector(35,35,15))
		puppeteer:Spawn()
		puppeteer:Activate()
		puppeteer:SetEnemy(wisher)
		puppeteer:SetTarget(wisher)
		puppeteer:Give("weapon_crowbar")
		puppeteer:AddEntityRelationship(self.Owner, D_LI, 99)
		puppeteer:AddEntityRelationship(wisher, D_HT, 99)
		local puppet = ents.Create("prop_dynamic")
		local dead = {}
		for k,v in pairs(player.GetAll()) do
			if !v:Alive() then
				table.insert(dead, v)
			end
		end
		local deadmanmod = "models/player/skeleton.mdl"
		local deadman = self.Owner
		if #dead > 0 then
			deadman = table.Random(dead)
			deadmanmod = deadman:GetModel()
		end
		  if IsValid(puppet) then
			puppeteer:AddEffects(EF_NODRAW)
			puppet:SetModel(deadmanmod or "models/player/skeleton.mdl")
			puppet:Spawn()
			puppet:Activate()
			ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, puppet, 1)
			puppet:EmitStandSound(dirt)
			puppet:SetColor(deadman:GetColor())
			puppet:SetSkin(deadman:GetSkin())
			local propAttachments = puppet:GetAttachments()
			if #puppeteer:GetAttachments() > 0 and #propAttachments > 0 then
				puppet:SetNotSolid(true)
				puppet:AddEffects( EF_BONEMERGE || EF_BONEMERGE_FASTCULL || EF_PARENT_ANIMATES)
				puppet:SetParent(puppeteer)
				puppet:Fire("Setparentattachment",  puppeteer:GetAttachments()[1].name)
			end
		end
	end,
	function(self, wisher)
		local car = ents.Create("prop_vehicle_jeep_old")
		car:SetModel("models/buggy.mdl")
		car:SetKeyValue("vehiclescript", "scripts/vehicles/jeep_test.txt")
		car:SetPos(wisher:GetPos())
		car:Spawn()
		car:GetPhysicsObject():SetVelocity(car:GetForward() * 3500)
		wisher:EnterVehicle(car)
		car:SetThrottle(500)
		car:AddCallback("PhysicsCollide", function(ent, data) if data.HitNormal:Distance(Vector(1, 0, 0)) <= 0.1 or data.HitNormal:Distance(Vector(-1, 0, 0)) <= 0.1 or data.HitNormal:Distance(Vector(0, 1, 0)) <= 0.1 or data.HitNormal:Distance(Vector(0, -1, 0)) <= 0.1 then util.BlastDamage(self.Owner:GetActiveWeapon(), self.Owner, data.HitPos, 150, 500) car:Remove() end end)
		car:CallOnRemove("CallbacksEverywhere", function() hook.Remove("CanExitVehicle", "JudgementJeepLock"..self.Owner:GetName()) end)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, car, 1)
		car:EmitStandSound(dirt)
		hook.Add("CanExitVehicle", "JudgementJeepLock"..self.Owner:GetName(), function(veh, ply)
			if !car:IsValid() then
				hook.Remove("CanExitVehicle", "JudgementJeepLock"..self.Owner:GetName())
			end
			if veh == car then
				return false
			end
		end)
	end,
	function(self, wisher)
		wisher:SetMoveType(MOVETYPE_FLY)
		wisher:SetPos(wisher:GetPos() + Vector(0,0,1))
		wisher:SetVelocity(Vector(0,0,15))
		wisher:SetCrouchedWalkSpeed(1)
		wisher:SetMaxSpeed(1)
		wisher:SetRunSpeed(1)
		wisher:SetWalkSpeed(1)
		wisher:SetJumpPower(1)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)

	end,
	function(self, wisher)
		wisher:GodEnable()
		wisher:AddFlags(FL_FROZEN)
		wisher:SetMaterial("models/props_canal/rock_riverbed01a")
		wisher:EmitSound("physics/concrete/concrete_break2.wav")
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)
		hook.Add("PostPlayerDeath", "ReleasePlayerImmortality"..wisher:GetName(), function(ply) if ply == wisher then ply:GodDisable() wisher:SetMaterial("") ply:RemoveFlags(FL_FROZEN) hook.Remove("PostPlayerDeath", "ReleasePlayerImmortality"..wisher:GetName()) end end)
	end,
	function(self, wisher)
		local puppeteer = ents.Create("npc_citizen")
		puppeteer:SetPos(self:GetPos() - Vector(35,35,15))
		puppeteer:Spawn()
		puppeteer:Activate()
		puppeteer:SetEnemy(wisher)
		puppeteer:SetTarget(wisher)
		puppeteer:Give("weapon_ar2")
		puppeteer:AddEntityRelationship(self.Owner, D_LI, 99)
		puppeteer:AddEntityRelationship(wisher, D_HT, 99)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, puppeteer, 1)
		puppeteer:EmitStandSound(dirt)
	end,
	function(self, wisher)
		for i = 0, 3 do
			local ent = ents.Create("prop_physics")
			ent:SetModel("models/items/ammocrate_ar2.mdl")
			ent:SetPos(wisher:GetPos() + Vector(0,0,256 + (i * 15)))
			ent:Spawn()
			ent:Activate()
			ent:GetPhysicsObject():SetVelocity(Vector(0,0,-1000))
			ent:SetPhysicsAttacker(self.Owner)
			ent:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
			ParticleEffectAttach("mudsmall", PATTACH_POINT_FOLLOW, ent, 1)
			ent:EmitStandSound(dirt)
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self.Owner )
			dmginfo:SetInflictor( self.Owner:GetActiveWeapon() )
			dmginfo:SetDamage( wisher:GetMaxHealth() )
			ent:AddCallback("PhysicsCollide", function(ent, data) if ent == wisher then wisher:TakeDamageInfo(dmginfo) end end)
			timer.Simple(2, function() ent:Remove() end)
		end
	end,
	function(self, wisher)
		ent:EmitStandSound(dirt)
		timer.Create("infinitemoney"..wisher:GetName(), 0.1, 0, function() 
		local ent = ents.Create("prop_physics")
			ent:SetModel("models/gold/gstands_gold.mdl")
			ent:SetPos(wisher:GetPos() + Vector(0,0,200))
			ent:Spawn()
			ent:Activate()
			ent:GetPhysicsObject():SetVelocity(Vector(0,0,-45))
			ent:GetPhysicsObject():SetMass(50)
			ent:SetPhysicsAttacker(self.Owner)
		ParticleEffectAttach("mudsmall", PATTACH_POINT_FOLLOW, ent, 1)
			timer.Simple(2, function() ent:Remove() end)
		end)
		hook.Add("PostPlayerDeath", "ReleasePlayerInfiniteGold"..wisher:GetName(), function(ply) if ply == wisher then timer.Remove("infinitemoney"..wisher:GetName()) hook.Remove("PostPlayerDeath", "ReleasePlayerInfiniteGold"..wisher:GetName()) end end)
	end,
	function(self, wisher)
		net.Start("jgm.knowledge")
		net.WriteEntity(self)
		net.WriteEntity(wisher)
		net.Send(wisher)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
		local puppeteer = ents.Create("npc_alyx")
		puppeteer:SetPos(self:GetPos() - Vector(35,35,15))
		puppeteer:Spawn()
		puppeteer:Activate()
		puppeteer:SetEnemy(wisher)
		puppeteer:SetTarget(wisher)
		puppeteer:Give("weapon_shotgun")
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, puppeteer, 1)
		puppeteer:EmitStandSound(dirt)
		puppeteer:AddEntityRelationship(self.Owner, D_LI, 99)
		puppeteer:AddEntityRelationship(wisher, D_HT, 99)
	end,
	function(self, wisher)
		local puppeteer = ents.Create("npc_barney")
		puppeteer:SetPos(self:GetPos() - Vector(35,35,15))
		puppeteer:Spawn()
		puppeteer:Activate()
		puppeteer:SetEnemy(wisher)
		puppeteer:SetTarget(wisher)
		puppeteer:Give("weapon_shotgun")
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, puppeteer, 1)
		puppeteer:AddEntityRelationship(self.Owner, D_LI, 99)
		puppeteer:AddEntityRelationship(wisher, D_HT, 99)
	end,
	function(self, wisher)
		local ent = ents.Create("prop_physics")
		ent:SetModel("models/stand_arrow/stand_arrow_long.mdl")
		local tr = util.TraceLine({
			start=wisher:WorldSpaceCenter(),
			endpos=wisher:WorldSpaceCenter() + VectorRand() * 200,
			filter={wisher}
		})
		ent:SetPos(tr.HitPos - tr.Normal * 10)
		ent:SetAngles(-tr.Normal:Angle())
		ent:Spawn()
		ent:Activate()
		ent:GetPhysicsObject():SetVelocity(-tr.Normal * 5000)
		ent:GetPhysicsObject():SetMass(50)
		ent:SetPhysicsAttacker(self.Owner)
		timer.Simple(2, function() ent:Remove() end)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, ent, 1)
		ent:EmitStandSound(dirt)
	end,
	function(self, wisher)
		if util.IsValidModel("models/player/roh/rohan3/rohan3.mdl") then
			wisher:SetModel("models/player/roh/rohan3/rohan3.mdl")
		end
		wisher:SetModelScale(1.1, 1)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
		local hooktag = wisher:GetName()
		hook.Add("Tick", "JudgementWaterWalk"..hooktag, function()
			if IsValid(wisher) and wisher:Alive() then
				trace = util.TraceLine( {
					start = wisher:GetPos() + Vector( 0, 0, 72),
					endpos = wisher:GetPos() + Vector( 0, 0, -10 ),
					mask = MASK_WATER,
					filter = function( ent ) return true end
				} )
				
				if( trace.Hit ) then
					wisher:SetGravity( 0 )
					wisher:SetGroundEntity( world )
					local vel = wisher:GetVelocity()
					vel.x = 0
					vel.y = 0
					vel.z = -vel.z - (wisher:GetPos().z - trace.HitPos.z) + 5
					wisher:SetVelocity(vel)
				else
					wisher:SetVelocity(-wisher:GetVelocity())
				end
				else
				hook.Remove("Tick", "JudgementWaterWalk"..hooktag)
			end
		end)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)
		ParticleEffectAttach("muddyshoes", PATTACH_POINT_FOLLOW, wisher, 1)
	end,
	function(self, wisher)
		local hooktag = wisher:GetName()
		wisher:SetRunSpeed(100000000)
		hook.Add("Tick", "JudgementRunFast"..hooktag, function()
			if IsValid(wisher) and wisher:Alive() then
				wisher:Ignite(1)
				else
				hook.Remove("Tick", "JudgementRunFast"..hooktag)
			end
		end)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
		local hooktag = wisher:GetName()
		hook.Add("EntityTakeDamage", "JudgementStrongman"..hooktag, function(ent, dmg)
			if IsValid(wisher) and wisher:Alive() then
				if dmg:GetAttacker() == wisher and ent != wisher then
					dmg:SetDamage(dmg:GetDamage() * 10)
					wisher:TakeDamageInfo(dmg)
				end
				else
				hook.Remove("EntityTakeDamage", "JudgementStrongman"..hooktag)
			end
		end)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
		wisher:SetJumpPower(50000)
		local hooktag = wisher:GetName()
		hook.Add("EntityTakeDamage", "JudgementFallDamage"..hooktag, function(ent, dmg)
			if IsValid(wisher) and wisher:Alive() then
				if ent == wisher and dmg:IsFallDamage() then
					dmg:SetDamage(dmg:GetDamage() * 1000)
				end
				else
				hook.Remove("EntityTakeDamage", "JudgementFallDamage"..hooktag)
			end
		end)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
		wisher:ScreenFade(SCREENFADE.STAYOUT, color_black, 1, 10)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
			local hooktag = wisher:GetName()

		hook.Add("Tick", "JudgementAttract"..hooktag, function()
			if IsValid(wisher) and wisher:Alive() then
				for k,v in pairs(ents.FindInSphere(wisher:GetPos(), 1000)) do
					if IsValid(v:GetPhysicsObject()) then
						local phys = v:GetPhysicsObject()
						local norm = -(v:GetPos() - wisher:GetPos()):GetNormalized()
						phys:SetVelocity(norm * 500)
					end
				end
				else
				hook.Remove("Tick", "JudgementAttract"..hooktag)
			end
		end)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
		local ent = ents.Create("judgement_clone")
		ent.Target = wisher
		ent:SetPos(wisher:GetPos() + wisher:GetRight() * 55)
		ent:SetOwner(self.Owner)
		ent:Spawn()
		ent:Activate()
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, ent, 1)
		ent:EmitStandSound(dirt)
		local ent1 = ents.Create("judgement_clone")
		ent1.Target = wisher
		ent1:SetPos(wisher:GetPos() - wisher:GetRight() * 55)
		ent1:SetOwner(self.Owner)
		ent1:Spawn()
		ent1:Activate()
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, ent1, 1)
		ent1:EmitStandSound(dirt)
		local ent2 = ents.Create("judgement_clone")
		ent2.Target = wisher
		ent2:SetPos(wisher:GetPos() + wisher:GetForward() * 55)
		ent2:SetOwner(self.Owner)
		ent2:Spawn()
		ent2:Activate()
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, ent2, 1)
		ent2:EmitStandSound(dirt)
		timer.Simple(0.5, function() ent:Remove() ent1:Remove() ent2:Remove() end)
	end,
}
local beneficialwishes = {
	function(self, wisher)
		local ent = ents.Create("prop_physics")
		ent:SetModel(props[math.random(1, #props - 1)])
		ent:SetPos(wisher:GetPos() + (wisher:GetForward() * 256) + Vector(0,0,256))
		ent:Spawn()
		ent:Activate()
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, ent, 1)
		ent:EmitStandSound(dirt)
		timer.Simple(2, function() ent:Remove() end)
	end,
	function(self, wisher)
		wisher:SetHealth(math.min(wisher:Health() + 100, wisher:GetMaxHealth()))
		wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
	wisher:SetArmor(100)
	ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
	wisher:EmitStandSound(dirt)

	end,
	function(self, wisher)
		local puppeteer = ents.Create("npc_barney")
		puppeteer:SetPos(self:GetPos() - Vector(35,35,15))
		puppeteer:Spawn()
		puppeteer:Activate()
		
		puppeteer:Give("weapon_crowbar")
		puppeteer:AddEntityRelationship(wisher, D_LI, 99)
		local puppet = ents.Create("prop_dynamic")
		local dead = {}
		for k,v in pairs(player.GetAll()) do
			if !v:Alive() then
				table.insert(dead, v)
			end
		end
		local deadmanmod = "models/player/skeleton.mdl"
		local deadman = self.Owner
		if #dead > 0 then
			deadman = table.Random(dead)
			deadmanmod = deadman:GetModel()
		end
		  if IsValid(puppet) then
			puppeteer:AddEffects(EF_NODRAW)
			puppet:SetModel(deadmanmod or "models/player/skeleton.mdl")
			puppet:Spawn()
			puppet:Activate()
			ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, puppet, 1)
			puppet:EmitStandSound(dirt)
			puppet:SetColor(deadman:GetColor())
			puppet:SetSkin(deadman:GetSkin())
			local propAttachments = puppet:GetAttachments()
			if #puppeteer:GetAttachments() > 0 and #propAttachments > 0 then
				puppet:SetNotSolid(true)
				puppet:AddEffects( EF_BONEMERGE || EF_BONEMERGE_FASTCULL || EF_PARENT_ANIMATES)
				puppet:SetParent(puppeteer)
				puppet:Fire("Setparentattachment",  puppeteer:GetAttachments()[1].name)
			end
		end
	end,
	function(self, wisher)
		local car = ents.Create("prop_vehicle_jeep_old")
		car:SetModel("models/buggy.mdl")
		car:SetKeyValue("vehiclescript", "scripts/vehicles/jeep_test.txt")
		car:SetPos(wisher:GetPos())
		car:Spawn()
		wisher:EnterVehicle(car)
		car:EmitStandSound(dirt)
		car:SetThrottle(500)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, car, 1)
	end,
	function(self, wisher)
		wisher:SetMoveType(MOVETYPE_FLY)
		wisher:SetPos(wisher:GetPos() + Vector(0,0,1))
		wisher:SetVelocity(Vector(0,0,15))
		wisher:EmitStandSound(dirt)
		timer.Simple(3, function() if IsValid(wisher) then wisher:SetMoveType(MOVETYPE_WALK) end end)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
	end,
	function(self, wisher)
		wisher:GodEnable()
		wisher:AddFlags(FL_FROZEN)
		wisher:SetMaterial("models/props_canal/rock_riverbed01a")
		wisher:EmitSound("physics/concrete/concrete_break2.wav")
		wisher:EmitStandSound(dirt)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		hook.Add("PostPlayerDeath", "ReleasePlayerImmortality"..wisher:GetName(), function(ply) if ply == wisher then ply:GodDisable() wisher:SetMaterial("") ply:RemoveFlags(FL_FROZEN) hook.Remove("PostPlayerDeath", "ReleasePlayerImmortality"..wisher:GetName()) end end)
	end,
	function(self, wisher)
		local puppeteer = ents.Create("npc_citizen")
		puppeteer:SetPos(self:GetPos() - Vector(35,35,15))
		puppeteer:Spawn()
		puppeteer:Activate()
		puppeteer:Give("weapon_ar2")
		puppeteer:AddEntityRelationship(wisher, D_LI, 99)
		puppeteer:EmitStandSound(dirt)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, puppeteer, 1)
	end,
	function(self, wisher)
		wisher:GiveAmmo( 5, "AR2AltFire", true )
		wisher:GiveAmmo( 200, "Pistol", true )
		wisher:GiveAmmo( 200, "SMG1", true )
		wisher:GiveAmmo( 200, "357", true )
		wisher:GiveAmmo( 200, "XBowBolt", true )
		wisher:GiveAmmo( 200, "Buckshot", true )
		wisher:GiveAmmo( 5, "RPG_Round", true )
		wisher:GiveAmmo( 5, "SMG1_Grenade", true )
		wisher:GiveAmmo( 5, "Grenade", true )
		wisher:GiveAmmo( 5, "slam", true )
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
		timer.Create("infinitemoney"..wisher:GetName(), 0.1, 0, function() 
		local ent = ents.Create("prop_physics")
			ent:SetModel("models/gold/gstands_gold.mdl")
			ent:SetPos(wisher:GetPos() + Vector(0,0,200))
			ent:Spawn()
			ent:Activate()
			ParticleEffectAttach("mudsmall", PATTACH_POINT_FOLLOW, ent, 1)
			timer.Simple(2, function() ent:Remove() end)
		end)
		hook.Add("PostPlayerDeath", "ReleasePlayerInfiniteGold"..wisher:GetName(), function(ply) if ply == wisher then timer.Remove("infinitemoney"..wisher:GetName()) hook.Remove("PostPlayerDeath", "ReleasePlayerInfiniteGold"..wisher:GetName()) end end)
		wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
		net.Start("jgm.knowledge")
		net.WriteEntity(self)
		net.WriteEntity(wisher)
		net.Send(wisher)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
		local puppeteer = ents.Create("npc_alyx")
		puppeteer:SetPos(self:GetPos() - Vector(35,35,15))
		puppeteer:Spawn()
		puppeteer:Activate()
		puppeteer:Give("weapon_shotgun")
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, puppeteer, 1)
		puppeteer:EmitStandSound(dirt)
		puppeteer:AddEntityRelationship(wisher, D_LI, 99)
	end,
	function(self, wisher)
		local puppeteer = ents.Create("npc_barney")
		puppeteer:SetPos(self:GetPos() - Vector(35,35,15))
		puppeteer:Spawn()
		puppeteer:Activate()
		puppeteer:Give("weapon_shotgun")
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, puppeteer, 1)
		puppeteer:EmitStandSound(dirt)
		puppeteer:AddEntityRelationship(wisher, D_LI, 99)
	end,
	function(self, wisher)
		local ent = ents.Create("prop_physics")
		ent:SetModel("models/stand_arrow/stand_arrow_long.mdl")
		local tr = util.TraceLine({
			start=wisher:WorldSpaceCenter(),
			endpos=wisher:WorldSpaceCenter() + VectorRand() * 200,
			filter={wisher}
		})
		ent:SetPos(tr.HitPos - tr.Normal * 10)
		ent:Spawn()
		ent:Activate()
		ent:SetPhysicsAttacker(self.Owner)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, ent, 1)
		ent:EmitStandSound(dirt)
		timer.Simple(10, function() ent:Remove() end)
	end,
	function(self, wisher)
		if util.IsValidModel("models/player/roh/rohan3/rohan3.mdl") then
			wisher:SetModel("models/player/roh/rohan3/rohan3.mdl")
		end
		wisher:SetModelScale(1.1, 1)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
		local hooktag = wisher:GetName()
		hook.Add("Tick", "JudgementWaterWalk"..hooktag, function()
			if IsValid(wisher) and wisher:Alive() then
				trace = util.TraceLine( {
					start = wisher:GetPos() + Vector( 0, 0, 72),
					endpos = wisher:GetPos() + Vector( 0, 0, -10 ),
					mask = MASK_WATER,
					filter = function( ent ) return true end
				} )
				
				if( trace.Hit ) then
					wisher:SetGravity( 0 )
					wisher:SetGroundEntity( world )
					local vel = wisher:GetVelocity()
					vel.x = 0
					vel.y = 0
					vel.z = -vel.z - (wisher:GetPos().z - trace.HitPos.z) + 5
					wisher:SetVelocity(vel)
				end
				else
				hook.Remove("Tick", "JudgementWaterWalk"..hooktag)
			end
		end)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)
		ParticleEffectAttach("muddyshoes", PATTACH_POINT_FOLLOW, wisher, 1)
	end,
	function(self, wisher)
		local hooktag = wisher:GetName()
		wisher:SetRunSpeed(750)
		hook.Add("Tick", "JudgementRunFast"..hooktag, function()
			if IsValid(wisher) and wisher:Alive() then
				else
				hook.Remove("Tick", "JudgementRunFast"..hooktag)
			end
		end)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
		local hooktag = wisher:GetName()
		hook.Add("EntityTakeDamage", "JudgementStrongman"..hooktag, function(ent, dmg)
			if IsValid(wisher) and wisher:Alive() then
				if dmg:GetAttacker() == wisher and ent != wisher then
					dmg:SetDamage(dmg:GetDamage() * 2)
				end
				else
				hook.Remove("EntityTakeDamage", "JudgementStrongman"..hooktag)
			end
		end)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
		wisher:SetJumpPower(50000)
		local hooktag = wisher:GetName()
		hook.Add("EntityTakeDamage", "JudgementFallDamage"..hooktag, function(ent, dmg)
			if IsValid(wisher) and wisher:Alive() then
				if ent == wisher and dmg:IsFallDamage() then
					dmg:SetDamage(dmg:GetDamage() * 2)
				end
				else
				hook.Remove("EntityTakeDamage", "JudgementFallDamage"..hooktag)
			end
		end)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
		wisher:ScreenFade(SCREENFADE.STAYOUT, color_black, 1, 10)
	end,
	function(self, wisher)
			local hooktag = wisher:GetName()

		hook.Add("Tick", "JudgementAttract"..hooktag, function()
			if IsValid(wisher) and wisher:Alive() then
				for k,v in pairs(ents.FindInSphere(wisher:GetPos(), 1000)) do
					if IsValid(v:GetPhysicsObject()) then
						local phys = v:GetPhysicsObject()
						local norm = -(v:GetPos() - wisher:GetPos()):GetNormalized()
						phys:SetVelocity(norm * 100)
					end
				end
				else
				hook.Remove("Tick", "JudgementAttract"..hooktag)
			end
		end)
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, wisher, 1)
		wisher:EmitStandSound(dirt)
	end,
	function(self, wisher)
		local ent = ents.Create("judgement_clone")
		ent.Target = wisher
		ent:SetPos(wisher:GetPos() + wisher:GetRight() * 55)
		ent:SetOwner(self.Owner)
		ent:Spawn()
		ent:Activate()
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, ent, 1)
		ent:EmitStandSound(dirt)
		local ent1 = ents.Create("judgement_clone")
		ent1.Target = wisher
		ent1:SetPos(wisher:GetPos() - wisher:GetRight() * 55)
		ent1:SetOwner(self.Owner)
		ent1:Spawn()
		ent1:Activate()
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, ent1, 1)
		ent1:EmitStandSound(dirt)
		local ent2 = ents.Create("judgement_clone")
		ent2.Target = wisher
		ent2:SetPos(wisher:GetPos() + wisher:GetForward() * 55)
		ent2:SetOwner(self.Owner)
		ent2:Spawn()
		ent2:Activate()
		ParticleEffectAttach("mud", PATTACH_POINT_FOLLOW, ent2, 1)
		ent2:EmitStandSound(dirt)
		timer.Simple(0.5, function() ent:Remove() ent1:Remove() ent2:Remove() end)
	end,
}
function ENT:DoWish(id, wisher)
	if SERVER then
		local beneficial = self.Wep:GetAMode()
		if beneficial then
			beneficialwishes[id](self, wisher)
		else
			maliciouswishes[id](self, wisher)
		end
	end
end		
function ENT:OnRemove()
		if self.Owner then
		hook.Remove("PlayerSwitchFlashlight", "StandFlashlightsareCool"..self.OwnerName..self:EntIndex())
		end
		if CLIENT and self.Aura then
			self.Aura:StopEmission()
		end
		if IsValid(self.Owner) then
			self.Owner:RemoveFlags(FL_ATCONTROLS)
		end
		if self.plrs then
		local ply1 = self.plrs:GetPlayers()[1]
		local ply2 = self.plrs:GetPlayers()[2]
		local gametag = ply1:Name()..ply2:Name()
				hook.Remove("Tick", "MagnumPongThink"..gametag)

		net.Start("atum.StopMagnumPong")
		net.Send(self.plrs)
		SetGlobalFloat("PongScore"..ply1:Name(), 0)
		SetGlobalFloat("PongScore"..ply2:Name(), 0)
		SetGlobalVector("PongBallVelocity"..gametag, Vector(0,0,0))
		SetGlobalVector("PongBallPos"..gametag, Vector(256, 256, 0))
		SetGlobalFloat("PongPlayer1Pos"..ply1:Name(), 224)
		SetGlobalFloat("PongPlayer2Pos"..ply2:Name(), 224)
		ply1:SetWalkSpeed(200)
		ply1:SetRunSpeed(400)
		ply1:SetJumpPower(200)
		ply1:SetCrouchedWalkSpeed(0.30000001192093)
		ply1:SetMaxSpeed(200)
		ply1:SetDuckSpeed(0.1)
		ply1:SetUnDuckSpeed(0.1)
		ply1.InPong = false
		ply2:SetWalkSpeed(200)
		ply2:SetRunSpeed(400)
		ply2:SetJumpPower(200)
		ply2:SetCrouchedWalkSpeed(0.30000001192093)
		ply2:SetMaxSpeed(200)
		ply2:SetDuckSpeed(0.1)
		ply2:SetUnDuckSpeed(0.1)
		ply2.InPong = false
		return false
end
end
hook.Add("PlayerGiveSWEP", "PreventTSWeaponGrab", function(ply) 
	if ply:GetObserverMode() != 0 then
		return false
	end 
end)
if SERVER then
	function ENT:DoRoll(user)
		if !self.InRoll then
			local roll1 = math.random(1,6)
			local roll2 = math.random(1,6)
			local player1 = self.Owner
			local player2 = user
			local tab = {
			[roll1] = player1:Name(),
			[roll2] = player2:Name(),
			}
			player1:PrintMessage(HUD_PRINTCENTER, "Rolling...")
			player2:PrintMessage(HUD_PRINTCENTER, "Rolling...")
			local Player1Die = ents.Create("prop_physics")
			Player1Die:SetModel("models/osiris/dice.mdl")
			Player1Die:SetPos(player1:EyePos())
			Player1Die:SetAngles(AngleRand())
			Player1Die:SetOwner(player1)
			Player1Die:Spawn()
			Player1Die:Activate()
			Player1Die:SetModelScale(0.1)
			local vel = player1:GetForward() * 150
			if player1:InVehicle() then
				vel = player1:GetVehicle():GetForward() * 150
			end
			Player1Die:GetPhysicsObject():SetVelocity(vel)
			Player1Die:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			local Player2Die = ents.Create("prop_physics")
			Player2Die:SetModel("models/osiris/dice.mdl")
			Player2Die:SetPos(player2:EyePos())
			Player2Die:SetAngles(AngleRand())
			Player2Die:SetOwner(player2)
			Player2Die:Spawn()
			Player2Die:Activate()
			Player2Die:SetModelScale(0.1)
			local vel = player2:GetForward() * 150
			if player2:InVehicle() then
				vel = player2:GetVehicle():GetForward() * 150
			end
			Player2Die:GetPhysicsObject():SetVelocity(vel)
			Player2Die:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			self.Owner:EmitSound(Goodo)
			timer.Simple(3, function() if Player1Die:IsValid() then Player1Die:Remove() end if Player2Die:IsValid() then Player2Die:Remove() end end)
			timer.Simple(1, function() if player1:IsValid() and player2:IsValid() then player1:PrintMessage(HUD_PRINTCENTER, player1:Name().." rolled "..roll1) player2:PrintMessage(HUD_PRINTCENTER, player1:Name().." rolled "..roll1) end end)
			timer.Simple(2, function() if player1:IsValid() and player2:IsValid() then player1:PrintMessage(HUD_PRINTCENTER, player2:Name().." rolled "..roll2) player2:PrintMessage(HUD_PRINTCENTER, player2:Name().." rolled "..roll2) end end)
			timer.Simple(3, function() if player1:IsValid() and player2:IsValid() then player1:PrintMessage(HUD_PRINTCENTER, tab[math.max(roll1, roll2)].." Won!") player2:PrintMessage(HUD_PRINTCENTER, tab[math.max(roll1, roll2)].." Won!") end end)
			self.InRoll = true
			self.Wep.Souls = self.Wep.Souls or {}
			self.Wep.SoulWeapons = self.Wep.SoulWeapons or {}
			local winner = tab[math.max(roll1, roll2)]
			timer.Simple(4, function() 
				if winner == player1:Name() then
					table.insert(self.Wep.Souls, player2)
					self.Wep.SoulWeapons[player2] = {}
					for k,v in pairs(player2:GetWeapons()) do
						table.insert(self.Wep.SoulWeapons[player2], v:GetClass())
					end
					local tag = player2:GetName()
					hook.Add("PostPlayerDeath", "WatchDeathOsiris"..tag, function(ply)
					if ply:IsValid() then
						if self:IsValid() then
							table.RemoveByValue(self.Wep.Souls, ply)
							if IsValid(ply) and IsValid(ply.OSIdoll) then
							ply.OSIdoll:Remove()
							end
						end
					else
					hook.Remove("PostPlayerDeath", "WatchDeathOsiris"..tag)
					end
					end)
					player2:ExitVehicle()
					player2:Spectate(OBS_MODE_CHASE)
					player2:SpectateEntity(player1)
					player2:StripWeapons()
					player2:SetNoDraw(true)
					timer.Simple(0.4, function() player2:SetNoDraw(true) end)
					player2.OSIdoll = ents.Create("prop_ragdoll")
					player2.OSIdoll:SetModel(player2:GetModel())
					player2.OSIdoll:SetColor(player2:GetColor())
					player2.OSIdoll:SetSkin(player2:GetSkin())
					player2.OSIdoll:SetPos(player2:GetPos())
					player2.OSIdoll:Spawn()
					player2.OSIdoll:Activate()
					timer.Simple(0.3, function()
					local Soul = ents.Create("soul")
					Soul:SetModel(player2:GetModel())
					Soul:SetMaterial("models/debug/debugwhite")
					Soul:SetColor(Color(214,193,0,250))
					Soul:SetSkin(player2:GetSkin())
					Soul:SetPos(player2:GetPos())
					Soul:ResetSequence(Soul:LookupSequence("swim_idle_all"))
					Soul.OwningOsiris = self
					Soul:Spawn()
					Soul:EmitStandSound(Rip)
					Soul:Activate()
					timer.Simple(1.2, function() 
					self:AddLayeredSequence(self:LookupSequence("clap"))
					end)
					end)
					
				else
					self:ReleaseSouls(false)
				end
				end)
			timer.Simple(5, function() if self and self:IsValid() then self.InRoll = false end end)
		end
	end
	function ENT:ReleaseSouls(harsh)
		local rem = {}
		if self.Wep.Souls then
					for k,v in ipairs(self.Wep.Souls) do
						v:UnSpectate()
						v:Spawn()
						if v.OSIdoll and v.OSIdoll:IsValid() then
						v:SetPos(v.OSIdoll:GetPos())
						v.OSIdoll:Remove()
						end
						local tag = v:GetName()
						for i,j in pairs(self.Wep.SoulWeapons[v]) do
							v:Give(j)
						end
						table.insert(rem, v)
						if harsh then
							v:Kill()
						end
					end
					for k,v in ipairs(rem) do
						table.RemoveByValue(self.Wep.Souls, v)
					end
	end
	end
function ENT:ReleaseSoulsATM(harsh)
	local rem = {}
		if self.Wep.Souls then
					for k,v in ipairs(self.Wep.Souls) do
						v:UnSpectate()
						v:Spawn()
						if v.ATMDoll and v.ATMDoll:IsValid() then
						v:SetPos(v.ATMDoll:GetPos())
						v.ATMDoll:Remove()
						end
						local tag = v:GetName()
						for i,j in pairs(self.Wep.SoulWeapons[v]) do
							v:Give(j)
						end
						table.insert(rem, v)
						if harsh then
							v:Kill()
						end
					end
					for k,v in ipairs(rem) do
						table.RemoveByValue(self.Wep.Souls, v)
					end
	end
	end
end
		