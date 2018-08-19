-- See LICENSE for terms
--any funcs called from Code/*

local Concat = ChoGGi.ComFuncs.Concat
local TableConcat = ChoGGi.ComFuncs.TableConcat
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local RetName = ChoGGi.ComFuncs.RetName
local Random = ChoGGi.ComFuncs.Random
local S = ChoGGi.Strings
local blacklist = ChoGGi.blacklist

local pcall,type,table = pcall,type,table

local CloseXBuildMenu = CloseXBuildMenu
local CloseDialog = CloseDialog
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
local HexGetNearestCenter = HexGetNearestCenter
local IsValid = IsValid
local NearestObject = NearestObject
local OpenXBuildMenu = OpenXBuildMenu
local PlaceObj = PlaceObj
local point = point
local SelectionMouseObj = SelectionMouseObj
local Sleep = Sleep

local terminal_GetMousePos = terminal.GetMousePos
local UIL_GetScreenSize = UIL.GetScreenSize
local cameraRTS_SetProperties = cameraRTS.SetProperties
local cameraRTS_SetZoomLimits = cameraRTS.SetZoomLimits
local camera_SetFovY = camera.SetFovY
local camera_SetFovX = camera.SetFovX

-- add some shortened func names
do -- for those that don't know "do ... end" is a way of keeping "local =" local to the do
  -- make some easy to type names
  local ChoGGi = ChoGGi
  if not blacklist then
    function dump(...)
      ChoGGi.ComFuncs.Dump(...)
    end
    function dumplua(...)
      ChoGGi.ComFuncs.DumpLua(...)
    end
    function dumptable(...)
      ChoGGi.ComFuncs.DumpTable(...)
    end
    function dumpl(...)
      ChoGGi.ComFuncs.DumpLua(...)
    end
    function dumpt(...)
      ChoGGi.ComFuncs.DumpTable(...)
    end
  end

--~   local function RemoveLast(str)
--~     --remove restart/quit as the last cmd so we don't hit it by accident
--~     local dlgConsole = dlgConsole
--~     if dlgConsole.history_queue[1] == str then
--~       table.remove(dlgConsole.history_queue,1)
--~       --and save it?
--~       if rawget(_G, "dlgConsole") then
--~         dlgConsole:StoreHistory()
--~       end
--~     end
--~   end
--~   local orig_quit = quit
--~   function quit(...)
--~     orig_quit(...)
--~     RemoveLast("quit")
--~   end

  -- works with userdata or index number
  trans = ChoGGi.ComFuncs.Translate
  function so()
    return ChoGGi.CodeFuncs.SelObject()
  end
end
-- no need to have these in the do
function restart()
  quit("restart")
end
reboot = restart
exit = quit
mh = GetTerrainCursorObjSel -- only returns selected obj under cursor
mhc = GetTerrainCursorObj -- returns obj under cursor
mc = GetPreciseCursorObj
m = SelectionMouseObj
c = GetTerrainCursor -- cursor position on map
cs = terminal_GetMousePos -- cursor pos on screen
s = false -- used to store SelectedObj

-- check if tech is researched before we get value
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

--if building requires a dome and that dome is borked then assign it to nearest dome
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
    CreateRealTimeThread(function()
      building:ToggleWorking()
      Sleep(5)
      building:ToggleWorking()
    end)
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

function ChoGGi.CodeFuncs.ShowBuildMenu(which)
  local BuildCategories = BuildCategories

  --make sure we're not in the main menu (deactiving mods when going back to main menu would be nice, check for a msg to use?)
  if not Dialogs.PinsDlg then
    return
  end

  local dlg = Dialogs.XBuildMenu
  if dlg then
    --opened so check if number corresponds and if so hide the menu
    if dlg.category == BuildCategories[which].id then
      CloseDialog("XBuildMenu")
    end
  else
    OpenXBuildMenu()
  end
  dlg = Dialogs.XBuildMenu
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

-- toggle visiblity of console log
function ChoGGi.CodeFuncs.ToggleConsoleLog()
  local log = dlgConsoleLog
  if log then
    if log:GetVisible() then
      log:SetVisible(false)
    else
      log:SetVisible(true)
    end
  else
    dlgConsoleLog = ConsoleLog:new({}, terminal.desktop)
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
  if not obj.ChoGGi_origcolors and obj:IsKindOf("ColorizableObject") then
    obj.ChoGGi_origcolors = {}
    obj.ChoGGi_origcolors[#obj.ChoGGi_origcolors+1] = {obj:GetColorizationMaterial(1)}
    obj.ChoGGi_origcolors[#obj.ChoGGi_origcolors+1] = {obj:GetColorizationMaterial(2)}
    obj.ChoGGi_origcolors[#obj.ChoGGi_origcolors+1] = {obj:GetColorizationMaterial(3)}
    obj.ChoGGi_origcolors[#obj.ChoGGi_origcolors+1] = {obj:GetColorizationMaterial(4)}
  end
end
function ChoGGi.CodeFuncs.RestoreOldPalette(obj)
  if obj.ChoGGi_origcolors then
    local c = obj.ChoGGi_origcolors
    obj:SetColorizationMaterial(1, c[1][1], c[1][2], c[1][3])
    obj:SetColorizationMaterial(2, c[2][1], c[2][2], c[2][3])
    obj:SetColorizationMaterial(3, c[3][1], c[3][2], c[3][3])
    obj:SetColorizationMaterial(4, c[4][1], c[4][2], c[4][3])
    obj.ChoGGi_origcolors = nil
  end
end

function ChoGGi.CodeFuncs.GetPalette(obj)
  local pal = {}
  pal.Color1, pal.Roughness1, pal.Metallic1 = obj:GetColorizationMaterial(1)
  pal.Color2, pal.Roughness2, pal.Metallic2 = obj:GetColorizationMaterial(2)
  pal.Color3, pal.Roughness3, pal.Metallic3 = obj:GetColorizationMaterial(3)
  pal.Color4, pal.Roughness4, pal.Metallic4 = obj:GetColorizationMaterial(4)
  return pal
end

function ChoGGi.CodeFuncs.RandomColour(amount)
  if amount and type(amount) == "number" then
    local RetTableNoDupes = ChoGGi.ComFuncs.RetTableNoDupes
    local Random = Random -- ChoGGi.ComFuncs.Random

    local colours = {}
    -- populate list with amount we want
    for _ = 1, amount do
      colours[#colours+1] = Random(-16777216,0) -- 24bit colour
    end

    -- now remove all dupes and add more till we hit amount
    repeat
      -- then loop missing amount
      for _ = 1, amount - #colours do
        colours[#colours+1] = Random(-16777216,0)
      end
      -- remove dupes
      colours = RetTableNoDupes(colours)
    until #colours == amount

    return colours
  end

  -- return a single colour
  return Random(-16777216,0)
end

do -- SetRandColour
  local function SetRandColour(obj,colour,ChoGGi)
    colour = colour or ChoGGi.CodeFuncs.RandomColour()
    local c1,c2,c3,c4 = obj:GetColorizationMaterial(1),obj:GetColorizationMaterial(2),obj:GetColorizationMaterial(3),obj:GetColorizationMaterial(4)
    -- likely can only change basecolour
    if c1 == 8421504 and c2 == 8421504 and c3 == 8421504 and c4 == 8421504 then
      obj:SetColorModifier(colour)
    else
      if not obj.ChoGGi_origcolors then
        ChoGGi.CodeFuncs.SaveOldPalette(obj)
      end
      -- object,1,Color, Roughness, Metallic
      local Random = Random -- ChoGGi.ComFuncs.Random
      obj:SetColorizationMaterial(1, ChoGGi.CodeFuncs.RandomColour(), Random(-255,255),Random(-255,255))
      obj:SetColorizationMaterial(2, ChoGGi.CodeFuncs.RandomColour(), Random(-255,255),Random(-255,255))
      obj:SetColorizationMaterial(3, ChoGGi.CodeFuncs.RandomColour(), Random(-255,255),Random(-255,255))
      obj:SetColorizationMaterial(4, ChoGGi.CodeFuncs.RandomColour(), Random(-255,255),Random(-255,255))
    end
  end

  function ChoGGi.CodeFuncs.ObjectColourRandom(obj)
    if not obj or obj and not obj:IsKindOf("ColorizableObject") then
      return
    end
    local ChoGGi = ChoGGi
    local attaches = obj:IsKindOf("ComponentAttach") and obj:GetAttaches() or ""
    --random is random after all, so lets try for at least slightly different colours
    local colours = ChoGGi.CodeFuncs.RandomColour(#attaches + 1)
    for i = 1, #attaches do
      if attaches[i]:IsKindOf("ColorizableObject") then
        SetRandColour(attaches[i],colours[i],ChoGGi)
      end
    end
    SetRandColour(obj,colours[#colours],ChoGGi)
  end
end -- do

do -- SetDefColour
  local function SetDefColour(obj)
    obj:SetColorModifier(6579300)
    if obj.ChoGGi_origcolors then
      local c = obj.ChoGGi_origcolors
      obj:SetColorizationMaterial(1, c[1][1], c[1][2], c[1][3])
      obj:SetColorizationMaterial(2, c[2][1], c[2][2], c[2][3])
      obj:SetColorizationMaterial(3, c[3][1], c[3][2], c[3][3])
      obj:SetColorizationMaterial(4, c[4][1], c[4][2], c[4][3])
    end
  end

  function ChoGGi.CodeFuncs.ObjectColourDefault(obj)
    if not obj or obj and not obj:IsKindOf("ColorizableObject") then
      return
    end
    SetDefColour(obj)
    local attaches = obj:IsKindOf("ComponentAttach") and obj:GetAttaches() or ""
    for i = 1, #attaches do
      SetDefColour(attaches[i])
    end
  end
end -- do

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
    ChoGGi.CodeFuncs.RemoveOldDialogs("ChoGGi_ListChoiceDlg")
    ChoGGi.CodeFuncs.RemoveOldDialogs("ChoGGi_MonitorInfoDlg")
    ChoGGi.CodeFuncs.RemoveOldDialogs("ChoGGi_ExecCodeDlg")
    ChoGGi.CodeFuncs.RemoveOldDialogs("ChoGGi_MultiLineTextDlg")
    ChoGGi.CodeFuncs.RemoveOldDialogs("ChoGGi_FindValueDlg")
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
  local dlg = Dialogs.XBuildMenu
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

do --ChangeObjectColour
  --they get called a few times so
  local function SetOrigColours(obj)
    ChoGGi.CodeFuncs.RestoreOldPalette(obj)
    --6579300 = reset base color
    obj:SetColorModifier(6579300)
  end
  local function SetColours(obj,choice)
    ChoGGi.CodeFuncs.SaveOldPalette(obj)
    for i = 1, 4 do
      local color = choice[i].value
      local roughness = choice[i+8].value
      local metallic = choice[i+4].value
      obj:SetColorizationMaterial(i,color,roughness,metallic)
    end
    obj:SetColorModifier(choice[13].value)
  end
  --make sure we're in the same grid
  local function CheckGrid(fake_parent,Func,obj,obj_bld,choice)
    --used to check for grid connections
    local check_air = choice[1].checkair
    local check_water = choice[1].checkwater
    local check_elec = choice[1].checkelec

    if check_air and obj_bld.air and fake_parent.air and obj_bld.air.grid.elements[1].building == fake_parent.air.grid.elements[1].building then
      Func(obj,choice)
    end
    if check_water and obj_bld.water and fake_parent.water and obj_bld.water.grid.elements[1].building == fake_parent.water.grid.elements[1].building then
      Func(obj,choice)
    end
    if check_elec and obj_bld.electricity and fake_parent.electricity and obj_bld.electricity.grid.elements[1].building == fake_parent.electricity.grid.elements[1].building then
      Func(obj,choice)
    end
    if not check_air and not check_water and not check_elec then
      Func(obj,choice)
    end
  end

  function ChoGGi.CodeFuncs.ChangeObjectColour(obj,parent,dialog)
    local ChoGGi = ChoGGi
    if not obj or obj and not obj:IsKindOf("ColorizableObject") then
      MsgPopup(
        302535920000015--[[Can't colour object--]],
        302535920000016--[[Colour--]]
      )
      return
    end
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
    local function CallBackFunc(choice)
      local value = choice[1].value
      if not value then
        return
      end

      if #choice == 13 then
        --needed to set attachment colours
        local label = obj.class
        local fake_parent
        if parent then
          label = parent.class
          fake_parent = parent
        else
          fake_parent = obj.parentobj
        end
        if not fake_parent then
          fake_parent = obj
        end

        --store table so it's the same as was displayed
        table.sort(choice,
          function(a,b)
            return ChoGGi.ComFuncs.CompareTableValue(a,b,"text")
          end
        )
        --All of type checkbox
        if choice[1].check1 then
          local tab = UICity.labels[label] or ""
          for i = 1, #tab do
            if parent then
              local attaches = tab[i]:GetAttaches(obj.class) or ""
              for j = 1, #attaches do
                --if Attaches[j].class == obj.class then
                  if choice[1].check2 then
                    CheckGrid(fake_parent,SetOrigColours,attaches[j],tab[i],choice)
                  else
                    CheckGrid(fake_parent,SetColours,attaches[j],tab[i],choice)
                  end
                --end
              end
            else --not parent
              if choice[1].check2 then
                CheckGrid(fake_parent,SetOrigColours,tab[i],tab[i],choice)
              else
                CheckGrid(fake_parent,SetColours,tab[i],tab[i],choice)
              end
            end --parent
          end
        else --single building change
          if choice[1].check2 then
            CheckGrid(fake_parent,SetOrigColours,obj,obj,choice)
          else
            CheckGrid(fake_parent,SetColours,obj,obj,choice)
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
      parent = dialog,
      custom_type = 2,
      check1 = 302535920000023--[[All of type--]],
      check1_hint = 302535920000024--[[Change all objects of the same type.--]],
      check2 = 302535920000025--[[Default Colour--]],
      check2_hint = 302535920000026--[[if they're there; resets to default colours.--]],
    }
  end
end -- do

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
    -- how far from cursor do we check for objects
    1500
  )
end

function ChoGGi.CodeFuncs.DeleteAllAttaches(obj)
  if obj:IsKindOf("ComponentAttach") then
    local attaches = obj:GetAttaches() or ""
    for i = #attaches, 1, -1 do
      attaches[i]:delete()
    end
  end
end

do -- FindNearestResource
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

    local function CallBackFunc(choice)
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
end -- do

do -- DeleteObject
  local IsValid = IsValid
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

  function ChoGGi.CodeFuncs.DeleteObject(obj,editor_delete)
    local ChoGGi = ChoGGi

    if not editor_delete then
      -- multiple selection from editor mode
      local objs = editor:GetSel() or ""
      if #objs > 0 then
        for i = 1, #objs do
          if objs[i].class ~= "MapSector" then
            ChoGGi.CodeFuncs.DeleteObject(objs[i],true)
          end
        end
      elseif not obj then
        obj = ChoGGi.CodeFuncs.SelObject()
      end
    end

    if not IsValid(obj) then
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

    if obj:IsKindOf("Deposit") and obj.group then
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
end -- do

do -- BuildingConsumption
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
    local amount = BuildingTemplates[obj.id ~= "" and obj.id or obj.encyclopedia_id][name]
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
end -- do

do -- DisplayMonitorList
  local function AddGrid(UICity,name,info)
    for i = 1, #UICity[name] do
      info.tables[#info.tables+1] = UICity[name][i]
    end
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
      AddGrid(UICity,"air",info)
      AddGrid(UICity,"electricity",info)
      AddGrid(UICity,"water",info)
    elseif value == "Air" then
      info = info_grid
      info_grid.title = S[891--[[Air--]]]
      AddGrid(UICity,"air",info)
    elseif value == "Electricity" then
      info = info_grid
      info_grid.title = S[302535920000037--[[Electricity--]]]
      AddGrid(UICity,"electricity",info)
    elseif value == "Water" then
      info = info_grid
      info_grid.title = S[681--[[Water--]]]
      AddGrid(UICity,"water",info)
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
end -- do

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

do -- CollisionsObject_Toggle
  local function AttachmentsCollisionToggle(sel,which)
    local att = sel:IsKindOf("ComponentAttach") and sel:GetAttaches() or ""
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
end -- do

function ChoGGi.CodeFuncs.CheckForBorkedTransportPath(obj)
  -- let it sleep for awhile
  DelayedCall(1000, function()
    -- 0 means it's stopped, so anything above that and without a path means it's borked (probably)
    if obj:GetAnim() > 0 and obj:GetPathLen() == 0 then
      obj:InterruptCommand()
      MsgPopup(
        S[302535920001267--[[%s at position: %s was stopped.--]]]:format(RetName(obj),obj:GetVisualPos()),
        302535920001266--[[Borked Transport Pathing--]],
        "UI/Icons/IPButtons/transport_route.tga",
        nil,
        obj
      )
    end
  end)
end

function ChoGGi.CodeFuncs.DeleteAttaches(obj)
  local a = obj:IsKindOf("ComponentAttach") and obj:GetAttaches() or ""
  for i = #a, 1, -1 do
    a[i]:delete()
  end
end

function ChoGGi.CodeFuncs.RetHardwareInfo()
  local mem = {}
  for key,value in pairs(GetMemoryInfo()) do
    mem[#mem+1] = Concat(key,": ",value,"\n")
  end

  local hw = {}
  for key,value in pairs(GetHardwareInfo(0)) do
    if key == "gpu" then
      hw[#hw+1] = Concat(key,": ",GetGpuDescription(),"\n")
    else
      hw[#hw+1] = Concat(key,": ",value,"\n")
    end
  end
  table.sort(hw)
  hw[#hw+1] = "\n"

  return Concat(
    "GetHardwareInfo(0): ",TableConcat(hw),"\n\n",
    "GetMemoryInfo(): ",TableConcat(mem),"\n",
    "AdapterMode(0): ",TableConcat({GetAdapterMode(0)}," "),"\n\n",
    "GetMachineID(): ",GetMachineID(),"\n\n",
    "GetSupportedMSAAModes(): ",TableConcat(GetSupportedMSAAModes()," "):gsub("HR::",""),"\n\n",
    "GetSupportedShaderModel(): ",GetSupportedShaderModel(),"\n\n",
    "GetMaxStrIDMemoryStats(): ",GetMaxStrIDMemoryStats(),"\n\n\n\n",

    "GameObjectStats(): ",GameObjectStats(),"\n\n\n\n",

    "GetCWD(): ",GetCWD(),"\n\n",
    "GetExecDirectory(): ",GetExecDirectory(),"\n\n",
    "GetExecName(): ",GetExecName(),"\n\n",
    "GetDate(): ",GetDate(),"\n\n",
    "GetOSName(): ",GetOSName(),"\n\n",
    "GetOSVersion(): ",GetOSVersion(),"\n\n",
    "GetUsername(): ",GetUsername(),"\n\n",
    "GetSystemDPI(): ",GetSystemDPI(),"\n\n",
    "GetComputerName(): ",GetComputerName(),"\n\n\n\n"
  )
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

function ChoGGi.CodeFuncs.SetCommanderBonuses(sType)
  local currentname = g_CurrentMissionParams.idCommanderProfile
  local comm = MissionParams.idCommanderProfile.items[currentname]
  local bonus = Presets.CommanderProfilePreset.Default[sType]
  local tab = bonus or ""
  for i = 1, #tab do
    CreateRealTimeThread(function()
      comm[#comm+1] = tab[i]
    end)
  end
end

function ChoGGi.CodeFuncs.SetSponsorBonuses(sType)
  local ChoGGi = ChoGGi

  local currentname = g_CurrentMissionParams.idMissionSponsor
  local sponsor = MissionParams.idMissionSponsor.items[currentname]
  local bonus = Presets.MissionSponsorPreset.Default[sType]
  --bonuses multiple sponsors have (CompareAmounts returns equal or larger amount)
  if sponsor.cargo then
    sponsor.cargo = ChoGGi.ComFuncs.CompareAmounts(sponsor.cargo,bonus.cargo)
  end
  if sponsor.additional_research_points then
    sponsor.additional_research_points = ChoGGi.ComFuncs.CompareAmounts(sponsor.additional_research_points,bonus.additional_research_points)
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
    sponsor.rocket_price = ChoGGi.ComFuncs.CompareAmounts(sponsor.rocket_price,bonus.rocket_price)
    sponsor.applicants_price = ChoGGi.ComFuncs.CompareAmounts(sponsor.applicants_price,bonus.applicants_price)
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
    sponsor.funding_per_tech = ChoGGi.ComFuncs.CompareAmounts(sponsor.funding_per_tech,bonus.funding_per_tech)
    sponsor.funding_per_breakthrough = ChoGGi.ComFuncs.CompareAmounts(sponsor.funding_per_breakthrough,bonus.funding_per_breakthrough)
  elseif sType == "SpaceY" then
    sponsor.modifier_name1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_name1,bonus.modifier_name1)
    sponsor.modifier_value1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_value1,bonus.modifier_value1)
    sponsor.modifier_name2 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_name2,bonus.bonusmodifier_name2)
    sponsor.modifier_value2 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_value2,bonus.modifier_value2)
    sponsor.modifier_name3 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_name3,bonus.modifier_name3)
    sponsor.modifier_value3 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_value3,bonus.modifier_value3)
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
    sponsor.modifier_name1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_name1,bonus.modifier_name1)
    sponsor.modifier_value1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_value1,bonus.modifier_value1)
    sponsor[#sponsor+1] = PlaceObj("TechEffect_GrantTech",{
      "Field","Robotics",
      "Research","FueledExtractors"
    })
  elseif sType == "Paradox" then
    sponsor.applicants_per_breakthrough = ChoGGi.ComFuncs.CompareAmounts(sponsor.applicants_per_breakthrough,bonus.applicants_per_breakthrough)
    sponsor.anomaly_bonus_breakthrough = ChoGGi.ComFuncs.CompareAmounts(sponsor.anomaly_bonus_breakthrough,bonus.anomaly_bonus_breakthrough)
  end
end

do -- flightgrids
  local Flight_DbgLines
  local type_tile = terrain.TypeTileSize()
  local work_step = 16 * type_tile
  local dbg_step = work_step / 4 -- 400
  local PlacePolyline = PlacePolyline
  local MulDivRound = MulDivRound
  local InterpolateRGB = InterpolateRGB
  local Clamp = Clamp
  local AveragePoint2D = AveragePoint2D
  local terrain_GetHeight = terrain.GetHeight

  local function Flight_DbgRasterLine(pos1, pos0, zoffset)
    pos1 = pos1 or GetTerrainCursor()
    pos0 = pos0 or FindPassable(GetTerrainCursor())
    zoffset = zoffset or 0
    if not pos0 or not Flight_Height then
      return
    end
    local diff = pos1 - pos0
    local dist = diff:Len2D()
    local steps = 1 + (dist + dbg_step - 1) / dbg_step
    local points, colors = {}, {}
    local max_diff = 10 * guim
    for i = 1,steps do
      local pos = pos0 + MulDivRound(pos1 - pos0, i - 1, steps - 1)
      local height = Flight_Height:GetBilinear(pos, work_step, 0, 1) + zoffset
      points[#points + 1] = pos:SetZ(height)
      colors[#colors + 1] = InterpolateRGB(
        -1, -- white
        -16711936, -- green
        Clamp(height - zoffset - terrain_GetHeight(pos), 0, max_diff),
        max_diff
      )
    end
    local line = PlacePolyline(points, colors)
    line:SetDepthTest(false)
    line:SetPos(AveragePoint2D(points))
    Flight_DbgLines = Flight_DbgLines or {}
    Flight_DbgLines[#Flight_DbgLines+1] = line
  end

  local function Flight_DbgClear()
    if Flight_DbgLines then
      for i = 1, #Flight_DbgLines do
        Flight_DbgLines[i]:delete()
      end
      Flight_DbgLines = false
    end
  end

  local grid_thread
  function ChoGGi.CodeFuncs.FlightGrid_Update(size,zoffset)
    if grid_thread then
      DeleteThread(grid_thread)
      grid_thread = nil
      Flight_DbgClear()
    end
    ChoGGi.CodeFuncs.FlightGrid_Toggle(size,zoffset)
  end
  function ChoGGi.CodeFuncs.FlightGrid_Toggle(size,zoffset)
    if grid_thread then
      DeleteThread(grid_thread)
      grid_thread = nil
      Flight_DbgClear()
      return
    end
    grid_thread = CreateMapRealTimeThread(function()
      local Sleep = Sleep
      local orig_size = size or 256 * guim
      local pos_c
      local pos_t
      while true do
        pos_t = GetTerrainCursor()
        if pos_c ~= pos_t then
          pos_c = pos_t
          pos = pos_t
          Flight_DbgClear()
          -- Flight_DbgRasterArea
          size = orig_size
          local steps = 1 + (size + dbg_step - 1) / dbg_step
          size = steps * dbg_step
          pos = pos - point(size, size) / 2
          for y = 0,steps do
            Flight_DbgRasterLine(pos + point(0, y*dbg_step), pos + point(size, y*dbg_step), zoffset)
          end
          for x = 0,steps do
            Flight_DbgRasterLine(pos + point(x*dbg_step, 0), pos + point(x*dbg_step, size), zoffset)
          end

          Sleep(10)
        end
        Sleep(50)
      end
    end)
  end
end -- do

function ChoGGi.CodeFuncs.DraggableCheatsMenu(which)
  local XShortcutsTarget = XShortcutsTarget

  if which then
    -- add a bit of spacing above menu
    XShortcutsTarget.idMenuBar:SetPadding(box(0, 8, 0, 0))

    -- add move control to menu
    XShortcutsTarget.idMoveControl = g_Classes.XMoveControl:new({
      Id = "idMoveControl",
      MinHeight = 8,
      VAlign = "top",
    }, XShortcutsTarget)

    -- move the move control to the padding space we created above
    DelayedCall(1, function()
      -- needs a delay (cause we added the control?)
      local height = XShortcutsTarget.idToolbar.box:maxy() * -1
      XShortcutsTarget.idMoveControl:SetMargins(box(0,height,0,0))
    end)
  elseif XShortcutsTarget.idMoveControl then
    XShortcutsTarget.idMoveControl:delete()
    XShortcutsTarget.idMenuBar:SetPadding(box(0, 0, 0, 0))
  end
end

function ChoGGi.CodeFuncs.Editor_Toggle()
  local Platform = Platform

--~   if type(UpdateMapRevision) ~= "function" then
--~     function UpdateMapRevision() end
--~   end

  Platform.editor = true
  Platform.developer = true

  if IsEditorActive() then
    EditorState(0)
    table.restore(hr, "Editor")
    editor.SavedDynRes = false
    XShortcutsSetMode("Game")
    Platform.editor = false
    Platform.developer = false
  else
    table.change(hr, "Editor", {
      ResolutionPercent = 100,
      SceneWidth = 0,
      SceneHeight = 0,
      DynResTargetFps = 0
    })
    XShortcutsSetMode("Game")
    --XShortcutsSetMode("Editor", function()EditorDeactivate()end)
    EditorState(1,1)
    GetEditorInterface():Show(true)

    --GetToolbar():SetVisible(true)
    editor.OldCameraType = {
      GetCamera()
    }
    editor.CameraWasLocked = camera.IsLocked(1)
    camera.Unlock(1)

    GetEditorInterface():SetVisible(true)
    GetEditorInterface():ShowActionBar(true)
    --GetEditorInterface():SetMinimapVisible(true)
    --CreateEditorPlaceObjectsDlg()
  end

end

function ChoGGi.CodeFuncs.AddScrollDialogXTemplates(obj)
  local g_Classes = g_Classes

  obj.idChoGGi_Dialog = g_Classes.XDrawCacheDialog:new({}, obj)

  obj.idChoGGi_ScrollArea = g_Classes.ChoGGi_DialogSection:new({
    Id = "idChoGGi_ScrollArea",
    BorderWidth = 1,
    Margins = box(0,0,0,0),
    BorderColor = 0,
  }, obj.idChoGGi_Dialog)

  obj.idChoGGi_ScrollV = g_Classes.ChoGGi_SleekScroll:new({
    Id = "idChoGGi_ScrollV",
    Target = "idChoGGi_ScrollBox",
    Dock = "right",
  }, obj.idChoGGi_ScrollArea)

  obj.idChoGGi_ScrollH = g_Classes.ChoGGi_SleekScroll:new({
    Id = "idChoGGi_ScrollH",
    Target = "idChoGGi_ScrollBox",
    Dock = "bottom",
    Horizontal = true,
  }, obj.idChoGGi_ScrollArea)

  obj.idChoGGi_ScrollBox = g_Classes.XScrollArea:new({
    Id = "idChoGGi_ScrollBox",
    VScroll = "idChoGGi_ScrollV",
    HScroll = "idChoGGi_ScrollH",
    Margins = box(4,4,4,4),
    BorderWidth = 0,
  }, obj.idChoGGi_ScrollArea)

  for i = #obj, 1, -1 do
    if obj[i].class ~= "XDrawCacheDialog" then
      obj[i]:SetParent(obj.idChoGGi_ScrollBox)
    end
  end

end

