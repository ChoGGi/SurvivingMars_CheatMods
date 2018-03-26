UserActions.AddActions({

  ChoGGi_ToggleInfopanelCheats = {
    icon = "toggle_dtm_slots.tga",
    menu = "Toggles/[1]Infopanel Cheats",
    description = function()
      local action = config.BuildingInfopanelCheats and "(Enabled)" or "(Disabled)"
      return action .. " the cheats in the infopanels"
    end,
    action = ChoGGi.ToggleInfopanelCheats
  },

  ChoGGi_ToggleBorderScrolling = {
    icon = "CameraToggle.tga",
    menu = "Toggles/Camera/Border Scrolling",
    description = function()
      local action = ChoGGi.CheatMenuSettings["ToggleBorderScrolling"] and "(Enabled)" or "(Disabled)"
      return action .. " scrolling when mouse is near borders."
    end,
    action = ChoGGi.ToggleBorderScrolling
  },

  ChoGGi_ToggleCameraZoom = {
    icon = "MoveUpCamera.tga",
    menu = "Toggles/Camera/Camera Zoom Distance",
    description = function()
      local action = ChoGGi.CheatMenuSettings["ToggleCameraZoom"] and "(Enabled)" or "(Disabled)"
      return action .. " further zoom out/in (best to lower your scroll speed in options)."
    end,
    action = ChoGGi.ToggleCameraZoom
  },

  ChoGGi_ToggleCameraZoomSpeed = {
    icon = "AreaToggleOverviewCamera.tga",
    menu = "Toggles/Camera/Camera Zoom Speed",
    description = function()
      local action = ChoGGi.CheatMenuSettings["ToggleCameraZoomSpeed"] and "(Enabled)" or "(Disabled)"
      return action .. " faster zooming."
    end,
    action = ChoGGi.ToggleCameraZoomSpeed
  },

  ChoGGi_BlockCheatEmpty = {
    icon = "toggle_dtm_slots.tga",
    menu = "Toggles/[1]Block CheatEmpty",
    description = function()
      local action = ChoGGi.CheatMenuSettings["BlockCheatEmpty"] and "(Enabled)" or "(Disabled)"
      return action .. " Block CheatEmpty from working (need to restart to enable/disable)"
    end,
    action = ChoGGi.BlockCheatEmpty
  },

  ChoGGi_ToggleDeveloperMode = {
    icon = "ReportBug.tga",
    menu = "Toggles/[99]developer mode",
    description = function()
      local action = ChoGGi.CheatMenuSettings["developer"] and "(Enabled)" or "(Disabled)"
      return action .. " developer mode (messes up labels/some keys)."
    end,
    action = ChoGGi.ToggleDeveloperMode
  },

})

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: MenuToggles.lua",true)
end
