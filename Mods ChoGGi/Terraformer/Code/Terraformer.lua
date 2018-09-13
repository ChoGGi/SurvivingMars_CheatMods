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

local Actions = {
	{
		ActionId = "Game.Terrain Editor Toggle",
		OnAction = ChoGGi.CodeFuncs.TerrainEditor_Toggle,
		ActionShortcut = "Shift-F",
		replace_matching_id = true,
		ActionBindable = true,
	},
	{
		ActionId = "Game.Delete All Rocks",
		OnAction = ChoGGi.CodeFuncs.DeleteAllRocks,
		ActionShortcut = "Shift-Ctrl-F",
		replace_matching_id = true,
		ActionBindable = true,
	},
}

function OnMsg.ShortcutsReloaded()
	ChoGGi.ComFuncs.Rebuildshortcuts(Actions)
end
