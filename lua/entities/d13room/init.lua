AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self.walls = {}
	self:SetPos(self:GetPos() - Vector(0,0,1950))
	self:SetModel("models/d13/d13map.mdl")
	self:ResetSequence(0)
	self.AutomaticFrameAdvance = true
	--self.DreamlandProp:SetModelScale(2)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)	
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:AddGameFlag(bit.bor(FVPHYSICS_NO_PLAYER_PICKUP,FVPHYSICS_NO_SELF_COLLISIONS,FVPHYSICS_NO_NPC_IMPACT_DMG,FVPHYSICS_NO_IMPACT_DMG))
		phys:EnableMotion(false)
	end
	self:SetRenderMode(RENDERMODE_TRANSALPHA)	

	self:Activate()
	self.Invincible = true
	
	self.StartPos = self:GetPos()
	self:SetDreamProp(self.DreamlandProp)
	hook.Add("PlayerNoClip", "NoClippingInaDream", function(ply, state)
		if IsValid(ply) and IsValid(self) then
			if self:PositionInside(ply:GetPos()) then
				return false
			end
		end
	end)
	hook.Remove("EntityEmitSound", "InDreamsYouCantScream", function(data)
		if IsValid(self) then
			if self:PositionInside(data.Entity:GetPos()) then
				for k,v in pairs(player.GetAll()) do
					if v:HasWeapon("gstands_death") then
						v:EmitSoundLocal(data, v:GetWeapon("gstands_death"):GetStand())
					end
				end
			end
		end
		return
	end)
end

function ENT:AddWall(ent)
	self.walls[#self.walls+1] = ent
	ent:SetDreamlandDimension(self)
end

local noRemoveEnts = {
	predicted_viewmodel = false,
}

function ENT:OnRemove()
	for k,v in ipairs(self.walls) do
		if v:IsValid() then
			v:Remove()
		end
	end
	for k,v in ipairs(ents.GetAll()) do
		if v:IsValid() and noRemoveEnts[v:GetClass()] != false and (!v:IsWeapon() or !v:GetParent():IsValid()) and self:PositionInside(v:GetPos()) then
			if v:IsPlayer() then
					v:SendToCorpse(v.d13rag)
					v.d13rag:Remove() 
					v.IsSlept = false
					ent:ScreenFade( SCREENFADE.IN , Color(0,0,0,255) , 0.3, 0.2 )
			else
				v:Remove()
			end
		end
	end
end

