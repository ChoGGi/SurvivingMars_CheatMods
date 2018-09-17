-- See LICENSE for terms

function OnMsg.ModsLoaded()
	if not table.find(ModsLoaded,"id","ChoGGi_Library") then
		CreateRealTimeThread(function()
			local Sleep = Sleep
			while not UICity do
				Sleep(1000)
			end
			if WaitMarsQuestion(nil,nil,[[Error: This mod requires ChoGGi's Library.
Press Ok to download it or check Mod Manager to make sure it's enabled.]]) == "ok" then
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
