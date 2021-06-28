ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName= "Stand Player Base"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "To stand"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false

--WARNING:
--This file allows stands to have player functions. Last time this was tested,
--it was for weapon support for stands. However, due to most weapons using IsPlayer or IsNPC to work,
--and neither of those functions being overrideable, it never actually got to do much. Release at your own
--peril.

--Player Aliases for Weapon Support

if CLIENT then
	function ENT:AddPlayerOption( aa, aaa, aaaa, aaaaa )
		self.Owner:AddPlayerOption(aa,aaa,aaaa,aaaaa)
	end
	function ENT:GetFriendStatus()
		return self.Owner:GetFriendStatus()
	end
end	
local META = FindMetaTable("Player")
for k,v in pairs(META) do
	if isfunction(v) and !ENT[k] then
		ENT[k] = function(self,arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12) return self.Owner[k](self.Owner, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12) end
	end
end
--Shared
function ENT:Give(wep)
	if SERVER then
	self:SetActiveWeapon(ents.Create(wep))
	end
	self.HeldWeapon = self:GetActiveWeapon()
	self.HeldWeapon:SetOwner(self)
	local att = "anim_attachment_rh"
	if (self.Model == "models/player/slc/slc.mdl" or self.Model == "models/player/slc/slc_un.mdl") and self.HeldWeapon:GetClass() == "gstands_anubis" then
	att = "anim_attachment_lh"
	end
	local tab = self:GetAttachment(self:LookupAttachment(att))
	local pos = tab.Pos
	local ang = tab.Ang
	
	self.HeldWeapon:SetPos(pos)
	self.HeldWeapon:SetAngles(ang)
		self.HeldWeapon:SetParent(self, self:LookupAttachment("att"))

	self.HeldWeapon:AddEffects( EF_BONEMERGE || EF_BONEMERGE_FASTCULL || EF_PARENT_ANIMATES)
	self.HeldWeapon:Spawn()
	self.HeldWeapon:Activate()
	if SERVER and self.HeldWeapon.Equip then
		self.HeldWeapon:Equip(self)
		self.HeldWeapon:SetTrigger(false)
		self.HeldWeapon:Deploy()
	else
		self.HeldWeapon:SetOwner(self.Owner)
	end
	self.HeldWeapon:SetNotSolid(true)
	self.HeldWeapon:SetSolid(SOLID_NONE)
	print(self.HeldWeapon)
	timer.Simple(1, function() print(self.HeldWeapon) end)
end

function ENT:AddCleanup(aa,aaa)
		self.Owner:AddCleanup(aa,aaa)
end
function ENT:AddCount(aa,aaa)
		self.Owner:AddCount(aa,aaa)
end

function ENT:GetAmmoCount(aa)
	return self.Owner:GetAmmoCount(aa)
end
function ENT:GetAimVector()
	if !head then head = false end
	if self:GetInDoDoDo() or head or self.Blocking then
		return self:GetForward()
		else
		return self.Owner:GetAimVector()
	end
end
function ENT:ViewPunch()
		return
end
function ENT:StripWeapon()
		return
		--self:SetActiveWeapon(NULL)
end
function ENT:KeyPressed(aa)
		return self.Owner:KeyPressed(aa)
end
function ENT:KeyReleased(aa)
		return self.Owner:KeyReleased(aa)
end
function ENT:KeyDown(aa)
		return self.Owner:KeyDown(aa)
end
function ENT:RemoveAmmo(aa, aaa)
		return self.Owner:RemoveAmmo(aa,aaa)
end
function ENT:AddVCDSequenceToGestureSlot( slot, sequenceId, cycle, autokill ) 
		self.Owner:AddVCDSequenceToGestureSlot(slot, sequenceId, cycle, autokill)
end
function ENT:Alive()
	return self.Owner:Alive()
end
function ENT:AllowFlashlight(aa)
	self.Owner:AllowFlashlight(aa)
end
function ENT:AnimResetGestureSlot( slot )
	self.Owner:AnimResetGestureSlot(slot)
end
function ENT:AnimRestartGesture( slot, act, autokill )
	self.Owner:AnimRestartGesture( slot, act, autokill )
end
function ENT:AnimRestartMainSequence( )
	self.Owner:AnimRestartMainSequence( )
end
function ENT:AnimSetGestureSequence( slot, id )
	self.Owner:AnimSetGestureSequence(slot, id )
end
function ENT:AnimSetGestureWeight( slot, wgt )
	self.Owner:AnimSetGestureWeight(slot, wgt )
end
function ENT:Armor( )
	return self.Owner:Armor()
end
function ENT:CanUseFlashlight()
	return self.Owner:CanUseFlashlight()
