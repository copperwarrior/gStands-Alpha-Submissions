--[[--
	Scalable Rocket Fire Effect
	
	@submodule Particles
--]]

--- Scalable Rocket Fire Effect
-- @field Origin Effect Position
-- @field Normal Effect Direction
-- @field Scale Effect Scale
-- @table launch_missile

local rocks = {
	"models/props_debris/physics_debris_rock1.mdl",
	"models/props_debris/physics_debris_rock2.mdl",
	"models/props_debris/physics_debris_rock3.mdl",
	"models/props_debris/physics_debris_rock4.mdl",
	"models/props_debris/physics_debris_rock5.mdl",
	"models/props_debris/physics_debris_rock6.mdl",
	"models/props_debris/physics_debris_rock7.mdl",
	"models/props_debris/physics_debris_rock8.mdl",
	"models/props_debris/physics_debris_rock9.mdl",
	"models/props_debris/physics_debris_rock10.mdl",
	"models/props_debris/physics_debris_rock11.mdl",
}

local ant_gibs = {
	"models/gibs/antlion_gib_medium_1.mdl",
	"models/gibs/antlion_gib_medium_2.mdl",
	"models/gibs/antlion_gib_medium_3.mdl",
	"models/gibs/antlion_gib_medium_3a.mdl",
	"models/gibs/antlion_gib_small_1.mdl",
	"models/gibs/antlion_gib_small_2.mdl",
	"models/gibs/antlion_gib_small_3.mdl",
}
local metal_gibs = {
	"models/props_debris/metal_panelshard01a.mdl",
	"models/props_debris/metal_panelshard01b.mdl",
	"models/props_debris/metal_panelshard01c.mdl",
	"models/props_debris/metal_panelshard01d.mdl",
}

local matlist = {}

local mat_cover = CreateMaterial("impact_rock", "VertexLitGeneric", {
	["$vertexcolor"] = 1,
	["$basetexture"] = "",
	["$translucent"] = 0,
})

