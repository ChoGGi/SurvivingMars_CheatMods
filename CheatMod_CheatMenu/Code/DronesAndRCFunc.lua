local UsualIcon = "UI/Icons/IPButtons/drone.tga"
local UsualIcon2 = "UI/Icons/IPButtons/transport_route.tga"
local UsualIcon3 = "UI/Icons/IPButtons/shuttle.tga"

function ChoGGi.SetRoverWorkRadius()
  local DefaultSetting = ChoGGi.Consts.RCRoverDefaultRadius
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 40,value = 40},
    {text = 80,value = 80},
    {text = 160,value = 160},
    {text = 320,value = 320,hint = "Cover the entire map from the centre."},
    {text = 640,value = 640,hint = "Cover the entire map from a corner."},
  }

  --other hint type
  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.RCRoverDefaultRadius then
    hint = ChoGGi.CheatMenuSettings.RCRoverDefaultRadius
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then

      --RCRoverMaxRadius is only needed for the radius during placement
      ChoGGi.SetSavedSetting("RCRoverMaxRadius",value)
      const.RCRoverMaxRadius = value
      ChoGGi.SetSavedSetting("RCRoverDefaultRadius",value)
      for _,Object in ipairs(UICity.labels.RCRover or empty_table) do
        Object:SetWorkRadius(value)
      end

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.RCRoverDefaultRadius) .. ": I can see for miles and miles",
        "RC","UI/Icons/Upgrades/service_bots_04.tga"
      )
    end
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Rover Work Radius","Current: " .. hint)
end

function ChoGGi.SetDroneHubWorkRadius()
  local DefaultSetting = ChoGGi.Consts.CommandCenterDefaultRadius
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 40,value = 40},
    {text = 80,value = 80},
    {text = 160,value = 160},
    {text = 320,value = 320,hint = "Cover the entire map from the centre."},
    {text = 640,value = 640,hint = "Cover the entire map from a corner."},
  }

  --other hint type
  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.CommandCenterDefaultRadius then
    hint = ChoGGi.CheatMenuSettings.CommandCenterDefaultRadius
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then

      ChoGGi.SetSavedSetting("CommandCenterMaxRadius",value)
      const.CommandCenterMaxRadius = value
      ChoGGi.SetSavedSetting("CommandCenterDefaultRadius",value)
      for _,Object in ipairs(UICity.labels.DroneHub or empty_table) do
        Object:SetWorkRadius(value)
      end

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.CommandCenterDefaultRadius) .. ": I can see for miles and miles",
        "DroneHub","UI/Icons/Upgrades/service_bots_04.tga"
      )
    end
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set DroneHub Work Radius","Current: " .. hint)
end

function ChoGGi.SetRockToConcreteSpeed()
  local DefaultSetting = ChoGGi.Consts.DroneTransformWasteRockObstructorToStockpileAmount
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 0,value = 0},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
  }

  --other hint type
  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.DroneTransformWasteRockObstructorToStockpileAmount then
    hint = ChoGGi.CheatMenuSettings.DroneTransformWasteRockObstructorToStockpileAmount
  end

  --callback
  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.SetConstsG("DroneTransformWasteRockObstructorToStockpileAmount",value)

      ChoGGi.SetSavedSetting("DroneTransformWasteRockObstructorToStockpileAmount",Consts.DroneTransformWasteRockObstructorToStockpileAmount)
      ChoGGi.MsgPopup("Selected: " .. choice[1].text,
        "Drones",UsualIcon
      )
    end
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Drone Rock To Concrete Speed","Current: " .. hint)
end

