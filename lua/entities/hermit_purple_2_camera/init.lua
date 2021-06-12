AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
ENT.PhysgunDisabled = true

include('shared.lua')


function ENT:Initialize()
	self:SetMoveType( MOVETYPE_NONE )
	self:DrawShadow( false )
end
function ENT:OnRemove()
	if ( RenderTargetCameraProp != self.Entity ) then return end

	local Cameras = ents.FindByClass( "hermit_purple_2_camera" )
	if ( #Cameras == 0 ) then return end
	local CameraIdx = math.random( #Cameras )

	if ( CameraIdx == self.Entity ) then
		if ( #Cameras != 0 ) then return end
		self:OnRemove()
	end

	local Camera = Cameras[ CameraIdx ]
	HP2UpdateRenderTarget( Camera )
end


local function RTCamera_Use( pl, ent )
	if (!ent:IsValid()) then return false end

	HP2UpdateRenderTarget( ent )

	return true
end
