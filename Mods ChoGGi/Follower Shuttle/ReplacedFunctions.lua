local cCodeFuncs = ChoGGiX.CodeFuncs
local cComFuncs = ChoGGiX.ComFuncs
local cInfoFuncs = ChoGGiX.InfoFuncs
local cConsts = ChoGGiX.Consts
local cOrigFuncs = ChoGGiX.OrigFuncs
local cMsgFuncs = ChoGGiX.MsgFuncs
local cTesting = ChoGGiX.Temp.Testing

local PlayFX = PlayFX
local NearestObject = NearestObject
local Sleep = Sleep
local GetTerrainCursor = GetTerrainCursor
local GameTime = GameTime
local GetObjects = GetObjects


function cMsgFuncs.ReplacedFunctions_ClassesGenerate()
  --meteor targeting
  cComFuncs.SaveOrigFunc("CargoShuttle","GameInit")
  function CargoShuttle:GameInit()
    local ChoGGiX = ChoGGiX
    self.ChoGGiX_FollowMouseShuttle = true
    self.shoot_range = 25 * cConsts.guim
    self.reload_time = const.HourDuration
    self.track_thread = false
    self.defence_threadD = CreateGameTimeThread(function()
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
    return cOrigFuncs.CargoShuttle_GameInit(self)
  end
end
function cMsgFuncs.ReplacedFunctions_ClassesBuilt()

  --gives an error when we spawn shuttle since i'm using a fake task
  cComFuncs.SaveOrigFunc("CargoShuttle","OnTaskAssigned")
  function CargoShuttle:OnTaskAssigned()
    if self.ChoGGiX_FollowMouseShuttle then
      return true
    else
      return cOrigFuncs.CargoShuttle_OnTaskAssigned(self)
    end
  end

  --add a call shuttle action on rightclick
  cComFuncs.SaveOrigFunc("PinsDlg","InitPinButton")
  function PinsDlg:InitPinButton(button)
    local ret = {cOrigFuncs.PinsDlg_InitPinButton(self, button)}
      for i = 1, #self do
        local pin = self[i]
        if pin.Icon == "UI/Icons/Buildings/res_shuttle.tga" then
          function pin:OnMouseButtonDown(pt, button)
            if button == "R" then
              CreateRealTimeThread(function()
                --give it a bit for user to move mouse away from pinsdlg so shuttle doesn't fly there
                Sleep(1500)
                self.context:SetCommand("ChoGGiX_FollowMouse",GetTerrainCursor())
              end)
            end
          end
        end
      end
    return table.unpack(ret)
  end

end
