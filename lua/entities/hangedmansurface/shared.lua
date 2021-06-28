AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName= "Hanged Man Reflective Surface"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "To stand"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true
ENT.Animated = true
ENT.pewcent = 1
ConvarDrawMirror = GetConVar("gstands_draw_hdm_mirror")
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:SetupDataTables()
	self:NetworkVar("Vector", 1, "OldMirror")
end
function ENT:FindTraces(numPoints)
	local traces = {}
	for i = 0, numPoints do
		local t = i / (numPoints - 1.0)
		local inclination = math.acos(1 - 2 * t)
		local azimuth = 2 * math.pi * 1.6180339887499 * i
		local x = math.sin(inclination) * math.cos(azimuth)
		local y = math.sin(inclination) * math.sin(azimuth)
		local z = math.cos(inclination)
		traces[i] = Vector(z, y, x)
	end
	return traces
end
function ENT:Initialize()    --Initial animation base
		self.traces = self:FindTraces(100)

    if SERVER then
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetHealth(1500000)
	local tex = util.TraceLine({
	start = self:GetPos() + self:GetUp() * 55,
	endpos = self:GetPos() - self:GetUp() * 25,
	filter={self},
	mask=MASK_ALL})
	if IsValid(tex.Entity) then
		self:SetParent(tex.Entity)
	end
	end
	self:SetRenderMode(RENDERMODE_WORLDGLOW)
	self:FindCorners()
	self:SetCollisionBoundsWS(self.Mins, self.Maxs)
	self.Wep = self.Owner:GetActiveWeapon()
	self:DrawShadow(false)
	if CLIENT then
	local tex = util.TraceLine({
	start = self:GetPos() + self:GetUp() * 55,
	endpos = self:GetPos() - self:GetUp() * 25})
	local ent = tex.Entity
	if tex.HitTexture then
	self.Mat = Material(tex.HitTexture)
	end
	local EyeMode = false
	if IsValid(tex.Entity) and (tex.Entity:IsPlayer() or tex.Entity:IsNPC()) then
		EyeMode = true
	end
local width = ScrW()
local height = ScrH()
local cmaxs, cmins = self:GetCollisionBounds()
local malength = cmaxs:Length()
local milength = cmins:Length()
local shortest
if malength >= milength then
	shortest = milength
else
	shortest = malength
end
local mirror_width = shortest * 1.4
local mirror_height = shortest * 1.4

local tex_name = "texture_scene"..self:EntIndex()
local mat_name = "material_scene"..self:EntIndex()
local mat_cover_name = "material_cover_scene"..self:EntIndex()

local col_white = Color(255, 255, 255, 255)
local mat_white = Material("debug/debugdrawflat")

local indraw
local draw_player

local mirror_center = self:GetPos() + self:GetUp() * 0.1
local mirror_normal = self:GetUp()
if IsValid(tex.Entity) then
	mirror_center = tex.Entity:WorldToLocal(self:GetPos() + self:GetUp())
end
-- Thanks to Wizzard of Ass for this portion of the code.
-- Thread: http://facepunch.com/showthread.php?t=1276039
local TEXTURE_FLAGS_CLAMP_S = 0x0004
local TEXTURE_FLAGS_CLAMP_T = 0x0008

local tex_scene = GetRenderTargetEx(tex_name,
	width,
	height,
	RT_SIZE_NO_CHANGE,
	MATERIAL_RT_DEPTH_SEPARATE,
	bit.bor(TEXTURE_FLAGS_CLAMP_S, TEXTURE_FLAGS_CLAMP_T),
	CREATERENDERTARGETFLAGS_UNFILTERABLE_OK,
    IMAGE_FORMAT_RGB888
)

local mat_scene = CreateMaterial(mat_name, "UnlitGeneric", {
	["$ignorez"] = 1,
	["$vertexcolor"] = 1,
	["$vertexalpha"] = 0,
	["$alpha"] = 1,
	["$nolod"] = 1,
	["$basetexture"] = tex_scene:GetName(),
	["$basetexturetransform"] = "center .5 .5 scale -1 1 rotate 0 translate 0 0"
})

