-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions

local str_ExpandedCM_Misc = "Expanded CM.Misc"
Actions[#Actions+1] = {
  ActionMenubar = "Expanded CM",
  ActionName = Concat(S[1000207--[[Misc--]]]," .."),
  ActionId = str_ExpandedCM_Misc,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
  ActionSortKey = "90Misc",
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Misc,
  ActionName = S[302535920000678--[[Change Surface Signs To Materials--]]],
  ActionId = "Expanded CM.Misc.Change Surface Signs To Materials",
  ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
  RolloverText = S[302535920000679--[[Changes all the ugly immersion breaking signs to materials (reversible).--]]],
  OnAction = ChoGGi.MenuFuncs.ChangeSurfaceSignsToMaterials,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Misc,
  ActionName = S[302535920000680--[[Annoying Sounds--]]],
  ActionId = "Expanded CM.Misc.Annoying Sounds",
  ActionIcon = "CommonAssets/UI/Menu/ToggleCutSmoothTrans.tga",
  RolloverText = S[302535920000681--[[Toggle annoying sounds (Sensor Tower, Mirror Sphere, Rover deployed drones, Drone incessant beeping).--]]],
  OnAction = ChoGGi.MenuFuncs.AnnoyingSounds_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Misc,
  ActionName = S[302535920000682--[[Change Entity--]]],
  ActionId = "Expanded CM.Misc.Change Entity",
  ActionIcon = "CommonAssets/UI/Menu/ConvertEnvironment.tga",
  RolloverText = S[302535920000683--[[Changes the entity of selected object, all of same type or all of same type in selected object's dome.--]]],
  OnAction = ChoGGi.MenuFuncs.SetEntity,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Misc,
  ActionName = S[302535920000684--[[Change Entity Scale--]]],
  ActionId = "Expanded CM.Misc.Change Entity Scale",
  ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
  RolloverText = S[302535920000685--[[You want them big, you want them small; have at it.--]]],
  OnAction = ChoGGi.MenuFuncs.SetEntityScale,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Misc,
  ActionName = S[302535920000686--[[Auto Unpin Objects--]]],
  ActionId = "Expanded CM.Misc.Auto Unpin Objects",
  ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
  RolloverText = S[302535920000687--[[Will automagically stop any of these objects from being added to the pinned list.--]]],
  OnAction = ChoGGi.MenuFuncs.ShowAutoUnpinObjectList,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Misc,
  ActionName = S[302535920000688--[[Clean All Objects--]]],
  ActionId = "Expanded CM.Misc.Clean All Objects",
  ActionIcon = "CommonAssets/UI/Menu/DisableAOMaps.tga",
  RolloverText = S[302535920000689--[[Removes all dust from all objects.--]]],
  OnAction = ChoGGi.MenuFuncs.CleanAllObjects,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Misc,
  ActionName = S[302535920000690--[[Fix All Objects--]]],
  ActionId = "Expanded CM.Misc.Fix All Objects",
  ActionIcon = "CommonAssets/UI/Menu/DisableAOMaps.tga",
  RolloverText = S[302535920000691--[[Fixes all broken objects.--]]],
  OnAction = ChoGGi.MenuFuncs.FixAllObjects,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Misc,
  ActionName = S[302535920000021--[[Change Colour--]]],
  ActionId = "Expanded CM.Misc.Change Colour",
  ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
  RolloverText = S[302535920000693--[[Select/mouse over an object to change the colours.--]]],
  OnAction = function()
    ChoGGi.MenuFuncs.CreateObjectListAndAttaches()
  end,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.CreateObjectListAndAttaches,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Misc,
  ActionName = S[302535920000694--[[Set Opacity--]]],
  ActionId = "Expanded CM.Misc.Set Opacity",
  ActionIcon = "CommonAssets/UI/Menu/set_last_texture.tga",
  RolloverText = S[302535920000695--[[Change the opacity of objects.--]]],
  OnAction = ChoGGi.MenuFuncs.SetObjectOpacity,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.SetObjectOpacity,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Misc,
  ActionName = S[302535920000696--[[Infopanel Cheats--]]],
  ActionId = "Expanded CM.Misc.Infopanel Cheats",
  ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.ToggleInfopanelCheats,
      302535920000697--[[Shows the cheat pane in the info panel (selection panel).--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.InfopanelCheats_Toggle,
  ActionSortKey = "-1",
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.InfopanelCheats_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Misc,
  ActionName = S[302535920000698--[[Infopanel Cheats Cleanup--]]],
  ActionId = "Expanded CM.Misc.302535920000698--[[Infopanel Cheats Cleanup",
  ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.CleanupCheatsInfoPane,
      302535920000699--[[Remove some entries from the cheat pane (restart to re-enable).

AddMaintenancePnts,MakeSphereTarget,Malfunction,SpawnWorker,SpawnVisitor--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.InfopanelCheatsCleanup_Toggle,
  ActionSortKey = "-1",
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Misc,
  ActionName = S[302535920000700--[[Scanner Queue Larger--]]],
  ActionId = "Expanded CM.Misc.Scanner Queue Larger",
  ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.ExplorationQueueMaxSize,
      302535920000701--[[Queue up to 100 squares.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.ScannerQueueLarger_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Misc,
  ActionName = S[302535920000702--[[Game Speed--]]],
  ActionId = "Expanded CM.Misc.Game Speed",
  ActionIcon = "CommonAssets/UI/Menu/SelectionToTemplates.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.mediumGameSpeed,
      302535920000703--[[Change the game speed (only for medium/fast, normal is normal).--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetGameSpeed,
  ActionSortKey = "90",
}
