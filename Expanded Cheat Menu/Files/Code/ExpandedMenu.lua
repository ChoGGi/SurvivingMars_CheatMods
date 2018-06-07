--See LICENSE for terms
--menus under Gameplay menu without a separate file

local icon = "new_city.tga"

function ChoGGi.MsgFuncs.ExpandedMenu_LoadingScreenPreClose()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/[98]Misc/" .. ChoGGi.ComFuncs.Trans(302535920000553,"Find Nearest Resource"),
    ChoGGi.CodeFuncs.FindNearestResource,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000554,"Select an object and click this to display a list of resources."),
    "EV_OpenFirst.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/[99]" .. ChoGGi.ComFuncs.Trans(302535920000555,"Monitor Info"),
    ChoGGi.MenuFuncs.MonitorInfo,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000556,"Shows a list of updated information about your city."),
    "EV_OpenFirst.tga"
  )

  -------------rockets
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Rocket/" .. ChoGGi.ComFuncs.Trans(302535920000557,"Launch Empty Rocket"),
    ChoGGi.MenuFuncs.LaunchEmptyRocket,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000558,"Launches an empty rocket to Mars."),
    "change_height_up.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Rocket/" .. ChoGGi.ComFuncs.Trans(302535920000559,"Cargo Capacity"),
    ChoGGi.MenuFuncs.SetRocketCargoCapacity,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000560,"Change amount of storage space in rockets."),
    "scale_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Rocket/" .. ChoGGi.ComFuncs.Trans(302535920000561,"Travel Time"),
    ChoGGi.MenuFuncs.SetRocketTravelTime,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000562,"Change how long to take to travel between planets."),
    "place_particles.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Rocket/" .. ChoGGi.ComFuncs.Trans(302535920000563,"Colonists Per Rocket"),
    ChoGGi.MenuFuncs.SetColonistsPerRocket,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000564,"Change how many colonists can arrive on Mars in a single Rocket."),
    "ToggleMarkers.tga"
  )

  --------------------capacity
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Capacity/" .. ChoGGi.ComFuncs.Trans(302535920000565,"Storage Mechanized Depots Temp"),
    ChoGGi.MenuFuncs.StorageMechanizedDepotsTemp_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.StorageMechanizedDepotsTemp and "(" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ")" or "(" .. ChoGGi.ComFuncs.Trans(302535920000036,"Disabled") .. ")"
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000566,"Allow the temporary storage to hold 100 instead of 50 cubes.")
    end,
    "Cube.tga"
  )
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Capacity/" .. ChoGGi.ComFuncs.Trans(302535920000567,"Worker Capacity"),
    ChoGGi.MenuFuncs.SetWorkerCapacity,
    "Ctrl-Shift-W",
    ChoGGi.ComFuncs.Trans(302535920000568,"Change how many workers per building type."),
    "scale_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Capacity/" .. ChoGGi.ComFuncs.Trans(302535920000569,"Building Capacity"),
    ChoGGi.MenuFuncs.SetBuildingCapacity,
    "Ctrl-Shift-C",
    ChoGGi.ComFuncs.Trans(302535920000570,"Set capacity of buildings of selected type, also applies to newly placed ones (colonists/air/water/elec)."),
    "scale_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Capacity/" .. ChoGGi.ComFuncs.Trans(302535920000571,"Building Visitor Capacity"),
    ChoGGi.MenuFuncs.SetVisitorCapacity,
    "Ctrl-Shift-V",
    ChoGGi.ComFuncs.Trans(302535920000572,"Set visitors capacity of all buildings of selected type, also applies to newly placed ones."),
    "scale_gizmo.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Capacity/" .. ChoGGi.ComFuncs.Trans(302535920000573,"Storage Universal Depot"),
    function()
      ChoGGi.MenuFuncs.SetStorageDepotSize("StorageUniversalDepot")
    end,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000574,"Change universal storage depot capacity."),
    "MeasureTool.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Capacity/" .. ChoGGi.ComFuncs.Trans(302535920000575,"Storage Other Depot"),
    function()
      ChoGGi.MenuFuncs.SetStorageDepotSize("StorageOtherDepot")
    end,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000576,"Change other storage depot capacity."),
    "MeasureTool.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Capacity/" .. ChoGGi.ComFuncs.Trans(302535920000577,"Storage Waste Depot"),
    function()
      ChoGGi.MenuFuncs.SetStorageDepotSize("StorageWasteDepot")
    end,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000578,"Change waste storage depot capacity."),
    "MeasureTool.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Capacity/" .. ChoGGi.ComFuncs.Trans(302535920000579,"Storage Mechanized Depots"),
    function()
      ChoGGi.MenuFuncs.SetStorageDepotSize("StorageMechanizedDepot")
    end,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000580,"Change mechanized depot storage capacity."),
    "Cube.tga"
  )

end
