local CCodeFuncs = ChoGGi.CodeFuncs
local CComFuncs = ChoGGi.ComFuncs
local CConsts = ChoGGi.Consts
local CInfoFuncs = ChoGGi.InfoFuncs
local CSettingFuncs = ChoGGi.SettingFuncs
local CTables = ChoGGi.Tables
local CMenuFuncs = ChoGGi.MenuFuncs

local UsualIcon = "UI/Icons/IPButtons/drone.tga"
local UsualIcon2 = "UI/Icons/IPButtons/transport_route.tga"
local UsualIcon3 = "UI/Icons/IPButtons/shuttle.tga"

function CMenuFuncs.SetRoverChargeRadius()
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

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup("Selected: " .. choice[1].text,
        "RC",UsualIcon2
      )
    end
  end

  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"TitleBar","Current: " .. hint)

end

function CMenuFuncs.SetRoverWorkRadius()
  local DefaultSetting = CConsts.RCRoverMaxRadius
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

      CComFuncs.SetSavedSetting("RCRoverMaxRadius",value)
      --we need to set this so the hex grid during placement is enlarged
      const.RCRoverMaxRadius = value

      local tab = UICity.labels.RCRover or empty_table
      for i = 1, #tab do
        tab[i]:SetWorkRadius(value)
      end

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.RCRoverMaxRadius) .. ": I can see for miles and miles",
        "RC","UI/Icons/Upgrades/service_bots_04.tga"
      )
    end
  end

  hint = "Current: " .. hint .. "\n\nToggle selection to update visible hex grid."
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Rover Work Radius",hint)
end

function CMenuFuncs.SetDroneHubWorkRadius()
  local DefaultSetting = CConsts.CommandCenterMaxRadius
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

      CComFuncs.SetSavedSetting("CommandCenterMaxRadius",value)
      --we need to set this so the hex grid during placement is enlarged
      const.CommandCenterMaxRadius = value

      local tab = UICity.labels.DroneHub or empty_table
      for i = 1, #tab do
        tab[i]:SetWorkRadius(value)
      end

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.CommandCenterMaxRadius) .. ": I can see for miles and miles",
        "DroneHub","UI/Icons/Upgrades/service_bots_04.tga"
      )
    end
  end

  hint = "Current: " .. hint .. "\n\nToggle selection to update visible hex grid."
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set DroneHub Work Radius",hint)
end

function CMenuFuncs.SetDroneRockToConcreteSpeed()
  local DefaultSetting = CConsts.DroneTransformWasteRockObstructorToStockpileAmount
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
      CComFuncs.SetConstsG("DroneTransformWasteRockObstructorToStockpileAmount",value)

      CComFuncs.SetSavedSetting("DroneTransformWasteRockObstructorToStockpileAmount",Consts.DroneTransformWasteRockObstructorToStockpileAmount)
      CComFuncs.MsgPopup("Selected: " .. choice[1].text,
        "Drones",UsualIcon
      )
    end
  end

  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Drone Rock To Concrete Speed","Current: " .. hint)
end

function CMenuFuncs.SetDroneMoveSpeed()
  local r = CConsts.ResourceScale
  local DefaultSetting = CConsts.SpeedDrone
  local UpgradedSetting = CCodeFuncs.GetSpeedDrone()
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
      CComFuncs.SetSavedSetting("SpeedDrone",value)

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup("Selected: " .. choice[1].text,
        "Drones",UsualIcon
      )
    end
  end

  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Drone Move Speed","Current: " .. hint)
end

function CMenuFuncs.SetRCMoveSpeed()
  local r = CConsts.ResourceScale
  local DefaultSetting = CConsts.SpeedRC
  local UpgradedSetting = CCodeFuncs.GetSpeedRC()
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
      CComFuncs.SetSavedSetting("SpeedRC",value)
      local tab = UICity.labels.Rover or empty_table
      for i = 1, #tab do
        --tab[i]:SetMoveSpeed(value)
        pf.SetStepLen(tab[i],value)
      end

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup("Selected: " .. choice[1].text,
        "RCs",UsualIcon2
      )
    end
  end

  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"RC Move Speed","Current: " .. hint)
