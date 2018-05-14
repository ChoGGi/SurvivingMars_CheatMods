local CMenuFuncs = ChoGGi.MenuFuncs
local CCodeFuncs = ChoGGi.CodeFuncs
local CComFuncs = ChoGGi.ComFuncs
local CConsts = ChoGGi.Consts
local CInfoFuncs = ChoGGi.InfoFuncs
local CSettingFuncs = ChoGGi.SettingFuncs
local CTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.MiscMenu_LoadingScreenPreClose()
  --CComFuncs.AddAction(Menu,Action,Key,Des,Icon)
  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/Change Light Model",
    CMenuFuncs.ChangeLightmodel,
    nil,
    "Changes the lighting mode (temporary or permanent).",
    "light_model.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/Change Entity",
    CMenuFuncs.SetEntity,
    nil,
    "Changes the entity of selected object, all of same type or all of same type in selected object's dome.",
    "ConvertEnvironment.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/Change Entity Scale",
    CMenuFuncs.SetEntityScale,
    nil,
    "You want big, you want them small.",
    "scale_gizmo.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/Change Light Model Custom",
    CMenuFuncs.ChangeLightmodelCustom,
    nil,
    "Make a custom lightmodel and save it to settings. You still need to use \"Change Light Model\" for permanent.",
    "light_model.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/Auto Unpin Objects",
    CMenuFuncs.ShowAutoUnpinObjectList,
    nil,
    "Will automagically stop any of these objects from being added to the pinned list.",
    "CutSceneArea.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/Clean All Objects",
    CMenuFuncs.CleanAllObjects,
    nil,
    "Removes all dust from all objects.",
    "DisableAOMaps.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/Fix All Objects",
    CMenuFuncs.FixAllObjects,
    nil,
    "Fixes all broken objects.",
    "DisableAOMaps.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/Change Colour",
    CMenuFuncs.CreateObjectListAndAttaches,
    "F6",
    "Select/mouse over an object to change the colours.",
    "toggle_dtm_slots.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/Set Opacity",
    CMenuFuncs.SetObjectOpacity,
    "F3",
    "Change the opacity of objects.",
    "set_last_texture.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/Set UI Transparency",
    CMenuFuncs.SetTransparencyUI,
    "Ctrl-F3",
    "Change the transparency of UI items.",
    "set_last_texture.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/Set UI Transparency Mouseover",
    CMenuFuncs.TransparencyUI_Toggle,
    nil,
    "Toggle removing transparency on mouseover.",
    "set_last_texture.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/[2]Render/Shadow Map",
    CMenuFuncs.SetShadowmapSize,
    nil,
    function()
      local des = "Current: " .. tostring(ChoGGi.UserSettings.ShadowmapSize)
      return des .. "\nSets the shadow map size (Menu>Options>Video>Shadows), menu options max out at 4096."
    end,
    "DisableEyeSpec.tga"
  )

  --------------------
  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/[2]Render/Disable Texture Compression",
    CMenuFuncs.DisableTextureCompression_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.DisableTextureCompression and "(Enabled)" or "(Disabled)"
      return des .. " Toggle texture compression (game defaults to on, seems to make a difference of 600MB vram)."
    end,
    "ExportImageSequence.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/[2]Render/Higher Render Distance",
    CMenuFuncs.HigherRenderDist_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.HigherRenderDist and "(Enabled)" or "(Disabled)"
      return des .. " Renders model from further away.\nNot noticeable unless using higher zoom."
    end,
    "CameraEditor.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/[2]Render/Higher Shadow Distance",
    CMenuFuncs.HigherShadowDist_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.HigherShadowDist and "(Enabled)" or "(Disabled)"
      return des .. " Renders shadows from further away.\nNot noticeable unless using higher zoom."
    end,
    "toggle_post.tga"
  )


  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Toggle Free Camera",
    CMenuFuncs.CameraFree_Toggle,
    "Shift-C",
    "I believe I can fly.",
    "NewCamera.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Toggle Follow Camera",
    CMenuFuncs.CameraFollow_Toggle,
    "Ctrl-Shift-F",
    "Select (or mouse over) an object to follow.",
    "Shot.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Toggle Cursor",
    CMenuFuncs.CursorVisible_Toggle,
    "Ctrl-Alt-F",
    "Toggle between moving camera and selecting objects.",
    "select_objects.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Border Scrolling",
    CMenuFuncs.SetBorderScrolling,
    nil,
    function()
      local des = ChoGGi.UserSettings.BorderScrollingToggle and "(Enabled)" or "(Disabled)"
      return des .. " Set size of activation for mouse border scrolling."
    end,
    "CameraToggle.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Zoom Distance",
    CMenuFuncs.CameraZoom_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.CameraZoomToggle and "(Enabled)" or "(Disabled)"
      return des .. " Further zoom distance."
    end,
    "MoveUpCamera.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/[-1]Infopanel Cheats",
    CMenuFuncs.InfopanelCheats_Toggle,
    nil,
    function()
      local des = config.BuildingInfopanelCheats and "(Enabled)" or "(Disabled)"
      return des .. " Show the cheat pane in the info panel."
    end,
    "toggle_dtm_slots.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/[-1]Infopanel Cheats Cleanup",
    CMenuFuncs.InfopanelCheatsCleanup_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.CleanupCheatsInfoPane and "(Enabled)" or "(Disabled)"
      return des .. " Remove some entries from the cheat pane (restart to re-enable).\n\nAddMaintenancePnts,MakeSphereTarget,Malfunction,SpawnWorker,SpawnVisitor"
    end,
    "toggle_dtm_slots.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/Scanner Queue Larger",
    CMenuFuncs.ScannerQueueLarger_Toggle,
    nil,
    function()
      local des = ""
      if const.ExplorationQueueMaxSize == 100 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Queue up to 100 squares (default " .. CConsts.ExplorationQueueMaxSize .. ")."
    end,
    "ViewArea.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/[999]Misc/Game Speed",
    CMenuFuncs.SetGameSpeed,
    nil,
    "Change the game speed (only for medium/fast, normal is normal).",
    "SelectionToTemplates.tga"
  )

end
