hwLib_UID_BITS = 32

if SERVER then

hwLib_Callbacks = {}

function hwLib_CreateServerSender( id, receive, send )

	util.AddNetworkString( id )

	net.Receive( id, function( len, ply )

		local uniqueId = net.ReadUInt( hwLib_UID_BITS )

		receive( ply, function( ... )

			net.Start( id )
				net.WriteUInt( uniqueId, hwLib_UID_BITS )
				if( send != nil ) then send( ... ) end
			net.Send( ply )

		end)

	end)

end

function hwLib_CreateServerReceiver( id, read )

	util.AddNetworkString( id )

	net.Receive( id, function( len, ply ) 

		local uniqueId = net.ReadUInt( hwLib_UID_BITS )

		local cb = hwLib_Callbacks[ uniqueId ]

		if( cb ) then

			cb( ply, read() )

			hwLib_Callbacks[ uniqueId ] = nil

		end

	end)

end

function hwLib_CreateServerRequest( id, callback, send )

	local uniqueId = math.random( 1, 10000 ) + math.random( 1, 10000 )

	net.Start( id )
		net.WriteUInt( uniqueId, hwLib_UID_BITS )
		if( send != nil ) then send() end
	net.Broadcast()

	hwLib_Callbacks[ uniqueId ] = callback

end

elseif CLIENT then

hwLib_Callbacks = {}

function hwLib_CreateClientReceiver( id, read )

	net.Receive( id, function( len, ply ) 

		local uniqueId = net.ReadUInt( hwLib_UID_BITS )

		local cb = hwLib_Callbacks[ uniqueId ]

		if( cb ) then

			cb( read() )

			hwLib_Callbacks[ uniqueId ] = nil

		end

	end)

end

function hwLib_CreateClientRequest( id, callback, send )

	local uniqueId = math.random( 1, 10000 ) + math.random( 1, 10000 )

	net.Start( id )
		net.WriteUInt( uniqueId, hwLib_UID_BITS )
		if( send != nil ) then send() end
	net.SendToServer()

	hwLib_Callbacks[ uniqueId ] = callback

end

function hwLib_CreateClientSender( id, receive, send )

	net.Receive( id, function()

		local uniqueId = net.ReadUInt( hwLib_UID_BITS )

		receive( function( ... )

			net.Start( id )
				net.WriteUInt( uniqueId, hwLib_UID_BITS )
				if( send != nil ) then send( ... ) end
			net.SendToServer()

		end)

	end)

end

end








if SERVER then

util.AddNetworkString( 'big_data' )

local chunks_count
local CHUNK_SIZE
local crc

local out
local counter
local time_start

net.Receive( 'big_data', function( len, ply )

	local rType = net.ReadString()
	if( rType == 'init' ) then
		print( 'delivery inizialization' )
		chunks_count = net.ReadInt( 32 )
		CHUNK_SIZE = net.ReadInt( 32 )
		crc = net.ReadString()

		out = ''
		counter = 0

		net.Start( 'big_data' )
		net.Send( ply )
		time_start = SysTime()
	end

	if( rType == 'sending' ) then
		print( 'delivered chunk ' .. counter )
		local chunkSize = net.ReadInt( 32 )
		local chunk = net.ReadData( chunkSize )
		print( 'chunk size ' .. chunkSize )
		out = out .. chunk
		if( counter == chunks_count ) then
			print( 'delivery time ' .. SysTime() - time_start )
			print( 'checksum ' .. util.CRC( out ) )
			if( util.CRC( out ) == crc ) then
				print( 'success delivery!' )
			else
				print( 'crc invalid' )
			end
			print( 'delivered ' .. #out )
			file.Write( 'result.png', out )
		else
			net.Start( 'big_data' )
			net.Send( ply )
		end
		counter = counter + 1
	end

end)

elseif CLIENT then

local CHUNK_SIZE = 32000
local make_screenshot = false
local data
local start_pos
local end_pos
local chunks_count
local chunks = {}
local counter

concommand.Add( 'test', function()

	make_screenshot = true

end)

hook.Add( 'PostRender', 'test', function()

	if( !make_screenshot ) then return end
	make_screenshot = false

	local pngData = render.Capture( {
		format = 'png',
		x = 0,
		y = 0,
		w = ScrW(),
		h = ScrH(),
		alpha = false,
	} )

	data = pngData

	chunks_count = math.ceil( #data / CHUNK_SIZE ) - 1
	chunks = {}
	start_pos = 1
	end_pos = CHUNK_SIZE
	counter = 0

	print( 'size of content ' .. #data )
	print( 'chunks count ' .. chunks_count )
	print( '-----------------' )

	net.Start( 'big_data' )
		net.WriteString( 'init' )
		net.WriteInt( chunks_count, 32 )
		net.WriteInt( CHUNK_SIZE, 32 )
		net.WriteString( util.CRC( data ) )
	net.SendToServer()

end)

net.Receive( 'big_data', function()

	local chunk = string.sub( data, start_pos, end_pos )

	print( 'printing chunk with size ' .. #chunk )
	--print( chunk )
	print( '-----------------' )

	start_pos = start_pos + CHUNK_SIZE
	end_pos = end_pos + CHUNK_SIZE

	net.Start( 'big_data' )
		net.WriteString( 'sending' )
		net.WriteInt( #chunk, 32 )
		net.WriteData( chunk, #chunk )
	net.SendToServer()

	if( counter == chunks_count ) then return end
	counter = counter + 1

end)

end