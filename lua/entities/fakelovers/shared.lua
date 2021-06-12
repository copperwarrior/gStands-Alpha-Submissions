ENT.Type = "anim"
ENT.Base = "stand"

ENT.PrintName= "Fake Lovers"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "To stand"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
if !GetConVar("gstands_opaque_stands"):GetBool() then
	ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
	else
	ENT.RenderGroup = RENDERGROUP_OPAQUE
end
ENT.AutomaticFrameAdvance = true
ENT.Animated = true
local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "E3_Phystown.Slicer" )
local Pew = Sound( "hdm.pew" )
function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "ActiveWeapon")
	self:NetworkVar("Entity", 1, "CenterImage")
	self:NetworkVar("Int", 2, "ImageID")
	self:NetworkVar("Angle", 3, "IdealAngles")
	self:NetworkVar("Vector", 4, "IdealPos")
	self:NetworkVar("Float", 5, "Range")
	self:NetworkVar("Entity", 6, "AITarget")
	self:NetworkVar("Bool", 7, "BlockCap")
	self:NetworkVar("Bool", 8, "MarkedToFade")
	self:NetworkVar("Entity", 9, "Image")
	self:NetworkVar("Bool", 10, "InDoDoDo")
	self:NetworkVar("Bool", 11, "InStill")
	self:NetworkVar("Bool", 12, "Frozen")
	self:NetworkVar("Vector", 13, "HEGEndPos")
	self:NetworkVar("Entity", 14, "Trail")
	
end

function ENT:Disable(silent)
	self:Remove()
end

function ENT:Withdraw()
	self:SetMarkedToFade(true)
	timer.Simple(0.3, function()
		if SERVER and IsValid(self) then
			self:Remove()
		end
	end)
end
function ENT:DoImpactEffect()
	return true
end
function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:GetClosest(ply, vec)
	local closestply
	local closestdist
	for k, v in pairs(player.GetAll()) do
		if v != ply then
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
    if closestply then
		return closestply
		else
		return ply
	end
end

function ENT:Initialize()
	if SERVER then
		self:SetLagCompensated(true)
	end
	self:DrawShadow(false)
	self.Wep = self.Owner:GetActiveWeapon()
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.OwnerPos = self.Owner:GetPos()
	self.OwnerCenterPos = self.Owner:WorldSpaceCenter()
	self.CenterPos = self:WorldSpaceCenter()
	self.Pos = self:GetPos()
	self.Forward = self:GetForward()
	self.InStill = self.Owner:KeyDown(IN_USE)
	self.DistToOwner = self.Pos:Distance(self.OwnerPos)
	self.StandId = GetgStandsID(self:GetModel())
	if SERVER then
		self:SetImageID(self.ImageID)
	end
	self:SetSolid( SOLID_OBB )
	self:SetMoveType( MOVETYPE_NOCLIP )
	
	self:SetSolidFlags( FSOLID_NOT_STANDABLE )
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.Model = self:GetModel()
	self:SetRenderMode(RENDERMODE_WORLDGLOW)
	self.OwnerName = self.Owner:GetName()
	self.Color = self:GetColor()
	if SERVER then
		self:SetSkin(self.Owner:GetInfoNum("gstands_standskin_"..self.Wep.ClassName, math.random(0, self:SkinCount() - 1)))
		self:SetHealth(self.Owner:Health())
	end
	self.Delay = CurTime() + 0.1
	self.OwnerPos = self.Owner:GetPos()
	self:SetIdealPos(self.Pos)
	self.Pos = self:GetPos()
	self.closest = self:GetClosest(self.Owner, self.Pos)
	self.StandVelocity = VectorRand()
	if CLIENT then
		self:SetIK(true)
	end
	if SERVER then
		timer.Simple(0, function()
			if IsValid(self) then
				self.ReadytoAnimate = true
				self:RemoveAllGestures()
				if !self.AnimDelay or CurTime() >= self.AnimDelay then
					self:DoAnimations()
				end
			end
		end)
	end
		offset = Vector(-20,20,30)
	self.Lifetime = CurTime() + 10
	
	local clr = gStands.GetStandColorTable(self.Model, self:GetSkin())
	clr.a = 150
	if SERVER then
	self:SetTrail(util.SpriteTrail(self, 4, clr, true, 0.6,0, 0.5, 1/(15) * 0.5, "effects/beam_generic01.vmt" ))
	end
	self:Think()
end				 

function ENT:DoAnimations()
	if SERVER then
		self:ResetSequence("standidle")
	end
end

function ENT:DoMovement()
	if SERVER and !self:GetMarkedToFade() then
		if self.Speed < self.MaxSpeed then
			self.Speed = Lerp(0.1, self.Speed, self.MaxSpeed)
		end
		self.closest = self:GetClosest(self.Owner, self.Pos)

		self.StandVelocity = self.StandVelocity or Vector(0,0,0)
		local toPlayer = (self.closest:EyePos() - self.Pos):GetNormalized()
		self.StandVelocity = (self.StandVelocity + toPlayer/15):GetNormalized()
		local FTr = util.TraceLine({
			start = self.Pos,
			endpos = self.Pos + self.StandVelocity * self.Speed * 5,
			filter = {self, self.Owner},
			collisiongroup = self:GetCollisionGroup()
		})
			if FTr.Hit then
				self.StandVelocity = self.StandVelocity + FTr.HitNormal/5
			end
			self:SetIdealPos((self.Pos + self.StandVelocity * FTr.Fraction * self.Speed))
		self:SetPos(self:GetIdealPos())
		self:SetAngles(LerpAngle(0.1, self:GetAngles(), self.StandVelocity:Angle()))
	end	
