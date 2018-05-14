local CCodeFuncs = ChoGGi.CodeFuncs
local CComFuncs = ChoGGi.ComFuncs
local CConsts = ChoGGi.Consts
local CInfoFuncs = ChoGGi.InfoFuncs
local CSettingFuncs = ChoGGi.SettingFuncs
local CTables = ChoGGi.Tables
local CMenuFuncs = ChoGGi.MenuFuncs

--funcs under Gameplay menu without a separate file

local UsualIcon = "UI/Icons/Sections/storage.tga"
local UsualIcon2 = "UI/Icons/Upgrades/home_collective_04.tga"

function CMenuFuncs.StorageMechanizedDepotsTemp_Toggle()
  ChoGGi.UserSettings.StorageMechanizedDepotsTemp = not ChoGGi.UserSettings.StorageMechanizedDepotsTemp

  local amount
  if not ChoGGi.UserSettings.StorageMechanizedDepotsTemp then
    amount = 5
  end
  local tab = UICity.labels.MechanizedDepots or empty_table
  for i = 1, #tab do
    CCodeFuncs.SetMechanizedDepotTempAmount(tab[i],amount)
  end

  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup("Temp Storage: " .. tostring(ChoGGi.UserSettings.StorageMechanizedDepotsTemp),
    "Storage",UsualIcon
  )

end

function CMenuFuncs.SetRocketCargoCapacity()
  local DefaultSetting = CCodeFuncs.GetCargoCapacity()
  local ItemList = {
    {text = " Default: " .. DefaultSetting .. " kg",value = DefaultSetting},
    {text = "50 000 kg",value = 50000},
    {text = "100 000 kg",value = 100000},
    {text = "250 000 kg",value = 250000},
    {text = "500 000 kg",value = 500000},
    {text = "1 000 000 kg",value = 1000000},
    {text = "10 000 000 kg",value = 10000000},
    {text = "100 000 000 kg",value = 100000000},
    {text = "1 000 000 000 kg",value = 1000000000},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      CComFuncs.SetConstsG("CargoCapacity",value)
      CComFuncs.SetSavedSetting("CargoCapacity",value)

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup(choice[1].text .. ": I can still see some space",
        "Rocket","UI/Icons/Sections/spaceship.tga"
      )
    end
  end

  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Rocket Cargo Capacity","Current capacity: " .. Consts.CargoCapacity)
end

function CMenuFuncs.SetRocketTravelTime()
  local r = CConsts.ResourceScale
  local DefaultSetting = CCodeFuncs.GetTravelTimeEarthMars() / r
  local ItemList = {
    {text = " Instant",value = 0},
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = " Original: " .. 750,value = 750},
    {text = " Half of Original: " .. 375,value = 375},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 150,value = 150},
    {text = 200,value = 200},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
  }

  --other hint type
  local hint = DefaultSetting
  if ChoGGi.UserSettings.TravelTimeEarthMars then
    hint = ChoGGi.UserSettings.TravelTimeEarthMars / r
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      local value = value * r
      CComFuncs.SetConstsG("TravelTimeEarthMars",value)
      CComFuncs.SetConstsG("TravelTimeMarsEarth",value)
      CComFuncs.SetSavedSetting("TravelTimeEarthMars",value)
      CComFuncs.SetSavedSetting("TravelTimeMarsEarth",value)

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup("88 MPH: " .. choice[1].text,
        "Rocket","UI/Upgrades/autoregulator_04/timer.tga"
      )
    end
  end

  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Rocket Travel Time","Current: " .. hint)
end

function CMenuFuncs.SetColonistsPerRocket()
  local DefaultSetting = CCodeFuncs.GetMaxColonistsPerRocket()
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 10000,value = 10000},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      CComFuncs.SetConstsG("MaxColonistsPerRocket",value)
      CComFuncs.SetSavedSetting("MaxColonistsPerRocket",value)

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup(choice[1].text .. ": Long pig sardines",
        "Rocket","UI/Icons/Notifications/colonist.tga"
      )
    end
  end

  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Colonist Capacity","Current capacity: " .. Consts.MaxColonistsPerRocket)
