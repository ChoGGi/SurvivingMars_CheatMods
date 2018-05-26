local SaveOrigFunc = PersonalShuttles.ComFuncs.SaveOrigFunc

function PersonalShuttles.MsgFuncs.ReplacedFunctions_ClassesGenerate()

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
      self.shoot_range = 25 * PersonalShuttles.Consts.guim
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

function PersonalShuttles.MsgFuncs.ReplacedFunctions_ClassesBuilt()

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
