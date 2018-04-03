ChoGGi.AddAction(
  "Gameplay/Buildings/Production Amount + 25",
  function()
    ChoGGi.SetProduction(true)
  end,
  "Ctrl-Shift-P",
  "Set production of buildings of selected type (air/water/elec/other + 25 (as well as newly placed ones).\nWorks on any building that produces.",
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Production Amount (Default)",
  ChoGGi.SetProduction,
  nil,
  function()
    local name
    if SelectedObj then
      name = SelectedObj.encyclopedia_id
    else
      name = "buildings of selected type"
    end
    return "Set production of all " .. tostring(name) .. " to default value."
  end,
  "DisableAOMaps.tga"
)

--------------
ChoGGi.AddAction(
  "Gameplay/Capacity/Battery Capacity + 1000",
  function()
    ChoGGi.SetCapacity(true,2)
  end,
  "Ctrl-Shift-B",
  "Set capacity of buildings of selected type + 1000 (as well as newly placed ones)",
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Capacity/Battery Capacity (Default)",
  function()
    ChoGGi.SetCapacity(nil,2)
  end,
  nil,
  function()
    local name
    if SelectedObj then
      name = SelectedObj.encyclopedia_id
    else
      name = "buildings of selected type"
    end
    return "Set capacity of all " .. tostring(name) .. " to default value."
  end,
  "DisableAOMaps.tga"
)
--------------
ChoGGi.AddAction(
  "Gameplay/Capacity/Air|Water Capacity + 1000",
  function()
    ChoGGi.AirWaterCapacity(true)
  end,
  "Ctrl-Shift-A",
  "Set capacity of buildings of selected type + 1000 (as well as newly placed ones)",
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Capacity/Air|Water Capacity (Default)",
  ChoGGi.AirWaterCapacity,
  nil,
  function()
    local name
    if SelectedObj then
      name = SelectedObj.encyclopedia_id
    else
      name = "buildings of selected type"
    end
    return "Set capacity of all " .. tostring(name) .. " to default value."
  end,
  "DisableAOMaps.tga"
)
--------------
ChoGGi.AddAction(
  "Gameplay/Capacity/Colonist Capacity + 16",
  function()
    ChoGGi.SetCapacity(true,1)
  end,
  "Ctrl-Shift-C",
  "Set colonist capacity of all buildings of selected type + 16 (as well as newly placed ones)",
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Capacity/Colonist Capacity (Default)",
  function()
    ChoGGi.SetCapacity(nil,1)
  end,
  nil,
  function()
    local amt
    local name
    if SelectedObj and SelectedObj.base_capacity then
      amt = SelectedObj.base_capacity
      name = SelectedObj.encyclopedia_id
    else
      amt = "default value"
      name = "buildings of selected type"
    end
    return "Set colonist capacity of all " .. tostring(name) .. " to " .. tostring(amt)
  end,
  "DisableAOMaps.tga"
)
--------------
ChoGGi.AddAction(
  "Gameplay/Capacity/Visitor Capacity + 16",
  function()
    ChoGGi.VisitorCapacitySet(true)
  end,
  "Ctrl-Shift-V",
  "Set visitors capacity of all buildings of selected type + 16 (as well as newly placed ones)",
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Capacity/Visitor Capacity (Default)",
  ChoGGi.VisitorCapacitySet,
  nil,
  function()
    local amt
    local name
    if SelectedObj and SelectedObj.base_max_visitors then
      amt = SelectedObj.base_max_visitors
      name = SelectedObj.encyclopedia_id
    else
      amt = "default value"
      name = "buildings of selected type"
    end
    return "Set visitor capacity of all " .. tostring(name) .. " to " .. tostring(amt)
  end,
  "DisableAOMaps.tga"
)
--------------
ChoGGi.AddAction(
  "Gameplay/Capacity/Storage Waste Depot + 1000",
  function()
    ChoGGi.StorageDepotWasteSet(true,(ChoGGi.CheatMenuSettings.StorageWasteDepot / ChoGGi.Consts.ResourceScale) + 1000)
  end,
  "Ctrl-Alt-Numpad 3",
  function()
    local des = "Set Depot capacity to " .. (ChoGGi.CheatMenuSettings.StorageWasteDepot / ChoGGi.Consts.ResourceScale) + 1000
    return des .. " (applies to each depot as well as newly built)."
  end,
  "ToggleTerrainHeight.tga"
)
ChoGGi.AddAction(
  "Gameplay/Capacity/Storage Waste Depot (Default)",
  function()
    ChoGGi.StorageDepotWasteSet(nil,ChoGGi.Consts.StorageWasteDepot / ChoGGi.Consts.ResourceScale)
  end,
  nil,
  function()
    return "Set Depot capacity to " .. ChoGGi.Consts.StorageWasteDepot / ChoGGi.Consts.ResourceScale
  end,
  "ToggleTerrainHeight.tga"
)
--------------
ChoGGi.AddAction(
  "Gameplay/Capacity/Storage Other Depot + 1000",
  function()
    ChoGGi.StorageDepotOtherSet(true,(ChoGGi.CheatMenuSettings.StorageOtherDepot / ChoGGi.Consts.ResourceScale) + 1000)
  end,
  "Ctrl-Alt-Numpad 2",
  function()
    local des = "Set Depot capacity to " .. (ChoGGi.CheatMenuSettings.StorageOtherDepot / ChoGGi.Consts.ResourceScale) + 1000
    return des .. " (applies to each depot as well as newly built)."
  end,
  "ToggleTerrainHeight.tga"
)

