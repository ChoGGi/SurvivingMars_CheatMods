--funcs under Gameplay menu without a separate file

function ChoGGi.SetDisasterOccurrence(sType,ListDisplay)
  local TempFunc = function(choice)
    mapdata["MapSettings_" .. sType] = sType .. "_" .. ListDisplay[choice]
    ChoGGi.MsgPopup(sType .. " occurrence is now: " .. ListDisplay[choice],
      "Disaster","UI/Icons/Sections/attention.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set " .. sType .. " Disaster Occurrences",1,"Current: " .. mapdata["MapSettings_" .. sType])
end

function ChoGGi.MeteorHealthDamage_Toggle()
  Consts.MeteorHealthDamage = ChoGGi.NumRetBool(Consts.MeteorHealthDamage,0,ChoGGi.Consts.MeteorHealthDamage)
  ChoGGi.CheatMenuSettings.MeteorHealthDamage = Consts.MeteorHealthDamage
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.MeteorHealthDamage .. ": Damage? Total, sir. It's what we call a global killer. The end of mankind. Doesn't matter where it hits. Nothing would survive, not even bacteria.",
   "Colonists","UI/Icons/Notifications/meteor_storm.tga"
  )
end

function ChoGGi.SetRocketCargoCapacity()
  local DefaultAmount = ChoGGi.GetCargoCapacity()
  local ListDisplay = {"Default: " .. DefaultAmount,"50 000 kg","100 000 kg","250 000 kg","500 000 kg","1 000 000 kg","10 000 000 kg","100 000 000 kg","1 000 000 000 kg"}
  local ListActual = {DefaultAmount,50000,100000,250000,500000,1000000,10000000,100000000,1000000000}
  local TempFunc = function(choice)
    Consts.CargoCapacity = ListActual[choice]
    g_Consts.CargoCapacity = ListActual[choice]
    ChoGGi.CheatMenuSettings.CargoCapacity = ListActual[choice]
    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup(ListDisplay[choice] .. ": I can still see some space",
     "Rocket","UI/Icons/Sections/spaceship.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set Rocket Cargo Capacity",1,"Current capacity: " .. Consts.CargoCapacity)
end

function ChoGGi.RocketInstantTravel_Toggle()
  --Consts.TravelTimeEarthMars = ChoGGi.NumRetBool(Consts.TravelTimeEarthMars,0,ChoGGi.Consts.TravelTimeEarthMars)
  --Consts.TravelTimeMarsEarth = ChoGGi.NumRetBool(Consts.TravelTimeMarsEarth,0,ChoGGi.Consts.TravelTimeMarsEarth)
  Consts.TravelTimeEarthMars = ChoGGi.NumRetBool(Consts.TravelTimeEarthMars,0,ChoGGi.GetTravelTimeEarthMars())
  Consts.TravelTimeMarsEarth = ChoGGi.NumRetBool(Consts.TravelTimeMarsEarth,0,ChoGGi.GetTravelTimeMarsEarth())
  ChoGGi.CheatMenuSettings.TravelTimeEarthMars = Consts.TravelTimeEarthMars
  ChoGGi.CheatMenuSettings.TravelTimeMarsEarth = Consts.TravelTimeMarsEarth
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.TravelTimeEarthMars / ChoGGi.Consts.ResourceScale .. ": 88 MPH",
   "Rocket","UI/Upgrades/autoregulator_04/timer.tga"
  )
end

function ChoGGi.SetColonistsPerRocket()
  local DefaultAmount = ChoGGi.GetMaxColonistsPerRocket()
  local ListDisplay = {DefaultAmount,25,50,75,100,250,500,1000,10000}
  local TempFunc = function(choice)
    Consts.MaxColonistsPerRocket = ListDisplay[choice]
    ChoGGi.CheatMenuSettings.MaxColonistsPerRocket = ListDisplay[choice]
    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup(ListDisplay[choice] .. ": Long pig sardines",
      "Rocket","UI/Icons/Notifications/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set Colonist Capacity",1,"Current capacity: " .. Consts.MaxColonistsPerRocket)