function ChoGGi.SetDroneMoveSpeed()
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.Consts.SpeedDrone
  local UpgradedSetting = ChoGGi.GetSpeedDrone()
  local ItemList = {
    {text = " Default: " .. DefaultSetting / r,value = DefaultSetting},
    {text = " Upgraded: " .. UpgradedSetting / r,value = UpgradedSetting},
    {text = 5,value = 5 * r},
    {text = 10,value = 10 * r},
    {text = 15,value = 15 * r},
    {text = 25,value = 25 * r},
    {text = 50,value = 50 * r},
    {text = 100,value = 100 * r},
    {text = 1000,value = 1000 * r},
    {text = 10000,value = 10000 * r},
  }

  --other hint type
  local hint = UpgradedSetting
  if ChoGGi.CheatMenuSettings.SpeedDrone then
    hint = ChoGGi.CheatMenuSettings.SpeedDrone
  end

  --callback
  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      for _,Object in ipairs(UICity.labels.Drone or empty_table) do
        Object:SetMoveSpeed(value)
      end
      ChoGGi.SetSavedSetting("SpeedDrone",value)
      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup("Selected: " .. choice[1].text,
        "Drones",UsualIcon
      )
    end
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Drone Move Speed","Current: " .. hint)
end

function ChoGGi.SetRCMoveSpeed()
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.Consts.SpeedRC
  local UpgradedSetting = ChoGGi.GetSpeedRC()
  local ItemList = {
    {text = " Default: " .. DefaultSetting / r,value = DefaultSetting},
    {text = " Upgraded: " .. UpgradedSetting / r,value = UpgradedSetting},
    {text = 5,value = 5 * r},
    {text = 10,value = 10 * r},
    {text = 15,value = 15 * r},
    {text = 25,value = 25 * r},
    {text = 50,value = 50 * r},
    {text = 100,value = 100 * r},
    {text = 1000,value = 1000 * r},
    {text = 10000,value = 10000 * r},
  }

  --other hint type
  local hint = UpgradedSetting
  if ChoGGi.CheatMenuSettings.SpeedRC then
    hint = ChoGGi.CheatMenuSettings.SpeedRC
  end

  --callback
  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.SetSavedSetting("SpeedRC",value)

      for _,Object in ipairs(UICity.labels.Rover or empty_table) do
        Object:SetMoveSpeed(value)
      end

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup("Selected: " .. choice[1].text,
        "RCs",UsualIcon2
      )
    end
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"RC Move Speed","Current: " .. hint)
end

function ChoGGi.SetDroneAmountDroneHub()
  local sel = SelectedObj or SelectionMouseObj()
  if not sel then
    return
  end

  local CurrentAmount = sel:GetDronesCount()
  local ItemList = {
    {text = " Current amount: " .. CurrentAmount,value = CurrentAmount},
    {text = 1,value = 1},
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 250,value = 250},
  }

  local CallBackFunc = function(choice)
    --nothing checked so just return
    local check1 = choice[1].check1
    local check2 = choice[1].check2
    if not check1 and not check2 then
      ChoGGi.MsgPopup("Pick a checkbox next time...","Drones")
      return
    elseif check1 and check2 then
      ChoGGi.MsgPopup("Don't pick both checkboxes next time...","Drones")
      return
    end

    local value = choice[1].value
    if type(value) == "number" then

      if check1 then
        for _ = 1, value do
          sel:UseDronePrefab()
        end
      elseif check2 then
        for _ = 1, value do
          sel:ConvertDroneToPrefab()
        end
      end

      ChoGGi.MsgPopup("Drones: " .. choice[1].text,"Drones")
    end
  end

  local hint = "Drones in hub: " .. CurrentAmount .. "\nDrone prefabs: " .. UICity.drone_prefabs
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Change Amount Of Drones",hint,nil,"Add","Check this to add drones to hub","Dismantle","Check this to dismantle drones in hub")
end

