--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local DeleteObject = ChoGGi.ComFuncs.DeleteObject
local S = ChoGGi.Strings

local pairs,pcall,type = pairs,pcall,type

local CreateRealTimeThread = CreateRealTimeThread
local FindNearestObject = FindNearestObject
local ForEach = ForEach
local GenerateColonistData = GenerateColonistData
local GetObjects = GetObjects
local GetPassablePointNearby = GetPassablePointNearby
local GetStateIdx = GetStateIdx
local HexGetNearestCenter = HexGetNearestCenter
local IsValid = IsValid
local Msg = Msg
local Sleep = Sleep

function ChoGGi.MenuFuncs.FireMostFixes()
  local ChoGGi = ChoGGi
  ChoGGi.MenuFuncs.RemoveUnreachableConstructionSites()
  ChoGGi.MenuFuncs.ParticlesWithNullPolylines()
  ChoGGi.MenuFuncs.StutterWithHighFPS()

  ChoGGi.MenuFuncs.ColonistsTryingToBoardRocketFreezesGame()
  ChoGGi.MenuFuncs.AttachBuildingsToNearestWorkingDome()
  ChoGGi.MenuFuncs.DronesKeepTryingBlockedAreas()
  ChoGGi.MenuFuncs.RemoveYellowGridMarks()
  ChoGGi.MenuFuncs.RemoveBlueGridMarks()
  ChoGGi.MenuFuncs.CablesAndPipesRepair()
  ChoGGi.MenuFuncs.MirrorSphereStuck()
  ChoGGi.MenuFuncs.ProjectMorpheusRadarFellDown()
end

do -- DronesNotRepairingDome
  local ChoGGi = ChoGGi
  local looping_thread

  local function MoveAllRes()
    local domes = UICity.labels.Domes or ""
    for i = 1, #domes do
      -- get a list of all res in the center of dome
      local pos = domes[i]:GetSpotPos(-1)
      local objs = GetObjects{
        class = "ResourcePile",
        -- we only want stuff within *radius*
        filter = function(o)
          if o:GetDist2D(pos) <= 1000 then
            return o
          end
        end,
      }

      -- loop through the spots till we find a Workdrone outside the dome (any spot outside will do)
      if #objs > 0 then
        local start_id, end_id = domes[i]:GetAllSpots(domes[i]:GetState())
        for j = start_id, end_id do
          if domes[i]:GetSpotName(j) == "Workdrone" then
            local spot_pos = domes[i]:GetSpotPos(j)
            -- and goodbye res
            for k = 1, #objs do
              objs[k]:SetPos(spot_pos)
            end
            break
          end
        end
      end
    end
  end

  function ChoGGi.MenuFuncs.DronesNotRepairingDomes()
    MsgPopup(
      83--[[Domes--]],
      302535920001295--[[Drones Not Repairing Domes--]]
    )
    -- just in case someone decides to click it more than once...
    if looping_thread then
      DeleteThread(looping_thread)
      looping_thread = nil
    end
    -- loop 50 times, more than long enough for a drone smart/idle enough to grab the res outside the dome and repair it.
    looping_thread = CreateRealTimeThread(function()
      local count = 0
      while true do
        if count > 49 then
          break
        end
        count = count + 1
        MoveAllRes()
        Sleep(1000)
      end
      MsgPopup(
        1157--[[Complete thread--]],
        302535920001295--[[Drones Not Repairing Domes--]]
      )
    end)
  end
end -- do

function ChoGGi.MenuFuncs.CheckForBorkedTransportPath_Toggle()
  local ChoGGi = ChoGGi
  if ChoGGi.UserSettings.CheckForBorkedTransportPath then
    ChoGGi.UserSettings.CheckForBorkedTransportPath = nil
  else
    ChoGGi.UserSettings.CheckForBorkedTransportPath = true
    ChoGGi.MenuFuncs.StutterWithHighFPS(true)
  end

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.CheckForBorkedTransportPath,302535920001266--[[Borked Transport Pathing--]]),
    1683--[[RC Transport--]],
    "UI/Icons/IPButtons/transport_route.tga"
  )
