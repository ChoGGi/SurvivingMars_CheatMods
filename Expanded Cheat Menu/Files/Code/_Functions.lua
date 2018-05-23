--any funcs called from Code/*

do --for those that don't know do*end is a way of keeping "local" local to the do
  --make some easy to type names
  local ChoGGi = ChoGGi
  local OpenExamine = OpenExamine
  function examine(Obj)OpenExamine(Obj)end
  function ex(Obj)OpenExamine(Obj)end
  function dump(...)ChoGGi.ComFuncs.Dump(...)end
  function dumpobject(...)ChoGGi.ComFuncs.DumpObject(...)end
  function dumplua(...)ChoGGi.ComFuncs.DumpLua(...)end
  function dumptable(...)ChoGGi.ComFuncs.DumpTable(...)end
  function dumpo(...)ChoGGi.ComFuncs.DumpObject(...)end
  function dumpl(...)ChoGGi.ComFuncs.DumpLua(...)end
  function dumpt(...)ChoGGi.ComFuncs.DumpTable(...)end
  function alert(...)ChoGGi.ComFuncs.MsgPopup(...)end
  function restart()quit("restart")end
  reboot = restart
  exit = quit
  trans = ChoGGi.CodeFuncs.Trans
  mh = GetTerrainCursorObjSel
  mc = GetPreciseCursorObj
  m = SelectionMouseObj
  c = GetTerrainCursor --cursor position on map
  cs = terminal.GetMousePos --cursor pos on screen
  s = false --used to store SelectedObj
  function so()return ChoGGi.CodeFuncs.SelObject()end
end

--check if tech is researched before we get value
do
  local ChoGGi = ChoGGi
  function ChoGGi.CodeFuncs.GetSpeedDrone()
    local UICity = UICity
    local MoveSpeed = ChoGGi.Consts.SpeedDrone

    if UICity and UICity:IsTechResearched("LowGDrive") then
      local p = ChoGGi.ComFuncs.ReturnTechAmount("LowGDrive","move_speed")
      MoveSpeed = MoveSpeed + MoveSpeed * p
    end
    if UICity and UICity:IsTechResearched("AdvancedDroneDrive") then
      local p = ChoGGi.ComFuncs.ReturnTechAmount("AdvancedDroneDrive","move_speed")
      MoveSpeed = MoveSpeed + MoveSpeed * p
    end

    return MoveSpeed
  end

  function ChoGGi.CodeFuncs.GetSpeedRC()
    local UICity = UICity
    if UICity and UICity:IsTechResearched("LowGDrive") then
      local p = ChoGGi.ComFuncs.ReturnTechAmount("LowGDrive","move_speed")
      return ChoGGi.Consts.SpeedRC + ChoGGi.Consts.SpeedRC * p
    end
    return ChoGGi.Consts.SpeedRC
  end

  function ChoGGi.CodeFuncs.GetCargoCapacity()
    local UICity = UICity
    if UICity and UICity:IsTechResearched("FuelCompression") then
      local a = ChoGGi.ComFuncs.ReturnTechAmount("FuelCompression","CargoCapacity")
      return ChoGGi.Consts.CargoCapacity + a
    end
    return ChoGGi.Consts.CargoCapacity
  end
  --
  function ChoGGi.CodeFuncs.GetCommandCenterMaxDrones()
    local UICity = UICity
    if UICity and UICity:IsTechResearched("DroneSwarm") then
      local a = ChoGGi.ComFuncs.ReturnTechAmount("DroneSwarm","CommandCenterMaxDrones")
      return ChoGGi.Consts.CommandCenterMaxDrones + a
    end
    return ChoGGi.Consts.CommandCenterMaxDrones
  end
  --
  function ChoGGi.CodeFuncs.GetDroneResourceCarryAmount()
    local UICity = UICity
    if UICity and UICity:IsTechResearched("ArtificialMuscles") then
      local a = ChoGGi.ComFuncs.ReturnTechAmount("ArtificialMuscles","DroneResourceCarryAmount")
      return ChoGGi.Consts.DroneResourceCarryAmount + a
    end
    return ChoGGi.Consts.DroneResourceCarryAmount
  end
  --
  function ChoGGi.CodeFuncs.GetLowSanityNegativeTraitChance()
    local UICity = UICity
    if UICity and UICity:IsTechResearched("SupportiveCommunity") then
      local p = ChoGGi.ComFuncs.ReturnTechAmount("SupportiveCommunity","LowSanityNegativeTraitChance")
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
  function ChoGGi.CodeFuncs.GetMaxColonistsPerRocket()
    local UICity = UICity
    local PerRocket = ChoGGi.Consts.MaxColonistsPerRocket
    if UICity and UICity:IsTechResearched("CompactPassengerModule") then
      local a = ChoGGi.ComFuncs.ReturnTechAmount("CompactPassengerModule","MaxColonistsPerRocket")
      PerRocket = PerRocket + a
    end
    if UICity and UICity:IsTechResearched("CryoSleep") then
      local a = ChoGGi.ComFuncs.ReturnTechAmount("CryoSleep","MaxColonistsPerRocket")
      PerRocket = PerRocket + a
    end
    return PerRocket
  end
  --
  function ChoGGi.CodeFuncs.GetNonSpecialistPerformancePenalty()
    local UICity = UICity
    if UICity and UICity:IsTechResearched("GeneralTraining") then
      local a = ChoGGi.ComFuncs.ReturnTechAmount("GeneralTraining","NonSpecialistPerformancePenalty")
      return ChoGGi.Consts.NonSpecialistPerformancePenalty - a
    end
    return ChoGGi.Consts.NonSpecialistPerformancePenalty
  end
  --
  function ChoGGi.CodeFuncs.GetRCRoverMaxDrones()
    local UICity = UICity
    if UICity and UICity:IsTechResearched("RoverCommandAI") then
      local a = ChoGGi.ComFuncs.ReturnTechAmount("RoverCommandAI","RCRoverMaxDrones")
      return ChoGGi.Consts.RCRoverMaxDrones + a
    end
    return ChoGGi.Consts.RCRoverMaxDrones
  end
  --
  function ChoGGi.CodeFuncs.GetRCTransportGatherResourceWorkTime()
    local UICity = UICity
    if UICity and UICity:IsTechResearched("TransportOptimization") then
      local p = ChoGGi.ComFuncs.ReturnTechAmount("TransportOptimization","RCTransportGatherResourceWorkTime")
      return ChoGGi.Consts.RCTransportGatherResourceWorkTime * p
    end
    return ChoGGi.Consts.RCTransportGatherResourceWorkTime
  end
  --
  function ChoGGi.CodeFuncs.GetRCTransportStorageCapacity()
    local UICity = UICity
    if UICity and UICity:IsTechResearched("TransportOptimization") then
      local a = ChoGGi.ComFuncs.ReturnTechAmount("TransportOptimization","max_shared_storage")
      return ChoGGi.Consts.RCTransportStorageCapacity + (a * ChoGGi.Consts.ResourceScale)
    end
    return ChoGGi.Consts.RCTransportStorageCapacity
  end
  --
  function ChoGGi.CodeFuncs.GetTravelTimeEarthMars()
    local UICity = UICity
    if UICity and UICity:IsTechResearched("PlasmaRocket") then
      local p = ChoGGi.ComFuncs.ReturnTechAmount("PlasmaRocket","TravelTimeEarthMars")
      return ChoGGi.Consts.TravelTimeEarthMars * p
    end
    return ChoGGi.Consts.TravelTimeEarthMars
  end
  --
  function ChoGGi.CodeFuncs.GetTravelTimeMarsEarth()
    local UICity = UICity
    if UICity and UICity:IsTechResearched("PlasmaRocket") then
      local p = ChoGGi.ComFuncs.ReturnTechAmount("PlasmaRocket","TravelTimeMarsEarth")
      return ChoGGi.Consts.TravelTimeMarsEarth * p
    end
    return ChoGGi.Consts.TravelTimeMarsEarth
  end
end

--if building requires a dome and that dome is broked then assign it to nearest dome
function ChoGGi.CodeFuncs.AttachToNearestDome(building)
  local workingdomes = ChoGGi.ComFuncs.FilterFromTable(GetObjects({class="Dome"}),nil,nil,"working") or empty_table
  --check for dome and ignore outdoor buildings *and* if there aren't any domes on map
  if not building.parent_dome and building:GetDefaultPropertyValue("dome_required") and #workingdomes > 0 then
    --find the nearest dome
    local dome = FindNearestObject(workingdomes,building)
    if dome and dome.labels then
      building.parent_dome = dome
      --add to dome labels
      dome:AddToLabel("InsideBuildings", building)
      --work/res
      if building:IsKindOf("Workplace") then
        dome:AddToLabel("Workplace", building)
      elseif building:IsKindOf("Residence") then
        dome:AddToLabel("Residence", building)
      end
      --spires
      if building:IsKindOf("WaterReclamationSpire") then
        dome:AddToLabel("WaterReclamationSpires", building)
      elseif building:IsKindOf("NetworkNode") then
        building.parent_dome:SetLabelModifier("BaseResearchLab", "NetworkNode", building.modifier)
      end
    end
  end
end

--toggle working status
function ChoGGi.CodeFuncs.ToggleWorking(building)
  if IsValid(building) then
    if not pcall(function()
      CreateRealTimeThread(function()
        building:ToggleWorking()
        Sleep(5)
        building:ToggleWorking()
      end)
    end) then
      print("Error borked building: " .. building.class)
      OpenExamine(building)
    end
  end
end

function ChoGGi.CodeFuncs.SetCameraSettings()
  local ChoGGi = ChoGGi
  local camera = camera
  local cameraRTS = cameraRTS
  --cameraRTS.GetProperties(1)

  --size of activation area for border scrolling
  if ChoGGi.UserSettings.BorderScrollingArea then
    cameraRTS.SetProperties(1,{ScrollBorder = ChoGGi.UserSettings.BorderScrollingArea})
  else
    --default
    cameraRTS.SetProperties(1,{ScrollBorder = 5})
  end

  --zoom
  --camera.GetFovY()
  --camera.GetFovX()
  if ChoGGi.UserSettings.CameraZoomToggle then
    if type(ChoGGi.UserSettings.CameraZoomToggle) == "number" then
      cameraRTS.SetZoomLimits(0,ChoGGi.UserSettings.CameraZoomToggle)
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
    cameraRTS.SetZoomLimits(400,15000)
  end

  --cameraRTS.SetProperties(1,{HeightInertia = 0})
end

function ChoGGi.CodeFuncs.RemoveOldFiles()
  local ChoGGi = ChoGGi
  --using a pack file now so we can skip most of this
  local Files = {
    --[[
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
    --]]
    --fifth
    "Functions",
    "Settings",
  }
  for i = 1, #Files do
    AsyncFileDelete(ChoGGi.ModPath .. "/" .. Files[i] .. ".lua")
  end
  --AsyncFileDelete(ChoGGi.ModPath .. "/libs")

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
  ChoGGi.UserSettings.FullyAutomatedBuildings = nil
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
end

function ChoGGi.CodeFuncs.ShowBuildMenu(iWhich)
  --make sure we're not in the main menu (deactiving mods when going back to main menu would be nice, have to check for a msg to use)
  local BuildCategories = BuildCategories
  local igi = GetInGameInterface()
  if not igi or not igi:GetVisible() then
    return
  end
  local pinsdlg = false
  for i = 1, #igi do
    if igi[i].class == "PinsDlg" then
      pinsdlg = true
    end
  end
  if not pinsdlg then
    return
  end

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

function ChoGGi.CodeFuncs.ColonistUpdateAge(Colonist,Age)
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
  --Colonist:TryToEmigrate()
end

function ChoGGi.CodeFuncs.ColonistUpdateGender(Colonist,Gender,Cloned)
  local ChoGGi = ChoGGi
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

function ChoGGi.CodeFuncs.ColonistUpdateSpecialization(Colonist,Spec)
  --children don't have spec models so they get black cube
  if not Colonist.entity:find("Child",1,true) then
    if Spec == "Random" then
      Spec = ChoGGi.Tables.ColonistSpecializations[UICity:Random(1,6)]
    end
    Colonist:SetSpecialization(Spec,"init")
    Colonist:ChooseEntity()
    Colonist:UpdateWorkplace()
    --randomly fails on colonists from rockets
    --Colonist:TryToEmigrate()
  end
end

function ChoGGi.CodeFuncs.ColonistUpdateTraits(Colonist,Bool,Traits)
  local Type = "RemoveTrait"
  if Bool == true then
    Type = "AddTrait"
  end
  for i = 1, #Traits do
    Colonist[Type](Colonist,Traits[i],true)
  end
end

function ChoGGi.CodeFuncs.ColonistUpdateRace(Colonist,Race)
  if Race == "Random" then
    Race = UICity:Random(1,5)
  end
  Colonist.race = Race
  Colonist:ChooseEntity()
end

--[[
called below from FireFuncAfterChoice

CustomType=1 : updates selected item with custom value type, dbl click opens colour changer, and sends back all items
CustomType=2 : colour selector
CustomType=3 : updates selected item with custom value type, and sends back selected item.
CustomType=4 : updates selected item with custom value type, and sends back all items
CustomType=5 : for Lightmodel: show colour selector when listitem.editor = color,pressing check2 applies the lightmodel without closing dialog, dbl rightclick shows lightmodel lists and lets you pick one to use in new window
CustomType=6 : same as 3, but dbl rightclick executes CustomFunc(selecteditem.func)

okay, maybe a few too many args, probably should send it as a table, but that means refactoring)
--]]
function ChoGGi.CodeFuncs.WaitListChoiceCustom(Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType,CustomFunc)
  local ChoGGi = ChoGGi
  local dlg = ChoGGi_ListChoiceCustomDialog:new()

  if not dlg then
    return
  end

  if ChoGGi.Temp.Testing then
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
    if CustomType == 2 or CustomType == 5 then
      dlg.idList:SetSelection(1, true)
      dlg.sel = dlg.idList:GetSelection()[#dlg.idList:GetSelection()]
      dlg.idEditValue:SetText(tostring(dlg.sel.value))
      dlg:UpdateColourPicker()
      if CustomType == 2 then
        dlg:SetWidth(800)
        dlg.idColorHSV:SetVisible(true)
        dlg.idColorCheckAir:SetVisible(true)
        dlg.idColorCheckWater:SetVisible(true)
        dlg.idColorCheckElec:SetVisible(true)
      end
    end
  end

  if CustomFunc then
    dlg.Func = CustomFunc
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

function ChoGGi.CodeFuncs.FireFuncAfterChoice(Func,Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType,CustomFunc)
  local ChoGGi = ChoGGi
  if not Func or not Items then
    return
  end

  --sort table by display text
  local sortby = "text"
  if CustomType == 5 then
    sortby = "sort"
  end
  table.sort(Items,
    function(a,b)
      return ChoGGi.ComFuncs.CompareTableValue(a,b,sortby)
    end
  )

  --only insert blank item if we aren't updating other items with it
  if not CustomType then
    --insert blank item for adding custom value
    Items[#Items+1] = {text = "",hint = "",value = false}
  end

  CreateRealTimeThread(function()
    local option = ChoGGi.CodeFuncs.WaitListChoiceCustom(Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType,CustomFunc)
    if option ~= "idClose" then
      Func(option)
    end
  end)
end

--some dev removed this from the Spirit update... (harumph)
function ChoGGi.CodeFuncs.AddConsolePrompt(text)
  if dlgConsole then
    local self = dlgConsole
    self:Show(true)
    self.idEdit:Replace(self.idEdit.cursor_pos, self.idEdit.cursor_pos, text, true)
    self.idEdit:SetCursorPos(#text)
  end
end

--toggle visiblity of console log
function ChoGGi.CodeFuncs.ToggleConsoleLog()
  local dlgConsoleLog = dlgConsoleLog
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

--[[
    local tab = UICity.labels.BlackCubeStockpiles or empty_table
    for i = 1, #tab do
      ChoGGi.CodeFuncs.FuckingDrones(tab[i])
    end
--]]
--force drones to pickup from object even if they have a large carry cap
function ChoGGi.CodeFuncs.FuckingDrones(Obj)
  local ChoGGi = ChoGGi
  --Come on, Bender. Grab a jack. I told these guys you were cool.
  --Well, if jacking on will make strangers think I'm cool, I'll do it.

  if not Obj then
    return
  end

  local stored
  local p
  local request
  local resource
  --mines/farms/factories
  if Obj.class == "SingleResourceProducer" then
    p = Obj.parent
    stored = Obj:GetAmountStored()
    request = Obj.stockpiles[Obj:GetNextStockpileIndex()].supply_request
    resource = Obj.resource_produced
  elseif Obj.class == "BlackCubeStockpile" then
    p = Obj
    stored = Obj:GetStoredAmount()
    request = Obj.supply_request
    resource = Obj.resource
  end

  --only fire if more then one resource
  if stored > 1000 then
    local drone = ChoGGi.CodeFuncs.GetNearestIdleDrone(p)
    if not drone then
      return
    end

    local carry = g_Consts.DroneResourceCarryAmount * ChoGGi.Consts.ResourceScale
    --round to nearest 1000 (don't want uneven stacks)
    stored = (stored - stored % ChoGGi.Consts.ResourceScale) / ChoGGi.Consts.ResourceScale * ChoGGi.Consts.ResourceScale
    --if carry is smaller then stored then they may not pickup (depends on storage)
    if carry < stored or
      --no picking up more then they can carry
      stored > carry then
        stored = carry
    end
    --pretend it's the user doing it (for more priority?)
    drone:SetCommandUserInteraction(
      "PickUp",
      request,
      false,
      resource,
      stored
    )
  end
end

function ChoGGi.CodeFuncs.GetNearestIdleDrone(Bld)
  local ChoGGi = ChoGGi
  if not Bld or (Bld and not Bld.command_centers) then
    return
  end

  --check if nearest cc has idle drones
  local cc = FindNearestObject(Bld.command_centers,Bld)
  if cc and cc:GetIdleDronesCount() > 0 then
    cc = cc.drones
  else
    --sort command_centers by nearest dist
    table.sort(Bld.command_centers,
      function(a,b)
        return ChoGGi.ComFuncs.CompareTableFuncs(a,b,"GetDist2D",Bld.command_centers)
      end
    )
    --get command_center with idle drones
    for i = 1, #Bld.command_centers do
      if Bld.command_centers[i]:GetIdleDronesCount() > 0 then
        cc = Bld.command_centers[i].drones
        break
      end
    end
  end
  --it happens...
  if not cc then
    return
  end

  --get an idle drone
  for i = 1, #cc do
    if cc[i].command == "Idle" or cc[i].command == "WaitCommand" then
      return cc[i]
    end
  end
end

function ChoGGi.CodeFuncs.SaveOldPalette(Obj)
  local GetPal = Obj.GetColorizationMaterial
  if not Obj.ChoGGi_origcolors then
    Obj.ChoGGi_origcolors = {}
    Obj.ChoGGi_origcolors[#Obj.ChoGGi_origcolors+1] = {GetPal(Obj,1)}
    Obj.ChoGGi_origcolors[#Obj.ChoGGi_origcolors+1] = {GetPal(Obj,2)}
    Obj.ChoGGi_origcolors[#Obj.ChoGGi_origcolors+1] = {GetPal(Obj,3)}
    Obj.ChoGGi_origcolors[#Obj.ChoGGi_origcolors+1] = {GetPal(Obj,4)}
  end
end
function ChoGGi.CodeFuncs.RestoreOldPalette(Obj)
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

function ChoGGi.CodeFuncs.GetPalette(Obj)
  local g = Obj.GetColorizationMaterial
  local pal = {}
  pal.Color1, pal.Roughness1, pal.Metallic1 = g(Obj, 1)
  pal.Color2, pal.Roughness2, pal.Metallic2 = g(Obj, 2)
  pal.Color3, pal.Roughness3, pal.Metallic3 = g(Obj, 3)
  pal.Color4, pal.Roughness4, pal.Metallic4 = g(Obj, 4)
  return pal
end

function ChoGGi.CodeFuncs.RandomColour(Amount)
  local ChoGGi = ChoGGi
  local AsyncRand = AsyncRand

  --no amount return single colour
  if type(Amount) ~= "number" then
    return AsyncRand(16777216) * -1
  end
  local randcolors = {}
  --populate list with amount we want
  for _ = 1, Amount do
    randcolors[#randcolors+1] = AsyncRand(16777216) * -1
  end
  --now remove all dupes and add more till we hit amount
  while true do
    --loop missing amount
    for _ = 1, Amount - #randcolors do
      randcolors[#randcolors+1] = AsyncRand(16777216) * -1
    end
    --then remove dupes
    randcolors = ChoGGi.ComFuncs.RetTableNoDupes(randcolors)
    if #randcolors == Amount then
      break
    end
  end
  return randcolors
end

function ChoGGi.CodeFuncs.ObjectColourRandom(Obj,Base)
  if Obj:IsKindOf("ColorizableObject") then
    local ChoGGi = ChoGGi
    local colour = ChoGGi.CodeFuncs.RandomColour()
    local SetPal = Obj.SetColorizationMaterial
    local GetPal = Obj.GetColorizationMaterial
    local c1,c2,c3,c4 = GetPal(Obj,1),GetPal(Obj,2),GetPal(Obj,3),GetPal(Obj,4)
    --likely can only change basecolour
    if Base or (c1 == 8421504 and c2 == 8421504 and c3 == 8421504 and c4 == 8421504) then
      Obj:SetColorModifier(colour)
    else
      if not Obj.ChoGGi_origcolors then
        ChoGGi.CodeFuncs.SaveOldPalette(Obj)
      end
      --s,1,Color, Roughness, Metallic
      SetPal(Obj, 1, ChoGGi.CodeFuncs.RandomColour(), 0,0)
      SetPal(Obj, 2, ChoGGi.CodeFuncs.RandomColour(), 0,0)
      SetPal(Obj, 3, ChoGGi.CodeFuncs.RandomColour(), 0,0)
      SetPal(Obj, 4, ChoGGi.CodeFuncs.RandomColour(), 0,0)
    end
    return colour
  end
end
function ChoGGi.CodeFuncs.ObjectColourDefault(Obj)
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

do --CloseDialogsECM
  local ChoGGi = ChoGGi
  function ChoGGi.CodeFuncs.RemoveOldDialogs(Dialog,win)
    while ChoGGi.ComFuncs.CheckForTypeInList(win,Dialog) do
      for i = #win, 1, -1 do
        if win[i]:IsKindOf(Dialog) then
          win[i]:delete()
        end
      end
    end
  end

  function ChoGGi.CodeFuncs.CloseDialogsECM()
    local win = terminal.desktop
    ChoGGi.CodeFuncs.RemoveOldDialogs("Examine",win)
    ChoGGi.CodeFuncs.RemoveOldDialogs("ChoGGi_ObjectManipulator",win)
    ChoGGi.CodeFuncs.RemoveOldDialogs("ChoGGi_ListChoiceCustomDialog",win)
    ChoGGi.CodeFuncs.RemoveOldDialogs("ChoGGi_MonitorInfoDlg",win)
    ChoGGi.CodeFuncs.RemoveOldDialogs("ChoGGi_ExecCodeDlg",win)
  end
end

function ChoGGi.CodeFuncs.SetMechanizedDepotTempAmount(Obj,amount)
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

function ChoGGi.CodeFuncs.NewThread(Func,...)
  coroutine.resume(coroutine.create(Func),...)
end

function ChoGGi.CodeFuncs.BuildMenu_Toggle()
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
function ChoGGi.CodeFuncs.EmptyMechDepot(oldobj)
  if not oldobj or not oldobj:IsKindOf("MechanizedDepot") then
    oldobj = ChoGGi.CodeFuncs.SelObject()
  end
  if not oldobj:IsKindOf("MechanizedDepot") then
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
  --new pos based on angle of old depot (so it's in front not inside)
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
  --yeah guys. lets have two names for a resource and use them interchangeably, it'll be fine...
  local res2 = res
  if res == "PreciousMetals" then
    res2 = "RareMetals"
  end
  --create new depot, and set max amount to stored amount of old depot
  local newobj = PlaceObj("UniversalStorageDepot", {
    "template_name", "Storage" .. res2,
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
do --RetType
  local IsPoint = IsPoint
  local IsBox = IsBox
  function ChoGGi.CodeFuncs.RetType(Obj)
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
end

function ChoGGi.CodeFuncs.ChangeObjectColour(obj,Parent)
  local ChoGGi = ChoGGi
  if not obj or obj and not obj:IsKindOf("ColorizableObject") then
    ChoGGi.ComFuncs.MsgPopup("Can't colour object","Colour")
    return
  end
  --SetPal(Obj,i,Color,Roughness,Metallic)
  local SetPal = obj.SetColorizationMaterial
  local pal = ChoGGi.CodeFuncs.GetPalette(obj)

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
        ChoGGi.CodeFuncs.RestoreOldPalette(Object)
        --6579300 = reset base color
        Object:SetColorModifier(6579300)
      end
      local function SetColours(Object)
        ChoGGi.CodeFuncs.SaveOldPalette(Object)
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
        if CheckAir and Building.air and FakeParent.air and Building.air.grid.elements[1].building == FakeParent.air.grid.elements[1].building then
          Func(Object)
        end
        if CheckWater and Building.water and FakeParent.water and Building.water.grid.elements[1].building == FakeParent.water.grid.elements[1].building then
          Func(Object)
        end
        if CheckElec and Building.electricity and FakeParent.electricity and Building.electricity.grid.elements[1].building == FakeParent.electricity.grid.elements[1].building then
          Func(Object)
        end
        if not CheckAir and not CheckWater and not CheckElec then
          Func(Object)
        end
      end

      --store table so it's the same as was displayed
      table.sort(choice,
        function(a,b)
          return ChoGGi.ComFuncs.CompareTableValue(a,b,"text")
        end
      )
      --All of type checkbox
      if choice[1].check1 then
        local tab = UICity.labels[Label] or empty_table
        for i = 1, #tab do
          if Parent then
            local Attaches = tab[i].GetAttaches and tab[i]:GetAttaches() or empty_table
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

      ChoGGi.ComFuncs.MsgPopup("Colour is set on " .. obj.class,"Colour")
    end
  end
  local hint = "If number is 8421504 (0 for Metallic/Roughness) then you probably can't change that colour.\n\nThe colour picker doesn't work for Metallic/Roughness.\nYou can copy and paste numbers if you want (click item again after picking)."
  local hint_check1 = "Change all objects of the same type."
  local hint_check2 = "if they're there; resets to default colours."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Change Colour: " .. obj.class,hint,true,"All of type",hint_check1,"Default Colour",hint_check2,2)
end

--returns the near hex grid for object placement
do --CursorNearestHex
  local HexGetNearestCenter = HexGetNearestCenter
  local GetTerrainCursor = GetTerrainCursor
  function ChoGGi.CodeFuncs.CursorNearestHex()
    return HexGetNearestCenter(GetTerrainCursor())
  end
end

--returns whatever is selected > moused over > nearest non particle object to cursor
do --SelObject
  local GetObjects = GetObjects
  local NearestObject = NearestObject
  local SelectionMouseObj = SelectionMouseObj
  local GetTerrainCursor = GetTerrainCursor
  --#GetObjects({class="CObject"})
  --#GetObjects({class="PropertyObject"})
  function ChoGGi.CodeFuncs.SelObject()
    local _,ret = pcall(function()
      local objs = ChoGGi.ComFuncs.FilterFromTable(GetObjects({class="CObject"}),{ParSystem=1},"class")
      return SelectedObj or SelectionMouseObj() or NearestObject(GetTerrainCursor(),objs,500)
    end)
    return ret
  end
end

function ChoGGi.CodeFuncs.LightmodelBuild(Table)
  local data = DataInstances.Lightmodel
  --always start with blank lightmodel
  data.ChoGGi_Custom:delete()
  data.ChoGGi_Custom = Lightmodel:new()
  data.ChoGGi_Custom.name = "ChoGGi_Custom"

  for i = 1, #Table do
    data.ChoGGi_Custom[Table[i].id] = Table[i].value
  end
  ChoGGi.Temp.LightmodelCustom = data.ChoGGi_Custom
  return data.ChoGGi_Custom
end

function ChoGGi.CodeFuncs.DeleteAllAttaches(Obj)
  if type(Obj.GetAttaches) == "function" then
    local Attaches =  Obj:GetAttaches() or empty_table
    for i = #Attaches, 1, -1 do
      Attaches[i]:delete()
    end
  end
end

do --FindNearestResource
  local FindNearestObject = FindNearestObject
  local FilterObjects = FilterObjects
  local function GetStockpile(Label,Type,Object)
    --check if there's actually a label and that it has anything in it
    if type(Label) == "table" and #Label > 0 then

      --GetStoredAmount works for all piles, but we only want to use it for ResourceStockpiles
      local pile = false
      --if it's a stockpile list then remove all stockpiles of a different type
      if Label[1].class == "ResourceStockpile" or Label[1].class == "ResourceStockpileLR" then
        pile = true
        Label = FilterObjects({
          filter = function(Obj)
            if Obj.resource == Type then
              return Obj
            end
          end
        },Label)
      end

      local GetStored = "GetStored_" .. Type
      --if there's only pile and it has a resource (for blackcubes/mystery, otherwise we send the full list of depots)
      if #Label == 1 and
        (Label[1][GetStored] and Label[1][GetStored](Label[1]) > 999 or
        pile and Label[1].GetStoredAmount and Label[1]:GetStoredAmount() > 999) then
          return Label[1]
      else
        --otherwise filter out empty stockpiles and (and ones for other resources)
        Label = FilterObjects({
          filter = function(Obj)
            if Obj[GetStored] and Obj[GetStored](Obj) > 999 or
              pile and Obj.GetStoredAmount and Obj:GetStoredAmount() > 999 then
                return Obj
            end
          end
        },Label)
        --and return nearest
        return FindNearestObject(Label,Object)
      end
    end
  end

  function ChoGGi.CodeFuncs.FindNearestResource(Object)
    local ChoGGi = ChoGGi
    if Object and not Object.class then
      Object = ChoGGi.CodeFuncs.SelObject()
    end
    if not Object then
      ChoGGi.ComFuncs.MsgPopup("Nothing selected","Find Resource")
      return
    end

    local ItemList = {
      {text = "Metals",value = "Metals"},
      {text = "BlackCube",value = "BlackCube"},
      {text = "MysteryResource",value = "MysteryResource"},
      {text = "Concrete",value = "Concrete"},
      {text = "Food",value = "Food"},
      {text = "PreciousMetals",value = "RareMetals"},
      {text = "Polymers",value = "Polymers"},
      {text = "Electronics",value = "Electronics"},
      {text = "Fuel",value = "Fuel"},
      {text = "MachineParts",value = "MachineParts"},
    }

    local CallBackFunc = function(choice)
      local value = choice[1].value
      if type(value) == "string" then

        --get nearest stockpiles to object
        local labels = UICity.labels
        local mechstockpile = GetStockpile(labels["MechanizedDepot" .. value],value,Object)
        local stockpile
        local resourcepile = GetStockpile(GetObjects({class="ResourceStockpile"}),value,Object)
        if value == "BlackCube" then
          stockpile = GetStockpile(labels[value .. "DumpSite"],value,Object)
        elseif value == "MysteryResource" then
          stockpile = GetStockpile(labels["MysteryDepot"],value,Object)
        else
          stockpile = GetStockpile(labels["UniversalStorageDepot"],value,Object)
        end

        local piles = {
          {obj = mechstockpile, dist = mechstockpile and mechstockpile:GetDist2D(Object)},
          {obj = stockpile, dist = stockpile and stockpile:GetDist2D(Object)},
          {obj = resourcepile, dist = resourcepile and resourcepile:GetDist2D(Object)},
        }

        local nearest
        local nearestdist
        --now we can compare the dists
        for i = 1, #piles do
          local p = piles[i]
          if p.obj then
            --we need something to compare
            if not nearest then
              nearest = p.obj
              nearestdist = p.dist
            elseif p.dist < nearestdist then
              nearest = p.obj
              nearestdist = p.dist
            end
          end
        end
        --if there's no resources then "nearest" doesn't exist
        if nearest then
          ChoGGi.CodeFuncs.ViewAndSelectObject(nearest)
        else
          ChoGGi.ComFuncs.MsgPopup("Error: Cannot find any " .. choice[1].text,"Resource")
        end
      end
    end

    local hint = "Select a resource to find"
    ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Find Nearest Resource " .. Object.class,hint)
  end
end

function ChoGGi.CodeFuncs.ViewAndSelectObject(Obj)
  ViewPos(Obj:GetVisualPos())
  SelectObj(Obj)
end

function ChoGGi.CodeFuncs.DeleteObject(obj)
  local ChoGGi = ChoGGi
  --the menu item sends itself
  if obj and not obj.class then
    --multiple selection from editor mode
    local objs = editor:GetSel()
    if next(objs) then
      for i = 1, #objs do
        ChoGGi.CodeFuncs.DeleteObject(objs[i])
      end
    else
      obj = ChoGGi.CodeFuncs.SelObject()
    end
  end

  --deleting domes will freeze game if they have anything in them.
  if obj:IsKindOf("Dome") and obj.working then
    return
  end

  local function TryFunc(Name,Param)
    if type(obj[Name]) == "function" then
      obj[Name](obj,Param)
    end
  end

  --some stuff will leave holes in the world if they're still working
  TryFunc("ToggleWorking")

  --try nicely first
  obj.can_demolish = true
  obj.indestructible = false

  if obj.DoDemolish then
    DestroyBuildingImmediate(obj)
  end

  TryFunc("Destroy")
  TryFunc("SetDome",false)
  TryFunc("RemoveFromLabels")
  TryFunc("Done")
  TryFunc("Gossip","done")
  TryFunc("SetHolder",false)
  local function TryFunc2(Name)
    if obj[Name] then
      obj[Name]:delete()
    end
  end
  TryFunc2("sphere")
  TryFunc2("decal")

  --fuck it, I asked nicely
  if obj then
    DoneObject(obj)
    --TryFunc("delete")
  end

    --so we don't get an error from UseLastOrientation
  ChoGGi.Temp.LastPlacedObject = nil
end

function ChoGGi.CodeFuncs.RetBuildingPermissions(traits,settings)
  local block = false
  local restrict = false

  local rtotal = 0
  for _,_ in pairs(settings.restricttraits) do
    rtotal = rtotal + 1
  end

  local rcount = 0
  for trait,_ in pairs(traits) do
    if settings.restricttraits[trait] then
      rcount = rcount + 1
    end
    if settings.blocktraits[trait] then
      block = true
    end
  end
  --restrict is empty so allow all or since we're restricting then they need to be the same
  if not next(settings.restricttraits) or rcount == rtotal then
    restrict = true
  end

  return block,restrict
end

function ChoGGi.CodeFuncs.Trans(...)
  local data = select(1,...)
  if type(data) == "userdata" then
    return _InternalTranslate(...)
  end
  return _InternalTranslate(T({...}))
end

function ChoGGi.CodeFuncs.RemoveBuildingElecConsump(Obj)
  local mods = Obj.modifications
  if mods and mods.electricity_consumption then
    local mod = Obj.modifications.electricity_consumption
    if mod[1] then
      mod = mod[1]
    end
    if not Obj.ChoGGi_mod_electricity_consumption then
      Obj.ChoGGi_mod_electricity_consumption = {
        amount = mod.amount,
        percent = mod.percent
      }
    end
    if mod:IsKindOf("ObjectModifier") then
      mod:Change(0,0)
    end
  end
  Obj:SetBase("electricity_consumption", 0)
end

--pretty much a direct copynpaste from explorer (just removed stuff that's rover only)
function ChoGGi.CodeFuncs.AnalyzeAnomaly(self,anomaly)
  local ChoGGi = ChoGGi
  local IsValid = IsValid
  local Sleep = Sleep
  local Msg = Msg

  if not IsValid(self) then
    return
  end
  self:SetState("idle")
  self:SetPos(self:GetVisualPos())
  self:Face(anomaly:GetPos(), 200)
  local layers = anomaly.depth_layer or 1
  self.scan_time = layers * g_Consts.RCRoverScanAnomalyTime
  local progress_time = MulDivRound(anomaly.scanning_progress, self.scan_time, 100)
  self.scanning_start = GameTime() - progress_time
  RebuildInfopanel(self)
  self:PushDestructor(function(self)
    if IsValid(anomaly) then
      anomaly.scanning_progress = ChoGGi.CodeFuncs.GetScanAnomalyProgress(self)
      if anomaly.scanning_progress >= 100 then
        self:Gossip("ScanAnomaly", anomaly.class, anomaly.handle)
        anomaly:ScanCompleted(self)
        anomaly:delete()
      end
    end
    if IsValid(anomaly) and anomaly == SelectedObj then
      Msg("UIPropertyChanged", anomaly)
    end
    --self:StopFX()
    self.scanning = false
    self.scanning_start = false
  end)
  local time = self.scan_time - progress_time
  --self:StartFX("Scan", anomaly)
  self.scanning = true
  while time > 0 and IsValid(self) and IsValid(anomaly) do
    Sleep(1000)
    time = time - 1000
    anomaly.scanning_progress = ChoGGi.CodeFuncs.GetScanAnomalyProgress(self)
    if anomaly == SelectedObj then
      Msg("UIPropertyChanged", anomaly)
    end
  end
  self:PopAndCallDestructor()
  ChoGGi.Temp.CargoShuttleScanningAnomaly[anomaly.handle] = nil
end

function ChoGGi.CodeFuncs.GetScanAnomalyProgress(self)
  return self.scanning_start and MulDivRound(GameTime() - self.scanning_start, 100, self.scan_time) or 0
end

function ChoGGi.CodeFuncs.DefenceTick(self,AlreadyFired)
  local CreateGameTimeThread = CreateGameTimeThread
  local Sleep = Sleep
  local PlayFX = PlayFX

  if type(AlreadyFired) ~= "table" then
    print("Error: ShuttleRocketDD isn't a table")
  end

  --list of dustdevils on map
  local hostiles = g_DustDevils or empty_table
  if IsValidThread(self.track_thread) then
    return
  end
  for i = 1, #hostiles do
    local obj = hostiles[i]

    --get dist (added * 10 as it didn't see to target at the range of it's hex grid)
    --it could be from me increasing protection radius, or just how it targets meteors
    if IsValid(obj) and self:GetVisualDist2D(obj) <= self.shoot_range * 10 then
      --check if tower is working
      if not IsValid(self) or not self.working or self.destroyed then
        return
      end

      --follow = small ones attached to majors
      if not obj.follow and not AlreadyFired[obj.handle] then
      --if not AlreadyFired[obj.handle] then
        --aim the tower at the dustdevil
        if self.class == "DefenceTower" then
          self:OrientPlatform(obj:GetVisualPos(), 7200)
        end
        --fire in the hole
        local rocket = self:FireRocket(nil, obj)
        --store handle so we only launch one per devil
        AlreadyFired[obj.handle] = obj
        --seems like safe bets to set
        self.meteor = obj
        self.is_firing = true
        --sleep till rocket explodes
        CreateGameTimeThread(function()
          while rocket.move_thread do
            Sleep(500)
          end
          if obj:IsKindOf("BaseMeteor") then
            --make it pretty
            PlayFX("AirExplosion", "start", obj, nil, obj:GetPos())
            Msg("MeteorIntercepted", obj)
            obj:ExplodeInAir()
          else
            --make it pretty
            PlayFX("AirExplosion", "start", obj, obj:GetAttaches()[1], obj:GetPos())
            --kill the devil object
            obj:delete()
          end
          self.meteor = false
          self.is_firing = false
        end)
        --back to the usual stuff
        Sleep(self.reload_time)
        return true
      end
    end
  end
  --remove only remove devil handles if they're actually gone
  if #AlreadyFired > 0 then
    CreateGameTimeThread(function()
      for i = #AlreadyFired, 1, -1 do
        if not IsValid(AlreadyFired[i]) then
          AlreadyFired[i] = nil
        end
      end
    end)
  end
end
--get all objects, then filter for ones within *Radius*, returned sorted by dist, or *Sort* for name
--OpenExamine(ChoGGi.CodeFuncs.ReturnAllNearby(1000),"class")
function ChoGGi.CodeFuncs.ReturnAllNearby(Radius,Sort)
  Radius = Radius or 5000
  local pos = GetTerrainCursor()
  --get pretty much all objects (18K on a new map)
  local all = GetObjects({class="CObject"})
  --we only want stuff within *Radius*
  local list = FilterObjects({
    filter = function(Obj)
      if Obj:GetDist2D(pos) <= Radius then
        return Obj
      end
    end
  },all)
  --sort list custom
  if Sort then
    table.sort(list,
      function(a,b)
        return a[Sort] < b[Sort]
      end
    )
  else
    --sort nearest
    table.sort(list,
      function(a,b)
        return a:GetDist2D(pos) < b:GetDist2D(pos)
      end
    )
  end
  return list
end

function ChoGGi.CodeFuncs.DisplayMonitorList(value,parent)
  local UICity = UICity
  local info
  local function AddGrid(Name,info)
    for i = 1, #UICity[Name] do
      info.tables[#info.tables+1] = UICity[Name][i]
    end
  end
  --0=value,1=#table,2=list table values
  local info_grid = {
    title = value,
    tables = {},
    values = {
      {name="connectors",kind=1},
      {name="consumers",kind=1},
      {name="producers",kind=1},
      {name="storages",kind=1},
      {name="all_consumers_supplied",kind=0},
      {name="charge",kind=0},
      {name="discharge",kind=0},
      {name="current_consumption",kind=0},
      {name="current_production",kind=0},
      {name="current_reserve",kind=0},
      {name="current_storage",kind=0},
      {name="current_storage_change",kind=0},
      {name="current_throttled_production",kind=0},
      {name="current_waste",kind=0},
    }
  }
  if value == "Grids" then
    info = info_grid
    AddGrid("air",info)
    AddGrid("electricity",info)
    AddGrid("water",info)
  elseif value == "Air" then
    info = info_grid
    AddGrid("air",info)
  elseif value == "Electricity" then
    info = info_grid
    AddGrid("electricity",info)
  elseif value == "Water" then
    info = info_grid
    AddGrid("water",info)
  elseif value == "City" then
    info = {
      title = "City",
      tables = {UICity},
      values = {
        {name="rand_state",kind=0},
        {name="day",kind=0},
        {name="hour",kind=0},
        {name="minute",kind=0},
        {name="total_export",kind=0},
        {name="total_export_funding",kind=0},
        {name="funding",kind=0},
        {name="research_queue",kind=1},
        {name="consumption_resources_consumed_today",kind=2},
        {name="maintenance_resources_consumed_today",kind=2},
        {name="gathered_resources_today",kind=2},
        {name="consumption_resources_consumed_yesterday",kind=2},
        {name="maintenance_resources_consumed_yesterday",kind=2},
        {name="gathered_resources_yesterday",kind=2},
         --{name="unlocked_upgrades",kind=2},
      }
    }
  end
  if info then
    ChoGGi.ComFuncs.OpenInMonitorInfoDlg(info,parent)
  end
end



function ChoGGi.CodeFuncs.RecallShuttlesHub(hub)
  for _, s_i in pairs(hub.shuttle_infos) do
    local shuttle = s_i.shuttle_obj
    if shuttle then

      if type(ChoGGi.Temp.CargoShuttleThreads[shuttle.handle]) == "boolean" then
        ChoGGi.Temp.CargoShuttleThreads[shuttle.handle] = nil
      end
      if shuttle.ChoGGi_FollowMouseShuttle then
        shuttle.ChoGGi_FollowMouseShuttle = nil
        shuttle:SetCommand("Idle")
      end

    end
  end
end
--which true=attack,false=friend
function ChoGGi.CodeFuncs.SpawnShuttle(hub,which)
  local ChoGGi = ChoGGi
  for _, s_i in pairs(hub.shuttle_infos) do
    if s_i:CanLaunch() then
      --ShuttleInfo:Launch(task)
      local hub = s_i.hub
      if not hub or not hub.has_free_landing_slots then
        return false
      end
      --LRManagerInstance
      local shuttle = CargoShuttle:new({
        hub = hub,
        transport_task = ChoGGi_ShuttleFollowTask:new({
          state = "ready_to_follow",
          dest_pos = GetTerrainCursor() or GetRandomPassable()
        }),
        info_obj = s_i
      })
      s_i.shuttle_obj = shuttle
      local slot = hub:ReserveLandingSpot(shuttle)
      shuttle:SetPos(slot.pos)
      --CargoShuttle:Launch()
      shuttle:PushDestructor(function(s)
        s.hub:ShuttleLeadOut(s)
        s.hub:FreeLandingSpot(s)
      end)
      local amount = 0
      for _ in pairs(ChoGGi.Temp.CargoShuttleThreads) do
        amount = amount + 1
      end
      if amount <= 50 then
        --do we attack dustdevils?
        if which then
          ChoGGi.Temp.CargoShuttleThreads[shuttle.handle] = true
          shuttle:SetColor1(-9624026)
          shuttle:SetColor2(1)
          shuttle:SetColor3(-13892861)
        else
          ChoGGi.Temp.CargoShuttleThreads[shuttle.handle] = false
          shuttle:SetColor1(-16711941)
          shuttle:SetColor2(-16760065)
          shuttle:SetColor3(-1)
        end
        shuttle.ChoGGi_FollowMouseShuttle = true
        --follow that cursor little minion
        shuttle:SetCommand("ChoGGi_FollowMouse")
        --return it so we can do viewpos on it for menu item
        return shuttle
      else
      --or the crash is from all the dust i have going :)
        ChoGGi.ComFuncs.MsgPopup(
          "Max of 50 (above 50 and below 100 it crashes).",
          "Shuttle"
        )
      end
      --since we found a shuttle break the loop
      break
    end
  end
end

--only add unique template names
function ChoGGi.CodeFuncs.AddXTemplate(Name,Template,Table,XT)
  if not Name or Template or Table then
    return
  end
  XT = XT or XTemplates
  if not XT[Template][Name] then
    XT[Template][Name] = true
    XT[Template][#XT[Template]+1] = PlaceObj("XTemplateTemplate", {
      "__context_of_kind", Table.__context_of_kind or "InfopanelObj",
      "__template", Table.__template or "InfopanelActiveSection",
      "Icon", Table.Icon or "UI/Icons/gpmc_system_shine.tga",
      "Title", Table.Title or "Placeholder",
      "RolloverText", Table.RolloverText or "Info",
      "RolloverTitle", Table.RolloverTitle or "Title",
      "RolloverHint", Table.RolloverHint or "Hint",
      "OnContextUpdate", Table.OnContextUpdate
    }, {
      PlaceObj("XTemplateFunc", {
      "name", "OnActivate(self, context)",
      "parent", function(parent, context)
          return parent.parent
        end,
      "func", Table.func
      })
    })
  end
end
