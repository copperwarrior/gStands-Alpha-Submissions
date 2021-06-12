ENT.Type 			    = "anim"
ENT.PrintName		    = "#gstands.general.standarrow"
ENT.Author			    = "Copper"
ENT.Contact			    = ""
ENT.Purpose			    = "#gstands.general.standarrow.purpose"
ENT.Category			= "gStands"
ENT.Instructions		= ""
ENT.Spawnable			= true
ENT.AdminOnly           = true 


if SERVER then

AddCSLuaFile("shared.lua")

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
local standList = {}
function ENT:Initialize()
	local Weapons = weapons.GetList()
	for k, weapon in pairs( Weapons ) do

		if ( !string.StartWith( weapon.ClassName, "gstands_" ) or weapon.ClassName == "gstands_copper" ) then continue end
		table.insert( standList, weapon.ClassName )

	end
	self:SetModel("models/stand_arrow/stand_arrow_long.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	--self.NextThink = CurTime() +  1

	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(10)
	end

	util.PrecacheSound("physics/metal/metal_grenade_impact_hard3.wav")
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard2.wav")
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet2.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet3.wav")

	self.Hit = { 
	Sound("physics/metal/metal_grenade_impact_hard1.wav"),
	Sound("physics/metal/metal_grenade_impact_hard2.wav"),
	Sound("physics/metal/metal_grenade_impact_hard3.wav")};

	self.FleshHit = { 
	Sound("physics/flesh/flesh_impact_bullet1.wav"),
	Sound("physics/flesh/flesh_impact_bullet2.wav"),
	Sound("physics/flesh/flesh_impact_bullet3.wav")}

	self:GetPhysicsObject():SetMass(2)	

	self.CanTool = false
    
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
	if not IsValid(self) then return end
	if not IsValid(self.Entity) then return end
    local give = true
	local closest = GetArrowClosest(self:GetPos())
            for i,j in pairs(standList) do
            if closest ~= NULL and closest:IsValid() and closest:HasWeapon(j) then
                give = false
			end
		end
    if give and closest:IsValid() and closest:Health() > 0 then
    self:PointAtVec(GetArrowClosest(self:GetPos()):LocalToWorld(GetArrowClosest(self:GetPos()):GetPhysicsObject():GetMassCenter()))
    self:GetPhysicsObject():SetVelocity((self:GetForward()) * 250)
        	self:GetPhysicsObject():EnableGravity(false)
    
    else
    	self:GetPhysicsObject():EnableGravity(true)
    end
    self:NextThink(CurTime() + 0.1)
    return true
end

function ENT:PointAtVec(vec)
  local dir = vec - self:GetPos()
  local cur = self:GetAngles()
  local diff = dir:Angle() - cur 
  print(diff.y)
  if math.Round(diff.y) >= 30 and math.Round(diff.y) <= 330 or math.Round(diff.y) <= -30 and math.Round(diff.y) >= -330 then
  self:SetAngles(Angle(0, cur.y + (diff.y / math.abs(diff.y)) * 20 ,0))
	elseif math.Round(diff.y) >= 330 or math.Round(diff.y) <= -330 or math.Round(diff.y) <= 30 or math.Round(diff.y) >= -30 then
	 	self:SetAngles(dir:Angle())
	end

	//self:SetAngles(dir:Angle())
end

function GetArrowClosest(vec)
	local closestply
	local closestdist
	for k, v in pairs(ents.FindInSphere(vec, 600)) do
		if v:IsPlayer() then
			if v:Alive() == false then return NULL end

			local dist = vec:DistToSqr(v:GetPos())
			local skip = false
			for i,j in pairs(standList) do
				if v:HasWeapon(j) then
					skip = true
				end
			end
			if not closestdist and !skip then
				closestdist = dist
				closestply = v
			end
			if !skip and dist <= closestdist then
				closestply = v
			end
		end
	end
	if !closestply then
		return NULL
	end
	return closestply
end

/*---------------------------------------------------------
   Name: ENT:Disable()
---------------------------------------------------------*/
function ENT:Disable()

	self.PhysicsCollide = function() end
	self.lifetime = CurTime() + 5

	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.Entity:SetOwner(NUL)
end

function ENT:Touch(data)
	
	local Ent = data
	if not (Ent:IsValid() or Ent:IsWorld()) then return NULL end
	
		if (Ent:IsPlayer()) then 
            local give = true
            for k,v in pairs(standList) do
            if Ent:HasWeapon(v) then
                give = false
			end
			end

            
            if give then
            	local standname = "gstands_hermit_purple"
            	local randomnum = math.random(1, 3)
            	if randomnum == 3 then
            		standname = "gstands_hermit_purple_2"
            	end
            	if Ent:GetWeapon("hamon"):IsValid() then
                Ent:Give(standname) 
                Ent:SelectWeapon(standname) 	
            	else
                local stand = standList[math.random(0, #standList)]
                Ent:Give(stand) 
                Ent:SelectWeapon(stand) 
            end

			local effectdata = EffectData()
			effectdata:SetStart(data:GetPos())
			effectdata:SetOrigin(data:GetPos())
			effectdata:SetScale(1)
			util.Effect("BloodImpact", effectdata)
			self:EmitSound(self.FleshHit[math.random(1,#self.Hit)])                
            end            			
		end
		

end

end

if CLIENT then
/*---------------------------------------------------------
   Name: ENT:Draw()
---------------------------------------------------------*/
function ENT:Draw()
	self.Entity:DrawModel()
end
end
