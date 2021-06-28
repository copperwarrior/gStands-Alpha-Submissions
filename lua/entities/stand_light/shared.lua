ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName= "Stand Light"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "To stand"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true
ENT.Animated = true
if SERVER then
		AddCSLuaFile("shared.lua")

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "R")
	self:NetworkVar("Float", 1, "G")
	self:NetworkVar("Float", 2, "B")
	self:NetworkVar("Float", 3, "Brightness")
	self:NetworkVar("Float", 4, "Decay")
	self:NetworkVar("Float", 5, "Size")
	self:NetworkVar("Float", 6, "DieTime")
end
function ENT:Initialize()  
	print("Aie!")
	if SERVER then
		local str1 = tostring(self:GetR())
		local str2 = tostring(self:GetR())
		local str3 = tostring(self:GetR())
		local str4 = str1.." "..str2.." "..str3.." ".."255"
		local light = ents.Create("light_dynamic")
		light:SetPos(self:GetPos())
		light:Spawn()
		light:Activate()
		light:SetKeyValue("distance", self:GetSize())
		light:SetKeyValue("brightness", 5)
		light:SetKeyValue("_light", str4)
		light:Fire("TurnOn")
	end
end
function ENT:OnRemove()
		self.Light:Remove()
end

function ENT:Think()
	-- if SERVER and CurTime() >= self:GetDieTime() then

		-- self:Remove()
	-- end
	self:NextThink(CurTime())
	return true
end
end
function ENT:Draw()
	if IsPlayerStandUser(LocalPlayer()) and GetConVar("gstands_light"):GetBool() then
		self.Light:SetNoDraw(false)
	else
		self.Light:SetNoDraw(true)
	end
end