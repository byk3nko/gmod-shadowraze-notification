local function addNotification( msgText, msgType, msgTime )

	if IsValid( LocalPlayer() ) then
		LocalPlayer():EmitSound( "shadowraze/shadowraze.wav", 100, math.random( 90,110 ), 0.5 )
	end

end

notification.AddLegacy = addNotification