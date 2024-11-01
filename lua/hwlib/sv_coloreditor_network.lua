--[[---
Network
-----]]

hwLib_CreateServerSender( 'hwLib_GetThemes', function( ply, cb )

	local themes = hwLib_GetThemes()

	cb( themes )

end, function( themes )

	net.WriteTable( themes )

end)

hwLib_CreateServerSender( 'hwLib_GetTheme', function( ply, cb )

	local id = net.ReadString()

	cb( hwLib_GetTheme( id ) )

end, function( theme )

	net.WriteTable( theme )

end)

hwLib_CreateServerSender( 'hwLib_AddColor', function( ply, cb )

	if( !hwLib_CheckRights( ply ) ) then cb( "You don't have access to do this." ) return end

	local receiveData = net.ReadTable()

	if( receiveData.theme_id == nil or receiveData.theme_id == '' ) then cb( 'Theme ID cannot be empty.' ) return end
	if( receiveData.id == nil or receiveData.id == receiveData.theme_id == '' ) then cb( 'Color ID cannot be empty.' ) return end
	if( tonumber( receiveData.id ) != nil ) then cb( 'Color ID cannot be a number.' ) return end
	if( receiveData.name == nil or receiveData.name == '' ) then cb( 'Color name cannot be empty.' ) return end
	if( receiveData.color == nil or receiveData.color == '' ) then cb( 'Color cannot be empty.' ) return end

	hwLib_AddColor( receiveData.theme_id, receiveData.id, receiveData.name, receiveData.color )

	hwLib_ForceInitColors()

end, function( message )

	net.WriteString( message )

end)

hwLib_CreateServerSender( 'hwLib_EditColor', function( ply, cb )

	if( !hwLib_CheckRights( ply ) ) then cb( "You don't have access to do this." ) return end

	local receiveData = net.ReadTable()

	if( hwLib_ColorExists( receiveData.theme_id, receiveData.new_id ) and receiveData.new_id != receiveData.id ) then cb( 'Color with this ID already exists.' ) return end
	if( receiveData.theme_id == nil or receiveData.theme_id == '' ) then cb( 'Theme ID cannot be empty.' ) return end
	if( receiveData.id == nil or receiveData.id == '' ) then cb( 'Something went wrong.' ) return end
	if( receiveData.new_id == nil or receiveData.new_id == '' ) then cb( 'Color ID cannot be empty.' ) return end
	if( tonumber( receiveData.new_id ) != nil ) then cb( 'Color ID cannot be a number.' ) return end
	if( receiveData.new_name == nil or receiveData.new_name == '' ) then cb( 'Color name cannot be empty.' ) return end
	if( receiveData.new_color == nil or receiveData.new_color == '' ) then cb( 'Color cannot be empty.' ) return end

	hwLib_EditColor( receiveData.theme_id, receiveData.id, receiveData.new_id, receiveData.new_name, receiveData.new_color )

	hwLib_ForceInitColors()

	cb( '201' )

end, function( message )

	net.WriteString( message )

end)

hwLib_CreateServerSender( 'hwLib_DeleteColor', function( ply, cb )

	if( !hwLib_CheckRights( ply ) ) then cb( "You don't have access to do this." ) return end

	local receiveData = net.ReadTable()

	if( receiveData.theme_id == nil or receiveData.theme_id == '' ) then cb( 'Theme ID cannot be empty.' ) return end
	if( receiveData.id == nil or receiveData.id == '' ) then cb( 'Color ID cannot be empty.' ) return end

	hwLib_DeleteColor( receiveData.theme_id, receiveData.id )

	hwLib_ForceInitColors()

	cb( '201' )

end, function( message )

	net.WriteString( message )

end)

hwLib_CreateServerSender( 'hwLib_AddTheme', function( ply, cb )

	if( !hwLib_CheckRights( ply ) ) then cb( "You don't have access to do this." ) return end

	local receiveData = net.ReadTable()

	if( receiveData.id == nil or receiveData.id == '' ) then cb( 'Theme ID cannot be empty.' ) return end
	if( receiveData.name == nil or receiveData.name == '' ) then cb( 'Theme name cannot be empty.' ) return end
	if( hwLib_ThemeExists( receiveData.id ) ) then cb( 'Theme with this ID already exists.' ) return end

	hwLib_AddTheme( receiveData.id, receiveData.name )

	hwLib_ForceInitColors()

	cb( '201' )

end, function( message )

	net.WriteString( message )

end)

hwLib_CreateServerSender( 'hwLib_DeleteTheme', function( ply, cb )

	if( !hwLib_CheckRights( ply ) ) then cb( "You don't have access to do this." ) return end

	local receiveData = net.ReadTable()

	if( receiveData.id == nil or receiveData.id == '' ) then cb( 'Theme ID cannot be empty.' ) return end
	if( !hwLib_ThemeExists( receiveData.id ) ) then cb( "Theme doesn't exists." ) return end 

	hwLib_DeleteTheme( receiveData.id )

	hwLib_ForceInitColors()

	cb( '201' )

end, function( message )

	net.WriteString( message )

end)

hwLib_CreateServerSender( 'hwLib_EditTheme', function( ply, cb )

	if( !hwLib_CheckRights( ply ) ) then cb( "You don't have access to do this." ) return end

	local receiveData = net.ReadTable()

	if( receiveData.id == nil or receiveData.theme_id == '' ) then cb( 'Something went wrong.' ) return end
	if( receiveData.new_id == nil or receiveData.new_id == '' ) then cb( 'Theme ID cannot be empty.' ) return end
	if( receiveData.new_name == nil or receiveData.new_name == '' ) then cb( 'Theme name cannot be empty.' ) return end
	if( receiveData.new_id != receiveData.id and hwLib_ThemeExists( receiveData.new_id ) ) then cb( 'Theme with this ID already exists.' ) return end

	hwLib_EditTheme( receiveData.id, receiveData.new_id, receiveData.new_name )

	hwLib_ForceInitColors()

	cb( '201' )

end, function( message )

	net.WriteString( message )

end)