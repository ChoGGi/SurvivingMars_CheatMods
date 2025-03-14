-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

local ChoGGi_Funcs = ChoGGi_Funcs
local T = T
local Translate = ChoGGi_Funcs.Common.Translate
local SettingState = ChoGGi_Funcs.Common.SettingState

local Actions = ChoGGi.Temp.Actions
local c = #Actions

-- menu
c = c + 1
Actions[c] = {ActionName = T(302535920001058--[[Camera]]),
	ActionMenubar = "ECM.Game",
	ActionId = ".Camera",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920001084--[[Reset]]),
	ActionMenubar = "ECM.Game.Camera",
	ActionId = ".Toggle Cursor",
	ActionIcon = "CommonAssets/UI/Menu/NewCamera.tga",
	RolloverText = T(302535920001370--[[If something makes the camera view wonky you can use this to fix it.]]),
	OnAction = ChoGGi_Funcs.Menus.ResetCamera,
	ActionSortKey = "-1",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000647--[[Border Scrolling]]),
	ActionMenubar = "ECM.Game.Camera",
	ActionId = ".Border Scrolling",
	ActionIcon = "CommonAssets/UI/Menu/CameraToggle.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.BorderScrollingArea,
			T(302535920000648--[[Set size of activation for mouse border scrolling.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetBorderScrolling,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000649--[[Zoom Distance]]),
	ActionMenubar = "ECM.Game.Camera",
	ActionId = ".Zoom Distance",
	ActionIcon = "CommonAssets/UI/Menu/MoveUpCamera.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.CameraZoomToggle,
			T(302535920000650--[[Further zoom distance.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetCameraZoom,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001375--[[Bird's Eye]]),
	ActionMenubar = "ECM.Game.Camera",
	ActionId = ".Bird's Eye",
	ActionIcon = "CommonAssets/UI/Menu/UnlockCamera.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.CameraLookatDist,
			T(302535920001429--[[How far up the camera can move.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetCameraLookatDist,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000651--[[Toggle Free Camera]]),
	ActionMenubar = "ECM.Game.Camera",
	ActionId = ".Toggle Free Camera",
	ActionIcon = "CommonAssets/UI/Menu/NewCamera.tga",
	RolloverText = function()
		return SettingState(
			cameraFly.IsActive(),
			T(302535920000652--[[I believe I can fly.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.CameraFree_Toggle,
	ActionShortcut = "Shift-C",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000653--[[Toggle Follow Camera]]),
	ActionMenubar = "ECM.Game.Camera",
	ActionId = ".Toggle Follow Camera",
	ActionIcon = "CommonAssets/UI/Menu/Shot.tga",
	RolloverText = function()
		return SettingState(
			camera3p.IsActive(),
			T(302535920000654--[[Select (or mouse over) an object to follow.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.CameraFollow_Toggle,
	ActionShortcut = "Ctrl-Shift-F",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000655--[[Toggle Cursor]]),
	ActionMenubar = "ECM.Game.Camera",
	ActionId = ".Toggle Cursor",
	ActionIcon = "CommonAssets/UI/Menu/select_objects.tga",
	RolloverText = function()
		return SettingState(
			IsMouseCursorHidden(),
			T(302535920000656--[[Toggle between moving camera and selecting objects.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.CursorVisible_Toggle,
	ActionShortcut = "Ctrl-Alt-F",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001489--[[Toggle Map Edge Limit]]),
	ActionMenubar = "ECM.Game.Camera",
	ActionId = ".Toggle Cursor",
	ActionIcon = "CommonAssets/UI/Menu/move_gizmo.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.MapEdgeLimit,
			T(302535920001490--[[Removes pushback limit at the edge of the map.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.MapEdgeLimit_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(302535920000845--[[Render]]),
	ActionMenubar = "ECM.Game",
	ActionId = ".Render",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000633--[[Lights Radius]]),
	ActionMenubar = "ECM.Game.Render",
	ActionId = ".Lights Radius",
	ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.LightsRadius,
			T(302535920000634--[[Sets light radius (Menu>Options>Video>Lights), menu options max out at 100.
Lets you see lights from further away/more bleedout?]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetLightsRadius,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000635--[[Terrain Detail]]),
	ActionMenubar = "ECM.Game.Render",
	ActionId = ".Terrain Detail",
	ActionIcon = "CommonAssets/UI/Menu/selslope.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.TerrainDetail,
			T(302535920000636--[[Sets hr.TR_MaxChunks (Menu>Options>Video>Terrain), menu options max out at 200.
Makes the background terrain more detailed (make sure to also stick Terrain on Ultra in the options menu).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetTerrainDetail,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000637--[[Video Memory]]),
	ActionMenubar = "ECM.Game.Render",
	ActionId = ".Video Memory",
	ActionIcon = "CommonAssets/UI/Menu/CountPointLights.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.VideoMemory,
			T(302535920000638--[[Sets hr.DTM_VideoMemory (Menu>Options>Video>Textures), menu options max out at 2048.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetVideoMemory,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000639--[[Shadow Map]]),
	ActionMenubar = "ECM.Game.Render",
	ActionId = ".Shadow Map",
	ActionIcon = "CommonAssets/UI/Menu/DisableEyeSpec.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.ShadowmapSize,
			T(302535920000640--[[Sets the shadow map size (Menu>Options>Video>Shadows), menu options max out at 4096.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetShadowmapSize,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000641--[[Disable Texture Compression]]),
	ActionMenubar = "ECM.Game.Render",
	ActionId = ".Disable Texture Compression",
	ActionIcon = "CommonAssets/UI/Menu/ExportImageSequence.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DisableTextureCompression,
			T(302535920000642--[[Toggle texture compression (game defaults to on, seems to make a difference of 600MB vram).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.DisableTextureCompression_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000643--[[Higher Render Distance]]),
	ActionMenubar = "ECM.Game.Render",
	ActionId = ".Higher Render Distance",
	ActionIcon = "CommonAssets/UI/Menu/CameraEditor.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.HigherRenderDist,
			T(302535920000644--[[Renders model from further away.
Not noticeable unless using higher zoom.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.HigherRenderDist_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000645--[[Higher Shadow Distance]]),
	ActionMenubar = "ECM.Game.Render",
	ActionId = ".Higher Shadow Distance",
	ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.HigherShadowDist,
			T(302535920000646--[[Renders shadows from further away.
Not noticeable unless using higher zoom.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.HigherShadowDist_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(302535920001449--[[Export]]) .. " " .. T(302535920001448--[[CSV]]),
	ActionMenubar = "ECM.Game",
	ActionId = ".Export CSV",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920001208--[[Colonist Data]]),
	ActionMenubar = "ECM.Game.Export CSV",
	ActionId = ".Colonist Data",
	ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
	RolloverText = Translate(302535920001219--[[Export colonist data to %sColonists.csv.]]):format(ConvertToOSPath("AppData/")),
	OnAction = ChoGGi_Funcs.Common.ExportColonistDataToCSV,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001450--[[Graphs Data]]),
	ActionMenubar = "ECM.Game.Export CSV",
	ActionId = ".Graphs Data",
	ActionIcon = "CommonAssets/UI/Menu/ConvertEnvironment.tga",
	RolloverText = Translate(302535920001452--[[Export command centre graph data to %sGraphs.csv.]]):format(ConvertToOSPath("AppData/")),
	OnAction = ChoGGi_Funcs.Common.ExportGraphsToCSV,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001501--[[Map Data]]),
	ActionMenubar = "ECM.Game.Export CSV",
	ActionId = ".Map Data",
	ActionIcon = "CommonAssets/UI/Menu/RandomMapPresetEditor.tga",
	RolloverText = Translate(302535920001502--[["Export map location data to %sMapData.csv (will take awhile).

Don't use in start new game screens (rating/topo will be messed up).
Difficulty Challenge/Named Location may not work on some saves (best to start a new game, or run from main menu)."]]):format(ConvertToOSPath("AppData/")),
	OnAction = ChoGGi_Funcs.Common.ExportMapDataToCSV,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001618--[[Map Data (Breakthroughs)]]),
	ActionMenubar = "ECM.Game.Export CSV",
	ActionId = ".Map Data (Breakthroughs)",
	ActionIcon = "CommonAssets/UI/Menu/LowerTerrainToLevel.tga",
	RolloverText = Translate(302535920001502--[["Export map location data to %sMapData.csv (will take awhile).

Don't use in start new game screens (rating/topo will be messed up).
Difficulty Challenge/Named Location may not work on some saves (best to start a new game, or run from main menu)."]]):format(ConvertToOSPath("AppData/"))
	.. "\n\n" .. T(302535920001619--[[This will take <color ChoGGi_red>longer</color> (about 15s).]]),
	OnAction = ChoGGi_Funcs.Common.ExportMapDataToCSV,
	setting_breakthroughs = true,
	setting_limit_count = 13,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(302535920000892--[[Screenshot]]),
	ActionMenubar = "ECM.Game",
	ActionId = ".Screenshot",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000657--[[Screenshot]]),
	ActionMenubar = "ECM.Game.Screenshot",
	ActionId = ".Screenshot",
	ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
	RolloverText = T(302535920000658--[[Write screenshot]]),
	OnAction = ChoGGi_Funcs.Menus.TakeScreenshot,
	setting_mask = 0,
	ActionShortcut = "-PrtScr",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000659--[[Screenshot Upsampled]]),
	ActionMenubar = "ECM.Game.Screenshot",
	ActionId = ".Screenshot Upsampled",
	ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
	RolloverText = T(302535920000660--[[Write screenshot upsampled]]),
	OnAction = ChoGGi_Funcs.Menus.TakeScreenshot,
	setting_mask = 1,
	ActionShortcut = "-Ctrl-PrtScr",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000661--[[Show Interface in Screenshots]]),
	ActionMenubar = "ECM.Game.Screenshot",
	ActionId = ".Show Interface in Screenshots",
	ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.ShowInterfaceInScreenshots,
			T(302535920000662--[[Do you want to see the interface in screenshots?]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.ShowInterfaceInScreenshots_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(302535920000893--[[Interface]]),
	ActionMenubar = "ECM.Game",
	ActionId = ".Interface",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920001737--[[Toggle Use All Loading Screens]]),
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".Toggle Use All Loading Screens",
	ActionIcon = "CommonAssets/UI/Menu/EnrichTerrainEditor.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.AllLoadingScreens,
			T(302535920001738--[[Some DLC replaces loading screens with their own, enable to use all of them.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.UseAllLoadingScreens_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001660--[[Toggle Vertical Cheat Menu]]),
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".Toggle Vertical Cheat Menu",
	ActionIcon = "CommonAssets/UI/Menu/HideUnselected.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.VerticalCheatMenu,
			T(302535920001661--[[Puts the menu down the side of the screen to save horizontal space for the info bar.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.VerticalCheatMenu_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001387--[[Toggle Signs]]),
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".Toggle Signs",
	ActionIcon = "CommonAssets/UI/Menu/ToggleMarkers.tga",
	RolloverText = T(302535920001388--[["Concrete, metal deposits, not working, etc..."]]),
	OnAction = ToggleSigns,
	ActionShortcut = "Ctrl-Alt-U",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000666--[[Toggle on-screen hints]]),
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".Toggle on-screen hints",
	ActionIcon = "CommonAssets/UI/Menu/HideUnselected.tga",
	RolloverText = function()
		return SettingState(
			HintsEnabled,
			T(302535920000667--[[Don't show hints for this game.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.OnScreenHints_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000668--[[Reset on-screen hints]]),
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".Reset on-screen hints",
	ActionIcon = "CommonAssets/UI/Menu/HideSelected.tga",
	RolloverText = T(302535920000669--[[Just in case you wanted to see them again (Hints that have been dismissed will be shown again).]]),
	OnAction = ChoGGi_Funcs.Menus.OnScreenHints_Reset,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000670--[[Toggle Show Hints]]),
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".Toggle Show Hints",
	ActionIcon = "CommonAssets/UI/Menu/set_debug_texture.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DisableHints,
			T(302535920000671--[[No more hints ever (Enable to disable all hints).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.ShowHints_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001653--[[Toggle Selection Panel Resize]]),
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".Selection Panel Resize",
	ActionIcon = "CommonAssets/UI/Menu/DisableAOMaps.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.StopSelectionPanelResize,
			T(302535920001654--[[Stops selection panel from shrinking (eg: dome).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SelectionPanelResize_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001655--[[Toggle Scroll Selection Panel]]),
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".Scroll Selection Panel",
	ActionIcon = "CommonAssets/UI/Menu/ListCollections.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.ScrollSelectionPanel,
			T(302535920001656--[[Add a scrollbar to larger selection panels (buildings, domes, etc).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.ScrollSelectionPanel_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001412--[[GUI Dock Side]]),
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".GUI Dock Side",
	ActionIcon = "CommonAssets/UI/Menu/DisableAOMaps.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.GUIDockSide and Translate(302535920001715--[[Right]]) or Translate(302535920001716--[[Left]]),
			T(302535920001413--[[Change which side (most) GUI menus are on.]])

		)
	end,
	OnAction = ChoGGi_Funcs.Menus.GUIDockSide_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000629--[[UI Transparency]]),
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".UI Transparency",
	ActionIcon = "CommonAssets/UI/Menu/set_last_texture.tga",
	RolloverText = T(302535920000630--[[Change the transparency of UI items (info panel, menu, pins).]]),
	OnAction = ChoGGi_Funcs.Menus.SetTransparencyUI,
	ActionShortcut = "Ctrl-F3",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000265--[[Toggle Pulsating Pins]]),
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".Toggle Pulsating Pins",
	ActionIcon = "CommonAssets/UI/Menu/JoinGame.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DisablePulsatingPinsMotion,
			T(302535920000335--[[When true pins will no longer do the pulsating motion (hover over to stop).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.PulsatingPins_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001665--[[Toggle Infopanel Toolbar Constrain]]),
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".Toggle Infopanel Toolbar Constrain",
	ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.InfopanelToolbarConstrain,
			T(302535920001666--[[Limits max width of infopanel toolbar buttons for those that have too many buttons (and they go off panel).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.InfopanelToolbarConstrain_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000631--[[UI Transparency Mouseover]]),
	ActionMenubar = "ECM.Game.Interface",
	ActionId = ".UI Transparency Mouseover",
	ActionIcon = "CommonAssets/UI/Menu/set_last_texture.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.TransparencyToggle,
			T(302535920000632--[[Toggle removing transparency on mouseover.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.TransparencyUI_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(911432559058--[[Light model]]),
	ActionMenubar = "ECM.Game",
	ActionId = ".Lightmodel",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(911432559058--[[Light model]]),
	ActionMenubar = "ECM.Game.Lightmodel",
	ActionId = ".Light Model",
	ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.Lightmodel,
			T(302535920000626--[[Changes the lighting mode (temporary or permanent).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.ChangeLightmodel,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001623--[[List Normal]]),
	ActionMenubar = "ECM.Game.Lightmodel",
	ActionId = ".List Normal",
	ActionIcon = "CommonAssets/UI/Menu/CountPointLights.tga",
	RolloverText = function()
		return SettingState(
			NormalLightmodelList,
			T(302535920001624--[[Changes the list of lightmodels to use (night/day/etc).]])
		)
	end,
	setting_func = SetNormalLightmodelList,
	setting_title = T(302535920001623--[[List Normal]]),
	OnAction = ChoGGi_Funcs.Menus.ChangeLightmodelList,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001625--[[List Disaster]]),
	ActionMenubar = "ECM.Game.Lightmodel",
	ActionId = ".List Disaster",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = function()
		return SettingState(
			DisasterLightmodelList,
			T(302535920001626--[[Overrides List Normal.]])
		)
	end,
	setting_func = SetDisasterLightmodelList,
	setting_title = T(302535920001625--[[List Disaster]]),
	OnAction = ChoGGi_Funcs.Menus.ChangeLightmodelList,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(904--[[Terrain]]),
	ActionMenubar = "ECM.Game",
	ActionId = ".Terrain",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000674--[[Terrain Editor Toggle]]),
	ActionMenubar = "ECM.Game.Terrain",
	ActionId = ".Terrain Editor Toggle",
	ActionIcon = "CommonAssets/UI/Menu/smooth_terrain.tga",
	RolloverText = T(302535920000675--[[Opens up the map editor with the brush tool visible.

Unfinished dev tool, don't use in regular saves!]]),
	OnAction = ChoGGi_Funcs.Common.TerrainEditor_Toggle,
	ActionShortcut = "Ctrl-Shift-T",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000485--[[Terrain Flatten Toggle]]),
	ActionMenubar = "ECM.Game.Terrain",
	ActionId = ".Terrain Flatten Toggle",
	ActionIcon = "CommonAssets/UI/Menu/FixUnderwaterEdges.tga",
	RolloverText = T(302535920000486--[[Use the shortcut to turn this on as it will use where your cursor is as the height to flatten to.

Use Shift + Arrow keys to change the height/radius.]]),
	OnAction = ChoGGi_Funcs.Menus.FlattenTerrain_Toggle,
	ActionShortcut = "Shift-F",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000623--[[Terrain Texture Change]]),
	ActionMenubar = "ECM.Game.Terrain",
	ActionId = ".Terrain Texture Change",
	ActionIcon = "CommonAssets/UI/Menu/terrain_type.tga",
	RolloverText = T(302535920000624--[[Green or Icy mars? Coming right up!
(don't forget a light model)]]),
	OnAction = ChoGGi_Funcs.Menus.TerrainTextureChange,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001237--[[Terrain Texture Remap]]),
	ActionMenubar = "ECM.Game.Terrain",
	ActionId = ".Terrain Texture Remap",
	ActionIcon = "CommonAssets/UI/Menu/terrain_type.tga",
	RolloverText = T(302535920001312--[["Instead of replacing all textures with one then re-adding stuff, this will remap existing textures."]]),
	OnAction = ChoGGi_Funcs.Menus.TerrainTextureRemap,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000864--[[Delete Large Rocks]]),
	ActionMenubar = "ECM.Game.Terrain",
	ActionId = ".Delete Large Rocks",
	ActionIcon = "CommonAssets/UI/Menu/selslope.tga",
	RolloverText = T(302535920001238--[[Removes rocks for that smooth map feel.]]),
	OnAction = ChoGGi_Funcs.Common.DeleteLargeRocks,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001366--[[Delete Small Rocks]]),
	ActionMenubar = "ECM.Game.Terrain",
	ActionId = ".Delete Small Rocks",
	ActionIcon = "CommonAssets/UI/Menu/selslope.tga",
	RolloverText = T(302535920001238--[[Removes rocks for that smooth map feel.]]),
	OnAction = ChoGGi_Funcs.Common.DeleteSmallRocks,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001259--[[Delete Bushes Trees]]),
	ActionMenubar = "ECM.Game.Terrain",
	ActionId = ".Delete Bushes Trees",
	ActionIcon = "CommonAssets/UI/Menu/selslope.tga",
	RolloverText = T(302535920001258--[[Cleans your Mars of alien shrubbery.]]),
	OnAction = ChoGGi_Funcs.Menus.DeleteBushesTrees,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001111--[[Whiter Rocks]]),
	ActionMenubar = "ECM.Game.Terrain",
	ActionId = ".Whiter Rocks",
	ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
	RolloverText = T(302535920001113--[[Helps the rocks blend in better when using the polar ground texture.]]),
	OnAction = ChoGGi_Funcs.Menus.WhiterRocks,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(302535920001685--[[Object]]),
	ActionMenubar = "ECM.Game",
	ActionId = ".Object",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000686--[[Auto Unpin Objects]]),
	ActionMenubar = "ECM.Game.Object",
	ActionId = ".Auto Unpin Objects",
	ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
	RolloverText = function()
		local value = ChoGGi.UserSettings.UnpinObjects or {}
		-- It can get large, so for this one we stick the description first.
		return T(302535920000687--[[Will automagically stop any of these objects from being added to the pinned list.]])
			.. "\n<color 100 255 100>" .. ValueToLuaCode(value) .. "</color>"
	end,
	OnAction = ChoGGi_Funcs.Menus.ShowAutoUnpinObjectList,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001292--[[List All Objects]]),
	ActionMenubar = "ECM.Game.Object",
	ActionId = ".List All Objects",
	ActionIcon = "CommonAssets/UI/Menu/select_objects.tga",
	RolloverText = T(302535920001293--[[A list of objects; double-click on one to select and move the camera to it.]]),
	OnAction = ChoGGi_Funcs.Menus.ListAllObjects,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000694--[[Set Opacity]]),
	ActionMenubar = "ECM.Game.Object",
	ActionId = ".Set Opacity",
	ActionIcon = "CommonAssets/UI/Menu/set_last_texture.tga",
	RolloverText = function()
		local obj = SelectedObj
		if IsValid(obj) then
			return SettingState(
				obj:GetOpacity(),
				T(302535920000695--[[Change the opacity of objects.]])
			)
		else
			return T(302535920000695--[[Change the opacity of objects.]])
		end
	end,
	OnAction = ChoGGi_Funcs.Menus.SetObjectOpacity,
	ActionShortcut = "F3",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001708--[[Color Modifier]]),
	ActionMenubar = "ECM.Game.Object",
	ActionId = ".Color Modifier",
	ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
	RolloverText = T(302535920000693--[[Select/mouse over an object to change the colours
Use Shift- or Ctrl- for random colours/reset colours.]]),
	OnAction = ChoGGi_Funcs.Common.CreateObjectListAndAttaches,
	ActionShortcut = "F6",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000678--[[Change Surface Signs To Materials]]),
	ActionMenubar = "ECM.Game.Object",
	ActionId = ".Change Surface Signs To Materials",
	ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
	RolloverText = T(302535920000679--[[Changes all the ugly immersion breaking signs to materials (reversible).]]),
	OnAction = ChoGGi_Funcs.Common.ChangeSurfaceSignsToMaterials,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000862--[[Object Planner]]),
	ActionMenubar = "ECM.Game.Object",
	ActionId = ".Object Planner",
	ActionIcon = "CommonAssets/UI/Menu/ShowOccluders.tga",
	RolloverText = T(302535920000863--[[Places fake construction site objects at mouse cursor (collision disabled).]]),
	OnAction = ChoGGi_Funcs.Common.EntitySpawner,
	setting_planning = true,
	ActionShortcut = "Ctrl-Shift-A",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000581--[[Toggle Object Collision]]),
	ActionMenubar = "ECM.Game.Object",
	ActionId = ".Toggle Object Collision",
	ActionIcon = "CommonAssets/UI/Menu/road_type.tga",
	RolloverText = T(302535920000582--[[Select an object and activate this to toggle collision (if you have a rover stuck in a dome).]]),
	OnAction = ChoGGi_Funcs.Common.CollisionsObject_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(302535920001355--[[Map]]),
	ActionMenubar = "ECM.Game",
	ActionId = ".Map",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000493--[[Change Map]]),
	ActionMenubar = "ECM.Game.Map",
	ActionId = ".Change Map",
	ActionIcon = "CommonAssets/UI/Menu/load_city.tga",
	RolloverText = T{302535920000494--[["Change map (options to pick commander, sponsor, etc...

Attention: If you get yellow ground areas; just load it again or try <str>."]],
		str = T(302535920001487--[[Reload Map]]),
	},
	OnAction = ChoGGi_Funcs.Menus.ChangeMap,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001651--[[Unlock Overview]]),
	ActionMenubar = "ECM.Game.Map",
	ActionId = ".Unlock Overview",
	ActionIcon = "CommonAssets/UI/Menu/load_city.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.UnlockOverview,
			T(302535920001652--[[Overview works on all maps.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.UnlockOverview_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001487--[[Reload Map]]),
	ActionMenubar = "ECM.Game.Map",
	ActionId = ".ReloadMap",
	ActionIcon = "CommonAssets/UI/Menu/reload.tga",
	RolloverText = T(302535920001488--[[Reloads map as new game.]]),
	OnAction = ChoGGi_Funcs.Menus.ReloadMap,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(5505--[[Game Speed]]),
	ActionMenubar = "ECM.Game",
	ActionId = ".Game Speed",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(5505--[[Game Speed]]),
	ActionMenubar = "ECM.Game.Game Speed",
	ActionId = ".Game Speed",
	ActionIcon = "CommonAssets/UI/Menu/SelectionToTemplates.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.mediumGameSpeed,
			T(302535920000703--[[Change the game speed (only for medium/fast, normal is normal).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetGameSpeed,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000356--[[Time Factor]]),
	ActionMenubar = "ECM.Game.Game Speed",
	ActionId = ".Time Factor",
	ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
	RolloverText = function()
		local time = GetTimeFactor()
		if time == 1000 then
			time = false
		end

		return SettingState(
			time,
			T(302535920000387--[[Change the time factor (not permanently); for ease of screenshots or something.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetTimeFactor,
}