local matSpecific = {
	[MAT_ANTLION] = function(self)
		local fx = EffectData()
		fx:SetOrigin(self.Pos)
		fx:SetNormal(self.Normal)
		fx:SetMagnitude(self.Scale)
		fx:SetRadius(self.Scale)
		fx:SetScale(self.Scale)
		util.Effect("AntlionGib", fx, true, true)
		for i=1, self.Scale/20 do
			local mdl = ents.CreateClientProp(table.Random(ant_gibs))
			local dir = VectorRand()
			dir.x = dir.x / 55
			dir:Rotate(self.Normal:Angle())
			dir:Normalize()
			mdl:SetPos(self.Pos + self.Normal * 24)
			local dir2 = ((self.Pos - (self.Normal * 70) + self.AttackAngle)):GetNormalized()
			mdl:SetAngles(dir2:Angle())
			mdl:Spawn()
			mdl:GetPhysicsObject():SetVelocity((self.AttackAngle)/4)
			table.insert(self.CSProps, mdl)
		end
	end,
	[MAT_FLESH] = function(self)
		local fx = EffectData()
		fx:SetOrigin(self.Pos)
		fx:SetStart(self.Pos)
		fx:SetEntity(self)
		fx:SetScale(65)
		fx:SetColor(0)
		fx:SetFlags(3)
		util.Effect("bloodspray", fx, true, true)
		for i=1, self.Scale/10 do
			local mdl = ents.CreateClientProp(table.Random(rocks))
			local dir = VectorRand()
			dir.x = dir.x / 55
			dir:Rotate(self.Normal:Angle())
			dir:Normalize()
			mdl:SetPos(self.Pos + self.Normal * 24)
			local dir2 = ((self.Pos - (self.Normal * 70) + self.AttackAngle)):GetNormalized()
			mdl:SetAngles(dir2:Angle())
			mdl:Spawn()
			mdl:GetPhysicsObject():SetVelocity((self.AttackAngle)/4)
			mdl:GetPhysicsObject():SetMaterial("bloodyflesh")
			mdl:SetMaterial("models/flesh")
			table.insert(self.CSProps, mdl)
		end
	end,
	[MAT_CONCRETE] = function(self)
		for i=1, self.Scale/4 do
			local AttackDir = self.AttackAngle * 1
			AttackDir = self.Normal + AttackDir
			self.Pos = self.OPos + AttackDir/300 * i
			local mdl = ClientsideModel(table.Random(rocks))
			mdl:SetModelScale(math.Rand(1, self.Scale/100))
			local dir = VectorRand()
			dir.x = dir.x / 55
			dir:Rotate(self.Normal:Angle())
			dir:Normalize()
			mdl.IdealPos = (self.Pos + (dir * (100) * math.Rand(0.1, 1) * self.Scale/300))
			local tr = util.TraceHull({
				start=mdl.IdealPos,
				endpos=mdl.IdealPos,
				mask = MASK_SOLID,
				mins=-Vector(15,15,15),
				maxs=Vector(15,15,15)
			})
			if tr.Hit then
				mdl:SetPos(self.Pos - self.Normal * 55)
				local dir2 = (mdl.IdealPos - (self.Pos - (self.Normal * 70) + AttackDir)):GetNormalized()
				mdl:SetAngles(dir2:Angle())
				mdl:Spawn()
				mdl:SetNoDraw(true)
				table.insert(self.CSModels, mdl)
				local velocity = (self.Normal + AttackDir/300 + (VectorRand() * 0.65)):GetNormalized() * (math.Rand(100, 100) * self.Scale/200)
				
				local p = self.Emitter:Add("particle/particle_smoke_dust", self.Pos)
				p:SetDieTime(math.Clamp(math.Rand(1, 2) * self.Scale/100, 0.5, 3))
				p:SetVelocity(self.Normal + ((AttackDir/5) * math.random(-1,1)))
				p:SetAirResistance(200)
				p:SetStartAlpha(100)
				p:SetEndAlpha(0)
				p:SetStartSize(math.random(55, 125) * self.Scale/300)
				p:SetEndSize(math.random(125, 450) * self.Scale/300)
				p:SetRollDelta(math.Rand(-0.25, 0.25))
				p:SetColor(100,100, 100)
				else
				mdl:Remove()
			end
		end
		for i=1, self.Scale/10 do
			local mdl = ents.CreateClientProp(table.Random(rocks))
			local dir = VectorRand()
			dir.x = dir.x / 55
			dir:Rotate(self.Normal:Angle())
			dir:Normalize()
			mdl:SetPos(self.Pos + self.Normal * 24)
			local dir2 = ((self.Pos - (self.Normal * 70) + self.AttackAngle)):GetNormalized()
			mdl:SetAngles(dir2:Angle())
			mdl:Spawn()
			mdl:GetPhysicsObject():SetVelocity((self.AttackAngle)/4)
			table.insert(self.CSProps, mdl)
		end
	end,
	[MAT_METAL] = function(self)
		for i=1, self.Scale/4 do
			local AttackDir = self.AttackAngle * 1
			AttackDir = self.Normal * 2 + AttackDir
			self.Pos = self.OPos + AttackDir/300 * i
			local mdl = ClientsideModel(table.Random(metal_gibs))
			mdl:SetModelScale(math.Rand(1, self.Scale/100))
			local dir = VectorRand()
			dir.x = dir.x / 55
			dir:Rotate(self.Normal:Angle())
			dir:Normalize()
			mdl.IdealPos = (self.Pos + (dir * (100) * math.Rand(0.1, 1) * self.Scale/300))
			local tr = util.TraceHull({
				start=mdl.IdealPos,
				endpos=mdl.IdealPos,
				mask = MASK_SOLID,
				mins=-Vector(15,15,15),
				maxs=Vector(15,15,15)
			})
			if tr.Hit then
				mdl:SetPos(self.Pos - self.Normal * 55)
				local dir2 = (mdl.IdealPos - (self.Pos + (self.Normal * 150))):GetNormalized()
				debugoverlay.Cross(self.Pos + (self.Normal * 150), 15, 1)
				mdl:SetAngles(dir2:Angle())
				mdl:Spawn()
				mdl:SetNoDraw(true)
				table.insert(self.CSModels, mdl)
				local velocity = (self.Normal + AttackDir/300 + (VectorRand() * 0.65)):GetNormalized() * (math.Rand(100, 100) * self.Scale/200)
				
				local p = self.Emitter:Add("particle/particle_smoke_dust", self.Pos)
				p:SetDieTime(math.Clamp(math.Rand(1, 2) * self.Scale/100, 0.5, 3))
				p:SetVelocity(self.Normal + ((AttackDir/5) * math.random(-1,1)))
				p:SetAirResistance(200)
				p:SetStartAlpha(100)
				p:SetEndAlpha(0)
				p:SetStartSize(math.random(55, 125) * self.Scale/300)
				p:SetEndSize(math.random(125, 450) * self.Scale/300)
				p:SetRollDelta(math.Rand(-0.25, 0.25))
				p:SetColor(100,100, 100)
				else
				mdl:Remove()
			end
		end
		for i=1, self.Scale/10 do
			local mdl = ents.CreateClientProp(table.Random(metal_gibs))
			mdl:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
			local dir = VectorRand()
			dir.x = dir.x / 55
			dir:Rotate(self.Normal:Angle())
			dir:Normalize()
			mdl:SetPos(self.Pos + self.Normal * 24)
			local dir2 = ((self.Pos - (self.Normal * 70) + self.AttackAngle)):GetNormalized()
			mdl:SetAngles(dir2:Angle())
			mdl:Spawn()
			mdl:GetPhysicsObject():SetVelocity((self.AttackAngle)/4)
			table.insert(self.CSProps, mdl)
		end
	end,
	[MAT_DIRT] = function(self)
		for i=1, self.Scale/10 do
			local AttackDir = self.AttackAngle * 1
			AttackDir = self.Normal * 2 + AttackDir
			self.Pos = self.OPos + AttackDir/300 * i
			local mdl = ClientsideModel(table.Random(rocks))
			mdl:SetModelScale(math.Rand(2, self.Scale/100))
			local dir = VectorRand()
			dir.x = dir.x / 55
			dir:Rotate(self.Normal:Angle())
			dir:Normalize()
			mdl.IdealPos = (self.Pos + (dir * (100) * math.Rand(0.1, 1) * self.Scale/300))
			local tr = util.TraceHull({
				start=mdl.IdealPos,
				endpos=mdl.IdealPos,
				mask = MASK_SOLID,
				mins=-Vector(15,15,15),
				maxs=Vector(15,15,15)
			})
			if tr.Hit then
				mdl:SetPos(self.Pos - self.Normal * 55)
				local dir2 = (mdl.IdealPos - (self.Pos - (self.Normal * 100) )):GetNormalized()
				mdl:SetAngles(dir2:Angle())
				mdl:Spawn()
				mdl:SetNoDraw(true)
				table.insert(self.CSModels, mdl)
				--Smoke Plume
				local velocity = (self.Normal + AttackDir/300 + (VectorRand() * 0.65)):GetNormalized() * (math.Rand(100, 100) * self.Scale/200)
				
				local p = self.Emitter:Add("particle/particle_smoke_dust", self.Pos)
				p:SetDieTime(math.Clamp(math.Rand(0.1, 0.5) * self.Scale/100, 0.5, 3))
				p:SetVelocity(VectorRand() * 5 + self.Normal + ((AttackDir/5) * math.random(-1,1)))
				p:SetAirResistance(200)
				p:SetStartAlpha(10)
				p:SetEndAlpha(0)
				p:SetStartSize(math.random(55, 125) * self.Scale/300)
				p:SetEndSize(math.random(125, 450) * self.Scale/300)
				p:SetRollDelta(math.Rand(-0.25, 0.25))
				p:SetColor(200,150, 100)
				else
				mdl:Remove()
			end
		end
		for i=1, self.Scale/10 do
			local mdl = ents.CreateClientProp(table.Random(rocks))
			local dir = VectorRand()
			dir.x = dir.x / 55
			dir:Rotate(self.Normal:Angle())
			dir:Normalize()
			mdl:SetPos(self.Pos + self.Normal * 24)
			local dir2 = ((self.Pos - (self.Normal * 70) + self.AttackAngle)):GetNormalized()
			mdl:SetAngles(dir2:Angle())
			mdl:Spawn()
			mdl:GetPhysicsObject():SetVelocity((self.AttackAngle)/4)
			mdl:GetPhysicsObject():SetMaterial("dirt")
			mdl:SetMaterial("models/props_wasteland/dirtwall001a")
			table.insert(self.CSProps, mdl)
		end
	end,
	[MAT_EGGSHELL] = function(self) end
}

