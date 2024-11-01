local PANEL = {}

function PANEL:Init()

	self.Tabs = {}

	self.Selected = false
	self.SelectedId = nil

	self.Scroller = vgui.Create( 'DHorizontalScroller', self )
	self.Scroller:SetPos( 5, 5 )
	self.Scroller:SetOverlap( -5 )

	self.AddButton = vgui.Create( 'hwLib_DButton', self )
	self.AddButton:SetBText( 'Add theme' )
	self.AddButton:SetIcon( 'vgui/plus20.png' )
	self.AddButton:SetColorData( hwLib_GetColor( 'vgui_themeviewer_addbtnbg' ), 155, 255 )
	self.AddButton:SetPos( 5, 5 )
	self.AddButton:CustomSize( true )
	self.AddButton:SetTall( 25 )
	self.AddButton:SetVisible( false )

end

function PANEL:PerformLayout()

	self.Scroller:SetSize( self:GetWide() - 10, 30 )

	if( table.IsEmpty( self.Tabs ) ) then
		self.AddButton:SetVisible( true )
	end

	self.AddButton.DoClick = self.DoAddBClick

end

function PANEL:OnSelect( current, next )

end

function PANEL:AddTab( name, id, rightClick )

	self.AddButton:SetVisible( false )

	local pnl = self

	local TabPanel = vgui.Create( 'DPanel', self )
	TabPanel:SetSize( self:GetWide() - 20, self:GetTall() - 50 )
	TabPanel:SetPos( 10, 40 )
	TabPanel:SetVisible( false )
	TabPanel:SetBackgroundColor( Color( 0, 0, 0, 0 ) )

	surface.SetFont( 'hwLib_Montserrat_Medium_16' )
	local w, h = surface.GetTextSize( name )

	local TabButton = vgui.Create( 'DButton', self.Scroller )	
	TabButton.alpha = 155
	TabButton.Selected = false
	TabButton:SetText( '' )
	TabButton:SetSize( w + 14, 30 )
	TabButton.DoClick = function( self )

		for i, v in pairs( pnl.Tabs ) do

			if( v.button.Selected ) then 
				v.button.Selected = false
				v.panel:SetVisible( false )
			end

		end

		pnl:OnSelect( pnl.SelectedId, id )

		pnl.SelectedId = id 
		self.Selected = true
		TabPanel:SetVisible( true )
		pnl.Selected = true

	end
	TabButton.DoRightClick = function( self )

		rightClick( id )

	end
	TabButton.Paint = function( self, w, h )

		draw.RoundedBox( 1, 0, 0, w, !self.Selected and h - 5 or h, ColorAlpha( hwLib_GetColor( 'vgui_themeviewer_btnbg' ), !self.Selected and self.alpha or 255 ) )
		draw.SimpleText( name, 'hwLib_Montserrat_Medium_16', 7, 5, hwLib_GetColor( 'vgui_text' ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	end
	TabButton.OnCursorEntered = function( self )
		self.alpha = 255
	end
	TabButton.OnCursorExited = function( self )
		self.alpha = 155
	end

	local tab = {
		name = name,
		id = id,
		rmbcb = rightClick,
		panel = TabPanel,
		button = TabButton,
	}

	self.Tabs[ id ] = tab

	self.Scroller:AddPanel( self.Tabs[ id ].button )

	return TabPanel

end

function PANEL:EditTab( id, name, newId )

	local tab = self.Tabs[ id ]
	local TabButton = tab.button

	surface.SetFont( 'hwLib_Montserrat_Medium_16' )
	local w, h = surface.GetTextSize( name )

	TabButton:SetSize( w + 14, 30 )
	if( newId != nil ) then
		TabButton.DoRightClick = function( self )

			tab[ 'rmbcb' ]( newId )

		end
	end
	TabButton.Paint = function( self, w, h )

		draw.RoundedBox( 1, 0, 0, w, !self.Selected and h - 5 or h, ColorAlpha( hwLib_GetColor( 'vgui_themeviewer_btnbg' ), !self.Selected and self.alpha or 255 ) )
		draw.SimpleText( name, 'hwLib_Montserrat_Medium_16', 7, 5, hwLib_GetColor( 'vgui_text' ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	end

	tab[ 'name' ] = name
	tab[ 'button' ] = TabButton

	if( newId != nil ) then

		tab[ 'id' ] = newId

		self.Tabs[ id ] = nil
		self.Tabs[ newId ] = tab

	end

	self.Scroller:InvalidateLayout()

end

function PANEL:DeleteTab( id )

	local tab = self.Tabs[ id ]

	tab.panel:Remove()
	tab.button:Remove()

	self.Tabs[ id ] = nil

	self.Selected = false
	self.SelectedId = nil

	if( table.IsEmpty( self.Tabs ) ) then
		self.AddButton:SetVisible( true )
	end

	self.Scroller:InvalidateLayout( true )

end

function PANEL:Paint( w, h )

	draw.RoundedBox( 3, 0, 0, w, h, hwLib_GetColor( 'vgui_themeviewer_bg' ) )
	draw.RoundedBoxEx( 3, 5, 35, w - 10, h - 40, hwLib_GetColor( 'vgui_themeviewer_bg2' ), false, false, true, true )
	if( !self.Selected ) then

		draw.SimpleText( 'No theme selected', 'hwLib_Montserrat_Medium_19', w / 2, h / 2, hwLib_GetColor( 'vgui_text' ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end

end

derma.DefineControl( 'hwLib_ThemeViewer', 'Theme viewer for hwLib', PANEL, 'DPanel' )