--See LICENSE for terms

local UsualIcon = "UI/Icons/IPButtons/drone.tga"
local UsualIcon2 = "UI/Icons/IPButtons/transport_route.tga"
local UsualIcon3 = "UI/Icons/IPButtons/shuttle.tga"

function ChoGGi.MenuFuncs.SetRoverChargeRadius()
  local DefaultSetting = 0
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 1,value = 1},
    {text = 2,value = 2},
    {text = 3,value = 3},
    {text = 4,value = 4},
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
  }

  --other hint type
  local hint = DefaultSetting
  if ChoGGi.UserSettings.RCChargeDist then
    hint = ChoGGi.UserSettings.RCChargeDist
  end

  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then

      if value == DefaultSetting then
        ChoGGi.UserSettings.RCChargeDist = nil
      else
        ChoGGi.UserSettings.RCChargeDist = value
      end

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup("Selected: " .. choice[1].text,
        "RC",UsualIcon2
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set Rover Charge Radius",
    hint = "Current: " .. hint,
  })
end

function ChoGGi.MenuFuncs.SetRoverWorkRadius()
  local DefaultSetting = ChoGGi.Consts.RCRoverMaxRadius
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
  if ChoGGi.UserSettings.RCRoverMaxRadius then
    hint = ChoGGi.UserSettings.RCRoverMaxRadius
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then

      ChoGGi.ComFuncs.SetSavedSetting("RCRoverMaxRadius",value)
      --we need to set this so the hex grid during placement is enlarged
      const.RCRoverMaxRadius = value

      local tab = UICity.labels.RCRover or empty_table
      for i = 1, #tab do
        tab[i]:SetWorkRadius(value)
      end

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.RCRoverMaxRadius) .. ": I can see for miles and miles",
        "RC","UI/Icons/Upgrades/service_bots_04.tga"
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set Rover Work Radius",
    hint = "Current: " .. hint .. "\n\nToggle selection to update visible hex grid.",
  })
end

function ChoGGi.MenuFuncs.SetDroneHubWorkRadius()
  local DefaultSetting = ChoGGi.Consts.CommandCenterMaxRadius
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
  if ChoGGi.UserSettings.CommandCenterMaxRadius then
    hint = ChoGGi.UserSettings.CommandCenterMaxRadius
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then

      ChoGGi.ComFuncs.SetSavedSetting("CommandCenterMaxRadius",value)
      --we need to set this so the hex grid during placement is enlarged
      const.CommandCenterMaxRadius = value

      local tab = UICity.labels.DroneHub or empty_table
      for i = 1, #tab do
        tab[i]:SetWorkRadius(value)
      end

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.CommandCenterMaxRadius) .. ": I can see for miles and miles",
        "DroneHub","UI/Icons/Upgrades/service_bots_04.tga"
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set DroneHub Work Radius",
    hint = "Current: " .. hint .. "\n\nToggle selection to update visible hex grid.",
  })
end

function ChoGGi.MenuFuncs.SetDroneRockToConcreteSpeed()
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
  if ChoGGi.UserSettings.DroneTransformWasteRockObstructorToStockpileAmount then
    hint = ChoGGi.UserSettings.DroneTransformWasteRockObstructorToStockpileAmount
  end

  --callback
  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.ComFuncs.SetConstsG("DroneTransformWasteRockObstructorToStockpileAmount",value)

      ChoGGi.ComFuncs.SetSavedSetting("DroneTransformWasteRockObstructorToStockpileAmount",Consts.DroneTransformWasteRockObstructorToStockpileAmount)
      ChoGGi.ComFuncs.MsgPopup("Selected: " .. choice[1].text,
        "Drones",UsualIcon
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Drone Rock To Concrete Speed",
    hint = "Current: " .. hint,
  })
end

function ChoGGi.MenuFuncs.SetDroneMoveSpeed()
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.Consts.SpeedDrone
  local UpgradedSetting = ChoGGi.CodeFuncs.GetSpeedDrone()
  local ItemList = {
    {text = " Default: " .. DefaultSetting / r,value = DefaultSetting,hint = "base speed"},
    {text = " Upgraded: " .. UpgradedSetting / r,value = UpgradedSetting,hint = "apply tech unlocks"},
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
  if ChoGGi.UserSettings.SpeedDrone then
    hint = ChoGGi.UserSettings.SpeedDrone
  end

  --callback
  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      local tab = UICity.labels.Drone or empty_table
      for i = 1, #tab do
        --tab[i]:SetMoveSpeed(value)
        pf.SetStepLen(tab[i],value)
      end
      ChoGGi.ComFuncs.SetSavedSetting("SpeedDrone",value)

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup("Selected: " .. choice[1].text,
        "Drones",UsualIcon
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Drone Move Speed",
    hint = "Current: " .. hint,
  })
