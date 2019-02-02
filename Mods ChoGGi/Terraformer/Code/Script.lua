-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 53
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Terraformer requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				if p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end

	-- stop menus from taking up the full width of the screen
	local XShortcutsTarget = XShortcutsTarget
	if XShortcutsTarget then

		for i = 1, #XShortcutsTarget do
			local item = XShortcutsTarget[i]
			item:SetHAlign("left")
		end
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

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local c = #Actions

	c = c + 1
	Actions[c] = {ActionName = S[302535920000674--[[Terrain Editor Toggle--]]],
		replace_matching_id = true,
		ActionId = "Terraformer.Terrain Editor Toggle",
		RolloverText = S[302535920000675--[[Opens up the map editor with the brush tool visible.--]]],
		OnAction = ChoGGi.ComFuncs.TerrainEditor_Toggle,
		ActionShortcut = "Shift-F",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000864--[[Delete Large Rocks--]]],
		replace_matching_id = true,
		ActionId = "Terraformer.Delete Large Rocks",
		RolloverText = S[302535920001238--[[Removes rocks for that smooth map feel.--]]],
		OnAction = ChoGGi.ComFuncs.DeleteLargeRocks,
		ActionShortcut = "Ctrl-Shift-1",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001366--[[Delete Small Rocks--]]],
		replace_matching_id = true,
		ActionId = "Terraformer.Delete Small Rocks",
		RolloverText = S[302535920001238--[[Removes rocks for that smooth map feel.--]]],
		OnAction = ChoGGi.ComFuncs.DeleteSmallRocks,
		ActionShortcut = "Ctrl-Shift-2",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000489--[[Delete Object(s)--]]],
		replace_matching_id = true,
		ActionId = "Terraformer.Delete Object(s)",
		RolloverText = S[302535920001238--[[Removes most rocks for that smooth map feel (will take about 30 seconds).--]]],
		OnAction = function()
			ChoGGi.ComFuncs.DeleteObject()
		end,
		ActionShortcut = "Ctrl-Shift-Alt-D",
		ActionBindable = true,
	}

end