end

function CMenuFuncs.SetWorkerCapacity()
  if not SelectedObj or not SelectedObj.base_max_workers then
    CComFuncs.MsgPopup("You need to select a building that has workers.",
      "Worker Capacity",UsualIcon
    )
    return
  end
  local sel = SelectedObj
  local DefaultSetting = sel.base_max_workers
  local hint_toolarge = "Warning: Above a thousand is laggy (above 60K may crash)."

  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000,hint = hint_toolarge},
    {text = 2000,value = 2000,hint = hint_toolarge},
    {text = 3000,value = 3000,hint = hint_toolarge},
    {text = 4000,value = 4000,hint = hint_toolarge},
    {text = 5000,value = 5000,hint = hint_toolarge},
    {text = 10000,value = 10000,hint = hint_toolarge},
    {text = 25000,value = 25000,hint = hint_toolarge},
  }

  --check if there's an entry for building
  if not ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id] then
    ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id] = {}
  end

  local hint = DefaultSetting
  local setting = ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id]
  if setting and setting.workers then
    hint = tostring(setting.workers)
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then

      local tab = UICity.labels.Workplace or empty_table
      for i = 1, #tab do
        if tab[i].encyclopedia_id == sel.encyclopedia_id then
          tab[i].max_workers = value
        end
      end

      if value == DefaultSetting then
        ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id].workers = nil
      else
        ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id].workers = value
      end

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup(sel.encyclopedia_id .. " Capacity is now " .. choice[1].text,
        "Worker Capacity",UsualIcon
      )
    end
  end

  hint = "Current capacity: " .. hint .. "\n\n" .. hint_toolarge
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sel.encyclopedia_id .. " Worker Capacity",hint)
end