end

function CMenuFuncs.SetDroneAmountDroneHub()
  local sel = CCodeFuncs.SelObject()
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
      CComFuncs.MsgPopup("Pick a checkbox next time...","Drones")
      return
    elseif check1 and check2 then
      CComFuncs.MsgPopup("Don't pick both checkboxes next time...","Drones")
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

      CComFuncs.MsgPopup("Drones: " .. choice[1].text,"Drones")
    end
  end

  local hint = "Drones in hub: " .. CurrentAmount .. "\nDrone prefabs: " .. UICity.drone_prefabs
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Change Amount Of Drones",hint,nil,"Add","Check this to add drones to hub","Dismantle","Check this to dismantle drones in hub")
end

function CMenuFuncs.SetDroneFactoryBuildSpeed()
  local DefaultSetting = CConsts.DroneFactoryBuildSpeed
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
    CComFuncs.SetSavedSetting("DroneFactoryBuildSpeed",value)

    CSettingFuncs.WriteSettings()
    CComFuncs.MsgPopup("Build Speed: " .. choice[1].text,
      "Drones",UsualIcon
    )
  end

  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Drone Factory Build Speed","Current: " .. hint)
end

function CMenuFuncs.DroneBatteryInfinite_Toggle()
  CComFuncs.SetConstsG("DroneMoveBatteryUse",CComFuncs.NumRetBool(Consts.DroneMoveBatteryUse,0,CConsts.DroneMoveBatteryUse))
  CComFuncs.SetConstsG("DroneCarryBatteryUse",CComFuncs.NumRetBool(Consts.DroneCarryBatteryUse,0,CConsts.DroneCarryBatteryUse))
  CComFuncs.SetConstsG("DroneConstructBatteryUse",CComFuncs.NumRetBool(Consts.DroneConstructBatteryUse,0,CConsts.DroneConstructBatteryUse))
  CComFuncs.SetConstsG("DroneBuildingRepairBatteryUse",CComFuncs.NumRetBool(Consts.DroneBuildingRepairBatteryUse,0,CConsts.DroneBuildingRepairBatteryUse))
  CComFuncs.SetConstsG("DroneDeconstructBatteryUse",CComFuncs.NumRetBool(Consts.DroneDeconstructBatteryUse,0,CConsts.DroneDeconstructBatteryUse))
  CComFuncs.SetConstsG("DroneTransformWasteRockObstructorToStockpileBatteryUse",CComFuncs.NumRetBool(Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse,0,CConsts.DroneTransformWasteRockObstructorToStockpileBatteryUse))
  CComFuncs.SetSavedSetting("DroneMoveBatteryUse",Consts.DroneMoveBatteryUse)
  CComFuncs.SetSavedSetting("DroneCarryBatteryUse",Consts.DroneCarryBatteryUse)
  CComFuncs.SetSavedSetting("DroneConstructBatteryUse",Consts.DroneConstructBatteryUse)
  CComFuncs.SetSavedSetting("DroneBuildingRepairBatteryUse",Consts.DroneBuildingRepairBatteryUse)
  CComFuncs.SetSavedSetting("DroneDeconstructBatteryUse",Consts.DroneDeconstructBatteryUse)
  CComFuncs.SetSavedSetting("DroneTransformWasteRockObstructorToStockpileBatteryUse",Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse)

  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.DroneMoveBatteryUse) .. ": What happens when the drones get into your Jolt Cola supply...",
    "Drones",UsualIcon
  )
end

function CMenuFuncs.DroneBuildSpeed_Toggle()
  CComFuncs.SetConstsG("DroneConstructAmount",CComFuncs.ValueRetOpp(Consts.DroneConstructAmount,999900,CConsts.DroneConstructAmount))
  CComFuncs.SetConstsG("DroneBuildingRepairAmount",CComFuncs.ValueRetOpp(Consts.DroneBuildingRepairAmount,999900,CConsts.DroneBuildingRepairAmount))
  CComFuncs.SetSavedSetting("DroneConstructAmount",Consts.DroneConstructAmount)
  CComFuncs.SetSavedSetting("DroneBuildingRepairAmount",Consts.DroneBuildingRepairAmount)

  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.DroneConstructAmount) .. ": What happens when the drones get into your Jolt Cola supply... and drink it",
    "Drones",UsualIcon
  )