local template = CreateMaterial("mat_cover_template", "UnlitGeneric", {
	["$vertexcolor"] = 1,
	["$vertexalpha"] = 1,
	["$translucent"] = 1,
	["$alpha"] = 1,
	["$nolod"] = 1,
	["$basetexturetransform"] = "center .5 .5 scale -0.8 0.8 rotate 0 translate 0 0",
})
local mat_cover = CreateMaterial(mat_cover_name, "UnlitGeneric", {
	["$vertexcolor"] = template:GetInt("$vertexcolor"),
	["$vertexalpha"] = template:GetInt("$vertexalpha"),
	["$translucent"] = template:GetInt("$translucent"),
	["$alpha"] = 1,
	["$nolod"] = template:GetInt("$nolod"),
	["$basetexture"] = self.Mat:GetTexture("$basetexture"):GetName(),
	["$basetexturetransform"] = template:GetMatrix("$basetexturetransform"),
})
mat_cover:SetInt("$vertexcolor", template:GetInt("$vertexcolor"))
mat_cover:SetInt("$vertexalpha", template:GetInt("$vertexalpha"))
mat_cover:SetInt("$translucent", 1)
mat_cover:SetInt("$nolod", template:GetInt("$nolod"))
mat_cover:SetFloat("$alpha", 0.99)
mat_cover:SetVector("$color", Vector(0.5, 0.5, 0.5) + ( render.ComputeLighting(mirror_center, mirror_normal)))
if IsValid(tex.Entity) then
mat_cover:SetVector("$color", Vector(0.5, 0.5, 0.5) + ( render.ComputeLighting(tex.Entity:LocalToWorld(mirror_center), self:GetUp())))
end
mat_cover:SetMatrix("$basetexturetransform", template:GetMatrix("$basetexturetransform"))
mat_cover:SetTexture("$basetexture", self.Mat:GetTexture("$basetexture"))

mat_cover2 = Material("models/hdm/mirror_cover")

local view = {}
view.dopostprocess = false
view.drawhud       = false
view.drawmonitors  = false
view.drawviewmodel = false
view.fov           = 90+16
view.znear         = 1
view.zfar          = 10000
view.x           = 0
view.y           = 0
view.w           = ScrW()
view.h           = ScrH()
view.aspectratio = ScrW() / ScrH()

local function CalcData()
	if not mirror_center or not mirror_normal then
		local trace   = LocalPlayer():GetEyeTrace()
		mirror_center  = trace.HitPos
		mirror_normal  = trace.HitNormal
	end
end

local function Mirror(vec, normal)
	local ret = vec - 2*(vec:Dot(normal))*normal
	-- if normal:Dot(Vector(0,0,1)) > 0.9 then
	-- return normal
	-- end
	-- local ang = ret:Angle()
	-- ang.p = (vec):Angle().p
	-- ret = ang:Forward()
	return ret
