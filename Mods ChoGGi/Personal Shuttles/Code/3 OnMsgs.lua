
local next,pairs = next,pairs
local IsValid = IsValid
local Sleep = Sleep

function OnMsg.ClassesGenerate()
  --custom shuttletask
  DefineClass.PersonalShuttles_ShuttleFollowTask = {
    __parents = {"InitDone"},
    state = "new",
    shuttle = false,
    scanning = false, --from explorer code for AnalyzeAnomaly
    dest_pos = false, --there isn't one, but adding one prevents log spam
  }
end

function OnMsg.ClassesPreprocess()
  CargoShuttle.defence_thread_DD = false
end

function OnMsg.ClassesBuilt()
  local SaveOrigFunc = PersonalShuttles.ComFuncs.SaveOrigFunc
  SaveOrigFunc("CargoShuttle","GameInit")
  SaveOrigFunc("CargoShuttle","Idle")
  SaveOrigFunc("CargoShuttle","OnTaskAssigned")
  local PersonalShuttles_OrigFuncs = PersonalShuttles.OrigFuncs

  --if it idles it'll go home, so we return my command till we remove thread
  function CargoShuttle:Idle()
    if self.PersonalShuttles_FollowMouseShuttle then
      self:SetCommand("PersonalShuttles_FollowMouse")
      Sleep(250)
    else
      return PersonalShuttles_OrigFuncs.CargoShuttle_Idle(self)
    end
  end

  --meteor targeting
  function CargoShuttle:GameInit()
    local PersonalShuttles = PersonalShuttles

    --if it's an attack shuttle
    if UICity.PersonalShuttles.CargoShuttleThreads[self.handle] then

      self.shoot_range = 25 * guim
      self.reload_time = const.HourDuration
      self.track_thread = false

      self.defence_thread_DD = CreateGameTimeThread(function()
        while IsValid(self) and not self.destroyed do
          if self.working then
            if not self:PersonalShuttles_DefenceTickD(PersonalShuttles) then
              Sleep(1000)
            end
          else
            Sleep(1000)
          end
        end
      end)
    end

    return PersonalShuttles_OrigFuncs.CargoShuttle_GameInit(self)
  end

  --gives an error when we spawn shuttle since i'm using a fake task
  function CargoShuttle:OnTaskAssigned()
    if self.PersonalShuttles_FollowMouseShuttle then
      return true
    else
      return PersonalShuttles_OrigFuncs.CargoShuttle_OnTaskAssigned(self)
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
