--  See LICENSE for terms

--  i like keeping all my OnMsgs in one file (go go gadget anal retentiveness)

local Concat = ChoGGi.ComFuncs.Concat
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local T = ChoGGi.ComFuncs.Trans

local pairs,type,next,tostring,print,pcall = pairs,type,next,tostring,print,pcall
local rawget,rawset = rawget,rawset

local AsyncFileToString = AsyncFileToString
local ClassDescendantsList = ClassDescendantsList
local CreateRealTimeThread = CreateRealTimeThread
local GetObjects = GetObjects
local IsValid = IsValid
local LuaCodeToTuple = LuaCodeToTuple
local Msg = Msg
local OpenGedApp = OpenGedApp
local PlaceObj = PlaceObj
local ReopenSelectionXInfopanel = ReopenSelectionXInfopanel
local SetLightmodelOverride = SetLightmodelOverride
local ShowConsoleLog = ShowConsoleLog
local UpdateDroneResourceUnits = UpdateDroneResourceUnits
local WaitMsg = WaitMsg

local UserActions_ClearGlobalTables = UserActions.ClearGlobalTables
local UserActions_GetActiveActions = UserActions.GetActiveActions
local terminal_SetOSWindowTitle = terminal.SetOSWindowTitle

local g_Classes = g_Classes
local OnMsg = OnMsg

--use this message to mess with the classdefs (before classes are built)
--function OnMsg.ClassesGenerate(classdefs)
function OnMsg.ClassesGenerate()

  local ChoGGi = ChoGGi
  ChoGGi.MsgFuncs.ReplacedFunctions_ClassesGenerate()
  ChoGGi.MsgFuncs.InfoPaneCheats_ClassesGenerate()
  if ChoGGi.Testing then
    ChoGGi.MsgFuncs.Testing_ClassesGenerate()
  end

end --OnMsg

--use this message to do some processing to the already final classdefs (still before classes are built)
function OnMsg.ClassesPreprocess()
  local ChoGGi = ChoGGi
  ChoGGi.MsgFuncs.ReplacedFunctions_ClassesPreprocess()
  if ChoGGi.Testing then
    ChoGGi.MsgFuncs.Testing_ClassesPreprocess()
  end

--~   InfopanelItems.LayoutMethod = "VList"
--~   InfopanelItems.MaxWidth = 500
--~   InfopanelItems.Clip = true
--~   InfopanelItems.LayoutVSpacing = 50
--~   InfopanelItems.Margins = box(0,135,-30,0)
--~   box(left,top, right, bottom)


--~   "None",
--~   "Box",
--~   "HOverlappingList",
--~   "VOverlappingList",
--~   "HList",
--~   "VList",
--~   "HPanel",
--~   "Grid",
--~   "HWrap",
--~   "VWrap"

  --changed from 2000000
  ConsoleLog.ZOrder = 2
end

--where we can add new BuildingTemplates
--use this message to make modifications to the built classes (before they are declared final)
function OnMsg.ClassesPostprocess()
  local ChoGGi = ChoGGi
  ChoGGi.MsgFuncs.ReplacedFunctions_ClassesPostprocess()
  if ChoGGi.Testing then
    ChoGGi.MsgFuncs.Testing_ClassesPostprocess()
  end

  --don't show cheats pane for ResourceOverview
  XTemplates.sectionCheats[1].__condition = function(parent, context)
    --no sense in doing anything without cheats pane enabled
    if not config.BuildingInfopanelCheats or context.class == "ResourceOverview" then
      return false
    end
    return context:CreateCheatActions(parent)
  end
--~   --don't show cheats pane if we don't have any to show
--~   XTemplates.sectionCheats[1].__condition = function(parent, context)
--~     --no sense in doing anything without cheats pane enabled
--~     if not config.BuildingInfopanelCheats then
--~       return false
--~     end
--~     --break on the first cheat we find
--~     local t = getmetatable(g_Classes[context.class])
--~     local cheats
--~     while type(t) == "table" do
--~       for name, value in pairs(t) do
--~         if type(name) == "string" and type(value) == "function" and name:starts_with("Cheat") then
--~           cheats = true
--~           break
--~         end
--~         t = getmetatable(t)
--~         t = t and t.__index
--~       end
--~     end
--~     if cheats then
--~       return context:CreateCheatActions(parent)
--~     end
--~   end

end