end

function ChoGGi.MenuFuncs.AllPipeSkinsToDefault()
  local ChoGGi = ChoGGi
  CreateRealTimeThread(function()
    -- so GetPipeConnections ignores the dupe connection error
    ChoGGi.Temp.FixingPipes = true
    local grids = UICity.water
    for i = 1, #grids do
      grids[i]:ChangeElementSkin("Chrome", true)
      -- needs a slight delay between changing skins
      Sleep(100)
      grids[i]:ChangeElementSkin("Default", true)
    end
    ChoGGi.Temp.FixingPipes = nil
  end)
end

local function ResetRover(rc)
  if rc.attached_drones then
    for i = 1, #rc.attached_drones do
      rc.attached_drones[i]:delete()
    end
  end
  local pos = rc:GetVisualPos()
  local new = rc:Clone()
  rc:delete()
  new:SetPos(GetPassablePointNearby(pos))
end

function ChoGGi.MenuFuncs.ResetRovers()
  CreateRealTimeThread(function()
    local before_table = {}

    -- get all rovers stuck in deploy with at least one drone
    ForEach({
      class = "RCRover",
      exec = function(rc)
        local drones = #rc.attached_drones > 0
--~         print("sdfsdfds",state,drones)
        if drones then
          if rc:GetState() == GetStateIdx("deployIdle") then
            -- store them in a table for later
            before_table[rc.handle] = {rc = rc, amount = #rc.attached_drones}
          -- borked, no sense in waiting for later
          elseif rc:GetState() == GetStateIdx("idle") and rc.waiting_on_drones then
            ResetRover(rc)
          end
        end
      end
    })
    -- let user know something is happening
    MsgPopup(
      302535920000464--[[Updating Rovers--]],
      5438--[[Rovers--]]
    )
    --wait awhile just to be sure
    Sleep(5000)
    --go through and reset any rovers still doing the same thing
    for _,rc_table in pairs(before_table) do
      local state = rc_table.rc:GetState() == GetStateIdx("deployIdle")
      local drones = #rc_table.rc.attached_drones == rc_table.amount
      if state and drones then
        ResetRover(rc_table.rc)
      end
    end
  end)
end

local function SpawnColonist(old_c,building,pos,city)
  local dome = FindNearestObject(city.labels.Dome or empty_table,old_c or building)
  if not dome then
    return
  end

  local colonist
  if old_c then
--~     colonist = GenerateColonistData(city, old_c.age_trait, false, old_c.gender, old_c.entity_gender, true)
    colonist = GenerateColonistData(city, old_c.age_trait, false, {gender=old_c.gender,entity_gender=old_c.entity_gender,no_traits = "no_traits",no_specialization=true})
    --we set all the set gen doesn't (it's more for random gen after all
    colonist.birthplace = old_c.birthplace
    colonist.death_age = old_c.death_age
    colonist.name = old_c.name
    colonist.race = old_c.race
    colonist.specialist = old_c.specialist
    for trait_id, _ in pairs(old_c.traits) do
      if trait_id and trait_id ~= "" then
        colonist.traits[trait_id] = true
        --colonist:AddTrait(trait_id,true)
      end
    end
  else
    --GenerateColonistData(city, age_trait, martianborn, gender, entity_gender, no_traits)
    colonist = GenerateColonistData(city)
  end

  colonist.dome = dome
  colonist.current_dome = dome
  Colonist:new(colonist)
  Msg("ColonistBorn", colonist)
  colonist:SetPos(pos or dome:PickColonistSpawnPt())
  --dome:UpdateUI()
  --if spec is different then updates to new entity
  colonist:ChooseEntity()
  return colonist
end

function ChoGGi.MenuFuncs.ResetAllColonists()
    local function CallBackFunc(answer)
      if answer then
        local objs = UICity.labels.Colonist or ""
        for i = 1, #objs do
          local c = objs[i]
          SpawnColonist(c,something,c:GetVisualPos(),UICity)
          if type(c.Done) == "function" then
            c:Done()
          end
          c:delete()
        end
      end
    end
    ChoGGi.ComFuncs.QuestionBox(
      Concat(S[6779--[[Warning--]]],"!\n",S[302535920000055--[[Reset All Colonists--]]],"\n",S[302535920000939--[["Fix certain freezing issues (mouse still moves screen, keyboard doesn't), will lower comfort by about 20."--]]]),
      CallBackFunc,
      Concat(S[6779--[[Warning--]]],": ",S[302535920000055--[[Reset All Colonists--]]])
    )
end

function ChoGGi.MenuFuncs.ColonistsTryingToBoardRocketFreezesGame()
  local UICity = UICity
  local objs = UICity.labels.Colonist or ""
  for i = 1, #objs do
    local c = objs[i]
    if c:GetStateText() == "movePlanet" then
      local rocket = FindNearestObject(UICity.labels.AllRockets or empty_table,c)
      SpawnColonist(c,rocket,c:GetVisualPos(),UICity)
      if type(c.Done) == "function" then
        c:Done()
      end
      c:delete()
    end
  end
end

function ChoGGi.MenuFuncs.ColonistsStuckOutsideRocket()
  local rockets = UICity.labels.AllRockets or ""
  local pos
  for i = 1, #rockets do
    -- AllRockets also returns rockets in space
    if rockets[i]:IsValidPos() then
      pos = rockets[i]:GetPos()
      local attaches = rockets[i]:GetAttaches("Colonist") or ""
      if #attaches > 0 then
        for j = #attaches, 1, -1 do
          local c = attaches[j]
          -- try to remove attached colonist from rocket, and get pos so we can create a new c at the same pos
          if not pcall(function()
            c:Detach()
            pos = type(c.GetPos) == "function" and c:GetPos() or pos
            SpawnColonist(c,rockets[i],pos)
          end) then
            SpawnColonist(nil,rockets[i],pos)
            --something messed up with so just spawn random colonist
          end
          if type(c.Done) == "function" then
            c:Done()
          end
          c:delete()
        end
      end
    end
  end

end

function ChoGGi.MenuFuncs.ParticlesWithNullPolylines()
  local objs = GetObjects{class = "ParSystem",area = ""}
  for i = 1, #objs do
    if type(objs[i].polyline) == "string" and objs[i].polyline:find("\0") then
      objs[i]:delete()
    end
  end
end

function ChoGGi.MenuFuncs.RemoveMissingClassObjects()
  ForEach{
    class = "UnpersistedMissingClass",
    exec = function(obj)
      DeleteObject(obj)
    end
  }
end

function ChoGGi.MenuFuncs.MirrorSphereStuck()
  local objs = UICity.labels.MirrorSpheres or ""
  for i = 1, #objs do
    if not IsValid(objs[i].target) then
      DeleteObject(objs[i])
    end
  end
  objs = GetObjects{class = "ParSystem",area = ""}
  for i = 1, #objs do
    if objs[i]:GetProperty("ParticlesName") == "PowerDecoy_Captured" and
        type(objs[i].polyline) == "string" and objs[i].polyline:find("\0") then
      objs[i]:delete()
    end
  end
end

function ChoGGi.MenuFuncs.StutterWithHighFPS(skip)
  local ChoGGi = ChoGGi
  local objs = UICity.labels.Unit or ""
  --CargoShuttle
  for i = 1, #objs do
    ChoGGi.CodeFuncs.CheckForBorkedTransportPath(objs[i])
  end

  if skip ~= true then
    ChoGGi.CodeFuncs.ResetHumanCentipedes()
  end
end

local function ResetPriorityQueue(cls_name)
  local const = const
  local hubs = GetObjects{class = cls_name,area = ""}
  for i = 1, #hubs do
    --clears out the queues
    hubs[i].priority_queue = {}
    for priority = -1, const.MaxBuildingPriority do
      hubs[i].priority_queue[priority] = {}
    end
  end
end
function ChoGGi.MenuFuncs.DronesKeepTryingBlockedAreas()
  local ChoGGi = ChoGGi
  ResetPriorityQueue("SupplyRocket")
  ResetPriorityQueue("RCRover")
  ResetPriorityQueue("DroneHub")
  --toggle working state on all ConstructionSite (wakes up drones else they'll wait at hub)
  local Sites = GetObjects{class = "ConstructionSite"}
  for i = 1, #Sites do
    ChoGGi.CodeFuncs.ToggleWorking(Sites[i])
  end
end

function ChoGGi.MenuFuncs.AlignAllBuildingsToHexGrid()
  local blds = GetObjects{class = "Building"}
  if blds[1] and blds[1].class then
    for i = 1, #blds do
      blds[i]:SetPos(HexGetNearestCenter(blds[i]:GetVisualPos()))
    end
  end
end

local function RemoveUnreachable(cls_name)
  local objs = GetObjects{class = cls_name,area = ""}
  for i = 1, #objs do
    for bld,_ in pairs(objs[i].unreachable_buildings or empty_table) do
      if type(bld.IsKindOf) == "function" and bld:IsKindOf("ConstructionSite") then
        bld:Cancel()
      end
    end
    objs[i].unreachable_buildings = empty_table
  end
end
function ChoGGi.MenuFuncs.RemoveUnreachableConstructionSites()
  local objs = UICity.labels.Drone or ""
  for i = 1, #objs do
    objs[i]:CleanUnreachables()
  end
  RemoveUnreachable("DroneHub")
  RemoveUnreachable("RCRover")
  RemoveUnreachable("SupplyRocket")
  MsgPopup(
    302535920000970--[[Removed unreachable--]],
    302535920000971--[[Sites--]]
  )
end

function ChoGGi.MenuFuncs.RemoveYellowGridMarks()
	ForEach{
		class = "GridTile",
		exec = function(obj)
      obj:delete()
		end
	}
end

function ChoGGi.MenuFuncs.RemoveBlueGridMarks()
	ForEach{
		class = "RangeHexRadius",
		exec = function(obj)
      obj:delete()
		end
	}
end

function ChoGGi.MenuFuncs.ProjectMorpheusRadarFellDown()
  local objs = UICity.labels.ProjectMorpheus or ""
  for i = 1, #objs do
    objs[i]:ChangeWorkingStateAnim(false)
    objs[i]:ChangeWorkingStateAnim(true)
  end
end

function ChoGGi.MenuFuncs.RebuildWalkablePointsInDomes()
	ForEach{
		class = "Dome",
		exec = function(dome)
      dome.walkable_points = false
      dome:GenerateWalkablePoints()
		end
	}
end

function ChoGGi.MenuFuncs.AttachBuildingsToNearestWorkingDome()
  local ChoGGi = ChoGGi
  local objs = UICity.labels.InsideBuildings or ""
  for i = 1, #objs do
    ChoGGi.CodeFuncs.AttachToNearestDome(objs[i])
  end

  MsgPopup(
    302535920000972--[[Buildings attached.--]],
    3980--[[Buildings--]],
    "UI/Icons/Sections/basic.tga"
  )
end

function ChoGGi.MenuFuncs.ColonistsFixBlackCube()
  local objs = UICity.labels.Colonist or ""
  for i = 1, #objs do
    local c = objs[i]
--~     if c.entity:find("Child",1,true) then
    if c.entity:find("Child",1,true) and c.specialist ~= "none" then
      c.specialist = "none"

      c.traits.Youth = nil
      c.traits.Adult = nil
      c.traits["Middle Aged"] = nil
      c.traits.Senior = nil
      c.traits.Retiree = nil

      c.traits.Child = true
      c.age_trait = "Child"
      c.age = 0
      c:ChooseEntity()
      c:SetResidence(false)
      c:UpdateResidence()
    end
  end
end

local function RepairBorkedShit(borked_shit)
  local just_in_case = 0
  while #borked_shit > 0 do

    for i = #borked_shit, 1, -1 do
      if IsValid(borked_shit[i]) and type(borked_shit[i].Repair) == "function" then
        borked_shit[i]:Repair()
      end
    end

    if just_in_case > 25000 then
      break
    end
    just_in_case = just_in_case + 1

  end
end

function ChoGGi.MenuFuncs.CablesAndPipesRepair()
  local g_BrokenSupplyGridElements = g_BrokenSupplyGridElements
  RepairBorkedShit(g_BrokenSupplyGridElements.electricity)
  RepairBorkedShit(g_BrokenSupplyGridElements.water)
end

------------------------- toggles

function ChoGGi.MenuFuncs.DroneChargesFromRoverWrongAngle_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.DroneChargesFromRoverWrongAngle = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.DroneChargesFromRoverWrongAngle)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DroneChargesFromRoverWrongAngle,302535920001071--[[Drone Charges From Rover Wrong Angle--]]),
    517--[[Drones--]]
  )
