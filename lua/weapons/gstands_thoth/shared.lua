--Send file to clients
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.Slot	  = 1
end

SWEP.DevPos = E 
SWEP.Power = 1 
SWEP.Speed = 1.8 
SWEP.Range = 100 
SWEP.Durability = 1500 
SWEP.Precision = E 

SWEP.Author		= "Copper"
SWEP.Purpose	   = "#gstands.tohth.purpose"
SWEP.Instructions  = "#gstands.tohth.instructions"
SWEP.Spawnable	 = true
SWEP.Base		  = "weapon_base"   
SWEP.Category	  = "gStands"
SWEP.PrintName	 = "#gstands.names.tohth"

if CLIENT then
	SWEP.PrintName = language.GetPhrase(SWEP.PrintName)
	SWEP.Purpose = language.GetPhrase(SWEP.Purpose)
	SWEP.Instructions = language.GetPhrase(SWEP.Instructions)
end
SWEP.SlotPos			= 2
SWEP.DrawCrosshair	  = true

SWEP.WorldModel = "models/tohth/thoth.mdl"
SWEP.ViewModel = "models/tohth/c_thoth.mdl"
SWEP.ViewModelFOV = 70
SWEP.UseHands = true

SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "emp_bul"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = true
SWEP.HitDistance = 48
SWEP.gStands_IsThirdPerson = false

local ActIndex = {
	[ "pistol" ]		= ACT_HL2MP_IDLE_PISTOL,
	[ "smg" ]			= ACT_HL2MP_IDLE_SMG1,
	[ "grenade" ]		= ACT_HL2MP_IDLE_GRENADE,
	[ "ar2" ]			= ACT_HL2MP_IDLE_AR2,
	[ "shotgun" ]		= ACT_HL2MP_IDLE_SHOTGUN,
	[ "rpg" ]			= ACT_HL2MP_IDLE_RPG,
	[ "physgun" ]		= ACT_HL2MP_IDLE_PHYSGUN,
	[ "crossbow" ]		= ACT_HL2MP_IDLE_CROSSBOW,
	[ "melee" ]			= ACT_HL2MP_IDLE_MELEE,
	[ "slam" ]			= ACT_HL2MP_IDLE_SLAM,
	[ "normal" ]		= ACT_HL2MP_IDLE,
	[ "fist" ]			= ACT_HL2MP_IDLE_FIST,
	[ "melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
	[ "passive" ]		= ACT_HL2MP_IDLE_PASSIVE,
	[ "knife" ]			= ACT_HL2MP_IDLE_KNIFE,
	[ "duel" ]			= ACT_HL2MP_IDLE_DUEL,
	[ "camera" ]		= ACT_HL2MP_IDLE_CAMERA,
	[ "magic" ]			= ACT_HL2MP_IDLE_MAGIC,
	[ "revolver" ]		= ACT_HL2MP_IDLE_REVOLVER,
	[ "stando" ]		= ACT_HL2MP_IDLE
	
}

function SWEP:SetWeaponHoldType( t )
	
	t = string.lower( t )
	local index = ActIndex[ t ]
	
	if ( index == nil ) then
		Msg( "SWEP:SetWeaponHoldType - ActIndex[ \"" .. t .. "\" ] isn't set! (defaulting to normal)\n" )
		t = "normal"
		index = ActIndex[ t ]
	end
	if ( t == "stando" ) then
		self.ActivityTranslate = {}
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= index
		self.ActivityTranslate[ ACT_MP_WALK ]						= index + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_HL2MP_RUN_FAST
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= index + 3
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_slam"))
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("range_slam"))
		self.ActivityTranslate[ ACT_MP_JUMP ]						= self.Owner:GetSequenceActivity(self.Owner:LookupSequence("jump_knife"))
		self.ActivityTranslate[ ACT_RANGE_ATTACK1 ]					= index + 8
		self.ActivityTranslate[ ACT_MP_SWIM ]						= index + 9
		else
		self.ActivityTranslate = {}
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= index
		self.ActivityTranslate[ ACT_MP_WALK ]						= index + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= index + 2
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= index + 3
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= index + 6
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= index + 6
		self.ActivityTranslate[ ACT_MP_JUMP ]						= index + 7
		self.ActivityTranslate[ ACT_RANGE_ATTACK1 ]					= index + 8
		self.ActivityTranslate[ ACT_MP_SWIM ]						= index + 9
	end
	-- "normal" jump animation doesn't exist
	if ( t == "normal" ) then
		self.ActivityTranslate[ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end
	
	
end

--Define swing and hit sounds. Might change these later.
local Page = Sound("weapons/tohth/pageflip.wav")
local Deploy = Sound( "weapons/tohth/deploy.wav" )
function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "ID")
	self:NetworkVar("Entity", 1, "Target1")
	self:NetworkVar("Bool", 2, "QuestComplete")
	self:NetworkVar("Entity", 3, "Target2")