--use this message to perform post-built actions on the final classes
function OnMsg.ClassesBuilt()
  local ChoGGi = ChoGGi
  ChoGGi.MsgFuncs.ReplacedFunctions_ClassesBuilt()
  if ChoGGi.Testing then
    ChoGGi.MsgFuncs.Testing_ClassesBuilt()
  end

  --add HiddenX cat for Hidden items
  if ChoGGi.UserSettings.Building_hide_from_build_menu then
    BuildCategories[#BuildCategories+1] = {id = "HiddenX",name = T(1000155--[[Hidden--]]),img = "UI/Icons/bmc_placeholder.tga",highlight_img = "UI/Icons/bmc_placeholder_shine.tga",}
  end

  --Only added to stuff spawned with object spawner
  local XTemplates = XTemplates
  if not XTemplates.ipEverything then
    PlaceObj('XTemplate', {
      group = "Infopanel Sections",
      id = "ipEverything",
      PlaceObj('XTemplateTemplate', {
        '__context_of_kind', "CObject",
        '__condition', function (_, context) return context.ChoGGi_Spawned end,
        '__template', "Infopanel",
        'Description', T(313911890683--[[<description>--]]),
      }, {
      PlaceObj('XTemplateTemplate', {
        'comment', "salvage",
        '__template', "InfopanelButton",
        'RolloverText', T(640016954592--[[Remove this switch or valve.--]]),
        'RolloverTitle', T(3973--[[Salvage--]]),
        'RolloverHintGamepad', T(7657--[[<ButtonY> Activate--]]),
        'ContextUpdateOnOpen', false,
        'OnPressParam', "Demolish",
        'Icon', "UI/Icons/IPButtons/salvage_1.tga",
      }, {
          PlaceObj('XTemplateFunc', {
            'name', "OnXButtonDown(self, button)",
            'func', function (self, button)
              if button == "ButtonY" then
                return self:OnButtonDown(false)
              elseif button == "ButtonX" then
                return self:OnButtonDown(true)
              end
              return (button == "ButtonA") and "break"
            end,
          }),
          PlaceObj('XTemplateFunc', {
            'name', "OnXButtonUp(self, button)",
            'func', function (self, button)
              if button == "ButtonY" then
                return self:OnButtonUp(false)
              elseif button == "ButtonX" then
                return self:OnButtonUp(true)
              end
              return (button == "ButtonA") and "break"
            end,
          }),
        }),
      }),
    })
  end --XTemplates

end --OnMsg

function OnMsg.OptionsApply()
  ChoGGi.MsgFuncs.Defaults_OptionsApply()
end --OnMsg

function OnMsg.ModsLoaded()
  local ChoGGi = ChoGGi
  ChoGGi.MsgFuncs.Defaults_ModsLoaded()

  --everyone loves a new titlebar, unless they don't
  if ChoGGi.UserSettings.DontChangeTitle then
    terminal_SetOSWindowTitle(Concat(T(1079--[[Surviving Mars--]]),": ",T(302535920000887--[[ECM--]])," v",ChoGGi._VERSION))
  end
  --genders/ages/traits/specs/birthplaces
  ChoGGi.ComFuncs.UpdateColonistsTables()
end

--for instant build
function OnMsg.BuildingPlaced(Obj)
  if Obj:IsKindOf("Building") then
    ChoGGi.Temp.LastPlacedObject = Obj
  end
end --OnMsg
--regular build
function OnMsg.ConstructionSitePlaced(Obj)
  if Obj:IsKindOf("Building") then
    ChoGGi.Temp.LastPlacedObject = Obj
  end
end --OnMsg

--this gets called before buildings are completely initialized (no air/water/elec attached)
function OnMsg.ConstructionComplete(building)

  --skip rockets
  if building.class == "RocketLandingSite" then
    return
  end
  local ChoGGi = ChoGGi
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
    for i = 1, #ChoGGi.Tables.PositiveTraits do
      building:SetTrait(i,ChoGGi.Tables.PositiveTraits[i])
    end

  elseif UserSettings.SanatoriumCureAll and building.class == "Sanatorium" then
    for i = 1, #ChoGGi.Tables.NegativeTraits do
      building:SetTrait(i,ChoGGi.Tables.NegativeTraits[i])
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
      ChoGGi.CodeFuncs.RemoveBuildingElecConsump(building)
    end
    --large protect_range for defence buildings
    if setting.protect_range then
      building.protect_range = setting.protect_range
      building.shoot_range = setting.protect_range * ChoGGi.Consts.guim
    end
    --fully auto building
    if setting.performance then
      building.max_workers = 0
      building.automation = 1
      building.auto_performance = setting.performance
    end
  else
    UserSettings.BuildingSettings[building.encyclopedia_id] = nil
  end

end --OnMsg

function OnMsg.Demolished(building)
  local UICity = UICity
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

local function ColonistCreated(Obj,Skip)
  local UserSettings = ChoGGi.UserSettings

  if UserSettings.GravityColonist then
    Obj:SetGravity(UserSettings.GravityColonist)
  end
  if UserSettings.NewColonistGender then
    ChoGGi.CodeFuncs.ColonistUpdateGender(Obj,UserSettings.NewColonistGender)
  end
  if UserSettings.NewColonistAge then
    ChoGGi.CodeFuncs.ColonistUpdateAge(Obj,UserSettings.NewColonistAge)
  end
  --children don't have spec models so they get black cube
  if UserSettings.NewColonistSpecialization and not Skip then
    ChoGGi.CodeFuncs.ColonistUpdateSpecialization(Obj,UserSettings.NewColonistSpecialization)
  end
  if UserSettings.NewColonistRace then
    ChoGGi.CodeFuncs.ColonistUpdateRace(Obj,UserSettings.NewColonistRace)
  end
  if UserSettings.NewColonistTraits then
    ChoGGi.CodeFuncs.ColonistUpdateTraits(Obj,true,UserSettings.NewColonistTraits)
  end
  if UserSettings.SpeedColonist then
    Obj:SetMoveSpeed(UserSettings.SpeedColonist)
  end
end

function OnMsg.ColonistArrived(Obj)
  ColonistCreated(Obj)
end --OnMsg

function OnMsg.ColonistBorn(Obj)
  ColonistCreated(Obj,true)
end --OnMsg

function OnMsg.SelectionAdded(Obj)
  --update selection shortcut
  s = Obj
  --update last placed (or selected)
  if Obj:IsKindOf("Building") then
    ChoGGi.Temp.LastPlacedObject = Obj
  end
end

--remove selected obj when nothing selected
function OnMsg.SelectionRemoved()
  s = false
end

local function ValidGridElements(Label,UICity,IsValid)
  Label = UICity.labels[Label]
  for i = #Label, 1, -1 do
    if not IsValid(Label[i]) then
      table.remove(Label,i)
    end
  end
end

function OnMsg.NewDay() --NewSol...
  local ChoGGi = ChoGGi
  local UICity = UICity

  --sorts cc list by dist to building
  if ChoGGi.UserSettings.SortCommandCenterDist then
    local blds = GetObjects{class="Building"} or empty_table
    for i = 1, #blds do
      --no sense in doing it with only one center
      if #blds[i].command_centers > 1 then
        table.sort(blds[i].command_centers,
          function(a,b)
            return ChoGGi.ComFuncs.CompareTableFuncs(a,b,"GetDist2D",blds[i])
          end
        )
      end
    end
  end

  --GridObject.RemoveFromGrids doesn't fire for all elements? (it leaves one from the end of each grid (or grid line?), so we remove them here)
  ValidGridElements("ChoGGi_GridElements",UICity,IsValid)
  ValidGridElements("ChoGGi_LifeSupportGridElement",UICity,IsValid)
  ValidGridElements("ChoGGi_ElectricityGridElement",UICity,IsValid)

end

function OnMsg.NewHour()
  local ChoGGi = ChoGGi

  --make them lazy drones stop abusing electricity (we need to have an hourly update if people are using large prod amounts/low amount of drones)
  if ChoGGi.UserSettings.DroneResourceCarryAmountFix then
    local UICity = UICity
    local empty_table = empty_table

    --Hey. Do I preach at you when you're lying stoned in the gutter? No!
    local Table = UICity.labels.ResourceProducer or empty_table
    for i = 1, #Table do
      ChoGGi.CodeFuncs.FuckingDrones(Table[i]:GetProducerObj())
      if Table[i].wasterock_producer then
        ChoGGi.CodeFuncs.FuckingDrones(Table[i].wasterock_producer)
      end
    end
    Table = UICity.labels.BlackCubeStockpiles or empty_table
    for i = 1, #Table do
      ChoGGi.CodeFuncs.FuckingDrones(Table[i])
    end
  end

  --pathing? pathing in domes works great... Watch out for that invisible wall!
  if ChoGGi.UserSettings.ColonistsStuckOutsideServiceBuildings then
    ChoGGi.CodeFuncs.ResetHumanCentipedes()
  end

end

--if you pick a mystery from the cheat menu
local logo_13 = "UI/Icons/Logos/logo_13.tga"
function OnMsg.MysteryBegin()
  local ChoGGi = ChoGGi
  if ChoGGi.UserSettings.ShowMysteryMsgs then
    MsgPopup(T(302535920000729--[[You've started a mystery!--]]),T(3486--[[Mystery--]]),logo_13)
  end
end
function OnMsg.MysteryChosen()
  local ChoGGi = ChoGGi
  if ChoGGi.UserSettings.ShowMysteryMsgs then
    MsgPopup(T(302535920000730--[[You've chosen a mystery!--]]),T(3486--[[Mystery--]]),logo_13)
  end
end
function OnMsg.MysteryEnd(Outcome)
  local ChoGGi = ChoGGi
  if ChoGGi.UserSettings.ShowMysteryMsgs then
    MsgPopup(tostring(Outcome),T(3486--[[Mystery--]]),logo_13)
  end
end

function OnMsg.ApplicationQuit()
  local ChoGGi = ChoGGi

  --my comp or if we're resetting settings
  if ChoGGi.Temp.ResetSettings or ChoGGi.Testing then
    return
  end

  --save menu pos
  local dlgUAMenu = dlgUAMenu
  if ChoGGi.UserSettings.KeepCheatsMenuPosition and dlgUAMenu then
    ChoGGi.UserSettings.KeepCheatsMenuPosition = dlgUAMenu:GetPos()
  end

  --console log window settings
  local dlgChoGGi_ConsoleLogWin = dlgChoGGi_ConsoleLogWin
  print("dlgChoGGi_ConsoleLogWin",dlgChoGGi_ConsoleLogWin)
  if dlgChoGGi_ConsoleLogWin then
    ChoGGi.UserSettings.ConsoleLogWin_Pos = dlgChoGGi_ConsoleLogWin:GetPos()
    ChoGGi.UserSettings.ConsoleLogWin_Size = dlgChoGGi_ConsoleLogWin:GetSize()
  end

  --save any unsaved settings on exit
  ChoGGi.SettingFuncs.WriteSettings()
end

--attached temporary resource depots
function OnMsg.ChoGGi_SpawnedResourceStockpileLR(Obj)
  local ChoGGi = ChoGGi
  if ChoGGi.UserSettings.StorageMechanizedDepotsTemp and Obj.parent.class:find("MechanizedDepot") then
    ChoGGi.CodeFuncs.SetMechanizedDepotTempAmount(Obj.parent)
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
  local labels = UICity.labels
  labels.ChoGGi_GridElements[#labels.ChoGGi_GridElements+1] = Obj
  local label = labels[Concat("ChoGGi_",Obj.class)]
  label[#label+1] = Obj
end
function OnMsg.ChoGGi_RemovedGridObject(Obj)
  local ChoGGi = ChoGGi
  ChoGGi.ComFuncs.RemoveFromLabel("ChoGGi_GridElements",Obj)
  ChoGGi.ComFuncs.RemoveFromLabel(Concat("ChoGGi_",Obj.class),Obj)
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
  ChoGGi.CodeFuncs.AttachToNearestDome(Obj)
end
function OnMsg.ChoGGi_SpawnedWorkplace(Obj)
  ChoGGi.CodeFuncs.AttachToNearestDome(Obj)
end
function OnMsg.ChoGGi_SpawnedSpireBase(Obj)
  ChoGGi.CodeFuncs.AttachToNearestDome(Obj)
end
function OnMsg.ChoGGi_SpawnedDinerGrocery(Obj)
  local ChoGGi = ChoGGi
  --more food for diner/grocery
  if ChoGGi.UserSettings.ServiceWorkplaceFoodStorage then
    --for some reason InitConsumptionRequest always adds 5 to it
    local storedv = ChoGGi.UserSettings.ServiceWorkplaceFoodStorage - (5 * ChoGGi.Consts.ResourceScale)
    Obj.consumption_stored_resources = storedv
    Obj.consumption_max_storage = ChoGGi.UserSettings.ServiceWorkplaceFoodStorage
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
        Obj[Concat("max_",sType,"_charge")] = value.charge
      end
      if value.discharge then
        Obj[sType].max_discharge = value.discharge
        Obj[Concat("max_",sType,"_discharge")] = value.discharge
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
  local MilestoneCompleted = MilestoneCompleted
  PlaceObj("Milestone", {
    Complete = function(self)
      WaitMsg("ChoGGi_DaddysLittleHitler2")
      return true
    end,
    base_score = 0,
    display_name = T(302535920000731--[[Deutsche Gesellschaft für Rassenhygiene--]]),
    group = "Default",
    id = "DaddysLittleHitler"
  })
  if not MilestoneCompleted.DaddysLittleHitler then
    MilestoneCompleted.DaddysLittleHitler = 3025359200000
  end
end

function OnMsg.ChoGGi_Childkiller()
  local MilestoneCompleted = MilestoneCompleted
  PlaceObj("Milestone", {
    base_score = 0,
    display_name = T(302535920000732--[[Childkiller (You evil, evil person.)--]]),
    group = "Default",
    id = "Childkiller"
  })
  if not MilestoneCompleted.Childkiller then
    MilestoneCompleted.Childkiller = 479000000
  end
end

--earliest on-ground objects are loaded?
--function OnMsg.PersistLoad()

--saved game is loaded
function OnMsg.LoadGame()
  --so ChoGGi_Loaded gets fired only every load, rather than also everytime we save
  ChoGGi.Temp.IsGameLoaded = false
  Msg("ChoGGi_Loaded")
end

--for new games
--OnMsg.NewMapLoaded()
function OnMsg.CityStart()
  local ChoGGi = ChoGGi
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

--~ --fired as late as we can
--~ function OnMsg.ChoGGi_Loaded()
--~   Msg("ChoGGi_Loaded")
--~ end

--fired when game is loaded
function OnMsg.ChoGGi_Loaded()
  local UICity = UICity
  --for new games
  if not UICity then
    return
  end

  --place to store per-game values
  if not UICity.ChoGGi then
    UICity.ChoGGi = {}
  end

  local ChoGGi = ChoGGi

  if ChoGGi.Temp.IsGameLoaded == true then
    return
  end
  ChoGGi.Temp.IsGameLoaded = true

  local BuildMenuPrerequisiteOverrides = BuildMenuPrerequisiteOverrides
  local config = config
  local const = const
  local DataInstances = DataInstances
  local dlgConsole = dlgConsole
  local Presets = Presets
  local UserActions = UserActions
  local UserSettings = ChoGGi.UserSettings
  local hr = hr

  --gets used a few times
  local Table

  local not_ged = not g_gedListener

  --late enough that I can set g_Consts.
  ChoGGi.SettingFuncs.SetConstsToSaved()

  if not_ged then
    --needed for DroneResourceCarryAmount?
    UpdateDroneResourceUnits()
  end

  --clear out Temp settings
  ChoGGi.Temp.UnitPathingHandles = {}

  --remove all built-in actions
  UserActions_ClearGlobalTables()
  UserActions.Actions = {}
  UserActions.RejectedActions = {}

  ChoGGi.MsgFuncs.Keys_ChoGGi_Loaded()
  ChoGGi.MsgFuncs.MissionFunc_ChoGGi_Loaded()
  if ChoGGi.Testing then
    ChoGGi.MsgFuncs.Testing_ChoGGi_Loaded()
  end

  --add custom actions
  ChoGGi.MsgFuncs.BuildingsMenu_ChoGGi_Loaded()
  ChoGGi.MsgFuncs.CheatsMenu_ChoGGi_Loaded()
  ChoGGi.MsgFuncs.ColonistsMenu_ChoGGi_Loaded()
  ChoGGi.MsgFuncs.DebugMenu_ChoGGi_Loaded()
  ChoGGi.MsgFuncs.DronesAndRCMenu_ChoGGi_Loaded()
  ChoGGi.MsgFuncs.ExpandedMenu_ChoGGi_Loaded()
  ChoGGi.MsgFuncs.FixesMenu_ChoGGi_Loaded()
  ChoGGi.MsgFuncs.GameMenu_ChoGGi_Loaded()
  ChoGGi.MsgFuncs.HelpMenu_ChoGGi_Loaded()
  ChoGGi.MsgFuncs.MiscMenu_ChoGGi_Loaded()
  ChoGGi.MsgFuncs.MissionMenu_ChoGGi_Loaded()

  --add preset menu items
  ClassDescendantsList("Preset", function(name, class)
    ChoGGi.ComFuncs.AddAction(
      Concat(T(302535920000979--[[Presets--]]),"/",name),
      function()
        OpenGedApp(g_Classes[name].GedEditor, Presets[name], {
          PresetClass = name,
          SingleFile = class.SingleFile
        })
      end,
      class.EditorShortcut or nil,
      T(302535920000733--[[Open a preset in the editor.--]]),
      class.EditorIcon or "CollectionsEditor.tga"
    )
  end)

  --update menu
  if not_ged then
    g_Classes.UAMenu.UpdateUAMenu(UserActions_GetActiveActions())
  end

-------------------do the above stuff before the below stuff



  --add Scripts button to console
  if dlgConsole and not dlgConsole.ChoGGi_MenuAdded then
    dlgConsole.ChoGGi_MenuAdded = true
--~     --make some space for the button
--~     dlgConsole.idEdit:SetMargins(box(10, 0, 10, 5))
    --build console buttons
    ChoGGi.Console.ConsoleControls()
    --check for and create example scripts/script folder
    ChoGGi.Console.ListScriptFiles()
  end

  --show completed hidden milestones
  if UICity.ChoGGi.DaddysLittleHitler then
    PlaceObj("Milestone", {
      base_score = 0,
      display_name = T(302535920000731--[[Deutsche Gesellschaft für Rassenhygiene--]]),
      group = "Default",
      id = "DaddysLittleHitler"
    })
    if not MilestoneCompleted.DaddysLittleHitler then
      MilestoneCompleted.DaddysLittleHitler = 3025359200000 --hitler's birthday
    end
  end
  if UICity.ChoGGi.Childkiller then
    PlaceObj("Milestone", {
      base_score = 0,
      display_name = T(302535920000732--[[Childkiller (You evil, evil person.)--]]),
      group = "Default",
      id = "Childkiller"
    })
    --it doesn't hurt
    if not MilestoneCompleted.Childkiller then
      MilestoneCompleted.Childkiller = 479000000 --666
    end
  end

  --add custom lightmodel
  if DataInstances.Lightmodel.ChoGGi_Custom and not_ged then
    DataInstances.Lightmodel.ChoGGi_Custom:delete()
  end

  local _,LightmodelCustom = LuaCodeToTuple(UserSettings.LightmodelCustom)
  if not LightmodelCustom then
    _,LightmodelCustom = LuaCodeToTuple(ChoGGi.Defaults.LightmodelCustom)
  end

  if LightmodelCustom then
    DataInstances.Lightmodel.ChoGGi_Custom = LightmodelCustom
  else
    LightmodelCustom = ChoGGi.Consts.LightmodelCustom
    UserSettings.LightmodelCustom = LightmodelCustom
    DataInstances.Lightmodel.ChoGGi_Custom = LightmodelCustom
    ChoGGi.Temp.WriteSettings = true
  end
  ChoGGi.Temp.LightmodelCustom = LightmodelCustom

  --if there's a lightmodel name saved
  local LightModel = UserSettings.LightModel
  if LightModel then
    SetLightmodelOverride(1,LightModel)
  end

  --default only saved 20 items in console history
  const.nConsoleHistoryMaxSize = 100

  --long arsed cables
  if UserSettings.UnlimitedConnectionLength then
    g_Classes.GridConstructionController.max_hex_distance_to_allow_build = 1000
  end

  --on by default, you know all them martian trees (might make a cpu difference, probably not)
  hr.TreeWind = 0

  if UserSettings.DisableTextureCompression then
    --uses more vram (1 toggles it, not sure what 0 does...)
    hr.TR_ToggleTextureCompression = 1
  end

  if UserSettings.ShadowmapSize then
    hr.ShadowmapSize = UserSettings.ShadowmapSize
  end

  if UserSettings.VideoMemory then
    hr.DTM_VideoMemory = UserSettings.VideoMemory
  end

  if UserSettings.TerrainDetail then
    hr.TR_MaxChunks = UserSettings.TerrainDetail
  end

  if UserSettings.LightsRadius then
    hr.LightsRadiusModifier = UserSettings.LightsRadius
  end

  if UserSettings.HigherRenderDist then
    --lot of lag for some small rocks in distance
    --hr.DistanceModifier = 260 --ultra=150
    --hr.LODDistanceModifier = 260 --ultra=120
    --hr.AutoFadeDistanceScale = 2200 --def 2200
    --render objects from further away (going to 960 makes a minimal difference, other than FPS on bigger cities)
    if type(UserSettings.HigherRenderDist) == "number" then
      hr.DistanceModifier = UserSettings.HigherRenderDist
      hr.LODDistanceModifier = UserSettings.HigherRenderDist
    else
      hr.DistanceModifier = 600
      hr.LODDistanceModifier = 600
    end
  end

  if UserSettings.HigherShadowDist then
    if type(UserSettings.HigherShadowDist) == "number" then
      hr.ShadowRangeOverride = UserSettings.HigherShadowDist
    else
    --shadow cutoff dist
    hr.ShadowRangeOverride = 1000000 --def 0
    end
    --no shadow fade out when zooming
    hr.ShadowFadeOutRangePercent = 0 --def 30
  end

  --default to showing interface in ss
  if UserSettings.ShowInterfaceInScreenshots then
    hr.InterfaceInScreenshot = 1
  end

  --not sure why this would be false on a dome
  Table = UICity.labels.Dome or empty_table
  for i = 1, #Table do
    if Table[i].achievement == "FirstDome" and type(Table[i].connected_domes) ~= "table" then
      Table[i].connected_domes = {}
    end
  end

  --something messed up if storage is negative (usually setting an amount then lowering it)
  Table = UICity.labels.Storages or empty_table
  pcall(function()
    for i = 1, #Table do
      if Table[i]:GetStoredAmount() < 0 then
        --we have to empty it first (just filling doesn't fix the issue)
        Table[i]:CheatEmpty()
        Table[i]:CheatFill()
      end
    end
  end)

  --so we can change the max_amount for concrete
  if not_ged then
    Table = g_Classes.TerrainDepositConcrete.properties
    for i = 1, #Table do
      if Table[i].id == "max_amount" then
        Table[i].read_only = nil
      end
    end
  end

  --override building templates
  Table = DataInstances.BuildingTemplate
  for i = 1, #Table do
    local temp = Table[i]

    --make hidden buildings visible
    if UserSettings.Building_hide_from_build_menu then
      BuildMenuPrerequisiteOverrides["StorageMysteryResource"] = true
      BuildMenuPrerequisiteOverrides["MechanizedDepotMysteryResource"] = true
      if temp.name ~= "LifesupportSwitch" and temp.name ~= "ElectricitySwitch" then
        temp.hide_from_build_menu = nil
      end
      if temp.build_category == "Hidden" and temp.name ~= "RocketLandingSite" then
        temp.build_category = "HiddenX"
      end
    end

    --wonder building limit
    if UserSettings.Building_wonder then
      temp.wonder = nil
    end

  end

  --get the +5 bonus from phys profile, fixed in curo update
  --[[
  if UserSettings.NoRestingBonusPsychologistFix then
    local commander_profile = GetCommanderProfile()
    if commander_profile.id == "psychologist" then
      commander_profile.param1 = 5
    end
  end
  --]]

  --show cheat pane?
  if UserSettings.InfopanelCheats then
    config.BuildingInfopanelCheats = true
    ReopenSelectionXInfopanel()
  end

  --show console log history
  if UserSettings.ConsoleToggleHistory and not_ged then
    ShowConsoleLog(true)
  end

  if UserSettings.ConsoleHistoryWin and not_ged then
    ChoGGi.ComFuncs.ShowConsoleLogWin(true)
  end

  --dim that console bg
  if UserSettings.ConsoleDim then
    config.ConsoleDim = 1
  end

  if UserSettings.ShowCheatsMenu or ChoGGi.Testing then
    --always show on my computer
    if not dlgUAMenu then
      g_Classes.UAMenu.ToggleOpen()
    end
  end

  --remove some uselessish Cheats to clear up space
  if UserSettings.CleanupCheatsInfoPane then
    ChoGGi.InfoFuncs.InfopanelCheatsCleanup()
  end

  --set zoom/border scrolling
  ChoGGi.CodeFuncs.SetCameraSettings()

  --show all traits
  if UserSettings.SanatoriumSchoolShowAll then
    g_Classes.Sanatorium.max_traits = #ChoGGi.Tables.NegativeTraits
    g_Classes.School.max_traits = #ChoGGi.Tables.PositiveTraits
  end

  --people will likely just copy new mod over old, and I moved stuff around (not as important now that most everything is stored in .hpk)
  if ChoGGi._VERSION ~= UserSettings._VERSION then
    --clean up
    CreateRealTimeThread(ChoGGi.CodeFuncs.RemoveOldFiles)
    --update saved version
    UserSettings._VERSION = ChoGGi._VERSION
    ChoGGi.Temp.WriteSettings = true
  end

  CreateRealTimeThread(function()
    --add custom labels for cables/pipes
    local function CheckLabel(Label)
      if not UICity.labels[Label] then
        UICity:InitEmptyLabel(Label)
        if Label == "ChoGGi_ElectricityGridElement" or Label == "ChoGGi_LifeSupportGridElement" then
          local objs = GetObjects{class=Label:gsub("ChoGGi_","")} or empty_table
          for i = 1, #objs do
            UICity.labels[Label][#UICity.labels[Label]+1] = objs[i]
            UICity.labels.ChoGGi_GridElements[#UICity.labels.ChoGGi_GridElements+1] = objs[i]
          end
        end
      end
    end
    CheckLabel("ChoGGi_GridElements")
    CheckLabel("ChoGGi_ElectricityGridElement")
    CheckLabel("ChoGGi_LifeSupportGridElement")

    --clean up my old notifications (doesn't actually matter if there's a few left, but it can spam log)
    local shown = g_ShownOnScreenNotifications
    for Key,_ in pairs(shown) do
      if type(Key) == "number" or tostring(Key):find("ChoGGi_")then
        shown[Key] = nil
      end
    end

    --remove any dialogs we opened
    ChoGGi.CodeFuncs.CloseDialogsECM()

    --remove any outside buildings i accidentally attached to domes ;)
    Table = UICity.labels.BuildingNoDomes or empty_table
    local sType
    for i = 1, #Table do
      if Table[i].dome_required == false and Table[i].parent_dome then

        sType = false
        --remove it from the dome label
        if Table[i].closed_shifts then
          sType = "Residence"
        elseif Table[i].colonists then
          sType = "Workplace"
        end

        if sType then --get a fucking continue lua
          if Table[i].parent_dome.labels and Table[i].parent_dome.labels[sType] then
            local dome = Table[i].parent_dome.labels[sType]
            for j = 1, #dome do
              if dome[j].class == Table[i].class then
                dome[j] = nil
              end
            end
          end
          --remove parent_dome
          Table[i].parent_dome = nil
        end

      end
    end

    --make the change map dialog movable
    DataInstances.UIDesignerData.MapSettingsDialog.parent_control.Movable = true
    DataInstances.UIDesignerData.MessageQuestionBox.parent_control.Movable = true
  end)

  --make sure to save anything we changed above
  if ChoGGi.Temp.WriteSettings then
    ChoGGi.SettingFuncs.WriteSettings()
    ChoGGi.Temp.WriteSettings = nil
  end

  --print startup msgs to console log
  local msgs = ChoGGi.Temp.StartupMsgs
  for i = 1, #msgs do
    print(msgs[i])
  end

  --someone doesn't like LICENSE files...
  local dickhead
  local nofile,file = AsyncFileToString(Concat(ChoGGi.ModPath,"LICENSE"))

  if nofile then
    --some dickhead removed the LICENSE
    dickhead = true
  elseif not file:find("ChoGGi") then
    --LICENSE exists, but was changed (again dickhead)
    dickhead = true
  end

  --look ma; a LICENSE! oh no wait, just a dickhead
  if dickhead then
    --i mean you gotta be compliant somehow...
    print(ChoGGi._LICENSE)
    terminal_SetOSWindowTitle("Zombie baby Jesus eats the babies of LICENSE removers.")
  end

  --how long startup takes, maybe add this as an option for other modders to see as well?
  if ChoGGi.Testing or UserSettings.ShowStartupTicks then
    ChoGGi.Temp.StartupTicks = GetPreciseTicks() - ChoGGi.Temp.StartupTicks
    print(Concat("<color 200 200 200>",T(302535920000887--[[ECM--]]),"</color><color 0 0 0>:</color>",T(302535920000247--[[Startup ticks--]]),": ",ChoGGi.Temp.StartupTicks))
  end

end --OnMsg

--show how long loading takes
function OnMsg.ChangeMap()
  ChoGGi.Temp.StartupTicks = GetPreciseTicks()
end
