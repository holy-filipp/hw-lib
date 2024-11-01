local PANEL = {}

function PANEL:Init()

	local pnl = self

	self.alpha = 255
	self.Selected = false

	self.NameLabel = vgui.Create( 'DLabel', self )
	self.NameLabel:SetFont( 'hwLib_Montserrat_Medium_16' )
	self.NameLabel:SetPos( 5, 5 )
	self.NameLabel:SetTextColor( hwLib_GetColor( 'vgui_text' ) )

	self.SelectButton = vgui.Create( 'DButton', self )
	self.SelectButton:SetPos( 0, 0 )
	self.SelectButton:SetText( '' )
	self.SelectButton.Paint = function()end
	self.SelectButton.OnCursorEntered = function()
		self.alpha = 155
	end
	self.SelectButton.OnCursorExited = function()
		self.alpha = 255
	end
	self.SelectButton.OnMousePressed = function( self, mousecode )
		
		if ( mousecode == MOUSE_LEFT && !dragndrop.IsDragging() ) then

			if ( self.LastClickTime && SysTime() - self.LastClickTime < 0.2 ) then

				pnl:DoDoubleClick()
				return

			end

			self.LastClickTime = SysTime()

		end

		if( mousecode == MOUSE_LEFT ) then

			if( self.DoClick_lastClick and SysTime() - self.DoClick_lastClick > 0.3 ) then

				self:DoClick()
				self.DoClick_lastClick = SysTime()
				return

			end
			
			if( !self.DoClick_lastClick ) then
				self:DoClick()
				self.DoClick_lastClick = SysTime()
			end

		end

		self.Depressed = true

	end

end

function PANEL:DoDoubleClick()

end

function PANEL:PerformLayout( w, h )

	self.NameLabel:SetWide( ( w - ( h - 10 ) - 5 ) - 10 )
	self.SelectButton:SetSize( w, h )

end

function PANEL:SetData( id, name, color, rmbCb, doubleCb )

	self.ColorId = id
	self.ColorName = name
	self.PanelColor = color
	self.ColorRmbCb = rmbCb
	self.ColorDoubleCb = doubleCb

	self.NameLabel:SetText( name )

	self.SelectButton.DoClick = function()
		self:OnSelect( id )
	end
	self.SelectButton.DoRightClick = function()
		rmbCb( id )
	end

	self.DoDoubleClick = function()
		doubleCb( id )
	end

end

function PANEL:UpdateData( id, name, color )

	self.ColorId = id
	self.ColorName = name
	self.PanelColor = color

	local rmbCb = self.ColorRmbCb
	local doubleCb = self.ColorDoubleCb

	self.NameLabel:SetText( name )

	self.SelectButton.DoClick = function()
		self:OnSelect( id )
	end
	self.SelectButton.DoRightClick = function()
		rmbCb( id )
	end
	self.DoDoubleClick = function()
		doubleCb( id )
	end

end

function PANEL:OnSelect( id )

end

function PANEL:Paint( w, h )

	draw.RoundedBox( 3, 0, 0, w, h, ColorAlpha( hwLib_GetColor( 'vgui_colorpanel_bg' ), self.alpha ) )
	draw.RoundedBox( 3, w - ( h - 10 ) - 5, 5, h - 10, h - 10, self.PanelColor )
	if( self.Selected ) then
		draw.RoundedBoxEx( 3, w - 1, 0, 1, h, hwLib_GetColor( 'vgui_colorpanel_selectln' ), true, false, true, false )
	end

end

derma.DefineControl( 'hwLib_ColorPanel', 'Color panel for hwLib', PANEL, 'DPanel' )