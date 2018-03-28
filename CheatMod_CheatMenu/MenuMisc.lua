UserActions.AddActions({

  ChoGGi_BorderScrollingToggle = {
    icon = "CameraToggle.tga",
    menu = "Gameplay/QoL/Camera/Border Scrolling",
    description = function()
      local action = ChoGGi.CheatMenuSettings.BorderScrollingToggle and "(Enabled)" or "(Disabled)"
      return action .. " scrolling when mouse is near borders."
    end,
    action = ChoGGi.BorderScrollingToggle
  },

  ChoGGi_CameraZoomToggle = {
    icon = "MoveUpCamera.tga",
    menu = "Gameplay/QoL/Camera/Camera Zoom Distance",
    description = function()
      local action = ChoGGi.CheatMenuSettings.CameraZoomToggle and "(Enabled)" or "(Disabled)"
      return action .. " further zoom out/in (best to lower your scroll speed in options)."
    end,
    action = ChoGGi.CameraZoomToggle
  },

  ChoGGi_CameraZoomToggleSpeed = {
    icon = "AreaToggleOverviewCamera.tga",
    menu = "Gameplay/QoL/Camera/Camera Zoom Speed",
    description = function()
      local action = ChoGGi.CheatMenuSettings.CameraZoomToggleSpeed and "(Enabled)" or "(Disabled)"
      return action .. " faster zooming."
    end,
    action = ChoGGi.CameraZoomToggleSpeed
  },

  ChoGGi_SpacingPipesPillarsToggle = {
    icon = "ViewCamPath.tga",
    menu = "Gameplay/QoL/Spacing Pipes Pillars Toggle",
    description = function()
      local action
      if Consts.PipesPillarSpacing == 1000 then
        action = "(Enabled)"
      else
        action = "(Disabled)"
      end
      return action .. " Only place Pillars at start and end."
    end,
    action = ChoGGi.SpacingPipesPillarsToggle
  },

  ChoGGi_ShowAllTraitsToggle = {
    icon = "LightArea.tga",
    menu = "Gameplay/QoL/Show All Traits Toggle",
    description = function()
      local action = ChoGGi.CheatMenuSettings.ShowAllTraits and "(Disabled)" or "(Enabled)"
      return action .. " Shows all appropriate traits in Sanatoriums/Schools."
    end,
    action = ChoGGi.ShowAllTraitsToggle
  },

  ChoGGi_ResearchQueueLargerToggle = {
    icon = "ViewArea.tga",
    menu = "Gameplay/QoL/Research Queue Larger Toggle",
    description = function()
      local action
      if const.ResearchQueueSize == 25 then
        action = "(Enabled)"
      else
        action = "(Disabled)"
      end
      return action .. " up to 25 items in queue."
    end,
    action = ChoGGi.ResearchQueueLargerToggle
  },

  ChoGGi_OutsourcingFreeToggle = {
    icon = "ViewArea.tga",
    menu = "Gameplay/Research/Outsourcing Free Toggle",
    description = function()
      local action = ChoGGi.NumRetBool(Consts.OutsourceResearchCost,"(Disabled)","(Enabled)")
      return action .. " Outsourcing is free to purchase (over n over)."
    end,
    action = ChoGGi.OutsourcingFreeToggle
  },

  ChoGGi_ScannerQueueLargerToggle = {
    icon = "ViewArea.tga",
    menu = "Gameplay/QoL/Scanner Queue Larger Toggle",
    description = function()
      local action
      if Consts.ExplorationQueueMaxSize == 100 then
        action = "(Enabled)"
      else
        action = "(Disabled)"
      end
      return action .. " Queue up to 100 squares (default 5)."
    end,
    action = ChoGGi.ScannerQueueLargerToggle
  },

  ChoGGi_MeteorHealthDamageToggle = {
    icon = "remove_water.tga",
    menu = "Gameplay/Meteors/Damage Toggle",
    description = function()
      local action = ChoGGi.NumRetBool(Consts.MeteorHealthDamage,"(Disabled)","(Enabled)")
      return action .. " Meteor damage (colonists and maybe buildings)."
    end,
    action = ChoGGi.MeteorHealthDamageToggle
  },

  ChoGGi_RocketCargoCapacityToggle = {
    icon = "EnrichTerrainEditor.tga",
    menu = "Gameplay/Rocket/Cargo Capacity Toggle",
    description = function()
      local action
      if Consts.CargoCapacity == 1000000000 then
        action = "(Enabled)"
      else
        action = "(Disabled)"
      end
      return action .. " 1,000,000,000 space."
    end,
    action = ChoGGi.RocketCargoCapacityToggle
  },

  ChoGGi_RocketTravelInstantToggle = {
    icon = "place_particles.tga",
    menu = "Gameplay/Rocket/Travel Instant Toggle",
    description = function()
      local action = ChoGGi.NumRetBool(Consts.TravelTimeEarthMars,"(Disabled)","(Enabled)")
      return action .. " Instant travel between Earth and Mars."
    end,
    action = ChoGGi.RocketTravelInstantToggle
  },

  ChoGGi_OutsourcePoints1000000 = {
    icon = "ViewArea.tga",
    menu = "Gameplay/Research/Outsource Points +1,000,000",
    description = "Gives a crapload of research points (almost instant research)",
    action = ChoGGi.OutsourcePoints1000000
  },

  ChoGGi_GameSpeedDefault = {
    icon = "SelectionToTemplates.tga",
    menu = "Gameplay/Speed/[1]Game Speed Default",
    description = "Default game speed.",
    action = function()
      ChoGGi.SetGameSpeed(1)
    end
  },

  ChoGGi_GameSpeedDouble = {
    icon = "SelectionToTemplates.tga",
    menu = "Gameplay/Speed/[2]Game Speed Double",
    description = "Doubles the speed of the game (at medium/fast).",
    action = function()
      ChoGGi.SetGameSpeed(2)
    end
  },

  ChoGGi_GameSpeedTriple = {
    icon = "SelectionToTemplates.tga",
    menu = "Gameplay/Speed/[3]Game Speed Triple",
    description = "Triples the speed of the game (at medium/fast).",
    action = function()
      ChoGGi.SetGameSpeed(3)
    end
  },

  ChoGGi_GameSpeedQuad = {
    icon = "SelectionToTemplates.tga",
    menu = "Gameplay/Speed/[4]Game Speed Quad",
    description = "Quadruples the speed of the game (at medium/fast).",
    action = function()
      ChoGGi.SetGameSpeed(4)
    end
  },

  ChoGGi_ColonistsPerRocketIncrease = {
    icon = "ToggleMarkers.tga",
    menu = "Gameplay/Rocket/Colonists Per Rocket + 25",
    description = function()
      return Consts.MaxColonistsPerRocket .. " + 25 colonists can arrive on Mars in a single Rocket."
    end,
    action = function()
      ChoGGi.ColonistsPerRocket(true)
    end
  },

  ChoGGi_ColonistsPerRocketDefault = {
    icon = "ToggleMarkers.tga",
    menu = "Gameplay/Rocket/Colonists Per Rocket Default",
    description = function()
      return ChoGGi.Consts.MaxColonistsPerRocket .. " colonists can arrive on Mars in a single Rocket."
    end,
    action = ChoGGi.ColonistsPerRocket
  },

  ChoGGi_HintRadius = {
    icon = "ReportBug.tga",
    menu = "Gameplay/Radius/[0]These don't really work for now",
    description = "keeps resetting...",
    action = function()
      return
    end
  },

  ChoGGi_RCRoverRadiusIncrease = {
    icon = "DisableRMMaps.tga",
    menu = "Gameplay/Radius/RC Rover Radius + 25",
    description = "Increase drone radius of each Rover.",
    action = function()
      ChoGGi.RCRoverRadius(true)
    end
  },

  ChoGGi_RCRoverRadiusDefault = {
    icon = "DisableRMMaps.tga",
    menu = "Gameplay/Radius/RC Rover Radius Default",
    description = "Default drone radius to each Rover.",
    action = ChoGGi.RCRoverRadius
  },

--not working
  ChoGGi_CommandCenterRadiusIncrease = {
    icon = "DisableRMMaps.tga",
    menu = "Gameplay/Radius/Command Center Radius + 25",
    description = "Increase Drone radius of drone hubs.",
    action = function()
      ChoGGi.CommandCenterRadius(true)
    end
  },

  ChoGGi_CommandCenterRadiusDefault = {
    icon = "DisableRMMaps.tga",
    menu = "Gameplay/Radius/Command Center Radius Default",
    description = "Default Drone radius of drone hubs.",
    action = ChoGGi.CommandCenterRadius
  },

  ChoGGi_TriboelectricScrubberRadiusIncrease = {
    icon = "DisableRMMaps.tga",
    menu = "Gameplay/Radius/Triboelectric Scrubber Radius + 25",
    description = "Increase radius of Triboelectric Scrubber.",
    action = function()
      ChoGGi.TriboelectricScrubberRadius(true)
    end
  },

  ChoGGi_TriboelectricScrubberRadiusDefault = {
    icon = "DisableRMMaps.tga",
    menu = "Gameplay/Radius/Triboelectric Scrubber Radius Default",
    description = "Default radius of Triboelectric Scrubber.",
    action = ChoGGi.TriboelectricScrubberRadius
  },

})

if ChoGGi.ChoGGiTest then
  AddConsoleLog("ChoGGi: MenuMisc.lua",true)
end
