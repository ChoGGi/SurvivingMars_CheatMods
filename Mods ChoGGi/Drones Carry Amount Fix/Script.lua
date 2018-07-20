-- hello
DronesCarryAmountFix = {
  _LICENSE = [[Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

All of my code is licensed under the MIT License as follows:

MIT License

Copyright (c) [2018] [ChoGGi]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.]],
  email = "SM_Mods@choggi.org",
  id = "ChoGGi_DronesCarryAmountFix",
  -- orig funcs that we replace
  OrigFuncs = {},
  -- CommonFunctions.lua
  ComFuncs = {
    FileExists = function(name)
      local _,test = AsyncFileOpen(name)
      return test
    end,
  },
  -- /Code/_Functions.lua
  CodeFuncs = {},
  -- /Code/*Menu.lua and /Code/*Func.lua
  MenuFuncs = {},
  -- OnMsgs.lua
  MsgFuncs = {},
  -- InfoPaneCheats.lua
  InfoFuncs = {},
  -- Defaults.lua
  SettingFuncs = {},
  -- temporary settings that aren't saved to SettingsFile
  Temp = {
    -- collect msgs to be displayed when game is loaded
    StartupMsgs = {},
  },
  -- settings that are saved to SettingsFile
  UserSettings = {
    BuildingSettings = {},
    Transparency = {},
  },
  Consts = {
    ResourceScale = 1000,
  },
}

-- if we use global func more then once: make them local for that small bit o' speed
local dofile,select,tostring,table = dofile,select,tostring,table
-- thanks for replacing concat...
DronesCarryAmountFix.ComFuncs.TableConcat = oldTableConcat or table.concat
local TConcat = DronesCarryAmountFix.ComFuncs.TableConcat

local AsyncFileOpen = AsyncFileOpen
local dofolder_files = dofolder_files

local g_Classes = g_Classes

-- SM has a tendency to inf loop when you return a non-string value that they want to table.concat
-- so now if i accidentally return say a menu item with a function for a name, it'll just look ugly instead of freezing (cursor moves screen wasd doesn't)

-- this is also used instead of string .. string; anytime you do that lua will hash the new string, and store it till exit
-- which means this is faster, and uses less memory
local concat_table = {}
local concat_value
function DronesCarryAmountFix.ComFuncs.Concat(...)
  -- reuse old table if it's not that big, else it's quicker to make new one
  if #concat_table > 500 then
    concat_table = {}
  else
    table.iclear(concat_table) -- i assume sm added a c func to clear tables, which does seem to be faster than a lua for loop
  end
  -- build table from args
  for i = 1, select("#",...) do
    concat_value = select(i,...)
      if type(concat_value) == "string" or type(concat_value) == "number" then
      concat_table[i] = concat_value
    else
      concat_table[i] = tostring(concat_value)
    end
  end
  -- and done
  return TConcat(concat_table)
end

local DronesCarryAmountFix = DronesCarryAmountFix
local Mods = Mods
DronesCarryAmountFix._VERSION = Mods[DronesCarryAmountFix.id].version
DronesCarryAmountFix.ModPath = Mods[DronesCarryAmountFix.id].path
local Concat = DronesCarryAmountFix.ComFuncs.Concat
local FileExists = DronesCarryAmountFix.ComFuncs.FileExists


function DronesCarryAmountFix.ComFuncs.CompareTableFuncs(a,b,sFunc,Obj)
  if not a and not b then
    return
  end
  if Obj then
    return Obj[sFunc](Obj,a) < Obj[sFunc](Obj,b)
  else
    return a[sFunc](a,b) < b[sFunc](b,a)
  end
end

-- backup orginal function for later use (checks if we already have a backup, or else problems)
function DronesCarryAmountFix.ComFuncs.SaveOrigFunc(ClassOrFunc,Func)
  local DronesCarryAmountFix = DronesCarryAmountFix
  if Func then
    local newname = Concat(ClassOrFunc,"_",Func)
    if not DronesCarryAmountFix.OrigFuncs[newname] then
--~       DronesCarryAmountFix.OrigFuncs[newname] = _G[ClassOrFunc][Func]
      DronesCarryAmountFix.OrigFuncs[newname] = g_Classes[ClassOrFunc][Func]
    end
  else
    if not DronesCarryAmountFix.OrigFuncs[ClassOrFunc] then
      DronesCarryAmountFix.OrigFuncs[ClassOrFunc] = _G[ClassOrFunc]
    end
  end
end

--force drones to pickup from object even if they have a large carry cap
function DronesCarryAmountFix.CodeFuncs.FuckingDrones(Obj)
  local DronesCarryAmountFix = DronesCarryAmountFix
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
    local drone = DronesCarryAmountFix.CodeFuncs.GetNearestIdleDrone(p)
    if not drone then
      return
    end

    local carry = g_Consts.DroneResourceCarryAmount * DronesCarryAmountFix.Consts.ResourceScale
    --round to nearest 1000 (don't want uneven stacks)
    stored = (stored - stored % DronesCarryAmountFix.Consts.ResourceScale) / DronesCarryAmountFix.Consts.ResourceScale * DronesCarryAmountFix.Consts.ResourceScale
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

function DronesCarryAmountFix.CodeFuncs.GetNearestIdleDrone(Bld)
  local DronesCarryAmountFix = DronesCarryAmountFix
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
        return DronesCarryAmountFix.ComFuncs.CompareTableFuncs(a,b,"GetDist2D",Bld.command_centers)
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

function OnMsg.ClassesBuilt()
  DronesCarryAmountFix.ComFuncs.SaveOrigFunc("SingleResourceProducer","Produce")
  local DronesCarryAmountFix_OrigFuncs = DronesCarryAmountFix.OrigFuncs

  function g_Classes.SingleResourceProducer:Produce(amount_to_produce)

    --get them lazy drones working (bugfix for drones ignoring amounts less then their carry amount)
    if DronesCarryAmountFix.UserSettings.DroneResourceCarryAmountFix then
      DronesCarryAmountFix.CodeFuncs.FuckingDrones(self)
    end

    return DronesCarryAmountFix_OrigFuncs.SingleResourceProducer_Produce(self, amount_to_produce)
  end

end

function OnMsg.NewHour()

  local DronesCarryAmountFix = DronesCarryAmountFix
  local UICity = UICity
  local empty_table = empty_table

  --Hey. Do I preach at you when you're lying stoned in the gutter? No!
  local Table = UICity.labels.ResourceProducer or empty_table
  for i = 1, #Table do
    DronesCarryAmountFix.CodeFuncs.FuckingDrones(Table[i]:GetProducerObj())
    if Table[i].wasterock_producer then
      DronesCarryAmountFix.CodeFuncs.FuckingDrones(Table[i].wasterock_producer)
    end
  end
  Table = UICity.labels.BlackCubeStockpiles or empty_table
  for i = 1, #Table do
    DronesCarryAmountFix.CodeFuncs.FuckingDrones(Table[i])
  end

end