end
local tag = self:EntIndex()
hook.Add("RenderScene", "mirror"..tag, function(origin, angles, fov)
	if !IsValid(self) or !IsValid(self.Wep) or !self.Wep.GetStand then hook.Remove("RenderScene", "mirror"..tag) end
	if IsValid(self) and IsValid(self.Wep) and self.Wep.GetStand then
	if indraw then return end
	indraw = true
	
	CalcData()
	
	local origin_local = origin-mirror_center
	if IsValid(tex.Entity) then
		origin_local = origin-tex.Entity:LocalToWorld(mirror_center)
	end
	local mirror_angle = self:GetUp():Angle()
	local scalar_forward = self:GetUp():Dot(origin_local)
	
	view.origin = origin - 2 * scalar_forward * self:GetUp()
	view.angles = Mirror(angles:Forward(), -self:GetUp()):Angle()
	view.fov = fov
	
	local render_target = render.GetRenderTarget()
	render.SetRenderTarget(tex_scene)
		local w,h = ScrW(), ScrH()
		render.Clear(0, 0, 0, 255)
		render.ClearDepth()
		render.SetViewPort(0, 0, self.Maxs:Length(), self.Maxs:Length())
			cam.Start2D()
				local normal = self:GetUp()
				local position = normal:Dot(self:GetPos())
				render.EnableClipping(true)
					render.PushCustomClipPlane(normal, position)
					draw_player = true
					DRAW_HANGED_MAN = self.Wep:GetStand():EntIndex()
						local nodraw
						if IsValid(tex.Entity) then
						nodraw = tex.Entity:GetNoDraw()
						tex.Entity:SetNoDraw(true)
						end
						if ConvarDrawMirror:GetBool() then
							render.RenderView(view)
						end
						if IsValid(tex.Entity) then
						tex.Entity:SetNoDraw(nodraw)
						end
						DRAW_HANGED_MAN = 0
					draw_player = nil
					render.PopCustomClipPlane()
				render.EnableClipping(false)
			cam.End2D()
		render.SetViewPort(0, 0, w, h)
	render.SetRenderTarget(render_target)
	
	indraw = false
	end
end)
hook.Add("PostDrawOpaqueRenderables", "mirror"..tag, function()
	if !IsValid(self) or !IsValid(self.Wep) or !self.Wep.GetStand then hook.Remove("PostDrawOpaqueRenderables", "mirror"..tag) end
	if IsValid(self) and IsValid(self.Wep) and self.Wep.GetStand then
	if self.pewcent > 0.1 then
		render.SetColorMaterial()
		render.DrawBeam(LerpVector(self.pewcent, self:GetPos(), self:GetOldMirror()), self:GetPos(), 5 * self.pewcent, 0, 0, Color(255,255,150))
		self.pewcent = self.pewcent - 0.02
		if self.pewcent > 0.8 then
			local fx = EffectData()
			fx:SetOrigin(self:GetPos() + self:GetUp() * 3)
			fx:SetNormal(self:GetUp())
			fx:SetRadius(48)
			util.Effect("AR2Explosion", fx, true, true)
		end
		render.MaterialOverride()
	end
	if indraw then return end
	indraw = true
	
	CalcData()
	
	local trace   = LocalPlayer():GetEyeTrace()
	trace_center  = trace.HitPos
	trace_normal  = trace.HitNormal
	
	render.ClearStencil()
	render.SetStencilEnable(true)
		
		render.SetStencilWriteMask(255)
		render.SetStencilTestMask(255)
		
		render.SetStencilReferenceValue (1)
		render.SetStencilFailOperation  (STENCILOPERATION_KEEP)
		render.SetStencilZFailOperation (STENCILOPERATION_KEEP)
		render.SetStencilPassOperation  (STENCILOPERATION_REPLACE)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
		
		render.SetMaterial(mat_white)
		
	local centerpos = mirror_center
	if IsValid(tex.Entity) then
		centerpos = tex.Entity:LocalToWorld(mirror_center)
	end
	if IsValid(ent) and !ent:IsWorld() and !EyeMode then
		local normal = self:GetUp()
		local position = normal:Dot(centerpos - normal * 2)
		render.EnableClipping(true)
			render.PushCustomClipPlane(normal, position)
					ent:DrawModel()
			render.PopCustomClipPlane()
		render.EnableClipping(false)

	end
	local nodraw = Material("models/hdm/nodraw_mat")
	local white = Material("models/debug/debugwhite")
	if IsValid(ent) and !ent:IsWorld() and EyeMode then
		local color = ent:GetColor()
		local rendermode = ent:GetRenderMode()
		self.MatTable = self.MatTable or {}
		self.MatTableIsEyes = self.MatTableIsEyes or {}
		self.Materials = self.Materials or ent:GetMaterials()
		render.MaterialOverride(nodraw)
		for k,v in pairs(self.Materials) do
			local mat = self.MatTable[k] or Material(v)
			self.MatTable[k] = mat
			self.MatTableIsEyes[k] = self.MatTableIsEyes[k] or string.StartWith(mat:GetShader(),"Eye")
			if self.MatTableIsEyes[k] then
				render.MaterialOverrideByIndex(k-1, white)
			end
		end
		ent:DrawModel()
		for k,v in pairs(self.Materials) do
			local mat = self.MatTable[k] or Material(v)
			self.MatTable[k] = mat
			self.MatTableIsEyes[k] = self.MatTableIsEyes[k] or string.StartWith(mat:GetShader(),"Eye")
			if self.MatTableIsEyes[k] then
				render.MaterialOverrideByIndex(k-1)
			end
		end
		render.MaterialOverride()
	end
	if ent:IsWorld() or tex.MatType == MAT_SLOSH then
		render.DrawQuadEasy(centerpos, self:GetUp(), mirror_width , mirror_height, Color(255,255,255,255), 0)
	end
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
		render.SetMaterial(mat_scene)
		render.DrawScreenQuad()

		DrawColorModify({
							[ "$pp_colour_addr" ] = 0.15,
							[ "$pp_colour_addg" ] = 0,
							[ "$pp_colour_addb" ] = 0.15,
							[ "$pp_colour_brightness" ] = -0.1,
							[ "$pp_colour_contrast" ] = 1,
							[ "$pp_colour_colour" ] = 0.6,
							[ "$pp_colour_mulr" ] = 0.02,
							[ "$pp_colour_mulg" ] = 0,
							[ "$pp_colour_mulb" ] = 0.02
						})
						
	render.SetMaterial(mat_cover2)
	render.DrawQuadEasy(centerpos + self:GetUp() * 0.4, self:GetUp(), mirror_width * 5, mirror_height * 5, Color(0,0,0,0), 45)
	render.SetStencilEnable(false)
	if ent:IsWorld() then
		render.SetMaterial(mat_cover)
		render.DrawQuadEasy(centerpos, self:GetUp(), mirror_width, mirror_height, Color(0,0,0,255), 180)
	end
	indraw = false
	end
	render.MaterialOverride()
	render.SetBlend(1)
	render.SetColorModulation(1,1,1)
end)


