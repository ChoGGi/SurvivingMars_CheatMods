function ChoGGi.BorderScrollingToggle()
  ChoGGi.CheatMenuSettings.BorderScrollingToggle = not ChoGGi.CheatMenuSettings.BorderScrollingToggle
  if ChoGGi.CheatMenuSettings.BorderScrollingToggle then
    cameraRTS.SetProperties(1,{ScrollBorder = 0})
  else
    cameraRTS.SetProperties(1,{ScrollBorder = 2})
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.BorderScrollingToggle .. " Mouse Border Scrolling",
   "BorderScrolling","UI/Icons/IPButtons/status_effects.tga"
  )
end

function ChoGGi.CameraZoomToggle()
  ChoGGi.CheatMenuSettings.CameraZoomToggle = not ChoGGi.CheatMenuSettings.CameraZoomToggle
  if ChoGGi.CheatMenuSettings.CameraZoomToggle then
    cameraRTS.SetProperties(1,{
      MinHeight = 1,
      MaxHeight = 80,
      MinZoom = 1,
      MaxZoom = 24000
    })
  else
    cameraRTS.SetProperties(1,{
      MinHeight = 4,
      MaxHeight = 40,
      MinZoom = 400,
      MaxZoom = 8000
    })
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.CameraZoomToggle .. " Camera Zoom",
   "Camera","UI/Icons/IPButtons/status_effects.tga"
  )
end

function ChoGGi.CameraZoomToggleSpeed()
  ChoGGi.CheatMenuSettings.CameraZoomToggleSpeed = not ChoGGi.CheatMenuSettings.CameraZoomToggleSpeed
  if ChoGGi.CheatMenuSettings.CameraZoomToggleSpeed then
    cameraRTS.SetProperties(1,{CameraZoomToggleSpeed = 800})
  else
    cameraRTS.SetProperties(1,{CameraZoomToggleSpeed = 230})
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.CameraZoomToggleSpeed .. " Camera Zoom Speed",
   "Camera","UI/Icons/IPButtons/status_effects.tga"
  )
end

function ChoGGi.SpacingPipesPillarsToggle()
  if Consts.PipesPillarSpacing == 1000 then
    Consts.PipesPillarSpacing = ChoGGi.Consts.PipesPillarSpacing
  else
    Consts.PipesPillarSpacing = 1000
  end
  ChoGGi.CheatMenuSettings.PipesPillarSpacing = Consts.PipesPillarSpacing
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.PipesPillarSpacing .. " Is that a rocket in your pocket?",
   "Buildings","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.ShowAllTraitsToggle()
  ChoGGi.CheatMenuSettings.ShowAllTraits = not ChoGGi.CheatMenuSettings.ShowAllTraits
  if ChoGGi.CheatMenuSettings.ShowAllTraits then
    g_SchoolTraits = ChoGGi.PositiveTraits
    g_SanatoriumTraits = ChoGGi.PositiveTraits
  else
    g_SchoolTraits = {"Nerd","Composed","Enthusiast","Religious","Survivor"}
    g_SanatoriumTraits = {"Alcoholic","Gambler","Glutton","Lazy","ChronicCondition","Melancholic","Coward"}
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.ShowAllTraits .. " Good for what ails you",
   "Traits","UI/Icons/Upgrades/factory_ai_04.tga"
  )
end

function ChoGGi.ResearchQueueLargerToggle()
  if const.ResearchQueueSize == 25 then
    const.ResearchQueueSize = ChoGGi.Consts.ResearchQueueSize
  else
    const.ResearchQueueSize = 25
  end
  ChoGGi.CheatMenuSettings.ResearchQueueSize = const.ResearchQueueSize
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.ResearchQueueSize .. " Nerdgasm",
   "Research","UI/Icons/Notifications/research.tga"
  )
end

function ChoGGi.OutsourcingFreeToggle()
  Consts.OutsourceResearchCost = ChoGGi.NumRetBool(Consts.OutsourceResearchCost) and 0 or ChoGGi.Consts.OutsourceResearchCost
  ChoGGi.CheatMenuSettings.OutsourceResearchCost = Consts.OutsourceResearchCost
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.OutsourceResearchCost .. " Best hope you picked India as your Mars sponsor",
   "Research","UI/Icons/Sections/research_1.tga"
  )
end

function ChoGGi.ScannerQueueLargerToggle()
  if const.ExplorationQueueMaxSize == 100 then
    const.ExplorationQueueMaxSize = ChoGGi.Consts.ExplorationQueueMaxSize
  else
    const.ExplorationQueueMaxSize = 100
  end
  ChoGGi.CheatMenuSettings.ExplorationQueueMaxSize = const.ExplorationQueueMaxSize
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.ExplorationQueueMaxSize .. " scans at a time.",
   "Scanner","UI/Icons/Notifications/scan.tga"
  )