end

function SWEP:Initialize()
end
local quests = {
	"#gstands.tohth.old.page1",
	"#gstands.tohth.old.page2",
	"#gstands.tohth.old.page3",
	"#gstands.tohth.old.page4",
	"#gstands.tohth.old.page5",
	"#gstands.tohth.old.page6",
	"#gstands.tohth.old.page7",
	"#gstands.tohth.old.page8",
	"#gstands.tohth.old.page9",
	"#gstands.tohth.old.page10",
	"#gstands.tohth.old.page11",
	"#gstands.tohth.old.page12",
}

local questfuncsstart = {
	function(self, target1, target2) 
		local tag = target1:Name()
		hook.Add("EntityTakeDamage", "TohthQuestCarCrash"..tag, function(ent, dmg)
			if IsValid(self) then
				if !self:GetQuestComplete() and ent == target2 and dmg:GetAttacker():IsVehicle() and dmg:GetAttacker():GetDriver() == target1 and dmg:GetInflictor():IsVehicle() and dmg:GetDamage() >= ent:Health() then
					self:SetQuestComplete(true)
				end
				else
				hook.Remove("EntityTakeDamage", "TohthQuestCarCrash"..tag)
			end
		end)
	end,
	function(self, target1, target2) 
		local tag = target1:Name()
		hook.Add("EntityTakeDamage", "TohthQuestSlapMoney"..tag, function(ent, dmg)
			if IsValid(self) then		
				if self and self.GetQuestComplete and !self:GetQuestComplete() and ent == target2 and dmg:GetAttacker() == target1 then
					for i = 0, 10 do
						local mon = ents.Create("prop_physics")
						mon:SetModel("models/gold/gstands_gold.mdl")
						mon:SetPos(target1:EyePos() + target1:GetAimVector() * 5)
						mon:Spawn()
						mon:Activate()
						mon:GetPhysicsObject():SetMass(5)
					end
					self:SetQuestComplete(true)
				end
				else
				hook.Remove("EntityTakeDamage", "TohthQuestSlapMoney"..tag)
			end
		end)
	end,
	function(self, target1, target2)
		if SERVER then
		target2:SetMaxHealth(target2:GetMaxHealth() + 20)
		target2:SetHealth(target2:Health() + 20)
		target1:SetMaxHealth(target1:GetMaxHealth() + 20)
		target1:SetHealth(target1:Health() + 20)
		end
	end,
	function(self, target1, target2)
		if SERVER then
		target2:SetArmor(100)
		end
	end,
	function(self, target1, target2)
		if SERVER then
		target1:SetArmor(100)
		end
	end,
	function(self, target1, target2) 
		local tag = target1:Name()
		hook.Add("EntityTakeDamage", "TohthQuestBoom"..tag, function(ent, dmg)
			if IsValid(self) then		
				if self and self.GetQuestComplete and !self:GetQuestComplete() and ent:IsPlayer() and dmg:GetAttacker() == target1 and dmg:IsExplosionDamage() then
					self:SetQuestComplete(true)
				end
				else
				hook.Remove("EntityTakeDamage", "TohthQuestBoom"..tag)
			end
		end)
	end,
	function(self, target1, target2) 
		local tag = target1:Name()
		hook.Add("Think", "TohthBurningSpicy"..tag, function()
		if IsValid(target1) and target1:Alive() then
			if target1:WaterLevel() >= 1 then
				target1:Extinguish()
				self:SetQuestComplete(true)
			elseif SERVER and target1:Alive() then
				target1:Ignite( 30 )
			end
		else
		hook.Remove("Think", "TohthBurningSpicy"..tag)

		end
		end)
	end,
	function(self, target1, target2) 
		local tag = target1:Name()
		target1.LastSpeed = 0
		hook.Add("Think", "TohthRunning"..tag, function()
		if IsValid(target1) and target1:Alive() then
			
			target1.LastSpeed = target1.LastSpeed or math.Round(target1:GetVelocity():Length())
			if math.Round(target1:GetVelocity():Length()) >= math.Round(target1.LastSpeed) then
				target1.LastSpeed = math.Round(target1:GetVelocity():Length())
			elseif SERVER and math.Round(target1.LastSpeed) - math.Round(target1:GetVelocity():Length()) > 100 then
				target1:Kill()
			end

		else
		hook.Remove("Think", "TohthRunning"..tag)

		end
		end)
	end,
	function(self, target1, target2) 
		local tag = target1:Name()
		hook.Add("EntityTakeDamage", "TohthQuestKill"..tag, function(ent, dmg)
			if IsValid(self) then		
				if self and self.GetQuestComplete and !self:GetQuestComplete() and ent:IsPlayer() and ent == target2 and dmg:GetAttacker() == target1 then
					local d = DamageInfo()
					d:SetDamage( target2:Health() + 10000 )
					d:SetAttacker( target1 )
					d:SetInflictor( dmg:GetInflictor() )
					self:SetQuestComplete(true)
					target2:TakeDamageInfo(d)
				end
				else
				hook.Remove("EntityTakeDamage", "TohthQuestKill"..tag)
			end
		end)
	end,
	function(self, target1, target2)
		if SERVER then
		target2.OldJump = target2:GetJumpPower()
		target2:SetJumpPower(target2.OldJump + 200)
		end
	end,
	function(self, target1, target2)
		if SERVER then
		target1.OldJump = target1:GetJumpPower()
		target1:SetJumpPower(target1.OldJump + 200)
		end
	end,
	function(self, target1, target2) 
		local tag = target1:Name()
		hook.Add("EntityTakeDamage", "TohthQuestPunch"..tag, function(ent, dmg)
			if IsValid(self) then		
				if self and self.GetQuestComplete and !self:GetQuestComplete() and ent:IsPlayer() and ent == target2 and dmg:GetAttacker() == target1 and (dmg:GetDamageType() == DMG_CRUSH or dmg:GetDamageType() == DMG_CLUB) then
					self:SetQuestComplete(true)
				end
				else
				hook.Remove("EntityTakeDamage", "TohthQuestPunch"..tag)
			end
		end)
	end,
}

