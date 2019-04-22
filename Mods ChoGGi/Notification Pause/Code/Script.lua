-- See LICENSE for terms

local function PauseGame(id)
	if id == "TransportationDroneOverload" or not GameState.gameplay then
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

function OnMsg.LoadGame()
  -- make sure there aren't any showing at the moment
  g_HeavyLoadDroneHubs = {}

  local notif = g_ActiveOnScreenNotifications
	for i = 1, #notif do
    if notif[i][1] == "TransportationDroneOverload" then
      table.remove(notif,i)
      break
    end
  end
end
