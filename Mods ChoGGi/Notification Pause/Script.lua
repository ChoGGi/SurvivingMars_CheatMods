local GetHUD = GetHUD

function OnMsg.ClassesBuilt()

  --does nothing instead of updating g_HeavyLoadDroneHubs
  function DroneControl:UpdateHeavyLoadNotification() end

  --pause when new notif happens
  local orig_AddOnScreenNotification = AddOnScreenNotification
  function AddOnScreenNotification(id, callback, params, cycle_objs)
    local hud = GetHUD()
    if hud then
      UICity:SetGameSpeed(0)
      GetHUD().prev_UISpeedState = UISpeedState
      UISpeedState = "pause"
    end
    orig_AddOnScreenNotification(id, callback, params, cycle_objs)
  end

end

local function SomeCode()
  local table = table
  --make sure there aren't any showing at the moment
  g_HeavyLoadDroneHubs = {}

  local notif = g_ActiveOnScreenNotifications
  for i = #notif, 1, -1 do
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
