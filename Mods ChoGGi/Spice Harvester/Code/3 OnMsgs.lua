local SaveOrigFunc = SpiceHarvester.ComFuncs.SaveOrigFunc

local HandleToObject = HandleToObject
local IsValid = IsValid

function OnMsg.ClassesGenerate()
  --custom shuttletask
  DefineClass.SpiceHarvester_ShuttleFollowTask = {
    __parents = {"InitDone"},
    state = "new",
    shuttle = false,
    dest_pos = false, --there isn't one, but adding one prevents log spam
  }
  --if it idles it'll go home, so we return my command till we remove thread
  SaveOrigFunc("CargoShuttle","Idle")
  function CargoShuttle:Idle()
    if self.SpiceHarvester_FollowHarvesterShuttle then
      self:SetCommand("SpiceHarvester_FollowHarvester")
      Sleep(250)
    else
      return SpiceHarvester.OrigFuncs.CargoShuttle_Idle(self)
    end
  end

end

function OnMsg.ClassesPreprocess()
  CargoShuttle.defence_thread_DD = false
end

function OnMsg.ClassesBuilt()

  --gives an error when we spawn shuttle since i'm using a fake task
  SaveOrigFunc("CargoShuttle","OnTaskAssigned")
  function CargoShuttle:OnTaskAssigned()
    if self.SpiceHarvester_FollowHarvesterShuttle then
      return true
    else
      return SpiceHarvester.OrigFuncs.CargoShuttle_OnTaskAssigned(self)
    end
  end

end

function OnMsg.LoadingScreenPreClose()
  local UICity = UICity

  --for new games
  if not UICity then
    return
  end
  --place to store per-game values
  if not UICity.SpiceHarvester then
    UICity.SpiceHarvester = {}
  end
  --controllable shuttle handles launched (true = attacker, false = friend)
  if not UICity.SpiceHarvester.CargoShuttleThreads then
    UICity.SpiceHarvester.CargoShuttleThreads = {}
  end

  --clear out Temp settings
  SpiceHarvester.Temp.UnitPathingHandles = {}

end

function OnMsg.NewDay() --newsol
  local UICity = UICity

  --clean up old handles
  if next(UICity.SpiceHarvester.CargoShuttleThreads) then
    for h,_ in pairs(UICity.SpiceHarvester.CargoShuttleThreads) do
      if not IsValid(HandleToObject[h]) then
        UICity.SpiceHarvester.CargoShuttleThreads[h] = nil
      end
    end
  end

end
