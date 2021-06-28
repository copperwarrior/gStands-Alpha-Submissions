ENT.Type 			= "anim"
ENT.PrintName		= "Time Stopper"
ENT.Author			= "Copper"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.RenderGroup			= RENDERGROUP_BOTH
ENT.AdminOnly = true 
ENT.OldTSMoveTypeWO = {}

-- local OldTimerFunc = timer.Create
-- GlobalTimerTable = {}
-- timer.Create = function(str, del, repe, func)
	-- if !table.HasValue(GlobalTimerTable, str) then
	-- table.insert(GlobalTimerTable, str)
	-- end
	-- OldTimerFunc(str, del, repe, func)
	-- PrintTable(GlobalTimerTable)
-- end

-- local OldTimerSimpFunc = timer.Simple

-- timer.Simple = function(del, func)
	-- timer.Create(tostring(func), del, 1, func)
-- end
-- local StepTimer = CurTime()
-- hook.Add("Think", "ClearTimerList", function()
	-- if CurTime() >= StepTimer then
		-- local MarkedForRemoval = {}
		-- for k,v in pairs(GlobalTimerTable) do
			-- if !timer.Exists(v) then
				-- table.insert(MarkedForRemoval, v)
			-- end
		-- end
		-- for k,v in pairs(MarkedForRemoval) do
			-- table.RemoveByValue(GlobalTimerTable, v)
		-- end
	-- end
-- end)

AddCSLuaFile("shared.lua")
if SERVER then
	hook.Add("PlayerGiveSWEP", "PreventTSWeaponGrab", function(ply) 
		if IsValid(GetGlobalEntity("Time Stop")) and not CanPlayerTimeStop(ply) then
			return false
		end 
	end)
	util.AddNetworkString("ts.Enter")
	net.Receive("ts.Enter", 
		function()
			local ply = net.ReadEntity()
			if GetGlobalEntity("Time Stop").StoppedUsers then
				local wep = GetPlayerTimeStopWep(ply)
				if !ply.WasFrozen then
				table.insert(GetGlobalEntity("Time Stop").StoppedUsers, ply)
				if CanPlayerTimeStop(ply) then
					wep.TSReleaseDelay = CurTime() + 1
					MsgC(Color(255,0,0), ply:GetName().." is entering stopped time with "..v.ClassName.."!\n")
					if wep.TSConvarLimit:GetBool() then
						timer.Create("stopMax"..ply:GetName(), wep.TSConvarLength:GetFloat(), 1,
						function() 
							if GetConVar("gstands_time_stop"):GetBool() then
								ply.WasFrozen = true
								wep:StartTime()
								MsgC(Color(255,0,0), ply:GetName().." is exiting stopped time with "..v.ClassName.."!\n")
							end
						end)
					end
				end
			end
		end
	end)
