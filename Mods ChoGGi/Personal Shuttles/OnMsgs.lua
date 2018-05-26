function OnMsg.ClassesGenerate()
  PersonalShuttles.MsgFuncs.ShuttleControl_ClassesGenerate()
end

function OnMsg.ClassesPreprocess()
  PersonalShuttles.MsgFuncs.ShuttleControl_ClassesPreprocess()
end

function OnMsg.ClassesBuilt()
  PersonalShuttles.MsgFuncs.ReplacedFunctions_ClassesBuilt()
  PersonalShuttles.MsgFuncs.ShuttleControl_ClassesBuilt()
end

function OnMsg.LoadingScreenPreClose()
  local UICity = UICity

  --for new games
  if not UICity then
    return
  end
  --place to store per-game values
  if not UICity.PersonalShuttles then
    UICity.PersonalShuttles = {}
  end
  --objects carried by shuttles
  if not UICity.PersonalShuttles.CargoShuttleCarried then
    UICity.PersonalShuttles.CargoShuttleCarried = {}
  end
  --controllable shuttle handles launched (true = attacker, false = friend)
  if not UICity.PersonalShuttles.CargoShuttleThreads then
    UICity.PersonalShuttles.CargoShuttleThreads = {}
  end
  --we just want one shuttle scanning per anomaly (list of anomaly handles that are being scanned)
  if not UICity.PersonalShuttles.CargoShuttleScanningAnomaly then
    UICity.PersonalShuttles.CargoShuttleScanningAnomaly = {}
  end

  --clear out Temp settings
  PersonalShuttles.Temp.ShuttleRocketDD = {}
  PersonalShuttles.Temp.UnitPathingHandles = {}

end

function OnMsg.NewDay() --newsol
  local PersonalShuttles = PersonalShuttles
  local UICity = UICity

  --clean up old handles
  if next(UICity.PersonalShuttles.CargoShuttleThreads) then
    for h,_ in pairs(UICity.PersonalShuttles.CargoShuttleThreads) do
      if not IsValid(HandleToObject[h]) then
        UICity.PersonalShuttles.CargoShuttleThreads[h] = nil
      end
    end
  end

end
