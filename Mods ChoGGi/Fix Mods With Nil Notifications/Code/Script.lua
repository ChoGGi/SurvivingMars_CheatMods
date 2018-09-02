local unpack_params = unpack_params

local orig_LoadCustomOnScreenNotification = LoadCustomOnScreenNotification
function LoadCustomOnScreenNotification(notification)
	-- the first return is id, and some mods (cough Ambassadors cough) send a nil id, which breaks the func
	if unpack_params(notification) then
		return orig_LoadCustomOnScreenNotification(notification)
	end
end
