ENT.Type = "anim"
ENT.Base = "stand_player_base"

ENT.PrintName= "Stand"
ENT.Author= "Copper"
ENT.Contact= ""
ENT.Purpose= "To stand"
ENT.Instructions= "How are you reading the instructions? This shouldn't be normally spawnable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.AutomaticFrameAdvance = true
ENT.Animated = true
ENT.Color = Color(150,150,150,1)
ENT.ForceOnce = false
ready = false
ENT.ImageID = 1
ENT.Rate = 0
ENT.Health = 1
ENT.rgl = 1.3
ENT.ggl = 1.3
ENT.bgl = 1.3
ENT.rglm = 1.3
ENT.gglm = 1.3
ENT.bglm = 1.3
ENT.FlameFX = nil
ENT.PhysgunDisabled = true
ENT.Range = 150
ENT.ItemPickedUp = NUL
ENT.Speed = 1
ENT.POWER = 1
ENT.Flashlight = self
ENT.Model = ""
ENT.OwnerName = ""
ENT.RotateSpeed = 1
ENT.AnimSet = {
	"SWIMMING_FIST", 1,
	"GMOD_BREATH_LAYER", 0.5,
	"AIMLAYER_CAMERA", 0.1,
	"JUMP_FIST", 0.1,
	"FIST_BLOCK", 0.6,
}

game.AddParticles("particles/stand_deploys.pcf")
game.AddParticles("particles/auraeffect.pcf")
game.AddParticles("particles/mblur.pcf")
PrecacheParticleSystem("stand_basic")
PrecacheParticleSystem("auraeffect")
PrecacheParticleSystem("loversaura")
PrecacheParticleSystem("succ")
PrecacheParticleSystem("standblock")
PrecacheParticleSystem("emerald_trail")

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 1, "CenterImage")
	self:NetworkVar("Int", 2, "ImageID")
	self:NetworkVar("Angle", 3, "IdealAngles")
	self:NetworkVar("Vector", 4, "IdealPos")
	self:NetworkVar("Float", 5, "Range")
	self:NetworkVar("Entity", 6, "AITarget")
	self:NetworkVar("Bool", 7, "BlockCap")
	self:NetworkVar("Bool", 8, "MarkedToFade")
	self:NetworkVar("Entity", 9, "Image")
	self:NetworkVar("Bool", 10, "InDoDoDo")
	self:NetworkVar("Bool", 11, "InStill")
	self:NetworkVar("Bool", 12, "Frozen")
	self:NetworkVar("Vector", 13, "HEGEndPos")
end
function math.ApproachVector(current, target, change)
	local xc = current.x
	local yc = current.y
	local zc = current.z
	local xt = target.x
	local yt = target.y
	local zt = target.z
	local x = math.Approach(xc, xt, change)
	local y = math.Approach(yc, yt, change)
	local z = math.Approach(zc, zt, change)
	return Vector(x,y,z)
end

function ENT:GetEyePos(head)
	if !head then head = false end
	if self:GetInDoDoDo() or head then
		local att = self:LookupAttachment("anim_attachment_head")
		local tab = self:GetAttachment(att)
		if !tab then
			tab = {}
			tab.Pos = self:WorldSpaceCenter()
		end
		return tab.Pos or self:WorldSpaceCenter()
		else
		return self.Owner:EyePos()
	end
end
