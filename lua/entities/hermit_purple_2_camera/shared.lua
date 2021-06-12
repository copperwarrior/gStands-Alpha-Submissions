ENT.Type = "anim"

ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Key" );
	self:NetworkVar( "Bool", 0, "On" );
	self:NetworkVar( "Vector", 0, "vecTrack" );
	self:NetworkVar( "Entity", 0, "entTrack" );
	self:NetworkVar( "Entity", 1, "Player" );
end

function ENT:CanTool( ply, trace, mode )
	if (self:GetMoveType() == MOVETYPE_NONE) then return false end
	return true
end

function ENT:TrackEntity( ent, lpos )
	if IsValid(ent) then
		self:SetPos(ent:EyePos() - (ent:GetAimVector() * 200))
		self:SetAngles(ent:EyeAngles())
	end
end