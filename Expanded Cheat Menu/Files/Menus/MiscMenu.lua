--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local TConcat = ChoGGi.ComFuncs.TableConcat
local T = ChoGGi.ComFuncs.Trans

--~ local icon = "new_city.tga"

function ChoGGi.MsgFuncs.MiscMenu_ChoGGi_Loaded()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/[90]",T(1000207--[[Misc--]]),"/",T(302535920000678--[[Change Surface Signs To Materials--]])),
    ChoGGi.MenuFuncs.ChangeSurfaceSignsToMaterials,
    nil,
    T(302535920000679--[[Changes all the ugly immersion breaking signs to materials (reversible).--]]),
    "SelectByClassName.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/[90]",T(1000207--[[Misc--]]),"/",T(302535920000680--[[Annoying Sounds--]])),
    ChoGGi.MenuFuncs.AnnoyingSounds_Toggle,
    nil,
    T(302535920000681--[[Toggle annoying sounds (Sensor Tower, Mirror Sphere, Rover deployed drones, Drone incessant beeping).--]]),
    "ToggleCutSmoothTrans.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/[90]",T(1000207--[[Misc--]]),"/",T(302535920000682--[[Change Entity--]])),
    ChoGGi.MenuFuncs.SetEntity,
    nil,
    T(302535920000683--[[Changes the entity of selected object, all of same type or all of same type in selected object's dome.--]]),
    "ConvertEnvironment.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/[90]",T(1000207--[[Misc--]]),"/",T(302535920000684--[[Change Entity Scale--]])),
    ChoGGi.MenuFuncs.SetEntityScale,
    nil,
    T(302535920000685--[[You want them big, you want them small; have at it.--]]),
    "scale_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/[90]",T(1000207--[[Misc--]]),"/",T(302535920000686--[[Auto Unpin Objects--]])),
    ChoGGi.MenuFuncs.ShowAutoUnpinObjectList,
    nil,
    T(302535920000687--[[Will automagically stop any of these objects from being added to the pinned list.--]]),
    "CutSceneArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/[90]",T(1000207--[[Misc--]]),"/",T(302535920000688--[[Clean All Objects--]])),
    ChoGGi.MenuFuncs.CleanAllObjects,
    nil,
    T(302535920000689--[[Removes all dust from all objects.--]]),
    "DisableAOMaps.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/[90]",T(1000207--[[Misc--]]),"/",T(302535920000690--[[Fix All Objects--]])),
    ChoGGi.MenuFuncs.FixAllObjects,
    nil,
    T(302535920000691--[[Fixes all broken objects.--]]),
    "DisableAOMaps.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/[90]",T(1000207--[[Misc--]]),"/",T(302535920000021--[[Change Colour--]])),
    ChoGGi.MenuFuncs.CreateObjectListAndAttaches,
    "F6",
    T(302535920000693--[[Select/mouse over an object to change the colours.--]]),
    "toggle_dtm_slots.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/[90]",T(1000207--[[Misc--]]),"/",T(302535920000694--[[Set Opacity--]])),
    ChoGGi.MenuFuncs.SetObjectOpacity,
    "F3",
    T(302535920000695--[[Change the opacity of objects.--]]),
    "set_last_texture.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/[90]",T(1000207--[[Misc--]]),"/[-1]",T(302535920000696--[[Infopanel Cheats--]])),
    ChoGGi.MenuFuncs.InfopanelCheats_Toggle,
    "Ctrl-F2",
    T(302535920000697--[[Shows the cheat pane in the info panel (selection panel).--]]),
    "toggle_dtm_slots.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/[90]",T(1000207--[[Misc--]]),"/[-1]",T(302535920000698--[[Infopanel Cheats Cleanup--]])),
    ChoGGi.MenuFuncs.InfopanelCheatsCleanup_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.CleanupCheatsInfoPane,
        302535920000699 --,"Remove some entries from the cheat pane (restart to re-enable).\n\nAddMaintenancePnts,MakeSphereTarget,Malfunction,SpawnWorker,SpawnVisitor"
      )
    end,
    "toggle_dtm_slots.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/[90]",T(1000207--[[Misc--]]),"/",T(302535920000700--[[Scanner Queue Larger--]])),
    ChoGGi.MenuFuncs.ScannerQueueLarger_Toggle,
    nil,
    function()
      local des
      if const.ExplorationQueueMaxSize == 100 then
        des = {T(302535920000030--[[Enabled--]]),": "}
      else
        des = {T(302535920000036--[[Disabled--]]),": "}
      end
      des[#des+1] = T(302535920000701--[[Queue up to 100 squares (default--]])
      des[#des+1] = ": "
      des[#des+1] = ChoGGi.Consts.ExplorationQueueMaxSize
      des[#des+1] = ")."
      return TConcat(des)
    end,
    "ViewArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/[90]",T(1000207--[[Misc--]]),"/",T(302535920000702--[[Game Speed--]])),
    ChoGGi.MenuFuncs.SetGameSpeed,
    nil,
    T(302535920000703--[[Change the game speed (only for medium/fast, normal is normal).--]]),
    "SelectionToTemplates.tga"
  )

end
