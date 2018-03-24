UserActions.AddActions({

  ChoGGi_ToggleInfopanelCheats = {
    icon = "toggle_dtm_slots.tga",
    menu = "Toggles/[1]Infopanel Cheats",
    description = function()
      local action = config.BuildingInfopanelCheats and "Disable" or "Enable"
      return action .. " the cheats in the infopanels"
    end,
    action = function()
      config.BuildingInfopanelCheats = not config.BuildingInfopanelCheats
      ReopenSelectionXInfopanel()
      ChoGGi.CheatMenuSettings["ToggleInfopanelCheats"] = config.BuildingInfopanelCheats
      ChoGGi.WriteSettings()
    end
  },

  ChoGGi_BlockCheatEmpty = {
    icon = "toggle_dtm_slots.tga",
    menu = "Toggles/[1]Block CheatEmpty",
    description = function()
      local action = ChoGGi.CheatMenuSettings["BlockCheatEmpty"] and "Allow" or "Deny"
      return action .. " CheatEmpty functions(restart to enable)"
    end,
    action = function()
      ChoGGi.BlockCheatEmpty()
      ChoGGi.CheatMenuSettings["BlockCheatEmpty"] = not ChoGGi.CheatMenuSettings["BlockCheatEmpty"]
      ChoGGi.WriteSettings()
    end
  },

  ChoGGi_Toggle = {
    icon = "ReportBug.tga",
    menu = "Toggles/[99]developer mode",
    description = "messes up labels/some keys.",
    description = function()
      local action = ChoGGi.CheatMenuSettings["developer"] and "Disable" or "Enable"
      return action .. " developer mode (messes up labels/some keys)."
    end,
    action = function()
      Platform.developer = not Platform.developer
      ChoGGi.CheatMenuSettings["developer"] = Platform.developer
      ChoGGi.WriteSettings()
      CreateRealTimeThread(WaitCustomPopupNotification,
        "Toggles Dev mode",
        "This adds more menuitems, but it'll change a bunch of labels to *stripped*, "
          .. "and some shortcut keys don't work\r\nrestart to take effect (or select again to disable).",
        { "OK" }
      )
    end
  },

  ChoGGi_StorageDepotHold1000 = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Toggles/[1]Storage Depot|Waste Rock Hold 1000",
    description = function()
      local action = ChoGGi.CheatMenuSettings["StorageDepotSpace"] and "Disable" or "Enable"
      return action .. " Larger storage depot space (applies to existing and newly placed)."
    end,
    action = function()
      ChoGGi.CheatMenuSettings["StorageDepotSpace"] = not ChoGGi.CheatMenuSettings["StorageDepotSpace"]
      ChoGGi.WriteSettings()
      for _,building in ipairs(UICity.labels.Building) do
        if IsKindOf(building,"UniversalStorageDepot") then
          building.max_storage_per_resource = 1000 * const.ResourceScale
        elseif IsKindOf(building,"WasteRockDumpSite") then
          building.max_amount_WasteRock = 1000 * const.ResourceScale
        end
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "StorageDepotHold1000",
        "Storage",
        "not a space elevator",
        "UI/Icons/Sections/basic.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Building_wonder = {
    icon = "toggle_post.tga",
    menu = "Toggles/[3]Building_wonder",
    description = function()
      local action = ChoGGi.CheatMenuSettings["Building_wonder"] and "Enable" or "Disable"
      return action .. " wonder limit (restart game to disable)."
    end,
    action = function()
      ChoGGi.CheatMenuSettings["Building_wonder"] = not ChoGGi.CheatMenuSettings["Building_wonder"]
      ChoGGi.WriteSettings()
      for _,building in ipairs(DataInstances.BuildingTemplate) do
        building.wonder = false
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Building_wonder",
        "Storage",
        "Building_wonder",
        "UI/Icons/IPButtons/assign_residence.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Building_hide_from_build_menu = {
    icon = "toggle_post.tga",
    menu = "Toggles/[3]Building_hide_from_build_menu",
    description = function()
      local action = ChoGGi.CheatMenuSettings["Building_hide_from_build_menu"] and "Hide" or "Show"
      return action .. " hidden buildings (restart game to disable)."
    end,
    action = function()
      ChoGGi.CheatMenuSettings["Building_hide_from_build_menu"] = not ChoGGi.CheatMenuSettings["Building_hide_from_build_menu"]
      ChoGGi.WriteSettings()
      for _,building in ipairs(DataInstances.BuildingTemplate) do
        building.hide_from_build_menu = false
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Building_hide_from_build_menu",
        "Storage",
        "Building_hide_from_build_menu",
        "UI/Icons/IPButtons/assign_residence.tga",
        nil,
        {expiration=5000})
      )
    end
  },

