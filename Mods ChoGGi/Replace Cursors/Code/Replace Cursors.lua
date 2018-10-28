-- See LICENSE for terms

local LICENSE = [[Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

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
SOFTWARE.]]

-- if we use global func more then once: make them local for that small bit o' speed
local select,tostring,type,pcall,table = select,tostring,type,pcall,table
local Mods = Mods

-- thanks for replacing concat... what's wrong with using table.concat2?
local TableConcat = rawget(_G, "oldTableConcat") or table.concat

-- SM has a tendency to inf loop when you return a non-string value that they want to table.concat
-- so now if i accidentally return say a menu item with a function for a name, it'll just look ugly instead of freezing (cursor moves screen wasd doesn't)
-- this is also used instead of "str .. str"; anytime you do that lua will hash the new string, and store it till exit (which means this is faster, and uses less memory)
local concat_table = {}
local function Concat(...)
  -- i assume sm added a c func to clear tables, which does seem to be faster than a lua for loop
  table.iclear(concat_table)
  -- build table from args
  local concat_value
  local concat_type
  for i = 1, select("#",...) do
    concat_value = select(i,...)
    -- no sense in calling a func more then we need to
    concat_type = type(concat_value)
    if concat_type == "string" or concat_type == "number" then
      concat_table[i] = concat_value
    else
      concat_table[i] = tostring(concat_value)
    end
  end
  -- and done
  return TableConcat(concat_table)
end

-- Everything stored in one global table
ReplaceCursors = {
  _LICENSE = LICENSE,
  email = "SM_Mods@choggi.org",
  id = "ChoGGi_ReplaceCursors",
  _VERSION = Mods.ChoGGi_ReplaceCursors.version,
  ModPath = CurrentModPath,
  -- CommonFunctions.lua
  ComFuncs = {
    TableConcat = TableConcat,
    Concat = Concat,
  },
}

--~ local cursors
--~ if ReplaceCursors.ComFuncs.FileExists("AppData/Cursors") then
--~   cursors = "AppData/Cursors/"
--~ else
--~   cursors = Concat(CurrentModPath,"Cursors/")
--~ end
local cursors = Concat(CurrentModPath,"Cursors/")

-- for some reason this doesn't work for everything... (caching I suppose)
--~ Unmount("UI")

-- sigh... thanks devs
--~ MountFolder("UI/Cursors",cursors)


--~ AsyncMountPack("UI", "Packs/UI.hpk")

--~ UIL.ReloadImage("UI/Cursors/cursor.tga")
--~ UIL.ReloadImage("UI/Cursors/Rollover.tga")

-- for some reason the default cursor doesn't get replaced with the above, so we do this crap
local cursor = Concat(cursors,"cursor.tga")
local rollover = Concat(cursors,"Rollover.tga")
local loading = Concat(cursors,"Loading.tga")
local pipeplace = Concat(cursors,"PipePlacement.tga")
local salvage = Concat(cursors,"Salvage.tga")

-- I would just add the ones I care for, but screw it: just do any using the wrong one
for _,t in pairs(XTemplates) do
  if t[1] and t[1].MouseCursor == "UI/Cursors/Rollover.tga" then
    t[1].MouseCursor = rollover
  end
end

--~ terminal.desktop:SetMouseCursor("CommonAssets/UI/Controls/Button/Close.tga")

-- default cursor for most objects
PropertyObject.MouseCursor = cursor
InterfaceModeDialog.MouseCursor = cursor
-- new cursors use the new one
const.DefaultMouseCursor = cursor

-- loadin'
MarsBaseLoadingScreen.MouseCursor = loading
MarsLoadingScreen.MouseCursor = loading
MarsAutosaveScreen.MouseCursor = loading
MarsDeleteGameScreen.MouseCursor = loading

-- hud buttons at the bottom of the screen
HUDButton.MouseCursor = rollover
-- a bunch of stuff
XWindow.MouseCursor = rollover
SplashScreen.MouseCursor = rollover
-- probably don't need to bother, but screw it
DemolishModeDialog.MouseCursor = salvage
GridConstructionDialogPipes.MouseCursor = pipeplace
GridSwitchConstructionDialogPipes.MouseCursor = pipeplace
GridSwitchConstructionDialogPassageRamp.MouseCursor = pipeplace

-- bunch of functions that try to use the cached one
local orig_OnScreenNotification_Init = OnScreenNotification.Init
function OnScreenNotification:Init()
  orig_OnScreenNotification_Init(self)
  self.idButton:SetMouseCursor(rollover)
end

local orig_MenuCategoryButton_Init = MenuCategoryButton.Init
function MenuCategoryButton:Init()
  orig_MenuCategoryButton_Init(self)
  self.idButton:SetMouseCursor(rollover)
  self.idCategoryButton:SetMouseCursor(rollover)
end

local orig_HexButtonItem_Init = HexButtonItem.Init
function HexButtonItem:Init()
  orig_HexButtonItem_Init(self)
  self.idButton:SetMouseCursor(rollover)
end

local orig_SplashScreen_Init = SplashScreen.Init
function SplashScreen:Init()
  orig_SplashScreen_Init(self)
  self.idButton:SetMouseCursor(rollover)
end

local orig_XPageScroll_Init = XPageScroll.Init
function XPageScroll:Init()
  orig_XPageScroll_Init(self)
  self.idPrev:SetMouseCursor(rollover)
  self.idNext:SetMouseCursor(rollover)
end

local orig_OnScreenHintDlg_Init = OnScreenHintDlg.Init
function OnScreenHintDlg:Init()
  orig_OnScreenHintDlg_Init(self)
  self.idMinimized:SetMouseCursor(rollover)
  self.idPrev:SetMouseCursor(rollover)
  self.idNext:SetMouseCursor(rollover)
  self.idEncyclopediaBtn:SetMouseCursor(rollover)
  self.idClose:SetMouseCursor(rollover)
end
