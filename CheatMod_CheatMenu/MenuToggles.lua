UserActions.AddActions({

  ChoGGi_ToggleInfopanelCheats = {
    icon = "toggle_dtm_slots.tga",
    menu = "Gameplay/Toggles/[-1]Infopanel Cheats",
    description = function()
      local action = config.BuildingInfopanelCheats and "(Enabled)" or "(Disabled)"
      return action .. " the cheats in the infopanels"
    end,
    action = ChoGGi.ToggleInfopanelCheats
  },

  ChoGGi_BlockCheatEmpty = {
    icon = "toggle_dtm_slots.tga",
    menu = "Gameplay/Toggles/[1]Block CheatEmpty",
    description = function()
      local action = ChoGGi.CheatMenuSettings.BlockCheatEmpty and "(Enabled)" or "(Disabled)"
      return action .. " Block CheatEmpty from working (need to restart to enable/disable)"
    end,
    action = ChoGGi.BlockCheatEmpty
  },

  ChoGGi_DeveloperModeToggle = {
    icon = "ReportBug.tga",
    menu = "Gameplay/Toggles/[99]developer mode",
    description = function()
      local action = ChoGGi.CheatMenuSettings.developer and "(Enabled)" or "(Disabled)"
      return action .. " developer mode (messes up labels/some keys)."
    end,
    action = ChoGGi.DeveloperModeToggle
  },

})

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: MenuToggles.lua",true)
end
