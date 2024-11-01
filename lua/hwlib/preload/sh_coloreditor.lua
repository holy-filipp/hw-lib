if SERVER then

local path = 'hwlib/themes/'

--[[----------
Themes control
------------]]

function hwLib_AddTheme( id, name )

	local fullPath = path .. id .. '.json'

	if( file.Exists( fullPath, 'DATA' ) ) then return end

	local themeForm = {
		id = id,
		name = name,
		colors = {},
	}

	file.Write( fullPath, util.TableToJSON( themeForm ) )

	hwLib_DebugMessage( 'Added theme at: ' .. fullPath )

end

function hwLib_DeleteTheme( id )

	local fullPath = path .. id .. '.json'

	if( !file.Exists( fullPath, 'DATA' ) ) then return false end

	file.Delete( fullPath )

	hwLib_DebugMessage( 'Deleted theme at: ' .. fullPath )

end

function hwLib_GetTheme( id )

	local fullPath = path .. id .. '.json'

	if( !file.Exists( fullPath, 'DATA' ) ) then return false end
	
	local themeJson = file.Read( fullPath, 'DATA' )

	return util.JSONToTable( themeJson )

end

function hwLib_GetThemes()

	local themes = file.Find( path .. '*.json', 'DATA' )

	if( themes == nil ) then return false end

	local themesOut = {}

	for i, v in pairs( themes ) do

		local themeId = string.StripExtension( v )

		local theme = hwLib_GetTheme( themeId )

		table.insert( themesOut, { id = theme.id, name = theme.name } )

	end

	return themesOut

end

function hwLib_EditTheme( id, newId, newName )

	local theme = hwLib_GetTheme( id )

	if( !theme ) then return end

	theme.id = newId
	theme.name = newName

	local oldFullPath = path .. id .. '.json'
	local newFullPath = path .. newId .. '.json'

	file.Rename( oldFullPath, newFullPath )
	file.Write( newFullPath, util.TableToJSON( theme ) )

	hwLib_DebugMessage( 'Edited theme at: ' .. oldFullPath )

end

function hwLib_ThemeExists( id )

	local theme = hwLib_GetTheme( id )

	if( theme ) then return true else return false end

end

--[[----------
Colors control
------------]]

function hwLib_AddColor( themeId, id, name, color )

	local fullPath = path .. themeId .. '.json'

	local theme = hwLib_GetTheme( themeId )

	if( !theme ) then return end

	local colorForm = {
		id = id,
		name = name,
		color = color,
	}

	theme.colors[ id ] = colorForm

	file.Write( fullPath, util.TableToJSON( theme ) )

	hwLib_DebugMessage( 'Added color ' .. id .. ' to theme at: ' .. fullPath )

end

function hwLib_DeleteColor( themeId, id )

	local fullPath = path .. themeId .. '.json'

	local theme = hwLib_GetTheme( themeId )

	if( !theme ) then return end

	if( !theme.colors[ id ] ) then return end

	theme.colors[ id ] = nil

	file.Write( fullPath, util.TableToJSON( theme ) )

	hwLib_DebugMessage( 'Deleted color ' .. id .. ' at: ' .. fullPath )

end

function hwLib_GetColorInternal( themeId, id )

	local theme = hwLib_GetTheme( themeId )

	if( !theme ) then return false end

	if( !theme.colors[ id ] ) then return false end

	return theme.colors[ id ]

end

function hwLib_GetColors( themeId )

	local theme = hwLib_GetTheme( themeId )

	if( !theme ) then return end

	if( theme.colors == {} ) then return false end
	
	return theme.colors

end

function hwLib_EditColor( themeId, id, newId, newName, newColor )

	local fullPath = path .. themeId .. '.json'

	local theme = hwLib_GetTheme( themeId )

	if( !theme ) then return end

	local color = theme.colors[ id ]

	if( !color ) then return end

	theme.colors[ id ] = nil

	color.id = tostring( newId )
	color.name = newName
	color.color = newColor

	theme.colors[ newId ] = color

	file.Write( fullPath, util.TableToJSON( theme ) )

	hwLib_DebugMessage( 'Edited color ' .. id .. ' in theme at: ' .. fullPath )

end

function hwLib_ColorExists( themeId, id )

	local color = hwLib_GetColorInternal( themeId, id )

	if( color ) then return true else return false end

end

--[[-------------
Force colors init
---------------]]

hwLib_CreateServerReceiver( 'hwLib_ForceInitColors', function()

	local themeId = net.ReadString()

	return themeId

end)

util.AddNetworkString( 'hwLib_ForceInitColorsData' )

function hwLib_ForceInitColors()

	hwLib_CreateServerRequest( 'hwLib_ForceInitColors', function( ply, themeId )

		local theme = hwLib_GetTheme( themeId )

		net.Start( 'hwLib_ForceInitColorsData' )
			net.WriteTable( theme )
		net.Send( ply )

	end, nil)

end

--[[-------
Colors init
---------]]	

hwLib_CreateServerSender( 'hwLib_InitColors', function( ply, cb )

	local themeid = net.ReadString()

	cb( hwLib_GetTheme( themeid ) )

end, function( theme )

	net.WriteTable( theme )

end)

elseif CLIENT then

CreateClientConVar( 'cl_themeid', 'dark', true, false, 'for dev' )

hwLib_SelectedThemeId = GetConVar( 'cl_themeid' ):GetString()
hwLib_SelectedTheme = {}

--[[-------------
Force colors init
---------------]]

hwLib_CreateClientSender( 'hwLib_ForceInitColors', function( cb )

	cb( hwLib_SelectedThemeId )

end, function( themeId )

	net.WriteString( themeId )

end)

net.Receive( 'hwLib_ForceInitColorsData', function() 

	local theme = net.ReadTable()

	hwLib_SelectedTheme = theme

end)

--[[-------
Colors init
---------]]

hwLib_CreateClientReceiver( 'hwLib_InitColors', function()

	local theme = net.ReadTable()

	return theme

end)

function hwLib_InitColors()

	hwLib_CreateClientRequest( 'hwLib_InitColors', function( theme )

		hwLib_SelectedTheme = theme

	end, function() 

		net.WriteString( hwLib_SelectedThemeId )

	end)

end

hwLib_InitColors() --if auto-refreshing, we need too update

hook.Add( 'InitPostEntity', 'hwLib_InitColors', hwLib_InitColors )

cvars.AddChangeCallback( 'cl_themeid', function( name, old, new )

	hwLib_SelectedThemeId = new

	hwLib_InitColors()

end)

--[[------------
Colors functions
--------------]]

function hwLib_GetSelectedTheme()

	return hwLib_SelectedTheme

end

function hwLib_GetSelectedThemeId()

	return hwLib_SelectedThemeId

end

function hwLib_GetColor( id )

	if( table.IsEmpty( hwLib_SelectedTheme ) ) then return Color( 255, 255, 255, 255 ) end

	local color = hwLib_SelectedTheme.colors[ id ]

	if( color == nil ) then return Color( 255, 255, 255, 255 ) end

	return color.color

end

end