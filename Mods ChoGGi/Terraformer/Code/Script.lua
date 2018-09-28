-- See LICENSE for terms

-- tell people know how to get the library
function OnMsg.ModsReloaded()
	local library_version = 15

	local ModsLoaded = ModsLoaded
	local not_found_or_wrong_version
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	if idx then
		if library_version > ModsLoaded[idx].version then
			not_found_or_wrong_version = true
		end
	else
		not_found_or_wrong_version = true
	end

	if not_found_or_wrong_version then
		CreateRealTimeThread(function()
			local Sleep = Sleep
			while not UICity do
				Sleep(1000)
			end
			if WaitMarsQuestion(nil,nil,string.format([[Error: This mod requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],library_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- do some stuff
local Platform = Platform
Platform.editor = true
-- fixes UpdateInterface nil value in editor mode
local d_before = Platform.developer
Platform.developer = true
editor.LoadPlaceObjConfig()
Platform.developer = d_before
-- editor wants a table
GlobalVar("g_revision_map",{})
-- stops some log spam in editor (function doesn't exist in SM)
function UpdateMapRevision()end
function AsyncGetSourceInfo()end

-- make a ref to Actions here, but create the table after my library is good to go
local Actions
function OnMsg.ShortcutsReloaded()
	ChoGGi.ComFuncs.Rebuildshortcuts(Actions)
end

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings

	Actions = {
		{
			replace_matching_id = true,
			ActionName = S[302535920000674--[[Terrain Editor Toggle--]]],
			ActionId = "Game.Terrain Editor Toggle",
			RolloverText = S[302535920000675--[[Opens up the map editor with the brush tool visible.--]]],
			OnAction = ChoGGi.CodeFuncs.TerrainEditor_Toggle,
			ActionShortcut = "Shift-F",
			ActionBindable = true,
		},
		{
			replace_matching_id = true,
			ActionName = S[302535920000864--[[Delete Large Rocks--]]],
			ActionId = "Game.Delete Large Rocks",
			RolloverText = S[302535920001238--[[Removes rocks for that smooth map feel.--]]],
			OnAction = ChoGGi.CodeFuncs.DeleteLargeRocks,
			ActionShortcut = "Ctrl-Shift-1",
			ActionBindable = true,
		},
		{
			replace_matching_id = true,
			ActionName = S[302535920001366--[[Delete Small Rocks--]]],
			ActionId = "Game.Delete Small Rocks",
			RolloverText = S[302535920001238--[[Removes rocks for that smooth map feel.--]]],
			OnAction = ChoGGi.CodeFuncs.DeleteSmallRocks,
			ActionShortcut = "Ctrl-Shift-2",
			ActionBindable = true,
		},
		{
			replace_matching_id = true,
			ActionName = S[302535920000864--[[Delete All Rocks--]]],
			ActionId = "Game.Delete Object(s)",
			RolloverText = S[302535920001238--[[Removes most rocks for that smooth map feel (will take about 30 seconds).--]]],
			OnAction = function()
				ChoGGi.CodeFuncs.DeleteObject()
			end,
			ActionShortcut = "Ctrl-Shift-Alt-D",
			ActionBindable = true,
		},
	}

end