end

function CMenuFuncs.RCRoverDroneRechargeFree_Toggle()
  CComFuncs.SetConstsG("RCRoverDroneRechargeCost",CComFuncs.NumRetBool(Consts.RCRoverDroneRechargeCost,0,CConsts.RCRoverDroneRechargeCost))
  CComFuncs.SetSavedSetting("RCRoverDroneRechargeCost",Consts.RCRoverDroneRechargeCost)

  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.RCRoverDroneRechargeCost) .. ": More where that came from",
    "RCs",UsualIcon2
  )
end

function CMenuFuncs.RCTransportInstantTransfer_Toggle()
  CComFuncs.SetConstsG("RCRoverTransferResourceWorkTime",CComFuncs.NumRetBool(Consts.RCRoverTransferResourceWorkTime,0,CConsts.RCRoverTransferResourceWorkTime))
  CComFuncs.SetConstsG("RCTransportGatherResourceWorkTime",CComFuncs.NumRetBool(Consts.RCTransportGatherResourceWorkTime,0,CCodeFuncs.GetRCTransportGatherResourceWorkTime()))
  CComFuncs.SetSavedSetting("RCRoverTransferResourceWorkTime",Consts.RCRoverTransferResourceWorkTime)
  CComFuncs.SetSavedSetting("RCTransportGatherResourceWorkTime",Consts.RCTransportGatherResourceWorkTime)

  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.RCRoverTransferResourceWorkTime) .. ": Slight of hand",
    "RCs","UI/Icons/IPButtons/resources_section.tga"
  )
end

function CMenuFuncs.DroneMeteorMalfunction_Toggle()
  CComFuncs.SetConstsG("DroneMeteorMalfunctionChance",CComFuncs.NumRetBool(Consts.DroneMeteorMalfunctionChance,0,CConsts.DroneMeteorMalfunctionChance))
  CComFuncs.SetSavedSetting("DroneMeteorMalfunctionChance",Consts.DroneMeteorMalfunctionChance)

  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.DroneMeteorMalfunctionChance) .. ": I'm singing in the rain. Just singin' in the rain. What a glorious feeling.",
    "Drones","UI/Icons/Notifications/meteor_storm.tga"
  )
end

function CMenuFuncs.DroneRechargeTime_Toggle()
  CComFuncs.SetConstsG("DroneRechargeTime",CComFuncs.NumRetBool(Consts.DroneRechargeTime,0,CConsts.DroneRechargeTime))
  CComFuncs.SetSavedSetting("DroneRechargeTime",Consts.DroneRechargeTime)

  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.DroneRechargeTime) .. "\nWell, if jacking on'll make strangers think I'm cool, I'll do it!",
    "Drones","UI/Icons/Notifications/low_battery.tga",true
  )
end

function CMenuFuncs.DroneRepairSupplyLeak_Toggle()
  CComFuncs.SetConstsG("DroneRepairSupplyLeak",CComFuncs.ValueRetOpp(Consts.DroneRepairSupplyLeak,1,CConsts.DroneRepairSupplyLeak))
  CComFuncs.SetSavedSetting("DroneRepairSupplyLeak",Consts.DroneRepairSupplyLeak)

  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.DroneRepairSupplyLeak) .. ": You know what they say about leaky pipes",
    "Drones",UsualIcon
  )
end

function CMenuFuncs.SetDroneCarryAmount()
  --retrieve default
  local DefaultSetting = CCodeFuncs.GetDroneResourceCarryAmount()
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
      CComFuncs.SetConstsG("DroneResourceCarryAmount",value)
      UpdateDroneResourceUnits()
      CComFuncs.SetSavedSetting("DroneResourceCarryAmount",value)

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup("Drones can carry: " .. choice[1].text .. " items.",
        "Drones",UsualIcon
      )
    end
  end

  hint = "Current capacity: " .. hint .. "\n\n" .. hinttoolarge .. "\n\nMax: 1000."
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Drone Carry Capacity",hint)
end

