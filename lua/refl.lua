local trace = Entity(1):GetEyeTrace()
TablePowerThisOne = {}
for k,v in pairs(constraint.GetAllConstrainedEntities(trace.Entity)) do
	table.insert(TablePowerThisOne, {
		pos = v:GetPos(),
		ang = v:GetAngles(),
		model = v:GetModel(),
		class = v:GetClass(),
		tab = v:GetTable(),
		constraints = constraint.GetTable(v)
		})
end
local str = util.TableToJSON(TablePowerThisOne)
file.CreateDir( "warptest" )
file.Write( "warptest/barrels.txt", str)

-- local trace = Entity(1):GetEyeTrace()
-- local str = file.Read("warptest/barrels.txt")
-- TablePowerThisOne = util.JSONToTable(str)
-- local offset = TablePowerThisOne[1].pos - trace.HitPos
-- for k,v in pairs(TablePowerThisOne) do
	-- local ent = ents.Create(v.class)
	-- ent:SetPos(v.pos - offset)
	-- ent:SetAngles(v.ang)
	-- ent:SetModel(v.model)
	-- ent:SetTable(v.tab)
	-- ent:Spawn()
	-- ent:Activate()
	
-- end

