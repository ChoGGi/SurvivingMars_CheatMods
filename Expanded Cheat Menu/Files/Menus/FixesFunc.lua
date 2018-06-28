--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local DeleteObject = ChoGGi.ComFuncs.DeleteObject
local T = ChoGGi.ComFuncs.Trans

local pairs,pcall,type,tostring = pairs,pcall,type,tostring

local CreateRealTimeThread = CreateRealTimeThread
local DoneObject = DoneObject
local FindNearestObject = FindNearestObject
local ForEach = ForEach
local GenerateColonistData = GenerateColonistData
local GetObjects = GetObjects
local GetPassablePointNearby = GetPassablePointNearby
local GetStateIdx = GetStateIdx
local HexGetNearestCenter = HexGetNearestCenter
local IsValid = IsValid
local Msg = Msg
local point = point
local Sleep = Sleep

local g_Classes = g_Classes

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

local function ResetRover(rc)
  for i = 1, #rc.attached_drones do
    DoneObject(rc.attached_drones[i])
  end
  local pos = rc:GetVisualPos()
  local new = rc:Clone()
  DoneObject(rc)
  new:SetPos(HexGetNearestCenter(pos))
end
function ChoGGi.MenuFuncs.ResetRovers()
  CreateRealTimeThread(function()
    local before_table = {}

    --get all rovers stuck in deployStart with at least one drone
    ForEach({
      class = "RCRover",
      exec = function(rc)
        local drones = #rc.attached_drones > 0
--~         print("sdfsdfds",state,drones)
        if drones then
          if rc:GetState() == GetStateIdx("deployIdle") then
            --store them in a table for later
            before_table[rc.handle] = {rc = rc, amount = #rc.attached_drones}
          elseif rc:GetState() == GetStateIdx("idle") and rc.waiting_on_drones then
            ResetRover(rc)
          end
        end
      end
    })
    --wait awhile just to be sure
    Sleep(5000)
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
  g_Classes.Colonist:new(colonist)
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
        local objs = GetObjects({class = "Colonist"}) or empty_table
        for i = 1, #objs do
          local c = objs[i]
          SpawnColonist(c,something,c:GetVisualPos(),UICity)
          if type(c.Done) == "function" then
            c:Done()
          end
          DoneObject(c)
        end
      end
    end
    ChoGGi.ComFuncs.QuestionBox(
      Concat(T(6779--[[Warning--]]),"!\n",T(302535920000055--[[Reset All Colonists--]]),"\n",T(302535920000939--[[Fix certain freezing issues (mouse still moves screen, keyboard doesn't), will lower comfort by about 20.--]])),
      CallBackFunc,
      Concat(T(6779--[[Warning--]]),": ",T(302535920000055--[[Reset All Colonists--]]))
    )
end

local function AttachmentsCollisionToggle(sel,which)
  local att = sel:GetAttaches() or empty_table
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

function ChoGGi.MenuFuncs.CollisionsObject_Toggle()
  local sel = SelectedObj
  if not sel then
    MsgPopup(T(302535920000967--[[Nothing selected.--]]),T(302535920000968--[[Collisions--]]))
    return
  end

  local which
  if sel.ChoGGi_CollisionsDisabled then
    sel:SetEnumFlags(const.efCollision + const.efApplyToGrids)
    AttachmentsCollisionToggle(sel,false)
    sel.ChoGGi_CollisionsDisabled = nil
    which = "enabled"
  else
    sel:ClearEnumFlags(const.efCollision + const.efApplyToGrids)
    AttachmentsCollisionToggle(sel,true)
    sel.ChoGGi_CollisionsDisabled = true
    which = "disabled"
  end

  MsgPopup(Concat(T(302535920000968--[[Collisions--]])," ",which," ",T(302535920000969--[[on--]])," ",ChoGGi.ComFuncs.RetName(sel)),
    T(302535920000968--[[Collisions--]])
  )
end

function ChoGGi.MenuFuncs.ColonistsTryingToBoardRocketFreezesGame()
  local UICity = UICity
  local objs = GetObjects({class = "Colonist"}) or empty_table
  for i = 1, #objs do
    local c = objs[i]
    if c:GetStateText() == "movePlanet" then
      local rocket = FindNearestObject(GetObjects({class="SupplyRocket"}),c)
      SpawnColonist(c,rocket,c:GetVisualPos(),UICity)
      if type(c.Done) == "function" then
        c:Done()
      end
      DoneObject(c)
    end
  end
end

function ChoGGi.MenuFuncs.ColonistsStuckOutsideRocket()
  local rockets = GetObjects({class="SupplyRocket"})
  local pos
  for i = 1, #rockets do
    pos = rockets[i]:GetPos()
    local Attaches = type(rockets[i].GetAttaches) == "function" and rockets[i]:GetAttaches("Colonist") or empty_table
    --Attaches = ChoGGi.ComFuncs.FilterFromTable(Attaches,nil,{Colonist=true},"class")
    if #Attaches > 0 then
      for j = #Attaches, 1, -1 do
        local c = Attaches[j]
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
        DoneObject(c)
      end
    end
  end

end

function ChoGGi.MenuFuncs.ParticlesWithNullPolylines()
  local objs = GetObjects({class = "ParSystem"}) or empty_table
  for i = 1, #objs do
    if type(objs[i].polyline) == "string" and objs[i].polyline:find("\0") then
      objs[i]:delete()
    end
  end
end

function ChoGGi.MenuFuncs.RemoveMissingClassObjects()
  ForEach({
    class = "UnpersistedMissingClass",
    exec = function(obj)
      DeleteObject(obj)
    end
  })
end

function ChoGGi.MenuFuncs.MirrorSphereStuck()
  local ChoGGi = ChoGGi
  local objs = GetObjects({class = "MirrorSphere"}) or empty_table
  for i = 1, #objs do
    if not IsValid(objs[i].target) then
      DeleteObject(objs[i])
    end
  end
  objs = GetObjects({class = "ParSystem"}) or empty_table
  for i = 1, #objs do
    if objs[i]:GetProperty("ParticlesName") == "PowerDecoy_Captured" and
        type(objs[i].polyline) == "string" and objs[i].polyline:find("\0") then
      objs[i]:delete()
    end
  end
end

function ChoGGi.MenuFuncs.StutterWithHighFPS()
  local objs = GetObjects({class = "Unit"}) or empty_table
  --CargoShuttle
  for i = 1, #objs do
    -- 102 is from :GetMoveAnim(), 0 is stopped or idle?
    if objs[i]:GetAnim() > 0 and objs[i]:GetPathLen() == 0 then
      --trying to move with no path = lag
      objs[i]:InterruptCommand()
    end
  end

  objs = UICity.labels.Colonist or empty_table
  for i = 1, #objs do
    --only need to do people walking outside (pathing issue), and if they don't have a path (not moving or walking into an invis wall)
    if objs[i]:IsValidPos() and not objs[i]:GetPath() then
      --too close and they keep doing the human centipede
      local x,y,_ = objs[i]:GetVisualPosXYZ()
      objs[i]:SetCommand("Goto", GetPassablePointNearby(point(x+5000,y+5000)))
    end
  end

end

function ChoGGi.MenuFuncs.DronesKeepTryingBlockedAreas()
  local ChoGGi = ChoGGi
  local function ResetPriorityQueue(Class)
    local Hubs = GetObjects({class=Class}) or empty_table
    for i = 1, #Hubs do
      --clears out the queues
      Hubs[i].priority_queue = {}
      for priority = -1, const.MaxBuildingPriority do
        Hubs[i].priority_queue[priority] = {}
      end
    end
  end
  ResetPriorityQueue("SupplyRocket")
  ResetPriorityQueue("RCRover")
  ResetPriorityQueue("DroneHub")
  --toggle working state on all ConstructionSite (wakes up drones else they'll wait at hub)
  local Sites = GetObjects({class="ConstructionSite"}) or empty_table
  for i = 1, #Sites do
    ChoGGi.CodeFuncs.ToggleWorking(Sites[i])
  end
end

function ChoGGi.MenuFuncs.AlignAllBuildingsToHexGrid()
  local Table = GetObjects({class="Building"})
  if Table[1] and Table[1].class then
    for i = 1, #Table do
      Table[i]:SetPos(HexGetNearestCenter(Table[i]:GetPos()))
    end
  end
end

function ChoGGi.MenuFuncs.RemoveUnreachableConstructionSites()
  local Table
  local function RemoveUnreachable(Class)
    Table = GetObjects({class=Class}) or empty_table
    for i = 1, #Table do
      for Bld,_ in pairs(Table[i].unreachable_buildings or empty_table) do
        if Bld:IsKindOf("ConstructionSite") then
          Bld:Cancel()
        end
      end
      Table[i].unreachable_buildings = empty_table
    end
  end

  Table = GetObjects({class="Drone"}) or empty_table
  for i = 1, #Table do
    Table[i]:CleanUnreachables()
  end
  RemoveUnreachable("DroneHub")
  RemoveUnreachable("RCRover")
  RemoveUnreachable("SupplyRocket")
  MsgPopup(T(302535920000970--[[Removed unreachable--]]),T(302535920000971--[[Sites--]]))
end

function ChoGGi.MenuFuncs.RemoveYellowGridMarks()
	ForEach({
		class = "GridTile",
		exec = function(obj)
      DoneObject(obj)
		end
	})
end

function ChoGGi.MenuFuncs.RemoveBlueGridMarks()
	ForEach({
		class = "RangeHexRadius",
		exec = function(obj)
      DoneObject(obj)
		end
	})
end

function ChoGGi.MenuFuncs.ProjectMorpheusRadarFellDown()
  local tab = UICity.labels.ProjectMorpheus or empty_table
  for i = 1, #tab do
    tab[i]:ChangeWorkingStateAnim(false)
    tab[i]:ChangeWorkingStateAnim(true)
  end
end

function ChoGGi.MenuFuncs.RebuildWalkablePointsInDomes()
	ForEach({
		class = "Dome",
		exec = function(d)
      d.walkable_points = false
      d:GenerateWalkablePoints()
		end
	})
end

function ChoGGi.MenuFuncs.AttachBuildingsToNearestWorkingDome()
  local ChoGGi = ChoGGi
  local Table = UICity.labels.InsideBuildings or empty_table
  for i = 1, #Table do
    ChoGGi.CodeFuncs.AttachToNearestDome(Table[i])
  end

  MsgPopup(T(302535920000972--[[Buildings attached.--]]),
    T(3980--[[Buildings--]]),"UI/Icons/Sections/basic.tga"
  )
end

function ChoGGi.MenuFuncs.ColonistsFixBlackCube()
  local tab = UICity.labels.Colonist or empty_table
  for i = 1, #tab do
    local colonist = tab[i]
    if colonist.entity:find("Child",1,true) then
      colonist.specialist = "none"

      colonist.traits.Youth = nil
      colonist.traits.Adult = nil
      colonist.traits["Middle Aged"] = nil
      colonist.traits.Senior = nil
      colonist.traits.Retiree = nil

      colonist.traits.Child = true
      colonist.age_trait = "Child"
      colonist.age = 0
      colonist:ChooseEntity()
      colonist:SetResidence(false)
      colonist:UpdateResidence()
    end
  end
end

function ChoGGi.MenuFuncs.RepairBrokenShit(BrokenShit)
  local JustInCase = 0
  while #BrokenShit > 0 do

    for i = 1, #BrokenShit do
      pcall(function()
        BrokenShit[i]:Repair()
      end)
    end

    if JustInCase == 10000 then
      break
    end
    JustInCase = JustInCase + 1

  end
end

function ChoGGi.MenuFuncs.CablesAndPipesRepair()
  local ChoGGi = ChoGGi
  local g_BrokenSupplyGridElements = g_BrokenSupplyGridElements
  ChoGGi.MenuFuncs.RepairBrokenShit(g_BrokenSupplyGridElements.electricity)
  ChoGGi.MenuFuncs.RepairBrokenShit(g_BrokenSupplyGridElements.water)
end

------------------------- toggles
--[[
fixed in curiosity

function ChoGGi.MenuFuncs.NoRestingBonusPsychologistFix_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.NoRestingBonusPsychologistFix = not ChoGGi.UserSettings.NoRestingBonusPsychologistFix

  local commander_profile = GetCommanderProfile()
  if ChoGGi.UserSettings.NoRestingBonusPsychologistFix then
    if commander_profile.id == "psychologist" then
      commander_profile.param1 = 5
    end
  else --don't know why you'd want to disable the bonus
    if commander_profile.id == "psychologist" then
      commander_profile.param1 = 0
    end
  end

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(Concat("No resting bonus psychologist: ",tostring(UserSettings.NoRestingBonusPsychologistFix)),
    "Psychologist"
  )
end
--]]

function ChoGGi.MenuFuncs.DroneChargesFromRoverWrongAngle_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.DroneChargesFromRoverWrongAngle = not ChoGGi.UserSettings.DroneChargesFromRoverWrongAngle
  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(Concat(T(302535920001040--[[Drone Wrong Angle--]]),": ",tostring(ChoGGi.UserSettings.DroneChargesFromRoverWrongAngle)),
    T(5438--[[Rovers--]])
  )
end

function ChoGGi.MenuFuncs.DroneResourceCarryAmountFix_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.DroneResourceCarryAmountFix = not ChoGGi.UserSettings.DroneResourceCarryAmountFix
  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(Concat(T(302535920000965--[[Drone Carry Fix--]]),": ",tostring(ChoGGi.UserSettings.DroneResourceCarryAmountFix)),
    T(517--[[Drones--]]),"UI/Icons/IPButtons/drone.tga"
  )
end

function ChoGGi.MenuFuncs.SortCommandCenterDist_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.SortCommandCenterDist = not ChoGGi.UserSettings.SortCommandCenterDist
  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(Concat(T(302535920000966--[[Sorting cc dist--]]),": ",tostring(ChoGGi.UserSettings.SortCommandCenterDist)),
    T(3980--[[Buildings--]])
  )
end

---------------------------------------------------Testers

--~ DupePos(GetObjects({class = "Colonist"}))
function ChoGGi.MenuFuncs.DupePos(list)
  local dupes = {}
  local positions = {}
  local pos
  for i = 1, #list do
    pos = list[i]:GetPos()
    pos = tostring(point(pos:x(),pos:y()))
    if not positions[pos] then
      positions[pos] = true
    else
      dupes[pos] = true
    end
  end
  if #dupes > 0 then
    table.sort(dupes)
    OpenExamine(dupes)
  end
end

function ChoGGi.MenuFuncs.DeathToObjects(classname)
  local objs = GetObjects({class = classname}) or empty_table
  print(#objs," = ",classname)
  for i = 1, #objs do
    DoneObject(objs[i])
  end
end

--~ ChoGGi.MenuFuncs.DeathToObjects("BaseRover")
--~ ChoGGi.MenuFuncs.DeathToObjects("Colonist")
--~ ChoGGi.MenuFuncs.DeathToObjects("CargoShuttle")
--~ ChoGGi.MenuFuncs.DeathToObjects("Building")
--~ ChoGGi.MenuFuncs.DeathToObjects("Drone")
--~ ChoGGi.MenuFuncs.DeathToObjects("SupplyRocket")
--~ ChoGGi.MenuFuncs.DeathToObjects("Unit") --rovers/drones/colonists

--show all elec consumption
--~ local objs = GetObjects({}) or empty_table
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