end

function ChoGGi.MeteorHealthDamageToggle()
  Consts.MeteorHealthDamage = ChoGGi.NumRetBool(Consts.MeteorHealthDamage,0,ChoGGi.Consts.MeteorHealthDamage)
  ChoGGi.CheatMenuSettings.MeteorHealthDamage = Consts.MeteorHealthDamage
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.MeteorHealthDamage .. " Damage? Total, sir. It's what we call a global killer. The end of mankind. Doesn't matter where it hits. Nothing would survive, not even bacteria.",
   "Colonists","UI/Icons/Notifications/meteor_storm.tga"
  )
end

function ChoGGi.RocketCargoCapacityToggle()
  if Consts.CargoCapacity == 1000000000 then
    Consts.CargoCapacity = ChoGGi.CargoCapacity()
  else
    Consts.CargoCapacity = 1000000000
  end
  ChoGGi.CheatMenuSettings.CargoCapacity = Consts.CargoCapacity
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.CargoCapacity .. " I can still see some space",
   "Rocket","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.RocketTravelInstantToggle()
  Consts.TravelTimeEarthMars = ChoGGi.NumRetBool(Consts.TravelTimeEarthMars,0,ChoGGi.Consts.TravelTimeEarthMars)
  Consts.TravelTimeMarsEarth = ChoGGi.NumRetBool(Consts.TravelTimeMarsEarth,0,ChoGGi.Consts.TravelTimeMarsEarth)
  ChoGGi.CheatMenuSettings.TravelTimeEarthMars = Consts.TravelTimeEarthMars
  ChoGGi.CheatMenuSettings.TravelTimeMarsEarth = Consts.TravelTimeMarsEarth
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.TravelTimeEarthMars / ChoGGi.Consts.ResourceScale .. "or 88 MPH",
   "Rocket","UI/Upgrades/autoregulator_04/timer.tga"
  )
end

function ChoGGi.OutsourcePoints1000000()
  Consts.OutsourceResearch = 9999900
  ChoGGi.CheatMenuSettings.OutsourceResearch = Consts.OutsourceResearch
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.OutsourceResearch .. " The same thing we do every night, Pinky - try to take over the world!",
   "Research","UI/Icons/Upgrades/eternal_fusion_04.tga"
  )
end

function ChoGGi.SetGameSpeed(Speed)
  if Speed == 1 then
    const.mediumGameSpeed = ChoGGi.Consts.mediumGameSpeed
    const.fastGameSpeed = ChoGGi.Consts.fastGameSpeed
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
  ChoGGi.CheatMenuSettings.mediumGameSpeed = const.mediumGameSpeed
  ChoGGi.CheatMenuSettings.fastGameSpeed = const.fastGameSpeed
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.mediumGameSpeed .. " I think I can",
   "Speed","UI/Icons/Notifications/timer.tga"
  )
end

function ChoGGi.ColonistsPerRocket(Bool)
  if Bool == true then
    Consts.MaxColonistsPerRocket = Consts.MaxColonistsPerRocket + 25
  else
    Consts.MaxColonistsPerRocket = ChoGGi.MaxColonistsPerRocket()
  end
  ChoGGi.CheatMenuSettings.MaxColonistsPerRocket = Consts.MaxColonistsPerRocket
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.MaxColonistsPerRocket .. " Long pig sardines",
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
      if Bool == true then
        local radius = rcvehicle:GetProperty(prop_meta.id)
        rcvehicle:SetProperty(prop_meta.id, Max(prop_meta.max, radius + 25))
      else
        rcvehicle:SetProperty(prop_meta.id, Max(prop_meta.max,ChoGGi.Consts.RCRoverMaxRadius))
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
        if Bool == true then
          const.CommandCenterDefaultRadius = const.CommandCenterDefaultRadius + 25
          const.CommandCenterMaxRadius = const.CommandCenterMaxRadius + 25
          const.CommandCenterMinRadius = const.CommandCenterMinRadius + 25
          local radius = building:GetProperty(prop_meta.id)
          building:SetProperty(prop_meta.id, Max(prop_meta.max, radius + 25))
          building:SetProperty(prop_meta.id, Default(prop_meta.default, radius + 25))
          building:SetProperty(prop_meta.id, Min(prop_meta.min, radius + 25))
        else
          const.CommandCenterDefaultRadius = ChoGGi.Consts.CommandCenterDefaultRadius
          const.CommandCenterMaxRadius = ChoGGi.Consts.CommandCenterMaxRadius
          const.CommandCenterMinRadius = ChoGGi.Consts.CommandCenterMinRadius
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
        if Bool == true then
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

if ChoGGi.ChoGGiTest then
  AddConsoleLog("ChoGGi: MenuMiscFunc.lua",true)
end
