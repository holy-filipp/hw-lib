local PANEL = {}

function PANEL:Init()

	self.Colors = {}

	self.Scroller = vgui.Create( 'hwLib_DScrollPanel', self )
	self.Scroller:SetPos( 0, 0 )
	self.Scroller:SetScrollColor( hwLib_GetColor( 'vgui_colorsviewer_scrollbg' ) )

end

function PANEL:PerformLayout( w, h )

	self.Scroller:SetSize( w, h )

	for i, v in pairs( self.Colors ) do

		v.panel:SetSize( w, 30 )

	end

end

function PANEL:AddColor( id, name, color, rmbCb, doubleCb )

	local pnl = self

	local ColorPnl = vgui.Create( 'hwLib_ColorPanel', self.Scroller )
	ColorPnl:SetData( id, name, color, rmbCb, doubleCb )
	ColorPnl:DockMargin( 0, 0, 0, 5 )
	ColorPnl:Dock( TOP )
	ColorPnl.OnSelect = function( self, id )
		pnl:OnSelect( id )
	end

	local colorForm = {
		id = id,
		name = name,
		color = color,
		rmbCb = rmbCb,
		doubleCb = doubleCb,
		panel = ColorPnl,
	}

	self.Colors[ id ] = colorForm

end

function PANEL:VisualSelect( id, state )

	for i, v in pairs( self.Colors ) do

		if( v.panel.Selected ) then
			v.panel.Selected = false
		end

	end

	self.Colors[ id ].panel.Selected = state

end

function PANEL:EditColor( id, newId, newName, newColor )

	local color = self.Colors[ id ]

	if( color == nil ) then return end

	color.panel:UpdateData( newId, newName, newColor )

	color.id = newId
	color.name = newName
	color.color = newColor

	self.Colors[ id ] = nil
	self.Colors[ newId ] = color

end

function PANEL:DeleteColor( id )

	self.Colors[ id ].panel:Remove()
	self.Colors[ id ] = nil

end

function PANEL:ClearColors()

	for i, v in pairs( self.Colors ) do

		v.panel:Remove()

	end

	self.Colors = {}

end

function PANEL:OnSelect( id )

end

function PANEL:Paint()

end

derma.DefineControl( 'hwLib_ColorsViewer', 'Colors viewer for hwLib', PANEL, 'DPanel' )