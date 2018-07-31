--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local AddAction = ChoGGi.ComFuncs.AddAction
local S = ChoGGi.Strings

--~ local icon = "new_city.tga"

--~ AddAction(Entry,Menu,Action,Key,Des,Icon)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/[90]",S[1000207--[[Misc--]]],"/",S[302535920000678--[[Change Surface Signs To Materials--]]]),
  ChoGGi.MenuFuncs.ChangeSurfaceSignsToMaterials,
  nil,
  302535920000679--[[Changes all the ugly immersion breaking signs to materials (reversible).--]],
  "SelectByClassName.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/[90]",S[1000207--[[Misc--]]],"/",S[302535920000680--[[Annoying Sounds--]]]),
  ChoGGi.MenuFuncs.AnnoyingSounds_Toggle,
  nil,
  302535920000681--[[Toggle annoying sounds (Sensor Tower, Mirror Sphere, Rover deployed drones, Drone incessant beeping).--]],
  "ToggleCutSmoothTrans.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/[90]",S[1000207--[[Misc--]]],"/",S[302535920000682--[[Change Entity--]]]),
  ChoGGi.MenuFuncs.SetEntity,
  nil,
  302535920000683--[[Changes the entity of selected object, all of same type or all of same type in selected object's dome.--]],
  "ConvertEnvironment.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/[90]",S[1000207--[[Misc--]]],"/",S[302535920000684--[[Change Entity Scale--]]]),
  ChoGGi.MenuFuncs.SetEntityScale,
  nil,
  302535920000685--[[You want them big, you want them small; have at it.--]],
  "scale_gizmo.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/[90]",S[1000207--[[Misc--]]],"/",S[302535920000686--[[Auto Unpin Objects--]]]),
  ChoGGi.MenuFuncs.ShowAutoUnpinObjectList,
  nil,
  302535920000687--[[Will automagically stop any of these objects from being added to the pinned list.--]],
  "CutSceneArea.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/[90]",S[1000207--[[Misc--]]],"/",S[302535920000688--[[Clean All Objects--]]]),
  ChoGGi.MenuFuncs.CleanAllObjects,
  nil,
  302535920000689--[[Removes all dust from all objects.--]],
  "DisableAOMaps.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/[90]",S[1000207--[[Misc--]]],"/",S[302535920000690--[[Fix All Objects--]]]),
  ChoGGi.MenuFuncs.FixAllObjects,
  nil,
  302535920000691--[[Fixes all broken objects.--]],
  "DisableAOMaps.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/[90]",S[1000207--[[Misc--]]],"/",S[302535920000021--[[Change Colour--]]]),
  function()
    ChoGGi.MenuFuncs.CreateObjectListAndAttaches()
  end,
  ChoGGi.UserSettings.KeyBindings.CreateObjectListAndAttaches,
  302535920000693--[[Select/mouse over an object to change the colours.--]],
  "toggle_dtm_slots.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/[90]",S[1000207--[[Misc--]]],"/",S[302535920000694--[[Set Opacity--]]]),
  ChoGGi.MenuFuncs.SetObjectOpacity,
  ChoGGi.UserSettings.KeyBindings.SetObjectOpacity,
  302535920000695--[[Change the opacity of objects.--]],
  "set_last_texture.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/[90]",S[1000207--[[Misc--]]],"/[-1]",S[302535920000696--[[Infopanel Cheats--]]]),
  ChoGGi.MenuFuncs.InfopanelCheats_Toggle,
  ChoGGi.UserSettings.KeyBindings.InfopanelCheats_Toggle,
  302535920000697--[[Shows the cheat pane in the info panel (selection panel).--]],
  "toggle_dtm_slots.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/[90]",S[1000207--[[Misc--]]],"/[-1]",S[302535920000698--[[Infopanel Cheats Cleanup--]]]),
  ChoGGi.MenuFuncs.InfopanelCheatsCleanup_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.CleanupCheatsInfoPane,
      302535920000699--[[Remove some entries from the cheat pane (restart to re-enable).

AddMaintenancePnts,MakeSphereTarget,Malfunction,SpawnWorker,SpawnVisitor--]]
    )
  end,
  "toggle_dtm_slots.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/[90]",S[1000207--[[Misc--]]],"/",S[302535920000700--[[Scanner Queue Larger--]]]),
  ChoGGi.MenuFuncs.ScannerQueueLarger_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      const.ExplorationQueueMaxSize,
      302535920000701--[[Queue up to 100 squares.--]]
    )
  end,
  "ViewArea.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/[90]",S[1000207--[[Misc--]]],"/",S[302535920000702--[[Game Speed--]]]),
  ChoGGi.MenuFuncs.SetGameSpeed,
  nil,
  302535920000703--[[Change the game speed (only for medium/fast, normal is normal).--]],
  "SelectionToTemplates.tga"
)
