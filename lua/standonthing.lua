local tr = Entity(1):GetEyeTrace()

local old_override = tr.Entity.RenderOverride
local mat_cache = {
}
local stored_matrix = {
}

for i,j in pairs(ents.GetAll()) do
	if j:GetClass() == "prop_physics" then
		j.RenderOverride = function(self)
			for k,v in pairs(j:GetMaterials()) do
				if not mat_cache[v] then
					mat_cache[v] = Material(v)
				end
				local mat = mat_cache[v]
				local matrix = mat:GetMatrix("$basetexturetransform")
				stored_matrix[v] = matrix:GetScale()
				matrix:SetScale(Vector(1,1,1) * math.abs(math.sin(CurTime())))
				mat:SetMatrix("$basetexturetransform", matrix)
			end
			for i=0, 31 do
				local v = j:GetSubMaterial(i)
				if not v or v == "" then continue end
				if not mat_cache[v] then
					mat_cache[v] = Material(v)
				end
				local mat = mat_cache[v]
				local matrix = mat:GetMatrix("$basetexturetransform")
				stored_matrix[v] = matrix:GetScale()
				matrix:SetScale(Vector(1,1,1) * math.abs(math.sin(CurTime())))
				mat:SetMatrix("$basetexturetransform", matrix)
			end
			local m = j:GetMaterial()
			if m and m ~= "" then 
				if not mat_cache[m] then
					mat_cache[m] = Material(m)
				end
				local mat = mat_cache[m]
				local matrix = mat:GetMatrix("$basetexturetransform")
				stored_matrix[m] = matrix:GetScale()
				matrix:SetScale(Vector(1,1,1) * math.abs(math.sin(CurTime())))
				mat:SetMatrix("$basetexturetransform", matrix)
			end
			self:DrawModel()
			if m and m ~= "" then 
				if not mat_cache[m] then
					mat_cache[m] = Material(m)
				end
				local mat = mat_cache[m]
				local matrix = mat:GetMatrix("$basetexturetransform")
				matrix:SetScale(stored_matrix[m])
				mat:SetMatrix("$basetexturetransform", matrix)
			end
			for k,v in pairs(j:GetMaterials()) do
				if not mat_cache[v] then
					mat_cache[v] = Material(v)
				end
				local mat = mat_cache[v]
				local matrix = mat:GetMatrix("$basetexturetransform")
				matrix:SetScale(stored_matrix[v])
				mat:SetMatrix("$basetexturetransform", matrix)
			end
			for i=0, 31 do
				local v = j:GetSubMaterial(i)
				if not v or v == "" then continue end
				if not mat_cache[v] then
					mat_cache[v] = Material(v)
				end
				local mat = mat_cache[v]
				local matrix = mat:GetMatrix("$basetexturetransform")
				matrix:SetScale(stored_matrix[v])
				mat:SetMatrix("$basetexturetransform", matrix)
			end
		end
	end
end