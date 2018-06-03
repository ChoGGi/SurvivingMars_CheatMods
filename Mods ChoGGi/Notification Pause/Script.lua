
function OnMsg.ClassesBuilt()

  --does nothing instead of updating g_HeavyLoadDroneHubs
  function DroneControl:UpdateHeavyLoadNotification()
  end

  --pause when new notif happens
  local orig_AddOnScreenNotification = AddOnScreenNotification
  function AddOnScreenNotification(id, callback, params, cycle_objs)
    --GetHUD().idPause:OnPress()
    UICity:SetGameSpeed(0)
    GetHUD().prev_UISpeedState = UISpeedState
    UISpeedState = "pause"
    orig_AddOnScreenNotification(id, callback, params, cycle_objs)
  end

end

function OnMsg.LoadGame()

  --make sure there aren't any showing at the moment
  g_HeavyLoadDroneHubs = {}

  local notif = g_ActiveOnScreenNotifications
  for i = 1, #notif do
    if notif[i][1] == "TransportationDroneOverload" then
      table.remove(notif,i)
      break
    end
  end

end