function ChoGGi.SetDroneFactoryBuildSpeed()
  local DefaultSetting = ChoGGi.Consts.DroneFactoryBuildSpeed
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 2500,value = 2500},
    {text = 5000,value = 5000},
    {text = 10000,value = 10000},
    {text = 25000,value = 25000},
    {text = 50000,value = 50000},
    {text = 100000,value = 100000},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.DroneFactoryBuildSpeed then
    hint = tostring(ChoGGi.CheatMenuSettings.DroneFactoryBuildSpeed)
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      for _,Object in ipairs(UICity.labels.DroneFactory or empty_table) do
        Object.performance = value
      end
    else
      for _,Object in ipairs(UICity.labels.DroneFactory or empty_table) do
        Object.performance = nil
      end
    end
    ChoGGi.SetSavedSetting("DroneFactoryBuildSpeed",value)

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Build Speed: " .. choice[1].text,
      "Drones",UsualIcon
    )
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Drone Factory Build Speed","Current: " .. hint)
end

function ChoGGi.DroneBatteryInfinite_Toggle()
  ChoGGi.SetConstsG("DroneMoveBatteryUse",ChoGGi.NumRetBool(Consts.DroneMoveBatteryUse,0,ChoGGi.Consts.DroneMoveBatteryUse))
  ChoGGi.SetConstsG("DroneCarryBatteryUse",ChoGGi.NumRetBool(Consts.DroneCarryBatteryUse,0,ChoGGi.Consts.DroneCarryBatteryUse))
  ChoGGi.SetConstsG("DroneConstructBatteryUse",ChoGGi.NumRetBool(Consts.DroneConstructBatteryUse,0,ChoGGi.Consts.DroneConstructBatteryUse))
  ChoGGi.SetConstsG("DroneBuildingRepairBatteryUse",ChoGGi.NumRetBool(Consts.DroneBuildingRepairBatteryUse,0,ChoGGi.Consts.DroneBuildingRepairBatteryUse))
  ChoGGi.SetConstsG("DroneDeconstructBatteryUse",ChoGGi.NumRetBool(Consts.DroneDeconstructBatteryUse,0,ChoGGi.Consts.DroneDeconstructBatteryUse))
  ChoGGi.SetConstsG("DroneTransformWasteRockObstructorToStockpileBatteryUse",ChoGGi.NumRetBool(Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse,0,ChoGGi.Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse))
  ChoGGi.SetSavedSetting("DroneMoveBatteryUse",Consts.DroneMoveBatteryUse)
  ChoGGi.SetSavedSetting("DroneCarryBatteryUse",Consts.DroneCarryBatteryUse)
  ChoGGi.SetSavedSetting("DroneConstructBatteryUse",Consts.DroneConstructBatteryUse)
  ChoGGi.SetSavedSetting("DroneBuildingRepairBatteryUse",Consts.DroneBuildingRepairBatteryUse)
  ChoGGi.SetSavedSetting("DroneDeconstructBatteryUse",Consts.DroneDeconstructBatteryUse)
  ChoGGi.SetSavedSetting("DroneTransformWasteRockObstructorToStockpileBatteryUse",Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.DroneMoveBatteryUse) .. ": What happens when the drones get into your Jolt Cola supply...",
    "Drones",UsualIcon
  )
end

function ChoGGi.DroneBuildSpeed_Toggle()
  ChoGGi.SetConstsG("DroneConstructAmount",ChoGGi.ValueRetOpp(Consts.DroneConstructAmount,999900,ChoGGi.Consts.DroneConstructAmount))
  ChoGGi.SetConstsG("DroneBuildingRepairAmount",ChoGGi.ValueRetOpp(Consts.DroneBuildingRepairAmount,999900,ChoGGi.Consts.DroneBuildingRepairAmount))
  ChoGGi.SetSavedSetting("DroneConstructAmount",Consts.DroneConstructAmount)
  ChoGGi.SetSavedSetting("DroneBuildingRepairAmount",Consts.DroneBuildingRepairAmount)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.DroneConstructAmount) .. ": What happens when the drones get into your Jolt Cola supply... and drink it",
    "Drones",UsualIcon
  )
end

function ChoGGi.RCRoverDroneRechargeFree_Toggle()
  ChoGGi.SetConstsG("RCRoverDroneRechargeCost",ChoGGi.NumRetBool(Consts.RCRoverDroneRechargeCost,0,ChoGGi.Consts.RCRoverDroneRechargeCost))
  ChoGGi.SetSavedSetting("RCRoverDroneRechargeCost",Consts.RCRoverDroneRechargeCost)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.RCRoverDroneRechargeCost) .. ": More where that came from",
    "RCs",UsualIcon2
  )
