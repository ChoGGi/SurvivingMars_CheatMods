UserActions.AddActions({

  ChoGGi_ResearchQueueLargerToggle = {
    icon = "ViewArea.tga",
    menu = "Gameplay/Research/Research Queue Larger Toggle",
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
      local action = Consts.OutsourceResearchCost and "(Disabled)" or "(Enabled)"
      return action .. " Outsourcing is free to purchase (over n over)."
    end,
    action = ChoGGi.OutsourcingFreeToggle
  },

  ChoGGi_DeepScanToggle = {
    icon = "change_height_down.tga",
    menu = "Gameplay/Scan/Deep Scan Toggle",
    description = function()
      local action = Consts.DeepScanAvailable and "(Disabled)" or "(Enabled)"
      return action .. " deep scan and deep resources exploitable. Also deep scanning probes.."
    end,
    action = ChoGGi.DeepScanToggle
  },

  ChoGGi_ScannerQueueLargerToggle = {
    icon = "ViewArea.tga",
    menu = "Gameplay/Scan/Scanner Queue Larger Toggle",
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
    menu = "Gameplay/Meteors/Damage Toggle",
    description = function()
      local action = Consts.MeteorHealthDamage and "(Disabled)" or "(Enabled)"
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
      local action = Consts.TravelTimeEarthMars and "(Disabled)" or "(Enabled)"
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
    icon = "DarkSideOfTheMoon.tga",
    menu = "Gameplay/Speed/[1]Game Speed Default",
    description = "Default game speed.",
    action = function()
      ChoGGi.SetGameSpeed(1)
    end
  },

  ChoGGi_GameSpeedDouble = {
    icon = "DarkSideOfTheMoon.tga",
    menu = "Gameplay/Speed/[2]Game Speed Double",
    description = "Doubles the speed of the game (at medium/fast).",
    action = function()
      ChoGGi.SetGameSpeed(2)
    end
  },

  ChoGGi_GameSpeedTriple = {
    icon = "DarkSideOfTheMoon.tga",
    menu = "Gameplay/Speed/[3]Game Speed Triple",
    description = "Triples the speed of the game (at medium/fast).",
    action = function()
      ChoGGi.SetGameSpeed(3)
    end
  },

  ChoGGi_GameSpeedQuad = {
    icon = "DarkSideOfTheMoon.tga",
    menu = "Gameplay/Speed/[4]Game Speed Quad",
    description = "Quadruples the speed of the game (at medium/fast).",
    action = function()
      ChoGGi.SetGameSpeed(4)
    end
  },

  ChoGGi_DeeperScanEnable = {
    icon = "change_height_down.tga",
    menu = "Gameplay/Scan/Deeper Scan Enable",
    description = "Uncovers extremely rich underground deposits.",
    action = ChoGGi.DeeperScanEnable
  },

  ChoGGi_ColonistsPerRocketIncrease = {
    menu = "Gameplay/Rocket/Colonists Per Rocket + 25",
    description = function()
      return Consts.MaxColonistsPerRocket .. " + 25 colonists can arrive on Mars in a single Rocket."
    end,
    action = function()
      ChoGGi.ColonistsPerRocket(true)
    end
  },

  ChoGGi_ColonistsPerRocketDefault = {
    menu = "Gameplay/Rocket/Colonists Per Rocket Default",
    description = function()
      return ChoGGi.Consts.MaxColonistsPerRocket .. " colonists can arrive on Mars in a single Rocket."
    end,
    action = function()
      ChoGGi.ColonistsPerRocket()
    end
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
    action = function()
      ChoGGi.RCRoverRadius()
    end
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
    action = function()
      ChoGGi.CommandCenterRadius()
    end
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
    action = function()
      ChoGGi.TriboelectricScrubberRadius()
    end
  },

})

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: MenuGameplayMisc.lua",true)
end
