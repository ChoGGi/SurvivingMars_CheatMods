--keep everything stored in
ChoGGiX = {
  email = "ECM@ChoGGi.org",
  --orig funcs that we replace
  OrigFuncs = {},
  --CommonFunctions.lua
  ComFuncs = {},
  --OnMsgs.lua
  MsgFuncs = {},
  --/Code/_Functions.lua
  CodeFuncs = {},
  --InfoPaneCheats.lua
  InfoFuncs = {},
  --Defaults.lua
  SettingFuncs = {},
  --temporary settings that aren't saved to SettingsFile
  Temp = {
    --collect msgs to be displayed when game is loaded
    StartupMsgs = {},
    --list of dustdevil handles we've shot at
    DefenceTowerRocketDD = {},
    --same
    ShuttleRocketDD = {},
    --controllable shuttle handles launched (true = attacker, false = friend)
    CargoShuttleThreads = {},
    --we just want one shuttle scanning per anomaly (list of anomaly handles that are being scanned)
    CargoShuttleScanningAnomaly = {},
    --handles of units we're placing waypoints for (keys=handles,values=threads)
    UnitPathingHandles = {},
  },
  UserSettings = {ShowShuttleControls=true},
}

function ChoGGiX.ComFuncs.SaveOrigFunc(ClassOrFunc,Func)
  local ChoGGiX = ChoGGiX
  if Func then
    local newname = ClassOrFunc .. "_" .. Func
    if not ChoGGiX.OrigFuncs[newname] then
      ChoGGiX.OrigFuncs[newname] = _G[ClassOrFunc][Func]
    end
  else
    if not ChoGGiX.OrigFuncs[ClassOrFunc] then
      ChoGGiX.OrigFuncs[ClassOrFunc] = _G[ClassOrFunc]
    end
  end
end
function ChoGGiX.ComFuncs.MsgPopup(Msg,Title,Icon)
  pcall(function()
    --returns translated text corresponding to number if we don't do tostring for numbers
    Msg = tostring(Msg)
    Title = Title or "Placeholder"
    Icon = Icon or "UI/Icons/Notifications/placeholder.tga"
    local id = AsyncRand()
    local timeout = 8000
    if type(AddCustomOnScreenNotification) == "function" then --if we called it where there ain't no UI
      CreateRealTimeThread(function()
        AddCustomOnScreenNotification(
          id,Title,Msg,Icon,nil,{expiration=timeout}
        )
        --since I use AsyncRand for the id, I don't want this getting too large.
        g_ShownOnScreenNotifications[id] = nil
      end)
    end
  end)
end
