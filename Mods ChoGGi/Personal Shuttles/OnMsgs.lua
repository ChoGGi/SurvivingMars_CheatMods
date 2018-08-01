local SaveOrigFunc = PersonalShuttles.ComFuncs.SaveOrigFunc

function OnMsg.ClassesGenerate()
  --custom shuttletask
  DefineClass.PersonalShuttles_ShuttleFollowTask = {
    __parents = {"InitDone"},
    state = "new",
    shuttle = false,
    scanning = false, --from explorer code for AnalyzeAnomaly
    dest_pos = false, --there isn't one, but adding one prevents log spam
  }
  --if it idles it'll go home, so we return my command till we remove thread
  SaveOrigFunc("CargoShuttle","Idle")
  function CargoShuttle:Idle()
    local PersonalShuttles = PersonalShuttles
    if self.PersonalShuttles_FollowMouseShuttle then
      self:SetCommand("PersonalShuttles_FollowMouse")
      Sleep(250)
    else
      return PersonalShuttles.OrigFuncs.CargoShuttle_Idle(self)
    end
  end

  --meteor targeting
  SaveOrigFunc("CargoShuttle","GameInit")
  function CargoShuttle:GameInit()

    local PersonalShuttles = PersonalShuttles

    --if it's an attack shuttle
    if UICity.PersonalShuttles.CargoShuttleThreads[self.handle] then

      local IsValid = IsValid
      local Sleep = Sleep
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

    return PersonalShuttles.OrigFuncs.CargoShuttle_GameInit(self)
  end
end

function OnMsg.ClassesPreprocess()
  CargoShuttle.defence_thread_DD = false
end

function OnMsg.ClassesBuilt()

  --gives an error when we spawn shuttle since i'm using a fake task
  SaveOrigFunc("CargoShuttle","OnTaskAssigned")
  function CargoShuttle:OnTaskAssigned()
    if self.PersonalShuttles_FollowMouseShuttle then
      return true
    else
      return PersonalShuttles.OrigFuncs.CargoShuttle_OnTaskAssigned(self)
    end
  end

  if type(PersonalShuttles.Temp.Testing) == "function" then
    SaveOrigFunc("terminal","MouseEvent")
    function terminal.MouseEvent(event, ...)
      --local PersonalShuttles = PersonalShuttles
      if PersonalShuttles.Temp.ShuttleClickerControl then
        local _, button = ...
        --that's a rightclick
        if event == "OnMouseButtonDown" and button == "R" then
          PersonalShuttles.Temp.ShuttleClickerPos = GetTerrainCursor()
        end
      end
      return PersonalShuttles.OrigFuncs.terminal_MouseEvent(event, ...)
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
  local IsValid = IsValid
  local UICity = UICity

  --clean up old handles
  if UICity.PersonalShuttles and next(UICity.PersonalShuttles.CargoShuttleThreads) then
    for h,_ in pairs(UICity.PersonalShuttles.CargoShuttleThreads) do
      if not IsValid(HandleToObject[h]) then
        UICity.PersonalShuttles.CargoShuttleThreads[h] = nil
      end
    end
  end

end
