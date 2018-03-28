UserActions.AddActions({

  ChoGGi_StorageWasteDepotIncrease = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Gameplay/Buildings/[01]Capacity/Storage Waste Depot + 1024",
    description = function()
      return "Set Depot capacity " .. (ChoGGi.CheatMenuSettings.StorageWasteDepot / ChoGGi.Consts.ResourceScale) + 1024
        .. " (applies to each depot as well as newly built)."
    end,
    action = function()
      ChoGGi.StorageDepotSet(1,true,"Waste",(ChoGGi.CheatMenuSettings.StorageWasteDepot / ChoGGi.Consts.ResourceScale) + 1024)
    end
  },

  ChoGGi_StorageWasteDepotDefault = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Gameplay/Buildings/[01]Capacity/Storage Waste Depot Default",
    description = function()
      return "Set Depot capacity " .. ChoGGi.Consts.StorageWasteDepot / ChoGGi.Consts.ResourceScale
    end,
    action = function()
      ChoGGi.StorageDepotSet(1,nil,"Waste",ChoGGi.Consts.StorageWasteDepot / ChoGGi.Consts.ResourceScale)
    end
  },

  ChoGGi_StorageOtherDepotIncrease = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Gameplay/Buildings/[01]Capacity/Storage Other Depot + 1024",
    description = function()
      return "Set Depot capacity " .. (ChoGGi.CheatMenuSettings.StorageOtherDepot / ChoGGi.Consts.ResourceScale) + 1024
        .. " (applies to each depot as well as newly built)."
    end,
    action = function()
      ChoGGi.StorageDepotSet(2,true,"Other",(ChoGGi.CheatMenuSettings.StorageOtherDepot / ChoGGi.Consts.ResourceScale) + 1024)
    end
  },

  ChoGGi_StorageOtherDepotDefault = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Gameplay/Buildings/[01]Capacity/Storage Other Depot Default",
    description = function()
      return "Set Depot capacity " .. ChoGGi.Consts.StorageOtherDepot / ChoGGi.Consts.ResourceScale
    end,
    action = function()
      ChoGGi.StorageDepotSet(2,nil,"Other",ChoGGi.Consts.StorageOtherDepot / ChoGGi.Consts.ResourceScale)
    end
  },

  ChoGGi_StorageUniversalDepotIncrease = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Gameplay/Buildings/[01]Capacity/Storage Universal Depot + 1024",
    description = function()
      return "Set Depot capacity " .. (ChoGGi.CheatMenuSettings.StorageUniversalDepot / ChoGGi.Consts.ResourceScale) + 1024
        .. " (applies to each depot as well as newly built)."
    end,
    action = function()
      ChoGGi.StorageDepotSet(3,true,"Universal",(ChoGGi.CheatMenuSettings.StorageUniversalDepot / ChoGGi.Consts.ResourceScale) + 1024)
    end
  },

  ChoGGi_StorageUniversalDepotDefault = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Gameplay/Buildings/[01]Capacity/Storage Universal Depot Default",
    description = function()
      return "Set Depot capacity " .. ChoGGi.Consts.StorageUniversalDepot / ChoGGi.Consts.ResourceScale
    end,
    action = function()
      ChoGGi.StorageDepotSet(3,nil,"Universal",ChoGGi.Consts.StorageUniversalDepot / ChoGGi.Consts.ResourceScale)
    end
  },

  ChoGGi_ArcologyColonistsIncrease = {
    icon = "DisableAOMaps.tga",
    menu = "Gameplay/Buildings/[01]Capacity/Arcology Colonists + 32",
    description = function()
      return "Set arcology colonist capacity " .. ChoGGi.CheatMenuSettings.ArcologyCapacity + ChoGGi.Consts.ArcologyCapacity
        .. " (applies to the capacity of each Arcology as well as newly built)."
    end,
    action = function()
      ChoGGi.ArcologyColonistsToggle(true)
    end
  },

  ChoGGi_ArcologyColonistsDefault = {
    icon = "DisableAOMaps.tga",
    menu = "Gameplay/Buildings/[01]Capacity/Arcology Colonists Default",
    description = function()
      return "Set arcology capacity " .. ChoGGi.Consts.ArcologyCapacity
    end,
    action = ChoGGi.ArcologyColonistsToggle
  },

  ChoGGi_FullyAutomatedBuildingsToggle = {
    icon = "DisableAOMaps.tga",
    menu = "Gameplay/Buildings/Fully Automated Buildings Toggle",
    description = function()
      local res = ChoGGi.CheatMenuSettings.FullyAutomatedBuildings and "(Enabled)" or "(Disabled)"
      return res .. " Add an upgrade to automate buildings, restart to enable/disable (if another upgrade replaces it; toggle it off and on).\nThanks to BoehserOnkel for the idea."
    end,
    action = ChoGGi.FullyAutomatedBuildingsToggle
  },

  ChoGGi_AddMysteryBreakthroughBuildings = {
    icon = "DisableAOMaps.tga",
    menu = "Gameplay/Buildings/Add Mystery|Breakthrough Buildings",
    description = function()
      local res = ChoGGi.CheatMenuSettings.AddMysteryBreakthroughBuildings and "(Enabled)" or "(Disabled)"
      return res .. " Show all the Mystery and Breakthrough buildings in the build menu."
    end,
    action = ChoGGi.AddMysteryBreakthroughBuildings
  },

  ChoGGi_SanatoriumCureAllToggle = {
    icon = "DisableAOMaps.tga",
    menu = "Gameplay/Buildings/Sanatoriums Cure All Toggle",
    description = function()
      local res = ChoGGi.CheatMenuSettings.SanatoriumCureAll and "(Disabled)" or "(Enabled)"
      return res .. " Sanatoriums now cure all bad traits."
    end,
    action = ChoGGi.SanatoriumCureAllToggle
  },

  ChoGGi_SchoolTrainAllToggle = {
    icon = "DisableAOMaps.tga",
    menu = "Gameplay/Buildings/Schools Train All Toggle",
    description = function()
      local res = ChoGGi.CheatMenuSettings.SchoolTrainAll and "(Disabled)" or "(Enabled)"
      return res .. " Schools now can train all good traits."
    end,
    action = ChoGGi.SchoolTrainAllToggle
  },

  ChoGGi_SanatoriumSchoolShowAll = {
    icon = "DisableAOMaps.tga",
    menu = "Gameplay/Buildings/Sanatoriums|Schools Show Full List Toggle",
    description = function()
      local res
      if Sanatorium.max_traits == 16 then
        res = "(Enabled)"
      else
        res = "(Disabled)"
      end
      return res .. " Toggle showing 16 traits in side pane."
    end,
    action = ChoGGi.SanatoriumSchoolShowAll
  },

  ChoGGi_MaintenanceBuildingsFreeToggle = {
    icon = "DisableAOMaps.tga",
    menu = "Gameplay/Buildings/Maintenance Free Toggle",
    description = function()
      local res = ChoGGi.NumRetBool(Consts.BuildingMaintenancePointsModifier,"(Disabled)","(Enabled)")
      return res .. " Buildings don't get dusty."
    end,
    action = ChoGGi.MaintenanceBuildingsFreeToggle
  },

  ChoGGi_MoistureVaporatorPenaltyToggle = {
    icon = "DisableAOMaps.tga",
    menu = "Gameplay/Buildings/Moisture Vaporator Penalty Toggle",
    description = function()
      local res = ChoGGi.NumRetBool(const.MoistureVaporatorRange,"(Disabled)","(Enabled)")
      return res .. " penalty when Moisture Vaporators are close to each other."
    end,
    action = ChoGGi.MoistureVaporatorPenaltyToggle
  },

  ChoGGi_ConstructionForFreeToggle = {
    icon = "DisableAOMaps.tga",
    menu = "Gameplay/Buildings/Construction For Free Toggle",
    description = function()
      local res = ChoGGi.NumRetBool(Consts.rebuild_cost_modifier,"(Disabled)","(Enabled)")
      return res .. " Build without resources."
    end,
    action = ChoGGi.ConstructionForFreeToggle
  },

  ChoGGi_BuildingDamageCrimeToggle = {
    icon = "DisableAOMaps.tga",
    menu = "Gameplay/Buildings/Building Damage Crime Toggle",
    description = function()
      local res = ChoGGi.NumRetBool(Consts.CrimeEventSabotageBuildingsCount,"(Disabled)","(Enabled)")
      return res .. " damage from renegedes to buildings."
    end,
    action = ChoGGi.BuildingDamageCrimeToggle
  },

  ChoGGi_CablesAndPipesToggle = {
    icon = "DisableAOMaps.tga",
    menu = "Gameplay/Buildings/Cables And Pipes Toggle",
    description = function()
      local res = ChoGGi.NumRetBool(Consts.InstantCables,"(Disabled)","(Enabled)")
      return res .. " Cables and pipes are built instantly."
    end,
    action = ChoGGi.CablesAndPipesToggle
  },

  ChoGGi_Building_wonder = {
    icon = "toggle_post.tga",
    menu = "Gameplay/Buildings/Unlimited Wonders",
    description = function()
      local res = ChoGGi.CheatMenuSettings.Building_wonder and "(Enabled)" or "(Disabled)"
      return res .. " Wonder build limit (restart game to toggle)."
    end,
    action = ChoGGi.Building_wonder
  },

  ChoGGi_Building_hide_from_build_menu = {
    icon = "toggle_post.tga",
    menu = "Gameplay/Buildings/Show Hidden Buildings",
    description = function()
      local res = ChoGGi.CheatMenuSettings.Building_hide_from_build_menu and "(Enabled)" or "(Disabled)"
      return res .. " Show hidden buildings (restart game to toggle)."
    end,
    action = ChoGGi.Building_hide_from_build_menu
  },

