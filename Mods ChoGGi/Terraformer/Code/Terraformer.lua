-- See LICENSE for terms

function OnMsg.ModsLoaded()
	if not table.find(ModsLoaded,"id","ChoGGi_Library") then
		print([[Error: This mod requires ChoGGi's Library:
https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374
Check Mod Manager to make sure it's enabled.]])
	end
end

-- nope not hacky at all
local is_loaded
function OnMsg.ClassesGenerate()
	Msg("ChoGGi_Library_Loaded","ChoGGi_Terraformer")
end
function OnMsg.ChoGGi_Library_Loaded(mod_id)
	if is_loaded or mod_id and mod_id ~= "ChoGGi_Terraformer" then
		return
	end
	is_loaded = true

--~ 	local ReloadShortcuts = ReloadShortcuts

--~ 	function OnMsg.LoadGame()
--~ 		ReloadShortcuts()
--~ 	end
--~ 	function OnMsg.CityStart()
--~ 		ReloadShortcuts()
--~ 	end
--~ 	function OnMsg.ReloadLua()
--~ 		ReloadShortcuts()
--~ 	end

	local S = ChoGGi.Strings

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

	local function ToggleCollisions(ChoGGi)
		MapForEach("map","LifeSupportGridElement",function(o)
			ChoGGi.CodeFuncs.CollisionsObject_Toggle(o,true)
		end)
	end

	local TerrainEditor_Toggle = ChoGGi.MenuFuncs.TerrainEditor_Toggle or function()
		local ChoGGi = ChoGGi
		ChoGGi.CodeFuncs.Editor_Toggle()

		if Platform.editor then
			editor.ClearSel()
			SetEditorBrush(const.ebtTerrainType)
		else
			-- disable collisions on pipes beforehand, so they don't get marked as uneven terrain
			ToggleCollisions(ChoGGi)
			-- update uneven terrain checker thingy
			RecalcBuildableGrid()
			-- and back on when we're done
			ToggleCollisions(ChoGGi)
		end

	end

	local DeleteAllRocks = ChoGGi.MenuFuncs.DeleteAllRocks or function()
		local function CallBackFunc(answer)
			if answer then
				CreateGameTimeThread(function()
					MapDelete("map", "Deposition")
					Sleep(10)
					MapDelete("map", "WasteRockObstructorSmall")
					Sleep(10)
					MapDelete("map", "WasteRockObstructor")
					Sleep(10)
					MapDelete("map", "StoneSmall")
				end)
			end
		end
		ChoGGi.ComFuncs.QuestionBox(
			string.format("%s!\n%s",S[6779--[[Warning--]]],S[302535920001238--[[Removes most rocks for that smooth map feel (will take about 30 seconds).--]]]),
			CallBackFunc,
			string.format("%s: %s",S[6779--[[Warning--]]],S[302535920000855--[[Last chance before deletion!--]]])
		)
	end

	local Actions = {
		{
			ActionId = "Terraformer.Terrain Editor Toggle",
			OnAction = TerrainEditor_Toggle,
			ActionShortcut = "Ctrl-F",
			replace_matching_id = true,
		},
		{
			ActionId = "Terraformer.Delete All Rocks",
			OnAction = DeleteAllRocks,
			ActionShortcut = "Ctrl-Shift-F",
			replace_matching_id = true,
		},
	}

	-- removes all the dev shortcuts/etc and adds mine
	local function Rebuildshortcuts()
		local XShortcutsTarget = XShortcutsTarget

		-- remove all built-in shortcuts (pretty much just a cutdown copy of ReloadShortcuts)
		XShortcutsTarget.actions = {}
		-- re-add certain ones
		if not Platform.ged then
			if XTemplates.GameShortcuts then
				XTemplateSpawn("GameShortcuts", XShortcutsTarget)
			end
		elseif XTemplates.GedShortcuts then
			XTemplateSpawn("GedShortcuts", XShortcutsTarget)
		end

--~ 		-- remove stuff from GameShortcuts
--~ 		local table_remove = table.remove
--~ 		for i = #XShortcutsTarget.actions, 1, -1 do
--~ 			-- removes pretty much all the dev actions added, and leaves the game ones intact
--~ 			local id = XShortcutsTarget.actions[i].ActionId
--~ 			if id and (not id:starts_with("action") --[[or id:starts_with("actionPOC")--]] or id == "actionToggleFullscreen") then
--~ 				table_remove(XShortcutsTarget.actions,i)
--~ 			end
--~ 		end

		-- and add mine
		local XAction = XAction

		for i = 1, #Actions do
			-- and add to the actual actions
			XShortcutsTarget:AddAction(XAction:new(Actions[i]))
		end

		-- add rightclick action to menuitems
		XShortcutsTarget:UpdateToolbar()
		-- got me
		XShortcutsThread = false
	end

	function OnMsg.ShortcutsReloaded()
		Rebuildshortcuts()
	end

end