local questfuncsend = {
	function(self) hook.Remove("EntityTakeDamage", "TohthQuestCarCrash"..self:GetTarget1():Name())
		if SERVER and !self:GetQuestComplete() then
			local car = ents.Create("prop_vehicle_jeep")
			car:SetPos(self:GetTarget1():GetPos() + Vector(0,0,400))
			car:SetKeyValue( "vehiclescript", "scripts/vehicles/jeep_test.txt" )
			car:SetModel( "models/buggy.mdl" )
			car:SetVelocity((car:GetPos() - self:GetTarget1():GetPos()) * 125 )
			
			car:Spawn()
			car:Activate()
			timer.Simple(1, function() if car:IsValid() then car:Remove() end end)
		end
	end,
	function(self) hook.Remove("EntityTakeDamage", "TohthQuestSlapMoney"..self:GetTarget1():Name())
		if SERVER and !self:GetQuestComplete() then
			local mon = ents.Create("prop_physics")
			mon:SetModel("models/gold/gstands_gold.mdl")
			mon:SetPos(self:GetTarget1():GetPos() + Vector(0,0,200))
			mon:Spawn()
			mon:Activate()
			mon:GetPhysicsObject():SetVelocity(Vector(0,0,-145))
			mon:GetPhysicsObject():SetMass(50)
			timer.Simple(2, function() mon:Remove() end)
		end
	end,
	function() end,
	function() end,
	function() end,
	function(self) hook.Remove("EntityTakeDamage", "TohthQuestBoom"..self:GetTarget1():Name())
		if SERVER and !self:GetQuestComplete() then
			local fxdata = EffectData()
			fxdata:SetOrigin(self:GetTarget1():GetPos())
			util.Effect("explosion", fxdata, true, true)
			util.BlastDamage(Entity(0), Entity(0), self:GetTarget1():GetPos(), 25, 100)
		end
	end,
	function(self) hook.Remove("Think", "TohthBurningSpicy"..self:GetTarget1():Name())
		if SERVER and !self:GetQuestComplete() then
			local d = DamageInfo()
			d:SetDamage( self:GetTarget1():Health() )
			d:SetAttacker( Entity(0) )
			d:SetInflictor( Entity(0) )
			d:SetDamageType( DMG_BURN )
			self:GetTarget1():TakeDamageInfo(d)
			self:GetTarget1():Extinguish()

		end
	end,
	function(self) hook.Remove("Think", "TohthRunning"..self:GetTarget1():Name())
		if SERVER and !self:GetQuestComplete() then
		
		end
	end,
	function(self) hook.Remove("EntityTakeDamage", "TohthQuestKill"..self:GetTarget1():Name())
	
	end,
	function(self) if SERVER and self:GetTarget2().OldJump then self:GetTarget2():SetJumpPower(self:GetTarget2().OldJump) self:GetTarget2().OldJump = 0 end end,
	function(self) if SERVER and self:GetTarget1().OldJump then self:GetTarget1():SetJumpPower(self:GetTarget1().OldJump) self:GetTarget1().OldJump = 0 end end,
	function(self) hook.Remove("EntityTakeDamage", "TohthQuestPunch"..self:GetTarget1():Name())
		if SERVER and !self:GetQuestComplete() then
			local d = DamageInfo()
			d:SetDamage( self:GetTarget1():Health()/3 )
			d:SetAttacker( self:GetTarget2() )
			d:SetInflictor( self:GetTarget2() )
			d:SetDamageType( DMG_CLUB )
			self:GetTarget1():TakeDamageInfo(d)
		end
	end,
}
function SWEP:GetQuest()
	if SERVER then
		if self:GetID() != 0 then
		self:EmitSound(Page)
		end
		self:SetID(math.random(1,#quests))
		local tab = player.GetAll()
		self:SetTarget1(self.Owner)
		table.RemoveByValue(tab, self:GetTarget1())
		table.RemoveByValue(tab, self.Owner)
		self:SetQuestComplete(false)
		self:SetTarget2(table.Random(tab))
		self.Owner:ChatPrint("#gstands.tohth.newpage")
		
	end
end
if CLIENT then
	local text = "When walking around gm_forkbr, Copper sees their enemy, Zaygh. Boom! A car crash kills them!"
	local panels = {
		Material("vgui/hud/manga1"),
		Material("vgui/hud/manga2"),
		Material("vgui/hud/manga3"),
		Material("vgui/hud/manga4"),
		Material("vgui/hud/manga5"),
		Material("vgui/hud/manga6"),
		Material("vgui/hud/manga7"),
		Material("vgui/hud/manga8"),
		Material("vgui/hud/manga9"),
		Material("vgui/hud/manga10"),
		Material("vgui/hud/manga11"),
		Material("vgui/hud/manga12"),
	}
	local function wrap(str, limit, indent, indent1)
		indent = indent or ""
		indent1 = indent1 or indent
		limit = limit or 72
		local here = 1-#indent1
		return indent1..str:gsub("(%s+)()(%S+)()",
			function(sp, st, word, fi)
				if fi-here > limit then
					here = st - #indent
					return "\n"..indent..word
				end
			end)
	end
	SWEP.ScopeTarg = GetRenderTarget("bookmat", 512, 512, false)
	SWEP.ScopeTarg2 = GetRenderTargetEx("bookmat2", 512, 512, RT_SIZE_OFFSCREEN, MATERIAL_RT_DEPTH_NONE, 0, 0, IMAGE_FORMAT_BGRA8888)
	
	SWEP.Scopemat = Material("models/thoth/bookmat")
	SWEP.Scopemat2 = Material("models/thoth/bookmat2")
	function SWEP:PostDrawViewModel()
		self:DrawRenderTarget()
	end
	function SWEP:DrawRenderTarget()
	if #player.GetAll() > 1 and self:GetTarget2().Name then
		local p = 1
		local text = string.format(language.GetPhrase(quests[self:GetID()]), game.GetMap(), self:GetTarget1():Name(), self:GetTarget2():Name()), 40
		local strRC = string.Explode("\n", wrap(text, 49))
		local x, y = ScrW(), ScrH()
		local oldtarg = render.GetRenderTarget()
		local ang = self.Owner:GetAimVector():Angle()
		
		render.SetRenderTarget(self.ScopeTarg)
		render.SetViewPort(0, 0, 512, 512)
		render.SetBlend(1)
		render.Clear(0,0,0,0)
		local oldW, oldH = ScrW(), ScrH()
		render.SetViewPort( 25, 10, 512, 512 )
		cam.Start2D()
		surface.SetDrawColor( 255, 255, 255 )
		for i = 1, #strRC do
			if i > 19 then
				p = 2
				break
			end
			draw.DrawText( strRC[i], "Trebuchet24", 0, (i-1) * 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT )
		end
		cam.End2D()
		render.SetViewPort( 1, 1, oldW, oldH )
		self.Scopemat:SetTexture("$basetexture", self.ScopeTarg)
		local x, y = ScrW(), ScrH()
		render.SetRenderTarget(self.ScopeTarg2)
		render.SetViewPort(0, 0, 512, 512)
		render.SetBlend(1)
		
		render.Clear(0,0,0,0)
		
		local oldW, oldH = ScrW(), ScrH()
		render.SetViewPort( 0, 0, 512, 512 )
		cam.Start2D()
		surface.SetMaterial(panels[self:GetID()])
		surface.SetDrawColor( 255, 255, 255, 255 )
		
		surface.DrawTexturedRect(0,0,512,512)
		cam.End2D()
		render.SetViewPort( 0, 0, oldW, oldH )
		
		render.SetRenderTarget(oldtarg)
		self.Scopemat2:SetTexture("$basetexture", self.ScopeTarg2)
	end
end
end
function SWEP:PrimaryAttack()
	
end
function SWEP:SecondaryAttack()
end
--Deploy starts up the stand
function SWEP:Deploy()
	self:SetHoldType( "stando" )
	if SERVER then
		if GetConVar("gstands_deploy_sounds"):GetBool() then
			self.Owner:EmitSound(Deploy)
		end
	end
	self:SendWeaponAnim(ACT_VM_DRAW)
	--As is standard with stand addons, set health to 1000
	if SERVER and self.Owner:Health() == 100  then
		self.Owner:SetMaxHealth( self.Durability )
		self.Owner:SetHealth( self.Durability )
	end
	
	--Create some networked variables, solves some issues where multiple people had the same stand
	self.Owner:SetCanZoom(false)
	timer.Create("TohthAnim"..self:EntIndex(), 1.8, 0, function()
		if self:GetActivity() != ACT_VM_PRIMARYATTACK then
		self:SendWeaponAnim(ACT_VM_IDLE) end end)
		local tag = self.Owner:GetName()
			if #player.GetAll() > 1 then

		hook.Add("Think", "TohthThink"..tag, function()
			if IsValid(self) then
				self:Think2()
			else
				hook.Remove("Think", "TohthThink"..tag)
			end
		end)
		
	else
		if SERVER then
		self.Owner:ChatPrint("#gstands.tohth.pagefail")
end
end
end
function SWEP:Think()
	if CLIENT and self.Owner:GetActiveWeapon() == self then
		local angle = LerpAngle(0.1, self.Owner:GetViewModel():GetManipulateBoneAngles( 0 ), Angle(0,-self.Owner:EyeAngles().p/4 + 25,0))
		self.Owner:GetViewModel():ManipulateBoneAngles(0, angle)
		elseif CLIENT then
		self.Owner:GetViewModel():ManipulateBoneAngles(0, Angle(0,0,0))
	end
	if self.Owner:gStandsKeyDown("dododo") then
		self.Menacing = self.Menacing or CurTime()
		if CurTime() > self.Menacing then
			self.Menacing = CurTime() + 0.5
			local effectdata = EffectData()
			effectdata:SetStart(self.Owner:GetPos())
			effectdata:SetOrigin(self.Owner:GetPos())
			effectdata:SetEntity(self.Owner)
			util.Effect("menacing", effectdata)
		end
	end
	self:NextThink(CurTime()) 
	return true
end

function SWEP:Think2()
	if #player.GetAll() > 1 then
		self.timer = self.timer or 0
		if CurTime() > self.timer or self:GetQuestComplete() then
			if self.GetID and self:GetID() != nil and questfuncsend[self:GetID()] then
				questfuncsend[self:GetID()](self)
			end
			self:GetQuest()
			questfuncsstart[self:GetID()](self, self:GetTarget1(), self:GetTarget2())
			self.timer = CurTime() + GetConVar("gstands_tohth_page_timer"):GetFloat()
		end
	end
end

--Screw this entire section, it only works like 20% of the time. Basically, meant to catch every time the weapon is not in your hands in order to remove the stand.
function SWEP:OnDrop()
	
	timer.Remove("TohthAnim"..self:EntIndex())
	if IsValid(self.Owner) and IsValid(self.Owner:GetViewModel()) then
		self.Owner:GetViewModel():ManipulateBoneAngles( 0, Angle(0,0,0) )
	end
	return true
end

function SWEP:OnRemove()
	
	timer.Remove("TohthAnim"..self:EntIndex())
	if IsValid(self.Owner) and IsValid(self.Owner:GetViewModel()) then
		self.Owner:GetViewModel():ManipulateBoneAngles( 0, Angle(0,0,0) )
	end
	return true
end

function SWEP:Holster( switchtowep )
	timer.Remove("TohthAnim"..self:EntIndex())
	if IsValid(self.Owner) and IsValid(self.Owner:GetViewModel()) then
		self.Owner:GetViewModel():ManipulateBoneAngles( 0, Angle(0,0,0) )
	end
	return true
end



function SWEP:DrawWorldModel()
	self:DrawModel()
end