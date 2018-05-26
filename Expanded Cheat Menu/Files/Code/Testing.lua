--See LICENSE for terms

local SaveOrigFunc = ChoGGi.ComFuncs.SaveOrigFunc
--stuff only loaded when ChoGGi.Temp.Testing = true

--ChoGGi.Temp.Testing = false
--stuff that never happens, fuck comments (like this one)
if type(ChoGGi.Temp.Testing) == "function" then

OpenExamine(ChoGGi.CodeFuncs.ReturnAllNearby(1000))
ChoGGi.CurObj:SetPos(GetTerrainCursor())

local Attaches = s.GetAttaches and s:GetAttaches() or empty_table
for i = #Attaches, 1, -1 do
  local Colonist = Attaches[i]
  if Colonist.class == "Colonist" then
  print(111)
    Attaches[i]:Detach()
    Attaches[i]:SetState("idle")
    Attaches[i].city:AddToLabel("Arrivals", Attaches[i])
    Attaches[i].arriving = nil
    Attaches[i]:OnArrival()

    --Attaches[i]:Arrive()
  end
end


function ChoGGi.ReplaceDome(dome)
  if not dome then
    return
  end
  local olddome = empty_table
  for Key,Value in pairs(dome) do
    olddome[Key] = Value
  end
  local pos = dome:GetPos()
  dome:delete()

  local newdome = PlaceObj('GeoscapeDome', {
    'template_name', "GeoscapeDome",
    'Pos', pos,
  })
  for Key,Value in pairs(olddome) do
    if Key ~= "entity" and Key ~= "dome_enterances" and Key ~= "encyclopedia_id" and Key ~= "my_interior" and Key ~= "waypoint_chains" and Key ~= "handle" then
      newdome[Key] = Value
    end
  end
  newdome:Init()
  newdome:GameInit()
  newdome:InitResourceSpots()
  newdome:InitPassageTables()

  newdome:Rebuild()
  newdome:ApplyToGrids()
  newdome:AddOutskirtBuildings()
  newdome:GenerateWalkablePoints()
  newdome:InitAttaches()
end

local Table1 = GetObjects({class="Destlock"})
for i = 1, #Table1 do

local wp = PlaceObject("WayPoint")
wp:SetPos(Table[i]:GetPos())

end

local Table2 = GetObjects({class="ParSystem"})
for i = 1, #Table2 do
  Table2[i]:delete()
end



  dofolder_files("CommonLua/UI/UIDesignerData")
--[[
  ChoGGi.ComFuncs.SaveOrigFunc("CargoShuttle","Idle")
  function CargoShuttle:Idle()
  print(self.command)
    if self.ChoGGi_FollowMouseShuttle and self.command == "Home" or self.command == "Idle" then
      self:SetCommand("ChoGGi_FollowMouse")
    end
    return ChoGGi.OrigFuncs.CargoShuttle_Idle(self)
  end
--]]
  for message, threads in pairs(ThreadsMessageToThreads) do
    --print(message)
    --print(threads)
    if message.action and message.action.class == "SA_WaitMsg" then
    print(message.ip)
    end
  end
  for thread in pairs(ThreadsRegister) do
    print(thread)
  end
end

if ChoGGi.Temp.Testing then
  config.TraceEnable = true
  Platform.editor = true
  config.LuaDebugger = true
  GlobalVar("outputSocket", false)
  dofile("CommonLua/Core/luasocket.lua")
  dofile("CommonLua/Core/luadebugger.lua")
  dofile("CommonLua/Core/luaDebuggerOutput.lua")
  dofile("CommonLua/Core/ProjectSync.lua")

  info = debug.getinfo

  --tell me if traits are different
  local StartupMsgs = ChoGGi.Temp.StartupMsgs
  local const = const
  local textstart = "<color 255 0 0>"
  local textend = " is different length</color>"
  if #const.SchoolTraits ~= 5 then
    StartupMsgs[#StartupMsgs+1] = textstart .. "SchoolTraits" .. textend
  end
  if #const.SanatoriumTraits ~= 7 then
    StartupMsgs[#StartupMsgs+1] = textstart .. "SanatoriumTraits" .. textend
  end
  local fulllist = TraitsCombo()
  if #fulllist ~= 55 then
    StartupMsgs[#StartupMsgs+1] = textstart .. "TraitsCombo" .. textend
  end

---------
  print("if ChoGGi.Temp.Testing")
end --Testing

function ChoGGi.MsgFuncs.Testing_ClassesGenerate()

  ------
  print("Testing_ClassesGenerate")
end

function ChoGGi.MsgFuncs.Testing_ClassesPreprocess()
  --fix the arcology dome spot
  SaveOrigFunc("SpireBase","GameInit")
  function SpireBase:GameInit()
    local dome = IsObjInDome(self)
    if self.spire_frame_entity ~= "none" and IsValidEntity(self.spire_frame_entity) then
      local frame = PlaceObject("Shapeshifter")
      frame:ChangeEntity(self.spire_frame_entity)
      local spot = dome:GetNearestSpot("idle", "Spireframe", self)

      --local pos = dome:GetSpotPos(spot)
      local pos = self:GetSpotPos(spot or 1)

      frame:SetAttachOffset(pos - self:GetPos())
      self:Attach(frame, self:GetSpotBeginIndex("Origin"))
    end
  end
  ------
  print("Testing_ClassesPreprocess")
end --ClassesPreprocess

--where we add new BuildingTemplates
function ChoGGi.MsgFuncs.Testing_ClassesPostprocess()
  ------
  print("Testing_ClassesPostprocess")
end

function ChoGGi.MsgFuncs.Testing_ClassesBuilt()

  SaveOrigFunc("PinsDlg","GetPinConditionImage")
  function PinsDlg:GetPinConditionImage(obj)
    local ret = ChoGGi.OrigFuncs.PinsDlg_GetPinConditionImage(self,obj)
    if obj.command == "Dead" and not obj.working then
      print(obj.class)
      return "UI/Icons/pin_not_working.tga"
    else
      return ret
    end
  end

  --stops confirmation dialog about missing mods (still lets you know they're missing)
  function GetMissingMods()
    return "", false
  end

  ------
  print("Testing_ClassesBuilt")
end

function ChoGGi.MsgFuncs.Testing_LoadingScreenPreClose()

  ------
  print("Testing_LoadingScreenPreClose")
end
