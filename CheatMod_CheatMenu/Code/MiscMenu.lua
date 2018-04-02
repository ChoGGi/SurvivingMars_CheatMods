--ChoGGi.AddAction(Menu,Action,Key,Des,Icon)
-------------
ChoGGi.AddAction(
  "Gameplay/Shuttles/ShuttleHub Shuttles + 25",
  function()
    ChoGGi.ShuttleHubCapacitySet(true)
  end,
  "Ctrl-Shift-S",
  "Set capacity of buildings of selected type + 25 (as well as newly placed ones)",
  "groups.tga"
)

ChoGGi.AddAction(
  "Gameplay/Shuttles/ShuttleHub Shuttles (Default)",
  ChoGGi.ShuttleHubCapacitySet,
  nil,
  function()
    local name
    if SelectedObj then
      name = SelectedObj.encyclopedia_id
    else
      name = "buildings of selected type"
    end
    return "Set capacity of all " .. name .. " to default value."
  end,
  "groups.tga"
)
-------------
ChoGGi.AddAction(
  "Gameplay/Shuttles/Shuttle Cargo + 256",
  function()
    ChoGGi.ShuttleCapacitySet(true)
  end,
  nil,
  "Increase capacity of shuttles (restart to set newly built ones).",
  "AlignSel.tga"
)

ChoGGi.AddAction(
  "Gameplay/Shuttles/Shuttle Cargo (Default)",
  ChoGGi.ShuttleCapacitySet,
  nil,
  "Default capacity.",
  "AlignSel.tga"
)
-------------
ChoGGi.AddAction(
  "Gameplay/Shuttles/Shuttle Speed + 5000",
  function()
    ChoGGi.ShuttleSpeedSet(true)
  end,
  nil,
  "Increase speed of shuttles (restart to set newly built ones).",
  "AlignSel.tga"
)

ChoGGi.AddAction(
  "Gameplay/Shuttles/Shuttle Speed (Default)",
  ChoGGi.ShuttleSpeedSet,
  nil,
  "Default speed.",
  "AlignSel.tga"
)
-------------
ChoGGi.AddAction(
  "Gameplay/QoL/Camera/Toggle Free Camera",
  ChoGGi.CameraFree_Toggle,
  "Shift-C",
  "I believe I can fly."
)

ChoGGi.AddAction(
  "Gameplay/QoL/Camera/Toggle Follow Camera",
  ChoGGi.CameraFollow_Toggle,
  "Ctrl-Shift-F",
  "Select an object to follow."
)

ChoGGi.AddAction(
  "Gameplay/QoL/Camera/Toggle Camera Cursor",
  ChoGGi.CameraCursor_Toggle,
  "Ctrl-Alt-F",
  "Toggles showing cursor."
)

ChoGGi.AddAction(
  "Gameplay/QoL/Camera/Border Scrolling",
  ChoGGi.BorderScrolling_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.BorderScrollingToggle and "(Enabled)" or "(Disabled)"
    return des .. " Disable scrolling when mouse is near borders."
  end,
  "CameraToggle.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/Camera/Zoom Distance",
  ChoGGi.CameraZoom_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.CameraZoomToggle and "(Enabled)" or "(Disabled)"
    return des .. " Further zoom distance."
  end,
  "MoveUpCamera.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/[-1]Infopanel Cheats",
  ChoGGi.InfopanelCheats_Toggle,
  nil,
  function()
    local des = config.BuildingInfopanelCheats and "(Enabled)" or "(Disabled)"
    return des .. " the cheats in the infopanels"
  end,
  "toggle_dtm_slots.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/Pipes Pillars Spacing Toggle",
  ChoGGi.PipesPillarsSpacing_Toggle,
  nil,
  function()
    local des
    if Consts.PipesPillarSpacing == 1000 then
      des = "(Enabled)"
    else
      des = "(Disabled)"
    end
    return des .. " Only place Pillars at start and end."
  end,
  "ViewCamPath.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/Show All Traits Toggle",
  ChoGGi.ShowAllTraits_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.ShowAllTraits and "(Enabled)" or "(Disabled)"
    return des .. " Shows all appropriate traits in Sanatoriums/Schools."
  end,
  "LightArea.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/Research Queue Larger Toggle",
  ChoGGi.ResearchQueueLarger_Toggle,
  nil,
  function()
    local des
    if const.ResearchQueueSize == 25 then
      des = "(Enabled)"
    else
      des = "(Disabled)"
    end
    return des .. " Enable up to 25 items in queue."
  end,
  "ViewArea.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/Scanner Queue Larger Toggle",
  ChoGGi.ScannerQueueLarger_Toggle,
  nil,
  function()
    local des
    if const.ExplorationQueueMaxSize == 100 then
      des = "(Enabled)"
    else
      des = "(Disabled)"
    end
    return des .. " Queue up to 100 squares (default " .. ChoGGi.Consts.ExplorationQueueMaxSize .. ")."
  end,
  "ViewArea.tga"
)

