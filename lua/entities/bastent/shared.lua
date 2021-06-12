ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName= "#gstands.names.bastet"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "To stand"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
ENT.Animated = true
ENT.target = {}
local power = 400
function ENT:Initialize()
	self.Owner:SetNWBool("Active_"..self.Owner:GetName(), false)
	--Initial animation base
	if SERVER then
		self:SetTrigger(true)
		self:SetUseType(CONTINUOUS_USE)
		self:SetSolid(SOLID_OBB)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS )
	end
end

function ENT:Think()
	if IsValid(self.Owner) then 
		if power >= 400 and table.Count(self.target) > 0 then
			self.Owner:ChatPrint("#gstands.bastet.magnetism.one")
		end
		if power == 325 then
			self.Owner:ChatPrint("#gstands.bastet.magnetism.twentyfive")
		end
		if power == 250 then
			self.Owner:ChatPrint("#gstands.bastet.magnetism.fifty")
		end
		if power == 75 then
			self.Owner:ChatPrint("#gstands.bastet.magnetism.seventyfive")
		end
		if power == 100 then
			self.Owner:ChatPrint("#gstands.bastet.magnetism.full")
		end
	end
	if SERVER and table.Count(self.target) > 0 and power <= 400 and power >= 100 then
		power = power - 0.5
	end
	for k,v in pairs(self.target) do
		if (v:IsPlayer() or v:IsNPC()) and v:IsValid() and !(v.Alive and v:Alive()) then
			self.target[k] = nil
			power = 400
		end
	end
	for k,v in pairs(ents.FindInSphere(self:GetPos(), 75)) do
		if v:IsPlayer() or v:IsNPC() then
			self:Use(v, v, USE_ON, 1)
		end
	end
	for k,v in pairs(self.target) do
		if v:IsValid() and IsValid(self.Owner) then
			for i,j in pairs(ents.FindInSphere(v:GetPos(), (1000 + (400 - power)))) do
				local mult = (2000 - self.Owner:WorldSpaceCenter():Distance(v:GetPos())) / power
				if mult < 0 then
					mult = 0
				end
				if v:Health() > 0 and v:Alive() then
					if v:GetPhysicsObject():IsValid() and j:GetPhysicsObject():IsValid() and j != v and string.StartWith(j:GetPhysicsObject():GetMaterial(), "metal") then
						j:GetPhysicsObject():ApplyForceCenter((v:LocalToWorld(v:GetPhysicsObject():GetMassCenter()) - j:GetPos()):GetNormalized() * (((1000 + (400 - power)) - j:GetPos():Distance(v:GetPos())) * mult))
					end
					if table.HasValue(self.target,j) and v:GetPhysicsObject():IsValid() and j:GetPhysicsObject():IsValid() and j != v and (j:IsPlayer() or j:IsNPC()) and j:IsOnGround() then
						j:SetVelocity((v:LocalToWorld(v:GetPhysicsObject():GetMassCenter()) - j:GetPos()):GetNormalized() * ((1000 + (400 - power)) - j:GetPos():Distance(v:GetPos()))/3)
					end  
				end
				end 
			end
		end
		for i=0,100 do
		self:SetSubMaterial(i)
		self:SetMaterial()
		self:SetColor(color_white)
	end
end
function ENT:Touch(ent)
	if ent:IsPlayer() or ent:IsNPC() then
		self:Use(ent, ent, USE_ON, 1)
	end
end
function ENT:Use(plr)
	if !table.HasValue(self.target,plr) and plr != self.Owner and SERVER and plr:Alive() then
		local tr = util.TraceLine( {
					start = self:WorldSpaceCenter(),
					endpos = plr:WorldSpaceCenter(),
					filter = {self.Owner, self},
					mask = MASK_SHOT_HULL
			} )
		if tr.Entity == plr then
			local dmginfo = DamageInfo()			
			local attacker = self.Owner
			dmginfo:SetAttacker( attacker )
			
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( 1 )
			
			dmginfo:SetDamageType(DMG_SHOCK)
			tr.Entity:TakeDamageInfo( dmginfo )
			tr.Entity:SetVelocity(tr.Normal * 275)
			if SERVER then
				local str1 = tostring(200)
				local str2 = tostring(200)
				local str3 = tostring(255)
				local str4 = str1.." "..str2.." "..str3.." ".."255"
				local light = ents.Create("light_dynamic")
				light:SetPos(self:WorldSpaceCenter() + self:GetForward() * 15)
				light:Spawn()
				light:Activate()
				light:SetKeyValue("distance", 150)
				light:SetKeyValue("brightness", 5)
				light:SetKeyValue("_light", "200 200 255 255")
				light:Fire("TurnOn")
				light:SetParent(self)
				timer.Simple(0.1, function() light:SetKeyValue("brightness", 0) end)
				timer.Simple(0.15, function() light:Remove() end)
			end
			self:EmitSound("ambient/energy/newspark0"..math.random(1,9)..".wav")
			local fxd = EffectData()
			fxd:SetOrigin(plr:GetPos())
			fxd:SetEntity(self)
			fxd:SetMagnitude(10)
			fxd:SetScale(10)
			util.Effect("TeslaZap", fxd)
			table.insert(self.target, #self.target, plr)
		end
	end
end
function ENT:OnRemove()
	self.target = {}
end