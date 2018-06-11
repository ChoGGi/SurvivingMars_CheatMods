--See LICENSE for terms
--menus under Gameplay menu without a separate file

local Concat = ChoGGi.ComFuncs.Concat
local T = ChoGGi.ComFuncs.Trans
--~ local icon = "new_city.tga"

function ChoGGi.MsgFuncs.ExpandedMenu_LoadingScreenPreClose()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

--------------------------------top level
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/[97]",T(302535920000031--[[Find Nearest Resource--]])),
    ChoGGi.CodeFuncs.FindNearestResource,
    nil,
    T(302535920000554--[[Select an object and click this to display a list of resources.--]]),
    "EV_OpenFirst.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/[99]",T(302535920000469--[[Close Dialogs--]])),
    ChoGGi.CodeFuncs.CloseDialogsECM,
    nil,
    T(302535920000470--[[Close any dialogs opened by ECM (Examine, ObjectManipulator, Change Colours, etc...)--]]),
    "remove_water.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/[98]",T(302535920000555--[[Monitor Info--]])),
    ChoGGi.MenuFuncs.MonitorInfo,
    nil,
    T(302535920000556--[[Shows a list of updated information about your city.--]]),
    "EV_OpenFirst.tga"
  )

--------------------------------top level

  -------------rockets
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(5238--[[Rockets--]]),"/",T(302535920000557--[[Launch Empty Rocket--]])),
    ChoGGi.MenuFuncs.LaunchEmptyRocket,
    nil,
    T(302535920000558--[[Launches an empty rocket to Mars.--]]),
    "change_height_up.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(5238--[[Rockets--]]),"/",T(302535920000559--[[Cargo Capacity--]])),
    ChoGGi.MenuFuncs.SetRocketCargoCapacity,
    nil,
    T(302535920000560--[[Change amount of storage space in rockets.--]]),
    "scale_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(5238--[[Rockets--]]),"/",T(302535920000561--[[Travel Time--]])),
    ChoGGi.MenuFuncs.SetRocketTravelTime,
    nil,
    T(302535920000562--[[Change how long to take to travel between planets.--]]),
    "place_particles.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(5238--[[Rockets--]]),"/",T(4594--[[Colonists Per Rocket--]])),
    ChoGGi.MenuFuncs.SetColonistsPerRocket,
    nil,
    T(302535920000564--[[Change how many colonists can arrive on Mars in a single Rocket.--]]),
    "ToggleMarkers.tga"
  )

  --------------------capacity
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(109035890389--[[Capacity--]]),"/",T(302535920000565--[[Storage Mechanized Depots Temp--]])),
    ChoGGi.MenuFuncs.StorageMechanizedDepotsTemp_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.StorageMechanizedDepotsTemp,
        302535920000566 --,"Allow the temporary storage to hold 100 instead of 50 cubes."
      )
    end,
    "Cube.tga"
  )
  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(109035890389--[[Capacity--]]),"/",T(302535920000567--[[Worker Capacity--]])),
    ChoGGi.MenuFuncs.SetWorkerCapacity,
    "Ctrl-Shift-W",
    T(302535920000568--[[Change how many workers per building type.--]]),
    "scale_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(109035890389--[[Capacity--]]),"/",T(302535920000569--[[Building Capacity--]])),
    ChoGGi.MenuFuncs.SetBuildingCapacity,
    "Ctrl-Shift-C",
    T(302535920000570--[[Set capacity of buildings of selected type, also applies to newly placed ones (colonists/air/water/elec).--]]),
    "scale_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(109035890389--[[Capacity--]]),"/",T(302535920000571--[[Building Visitor Capacity--]])),
    ChoGGi.MenuFuncs.SetVisitorCapacity,
    "Ctrl-Shift-V",
    T(302535920000572--[[Set visitors capacity of all buildings of selected type, also applies to newly placed ones.--]]),
    "scale_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(109035890389--[[Capacity--]]),"/",T(302535920000573--[[Storage Universal Depot--]])),
    function()
      ChoGGi.MenuFuncs.SetStorageDepotSize("StorageUniversalDepot")
    end,
    nil,
    T(302535920000574--[[Change universal storage depot capacity.--]]),
    "MeasureTool.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(109035890389--[[Capacity--]]),"/",T(302535920000575--[[Storage Other Depot--]])),
    function()
      ChoGGi.MenuFuncs.SetStorageDepotSize("StorageOtherDepot")
    end,
    nil,
    T(302535920000576--[[Change other storage depot capacity.--]]),
    "MeasureTool.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(109035890389--[[Capacity--]]),"/",T(302535920000577--[[Storage Waste Depot--]])),
    function()
      ChoGGi.MenuFuncs.SetStorageDepotSize("StorageWasteDepot")
    end,
    nil,
    T(302535920000578--[[Change waste storage depot capacity.--]]),
    "MeasureTool.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/",T(109035890389--[[Capacity--]]),"/",T(302535920000579--[[Storage Mechanized Depots--]])),
    function()
      ChoGGi.MenuFuncs.SetStorageDepotSize("StorageMechanizedDepot")
    end,
    nil,
    T(302535920000580--[[Change mechanized depot storage capacity.--]]),
    "Cube.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/Resources/",T(302535920000719--[[Add Orbital Probes--]])),
    ChoGGi.MenuFuncs.AddOrbitalProbes,
    nil,
    T(302535920000720--[[Add more probes.--]]),
    "ToggleTerrainHeight.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/Resources/",T(4616--[[Food Per Rocket Passenger--]])),
    ChoGGi.MenuFuncs.SetFoodPerRocketPassenger,
    nil,
    T(302535920000722--[[Change the amount of Food supplied with each Colonist arrival.--]]),
    "ToggleTerrainHeight.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/Resources/",T(302535920000723--[[Add Prefabs--]])),
    ChoGGi.MenuFuncs.AddPrefabs,
    nil,
    T(302535920000724--[[Adds prefabs.--]]),
    "gear.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/Resources/",T(302535920000725--[[Add Funding--]])),
    ChoGGi.MenuFuncs.SetFunding,
    "Ctrl-Shift-0",
    T(302535920000726--[[Add more funding (or reset back to 500 M).--]]),
    "pirate.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(302535920000104--[[Expanded CM--]]),"/Resources/",T(302535920000727--[[Fill Selected Resource--]])),
    ChoGGi.MenuFuncs.FillResource,
    "Ctrl-F",
    T(302535920000728--[[Fill the selected/moused over object's resource(s)--]]),
    "Cube.tga"
  )

end