end

function ChoGGi.MenuFuncs.SetRCMoveSpeed()
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.Consts.SpeedRC
  local UpgradedSetting = ChoGGi.CodeFuncs.GetSpeedRC()
  local ItemList = {
    {text = " Default: " .. DefaultSetting / r,value = DefaultSetting,hint = "base speed"},
    {text = " Upgraded: " .. UpgradedSetting / r,value = UpgradedSetting,hint = "apply tech unlocks"},
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
  if ChoGGi.UserSettings.SpeedRC then
    hint = ChoGGi.UserSettings.SpeedRC
  end

  --callback
  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.ComFuncs.SetSavedSetting("SpeedRC",value)
      local tab = UICity.labels.Rover or empty_table
      for i = 1, #tab do
        --tab[i]:SetMoveSpeed(value)
        pf.SetStepLen(tab[i],value)
      end

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup("Selected: " .. choice[1].text,
        "RCs",UsualIcon2
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "RC Move Speed",
    hint = "Current: " .. hint,
  })
end

function ChoGGi.MenuFuncs.SetDroneAmountDroneHub()
  local sel = ChoGGi.CodeFuncs.SelObject()
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
    local value = choice[1].value
    if type(value) == "number" then

      local change = " added: "
      if choice[1].check1 then
        change = " dismantled: "
        for _ = 1, value do
          sel:ConvertDroneToPrefab()
        end
      else
        for _ = 1, value do
          sel:UseDronePrefab()
        end
      end

      ChoGGi.ComFuncs.MsgPopup("Drones" .. change .. choice[1].text,"Drones")
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Change Amount Of Drones",
    hint = "Drones in hub: " .. CurrentAmount .. "\nDrone prefabs: " .. UICity.drone_prefabs,
    check1 = "Dismantle",
    check1_hint = "Check this to dismantle drones in hub",
  })
end

function ChoGGi.MenuFuncs.SetDroneFactoryBuildSpeed()
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
  if ChoGGi.UserSettings.DroneFactoryBuildSpeed then
    hint = tostring(ChoGGi.UserSettings.DroneFactoryBuildSpeed)
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value

    if type(value) == "number" then
      local tab = UICity.labels.DroneFactory or empty_table
      for i = 1, #tab do
        tab[i].performance = value
      end
    end
    ChoGGi.ComFuncs.SetSavedSetting("DroneFactoryBuildSpeed",value)

    ChoGGi.SettingFuncs.WriteSettings()
    ChoGGi.ComFuncs.MsgPopup("Build Speed: " .. choice[1].text,
      "Drones",UsualIcon
    )
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set Drone Factory Build Speed",
    hint = "Current: " .. hint,
  })
end

function ChoGGi.MenuFuncs.DroneBatteryInfinite_Toggle()
  ChoGGi.ComFuncs.SetConstsG("DroneMoveBatteryUse",ChoGGi.ComFuncs.NumRetBool(Consts.DroneMoveBatteryUse,0,ChoGGi.Consts.DroneMoveBatteryUse))
  ChoGGi.ComFuncs.SetConstsG("DroneCarryBatteryUse",ChoGGi.ComFuncs.NumRetBool(Consts.DroneCarryBatteryUse,0,ChoGGi.Consts.DroneCarryBatteryUse))
  ChoGGi.ComFuncs.SetConstsG("DroneConstructBatteryUse",ChoGGi.ComFuncs.NumRetBool(Consts.DroneConstructBatteryUse,0,ChoGGi.Consts.DroneConstructBatteryUse))
  ChoGGi.ComFuncs.SetConstsG("DroneBuildingRepairBatteryUse",ChoGGi.ComFuncs.NumRetBool(Consts.DroneBuildingRepairBatteryUse,0,ChoGGi.Consts.DroneBuildingRepairBatteryUse))
  ChoGGi.ComFuncs.SetConstsG("DroneDeconstructBatteryUse",ChoGGi.ComFuncs.NumRetBool(Consts.DroneDeconstructBatteryUse,0,ChoGGi.Consts.DroneDeconstructBatteryUse))
  ChoGGi.ComFuncs.SetConstsG("DroneTransformWasteRockObstructorToStockpileBatteryUse",ChoGGi.ComFuncs.NumRetBool(Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse,0,ChoGGi.Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse))
  ChoGGi.ComFuncs.SetSavedSetting("DroneMoveBatteryUse",Consts.DroneMoveBatteryUse)
  ChoGGi.ComFuncs.SetSavedSetting("DroneCarryBatteryUse",Consts.DroneCarryBatteryUse)
  ChoGGi.ComFuncs.SetSavedSetting("DroneConstructBatteryUse",Consts.DroneConstructBatteryUse)
  ChoGGi.ComFuncs.SetSavedSetting("DroneBuildingRepairBatteryUse",Consts.DroneBuildingRepairBatteryUse)
  ChoGGi.ComFuncs.SetSavedSetting("DroneDeconstructBatteryUse",Consts.DroneDeconstructBatteryUse)
  ChoGGi.ComFuncs.SetSavedSetting("DroneTransformWasteRockObstructorToStockpileBatteryUse",Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.DroneMoveBatteryUse) .. ": What happens when the drones get into your Jolt Cola supply...",
    "Drones",UsualIcon
  )