end
function ENT:Initialize()
	if !GetConVar("gstands_can_time_stop"):GetBool() then
		self:Remove()
		return true
	end
	if SERVER then
		self.StoppedUsers = {
			self.Owner,
		}
		self:SetOwner(self.Owner)
		self.damages = {}
		hook.Add("EntityTakeDamage", "TimeStopBuildup", function(ent, dmg)
			if !table.HasValue(self.StoppedUsers, ent) then
				if ent:GetClass() == "stand" and table.HasValue(self.StoppedUsers, ent.Owner) then
					return false
				end
				if !ent:IsPlayer() and !ent:IsNPC() then
					local ang = LerpAngle(0.1, ent:GetAngles(), dmg:GetDamageForce():GetNormalized():Angle())
					ent.OGVel = ang:Forward() * 200
					ent.GSTSStopped = false
					ent.GSTSFactor = 1
					ent:SetAngles(ang)
				end
				self.damages[ent] = self.damages[ent] or {}
				local damag = {
					dmg:GetAmmoType(),
					dmg:GetAttacker(),
					dmg:GetBaseDamage(),
					dmg:GetDamage(),
					dmg:GetDamageBonus(),
					dmg:GetDamageCustom(),
					dmg:GetDamageForce(),
					dmg:GetDamagePosition(),
					dmg:GetDamageType(),
					dmg:GetInflictor(),
					dmg:GetMaxDamage(),
					dmg:GetReportedPosition()
				}
				table.insert(self.damages[ent], damag)
				return true
				else
				return false
			end
		end)
		hook.Remove("DoPlayerDeath", "TimeStopBuildup", function(ply, attacker, dmg)
			ply.DeathVel = ply:GetVelocity()
		end)
		hook.Remove("PlayerDeath", "TimeStopBuildup", function(ply, attacker, dmg)
			ply:GetRagdollEntity():SetVelocity(ply.DeathVel)
			ply.DeathVel = nil
		end)
		hook.Remove("EntityTakeDamage", "checker")
		self:SetPos(self.Owner:EyePos())
		
		self:SetModel("models/XQM/Rails/gumball_1.mdl")
		self:SetModelScale(0.1)
		self:SetModelScale(100, 3)
		timer.Simple(1, function() self:SetModelScale(0.01, 1) 
		end)
	end
	if CLIENT then
		
		hook.Add("CreateMove", "gstandstimestopshare", function(cmd)
			if LocalPlayer():IsFlagSet(FL_FROZEN) and ( CanPlayerTimeStop(LocalPlayer()) ) and cmd:KeyDown(IN_ATTACK2) then
					net.Start("ts.Enter")
					net.WriteEntity(LocalPlayer())
					net.SendToServer()
					hook.Remove("CreateMove", "gstandstimestopshare")
			end
		end)
		timer.Simple(1, function() self.IsExpanding = false end)
		
		local tab =  {
			[ "$pp_colour_addr" ] =  0,
			[ "$pp_colour_addg" ] =  0,
			[ "$pp_colour_addb" ] =  0,
			[ "$pp_colour_brightness" ] =  0,
			[ "$pp_colour_contrast" ] = 0.4,
			[ "$pp_colour_colour" ] = 0.01,
			[ "$pp_colour_mulr" ] = 0.5,
			[ "$pp_colour_mulg" ] = 0.5,
			[ "$pp_colour_mulb" ] = 0.5
		}
		local StartTime = CurTime()
		hook.Add( "PostDrawTranslucentRenderables", "StopTimeColour", function()
			render.ClearStencil()
			
			render.SetStencilEnable(true)
			render.SetStencilWriteMask(1 )
			render.SetStencilTestMask(1 )
			render.SetStencilReferenceValue(1 )
			render.SetStencilFailOperation(STENCILOPERATION_KEEP)
			render.SetStencilPassOperation(STENCIL_REPLACE)
			local w,h = ScrW(),ScrH()
			
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NOTEQUAL)
			render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
			self:SetMaterial("models/shadertest/shader4")
			
			self:DrawModel()
			local tabI = {
				[ "$pp_colour_addr" ] = 0,
				[ "$pp_colour_addg" ] = 0,
				[ "$pp_colour_addb" ] = 0,
				[ "$pp_colour_brightness" ] = 2,
				[ "$pp_colour_contrast" ] = 1.6,
				[ "$pp_colour_colour" ] = 2,
				[ "$pp_colour_mulr" ] = 1.5,
				[ "$pp_colour_mulg" ] = 1.5,
				[ "$pp_colour_mulb" ] = 1.5
			}
			DrawColorModify( tab )
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
			
			
			render.SetStencilEnable(false)
			
		end)
		render.UpdateScreenEffectTexture() 
		local first = true
		hook.Add( "PostDrawHUD", "StopTime", function() 
			if CanPlayerTimeStop(LocalPlayer()) then return nil end
				RunConsoleCommand("stopsound")
				DrawMotionBlur(1, 1, 10000) 
				hook.Add( "EntityEmitSound", "KillAudioVeryWell", function(dat)
					if GetConVar("gstands_time_stop"):GetBool() then
						return false
					end
				end )
		end )
	end
	-- if CLIENT then
		-- for k,v in ipairs(player.GetAll()) do
			-- v.GSTSDummyEnt = ClientsideRagdoll(v:GetModel())
			-- --v:SetupBones()
			-- v.GSTSDummyEnt:SetPos(v:GetPos())

			-- for i = 0, v.GSTSDummyEnt:GetBoneCount() do
					-- local pos, ang = v:GetBonePosition(i)
					-- v.GSTSDummyEnt:SetBonePosition(i, pos, ang)
			-- end
			-- v.GSTSDummyEnt:SetNoDraw(false)

		-- end
	-- end
	if SERVER then
		self:StopTime()
		self:Think()
	end
	
	if CLIENT and NOMBAT then
		self.NOMBAT_MusicVolume = GetConVar("nombat.volume"):GetFloat()
		GetConVar("nombat.volume"):SetFloat(0)
	end
