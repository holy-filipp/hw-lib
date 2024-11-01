--[[---
Network
-----]]

hwLib_CreateClientReceiver( 'hwLib_GetThemes', function()

	local themes = net.ReadTable()

	return themes

end)

hwLib_CreateClientReceiver( 'hwLib_GetTheme', function()

	local theme = net.ReadTable()

	return theme

end)

hwLib_CreateClientReceiver( 'hwLib_AddColor', function() 

	local message = net.ReadString()

	return message

end)

hwLib_CreateClientReceiver( 'hwLib_EditColor', function() 

	local message = net.ReadString()

	return message

end)

hwLib_CreateClientReceiver( 'hwLib_DeleteColor', function() 

	local message = net.ReadString()

	return message

end)

hwLib_CreateClientReceiver( 'hwLib_AddTheme', function() 

	local message = net.ReadString()

	return message

end)

hwLib_CreateClientReceiver( 'hwLib_DeleteTheme', function() 

	local message = net.ReadString()

	return message

end)

hwLib_CreateClientReceiver( 'hwLib_EditTheme', function() 

	local message = net.ReadString()

	return message

end)

function hwLib_AddColor( themeId, id, name, color )

	local sendForm = {
		theme_id = themeId,
		id = id,
		name = name,
		color = color,
	}

	hwLib_CreateClientRequest( 'hwLib_AddColor', function( message )

		hwLib_DialogFrame( 'Error', message, {
			text = 'Ok',
			cb = function( frame )
				frame:Close()
			end
		})

	end, function() 

		net.WriteTable( sendForm )

	end)

end

--[[-----
Editor UI
-------]]

local pasteColor, copiedColor = nil

local function closeFrame( Frame )

	Frame:AlphaTo( 0, 0.1, 0, function() Frame:Close() end)

end

