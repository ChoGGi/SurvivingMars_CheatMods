--See LICENSE for terms

local icon = "new_city.tga"

function ChoGGi.MsgFuncs.MiscMenu_LoadingScreenPreClose()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/[98]Misc/Change Surface Signs To Materials",
    ChoGGi.MenuFuncs.ChangeSurfaceSignsToMaterials,
    nil,
    "Changes all the ugly immersion breaking signs to materials (reversible).",
    "SelectByClassName.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/[98]Misc/Annoying Sounds",
    ChoGGi.MenuFuncs.AnnoyingSounds_Toggle,
    nil,
    "Toggle annoying sounds (Sensor Tower, Mirror Sphere).",
    "ToggleCutSmoothTrans.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/[98]Misc/Change Entity",
    ChoGGi.MenuFuncs.SetEntity,
    nil,
    "Changes the entity of selected object, all of same type or all of same type in selected object's dome.",
    "ConvertEnvironment.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/[98]Misc/Change Entity Scale",
    ChoGGi.MenuFuncs.SetEntityScale,
    nil,
    "You want big, you want them small.",
    "scale_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/[98]Misc/Auto Unpin Objects",
    ChoGGi.MenuFuncs.ShowAutoUnpinObjectList,
    nil,
    "Will automagically stop any of these objects from being added to the pinned list.",
    "CutSceneArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/[98]Misc/Clean All Objects",
    ChoGGi.MenuFuncs.CleanAllObjects,
    nil,
    "Removes all dust from all objects.",
    "DisableAOMaps.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/[98]Misc/Fix All Objects",
    ChoGGi.MenuFuncs.FixAllObjects,
    nil,
    "Fixes all broken objects.",
    "DisableAOMaps.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/[98]Misc/Change Colour",
    ChoGGi.MenuFuncs.CreateObjectListAndAttaches,
    "F6",
    "Select/mouse over an object to change the colours.",
    "toggle_dtm_slots.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/[98]Misc/Set Opacity",
    ChoGGi.MenuFuncs.SetObjectOpacity,
    "F3",
    "Change the opacity of objects.",
    "set_last_texture.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/[98]Misc/[-1]Infopanel Cheats",
    ChoGGi.MenuFuncs.InfopanelCheats_Toggle,
    "Ctrl-F2",
    "Shows the cheat pane in the info panel (selection panel).",
    "toggle_dtm_slots.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/[98]Misc/[-1]Infopanel Cheats Cleanup",
    ChoGGi.MenuFuncs.InfopanelCheatsCleanup_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.CleanupCheatsInfoPane and "(Enabled)" or "(Disabled)"
      return des .. " Remove some entries from the cheat pane (restart to re-enable).\n\nAddMaintenancePnts,MakeSphereTarget,Malfunction,SpawnWorker,SpawnVisitor"
    end,
    "toggle_dtm_slots.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/[98]Misc/Scanner Queue Larger",
    ChoGGi.MenuFuncs.ScannerQueueLarger_Toggle,
    nil,
    function()
      local des = ""
      if const.ExplorationQueueMaxSize == 100 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Queue up to 100 squares (default " .. ChoGGi.Consts.ExplorationQueueMaxSize .. ")."
    end,
    "ViewArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/[98]Misc/Game Speed",
    ChoGGi.MenuFuncs.SetGameSpeed,
    nil,
    "Change the game speed (only for medium/fast, normal is normal).",
    "SelectionToTemplates.tga"
  )

end
