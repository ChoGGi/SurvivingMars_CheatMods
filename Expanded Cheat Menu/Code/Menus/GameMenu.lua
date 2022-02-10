-- See LICENSE for terms

local Translate = ChoGGi.ComFuncs.Translate
local SettingState = ChoGGi.ComFuncs.SettingState
local Strings = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local c = #Actions

-- menu
c = c + 1
Actions[c] = {ActionName = Strings[302535920001058--[[Camera]]],
	ActionMenubar = "ECM.Game",
	ActionId = ".Camera",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001084--[[Reset]]],
	ActionMenubar = "ECM.Game.Camera",
	ActionId = ".Toggle Cursor",
	ActionIcon = "CommonAssets/UI/Menu/NewCamera.tga",
	RolloverText = Strings[302535920001370--[[If something makes the camera view wonky you can use this to fix it.]]],
	OnAction = ChoGGi.MenuFuncs.ResetCamera,
	ActionSortKey = "-1",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000647--[[Border Scrolling]]],
	ActionMenubar = "ECM.Game.Camera",
	ActionId = ".Border Scrolling",
	ActionIcon = "CommonAssets/UI/Menu/CameraToggle.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.BorderScrollingArea,
			Strings[302535920000648--[[Set size of activation for mouse border scrolling.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetBorderScrolling,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000649--[[Zoom Distance]]],
	ActionMenubar = "ECM.Game.Camera",
	ActionId = ".Zoom Distance",
	ActionIcon = "CommonAssets/UI/Menu/MoveUpCamera.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.CameraZoomToggle,
			Strings[302535920000650--[[Further zoom distance.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetCameraZoom,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001375--[[Bird's Eye]]],
	ActionMenubar = "ECM.Game.Camera",
	ActionId = ".Bird's Eye",
	ActionIcon = "CommonAssets/UI/Menu/UnlockCamera.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.CameraLookatDist,
			Strings[302535920001429--[[How far up the camera can move.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetCameraLookatDist,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000651--[[Toggle Free Camera]]],
	ActionMenubar = "ECM.Game.Camera",
	ActionId = ".Toggle Free Camera",
	ActionIcon = "CommonAssets/UI/Menu/NewCamera.tga",
	RolloverText = function()
		return SettingState(
			cameraFly.IsActive(),
			Strings[302535920000652--[[I believe I can fly.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.CameraFree_Toggle,
	ActionShortcut = "Shift-C",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000653--[[Toggle Follow Camera]]],
	ActionMenubar = "ECM.Game.Camera",
	ActionId = ".Toggle Follow Camera",
	ActionIcon = "CommonAssets/UI/Menu/Shot.tga",
	RolloverText = function()
		return SettingState(
			camera3p.IsActive(),
			Strings[302535920000654--[[Select (or mouse over) an object to follow.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.CameraFollow_Toggle,
	ActionShortcut = "Ctrl-Shift-F",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000655--[[Toggle Cursor]]],
	ActionMenubar = "ECM.Game.Camera",
	ActionId = ".Toggle Cursor",
	ActionIcon = "CommonAssets/UI/Menu/select_objects.tga",
	RolloverText = function()
		return SettingState(
			IsMouseCursorHidden(),
			Strings[302535920000656--[[Toggle between moving camera and selecting objects.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.CursorVisible_Toggle,
	ActionShortcut = "Ctrl-Alt-F",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001489--[[Toggle Map Edge Limit]]],
	ActionMenubar = "ECM.Game.Camera",
	ActionId = ".Toggle Cursor",
	ActionIcon = "CommonAssets/UI/Menu/move_gizmo.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.MapEdgeLimit,
			Strings[302535920001490--[[Removes pushback limit at the edge of the map.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.MapEdgeLimit_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = Strings[302535920000845--[[Render]]],
	ActionMenubar = "ECM.Game",
	ActionId = ".Render",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000633--[[Lights Radius]]],
	ActionMenubar = "ECM.Game.Render",
	ActionId = ".Lights Radius",
	ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.LightsRadius,
			Strings[302535920000634--[[Sets light radius (Menu>Options>Video>Lights), menu options max out at 100.
Lets you see lights from further away/more bleedout?]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetLightsRadius,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000635--[[Terrain Detail]]],
	ActionMenubar = "ECM.Game.Render",
	ActionId = ".Terrain Detail",
	ActionIcon = "CommonAssets/UI/Menu/selslope.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.TerrainDetail,
			Strings[302535920000636--[[Sets hr.TR_MaxChunks (Menu>Options>Video>Terrain), menu options max out at 200.
Makes the background terrain more detailed (make sure to also stick Terrain on Ultra in the options menu).]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetTerrainDetail,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000637--[[Video Memory]]],
	ActionMenubar = "ECM.Game.Render",
	ActionId = ".Video Memory",
	ActionIcon = "CommonAssets/UI/Menu/CountPointLights.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.VideoMemory,
			Strings[302535920000638--[[Sets hr.DTM_VideoMemory (Menu>Options>Video>Textures), menu options max out at 2048.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetVideoMemory,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000639--[[Shadow Map]]],
	ActionMenubar = "ECM.Game.Render",
	ActionId = ".Shadow Map",
	ActionIcon = "CommonAssets/UI/Menu/DisableEyeSpec.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.ShadowmapSize,
			Strings[302535920000640--[[Sets the shadow map size (Menu>Options>Video>Shadows), menu options max out at 4096.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetShadowmapSize,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000641--[[Disable Texture Compression]]],
	ActionMenubar = "ECM.Game.Render",
	ActionId = ".Disable Texture Compression",
	ActionIcon = "CommonAssets/UI/Menu/ExportImageSequence.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DisableTextureCompression,
			Strings[302535920000642--[[Toggle texture compression (game defaults to on, seems to make a difference of 600MB vram).]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.DisableTextureCompression_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000643--[[Higher Render Distance]]],
	ActionMenubar = "ECM.Game.Render",
	ActionId = ".Higher Render Distance",
	ActionIcon = "CommonAssets/UI/Menu/CameraEditor.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.HigherRenderDist,
			Strings[302535920000644--[[Renders model from further away.
Not noticeable unless using higher zoom.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.HigherRenderDist_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000645--[[Higher Shadow Distance]]],
	ActionMenubar = "ECM.Game.Render",
	ActionId = ".Higher Shadow Distance",
	ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.HigherShadowDist,
			Strings[302535920000646--[[Renders shadows from further away.
Not noticeable unless using higher zoom.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.HigherShadowDist_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = Strings[302535920001449--[[Export]]] .. " " .. Strings[302535920001448--[[CSV]]],
	ActionMenubar = "ECM.Game",
	ActionId = ".Export CSV",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001208--[[Colonist Data]]],
	ActionMenubar = "ECM.Game.Export CSV",
	ActionId = ".Colonist Data",
	ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
	RolloverText = Strings[302535920001219--[[Export colonist data to %sColonists.csv.]]]:format(ConvertToOSPath("AppData/")),
	OnAction = ChoGGi.ComFuncs.ExportColonistDataToCSV,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001450--[[Graphs Data]]],
	ActionMenubar = "ECM.Game.Export CSV",
	ActionId = ".Graphs Data",
	ActionIcon = "CommonAssets/UI/Menu/ConvertEnvironment.tga",
	RolloverText = Strings[302535920001452--[[Export command centre graph data to %sGraphs.csv.]]]:format(ConvertToOSPath("AppData/")),
	OnAction = ChoGGi.ComFuncs.ExportGraphsToCSV,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001501--[[Map Data]]],
	ActionMenubar = "ECM.Game.Export CSV",
	ActionId = ".Map Data",
	ActionIcon = "CommonAssets/UI/Menu/RandomMapPresetEditor.tga",
	RolloverText = Strings[302535920001502--[["Export map location data to %sMapData.csv (will take awhile).

See survivingmaps.com for a filtered list.
Don't use in start new game screens (rating/topo will be messed up).
Difficulty Challenge/Named Location may not work on some saves (best to start a new game, or run from main menu)."]]]:format(ConvertToOSPath("AppData/")),
	OnAction = ChoGGi.ComFuncs.ExportMapDataToCSV,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001618--[[Map Data (Breakthroughs)]]],
	ActionMenubar = "ECM.Game.Export CSV",
	ActionId = ".Map Data (Breakthroughs)",
	ActionIcon = "CommonAssets/UI/Menu/LowerTerrainToLevel.tga",
	RolloverText = Strings[302535920001502--[["Export map location data to %sMapData.csv (will take awhile).

See survivingmaps.com for a filtered list.
Don't use in start new game screens (rating/topo will be messed up).
Difficulty Challenge/Named Location may not work on some saves (best to start a new game, or run from main menu)."]]]:format(ConvertToOSPath("AppData/"))
	.. "\n\n" .. Strings[302535920001619--[[This will take <color ChoGGi_red>longer</color> (about 15s).]]],
	OnAction = ChoGGi.ComFuncs.ExportMapDataToCSV,
	setting_breakthroughs = true,
	setting_limit_count = 12,
}

-- menu
c = c + 1
Actions[c] = {ActionName = Strings[302535920000892--[[Screenshot]]],
	ActionMenubar = "ECM.Game",
	ActionId = ".Screenshot",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000657--[[Screenshot]]],
	ActionMenubar = "ECM.Game.Screenshot",
	ActionId = ".Screenshot",
	ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
	RolloverText = Strings[302535920000658--[[Write screenshot]]],
	OnAction = ChoGGi.MenuFuncs.TakeScreenshot,
	setting_mask = 0,
	ActionShortcut = "-PrtScr",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000659--[[Screenshot Upsampled]]],
	ActionMenubar = "ECM.Game.Screenshot",
	ActionId = ".Screenshot Upsampled",
	ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
	RolloverText = Strings[302535920000660--[[Write screenshot upsampled]]],
	OnAction = ChoGGi.MenuFuncs.TakeScreenshot,
	setting_mask = 1,
	ActionShortcut = "-Ctrl-PrtScr",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000661--[[Show Interface in Screenshots]]],
	ActionMenubar = "ECM.Game.Screenshot",
	ActionId = ".Show Interface in Screenshots",
	ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.ShowInterfaceInScreenshots,
			Strings[302535920000662--[[Do you want to see the interface in screenshots?]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ShowInterfaceInScreenshots_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = Strings[302535920000893--[[Interface]]],
	ActionMenubar = "ECM.Game",
	ActionId = ".Interface",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001660--[[Toggle Vertical Cheat Menu]]],
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".Toggle Vertical Cheat Menu",
	ActionIcon = "CommonAssets/UI/Menu/HideUnselected.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.VerticalCheatMenu,
			Strings[302535920001661--[[Puts the menu down the side of the screen to save horizontal space for the info bar.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.VerticalCheatMenu_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001387--[[Toggle Signs]]],
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".Toggle Signs",
	ActionIcon = "CommonAssets/UI/Menu/ToggleMarkers.tga",
	RolloverText = Strings[302535920001388--[["Concrete, metal deposits, not working, etc..."]]],
	OnAction = ToggleSigns,
	ActionShortcut = "Ctrl-Alt-U",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000666--[[Toggle on-screen hints]]],
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".Toggle on-screen hints",
	ActionIcon = "CommonAssets/UI/Menu/HideUnselected.tga",
	RolloverText = function()
		return SettingState(
			HintsEnabled,
			Strings[302535920000667--[[Don't show hints for this game.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.OnScreenHints_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000668--[[Reset on-screen hints]]],
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".Reset on-screen hints",
	ActionIcon = "CommonAssets/UI/Menu/HideSelected.tga",
	RolloverText = Strings[302535920000669--[[Just in case you wanted to see them again.]]],
	OnAction = ChoGGi.MenuFuncs.OnScreenHints_Reset,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000670--[[Never Show Hints]]],
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".Never Show Hints",
	ActionIcon = "CommonAssets/UI/Menu/set_debug_texture.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DisableHints,
			Strings[302535920000671--[[No more hints ever.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.NeverShowHints_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001412--[[GUI Dock Side]]],
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".GUI Dock Side",
	ActionIcon = "CommonAssets/UI/Menu/DisableAOMaps.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.GUIDockSide and Translate(1000459--[[Right]]) or Translate(1000457--[[Left]]),
			Strings[302535920001413--[[Change which side (most) GUI menus are on.]]]

		)
	end,
	OnAction = ChoGGi.MenuFuncs.GUIDockSide_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001653--[[Toggle Selection Panel Resize]]],
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".Selection Panel Resize",
	ActionIcon = "CommonAssets/UI/Menu/DisableAOMaps.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.StopSelectionPanelResize,
			Strings[302535920001654--[[Stops selection panel from shrinking (eg: dome).]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SelectionPanelResize_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001655--[[Toggle Scroll Selection Panel]]],
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".Scroll Selection Panel",
	ActionIcon = "CommonAssets/UI/Menu/ListCollections.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.ScrollSelectionPanel,
			Strings[302535920001656--[[Add a scrollbar to larger selection panels (buildings, domes, etc).]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ScrollSelectionPanel_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = Translate(911432559058--[[Light model]]),
	ActionMenubar = "ECM.Game",
	ActionId = ".Lightmodel",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Translate(911432559058--[[Light model]]),
	ActionMenubar = "ECM.Game.Lightmodel",
	ActionId = ".Light Model",
	ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.Lightmodel,
			Strings[302535920000626--[[Changes the lighting mode (temporary or permanent).]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ChangeLightmodel,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001623--[[List Normal]]],
	ActionMenubar = "ECM.Game.Lightmodel",
	ActionId = ".List Normal",
	ActionIcon = "CommonAssets/UI/Menu/CountPointLights.tga",
	RolloverText = function()
		return SettingState(
			NormalLightmodelList,
			Strings[302535920001624--[[Changes the list of lightmodels to use (night/day/etc).]]]
		)
	end,
	setting_func = SetNormalLightmodelList,
	setting_title = Strings[302535920001623--[[List Normal]]],
	OnAction = ChoGGi.MenuFuncs.ChangeLightmodelList,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001625--[[List Disaster]]],
	ActionMenubar = "ECM.Game.Lightmodel",
	ActionId = ".List Disaster",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = function()
		return SettingState(
			DisasterLightmodelList,
			Strings[302535920001626--[[Overrides List Normal.]]]
		)
	end,
	setting_func = SetDisasterLightmodelList,
	setting_title = Strings[302535920001625--[[List Disaster]]],
	OnAction = ChoGGi.MenuFuncs.ChangeLightmodelList,
}

-- menu
c = c + 1
Actions[c] = {ActionName = Translate(904--[[Terrain]]),
	ActionMenubar = "ECM.Game",
	ActionId = ".Terrain",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000674--[[Terrain Editor Toggle]]],
	ActionMenubar = "ECM.Game.Terrain",
	ActionId = ".Terrain Editor Toggle",
	ActionIcon = "CommonAssets/UI/Menu/smooth_terrain.tga",
	RolloverText = Strings[302535920000675--[[Opens up the map editor with the brush tool visible.]]],
	OnAction = ChoGGi.ComFuncs.TerrainEditor_Toggle,
	ActionShortcut = "Ctrl-Shift-T",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000485--[[Terrain Flatten Toggle]]],
	ActionMenubar = "ECM.Game.Terrain",
	ActionId = ".Terrain Flatten Toggle",
	ActionIcon = "CommonAssets/UI/Menu/FixUnderwaterEdges.tga",
	RolloverText = Strings[302535920000486--[[Use the shortcut to turn this on as it will use where your cursor is as the height to flatten to.

Use Shift + Arrow keys to change the height/radius.]]],
	OnAction = ChoGGi.MenuFuncs.FlattenTerrain_Toggle,
	ActionShortcut = "Shift-F",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000623--[[Terrain Texture Change]]],
	ActionMenubar = "ECM.Game.Terrain",
	ActionId = ".Terrain Texture Change",
	ActionIcon = "CommonAssets/UI/Menu/terrain_type.tga",
	RolloverText = Strings[302535920000624--[[Green or Icy mars? Coming right up!
(don't forget a light model)]]],
	OnAction = ChoGGi.MenuFuncs.TerrainTextureChange,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001237--[[Terrain Texture Remap]]],
	ActionMenubar = "ECM.Game.Terrain",
	ActionId = ".Terrain Texture Remap",
	ActionIcon = "CommonAssets/UI/Menu/terrain_type.tga",
	RolloverText = Strings[302535920001312--[["Instead of replacing all textures with one then re-adding stuff, this will remap existing textures."]]],
	OnAction = ChoGGi.MenuFuncs.TerrainTextureRemap,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000864--[[Delete Large Rocks]]],
	ActionMenubar = "ECM.Game.Terrain",
	ActionId = ".Delete Large Rocks",
	ActionIcon = "CommonAssets/UI/Menu/selslope.tga",
	RolloverText = Strings[302535920001238--[[Removes rocks for that smooth map feel.]]],
	OnAction = ChoGGi.ComFuncs.DeleteLargeRocks,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001366--[[Delete Small Rocks]]],
	ActionMenubar = "ECM.Game.Terrain",
	ActionId = ".Delete Small Rocks",
	ActionIcon = "CommonAssets/UI/Menu/selslope.tga",
	RolloverText = Strings[302535920001238--[[Removes rocks for that smooth map feel.]]],
	OnAction = ChoGGi.ComFuncs.DeleteSmallRocks,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001259--[[Delete Grass Bushes Trees]]],
	ActionMenubar = "ECM.Game.Terrain",
	ActionId = ".Delete Grass Bushes Trees",
	ActionIcon = "CommonAssets/UI/Menu/selslope.tga",
	RolloverText = Strings[302535920001258--[[Removes Grass Bushes Trees for that smooth map feel.]]],
	OnAction = ChoGGi.MenuFuncs.DeleteGrassBushesTrees,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001111--[[Whiter Rocks]]],
	ActionMenubar = "ECM.Game.Terrain",
	ActionId = ".Whiter Rocks",
	ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
	RolloverText = Strings[302535920001113--[[Helps the rocks blend in better when using the polar ground texture.]]],
	OnAction = ChoGGi.MenuFuncs.WhiterRocks,
}

-- menu
c = c + 1
Actions[c] = {ActionName = Translate(4820--[[UI]]),
	ActionMenubar = "ECM.Game",
	ActionId = ".UI",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000629--[[UI Transparency]]],
	ActionMenubar = "ECM.Game.UI",
	ActionId = ".UI Transparency",
	ActionIcon = "CommonAssets/UI/Menu/set_last_texture.tga",
	RolloverText = Strings[302535920000630--[[Change the transparency of UI items (info panel, menu, pins).]]],
	OnAction = ChoGGi.MenuFuncs.SetTransparencyUI,
	ActionShortcut = "Ctrl-F3",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000631--[[UI Transparency Mouseover]]],
	ActionMenubar = "ECM.Game.UI",
	ActionId = ".UI Transparency Mouseover",
	ActionIcon = "CommonAssets/UI/Menu/set_last_texture.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.TransparencyToggle,
			Strings[302535920000632--[[Toggle removing transparency on mouseover.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.TransparencyUI_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000265--[[Pulsating Pins]]],
	ActionMenubar = "ECM.Game.UI",
	ActionId = ".Pulsating Pins",
	ActionIcon = "CommonAssets/UI/Menu/JoinGame.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DisablePulsatingPinsMotion,
			Strings[302535920000335--[[When true pins will no longer do the pulsating motion (hover over to stop).]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.PulsatingPins_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = Translate(298035641454--[[Object]]),
	ActionMenubar = "ECM.Game",
	ActionId = ".Object",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000686--[[Auto Unpin Objects]]],
	ActionMenubar = "ECM.Game.Object",
	ActionId = ".Auto Unpin Objects",
	ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
	RolloverText = function()
		local value = ChoGGi.UserSettings.UnpinObjects or {}
		-- It can get large, so for this one we stick the description first.
		return Strings[302535920000687--[[Will automagically stop any of these objects from being added to the pinned list.]]]
			.. "\n<color 100 255 100>" .. ValueToLuaCode(value) .. "</color>"
	end,
	OnAction = ChoGGi.MenuFuncs.ShowAutoUnpinObjectList,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001292--[[List All Objects]]],
	ActionMenubar = "ECM.Game.Object",
	ActionId = ".List All Objects",
	ActionIcon = "CommonAssets/UI/Menu/select_objects.tga",
	RolloverText = Strings[302535920001293--[[A list of objects; double-click on one to select and move the camera to it.]]],
	OnAction = ChoGGi.MenuFuncs.ListAllObjects,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000694--[[Set Opacity]]],
	ActionMenubar = "ECM.Game.Object",
	ActionId = ".Set Opacity",
	ActionIcon = "CommonAssets/UI/Menu/set_last_texture.tga",
	RolloverText = function()
		local obj = SelectedObj
		if IsValid(obj) then
			return SettingState(
				obj:GetOpacity(),
				Strings[302535920000695--[[Change the opacity of objects.]]]
			)
		else
			return Strings[302535920000695]
		end
	end,
	OnAction = ChoGGi.MenuFuncs.SetObjectOpacity,
	ActionShortcut = "F3",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Translate(174--[[Color Modifier]]),
	ActionMenubar = "ECM.Game.Object",
	ActionId = ".Color Modifier",
	ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
	RolloverText = Strings[302535920000693--[[Select/mouse over an object to change the colours
Use Shift- or Ctrl- for random colours/reset colours.]]],
	OnAction = ChoGGi.ComFuncs.CreateObjectListAndAttaches,
	ActionShortcut = "F6",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000678--[[Change Surface Signs To Materials]]],
	ActionMenubar = "ECM.Game.Object",
	ActionId = ".Change Surface Signs To Materials",
	ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
	RolloverText = Strings[302535920000679--[[Changes all the ugly immersion breaking signs to materials (reversible).]]],
	OnAction = ChoGGi.ComFuncs.ChangeSurfaceSignsToMaterials,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000862--[[Object Planner]]],
	ActionMenubar = "ECM.Game.Object",
	ActionId = ".Object Planner",
	ActionIcon = "CommonAssets/UI/Menu/ShowOccluders.tga",
	RolloverText = Strings[302535920000863--[[Places fake construction site objects at mouse cursor (collision disabled).]]],
	OnAction = ChoGGi.ComFuncs.EntitySpawner,
	setting_planning = true,
	ActionShortcut = "Ctrl-Shift-A",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000581--[[Toggle Object Collision]]],
	ActionMenubar = "ECM.Game.Object",
	ActionId = ".Toggle Object Collision",
	ActionIcon = "CommonAssets/UI/Menu/road_type.tga",
	RolloverText = Strings[302535920000582--[[Select an object and activate this to toggle collision (if you have a rover stuck in a dome).]]],
	OnAction = ChoGGi.ComFuncs.CollisionsObject_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = Strings[302535920001355--[[Map]]],
	ActionMenubar = "ECM.Game",
	ActionId = ".Map",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000493--[[Change Map]]],
	ActionMenubar = "ECM.Game.Map",
	ActionId = ".Change Map",
	ActionIcon = "CommonAssets/UI/Menu/load_city.tga",
	RolloverText = Strings[302535920000494--[[Change map (options to pick commander, sponsor, etc...

Attention: If you get yellow ground areas; just load it again or try %s.]]]:format(Strings[302535920001487--[[Reload Map]]]),
	OnAction = ChoGGi.MenuFuncs.ChangeMap,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001651--[[Unlock Overview]]],
	ActionMenubar = "ECM.Game.Map",
	ActionId = ".Unlock Overview",
	ActionIcon = "CommonAssets/UI/Menu/load_city.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.UnlockOverview,
			Strings[302535920001652--[[Overview works on all maps.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.UnlockOverview_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001487--[[Reload Map]]],
	ActionMenubar = "ECM.Game.Map",
	ActionId = ".ReloadMap",
	ActionIcon = "CommonAssets/UI/Menu/reload.tga",
	RolloverText = Strings[302535920001488--[[Reloads map as new game.]]],
	OnAction = ChoGGi.MenuFuncs.ReloadMap,
}

-- menu
c = c + 1
Actions[c] = {ActionName = Translate(5505--[[Game Speed]]),
	ActionMenubar = "ECM.Game",
	ActionId = ".Game Speed",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = Translate(5505--[[Game Speed]]),
	ActionMenubar = "ECM.Game.Game Speed",
	ActionId = ".Game Speed",
	ActionIcon = "CommonAssets/UI/Menu/SelectionToTemplates.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.mediumGameSpeed,
			Strings[302535920000703--[[Change the game speed (only for medium/fast, normal is normal).]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetGameSpeed,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000356--[[Time Factor]]],
	ActionMenubar = "ECM.Game.Game Speed",
	ActionId = ".Time Factor",
	ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
	RolloverText = function()
		return SettingState(
			GetTimeFactor(),
			Strings[302535920000387--[[Change the time factor (not permanently); for ease of screenshots or something.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetTimeFactor,
}