function CMenuFuncs.SetBuildingCapacity()
  local sel = SelectedObj
  if not sel or (type(sel.GetStoredWater) == "nil" and type(sel.GetStoredAir) == "nil" and type(sel.GetStoredPower) == "nil" and type(sel.GetUIResidentsCount) == "nil") then
    CComFuncs.MsgPopup("You need to select a building that has capacity.",
      "Building Capacity",UsualIcon
    )
    return
  end
  local r = CConsts.ResourceScale
  local hint_toolarge = "Warning For Colonist Capacity: Above a thousand is laggy (above 60K may crash)."

  --get type of capacity
  local CapType
  if type(sel.GetStoredAir) == "function" then
    CapType = "air"
  elseif type(sel.GetStoredWater) == "function" then
    CapType = "water"
  elseif type(sel.GetStoredPower) == "function" then
    CapType = "electricity"
  elseif type(sel.GetUIResidentsCount) == "function" then
    CapType = "colonist"
  end

  --get default amount
  local DefaultSetting
  if CapType == "electricity" or CapType == "colonist" then
    DefaultSetting = sel.base_capacity
  else
    DefaultSetting = sel["base_" .. CapType .. "_capacity"]
  end

  if CapType ~= "colonist" then
    DefaultSetting = DefaultSetting / r
  end

  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000,hint = hint_toolarge},
    {text = 2000,value = 2000,hint = hint_toolarge},
    {text = 3000,value = 3000,hint = hint_toolarge},
    {text = 4000,value = 4000,hint = hint_toolarge},
    {text = 5000,value = 5000,hint = hint_toolarge},
    {text = 10000,value = 10000,hint = hint_toolarge},
    {text = 25000,value = 25000,hint = hint_toolarge},
    {text = 50000,value = 50000,hint = hint_toolarge},
    {text = 100000,value = 100000,hint = hint_toolarge},
  }

  --check if there's an entry for building
  if not ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id] then
    ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id] = {}
  end

  local hint = DefaultSetting
  local setting = ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id]
  if setting and setting.capacity then
    if CapType ~= "colonist" then
      hint = tostring(setting.capacity / r)
    else
      hint = tostring(setting.capacity)
    end
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then

      --colonist cap doesn't use res scale
      local amount
      if CapType == "colonist" then
        amount = value
      else
        amount = value * r
      end

      local function StoredAmount(prod,current)
        if prod:GetStoragePercent() == 0 then
          return "empty"
        elseif prod:GetStoragePercent() == 100 then
          return "full"
        elseif current == "discharging" then
          return "discharging"
        else
          return "charging"
        end
      end
      --updating time
      if CapType == "electricity" then
        local tab = UICity.labels.Power or empty_table
        for i = 1, #tab do
          if tab[i].encyclopedia_id == sel.encyclopedia_id then
            tab[i].capacity = amount
            tab[i][CapType].storage_capacity = amount
            tab[i][CapType].storage_mode = StoredAmount(tab[i][CapType],tab[i][CapType].storage_mode)
            CCodeFuncs.ToggleWorking(tab[i])
          end
        end

      elseif CapType == "colonist" then
        local tab = UICity.labels.Residence or empty_table
        for i = 1, #tab do
          if tab[i].encyclopedia_id == sel.encyclopedia_id then
            tab[i].capacity = amount
          end
        end

      else --water and air
        local tab = UICity.labels["Life-Support"] or empty_table
        for i = 1, #tab do
          if tab[i].encyclopedia_id == sel.encyclopedia_id then
            tab[i][CapType .. "_capacity"] = amount
            tab[i][CapType].storage_capacity = amount
            tab[i][CapType].storage_mode = StoredAmount(tab[i][CapType],tab[i][CapType].storage_mode)
            CCodeFuncs.ToggleWorking(tab[i])
          end
        end
      end

      if value == DefaultSetting then
        setting.capacity = nil
      else
        setting.capacity = amount
      end

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup(sel.encyclopedia_id .. " Capacity is now " .. choice[1].text,
        "Buildings",UsualIcon
      )
    end

  end

  hint = "Current capacity: " .. hint .. "\n\n" .. hint_toolarge
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sel.encyclopedia_id .. " Capacity",hint)
end --SetBuildingCapacity

function CMenuFuncs.SetVisitorCapacity()
  local sel = SelectedObj
  if not sel or (sel and not sel.base_max_visitors) then
    CComFuncs.MsgPopup("You need to select something that has space for visitors.",
      "Buildings",UsualIcon2
    )
    return
  end
  local DefaultSetting = sel.base_max_visitors
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
  }

  --check if there's an entry for building
  if not ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id] then
    ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id] = {}
  end

  local hint = DefaultSetting
  local setting = ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id]
  if setting and setting.visitors then
    hint = tostring(setting.visitors)
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      local tab = UICity.labels.BuildingNoDomes or empty_table
      for i = 1, #tab do
        if tab[i].encyclopedia_id == sel.encyclopedia_id then
          tab[i].max_visitors = value
        end
      end

      if value == DefaultSetting then
        ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id].visitors = nil
      else
        ChoGGi.UserSettings.BuildingSettings[sel.encyclopedia_id].visitors = value
      end

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup(sel.encyclopedia_id .. " visitor capacity is now " .. choice[1].text,
        "Buildings",UsualIcon2
      )
    end
  end

  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sel.encyclopedia_id .. " Visitor Capacity","Current capacity: " .. hint)
end