function EFFECT:Init( data )
	self.Pos = data:GetOrigin()
	self.OPos = self.Pos
	self.Normal = data:GetNormal()
	self.AttackAngle = data:GetStart()
	self.Scale = data:GetScale()/5 or 1
	self.Surface = util.GetSurfaceData(data:GetSurfaceProp())
	self.CSModels = {}
	self.CSProps = {}
	self.Emitter = ParticleEmitter(self.Pos)
	
	local vec = Vector(self.Scale, self.Scale, self.Scale)
	self:SetRenderBounds(-vec, vec)
	self:EmitSound(self.Surface.impactHardSound)
	self:EmitSound(self.Surface.strainSound)
	local mattype = self.Surface.material
	if mattype == MAT_TILE then mattype = MAT_CONCRETE end
	if mattype == MAT_BLOODYFLESH then mattype = MAT_FLESH end
	if mattype == MAT_GRATE then mattype = MAT_METAL end
	if mattype == MAT_COMPUTER then mattype = MAT_METAL end
	matSpecific[mattype](self)
	self.Emitter:Finish()

end

function EFFECT:Think( )
  	self.LifeTime = self.LifeTime or CurTime() + 5
	if CurTime() > self.LifeTime then
		for k,v in pairs(self.CSModels) do
			v:Remove()
		end
		for k,v in pairs(self.CSProps) do
			v:Remove()
		end
		if IsValid(self.HoleModel) then
			self.HoleModel:Remove()
		end
		return false
	end
	local mult = self.LifeTime - CurTime()
	if mult < 0.5 then
		for k,v in pairs(self.CSModels) do
			v:SetPos(v:GetPos() - self.Normal)
		end
		for k,v in pairs(self.CSProps) do
			v:SetPos(v:GetPos() - self.Normal)
		end
		else
		
	for k,v in pairs(self.CSModels) do
		v:SetPos(LerpVector(0.5, v:GetPos(), v.IdealPos))
	end
	end
	return true
