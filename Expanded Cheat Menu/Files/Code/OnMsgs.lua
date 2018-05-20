local cCodeFuncs = ChoGGi.CodeFuncs
local cComFuncs = ChoGGi.ComFuncs
local cConsts = ChoGGi.Consts
local cInfoFuncs = ChoGGi.InfoFuncs
local cMsgFuncs = ChoGGi.MsgFuncs
local cSettingFuncs = ChoGGi.SettingFuncs
local cTables = ChoGGi.Tables
local cTesting = ChoGGi.Temp.Testing

local PlayFX = PlayFX
local NearestObject = NearestObject
local Sleep = Sleep
local GetTerrainCursor = GetTerrainCursor
local GameTime = GameTime
local GetObjects = GetObjects

--fired as early as possible (excluding Init.lua of course, but i like to keep that simple)
if ChoGGi.UserSettings.DisableHints then
  mapdata.DisableHints = true
  HintsEnabled = false
end

function OnMsg.ClassesGenerate()
  --i like keeping all my OnMsgs. in one file
  cMsgFuncs.DebugFunc_ClassesGenerate()
  cMsgFuncs.ReplacedFunctions_ClassesGenerate()
  cMsgFuncs.InfoPaneCheats_ClassesGenerate()
  --custom dialogs
  cMsgFuncs.uiMultiLineEdit_ClassesGenerate()
  cMsgFuncs.ListChoiceCustom_ClassesGenerate()
  cMsgFuncs.ObjectManipulator_ClassesGenerate()
  cMsgFuncs.ExecCodeDlg_ClassesGenerate()

  --custom shuttletask
  DefineClass.ChoGGi_ShuttleFollowTask = {
    __parents = {"InitDone"},
    state = "new",
    shuttle = false,
    dest_pos = false
  }

  if cTesting then
    cMsgFuncs.Testing_ClassesGenerate()
  end
end --OnMsg

