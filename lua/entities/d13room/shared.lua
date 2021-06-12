ENT.Type 		= "anim"
ENT.Base 		= "base_anim"
ENT.PrintName 	= "Dreamland Dimension"
ENT.Name 		= "Dreamland Dimension"
ENT.Spawnable 	= false
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.PhysgunDisabled = true
ENT.UnEatable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"Width")
	self:NetworkVar("Int",1,"Length")
	self:NetworkVar("Int",2,"Height")
	self:NetworkVar("Entity", 0, "DreamProp")
end

function ENT:GetDreamlandBounds()
	return Vector(self:GetWidth()/2,self:GetLength()/2,self:GetHeight()/2)
end

function ENT:PositionInside(pos)
	local bounds = self:GetDreamlandBounds()
	return pos:WithinAABox(self:GetPos()-bounds,self:GetPos()+bounds)
end
function ENT:Think()
		if SERVER then
		for k,v in pairs(player.GetAll()) do
			if self:PositionInside(v:GetPos()) and v:GetMoveType() == MOVETYPE_NOCLIP then
					v:SetMoveType(MOVETYPE_WALK)
				end
			end
		end
		if SERVER and self:GetPos() != self.StartPos then
			self:SetPos(self.StartPos)
		end
		self:NextThink(CurTime())
		return true
end
if SERVER then return end


function ENT:Initialize()
	local bounds = self:GetDreamlandBounds()
	self:SetRenderBounds(-bounds,bounds)
	Dreamland = self
end

function ENT:Draw()
	if self:IsValid() and !self:ShouldRenderInterior() then
		return
	end
	self:DrawModel()
	self.StandAura = self.StandAura or CreateParticleSystem(self, "d13mapfog", PATTACH_POINT, 0)
	self.StandAura:SetControlPoint(0, self:GetPos() + Vector(0,0,500))
	self.StandAura:SetShouldDraw(false)
	self.StandAura:Render()

end

function ENT:ShouldRenderInterior()
	return self:PositionInside(EyePos())
end

hook.Add("PreRender","PreRenderDreamlandEnts",function()
	for k,Dreamland in ipairs(ents.FindByClass("d13room")) do
		if Dreamland:ShouldRenderInterior() then continue end
		for o,ent in ipairs(ents.GetAll()) do
			if !ent.DreamlandRenderingMode and ent != Dreamland and ent:GetClass() != "d13wall" and Dreamland:PositionInside(ent:GetPos()) then
				ent.DreamlandRenderingMode = true
				local prevRender = ent.RenderOverride
				ent.RenderOverride = function(self)
					if !Dreamland:IsValid() or !Dreamland:PositionInside(self:GetPos()) or Dreamland:ShouldRenderInterior() then
						self.RenderOverride = prevRender
						self.DreamlandRenderingMode = nil
						return
					end
				end
			end
		end
	end
end)

hook.Add("PreDrawTranslucentRenderables","CatchDreamlandEyePos",function()
	EyePos()
end)