end

function ChoGGi.MenuFuncs.DroneBuildSpeed_Toggle()
  ChoGGi.ComFuncs.SetConstsG("DroneConstructAmount",ChoGGi.ComFuncs.ValueRetOpp(Consts.DroneConstructAmount,999900,ChoGGi.Consts.DroneConstructAmount))
  ChoGGi.ComFuncs.SetConstsG("DroneBuildingRepairAmount",ChoGGi.ComFuncs.ValueRetOpp(Consts.DroneBuildingRepairAmount,999900,ChoGGi.Consts.DroneBuildingRepairAmount))
  ChoGGi.ComFuncs.SetSavedSetting("DroneConstructAmount",Consts.DroneConstructAmount)
  ChoGGi.ComFuncs.SetSavedSetting("DroneBuildingRepairAmount",Consts.DroneBuildingRepairAmount)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.DroneConstructAmount) .. ": What happens when the drones get into your Jolt Cola supply... and drink it",
    "Drones",UsualIcon
  )
end

function ChoGGi.MenuFuncs.RCRoverDroneRechargeFree_Toggle()
  ChoGGi.ComFuncs.SetConstsG("RCRoverDroneRechargeCost",ChoGGi.ComFuncs.NumRetBool(Consts.RCRoverDroneRechargeCost,0,ChoGGi.Consts.RCRoverDroneRechargeCost))
  ChoGGi.ComFuncs.SetSavedSetting("RCRoverDroneRechargeCost",Consts.RCRoverDroneRechargeCost)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.RCRoverDroneRechargeCost) .. ": More where that came from",
    "RCs",UsualIcon2
  )
end

function ChoGGi.MenuFuncs.RCTransportInstantTransfer_Toggle()
  ChoGGi.ComFuncs.SetConstsG("RCRoverTransferResourceWorkTime",ChoGGi.ComFuncs.NumRetBool(Consts.RCRoverTransferResourceWorkTime,0,ChoGGi.Consts.RCRoverTransferResourceWorkTime))
  ChoGGi.ComFuncs.SetConstsG("RCTransportGatherResourceWorkTime",ChoGGi.ComFuncs.NumRetBool(Consts.RCTransportGatherResourceWorkTime,0,ChoGGi.CodeFuncs.GetRCTransportGatherResourceWorkTime()))
  ChoGGi.ComFuncs.SetSavedSetting("RCRoverTransferResourceWorkTime",Consts.RCRoverTransferResourceWorkTime)
  ChoGGi.ComFuncs.SetSavedSetting("RCTransportGatherResourceWorkTime",Consts.RCTransportGatherResourceWorkTime)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.RCRoverTransferResourceWorkTime) .. ": Slight of hand",
    "RCs","UI/Icons/IPButtons/resources_section.tga"
  )
end

function ChoGGi.MenuFuncs.DroneMeteorMalfunction_Toggle()
  ChoGGi.ComFuncs.SetConstsG("DroneMeteorMalfunctionChance",ChoGGi.ComFuncs.NumRetBool(Consts.DroneMeteorMalfunctionChance,0,ChoGGi.Consts.DroneMeteorMalfunctionChance))
  ChoGGi.ComFuncs.SetSavedSetting("DroneMeteorMalfunctionChance",Consts.DroneMeteorMalfunctionChance)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.DroneMeteorMalfunctionChance) .. ": I'm singing in the rain. Just singin' in the rain. What a glorious feeling.",
    "Drones","UI/Icons/Notifications/meteor_storm.tga"
  )
end

