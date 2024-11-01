local PANEL = {}

function PANEL:Init()

	self.IconMaterial = Material( 'vgui/search20.png' )

	self.Entry = vgui.Create( 'hwLib_DTextEntry', self )
	self.Entry:SetPos( 28, 0 )
	self.Entry:SetPlaceholderText( 'Search' )
	self.Entry.OnChange = function()
		self:OnChange( self.Entry:GetValue() )
	end
	
end

function PANEL:PerformLayout( w, h )

	self.Entry:SetSize( w - 28, h )

end

function PANEL:SetColorData( bgColor, iconColor )

	self.Entry:SetBGColor( bgColor )
	self.bgColor = bgColor
	self.IconColor = iconColor

end

function PANEL:OnChange( value )

end

function PANEL:Paint( w, h )

	draw.RoundedBox( 3, 0, 0, w, h, self.bgColor )
	surface.SetDrawColor( self.IconColor )
	surface.SetMaterial( self.IconMaterial )
	surface.DrawTexturedRect( 4, 4, 20, 20 )

end

derma.DefineControl( 'hwLib_SearchField', 'Search field for hwLib', PANEL, 'DPanel' )