ChoGGi.AddAction(
  "Gameplay/Capacity/Storage Other Depot (Default)",
  function()
    ChoGGi.StorageDepotOtherSet(nil,ChoGGi.Consts.StorageOtherDepot / ChoGGi.Consts.ResourceScale)
  end,
  nil,
  function()
    return "Set Depot capacity to " .. ChoGGi.Consts.StorageOtherDepot / ChoGGi.Consts.ResourceScale
  end,
  "ToggleTerrainHeight.tga"
)
--------------
ChoGGi.AddAction(
  "Gameplay/Capacity/Storage Universal Depot + 1000",
  function()
    ChoGGi.StorageDepotUniversalSet(true,(ChoGGi.CheatMenuSettings.StorageUniversalDepot / ChoGGi.Consts.ResourceScale) + 1000)
  end,
  "Ctrl-Alt-Numpad 1",
  function()
    local des = "Set Depot capacity to " .. (ChoGGi.CheatMenuSettings.StorageUniversalDepot / ChoGGi.Consts.ResourceScale) + 1000
    return des .. " (applies to each depot as well as newly built)."
  end,
  "ToggleTerrainHeight.tga"
)

ChoGGi.AddAction(
  "Gameplay/Capacity/Storage Universal Depot (Default)",
  function()
    ChoGGi.StorageDepotUniversalSet(nil,ChoGGi.Consts.StorageUniversalDepot / ChoGGi.Consts.ResourceScale)
  end,
  nil,
  function()
    return "Set Depot capacity to " .. ChoGGi.Consts.StorageUniversalDepot / ChoGGi.Consts.ResourceScale
  end,
  "ToggleTerrainHeight.tga"
)
--------------
ChoGGi.AddAction(
  "Gameplay/Buildings/Repair Pipes|Cables",
  ChoGGi.RepairPipesCables,
  nil,
  "Instantly repair all broken pipes and cables.",
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Fully Automated Buildings Toggle",
  ChoGGi.FullyAutomatedBuildings_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.FullyAutomatedBuildings and "(Enabled)" or "(Disabled)"
    return des  .. " No more colonists needed.\nThanks to BoehserOnkel for the idea."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Add Mystery|Breakthrough Buildings",
  ChoGGi.AddMysteryBreakthroughBuildings,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.AddMysteryBreakthroughBuildings and "(Enabled)" or "(Disabled)"
    return des .. " Show all the Mystery and Breakthrough buildings in the build menu."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Sanatoriums Cure All Toggle",
  ChoGGi.SanatoriumCureAll_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.SanatoriumCureAll and "(Disabled)" or "(Enabled)"
    return des .. " Sanatoriums can cure all bad traits."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Schools Train All Toggle",
  ChoGGi.SchoolTrainAll_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.SchoolTrainAll and "(Disabled)" or "(Enabled)"
    return des .. " Schools can train all good traits."
  end,
  "DisableAOMaps.tga"
)