end
function ENT:ChatPrint(msg)
		self.Owner:ChatPrint(msg)
end
function ENT:CheckLimit(limtype)
	return self.Owner:CheckLimit(limtype)
end
function ENT:ConCommand(cmd)
		self.Owner:ConCommand(cmd)
end
function ENT:Crouching()
	return self.Owner:Crouching()
end
function ENT:Deaths()
		return self.Owner:Deaths()
end
function ENT:DoAnimationEvent(data)
		self.Owner:DoAnimationEvent(data)
end
function ENT:DoAttackEvent()
		self.Owner:DoAttackEvent()
end
function ENT:DoCustomAnimEvent(event, data)
		self.Owner:DoCustomAnimEvent(event, data)
end
function ENT:DoReloadEvent()
		self.Owner:DoReloadEvent()
end
function ENT:DoSecondaryAttack()
		self.Owner:DoSecondaryAttack()
end
function ENT:DrawViewModel()
return 
end
function ENT:Frags()
	return self.Owner:Frags()
end
	function ENT:GetAllowFullRotation()
	return self.Owner:GetAllowFullRotation()
end
function ENT:GetAllowWeaponsInVehicle()
	return self.Owner:GetAllowWeaponsInVehicle()
end
function ENT:GetAmmoCount(ammo)
	return self.Owner:GetAmmoCount(ammo)
end
function ENT:GetAvoidPlayers()
	return self.Owner:GetAvoidPlayers()
end
function ENT:GetCanWalk()
	return self.Owner:GetCanWalk()
end
function ENT:GetCanZoom()
	return self.Owner:GetCanZoom()
end
function ENT:GetClassID()
	return self.Owner:GetClassID()
end
function ENT:GetCount(typ, min)
		return self.Owner:GetCount()
end
function ENT:GetCrouchedWalkSpeed()
		return self.Owner:GetCrouchedWalkSpeed()
end
function ENT:GetCurrentCommand()
		return self.Owner:GetCurrentCommand()
end
function ENT:GetCurrentViewOffset()
	return self.Owner:GetCurrentViewOffset()
end
function ENT:GetDrivingEntity()
	return self.Owner:GetDrivingEntity()
end
function ENT:GetDrivingMode()
	return self.Owner:GetDrivingMode()
end
function ENT:GetDuckSpeed()
	return self.Owner:GetDuckSpeed()
end
function ENT:GetEyeTrace()
	if CLIENT then
		local curtime = CurTime()
		if ( self.LastPlayerTrace == curtime ) then
			return self.PlayerTrace
		end
		self.LastPlayerTrace = curtime
	end
	
	local tr = util.TraceLine( util.GetPlayerTrace( self ) )
	self.PlayerTrace = tr
	return tr
end
function ENT:GetEyeTraceNoCursor()
	if CLIENT then
		local curtime = CurTime()
		if ( self.LastPlayerTrace == curtime ) then
			return self.PlayerTrace
		end
		self.LastPlayerTrace = curtime
	end
	
	local tr = util.TraceLine( util.GetPlayerTrace( self ) )
	self.PlayerTrace = tr
	return tr
end
function ENT:GetFOV()
	return self.Owner:GetFOV()
end
function ENT:GetHands()
	return NULL
end
function ENT:GetHoveredWidget()
	return self.Owner:GetHoveredWidget()
end
function ENT:GetHull()
	return self.Owner:GetHull()
end
function ENT:GetHullDuck()
	return self.Owner:GetHullDuck()
end
function ENT:GetJumpPower()
	return self.Owner:GetJumpPower()
end
function ENT:GetLaggedMovementValue()
	return self.Owner:GetLaggedMovementValue()
end
function ENT:GetMaxSpeed()
	return self.Owner:GetMaxSpeed()
end
function ENT:GetName()
		return self.Owner:GetName()
end
function ENT:GetNoCollideWithTeamMates()
		return self.Owner:GetNoCollideWithTeamMates()
end
function ENT:GetObserverMode()
		return self.Owner:GetObserverMode()
end
function ENT:GetObserverTarget()
		return self.Owner:GetObserverTarget()
end
function ENT:GetPData(key, def)
		return self.Owner:GetPData(key, def)
end
function ENT:GetPlayerColor()
		return self.Owner:GetPlayerColor()
end
function ENT:GetPlayerInfo()
		return self.Owner:GetPlayerInfo()
end
function ENT:GetPressedWidget()
		return self.Owner:GetPressedWidget()
end
function ENT:GetPunchAngle() --DEPRECATED
		return self.Owner:GetPunchAngle()
end
function ENT:GetRenderAngles()
	return self.Owner:GetRenderAngles()
