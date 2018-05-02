function ChoGGi.MiscMenu_LoadingScreenPreClose()
  --ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/Auto Unpin Objects",
    ChoGGi.ShowAutoUnpinObjectList,
    nil,
    "Will automagically stop any of these objects from being added to the pinned list.",
    "CutSceneArea.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/Clean All Objects",
    ChoGGi.CleanAllObjects,
    nil,
    "Removes all dust from all objects.",
    "DisableAOMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/Fix All Objects",
    ChoGGi.FixAllObjects,
    nil,
    "Fixes all broken objects.",
    "DisableAOMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/Change Colour",
    ChoGGi.CreateObjectListAndAttaches,
    "F6",
    "Select/mouse over an object to change the colours.",
    "toggle_dtm_slots.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/Set Opacity",
    ChoGGi.SetObjectOpacity,
    "F3",
    "Change the opacity of objects.",
    "set_last_texture.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/Instant Colony Approval",
    ChoGGi.InstantColonyApproval,
    nil,
    "Make your colony instantly approved (can be called before you summon your first victims).",
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/[2]Render/Shadow Map",
    ChoGGi.SetShadowmapSize,
    nil,
    function()
      local des = "Current: " .. tostring(ChoGGi.CheatMenuSettings.ShadowmapSize)
      return des .. "\nSets the shadow map size (Menu>Options>Video>Shadows), menu options max out at 4096."
    end,
    "DisableEyeSpec.tga"
  )

  --------------------
  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/[2]Render/Disable Texture Compression",
    ChoGGi.DisableTextureCompression_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.DisableTextureCompression and "(Enabled)" or "(Disabled)"
      return des .. " Toggle texture compression (game defaults to on, seems to make a difference of 600MB vram)."
    end,
    "ExportImageSequence.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/[2]Render/Higher Render Distance",
    ChoGGi.HigherRenderDist_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.HigherRenderDist and "(Enabled)" or "(Disabled)"
      return des .. " Renders model from further away.\nNot noticeable unless using higher zoom."
    end,
    "CameraEditor.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/[2]Render/Higher Shadow Distance",
    ChoGGi.HigherShadowDist_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.HigherShadowDist and "(Enabled)" or "(Disabled)"
      return des .. " Renders shadows from further away.\nNot noticeable unless using higher zoom."
    end,
    "toggle_post.tga"
  )


  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Toggle Free Camera",
    ChoGGi.CameraFree_Toggle,
    "Shift-C",
    "I believe I can fly.",
    "NewCamera.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Toggle Follow Camera",
    ChoGGi.CameraFollow_Toggle,
    "Ctrl-Shift-F",
    "Select (or mouse over) an object to follow.",
    "Shot.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Toggle Cursor",
    ChoGGi.CursorVisible_Toggle,
    "Ctrl-Alt-F",
    "Toggle between moving camera and selecting objects.",
    "select_objects.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Border Scrolling",
    ChoGGi.SetBorderScrolling,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.BorderScrollingToggle and "(Enabled)" or "(Disabled)"
      return des .. " Set size of activation for mouse border scrolling."
    end,
    "CameraToggle.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Zoom Distance",
    ChoGGi.CameraZoom_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.CameraZoomToggle and "(Enabled)" or "(Disabled)"
      return des .. " Further zoom distance."
    end,
    "MoveUpCamera.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/[-1]Infopanel Cheats",
    ChoGGi.InfopanelCheats_Toggle,
    nil,
    function()
      local des = config.BuildingInfopanelCheats and "(Enabled)" or "(Disabled)"
      return des .. " Show the cheat pane in the info panel."
    end,
    "toggle_dtm_slots.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/[-1]Infopanel Cheats Cleanup",
    ChoGGi.InfopanelCheatsCleanup_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.CleanupCheatsInfoPane and "(Enabled)" or "(Disabled)"
      return des .. " Remove some entries from the cheat pane (restart to re-enable).\n\nAddMaintenancePnts,MakeSphereTarget,Malfunction,SpawnWorker,SpawnVisitor"
    end,
    "toggle_dtm_slots.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/Show All Traits",
    ChoGGi.ShowAllTraits_Toggle,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.ShowAllTraits and "(Enabled)" or "(Disabled)"
      return des .. " Shows all appropriate traits in Sanatoriums/Schools."
    end,
    "LightArea.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/Scanner Queue Larger",
    ChoGGi.ScannerQueueLarger_Toggle,
    nil,
    function()
      local des
      if const.ExplorationQueueMaxSize == 100 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Queue up to 100 squares (default " .. ChoGGi.Consts.ExplorationQueueMaxSize .. ")."
    end,
    "ViewArea.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/[999]Misc/Game Speed",
    ChoGGi.SetGameSpeed,
    nil,
    "Change the game speed (only for medium/fast, normal is normal).",
    "SelectionToTemplates.tga"
  )

end
