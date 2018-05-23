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
