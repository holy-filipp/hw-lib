--[[----------
Rights checker
------------]]

function hwLib_CheckRights( ply )

	if( ply == nil ) then return false end 

	if( !IsValid( ply ) ) then return false end

	if( !ply:IsPlayer() ) then return false end

	local hasAccess = CAMI.PlayerHasAccess( ply, 'superadmin' )

	return hasAccess

end