end

local mdls = {}

local rockmats = {
	[MAT_CONCRETE] = "",
	[MAT_DIRT] = "models/props_wasteland/dirtwall001a"
}
function EFFECT:Render( )
	for k,mdl in pairs(self.CSModels) do
		local tra = util.TraceLine({
			start=mdl:GetPos() + self.Normal * 555,
			endpos=mdl:GetPos() - self.Normal * 555,
			filter = self.CSModels,
			mask=MASK_SOLID_BRUSHONLY
		})
		matlist[tra.HitTexture] = matlist[tra.HitTexture] or Material(tra.HitTexture)
		mat_cover:SetTexture("$basetexture", matlist[tra.HitTexture]:GetTexture("$basetexture"))
		if tra.Hit and tra.HitTexture ~= "**empty**" and tra.HitTexture ~= "**displacement**" and not matlist[tra.HitTexture]:GetTexture("$basetexture"):IsError() and not mat_cover:GetTexture("$basetexture"):IsError() then
			mdl:SetMaterial("!impact_rock")
			else
			local mattype = self.Surface.material
			if mattype == MAT_TILE then mattype = MAT_CONCRETE end
			if mattype == MAT_BLOODYFLESH then mattype = MAT_FLESH end
			if mattype == MAT_GRATE then mattype = MAT_METAL end
			if mattype == MAT_COMPUTER then mattype = MAT_METAL end
			mdl:SetMaterial(rockmats[mattype])
		end
		mdl:DrawModel()
	end
	return false
end