ChoGGi.AddAction(
  "Gameplay/Meteors/Damage Toggle",
  ChoGGi.MeteorHealthDamage_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.MeteorHealthDamage,"(Disabled)","(Enabled)")
    return des .. " Disable Meteor damage (colonists?)."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Rocket/Cargo Capacity Toggle",
  ChoGGi.RocketCargoCapacity_Toggle,
  nil,
  function()
    local des
    if Consts.CargoCapacity == 1000000000 then
      des = "(Enabled)"
    else
      des = "(Disabled)"
    end
    return des .. " 1,000,000,000 space."
  end,
  "EnrichTerrainEditor.tga"
)

ChoGGi.AddAction(
  "Gameplay/Rocket/Travel Instant Toggle",
  ChoGGi.RocketTravelInstant_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.TravelTimeEarthMars,"(Disabled)","(Enabled)")
    return des .. " Instant travel between Earth and Mars."
  end,
  "place_particles.tga"
)

ChoGGi.AddAction(
  "Gameplay/Speed/[1]Game Speed Default",
  function()
    ChoGGi.SetGameSpeed(1)
  end,
  nil,
  "Default game speed.",
  "SelectionToTemplates.tga"
)

ChoGGi.AddAction(
  "Gameplay/Speed/[2]Game Speed Double",
  function()
    ChoGGi.SetGameSpeed(2)
  end,
  nil,
  "Doubles (2) the speed of the game (at medium/fast).",
  "SelectionToTemplates.tga"
)

ChoGGi.AddAction(
  "Gameplay/Speed/[3]Game Speed Triple",
  function()
    ChoGGi.SetGameSpeed(3)
  end,
  nil,
  "Triples (3) the speed of the game (at medium/fast).",
  "SelectionToTemplates.tga"
)

ChoGGi.AddAction(
  "Gameplay/Speed/[4]Game Speed Quad",
  function()
    ChoGGi.SetGameSpeed(4)
  end,
  nil,
  "Quadruples (4) the speed of the game (at medium/fast).",
  "SelectionToTemplates.tga"
)

ChoGGi.AddAction(
  "Gameplay/Speed/[5]Game Speed Octuple",
  function()
    ChoGGi.SetGameSpeed(5)
  end,
  nil,
  "Octuples (8) the speed of the game (at medium/fast).",
  "SelectionToTemplates.tga"
)

ChoGGi.AddAction(
  "Gameplay/Speed/[6]Game Speed Sexdecuple",
  function()
    ChoGGi.SetGameSpeed(6)
  end,
  nil,
  "Sexdecuples (16) the speed of the game (at medium/fast).",
  "SelectionToTemplates.tga"
)

ChoGGi.AddAction(
  "Gameplay/Speed/[7]Game Speed Duotriguple",
  function()
    ChoGGi.SetGameSpeed(7)
  end,
  nil,
  "Duotriguples (32) the speed of the game (at medium/fast).",
  "SelectionToTemplates.tga"
)

ChoGGi.AddAction(
  "Gameplay/Speed/[8]Game Speed Quattuorsexaguple",
  function()
    ChoGGi.SetGameSpeed(8)
  end,
  nil,
  "Quattuorsexaguples (64) the speed of the game (at medium/fast).",
  "SelectionToTemplates.tga"
)

ChoGGi.AddAction(
  "Gameplay/Rocket/Colonists Per Rocket + 25",
  function()
    ChoGGi.ColonistsPerRocket(true)
  end,
  "Ctrl-Shift-O",
  function()
    return Consts.MaxColonistsPerRocket + 25 .. " colonists can arrive on Mars in a single Rocket."
  end,
  "ToggleMarkers.tga"
)

ChoGGi.AddAction(
  "Gameplay/Rocket/Colonists Per Rocket Default",
  ChoGGi.ColonistsPerRocket,
  nil,
  function()
    return ChoGGi.Consts.MaxColonistsPerRocket .. " colonists can arrive on Mars in a single Rocket."
  end,
  "ToggleMarkers.tga"
)

--[[
not working

ChoGGi.AddAction(
  "Gameplay/Radius/[0]These don't really work for now...",
  function()
    return
  end,
  nil,
  "keeps resetting...",
  "ReportBug.tga"
)

ChoGGi.AddAction(
  "Gameplay/Radius/RC Rover Radius + 25",
  function()
    ChoGGi.RCRoverRadius(true)
  end,
  nil,
  "Increase drone radius of each Rover.",
  "DisableRMMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Radius/RC Rover Radius Default",
  ChoGGi.RCRoverRadius,
  nil,
  "Default drone radius to each Rover.",
  "DisableRMMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Radius/Command Center Radius + 25",
  function()
    ChoGGi.CommandCenterRadius(true)
  end,
  nil,
  "Increase Drone radius of drone hubs.",
  "DisableRMMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Radius/Command Center Radius Default",
  ChoGGi.CommandCenterRadius,
  nil,
  "Default Drone radius of drone hubs.",
  "DisableRMMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Radius/Triboelectric Scrubber Radius + 25",
  function()
    ChoGGi.TriboelectricScrubberRadius(true)
  end,
  nil,
  "Increase radius of Triboelectric Scrubber.",
  "DisableRMMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Radius/Triboelectric Scrubber Radius Default",
  "Default radius of Triboelectric Scrubber.",,
  nil,
  ChoGGi.TriboelectricScrubberRadius
  "DisableRMMaps.tga"
)
--]]

if ChoGGi.ChoGGiTest then
  table.insert(ChoGGi.FilesCount,"MiscMenu")
end