function ChoGGi.MenuFuncs.DroneRechargeTime_Toggle()
  ChoGGi.ComFuncs.SetConstsG("DroneRechargeTime",ChoGGi.ComFuncs.NumRetBool(Consts.DroneRechargeTime,0,ChoGGi.Consts.DroneRechargeTime))
  ChoGGi.ComFuncs.SetSavedSetting("DroneRechargeTime",Consts.DroneRechargeTime)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.DroneRechargeTime) .. "\nWell, if jacking on'll make strangers think I'm cool, I'll do it!",
    "Drones","UI/Icons/Notifications/low_battery.tga",true
  )
end

function ChoGGi.MenuFuncs.DroneRepairSupplyLeak_Toggle()
  ChoGGi.ComFuncs.SetConstsG("DroneRepairSupplyLeak",ChoGGi.ComFuncs.ValueRetOpp(Consts.DroneRepairSupplyLeak,1,ChoGGi.Consts.DroneRepairSupplyLeak))
  ChoGGi.ComFuncs.SetSavedSetting("DroneRepairSupplyLeak",Consts.DroneRepairSupplyLeak)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.DroneRepairSupplyLeak) .. ": You know what they say about leaky pipes",
    "Drones",UsualIcon
  )
end

function ChoGGi.MenuFuncs.SetDroneCarryAmount()
  --retrieve default
  local DefaultSetting = ChoGGi.CodeFuncs.GetDroneResourceCarryAmount()
  local hinttoolarge = "If you set this amount larger then a building's \"Storage\" amount then the drones will NOT pick up storage (See: Fixes>Drone Carry Amount)."
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
  if ChoGGi.UserSettings.DroneResourceCarryAmount then
    hint = ChoGGi.UserSettings.DroneResourceCarryAmount
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      --somewhere above 1000 fucks the save
      if value > 1000 then
        value = 1000
      end
      ChoGGi.ComFuncs.SetConstsG("DroneResourceCarryAmount",value)
      UpdateDroneResourceUnits()
      ChoGGi.ComFuncs.SetSavedSetting("DroneResourceCarryAmount",value)

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup("Drones can carry: " .. choice[1].text .. " items.",
        "Drones",UsualIcon
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set Drone Carry Capacity",
    hint = "Current capacity: " .. hint .. "\n\n" .. hinttoolarge .. "\n\nMax: 1000.",
  })
end

function ChoGGi.MenuFuncs.SetDronesPerDroneHub()
  local DefaultSetting = ChoGGi.CodeFuncs.GetCommandCenterMaxDrones()
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
  if ChoGGi.UserSettings.CommandCenterMaxDrones then
    hint = ChoGGi.UserSettings.CommandCenterMaxDrones
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.ComFuncs.SetConstsG("CommandCenterMaxDrones",value)
      ChoGGi.ComFuncs.SetSavedSetting("CommandCenterMaxDrones",value)

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup("DroneHubs can control: " .. choice[1].text .. " drones.",
        "RCs",UsualIcon
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set DroneHub Drone Capacity",
    hint = "Current capacity: " .. hint,
  })
end

function ChoGGi.MenuFuncs.SetDronesPerRCRover()
  local DefaultSetting = ChoGGi.CodeFuncs.GetRCRoverMaxDrones()
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
  if ChoGGi.UserSettings.RCRoverMaxDrones then
    hint = ChoGGi.UserSettings.RCRoverMaxDrones
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.ComFuncs.SetConstsG("RCRoverMaxDrones",value)
      ChoGGi.ComFuncs.SetSavedSetting("RCRoverMaxDrones",value)

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup("RC Rovers can control: " .. choice[1].text .. " drones.",
        "RCs",UsualIcon2
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set RC Rover Drone Capacity",
    hint = "Current capacity: " .. hint,
  })
end

--somewhere above 2000 it will fuck the save (different amounts depending on the unit type (is it a height thing?)
function ChoGGi.MenuFuncs.SetRCTransportStorageCapacity()
  --retrieve default
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.CodeFuncs.GetRCTransportStorageCapacity() / r
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
  if ChoGGi.UserSettings.RCTransportStorageCapacity then
    hint = ChoGGi.UserSettings.RCTransportStorageCapacity / r
  end

  local CallBackFunc = function(choice)
    if type(choice[1].value) == "number" then
      local value = choice[1].value * r
      --somewhere above 2000 fucks the save
      if value > 2000000 then
        value = 2000000
      end
      --loop through and set all
      local tab = UICity.labels.RCTransport or empty_table
      for i = 1, #tab do
        tab[i].max_shared_storage = value
      end
      ChoGGi.ComFuncs.SetSavedSetting("RCTransportStorageCapacity",value)

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup("RC Transport capacity is now: " .. choice[1].text,
        "RCs","UI/Icons/bmc_building_storages_shine.tga"
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set RC Transport Capacity",
    hint = "Current capacity: " .. hint,
  })
