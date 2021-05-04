surface.CreateFont( "Trajan", {
    font = "Trajan",
    font = "Trajan pro 3",
    extended = false,
    size = 36,
    weight = 400,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

local ScreenPos = ScrH() - 200

local ForegroundColor = Color( 230, 230, 230 )
local BackgroundColor = Color( 0, 0, 0, 235 )

local Colors = {}
Colors[ NOTIFY_GENERIC ] = Color( 52, 73, 94 )
Colors[ NOTIFY_ERROR ] = Color( 192, 57, 43 )
Colors[ NOTIFY_UNDO ] = Color( 41, 128, 185 )
Colors[ NOTIFY_HINT ] = Color( 39, 174, 96 )
Colors[ NOTIFY_CLEANUP ] = Color( 243, 156, 18 )

local LoadingColor = Color( 22, 160, 133 )

local Icons = {}
Icons[ NOTIFY_GENERIC ] = Material( "notifications/cleanup.png" )
Icons[ NOTIFY_ERROR ] = Material( "notifications/cleanup.png" )
Icons[ NOTIFY_UNDO ] = Material( "notifications/cleanup.png" )
Icons[ NOTIFY_HINT ] = Material( "notifications/cleanup.png" )
Icons[ NOTIFY_CLEANUP ] = Material( "notifications/cleanup.png" )

local LoadingIcon = Material( "notifications/loading.png" )
local Notifications = {}

local function DrawNotification( x, y, w, h, text, icon, col, progress )
	draw.RoundedBoxEx( 4, x, y, w, h, BackgroundColor, false, true, false, true )

	if progress then
		draw.RoundedBoxEx( 4, x, y, h + ( w - h ) * progress, h, true, false, true, false )
	else
		
	end

	draw.SimpleText( text, "Trajan", x + 32 + 10, y + h / 2, ForegroundColor,
		TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

	surface.SetDrawColor( ForegroundColor )
	surface.SetMaterial( icon )

	if progress then
		surface.DrawTexturedRectRotated( x + 32, y + h / 2, 32, 32, -CurTime() * 360 % 360 )
	else
		surface.DrawTexturedRect( x, y, 32, 32 )
	end
end

function notification.AddLegacy( text, type, time )
	surface.SetFont( "Trajan" )
	surface.PlaySound( "shadowraze/shadowraze.wav", 100, math.random( 90,110 ), 0.5 )
	local w = surface.GetTextSize( text ) + 20 + 32
	local h = 32
	local x = ScrW()
	local y = ScreenPos

	table.insert( Notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,

		text = text,
		col = Colors[ type ],
		icon = Icons[ type ],
		time = CurTime() + time,

		progress = nil,
	} )
end

function notification.AddProgress( id, text, frac )
	for k, v in ipairs( Notifications ) do
		if v.id == id then
			v.text = text
			v.progress = frac
			
			return
		end
	end

	surface.SetFont( "Trajan" )

	local w = surface.GetTextSize( text ) + 20 + 32
	local h = 32
	local x = ScrW()
	local y = ScreenPos

	table.insert( Notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,

		id = id,
		text = text,
		col = LoadingColor,
		icon = LoadingIcon,
		time = math.huge,

		progress = math.Clamp( frac or 0, 0, 1 ),
	} )	
end

function notification.Kill( id )
	for k, v in ipairs( Notifications ) do
		if v.id == id then v.time = 0 end
	end
end


hook.Add( "HUDPaint", "DrawNotifications", function()
	for k, v in ipairs( Notifications ) do
		DrawNotification( math.floor( v.x ), math.floor( v.y ), v.w, v.h, v.text, v.icon, v.col, v.progress )
		v.x = Lerp( FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - v.w - 10 or ScrW() + 1 )
		v.y = Lerp( FrameTime() * 10, v.y, ScreenPos - ( k - 1 ) * ( v.h + 5 ) )
	end
	for k, v in ipairs( Notifications ) do
		if v.x >= ScrW() and v.time < CurTime() then
			table.remove( Notifications, k )
		end
	end
end )
