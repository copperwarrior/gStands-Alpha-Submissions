ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName= "dumi"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "To stand"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.AutomaticFrameAdvance = false
ENT.Animated = false
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
ENT.Model = ""
ENT.OwnerName = ""

function ENT:UpdateTransmitState()
		return TRANSMIT_PVS
end
function ENT:Initialize()
		self:SetSolid( SOLID_NONE )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		if SERVER then
		self:SetModel(self.Owner:GetModel())
		end
		self:SetPos(self.Owner:GetPos())
		self:SetAngles(self.Owner:GetAngles())
		self:SetParent(self.Owner)
		self:AddEffects( EF_BONEMERGE || EF_BONEMERGE_FASTCULL || EF_PARENT_ANIMATES)
		self.Positions = self.Positions or {}
		self.Angles = self.Angles or {}
		
		for i=0, self:GetBoneCount() do
			if !self.Positions[i] then
			self.Positions[i], self.Angles[i] = self:GetBonePosition(i)
			end
			self:ManipulateBoneJiggle(i, 0)
		end
		self:SetParent(nil)
		self:RemoveEffects( EF_BONEMERGE || EF_BONEMERGE_FASTCULL || EF_PARENT_ANIMATES)
end 	                
function ENT:Think()
		return false
end
function ENT:Draw()

		self:SetupBones()
		for i=0, self:GetBoneCount() do
			local pos, ang = self:GetBonePosition(i)
			if self.Positions[i] then
				self:SetBonePosition(i, self.Positions[i] or pos, self.Angles[i] or ang)
			end
		end

		self:DrawModel()
		self:SetupBones()
end
								