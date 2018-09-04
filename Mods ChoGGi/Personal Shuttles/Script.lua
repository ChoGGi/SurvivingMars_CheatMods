--keep everything stored in
PersonalShuttles = {
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
  id = "ChoGGi_PersonalShuttles",
  --orig funcs that we replace
  OrigFuncs = {},
  --CommonFunctions.lua
  ComFuncs = {},
  --OnMsgs.lua
  MsgFuncs = {},
  --/Code/_Functions.lua
  CodeFuncs = {},
  --InfoPaneCheats.lua
  InfoFuncs = {},
  --Defaults.lua
  SettingFuncs = {},
  --temporary settings that aren't saved to SettingsFile
  Temp = {
    --collect msgs to be displayed when game is loaded
    StartupMsgs = {},
  },
  UserSettings = {ShowShuttleControls=true},
}

-- if we use global func more then once: make them local for that small bit o' speed
local dofile,select,tostring,table = dofile,select,tostring,table

PersonalShuttles.ComFuncs.TableConcat = oldTableConcat or table.concat
local TConcat = PersonalShuttles.ComFuncs.TableConcat

--~ -- this is also used instead of string .. string; anytime you do that lua will hash the new string, and store it till exit
--~ -- which means this is faster, and uses less memory
--~ local concat_table = {}
--~ function PersonalShuttles.ComFuncs.Concat(...)
--~   -- i assume sm added a c func to clear tables, which does seem to be faster than a lua for loop
--~   table.iclear(concat_table)
--~   -- build table from args
--~   local concat_value
--~   local concat_type
--~   for i = 1, select("#",...) do
--~     concat_value = select(i,...)
--~     -- no sense in calling a func more then we need to
--~     concat_type = type(concat_value)
--~     if concat_type == "string" or concat_type == "number" then
--~       concat_table[i] = concat_value
--~     else
--~       concat_table[i] = tostring(concat_value)
--~     end
--~   end
--~   -- and done
--~   return TConcat(concat_table)
--~ end

local PersonalShuttles = PersonalShuttles
local Mods = Mods
PersonalShuttles._VERSION = Mods[PersonalShuttles.id].version
PersonalShuttles.ModPath = CurrentModPath

local Concat = PersonalShuttles.ComFuncs.Concat

dofile(Concat(PersonalShuttles.ModPath,"CommonFunctions.lua"))
dofile(Concat(PersonalShuttles.ModPath,"_Functions.lua"))
dofile(Concat(PersonalShuttles.ModPath,"OnMsgs.lua"))
dofile(Concat(PersonalShuttles.ModPath,"ShuttleControl.lua"))
