function ChoGGi.ExpandedMenu_LoadingScreenPreClose()
  --menus under Gameplay menu without a separate file
  --ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

-------------
  local function DisasterOccurrenceText(Name)
    local des = mapdata["MapSettings_" .. Name]
    return "Set the occurrence level of " .. Name .. " disasters.\nCurrent: " .. des
  end

  ChoGGi.AddAction(
    "Expanded CM/Disasters/DustDevils",
    function()
      ChoGGi.SetDisasterOccurrence("DustDevils")
    end,
    nil,
    DisasterOccurrenceText("DustDevils"),
    "RandomMapPresetEditor.tga"
  )
  ChoGGi.AddAction(
    "Expanded CM/Disasters/ColdWave",
    function()
      ChoGGi.SetDisasterOccurrence("ColdWave")
    end,
    nil,
    DisasterOccurrenceText("ColdWave"),
    "RandomMapPresetEditor.tga"
  )
  ChoGGi.AddAction(
    "Expanded CM/Disasters/DustStorm",
    function()
      ChoGGi.SetDisasterOccurrence("DustStorm")
    end,
    nil,
    DisasterOccurrenceText("DustStorm"),
    "RandomMapPresetEditor.tga"
  )
  ChoGGi.AddAction(
    "Expanded CM/Disasters/Meteor",
    function()
      ChoGGi.SetDisasterOccurrence("Meteor")
    end,
    nil,
    DisasterOccurrenceText("Meteor"),
    "RandomMapPresetEditor.tga"
  )
-------------
  ChoGGi.AddAction(
    "Expanded CM/Disasters/Meteor Damage",
    ChoGGi.MeteorHealthDamage_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.MeteorHealthDamage,"(Disabled)","(Enabled)")
      return des .. " Disable Meteor damage (colonists?)."
    end,
    "remove_water.tga"
  )
  -------------
  ChoGGi.AddAction(
    "Expanded CM/Rocket/Cargo Capacity",
    ChoGGi.SetRocketCargoCapacity,
    nil,
    "Change amount of storage space in rockets.",
    "EnrichTerrainEditor.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Rocket/Travel Time",
    ChoGGi.SetRocketTravelTime,
    nil,
    "Change how long to take to travel between planets.",
    "place_particles.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Rocket/Colonists Per Rocket",
    ChoGGi.SetColonistsPerRocket,
    nil,
    "Change how many colonists can arrive on Mars in a single Rocket.",
    "ToggleMarkers.tga"
  )

  --------------------
  ChoGGi.AddAction(
    "Expanded CM/Capacity/Building Capacity",
    ChoGGi.SetBuildingCapacity,
    "Ctrl-Shift-C",
    "Set capacity of buildings of selected type, also applies to newly placed ones.",
    "DisableAOMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Capacity/Building Visitor Capacity",
    ChoGGi.SetVisitorCapacity,
    "Ctrl-Shift-V",
    "Set visitors capacity of all buildings of selected type, also applies to newly placed ones.",
    "DisableAOMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Capacity/Storage Universal Depot",
    function()
      ChoGGi.SetStorageDepotSize("StorageUniversalDepot")
    end,
    nil,
    "Change universal storage depot capacity (only applies after restarting).",
    "ToggleTerrainHeight.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Capacity/Storage Other Depot",
    function()
      ChoGGi.SetStorageDepotSize("StorageOtherDepot")
    end,
    nil,
    "Change other storage depot capacity (only applies after restarting).",
    "ToggleTerrainHeight.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Capacity/Storage Waste Depot",
    function()
      ChoGGi.SetStorageDepotSize("StorageWasteDepot")
    end,
    nil,
    "Change waste storage depot capacity (only applies after restarting).",
    "ToggleTerrainHeight.tga"
  )

---------all the fixes

  ChoGGi.AddAction(
    "Expanded CM/Fixes/Fix Black Cube Colonists",
    ChoGGi.ColonistsFixBlackCube,
    nil,
    "If any colonists are black cubes click this.",
    "ReportBug.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Fixes/Attach Buildings To Nearest Working Dome",
    ChoGGi.AttachBuildingsToNearestWorkingDome,
    nil,
    "If you placed inside buildings outside and removed the dome they're attached to; use this.",
    "ReportBug.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Fixes/Cables & Pipes: Instant Repair",
    ChoGGi.CablesAndPipesRepair,
    nil,
    "Instantly repair all broken pipes and cables.",
    "DisableAOMaps.tga"
  )

  --[[
  not working

  ChoGGi.AddAction(
    "Expanded CM/Radius/[0]These don't really work for now...",
    function()
      return
    end,
    nil,
    "keeps resetting...",
    "ToggleEnvMap.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Radius/RC Rover Radius + 25",
    function()
      ChoGGi.RCRoverRadius(true)
    end,
    nil,
    "Increase drone radius of each Rover.",
    "DisableRMMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Radius/RC Rover Radius Default",
    ChoGGi.RCRoverRadius,
    nil,
    "Default drone radius to each Rover.",
    "DisableRMMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Radius/Command Center Radius + 25",
    function()
      ChoGGi.CommandCenterRadius(true)
    end,
    nil,
    "Increase Drone radius of drone hubs.",
    "DisableRMMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Radius/Command Center Radius Default",
    ChoGGi.CommandCenterRadius,
    nil,
    "Default Drone radius of drone hubs.",
    "DisableRMMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Radius/Triboelectric Scrubber Radius + 25",
    function()
      ChoGGi.TriboelectricScrubberRadius(true)
    end,
    nil,
    "Increase radius of Triboelectric Scrubber.",
    "DisableRMMaps.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Radius/Triboelectric Scrubber Radius Default",
    "Default radius of Triboelectric Scrubber.",,
    nil,
    ChoGGi.TriboelectricScrubberRadius
    "DisableRMMaps.tga"
  )
  --]]
end
