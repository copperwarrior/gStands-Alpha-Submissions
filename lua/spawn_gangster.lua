local tr = Entity(1):GetEyeTrace()
local puppeteer = ents.Create("npc_citizen")
puppeteer:SetPos(tr.HitPos)
puppeteer:Spawn()
puppeteer:Activate()
puppeteer:Give("weapon_stunstick")
puppeteer:SetEnemy(Entity(1))
puppeteer:SetTarget(Entity(1))
puppeteer:AddEntityRelationship(Entity(1), D_HT, 99)
local puppet = ents.Create("prop_dynamic")

local deadmanmod = {"models/player/gaara/buccellati.mdl",
"models/player/gaara/giorno.mdl",
"models/player/gaara/mista.mdl",
"models/player/gaara/fugo.mdl"}
  if IsValid(puppet) then
	puppeteer:AddEffects(EF_NODRAW)
	puppet:SetModel(table.Random(deadmanmod))
	puppet:Spawn()
	puppet:Activate()
	local propAttachments = puppet:GetAttachments()
	if #puppeteer:GetAttachments() > 0 and #propAttachments > 0 then
		puppet:SetNotSolid(true)
		puppet:AddEffects( EF_BONEMERGE || EF_BONEMERGE_FASTCULL || EF_PARENT_ANIMATES)
		puppet:SetParent(puppeteer)
		puppet:Fire("Setparentattachment",  puppeteer:GetAttachments()[1].name)
	end
end