ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName= "Empress"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "Empress"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
ENT.Animated = true
ENT.ImageID = 1
ENT.Rate = 0
ENT.Health = 1
ENT.CurrentAnim = "idle"
ENT.State = false
ENT.Color = Color(255,255,255,75)
local snd = false
local Deploy = Sound( "weapons/empress/deploy.wav" )
local FDeploy = Sound( "weapons/empress/fdeploy.wav" )

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Target")
	self:NetworkVar("Bool", 1, "Ready")
end

function ENT:Initialize()
	self.StartTime = CurTime()
    self:SetModel("models/empress/empress.mdl")
	self:Activate()
	self:SetMoveType( MOVETYPE_NONE )
	self:UseClientSideAnimation()
	
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	local mins, maxs = self:GetTarget():GetCollisionBounds()
	self:SetCollisionBounds(mins * 1.1, maxs * 1.1)
	self:SetPos(self:GetTarget():GetPos())
	self:SetMoveParent(self:GetTarget())
	self:AddEffects( EF_BONEMERGE || EF_BONEMERGE_FASTCULL || EF_PARENT_ANIMATES)
	if self.Owner then
		self:SetHealth(self.Owner:Health())
	end
	self:SetSequence( 4 )
local hooktag = self.Owner:GetName()..self:GetTarget():EntIndex()
	hook.Add("EntityTakeDamage", "CutOffEmpress"..hooktag, function(targ, dmg)
		if self:IsValid() and self.Owner:IsValid() and IsValid(self:GetTarget()) then
			if targ == self:GetTarget() and dmg:GetAttacker() != self.Owner and string.StartWith(dmg:GetInflictor():GetClass(), "gstands_") then
				self:TakeDamageInfo(dmg)
			end
			if targ != self and targ != self.Owner and dmg:GetAttacker() == self:GetTarget() and string.StartWith(dmg:GetInflictor():GetClass(), "gstands_") and dmg:GetInflictor():GetPos():DistToSqr(self:GetBonePosition(self:LookupBone("spine4.001"))) < 50000 then
				self.Owner:TakeDamageInfo(dmg)
			end
			elseif !self:IsValid() or !self.Owner:IsValid() or !self:GetTarget():IsValid() then
			hook.Remove("EntityTakeDamage", "CutOffEmpress"..hooktag)
		end
	end)
	hook.Add("SetupPlayerVisibility", "standnocullbreak"..hooktag, function(ply, ent) 
		if self:IsValid() and self.Owner:IsValid() then
			AddOriginToPVS( self:GetBonePosition(self:LookupBone("spine4.001") ))
		end
	end)
	if SERVER then
		self:EmitStandSound(FDeploy)
	end
	timer.Simple(60, function() if IsValid(self) then self:SetSequence(1) if SERVER then self:EmitStandSound(Deploy) self:SetReady(true) end end end)
end

function ENT:Disable(silent)
    if silent then
        self.Owner:KillSilent()
		else
        self.Owner:Kill()
	end
    self:Remove()
end

function ENT:OnRemove()

end

function ENT:Think()

	
	if SERVER and self:GetTarget():Health() < 0 then
		self:Remove()
	end
    self:NextThink( CurTime()) 
    return true
end

function ENT:OnTakeDamage(dmg)
	if string.StartWith(dmg:GetInflictor():GetClass(), "gstands_") then
		dmg:SetDamage(dmg:GetDamage() * 2)
		self.Owner:TakeDamageInfo(dmg)
		return false
	end
end

function ENT:Draw()
	return false
end
local zero = Vector(0,0,0)
function ENT:DrawTranslucent()
	self.Timescale = GetConVar("host_timescale"):GetFloat()
	local rupper, lupper, rlower, llower = self:LookupBone("upperarm_r"), self:LookupBone("upperarm_l"), self:LookupBone("forearm_r"), self:LookupBone("forearm_l")
	local spine, lupper, rlower, llower = self:LookupBone("spine1"), self:LookupBone("upperarm_l"), self:LookupBone("forearm_r"), self:LookupBone("forearm_l")
	
		self:SetupBones()
		self:DrawModel()
		if self:GetSequence() == 2 then
			for i=0, GetConVar("gstands_barrage_arms"):GetInt() do
				self.ArmFrame = FrameNumber() + (5 - (5 * self.Timescale))
				
				local resetAnim = self:GetCycle()
				self:SetCycle(self:GetCycle() + math.Rand(0.3,0.8))
				
				local randvec1 = VectorRand() * 2
				local randvec1 = Vector(randvec1.x/4, randvec1.y, randvec1.z)
				local randvec2 = VectorRand() * 2
				local randvec2 =  Vector(randvec2.x/4, randvec2.y, randvec2.z)
				self:ManipulateBonePosition(rupper,randvec2)
				self:ManipulateBonePosition(lupper,randvec2)
				self:ManipulateBonePosition(rlower,self:GetManipulateBonePosition(rupper)/2)
				self:ManipulateBonePosition(llower,self:GetManipulateBonePosition(lupper)/2)
				local angadj = 45
				local oldclip = false
				angadj = 25
				oldclip = render.EnableClipping( true )
				local normal = self:GetForward()
				local position = normal:Dot( self:WorldSpaceCenter() + normal * 1 )
				render.PushCustomClipPlane( normal, position )
				
				self:ManipulateBoneAngles(rupper,Angle(math.random(-angadj,angadj), math.random(-angadj,angadj),math.random(-angadj,angadj)))
				self:ManipulateBoneAngles(lupper,Angle(math.random(-angadj,angadj), math.random(-angadj,angadj),math.random(-angadj,angadj)))
				
				self:SetupBones()
				render.SetBlend(math.Rand(0.1, 0.9))

				self:DrawModel()
				render.PopCustomClipPlane()
				oldclip = render.EnableClipping( oldclip )
				self:SetCycle(resetAnim)
				self:ManipulateBonePosition(rupper,zero)
				self:ManipulateBonePosition(lupper,zero)
				self:ManipulateBonePosition(rlower,zero)
				self:ManipulateBonePosition(llower,zero)
				self:ManipulateBoneAngles(rupper,Angle(0,0,0))
				self:ManipulateBoneAngles(lupper,Angle(0,0,0))
			end
		end
	
    if GetConVar("gstands_show_hitboxes"):GetBool() then
        for i = 0, self:GetHitBoxCount(0) - 1 do
            local cmins, cmaxs = self:GetHitBoxBounds(i, 0)
            local cpos, cang = self:GetBonePosition(self:GetHitBoxBone(i, 0))
            render.DrawWireframeBox(cpos, cang, cmins, cmaxs, Color(255,0,0,255), true)
		end
        local cmins, cmaxs = self:GetCollisionBounds()
        render.DrawWireframeBox(self:GetPos(), self:GetAngles(), cmins, cmaxs, Color(0,255,0,255), true)
        local pos, ang = self:GetPos(), self:GetAngles()
        render.DrawWireframeBox(pos, ang:Right():Angle(), Vector(-35, -35, 0), Vector(5, 45, 65), Color(255,255,0,255), false)
	end
	
end
