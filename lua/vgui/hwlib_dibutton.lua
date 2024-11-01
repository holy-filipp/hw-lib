local PANEL = {}

function PANEL:Init()

	self:SetText( '' )

	self.customSize = false

	self:SetSize( 34, 30 )

end

function PANEL:SetColorData( bgColor, alphaI, alphaO )

	self.alphaEntered = alphaI
	self.alphaExited = alphaO
	self.bgColor = bgColor

	self.alpha = self.alphaExited

end

function PANEL:PerformLayout( w, h )



end

function PANEL:CustomSize( state )

	self.customSize = state

end

function PANEL:OnCursorEntered()

	self.alpha = self.alphaEntered

end

function PANEL:OnCursorExited()

	self.alpha = self.alphaExited

end

function PANEL:SetIcon( path )

	self.IconMaterial = Material( path )

end

function PANEL:Paint( w, h )

	draw.RoundedBox( 3, 0, 0, w, h, ColorAlpha( self.bgColor, self.alpha ) )
	if( self.IconMaterial ) then
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.SetMaterial( self.IconMaterial )
		surface.DrawTexturedRect( 7, self.customSize and ( self:GetTall() - 20 ) / 2 + 1 or 5, 20, 20 )
	end

end

derma.DefineControl( 'hwLib_DIButton', 'DIButton for hwLib', PANEL, 'DButton' )