end
function ENT:StopTime()
	if !GetConVar("gstands_can_time_stop"):GetBool() then
		self:Remove()
		return true
	end
	RunConsoleCommand( "phys_timescale", "0" )				
	RunConsoleCommand("ai_disabled", 1)
	for k,v in ipairs(ents.GetAll()) do
		if v:GetClass() == "hg_barrier" then
			continue
		end
		if v:GetClass() == "env_spritetrail" then
			local vals = v:GetKeyValues()
			v.LifeStore = vals["lifetime"]
			v:SetKeyValue("lifetime", "100" )
		end
		if !v:IsPlayer() then
			v.iMoveType = 0
			v.bPrimaryState = false
			if !v:IsNPC() and v:GetClass() != "hg_barrier" and v != self.Owner and v != self.Stand and v:GetClass() != "stand" and v:GetClass() != "stand_useable" and v:GetClass() != "death" and v != Dreamland and (IsValid(Dreamland) and v != Dreamland.DreamlandProp) then
				v:NextThink(CurTime() + 1000)
				
			end
			
			self.OldTSMoveTypeWO[v:EntIndex()] = self.OldTSMoveTypeWO[v:EntIndex()] or v:GetMoveType()
			if v:GetPhysicsObject():IsValid() and v:GetPhysicsObject():IsMotionEnabled() then
				v.GSTSOriginalVelocity = v.GSTSOriginalVelocity or v:GetPhysicsObject():GetVelocity()
				v.OldGrav = v:GetPhysicsObject():IsGravityEnabled()
				v.OldSlep = v:GetPhysicsObject():IsAsleep()
				v:GetPhysicsObject():EnableGravity(false)
				v.OldMotionState = v.OldMotionState or true
				v:SetMoveType(MOVETYPE_NONE)
				v:NextThink(CurTime() + 1000)
				elseif !v:GetPhysicsObject():IsValid() and v:GetClass() != "stand" then
				v.GSTSOriginalVelocity = v.GSTSOriginalVelocity or v:GetVelocity()
				v:SetGravity(0)
				v:SetMoveType(MOVETYPE_NONE)
				v:NextThink(CurTime() + 1000)
			end
			v.GSTSOriginalVelocity = v:GetAbsVelocity()
			v:SetAbsVelocity(Vector(0,0,0))
			if v.IsDoomNPC then
			end
			if string.StartWith(v:GetClass(), "doom_") then
				v:SetMoveType(MOVETYPE_NONE )
			end
			if v:IsNPC() and v:GetNPCState() != NPC_STATE_DEAD then
				v.BlindFire_activated = 0
				v.ForceWeaponFire_activated = 0
				v.BlindFire_NextT = CurTime() + 1000
				v:SetEnemy(nil)
				v:SetNPCState(NPC_STATE_NONE)
				v:ClearSchedule()
				v:ClearGoal()
				v:StopMoving()
				self.OldTSMoveTypeWO[v:EntIndex()] = self.OldTSMoveTypeWO[v:EntIndex()] or v:GetMoveType()
				v:SetMoveType(MOVETYPE_NONE )
				v:SetGravity(0)
				if v:GetPhysicsObject():IsValid() then
					v:GetPhysicsObject():EnableGravity(false)
					v:GetPhysicsObject():EnableMotion(false)
				end
				if v != self.Owner and v != self.Stand then
					v:SetPlaybackRate(0)
				end
				v:Fire("GagEnable")
				
				v:NextThink(CurTime() + 1000)
				
				v:SetCondition(67 )
				
				if CLIENT then
					v:NextClientThink(CurTime())
				end
			end
			
			if v.Base == "base_nextbot" then
				v:NextThink(CurTime() + 1000)
			end
			v.GSTSStopped = true
		end
	end
	for k,v in ipairs(player.GetAll()) do
		v.seq = v:GetSequence()
		for i = 0, v:GetNumPoseParameters() - 1 do
			local sPose = v:GetPoseParameterName( i )
			v.GSTSPoses = {}
			v.GSTSPoses[i] = v:GetPoseParameter( sPose )
		end
		if (v:IsPlayer() and !v:IsConnected()) then
			continue
		end
		
		if v != nil and v:GetActiveWeapon():IsValid() and v:GetMoveType() != nil then 
			--For everyone except ourselves
			 
			if !v:Alive() then
				v:Lock()
			end
			if v.PlayerMoveType != nil then
				v.PlayerMoveType = v:GetMoveType()
				v:SetMoveType( MOVETYPE_NONE )
				
				if v == self.Owner then
					v:SetMoveType( MOVETYPE_FLY )
				end
			end
			
			if !(table.HasValue(self.StoppedUsers, v)) then
				v:Lock()
				v.GSTSStopped = true
				v:RemoveFlags(FL_GODMODE)
				if SERVER then
					v:SetDSP(133, false)
				end
				
			end			
		end
	end
	-- for k,v in pairs(GlobalTimerTable) do
		-- if timer.Exists(v) then
		 -- if !string.StartWith(v, "zawarudo") and !string.StartWith(v, "stopMax") and !string.StartWith(v, "sutahprachina") then
			-- timer.Pause(v)
		-- end
		-- end
	-- end
