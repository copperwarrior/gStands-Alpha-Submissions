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

	local Cameras = ents.FindByClass( "hermit_purple_camera" )
	if ( #Cameras == 0 ) then return end
	local CameraIdx = math.random( #Cameras )

	if ( CameraIdx == self.Entity ) then
		if ( #Cameras != 0 ) then return end
		self:OnRemove()
	end

	local Camera = Cameras[ CameraIdx ]
	HPUpdateRenderTarget( Camera )
end


local function RTCamera_Use( pl, ent )
	if (!ent:IsValid()) then return false end

	HPUpdateRenderTarget( ent )

	return true
end
