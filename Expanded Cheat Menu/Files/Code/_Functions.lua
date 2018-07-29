-- See LICENSE for terms
--any funcs called from Code/*

local Concat = ChoGGi.ComFuncs.Concat
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local RetName = ChoGGi.ComFuncs.RetName
local S = ChoGGi.Strings

local pcall,print,rawget,type,table = pcall,print,rawget,type,table

local AsyncFileDelete = AsyncFileDelete
local CloseXBuildMenu = CloseXBuildMenu
local CloseXDialog = CloseXDialog
local CreateRealTimeThread = CreateRealTimeThread
local DelayedCall = DelayedCall
local DestroyBuildingImmediate = DestroyBuildingImmediate
local FilterObjects = FilterObjects
local FindNearestObject = FindNearestObject
local GetObjects = GetObjects
local GetPassablePointNearby = GetPassablePointNearby
local GetPreciseCursorObj = GetPreciseCursorObj
local GetTerrainCursor = GetTerrainCursor
local GetTerrainCursorObjSel = GetTerrainCursorObjSel
local GetXDialog = GetXDialog
local HexGetNearestCenter = HexGetNearestCenter
local IsValid = IsValid
local NearestObject = NearestObject
local OpenExamine = OpenExamine
local OpenXBuildMenu = OpenXBuildMenu
local PlaceObj = PlaceObj
local point = point
local RandColor = RandColor
local Random = Random
local SelectionMouseObj = SelectionMouseObj
local Sleep = Sleep

local terminal_GetMousePos = terminal.GetMousePos
local UIL_GetScreenSize = UIL.GetScreenSize
local cameraRTS_SetProperties = cameraRTS.SetProperties
local cameraRTS_SetZoomLimits = cameraRTS.SetZoomLimits
local camera_SetFovY = camera.SetFovY
local camera_SetFovX = camera.SetFovX

local g_Classes = g_Classes

-- add some shortened func names
do --for those that don't know "do ... end" is a way of keeping "local" local to the do
  --make some easy to type names
  local ChoGGi = ChoGGi
  function dump(...)ChoGGi.ComFuncs.Dump(...)end
  function dumplua(...)ChoGGi.ComFuncs.DumpLua(...)end
  function dumptable(...)ChoGGi.ComFuncs.DumpTable(...)end
  function dumpl(...)ChoGGi.ComFuncs.DumpLua(...)end
  function dumpt(...)ChoGGi.ComFuncs.DumpTable(...)end
  local function RemoveLast(str)
    --remove restart as the last cmd so we don't hit it by accident
    local dlgConsole = dlgConsole
    if dlgConsole.history_queue[1] == str then
      table.remove(dlgConsole.history_queue,1)
      --and save it?
      if rawget(_G, "dlgConsole") then
--~         g_Classes.Console.StoreHistory(dlgConsole)
        dlgConsole:StoreHistory()
      end
    end
  end
  local orig_quit = quit
  function quit(...)
    orig_quit(...)
    RemoveLast("quit")
  end
  function restart()
    quit("restart")
    RemoveLast("restart")
  end
  reboot = restart
  exit = quit
  trans = ChoGGi.ComFuncs.Trans -- works with userdata or index number
  mh = GetTerrainCursorObjSel -- only returns selected obj under cursor
  mhc = GetTerrainCursorObj -- returns obj under cursor
  mc = GetPreciseCursorObj
  m = SelectionMouseObj
  c = GetTerrainCursor -- cursor position on map
  cs = terminal_GetMousePos -- cursor pos on screen
  s = false --used to store SelectedObj
  function so()
    return ChoGGi.CodeFuncs.SelObject()
  end
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
  local workingdomes = ChoGGi.ComFuncs.FilterFromTable(UICity.labels.Dome or "",nil,nil,"working")
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
--~         dome:AddToLabel("WaterReclamationSpires", building)
        building:SetDome(dome)
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
      print(S[302535920000012]--[[302535920000012,Error borked building: %s--]]:format(RetName(building)))
      OpenExamine(building)
    end
  end
end

function ChoGGi.CodeFuncs.SetCameraSettings()
  local ChoGGi = ChoGGi
  --cameraRTS.GetProperties(1)

  --size of activation area for border scrolling
  if ChoGGi.UserSettings.BorderScrollingArea then
    cameraRTS_SetProperties(1,{ScrollBorder = ChoGGi.UserSettings.BorderScrollingArea})
  else
    --default
    cameraRTS_SetProperties(1,{ScrollBorder = 5})
  end

  --zoom
  --camera.GetFovY()
  --camera.GetFovX()
  if ChoGGi.UserSettings.CameraZoomToggle then
    if type(ChoGGi.UserSettings.CameraZoomToggle) == "number" then
      cameraRTS_SetZoomLimits(0,ChoGGi.UserSettings.CameraZoomToggle)
    else
      cameraRTS_SetZoomLimits(0,24000)
    end

    --5760x1080 doesn't get the correct zoom size till after zooming out
    if UIL_GetScreenSize():x() == 5760 then
      camera_SetFovY(2580)
      camera_SetFovX(7745)
    end
  else
    --default
    cameraRTS_SetZoomLimits(400,15000)
  end

  --cameraRTS_SetProperties(1,{HeightInertia = 0})
end

function ChoGGi.CodeFuncs.RemoveOldFiles()
  local ChoGGi = ChoGGi
  local files = {
    --from before we used Files.hpk
    "Functions",
    "Settings",
  }
  for i = 1, #files do
    AsyncFileDelete(Concat(ChoGGi.ModPath,files[i],".lua"))
  end
end

function ChoGGi.CodeFuncs.ShowBuildMenu(which)
  local BuildCategories = BuildCategories

  --make sure we're not in the main menu (deactiving mods when going back to main menu would be nice, check for a msg to use?)
  if not GetXDialog("PinsDlg") then
    return
  end

  local dlg = GetXDialog("XBuildMenu")
  if dlg then
    --opened so check if number corresponds and if so hide the menu
    if dlg.category == BuildCategories[which].id then
      CloseXDialog("XBuildMenu")
    end
  else
    OpenXBuildMenu()
  end
  dlg = GetXDialog("XBuildMenu")
  dlg:SelectCategory(BuildCategories[which])
  --have to fire twice to highlight the icon
  dlg:SelectCategory(BuildCategories[which])
end

function ChoGGi.CodeFuncs.ColonistUpdateAge(c,age)
  if age == S[3490--[[Random--]]] then
    age = ChoGGi.Tables.ColonistAges[Random(1,6)]
  end
  --remove all age traits
  c:RemoveTrait("Child")
  c:RemoveTrait("Youth")
  c:RemoveTrait("Adult")
  c:RemoveTrait("Middle Aged")
  c:RemoveTrait("Senior")
  c:RemoveTrait("Retiree")
  --add new age trait
  c:AddTrait(age)

  --needed for comparison
  local OrigAge = c.age_trait
  --needed for updating entity
  c.age_trait = age

  if age == "Retiree" then
    c.age = 65 --why isn't there a base_MinAge_Retiree...
  else
    c.age = c[Concat("base_MinAge_",age)]
  end

  if age == "Child" then
    --there aren't any child specialist entities
    c.specialist = "none"
    --only children live in nurseries
    if OrigAge ~= "Child" then
      c:SetResidence(false)
    end
  end
  --only children live in nurseries
  if OrigAge == "Child" and age ~= "Child" then
    c:SetResidence(false)
  end
  --now we can set the new entity
  c:ChooseEntity()
  --and (hopefully) prod them into finding a new residence
  c:UpdateWorkplace()
  c:UpdateResidence()
  --c:TryToEmigrate()
end

function ChoGGi.CodeFuncs.ColonistUpdateGender(c,gender,cloned)
  local ChoGGi = ChoGGi
  if gender == S[3490--[[Random--]]] then
    gender = ChoGGi.Tables.ColonistGenders[Random(1,5)]
  elseif gender == S[302535920000800--[[MaleOrFemale--]]] then
    gender = ChoGGi.Tables.ColonistGenders[Random(4,5)]
  end
  --remove all gender traits
  c:RemoveTrait("OtherGender")
  c:RemoveTrait("Android")
  c:RemoveTrait("Clone")
  c:RemoveTrait("Male")
  c:RemoveTrait("Female")
  --add new gender trait
  c:AddTrait(gender)
  --needed for updating entity
  c.gender = gender
  --set entity gender
  if gender == "Male" or gender == "Female" then
    c.entity_gender = gender
  else --random
    if cloned then
      c.entity_gender = cloned
    else
      if Random(1,2) == 1 then
        c.entity_gender = "Male"
      else
        c.entity_gender = "Female"
      end
    end
  end
  --now we can set the new entity
  c:ChooseEntity()
end

function ChoGGi.CodeFuncs.ColonistUpdateSpecialization(c,spec)
  --children don't have spec models so they get black cube
  if not c.entity:find("Child",1,true) then
    if spec == S[3490--[[Random--]]] then
      spec = ChoGGi.Tables.ColonistSpecializations[Random(1,6)]
    end
    c:SetSpecialization(spec,"init")
    c:ChooseEntity()
    c:UpdateWorkplace()
    --randomly fails on colonists from rockets
    --c:TryToEmigrate()
  end
end

function ChoGGi.CodeFuncs.ColonistUpdateTraits(c,bool,traits)
  local func
  if bool == true then
    func = "AddTrait"
  else
    func = "RemoveTrait"
  end
  for i = 1, #traits do
    c[func](c,traits[i],true)
  end
end

function ChoGGi.CodeFuncs.ColonistUpdateRace(c,race)
  if race == S[3490--[[Random--]]] then
    race = Random(1,5)
  end
  c.race = race
  c:ChooseEntity()
end

--some dev removed this from the Spirit update... (harumph)
function ChoGGi.CodeFuncs.AddConsolePrompt(text)
  local dlg = dlgConsole
  if dlg then
    dlg:Show(true)
    dlg.idEdit:Replace(dlg.idEdit.cursor_pos, dlg.idEdit.cursor_pos, text, true)
    dlg.idEdit:SetCursorPos(#text)
  end
end

--toggle visiblity of console log
function ChoGGi.CodeFuncs.ToggleConsoleLog()
  local log = dlgConsoleLog
  if log then
    if log:GetVisible() then
      log:SetVisible(false)
    else
      log:SetVisible(true)
    end
  else
    dlgConsoleLog = g_Classes.ConsoleLog:new({}, terminal.desktop)
  end
end

--[[
    local tab = UICity.labels.BlackCubeStockpiles or ""
    for i = 1, #tab do
      ChoGGi.CodeFuncs.FuckingDrones(tab[i])
    end
--]]
--force drones to pickup from object even if they have a large carry cap
function ChoGGi.CodeFuncs.FuckingDrones(obj)
  local ChoGGi = ChoGGi
  local r = ChoGGi.Consts.ResourceScale
  --Come on, Bender. Grab a jack. I told these guys you were cool.
  --Well, if jacking on will make strangers think I'm cool, I'll do it.

  if not obj then
    return
  end

  local stored
  local p
  local request
  local resource
  --mines/farms/factories
  if obj.class == "SingleResourceProducer" then
    p = obj.parent
    stored = obj:GetAmountStored()
    request = obj.stockpiles[obj:GetNextStockpileIndex()].supply_request
    resource = obj.resource_produced
  elseif obj.class == "BlackCubeStockpile" then
    p = obj
    stored = obj:GetStoredAmount()
    request = obj.supply_request
    resource = obj.resource
  end

  --only fire if more then one resource
  if stored > 1000 then
    local drone = ChoGGi.CodeFuncs.GetNearestIdleDrone(p)
    if not drone then
      return
    end

    local carry = g_Consts.DroneResourceCarryAmount * r
    --round to nearest 1000 (don't want uneven stacks)
    stored = (stored - stored % 1000) / 1000 * 1000
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

function ChoGGi.CodeFuncs.GetNearestIdleDrone(bld)
  local ChoGGi = ChoGGi
  if not bld or (bld and not bld.command_centers) then
    return
  end

  --check if nearest cc has idle drones
  local cc = FindNearestObject(bld.command_centers,bld)
  if cc and cc:GetIdleDronesCount() > 0 then
    cc = cc.drones
  else
    --sort command_centers by nearest dist
    table.sort(bld.command_centers,
      function(a,b)
        return ChoGGi.ComFuncs.CompareTableFuncs(a,b,"GetDist2D",bld.command_centers)
      end
    )
    --get command_center with idle drones
    for i = 1, #bld.command_centers do
      if bld.command_centers[i]:GetIdleDronesCount() > 0 then
        cc = bld.command_centers[i].drones
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

function ChoGGi.CodeFuncs.SaveOldPalette(obj)
  local GetPal = obj.GetColorizationMaterial
  if not obj.ChoGGi_origcolors then
    obj.ChoGGi_origcolors = {}
    obj.ChoGGi_origcolors[#obj.ChoGGi_origcolors+1] = {GetPal(obj,1)}
    obj.ChoGGi_origcolors[#obj.ChoGGi_origcolors+1] = {GetPal(obj,2)}
    obj.ChoGGi_origcolors[#obj.ChoGGi_origcolors+1] = {GetPal(obj,3)}
    obj.ChoGGi_origcolors[#obj.ChoGGi_origcolors+1] = {GetPal(obj,4)}
  end
end
function ChoGGi.CodeFuncs.RestoreOldPalette(obj)
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

function ChoGGi.CodeFuncs.GetPalette(obj)
  local g = obj.GetColorizationMaterial
  local pal = {}
  pal.Color1, pal.Roughness1, pal.Metallic1 = g(obj, 1)
  pal.Color2, pal.Roughness2, pal.Metallic2 = g(obj, 2)
  pal.Color3, pal.Roughness3, pal.Metallic3 = g(obj, 3)
  pal.Color4, pal.Roughness4, pal.Metallic4 = g(obj, 4)
  return pal
end

function ChoGGi.CodeFuncs.RandomColour(amount)
  local ChoGGi = ChoGGi

  -- amount isn't a number so return a single colour
  if type(amount) ~= "number" then
    return RandColor() --24bit colour
  end

  local colours = {}
  -- populate list with amount we want
  for _ = 1, amount do
    colours[#colours+1] = RandColor()
  end

  -- now remove all dupes and add more till we hit amount
  while #colours ~= amount do
    -- remove dupes
    colours = ChoGGi.ComFuncs.RetTableNoDupes(colours)
    -- then loop missing amount
    for _ = 1, amount - #colours do
      colours[#colours+1] = RandColor()
    end
  end

  return colours
end

local function SetRandColour(obj,colour,ChoGGi)
  colour = colour or ChoGGi.CodeFuncs.RandomColour()
  local SetPal = obj.SetColorizationMaterial
  local GetPal = obj.GetColorizationMaterial
  local c1,c2,c3,c4 = GetPal(obj,1),GetPal(obj,2),GetPal(obj,3),GetPal(obj,4)
  --likely can only change basecolour
  if c1 == 8421504 and c2 == 8421504 and c3 == 8421504 and c4 == 8421504 then
    obj:SetColorModifier(colour)
  else
    if not obj.ChoGGi_origcolors then
      ChoGGi.CodeFuncs.SaveOldPalette(obj)
    end
    --s,1,Color, Roughness, Metallic
    SetPal(obj, 1, ChoGGi.CodeFuncs.RandomColour(), 0,0)
    SetPal(obj, 2, ChoGGi.CodeFuncs.RandomColour(), 0,0)
    SetPal(obj, 3, ChoGGi.CodeFuncs.RandomColour(), 0,0)
    SetPal(obj, 4, ChoGGi.CodeFuncs.RandomColour(), 0,0)
  end
end

function ChoGGi.CodeFuncs.ObjectColourRandom(obj)
  if not obj or obj and not obj:IsKindOf("ColorizableObject") then
    return
  end
  local ChoGGi = ChoGGi
  local attaches = obj:GetAttaches() or ""
  --random is random after all, so lets try for at least slightly different colours
  local colours = ChoGGi.CodeFuncs.RandomColour(#attaches + 1)
  for i = 1, #attaches do
    SetRandColour(attaches[i],colours[i],ChoGGi)
  end
  SetRandColour(obj,colours[#colours],ChoGGi)
end

local function SetDefColour(obj)
  obj:SetColorModifier(6579300)
  if obj.ChoGGi_origcolors then
    local SetPal = obj.SetColorizationMaterial
    local c = obj.ChoGGi_origcolors
    SetPal(obj,1, c[1][1], c[1][2], c[1][3])
    SetPal(obj,2, c[2][1], c[2][2], c[2][3])
    SetPal(obj,3, c[3][1], c[3][2], c[3][3])
    SetPal(obj,4, c[4][1], c[4][2], c[4][3])
  end
end

function ChoGGi.CodeFuncs.ObjectColourDefault(obj)
  if not obj or obj and not obj:IsKindOf("ColorizableObject") then
    return
  end
  SetDefColour(obj)
  local attaches = obj:GetAttaches() or ""
  for i = 1, #attaches do
    SetDefColour(attaches[i])
  end
end

do --CloseDialogsECM
  local ChoGGi = ChoGGi
  local term = terminal.desktop
  function ChoGGi.CodeFuncs.RemoveOldDialogs(dialog)
    while ChoGGi.ComFuncs.CheckForTypeInList(term,dialog) do
      for i = #term, 1, -1 do
        if term[i]:IsKindOf(dialog) then
          term[i]:delete()
        end
      end
    end
  end

  function ChoGGi.CodeFuncs.CloseDialogsECM()
    ChoGGi.CodeFuncs.RemoveOldDialogs("Examine")
    ChoGGi.CodeFuncs.RemoveOldDialogs("ChoGGi_ObjectManipulator")
    ChoGGi.CodeFuncs.RemoveOldDialogs("ChoGGi_ListChoiceCustomDialog")
    ChoGGi.CodeFuncs.RemoveOldDialogs("ChoGGi_MonitorInfoDlg")
    ChoGGi.CodeFuncs.RemoveOldDialogs("ChoGGi_ExecCodeDlg")
    ChoGGi.CodeFuncs.RemoveOldDialogs("ChoGGi_MultiLineText")
  end
end

function ChoGGi.CodeFuncs.SetMechanizedDepotTempAmount(obj,amount)
  amount = amount or 10
  local resource = obj.resource
  local io_stockpile = obj.stockpiles[obj:GetNextStockpileIndex()]
  local io_supply_req = io_stockpile.supply[resource]
  local io_demand_req = io_stockpile.demand[resource]

  io_stockpile.max_z = amount
  amount = (amount * 10) * ChoGGi.Consts.ResourceScale
  io_supply_req:SetAmount(amount)
  io_demand_req:SetAmount(amount)
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
  local amount = oldobj[Concat("GetStored_",res)](oldobj)
  --not good to be larger then this when game is saved (height limit of map objects seems to be 65536)
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
    "template_name", Concat("Storage",res2),
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

function ChoGGi.CodeFuncs.ChangeObjectColour(obj,parent)
  local ChoGGi = ChoGGi
  if not obj or obj and not obj:IsKindOf("ColorizableObject") then
    MsgPopup(
      302535920000015--[[Can't colour object--]],
      302535920000016--[[Colour--]]
    )
    return
  end
  --SetPal(obj,i,Color,Roughness,Metallic)
  local SetPal = obj.SetColorizationMaterial
  local pal = ChoGGi.CodeFuncs.GetPalette(obj)

  local ItemList = {}
  for i = 1, 4 do
    local text = Concat("Color",i)
    ItemList[#ItemList+1] = {
      text = text,
      value = pal[text],
      hint = 302535920000017--[[Use the colour picker (dbl right-click for instant change).--]],
    }
    text = Concat("Metallic",i)
    ItemList[#ItemList+1] = {
      text = text,
      value = pal[text],
      hint = 302535920000018--[[Don't use the colour picker: Numbers range from -255 to 255.--]],
    }
    text = Concat("Roughness",i)
    ItemList[#ItemList+1] = {
      text = text,
      value = pal[text],
      hint = 302535920000018--[[Don't use the colour picker: Numbers range from -255 to 255.--]],
    }
  end
  ItemList[#ItemList+1] = {
    text = "X_BaseColour",
    value = 6579300,
    obj = obj,
    hint = 302535920000019--[["Single colour for object (this colour will interact with the other colours).
If you want to change the colour of an object you can't with 1-4 (like drones)."--]],
  }

  --callback
  local CallBackFunc = function(choice)
    local value = choice[1].value
    if not value then
      return
    end

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
      if parent then
        Label = parent.class
        FakeParent = parent
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
        local tab = UICity.labels[Label] or ""
        for i = 1, #tab do
          if parent then
            local attaches = type(tab[i].GetAttaches) == "function" and tab[i]:GetAttaches(obj.class) or ""
            for j = 1, #attaches do
              --if Attaches[j].class == obj.class then
                if choice[1].check2 then
                  CheckGrid(SetOrigColours,attaches[j],tab[i])
                else
                  CheckGrid(SetColours,attaches[j],tab[i])
                end
              --end
            end
          else --not parent
            if choice[1].check2 then
              CheckGrid(SetOrigColours,tab[i],tab[i])
            else
              CheckGrid(SetColours,tab[i],tab[i])
            end
          end --parent
        end
      else --single building change
        if choice[1].check2 then
          CheckGrid(SetOrigColours,obj,obj)
        else
          CheckGrid(SetColours,obj,obj)
        end
      end

      MsgPopup(
        S[302535920000020--[[Colour is set on %s--]]]:format(RetName(obj)),
        302535920000016--[[Colour--]],
        nil,
        nil,
        obj
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920000021--[[Change Colour--]]],": ",RetName(obj)),
    hint = 302535920000022--[["If number is 8421504 (0 for Metallic/Roughness) then you probably can't change that colour.

The colour picker doesn't work for Metallic/Roughness.
You can copy and paste numbers if you want (click item again after picking)."--]],
    multisel = true,
    custom_type = 2,
    check1 = 302535920000023--[[All of type--]],
    check1_hint = 302535920000024--[[Change all objects of the same type.--]],
    check2 = 302535920000025--[[Default Colour--]],
    check2_hint = 302535920000026--[[if they're there; resets to default colours.--]],
  }
end

--returns the near hex grid for object placement
function ChoGGi.CodeFuncs.CursorNearestHex()
  return HexGetNearestCenter(GetTerrainCursor())
end

--returns whatever is selected > moused over > nearest non particle object to cursor (the selection hex is a ParSystem)
function ChoGGi.CodeFuncs.SelObject()
  return SelectedObj or SelectionMouseObj() or NearestObject(
    GetTerrainCursor(),
    GetObjects{
      filter = function(o)
        if o.class ~= "ParSystem" then
          return o
        end
      end,
    },
    1500
  )
end

function ChoGGi.CodeFuncs.LightmodelBuild(list)
  local data = DataInstances.Lightmodel
  --always start with blank lightmodel
  data.ChoGGi_Custom:delete()
  data.ChoGGi_Custom = g_Classes.Lightmodel:new()
  data.ChoGGi_Custom.name = "ChoGGi_Custom"

  for i = 1, #list do
    data.ChoGGi_Custom[list[i].id] = list[i].value
  end
  ChoGGi.Temp.LightmodelCustom = data.ChoGGi_Custom
  return data.ChoGGi_Custom
end

function ChoGGi.CodeFuncs.DeleteAllAttaches(obj)
  if type(obj.GetAttaches) == "function" then
    local attaches = obj:GetAttaches() or ""
    for i = #attaches, 1, -1 do
      attaches[i]:delete()
    end
  end
end

local function GetNearestStockpile(list,GetStored,obj)
  -- check if there's actually a list and that it has anything in it
  if type(list) == "table" and #list > 0 then
    -- if there's only one pile and it has a resource
    if #list == 1 and list[1][GetStored] and list[1][GetStored](list[1]) > 999 then
      return list[1]
    else
      --otherwise filter out empty stockpiles and (and ones for other resources)
      list = FilterObjects({
        filter = function(o)
          if o[GetStored] and o[GetStored](o) > 999 then
            return o
          end
        end
      },list)
      --and return nearest
      return FindNearestObject(list,obj)
    end
  end
end

function ChoGGi.CodeFuncs.FindNearestResource(obj)
  local ChoGGi = ChoGGi
  obj = obj or ChoGGi.CodeFuncs.SelObject()
  if not obj then
    MsgPopup(
      302535920000027--[[Nothing selected--]],
      302535920000028--[[Find Resource--]]
    )
    return
  end

  local ItemList = {
    {text = S[3514],value = "Metals"},
    {text = S[4764],value = "BlackCube"},
    {text = S[8064],value = "MysteryResource"},
    {text = S[3513],value = "Concrete"},
    {text = S[1022],value = "Food"},
    {text = S[4139],value = "PreciousMetals"},
    {text = S[3515],value = "Polymers"},
    {text = S[3517],value = "Electronics"},
    {text = S[4765],value = "Fuel"},
    {text = S[3516],value = "MachineParts"},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "string" then

      --get nearest stockpiles to object
      local labels = UICity.labels
      local GetStored = Concat("GetStored_",value)

      local mechstockpile = GetNearestStockpile(labels[Concat("MechanizedDepot",value)],GetStored,obj)
      local stockpile
      if value == "BlackCube" then
        stockpile = GetNearestStockpile(labels[Concat(value,"DumpSite")],GetStored,obj)
      elseif value == "MysteryResource" then
        stockpile = GetNearestStockpile(labels["MysteryDepot"],GetStored,obj)
      else
        stockpile = GetNearestStockpile(labels["UniversalStorageDepot"],GetStored,obj)
      end
      local resourcepile = GetNearestStockpile(GetObjects{
        classes = "ResourceStockpile","ResourceStockpileLR",
        filter = function(o)
          if o.resource == value and o:GetStoredAmount() > 999 then
            return o
          end
        end,
      },"GetStoredAmount",obj)

      local piles = {
        {obj = mechstockpile, dist = mechstockpile and mechstockpile:GetDist2D(obj)},
        {obj = stockpile, dist = stockpile and stockpile:GetDist2D(obj)},
        {obj = resourcepile, dist = resourcepile and resourcepile:GetDist2D(obj)},
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
        ViewAndSelectObject(nearest)
      else
        MsgPopup(
          S[302535920000029--[[Error: Cannot find any %s.--]]]:format(choice[1].text),
          15--[[Resource--]]
        )
      end
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920000031--[[Find Nearest Resource--]]]," ",RetName(obj)),
    hint = 302535920000032--[[Select a resource to find--]],
  }
end

local function DeleteObject_ExecFunc(obj,name,param)
  if type(obj[name]) == "function" then
    obj[name](obj,param)
  end
end

local function DeleteObject_DeleteAttach(obj,name)
  if obj[name] then
    obj[name]:delete()
  end
end

function ChoGGi.CodeFuncs.DeleteObject(obj)
  local ChoGGi = ChoGGi

  --multiple selection from editor mode
  local objs = editor:GetSel() or ""
  if #objs > 0 then
    for i = 1, #objs do
      ChoGGi.CodeFuncs.DeleteObject(objs[i])
    end
  elseif not obj then
    obj = ChoGGi.CodeFuncs.SelObject()
  end

  if not obj then
    return
  end

  --deleting domes will freeze game if they have anything in them.
  if obj:IsKindOf("Dome") and obj.air then
    return
  end

  --some stuff will leave holes in the world if they're still working
  DeleteObject_ExecFunc(obj,"ToggleWorking")

  obj.can_demolish = true
  obj.indestructible = false

  if obj.DoDemolish then
    pcall(function()
      DestroyBuildingImmediate(obj)
    end)
  end

  if obj:IsKindOf("Deposit") then
    for i = #obj.group, 1, -1 do
      obj.group[i]:delete()
      obj.group[i] = nil
    end
  end

  DeleteObject_ExecFunc(obj,"Destroy")
  DeleteObject_ExecFunc(obj,"SetDome",false)
  DeleteObject_ExecFunc(obj,"RemoveFromLabels")
  DeleteObject_ExecFunc(obj,"Done")
  DeleteObject_ExecFunc(obj,"Gossip","done")
  DeleteObject_ExecFunc(obj,"SetHolder",false)

  DeleteObject_DeleteAttach(obj,"sphere")
  DeleteObject_DeleteAttach(obj,"decal")

  -- I did ask nicely
  if IsValid(obj) then
    obj:delete()
  end
end

local function AddConsumption(obj,name)
  --if this is here we know it has what we need so no need to check for mod/consump
  if obj[Concat("ChoGGi_mod_",name)] then
    local mod = obj.modifications[name]
    if mod[1] then
      mod = mod[1]
    end
    local orig = obj[Concat("ChoGGi_mod_",name)]
    if mod:IsKindOf("ObjectModifier") then
      mod:Change(orig.amount,orig.percent)
    else
      mod.amount = orig.amount
      mod.percent = orig.percent
    end
    obj[Concat("ChoGGi_mod_",name)] = nil
  end
  local amount = DataInstances.BuildingTemplate[obj.encyclopedia_id][name]
  obj:SetBase(name, amount)
end
local function RemoveConsumption(obj,name)
  local mods = obj.modifications
  if mods and mods[name] then
    local mod = obj.modifications[name]
    if mod[1] then
      mod = mod[1]
    end
    if not obj[Concat("ChoGGi_mod_",name)] then
      obj[Concat("ChoGGi_mod_",name)] = {
        amount = mod.amount,
        percent = mod.percent
      }
    end
    if mod:IsKindOf("ObjectModifier") then
      mod:Change(0,0)
    end
  end
  obj:SetBase(name, 0)
end
function ChoGGi.CodeFuncs.RemoveBuildingWaterConsump(obj)
  RemoveConsumption(obj,"water_consumption")
end
function ChoGGi.CodeFuncs.AddBuildingWaterConsump(obj)
  AddConsumption(obj,"water_consumption")
end
function ChoGGi.CodeFuncs.RemoveBuildingElecConsump(obj)
  RemoveConsumption(obj,"electricity_consumption")
end
function ChoGGi.CodeFuncs.AddBuildingElecConsump(obj)
  AddConsumption(obj,"electricity_consumption")
end
function ChoGGi.CodeFuncs.RemoveBuildingAirConsump(obj)
  RemoveConsumption(obj,"air_consumption")
end
function ChoGGi.CodeFuncs.AddBuildingAirConsump(obj)
  AddConsumption(obj,"air_consumption")
end

function ChoGGi.CodeFuncs.DisplayMonitorList(value,parent)
  if value == "New" then
    local ChoGGi = ChoGGi
    ChoGGi.ComFuncs.MsgWait(
      S[302535920000033--[[Post a request on Nexus or Github or send an email to: %s--]]]:format(ChoGGi.email),
      S[302535920000034--[[Request--]]]
    )
    return
  end

  local UICity = UICity
  local info
  local function AddGrid(Name,info)
    for i = 1, #UICity[Name] do
      info.tables[#info.tables+1] = UICity[Name][i]
    end
  end
  --0=value,1=#table,2=list table values
  local info_grid = {
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
    info_grid.title = S[302535920000035--[[Grids--]]]
    AddGrid("air",info)
    AddGrid("electricity",info)
    AddGrid("water",info)
  elseif value == "Air" then
    info = info_grid
    info_grid.title = S[891--[[Air--]]]
    AddGrid("air",info)
  elseif value == "Electricity" then
    info = info_grid
    info_grid.title = S[302535920000037--[[Electricity--]]]
    AddGrid("electricity",info)
  elseif value == "Water" then
    info = info_grid
    info_grid.title = S[681--[[Water--]]]
    AddGrid("water",info)
  elseif value == "Research" then
    info = {
      title = S[311--[[Research--]]],
      listtype = "all",
      tables = {UICity.tech_status},
      values = {
        researched = true
      }
    }
  elseif value == "Colonists" then
    info = {
      title = S[547--[[Colonists--]]],
      tables = UICity.labels.Colonist or "",
      values = {
        {name="handle",kind=0},
        {name="command",kind=0},
        {name="goto_target",kind=0},
        {name="age",kind=0},
        {name="age_trait",kind=0},
        {name="death_age",kind=0},
        {name="race",kind=0},
        {name="gender",kind=0},
        {name="birthplace",kind=0},
        {name="specialist",kind=0},
        {name="sols",kind=0},
        --{name="workplace",kind=0},
        {name="workplace_shift",kind=0},
        --{name="residence",kind=0},
        --{name="current_dome",kind=0},
        {name="daily_interest",kind=0},
        {name="daily_interest_fail",kind=0},
        {name="dome_enter_fails",kind=0},
        {name="traits",kind=2},
      }
    }
  elseif value == "Rockets" then
    info = {
      title = S[5238--[[Rockets--]]],
      tables = UICity.labels.AllRockets,
      values = {
        {name="name",kind=0},
        {name="handle",kind=0},
        {name="command",kind=0},
        {name="status",kind=0},
        {name="priority",kind=0},
        {name="working",kind=0},
        {name="charging_progress",kind=0},
        {name="charging_time_left",kind=0},
        {name="landed",kind=0},
        {name="drones",kind=1},
        --{name="units",kind=1},
        {name="unreachable_buildings",kind=0},
      }
    }
  elseif value == "City" then
    info = {
      title = S[302535920000042--[[City--]]],
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

function ChoGGi.CodeFuncs.ResetHumanCentipedes()
  local objs = UICity.labels.Colonist or ""
  for i = 1, #objs do
    --only need to do people walking outside (pathing issue), and if they don't have a path (not moving or walking into an invis wall)
    if objs[i]:IsValidPos() and not objs[i]:GetPath() then
      --too close and they keep doing the human centipede
      local x,y,_ = objs[i]:GetVisualPosXYZ()
      objs[i]:SetCommand("Goto", GetPassablePointNearby(point(x+Random(-5000,5000),y+Random(-5000,5000))))
    end
  end
end

local function AttachmentsCollisionToggle(sel,which)
  local att = sel:GetAttaches() or ""
  if att and #att > 0 then
    --are we disabling col or enabling
    local flag
    if which then
      flag = "ClearEnumFlags"
    else
      flag = "SetEnumFlags"
    end
    --and loop through all the attach
    local const = const
    for i = 1, #att do
      att[i][flag](att[i],const.efCollision + const.efApplyToGrids)
    end
  end
end

function ChoGGi.CodeFuncs.CollisionsObject_Toggle(obj,skip_msg)
  obj = obj or ChoGGi.CodeFuncs.SelObject()
  --menu item
  if not obj.class then
    obj = ChoGGi.CodeFuncs.SelObject()
  end
  if not obj then
    if not skip_msg then
      MsgPopup(
        302535920000967--[[Nothing selected.--]],
        302535920000968--[[Collisions--]]
      )
    end
    return
  end

  local which
  if obj.ChoGGi_CollisionsDisabled then
    obj:SetEnumFlags(const.efCollision + const.efApplyToGrids)
    AttachmentsCollisionToggle(obj,false)
    obj.ChoGGi_CollisionsDisabled = nil
    which = "enabled"
  else
    obj:ClearEnumFlags(const.efCollision + const.efApplyToGrids)
    AttachmentsCollisionToggle(obj,true)
    obj.ChoGGi_CollisionsDisabled = true
    which = "disabled"
  end

  if not skip_msg then
    MsgPopup(
      S[302535920000969--[[Collisions %s on %s--]]]:format(which,RetName(obj)),
      302535920000968--[[Collisions--]],
      nil,
      nil,
      obj
    )
  end
end

function ChoGGi.CodeFuncs.CheckForBrokedTransportPath(obj)
  -- let it sleep for awhile
  DelayedCall(1000, function()
    -- 0 means it's stopped, so anything above that and without a path means it's broked (probably)
    if obj:GetAnim() > 0 and obj:GetPathLen() == 0 then
      obj:InterruptCommand()
      MsgPopup(
        S[302535920001267--[[%s at position: %s was stopped.--]]]:format(RetName(obj),obj:GetVisualPos()),
        302535920001266--[[Broked Transport Pathing--]],
        "UI/Icons/IPButtons/transport_route.tga",
        nil,
        obj
      )
    end
  end)
end

function ChoGGi.CodeFuncs.DeleteAttaches(obj)
  local a = obj:GetAttaches() or ""
  for i = #a, 1, -1 do
    a[i]:delete()
  end
end

--only add unique template names
function ChoGGi.CodeFuncs.AddXTemplate(Name,Template,Table,XTemplates,InnerTable)
  if not (Name or Template or Table) then
    return
  end
  XTemplates = XTemplates or XTemplates

  if not InnerTable then
    if not XTemplates[Template][1][Name] then
      XTemplates[Template][1][Name] = true

      XTemplates[Template][1][#XTemplates[Template][1]+1] = PlaceObj("XTemplateTemplate", {
        Concat("ChoGGi_ECM_",AsyncRand()), true,
        "__context_of_kind", Table.__context_of_kind or "Infopanel",
        "__template", Table.__template or "InfopanelSection",
        "Icon", Table.Icon or "UI/Icons/gpmc_system_shine.tga",
        "Title", Table.Title or S[588--[[Empty--]]],
        "RolloverText", Table.RolloverText or S[126095410863--[[Info--]]],
        "RolloverTitle", Table.RolloverTitle or S[1000016--[[Title--]]],
        "RolloverHint", Table.RolloverHint or S[4248--[[Hints--]]],
        "OnContextUpdate", Table.OnContextUpdate
      }, {
        PlaceObj("XTemplateFunc", {
        "name", "OnActivate(self, context)",
--~         "parent", function(parent, context)
        "parent", function(parent, _)
            return parent.parent
          end,
        "func", Table.func or "function() return end"
        })
      })
    end
  else
    if not XTemplates[Template][Name] then
      XTemplates[Template][Name] = true

      XTemplates[Template][#XTemplates[Template]+1] = PlaceObj("XTemplateTemplate", {
        Concat("ChoGGi_ECM_",AsyncRand()), true,
        "__context_of_kind", Table.__context_of_kind or "Infopanel",
        "__template", Table.__template or "InfopanelSection",
        "Icon", Table.Icon or "UI/Icons/gpmc_system_shine.tga",
        "Title", Table.Title or S[588--[[Empty--]]],
        "RolloverText", Table.RolloverText or S[126095410863--[[Info--]]],
        "RolloverTitle", Table.RolloverTitle or S[1000016--[[Title--]]],
        "RolloverHint", Table.RolloverHint or S[4248--[[Hints--]]],
        "OnContextUpdate", Table.OnContextUpdate
      }, {
        PlaceObj("XTemplateFunc", {
        "name", "OnActivate(self, context)",
--~         "parent", function(parent, context)
        "parent", function(parent, _)
            return parent.parent
          end,
        "func", Table.func or "function() return end"
        })
      })
    end
  end
end
