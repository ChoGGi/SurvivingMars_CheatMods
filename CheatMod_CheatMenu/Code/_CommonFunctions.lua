--any functions called from Code/*.lua

function ChoGGi.AttachToNearestDome(building)
  --ignore outdoor buildings
  if building.dome_required ~= true then
    return
  end
  --dome ruins don't have air/water/elec
  if (building.parent_dome and not building.parent_dome.air) or not building.parent_dome then
    --find the nearest working dome
    local dome = FindNearestObject(UICity.labels.Domes_Working,building)
    if dome and dome.labels then
      building.parent_dome = dome
      --which type is it (check for getlabels or some such)
      if building.closed_shifts then
        table.insert(dome.labels.Workplace,building)
      elseif building.colonists then
        table.insert(dome.labels.Residence,building)
      end
    end
  end
end

function ChoGGi.SetProductionToSavedAmt()
  for _,building in ipairs(UICity.labels.BuildingNoDomes or empty_table) do
    if ChoGGi.CheatMenuSettings.BuildingsProduction[building.encyclopedia_id] then
      local amount = ChoGGi.CheatMenuSettings.BuildingsProduction[building.encyclopedia_id]
      pcall(function()
        if building.base_air_production then
          building.air:SetProduction(amount)
          building.air_production = amount
        elseif building.base_water_production then
          building.water:SetProduction(amount)
          building.water_production = amount
        elseif building.base_electricity_production then
          building.electricity:SetProduction(amount)
          building.electricity_production = amount
        elseif building.producers then
          building.producers[1].production_per_day = amount
          building.production_per_day1 = amount
        end
      end)
    end
  end
end

--toggle working status
function ChoGGi.ToggleWorking(building)
  building:ToggleWorking()
  building:ToggleWorking()
end

function ChoGGi.SetCameraSettings()
--cameraRTS.GetProperties(1)

  --reduce ScrollBorder to the smallest we can (1 or 2 = can't scroll down)
  if ChoGGi.CheatMenuSettings.BorderScrollingArea then
    cameraRTS.SetProperties(1,{ScrollBorder = 3})
  --disable border scrolling
  elseif ChoGGi.CheatMenuSettings.BorderScrollingToggle then
    cameraRTS.SetProperties(1,{ScrollBorder = 0})
  else
  --default
    cameraRTS.SetProperties(1,{ScrollBorder = 5})
  end

  --zoom
  --camera.GetFovY()
  --camera.GetFovX()
  if ChoGGi.CheatMenuSettings.CameraZoomToggle then
    cameraRTS.SetZoomLimits(0,24000)
    --5760x1080 doesn't get the correct zoom size till after zooming out
    if UIL.GetScreenSize():x() == 5760 then
      camera.SetFovY(2580)
      camera.SetFovX(7745)
    end
  else
    cameraRTS.SetZoomLimits(400,8000)
  end

  --cameraRTS.SetProperties(1,{HeightInertia = 0})
end

function ChoGGi.RemoveOldFiles()
  local Table = {
    "CheatMenuSettings",
    "ConsoleExec",
    "FuncsCheats",
    "FuncsDebug",
    "FuncsGameplayBuildings",
    "FuncsGameplayColonists",
    "FuncsGameplayDronesAndRC",
    "FuncsGameplayMisc",
    "FuncsResources",
    "FuncsToggles",
    "MenuGameplayBuildings",
    "MenuGameplayColonists",
    "MenuGameplayDronesAndRC",
    "MenuGameplayMisc",
    "MenuToggles",
    "MenuTogglesFunc",
    "Script",
    --second files change :)
    "Keys",
    "MenuBuildings",
    "MenuBuildingsFunc",
    "MenuCheats",
    "MenuCheatsFunc",
    "MenuColonists",
    "MenuColonistsFunc",
    "MenuDebug",
    "MenuDebugFunc",
    "MenuDronesAndRC",
    "MenuDronesAndRCFunc",
    "MenuHelp",
    "MenuMisc",
    "MenuMiscFunc",
    "MenuResources",
    "MenuResourcesFunc",
    "OnMsgs",
    "libs/ReplacedFunctions",
    "libs/ExamineDialog",
    --third
    "FuncDebug",
    "FuncGame",
  }
  for _,Value in ipairs(Table) do
    AsyncFileDelete(ChoGGi.ModPath .. Value .. ".lua")
  end
  AsyncFileDelete(ChoGGi.ModPath .. "libs")
end

function ChoGGi.ShowBuildMenu(iWhich)
  local dlg = GetXDialog("XBuildMenu")

  if dlg then
    --opened so check if number corresponds and if so hide the menu
    if dlg.category == BuildCategories[iWhich].id then
      CloseXDialog("XBuildMenu")
    end
  else
    OpenXBuildMenu()
  end
  dlg = GetXDialog("XBuildMenu")
  dlg:SelectCategory(BuildCategories[iWhich])
  --have to fire twice to highlight the icon
  dlg:SelectCategory(BuildCategories[iWhich])
end

function ChoGGi.ColonistUpdateAge(colonist,Age)
  if Age == "Random" then
    Age = ChoGGi.ColonistAges[UICity:Random(1,6)]
  end
  --remove all age traits
  colonist:RemoveTrait("Child")
  colonist:RemoveTrait("Youth")
  colonist:RemoveTrait("Adult")
  colonist:RemoveTrait("Middle Aged")
  colonist:RemoveTrait("Senior")
  colonist:RemoveTrait("Retiree")
  --add new age trait
  colonist:AddTrait(Age)

  --needed for comparison
  local OrigAge = colonist.age_trait
  --needed for updating entity
  colonist.age_trait = Age

  if Age == "Retiree" then
    colonist.age = 65 --why isn't there a base_MinAge_Retiree...
  else
    colonist.age = colonist["base_MinAge_" .. Age]
  end

  if Age == "Child" then
    --there aren't any child specialist entities
    colonist.specialist = "none"
    --only children live in nurseries
    if OrigAge ~= "Child" then
      colonist:SetResidence(false)
    end
  end
  --only children live in nurseries
  if OrigAge == "Child" and Age ~= "Child" then
    colonist:SetResidence(false)
  end
  --now we can set the new entity
  colonist:ChooseEntity()
  --and (hopefully) prod them into finding a new residence
  colonist:UpdateWorkplace()
  colonist:UpdateResidence()
  colonist:TryToEmigrate()
end

function ChoGGi.ColonistUpdateGender(colonist,Gender,Cloned)
  if Gender == "Random" then
    Gender = ChoGGi.ColonistGenders[UICity:Random(1,5)]
  elseif Gender == "MaleOrFemale" then
    Gender = ChoGGi.ColonistGenders[UICity:Random(4,5)]
  end
  --remove all gender traits
  colonist:RemoveTrait("OtherGender")
  colonist:RemoveTrait("Android")
  colonist:RemoveTrait("Clone")
  colonist:RemoveTrait("Male")
  colonist:RemoveTrait("Female")
  --add new gender trait
  colonist:AddTrait(Gender)
  --needed for updating entity
  colonist.gender = Gender
  --set entity gender
  if Gender == "Male" or Gender == "Female" then
    colonist.entity_gender = Gender
  else --random
    if Cloned then
      colonist.entity_gender = Cloned
    else
      if UICity:Random(1,2) == 1 then
        colonist.entity_gender = "Male"
      else
        colonist.entity_gender = "Female"
      end
    end
  end
  --now we can set the new entity
  colonist:ChooseEntity()
end

function ChoGGi.ColonistUpdateSpecialization(colonist,Spec)
  if not colonist.entity:find("Child",1,true) then
    if Spec == "Random" then
      Spec = ChoGGi.ColonistSpecializations[UICity:Random(1,6)]
    end
    colonist:SetSpecialization(Spec,"init")
    colonist:ChooseEntity()
    colonist:UpdateWorkplace()
    colonist:TryToEmigrate()
  end
end

function ChoGGi.ColonistUpdateTraits(colonist,Bool,Type)
  for i = 1, #ChoGGi[Type] do
    if Bool == true then
      colonist:AddTrait(ChoGGi[Type][i],true)
    else
      colonist:RemoveTrait(ChoGGi[Type][i])
    end
  end
end

function ChoGGi.ColonistUpdateRace(colonist,Race)
  if Race == "Random" then
    Race = UICity:Random(1,5)
  end
  colonist.race = Race
  colonist:ChooseEntity()
end

--[[
ChoGGi.ReturnTechAmount(Tech,Prop)
returns number from TechTree (so you know how much it changes)
see: Data/TechTree.lua, or examine(TechTree)

ChoGGi.ReturnTechAmount("GeneralTraining","NonSpecialistPerformancePenalty").a
^returns 10
ChoGGi.ReturnTechAmount("SupportiveCommunity","LowSanityNegativeTraitChance").p
^ returns 0.7

it returns percentages in decimal for ease of mathing (SM removed the math.functions from lua)
ie: SupportiveCommunity is -70 this returns it as 0.7
it also returns negative amounts as positive (I prefer num - Amt, not num + NegAmt)

if .a is 0 or .p is 0.0 then you most likely have the wrong one
(TechTree'll always return both, I assume there's a default value somewhere)
--]]
function ChoGGi.ReturnTechAmount(Tech,Prop)
  for i,_ in ipairs(TechTree) do
    for j,_ in ipairs(TechTree[i]) do
      if TechTree[i][j].id == Tech then
        for k,_ in ipairs(TechTree[i][j]) do
          if TechTree[i][j][k].Prop == Prop then
            local Tech = TechTree[i][j][k]
            local RetObj = {}
            if Tech.Percent then
              RetObj.p = (Tech.Percent * -1 + 0.0) / 100 -- (-50 > 50 > 50.0) > 0.50
            end
            if Tech.Amount then
              if Tech.Amount <= 0 then
                RetObj.a = Tech.Amount * -1
              else
                RetObj.a = Tech.Amount
              end
            end
            return RetObj
          end
        end
      end
    end
  end
end

--check if tech is researched before we set these consts (activated from menu items)
function ChoGGi.GetCargoCapacity()
  if UICity and UICity:IsTechDiscovered("FuelCompression") then
    local a = ChoGGi.ReturnTechAmount("FuelCompression","CargoCapacity").a
    return ChoGGi.Consts.CargoCapacity + a
  end
  return ChoGGi.Consts.CargoCapacity
end
--
function ChoGGi.GetCommandCenterMaxDrones()
  if UICity and UICity:IsTechDiscovered("DroneSwarm") then
    local a = ChoGGi.ReturnTechAmount("DroneSwarm","CommandCenterMaxDrones").a
    return ChoGGi.Consts.CommandCenterMaxDrones + a
  end
  return ChoGGi.Consts.CommandCenterMaxDrones
end
--
function ChoGGi.GetDroneResourceCarryAmount()
  if UICity and UICity:IsTechDiscovered("ArtificialMuscles") then
    local a = ChoGGi.ReturnTechAmount("ArtificialMuscles","DroneResourceCarryAmount").a
    return ChoGGi.Consts.DroneResourceCarryAmount + a
  end
  return ChoGGi.Consts.DroneResourceCarryAmount
end
--
function ChoGGi.GetLowSanityNegativeTraitChance()
  if UICity and UICity:IsTechDiscovered("SupportiveCommunity") then
    local p = ChoGGi.ReturnTechAmount("SupportiveCommunity","LowSanityNegativeTraitChance").p
    --[[
    LowSanityNegativeTraitChance = 30%
    SupportiveCommunity = -70%
    --]]
    local LowSan = ChoGGi.Consts.LowSanityNegativeTraitChance + 0.0 --SM has no math.funcs so + 0.0
    return p*LowSan/100*100
  end
  return ChoGGi.Consts.LowSanityNegativeTraitChance
end
--
function ChoGGi.GetMaxColonistsPerRocket()
  local PerRocket = ChoGGi.Consts.MaxColonistsPerRocket
  if UICity and UICity:IsTechDiscovered("CompactPassengerModule") then
    local a = ChoGGi.ReturnTechAmount("CompactPassengerModule","MaxColonistsPerRocket").a
    PerRocket = PerRocket + a
  end
  if UICity and UICity:IsTechDiscovered("CryoSleep") then
    local a = ChoGGi.ReturnTechAmount("CryoSleep","MaxColonistsPerRocket").a
    PerRocket = PerRocket + a
  end
  return PerRocket
end
--
function ChoGGi.GetNonSpecialistPerformancePenalty()
  if UICity and UICity:IsTechDiscovered("GeneralTraining") then
    local a = ChoGGi.ReturnTechAmount("GeneralTraining","NonSpecialistPerformancePenalty").a
    return ChoGGi.Consts.NonSpecialistPerformancePenalty - a
  end
  return ChoGGi.Consts.NonSpecialistPerformancePenalty
end
--
function ChoGGi.GetRCRoverMaxDrones()
  if UICity and UICity:IsTechDiscovered("RoverCommandAI") then
    local a = ChoGGi.ReturnTechAmount("RoverCommandAI","RCRoverMaxDrones").a
    return ChoGGi.Consts.RCRoverMaxDrones + a
  end
  return ChoGGi.Consts.RCRoverMaxDrones
end
--
function ChoGGi.GetRCTransportGatherResourceWorkTime()
  if UICity and UICity:IsTechDiscovered("TransportOptimization") then
    local p = ChoGGi.ReturnTechAmount("TransportOptimization","RCTransportGatherResourceWorkTime").p
    return ChoGGi.Consts.RCTransportGatherResourceWorkTime * p
  end
  return ChoGGi.Consts.RCTransportGatherResourceWorkTime
end
--
function ChoGGi.GetRCTransportStorageCapacity()
  if UICity and UICity:IsTechDiscovered("TransportOptimization") then
    local a = ChoGGi.ReturnTechAmount("TransportOptimization","max_shared_storage").a
    return ChoGGi.Consts.RCTransportStorageCapacity + (a * ChoGGi.Consts.ResourceScale)
  end
  return ChoGGi.Consts.RCTransportStorageCapacity
end
--
function ChoGGi.GetTravelTimeEarthMars()
  if UICity and UICity:IsTechDiscovered("PlasmaRocket") then
    local p = ChoGGi.ReturnTechAmount("PlasmaRocket","TravelTimeEarthMars").p
    return ChoGGi.Consts.TravelTimeEarthMars * p
  end
  return ChoGGi.Consts.TravelTimeEarthMars
end
--
function ChoGGi.GetTravelTimeMarsEarth()
  if UICity and UICity:IsTechDiscovered("PlasmaRocket") then
    local p = ChoGGi.ReturnTechAmount("PlasmaRocket","TravelTimeMarsEarth").p
    return ChoGGi.Consts.TravelTimeMarsEarth * p
  end
  return ChoGGi.Consts.TravelTimeMarsEarth
end

--hex rings
do
  local build_grid_debug_range = 10
  GlobalVar("build_grid_debug_objs", false)
  GlobalVar("build_grid_debug_thread", false)
  function ChoGGi.debug_build_grid()
    if build_grid_debug_thread then
      DeleteThread(build_grid_debug_thread)
      build_grid_debug_thread = false
      if build_grid_debug_objs then
        for i = 1, #build_grid_debug_objs do
          DoneObject(build_grid_debug_objs[i])
        end
        build_grid_debug_objs = false
      end
    else
      build_grid_debug_objs = {}
      build_grid_debug_thread = CreateRealTimeThread(function()
        local last_q, last_r
        while build_grid_debug_objs do
          local q, r = WorldToHex(GetTerrainCursor())
          if last_q ~= q or last_r ~= r then
            local z = -q - r
            local idx = 1
            for q_i = q - build_grid_debug_range, q + build_grid_debug_range do
              for r_i = r - build_grid_debug_range, r + build_grid_debug_range do
                for z_i = z - build_grid_debug_range, z + build_grid_debug_range do
                  if q_i + r_i + z_i == 0 then
                    local c = build_grid_debug_objs[idx] or Circle:new()
                    c:SetRadius(const.GridSpacing / 2)
                    c:SetPos(point(HexToWorld(q_i, r_i)))
                    if HexGridGetObject(ObjectGrid, q_i, r_i) then
                      c:SetColor(RGBA(255, 0, 0, 0))
                    else
                      c:SetColor(RGBA(0, 255, 0, 0))
                    end
                    build_grid_debug_objs[idx] = c
                    idx = idx + 1
                  end
                end
              end
            end
            last_q = q
            last_r = r
          end
          Sleep(50)
        end
      end)
    end
  end
end

--ex(DataInstances.CommanderProfile[g_CurrentMissionParams.idCommanderProfile])
function ChoGGi.SetCommanderBonuses(sType)
  if sType == "Inventor" then
    local comm = DataInstances.CommanderProfile[g_CurrentMissionParams.idCommanderProfile]
    table.insert(comm,PlaceObj("TechEffect_ModifyLabelOverTime",{
      "Label","Consts",
      "Prop","DroneConstructAmount",
      "Percent",1,
      "TimeInterval",2,
      "TimeUnits",750000,
      "Repetitions",50
    }))
    table.insert(comm,PlaceObj("TechEffect_ModifyLabelOverTime",{
      "Label","Consts",
      "Prop","DroneBuildingRepairAmount",
      "Percent",1,
      "TimeInterval",2,
      "TimeUnits",750000,
      "Repetitions",50
    }))
    table.insert(comm,PlaceObj("TechEffect_ModifyLabelOverTime",{
      "Label","Consts",
      "Prop","DroneGatherResourceWorkTime",
      "Percent",-1,
      "TimeInterval",2,
      "TimeUnits",750000,
      "Repetitions",50
    }))
  elseif sType == "Oligarch" then
    local comm = DataInstances.CommanderProfile[g_CurrentMissionParams.idCommanderProfile]
    table.insert(comm,PlaceObj("TechEffect_ModifyLabel",{
      "Label","FuelFactory",
      "Prop","production_per_day1",
      "Percent",25
    }))
  elseif sType == "HydroEngineer" then
    local comm = DataInstances.CommanderProfile[g_CurrentMissionParams.idCommanderProfile]
    table.insert(comm,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Dome",
      "Prop","water_consumption",
      "Percent",-25
    }))
  elseif sType == "Doctor" then
    local comm = DataInstances.CommanderProfile[g_CurrentMissionParams.idCommanderProfile]
    table.insert(comm,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","MinComfortBirth",
      "Amount",-15
    }))
  elseif sType == "Politician" then
    local comm = DataInstances.CommanderProfile[g_CurrentMissionParams.idCommanderProfile]
    table.insert(comm,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","FundingGainsModifier",
      "Percent",20
    }))
  elseif sType == "Author" then
    local comm = DataInstances.CommanderProfile[g_CurrentMissionParams.idCommanderProfile]
    table.insert(comm,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","BreakThroughTechCostMod",
      "Amount",-30
    }))
  elseif sType == "Ecologist" then
    local comm = DataInstances.CommanderProfile[g_CurrentMissionParams.idCommanderProfile]
    table.insert(comm,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Decorations",
      "Prop","service_comfort",
      "Amount",10
    }))
  elseif sType == "Astrogeologist" then
    local comm = DataInstances.CommanderProfile[g_CurrentMissionParams.idCommanderProfile]
    table.insert(comm,PlaceObj("TechEffect_ModifyLabel",{
      "Label","WaterExtractor",
      "Prop","water_production",
      "Percent",10
    }))
    table.insert(comm,PlaceObj("TechEffect_ModifyLabel",{
      "Label","MetalsExtractor",
      "Prop","production_per_day1",
      "Percent",10
    }))
    table.insert(comm,PlaceObj("TechEffect_ModifyLabel",{
      "Label","PreciousMetalsExtractor",
      "Prop","production_per_day1",
      "Percent",10
    }))
    table.insert(comm,PlaceObj("TechEffect_ModifyLabel",{
      "Label","RegolithExtractor",
      "Prop","production_per_day1",
      "Percent",10
    }))
  end
end

--ex(DataInstances.MissionSponsor[g_CurrentMissionParams.idMissionSponsor])
function ChoGGi.SetSponsorBonuses(sType)
  if sType == "IMM" then
    local sponsor = DataInstances.MissionSponsor[g_CurrentMissionParams.idMissionSponsor]
    sponsor.cargo = ChoGGi.CompareAmounts(sponsor.cargo,DataInstances.MissionSponsor.IMM.cargo)
    sponsor.additional_research_points = ChoGGi.CompareAmounts(sponsor.additional_research_points,DataInstances.MissionSponsor.IMM.additional_research_points)
    table.insert(sponsor,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","FoodPerRocketPassenger",
      "Amount",9000
    }))
  elseif sType == "NASA" then
    local sponsor = DataInstances.MissionSponsor[g_CurrentMissionParams.idMissionSponsor]
    sponsor.cargo = ChoGGi.CompareAmounts(sponsor.cargo,DataInstances.MissionSponsor.NASA.cargo)
    sponsor.additional_research_points = ChoGGi.CompareAmounts(sponsor.additional_research_points,DataInstances.MissionSponsor.NASA.additional_research_points)
    table.insert(sponsor,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","SponsorFundingPerInterval",
      "Amount",500
    }))
  elseif sType == "BlueSun" then
    local sponsor = DataInstances.MissionSponsor[g_CurrentMissionParams.idMissionSponsor]
    sponsor.rocket_price = ChoGGi.CompareAmounts(sponsor.rocket_price,DataInstances.MissionSponsor.BlueSun.rocket_price)
    sponsor.applicants_price = ChoGGi.CompareAmounts(sponsor.applicants_price,DataInstances.MissionSponsor.BlueSun.applicants_price)
    table.insert(sponsor,PlaceObj("TechEffect_GrantTech",{
      "Field","Physics",
      "Research","DeepMetalExtraction"
    }))
  elseif sType == "CNSA" then
    local sponsor = DataInstances.MissionSponsor[g_CurrentMissionParams.idMissionSponsor]
    sponsor.additional_research_points = ChoGGi.CompareAmounts(sponsor.additional_research_points,DataInstances.MissionSponsor.CNSA.additional_research_points)
    table.insert(sponsor,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","ApplicantGenerationInterval",
      "Percent",-50
    }))
    table.insert(sponsor,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","MaxColonistsPerRocket",
      "Amount",10
    }))
  elseif sType == "ISRO" then
    local sponsor = DataInstances.MissionSponsor[g_CurrentMissionParams.idMissionSponsor]
    table.insert(sponsor,PlaceObj("TechEffect_GrantTech",{
      "Field","Engineering",
      "Research","LowGEngineering"
    }))
    table.insert(sponsor,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","Concrete_cost_modifier",
      "Percent",-20
    }))
    table.insert(sponsor,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","Electronics_cost_modifier",
      "Percent",-20
    }))
    table.insert(sponsor,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","MachineParts_cost_modifier",
      "Percent",-20
    }))
    table.insert(sponsor,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","ApplicantsPoolStartingSize",
      "Percent",50
    }))
    table.insert(sponsor,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","Metals_cost_modifier",
      "Percent",-20
    }))
    table.insert(sponsor,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","Polymers_cost_modifier",
      "Percent",-20
    }))
    table.insert(sponsor,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","PreciousMetals_cost_modifier",
      "Percent",-20
    }))
  elseif sType == "ESA" then
    local sponsor = DataInstances.MissionSponsor[g_CurrentMissionParams.idMissionSponsor]
    sponsor.funding_per_tech = ChoGGi.CompareAmounts(sponsor.funding_per_tech,DataInstances.MissionSponsor.ESA.funding_per_tech)
    sponsor.funding_per_breakthrough = ChoGGi.CompareAmounts(sponsor.funding_per_breakthrough,DataInstances.MissionSponsor.ESA.funding_per_breakthrough)
    sponsor.additional_research_points = ChoGGi.CompareAmounts(sponsor.additional_research_points,DataInstances.MissionSponsor.ESA.additional_research_points)
  elseif sType == "SpaceY" then
    local sponsor = DataInstances.MissionSponsor[g_CurrentMissionParams.idMissionSponsor]
    sponsor.additional_research_points = ChoGGi.CompareAmounts(sponsor.additional_research_points,DataInstances.MissionSponsor.SpaceY.additional_research_points)
    sponsor.modifier_name1 = DataInstances.MissionSponsor.SpaceY.modifier_name1
    sponsor.modifier_value1 = DataInstances.MissionSponsor.SpaceY.modifier_value1
    sponsor.modifier_name2 = DataInstances.MissionSponsor.SpaceY.modifier_name2
    sponsor.modifier_value2 = DataInstances.MissionSponsor.SpaceY.modifier_value2
    sponsor.modifier_name3 = DataInstances.MissionSponsor.SpaceY.modifier_name3
    sponsor.modifier_value3 = DataInstances.MissionSponsor.SpaceY.modifier_value3
    table.insert(sponsor,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","CommandCenterMaxDrones",
      "Percent",20
    }))
    table.insert(sponsor,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","starting_drones",
      "Percent",4
    }))
  elseif sType == "NewArk" then
    local sponsor = DataInstances.MissionSponsor[g_CurrentMissionParams.idMissionSponsor]
    table.insert(sponsor,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","BirthThreshold",
      "Percent",-50
    }))
  elseif sType == "Roscosmos" then
    local sponsor = DataInstances.MissionSponsor[g_CurrentMissionParams.idMissionSponsor]
    sponsor.modifier_name1 = DataInstances.MissionSponsor.Roscosmos.modifier_name1
    sponsor.modifier_value1 = DataInstances.MissionSponsor.Roscosmos.modifier_value1
    sponsor.additional_research_points = ChoGGi.CompareAmounts(sponsor.additional_research_points,DataInstances.MissionSponsor.Roscosmos.additional_research_points)
    table.insert(sponsor,PlaceObj("TechEffect_GrantTech",{
      "Field","Robotics",
      "Research","FueledExtractors"
    }))
  elseif sType == "Paradox" then
    local sponsor = DataInstances.MissionSponsor[g_CurrentMissionParams.idMissionSponsor]
    sponsor.applicants_per_breakthrough = ChoGGi.CompareAmounts(sponsor.applicants_per_breakthrough,DataInstances.MissionSponsor.paradox.applicants_per_breakthrough)
    sponsor.anomaly_bonus_breakthrough = ChoGGi.CompareAmounts(sponsor.anomaly_bonus_breakthrough,DataInstances.MissionSponsor.paradox.anomaly_bonus_breakthrough)
  end
end

--called from below

function ChoGGi.WaitListChoiceCustom(Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,ListHints)
  --local dlg = OpenDialog("ListChoiceCustomDialog", nil, terminal.desktop, _InternalTranslate(Caption))
  local dlg = OpenDialog("ListChoiceCustomDialog", nil, terminal.desktop)

--easier to fiddle with it like this (remove sometime)
ChoGGi.ListChoiceCustomDialog_Dlg = dlg

  if MultiSel then
    dlg.idList.multiple_selection = true
  end
  if ListHints then
    dlg.showlisthints = true
  end
  --hides if short list
  --dlg.idList:SetScrollAutohide(true)
  --title text
  dlg.idCaption:SetText(Caption)
  --list
  dlg.idList:SetContent(Items)

  --setup checkboxes
  if not Check1 and not Check2 then
    dlg.idCheckBox1:SetVisible(false)
    dlg.idCheckBox2:SetVisible(false)
  else
    dlg.idList:SetSize(point(390, 310))


    if Check1 then
      dlg.idCheckBox1:SetText(Check1)
      dlg.idCheckBox1:SetHint(Check1Hint)
    else
      dlg.idCheckBox1:SetVisible(false)
    end
    if Check2 then
      dlg.idCheckBox2:SetText(Check2)
      dlg.idCheckBox2:SetHint(Check2Hint)
    else
      dlg.idCheckBox2:SetVisible(false)
    end
  end
  --where to position dlg
  dlg:SetPos(terminal.GetMousePos())

  --focus on list
  dlg.idList:SetFocus()
  --dlg.idList:SetSelection(1, true)

  --are we showing a hint?
  if Hint then
    dlg.idList:SetHint(Hint)
    dlg.idOK:SetHint("Apply and close dialog (Arrow keys and Enter/Esc can also be used).\n\n\n\n" .. Hint)
  end

  --waiting for choice
  return dlg:Wait()
end

function ChoGGi.FireFuncAfterChoice(Func,Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint)
  if not Func or not Items or (Items and #Items == 0) then
    return
  end

  local ListHints = false
  if Items[1].hint then
    ListHints = true
  end

  --sort table by display text
  table.sort(Items,
    function(a,b)
      return ChoGGi.CompareTableNames(a,b,"text")
    end
  )

  --insert blank item for adding custom value
  table.insert(Items,{text = "",hint = "",value = false})

  CreateRealTimeThread(function()
    local option = ChoGGi.WaitListChoiceCustom(Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,ListHints)
    if option ~= "idCancel" then
      Func(option)
    end
  end)
end

--some dev removed this from the Spirit update... (harumph)
function ChoGGi.AddConsolePrompt(text)
  if dlgConsole then
    local self = dlgConsole
    self:Show(true)
    self.idEdit:Replace(self.idEdit.cursor_pos, self.idEdit.cursor_pos, text, true)
    self.idEdit:SetCursorPos(#text)
  end
end

--toggle visiblity of console log
function ChoGGi.ToggleConsoleLog()
  if dlgConsoleLog then
    if dlgConsoleLog:GetVisible() then
      dlgConsoleLog:SetVisible(false)
    else
      dlgConsoleLog:SetVisible(true)
    end
  else
    dlgConsoleLog = ConsoleLog:new({}, terminal.desktop)
  end
end

function ChoGGi.OpenInObjectManipulator(object,parent)
  local dlg = OpenDialog("ObjectManipulatorDialog", nil, parent or terminal.desktop)
  if dlg then
    --hides if short list
    dlg.idList:SetScrollAutohide(true)
    --title text
    dlg.idCaption:SetText(tostring(object))

    --create prop list for list
    local list = ChoGGi.CreatePropList(object)
    if list then
      dlg.idList:SetContent(list)
    end
  end
end
