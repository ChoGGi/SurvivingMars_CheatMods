-- See LICENSE for terms

local SetGameSpeedState = SetGameSpeedState

local function PauseGame()
	if not GameState.gameplay then
		return
	end

	SetGameSpeedState("pause")
end

function OnMsg.ClassesBuilt()

  -- does nothing instead of updating g_HeavyLoadDroneHubs
	DroneControl.UpdateHeavyLoadNotification = empty_func
--~   function DroneControl:UpdateHeavyLoadNotification()
--~ 	end

  --pause when new notif happens
  local orig_AddOnScreenNotification = AddOnScreenNotification
  function AddOnScreenNotification(id, callback, params, cycle_objs)
    PauseGame()
    return orig_AddOnScreenNotification(id, callback, params, cycle_objs)
  end

  local orig_AddCustomOnScreenNotification = AddCustomOnScreenNotification
  function AddCustomOnScreenNotification(id, title, text, image, callback, params)
    PauseGame()
    return orig_AddCustomOnScreenNotification(id, title, text, image, callback, params)
  end

end

local function SomeCode()
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

function OnMsg.CityStart()
  SomeCode()
end

function OnMsg.LoadGame()
  SomeCode()
end
