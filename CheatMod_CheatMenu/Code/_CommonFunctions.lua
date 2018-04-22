--any functions called from Code/*.lua

function ChoGGi.AttachToNearestDome(building)

  --ignore outdoor buildings
  if  building.dome_required ~= true then
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

--creates a list for use with ObjectManipulator
function ChoGGi.CreatePropList(Object)
  local List

  return List
end

function ChoGGi.OpenInObjectManipulator(Object,Parent)
  if not Object then
    return
  end

  local dlg = OpenDialog("ObjectManipulatorDialog", nil, Parent or terminal.desktop)
ChoGGi.ObjectManipulatorDialog_Dlg = dlg
  if dlg then
    --title text
    if Object.entity then
      dlg.idCaption:SetText(Object.entity .. " - " .. Object.class)
    else
      dlg.idCaption:SetText(Object.class)
    end
    if not Parent then
      dlg:SetPos(terminal.GetMousePos())
    end

    dlg.obj = Object

    --create prop list for list
    local list = ChoGGi.CreatePropList(Object)
    if not list then
      dlg.idList:SetContent({{text="Error"}})
---------TESTING
dlg.idList:SetContent({
    {
      text = "   Really long text to test out some stuff, feel free to ignore if I forget to remove this when I upload the next version. Thank you. uiyghjkjgfjhcvbmnjuyghfjeriuy23o7q5tugrtesh;394o5f7syo58j4t7sc6yknl345u;j836cvylte4eksdocfx6j8745tyxdt89ydvpe8xtroo8c7dry......................",
      hint = "long",
    },
  {text = 1,hint = 11111,column1 = true},
  {text = 2,hint = 22222,column2 = true},
  {text = 3,hint = 33333,column3 = true}
})
---------TESTING
      return
    end
    dlg.idList:SetContent(list)

  end
end
