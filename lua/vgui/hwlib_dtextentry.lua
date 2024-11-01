local PANEL = {}

function PANEL:Init()

	self:SetTextColor( hwLib_GetColor( 'vgui_text' ) )
	self:SetFont( 'hwLib_Montserrat_Medium_16' )
	self:SetCursorColor( hwLib_GetColor( 'vgui_dtextentry_cursor' ) )
	self:SetDrawLanguageID( false )

	self.bgColor = Color( 255, 255, 255, 255 )

end

function PANEL:SetBGColor( bgColor )

	self.bgColor = bgColor

end

function PANEL:Paint( w, h )

	draw.RoundedBox( 3, 0, 0, w, h, self.bgColor )
	self:DrawTextEntryText( self:GetTextColor(), self:GetHighlightColor(), self:GetCursorColor() )
	if( self:GetValue() == '' and self:GetPlaceholderText() != nil ) then
		draw.SimpleText( self:GetPlaceholderText(), 'hwLib_Montserrat_Medium_16', 3, 6, hwLib_GetColor( 'vgui_dtextentry_placeholder' ) )
	end

end

derma.DefineControl( 'hwLib_DTextEntry', 'Colors viewer for hwLib', PANEL, 'DTextEntry' )