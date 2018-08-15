-- See LICENSE for terms

-- menus under Gameplay menu without a separate file

local Concat = ChoGGi.ComFuncs.Concat
local AddAction = ChoGGi.ComFuncs.AddAction
local S = ChoGGi.Strings

--~ local icon = "new_city.tga"

local Actions = ChoGGi.Temp.Actions

--------------------------------top level
AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/[96]",S[302535920000031--[[Find Nearest Resource--]]]),
  function()
    ChoGGi.CodeFuncs.FindNearestResource()
  end,
  nil,
  302535920000554--[[Select an object and click this to display a list of resources.--]],
  "EV_OpenFirst.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/[97]",S[302535920000333--[[Building Info--]]]),
  ChoGGi.MenuFuncs.BuildingInfo_Toggle,
  nil,
  302535920000345--[[Shows info about building in text above it.--]],
  "ExportImageSequence.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/[98]",S[302535920000555--[[Monitor Info--]]]),
  ChoGGi.MenuFuncs.MonitorInfo,
  nil,
  302535920000556--[[Shows a list of updated information about your city.--]],
  "EV_OpenFirst.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/[99]",S[302535920000469--[[Close Dialogs--]]]),
  ChoGGi.CodeFuncs.CloseDialogsECM,
  nil,
  302535920000470--[[Close any dialogs opened by ECM (Examine, ObjectManipulator, Change Colours, etc...)--]],
  "remove_water.tga"
)



--------------------------------top level

-------------rockets
AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[5238--[[Rockets--]]],"/",S[302535920000850--[[Change Resupply Settings--]]]),
  ChoGGi.MenuFuncs.ChangeResupplySettings,
  nil,
  302535920001094--[["Shows a list of all cargo and allows you to change the price, weight taken up, if it's locked from view, and how many per click."--]],
  "change_height_down.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[5238--[[Rockets--]]],"/",S[302535920000557--[[Launch Empty Rocket--]]]),
  ChoGGi.MenuFuncs.LaunchEmptyRocket,
  nil,
  302535920000558--[[Launches an empty rocket to Mars.--]],
  "change_height_up.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[5238--[[Rockets--]]],"/",S[302535920000559--[[Cargo Capacity--]]]),
  ChoGGi.MenuFuncs.SetRocketCargoCapacity,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.CargoCapacity,
      302535920000560--[[Change amount of storage space in rockets.--]]
    )
  end,
  "scale_gizmo.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[5238--[[Rockets--]]],"/",S[302535920000561--[[Travel Time--]]]),
  ChoGGi.MenuFuncs.SetRocketTravelTime,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.TravelTimeEarthMars,
      302535920000562--[[Change how long to take to travel between planets.--]]
    )
  end,
  "place_particles.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[5238--[[Rockets--]]],"/",S[4594--[[Colonists Per Rocket--]]]),
  ChoGGi.MenuFuncs.SetColonistsPerRocket,
  nil,
  302535920000564--[[Change how many colonists can arrive on Mars in a single Rocket.--]],
  "ToggleMarkers.tga"
)

--------------------capacity
AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[109035890389--[[Capacity--]]],"/",S[302535920000565--[[Storage Mechanized Depots Temp--]]]),
  ChoGGi.MenuFuncs.StorageMechanizedDepotsTemp_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.StorageMechanizedDepotsTemp,
      302535920000566--[[Allow the temporary storage to hold 100 instead of 50 cubes.--]]
    )
  end,
  "Cube.tga"
)
AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[109035890389--[[Capacity--]]],"/",S[302535920000567--[[Worker Capacity--]]]),
  ChoGGi.MenuFuncs.SetWorkerCapacity,
  ChoGGi.UserSettings.KeyBindings.SetWorkerCapacity,
  302535920000568--[["Set worker capacity of buildings of selected type, also applies to newly placed ones."--]],
  "scale_gizmo.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[109035890389--[[Capacity--]]],"/",S[302535920000569--[[Building Capacity--]]]),
  ChoGGi.MenuFuncs.SetBuildingCapacity,
  ChoGGi.UserSettings.KeyBindings.SetBuildingCapacity,
  302535920000570--[[Set capacity of buildings of selected type, also applies to newly placed ones (colonists/air/water/elec).--]],
  "scale_gizmo.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[109035890389--[[Capacity--]]],"/",S[302535920000571--[[Building Visitor Capacity--]]]),
  ChoGGi.MenuFuncs.SetVisitorCapacity,
  ChoGGi.UserSettings.KeyBindings.SetVisitorCapacity,
  302535920000572--[[Set visitors capacity of all buildings of selected type, also applies to newly placed ones.--]],
  "scale_gizmo.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[109035890389--[[Capacity--]]],"/",S[302535920000573--[[Storage Universal Depot--]]]),
  function()
    ChoGGi.MenuFuncs.SetStorageDepotSize("StorageUniversalDepot")
  end,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.StorageUniversalDepot,
      302535920000574--[[Change universal storage depot capacity.--]]
    )
  end,
  "MeasureTool.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[109035890389--[[Capacity--]]],"/",S[302535920000575--[[Storage Other Depot--]]]),
  function()
    ChoGGi.MenuFuncs.SetStorageDepotSize("StorageOtherDepot")
  end,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.StorageOtherDepot,
      302535920000576--[[Change other storage depot capacity.--]]
    )
  end,
  "MeasureTool.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[109035890389--[[Capacity--]]],"/",S[302535920000577--[[Storage Waste Depot--]]]),
  function()
    ChoGGi.MenuFuncs.SetStorageDepotSize("StorageWasteDepot")
  end,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.StorageWasteDepot,
      302535920000578--[[Change waste storage depot capacity.--]]
    )
  end,
  "MeasureTool.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[109035890389--[[Capacity--]]],"/",S[302535920000579--[[Storage Mechanized Depots--]]]),
  function()
    ChoGGi.MenuFuncs.SetStorageDepotSize("StorageMechanizedDepot")
  end,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.StorageMechanizedDepot,
      302535920000580--[[Change mechanized depot storage capacity.--]]
    )
  end,
  "Cube.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[692--[[Resources--]]],"/",S[302535920000719--[[Add Orbital Probes--]]]),
  ChoGGi.MenuFuncs.AddOrbitalProbes,
  nil,
  302535920000720--[[Add more probes.--]],
  "ToggleTerrainHeight.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[692--[[Resources--]]],"/",S[4616--[[Food Per Rocket Passenger--]]]),
  ChoGGi.MenuFuncs.SetFoodPerRocketPassenger,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.FoodPerRocketPassenger,
      302535920000722--[[Change the amount of Food supplied with each Colonist arrival.--]]
    )
  end,
  "ToggleTerrainHeight.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[692--[[Resources--]]],"/",S[302535920000723--[[Add Prefabs--]]]),
  ChoGGi.MenuFuncs.AddPrefabs,
  nil,
  302535920000724--[[Adds prefabs.--]],
  "gear.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[692--[[Resources--]]],"/",S[302535920000725--[[Add Funding--]]]),
  ChoGGi.MenuFuncs.SetFunding,
  ChoGGi.UserSettings.KeyBindings.SetFunding,
  302535920000726--[[Add more funding (or reset back to 500 M).--]],
  "pirate.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[692--[[Resources--]]],"/",S[302535920000727--[[Fill Selected Resource--]]]),
  ChoGGi.MenuFuncs.FillResource,
  ChoGGi.UserSettings.KeyBindings.FillResource,
  302535920000728--[[Fill the selected/moused over object's resource(s)--]],
  "Cube.tga"
)
