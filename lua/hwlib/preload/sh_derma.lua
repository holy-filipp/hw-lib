--[[----------------- название файла сменить
Derma background blur
-------------------]]

local blurScreen = Material( "pp/blurscreen" )

function hwLib_Derma_DrawBackgroundBlurInside( panel )

	local x, y = panel:LocalToScreen( 0, 0 )

    surface.SetMaterial( blurScreen )
    surface.SetDrawColor( 255, 255, 255, 255 )

    for i = 0.33, 1, 0.33 do
        blurScreen:SetFloat( "$blur", 5 * i )
        blurScreen:Recompute()
        if ( render ) then render.UpdateScreenEffectTexture() end
        surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
    end

    surface.SetDrawColor( 10, 10, 10, 150 )
    surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )

end

--[[--------
Dialog frame
----------]]

if CLIENT then

function hwLib_DialogFrame( title, text, ... )

    if( title == nil or text == nil ) then return end

    local buttons = { ... } or {}

    local buttonsPanels = {}

    local Frame = vgui.Create( 'hwLib_DFrame' )
    Frame:SetWide( 300 )
    Frame:SetTitle( title )
    Frame:SetDraggable( false )
    Frame:MakePopup()
    Frame:SetBackgroundBlur( true )

    local Text = vgui.Create( 'DLabel', Frame )
    Text:SetFont( 'hwLib_Montserrat_Medium_16' )
    Text:SetPos( 10, 36 )
    Text:SetWide( 280 )
    Text:SetText( text )
    Text:SetWrap( true )
    Text:SetAutoStretchVertical( true )
    Text:SetTextColor( Color( 255, 255, 255, 255 ) )

    local indent = 0

    for i, v in pairs( buttons ) do

        local Choice = vgui.Create( 'hwLib_DButton', Frame )
        Choice:SetBText( v.text )
        Choice:SetPos( 10 + indent, 0 )
        Choice:SetColorData( Color( 30, 30, 30 ), 255, 150 )
        if( v.icon ) then
            Choice:SetIcon( v.icon )
        end
        Choice.DoClick = function()
            v.cb( Frame )
        end

        indent = indent + Choice:GetWide() + 5

        if( indent > 290 ) then
            Frame:SetWide( indent + 15 )
        end

        table.insert( buttonsPanels, Choice )

    end

    local function updateSizes( w, h )

        if( !table.IsEmpty( buttons ) ) then

            Frame:SetTall( Frame:GetTall() + 35 )

        end

        for i, v in pairs( buttonsPanels ) do

            local x, y = v:GetPos()

            v:SetPos( x, Frame:GetTall() - 35 )

        end          

    end

    Text.OnSizeChanged = function( self, w, h )

        Frame:SetTall( h + 46 )
        Frame:Center()

        updateSizes( w, h )

    end

end

end