--[[these don't work (yet)
  ChoGGi_Building_dome_required = {
    icon = "toggle_post.tga",
    menu = "Toggles/[3]Building_dome_required",
    description = "",
    description = function()
      local action = ChoGGi.CheatMenuSettings["Building_dome_required"] and "Allow" or "Block"
      return action .. " inside buildings outside (restart game to disable)."
    end,
    action = function()
      ChoGGi.CheatMenuSettings["Building_dome_required"] = not ChoGGi.CheatMenuSettings["Building_dome_required"]
      ChoGGi.WriteSettings()
      for _,building in ipairs(DataInstances.BuildingTemplate) do
        building.dome_required = false
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Building_dome_required",
        "Storage",
        "Building_dome_required",
        "UI/Icons/IPButtons/assign_residence.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Building_dome_forbidden = {
    icon = "toggle_post.tga",
    menu = "Toggles/[3]Building_dome_forbidden",
    description = function()
      local action = ChoGGi.CheatMenuSettings["Building_dome_forbidden"] and "Allow" or "Block"
      return action .. " outer buildings placed inside (restart game to disable)."
    end,
    action = function()
      ChoGGi.CheatMenuSettings["Building_dome_forbidden"] = not ChoGGi.CheatMenuSettings["Building_dome_forbidden"]
      ChoGGi.WriteSettings()
      for _,building in ipairs(DataInstances.BuildingTemplate) do
        building.dome_forbidden = false
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Building_dome_forbidden",
        "Storage",
        "Building_dome_forbidden",
        "UI/Icons/IPButtons/assign_residence.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Building_dome_spot = {
    icon = "toggle_post.tga",
    menu = "Toggles/[3]Building_dome_spot",
    description = function()
      local action = ChoGGi.CheatMenuSettings["Building_dome_spot"] and "Allow" or "Block"
      return action .. " spires to be placed anywhere inside dome, other than spire area (restart game to disable)."
    end,
    action = function()
      ChoGGi.CheatMenuSettings["Building_dome_spot"] = not ChoGGi.CheatMenuSettings["Building_dome_spot"]
      ChoGGi.WriteSettings()
      for _,building in ipairs(DataInstances.BuildingTemplate) do
        building.dome_spot = "none"
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Building_dome_spot",
        "Storage",
        "Building_dome_spot",
        "UI/Icons/IPButtons/assign_residence.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Building_is_tall = {
    icon = "toggle_post.tga",
    menu = "Toggles/[3]Building_is_tall",
    description = function()
      local action = ChoGGi.CheatMenuSettings["Building_is_tall"] and "Allow" or "Block"
      return action .. " tall buildings placed under pipes (restart game to disable)."
    end,
    action = function()
      ChoGGi.CheatMenuSettings["Building_is_tall"] = not ChoGGi.CheatMenuSettings["Building_is_tall"]
      ChoGGi.WriteSettings()
      for _,building in ipairs(DataInstances.BuildingTemplate) do
        building.is_tall = false
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Building_is_tall",
        "Storage",
        "Building_is_tall",
        "UI/Icons/IPButtons/assign_residence.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Building_instant_build = {
    icon = "toggle_post.tga",
    menu = "Toggles/[3]Building_instant_build",
    description = function()
      local action = ChoGGi.CheatMenuSettings["Building_instant_build"] and "Allow" or "Block"
      return action .. " instant building (restart game to disable)."
    end,
    action = function()
      ChoGGi.CheatMenuSettings["Building_instant_build"] = not ChoGGi.CheatMenuSettings["Building_instant_build"]
      ChoGGi.WriteSettings()
      for _,building in ipairs(DataInstances.BuildingTemplate) do
        building.instant_build = true
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Building_instant_build",
        "Storage",
        "Building_instant_build",
        "UI/Icons/IPButtons/assign_residence.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  --breaks building buildings with prefabs
  ChoGGi_Building_require_prefab = {
    icon = "toggle_post.tga",
    menu = "Toggles/[3]Building_require_prefab",
    description = function()
      local action = ChoGGi.CheatMenuSettings["Building_hide_from_build_menu"] and "Allow" or "Block"
      return action .. " requiring Prefabs (restart game to disable)."
    end,
    action = function()
      ChoGGi.CheatMenuSettings["Building_require_prefab"] = not ChoGGi.CheatMenuSettings["Building_require_prefab"]
      ChoGGi.WriteSettings()
      for _,building in ipairs(DataInstances.BuildingTemplate) do
        building.require_prefab = false
      end
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Building_require_prefab",
        "Storage",
        "Building_require_prefab",
        "UI/Icons/IPButtons/assign_residence.tga",
        nil,
        {expiration=5000})
      )
    end
  },
--]]

})