end
function ENT:OnRemove()
	return false
end
function ENT:Think()
	if (SERVER and !IsValid(self.Owner)) or (SERVER and CurTime() >= self.Lifetime) then
		self:Remove()
		return true
	end
	self.Range = self:GetRange()
	
	self.OwnerPos = self.Owner:GetPos()
	self.OwnerCenterPos = self.Owner:WorldSpaceCenter()
	self.CenterPos = self:WorldSpaceCenter()
	self.Pos = self:GetPos()
	self.Forward = self:GetForward()
	self.DoDoDoTimer = self.DoDoDoTimer or CurTime()
	self.Skin = self:GetSkin()
	self.InStill = self.Owner:KeyDown(IN_USE)
	self.DistToOwner = self.Pos:Distance(self.OwnerPos)
	self.Model = self:GetModel()
	self.Image = self:GetImage()
	self.Wep = self.Wep or self.Owner:GetActiveWeapon()
	--Define initial value of the picked up item
	self.ItemPickedUp = self.ItemPickedUp or self
	if self.Owner and self.Owner:GetActiveWeapon():IsValid() and self.Owner:GetActiveWeapon():GetHoldType() != "stando" then
		self:DropItem()
	end
	
	self:SetVelocity(-self:GetVelocity())
	if self.Owner:IsValid() and self.Owner:Alive() then
		
		
		if self.Owner:IsFlagSet(FL_FROZEN) or self:GetMoveType() == MOVETYPE_NONE then
			self.StoppedAnimTime = self.StoppedAnimTime or self:GetCycle()
			else
			self.StoppedAnimTime = nil
		end
		if !self.AnimDelay or CurTime() >= self.AnimDelay then
			self:DoAnimations()
		end
		self.LastSequence = self.LastSequence or self:GetSequence()
		self.LastSequence = self:GetSequence()
		self.LastPos = self:GetPos()
		if !self:GetFrozen() then
			self:DoMovement()
		end
		
		if SERVER and (self.Owner:IsFlagSet(FL_FROZEN) or (self:GetMoveType() == MOVETYPE_NONE and !Active)) then
			self:SetCycle(self.StoppedAnimTime)
			self:SetPlaybackRate(0)
			self:RemoveAllGestures()
			for i = 0, 14 do 
				if self:IsValidLayer(i) then
					self:SetLayerCycle(i,1)
				end
			end
			
			else
			self:SetPlaybackRate(1)
		end
		elseif SERVER then
		self:Remove()
	end
				self:SetPlaybackRate(1)

	self:NextThink( CurTime() ) 
	return true
end

function ENT:GetEyePos(head)
	if !head then head = false end
	if self:GetInDoDoDo() or head then
		local att = self:LookupAttachment("anim_attachment_head")
		local tab = self:GetAttachment(att)
		if !tab then
			tab = {}
			tab.Pos = self:WorldSpaceCenter()
		end
		return tab.Pos or self:WorldSpaceCenter()
		else
		return self.Owner:EyePos()
	end
end


function ENT:OnTakeDamage(dmg)
	self:Remove()
	return false
end
local mat = Material("effects/gstands_aura")
local blur = Material("pp/blurscreen")
local shine = Material("sprites/light_glow02_add.vmt")
function ENT:Draw()
end
function ENT:DrawTranslucent()
	if !IsValid(self.Owner) then
		return true 
	end
	if !IsValid(self.Wep:GetTarget()) then
	if !(LocalPlayer():GetActiveWeapon() and LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer())) and IsValid(self:GetTrail()) then
		self:GetTrail():SetNoDraw(true)
		elseif (LocalPlayer():GetActiveWeapon() and LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer())) and IsValid(self:GetTrail()) then
			self:GetTrail():SetNoDraw(false)
	end
	local LOD = self.Pos:Distance(EyePos())
	self.LOD = 0
	if LOD >= 100 then
		self.LOD = 1
	end
	if LOD >= 300 then
		self.LOD = 2
	end
	if LOD >= 500 then
		self.LOD = 3
	end
	
	if self.LOD <= 2 and IsValid(self:GetTrail()) then
		self:GetTrail():SetNoDraw(true)
	end
	self.OwnerNoDraw = false
	if !self.OwnerNoDraw then
		if CLIENT and LocalPlayer():GetActiveWeapon() then
			if LocalPlayer():IsValid() and IsPlayerStandUser(LocalPlayer()) then
				render.SetMaterial(shine)
				render.DrawSprite(self:GetPos(), 15,15, Color(255 * (LOD/500),255 * (LOD/500),255 * (LOD/500)))
				self:DrawModel() 
				render.SetBlend(1)
			end
		end
	end
	end
	end