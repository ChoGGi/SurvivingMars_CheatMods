local CTables = ChoGGi.Tables
local CComFuncs = ChoGGi.ComFuncs
local CConsts = ChoGGi.Consts

--any funcs called from Code/*.lua

--make some easy to type names
function console(...)ConsolePrint(tostring(...))end
function examine(Obj)OpenExamine(Obj)end
function ex(Obj)OpenExamine(Obj)end
function con(...)console(...)end
function dump(...)CComFuncs.Dump(...)end
function dumpobject(...)CComFuncs.DumpObject(...)end
function dumplua(...)CComFuncs.DumpLua(...)end
function dumptable(...)CComFuncs.DumpTable(...)end
function dumpo(...)CComFuncs.DumpObject(...)end
function dumpl(...)CComFuncs.DumpLua(...)end
function dumpt(...)CComFuncs.DumpTable(...)end
function alert(...)CComFuncs.MsgPopup(...)end
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
function ChoGGi.CodeFuncs.GetSpeedDrone()
  local MoveSpeed = CConsts.SpeedDrone

  if UICity and UICity:IsTechResearched("LowGDrive") then
    local p = CComFuncs.ReturnTechAmount("LowGDrive","move_speed")
    MoveSpeed = MoveSpeed + MoveSpeed * p
  end
  if UICity and UICity:IsTechResearched("AdvancedDroneDrive") then
    local p = CComFuncs.ReturnTechAmount("AdvancedDroneDrive","move_speed")
    MoveSpeed = MoveSpeed + MoveSpeed * p
  end

  return MoveSpeed
end

function ChoGGi.CodeFuncs.GetSpeedRC()
  if UICity and UICity:IsTechResearched("LowGDrive") then
    local p = CComFuncs.ReturnTechAmount("LowGDrive","move_speed")
    return CConsts.SpeedRC + CConsts.SpeedRC * p
  end
  return CConsts.SpeedRC
end

function ChoGGi.CodeFuncs.GetCargoCapacity()
  if UICity and UICity:IsTechResearched("FuelCompression") then
    local a = CComFuncs.ReturnTechAmount("FuelCompression","CargoCapacity")
    return CConsts.CargoCapacity + a
  end
  return CConsts.CargoCapacity
end
--
function ChoGGi.CodeFuncs.GetCommandCenterMaxDrones()
  if UICity and UICity:IsTechResearched("DroneSwarm") then
    local a = CComFuncs.ReturnTechAmount("DroneSwarm","CommandCenterMaxDrones")
    return CConsts.CommandCenterMaxDrones + a
  end
  return CConsts.CommandCenterMaxDrones
end
--
function ChoGGi.CodeFuncs.GetDroneResourceCarryAmount()
  if UICity and UICity:IsTechResearched("ArtificialMuscles") then
    local a = CComFuncs.ReturnTechAmount("ArtificialMuscles","DroneResourceCarryAmount")
    return CConsts.DroneResourceCarryAmount + a
  end
  return CConsts.DroneResourceCarryAmount
end
--
function ChoGGi.CodeFuncs.GetLowSanityNegativeTraitChance()
  if UICity and UICity:IsTechResearched("SupportiveCommunity") then
    local p = CComFuncs.ReturnTechAmount("SupportiveCommunity","LowSanityNegativeTraitChance")
    --[[
    LowSanityNegativeTraitChance = 30%
    SupportiveCommunity = -70%
    --]]
    local LowSan = CConsts.LowSanityNegativeTraitChance + 0.0 --SM has no math.funcs so + 0.0
    return p*LowSan/100*100
  end
  return CConsts.LowSanityNegativeTraitChance
end
--
function ChoGGi.CodeFuncs.GetMaxColonistsPerRocket()
  local PerRocket = CConsts.MaxColonistsPerRocket
  if UICity and UICity:IsTechResearched("CompactPassengerModule") then
    local a = CComFuncs.ReturnTechAmount("CompactPassengerModule","MaxColonistsPerRocket")
    PerRocket = PerRocket + a
  end
  if UICity and UICity:IsTechResearched("CryoSleep") then
    local a = CComFuncs.ReturnTechAmount("CryoSleep","MaxColonistsPerRocket")
    PerRocket = PerRocket + a
  end
  return PerRocket
end
--
function ChoGGi.CodeFuncs.GetNonSpecialistPerformancePenalty()
  if UICity and UICity:IsTechResearched("GeneralTraining") then
    local a = CComFuncs.ReturnTechAmount("GeneralTraining","NonSpecialistPerformancePenalty")
    return CConsts.NonSpecialistPerformancePenalty - a
  end
  return CConsts.NonSpecialistPerformancePenalty
end
--
function ChoGGi.CodeFuncs.GetRCRoverMaxDrones()
  if UICity and UICity:IsTechResearched("RoverCommandAI") then
    local a = CComFuncs.ReturnTechAmount("RoverCommandAI","RCRoverMaxDrones")
    return CConsts.RCRoverMaxDrones + a
  end
  return CConsts.RCRoverMaxDrones
end
--
function ChoGGi.CodeFuncs.GetRCTransportGatherResourceWorkTime()
  if UICity and UICity:IsTechResearched("TransportOptimization") then
    local p = CComFuncs.ReturnTechAmount("TransportOptimization","RCTransportGatherResourceWorkTime")
    return CConsts.RCTransportGatherResourceWorkTime * p
  end
  return CConsts.RCTransportGatherResourceWorkTime
end
--
function ChoGGi.CodeFuncs.GetRCTransportStorageCapacity()
  if UICity and UICity:IsTechResearched("TransportOptimization") then
    local a = CComFuncs.ReturnTechAmount("TransportOptimization","max_shared_storage")
    return CConsts.RCTransportStorageCapacity + (a * CConsts.ResourceScale)
  end
  return CConsts.RCTransportStorageCapacity
end
--
function ChoGGi.CodeFuncs.GetTravelTimeEarthMars()
  if UICity and UICity:IsTechResearched("PlasmaRocket") then
    local p = CComFuncs.ReturnTechAmount("PlasmaRocket","TravelTimeEarthMars")
    return CConsts.TravelTimeEarthMars * p
  end
  return CConsts.TravelTimeEarthMars
end
--
function ChoGGi.CodeFuncs.GetTravelTimeMarsEarth()
  if UICity and UICity:IsTechResearched("PlasmaRocket") then
    local p = CComFuncs.ReturnTechAmount("PlasmaRocket","TravelTimeMarsEarth")
    return CConsts.TravelTimeMarsEarth * p
  end
  return CConsts.TravelTimeMarsEarth
end

function ChoGGi.CodeFuncs.AttachToNearestDome(building)
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
function ChoGGi.CodeFuncs.ToggleWorking(building)
  CreateRealTimeThread(function()
    building:ToggleWorking()
    Sleep(5)
    building:ToggleWorking()
  end)
end

function ChoGGi.CodeFuncs.SetCameraSettings()
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
    cameraRTS.SetZoomLimits(400,15000)
  end

  --cameraRTS.SetProperties(1,{HeightInertia = 0})
end

function ChoGGi.CodeFuncs.RemoveOldFiles()
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
    Age = CTables.ColonistAges[UICity:Random(1,6)]
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

function ChoGGi.CodeFuncs.ColonistUpdateGender(Colonist,Gender,Cloned)
  if Gender == "Random" then
    Gender = CTables.ColonistGenders[UICity:Random(1,5)]
  elseif Gender == "MaleOrFemale" then
    Gender = CTables.ColonistGenders[UICity:Random(4,5)]
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
  if not Colonist.entity:find("Child",1,true) then
    if Spec == "Random" then
      Spec = CTables.ColonistSpecializations[UICity:Random(1,6)]
    end
    Colonist:SetSpecialization(Spec,"init")
    Colonist:ChooseEntity()
    Colonist:UpdateWorkplace()
    Colonist:TryToEmigrate()
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
called from FireFuncAfterChoice

CustomType=1 : updates selected item with custom value type, dbl click opens colour changer, and sends back all items
CustomType=2 : colour selector
CustomType=3 : updates selected item with custom value type, and sends back selected item.
CustomType=4 : updates selected item with custom value type, and sends back all items
CustomType=5 : for Lightmodel: show colour selector when listitem.editor = color,pressing check2 applies the lightmodel without closing dialog, dbl rightclick shows lightmodel lists and lets you pick one to use in new window
--]]
function ChoGGi.CodeFuncs.WaitListChoiceCustom(Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType)
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

function ChoGGi.CodeFuncs.FireFuncAfterChoice(Func,Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType)
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
      return CComFuncs.CompareTableValue(a,b,sortby)
    end
  )

  --only insert blank item if we aren't updating other items with it
  if not CustomType then
    --insert blank item for adding custom value
    Items[#Items+1] = {text = "",hint = "",value = false}
  end

  CreateRealTimeThread(function()
    local option = ChoGGi.CodeFuncs.WaitListChoiceCustom(Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType)
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
function ChoGGi.CodeFuncs.FuckingDrones(Producer)
  --Come on, Bender. Grab a jack. I told these guys you were cool.
  --Well, if jacking on will make strangers think I'm cool, I'll do it.
  if not Producer then
    return
  end
  local amount = Producer:GetAmountStored()
  if amount > 1000 then
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
      if cc[i].command == "Idle" or cc[i].command == "WaitCommand" then
        drone = cc[i]
        break
      end
    end
    if drone then

      local carry = g_Consts.DroneResourceCarryAmount * CConsts.ResourceScale
      --round to nearest 1000 (don't want uneven stacks)
      amount = (amount - amount % CConsts.ResourceScale) / CConsts.ResourceScale * CConsts.ResourceScale
      --if carry is smaller then amount then fine
      if carry < amount then
        amount = carry
      end

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

function ChoGGi.CodeFuncs.ObjectColourRandom(Obj,Base)
  if Obj:IsKindOf("ColorizableObject") then
    local color = RandColor()
    local SetPal = Obj.SetColorizationMaterial
    local GetPal = Obj.GetColorizationMaterial
    local c1,c2,c3,c4 = GetPal(Obj,1),GetPal(Obj,2),GetPal(Obj,3),GetPal(Obj,4)
    --likely can only change basecolour
    if Base or c1 == 8421504 and c2 == 8421504 and c3 == 8421504 and c4 == 8421504 then
      Obj:SetColorModifier(color)
    else
      if not Obj.ChoGGi_origcolors then
        ChoGGi.CodeFuncs.SaveOldPalette(Obj)
      end
      --s,1,Color, Roughness, Metallic
      SetPal(Obj, 1, RandColor(), 0,0)
      SetPal(Obj, 2, RandColor(), 0,0)
      SetPal(Obj, 3, RandColor(), 0,0)
      SetPal(Obj, 4, RandColor(), 0,0)
    end
    return color
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

function ChoGGi.CodeFuncs.OpenInObjectManipulator(Object,Parent)
  if type(Object) ~= "table" then
    return
  end
  --nil or selected self
  if not Object or (Object.action and Object.idx) then
    Object = ChoGGi.CodeFuncs.SelObject()
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
      dlg:SetPos(point(pos:x(),pos:y() + 22)) --22=side of header
    end
  else
    dlg:SetPos(terminal.GetMousePos())
  end
  --update item list
  dlg:UpdateListContent(Object)

end

function ChoGGi.CodeFuncs.RemoveOldDialogs(Dialog,win)
  while CComFuncs.CheckForTypeInList(win,Dialog) do
    for i = 1, #win do
      if IsKindOf(win[i],Dialog) then
        win[i]:delete()
      end
    end
  end
end

function ChoGGi.CodeFuncs.CloseDialogsECM()
  local win = terminal.desktop
  ChoGGi.CodeFuncs.RemoveOldDialogs("Examine",win)
  ChoGGi.CodeFuncs.RemoveOldDialogs("ObjectManipulator",win)
  ChoGGi.CodeFuncs.RemoveOldDialogs("ListChoiceCustomDialog",win)
end

function ChoGGi.CodeFuncs.SetMechanizedDepotTempAmount(Obj,amount)
  amount = amount or 10
  local resource = Obj.resource
  local io_stockpile = Obj.stockpiles[Obj:GetNextStockpileIndex()]
  local io_supply_req = io_stockpile.supply[resource]
  local io_demand_req = io_stockpile.demand[resource]

  io_stockpile.max_z = amount
  amount = (amount * 10) * CConsts.ResourceScale
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

  if not oldobj or not IsKindOf(oldobj,"MechanizedDepot") then
    oldobj = ChoGGi.CodeFuncs.SelObject()
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
function ChoGGi.CodeFuncs.ChangeObjectColour(obj,Parent)
  if not obj and not obj:IsKindOf("ColorizableObject") then
    CComFuncs.MsgPopup("Can't colour object","Colour")
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
          return CComFuncs.CompareTableValue(a,b,"text")
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

      CComFuncs.MsgPopup("Colour is set on " .. obj.class,"Colour")
    end
  end
  local hint = "If number is 8421504 (0 for Metallic/Roughness) then you probably can't change that colour.\n\nThe colour picker doesn't work for Metallic/Roughness.\nYou can copy and paste numbers if you want (click item again after picking)."
  local hint_check1 = "Change all objects of the same type."
  local hint_check2 = "if they're there; resets to default colours."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Change Colour: " .. obj.class,hint,true,"All of type",hint_check1,"Default Colour",hint_check2,2)
end

--returns the near hex grid for object placement
function ChoGGi.CodeFuncs.CursorNearestHex()
  return HexGetNearestCenter(GetTerrainCursor())
end

--returns whatever is selected > moused over > nearest non particle object to cursor
function ChoGGi.CodeFuncs.SelObject()
  local _,ret = pcall(function()
    --#GetObjects({class="CObject"})
    --#GetObjects({class="PropertyObject"})
    local objs = CComFuncs.FilterFromTable(GetObjects({class="CObject"}),{ParSystem=1},"class")
    return SelectedObj or SelectionMouseObj() or NearestObject(GetTerrainCursor(),objs,500)
  end)
  return ret
end

function ChoGGi.CodeFuncs.LightmodelBuild(Table)
  local data = DataInstances.Lightmodel
  --always start with blank lightmodel
  --[[
  local Table = DataInstances.Lightmodel.ChoGGi_Custom[Name]
  for Key,Value in pairs(Table or empty_table) do
    local defitem = GetInfo(Key)
    ItemList[#ItemList+1] = {
      text = defitem.editor == "color" and "<color 175 175 255>" .. Key .. "</color>" or Key,
      sort = Key,
      value = Value,
      default = defitem.default,
      editor = defitem.editor,
      hint = "" .. (defitem.name or "") .. "\nhelp: " .. (defitem.help or "") .. "\n\ndefault: " .. (tostring(defitem.default) or "") .. " min: " .. (defitem.min or "") .. " max: " .. (defitem.max or "") .. " scale: " .. (defitem.scale or ""),
    }
  end
--]]
  data.ChoGGi_Custom:delete()
  data.ChoGGi_Custom = Lightmodel:new()
  data.ChoGGi_Custom.name = "ChoGGi_Custom"

  for i = 1, #Table do
    data.ChoGGi_Custom[Table[i].id] = Table[i].value
  end
  ChoGGi.Temp.LightmodelCustom = data.ChoGGi_Custom
  return data.ChoGGi_Custom
end
