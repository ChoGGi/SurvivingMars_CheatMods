local function RemoveMaintenanceBuildup(building)
  --no points buildup
  if building.base_maintenance_build_up_per_hr then
    building.maintenance_build_up_per_hr = 0
  end
  --[[
    --FullyAutomatedBuildings
    building.max_workers = 0
    building.automation = 1
    building.auto_performance = 150
  --]]
end

--for newly placed buildings
function OnMsg.ConstructionComplete(building)
  RemoveMaintenanceBuildup(building)
end

--if instant_build is on
function OnMsg.BuildingPlaced(building)
  RemoveMaintenanceBuildup(building)
end

--go through and make sure every building is maintenance free at startup
function OnMsg.LoadGame(metadata)
  for _,object in ipairs(UICity.labels.Building or empty_table) do
    if object.base_maintenance_build_up_per_hr then
        object.maintenance_build_up_per_hr = 0
    end
  end
end
