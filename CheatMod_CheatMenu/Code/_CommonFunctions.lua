--any funcs called from Code/*.lua

--make some easy to type names
function console(...)ConsolePrint(tostring(...))end
function examine(Obj)OpenExamine(Obj)end
function ex(Obj)OpenExamine(Obj)end
function con(...)console(...)end
function dump(...)ChoGGi.Funcs.Dump(...)end
function dumpobject(...)ChoGGi.Funcs.DumpObject(...)end
function dumplua(...)ChoGGi.Funcs.DumpLua(...)end
function dumptable(...)ChoGGi.Funcs.DumpTable(...)end
function dumpo(...)ChoGGi.Funcs.DumpObject(...)end
function dumpl(...)ChoGGi.Funcs.DumpLua(...)end
function dumpt(...)ChoGGi.Funcs.DumpTable(...)end
function alert(...)ChoGGi.Funcs.MsgPopup(...)end
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
function ChoGGi.Funcs.GetSpeedDrone()
  local MoveSpeed = ChoGGi.Consts.SpeedDrone

  if UICity and UICity:IsTechResearched("LowGDrive") then
    local p = ChoGGi.Funcs.ReturnTechAmount("LowGDrive","move_speed")
    MoveSpeed = MoveSpeed + MoveSpeed * p
  end
  if UICity and UICity:IsTechResearched("AdvancedDroneDrive") then
    local p = ChoGGi.Funcs.ReturnTechAmount("AdvancedDroneDrive","move_speed")
    MoveSpeed = MoveSpeed + MoveSpeed * p
  end

  return MoveSpeed
end

function ChoGGi.Funcs.GetSpeedRC()
  if UICity and UICity:IsTechResearched("LowGDrive") then
    local p = ChoGGi.Funcs.ReturnTechAmount("LowGDrive","move_speed")
    return ChoGGi.Consts.SpeedRC + ChoGGi.Consts.SpeedRC * p
  end
  return ChoGGi.Consts.SpeedRC
end

function ChoGGi.Funcs.GetCargoCapacity()
  if UICity and UICity:IsTechResearched("FuelCompression") then
    local a = ChoGGi.Funcs.ReturnTechAmount("FuelCompression","CargoCapacity")
    return ChoGGi.Consts.CargoCapacity + a
  end
  return ChoGGi.Consts.CargoCapacity
end
--
function ChoGGi.Funcs.GetCommandCenterMaxDrones()
  if UICity and UICity:IsTechResearched("DroneSwarm") then
    local a = ChoGGi.Funcs.ReturnTechAmount("DroneSwarm","CommandCenterMaxDrones")
    return ChoGGi.Consts.CommandCenterMaxDrones + a
  end
  return ChoGGi.Consts.CommandCenterMaxDrones
end
--
function ChoGGi.Funcs.GetDroneResourceCarryAmount()
  if UICity and UICity:IsTechResearched("ArtificialMuscles") then
    local a = ChoGGi.Funcs.ReturnTechAmount("ArtificialMuscles","DroneResourceCarryAmount")
    return ChoGGi.Consts.DroneResourceCarryAmount + a
  end
  return ChoGGi.Consts.DroneResourceCarryAmount
end
--
function ChoGGi.Funcs.GetLowSanityNegativeTraitChance()
  if UICity and UICity:IsTechResearched("SupportiveCommunity") then
    local p = ChoGGi.Funcs.ReturnTechAmount("SupportiveCommunity","LowSanityNegativeTraitChance")
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
function ChoGGi.Funcs.GetMaxColonistsPerRocket()
  local PerRocket = ChoGGi.Consts.MaxColonistsPerRocket
  if UICity and UICity:IsTechResearched("CompactPassengerModule") then
    local a = ChoGGi.Funcs.ReturnTechAmount("CompactPassengerModule","MaxColonistsPerRocket")
    PerRocket = PerRocket + a
  end
  if UICity and UICity:IsTechResearched("CryoSleep") then
    local a = ChoGGi.Funcs.ReturnTechAmount("CryoSleep","MaxColonistsPerRocket")
    PerRocket = PerRocket + a
  end
  return PerRocket
end
--
function ChoGGi.Funcs.GetNonSpecialistPerformancePenalty()
  if UICity and UICity:IsTechResearched("GeneralTraining") then
    local a = ChoGGi.Funcs.ReturnTechAmount("GeneralTraining","NonSpecialistPerformancePenalty")
    return ChoGGi.Consts.NonSpecialistPerformancePenalty - a
  end
  return ChoGGi.Consts.NonSpecialistPerformancePenalty
end
--
function ChoGGi.Funcs.GetRCRoverMaxDrones()
  if UICity and UICity:IsTechResearched("RoverCommandAI") then
    local a = ChoGGi.Funcs.ReturnTechAmount("RoverCommandAI","RCRoverMaxDrones")
    return ChoGGi.Consts.RCRoverMaxDrones + a
  end
  return ChoGGi.Consts.RCRoverMaxDrones
end
--
function ChoGGi.Funcs.GetRCTransportGatherResourceWorkTime()
  if UICity and UICity:IsTechResearched("TransportOptimization") then
    local p = ChoGGi.Funcs.ReturnTechAmount("TransportOptimization","RCTransportGatherResourceWorkTime")
    return ChoGGi.Consts.RCTransportGatherResourceWorkTime * p
  end
  return ChoGGi.Consts.RCTransportGatherResourceWorkTime
end
--
function ChoGGi.Funcs.GetRCTransportStorageCapacity()
  if UICity and UICity:IsTechResearched("TransportOptimization") then
    local a = ChoGGi.Funcs.ReturnTechAmount("TransportOptimization","max_shared_storage")
    return ChoGGi.Consts.RCTransportStorageCapacity + (a * ChoGGi.Consts.ResourceScale)
  end
  return ChoGGi.Consts.RCTransportStorageCapacity
end
--
function ChoGGi.Funcs.GetTravelTimeEarthMars()
  if UICity and UICity:IsTechResearched("PlasmaRocket") then
    local p = ChoGGi.Funcs.ReturnTechAmount("PlasmaRocket","TravelTimeEarthMars")
    return ChoGGi.Consts.TravelTimeEarthMars * p
  end
  return ChoGGi.Consts.TravelTimeEarthMars
end
--
function ChoGGi.Funcs.GetTravelTimeMarsEarth()
  if UICity and UICity:IsTechResearched("PlasmaRocket") then
    local p = ChoGGi.Funcs.ReturnTechAmount("PlasmaRocket","TravelTimeMarsEarth")
    return ChoGGi.Consts.TravelTimeMarsEarth * p
  end
  return ChoGGi.Consts.TravelTimeMarsEarth
end

function ChoGGi.Funcs.AttachToNearestDome(building)
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
        dome.labels.Workplace[#dome.labels.Workplace+1] = building
      elseif building.colonists then
        dome.labels.Workplace[#dome.labels.Residence+1] = building
      end
    end
  end
end

--toggle working status
function ChoGGi.Funcs.ToggleWorking(building)
  CreateRealTimeThread(function()
    building:ToggleWorking()
    Sleep(5)
    building:ToggleWorking()
  end)
end

function ChoGGi.Funcs.SetCameraSettings()
--cameraRTS.GetProperties(1)

  --size of activation area for border scrolling
  local BorderScrollingArea = ChoGGi.UserSettings.BorderScrollingArea
  if BorderScrollingArea then
    cameraRTS.SetProperties(1,{ScrollBorder = BorderScrollingArea})
  else
    --default
    cameraRTS.SetProperties(1,{ScrollBorder = 5})
  end

  --zoom
  --camera.GetFovY()
  --camera.GetFovX()
  local CameraZoomToggle = ChoGGi.UserSettings.CameraZoomToggle
  if CameraZoomToggle then
    if type(CameraZoomToggle) == "number" then
      cameraRTS.SetZoomLimits(0,CameraZoomToggle)
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

function ChoGGi.Funcs.RemoveOldFiles()
  CreateRealTimeThread(function()
    local Table = {
      "UserSettings",
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
      --fourth
      "ReplacedFunctions",
      "Code/SponsorsFunc",
      "Code/SponsorsMenu",
      "Code/UIDesignerData",
    }
    local tab = Table or empty_table
    for i = 1, #tab do
      AsyncFileDelete(ChoGGi.ModPath .. tab[i] .. ".lua")
    end
    AsyncFileDelete(ChoGGi.ModPath .. "libs")

    --old settings that aren't used anymore
    ChoGGi.UserSettings.AddMysteryBreakthroughBuildings = nil
    ChoGGi.UserSettings.AirWaterAddAmount = nil
    ChoGGi.UserSettings.AirWaterBatteryAddAmount = nil
    ChoGGi.UserSettings.BatteryAddAmount = nil
    ChoGGi.UserSettings.BorderScrollingToggle = nil
    ChoGGi.UserSettings.Building_dome_forbidden = nil
    ChoGGi.UserSettings.Building_dome_required = nil
    ChoGGi.UserSettings.Building_is_tall = nil
    ChoGGi.UserSettings.CapacityShuttle = nil
    ChoGGi.UserSettings.CommanderAstrogeologist = nil
    ChoGGi.UserSettings.CommanderAuthor = nil
    ChoGGi.UserSettings.CommanderDoctor = nil
    ChoGGi.UserSettings.CommanderEcologist = nil
    ChoGGi.UserSettings.CommanderHydroEngineer = nil
    ChoGGi.UserSettings.CommanderInventor = nil
    ChoGGi.UserSettings.CommanderOligarch = nil
    ChoGGi.UserSettings.CommanderPolitician = nil
    ChoGGi.UserSettings.developer = nil
    ChoGGi.UserSettings.FullyAutomatedBuildingsPerf = nil
    ChoGGi.UserSettings.NewColonistSex = nil
    ChoGGi.UserSettings.ProductionAddAmount = nil
    ChoGGi.UserSettings.ResidenceAddAmount = nil
    ChoGGi.UserSettings.ResidenceMaxHeight = nil
    ChoGGi.UserSettings.ShuttleAddAmount = nil
    ChoGGi.UserSettings.ShuttleSpeed = nil
    ChoGGi.UserSettings.ShuttleStorage = nil
    ChoGGi.UserSettings.SponsorBlueSun = nil
    ChoGGi.UserSettings.SponsorCNSA = nil
    ChoGGi.UserSettings.SponsorESA = nil
    ChoGGi.UserSettings.SponsorISRO = nil
    ChoGGi.UserSettings.SponsorNASA = nil
    ChoGGi.UserSettings.SponsorNewArk = nil
    ChoGGi.UserSettings.SponsorParadox = nil
    ChoGGi.UserSettings.SponsorRoscosmos = nil
    ChoGGi.UserSettings.SponsorSpaceY = nil
    ChoGGi.UserSettings.ToggleInfopanelCheats = nil
    ChoGGi.UserSettings.TrainersAddAmount = nil
  end)
end

function ChoGGi.Funcs.ShowBuildMenu(iWhich)
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

function ChoGGi.Funcs.ColonistUpdateAge(Colonist,Age)
  if Age == "Random" then
    Age = ChoGGi.Tables.ColonistAges[UICity:Random(1,6)]
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

function ChoGGi.Funcs.ColonistUpdateGender(Colonist,Gender,Cloned)
  if Gender == "Random" then
    Gender = ChoGGi.Tables.ColonistGenders[UICity:Random(1,5)]
  elseif Gender == "MaleOrFemale" then
    Gender = ChoGGi.Tables.ColonistGenders[UICity:Random(4,5)]
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

function ChoGGi.Funcs.ColonistUpdateSpecialization(Colonist,Spec)
  if not Colonist.entity:find("Child",1,true) then
    if Spec == "Random" then
      Spec = ChoGGi.Tables.ColonistSpecializations[UICity:Random(1,6)]
    end
    Colonist:SetSpecialization(Spec,"init")
    Colonist:ChooseEntity()
    Colonist:UpdateWorkplace()
    Colonist:TryToEmigrate()
  end
end

function ChoGGi.Funcs.ColonistUpdateTraits(Colonist,Bool,Traits)
  local Type = "RemoveTrait"
  if Bool == true then
    Type = "AddTrait"
  end
  for i = 1, #Traits do
    Colonist[Type](Colonist,Traits[i],true)
  end
end

function ChoGGi.Funcs.ColonistUpdateRace(Colonist,Race)
  if Race == "Random" then
    Race = UICity:Random(1,5)
  end
  Colonist.race = Race
  Colonist:ChooseEntity()
end

function ChoGGi.Funcs.SetCommanderBonuses(sType)
  local currentname = g_CurrentMissionParams.idCommanderProfile
  local comm = MissionParams.idCommanderProfile.items[currentname]
  local bonus = Presets.CommanderProfilePreset.Default[sType]
  local tab = bonus or empty_table
  for i = 1, #tab do
    CreateRealTimeThread(function()
      comm[#comm+1] = tab[i]
    end)
  end
end

function ChoGGi.Funcs.SetSponsorBonuses(sType)
  local currentname = g_CurrentMissionParams.idMissionSponsor
  local sponsor = MissionParams.idMissionSponsor.items[currentname]
  local bonus = Presets.MissionSponsorPreset.Default[sType]
  --bonuses multiple sponsors have (CompareAmounts returns equal or larger amount)
  if sponsor.cargo then
    sponsor.cargo = ChoGGi.Funcs.CompareAmounts(sponsor.cargo,bonus.cargo)
  end
  if sponsor.additional_research_points then
    sponsor.additional_research_points = ChoGGi.Funcs.CompareAmounts(sponsor.additional_research_points,bonus.additional_research_points)
  end

  if sType == "IMM" then
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","FoodPerRocketPassenger",
      "Amount",9000
    })
  elseif sType == "NASA" then
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","SponsorFundingPerInterval",
      "Amount",500
    })
  elseif sType == "BlueSun" then
    sponsor.rocket_price = ChoGGi.Funcs.CompareAmounts(sponsor.rocket_price,bonus.rocket_price)
    sponsor.applicants_price = ChoGGi.Funcs.CompareAmounts(sponsor.applicants_price,bonus.applicants_price)
    sponsor[#sponsor+1] = PlaceObj("TechEffect_GrantTech",{
      "Field","Physics",
      "Research","DeepMetalExtraction"
    })
  elseif sType == "CNSA" then
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","ApplicantGenerationInterval",
      "Percent",-50
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","MaxColonistsPerRocket",
      "Amount",10
    })
  elseif sType == "ISRO" then
    sponsor[#sponsor+1] = PlaceObj("TechEffect_GrantTech",{
      "Field","Engineering",
      "Research","LowGEngineering"
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","Concrete_cost_modifier",
      "Percent",-20
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","Electronics_cost_modifier",
      "Percent",-20
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","MachineParts_cost_modifier",
      "Percent",-20
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","ApplicantsPoolStartingSize",
      "Percent",50
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","Metals_cost_modifier",
      "Percent",-20
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","Polymers_cost_modifier",
      "Percent",-20
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","PreciousMetals_cost_modifier",
      "Percent",-20
    })
  elseif sType == "ESA" then
    sponsor.funding_per_tech = ChoGGi.Funcs.CompareAmounts(sponsor.funding_per_tech,bonus.funding_per_tech)
    sponsor.funding_per_breakthrough = ChoGGi.Funcs.CompareAmounts(sponsor.funding_per_breakthrough,bonus.funding_per_breakthrough)
  elseif sType == "SpaceY" then
    sponsor.modifier_name1 = ChoGGi.Funcs.CompareAmounts(sponsor.modifier_name1,bonus.modifier_name1)
    sponsor.modifier_value1 = ChoGGi.Funcs.CompareAmounts(sponsor.modifier_value1,bonus.modifier_value1)
    sponsor.modifier_name2 = ChoGGi.Funcs.CompareAmounts(sponsor.modifier_name2,bonusmodifier_name2)
    sponsor.modifier_value2 = ChoGGi.Funcs.CompareAmounts(sponsor.modifier_value2,bonus.modifier_value2)
    sponsor.modifier_name3 = ChoGGi.Funcs.CompareAmounts(sponsor.modifier_name3,bonus.modifier_name3)
    sponsor.modifier_value3 = ChoGGi.Funcs.CompareAmounts(sponsor.modifier_value3,bonus.modifier_value3)
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","CommandCenterMaxDrones",
      "Percent",20
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","starting_drones",
      "Percent",4
    })
  elseif sType == "NewArk" then
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","BirthThreshold",
      "Percent",-50
    })
  elseif sType == "Roscosmos" then
    sponsor.modifier_name1 = ChoGGi.Funcs.CompareAmounts(sponsor.modifier_name1,bonus.modifier_name1)
    sponsor.modifier_value1 = ChoGGi.Funcs.CompareAmounts(sponsor.modifier_value1,bonus.modifier_value1)
    sponsor[#sponsor+1] = PlaceObj("TechEffect_GrantTech",{
      "Field","Robotics",
      "Research","FueledExtractors"
    })
  elseif sType == "Paradox" then
    sponsor.applicants_per_breakthrough = ChoGGi.Funcs.CompareAmounts(sponsor.applicants_per_breakthrough,bonus.applicants_per_breakthrough)
    sponsor.anomaly_bonus_breakthrough = ChoGGi.Funcs.CompareAmounts(sponsor.anomaly_bonus_breakthrough,bonus.anomaly_bonus_breakthrough)
  end
end

--called from FireFuncAfterChoice

function ChoGGi.Funcs.WaitListChoiceCustom(Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType)
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

function ChoGGi.Funcs.FireFuncAfterChoice(Func,Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType)
  if not Func or not Items then
    return
  end

  --sort table by display text
  table.sort(Items,
    function(a,b)
      return ChoGGi.Funcs.CompareTableNames(a,b,"text")
    end
  )

  --only insert blank item if we aren't updating other items with it
  if not CustomType then
    --insert blank item for adding custom value
    Items[#Items+1] = {text = "",hint = "",value = false}
  end

  CreateRealTimeThread(function()
    local option = ChoGGi.Funcs.WaitListChoiceCustom(Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType)
    if option ~= "idClose" then
      Func(option)
    end
  end)
end

--some dev removed this from the Spirit update... (harumph)
function ChoGGi.Funcs.AddConsolePrompt(text)
  if dlgConsole then
    local self = dlgConsole
    self:Show(true)
    self.idEdit:Replace(self.idEdit.cursor_pos, self.idEdit.cursor_pos, text, true)
    self.idEdit:SetCursorPos(#text)
  end
end

--toggle visiblity of console log
function ChoGGi.Funcs.ToggleConsoleLog()
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
function ChoGGi.Funcs.FuckingDrones(Producer)
  --Come on, Bender. Grab a jack. I told these guys you were cool.
  --Well, if jacking on will make strangers think I'm cool, I'll do it.
  if not Producer then
    return
  end
  local r = ChoGGi.Consts.ResourceScale
  local amount = Producer:GetAmountStored()
  if amount > r then
    local p = Producer.parent
    local cc = FindNearestObject(p.command_centers,p).drones
    --i'm looking at you rocket
    if #cc == 0 then
      --get a command_center, i'm not sure how to tell nearest to skip an object without drones
      for i = 1, #p.command_centers do
        if #p.command_centers[i].drones > 0 then
          cc = p.command_centers[i].drones
        end
      end
    end
    --get an idle drone
    local drone
    for i = 1, #cc do
      if cc[i].command == "Idle" then
        drone = cc[i]
        break
      end
    end
    if drone then
      local saved = ChoGGi.UserSettings.DroneResourceCarryAmount
      if saved then
        amount = saved * r
      else
        --round to nearest 1000 (don't want uneven stacks)
        amount = (amount - amount % r) / r * r
      end
      --pick that shit up
      drone:SetCommandUserInteraction(
        "PickUp",
        Producer.stockpiles[Producer:GetNextStockpileIndex()].supply_request,
        false,
        Producer.resource_produced,
        amount
      )
    end
  end
end

function ChoGGi.Funcs.SaveOldPalette(Obj)
  local GetPal = Obj.GetColorizationMaterial
  if not Obj.ChoGGi_origcolors then
    Obj.ChoGGi_origcolors = {}
    Obj.ChoGGi_origcolors[#Obj.ChoGGi_origcolors+1] = {GetPal(Obj,1)}
    Obj.ChoGGi_origcolors[#Obj.ChoGGi_origcolors+1] = {GetPal(Obj,2)}
    Obj.ChoGGi_origcolors[#Obj.ChoGGi_origcolors+1] = {GetPal(Obj,3)}
    Obj.ChoGGi_origcolors[#Obj.ChoGGi_origcolors+1] = {GetPal(Obj,4)}
  end
end
function ChoGGi.Funcs.RestoreOldPalette(Obj)
  if Obj.ChoGGi_origcolors then
    local c = Obj.ChoGGi_origcolors
    local SetPal = Obj.SetColorizationMaterial
    SetPal(Obj,1, c[1][1], c[1][2], c[1][3])
    SetPal(Obj,2, c[2][1], c[2][2], c[2][3])
    SetPal(Obj,3, c[3][1], c[3][2], c[3][3])
    SetPal(Obj,4, c[4][1], c[4][2], c[4][3])
    Obj.ChoGGi_origcolors = nil
  end
end

function ChoGGi.Funcs.GetPalette(Obj)
  local g = Obj.GetColorizationMaterial
  local pal = {}
  pal.Color1, pal.Roughness1, pal.Metallic1 = g(Obj, 1)
  pal.Color2, pal.Roughness2, pal.Metallic2 = g(Obj, 2)
  pal.Color3, pal.Roughness3, pal.Metallic3 = g(Obj, 3)
  pal.Color4, pal.Roughness4, pal.Metallic4 = g(Obj, 4)
  return pal
end

function ChoGGi.Funcs.ObjectColourRandom(Obj)
  if Obj:IsKindOf("ColorizableObject") then
    local SetPal = Obj.SetColorizationMaterial
    local GetPal = Obj.GetColorizationMaterial
    local c1,c2,c3,c4 = GetPal(Obj,1),GetPal(Obj,2),GetPal(Obj,3),GetPal(Obj,4)
    --likely can only change basecolour
    if c1 == 8421504 and c2 == 8421504 and c3 == 8421504 and c4 == 8421504 then
      Obj:SetColorModifier(RandColor())
    else
      if not Obj.ChoGGi_origcolors then
        ChoGGi.Funcs.SaveOldPalette(Obj)
      end
      --s,1,Color, Roughness, Metallic
      SetPal(Obj, 1, RandColor(), 0,0)
      SetPal(Obj, 2, RandColor(), 0,0)
      SetPal(Obj, 3, RandColor(), 0,0)
      SetPal(Obj, 4, RandColor(), 0,0)
    end
  end
end
function ChoGGi.Funcs.ObjectColourDefault(Obj)
  if Obj:IsKindOf("ColorizableObject") then
    Obj:SetColorModifier(6579300)
    if Obj.ChoGGi_origcolors then
      local SetPal = Obj.SetColorizationMaterial
      local c = Obj.ChoGGi_origcolors
      SetPal(Obj,1, c[1][1], c[1][2], c[1][3])
      SetPal(Obj,2, c[2][1], c[2][2], c[2][3])
      SetPal(Obj,3, c[3][1], c[3][2], c[3][3])
      SetPal(Obj,4, c[4][1], c[4][2], c[4][3])
    end
  end
end

function ChoGGi.Funcs.OpenInObjectManipulator(Object,Parent)
  --nil or selected self
  if not Object or (Object.action and Object.idx) then
    Object = SelectedObj or SelectionMouseObj() or ChoGGi.Funcs.CursorNearestObject()
  end

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
  if type(Object) == "table" and Object.class then
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

function ChoGGi.Funcs.RemoveOldDialogs(Dialog,win)
  while ChoGGi.Funcs.CheckForTypeInList(win,Dialog) do
    for i = 1, #win do
      if IsKindOf(win[i],Dialog) then
        win[i]:delete()
      end
    end
  end
end

function ChoGGi.Funcs.CloseDialogsECM()
  local win = terminal.desktop
  ChoGGi.Funcs.RemoveOldDialogs("Examine",win)
  ChoGGi.Funcs.RemoveOldDialogs("ObjectManipulator",win)
  ChoGGi.Funcs.RemoveOldDialogs("ListChoiceCustomDialog",win)
end

function ChoGGi.Funcs.SetMechanizedDepotTempAmount(Obj,amount)
  amount = amount or 10
  local resource = Obj.resource
  local io_stockpile = Obj.stockpiles[Obj:GetNextStockpileIndex()]
  local io_supply_req = io_stockpile.supply[resource]
  local io_demand_req = io_stockpile.demand[resource]

  io_stockpile.max_z = amount
  amount = (amount * 10) * ChoGGi.Consts.ResourceScale
  io_supply_req:SetAmount(amount)
  io_demand_req:SetAmount(amount)
end

function ChoGGi.Funcs.NewThread(Func,...)
  coroutine.resume(coroutine.create(Func),...)
end

function ChoGGi.Funcs.BuildMenu_Toggle()
  local dlg = GetXDialog("XBuildMenu")
  if not dlg then
    return
  end

  CreateRealTimeThread(function()
    CloseXBuildMenu()
    Sleep(250)
    OpenXBuildMenu()
  end)
end

--sticks small depot in front of mech depot and moves all resources to it (max of 20 000)
function ChoGGi.Funcs.EmptyMechDepot(oldobj)

  if not oldobj or not IsKindOf(oldobj,"MechanizedDepot") then
    oldobj = SelectedObj or SelectionMouseObj() or ChoGGi.Funcs.CursorNearestObject()
  end
  if not IsKindOf(oldobj,"MechanizedDepot") then
    return
  end

  local res = oldobj.resource
  local amount = oldobj["GetStored_" .. res](oldobj)
  --not good to be larger then this when game is saved
  if amount > 20000000 then
    amount = amount
  end
  local stock = oldobj.stockpiles[oldobj:GetNextStockpileIndex()]
  local angle = oldobj:GetAngle()
  --new pos based on angle of old depot (so it's in front not under it)
  local newx = 0
  local newy = 0
  if angle == 0 then
    newx = 500
    newy = 0
  elseif angle == 3600 then
    newx = 500
    newy = 500
  elseif angle == 7200 then
    newx = 0
    newy = 500
  elseif angle == 10800 then
    newx = -600
    newy = 0
  elseif angle == 14400 then
    newx = 0
    newy = -500
  elseif angle == 18000 then
    newx = 500
    newy = -500
  end
  local oldpos = stock:GetPos()
  local newpos = point(oldpos:x() + newx,oldpos:y() + newy,oldpos:z())
  --create new depot, and set max amount to stored amount of old depot
  local newobj = PlaceObj("UniversalStorageDepot", {
    "template_name", "Storage" .. res,
    "resource", {res},
    "stockpiled_amount", {},
    "max_storage_per_resource", amount,
    --make sure it's on a hex point after we moved it in front
    "Pos", HexGetNearestCenter(newpos),
  })
  --make it align with the depot
  newobj:SetAngle(angle)
  --give it a bit before filling
  CreateRealTimeThread(function()
    local time = 0
    repeat
      Sleep(25)
      time = time + 25
    until type(newobj.requester_id) == "number" or time > 5000
    --since we set new depot max amount to old amount we can just fill it
    newobj:CheatFill()
    --clean out old depot
    oldobj:CheatEmpty()
  end)
end

--used to check for some SM objects (Points/Boxes)
function ChoGGi.Funcs.RetType(Obj)
  local meta = getmetatable(Obj)
  if meta then
    if IsPoint(Obj) then
      return "Point"
    end
    if IsBox(Obj) then
      return "Box"
    end
  end
end
function ChoGGi.Funcs.ChangeObjectColour(obj,Parent)
  if not obj and not obj:IsKindOf("ColorizableObject") then
    ChoGGi.Funcs.MsgPopup("Can't colour object","Colour")
    return
  end
  --SetPal(Obj,i,Color,Roughness,Metallic)
  local SetPal = obj.SetColorizationMaterial
  local pal = ChoGGi.Funcs.GetPalette(obj)

  local ItemList = {}
  for i = 1, 4 do
    ItemList[#ItemList+1] = {
      text = "Colour " .. i,
      value = pal["Color" .. i],
      hint = "Use the colour picker (dbl-click for instant change).",
    }
    ItemList[#ItemList+1] = {
      text = "Metallic " .. i,
      value = pal["Metallic" .. i],
      hint = "Don't use the colour picker: Numbers range from -255 to 255.",
    }
    ItemList[#ItemList+1] = {
      text = "Roughness " .. i,
      value = pal["Roughness" .. i],
      hint = "Don't use the colour picker: Numbers range from -255 to 255.",
    }
  end
  ItemList[#ItemList+1] = {
    text = "X_BaseColour",
    value = 6579300,
    obj = obj,
    hint = "single colour for object (this colour will interact with the other colours).\nIf you want to change the colour of an object you can't with 1-4 (like drones).",
  }

  --callback
  local CallBackFunc = function(choice)
    if #choice == 13 then
      --keep original colours as part of object
      local base = choice[13].value
      --used to check for grid connections
      local CheckAir = choice[1].checkair
      local CheckWater = choice[1].checkwater
      local CheckElec = choice[1].checkelec
      --needed to set attachment colours
      local Label = obj.class
      local FakeParent
      if Parent then
        Label = Parent.class
        FakeParent = Parent
      else
        FakeParent = obj.parentobj
      end
      if not FakeParent then
        FakeParent = obj
      end
      --they get called a few times so
      local function SetOrigColours(Object)
        ChoGGi.Funcs.RestoreOldPalette(Object)
        --6579300 = reset base color
        Object:SetColorModifier(6579300)
      end
      local function SetColours(Object)
        ChoGGi.Funcs.SaveOldPalette(Object)
        for i = 1, 4 do
          local Color = choice[i].value
          local Metallic = choice[i+4].value
          local Roughness = choice[i+8].value
          SetPal(Object,i,Color,Roughness,Metallic)
        end
        Object:SetColorModifier(base)
      end
      --make sure we're in the same grid
      local function CheckGrid(Func,Object,Building)
        if CheckAir and Building.air and FakeParent.air and Building.air.grid.elements[1].building.handle == FakeParent.air.grid.elements[1].building.handle then
          Func(Object)
        end
        if CheckWater and Building.water and FakeParent.water and Building.water.grid.elements[1].building.handle == FakeParent.water.grid.elements[1].building.handle then
          Func(Object)
        end
        if CheckElec and Building.electricity and FakeParent.electricity and Building.electricity.grid.elements[1].building.handle == FakeParent.electricity.grid.elements[1].building.handle then
          Func(Object)
        end
        if not CheckAir and not CheckWater and not CheckElec then
          Func(Object)
        end
      end

      --store table so it's the same as was displayed
      table.sort(choice,
        function(a,b)
          return ChoGGi.Funcs.CompareTableNames(a,b,"text")
        end
      )
      --All of type checkbox
      if choice[1].check1 then
        local tab = UICity.labels[Label] or empty_table
        for i = 1, #tab do
          if Parent then
            local Attaches = tab[i]:GetAttaches()
            for j = 1, #Attaches do
              if Attaches[j].class == obj.class then
                if choice[1].check2 then
                  CheckGrid(SetOrigColours,Attaches[j],tab[i])
                else
                  CheckGrid(SetColours,Attaches[j],tab[i])
                end
              end
            end
          else --not parent
            if choice[1].check2 then
              CheckGrid(SetOrigColours,tab[i],tab[i])
            else
              CheckGrid(SetColours,tab[i],tab[i])
            end
          end --Parent
        end
      else --single building change
        if choice[1].check2 then
          CheckGrid(SetOrigColours,obj,obj)
        else
          CheckGrid(SetColours,obj,obj)
        end
      end

      ChoGGi.Funcs.MsgPopup("Colour is set on " .. obj.class,"Colour")
    end
  end
  local hint = "If number is 8421504 (0 for Metallic/Roughness) then you probably can't change that colour.\n\nThe colour picker doesn't work for Metallic/Roughness.\nYou can copy and paste numbers if you want (click item again after picking)."
  local hint_check1 = "Change all objects of the same type."
  local hint_check2 = "if they're there; resets to default colours."
  ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"Change Colour: " .. obj.class,hint,true,"All of type",hint_check1,"Default Colour",hint_check2,2)
end

function ChoGGi.Funcs.CursorNearestHex()
  return HexGetNearestCenter(GetTerrainCursor())
end
function ChoGGi.Funcs.CursorNearestObject()
  local objs = ChoGGi.Funcs.RemoveFromTable(GetObjects({class="PropertyObject"}),{ParSystem=1},"class")
  return NearestObject(GetTerrainCursor(),objs,500)
end

