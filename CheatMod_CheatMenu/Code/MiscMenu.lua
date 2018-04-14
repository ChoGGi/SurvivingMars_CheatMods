--ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

-------------
ChoGGi.BuildDisasterMenu(
  {"VeryLow","Low","High","VeryHigh","VeryHigh_1","VeryHigh_2","VeryHigh_3"},
  "MapSettings_DustDevils",
  "DustDevils"
)
ChoGGi.BuildDisasterMenu(
  {"VeryLow","Low","High","VeryHigh","VeryHigh_1"},
  "MapSettings_ColdWave",
  "ColdWave"
)
ChoGGi.BuildDisasterMenu(
  {"VeryLow","Low","High","VeryHigh","VeryHigh_1","VeryHigh_2"},
  "MapSettings_DustStorm",
  "DustStorm"
)
ChoGGi.BuildDisasterMenu(
  {"VeryLow","Low","High","VeryHigh"},
  "MapSettings_Meteor",
  "Meteor"
)

ChoGGi.AddAction(
  "Gameplay/Disasters/Meteor Damage",
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
  "Gameplay/Shuttles/Shuttle Cargo + 250",
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
  "Gameplay/QoL/[3]Shadow Map/[0](default)",
  function()
    ChoGGi.SetShadowmapSize(false)
  end,
  nil,
  function()
    local des = "Current: " .. tostring(ChoGGi.CheatMenuSettings.ShadowmapSize)
    return des .. "\nUses setting from Menu>Options>Video>Shadows (restart to enable)."
  end,
  "DisableEyeSpec.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/[3]Shadow Map/[1]Crap (256)",
  function()
    ChoGGi.SetShadowmapSize(256)
  end,
  nil,
  function()
    local des = "Current: " .. tostring(ChoGGi.CheatMenuSettings.ShadowmapSize)
    return des .. "\nSets the shadow map size (Menu>Options>Video>Shadows)."
  end,
  "DisableEyeSpec.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/[3]Shadow Map/[2]Lower (512)",
  function()
    ChoGGi.SetShadowmapSize(512)
  end,
  nil,
  function()
    local des = "Current: " .. tostring(ChoGGi.CheatMenuSettings.ShadowmapSize)
    return des .. "\nSets the shadow map size (Menu>Options>Video>Shadows)."
  end,
  "DisableEyeSpec.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/[3]Shadow Map/[3]Low (1536)",
  function()
    ChoGGi.SetShadowmapSize(1536)
  end,
  nil,
  function()
    local des = "Current: " .. tostring(ChoGGi.CheatMenuSettings.ShadowmapSize)
    return des .. "\nSets the shadow map size (Menu>Options>Video>Shadows)."
  end,
  "DisableEyeSpec.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/[3]Shadow Map/[3]Medium (2048)",
  function()
    ChoGGi.SetShadowmapSize(2048)
  end,
  nil,
  function()
    local des = "Current: " .. tostring(ChoGGi.CheatMenuSettings.ShadowmapSize)
    return des .. "\nSets the shadow map size (Menu>Options>Video>Shadows)."
  end,
  "DisableEyeSpec.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/[3]Shadow Map/[4]High (4096)",
  function()
    ChoGGi.SetShadowmapSize(4096)
  end,
  nil,
  function()
    local des = "Current: " .. tostring(ChoGGi.CheatMenuSettings.ShadowmapSize)
    return des .. "\nSets the shadow map size (Menu>Options>Video>Shadows)."
  end,
  "DisableEyeSpec.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/[3]Shadow Map/[5]Higher (8192)",
  function()
    ChoGGi.SetShadowmapSize(8192)
  end,
  nil,
  function()
    local des = "Current: " .. tostring(ChoGGi.CheatMenuSettings.ShadowmapSize)
    return des .. "\nSets the shadow map size (Menu>Options>Video>Shadows)."
  end,
  "DisableEyeSpec.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/[3]Shadow Map/[6]Highest (16384)",
  function()
    ChoGGi.SetShadowmapSize(16384)
  end,
  nil,
  function()
    local des = "Current: " .. tostring(ChoGGi.CheatMenuSettings.ShadowmapSize)
    return des .. "\nSets the shadow map size (Menu>Options>Video>Shadows).\nWarning: Uses a couple gigs of vram."
  end,
  "DisableEyeSpec.tga"
)
--------------------
ChoGGi.AddAction(
  "Gameplay/QoL/[2]Render/Disable Texture Compression",
  ChoGGi.DisableTextureCompression_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.DisableTextureCompression and "(Enabled)" or "(Disabled)"
    return des .. " Toggle texture compression (game defaults to on, seems to make a difference of 600MB vram)."
  end,
  "ExportImageSequence.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/[2]Render/Higher Render Distance",
  ChoGGi.HigherRenderDist_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.HigherRenderDist and "(Enabled)" or "(Disabled)"
    return des .. " Renders model from further away.\nNot noticeable unless using higher zoom."
  end,
  "CameraEditor.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/[2]Render/Higher Shadow Distance",
  ChoGGi.HigherShadowDist_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.HigherShadowDist and "(Enabled)" or "(Disabled)"
    return des .. " Renders shadows from further away.\nNot noticeable unless using higher zoom."
  end,
  "toggle_post.tga"
)