end

function ChoGGi.SetBuildingCapacity()
  if not SelectedObj or (not SelectedObj.base_water_capacity and not SelectedObj.base_air_capacity and not SelectedObj.base_capacity) then
    ChoGGi.MsgPopup("You need to select a building that has capacity.",
      "Building Capacity","UI/Icons/Sections/storage.tga"
    )
    return
  end
  local sel = SelectedObj

  --get type of capacity
  local CapType
  if sel.base_air_capacity then
    CapType = "air"
  elseif sel.base_water_capacity then
    CapType = "water"
  elseif sel.electricity and sel.electricity.storage_capacity then
    CapType = "electricity"
  elseif sel.colonists then
    CapType = "colonist"
  end

  --get default amount
  local DefaultAmount
  if CapType == "electricity" or CapType == "colonist" then
    DefaultAmount = sel.base_capacity
  else
    DefaultAmount = sel["base_" .. CapType .. "_capacity"]
  end

  if CapType ~= "colonist" then
    DefaultAmount = DefaultAmount / ChoGGi.Consts.ResourceScale
  end
  local ListDisplay = {DefaultAmount,10,25,50,75,100,250,500,1000,2000,3000,4000,5000,10000,25000,50000,100000}
  local hintCap = DefaultAmount
  if ChoGGi.CheatMenuSettings.BuildingsCapacity[sel.encyclopedia_id] then
    hintCap = ChoGGi.CheatMenuSettings.BuildingsCapacity[sel.encyclopedia_id]
  end
  local hint = "Current capacity: " .. hintCap .. "\n\nWarning For Colonist Capacity: 4000 is laggy (above 60K may crash)."
  local TempFunc = function(choice)
    --colonist cap doesn't use res scale
    local amount
    if CapType == "colonist" then
      amount = ListDisplay[choice]
    else
      amount = ListDisplay[choice] * ChoGGi.Consts.ResourceScale
    end

    --NewLabel needed to update battery/etc capacity without toggling it?
    local NewLabel
    if choice == 1 then
      ChoGGi.CheatMenuSettings.BuildingsCapacity[sel.encyclopedia_id] = nil
      NewLabel = "full"
    else
      ChoGGi.CheatMenuSettings.BuildingsCapacity[sel.encyclopedia_id] = amount
      NewLabel = "charging"
    end

    --updating time
    if CapType == "electricity" then
      for _,building in ipairs(UICity.labels.Power or empty_table) do
        if building.encyclopedia_id == sel.encyclopedia_id then
          building.capacity = amount
          building[CapType].storage_capacity = amount
          building[CapType].storage_mode = NewLabel
          ChoGGi.ToggleWorking(building)
        end
      end

    elseif CapType == "colonist" then
      for _,building in ipairs(UICity.labels.Residence or empty_table) do
        if building.encyclopedia_id == sel.encyclopedia_id then
          building.capacity = amount
        end
      end

    else --water and air
      for _,building in ipairs(UICity.labels["Life-Support"] or empty_table) do
        if building.encyclopedia_id == sel.encyclopedia_id then
          building[CapType .. "_capacity"] = amount
          building[CapType].storage_capacity = amount
          building[CapType].storage_mode = NewLabel
          ChoGGi.ToggleWorking(building)
        end
      end
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup(sel.encyclopedia_id .. " Capacity is now " .. ListDisplay[choice],
      "Buildings","UI/Icons/Sections/storage.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set " .. sel.encyclopedia_id .. " Capacity",1,hint)
end --SetBuildingCapacity

