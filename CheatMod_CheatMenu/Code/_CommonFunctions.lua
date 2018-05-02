--any funcs called from Code/*.lua

--make some easy to type names
function console(...)ConsolePrint(tostring(...))end
function examine(Obj)OpenExamine(Obj)end
function ex(Obj)OpenExamine(Obj)end
function con(...)console(...)end
function dump(...)ChoGGi.Dump(...)end
function dumpobject(...)ChoGGi.DumpObject(...)end
function dumplua(...)ChoGGi.DumpLua(...)end
function dumptable(...)ChoGGi.DumpTable(...)end
function dumpo(...)ChoGGi.DumpObject(...)end
function dumpl(...)ChoGGi.DumpLua(...)end
function dumpt(...)ChoGGi.DumpTable(...)end
function alert(...)ChoGGi.MsgPopup(...)end
function restart()quit("restart")end
s = false --used to store SelectedObj
reboot = restart
exit = quit
trans = _InternalTranslate
mh = GetTerrainCursorObjSel
mc = GetPreciseCursorObj
m = SelectionMouseObj
c = GetTerrainCursor
cs = terminal.GetMousePos --pos on screen, not map

--check if tech is researched before we set these consts (activated from menu items)
function ChoGGi.GetSpeedDrone()
  local MoveSpeed = ChoGGi.Consts.SpeedDrone

  if UICity and UICity:IsTechResearched("LowGDrive") then
    local p = ChoGGi.ReturnTechAmount("LowGDrive","move_speed")
    MoveSpeed = MoveSpeed + MoveSpeed * p
  end
  if UICity and UICity:IsTechResearched("AdvancedDroneDrive") then
    local p = ChoGGi.ReturnTechAmount("AdvancedDroneDrive","move_speed")
    MoveSpeed = MoveSpeed + MoveSpeed * p
  end

  return MoveSpeed
end

function ChoGGi.GetSpeedRC()
  if UICity and UICity:IsTechResearched("LowGDrive") then
    local p = ChoGGi.ReturnTechAmount("LowGDrive","move_speed")
    return ChoGGi.Consts.SpeedRC + ChoGGi.Consts.SpeedRC * p
  end
  return ChoGGi.Consts.SpeedRC
end

function ChoGGi.GetCargoCapacity()
  if UICity and UICity:IsTechResearched("FuelCompression") then
    local a = ChoGGi.ReturnTechAmount("FuelCompression","CargoCapacity")
    return ChoGGi.Consts.CargoCapacity + a
  end
  return ChoGGi.Consts.CargoCapacity
end
--
function ChoGGi.GetCommandCenterMaxDrones()
  if UICity and UICity:IsTechResearched("DroneSwarm") then
    local a = ChoGGi.ReturnTechAmount("DroneSwarm","CommandCenterMaxDrones")
    return ChoGGi.Consts.CommandCenterMaxDrones + a
  end
  return ChoGGi.Consts.CommandCenterMaxDrones
end
--
function ChoGGi.GetDroneResourceCarryAmount()
  if UICity and UICity:IsTechResearched("ArtificialMuscles") then
    local a = ChoGGi.ReturnTechAmount("ArtificialMuscles","DroneResourceCarryAmount")
    return ChoGGi.Consts.DroneResourceCarryAmount + a
  end
  return ChoGGi.Consts.DroneResourceCarryAmount
end
--
function ChoGGi.GetLowSanityNegativeTraitChance()
  if UICity and UICity:IsTechResearched("SupportiveCommunity") then
    local p = ChoGGi.ReturnTechAmount("SupportiveCommunity","LowSanityNegativeTraitChance")
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
  if UICity and UICity:IsTechResearched("CompactPassengerModule") then
    local a = ChoGGi.ReturnTechAmount("CompactPassengerModule","MaxColonistsPerRocket")
    PerRocket = PerRocket + a
  end
  if UICity and UICity:IsTechResearched("CryoSleep") then
    local a = ChoGGi.ReturnTechAmount("CryoSleep","MaxColonistsPerRocket")
    PerRocket = PerRocket + a
  end
  return PerRocket
end
--
function ChoGGi.GetNonSpecialistPerformancePenalty()
  if UICity and UICity:IsTechResearched("GeneralTraining") then
    local a = ChoGGi.ReturnTechAmount("GeneralTraining","NonSpecialistPerformancePenalty")
    return ChoGGi.Consts.NonSpecialistPerformancePenalty - a
  end
  return ChoGGi.Consts.NonSpecialistPerformancePenalty
end
--
function ChoGGi.GetRCRoverMaxDrones()
  if UICity and UICity:IsTechResearched("RoverCommandAI") then
    local a = ChoGGi.ReturnTechAmount("RoverCommandAI","RCRoverMaxDrones")
    return ChoGGi.Consts.RCRoverMaxDrones + a
  end
  return ChoGGi.Consts.RCRoverMaxDrones
end
--
function ChoGGi.GetRCTransportGatherResourceWorkTime()
  if UICity and UICity:IsTechResearched("TransportOptimization") then
    local p = ChoGGi.ReturnTechAmount("TransportOptimization","RCTransportGatherResourceWorkTime")
    return ChoGGi.Consts.RCTransportGatherResourceWorkTime * p
  end
  return ChoGGi.Consts.RCTransportGatherResourceWorkTime
end
--
function ChoGGi.GetRCTransportStorageCapacity()
  if UICity and UICity:IsTechResearched("TransportOptimization") then
    local a = ChoGGi.ReturnTechAmount("TransportOptimization","max_shared_storage")
    return ChoGGi.Consts.RCTransportStorageCapacity + (a * ChoGGi.Consts.ResourceScale)
  end
  return ChoGGi.Consts.RCTransportStorageCapacity
end
--
function ChoGGi.GetTravelTimeEarthMars()
  if UICity and UICity:IsTechResearched("PlasmaRocket") then
    local p = ChoGGi.ReturnTechAmount("PlasmaRocket","TravelTimeEarthMars")
    return ChoGGi.Consts.TravelTimeEarthMars * p
  end
  return ChoGGi.Consts.TravelTimeEarthMars
end
--
function ChoGGi.GetTravelTimeMarsEarth()
  if UICity and UICity:IsTechResearched("PlasmaRocket") then
    local p = ChoGGi.ReturnTechAmount("PlasmaRocket","TravelTimeMarsEarth")
    return ChoGGi.Consts.TravelTimeMarsEarth * p
  end
  return ChoGGi.Consts.TravelTimeMarsEarth
end

function ChoGGi.AttachToNearestDome(building)
  --ignore outdoor buildings, and if there aren't any domes
  local work = UICity.labels.Domes_Working
  if building.dome_required ~= true or not work or (work and next(work) == nil) then
    return
  end

  --check for domes and dome ruins don't have air/water/elec
  if (building.parent_dome and not building.parent_dome.air) or not building.parent_dome then
    --find the nearest working dome
    local dome = FindNearestObject(work,building)
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
  --electricity
  for _,building in ipairs(UICity.labels.Power or empty_table) do
    local bld = ChoGGi.CheatMenuSettings.BuildingSettings[building.encyclopedia_id]
    if bld and bld.production then
      building.electricity:SetProduction(bld.production)
      building.electricity_production = bld.production
    end
  end

  --water/air
  for _,building in ipairs(UICity.labels["Life-Support"] or empty_table) do
    local bld = ChoGGi.CheatMenuSettings.BuildingSettings[building.encyclopedia_id]
    if bld and bld.production then
      if building.base_air_production then
        building.air:SetProduction(bld.production)
        building.air_production = bld.production
      elseif building.base_water_production then
        building.water:SetProduction(bld.production)
        building.water_production = bld.production
      end
    end
  end

  --extractors/factories
  for _,building in ipairs(UICity.labels.Production or empty_table) do
    local bld = ChoGGi.CheatMenuSettings.BuildingSettings[building.encyclopedia_id]
    if bld and bld.production then
      building.producers[1].production_per_day = bld.production
      building.production_per_day1 = bld.production
    end
  end
  --moholemine/theexvacator
  for _,building in ipairs(UICity.labels.Wonders or empty_table) do
    local bld = ChoGGi.CheatMenuSettings.BuildingSettings[building.encyclopedia_id]
    if bld and bld.production then
      building.producers[1].production_per_day = bld.production
      building.production_per_day1 = bld.production
    end
  end
  --farms
  for _,building in ipairs(UICity.labels.BaseFarm or empty_table) do
    local bld = ChoGGi.CheatMenuSettings.BuildingSettings[building.encyclopedia_id]
    if bld and bld.production then
      building.producers[1].production_per_day = bld.production
      building.production_per_day1 = bld.production
    end
  end
  for _,building in ipairs(UICity.labels.FungalFarm or empty_table) do
    local bld = ChoGGi.CheatMenuSettings.BuildingSettings[building.encyclopedia_id]
    if bld and bld.production then
      building.producers[1].production_per_day = bld.production
      building.production_per_day1 = bld.production
    end
  end
end

--toggle working status
function ChoGGi.ToggleWorking(building)
  CreateRealTimeThread(function()
    building:ToggleWorking()
    Sleep(5)
    building:ToggleWorking()
  end)
end

function ChoGGi.SetCameraSettings()
--cameraRTS.GetProperties(1)

  --size of activation area for border scrolling
  if ChoGGi.CheatMenuSettings.BorderScrollingArea then
    cameraRTS.SetProperties(1,{ScrollBorder = ChoGGi.CheatMenuSettings.BorderScrollingArea})
  else
    --default
    cameraRTS.SetProperties(1,{ScrollBorder = 5})
  end

  --zoom
  --camera.GetFovY()
  --camera.GetFovX()
  if ChoGGi.CheatMenuSettings.CameraZoomToggle then
    if type(ChoGGi.CheatMenuSettings.CameraZoomToggle) == "number" then
      cameraRTS.SetZoomLimits(0,ChoGGi.CheatMenuSettings.CameraZoomToggle)
    else
      cameraRTS.SetZoomLimits(0,24000)
    end

    --5760x1080 doesn't get the correct zoom size till after zooming out
    if UIL.GetScreenSize():x() == 5760 then
      camera.SetFovY(2580)
      camera.SetFovX(7745)
    end
  else
    --default
    cameraRTS.SetZoomLimits(400,8000)
  end

  --cameraRTS.SetProperties(1,{HeightInertia = 0})
end

function ChoGGi.RemoveOldFiles()
  CreateRealTimeThread(function()
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

    --and old settings that aren't used anymore
    ChoGGi.CheatMenuSettings.NewColonistSex = nil
    ChoGGi.CheatMenuSettings.ShuttleSpeed = nil
    ChoGGi.CheatMenuSettings.ShuttleStorage = nil
    ChoGGi.CheatMenuSettings.AirWaterAddAmount = nil
    ChoGGi.CheatMenuSettings.AirWaterBatteryAddAmount = nil
    ChoGGi.CheatMenuSettings.BatteryAddAmount = nil
    ChoGGi.CheatMenuSettings.FullyAutomatedBuildingsPerf = nil
    ChoGGi.CheatMenuSettings.ProductionAddAmount = nil
    ChoGGi.CheatMenuSettings.ResidenceAddAmount = nil
    ChoGGi.CheatMenuSettings.ResidenceMaxHeight = nil
    ChoGGi.CheatMenuSettings.ShuttleAddAmount = nil
    ChoGGi.CheatMenuSettings.TrainersAddAmount = nil
    ChoGGi.CheatMenuSettings.developer = nil
    ChoGGi.CheatMenuSettings.ToggleInfopanelCheats = nil
    ChoGGi.CheatMenuSettings.Building_dome_forbidden = nil
    ChoGGi.CheatMenuSettings.Building_dome_required = nil
    ChoGGi.CheatMenuSettings.Building_is_tall = nil
    ChoGGi.CheatMenuSettings.BorderScrollingToggle = nil
    ChoGGi.CheatMenuSettings.CommanderAstrogeologist = nil
    ChoGGi.CheatMenuSettings.CommanderAuthor = nil
    ChoGGi.CheatMenuSettings.CommanderDoctor = nil
    ChoGGi.CheatMenuSettings.CommanderEcologist = nil
    ChoGGi.CheatMenuSettings.CommanderHydroEngineer = nil
    ChoGGi.CheatMenuSettings.CommanderInventor = nil
    ChoGGi.CheatMenuSettings.CommanderOligarch = nil
    ChoGGi.CheatMenuSettings.CommanderPolitician = nil
    ChoGGi.CheatMenuSettings.SponsorBlueSun = nil
    ChoGGi.CheatMenuSettings.SponsorCNSA = nil
    ChoGGi.CheatMenuSettings.SponsorESA = nil
    ChoGGi.CheatMenuSettings.SponsorISRO = nil
    ChoGGi.CheatMenuSettings.SponsorNASA = nil
    ChoGGi.CheatMenuSettings.SponsorNewArk = nil
    ChoGGi.CheatMenuSettings.SponsorParadox = nil
    ChoGGi.CheatMenuSettings.SponsorRoscosmos = nil
    ChoGGi.CheatMenuSettings.SponsorSpaceY = nil
    ChoGGi.CheatMenuSettings.CapacityShuttle = nil
  end)
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

function ChoGGi.ColonistUpdateAge(Colonist,Age)
  if Age == "Random" then
    Age = ChoGGi.ColonistAges[UICity:Random(1,6)]
  end
  --remove all age traits
  Colonist:RemoveTrait("Child")
  Colonist:RemoveTrait("Youth")
  Colonist:RemoveTrait("Adult")
  Colonist:RemoveTrait("Middle Aged")
  Colonist:RemoveTrait("Senior")
  Colonist:RemoveTrait("Retiree")
  --add new age trait
  Colonist:AddTrait(Age)

  --needed for comparison
  local OrigAge = Colonist.age_trait
  --needed for updating entity
  Colonist.age_trait = Age

  if Age == "Retiree" then
    Colonist.age = 65 --why isn't there a base_MinAge_Retiree...
  else
    Colonist.age = Colonist["base_MinAge_" .. Age]
  end

  if Age == "Child" then
    --there aren't any child specialist entities
    Colonist.specialist = "none"
    --only children live in nurseries
    if OrigAge ~= "Child" then
      Colonist:SetResidence(false)
    end
  end
  --only children live in nurseries
  if OrigAge == "Child" and Age ~= "Child" then
    Colonist:SetResidence(false)
  end
  --now we can set the new entity
  Colonist:ChooseEntity()
  --and (hopefully) prod them into finding a new residence
  Colonist:UpdateWorkplace()
  Colonist:UpdateResidence()
  Colonist:TryToEmigrate()
end

function ChoGGi.ColonistUpdateGender(Colonist,Gender,Cloned)
  if Gender == "Random" then
    Gender = ChoGGi.ColonistGenders[UICity:Random(1,5)]
  elseif Gender == "MaleOrFemale" then
    Gender = ChoGGi.ColonistGenders[UICity:Random(4,5)]
  end
  --remove all gender traits
  Colonist:RemoveTrait("OtherGender")
  Colonist:RemoveTrait("Android")
  Colonist:RemoveTrait("Clone")
  Colonist:RemoveTrait("Male")
  Colonist:RemoveTrait("Female")
  --add new gender trait
  Colonist:AddTrait(Gender)
  --needed for updating entity
  Colonist.gender = Gender
  --set entity gender
  if Gender == "Male" or Gender == "Female" then
    Colonist.entity_gender = Gender
  else --random
    if Cloned then
      Colonist.entity_gender = Cloned
    else
      if UICity:Random(1,2) == 1 then
        Colonist.entity_gender = "Male"
      else
        Colonist.entity_gender = "Female"
      end
    end
  end
  --now we can set the new entity
  Colonist:ChooseEntity()
end

function ChoGGi.ColonistUpdateSpecialization(Colonist,Spec)
  if not Colonist.entity:find("Child",1,true) then
    if Spec == "Random" then
      Spec = ChoGGi.ColonistSpecializations[UICity:Random(1,6)]
    end
    Colonist:SetSpecialization(Spec,"init")
    Colonist:ChooseEntity()
    Colonist:UpdateWorkplace()
    Colonist:TryToEmigrate()
  end
end

function ChoGGi.ColonistUpdateTraits(Colonist,Bool,Traits)
  for i = 1, #Traits do
    if Bool == true then
      Colonist:AddTrait(Traits[i],true)
    else
      Colonist:RemoveTrait(Traits[i])
    end
  end
end

function ChoGGi.ColonistUpdateRace(Colonist,Race)
  if Race == "Random" then
    Race = UICity:Random(1,5)
  end
  Colonist.race = Race
  Colonist:ChooseEntity()
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

function ChoGGi.SetCommanderBonuses(sType)
  local currentname = g_CurrentMissionParams.idCommanderProfile
  local comm = MissionParams.idCommanderProfile.items[currentname]
  local bonus = Presets.CommanderProfilePreset.Default[sType]

  for _,Value in ipairs(bonus or empty_table) do
    CreateRealTimeThread(function()
      table.insert(comm,Value)
    end)
  end
end

function ChoGGi.SetSponsorBonuses(sType)
  local currentname = g_CurrentMissionParams.idMissionSponsor
  local sponsor = MissionParams.idMissionSponsor.items[currentname]
  local bonus = Presets.MissionSponsorPreset.Default[sType]
  --bonuses multiple sponsors have (CompareAmounts returns equal or larger amount)
  if sponsor.cargo then
    sponsor.cargo = ChoGGi.CompareAmounts(sponsor.cargo,bonus.cargo)
  end
  if sponsor.additional_research_points then
    sponsor.additional_research_points = ChoGGi.CompareAmounts(sponsor.additional_research_points,bonus.additional_research_points)
  end

  if sType == "IMM" then
    table.insert(sponsor,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","FoodPerRocketPassenger",
      "Amount",9000
    }))
  elseif sType == "NASA" then
    table.insert(sponsor,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","SponsorFundingPerInterval",
      "Amount",500
    }))
  elseif sType == "BlueSun" then
    sponsor.rocket_price = ChoGGi.CompareAmounts(sponsor.rocket_price,bonus.rocket_price)
    sponsor.applicants_price = ChoGGi.CompareAmounts(sponsor.applicants_price,bonus.applicants_price)
    table.insert(sponsor,PlaceObj("TechEffect_GrantTech",{
      "Field","Physics",
      "Research","DeepMetalExtraction"
    }))
  elseif sType == "CNSA" then
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
    sponsor.funding_per_tech = ChoGGi.CompareAmounts(sponsor.funding_per_tech,bonus.funding_per_tech)
    sponsor.funding_per_breakthrough = ChoGGi.CompareAmounts(sponsor.funding_per_breakthrough,bonus.funding_per_breakthrough)
  elseif sType == "SpaceY" then
    sponsor.modifier_name1 = ChoGGi.CompareAmounts(sponsor.modifier_name1,bonus.modifier_name1)
    sponsor.modifier_value1 = ChoGGi.CompareAmounts(sponsor.modifier_value1,bonus.modifier_value1)
    sponsor.modifier_name2 = ChoGGi.CompareAmounts(sponsor.modifier_name2,bonusmodifier_name2)
    sponsor.modifier_value2 = ChoGGi.CompareAmounts(sponsor.modifier_value2,bonus.modifier_value2)
    sponsor.modifier_name3 = ChoGGi.CompareAmounts(sponsor.modifier_name3,bonus.modifier_name3)
    sponsor.modifier_value3 = ChoGGi.CompareAmounts(sponsor.modifier_value3,bonus.modifier_value3)
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
    table.insert(sponsor,PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","BirthThreshold",
      "Percent",-50
    }))
  elseif sType == "Roscosmos" then
    sponsor.modifier_name1 = ChoGGi.CompareAmounts(sponsor.modifier_name1,bonus.modifier_name1)
    sponsor.modifier_value1 = ChoGGi.CompareAmounts(sponsor.modifier_value1,bonus.modifier_value1)
    table.insert(sponsor,PlaceObj("TechEffect_GrantTech",{
      "Field","Robotics",
      "Research","FueledExtractors"
    }))
  elseif sType == "Paradox" then
    sponsor.applicants_per_breakthrough = ChoGGi.CompareAmounts(sponsor.applicants_per_breakthrough,bonus.applicants_per_breakthrough)
    sponsor.anomaly_bonus_breakthrough = ChoGGi.CompareAmounts(sponsor.anomaly_bonus_breakthrough,bonus.anomaly_bonus_breakthrough)
  end
end

--called from FireFuncAfterChoice

function ChoGGi.WaitListChoiceCustom(Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType)
  local dlg = ListChoiceCustomDialog:new()

  if not dlg then
    return
  end

  if ChoGGi.Testing then
    --easier to fiddle with it
    ChoGGi.ListChoiceCustomDialog_Dlg = dlg
  end

  --title text
  dlg.idCaption:SetText(Caption)
  --list
  dlg.idList:SetContent(Items)

  --fiddling with custom value
  if CustomType then
    dlg.idEditValue.auto_select_all = false
    dlg.CustomType = CustomType
    if dlg.CustomType == 2 then
      dlg.idColorHSV:SetVisible(true)
      dlg.idColorCheckAir:SetVisible(true)
      dlg.idColorCheckWater:SetVisible(true)
      dlg.idColorCheckElec:SetVisible(true)
      dlg:SetWidth(800)
      dlg.idList:SetSelection(1, true)
      dlg.sel = dlg.idList:GetSelection()[#dlg.idList:GetSelection()]
      dlg.idEditValue:SetText(tostring(dlg.sel.value))
      dlg:UpdateColourPicker()
    end
  end

  if MultiSel then
    dlg.idList.multiple_selection = true
    if type(MultiSel) == "number" then
      --select all of number
      for i = 1, MultiSel do
        dlg.idList:SetSelection(i, true)
      end
    end
  end

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
    dlg.idOK:SetHint(dlg.idOK:GetHint() .. "\n\n\n" .. Hint)
  end

  --waiting for choice
  return dlg:Wait()
end

function ChoGGi.FireFuncAfterChoice(Func,Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType)
  if not Func or not Items then
    return
  end

  --sort table by display text
  table.sort(Items,
    function(a,b)
      return ChoGGi.CompareTableNames(a,b,"text")
    end
  )

  --only insert blank item if we aren't updating other items with it
  if not CustomType then
    --insert blank item for adding custom value
    table.insert(Items,{text = "",hint = "",value = false})
  end

  CreateRealTimeThread(function()
    local option = ChoGGi.WaitListChoiceCustom(Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType)
    if option ~= "idClose" then
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

--force drones to pickup from producers even if they have a large carry cap
function ChoGGi.FuckingDrones(producer)
  --Come on, Bender. Grab a jack. I told these guys you were cool.
  --Well, if jacking on will make strangers think I'm cool, I'll do it.

  local amount = producer:GetAmountStored()
  if amount > 1000 then
    local drone = FindNearestObject(UICity.labels.Drone,producer.parent)
    if drone and not drone:GetCarriedResource() then
      drone:SetCommandUserInteraction("PickUp", producer.stockpiles[1].supply_request, false,producer.resource_produced, amount)
    end
  end
end

function ChoGGi.SaveOldPalette(obj)
  local GetPal = obj.GetColorizationMaterial
  if not obj.ChoGGi_origcolors then
    obj.ChoGGi_origcolors = {}
    table.insert(obj.ChoGGi_origcolors,{GetPal(obj,1)})
    table.insert(obj.ChoGGi_origcolors,{GetPal(obj,2)})
    table.insert(obj.ChoGGi_origcolors,{GetPal(obj,3)})
    table.insert(obj.ChoGGi_origcolors,{GetPal(obj,4)})
  end
end
function ChoGGi.RestoreOldPalette(obj)
  if obj.ChoGGi_origcolors then
    local c = obj.ChoGGi_origcolors
    local SetPal = obj.SetColorizationMaterial
    SetPal(obj,1, c[1][1], c[1][2], c[1][3])
    SetPal(obj,2, c[2][1], c[2][2], c[2][3])
    SetPal(obj,3, c[3][1], c[3][2], c[3][3])
    SetPal(obj,4, c[4][1], c[4][2], c[4][3])
    obj.ChoGGi_origcolors = nil
  end
end

function ChoGGi.GetPalette(Obj)
  local g = Obj.GetColorizationMaterial
  local pal = {}
  pal.Color1, pal.Roughness1, pal.Metallic1 = g(Obj, 1)
  pal.Color2, pal.Roughness2, pal.Metallic2 = g(Obj, 2)
  pal.Color3, pal.Roughness3, pal.Metallic3 = g(Obj, 3)
  pal.Color4, pal.Roughness4, pal.Metallic4 = g(Obj, 4)
  return pal
end

function ChoGGi.OpenInObjectManipulator(Object,Parent)
  if not Object then
    return
  end

  local dlg = ObjectManipulator:new()

  if not dlg then
    return
  end

  if ChoGGi.Testing then
    --easier to fiddle with it
    ChoGGi.ObjectManipulator_Dlg = dlg
  end

  --update internal object
  dlg.obj = Object

  local title = tostring(Object)
  if type(Object) == "table" then
    title = "Class: " .. Object.class
  end

  --update the add button hint
  dlg.idAddNew:SetHint(dlg.idAddNew:GetHint() .. title .. ".")

  --title text
  if type(Object) == "table" then
    if Object.entity then
      dlg.idCaption:SetText(Object.entity .. " - " .. Object.class)
    else
      dlg.idCaption:SetText(Object.class)
    end
  else
    dlg.idCaption:SetText(tostring(Object))
  end

  --set pos
  if Parent then
    local pos = Parent:GetPos()
    if not pos then
      dlg:SetPos(terminal.GetMousePos())
    else
      dlg:SetPos(point(pos:x(),pos:y() + 15))
    end
  else
    dlg:SetPos(terminal.GetMousePos())
  end
  --update item list
  dlg:UpdateListContent(Object)

end

local function RemoveOldDialogs(Dialog,win)
  while ChoGGi.CheckForTypeInList(win,Dialog) do
    for i = 1, #win do
      if IsKindOf(win[i],Dialog) then
        win[i]:delete()
      end
    end
  end
end

function ChoGGi.CloseDialogsECM()
  local win = terminal.desktop
  RemoveOldDialogs("Examine",win)
  RemoveOldDialogs("ObjectManipulator",win)
  RemoveOldDialogs("ListChoiceCustomDialog",win)
end

function ChoGGi.SetMechanizedDepotTempAmount(Obj,amount)
  amount = amount or 10
  local resource = Obj.resource
  local io_stockpile = Obj.stockpiles[1]
  local io_supply_req = io_stockpile.supply[resource]
  local io_demand_req = io_stockpile.demand[resource]

  io_stockpile.max_z = amount
  amount = (amount * 10) * ChoGGi.Consts.ResourceScale
  io_supply_req:SetAmount(amount)
  io_demand_req:SetAmount(amount)
end
