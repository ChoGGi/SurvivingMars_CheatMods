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

      ChoGGi.Funcs.WriteSettings()
      ChoGGi.Funcs.MsgPopup("Selected: " .. choice[1].text,
        "RC",UsualIcon2
      )
    end
  end

  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"TitleBar","Current: " .. hint)

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

      ChoGGi.Funcs.SetSavedSetting("RCRoverMaxRadius",value)
      --we need to set this so the hex grid during placement is enlarged
      const.RCRoverMaxRadius = value

      local tab = UICity.labels.RCRover or empty_table
      for i = 1, #tab do
        tab[i]:SetWorkRadius(value)
      end

      ChoGGi.Funcs.WriteSettings()
      ChoGGi.Funcs.MsgPopup(tostring(ChoGGi.UserSettings.RCRoverMaxRadius) .. ": I can see for miles and miles",
        "RC","UI/Icons/Upgrades/service_bots_04.tga"
      )
    end
  end

  hint = "Current: " .. hint .. "\n\nToggle selection to update visible hex grid."
  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Rover Work Radius",hint)
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

      ChoGGi.Funcs.SetSavedSetting("CommandCenterMaxRadius",value)
      --we need to set this so the hex grid during placement is enlarged
      const.CommandCenterMaxRadius = value

      local tab = UICity.labels.DroneHub or empty_table
      for i = 1, #tab do
        tab[i]:SetWorkRadius(value)
      end

      ChoGGi.Funcs.WriteSettings()
      ChoGGi.Funcs.MsgPopup(tostring(ChoGGi.UserSettings.CommandCenterMaxRadius) .. ": I can see for miles and miles",
        "DroneHub","UI/Icons/Upgrades/service_bots_04.tga"
      )
    end
  end

  hint = "Current: " .. hint .. "\n\nToggle selection to update visible hex grid."
  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set DroneHub Work Radius",hint)
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
      ChoGGi.Funcs.SetConstsG("DroneTransformWasteRockObstructorToStockpileAmount",value)

      ChoGGi.Funcs.SetSavedSetting("DroneTransformWasteRockObstructorToStockpileAmount",Consts.DroneTransformWasteRockObstructorToStockpileAmount)
      ChoGGi.Funcs.MsgPopup("Selected: " .. choice[1].text,
        "Drones",UsualIcon
      )
    end
  end

  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"Drone Rock To Concrete Speed","Current: " .. hint)
end

function ChoGGi.MenuFuncs.SetDroneMoveSpeed()
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.Consts.SpeedDrone
  local UpgradedSetting = ChoGGi.Funcs.GetSpeedDrone()
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
      ChoGGi.Funcs.SetSavedSetting("SpeedDrone",value)

      ChoGGi.Funcs.WriteSettings()
      ChoGGi.Funcs.MsgPopup("Selected: " .. choice[1].text,
        "Drones",UsualIcon
      )
    end
  end

  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"Drone Move Speed","Current: " .. hint)
end

function ChoGGi.MenuFuncs.SetRCMoveSpeed()
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.Consts.SpeedRC
  local UpgradedSetting = ChoGGi.Funcs.GetSpeedRC()
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
  if ChoGGi.UserSettings.SpeedRC then
    hint = ChoGGi.UserSettings.SpeedRC
  end

  --callback
  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.Funcs.SetSavedSetting("SpeedRC",value)
      local tab = UICity.labels.Rover or empty_table
      for i = 1, #tab do
        --tab[i]:SetMoveSpeed(value)
        pf.SetStepLen(tab[i],value)
      end

      ChoGGi.Funcs.WriteSettings()
      ChoGGi.Funcs.MsgPopup("Selected: " .. choice[1].text,
        "RCs",UsualIcon2
      )
    end
  end

  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"RC Move Speed","Current: " .. hint)
end

function ChoGGi.MenuFuncs.SetDroneAmountDroneHub()
  local sel = SelectedObj or SelectionMouseObj() or ChoGGi.Funcs.CursorNearestObject()
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
      ChoGGi.Funcs.MsgPopup("Pick a checkbox next time...","Drones")
      return
    elseif check1 and check2 then
      ChoGGi.Funcs.MsgPopup("Don't pick both checkboxes next time...","Drones")
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

      ChoGGi.Funcs.MsgPopup("Drones: " .. choice[1].text,"Drones")
    end
  end

  local hint = "Drones in hub: " .. CurrentAmount .. "\nDrone prefabs: " .. UICity.drone_prefabs
  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"Change Amount Of Drones",hint,nil,"Add","Check this to add drones to hub","Dismantle","Check this to dismantle drones in hub")
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
    ChoGGi.Funcs.SetSavedSetting("DroneFactoryBuildSpeed",value)

    ChoGGi.Funcs.WriteSettings()
    ChoGGi.Funcs.MsgPopup("Build Speed: " .. choice[1].text,
      "Drones",UsualIcon
    )
  end

  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Drone Factory Build Speed","Current: " .. hint)
