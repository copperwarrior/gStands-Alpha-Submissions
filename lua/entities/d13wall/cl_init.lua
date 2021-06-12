include("shared.lua")

local sunBlockerMat = Material("color")
local FloorMaterial = Material("models/d13/groundtan")
local balloon = Model("models/d13/balloon.mdl")
function ENT:Initialize()
	local bounds = self:GetWallBounds()
	self:SetRenderBounds(-bounds,bounds)
	hook.Add("SetupWorldFog", "NightmareFog", function()
	if self and self.GetDreamlandDimension and self:GetDreamlandDimension() and self:GetDreamlandDimension():IsValid() and self:GetDreamlandDimension():ShouldRenderInterior() then
	local clr = HSVToColor(( CurTime() * 15 ) % 360, 1, 1)

	render.FogStart(0)
	render.FogEnd(5000)
	render.FogMode(MATERIAL_FOG_LINEAR)
	for k, ent in pairs(ents.GetAll()) do
        if ent:GetClass() == "d13scythe"then
            render.FogMaxDensity(5)
        else
            render.FogMaxDensity(0.3)
        end
    end
	render.FogColor(clr.r, clr.g, clr.b )
	return true
	end
	end)
	
end

function ENT:GetDrawMesh()
	if !self.mesh then
		local bounds = self:GetWallBounds()
		self.mesh = Mesh(sunBlockerMat)
		self.mesh:BuildFromTriangles({--This is autistic
			[1] = {pos = Vector(-bounds.x,bounds.y,bounds.z)},
			[2] = {pos = Vector(-bounds.x,-bounds.y,-bounds.z)},
			[3] = {pos = Vector(-bounds.x,bounds.y,-bounds.z)},
			[4] = {pos = Vector(-bounds.x,-bounds.y,bounds.z)},
			[5] = {pos = Vector(-bounds.x,-bounds.y,-bounds.z)},
			[6] = {pos = Vector(-bounds.x,bounds.y,bounds.z)},
			[7] = {pos = Vector(bounds.x,-bounds.y,-bounds.z)},
			[8] = {pos = Vector(-bounds.x,bounds.y,-bounds.z)},
			[9] = {pos = Vector(-bounds.x,-bounds.y,-bounds.z)},
			[10] = {pos = Vector(bounds.x,bounds.y,-bounds.z)},
			[11] = {pos = Vector(-bounds.x,bounds.y,-bounds.z)},
			[12] = {pos = Vector(bounds.x,-bounds.y,-bounds.z)},
			[13] = {pos = Vector(-bounds.x,-bounds.y,bounds.z)},
			[14] = {pos = Vector(bounds.x,-bounds.y,-bounds.z)},
			[15] = {pos = Vector(-bounds.x,-bounds.y,-bounds.z)},
			[16] = {pos = Vector(bounds.x,-bounds.y,bounds.z)},
			[17] = {pos = Vector(bounds.x,-bounds.y,-bounds.z)},
			[18] = {pos = Vector(-bounds.x,-bounds.y,bounds.z)},
			[19] = {pos = Vector(bounds.x,bounds.y,-bounds.z)},
			[20] = {pos = Vector(bounds.x,bounds.y,bounds.z)},
			[21] = {pos = Vector(-bounds.x,bounds.y,-bounds.z)},
			[22] = {pos = Vector(bounds.x,bounds.y,bounds.z)},
			[23] = {pos = Vector(-bounds.x,bounds.y,bounds.z)},
			[24] = {pos = Vector(-bounds.x,bounds.y,-bounds.z)},
			[25] = {pos = Vector(bounds.x,-bounds.y,-bounds.z)},
			[26] = {pos = Vector(bounds.x,-bounds.y,bounds.z)},
			[27] = {pos = Vector(bounds.x,bounds.y,-bounds.z)},
			[28] = {pos = Vector(bounds.x,-bounds.y,bounds.z)},
			[29] = {pos = Vector(bounds.x,bounds.y,bounds.z)},
			[30] = {pos = Vector(bounds.x,bounds.y,-bounds.z)},
			[31] = {pos = Vector(bounds.x,-bounds.y,bounds.z)},
			[32] = {pos = Vector(-bounds.x,-bounds.y,bounds.z)},
			[33] = {pos = Vector(bounds.x,bounds.y,bounds.z)},
			[34] = {pos = Vector(-bounds.x,-bounds.y,bounds.z)},
			[35] = {pos = Vector(-bounds.x,bounds.y,bounds.z)},
			[36] = {pos = Vector(bounds.x,bounds.y,bounds.z)},
		})
	end
	return self.mesh
end




--	self:SetMaterial("models/d13/water")
local matScale = Vector(15,15,15)

local matScaleSky = Vector(1500,1,1500)






function ENT:OnRemove()
	hook.Remove("SetupWorldFog", "NightmareFog")
end