ChoGGi.AddAction(
  "Gameplay/QoL/[1]Camera/Toggle Free Camera",
  ChoGGi.CameraFree_Toggle,
  "Shift-C",
  "I believe I can fly.",
  "CameraToggle.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/[1]Camera/Toggle Follow Camera",
  ChoGGi.CameraFollow_Toggle,
  "Ctrl-Shift-F",
  "Select (or mouse over) an object to follow.",
  "CameraToggle.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/[1]Camera/Toggle Cursor",
  ChoGGi.CursorVisible_Toggle,
  "Ctrl-Alt-F",
  "Toggle between moving camera and selecting objects.",
  "CameraToggle.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/[1]Camera/Border Scrolling",
  ChoGGi.BorderScrolling_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.BorderScrollingToggle and "(Enabled)" or "(Disabled)"
    return des .. " Disable scrolling when mouse is near borders."
  end,
  "CameraToggle.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/[1]Camera/Border Scrolling Area",
  ChoGGi.BorderScrollingArea_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.BorderScrollingArea and "(Enabled)" or "(Disabled)"
    return des .. " Minimize activation area for mouse scrolling, so menus are less annoying to use."
  end,
  "CameraToggle.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/[1]Camera/Zoom Distance",
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
    return des .. " Show the cheat pane in the info panel."
  end,
  "toggle_dtm_slots.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/[-1]Infopanel Cheats Cleanup",
  ChoGGi.InfopanelCheatsCleanup_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.CleanupCheatsInfoPane and "(Enabled)" or "(Disabled)"
    return des .. " Remove some entries from the cheat pane (restart to re-enable).\n\nAddMaintenancePnts,MakeSphereTarget,Malfunction,SpawnWorker,SpawnVisitor"
  end,
  "toggle_dtm_slots.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/Pipes Pillars Spacing",
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
  "Gameplay/QoL/Show All Traits",
  ChoGGi.ShowAllTraits_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.ShowAllTraits and "(Enabled)" or "(Disabled)"
    return des .. " Shows all appropriate traits in Sanatoriums/Schools."
  end,
  "LightArea.tga"
)

ChoGGi.AddAction(
  "Gameplay/QoL/Research Queue Larger",
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
  "Gameplay/QoL/Scanner Queue Larger",
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
  "Gameplay/Rocket/Cargo Capacity",
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
  "Gameplay/Rocket/Instant Travel",
  ChoGGi.RocketInstantTravel_Toggle,
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
  "+ 25 colonists can arrive on Mars in a single Rocket.",
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
  "ToggleEnvMap.tga"
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
