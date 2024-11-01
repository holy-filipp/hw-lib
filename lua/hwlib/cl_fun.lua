local angles = Angle( 0, 0, 0 )
local mousex = 0
local mousey = 0
local noclip = false
local sensitivity = math.Round( GetConVar( 'sensitivity' ):GetFloat(), 2 )
local mouseYaw = GetConVar( 'm_yaw' ):GetFloat()
local mousePitch = GetConVar( 'm_pitch' ):GetFloat()

cvars.AddChangeCallback( 'sensitivity', function()

	sensitivity = math.Round( GetConVar( 'sensitivity' ):GetFloat(), 2 )
	mouseYaw = GetConVar( 'm_yaw' ):GetFloat()
	mousePitch = GetConVar( 'm_pitch' ):GetFloat()

end)

hook.Add( 'CreateMove', 'test', function( cmd )

	mousex = cmd:GetMouseX() * mouseYaw
	mousey = cmd:GetMouseY() * mousePitch

	if( noclip ) then
		noclip.angles.x = math.Clamp( noclip.angles.x + mousey, -89.9, 89.9 )
		noclip.angles.y = noclip.angles.y - mousex

		local speed = 0.03 * FrameTime()
		if( cmd:KeyDown( IN_SPEED ) ) then speed = 0.3 * FrameTime() end

		local vel = Vector( 0, 0, 0 )

		vel = vel + noclip.angles:Forward() * cmd:GetForwardMove() * speed
		vel = vel + noclip.angles:Right() * cmd:GetSideMove() * speed
		vel = vel + noclip.angles:Up() * cmd:GetUpMove() * speed

		noclip.pos = noclip.pos + vel

		cmd:ClearButtons()
		cmd:ClearMovement()
		cmd:SetMouseX( 0 )
		cmd:SetMouseY( 0 ) 
		cmd:SetViewAngles( angles )
	else
		angles = cmd:GetViewAngles()
	end

end)

--[[ hook.Add( 'HUDPaint', 'test2', function()

	draw.SimpleText( 'Noclip ' .. ( noclip and 'enabled' or 'disabled' ), 'hwLib_Montserrat_Medium_16', ScrW() / 2, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	draw.SimpleText( 'Mouse sens/yaw/pitch ' .. sensitivity .. '/' .. mouseYaw .. '/' .. mousePitch, 'hwLib_Montserrat_Medium_16', ScrW() / 2, 16, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

end)--]] 

hook.Add( 'CalcView', 'test3', function( ply, pos, angles, fov )

	if( noclip ) then

		local view = {
			origin = noclip.pos,
			angles = noclip.angles,
			fov = fov,
			drawviewer = true
		}

		return view

	end

end)

concommand.Add( 'nc', function( ply )

	if( !noclip ) then
		noclip = {
			pos = ply:GetPos() + Vector( 0, 0, 20 ),
			angles = ply:GetAngles()
		}
		chat.AddText( Color( 255, 255, 0 ), 'Noclip enabled' )
	else
		noclip = false
		chat.AddText( Color( 255, 255, 0 ), 'Noclip disabled' )
	end

end)