function CMenuFuncs.SetDronesPerDroneHub()
  local DefaultSetting = CCodeFuncs.GetCommandCenterMaxDrones()
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
      CComFuncs.SetConstsG("CommandCenterMaxDrones",value)
      CComFuncs.SetSavedSetting("CommandCenterMaxDrones",value)

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup("DroneHubs can control: " .. choice[1].text .. " drones.",
        "RCs",UsualIcon
      )
    end
  end

  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set DroneHub Drone Capacity","Current capacity: " .. hint)
end

function CMenuFuncs.SetDronesPerRCRover()
  local DefaultSetting = CCodeFuncs.GetRCRoverMaxDrones()
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
      CComFuncs.SetConstsG("RCRoverMaxDrones",value)
      CComFuncs.SetSavedSetting("RCRoverMaxDrones",value)

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup("RC Rovers can control: " .. choice[1].text .. " drones.",
        "RCs",UsualIcon2
      )
    end
  end

  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set RC Rover Drone Capacity","Current capacity: " .. hint)
end

--somewhere above 2000 it will fuck the save (different amounts depending on the unit type (is it a height thing?)
function CMenuFuncs.SetRCTransportStorageCapacity()
  --retrieve default
  local r = CConsts.ResourceScale
  local DefaultSetting = CCodeFuncs.GetRCTransportStorageCapacity() / r
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
      CComFuncs.SetSavedSetting("RCTransportStorageCapacity",value)

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup("RC Transport capacity is now: " .. choice[1].text,
        "RCs","UI/Icons/bmc_building_storages_shine.tga"
      )
    end
  end
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set RC Transport Capacity","Current capacity: " .. hint)
end

function CMenuFuncs.SetShuttleCapacity()
  local r = CConsts.ResourceScale
  local DefaultSetting = CConsts.StorageShuttle / r
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
      CComFuncs.SetSavedSetting("StorageShuttle",value)

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup("Shuttle storage is now: " .. choice[1].text,
        "Shuttle",UsualIcon3
      )
    end
  end
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Cargo Shuttle Capacity","Current capacity: " .. hint)
end

function CMenuFuncs.SetShuttleSpeed()
  --retrieve default
  local r = CConsts.ResourceScale
  local DefaultSetting = CConsts.SpeedShuttle / r
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
      CComFuncs.SetSavedSetting("SpeedShuttle",value)

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup("Shuttle speed is now: " .. choice[1].text,
        "Shuttle",UsualIcon3
      )
    end
  end
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Cargo Shuttle Speed","Current speed: " .. hint)
end

function CMenuFuncs.SetShuttleHubShuttleCapacity()
  --retrieve default
  local DefaultSetting = CConsts.ShuttleHubShuttleCapacity
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

    CSettingFuncs.WriteSettings()
    CComFuncs.MsgPopup("ShuttleHub shuttle capacity is now: " .. choice[1].text,
      "Shuttle",UsualIcon3
    )
  end

  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set ShuttleHub Shuttle Capacity","Current capacity: " .. hint)
end

function CMenuFuncs.SetGravityRC()
  --retrieve default
  local DefaultSetting = CConsts.GravityRC
  local r = CConsts.ResourceScale
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
      CComFuncs.SetSavedSetting("GravityRC",value)

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup("RC gravity is now: " .. choice[1].text,
        "RCs",UsualIcon2
      )
    end
  end
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set RC Gravity","Current gravity: " .. hint)
end

function CMenuFuncs.SetGravityDrones()
  --retrieve default
  local DefaultSetting = CConsts.GravityDrone
  local r = CConsts.ResourceScale
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
      CComFuncs.SetSavedSetting("GravityDrone",value)

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup("RC gravity is now: " .. choice[1].text,
        "RCs",UsualIcon2
      )
    end
  end
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Drone Gravity","Current gravity: " .. hint)
end
