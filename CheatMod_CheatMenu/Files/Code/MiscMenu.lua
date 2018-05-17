local cMenuFuncs = ChoGGi.MenuFuncs
local cCodeFuncs = ChoGGi.CodeFuncs
local cComFuncs = ChoGGi.ComFuncs
local cConsts = ChoGGi.Consts
local cInfoFuncs = ChoGGi.InfoFuncs
local cSettingFuncs = ChoGGi.SettingFuncs
local cTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.MiscMenu_LoadingScreenPreClose()
  --cComFuncs.AddAction(Menu,Action,Key,Des,Icon)
  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/Change Terrain Type",
    cMenuFuncs.ChangeTerrainType,
    nil,
    "Green or Icy mars? Coming right up!",
    "prefabs.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/Change Light Model",
    cMenuFuncs.ChangeLightmodel,
    nil,
    "Changes the lighting mode (temporary or permanent).",
    "light_model.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/Change Entity",
    cMenuFuncs.SetEntity,
    nil,
    "Changes the entity of selected object, all of same type or all of same type in selected object's dome.",
    "ConvertEnvironment.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/Change Entity Scale",
    cMenuFuncs.SetEntityScale,
    nil,
    "You want big, you want them small.",
    "scale_gizmo.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/Change Light Model Custom",
    cMenuFuncs.ChangeLightmodelCustom,
    nil,
    "Make a custom lightmodel and save it to settings. You still need to use \"Change Light Model\" for permanent.",
    "light_model.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/Auto Unpin Objects",
    cMenuFuncs.ShowAutoUnpinObjectList,
    nil,
    "Will automagically stop any of these objects from being added to the pinned list.",
    "CutSceneArea.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/Clean All Objects",
    cMenuFuncs.CleanAllObjects,
    nil,
    "Removes all dust from all objects.",
    "DisableAOMaps.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/Fix All Objects",
    cMenuFuncs.FixAllObjects,
    nil,
    "Fixes all broken objects.",
    "DisableAOMaps.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/Change Colour",
    cMenuFuncs.CreateObjectListAndAttaches,
    "F6",
    "Select/mouse over an object to change the colours.",
    "toggle_dtm_slots.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/Set Opacity",
    cMenuFuncs.SetObjectOpacity,
    "F3",
    "Change the opacity of objects.",
    "set_last_texture.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/Set UI Transparency",
    cMenuFuncs.SetTransparencyUI,
    "Ctrl-F3",
    "Change the transparency of UI items.",
    "set_last_texture.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/Set UI Transparency Mouseover",
    cMenuFuncs.TransparencyUI_Toggle,
    nil,
    "Toggle removing transparency on mouseover.",
    "set_last_texture.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/[2]Render/Shadow Map",
    cMenuFuncs.SetShadowmapSize,
    nil,
    function()
      local des = "Current: " .. tostring(ChoGGi.UserSettings.ShadowmapSize)
      return des .. "\nSets the shadow map size (Menu>Options>Video>Shadows), menu options max out at 4096."
    end,
    "DisableEyeSpec.tga"
  )

  --------------------
  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/[2]Render/Disable Texture Compression",
    cMenuFuncs.DisableTextureCompression_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.DisableTextureCompression and "(Enabled)" or "(Disabled)"
      return des .. " Toggle texture compression (game defaults to on, seems to make a difference of 600MB vram)."
    end,
    "ExportImageSequence.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/[2]Render/Higher Render Distance",
    cMenuFuncs.HigherRenderDist_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.HigherRenderDist and "(Enabled)" or "(Disabled)"
      return des .. " Renders model from further away.\nNot noticeable unless using higher zoom."
    end,
    "CameraEditor.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/[2]Render/Higher Shadow Distance",
    cMenuFuncs.HigherShadowDist_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.HigherShadowDist and "(Enabled)" or "(Disabled)"
      return des .. " Renders shadows from further away.\nNot noticeable unless using higher zoom."
    end,
    "toggle_post.tga"
  )


  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Toggle Free Camera",
    cMenuFuncs.CameraFree_Toggle,
    "Shift-C",
    "I believe I can fly.",
    "NewCamera.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Toggle Follow Camera",
    cMenuFuncs.CameraFollow_Toggle,
    "Ctrl-Shift-F",
    "Select (or mouse over) an object to follow.",
    "Shot.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Toggle Cursor",
    cMenuFuncs.CursorVisible_Toggle,
    "Ctrl-Alt-F",
    "Toggle between moving camera and selecting objects.",
    "select_objects.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Border Scrolling",
    cMenuFuncs.SetBorderScrolling,
    nil,
    function()
      local des = ChoGGi.UserSettings.BorderScrollingToggle and "(Enabled)" or "(Disabled)"
      return des .. " Set size of activation for mouse border scrolling."
    end,
    "CameraToggle.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Zoom Distance",
    cMenuFuncs.CameraZoom_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.CameraZoomToggle and "(Enabled)" or "(Disabled)"
      return des .. " Further zoom distance."
    end,
    "MoveUpCamera.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/[-1]Infopanel Cheats",
    cMenuFuncs.InfopanelCheats_Toggle,
    nil,
    function()
      local des = config.BuildingInfopanelCheats and "(Enabled)" or "(Disabled)"
      return des .. " Show the cheat pane in the info panel."
    end,
    "toggle_dtm_slots.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/[-1]Infopanel Cheats Cleanup",
    cMenuFuncs.InfopanelCheatsCleanup_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.CleanupCheatsInfoPane and "(Enabled)" or "(Disabled)"
      return des .. " Remove some entries from the cheat pane (restart to re-enable).\n\nAddMaintenancePnts,MakeSphereTarget,Malfunction,SpawnWorker,SpawnVisitor"
    end,
    "toggle_dtm_slots.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/Scanner Queue Larger",
    cMenuFuncs.ScannerQueueLarger_Toggle,
    nil,
    function()
      local des = ""
      if const.ExplorationQueueMaxSize == 100 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Queue up to 100 squares (default " .. cConsts.ExplorationQueueMaxSize .. ")."
    end,
    "ViewArea.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/[999]Misc/Game Speed",
    cMenuFuncs.SetGameSpeed,
    nil,
    "Change the game speed (only for medium/fast, normal is normal).",
    "SelectionToTemplates.tga"
  )

end
