--[[
--retrieve list of building/vehicle names
  local templates = DataInstances.BuildingTemplate
  for i = 1, #templates do
    local building_template = templates[i]
    building_template.name
    building_template.require_prefab
  end
available_prefabs = UICity:GetPrefabs(building_template.name)
City:AddPrefabs(bld, count)

--loop through all buildings
  local buildings = UICity.labels.Building
  for _,building in ipairs(buildings) do
    if IsKindOf(building,"Sanatorium") then
      for i = 1, #traits do
        building:SetTrait(i, traits[i])
      end
    end
  end
--]]

--Edit new buildings
function OnMsg.ConstructionComplete(building)

  --increase UniversalStorageDepot to 1000
  if CheatMenuSettings["StorageDepotSpace"] and IsKindOf(building,"UniversalStorageDepot") then
    building.max_storage_per_resource = 1000 * const.ResourceScale
  end
end

-- Call init at the right time
function OnMsg.DataLoaded()
  ReadSettings()
  InitCheats()
end
if not FirstLoad then
  ReadSettings()
  InitCheats()
end