end
function ENT:StartTime()
	
	RunConsoleCommand( "phys_timescale", "1" )				
	RunConsoleCommand("ai_disabled", 0)
	
	
	for k,v in ipairs(player.GetAll()) do
		if (v:IsPlayer() and !v:IsConnected()) then
			continue
		end
		hook.Remove("CalcMainActivity", "StopPlayerAnims"..v:GetName())
		
		if v != nil and v:GetMoveType() != nil then 
			if v.PlayerMoveType != nil then
				if v.PlayerMoveType != nil then
					local vel = v:GetVelocity()
					v:SetMoveType( v.PlayerMoveType )
					v:SetVelocity(vel)
				end
			end
		end
		v.WasFrozen = false
		v:UnLock()
		if(SERVER) then
			v:SetDSP(0, false)
		end
		if IsValid(v:GetActiveWeapon()) and v:GetActiveWeapon():GetClass() == "gstands_hermit_purple" then
			v:GetActiveWeapon():EndAttack()
		end
	end
	local damages = self.damages
	timer.Simple(0.2, function()
		for k,v in pairs(damages) do
			for i,j in pairs(damages[k]) do
				local damag = DamageInfo()
				if j[1] then
					damag:SetAmmoType(j[1])
				end
				if j[2] and IsValid(j[2]) then
					damag:SetAttacker(j[2])
				end
				if j[4] then
					damag:SetDamage(j[4])
				end
				if j[5] then
					damag:SetDamageBonus(j[5])
				end
				if j[6] then
					damag:SetDamageCustom(j[6])
				end
				if j[7] then
					damag:SetDamageForce(j[7])
				end
				if j[8] then
					damag:SetDamagePosition(j[8])
				end
				if j[9] then
					damag:SetDamageType(j[9])
				end
				if j[10] and IsValid(j[10]) then
					damag:SetInflictor(j[10])
				end
				if j[11] then
					damag:SetMaxDamage(j[11])
				end
				if j[12] then
					damag:SetReportedPosition(j[12])
				end
				k.TSDamage = true
				if IsValid(k) then
					if k:IsPlayer() and k:Alive() then
						k:TakeDamageInfo(damag)
						elseif !k:IsPlayer() then
						k:TakeDamageInfo(damag)
					end
					
				end
				k.TSDamage = false
			end
		end
	end)
	for k,v in ipairs(ents.GetAll()) do
		if v:GetClass() == "env_spritetrail" then
			print(v.LifeStore)
			v:SetKeyValue("lifetime", tostring(v.LifeStore) or tostring(1 ))
			v:Spawn()
			v:Activate()
		end
		if !v:IsPlayer() then
			if !v:IsNPC() and v != self.Owner and !v:GetClass() == "hg_barrier" and v != self.Stand and v:GetClass() != "stand" then
				v:NextThink(CurTime())
				
			end
			
			v.GSTSFactor = nil
			if self.OldTSMoveTypeWO[v:EntIndex()] then
				v:SetMoveType(self.OldTSMoveTypeWO[v:EntIndex()])
				v:NextThink(CurTime())
			end
			if v:GetClass() == "bearing" then
				v.lifetime = CurTime() + 1
			end
			if v.OldMotionState then
				--v:SetMoveType(MOVETYPE_VPHYSICS)
				
				--v:GetPhysicsObject():SetVelocity(v.GSTSOriginalVelocity)
				--v:GetPhysicsObject():SetPos(v:GetPos(), true)
				if IsValid(v:GetPhysicsObject()) then
					v:GetPhysicsObject():EnableGravity(v.OldGrav or true)
					v:GetPhysicsObject():EnableMotion(v.OldMotion or true)
					if !v.OldSlep then
						v:GetPhysicsObject():Wake()
					end
				end
				if v:GetClass() == "physical_bullet" then
					v:Spawn()
				end
				v:NextThink(CurTime())
				else
				if IsValid(v:GetPhysicsObject()) then
					v:GetPhysicsObject():EnableGravity(true)
					v:GetPhysicsObject():EnableMotion(true)
					if !v.OldSlep then
						v:GetPhysicsObject():Wake()
					end
				end
				if v:GetClass() == "physical_bullet" then
					v:Spawn()
				end
				v:NextThink(CurTime())
			end
			v.GSTSStopped = false
			v.iMoveType = 4
			v.bPrimaryState = true
			if v.IsDoomNPC then
				v:SetMoveType(4)
			end
			if string.StartWith(v:GetClass(), "doom_")  then
				v:SetMoveType(4)
			end
			if v:IsNPC() and v:GetNPCState() != NPC_STATE_DEAD then
				
				v:SetNPCState(NPC_STATE_IDLE)
				v:SetPlaybackRate(1)
				if self.OldTSMoveTypeWO[v:EntIndex()] then
					v:SetMoveType(self.OldTSMoveTypeWO[v:EntIndex()] )
					else
					v:SetMoveType(MOVETYPE_WALK)
				end
				v:SetGravity(1)
				if v:GetPhysicsObject():IsValid() then
					v:GetPhysicsObject():EnableGravity(true)
					v:GetPhysicsObject():EnableMotion(true)
				end
				v:NextThink(CurTime() + 0.1)
				timer.Simple(0.2, function() if v:IsValid() and v:GetNPCState() != NPC_STATE_DEAD then v:SetCondition( 68 ) end end)
				v:Fire("GagDisable")
			end
			if v.Base == "base_nextbot" then
				v:NextThink(CurTime() + 0.1)
			end
		end
	end
	for k,v in ipairs(player.GetAll()) do
		v.seq = v:GetSequence()
		if (v:IsPlayer() and !v:IsConnected()) then
			continue
		end
		if v != nil and v:GetMoveType() != nil then 
			if v.PlayerMoveType != nil then
				v:SetMoveType( v.PlayerMoveType )
				v.PlayerMoveType = nil
			end
		end
		if v == self.Owner then
			v:SetDSP(0)
		end
		if v != self.Owner then
			v:UnLock()
			v.GSTSStopped = false
			v:Freeze(false)
			if(SERVER) then
				-- net.Start("world.UnBlind")
				-- net.Send(v)
				v:SetDSP(0, false)
				timer.Remove("stopWorld1"..self.Owner:GetName())
				timer.Remove("stopWorld2"..self.Owner:GetName())
				-- net.Start("world.Exit")
				-- net.Broadcast()
			end
		end
	end
	-- for k,v in pairs(GlobalTimerTable) do
		-- if timer.Exists(v) then
			-- timer.UnPause(v)
		-- end
	-- end