--[[these don't work (yet)
  ChoGGi_Building_dome_required = {
    icon = "toggle_post.tga",
    menu = "Gameplay/Buildings/Building_dome_required",
    description = function()
      local res = ChoGGi.CheatMenuSettings.Building_dome_required and "Allow" or "Block"
      return res .. " inside buildings outside (restart game to disable)."
    end,
    action = ChoGGi.Building_dome_required
  },

  ChoGGi_Building_dome_forbidden = {
    icon = "toggle_post.tga",
    menu = "Gameplay/Buildings/Building_dome_forbidden",
    description = function()
      local res = ChoGGi.CheatMenuSettings.Building_dome_forbidden and "Allow" or "Block"
      return res .. " outer buildings placed inside (restart game to disable)."
    end,
    action = ChoGGi.Building_dome_forbidden
  },

  ChoGGi_Building_dome_spot = {
    icon = "toggle_post.tga",
    menu = "Gameplay/Buildings/Building_dome_spot",
    description = function()
      local res = ChoGGi.CheatMenuSettings.Building_dome_spot and "Allow" or "Block"
      return res .. " spires to be placed anywhere inside dome, other than spire area (restart game to disable)."
    end,
    action = ChoGGi.Building_dome_spot
  },

  ChoGGi_Building_is_tall = {
    icon = "toggle_post.tga",
    menu = "Gameplay/Buildings/Building_is_tall",
    description = function()
      local res = ChoGGi.CheatMenuSettings.Building_is_tall and "Allow" or "Block"
      return res .. " tall buildings placed under pipes (restart game to disable)."
    end,
    action = ChoGGi.Building_is_tall
  },

  ChoGGi_Building_instant_build = {
    icon = "toggle_post.tga",
    menu = "Gameplay/Buildings/Building_instant_build",
    description = function()
      local res = ChoGGi.CheatMenuSettings.Building_instant_build and "Allow" or "Block"
      return res .. " instant building (restart game to disable)."
    end,
    action = ChoGGi.Building_instant_build
  },

  --breaks building buildings with prefabs
  ChoGGi_Building_require_prefab = {
    icon = "toggle_post.tga",
    menu = "Gameplay/Buildings/Building_require_prefab",
    description = function()
      local res = ChoGGi.CheatMenuSettings.Building_hide_from_build_menu and "Allow" or "Block"
      return res .. " requiring Prefabs (restart game to disable)."
    end,
    action = ChoGGi.Building_require_prefab
  },
--]]

})

if ChoGGi.ChoGGiTest then
  AddConsoleLog("ChoGGi: MenuBuildings.lua",true)
end
