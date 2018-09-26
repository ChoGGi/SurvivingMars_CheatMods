-- See LICENSE for terms

-- tell people know how to get the library
function OnMsg.ModsReloaded()
	local library_version = 14

	local ModsLoaded = ModsLoaded
	local not_found_or_wrong_version
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	if idx then
		if library_version < ModsLoaded[idx].version then
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
			if WaitMarsQuestion(nil,nil,string.format([[Error: This mod requires ChoGGi's Library v%s.
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

local Actions

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings

	Actions = {
		{
			ActionShortcut = "Shift-F",
			replace_matching_id = true,

			ActionName = S[302535920000674--[[Terrain Editor Toggle--]]],
			ActionId = "Game.Terrain Editor Toggle",
			RolloverText = S[302535920000675--[[Opens up the map editor with the brush tool visible.--]]],
			OnAction = ChoGGi.CodeFuncs.TerrainEditor_Toggle,
			ActionBindable = true,

		},
		{
			ActionShortcut = "Ctrl-Shift-F",
			replace_matching_id = true,
			ActionBindable = true,

			ActionName = S[302535920000864--[[Delete All Rocks--]]],
			ActionId = "Game.Delete All Rocks",
			RolloverText = S[302535920001238--[[Removes most rocks for that smooth map feel (will take about 30 seconds).--]]],
			OnAction = ChoGGi.CodeFuncs.DeleteAllRocks,

		},
	}

	function OnMsg.ShortcutsReloaded()
		ChoGGi.ComFuncs.Rebuildshortcuts(Actions)
	end

end
