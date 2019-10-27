-- See LICENSE for terms

local unpack = table.unpack

local orig_LoadCustomOnScreenNotification = LoadCustomOnScreenNotification
function LoadCustomOnScreenNotification(notification)
	-- the first return is id, and some mods (cough Ambassadors cough) send a nil id, which breaks the func
	if unpack(notification) then
		return orig_LoadCustomOnScreenNotification(notification)
	end
end