end

function ChoGGi.RCTransportInstantTransfer_Toggle()
  ChoGGi.SetConstsG("RCRoverTransferResourceWorkTime",ChoGGi.NumRetBool(Consts.RCRoverTransferResourceWorkTime,0,ChoGGi.Consts.RCRoverTransferResourceWorkTime))
  ChoGGi.SetConstsG("RCTransportGatherResourceWorkTime",ChoGGi.NumRetBool(Consts.RCTransportGatherResourceWorkTime,0,ChoGGi.GetRCTransportGatherResourceWorkTime()))
  ChoGGi.SetSavedSetting("RCRoverTransferResourceWorkTime",Consts.RCRoverTransferResourceWorkTime)
  ChoGGi.SetSavedSetting("RCTransportGatherResourceWorkTime",Consts.RCTransportGatherResourceWorkTime)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.RCRoverTransferResourceWorkTime) .. ": Slight of hand",
    "RCs","UI/Icons/IPButtons/resources_section.tga"
  )
end

function ChoGGi.DroneMeteorMalfunction_Toggle()
  ChoGGi.SetConstsG("DroneMeteorMalfunctionChance",ChoGGi.NumRetBool(Consts.DroneMeteorMalfunctionChance,0,ChoGGi.Consts.DroneMeteorMalfunctionChance))
  ChoGGi.SetSavedSetting("DroneMeteorMalfunctionChance",Consts.DroneMeteorMalfunctionChance)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.DroneMeteorMalfunctionChance) .. ": I'm singing in the rain. Just singin' in the rain. What a glorious feeling.",
    "Drones","UI/Icons/Notifications/meteor_storm.tga"
  )
end

function ChoGGi.DroneRechargeTime_Toggle()
  ChoGGi.SetConstsG("DroneRechargeTime",ChoGGi.NumRetBool(Consts.DroneRechargeTime,0,ChoGGi.Consts.DroneRechargeTime))
  ChoGGi.SetSavedSetting("DroneRechargeTime",Consts.DroneRechargeTime)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.DroneRechargeTime) .. "\nWell, if jacking on'll make strangers think I'm cool, I'll do it!",
    "Drones","UI/Icons/Notifications/low_battery.tga",true
  )
end

function ChoGGi.DroneRepairSupplyLeak_Toggle()
  ChoGGi.SetConstsG("DroneRepairSupplyLeak",ChoGGi.ValueRetOpp(Consts.DroneRepairSupplyLeak,1,ChoGGi.Consts.DroneRepairSupplyLeak))
  ChoGGi.SetSavedSetting("DroneRepairSupplyLeak",Consts.DroneRepairSupplyLeak)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.DroneRepairSupplyLeak) .. ": You know what they say about leaky pipes",
    "Drones",UsualIcon
  )
end

function ChoGGi.SetDroneCarryAmount()
  --retrieve default
  local DefaultSetting = ChoGGi.GetDroneResourceCarryAmount()
  --local hinttoolarge = "Warning: If you set this amount larger then a building's \"Stored\" amount drones will NOT empty those buildings."
  local hinttoolarge = "If you set this amount larger then a building's \"Stored\" amount then it'll use my method for removing storage. If you have an insane production amount set then it'll take an (in-game) hour between calling drones."
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 25,value = 25,hint = hinttoolarge},
    {text = 50,value = 50,hint = hinttoolarge},
    {text = 75,value = 75,hint = hinttoolarge},
    {text = 100,value = 100,hint = hinttoolarge},
    {text = 250,value = 250,hint = hinttoolarge},
    {text = 500,value = 500,hint = hinttoolarge},
    {text = 1000,value = 1000,hint = hinttoolarge .. "\n\nsomewhere above 1000 will delete the save (when it's full)"},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.DroneResourceCarryAmount then
    hint = ChoGGi.CheatMenuSettings.DroneResourceCarryAmount
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      --somewhere above 1000 fucks the save
      if value > 1000 then
        value = 1000
      end
      ChoGGi.SetConstsG("DroneResourceCarryAmount",value)
      UpdateDroneResourceUnits()
      ChoGGi.SetSavedSetting("DroneResourceCarryAmount",value)
      ChoGGi.ForceDronesToEmptyStorage_Enable()

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup("Drones can carry: " .. choice[1].text .. " items.",
        "Drones",UsualIcon
      )
    end
  end

  hint = "Current capacity: " .. hint .. "\n\n" .. hinttoolarge .. "\n\nMax: 1000."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Drone Carry Capacity",hint)