end

function ChoGGi.MenuFuncs.ColonistsStuckOutsideServiceBuildings_Toggle()
  local ChoGGi = ChoGGi
  if ChoGGi.UserSettings.ColonistsStuckOutsideServiceBuildings then
    ChoGGi.UserSettings.ColonistsStuckOutsideServiceBuildings = nil
  else
    ChoGGi.UserSettings.ColonistsStuckOutsideServiceBuildings = true
    ChoGGi.CodeFuncs.ResetHumanCentipedes()
  end

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.ColonistsStuckOutsideServiceBuildings,302535920000248--[[Colonists Stuck Outside Service Buildings--]]),
    547--[[Colonists--]],
    "UI/Icons/IPButtons/colonist_section.tga"
  )
end

function ChoGGi.MenuFuncs.DroneResourceCarryAmountFix_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.DroneResourceCarryAmountFix = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.DroneResourceCarryAmountFix)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DroneResourceCarryAmountFix,302535920000613--[[Drone Carry Amount--]]),
    517--[[Drones--]],
    "UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.MenuFuncs.SortCommandCenterDist_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.SortCommandCenterDist = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.SortCommandCenterDist)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.SortCommandCenterDist,302535920000615--[[Sort Command Center Dist--]]),
    3980--[[Buildings--]]
  )