end

function ChoGGi.MenuFuncs.SetShuttleCapacity()
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
  if ChoGGi.UserSettings.StorageShuttle then
    hint = ChoGGi.UserSettings.StorageShuttle / r
  end

  local CallBackFunc = function(choice)
    if type(choice[1].value) == "number" then
      local value = choice[1].value * r
      --not tested but I assume too much = dead save as well (like rc and transport)
      if value > 1000000 then
        value = 1000000
      end

      --loop through and set all shuttles
      local tab = UICity.labels.CargoShuttle or empty_table
      for i = 1, #tab do
        tab[i].max_shared_storage = value
      end
      ChoGGi.ComFuncs.SetSavedSetting("StorageShuttle",value)

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup("Shuttle storage is now: " .. choice[1].text,
        "Shuttle",UsualIcon3
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set Cargo Shuttle Capacity",
    hint = "Current capacity: " .. hint,
  })
end

function ChoGGi.MenuFuncs.SetShuttleSpeed()
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
  if ChoGGi.UserSettings.SpeedShuttle then
    hint = ChoGGi.UserSettings.SpeedShuttle / r
  end

  local CallBackFunc = function(choice)
    if type(choice[1].value) == "number" then
      local value = choice[1].value * r
      --loop through and set all shuttles
      local tab = UICity.labels.CargoShuttle or empty_table
      for i = 1, #tab do
        tab[i].max_speed = value
        --pf.SetStepLen(tab[i],value)
      end
      ChoGGi.ComFuncs.SetSavedSetting("SpeedShuttle",value)

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup("Shuttle speed is now: " .. choice[1].text,
        "Shuttle",UsualIcon3
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set Cargo Shuttle Speed",
    hint = "Current speed: " .. hint,
  })
end

function ChoGGi.MenuFuncs.SetShuttleHubShuttleCapacity()
  --retrieve default
  local DefaultSetting = ChoGGi.Consts.ShuttleHubShuttleCapacity
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
  if not ChoGGi.UserSettings.BuildingSettings.ShuttleHub then
    ChoGGi.UserSettings.BuildingSettings.ShuttleHub = {}
  end

  local hint = DefaultSetting
  local setting = ChoGGi.UserSettings.BuildingSettings.ShuttleHub
  if setting and setting.shuttles then
    hint = tostring(setting.shuttles)
  end

  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      --loop through and set all shuttles
      local tab = UICity.labels.ShuttleHub or empty_table
      for i = 1, #tab do
        tab[i].max_shuttles = value
      end
      if value == DefaultSetting then
        ChoGGi.UserSettings.BuildingSettings.ShuttleHub.shuttles = nil
      else
        ChoGGi.UserSettings.BuildingSettings.ShuttleHub.shuttles = value
      end
    end

    ChoGGi.SettingFuncs.WriteSettings()
    ChoGGi.ComFuncs.MsgPopup("ShuttleHub shuttle capacity is now: " .. choice[1].text,
      "Shuttle",UsualIcon3
    )
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set ShuttleHub Shuttle Capacity",
    hint = "Current capacity: " .. hint,
  })
end

function ChoGGi.MenuFuncs.SetGravityRC()
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
  if ChoGGi.UserSettings.GravityRC then
    hint = ChoGGi.UserSettings.GravityRC / r
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      local value = value * r
      local tab = UICity.labels.Rover or empty_table
      for i = 1, #tab do
        tab[i]:SetGravity(value)
      end
      ChoGGi.ComFuncs.SetSavedSetting("GravityRC",value)

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup("RC gravity is now: " .. choice[1].text,
        "RCs",UsualIcon2
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set RC Gravity",
    hint = "Current gravity: " .. hint,
  })
end

function ChoGGi.MenuFuncs.SetGravityDrones()
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
  if ChoGGi.UserSettings.GravityDrone then
    hint = ChoGGi.UserSettings.GravityDrone / r
  end
  local CallBackFunc = function(choice)
    if type(choice[1].value) == "number" then
      local value = choice[1].value * r
      --loop through and set all
      local tab = UICity.labels.Drone or empty_table
      for i = 1, #tab do
        tab[i]:SetGravity(value)
      end
      ChoGGi.ComFuncs.SetSavedSetting("GravityDrone",value)

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup("RC gravity is now: " .. choice[1].text,
        "RCs",UsualIcon2
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Set Drone Gravity",
    hint = "Current gravity: " .. hint,
  })
end
