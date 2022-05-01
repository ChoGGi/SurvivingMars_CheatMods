-- See LICENSE for terms

-- not sure where to put this stuff

local TranslationTable = TranslationTable
local T = T

-- defaults to 20 items
const.nConsoleHistoryMaxSize = 100

-- bugfix?
-- got me, MapTools shouldn't be doing anything
if not rawget(_G, "DroneDebug") then
	DroneDebug = {ShowInfo = empty_func}
end

-- makes the log visible during loading/saving
ChoGGi.ComFuncs.SetLoadingScreenLog()

-- show/hide tooltips for my stuff
ChoGGi.ComFuncs.SetLibraryToolTips()

-- be too annoying to add templates to all of these manually
XMenuEntry.RolloverTemplate = "Rollover"
XMenuEntry.RolloverHint = T(608042494285--[[<left_click> Activate]])
XListItem.RolloverTemplate = "Rollover"
XListItem.RolloverHint = T(608042494285--[[<left_click> Activate]])

-- sure, lets have them appear under certain items (though i think mostly just happens from console, and I've changed that so I could remove this?)
XRolloverWindow.ZOrder = max_int

-- changed from 2000000
ConsoleLog.ZOrder = 2
Console.ZOrder = 3
-- changed from 10000000
XShortcutsHost.ZOrder = 4
-- make cheats menu look like older one (more gray, less white)
local dark_gray = -9868951
XMenuBar.Background = dark_gray
XMenuBar.RolloverHint = T(608042494285--[[<left_click> Activate]])
XPopupMenu.Background = dark_gray
XPopupMenu.RolloverHint = T(608042494285--[[<left_click> Activate]])
-- It sometimes does a jarring white background
XPopupMenu.DisabledBackground = dark_gray
-- darker gray
XPopupMenu.FocusedBackground = -11711669

TextStyles.DevMenuBar.TextColor = white

-- cheat menu names
local Actions = ChoGGi.Temp.Actions
local c = #Actions
local function AddMenuitem(id, name, sort)
	c = c + 1
	Actions[c] = {
		ActionMenubar = "DevMenu",
		ActionName = name,
		ActionId = id,
		ActionSortKey = sort,
		OnActionEffect = "popup",
		ChoGGi_ECM = true,
	}
end
AddMenuitem("ECM.Cheats", TranslationTable[27--[[Cheats]]], "1")
AddMenuitem("ECM.ECM", TranslationTable[302535920000002--[[ECM]]], "2")
AddMenuitem("ECM.Game", TranslationTable[283142739680--[[Game]]], "3")
AddMenuitem("ECM.Debug", TranslationTable[1000113--[[Debug]]], "4")
AddMenuitem("ECM.Help", TranslationTable[487939677892--[[Help]]], "5")

-- unforbid binding some keys (i left Enter and Menu, not sure what Menu is for? seems best to leave it)
local f = ForbiddenShortcutKeys
f.Lwin = nil
f.Rwin = nil
f.MouseL = nil
f.MouseR = nil
f.MouseM = nil

local us = ChoGGi.UserSettings
if us.RemoveLandScapingLimits then
	ChoGGi.ComFuncs.SetLandScapingLimits(true)
end
if us.RemoveBuildingLimits then
	ChoGGi.ComFuncs.SetBuildingLimits(true)
end