function CMenuFuncs.SetStorageDepotSize(sType)
  local r = CConsts.ResourceScale
  local DefaultSetting = CConsts[sType] / r
  local hint_max = "Max capacity limited to:\nUniversal: 2,500\nOther: 20,000\nWaste: 1,000,000\nMechanized: 1,000,000"
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 2500,value = 2500,hint = hint_max},
    {text = 5000,value = 5000,hint = hint_max},
    {text = 10000,value = 10000,hint = hint_max},
    {text = 20000,value = 20000,hint = hint_max},
    {text = 100000,value = 100000,hint = hint_max},
    {text = 1000000,value = 1000000,hint = hint_max},
  }

  local hint = DefaultSetting
  if ChoGGi.UserSettings[sType] then
    hint = ChoGGi.UserSettings[sType] / r
  end

  local CallBackFunc = function(choice)
    if type(choice[1].value) == "number" then

      local value = choice[1].value * r
      if sType == "StorageWasteDepot" then
        --limit amounts so saving with a full load doesn't delete your game
        if value > 1000000000 then
          value = 1000000000 --might be safe above a million, but I figured I'd stop somewhere
        end
        --loop through and change all existing

        local tab = UICity.labels.WasteRockDumpSite or empty_table
        for i = 1, #tab do
          tab[i].max_amount_WasteRock = value
          if tab[i]:GetStoredAmount() < 0 then
            tab[i]:CheatEmpty()
            tab[i]:CheatFill()
          end
        end
      elseif sType == "StorageOtherDepot" then
        if value > 20000000 then
          value = 20000000
        end
        local tab = UICity.labels.UniversalStorageDepot or empty_table
        for i = 1, #tab do
          if tab[i].entity ~= "StorageDepot" then
            tab[i].max_storage_per_resource = value
          end
        end
        local function OtherDepot(label,res)
          local tab = UICity.labels[label] or empty_table
          for i = 1, #tab do
            tab[i][res] = value
          end
        end
        OtherDepot("MysteryResource","max_storage_per_resource")
        OtherDepot("BlackCubeDumpSite","max_amount_BlackCube")
      elseif sType == "StorageUniversalDepot" then
        if value > 2500000 then
          value = 2500000 --can go to 2900, but I got a crash; which may have been something else, but it's only 400
        end
        local tab = UICity.labels.UniversalStorageDepot or empty_table
        for i = 1, #tab do
          if tab[i].entity == "StorageDepot" then
            tab[i].max_storage_per_resource = value
          end
        end
      elseif sType == "StorageMechanizedDepot" then
        if value > 1000000000 then
          value = 1000000000 --might be safe above a million, but I figured I'd stop somewhere
        end
        local tab = UICity.labels.MechanizedDepots or empty_table
        for i = 1, #tab do
          tab[i].max_storage_per_resource = value
        end
      end
      --for new buildings
      CComFuncs.SetSavedSetting(sType,value)

      CSettingFuncs.WriteSettings()
      CComFuncs.MsgPopup(sType .. ": " ..  choice[1].text,
        "Storage","UI/Icons/Sections/basic.tga"
      )
    end
  end
  CCodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. " Size","Current capacity: " .. hint .. "\n\n" .. hint_max)
end

---------fixes
function CMenuFuncs.DronesKeepTryingBlockedRocks()
  local function ResetPriorityQueue(Class)
    local Hubs = GetObjects({class=Class}) or empty_table
    for i = 1, #Hubs do
      Hubs[i].priority_queue = {}
      for priority = -1, const.MaxBuildingPriority do
        Hubs[i].priority_queue[priority] = {}
      end
      Hubs[i]:AddBuilding(FindNearestObject(GetObjects({class="ConstructionSite"}),Hubs[i]))
    end
  end
  ResetPriorityQueue("SupplyRocket")
  ResetPriorityQueue("RCRover")
  ResetPriorityQueue("DroneHub")

  CComFuncs.MsgPopup("Hubs reset","Rocks")
end

function CMenuFuncs.AlignAllBuildingsToHexGrid()
  local Table = GetObjects({class="Building"})
  if Table[1] and Table[1].class then
    for i = 1, #Table do
      Table[i]:SetPos(HexGetNearestCenter(Table[i]:GetPos()))
    end
    CComFuncs.MsgPopup("Buildings aligned to grid.","Grid")
  end
end