end
function ENT:GetRunSpeed()
		return self.Owner:GetRunSpeed()
end
function ENT:GetShootPos()
		return self:GetEyePos(true)
end
function ENT:GetStepSize()
		return self.Owner:GetStepSize()
end
function ENT:GetTool(m)
		return self.Owner:GetTool(m)
end
function ENT:GetUnDuckSpeed()
		return self.Owner:GetUnDuckSpeed()
end
function ENT:GetUserGroup()
		return self.Owner:GetUserGroup()
end
function ENT:GetVehicle()
	return self.Owner:GetVehicle()
end
function ENT:GetViewEntity()
		return self.Owner:GetViewEntity()
end
function ENT:GetViewModel()
		return self.Owner:GetViewModel()
end
function ENT:GetViewOffset()
		return self.Owner:GetViewOffset()
end
function ENT:GetViewOffsetDucked()
		return self.Owner:GetViewOffsetDucked()
end
function ENT:GetViewPunchAngles()
		return self.Owner:GetViewPunchAngles()
end
function ENT:GetWalkSpeed()
		return self.Owner:GetWalkSpeed()
end
function ENT:GetWeapon(class)
		if self:GetActiveWeapon():GetClass() == class then
			return self:GetActiveWeapon()
		else
			return self.Owner:GetWeapon(class)
		end
	end
if SERVER then
	function ENT:AddDeaths(aa)
		self.Owner:AddDeaths(aa)
	end
	function ENT:AddFrags(aa)
		self.Owner:AddFrags(aa)
	end
	function ENT:AddFrozenPhysicsObject(aa,aaa)
		self.Owner:AddFrozenPhysicsObject(aa,aaa)
	end
	function ENT:AllowImmediateDecalPainting(aa)
		self.Owner:AllowImmediateDecalPainting(aa)
	end
	function ENT:Ban(min, kick)
		self.Owner:Ban(min, kick)
	end
	function ENT:CreateRagdoll()
		self.Owner:CreateRagdoll()
	end
	function ENT:CrosshairDisable()
		self.Owner:CrosshairDisable()
	end
	function ENT:CrosshairEnable()
		self.Owner:CrosshairEnable()
	end
	function ENT:DebugInfo()
		self.Owner:DebugInfo()
	end
	function ENT:DetonateTripmines()
		self.Owner:DetonateTripmines()
	end
	function ENT:DrawWorldModel(aa)
			self.Owner:DrawWorldModel(aa)
	end
	function ENT:DropNamedWeapon(class)
		if self:GetActiveWeapon():GetClass() == class then
			self:SetActiveWeapon(NULL)
		else
			self.Owner:DropNamedWeapon(class)
		end
	end
	function ENT:DropObject()
		self.Owner:DropObject()
	end
	function ENT:DropWeapon(weapon)
		if self:GetActiveWeapon() == weapon then
			self:SetActiveWeapon(NULL)
		else
			self.Owner:DropWeapon(weapon)
		end
	end
	function ENT:EnterVehicle(vhc)
		self.Owner:EnterVehicle(vhc)
	end
	function ENT:EquipSuit()
		self.Owner:EquipSuit()
	end
	function ENT:ExitVehicle()
		self.Owner:ExitVehicle()
	end
	function ENT:Flashlight()
		if self and self:IsValid() then
			if self.Flashlight == self and self.Flashlight:IsValid() then
				self.Flashlight = ents.Create("env_projectedtexture")
				if self.Flashlight != self and self.Flashlight:IsValid() then
					self.Flashlight:SetPos(self.CenterPos)
					self.Flashlight:SetAngles(self:GetAngles())
					self.Flashlight:SetParent(self)
					self.Flashlight:SetKeyValue("lightfov", 75)
					self.Flashlight:SetKeyValue("enableshadows", "true" )
					self:EmitStandSound("items/flashlight1.wav")
				end
				elseif self.Flashlight:IsValid() then
				self.Flashlight:Remove()
				self.Flashlight = self
				self:EmitStandSound("items/flashlight1.wav")
			end
		end
	end
	function ENT:FlashlightIsOn()
		return self.Flashlight != self and self.Flashlight:IsValid()
	end
	function ENT:Freeze(f)
		self.Owner:Freeze(f)
	end

	function ENT:GetInfo(aa)
		return self.Owner:GetInfo(aa)
	end
	function ENT:GetInfoNum(aa, aaa)
		return self.Owner:GetInfoNum(aa,aaa)
	end
	function ENT:GetPreferredCarryAngles(ent)
			return self.Owner:GetPreferredCarryAngles(ent)
	end
	function ENT:GetTimeoutSeconds()
			return self.Owner:GetTimeoutSeconds()
	end
end
