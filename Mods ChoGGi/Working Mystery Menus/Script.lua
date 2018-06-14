-- hello
WorkingMysteryMenus = {
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
  id = "ChoGGi_WorkingMysteryMenus",
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
}

-- if we use global func more then once: make them local for that small bit o' speed
local select,tostring,table = select,tostring,table
-- thanks for replacing concat...
WorkingMysteryMenus.ComFuncs.TableConcat = oldTableConcat or table.concat
local TConcat = WorkingMysteryMenus.ComFuncs.TableConcat

-- SM has a tendency to inf loop when you return a non-string value that they want to table.concat
-- so now if i accidentally return say a menu item with a function for a name, it'll just look ugly instead of freezing (cursor moves screen wasd doesn't)

-- this is also used instead of string .. string; anytime you do that lua will hash the new string, and store it till exit
-- which means this is faster, and uses less memory
local concat_table = {}
local concat_value
function WorkingMysteryMenus.ComFuncs.Concat(...)
  -- reuse old table if it's not that big, else it's quicker to make new one
  if #concat_table > 1000 then
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

local WorkingMysteryMenus = WorkingMysteryMenus
local Mods = Mods
WorkingMysteryMenus._VERSION = Mods[WorkingMysteryMenus.id].version
WorkingMysteryMenus.ModPath = Mods[WorkingMysteryMenus.id].path
local Concat = WorkingMysteryMenus.ComFuncs.Concat
local FileExists = WorkingMysteryMenus.ComFuncs.FileExists

-- load locale translation (if any, not likely with the amount of text, but maybe a partial one)
local locale_file = Concat(WorkingMysteryMenus.ModPath,"Locales/",GetLanguage(),".csv")
if FileExists(locale_file) then
  LoadTranslationTableFile(locale_file)
else
  LoadTranslationTableFile(Concat(WorkingMysteryMenus.ModPath,"Locales/","English.csv"))
end
Msg("TranslationChanged")

local _InternalTranslate = _InternalTranslate
local UserActions_SetMode = UserActions.SetMode
local T = T

-- change some annoying stuff about UserActions.AddActions()
local g_idxAction = 0
function WorkingMysteryMenus.ComFuncs.UserAddActions(ActionsToAdd)
if WorkingMysteryMenus.Temp.Testing then
  if type(ActionsToAdd) == "string" then
    print("ActionsToAdd",ActionsToAdd)
  end
end
  for k, v in pairs(ActionsToAdd) do
    if type(v.action) == "function" and (v.key ~= nil and v.key ~= "" or v.xinput ~= nil and v.xinput ~= "" or v.menu ~= nil and v.menu ~= "" or v.toolbar ~= nil and v.toolbar ~= "") then
      if v.key ~= nil and v.key ~= "" then
        if type(v.key) == "table" then
          local keys = v.key
          if #keys <= 0 then
            v.description = ""
          else
            v.description = Concat(v.description," (",keys[1])
            for i = 2, #keys do
              v.description = Concat(v.description," or ",keys[i])
            end
            v.description = Concat(v.description,")")
          end
        else
          v.description = Concat(tostring(v.description)," (",v.key,")")
        end
      end
      v.id = k
      v.idx = g_idxAction
      g_idxAction = g_idxAction + 1
      UserActions.Actions[k] = v
    else
      UserActions.RejectedActions[k] = v
    end
  end
  UserActions_SetMode(UserActions.mode)
end