end

---------------------------------------------------Testers

--~ GetDupePositions(UICity.labels.Colonist or "")
--~ function ChoGGi.MenuFuncs.GetDupePositions(list)
--~   local dupes = {}
--~   local positions = {}
--~   local pos
--~   for i = 1, #list do
--~     pos = list[i]:GetPos()
--~     pos = tostring(point(pos:x(),pos:y()))
--~     if not positions[pos] then
--~       positions[pos] = true
--~     else
--~       dupes[pos] = true
--~     end
--~   end
--~   if #dupes > 0 then
--~     table.sort(dupes)
--~     OpenExamine(dupes)
--~   end
--~ end

--~ function ChoGGi.MenuFuncs.DeathToObjects(classname)
--~   local objs = GetObjects{class = classname,area = ""}
--~   print(#objs," = ",classname)
--~   for i = 1, #objs do
--~     objs[i]:delete()
--~   end
--~ end

--~ ChoGGi.MenuFuncs.DeathToObjects("BaseRover")
--~ ChoGGi.MenuFuncs.DeathToObjects("Colonist")
--~ ChoGGi.MenuFuncs.DeathToObjects("CargoShuttle")
--~ ChoGGi.MenuFuncs.DeathToObjects("Building")
--~ ChoGGi.MenuFuncs.DeathToObjects("Drone")
--~ ChoGGi.MenuFuncs.DeathToObjects("SupplyRocket")
--~ ChoGGi.MenuFuncs.DeathToObjects("Unit") --rovers/drones/colonists

--show all elec consumption
--~ local objs = GetObjects{area = ""}
--~ local amount = 0
--~ for i = 1, #objs do
--~   local obj = objs[i]
--~   if obj.class and obj.electricity and obj.electricity.consumption then
--~     local temp = obj.electricity.consumption / 1000
--~     amount = amount + temp
--~     print(obj.class,": ",temp)
--~   end
--~ end
--~ print(amount)
