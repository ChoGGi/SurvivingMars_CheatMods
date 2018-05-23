local SaveOrigFunc = ChoGGiX.ComFuncs.SaveOrigFunc

function ChoGGiX.MsgFuncs.ReplacedFunctions_ClassesGenerate()
  --if it idles it'll go home, so we return my command till we remove thread
  SaveOrigFunc("CargoShuttle","Idle")
  function CargoShuttle:Idle()
    local ChoGGiX = ChoGGiX
    if not type(ChoGGiX.Temp.CargoShuttleThreads[self.handle]) == "boolean" then
      return ChoGGiX.OrigFuncs.CargoShuttle_Idle(self)
    else
      self:SetCommand("ChoGGiX_FollowMouse")
    end
    Sleep(250)
  end

  --meteor targeting
  SaveOrigFunc("CargoShuttle","GameInit")
  function CargoShuttle:GameInit()
    local ChoGGiX = ChoGGiX
    local IsValid = IsValid
    local Sleep = Sleep
    --if it's an attack shuttle
    if ChoGGiX.Temp.CargoShuttleThreads[self.handle] then
      self.shoot_range = 25 * ChoGGiX.Consts.guim
      self.reload_time = const.HourDuration
      self.track_thread = false

      self.defence_thread_DD = CreateGameTimeThread(function()
        while IsValid(self) and not self.destroyed do
          if self.working then
            if not self:ChoGGiX_DefenceTickD(ChoGGiX) then
              Sleep(1000)
            end
          else
            Sleep(1000)
          end
        end
      end)

    end
    return ChoGGiX.OrigFuncs.CargoShuttle_GameInit(self)
  end
end

function ChoGGiX.MsgFuncs.ReplacedFunctions_ClassesBuilt()

  --gives an error when we spawn shuttle since i'm using a fake task
  SaveOrigFunc("CargoShuttle","OnTaskAssigned")
  function CargoShuttle:OnTaskAssigned()
    if self.ChoGGiX_FollowMouseShuttle then
      return true
    else
      return ChoGGiX.OrigFuncs.CargoShuttle_OnTaskAssigned(self)
    end
  end

  --add a call shuttle action on rightclick
  SaveOrigFunc("PinsDlg","InitPinButton")
  function PinsDlg:InitPinButton(button)
    local ret = {ChoGGiX.OrigFuncs.PinsDlg_InitPinButton(self, button)}
      for i = 1, #self do
        local pin = self[i]
        if pin.Icon == "UI/Icons/Buildings/res_shuttle.tga" then
          function pin:OnMouseButtonDown(pt, button)
            if button == "R" then
              CreateGameTimeThread(function()
                --give it a bit for user to move mouse away from pinsdlg so shuttle doesn't fly there
                Sleep(1500)
                if not self.context.scanning then
                  self.context:SetCommand("ChoGGiX_FollowMouse",GetTerrainCursor())
                end
              end)
            end
          end
        end
      end
    return table.unpack(ret)
  end

end
