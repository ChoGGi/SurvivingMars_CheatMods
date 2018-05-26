function OnMsg.ClassesGenerate()
  ChoGGiX.MsgFuncs.ShuttleControl_ClassesGenerate()
end

function OnMsg.ClassesPreprocess()
  ChoGGiX.MsgFuncs.ShuttleControl_ClassesPreprocess()
end

function OnMsg.ClassesBuilt()
  ChoGGiX.MsgFuncs.ReplacedFunctions_ClassesBuilt()
  ChoGGiX.MsgFuncs.ShuttleControl_ClassesBuilt()
end

function OnMsg.LoadingScreenPreClose()
  local UICity = UICity

  --for new games
  if not UICity then
    return
  end

  --clear out Temp settings
  ChoGGiX.Temp.DefenceTowerRocketDD = {}
  ChoGGiX.Temp.ShuttleRocketDD = {}
  ChoGGiX.Temp.CargoShuttleThreads = {}
  ChoGGiX.Temp.CargoShuttleScanningAnomaly = {}
  ChoGGiX.Temp.UnitPathingHandles = {}

end

function OnMsg.NewDay() --newsol
  local ChoGGiX = ChoGGiX
  local UICity = UICity

  --clean up old handles
  if next(ChoGGiX.Temp.CargoShuttleThreads) then
    for h,_ in pairs(ChoGGiX.Temp.CargoShuttleThreads) do
      if not IsValid(HandleToObject[h]) then
        ChoGGiX.Temp.CargoShuttleThreads[h] = nil
      end
    end
  end

end