end	
/*---------------------------------------------------------
Name: ENT:Think()
---------------------------------------------------------*/

local ClassTable = {
	["physical_bullet"] = 1.27 * 0.8 or 1.3,
	["crossbow_bolt"] = 3 or 1.3
}
local ClassTableX = {
	["physical_bullet"] = 5750,
	["crossbow_bolt"] = 5750,
	["bearing"] = 5750,
	["m9k_m202_rocket"] = 15750
}

function ENT:Think()
	if !GetConVar("gstands_can_time_stop"):GetBool() then
		self:Remove()
		return true
	end
	if CLIENT then
		self:SetPos(EyePos() + EyeAngles():Forward() * 2)
		self:SetupBones()
		self.StoppedUsers = self.StoppedUsers or {}
		local str = string.Split(self:GetNWString("StoppedUsers"), " ")
		local stp = {}
		for k,v in pairs(str) do
			if tonumber(v) then
				local a = tonumber(v)
				table.insert(stp, Entity(a))
			end
		end
		self.StoppedUsers = stp
	end
	
	for k,v in pairs(player.GetAll()) do
		hook.Remove("CalcMainActivity", "StopPlayerAnims"..v:GetName())
		hook.Remove("UpdateAnimation", "StopPlayerAnims"..v:GetName())
		if !table.HasValue(self.StoppedUsers, v) then
			v.seq = v.seq or v:GetSequence()
			v.Cycle = v:GetCycle()
			hook.Add("CalcMainActivity", "StopPlayerAnims"..v:GetName(), function(ply, vel)
				if IsValid(ply) and IsValid(v) and ply == v then
					return 0, v.seq
				end
			end)	
			hook.Add("UpdateAnimation", "StopPlayerAnims"..v:GetName(), function(ply, vel)
				if ply == v then
					for i = 0, v:GetNumPoseParameters() - 1 do
						if SERVER then
						local sPose = v:GetPoseParameterName( i )
						v.GSTSPoses = {}
						v.GSTSPoses[i] = v:GetPoseParameter( sPose )
						v:SetPoseParameter( sPose, v.GSTSPoses[i] )
						else
							local flMin, flMax = v:GetPoseParameterRange( i )
						local sPose = v:GetPoseParameterName( i )
						v.GSTSPoses = {}
						v.GSTSPoses[i] = v:GetPoseParameter( sPose )
						v:SetPoseParameter( sPose, math.Remap( v.GSTSPoses[i], 0, 1, flMin, flMax ))
						end
					end
				end
			end)		
			v:SetPlaybackRate(0)
			v:SetCycle(0)
			if CLIENT then
				v:SetAnimTime( 0 )
			end
			-- v:AnimResetGestureSlot( 0 ) 
			-- v:AnimResetGestureSlot( 1 ) 
			-- v:AnimResetGestureSlot( 2 ) 
			-- v:AnimResetGestureSlot( 3 ) 
			-- v:AnimResetGestureSlot( 4 ) 
			-- v:AnimResetGestureSlot( 5 ) 
			-- v:AnimResetGestureSlot( 6 ) 
			-- v:AnimSetGestureWeight( 0, 0 ) 
			-- v:AnimSetGestureWeight( 1, 0 ) 
			-- v:AnimSetGestureWeight( 2, 0 ) 
			-- v:AnimSetGestureWeight( 3, 0 ) 
			-- v:AnimSetGestureWeight( 4, 0 ) 
			-- v:AnimSetGestureWeight( 5, 0 ) 
			-- v:AnimSetGestureWeight( 6, 0 ) 
			if SERVER then
				v:SetLayerPlaybackRate(0, 0)
				v:SetLayerPlaybackRate(1, 0)
				v:SetLayerPlaybackRate(2, 0)
				v:SetLayerPlaybackRate(3, 0)
				v:SetLayerPlaybackRate(4, 0)
				v:SetLayerPlaybackRate(5, 0)
				v:SetLayerPlaybackRate(6, 0)
				v:SetLayerPlaybackRate(7, 0)
				v:SetLayerPlaybackRate(8, 0)
				v:SetLayerPlaybackRate(9, 0)
				v:SetLayerPlaybackRate(10, 0)
				v:SetLayerPlaybackRate(11, 0)
				v:SetLayerPlaybackRate(12, 0)
				v:SetLayerPlaybackRate(13, 0)
				v:SetLayerPlaybackRate(14, 0)
				v:SetLayerPlaybackRate(15, 0)
				for i = 0, 15 do
					v.Cycles = v.Cycles or {}
					v.Cycles[i] = v.Cycles[i] or v:GetLayerCycle(i)
					v:SetLayerCycle(i, v.Cycles[i])
				end
			end
		end
	end
	
	if SERVER then
		
		local res = {}
		local hash = {}
		for _,v in ipairs(self.StoppedUsers) do
			if (not hash[v]) then
				res[#res+1] = v
				hash[v] = true
			end
			
		end
		self.StoppedUsers = res
		local send = ""
		for k,v in pairs(self.StoppedUsers) do
			send = send..v:EntIndex().." "
		end
		self:SetNWString("StoppedUsers", send)
		for k,v in pairs(self.StoppedUsers) do
			if self.damages[v] then
				for i,j in pairs(self.damages[v]) do
					local damag = DamageInfo()
					if j[1] then
						damag:SetAmmoType(j[1])
					end
					if j[2] and IsValid(j[2]) then
						damag:SetAttacker(j[2])
					end
					if j[4] then
						damag:SetDamage(j[4])
					end
					if j[5] then
						damag:SetDamageBonus(j[5])
					end
					if j[6] then
						damag:SetDamageCustom(j[6])
					end
					if j[7] then
						damag:SetDamageForce(j[7])
					end
					if j[8] then
						damag:SetDamagePosition(j[8])
					end
					if j[9] then
						damag:SetDamageType(j[9])
					end
					if j[10] and IsValid(j[10]) then
						damag:SetInflictor(j[10])
					end
					if j[11] then
						damag:SetMaxDamage(j[11])
					end
					if j[12] then
						damag:SetReportedPosition(j[12])
					end
					v.TSDamage = true
					if IsValid(v) then
						if v:IsPlayer() and v:Alive() then
							v:TakeDamageInfo(damag)
							elseif !v:IsPlayer() then
							v:TakeDamageInfo(damag)
						end
					end
					v.TSDamage = false
				end
				self.damages[v] = nil
			end
		end
		
		
		if #self.StoppedUsers < 1 then
			self:Remove()
		end
		for k,v in ipairs(player.GetAll()) do
			--For everyone except ourselves
			if !v:Alive() then
				v:Lock()
			end
			if v.PlayerMoveType != nil then
				v.PlayerMoveType = v:GetMoveType()
				v:SetMoveType( MOVETYPE_NONE )
				
				if v == self.Owner then
					v:SetMoveType( MOVETYPE_FLY )
				end
			end
			
			if !(table.HasValue(self.StoppedUsers, v)) then
				v:Lock()
				v.GSTSStopped = true
				v:RemoveFlags(FL_GODMODE)
				if SERVER then
					v:SetDSP(133, false)
				end
				else
				v:UnLock()			
				v:SetDSP(2)
			end
			
		end
		for k,v in ipairs(ents.GetAll()) do
			if v:GetClass() == "hg_barrier" then
				continue
			end
			if v == self or (v:IsPlayer() and !v:IsConnected()) then
				continue
			end
			if v:GetClass() == "env_spritetrail" then
				local vals = v:GetKeyValues()
				v.LifeStore = v.LifeStore or vals["lifetime"]
				v:SetKeyValue("lifetime", "100" )
			end
			if !v:IsPlayer() and !v.GSTSStopped then
				
				v.iMoveType = 0
				v.bPrimaryState = false
				self.OldTSMoveTypeWO[v:EntIndex()] = self.OldTSMoveTypeWO[v:EntIndex()] or v:GetMoveType()
				if !v:IsNPC() and v:GetClass() != "hg_barrier" and v != self.Owner and v != self.Stand and v:GetClass() != "stand" and v:GetClass() != "stand_useable" and v:GetClass() != "death" and v:GetClass() != "bearing" and v != Dreamland and (IsValid(Dreamland) and v != Dreamland.DreamlandProp) then
					v:NextThink(CurTime() + 1000)
				end
				if !v.GSTSFactor then
					v.GSTSFactor = 1
					v.GSTSFactorX = ClassTableX[v:GetClass()] or 550
					if v:GetMoveType() == MOVETYPE_NONE then
						v.GSTSFactorX = 1.27 * 0.8
					end
					else
					if v:GetPhysicsObject():IsValid() then	
						if v:GetMoveType() == MOVETYPE_NONE then
							v.GSTSFactor = v.GSTSFactor * 1.04
							else
							v.GSTSFactor = v.GSTSFactor * (ClassTable[v:GetClass()] or 1.01)
							v.GSTSFactorX = ClassTableX[v:GetClass()] or 550
						end
						else
						if v:GetMoveType() == MOVETYPE_NONE then
							v.GSTSFactor = v.GSTSFactor * 1.07
							
							else
							v.GSTSFactor = v.GSTSFactor * (ClassTable[v:GetClass()] or 1.01)
						end
					end
				end
				if v:GetPhysicsObject():IsValid() then
					v.OldGrav = v.OldGrav or v:GetPhysicsObject():IsGravityEnabled()
					v.OldSlep = v.OldSlep or false
					if v:GetMoveType() == MOVETYPE_NONE and v.GSTSFactor < 1.1 then
						local aim = nil
						if v.Owner and v.Owner.GetAimVector then
							aim = v.Owner:GetAimVector() * 5
						end
						v.OGVel = v.OGVel or aim or v:GetForward()
						if IsValid(v:GetPhysicsObject()) then
							v:SetVelocity(v.OGVel * v.GSTSOriginalVelocity:Length())
						end
						v.GSTSFactorX = v.GSTSFactorX or 1
						local trace = util.TraceLine( {
							start = v:GetPos(),
							endpos = v:GetPos() + ((v.OGVel/(v.GSTSFactorX * (1.27 * 0.8)))),
							filter = function(ent) if v:GetClass() == ent:GetClass() or ent == v.Owner or ent:GetClass() == "stand" then return false else return true end end,
							mask = MASK_SHOT
						} )
						if trace.Hit then
							v:SetPos(LerpVector(0.1, v:GetPos(), trace.HitPos),true)
						end
						if !trace.Hit then	
							v:SetPos(v:GetPos() + (v.OGVel/(v.GSTSFactorX * 0.8)) ,true)
						end
						
						else
						if v.GSTSFactor < 2 then
							v.OGVel = v.OGVel or v:GetPhysicsObject():GetVelocity()
							v.GSTSFactorX = v.GSTSFactorX or 0
							v.GSTSFactor = v.GSTSFactor or 1
							local trace = util.TraceLine( {
								start = v:GetPos(),
								endpos = v:GetPos() + ((v.OGVel/(v.GSTSFactorX * v.GSTSFactor))),
								filter = function(ent) if v:GetClass() == ent:GetClass() or ent == v.Owner then return false else return true end end,
								mask = MASK_SHOT
							} )
							if trace.Hit then
								v:SetPos(LerpVector(0.3, v:GetPos(), trace.HitPos),true)
							end
							if !trace.Hit then	
								v:SetPos(v:GetPos() + (v.OGVel/(v.GSTSFactorX * v.GSTSFactor)) ,true)
							end
							
						end
						v.OldMotionState = v.OldMotionState or true
						v:NextThink(CurTime() + 1000)
					end
					elseif !v:GetPhysicsObject():IsValid() and v:GetClass() != "stand" then
					
					v.GSTSOriginalVelocity = v.GSTSOriginalVelocity or v:GetVelocity()
					if v.GSTSOriginalVelocity == Vector(0,0,0) then
						v.GSTSOriginalVelocity = v:GetForward() 
					end
					v.GSTSFactorX = v.GSTSFactorX or 0
					v.GSTSFactor = v.GSTSFactor or 0
					local trace = util.TraceLine( {
						start = v:GetPos(),
						endpos = v:GetPos() + ((v.GSTSOriginalVelocity/(v.GSTSFactorX * v.GSTSFactor))),
						filter = function(ent) if v:GetClass() == ent:GetClass() or ent == v.Owner then return false else return true end end,
						mask = MASK_SHOT
					} )
					if trace.Hit then
						v:SetPos(LerpVector(0.01, v:GetPos(), trace.HitPos),true)
					end
					if !trace.Hit then	
						v:SetPos(v:GetPos() + (v.GSTSOriginalVelocity/(v.GSTSFactorX * v.GSTSFactor)) ,true)
					end
					v:SetGravity(0)
					if v.GSTSFactor > 2 then
						v.GSTSStopped = true
						v:SetMoveType(MOVETYPE_NONE)
						v:NextThink(CurTime() + 1000)
					end
				end	
				if string.StartWith(v:GetClass(), "doom_") then
					v:SetMoveType(MOVETYPE_NONE )
				end
				
				if v:IsNPC() and v:GetNPCState() != NPC_STATE_DEAD then
					v.BlindFire_activated = 0
					v.ForceWeaponFire_activated = 0
					v.BlindFire_NextT = CurTime() + 1000
					
					v:SetNPCState(NPC_STATE_NONE)
					v:ClearSchedule()
					v:ClearGoal()
					v:StopMoving()
					self.OldTSMoveTypeWO[v:EntIndex()] = self.OldTSMoveTypeWO[v:EntIndex()] or v:GetMoveType()
					v:SetMoveType(MOVETYPE_NONE )
					v:SetGravity(0)
					if v:GetPhysicsObject():IsValid() then
						v:GetPhysicsObject():EnableGravity(false)
						v:GetPhysicsObject():EnableMotion(false)
					end
					if v != self.Owner and v != self.Stand then
						v:SetPlaybackRate(0)
					end
					v:Fire("GagEnable")
					
					v:NextThink(CurTime() + 1000)
					v:SetCondition(67 )
					
				end
				
				if v.Base == "base_nextbot" then
					v:NextThink(CurTime() + 1000)
				end
			end
		end
		self:NextThink(CurTime())
		return true
	end
end
function ENT:OnRemove()
	if CLIENT then
		hook.Remove( "PostDrawTranslucentRenderables", "StopTimeColour")
		hook.Remove( "PostDrawHUD", "StopTime")
		hook.Remove( "CalcView", "KillAudioVeryWell")
		hook.Remove("RenderScreenspaceEffects", "DrawOrb")
		hook.Remove("CreateMove", "gstandstimestopshare")
		if NOMBAT then
			GetConVar("nombat.volume"):SetFloat(self.NOMBAT_MusicVolume or 50)
		end
	end
	for k,v in pairs(player.GetAll()) do
		v.seq = nil
		v.GSTSPoses = nil
		v.Cycles = nil
		hook.Remove("CalcMainActivity", "StopPlayerAnims"..v:GetName())
		hook.Remove("UpdateAnimation", "StopPlayerAnims"..v:GetName())
		hook.Remove("CalcMainActivity", "StopPlayerAnims"..v:GetName())
		hook.Remove("UpdateAnimation", "StopPlayerAnims"..v:GetName())
		if IsValid(v.GSTSDummyEnt) then
		v.GSTSDummyEnt:Remove()
		end
	end
	if SERVER then
		hook.Remove("EntityTakeDamage", "TimeStopBuildup")
		self:StartTime()
	end
end
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
if CLIENT then
	/*---------------------------------------------------------
	Name: ENT:Draw()
	---------------------------------------------------------*/
	function ENT:Draw()
	end
	local tab = {
		["$pp_colour_addr"]		 = 0/255,
		["$pp_colour_addg"]		 = 0/255,
		["$pp_colour_addb"]		 = 0/255,
		["$pp_colour_brightness"]	 = 0.3,
		["$pp_colour_contrast"]	 = 1,
		["$pp_colour_colour"]		 = -5,
		["$pp_colour_mulr"]		 = -5,
		["$pp_colour_mulg"]		 = -5,
		["$pp_colour_mulb"]		 = -5,
	}
	local StartTime = CurTime()
	-- function ENT:Draw()
	-- local tabL = {
	
	-- [ "$pp_colour_addr" ] =  0,
	-- [ "$pp_colour_addg" ] =  0,
	-- [ "$pp_colour_addb" ] = 0,
	-- [ "$pp_colour_brightness" ] = 0,
	-- [ "$pp_colour_contrast" ] = 0.4,
	-- [ "$pp_colour_colour" ] = 0.01,
	-- [ "$pp_colour_mulr" ] = 0.5,
	-- [ "$pp_colour_mulg" ] = 0.5,
	-- [ "$pp_colour_mulb" ] = 0.5
	-- }
	-- tab = tabL
	-- DrawColorModify( tabL )
	-- end
	function ENT:DrawTranslucent()
		self:SetPos(EyePos() + EyeAngles():Forward() * 55)
		self:SetupBones()
		render.ClearStencil()
		
		render.SetStencilEnable(true)
		render.SetStencilWriteMask(0xff )
		render.SetStencilTestMask(0xff )
		render.SetStencilReferenceValue(0xff )
		render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
		render.SetStencilPassOperation(STENCILOPERATION_KEEP)
		local w,h = ScrW(),ScrH()
		
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
		render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
		self:SetMaterial("models/shadertest/shader4")
		if IsValid(self.Owner) and self.Owner:GetActiveWeapon().GetStand and IsValid(self.Owner:GetActiveWeapon():GetStand()) then
			self:SetPos(self.Owner:GetActiveWeapon():GetStand():GetAttachment(1)["Pos"])
			else
			self:SetPos(self.Owner:EyePos())
		end
		self:SetupBones()
		
		self:DrawModel()
		local clr = HSVToColor((CurTime() * 255) % 360, 1, 1)
		local tabI = {
			[ "$pp_colour_addr" ] = clr.r/4096,
			[ "$pp_colour_addg" ] = clr.b/4096,
			[ "$pp_colour_addb" ] = clr.g/4096,
			["$pp_colour_brightness"]	 = 0,
			["$pp_colour_contrast"]	 = 1,
			["$pp_colour_colour"]		 = -2,
			["$pp_colour_mulr"]		 = -1,
			["$pp_colour_mulg"]		 = -1,
			["$pp_colour_mulb"]		 = -1,
		}
		--tab = tabI
		render.SetBlend(1)
		DrawColorModify( tabI )
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
		
		
		render.SetStencilEnable(false)
	end
end																											