local PANEL = {}

function PANEL:Init()

	self.Text = ''

	self:SetText( '' )

	self.customSize = false

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

function PANEL:SetBText( text )

	self.Text = text

	surface.SetFont( 'hwLib_Montserrat_Medium_16' )
	local tw, th = surface.GetTextSize( text )

	self.TextTall = th

	self:SetSize( 20 + tw, 30 )

end

function PANEL:SetIcon( path )

	self.IconMaterial = Material( path )

	self:SetWide( self:GetWide() + 22 )

end

function PANEL:Paint( w, h )

	draw.RoundedBox( 3, 0, 0, w, h, ColorAlpha( self.bgColor, self.alpha ) )
	draw.SimpleText( self.Text, 'hwLib_Montserrat_Medium_16', self.IconMaterial and 32 or 10, self.CustomSize and ( self:GetTall() - self.TextTall ) / 2 or 7, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	if( self.IconMaterial ) then
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.SetMaterial( self.IconMaterial )
		surface.DrawTexturedRect( 7, self.customSize and ( self:GetTall() - 20 ) / 2 + 1 or 5, 20, 20 )
	end

end

derma.DefineControl( 'hwLib_DButton', 'DButton for hwLib', PANEL, 'DButton' )