end

function ChoGGi.MenuFuncs.DroneBatteryInfinite_Toggle()
  ChoGGi.Funcs.SetConstsG("DroneMoveBatteryUse",ChoGGi.Funcs.NumRetBool(Consts.DroneMoveBatteryUse,0,ChoGGi.Consts.DroneMoveBatteryUse))
  ChoGGi.Funcs.SetConstsG("DroneCarryBatteryUse",ChoGGi.Funcs.NumRetBool(Consts.DroneCarryBatteryUse,0,ChoGGi.Consts.DroneCarryBatteryUse))
  ChoGGi.Funcs.SetConstsG("DroneConstructBatteryUse",ChoGGi.Funcs.NumRetBool(Consts.DroneConstructBatteryUse,0,ChoGGi.Consts.DroneConstructBatteryUse))
  ChoGGi.Funcs.SetConstsG("DroneBuildingRepairBatteryUse",ChoGGi.Funcs.NumRetBool(Consts.DroneBuildingRepairBatteryUse,0,ChoGGi.Consts.DroneBuildingRepairBatteryUse))
  ChoGGi.Funcs.SetConstsG("DroneDeconstructBatteryUse",ChoGGi.Funcs.NumRetBool(Consts.DroneDeconstructBatteryUse,0,ChoGGi.Consts.DroneDeconstructBatteryUse))
  ChoGGi.Funcs.SetConstsG("DroneTransformWasteRockObstructorToStockpileBatteryUse",ChoGGi.Funcs.NumRetBool(Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse,0,ChoGGi.Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse))
  ChoGGi.Funcs.SetSavedSetting("DroneMoveBatteryUse",Consts.DroneMoveBatteryUse)
  ChoGGi.Funcs.SetSavedSetting("DroneCarryBatteryUse",Consts.DroneCarryBatteryUse)
  ChoGGi.Funcs.SetSavedSetting("DroneConstructBatteryUse",Consts.DroneConstructBatteryUse)
  ChoGGi.Funcs.SetSavedSetting("DroneBuildingRepairBatteryUse",Consts.DroneBuildingRepairBatteryUse)
  ChoGGi.Funcs.SetSavedSetting("DroneDeconstructBatteryUse",Consts.DroneDeconstructBatteryUse)
  ChoGGi.Funcs.SetSavedSetting("DroneTransformWasteRockObstructorToStockpileBatteryUse",Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse)

  ChoGGi.Funcs.WriteSettings()
  ChoGGi.Funcs.MsgPopup(tostring(ChoGGi.UserSettings.DroneMoveBatteryUse) .. ": What happens when the drones get into your Jolt Cola supply...",
    "Drones",UsualIcon
  )
end

function ChoGGi.MenuFuncs.DroneBuildSpeed_Toggle()
  ChoGGi.Funcs.SetConstsG("DroneConstructAmount",ChoGGi.Funcs.ValueRetOpp(Consts.DroneConstructAmount,999900,ChoGGi.Consts.DroneConstructAmount))
  ChoGGi.Funcs.SetConstsG("DroneBuildingRepairAmount",ChoGGi.Funcs.ValueRetOpp(Consts.DroneBuildingRepairAmount,999900,ChoGGi.Consts.DroneBuildingRepairAmount))
  ChoGGi.Funcs.SetSavedSetting("DroneConstructAmount",Consts.DroneConstructAmount)
  ChoGGi.Funcs.SetSavedSetting("DroneBuildingRepairAmount",Consts.DroneBuildingRepairAmount)

  ChoGGi.Funcs.WriteSettings()
  ChoGGi.Funcs.MsgPopup(tostring(ChoGGi.UserSettings.DroneConstructAmount) .. ": What happens when the drones get into your Jolt Cola supply... and drink it",
    "Drones",UsualIcon
  )
end