ChoGGi.AddAction(
  "Gameplay/Buildings/Sanatoriums|Schools Show Full List Toggle",
  ChoGGi.SanatoriumSchoolShowAll,
  nil,
  function()
    local des
    if Sanatorium.max_traits == 16 then
      des = "(Enabled)"
    else
      des = "(Disabled)"
    end
    return des .. " Toggle showing 16 traits in side pane."
  end,
  "DisableAOMaps.tga"
)


ChoGGi.AddAction(
  "Gameplay/Buildings/Maintenance Free Toggle",
  ChoGGi.MaintenanceBuildingsFree_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.BuildingMaintenancePointsModifier,"(Disabled)","(Enabled)")
    return des .. " Buildings don't build up maintenance points."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Moisture Vaporator Penalty Toggle",
  ChoGGi.MoistureVaporatorPenalty_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(const.MoistureVaporatorRange,"(Disabled)","(Enabled)")
    return des .. " Disable penalty when Moisture Vaporators are close to each other."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Crop Fail Threshold Toggle",
  ChoGGi.CropFailThreshold_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.CropFailThreshold,"(Disabled)","(Enabled)")
    return des .. " Remove Threshold for failing crops."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Cheap Construction Toggle",
  ChoGGi.CheapConstruction_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.rebuild_cost_modifier,"(Disabled)","(Enabled)")
    return des .. " Build with minimal resources."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Building Damage Crime Toggle",
  ChoGGi.BuildingDamageCrime_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.CrimeEventSabotageBuildingsCount,"(Disabled)","(Enabled)")
    return des .. " Disable damage from renegedes to buildings."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Instant Cables And Pipes Toggle",
  ChoGGi.CablesAndPipes_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.InstantCables,"(Enabled)","(Disabled)")
    return des .. " Cables and pipes are built instantly."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Unlimited Wonders",
  ChoGGi.Building_wonder_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.Building_wonder and "(Enabled)" or "(Disabled)"
    return des .. " Wonder build limit (restart game to toggle)."
  end,
  "toggle_post.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Build Spires Outside of Spire Point",
  ChoGGi.Building_dome_spot_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.Building_dome_spot and "(Enabled)" or "(Disabled)"
    return des .. " Wonder build limit (restart game to toggle)."
  end,
  "toggle_post.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Show Hidden Buildings",
  ChoGGi.Building_hide_from_build_menu_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.Building_hide_from_build_menu and "(Enabled)" or "(Disabled)"
    return des .. " Show hidden buildings (restart game to toggle).\nUse with remove building limits to fill up a dome with spires."
  end,
  "toggle_post.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Allow Dome Forbidden Buildings",
  ChoGGi.Building_dome_forbidden_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.Building_dome_forbidden and "(Enabled)" or "(Disabled)"
    return des .. " Allow buildings forbidden to be placed in dome (restart game to toggle)."
  end,
  "toggle_post.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Allow Dome Required Buildings",
  ChoGGi.Building_dome_required_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.Building_dome_required and "(Enabled)" or "(Disabled)"
    return des .. " Allow buildings required to be placed in dome not to be (restart game to toggle)."
  end,
  "toggle_post.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Allow Tall Buildings Under Pipes",
  ChoGGi.Building_is_tall_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.Building_is_tall and "(Enabled)" or "(Disabled)"
    return des .. " Allow tall buildings to be placed under pipes (restart game to toggle)."
  end,
  "toggle_post.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Instant Build",
  ChoGGi.Building_instant_build_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.Building_instant_build and "(Enabled)" or "(Disabled)"
    return des .. " Allow buildings to be built instantly (restart game to toggle)."
  end,
  "toggle_post.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Remove Building Limits",
  ChoGGi.RemoveBuildingLimits_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.RemoveBuildingLimits and "(Enabled)" or "(Disabled)"
    return des .. " Buildings can be placed almost anywhere (I left uneven terrain blocked, and pipes don't like domes).\nRestart to toggle."
  end,
  "toggle_post.tga"
)

if ChoGGi.ChoGGiTest then
  table.insert(ChoGGi.FilesCount,"BuildingsMenu")
end
