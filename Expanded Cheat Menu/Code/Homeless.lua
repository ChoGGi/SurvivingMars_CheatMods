-- See LICENSE for terms

-- not sure where to put this stuff

local Translate = ChoGGi.ComFuncs.Translate

-- now to get the devs to add this by default (Added the X so people realise it isn't offical)
local Mods,rawset = Mods,rawset
for id,mod in pairs(Mods) do
	rawset(mod.env,"CurrentModId_X",id)
end

-- bugfix?
-- got me, MapTools shouldn't be doing anything
if not rawget(_G,"DroneDebug") then
	DroneDebug = {}
	DroneDebug.ShowInfo = empty_func
end

-- makes the log visible during loading/saving
ChoGGi.ComFuncs.SetLoadingScreenLog()

-- show/hide tooltips for my stuff
ChoGGi.ComFuncs.SetLibraryToolTips()

-- be too annoying to add templates to all of these manually
XMenuEntry.RolloverTemplate = "Rollover"
XMenuEntry.RolloverHint = Translate(608042494285--[[<left_click> Activate--]])
XListItem.RolloverTemplate = "Rollover"
XListItem.RolloverHint = Translate(608042494285--[[<left_click> Activate--]])

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
XMenuBar.RolloverHint = Translate(608042494285--[[<left_click> Activate--]])
XPopupMenu.Background = dark_gray
XPopupMenu.RolloverHint = Translate(608042494285--[[<left_click> Activate--]])
-- it sometimes does a jarring white background
XPopupMenu.DisabledBackground = dark_gray
-- darker gray
XPopupMenu.FocusedBackground = -11711669

TextStyles.DevMenuBar.TextColor = white

-- unforbid binding some keys (i left Enter and Menu, not sure what Menu is for? seems best to leave it)
local f = ForbiddenShortcutKeys
f.Lwin = nil
f.Rwin = nil
f.MouseL = nil
f.MouseR = nil
f.MouseM = nil
