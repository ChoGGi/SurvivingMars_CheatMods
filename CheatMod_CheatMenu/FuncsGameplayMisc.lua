function ChoGGi.ResearchQueueLargerToggle()
  if const.ResearchQueueSize == 25 then
    const.ResearchQueueSize = ChoGGi.Consts["ResearchQueueSize"]
  else
    const.ResearchQueueSize = 25
  end
  ChoGGi.CheatMenuSettings["ResearchQueueSize"] = const.ResearchQueueSize
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Nerdgasm",
   "Research","UI/Icons/Notifications/research.tga"
  )
end

function ChoGGi.OutsourcingFreeToggle()
  if Consts.OutsourceResearchCost == 0 then
    Consts.OutsourceResearchCost = ChoGGi.Consts["OutsourceResearchCost"]
  else
    Consts.OutsourceResearchCost = 0
  end
  ChoGGi.CheatMenuSettings["OutsourceResearchCost"] = Consts.OutsourceResearchCost
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Best hope you picked India as your Mars sponsor",
   "Research","UI/Icons/Sections/research_1.tga"
  )
end

function ChoGGi.DeepScanToggle()
  if Consts.DeepScanAvailable == 1 then
    Consts.DeepScanAvailable = ChoGGi.Consts["DeepScanAvailable"]
    Consts.IsDeepWaterExploitable = ChoGGi.Consts["IsDeepWaterExploitable"]
    Consts.IsDeepMetalsExploitable = ChoGGi.Consts["IsDeepMetalsExploitable"]
    Consts.IsDeepPreciousMetalsExploitable = ChoGGi.Consts["IsDeepPreciousMetalsExploitable"]
  else
    Consts.DeepScanAvailable = 1
    Consts.IsDeepWaterExploitable = 1
    Consts.IsDeepMetalsExploitable = 1
    Consts.IsDeepPreciousMetalsExploitable = 1
  end
  --GrantTech("AdaptedProbes")
  --GrantTech("DeepScanning")
  --GrantTech("DeepWaterExtraction")
  --GrantTech("DeepMetalExtraction")
  ChoGGi.CheatMenuSettings["DeepScanAvailable"] = Consts.DeepScanAvailable
  ChoGGi.CheatMenuSettings["IsDeepWaterExploitable"] = Consts.IsDeepWaterExploitable
  ChoGGi.CheatMenuSettings["IsDeepMetalsExploitable"] = Consts.IsDeepMetalsExploitable
  ChoGGi.CheatMenuSettings["IsDeepPreciousMetalsExploitable"] = Consts.IsDeepPreciousMetalsExploitable
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Alice thought to herself... Alice thought to herself 'Now you will see a film... made for children... perhaps... ' But, I nearly forgot... you must... close your eyes... otherwise... you won't see anything.",
   "Scanner","UI/Icons/Notifications/scan.tga"
  )
end

function ChoGGi.ScannerQueueLargerToggle()
  if const.ExplorationQueueMaxSize == 100 then
    const.ExplorationQueueMaxSize = ChoGGi.Consts["ExplorationQueueMaxSize"]
  else
    const.ExplorationQueueMaxSize = 100
  end
  ChoGGi.CheatMenuSettings["ExplorationQueueMaxSize"] = const.ExplorationQueueMaxSize
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("5 scans at a time...bulldiddy",
   "Scanner","UI/Icons/Notifications/scan.tga"
  )
end

function ChoGGi.MeteorHealthDamageToggle()
  if Consts.MeteorHealthDamage == 0 then
    Consts.MeteorHealthDamage = ChoGGi.Consts["MeteorHealthDamage"]
  else
    Consts.MeteorHealthDamage = 0
  end
  ChoGGi.CheatMenuSettings["MeteorHealthDamage"] = Consts.MeteorHealthDamage
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Damage? Total, sir. It's what we call a global killer. The end of mankind. Doesn't matter where it hits. Nothing would survive, not even bacteria.",
   "Colonists","UI/Icons/Notifications/meteor_storm.tga"
  )
end