end

function ChoGGi.SetDronesPerDroneHub()
  local DefaultSetting = ChoGGi.GetCommandCenterMaxDrones()
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.CommandCenterMaxDrones then
    hint = ChoGGi.CheatMenuSettings.CommandCenterMaxDrones
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.SetConstsG("CommandCenterMaxDrones",value)
      ChoGGi.SetSavedSetting("CommandCenterMaxDrones",value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup("DroneHubs can control: " .. choice[1].text .. " drones.",
        "RCs",UsualIcon
      )
    end
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set DroneHub Drone Capacity","Current capacity: " .. hint)
end

function ChoGGi.SetDronesPerRCRover()
  local DefaultSetting = ChoGGi.GetRCRoverMaxDrones()
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.RCRoverMaxDrones then
    hint = ChoGGi.CheatMenuSettings.RCRoverMaxDrones
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.SetConstsG("RCRoverMaxDrones",value)
      ChoGGi.SetSavedSetting("RCRoverMaxDrones",value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup("RC Rovers can control: " .. choice[1].text .. " drones.",
        "RCs",UsualIcon2
      )
    end
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set RC Rover Drone Capacity","Current capacity: " .. hint)
end

--somewhere above 2000 it will fuck the save
function ChoGGi.SetRCTransportStorageCapacity()
  --retrieve default
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.GetRCTransportStorageCapacity() / r
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 2000,value = 2000,hint = "somewhere above 2000 will delete the save (when it's full)"},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.RCTransportStorageCapacity then
    hint = ChoGGi.CheatMenuSettings.RCTransportStorageCapacity / r
  end

  local CallBackFunc = function(choice)
    if type(choice[1].value) == "number" then
      local value = choice[1].value * r
      --somewhere above 2000 fucks the save
      if value > 2000000 then
        value = 2000000
      end
      --loop through and set all
      for _,Object in ipairs(UICity.labels.RCTransport or empty_table) do
        Object.max_shared_storage = value
      end
      ChoGGi.SetSavedSetting("RCTransportStorageCapacity",value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup("RC Transport capacity is now: " .. choice[1].text,
        "RCs","UI/Icons/bmc_building_storages_shine.tga"
      )
    end
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set RC Transport Capacity","Current capacity: " .. hint)
end

function ChoGGi.SetShuttleCapacity()
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.Consts.StorageShuttle / r
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000,hint = "above 1000 may delete the save (when it's full)"},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.StorageShuttle then
    hint = ChoGGi.CheatMenuSettings.StorageShuttle / r
  end

  local CallBackFunc = function(choice)
    if type(choice[1].value) == "number" then
      local value = choice[1].value * r
      --not tested but I assume too much = dead save as well (like rc and transport)
      if value > 1000000 then
        value = 1000000
      end

      --loop through and set all shuttles
      for _,object in ipairs(UICity.labels.CargoShuttle or empty_table) do
        object.max_shared_storage = value
      end

      ChoGGi.SetSavedSetting("StorageShuttle",value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup("Shuttle storage is now: " .. choice[1].text,
        "Shuttle",UsualIcon3
      )
    end
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Cargo Shuttle Capacity","Current capacity: " .. hint)
end

function ChoGGi.SetShuttleSpeed()
  --retrieve default
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.Consts.SpeedShuttle / r
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 5000,value = 5000},
    {text = 10000,value = 10000},
    {text = 25000,value = 25000},
    {text = 50000,value = 50000},
    {text = 100000,value = 100000},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.SpeedShuttle then
    hint = ChoGGi.CheatMenuSettings.SpeedShuttle / r
  end

  local CallBackFunc = function(choice)
    if type(choice[1].value) == "number" then
      local value = choice[1].value * r
      --loop through and set all shuttles
      for _,object in ipairs(UICity.labels.CargoShuttle or empty_table) do
        object.max_speed = value
      end
      ChoGGi.SetSavedSetting("SpeedShuttle",value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup("Shuttle speed is now: " .. choice[1].text,
        "Shuttle",UsualIcon3
      )
    end
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Cargo Shuttle Speed","Current speed: " .. hint)
end

function ChoGGi.SetShuttleHubCapacity()
  --retrieve default
  local DefaultSetting = ChoGGi.Consts.ShuttleHubCapacity
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
  }

  --check if there's an entry for building
  if not ChoGGi.CheatMenuSettings.BuildingSettings.ShuttleHub then
    ChoGGi.CheatMenuSettings.BuildingSettings.ShuttleHub = {}
  end

  local hint = DefaultSetting
  local setting = ChoGGi.CheatMenuSettings.BuildingSettings.ShuttleHub
  if setting and setting.shuttles then
    hint = tostring(setting.shuttles)
  end

  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      --loop through and set all shuttles
      for _,object in ipairs(UICity.labels.ShuttleHub or empty_table) do
        object.max_shuttles = value
      end
      ChoGGi.CheatMenuSettings.BuildingSettings.ShuttleHub.shuttles = value
    else
      ChoGGi.CheatMenuSettings.BuildingSettings.ShuttleHub.shuttles = nil
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("ShuttleHub shuttle capacity is now: " .. choice[1].text,
      "Shuttle",UsualIcon3
    )
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set ShuttleHub Shuttle Capacity","Current capacity: " .. hint)
end

function ChoGGi.SetGravityRC()
  --retrieve default
  local DefaultSetting = ChoGGi.Consts.GravityRC
  local r = ChoGGi.Consts.ResourceScale
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 1,value = 1},
    {text = 2,value = 2},
    {text = 3,value = 3},
    {text = 4,value = 4},
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 15,value = 15},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.GravityRC then
    hint = ChoGGi.CheatMenuSettings.GravityRC / r
  end

  local CallBackFunc = function(choice)
    if type(choice[1].value) == "number" then
      local value = choice[1].value * r
      for _,Object in ipairs(UICity.labels.Rover or empty_table) do
        Object:SetGravity(value)
      end
      ChoGGi.SetSavedSetting("GravityRC",value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup("RC gravity is now: " .. choice[1].text,
        "RCs",UsualIcon2
      )
    end
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set RC Gravity","Current gravity: " .. hint)
end

function ChoGGi.SetGravityDrones()
  --retrieve default
  local DefaultSetting = ChoGGi.Consts.GravityDrone
  local r = ChoGGi.Consts.ResourceScale
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 1,value = 1},
    {text = 2,value = 2},
    {text = 3,value = 3},
    {text = 4,value = 4},
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 15,value = 15},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.GravityDrone then
    hint = ChoGGi.CheatMenuSettings.GravityDrone / r
  end
  local CallBackFunc = function(choice)
    if type(choice[1].value) == "number" then
      local value = choice[1].value * r
      --loop through and set all
      for _,Object in ipairs(UICity.labels.Drone or empty_table) do
        Object:SetGravity(value)
      end
      ChoGGi.SetSavedSetting("GravityDrone",value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup("RC gravity is now: " .. choice[1].text,
        "RCs",UsualIcon2
      )
    end
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Drone Gravity","Current gravity: " .. hint)
end