hook.Add("ShouldDrawLocalPlayer", "mirror"..tag, function()
	if indraw and draw_player then
	end
end)
end
end
function ENT:FindCorners()
	local norm = (self:GetForward() + self:GetRight()):GetNormalized()
	self.Maxs = self:GetPos() + norm * 15
	self.Mins = self:GetPos() - norm * 15
	for i=0, 75 do
		local tr1 = util.TraceLine(
		{
			start=(self:GetPos() +  norm * i) + self:GetUp() * 15,
			endpos = (self:GetPos() +  norm * i)- self:GetUp() * 15,
			filter={self},
			mask=MASK_ALL
		})
		if tr1.Hit then
			self.Maxs = tr1.HitPos + self:GetUp() * 4
		end
		local tr2 = util.TraceLine(
		{
			start=(self:GetPos() -  norm * i) + self:GetUp() * 15,
			endpos = (self:GetPos() -  norm * i)- self:GetUp() * 15,
			filter= {self}
		})
		if tr2.Hit then
			self.Mins = tr2.HitPos + self:GetUp() * 4
		end
	end
end

function ENT:OnRemove()
	hook.Remove("RenderScene", "mirror"..self:EntIndex())

hook.Remove("PreDrawOpaqueRenderables", "mirror"..self:EntIndex())
	if self.Wep:GetState() == 2 then
	self.Wep:SetState(0)
	self.Wep:GetStand():SetInDoDoDo(false)
	end
	
end
function ENT:FindNewLocation()
	if SERVER then
		for k,v in pairs(self.traces) do
			local ang = v:Angle()
			local norma = v + self:GetUp()
			local tr = util.TraceLine( {
				start = self:GetPos(),
				endpos = self:GetPos() + norma * (5000),
				filter = { self, self.Owner},
			} )
			if tr.Hit and self.Wep:CheckReflectivityOfSurface(tr) and norma:Dot(self:GetUp()) > 0 and tr.Fraction > 0.01 then
				local pos = self.Owner:EyePos()
				if IsValid(self) then
					pos = self:GetPos()
				end
				self.Wep:SetMirror(ents.Create("hangedmansurface"))
				self.Wep:GetMirror():SetPos(tr.HitPos)
				self.Wep:GetMirror():SetOwner(self.Owner)
				self.Wep:GetMirror():SetAngles(tr.HitNormal:Angle() + Angle(90, 0, 0))
				if tr.Entity:IsValid() and (tr.Entity:IsPlayer() or tr.Entity:IsNPC()) then
					self.Wep:GetMirror():SetPos(tr.Entity:EyePos())
					self.Wep:GetMirror():SetAngles(tr.Entity:GetAngles() + Angle(90, 0, 0))
				end
				self.Wep:GetMirror():Spawn()
				self.Wep:GetMirror():SetOldMirror(pos)
				
				return
			end
			
		end
	end
end
function ENT:OnTakeDamage(dmg)
	if SERVER and dmg:GetAttacker():IsPlayer() and self:GetParent() != dmg:GetAttacker() then
		local pos = self:GetPos()
		if IsValid(self.Wep:GetMirror()) then
			self:Remove()
		end
		self.Wep:SetMirror(ents.Create("hangedmansurface"))
		self.Wep:GetMirror():SetPos(dmg:GetAttacker():EyePos())
		self.Wep:GetMirror():SetOwner(self.Owner)
		self.Wep:GetMirror():SetAngles(dmg:GetAttacker():GetAngles() + Angle(90, 0, 0))
		self.Wep:GetMirror():Spawn()
		self.Wep:GetMirror():SetOldMirror(pos)
		if IsValid(dmg:GetAttacker():GetActiveWeapon()) and dmg:GetAttacker():GetActiveWeapon().GetStand then
			if dmg:GetAttacker():GetActiveWeapon():GetStand().Speed <= 1.25 * 20 then
				dmg:SetDamage(dmg:GetDamage() * 2)
				self.Owner:TakeDamageInfo(dmg)
			end
		end
	end
end

function ENT:DrawTranslucent()
	for k,v in pairs(self.traces) do
		local norma = v + self:GetUp()
		local tr = util.TraceLine( {
			start = self:GetPos(),
			endpos = self:GetPos() + norma * 5000,
			filter = { self, self.Owner},
		} )

		if GetConVar("gstands_show_hitboxes"):GetBool() and IsValid(self.Wep) and self.Wep.CheckReflectivityOfSurface and tr.Hit and self.Wep:CheckReflectivityOfSurface(tr) and tr.Normal:Dot(self:GetUp()) > 0 then
								render.DrawLine(self:GetPos(), tr.HitPos, Color(255,0,0), true)

			break
		end
	end
end
function ENT:Think()
	if SERVER and IsValid(self:GetParent()) and (self:GetParent():IsPlayer() or self:GetParent():IsNPC()) and self:GetParent():Health() < 1 and !self:GetParent():IsWorld() then
		self:Remove()
		self:FindNewLocation()
	end
	self:NextThink(CurTime())
	return true
end