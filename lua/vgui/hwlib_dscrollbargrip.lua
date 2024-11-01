local PANEL = {}

function PANEL:Init()

	self.colors = {
		[ 'exited' ] = hwLib_GetColor( 'vgui_dscrollbargrip_bg' ),
		[ 'entered' ] = hwLib_GetColor( 'vgui_dscrollbargrip_bghover' ),
		[ 'pressed' ] = hwLib_GetColor( 'vgui_dscrollbargrip_bgpressed' ),
		[ 'released' ] = hwLib_GetColor( 'vgui_dscrollbargrip_bg' ),
	}
	self.status = 'exited'

end

function PANEL:OnMousePressed()

	self:GetParent():Grip( 1 )
	self.status = 'pressed'

end

function PANEL:OnCursorEntered()

	self.status = 'entered'

end

function PANEL:OnCursorExited()

	self.status = 'exited'

end

function PANEL:Paint( w, h )

	if( !self.Depressed and self.status == 'pressed' ) then self.status = 'released' end

	draw.RoundedBox( 3, 0, 0, w, h, self.colors[ self.status ] )
	return true

end

derma.DefineControl( "hwLib_DScrollBarGrip", "A Scrollbar Grip", PANEL, "DPanel" )