function hwLib_AddThemeTab( Frame, Viewer, colors, addThemeCb, deleteThemeCb, editTheme )

	local v = colors

	local function copyColor( c )
		copiedColor = c
		SetClipboardText( string.format( '%d, %d, %d, %d', c.r, c.g, c.b, c.a ) )
	end

	local function rmbCb( id )
		
	end

	local function doubleCb( id )
		local c = v.colors[ id ].color
		copyColor( c )
	end

	local Panel = Viewer:AddTab( v.name, v.id, function( id )

		local dmenu = vgui.Create( 'hwLib_DMenu' )
		dmenu:AddOption( 'Add theme', addThemeCb )
		dmenu:AddOption( 'Delete theme', function() deleteThemeCb( id ) end)
		dmenu:AddOption( 'Edit theme', function() editTheme( id ) end)
		dmenu:Open()

	end)

	local ColorsPanel = vgui.Create( 'DPanel', Panel )
	ColorsPanel:SetSize( Panel:GetWide() / 2 - 10, Panel:GetTall() - 10 )
	ColorsPanel:SetPos( 5, 5 )
	ColorsPanel.Paint = function( self, w, h )
		
		draw.RoundedBox( 3, 0, 0, w, h, hwLib_GetColor( 'vgui_coloreditor_pnlsbg' ) )

	end

	local ColorsViewer = vgui.Create( 'hwLib_ColorsViewer', ColorsPanel )
	ColorsViewer:SetPos( 5, 43 )
	ColorsViewer:SetSize( ColorsPanel:GetWide() - 10, ColorsPanel:GetTall() - 84 )

	for i, v in pairs( v.colors ) do

		ColorsViewer:AddColor( v.id, v.name, v.color, rmbCb, doubleCb )

	end

	local ColorsSearch = vgui.Create( 'hwLib_SearchField', ColorsPanel )
	ColorsSearch:SetSize( ColorsPanel:GetWide() - 10, 28 )
	ColorsSearch:SetPos( 5, 5 )
	ColorsSearch:SetColorData( hwLib_GetColor( 'vgui_coloreditor_searchfldbg' ), hwLib_GetColor( 'vgui_icon' ) )
	ColorsSearch.OnChange = function( self, value )

		ColorsViewer:ClearColors()

		for i, v in pairs( v.colors ) do

			if( string.find( string.lower( v.name ), string.lower( value ) ) ) then

				ColorsViewer:AddColor( v.id, v.name, v.color, rmbCb, doubleCb )

			end

		end

	end

	local AddColor = vgui.Create( 'hwLib_DButton', ColorsPanel )
	AddColor:SetBText( 'Add color' )
	AddColor:SetColorData( hwLib_GetColor( 'vgui_coloreditor_lightbtnbg' ), 155, 255 )
	AddColor:SetIcon( 'vgui/plus20.png' )
	AddColor:SetPos( ColorsPanel:GetWide() / 2 - AddColor:GetWide() / 2, ColorsPanel:GetTall() - 35 )

	local OptionsPanel = vgui.Create( 'DPanel', Panel )
	OptionsPanel:SetSize( Panel:GetWide() / 2 - 10, Panel:GetTall() - 10 )
	OptionsPanel:SetPos( Panel:GetWide() / 2 + 5, 5 )
	OptionsPanel.Paint = function( self, w, h )
		
		draw.RoundedBox( 3, 0, 0, w, h, hwLib_GetColor( 'vgui_coloreditor_pnlsbg' ) )

	end

	local ItemSelected = false

	local ColorIdText = vgui.Create( 'DLabel', OptionsPanel )
	ColorIdText:SetTextColor( hwLib_GetColor( 'vgui_text' ) )
	ColorIdText:SetText( 'Color ID' )
	ColorIdText:SetWide( 100 )
	ColorIdText:SetPos( 7, 5 )
	ColorIdText:SetFont( 'hwLib_Montserrat_Medium_16' )

	local ColorId = vgui.Create( 'hwLib_DTextEntry', OptionsPanel )
	ColorId:SetSize( OptionsPanel:GetWide() - 10, 28 )
	ColorId:SetPos( 5, 30 )
	ColorId:SetBGColor( hwLib_GetColor( 'vgui_coloreditor_textentlightbg' ) )

	local ColorNameText = vgui.Create( 'DLabel', OptionsPanel )
	ColorNameText:SetTextColor( hwLib_GetColor( 'vgui_text' ) )
	ColorNameText:SetText( 'Color name' )
	ColorNameText:SetWide( 100 )
	ColorNameText:SetPos( 7, 63 )
	ColorNameText:SetFont( 'hwLib_Montserrat_Medium_16' )

	local ColorName = vgui.Create( 'hwLib_DTextEntry', OptionsPanel )
	ColorName:SetSize( OptionsPanel:GetWide() - 10, 28 )
	ColorName:SetPos( 5, 87 )
	ColorName:SetBGColor( hwLib_GetColor( 'vgui_coloreditor_textentlightbg' ) )

	local ColorPickerText = vgui.Create( 'DLabel', OptionsPanel )
	ColorPickerText:SetTextColor( hwLib_GetColor( 'vgui_text' ) )
	ColorPickerText:SetText( 'Color' )
	ColorPickerText:SetWide( 100 )
	ColorPickerText:SetPos( 7, 120 )
	ColorPickerText:SetFont( 'hwLib_Montserrat_Medium_16' )

	local ColorPicker = vgui.Create( 'hwLib_DColorMixer', OptionsPanel )
	ColorPicker:SetPos( 5, 145 )
	ColorPicker:SetSize( OptionsPanel:GetWide() - 10, 200 )

	local UndoChanges = vgui.Create( 'hwLib_DButton', OptionsPanel )
	UndoChanges:SetBText( 'Undo changes' )
	UndoChanges:SetColorData( hwLib_GetColor( 'vgui_coloreditor_lightbtnbg' ), 155, 255 )
	UndoChanges:SetIcon( 'vgui/rotate20.png' )
	UndoChanges:SetPos( 5, OptionsPanel:GetTall() - 35 )

	local DeleteColor = vgui.Create( 'hwLib_DButton', OptionsPanel )
	DeleteColor:SetBText( 'Delete' )
	DeleteColor:SetColorData( hwLib_GetColor( 'vgui_coloreditor_lightbtnbg' ), 155, 255 )
	DeleteColor:SetIcon( 'vgui/trash20.png' )
	DeleteColor:SetPos( 10 + UndoChanges:GetWide(), OptionsPanel:GetTall() - 35 )

	local CopyColor = vgui.Create( 'hwLib_DIButton', OptionsPanel )
	CopyColor:SetColorData( hwLib_GetColor( 'vgui_coloreditor_lightbtnbg' ), 155, 255 )
	CopyColor:SetIcon( 'vgui/copy20.png' )
	CopyColor:SetPos( OptionsPanel:GetWide() - CopyColor:GetWide() - 5, OptionsPanel:GetTall() - 35 )


	function pasteColor()

		if( copiedColor == nil ) then return end

		ColorPicker:SetColor( copiedColor )
		ColorPicker:SetBaseColor( copiedColor )

	end

	local PasteColor = vgui.Create( 'hwLib_DIButton', OptionsPanel )
	PasteColor:SetColorData( hwLib_GetColor( 'vgui_coloreditor_lightbtnbg' ), 155, 255 )
	PasteColor:SetIcon( 'vgui/clipboard20.png' )
	PasteColor:SetPos( OptionsPanel:GetWide() - CopyColor:GetWide() - PasteColor:GetWide() - 10, OptionsPanel:GetTall() - 35 )
	PasteColor.DoClick = function()
		pasteColor()
	end

	local BlurPanel = vgui.Create( 'DPanel', OptionsPanel )
	BlurPanel:SetSize( OptionsPanel:GetSize() )
	BlurPanel:SetPos( 0, 0 )
	BlurPanel.Paint = function( self, w, h )

		hwLib_Derma_DrawBackgroundBlurInside( self )
		if( !ItemSelected ) then
			draw.SimpleText( 'No color selected', 'hwLib_Montserrat_Medium_19', w / 2, h / 2, hwLib_GetColor( 'vgui_text' ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

	end

	local sendChanges

	local function undoChanges( color )

		ColorId:SetText( color.id )
		ColorName:SetText( color.name )
		ColorPicker:SetColor( color.color )
		ColorPicker:SetBaseColor( color.color )

	end

	local function deleteColor( id )

		hwLib_DialogFrame( 'Continue?', 'Are you sure you want to delete this color?', {
			text = 'Yes',
			cb = function( frame )

				local sendForm = {
					theme_id = v.id,
					id = id,
				}

				hwLib_CreateClientRequest( 'hwLib_DeleteColor', function( message )

					if( message != '201' ) then
						hwLib_DialogFrame( 'Error', message, {
							text = 'Ok',
							cb = function( frame )
								frame:Close()
							end
						})
						return
					end

					ColorsViewer:DeleteColor( id )

					v.colors[ id ] = nil

					if( table.Count( v.colors ) == 0 ) then 
						BlurPanel:SetVisible( true )
						BlurPanel:RequestFocus()
						ItemSelected = false
						Frame:OnCloseFunction( function()
							closeFrame( Frame )
						end)

						Viewer.OnSelect = function( self, currentTheme, nextTheme )

						end
						return
					end

					local color = v.colors[ table.GetKeys( v.colors )[ 1 ] ]

					ColorId:SetText( color.id )
					ColorName:SetText( color.name )
					ColorPicker:SetColor( color.color )
					ColorPicker:SetBaseColor( color.color )

					BlurPanel:SetVisible( false )

					ItemSelected = color

					UndoChanges.DoClick = function()
						undoChanges( color )
					end

					DeleteColor.DoClick = function()
						deleteColor( color.id )
					end

					CopyColor.DoClick = function()
						copyColor( color.color )
					end

					ColorsViewer:VisualSelect( color.id, true )

					Frame:OnCloseFunction( function()

						sendChanges( color, nil, 'on_WindowClose' )

					end)

					Viewer.OnSelect = function( self, currentTheme, nextTheme )

						if( currentTheme != nextTheme and currentTheme != nil ) then
							sendChanges( color, color, 'on_ThemeChanged' )
						end

					end

				end, function() 

					net.WriteTable( sendForm )

				end)

				frame:Close()

			end
		}, {
			text = 'No',
			cb = function( frame )
				frame:Close()
			end
		})

	end

	local function selectColor( color )

		ColorId:SetText( color.id )
		ColorName:SetText( color.name )
		ColorPicker:SetColor( color.color )
		ColorPicker:SetBaseColor( color.color )

		BlurPanel:SetVisible( false )

		ItemSelected = color

		UndoChanges.DoClick = function()
			undoChanges( color )
		end

		DeleteColor.DoClick = function()
			deleteColor( color.id )
		end

		CopyColor.DoClick = function()
			copyColor( color.color )
		end

		ColorsViewer:VisualSelect( color.id, true )

	end

	function sendChanges( color, nextColor, action ) --color, nextColor, frameClosing, themeChanging

		local actions = { --adding table with actions codes
			[ 1 ] = 'on_WindowClose',
			[ 2 ] = 'on_ColorChanged',
			[ 3 ] = 'on_ThemeChanged'
		}

		local newId = ColorId:GetText() --getting new id, name and color
		local newName = ColorName:GetText()
		local newColor = ColorPicker:GetColor()

		if( color.id == newId and color.name == newName and ( color.color.r == newColor.r and color.color.g == newColor.g and color.color.b == newColor.b and color.color.a == newColor.a ) ) then --checking on updates

			if( action == actions[ 1 ] ) then --if action is window close then close window
				closeFrame( Frame ) --closing window
			else
				selectColor( nextColor ) --or select next color
			end
			return --code below doesn't works
		
		end

		local sendForm = { --creating edit form
			theme_id = v.id,
			id = color.id,
			new_id = newId,
			new_name = newName,
			new_color = newColor,
		}

		hwLib_CreateClientRequest( 'hwLib_EditColor', function( message ) --creating request on server

			if( message != '201' ) then --checking on success

				hwLib_DialogFrame( 'Error', message, { --printing error on screen if needed
					text = 'Ok',
					cb = function( frame )
						frame:Close()
					end
				})

				if( action == actions[ 3 ] ) then --if action is theme changing then just undo changes
					undoChanges( color )
				end

				return --code below doesn't works

			end

			if( action == actions[ 1 ] ) then --if action is close window and all okey just close window
				closeFrame( Frame ) --closing window
				return --code below doesn't works
			end

			ColorsViewer:EditColor( color.id, newId, newName, newColor ) --visual color updating because below we changing color.id

			color.id = newId --updating id
			color.name = newName --updating name
			color.color = newColor --updating color

			v.colors[ color.id ] = nil --deleting old color with old id
			v.colors[ newId ] = color --adding new color with new id

			if( action == actions[ 2 ] ) then --if action is changing color then select next color
				selectColor( nextColor ) --selecting next color
			end

		end, function() 

			net.WriteTable( sendForm )

		end)

	end 

	ColorsViewer.OnSelect = function( self, id )

		local color = v.colors[ id ] --getting current color from table

		if( ItemSelected ) then --if currently item selected then check on coincidence else just select color
			if( ItemSelected.id == id ) then return end --checking on coincidence, if coincidence then code doesn't work below
			sendChanges( ItemSelected, color, 'on_ColorChanged' ) --sending changes
		else
			selectColor( color ) --selecting color
		end

		Frame:OnCloseFunction( function() --setup close function

			sendChanges( ItemSelected, nil, 'on_WindowClose' )

		end)

		Viewer.OnSelect = function( self, currentTheme, nextTheme )

			if( currentTheme != nextTheme and currentTheme != nil ) then
				sendChanges( ItemSelected, color, 'on_ThemeChanged' )
			end

		end

	end

	AddColor.DoClick = function()

		local id = 'unnamed_color' .. table.Count( v.colors )

		local colorForm = {
			id = id,
			name = 'New color',
			color = Color( 255, 255, 255, 255 ),
		}

		v.colors[ id ] = colorForm

		hwLib_AddColor( v.id, colorForm.id, colorForm.name, colorForm.color )

		ColorsViewer:AddColor( colorForm.id, colorForm.name, colorForm.color, rmbCb, doubleCb )

	end

end

function hwLib_ColorEditor( themes )

	local ThemeFrame
	local Viewer
	local deleteTheme
	local editTheme
	local Frame = vgui.Create( 'hwLib_DFrame' )
	Frame:SetSize( 800, 500 )
	Frame:Center()
	Frame:SetTitle( 'Theme editor' )
	Frame:SetDraggable( false )
	Frame:MakePopup()

	local function addThemeUI()

		if( IsValid( ThemeFrame ) ) then ThemeFrame:Close() end

		ThemeFrame = vgui.Create( 'hwLib_DFrame' )
		ThemeFrame:SetSize( 300, 189 )
		ThemeFrame:Center()
		ThemeFrame:SetTitle( 'Create theme' )
		ThemeFrame:SetDraggable( false )
		ThemeFrame:MakePopup()
		ThemeFrame:SetBackgroundBlur( true )

		local ThemeIdText = vgui.Create( 'DLabel', ThemeFrame )
		ThemeIdText:SetTextColor( hwLib_GetColor( 'vgui_text' ) )
		ThemeIdText:SetText( 'Theme ID' )
		ThemeIdText:SetWide( 100 )
		ThemeIdText:SetPos( 12, 31 )
		ThemeIdText:SetFont( 'hwLib_Montserrat_Medium_16' )

		local ThemeId = vgui.Create( 'hwLib_DTextEntry', ThemeFrame )
		ThemeId:SetSize( ThemeFrame:GetWide() - 20, 28 )
		ThemeId:SetPos( 10, 56 )
		ThemeId:SetBGColor( hwLib_GetColor( 'vgui_coloreditor_textentdarkbg' ) )

		local ThemeNameText = vgui.Create( 'DLabel', ThemeFrame )
		ThemeNameText:SetTextColor( hwLib_GetColor( 'vgui_text' ) )
		ThemeNameText:SetText( 'Theme name' )
		ThemeNameText:SetWide( 100 )
		ThemeNameText:SetPos( 12, 89 )
		ThemeNameText:SetFont( 'hwLib_Montserrat_Medium_16' )

		local ThemeName = vgui.Create( 'hwLib_DTextEntry', ThemeFrame )
		ThemeName:SetSize( ThemeFrame:GetWide() - 20, 28 )
		ThemeName:SetPos( 10, 114 )
		ThemeName:SetBGColor( hwLib_GetColor( 'vgui_coloreditor_textentdarkbg' ) )

		local AddTheme = vgui.Create( 'hwLib_DButton', ThemeFrame )
		AddTheme:SetBText( 'Add theme' )
		AddTheme:SetColorData( hwLib_GetColor( 'vgui_coloreditor_darkbtnbg' ), 255, 155 )
		AddTheme:SetIcon( 'vgui/plus20.png' )
		AddTheme:SetPos( 10, ThemeFrame:GetTall() - 40 )
		AddTheme.DoClick = function()

			local sendForm = {
				id = ThemeId:GetText(),
				name = ThemeName:GetText(),
			}

			hwLib_CreateClientRequest( 'hwLib_AddTheme', function( message )

				if( message != '201' ) then

					hwLib_DialogFrame( 'Error', message, {
						text = 'Ok',
						cb = function( frame )
							frame:Close()
						end
					})

					return

				end

				local themeForm = {
					id = sendForm.id,
					name = sendForm.name,
					colors = {},
				}

				themes[ sendForm.id ] = themeForm

				hwLib_AddThemeTab( Frame, Viewer, themeForm, addThemeUI, deleteTheme, editTheme )

				ThemeFrame:Close()

			end, function() 

				net.WriteTable( sendForm )

			end)

		end

	end

	Viewer = vgui.Create( 'hwLib_ThemeViewer', Frame )
	Viewer:SetSize( 780, 454 )
	Viewer:SetPos( 10, 36 )
	Viewer.DoAddBClick = function()

		addThemeUI()

	end

	function deleteTheme( id )

		hwLib_DialogFrame( 'Continue?', 'Are you sure you want to delete this theme?', {
			text = 'Yes',
			cb = function( frame )

				local sendForm = {
					id = id,
				}

				hwLib_CreateClientRequest( 'hwLib_DeleteTheme', function( message )

					if( message != '201' ) then

						hwLib_DialogFrame( 'Error', message, {
							text = 'Ok',
							cb = function( frame )
								frame:Close()
							end
						})

						return

					end

					themes[ id ] = nil

					Frame:OnCloseFunction( function() closeFrame( Frame ) end)

					Viewer:DeleteTab( id )
					frame:Close()

				end, function() 

					net.WriteTable( sendForm )

				end)

			end
		}, {
			text = 'No',
			cb = function( frame )
				frame:Close()
			end
		})

	end

	function editTheme( id )

		local EditTheme = vgui.Create( 'hwLib_DFrame' )
		EditTheme:SetSize( 300, 189 )
		EditTheme:Center()
		EditTheme:SetTitle( 'Edit theme' )
		EditTheme:SetDraggable( false )
		EditTheme:MakePopup()
		EditTheme:SetBackgroundBlur( true )

		local ThemeIdText = vgui.Create( 'DLabel', EditTheme )
		ThemeIdText:SetTextColor( hwLib_GetColor( 'vgui_text' ) )
		ThemeIdText:SetText( 'Theme ID' )
		ThemeIdText:SetWide( 100 )
		ThemeIdText:SetPos( 12, 31 )
		ThemeIdText:SetFont( 'hwLib_Montserrat_Medium_16' )

		local ThemeId = vgui.Create( 'hwLib_DTextEntry', EditTheme )
		ThemeId:SetSize( EditTheme:GetWide() - 20, 28 )
		ThemeId:SetPos( 10, 56 )
		ThemeId:SetBGColor( hwLib_GetColor( 'vgui_coloreditor_textentdarkbg' ) )

		local ThemeNameText = vgui.Create( 'DLabel', EditTheme )
		ThemeNameText:SetTextColor( hwLib_GetColor( 'vgui_text' ) )
		ThemeNameText:SetText( 'Theme name' )
		ThemeNameText:SetWide( 100 )
		ThemeNameText:SetPos( 12, 89 )
		ThemeNameText:SetFont( 'hwLib_Montserrat_Medium_16' )

		local ThemeName = vgui.Create( 'hwLib_DTextEntry', EditTheme )
		ThemeName:SetSize( EditTheme:GetWide() - 20, 28 )
		ThemeName:SetPos( 10, 114 )
		ThemeName:SetBGColor( hwLib_GetColor( 'vgui_coloreditor_textentdarkbg' ) )

		local AddTheme = vgui.Create( 'hwLib_DButton', EditTheme )
		AddTheme:SetBText( 'Save' )
		AddTheme:SetColorData( hwLib_GetColor( 'vgui_coloreditor_darkbtnbg' ), 255, 155 )
		AddTheme:SetIcon( 'vgui/check20.png' )
		AddTheme:SetPos( 10, EditTheme:GetTall() - 40 )

		ThemeId:SetText( themes[ id ].id )
		ThemeName:SetText( themes[ id ].name )

		AddTheme.DoClick = function()

			local sendForm = {
				id = id,
				new_id = ThemeId:GetText(),
				new_name = ThemeName:GetText(),
			}

			hwLib_CreateClientRequest( 'hwLib_EditTheme', function( message )

				if( message != '201' ) then

					hwLib_DialogFrame( 'Error', message, {
						text = 'Ok',
						cb = function( frame )
							frame:Close()
						end
					})

					return

				end

				local theme = themes[ id ]

				theme.id = sendForm.new_id
				theme.name = sendForm.new_name
				themes[ id ] = nil
				themes[ sendForm.new_id ] = theme

				Viewer:EditTab( id, sendForm.new_name, sendForm.new_id )
				EditTheme:Close()
				
			end, function() 

				net.WriteTable( sendForm )

			end)

		end

	end

	for i, v in pairs( themes ) do

		hwLib_AddThemeTab( Frame, Viewer, v, addThemeUI, deleteTheme, editTheme )

	end

end

--[[-----------------------------
Editor initialization and network
-------------------------------]]

function hwLib_ColorEditorInit()

	local themesList = {}

	hwLib_CreateClientRequest( 'hwLib_GetThemes', function( themes )

		if( table.IsEmpty( themes ) ) then
			hwLib_ColorEditor( {} )
			return
		end

		for i, v in pairs( themes ) do

			hwLib_CreateClientRequest( 'hwLib_GetTheme', function( theme )

				themesList[ theme.id ] = theme

				if( i == #themes ) then
					hwLib_ColorEditor( themesList )
				end

			end, function() 

				net.WriteString( v.id )

			end)

		end

	end, nil )

end

concommand.Add( 'hwLib_ColorEditor', hwLib_ColorEditorInit )