--[[---------
Fonts creator
-----------]]

function hwLib_CreateFont( name, ... )

	local nameWithoutSpaces = string.Replace( name, ' ', '_' )
	local fonts = { ... }

	for i, v in pairs( fonts ) do

		surface.CreateFont( 'hwLib_' .. nameWithoutSpaces .. '_' .. v, {
			font = name,
			size = v,
			weight = 500,
			extended = true,
		})

		hwLib_DebugMessage( 'Added font: ' .. 'hwLib_' .. nameWithoutSpaces .. '_' .. v )

	end

end

hwLib_CreateFont( 'Montserrat Medium', 19, 17, 16, 15 )