function ChoGGi.SetVisitorCapacity()
  if not SelectedObj and not SelectedObj.base_max_visitors then
    ChoGGi.MsgPopup("You need to select something that has space for visitors.",
     "Buildings","UI/Icons/Upgrades/home_collective_04.tga"
    )
    return
  end
  local sel = SelectedObj
  local DefaultAmount = sel.base_max_visitors

  --list to display and list with values
  local ListDisplay = {DefaultAmount,10,25,50,75,100,250,500,1000}
  local hint = DefaultAmount
  if ChoGGi.CheatMenuSettings.BuildingsCapacity[sel.encyclopedia_id] then
    hint = ChoGGi.CheatMenuSettings.BuildingsCapacity[sel.encyclopedia_id]
  end
  local TempFunc = function(choice)
    local amount
    if choice ~= 1 then
      amount = ListDisplay[choice]
    end

    for _,building in ipairs(UICity.labels.BuildingNoDomes or empty_table) do
      if building.encyclopedia_id == sel.encyclopedia_id then
        building.max_visitors = amount
      end
    end

    ChoGGi.CheatMenuSettings.BuildingsCapacity[sel.encyclopedia_id] = amount
    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup(sel.encyclopedia_id .. " visitor capacity is now " .. ListDisplay[choice],
     "Buildings","UI/Icons/Upgrades/home_collective_04.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set " .. sel.encyclopedia_id .. " Visitor Capacity",1,"Current capacity: " .. hint)
end

function ChoGGi.SetStorageDepotSize(sType)

  local DefaultAmount = ChoGGi.Consts[sType] / ChoGGi.Consts.ResourceScale
  --list to display and list with values
  local ListDisplay = {DefaultAmount,50,100,250,500,1000,2500,5000,10000,20000,25000,50000,100000,250000,500000,1000000}
  local hintCap = DefaultAmount
  if ChoGGi.CheatMenuSettings[sType] then
    hintCap = ChoGGi.CheatMenuSettings[sType] / ChoGGi.Consts.ResourceScale
  end
  local hint = "Current capacity: " .. hintCap .. "\n\nMax capacity limited to:\nUniversal: 2,500\nOther: 20,000\nWaste: 1,000,000"
  local TempFunc = function(choice)
    ChoGGi.CheatMenuSettings[sType] = ListDisplay[choice] * ChoGGi.Consts.ResourceScale

    --limit amounts so saving with a full load doesn't delete your game
    if sType == "StorageWasteDepot" and ListDisplay[choice] > 1000000 then
      ChoGGi.CheatMenuSettings[sType] = 1000000000 --might be safe above a million, but I figured I'd stop somewhere
    elseif sType == "StorageOtherDepot" and ListDisplay[choice] > 20000 then
      ChoGGi.CheatMenuSettings[sType] = 20000000
    elseif sType == "StorageUniversalDepot" and ListDisplay[choice] > 2500 then
      ChoGGi.CheatMenuSettings[sType] = 2500000 --can go to 2900, but I got a crash; which may have been something else, but it's only 400 storage
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup(sType .. ": " ..  ChoGGi.CheatMenuSettings[sType] / ChoGGi.Consts.ResourceScale,
      "Storage","UI/Icons/Sections/basic.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set " .. sType .. " Size",1,hint)
end

--TESTING
--[[
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
  ChoGGi.MsgPopup("+25 I can see for miles and miles",
   "RC","UI/Icons/Upgrades/service_bots_04.tga"
  )
end

function ChoGGi.CommandCenterRadius(Bool)
  for _,building in ipairs(UICity.labels.DroneHub) do
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
  ChoGGi.MsgPopup("I see you there",
   "Buildings","UI/Icons/Upgrades/polymer_blades_04.tga"
  )
end

function ChoGGi.TriboelectricScrubberRadius(Bool)
  for _,building in ipairs(UICity.labels.TriboelectricScrubber) do
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
  ChoGGi.MsgPopup("I see you there",
   "Buildings","UI/Icons/Upgrades/polymer_blades_04.tga"
  )
end
--]]
