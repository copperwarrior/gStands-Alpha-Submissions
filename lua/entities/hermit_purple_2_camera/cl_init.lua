
include('shared.lua')

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self.ShouldDrawInfo 	= false
end

/*---------------------------------------------------------
   Name: Draw
---------------------------------------------------------*/
function ENT:Draw()
return 
end

function ENT:Think()
	self:TrackEntity( self:GetentTrack(), self:GetvecTrack() )
end