function WorkingMysteryMenus.ComFuncs.AddAction(Menu,Action,Key,Des,Icon,Toolbar,Mode,xInput,ToolbarDefault)
  local WorkingMysteryMenus = WorkingMysteryMenus
  if Menu then
    Menu = Concat("/",tostring(Menu))
  end
  local name = "NOFUNC"
  --add name to action id
  if Action then
    local debug_info = debug.getinfo(Action, "Sn")
    local text = tostring(Concat(debug_info.short_src,"(",debug_info.linedefined,")"))
    name = text:gsub(WorkingMysteryMenus.ModPath,"")
    name = name:gsub(WorkingMysteryMenus.ModPath:gsub("AppData","...ata"),"")
    name = name:gsub(WorkingMysteryMenus.ModPath:gsub("AppData","...a"),"")
    --
  end

  --UserActions.AddActions({
  --UserActions.RejectedActions()
  WorkingMysteryMenus.ComFuncs.UserAddActions({
    [Concat("ChoGGi_",name,"-",AsyncRand())] = {
      menu = Menu,
      action = Action,
      key = Key,
      description = Des or "", --errors if not a string
      icon = Icon,
      toolbar = Toolbar,
      mode = Mode,
      xinput = xInput,
      toolbar_default = ToolbarDefault
    }
  })
end

WorkingMysteryMenus.ComFuncs.AddAction(nil,UAMenu.ToggleOpen,"F2")

local function CheatStartMystery(mystery_id)
  local UICity = UICity
  local Presets = Presets

  UICity.mystery_id = mystery_id
  local fields = Presets.TechFieldPreset.Default
  for i = 1, #fields do
    local field = fields[i]
    local field_id = field.id
--~     local costs = field.costs or empty_table
    local list = UICity.tech_field[field_id] or empty_table
    UICity.tech_field[field_id] = list
--~     for _, tech in ipairs(Presets.TechPreset[field_id]) do
    local ids = Presets.TechPreset[field_id] or empty_table
    for j = 1, #ids do
      if ids[j].mystery == mystery_id then
        local tech_id = ids[j].id
        list[#list + 1] = tech_id
        UICity.tech_status[tech_id] = {points = 0, field = field_id}
        ids[j]:EffectsInit(UICity)
      end
    end
  end
  UICity:InitMystery()

  --might help
  if UICity.mystery then
    UICity.mystery_id = UICity.mystery.class
    UICity.mystery:ApplyMysteryResourceProperties()
  end

  --instant start
  if instant then
    local seqs = UICity.mystery.seq_player.seq_list[1]
    for i = 1, #seqs do
      local seq = seqs[i]
      if seq.class == "SA_WaitExpression" then
        seq.duration = 0
        seq.expression = nil
      elseif seq.class == "SA_WaitMarsTime" then
        seq.duration = 0
        seq.rand_duration = 0
        break
      end
    end
  end

  --needed to start mystery
  UICity.mystery.seq_player:AutostartSequences()
end

function WorkingMysteryMenus.StartMystery(Mystery)
  --inform people of actions, so they don't add a bunch of them
  UICity.mystery_id = Mystery
  CheatStartMystery(Mystery)
end

--if you pick a mystery from the cheat menu
function OnMsg.MysteryBegin()
  WorkingMysteryMenus.MsgPopup("You've started a mystery!","Mystery","UI/Icons/Logos/logo_13.tga")
end
function OnMsg.MysteryChosen()
  WorkingMysteryMenus.MsgPopup("You've chosen a mystery!","Mystery","UI/Icons/Logos/logo_13.tga")
end
function OnMsg.MysteryEnd(Outcome)
  WorkingMysteryMenus.MsgPopup(Outcome,"Mystery","UI/Icons/Logos/logo_13.tga")
end

--for mystery menu items
WorkingMysteryMenus.MysteryDescription = {BlackCubeMystery = 1165,DiggersMystery = 1171,MirrorSphereMystery = 1185,DreamMystery = 1181,AIUprisingMystery = 1163,MarsgateMystery = 7306,WorldWar3 = 8073,TheMarsBug = 8068,UnitedEarthMystery = 8071}
WorkingMysteryMenus.MysteryDifficulty = {BlackCubeMystery = 1164,DiggersMystery = 1170,MirrorSphereMystery = 1184,DreamMystery = 1180,AIUprisingMystery = 1162,MarsgateMystery = 8063,WorldWar3 = 8072,TheMarsBug = 8067,UnitedEarthMystery = 8070}

function OnMsg.ClassesBuilt()

  --build "Cheats/Start Mystery" menu
  ClassDescendantsList("MysteryBase", function(class)
    WorkingMysteryMenus.AddAction(
      "Cheats/[05]Start Mystery/" .. g_Classes[class].scenario_name .. " " .. _InternalTranslate(T({WorkingMysteryMenus.MysteryDifficulty[class]})) or "Missing Name",
      function()
        return WorkingMysteryMenus.StartMystery(class)
      end,
      nil,
      _InternalTranslate(T({WorkingMysteryMenus.MysteryDescription[class]})) or "Missing Description",
      "DarkSideOfTheMoon.tga"
    )
  end)

  --instant start
  local maytake = "Starts mystery instantly (may take up to 1 sol)."
  ClassDescendantsList("MysteryBase", function(class)
    WorkingMysteryMenus.AddAction(
      "Cheats/[05]Start Mystery/" .. g_Classes[class].scenario_name .. " " .. _InternalTranslate(T({WorkingMysteryMenus.MysteryDifficulty[class]})) .. ": Instant" or "Missing Name: Instant",
      function()
        return WorkingMysteryMenus.StartMystery(class,true)
      end,
      nil,
      _InternalTranslate(T({WorkingMysteryMenus.MysteryDescription[class]})) .. "\n\n" .. maytake or "Missing Description: " .. maytake,
      "SelectionToTemplates.tga"
    )
  end)

end --OnMsg

local function SomeCode()
  local UserActions = UserActions
  --remove broken menu items
  UserActions.RemoveActions({
    "StartMysteryAIUprisingMystery",
    "StartMysteryBlackCubeMystery",
    "StartMysteryDiggersMystery",
    "StartMysteryDreamMystery",
    "StartMysteryMarsgateMystery",
    "StartMysteryMirrorSphereMystery",
    "StartMysteryTheMarsBug",
    "StartMysteryUnitedEarthMystery",
    "StartMysteryWorldWar3",
  })
  --update menu
  UAMenu.UpdateUAMenu(UserActions.GetActiveActions())

end

function OnMsg.CityStart()
  SomeCode()
end

function OnMsg.LoadGame()
  SomeCode()
end

-- shows a popup msg with the rest of the notifications
function WorkingMysteryMenus.MsgPopup(Msg,Title,Icon)
  Icon = type(tostring(Icon):find(".tga")) == "number" and Icon or ""
  --eh, it needs something for the id, so I can fiddle with it later
  local id = AsyncRand()
  --build our popup
  local timeout = 10000

  local params = {
    expiration=timeout, --{expiration=99999999999999999}
    --dismissable=false,
  }
  local cycle_objs = params.cycle_objs
  local dlg = GetXDialog("OnScreenNotificationsDlg")
  if not dlg then
    if not GetInGameInterface() then
      return
    end
    dlg = OpenXDialog("OnScreenNotificationsDlg", GetInGameInterface())
  end
  local data = {
    id = id,
    --name = id,
    title = tostring(Title or ""),
    text = tostring(Msg or T({3718,"NONE"})),
    image = Icon
  }
  table.set_defaults(data, params)
  table.set_defaults(data, OnScreenNotificationPreset)

  CreateRealTimeThread(function()
		local popup = g_Classes.OnScreenNotification:new({}, dlg.idNotifications)
		popup:FillData(data, nil, params, cycle_objs)
		popup:Open()
		dlg:ResolveRelativeFocusOrder()
  end)
end
