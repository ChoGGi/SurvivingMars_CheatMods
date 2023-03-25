-- See LICENSE for terms

function OnMsg.ModsReloaded()
	-- stop menus from taking up the full width of the screen
	local XShortcutsTarget = XShortcutsTarget
	if XShortcutsTarget then

		for i = 1, #XShortcutsTarget do
			local item = XShortcutsTarget[i]
			item:SetHAlign("left")
		end
	end

end

-- fix log spam
PlaceObjectConfig = {
  Decals = {},
  Gameplay = {
    "MinimumElevationMarker"
  },
  Lights = {"PointLight"},
  Units = {}
}
ObjectPaletteFilters = {
  {text = "all", item = nil},
  {
    text = "decals",
    item = function(x)
      return g_Classes[x] and g_Classes[x]:IsKindOf("Decal")
    end
  }
}
-- editor wants a table
GlobalVar("g_revision_map",{})
-- stops some log spam in editor (function doesn't exist in SM)
UpdateMapRevision = rawget(_G,"UpdateMapRevision") or empty_func
AsyncGetSourceInfo = rawget(_G,"AsyncGetSourceInfo") or empty_func

local Actions = ChoGGi.Temp.Actions
local c = #Actions

c = c + 1
Actions[c] = {ActionName = T(302535920000674, "Terrain Editor Toggle"),
	replace_matching_id = true,
	ActionId = "Terraformer.Terrain Editor Toggle",
	RolloverText = T(302535920000675, "Opens up the map editor with the brush tool visible."),
	OnAction = function()
		ChoGGi.ComFuncs.TerrainEditor_Toggle()
		if dlgConsoleLog then
			dlgConsoleLog:SetVisible(false)
		end
	end,
	ActionShortcut = "Shift-F",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000864, "Delete Large Rocks"),
	replace_matching_id = true,
	ActionId = "Terraformer.Delete Large Rocks",
	RolloverText = T(302535920001238, "Removes rocks for that smooth map feel."),
	OnAction = ChoGGi.ComFuncs.DeleteLargeRocks,
	ActionShortcut = "Ctrl-Shift-1",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001366, "Delete Small Rocks"),
	replace_matching_id = true,
	ActionId = "Terraformer.Delete Small Rocks",
	RolloverText = T(302535920001238, "Removes rocks for that smooth map feel."),
	OnAction = ChoGGi.ComFuncs.DeleteSmallRocks,
	ActionShortcut = "Ctrl-Shift-2",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000489, "Delete Object(s)"),
	replace_matching_id = true,
	ActionId = "Terraformer.Delete Object(s)",
	RolloverText = T(302535920001238, "Removes most rocks for that smooth map feel (will take about 30 seconds)."),
	OnAction = ChoGGi.ComFuncs.DeleteObject,
	ActionShortcut = "Ctrl-Shift-Alt-D",
	ActionBindable = true,
}