function OnMsg.ClassesPreprocess()
  local c = CargoShuttle
  c.__parents[#c.__parents] = "PinnableObject"
  c.ChoGGi_DefenceTickD = false

  DefenceTower.defence_thread_ChoGGi_Dust = false

  if cTesting then
    cMsgFuncs.Testing_ClassesPreprocess()
  end
end

--where we can add new BuildingTemplates
function OnMsg.ClassesPostprocess()
  if cTesting then
    cMsgFuncs.Testing_ClassesPostprocess()
  end
end

function OnMsg.ClassesBuilt()
  cMsgFuncs.ReplacedFunctions_ClassesBuilt()
  --custom dialogs
  cMsgFuncs.ListChoiceCustom_ClassesBuilt()
  cMsgFuncs.ObjectManipulator_ClassesBuilt()
  cMsgFuncs.ExecCodeDlg_ClassesBuilt()
  if cTesting then
    cMsgFuncs.Testing_ClassesBuilt()
  end

  function DefenceTower:DefenceTick_ChoGGi_Dust(ChoGGi)
    if ChoGGi.UserSettings.DefenceTowersAttackDustDevils then
      return cCodeFuncs.DefenceTick(self,ChoGGi.Temp.DefenceTowerRocketDD)
    end
  end
  --
  function CargoShuttle:ChoGGi_DefenceTickD(ChoGGi)
    if self.ChoGGi_FollowMouseShuttle then
      return cCodeFuncs.DefenceTick(self,ChoGGi.Temp.ShuttleRocketDD,10000)
    end
  end

  --dust for the shuttle
  local function duston(shut)
    if not shut.ChoGGi_Landed and not shut.ChoGGi_DustOn then
      PlayFX("Dust", "start", shut)
      shut.ChoGGi_DustOn = true
    end
  end
  --get shuttle to follow mouse
  function CargoShuttle:ChoGGi_FollowMouse(newpos)
    --when shuttle isn't moving it gets magical fuel from somewhere so we use a timer
    local timenow = GameTime()
    local idle = 0
    duston(self)
    repeat
      --atttack dustdevils/meteors
      local sel = SelectedObj
      local pos = self:GetVisualPos()
      local dest = GetTerrainCursor()
      local x = pos:x()
      local y = pos:y()
      if x ~= dest:x() or y ~= dest:y() then
        --don't try to fly if pos or dest aren't different (spams log)
        local path = self:CalcPath(pos, dest)
        local destp = path[#path][#path[#path]]
        --check the last path point to see if it's far away (can't be bothered to make a new func that allows you to break off the path)
        --and if we move when we're too close it's jerky
        local dist = point(x,y):Dist(destp) < 50000 and point(x,y):Dist(destp) > 2000
        if newpos or dist or idle > 50 then
          self.hover_height = 0
          --rest on ground
          if idle > 50 and pos:z() ~= terrain.GetHeight(pos) then
            self:FollowPathCmd(self:CalcPath(pos, point(x+1000,y+1000)))
            --this may not have been set so make sure we turn off dust
            self.ChoGGi_Landed = true
            self.ChoGGi_DustOn = nil
            PlayFX("Dust", "end", self)
          --goto cursor
          --elseif newpos or dist or idle > 150 then
          elseif newpos or dist then
            --reset idle count
            idle = 0
            --we don't want to skim the ground (default is 3, but this one likes living life on the edge)
            self.hover_height = 2000
            --from pinsdlg
            if newpos then
              path = self:CalcPath(pos, newpos)
              newpos = nil
            end
            if self.ChoGGi_Landed then
              self.ChoGGi_Landed = nil
              PlayFX("DomeExplosion", "start", self)
            end
            self:FollowPathCmd(path)
            --re-add the dust after a bit
            CreateRealTimeThread(function()
              Sleep(250)
              duston(self)
            end)
          end
        end
        if sel and sel ~= self then
          if IsKindOf(sel,"SubsurfaceAnomaly") then
            --scan nearby SubsurfaceAnomaly
            local anomaly = NearestObject(pos,GetObjects({class="SubsurfaceAnomaly"}),2000)
            if anomaly and sel == anomaly then
              --duston(self)
              PlayFX("ArtificialSunCharge", "start", anomaly)
              cCodeFuncs.AnalyzeAnomaly(self, anomaly)
              PlayFX("ArtificialSunCharge", "end", anomaly)
            end
          elseif type(cTesting) == "function" and sel:IsKindOfClasses("ResourceStockpile", "SurfaceDepositGroup", "ResourcePile") then
            --if carrying resource then drop it off
            local stockpile = NearestObject(pos,GetObjects({class=sel.class}),2000)
            if stockpile and sel == stockpile then
              local supply --userdata
              local demand --userdata
              local resource --string
              if IsKindOf(sel,"SurfaceDepositGroup") then
                supply = sel.group[1].task_requests[1]
                demand = sel.group[1].transport_request
                resource = sel.group[1].encyclopedia_id
              elseif IsKindOf(sel,"ResourceStockpile") then
                supply = sel.supply_request
                demand = sel.task_requests[1]
                resource = sel.resource
              end
              self.transport_task[2] = supply
              self.transport_task[3] = demand
              self.transport_task[4] = resource
              print("pickup")
              self:PickUp()
            end
          end
        end
      end
      --so shuttle follows the mouse after awhile if shuttle is too far away
      idle = idle + 1
      Sleep(300 + idle)
    --about 4 sols then send it back home
    until GameTime() - timenow > 2000000
  end
  function CargoShuttle:Analyze(anomaly)
    cCodeFuncs.AnalyzeAnomaly(self,anomaly)
  end
  function CargoShuttle:FireRocket(spot, target, rocket_class, luaobj)
    local pos = self:GetSpotPos(1)
    local angle, axis = self:GetSpotRotation(1)
    rocket_class = rocket_class or "RocketProjectile"
    luaobj = luaobj or {}
    luaobj.shooter = luaobj.shooter or self
    luaobj.target = luaobj.target or target
    local rocket = PlaceObject(rocket_class, luaobj)
    rocket:Place(pos, axis, angle)
    rocket:StartMoving()
    PlayFX("MissileFired", "start", self, nil, pos, rocket.move_dir)
    return rocket
  end

  --add HiddenX cat for Hidden items
  if ChoGGi.UserSettings.Building_hide_from_build_menu then
    BuildCategories[#BuildCategories+1] = {id = "HiddenX",name = T({1000155, "Hidden"}),img = "UI/Icons/bmc_placeholder.tga",highlight_img = "UI/Icons/bmc_placeholder_shine.tga",}
  end

end --OnMsg

function OnMsg.OptionsApply()
  cMsgFuncs.Defaults_OptionsApply()
end --OnMsg

function OnMsg.ModsLoaded()
  cMsgFuncs.Defaults_ModsLoaded()
  terminal.SetOSWindowTitle(cCodeFuncs.Trans(1079) .. ": " .. Mods[ChoGGi.id].title)
end

--earlist on-ground objects are loaded?
--function OnMsg.PersistLoad()

--saved game is loaded
function OnMsg.LoadGame()
  --so LoadingScreenPreClose gets fired only every load, rather than also everytime we save
  ChoGGi.Temp.IsGameLoaded = false
  Msg("ChoGGi_Loaded")
end

--for new games
--OnMsg.NewMapLoaded()
function OnMsg.CityStart()
  ChoGGi.Temp.IsGameLoaded = false
  --reset my mystery msgs to hidden
  ChoGGi.UserSettings.ShowMysteryMsgs = nil
  Msg("ChoGGi_Loaded")
end

function OnMsg.ReloadLua()
  --only do it when we're in-game
  if UICity then
    ChoGGi.Temp.IsGameLoaded = false
    Msg("ChoGGi_Loaded")
  end
end

--fired as late as we can
function OnMsg.LoadingScreenPreClose()
  Msg("ChoGGi_Loaded")
end

--for instant build
function OnMsg.BuildingPlaced(Obj)
  if IsKindOf(Obj,"Building") then
    ChoGGi.Temp.LastPlacedObject = Obj
  end
end --OnMsg
--regular build
function OnMsg.ConstructionSitePlaced(Obj)
  if IsKindOf(Obj,"Building") then
    ChoGGi.Temp.LastPlacedObject = Obj
  end
end --OnMsg

--this gets called before buildings are completely initialized (no air/water/elec attached)
function OnMsg.ConstructionComplete(building)

  --skip rockets
  if building.class == "RocketLandingSite" then
    return
  end
  local UserSettings = ChoGGi.UserSettings

  --print(building.encyclopedia_id) print(building.class)
  if building.class == "UniversalStorageDepot" then
    if UserSettings.StorageUniversalDepot and building.entity == "StorageDepot" then
      building.max_storage_per_resource = UserSettings.StorageUniversalDepot
    --other
    elseif UserSettings.StorageOtherDepot and building.entity ~= "StorageDepot" then
      building.max_storage_per_resource = UserSettings.StorageOtherDepot
    end

  elseif UserSettings.StorageMechanizedDepot and building.class:find("MechanizedDepot") then
    building.max_storage_per_resource = UserSettings.StorageMechanizedDepot

  elseif UserSettings.StorageWasteDepot and building.class == "WasteRockDumpSite" then
    building.max_amount_WasteRock = UserSettings.StorageWasteDepot
    if building:GetStoredAmount() < 0 then
      building:CheatEmpty()
      building:CheatFill()
    end

  elseif UserSettings.StorageOtherDepot and building.class == "MysteryDepot" then
    building.max_storage_per_resource = UserSettings.StorageOtherDepot

  elseif UserSettings.StorageOtherDepot and building.class == "BlackCubeDumpSite" then
    building.max_amount_BlackCube = UserSettings.StorageOtherDepot

  elseif UserSettings.DroneFactoryBuildSpeed and building.class == "DroneFactory" then
    building.performance = UserSettings.DroneFactoryBuildSpeed

  elseif UserSettings.ShuttleHubFuelStorage and building.class:find("ShuttleHub") then
    building.consumption_max_storage = UserSettings.ShuttleHubFuelStorage

  elseif UserSettings.SchoolTrainAll and building.class == "School" then
    for i = 1, #cTables.PositiveTraits do
      building:SetTrait(i,cTables.PositiveTraits[i])
    end

  elseif UserSettings.SanatoriumCureAll and building.class == "Sanatorium" then
    for i = 1, #cTables.NegativeTraits do
      building:SetTrait(i,cTables.NegativeTraits[i])
    end

  end --end of elseifs

  if UserSettings.InsideBuildingsNoMaintenance and building.dome_required then
    building.ChoGGi_InsideBuildingsNoMaintenance = true
    building.maintenance_build_up_per_hr = -10000
  end

  if UserSettings.RemoveMaintenanceBuildUp and building.base_maintenance_build_up_per_hr then
    building.ChoGGi_RemoveMaintenanceBuildUp = true
    building.maintenance_build_up_per_hr = -10000
  end

  local FullyAutomatedBuildings = UserSettings.FullyAutomatedBuildings
  if FullyAutomatedBuildings and building.base_max_workers then
    building.max_workers = 0
    building.automation = 1
    building.auto_performance = FullyAutomatedBuildings
  end

  --saved building settings
  local setting = UserSettings.BuildingSettings[building.encyclopedia_id]
  if setting and next(setting) then
    --saved settings for capacity, shuttles
    if setting.capacity then
      if building.base_capacity then
        building.capacity = setting.capacity
      elseif building.base_air_capacity then
        building.air_capacity = setting.capacity
      elseif building.base_water_capacity then
        building.water_capacity = setting.capacity
      elseif building.base_max_shuttles then
        building.max_shuttles = setting.capacity
      end
    end
    --max visitors
    if setting.visitors and building.base_max_visitors then
      building.max_visitors = setting.visitors
    end
    --max workers
    if setting.workers then
      building.max_workers = setting.workers
    end
    --no power needed
    if setting.nopower then
      cCodeFuncs.RemoveBuildingElecConsump(building)
    end
    --large protect_range for defence buildings
    if setting.protect_range then
      building.protect_range = setting.protect_range
      building.shoot_range = setting.protect_range * cConsts.guim
    end
  else
    UserSettings.BuildingSettings[building.encyclopedia_id] = nil
  end

end --OnMsg

function OnMsg.Demolished(building)
  --update our list of working domes for AttachToNearestDome (though I wonder why this isn't already a label)
  if building.achievement == "FirstDome" then
    local UICity = building.city or UICity
    UICity.labels.Domes_Working = nil
    UICity:InitEmptyLabel("Domes_Working")
    local Table = UICity.labels.Dome or empty_table
    for i = 1, #Table do
      UICity.labels.Domes_Working[#UICity.labels.Domes_Working+1] = Table[i]
    end
  end
end --OnMsg

local function ColonistCreated(Obj)
  local UserSettings = ChoGGi.UserSettings

  if UserSettings.GravityColonist then
    Obj:SetGravity(UserSettings.GravityColonist)
  end
  if UserSettings.NewColonistGender then
    cCodeFuncs.ColonistUpdateGender(Obj,UserSettings.NewColonistGender)
  end
  if UserSettings.NewColonistAge then
    cCodeFuncs.ColonistUpdateAge(Obj,UserSettings.NewColonistAge)
  end
  if UserSettings.NewColonistSpecialization then
    cCodeFuncs.ColonistUpdateSpecialization(Obj,UserSettings.NewColonistSpecialization)
  end
  if UserSettings.NewColonistRace then
    cCodeFuncs.ColonistUpdateRace(Obj,UserSettings.NewColonistRace)
  end
  if UserSettings.NewColonistTraits then
    cCodeFuncs.ColonistUpdateTraits(Obj,true,UserSettings.NewColonistTraits)
  end
  if UserSettings.SpeedColonist then
    Obj:SetMoveSpeed(UserSettings.SpeedColonist)
  end
end

function OnMsg.ColonistArrived(Obj)
  ColonistCreated(Obj)
end --OnMsg

function OnMsg.ColonistBorn(Obj)
  ColonistCreated(Obj)
end --OnMsg

function OnMsg.SelectionAdded(Obj)
  --update selection shortcut
  s = Obj
  --
  if IsKindOf(Obj,"Building") then
    ChoGGi.Temp.LastPlacedObject = Obj
  end
end

function OnMsg.SelectionRemoved()
  s = false
end

function OnMsg.NewDay() --newsol

  --sorts cc list by dist to building
  if ChoGGi.UserSettings.SortCommandCenterDist then
    local blds = GetObjects({class="Building"})
    for i = 1, #blds do
      table.sort(blds[i].command_centers,
        function(a,b)
          return cComFuncs.CompareTableFuncs(a,b,"GetDist2D",blds[i])
        end
      )
    end
  end

  --GridObject.RemoveFromGrids doesn't fire for all elements? (it leaves one from the end of each grid (or grid line?), so we remove them here)
  local labels = UICity.labels
  if UICity.labels.ChoGGi_GridElements then
    local function ValidGridElements(Label)
      local Table = labels[Label]
      for i = #Table, 1, -1 do
        if not IsValid(Table[i]) then
          table.remove(Table,i)
        end
      end
    end
    ValidGridElements("ChoGGi_GridElements")
    ValidGridElements("ChoGGi_LifeSupportGridElement")
    ValidGridElements("ChoGGi_ElectricityGridElement")
  end

end

function OnMsg.NewHour()
  --make them lazy drones stop abusing electricity (we need to have an hourly update if people are using large prod amounts/low amount of drones)
  if ChoGGi.UserSettings.DroneResourceCarryAmountFix then
    local city = UICity
    --Hey. Do I preach at you when you're lying stoned in the gutter? No!
    local Table = city.labels.ResourceProducer or empty_table
    for i = 1, #Table do
      cCodeFuncs.FuckingDrones(Table[i]:GetProducerObj())
      if Table[i].wasterock_producer then
        cCodeFuncs.FuckingDrones(Table[i].wasterock_producer)
      end
    end
    Table = city.labels.BlackCubeStockpiles or empty_table
    for i = 1, #Table do
      cCodeFuncs.FuckingDrones(Table[i])
    end
  end

end

--if you pick a mystery from the cheat menu
function OnMsg.MysteryBegin()
  if ChoGGi.UserSettings.ShowMysteryMsgs then
    cComFuncs.MsgPopup("You've started a mystery!","Mystery","UI/Icons/Logos/logo_13.tga")
  end
end
function OnMsg.MysteryChosen()
  if ChoGGi.UserSettings.ShowMysteryMsgs then
    cComFuncs.MsgPopup("You've chosen a mystery!","Mystery","UI/Icons/Logos/logo_13.tga")
  end
end
function OnMsg.MysteryEnd(Outcome)
  if ChoGGi.UserSettings.ShowMysteryMsgs then
    cComFuncs.MsgPopup(tostring(Outcome),"Mystery","UI/Icons/Logos/logo_13.tga")
  end
end

function OnMsg.ApplicationQuit()

  --my comp or if we're resetting settings
  if ChoGGi.Temp.ResetSettings or cTesting then
    return
  end

  --save any unsaved settings on exit
  cSettingFuncs.WriteSettings()
end

--custom OnMsgs
cComFuncs.AddMsgToFunc("CargoShuttle","GameInit","ChoGGi_SpawnedShuttle")
cComFuncs.AddMsgToFunc("Drone","GameInit","ChoGGi_SpawnedDrone")
cComFuncs.AddMsgToFunc("RCTransport","GameInit","ChoGGi_SpawnedRCTransport")
cComFuncs.AddMsgToFunc("RCRover","GameInit","ChoGGi_SpawnedRCRover")
cComFuncs.AddMsgToFunc("ExplorerRover","GameInit","ChoGGi_SpawnedExplorerRover")
cComFuncs.AddMsgToFunc("Residence","GameInit","ChoGGi_SpawnedResidence")
cComFuncs.AddMsgToFunc("Workplace","GameInit","ChoGGi_SpawnedWorkplace")
cComFuncs.AddMsgToFunc("GridObject","ApplyToGrids","ChoGGi_CreatedGridObject")
cComFuncs.AddMsgToFunc("GridObject","RemoveFromGrids","ChoGGi_RemovedGridObject")
cComFuncs.AddMsgToFunc("ElectricityProducer","CreateElectricityElement","ChoGGi_SpawnedProducerElectricity")
cComFuncs.AddMsgToFunc("AirProducer","CreateLifeSupportElements","ChoGGi_SpawnedProducerAir")
cComFuncs.AddMsgToFunc("WaterProducer","CreateLifeSupportElements","ChoGGi_SpawnedProducerWater")
cComFuncs.AddMsgToFunc("SingleResourceProducer","Init","ChoGGi_SpawnedProducerSingle")
cComFuncs.AddMsgToFunc("ElectricityStorage","GameInit","ChoGGi_SpawnedElectricityStorage")
cComFuncs.AddMsgToFunc("LifeSupportGridObject","GameInit","ChoGGi_SpawnedLifeSupportGridObject")
cComFuncs.AddMsgToFunc("PinnableObject","TogglePin","ChoGGi_TogglePinnableObject")
cComFuncs.AddMsgToFunc("ResourceStockpileLR","GameInit","ChoGGi_SpawnedResourceStockpileLR")
cComFuncs.AddMsgToFunc("DroneHub","GameInit","ChoGGi_SpawnedDroneHub")
cComFuncs.AddMsgToFunc("Diner","GameInit","ChoGGi_SpawnedDinerGrocery")
cComFuncs.AddMsgToFunc("Grocery","GameInit","ChoGGi_SpawnedDinerGrocery")

--attached temporary resource depots
function OnMsg.ChoGGi_SpawnedResourceStockpileLR(Obj)
  if ChoGGi.UserSettings.StorageMechanizedDepotsTemp and Obj.parent.class:find("MechanizedDepot") then
    cCodeFuncs.SetMechanizedDepotTempAmount(Obj.parent)
  end
end

function OnMsg.ChoGGi_TogglePinnableObject(Obj)
  local UnpinObjects = ChoGGi.UserSettings.UnpinObjects
  if type(UnpinObjects) == "table" and next(UnpinObjects) then
    local Table = UnpinObjects or empty_table
    for i = 1, #Table do
      if Obj.class == Table[i] and Obj:IsPinned() then
        Obj:TogglePin()
        break
      end
    end
  end
end

--custom UICity.labels lists
function OnMsg.ChoGGi_CreatedGridObject(Obj)
  if Obj.class == "ElectricityGridElement" or Obj.class == "LifeSupportGridElement" then
    local labels = UICity.labels
    labels.ChoGGi_GridElements[#labels.ChoGGi_GridElements+1] = Obj
    local label = labels["ChoGGi_" .. Obj.class]
    label[#label+1] = Obj
  end
end
function OnMsg.ChoGGi_RemovedGridObject(Obj)
  if Obj.class == "ElectricityGridElement" or Obj.class == "LifeSupportGridElement" then
    cComFuncs.RemoveFromLabel("ChoGGi_GridElements",Obj)
    cComFuncs.RemoveFromLabel("ChoGGi_" .. Obj.class,Obj)
  end
end

--shuttle comes out of a hub
function OnMsg.ChoGGi_SpawnedShuttle(Obj)
  local UserSettings = ChoGGi.UserSettings
  if UserSettings.StorageShuttle then
    Obj.max_shared_storage = UserSettings.StorageShuttle
  end
  if UserSettings.SpeedShuttle then
    Obj.max_speed = UserSettings.SpeedShuttle
  end
end

function OnMsg.ChoGGi_SpawnedDrone(Obj)
  local UserSettings = ChoGGi.UserSettings
  if UserSettings.GravityDrone then
    Obj:SetGravity(UserSettings.GravityDrone)
  end
  if UserSettings.SpeedDrone then
    Obj:SetMoveSpeed(UserSettings.SpeedDrone)
  end
end

local function RCCreated(Obj)
  local UserSettings = ChoGGi.UserSettings
  if UserSettings.SpeedRC then
    Obj:SetMoveSpeed(UserSettings.SpeedRC)
  end
  if UserSettings.GravityRC then
    Obj:SetGravity(UserSettings.GravityRC)
  end
end
function OnMsg.ChoGGi_SpawnedRCTransport(Obj)
  local UserSettings = ChoGGi.UserSettings
  if UserSettings.RCTransportStorageCapacity then
    Obj.max_shared_storage = UserSettings.RCTransportStorageCapacity
  end
  RCCreated(Obj)
end
function OnMsg.ChoGGi_SpawnedRCRover(Obj)
  if ChoGGi.UserSettings.RCRoverMaxRadius then
    Obj:SetWorkRadius() -- I override the func so no need to send a value here
  end
  RCCreated(Obj)
end
function OnMsg.ChoGGi_SpawnedExplorerRover(Obj)
  RCCreated(Obj)
end

function OnMsg.ChoGGi_SpawnedDroneHub(Obj)
  if ChoGGi.UserSettings.CommandCenterMaxRadius then
    Obj:SetWorkRadius()
  end
end

--if an inside building is placed outside of dome, attach it to nearest dome (if there is one)
function OnMsg.ChoGGi_SpawnedResidence(Obj)
  cCodeFuncs.AttachToNearestDome(Obj)
end
function OnMsg.ChoGGi_SpawnedWorkplace(Obj)
  cCodeFuncs.AttachToNearestDome(Obj)
end
function OnMsg.ChoGGi_SpawnedDinerGrocery(Obj)
  local ChoGGi = ChoGGi
  local UserSettings = ChoGGi.UserSettings

  --more food for diner/grocery
  if UserSettings.ServiceWorkplaceFoodStorage then
    --for some reason InitConsumptionRequest always adds 5 to it
    local storedv = UserSettings.ServiceWorkplaceFoodStorage - (5 * ChoGGi.Consts.ResourceScale)
    Obj.consumption_stored_resources = storedv
    Obj.consumption_max_storage = UserSettings.ServiceWorkplaceFoodStorage
  end
end

--make sure they use with our new values
local function SetProd(Obj,sType)
  local prod = ChoGGi.UserSettings.BuildingSettings[Obj.encyclopedia_id]
  if prod and prod.production then
    Obj[sType] = prod.production
  end
end
function OnMsg.ChoGGi_SpawnedProducerElectricity(Obj)
  SetProd(Obj,"electricity_production")
end
function OnMsg.ChoGGi_SpawnedProducerAir(Obj)
  SetProd(Obj,"air_production")
end
function OnMsg.ChoGGi_SpawnedProducerWater(Obj)
  SetProd(Obj,"water_production")
end
function OnMsg.ChoGGi_SpawnedProducerSingle(Obj)
  SetProd(Obj,"production_per_day")
end

local function CheckForRate(Obj)

  --charge/discharge
  local value = ChoGGi.UserSettings.BuildingSettings[Obj.encyclopedia_id]

  if value then
    local function SetValue(sType)
      if value.charge then
        Obj[sType].max_charge = value.charge
        Obj["max_" .. sType .. "_charge"] = value.charge
      end
      if value.discharge then
        Obj[sType].max_discharge = value.discharge
        Obj["max_" .. sType .. "_discharge"] = value.discharge
      end
    end

    if type(Obj.GetStoredAir) == "function" then
      SetValue("air")
    elseif type(Obj.GetStoredWater) == "function" then
      SetValue("water")
    elseif type(Obj.GetStoredPower) == "function" then
      SetValue("electricity")
    end

  end
end

--water/air tanks
function OnMsg.ChoGGi_SpawnedLifeSupportGridObject(Obj)
  CheckForRate(Obj)
end
--battery
function OnMsg.ChoGGi_SpawnedElectricityStorage(Obj)
  CheckForRate(Obj)
end

--hidden milestones
function OnMsg.ChoGGi_DaddysLittleHitler()
  PlaceObj("Milestone", {
    Complete = function(self)
      WaitMsg("ChoGGi_DaddysLittleHitler2")
      return true
    end,
    SortKey = 0,
    base_score = 0,
    bonus_score = 0,
    bonus_score_expiration = 0,
    display_name = "Deutsche Gesellschaft fur Rassenhygiene",
    group = "Default",
    id = "DaddysLittleHitler"
  })
  if not MilestoneCompleted.DaddysLittleHitler then
    MilestoneCompleted.DaddysLittleHitler = 3025359200000
  end
end

function OnMsg.ChoGGi_Childkiller()
  PlaceObj("Milestone", {
    SortKey = 0,
    base_score = 0,
    bonus_score = 0,
    bonus_score_expiration = 666,
    display_name = "Childkiller (You evil, evil person.)",
    group = "Default",
    id = "Childkiller"
  })
  if not MilestoneCompleted.Childkiller then
    MilestoneCompleted.Childkiller = 479000000
  end
end