function ChoGGi.MenuFuncs.RCRoverDroneRechargeFree_Toggle()
  ChoGGi.Funcs.SetConstsG("RCRoverDroneRechargeCost",ChoGGi.Funcs.NumRetBool(Consts.RCRoverDroneRechargeCost,0,ChoGGi.Consts.RCRoverDroneRechargeCost))
  ChoGGi.Funcs.SetSavedSetting("RCRoverDroneRechargeCost",Consts.RCRoverDroneRechargeCost)

  ChoGGi.Funcs.WriteSettings()
  ChoGGi.Funcs.MsgPopup(tostring(ChoGGi.UserSettings.RCRoverDroneRechargeCost) .. ": More where that came from",
    "RCs",UsualIcon2
  )
end

function ChoGGi.MenuFuncs.RCTransportInstantTransfer_Toggle()
  ChoGGi.Funcs.SetConstsG("RCRoverTransferResourceWorkTime",ChoGGi.Funcs.NumRetBool(Consts.RCRoverTransferResourceWorkTime,0,ChoGGi.Consts.RCRoverTransferResourceWorkTime))
  ChoGGi.Funcs.SetConstsG("RCTransportGatherResourceWorkTime",ChoGGi.Funcs.NumRetBool(Consts.RCTransportGatherResourceWorkTime,0,ChoGGi.Funcs.GetRCTransportGatherResourceWorkTime()))
  ChoGGi.Funcs.SetSavedSetting("RCRoverTransferResourceWorkTime",Consts.RCRoverTransferResourceWorkTime)
  ChoGGi.Funcs.SetSavedSetting("RCTransportGatherResourceWorkTime",Consts.RCTransportGatherResourceWorkTime)

  ChoGGi.Funcs.WriteSettings()
  ChoGGi.Funcs.MsgPopup(tostring(ChoGGi.UserSettings.RCRoverTransferResourceWorkTime) .. ": Slight of hand",
    "RCs","UI/Icons/IPButtons/resources_section.tga"
  )
end

function ChoGGi.MenuFuncs.DroneMeteorMalfunction_Toggle()
  ChoGGi.Funcs.SetConstsG("DroneMeteorMalfunctionChance",ChoGGi.Funcs.NumRetBool(Consts.DroneMeteorMalfunctionChance,0,ChoGGi.Consts.DroneMeteorMalfunctionChance))
  ChoGGi.Funcs.SetSavedSetting("DroneMeteorMalfunctionChance",Consts.DroneMeteorMalfunctionChance)

  ChoGGi.Funcs.WriteSettings()
  ChoGGi.Funcs.MsgPopup(tostring(ChoGGi.UserSettings.DroneMeteorMalfunctionChance) .. ": I'm singing in the rain. Just singin' in the rain. What a glorious feeling.",
    "Drones","UI/Icons/Notifications/meteor_storm.tga"
  )
end

function ChoGGi.MenuFuncs.DroneRechargeTime_Toggle()
  ChoGGi.Funcs.SetConstsG("DroneRechargeTime",ChoGGi.Funcs.NumRetBool(Consts.DroneRechargeTime,0,ChoGGi.Consts.DroneRechargeTime))
  ChoGGi.Funcs.SetSavedSetting("DroneRechargeTime",Consts.DroneRechargeTime)

  ChoGGi.Funcs.WriteSettings()
  ChoGGi.Funcs.MsgPopup(tostring(ChoGGi.UserSettings.DroneRechargeTime) .. "\nWell, if jacking on'll make strangers think I'm cool, I'll do it!",
    "Drones","UI/Icons/Notifications/low_battery.tga",true
  )
end

function ChoGGi.MenuFuncs.DroneRepairSupplyLeak_Toggle()
  ChoGGi.Funcs.SetConstsG("DroneRepairSupplyLeak",ChoGGi.Funcs.ValueRetOpp(Consts.DroneRepairSupplyLeak,1,ChoGGi.Consts.DroneRepairSupplyLeak))
  ChoGGi.Funcs.SetSavedSetting("DroneRepairSupplyLeak",Consts.DroneRepairSupplyLeak)

  ChoGGi.Funcs.WriteSettings()
  ChoGGi.Funcs.MsgPopup(tostring(ChoGGi.UserSettings.DroneRepairSupplyLeak) .. ": You know what they say about leaky pipes",
    "Drones",UsualIcon
  )
end

