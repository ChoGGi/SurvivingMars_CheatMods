-- See LICENSE for terms

local lookup_skips = {
	TransportationDroneOverload = true,
	StarvingColonists = true,
}

local function PauseGame(id)
	if lookup_skips[id] or not GameState.gameplay then
		return
	end

	SetGameSpeedState("pause")
end

-- pause when new notif happens
local orig_AddOnScreenNotification = AddOnScreenNotification
function AddOnScreenNotification(id, ...)
	PauseGame(id)
	return orig_AddOnScreenNotification(id, ...)
end

local orig_AddCustomOnScreenNotification = AddCustomOnScreenNotification
function AddCustomOnScreenNotification(id, ...)
	PauseGame(id)
	return orig_AddCustomOnScreenNotification(id, ...)
end
