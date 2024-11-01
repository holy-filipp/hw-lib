--[[-------------------------------------

	 _               _      _  _     
	| |             | |    (_)| |    
	| |__ __      __| |     _ | |__  
	| '_ \\ \ /\ / /| |    | || '_ \ 
	| | | |\ V  V / | |____| || |_) |
	|_| |_| \_/\_/  \_____/|_||_.__/ 

	  by Holy Whiskey

--]]-------------------------------------

hwLib_Debug = true

function hwLib_DebugMessage( text )

	if( !hwLib_Debug ) then return end
	if( text == nil or text == '' ) then return end

	print( '[hwLib] ' .. text )

end

--[[---------
Beatiful shit
-----------]]

hwLib_LogoString = [[

	 _               _      _  _     
	| |             | |    (_)| |    
	| |__ __      __| |     _ | |__  
	| '_ \\ \ /\ / /| |    | || '_ \ 
	| | | |\ V  V / | |____| || |_) |
	|_| |_| \_/\_/  \_____/|_||_.__/ 

	  by Holy Whiskey

]]

--[[--------
hwLib loader
----------]]

local root = 'hwlib'
local preload = 'hwlib/preload'
local libs = 'hwlib/libs'
local restricted = {
	[ preload ] = true,
	[ libs ] = true,
}

--[[----------------------------------------------
Files in folder libs loading earlier then preload, 
because files in preload dependend on libs
------------------------------------------------]]

function hwLib_InitAddFile( newfile, directory )

	local prefix = string.lower( string.Left( newfile, 3 ) )

	hwLib_DebugMessage( 'Loading file: ' .. newfile )

	if( SERVER and prefix == 'sv_' ) then
		include( directory .. newfile )
	elseif( prefix == 'sh_' ) then
		if( SERVER ) then
			include( directory .. newfile )
			AddCSLuaFile( directory .. newfile )
		end
		include( directory .. newfile )
	elseif( prefix == 'cl_' ) then
		if( SERVER ) then
			AddCSLuaFile( directory .. newfile )
		elseif( CLIENT ) then
			include( directory .. newfile )
		end
	end

end

function hwLib_InitIncludeDirectory( lastdir, directory )

	directory = lastdir .. directory .. '/'

	hwLib_DebugMessage( 'Loading directory: ' .. directory )

	local files, directories = file.Find( directory .. '*', 'LUA' )

	for i, v in pairs( files ) do
		hwLib_DebugMessage( 'Finded file: ' .. v )
		if( string.EndsWith( v, '.lua' ) ) then
			hwLib_InitAddFile( v, directory )
		end
	end

	for i, v in pairs( directories ) do
		if( restricted[ directory .. v ] ) then continue end  
		--if( directory .. v == preload ) then continue end
		hwLib_DebugMessage( 'Finded directory: ' .. v )
		hwLib_InitIncludeDirectory( directory, v )
	end

end

if( hwLib_Debug ) then print( hwLib_LogoString ) end

hwLib_InitIncludeDirectory( '', libs )

hwLib_InitIncludeDirectory( '', preload )

hwLib_InitIncludeDirectory( '', root )