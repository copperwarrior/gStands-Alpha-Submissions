ENT.Type = "anim"

function ENT:SetupDataTables()
		self:NetworkVar("Vector", 1, "EndPos")
		self:NetworkVar("Entity", 2, "HPEntity")
		
end
