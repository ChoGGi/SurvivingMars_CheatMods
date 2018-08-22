-- See LICENSE for terms

--~ local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions

Actions[#Actions+1] = {
	ActionMenubar = "Expanded CM",
	ActionName = S[302535920000031--[[Find Nearest Resource--]]],
	ActionId = "Expanded CM.Find Nearest Resource",
	ActionIcon = "CommonAssets/UI/Menu/EV_OpenFirst.tga",
	RolloverText = S[302535920000554--[[Select an object and click this to display a list of resources.--]]],
	OnAction = function()
		ChoGGi.CodeFuncs.FindNearestResource()
	end,
	ActionSortKey = "96",
}

Actions[#Actions+1] = {
	ActionMenubar = "Expanded CM",
	ActionName = S[302535920000333--[[Building Info--]]],
	ActionId = "Expanded CM.Building Info",
	ActionIcon = "CommonAssets/UI/Menu/ExportImageSequence.tga",
	RolloverText = S[302535920000345--[[Shows info about building in text above it.--]]],
	OnAction = ChoGGi.MenuFuncs.BuildingInfo_Toggle,
	ActionSortKey = "97",
}

--~ Actions[#Actions+1] = {
--~	 ActionMenubar = "Expanded CM",
--~	 ActionName = S[302535920000555--[[Monitor Info--]]],
--~	 ActionId = "Expanded CM.Monitor Info",
--~	 ActionIcon = "CommonAssets/UI/Menu/EV_OpenFirst.tga",
--~	 RolloverText = S[302535920000556--[[Shows a list of updated information about your city.--]]],
--~	 OnAction = ChoGGi.MenuFuncs.MonitorInfo,
--~	 ActionSortKey = "98",
--~ }

Actions[#Actions+1] = {
	ActionMenubar = "Expanded CM",
	ActionName = S[302535920000469--[[Close Dialogs--]]],
	ActionId = "Expanded CM.Close Dialogs",
	ActionIcon = "CommonAssets/UI/Menu/remove_water.tga",
	RolloverText = S[302535920000470--[[Close any dialogs opened by ECM (Examine, ObjectManipulator, Change Colours, etc...)--]]],
	OnAction = ChoGGi.CodeFuncs.CloseDialogsECM,
	ActionSortKey = "99",
}