function ChoGGi.MenuFuncs.SetDroneCarryAmount()
  --retrieve default
  local DefaultSetting = ChoGGi.Funcs.GetDroneResourceCarryAmount()
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
      ChoGGi.Funcs.SetConstsG("DroneResourceCarryAmount",value)
      UpdateDroneResourceUnits()
      ChoGGi.Funcs.SetSavedSetting("DroneResourceCarryAmount",value)

      ChoGGi.Funcs.WriteSettings()
      ChoGGi.Funcs.MsgPopup("Drones can carry: " .. choice[1].text .. " items.",
        "Drones",UsualIcon
      )
    end
  end

  hint = "Current capacity: " .. hint .. "\n\n" .. hinttoolarge .. "\n\nMax: 1000."
  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Drone Carry Capacity",hint)
end

function ChoGGi.MenuFuncs.SetDronesPerDroneHub()
  local DefaultSetting = ChoGGi.Funcs.GetCommandCenterMaxDrones()
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
      ChoGGi.Funcs.SetConstsG("CommandCenterMaxDrones",value)
      ChoGGi.Funcs.SetSavedSetting("CommandCenterMaxDrones",value)

      ChoGGi.Funcs.WriteSettings()
      ChoGGi.Funcs.MsgPopup("DroneHubs can control: " .. choice[1].text .. " drones.",
        "RCs",UsualIcon
      )
    end
  end

  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set DroneHub Drone Capacity","Current capacity: " .. hint)
end

function ChoGGi.MenuFuncs.SetDronesPerRCRover()
  local DefaultSetting = ChoGGi.Funcs.GetRCRoverMaxDrones()
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
      ChoGGi.Funcs.SetConstsG("RCRoverMaxDrones",value)
      ChoGGi.Funcs.SetSavedSetting("RCRoverMaxDrones",value)

      ChoGGi.Funcs.WriteSettings()
      ChoGGi.Funcs.MsgPopup("RC Rovers can control: " .. choice[1].text .. " drones.",
        "RCs",UsualIcon2
      )
    end
  end

  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set RC Rover Drone Capacity","Current capacity: " .. hint)
end

--somewhere above 2000 it will fuck the save (different amounts depending on the unit type (is it a height thing?)
function ChoGGi.MenuFuncs.SetRCTransportStorageCapacity()
  --retrieve default
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.Funcs.GetRCTransportStorageCapacity() / r
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
      ChoGGi.Funcs.SetSavedSetting("RCTransportStorageCapacity",value)

      ChoGGi.Funcs.WriteSettings()
      ChoGGi.Funcs.MsgPopup("RC Transport capacity is now: " .. choice[1].text,
        "RCs","UI/Icons/bmc_building_storages_shine.tga"
      )
    end
  end
  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set RC Transport Capacity","Current capacity: " .. hint)
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
      ChoGGi.Funcs.SetSavedSetting("StorageShuttle",value)

      ChoGGi.Funcs.WriteSettings()
      ChoGGi.Funcs.MsgPopup("Shuttle storage is now: " .. choice[1].text,
        "Shuttle",UsualIcon3
      )
    end
  end
  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Cargo Shuttle Capacity","Current capacity: " .. hint)
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
      ChoGGi.Funcs.SetSavedSetting("SpeedShuttle",value)

      ChoGGi.Funcs.WriteSettings()
      ChoGGi.Funcs.MsgPopup("Shuttle speed is now: " .. choice[1].text,
        "Shuttle",UsualIcon3
      )
    end
  end
  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Cargo Shuttle Speed","Current speed: " .. hint)
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

    ChoGGi.Funcs.WriteSettings()
    ChoGGi.Funcs.MsgPopup("ShuttleHub shuttle capacity is now: " .. choice[1].text,
      "Shuttle",UsualIcon3
    )
  end

  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set ShuttleHub Shuttle Capacity","Current capacity: " .. hint)
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
      ChoGGi.Funcs.SetSavedSetting("GravityRC",value)

      ChoGGi.Funcs.WriteSettings()
      ChoGGi.Funcs.MsgPopup("RC gravity is now: " .. choice[1].text,
        "RCs",UsualIcon2
      )
    end
  end
  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set RC Gravity","Current gravity: " .. hint)
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
      ChoGGi.Funcs.SetSavedSetting("GravityDrone",value)

      ChoGGi.Funcs.WriteSettings()
      ChoGGi.Funcs.MsgPopup("RC gravity is now: " .. choice[1].text,
        "RCs",UsualIcon2
      )
    end
  end
  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Drone Gravity","Current gravity: " .. hint)
end
