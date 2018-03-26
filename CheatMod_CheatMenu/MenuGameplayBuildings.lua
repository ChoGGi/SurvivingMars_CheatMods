UserActions.AddActions({

  ChoGGi_ShowAllTraitsToggle = {
    menu = "Gameplay/Buildings/Show All Traits Toggle",
    description = function()
      local action = ChoGGi.CheatMenuSettings.ShowAllTraits and "(Disabled)" or "(Enabled)"
      return action .. " Shows all appropriate traits in Sanatoriums/Schools."
    end,
    action = ChoGGi.ShowAllTraitsToggle
  },

  ChoGGi_FullyAutomatedBuildingsToggle = {
    menu = "Gameplay/Buildings/Fully Automated Buildings Toggle",
    description = function()
      local action = ChoGGi.CheatMenuSettings.FullyAutomatedBuildings and "(Enabled)" or "(Disabled)"
      return action .. " Add an upgrade to automate buildings (if another upgrade replaces it; toggle it off and on).\nThanks to BoehserOnkel for the idea."
    end,
    action = ChoGGi.FullyAutomatedBuildingsToggle
  },

  ChoGGi_AddMysteryBreakthroughBuildings = {
    menu = "Gameplay/Buildings/Add Mystery|Breakthrough Buildings",
    description = function()
      local action = ChoGGi.CheatMenuSettings.AddMysteryBreakthroughBuildings and "(Enabled)" or "(Disabled)"
      return action .. " Show all the Mystery and Breakthrough buildings in the build menu."
    end,
    action = ChoGGi.AddMysteryBreakthroughBuildings
  },

  ChoGGi_SanatoriumCureAllToggle = {
    menu = "Gameplay/Buildings/Sanatoriums Cure All Toggle",
    description = function()
      local action = ChoGGi.CheatMenuSettings.SanatoriumCureAll and "(Disabled)" or "(Enabled)"
      return action .. " Sanatoriums now cure all bad traits."
    end,
    action = ChoGGi.SanatoriumCureAllToggle
  },

  ChoGGi_SchoolTrainAllToggle = {
    menu = "Gameplay/Buildings/Schools Train All Toggle",
    description = function()
      local action = ChoGGi.CheatMenuSettings.SchoolTrainAll and "(Disabled)" or "(Enabled)"
      return action .. " Schools now can train all good traits."
    end,
    action = ChoGGi.SchoolTrainAllToggle
  },

  ChoGGi_SanatoriumSchoolShowAll = {
    menu = "Gameplay/Buildings/Sanatoriums|Schools Show Full List Toggle",
    description = function()
      local action
      if Sanatorium.max_traits == 16 then
        action = "(Enabled)"
      else
        action = "(Disabled)"
      end
      return action .. " Toggle showing 16 traits in side pane."
    end,
    action = ChoGGi.SanatoriumSchoolShowAll
  },

  ChoGGi_MaintenanceBuildingsFreeToggle = {
    menu = "Gameplay/Buildings/Maintenance Buildings Free Toggle",
    description = function()
      local action
      if Consts.BuildingMaintenancePointsModifier == -100 then
        action = "(Enabled)"
      else
        action = "(Disabled)"
      end
      return action .. " Buildings don't get dusty."
    end,
    action = ChoGGi.MaintenanceBuildingsFreeToggle
  },

  ChoGGi_MoistureVaporatorPenaltyToggle = {
    menu = "Gameplay/Buildings/Moisture Vaporator Penalty Toggle",
    description = function()
      local action = const.MoistureVaporatorRange and "(Disabled)" or "(Enabled)"
      return action .. " penalty when Moisture Vaporators are close to each other."
    end,
    action = ChoGGi.MoistureVaporatorPenaltyToggle
  },

  ChoGGi_ConstructionForFreeToggle = {
    menu = "Gameplay/Buildings/Construction For Free Toggle",
    description = function()
      local action
      if Consts.rebuild_cost_modifier == -100 then
        action = "(Enabled)"
      else
        action = "(Disabled)"
      end
      return action .. " Build without resources."
    end,
    action = ChoGGi.ConstructionForFreeToggle
  },

  ChoGGi_SpacingPipesPillarsToggle = {
    menu = "Gameplay/Buildings/Spacing Pipes Pillars Toggle",
    description = function()
      local action
      if Consts.PipesPillarSpacing == 1000 then
        action = "(Enabled)"
      else
        action = "(Disabled)"
      end
      return action .. " Only place Pillars at start and end."
    end,
    action = ChoGGi.SpacingPipesPillarsToggle
  },

  ChoGGi_BuildingDamageCrimeToggle = {
    menu = "Gameplay/Buildings/Building Damage Crime Toggle",
    description = function()
      local action = Consts.CrimeEventSabotageBuildingsCount and "(Disabled)" or "(Enabled)"
      return action .. " damage from renegedes to buildings."
    end,
    action = ChoGGi.BuildingDamageCrimeToggle
  },

  ChoGGi_CablesAndPipesToggle = {
    menu = "Gameplay/Buildings/Cables And Pipes Toggle",
    description = function()
      local action = Consts.SuperiorCables and "(Disabled)" or "(Enabled)"
      return action .. " Cables and pipes are built instantly."
    end,
    action = ChoGGi.CablesAndPipesToggle
  },

  ChoGGi_StorageDepotHold1000 = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Gameplay/Buildings/Storage Depot|Waste Rock Hold 1000",
    description = function()
      local action = ChoGGi.CheatMenuSettings.StorageDepotSpace and "(Enabled)" or "(Disabled)"
      return action .. " Larger storage depot space (applies to existing and newly placed)."
    end,
    action = ChoGGi.StorageDepotHold1000
  },

  ChoGGi_Building_wonder = {
    icon = "toggle_post.tga",
    menu = "Gameplay/Buildings/Unlimited Wonders",
    description = function()
      local action = ChoGGi.CheatMenuSettings.Building_wonder and "(Enabled)" or "(Disabled)"
      return action .. " Wonder build limit (restart game to toggle)."
    end,
    action = ChoGGi.Building_wonder
  },

  ChoGGi_Building_hide_from_build_menu = {
    icon = "toggle_post.tga",
    menu = "Gameplay/Buildings/Show Hidden Buildings",
    description = function()
      local action = ChoGGi.CheatMenuSettings.Building_hide_from_build_menu and "(Enabled)" or "(Disabled)"
      return action .. " Show hidden buildings (restart game to toggle)."
    end,
    action = ChoGGi.Building_hide_from_build_menu
  },

--[[these don't work (yet)
  ChoGGi_Building_dome_required = {
    icon = "toggle_post.tga",
    menu = "Gameplay/Buildings/Building_dome_required",
    description = function()
      local action = ChoGGi.CheatMenuSettings.Building_dome_required and "Allow" or "Block"
      return action .. " inside buildings outside (restart game to disable)."
    end,
    action = ChoGGi.Building_dome_required
  },

  ChoGGi_Building_dome_forbidden = {
    icon = "toggle_post.tga",
    menu = "Gameplay/Buildings/Building_dome_forbidden",
    description = function()
      local action = ChoGGi.CheatMenuSettings.Building_dome_forbidden and "Allow" or "Block"
      return action .. " outer buildings placed inside (restart game to disable)."
    end,
    action = ChoGGi.Building_dome_forbidden
  },

  ChoGGi_Building_dome_spot = {
    icon = "toggle_post.tga",
    menu = "Gameplay/Buildings/Building_dome_spot",
    description = function()
      local action = ChoGGi.CheatMenuSettings.Building_dome_spot and "Allow" or "Block"
      return action .. " spires to be placed anywhere inside dome, other than spire area (restart game to disable)."
    end,
    action = ChoGGi.Building_dome_spot
  },

  ChoGGi_Building_is_tall = {
    icon = "toggle_post.tga",
    menu = "Gameplay/Buildings/Building_is_tall",
    description = function()
      local action = ChoGGi.CheatMenuSettings.Building_is_tall and "Allow" or "Block"
      return action .. " tall buildings placed under pipes (restart game to disable)."
    end,
    action = ChoGGi.Building_is_tall
  },

  ChoGGi_Building_instant_build = {
    icon = "toggle_post.tga",
    menu = "Gameplay/Buildings/Building_instant_build",
    description = function()
      local action = ChoGGi.CheatMenuSettings.Building_instant_build and "Allow" or "Block"
      return action .. " instant building (restart game to disable)."
    end,
    action = ChoGGi.Building_instant_build
  },

  --breaks building buildings with prefabs
  ChoGGi_Building_require_prefab = {
    icon = "toggle_post.tga",
    menu = "Gameplay/Buildings/Building_require_prefab",
    description = function()
      local action = ChoGGi.CheatMenuSettings.Building_hide_from_build_menu and "Allow" or "Block"
      return action .. " requiring Prefabs (restart game to disable)."
    end,
    action = ChoGGi.Building_require_prefab
  },
--]]

})

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: MenuGameplayBuildings.lua",true)
end