function CMenuFuncs.RemoveUnreachableConstructionSites()
  local function RemoveUnreachable(Class)
    local Table = GetObjects({class=Class}) or empty_table
    for i = 1, #Table do
      for Bld,_ in pairs(Table[i].unreachable_buildings or empty_table) do
        if IsKindOf(Bld,"ConstructionSite") then
          Bld:Cancel()
        end
      end
    end
  end

  RemoveUnreachable("DroneHub")
  RemoveUnreachable("RCRover")
  RemoveUnreachable("SupplyRocket")
  CComFuncs.MsgPopup("Removed unreachable","Sites")
end

function CMenuFuncs.RemoveYellowGridMarks()
  local Table = GetObjects({class="GridTile"})
  if Table[1] and Table[1].class and Table[1].class == "GridTile" then
    for i = 1, #Table do
      Table[i]:delete()
    end
  end
  CComFuncs.MsgPopup("Grid marks removed","Grid")
end

function CMenuFuncs.DroneResourceCarryAmountFix_Toggle()
  ChoGGi.UserSettings.DroneResourceCarryAmountFix = not ChoGGi.UserSettings.DroneResourceCarryAmountFix
  CSettingFuncs.WriteSettings()
  CComFuncs.MsgPopup("Drone Carry Fix: " .. tostring(ChoGGi.UserSettings.DroneResourceCarryAmountFix),
    "Drones","UI/Icons/IPButtons/drone.tga"
  )
end

function CMenuFuncs.ProjectMorpheusRadarFellDown()
  local tab = UICity.labels.ProjectMorpheus or empty_table
  for i = 1, #tab do
    tab[i]:ChangeWorkingStateAnim(false)
    tab[i]:ChangeWorkingStateAnim(true)
  end
end

function CMenuFuncs.AttachBuildingsToNearestWorkingDome()
  local tab = UICity.labels.Residence or empty_table
  for i = 1, #tab do
    CCodeFuncs.AttachToNearestDome(tab[i])
  end
  tab = UICity.labels.Workplace or empty_table
  for i = 1, #tab do
    CCodeFuncs.AttachToNearestDome(tab[i])
  end

  CComFuncs.MsgPopup("Buildings attached.",
    "Buildings","UI/Icons/Sections/basic.tga"
  )
end

function CMenuFuncs.ColonistsFixBlackCube()
  local tab = UICity.labels.Colonist or empty_table
  for i = 1, #tab do
    local colonist = tab[i]
    if colonist.entity:find("Child",1,true) then
      colonist.specialist = "none"

      colonist.traits.Youth = nil
      colonist.traits.Adult = nil
      colonist.traits["Middle Aged"] = nil
      colonist.traits.Senior = nil
      colonist.traits.Retiree = nil

      colonist.traits.Child = true
      colonist.age_trait = "Child"
      colonist.age = 0
      colonist:ChooseEntity()
      colonist:SetResidence(false)
      colonist:UpdateResidence()
    end
  end
  CComFuncs.MsgPopup("Fixed black cubes",
    "Colonists",UsualIcon2
  )
end

function CMenuFuncs.RepairBrokenShit(BrokenShit)
  local JustInCase = 0
  while #BrokenShit > 0 do

    for i = 1, #BrokenShit do
      pcall(function()
        BrokenShit[i]:Repair()
      end)
    end

    if JustInCase == 10000 then
      break
    end
    JustInCase = JustInCase + 1

  end
end

function CMenuFuncs.CablesAndPipesRepair()
  CMenuFuncs.RepairBrokenShit(g_BrokenSupplyGridElements.electricity)
  CMenuFuncs.RepairBrokenShit(g_BrokenSupplyGridElements.water)
end

--[[
function CMenuFuncs.SetTriboelectricScrubberRadius(Bool)
  for _,building in iXpairs(UICity.labels.TriboelectricScrubber) do
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
  CComFuncs.MsgPopup("I see you there",
    "Buildings","UI/Icons/Upgrades/polymer_blades_04.tga"
  )
end
--]]