function ChoGGi.RocketCargoCapacityToggle()
  if Consts.CargoCapacity == 1000000000 then
    Consts.CargoCapacity = ChoGGi.CargoCapacity()
  else
    Consts.CargoCapacity = 1000000000
  end
  ChoGGi.CheatMenuSettings["CargoCapacity"] = Consts.CargoCapacity
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("I can still see some space",
   "Rocket","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.RocketTravelInstantToggle()
  if Consts.TravelTimeEarthMars == 0 then
    Consts.TravelTimeEarthMars = ChoGGi.TravelTimeEarthMars()
    Consts.TravelTimeMarsEarth = ChoGGi.TravelTimeMarsEarth()
  else
    Consts.TravelTimeEarthMars = 0
    Consts.TravelTimeMarsEarth = 0
  end
  ChoGGi.CheatMenuSettings["TravelTimeEarthMars"] = Consts.TravelTimeEarthMars
  ChoGGi.CheatMenuSettings["TravelTimeMarsEarth"] = Consts.TravelTimeMarsEarth
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("88 MPH",
   "Rocket","UI/Upgrades/autoregulator_04/timer.tga"
  )
end

function ChoGGi.OutsourcePoints1000000()
  Consts.OutsourceResearch = 9999900
  ChoGGi.CheatMenuSettings["OutsourceResearch"] = Consts.OutsourceResearch
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("The same thing we do every night, Pinky - try to take over the world!",
   "Research","UI/Icons/Upgrades/eternal_fusion_04.tga"
  )
end

function ChoGGi.SetGameSpeed(Speed)
  if Speed == 1 then
    const.mediumGameSpeed = ChoGGi.Consts["mediumGameSpeed"]
    const.fastGameSpeed = ChoGGi.Consts["fastGameSpeed"]
  elseif Speed == 2 then
    const.mediumGameSpeed = 6
    const.fastGameSpeed = 10
  elseif Speed == 3 then
    const.mediumGameSpeed = 9
    const.fastGameSpeed = 15
  elseif Speed == 4 then
    const.mediumGameSpeed = 12
    const.fastGameSpeed = 20
  end
  ChoGGi.CheatMenuSettings["mediumGameSpeed"] = const.mediumGameSpeed
  ChoGGi.CheatMenuSettings["fastGameSpeed"] = const.fastGameSpeed
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("I think I can",
   "Speed","UI/Icons/Notifications/timer.tga"
  )
end

function ChoGGi.DeeperScanEnable()
  GrantTech("CoreMetals")
  GrantTech("CoreWater")
  GrantTech("CoreRareMetals")
  ChoGGi.MsgPopup("Further down the rabbit hole",
   "Scanner","UI/Icons/Notifications/scan.tga"
  )
end

function ChoGGi.ColonistsPerRocket(Bool)
  if Bool then
    Consts.MaxColonistsPerRocket = Consts.MaxColonistsPerRocket + 25
  else
    Consts.MaxColonistsPerRocket = ChoGGi.MaxColonistsPerRocket()
  end
  ChoGGi.CheatMenuSettings["MaxColonistsPerRocket"] = Consts.MaxColonistsPerRocket
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Long pig sardines",
   "Rocket","UI/Icons/Notifications/colonist.tga"
  )
end

--TESTING
--TESTING
--TESTING
--TESTING
--TESTING
function ChoGGi.RCRoverRadius(Bool)
  for _,rcvehicle in ipairs(UICity.labels.RCRover or empty_table) do
    local prop_meta = rcvehicle:GetPropertyMetadata("UIWorkRadius")
    if prop_meta then
      if Bool then
        local radius = rcvehicle:GetProperty(prop_meta.id)
        rcvehicle:SetProperty(prop_meta.id, Max(prop_meta.max, radius + 25))
      else
        rcvehicle:SetProperty(prop_meta.id, Max(prop_meta.max,ChoGGi.Consts["RCRoverMaxRadius"]))
      end
    end
  end
  ChoGGi.MsgPopup("I can see for miles and miles",
   "RC","UI/Icons/Upgrades/service_bots_04.tga"
  )
end

function ChoGGi.CommandCenterRadius(Bool)
  local buildings = UICity.labels.Building
  for _,building in ipairs(buildings) do
    if IsKindOf(building,"DroneHub") then
      local prop_meta = building:GetPropertyMetadata("UIWorkRadius")
      if prop_meta then
        if Bool then
          const.CommandCenterDefaultRadius = const.CommandCenterDefaultRadius + 25
          const.CommandCenterMaxRadius = const.CommandCenterMaxRadius + 25
          const.CommandCenterMinRadius = const.CommandCenterMinRadius + 25
          local radius = building:GetProperty(prop_meta.id)
          building:SetProperty(prop_meta.id, Max(prop_meta.max, radius + 25))
          building:SetProperty(prop_meta.id, Default(prop_meta.default, radius + 25))
          building:SetProperty(prop_meta.id, Min(prop_meta.min, radius + 25))
        else
          const.CommandCenterDefaultRadius = ChoGGi.Consts["CommandCenterDefaultRadius"]
          const.CommandCenterMaxRadius = ChoGGi.Consts["CommandCenterMaxRadius"]
          const.CommandCenterMinRadius = ChoGGi.Consts["CommandCenterMinRadius"]
          building:SetProperty(prop_meta.id, Default(prop_meta.default, const.CommandCenterDefaultRadius))
          building:SetProperty(prop_meta.id, Max(prop_meta.max, const.CommandCenterMaxRadius))
          building:SetProperty(prop_meta.id, Min(prop_meta.min, const.CommandCenterMinRadius))
        end
      end
    end
  end
  ChoGGi.MsgPopup("I see you there",
   "Buildings","UI/Icons/Upgrades/polymer_blades_04.tga"
  )
end

function ChoGGi.TriboelectricScrubberRadius(Bool)
  local buildings = UICity.labels.Building
  for _,building in ipairs(buildings) do
    if IsKindOf(building,"TriboelectricScrubber") then
      local prop_meta = building:GetPropertyMetadata("UIRange")
      if prop_meta then
        if Bool then
          local radius = building:GetProperty(prop_meta.id)
          building:SetProperty(prop_meta.id, Max(prop_meta.max, radius + 25))
        else
          building:SetProperty(prop_meta.id, Max(prop_meta.max,5)) --figure out default const to put here
        end
      end
    end
  end
  ChoGGi.MsgPopup("I see you there",
   "Buildings","UI/Icons/Upgrades/polymer_blades_04.tga"
  )
end

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: FuncsGameplayMisc.lua",true)
end
