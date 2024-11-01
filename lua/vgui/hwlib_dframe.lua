
local PANEL = {}

AccessorFunc( PANEL, "m_bIsMenuComponent",	"IsMenu",			FORCE_BOOL )
AccessorFunc( PANEL, "m_bDraggable",		"Draggable",		FORCE_BOOL )
AccessorFunc( PANEL, "m_bSizable",			"Sizable",			FORCE_BOOL )
AccessorFunc( PANEL, "m_bScreenLock",		"ScreenLock",		FORCE_BOOL )
AccessorFunc( PANEL, "m_bDeleteOnClose",	"DeleteOnClose",	FORCE_BOOL )
AccessorFunc( PANEL, "m_bPaintShadow",		"PaintShadow",		FORCE_BOOL )

AccessorFunc( PANEL, "m_iMinWidth",			"MinWidth",			FORCE_NUMBER )
AccessorFunc( PANEL, "m_iMinHeight",		"MinHeight",		FORCE_NUMBER )

AccessorFunc( PANEL, "m_bBackgroundBlur",	"BackgroundBlur",	FORCE_BOOL )

local closeImg = Material( 'vgui/x20.png' )

function PANEL:Init()

	self:SetAlpha( 0 )

	self.Title = ''

	self:SetFocusTopLevel( true )

	self:SetPaintShadow( true )

	self.btnClose = vgui.Create( 'DButton', self )
	self.btnClose.alpha = 0
	self.btnClose:SetText( '' )
	self.btnClose.DoClick = function()
		self:AlphaTo( 0, 0.1, 0, function() self:Close() end) 
	end
	self.btnClose.OnCursorEntered = function()
		self.btnClose.alpha = 100
	end
	self.btnClose.OnCursorExited = function()
		self.btnClose.alpha = 0
	end
	self.btnClose.Paint = function( panel, w, h )
		draw.RoundedBox( 5, 0, 0, 20, 20, ColorAlpha( hwLib_GetColor( 'vgui_dframe_clsbtnbg' ), self.btnClose.alpha ) )
		surface.SetDrawColor( hwLib_GetColor( 'vgui_icon' ) )
		surface.SetMaterial( closeImg )
		surface.DrawTexturedRect( 0, 0, 20, 20 )
	end

	self:SetDraggable( true )
	self:SetSizable( false )
	self:SetScreenLock( false )
	self:SetDeleteOnClose( true )
	self:SetTitle( "Window" )

	self:SetMinWidth( 50 )
	self:SetMinHeight( 50 )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

	self.m_fCreateTime = SysTime()

	self:DockPadding( 5, 24 + 5, 5, 5 )

	self:AlphaTo( 255, 0.1, 0 )

end

function PANEL:SetIcon( path )

	self.iconMaterial = Material( path )
	self.icon = true

end

function PANEL:OnCloseFunction( cb )

	self.btnClose.DoClick = cb

end

function PANEL:ShowCloseButton( bShow )

	self.btnClose:SetVisible( bShow )

end

function PANEL:GetTitle()

	return self.Title

end

function PANEL:SetTitle( strTitle )

	self.Title = strTitle

end

function PANEL:Close()

	self:SetVisible( false )

	if ( self:GetDeleteOnClose() ) then
		self:Remove()
	end

	self:OnClose()

end

function PANEL:OnClose()
end

function PANEL:Center()

	self:InvalidateLayout( true )
	self:CenterVertical()
	self:CenterHorizontal()

end

function PANEL:IsActive()

	if ( self:HasFocus() ) then return true end
	if ( vgui.FocusedHasParent( self ) ) then return true end

	return false

end

function PANEL:Think()

	local mousex = math.Clamp( gui.MouseX(), 1, ScrW() - 1 )
	local mousey = math.Clamp( gui.MouseY(), 1, ScrH() - 1 )

	if ( self.Dragging ) then

		local x = mousex - self.Dragging[1]
		local y = mousey - self.Dragging[2]

		-- Lock to screen bounds if screenlock is enabled
		if ( self:GetScreenLock() ) then

			x = math.Clamp( x, 0, ScrW() - self:GetWide() )
			y = math.Clamp( y, 0, ScrH() - self:GetTall() )

		end

		self:SetPos( x, y )

	end

	if ( self.Sizing ) then

		local x = mousex - self.Sizing[1]
		local y = mousey - self.Sizing[2]
		local px, py = self:GetPos()

		if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW() - px && self:GetScreenLock() ) then x = ScrW() - px end
		if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH() - py && self:GetScreenLock() ) then y = ScrH() - py end

		self:SetSize( x, y )
		self:SetCursor( "sizenwse" )
		return

	end

	local screenX, screenY = self:LocalToScreen( 0, 0 )

	if ( self.Hovered && self.m_bSizable && mousex > ( screenX + self:GetWide() - 20 ) && mousey > ( screenY + self:GetTall() - 20 ) ) then

		self:SetCursor( "sizenwse" )
		return

	end

	if ( self.Hovered && self:GetDraggable() && mousey < ( screenY + 24 ) ) then
		self:SetCursor( "sizeall" )
		return
	end

	self:SetCursor( "arrow" )

	-- Don't allow the frame to go higher than 0
	if ( self.y < 0 ) then
		self:SetPos( self.x, 0 )
	end

end

function PANEL:Paint( w, h )

	if ( self.m_bBackgroundBlur ) then
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end

	draw.RoundedBox( 5, 0, 0, w, h, hwLib_GetColor( 'vgui_dframe_bg' ) )
	draw.RoundedBoxEx( 5, 0, 0, w, 26, hwLib_GetColor( 'vgui_dframe_header' ), true, true )
	draw.SimpleText( self.Title, 'hwLib_Montserrat_Medium_17', self.icon and 28 or 5, 4, hwLib_GetColor( 'vgui_text' ) )
	if( self.iconMaterial != nil ) then
		surface.SetDrawColor( hwLib_GetColor( 'vgui_icon' ) )
		surface.SetMaterial( closeImg )
		surface.DrawTexturedRect( 3, 3, 20, 20 )
	end

	return true

end

function PANEL:OnMousePressed()

	local screenX, screenY = self:LocalToScreen( 0, 0 )

	if ( self.m_bSizable && gui.MouseX() > ( screenX + self:GetWide() - 20 ) && gui.MouseY() > ( screenY + self:GetTall() - 20 ) ) then
		self.Sizing = { gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall() }
		self:MouseCapture( true )
		return
	end

	if ( self:GetDraggable() && gui.MouseY() < ( screenY + 24 ) ) then
		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
		self:MouseCapture( true )
		return
	end

end

function PANEL:OnMouseReleased()

	self.Dragging = nil
	self.Sizing = nil
	self:MouseCapture( false )

end

function PANEL:PerformLayout()

	self.btnClose:SetPos( self:GetWide() - 23, 3 )
	self.btnClose:SetSize( 20, 20 )

end

derma.DefineControl( "hwLib_DFrame", "A simple window", PANEL, "EditablePanel" )