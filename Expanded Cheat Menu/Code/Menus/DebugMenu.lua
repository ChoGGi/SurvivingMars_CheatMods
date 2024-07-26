-- See LICENSE for terms

local ChoGGi_Funcs = ChoGGi_Funcs
local what_game = ChoGGi.what_game

local T = T
local Translate = ChoGGi_Funcs.Common.Translate
local SettingState = ChoGGi_Funcs.Common.SettingState
local Actions = ChoGGi.Temp.Actions
local c = #Actions

c = c + 1
Actions[c] = {ActionName = T(302535920000453--[[Reload LUA]]),
	ActionMenubar = "ECM.Debug",
	ActionId = ".Reload LUA",
	ActionIcon = "CommonAssets/UI/Menu/EV_OpenFirst.tga",
	RolloverText = T(302535920000454--[[Reloads code from any enabled mods (excluding ECM/Lib).]]),
	OnAction = ChoGGi_Funcs.Common.ReloadLua,
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001181--[[Used Terrain Textures]]),
	ActionMenubar = "ECM.Debug",
	ActionId = ".Used Terrain Textures",
	ActionIcon = "CommonAssets/UI/Menu/terrain_type.tga",
	RolloverText = T(302535920001198--[[Show a list of terrain textures used in current map.]]),
	OnAction = ChoGGi_Funcs.Common.UsedTerrainTextures,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001125--[[Test Locale File]]),
	ActionMenubar = "ECM.Debug",
	ActionId = ".Test Locale File",
	ActionIcon = "CommonAssets/UI/Menu/Subtitle.tga",
	RolloverText = T(302535920001136--[[Test a CSV for malformed strings (can cause freezing when loaded normally).]]),
	OnAction = ChoGGi_Funcs.Menus.TestLocaleFile,
}
c = c + 1
Actions[c] = {ActionName = T(302535920000069--[[Examine]]),
	ActionMenubar = "ECM.Debug",
	ActionId = ".Examine",
	ActionIcon = "CommonAssets/UI/Menu/PlayerInfo.tga",
	RolloverText = Translate(302535920000492--[[Opens the object examiner for the selected or moused-over obj.
Use %s to show a list of all objects in a radius around cursor.]]):format(ChoGGi_Funcs.Common.GetShortcut(".Keys.Examine Objects Shift")),
	OnAction = ChoGGi_Funcs.Menus.ExamineObject,
	ActionShortcut = what_game == "Mars" and "F4" or "Shift-F4",
	ActionBindable = true,
}
c = c + 1
Actions[c] = {ActionName = T(302535920000069--[[Examine]]) .. " " .. T(302535920000163--[[Radius]]),
	ActionMenubar = "ECM.Debug",
	ActionId = ".Examine Radius",
	ActionIcon = "CommonAssets/UI/Menu/ToggleStretchFactor.tga",
	RolloverText = function()
		return SettingState(
			"ChoGGi.UserSettings.ExamineObjectRadius",
			Translate(302535920000923--[[Set the radius used for %s examining.]]):format(ChoGGi_Funcs.Common.GetShortcut(".Keys.Examine Objects Shift"))
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.ExamineObjectRadius_Set,
	ActionBindable = true,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(302535920000035--[[Grids]]),
	ActionMenubar = "ECM.Debug",
	ActionId = ".Grids",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920001328--[[Show Grid Disable]]),
	ActionMenubar = "ECM.Debug.Grids",
	ActionId = ".Show Grid Disable",
	ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
	RolloverText = T(302535920001329--[[Hide the white ground grids.]]),
	OnAction = ChoGGi_Funcs.Menus.PostProcGrids,
	ActionSortKey = "-1Show Grid Disable",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000724--[[Show Grid Square]]),
	ActionMenubar = "ECM.Debug.Grids",
	ActionId = ".Show Grid Square",
	ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
	RolloverText = T(302535920000725--[[Square (use Disable to hide).]]),
	OnAction = ChoGGi_Funcs.Menus.PostProcGrids,
	grid_mask = "grid",
	ActionSortKey = "0Show Grid Square",
}

c = c + 1
Actions[c] = {ActionName = T(302535920001192--[[Show Grid 45 Square]]),
	ActionMenubar = "ECM.Debug.Grids",
	ActionId = ".Show Grid 45 Square",
	ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
	RolloverText = T(302535920001325--[[Square 45 (use Disable to hide).]]),
	OnAction = ChoGGi_Funcs.Menus.PostProcGrids,
	grid_mask = "grid45",
	ActionSortKey = "0Show Grid 45 Square",
}

c = c + 1
Actions[c] = {ActionName = T(302535920001326--[[Show Grid Hex]]),
	ActionMenubar = "ECM.Debug.Grids",
	ActionId = ".Show Grid Hex",
	ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
	RolloverText = T(302535920001327--[[Hex (use Disable to hide).]]),
	OnAction = ChoGGi_Funcs.Menus.PostProcGrids,
	grid_mask = "hexgrid",
	ActionSortKey = "0Show Grid Hex",
}

c = c + 1
Actions[c] = {ActionName = T(302535920001591--[[Show Grid Small]]),
	ActionMenubar = "ECM.Debug.Grids",
	ActionId = ".Show Grid Small",
	ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
	RolloverText = T(302535920001592--[[Small (use Disable to hide).]]),
	OnAction = ChoGGi_Funcs.Menus.PostProcGrids,
	grid_mask = "smallgrid",
	ActionSortKey = "0Show Grid Hex",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000499--[[Toggle Building Grid]]),
	ActionMenubar = "ECM.Debug.Grids",
	ActionId = ".Toggle Building Grid",
	ActionIcon = "CommonAssets/UI/Menu/ToggleWalk.tga",
	RolloverText = T(302535920000500--[["Show a hex grid around mouse: Green = pass/build, Yellow = no pass/build, Blue = pass/no build, Red = no pass/no build."]]),
	OnAction = ChoGGi_Funcs.Common.BuildableHexGrid,
	ActionShortcut = "Shift-F1",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001732--[[Toggle Mouse Grid Position]]),
	ActionMenubar = "ECM.Debug.Grids",
	ActionId = ".Toggle Building Grid Position",
	ActionIcon = "CommonAssets/UI/Menu/ToggleWalk.tga",
	RolloverText = T{302535920000220--[["Like <str>, but this shows hex positioning (offset or map, change in debug>grids)."]],
		str = T(302535920000499--[[Toggle Building Grid]]),
	},
	OnAction = ChoGGi_Funcs.Common.BuildableHexGrid,
	ActionShortcut = "Shift-F3",
	ActionBindable = true,
	setting_mask = "position",
}

c = c + 1
Actions[c] = {ActionName = T(302535920001297--[[Toggle Flight Grid]]),
	ActionMenubar = "ECM.Debug.Grids",
	ActionId = ".Toggle Flight Grid",
	ActionIcon = "CommonAssets/UI/Menu/ToggleCollisions.tga",
	RolloverText = T(302535920001298--[[Shows a square grid with terrain/objects shape.]]),
	OnAction = ChoGGi_Funcs.Menus.FlightGrid_Toggle,
	ActionShortcut = "Shift-F2",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001417--[[Follow Mouse Grid Size]]),
	ActionMenubar = "ECM.Debug.Grids",
	ActionId = ".Follow Mouse Grid Size",
	ActionIcon = "CommonAssets/UI/Menu/ToggleWalk.tga",
	RolloverText = function()
		return SettingState(
			"ChoGGi.UserSettings.DebugGridSize",
			T(302535920001418--[[Sets the size of the Building/Flight grid.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.BuildableHexGridSettings,
	setting_mask = "DebugGridSize",
	ActionSortKey = "9Follow Mouse Grid Size",
}

c = c + 1
Actions[c] = {ActionName = T(302535920001419--[[Follow Mouse Grid Trans]]),
	ActionMenubar = "ECM.Debug.Grids",
	ActionId = ".Follow Mouse Grid Trans",
	ActionIcon = "CommonAssets/UI/Menu/ToggleWalk.tga",
	RolloverText = function()
		return SettingState(
			"ChoGGi.UserSettings.DebugGridOpacity",
			T(302535920001420--[[How transparent the Building grid is.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.BuildableHexGridSettings,
	setting_mask = "DebugGridOpacity",
	ActionSortKey = "9Follow Mouse Grid Trans",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000680--[[Follow Mouse Grid Position]]),
	ActionMenubar = "ECM.Debug.Grids",
	ActionId = ".Follow Mouse Grid Position",
	ActionIcon = "CommonAssets/UI/Menu/ToggleWalk.tga",
	RolloverText = function()
		return SettingState(
			"ChoGGi.UserSettings.DebugGridPosition",
			T(302535920000681--[[Type of positioning to show (relative or absolute).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.BuildableHexGridSettings,
	setting_mask = "DebugGridPosition",
	ActionSortKey = "9Follow Mouse Grid Position",
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(302535920001175--[[Debug FX]]),
	ActionMenubar = "ECM.Debug",
	ActionId = ".Debug FX",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920001175--[[Debug FX]]),
	ActionMenubar = "ECM.Debug.Debug FX",
	ActionId = ".Debug FX",
	ActionIcon = "CommonAssets/UI/Menu/FXEditor.tga",
	RolloverText = function()
		return SettingState(
			DebugFX,
			T(302535920001176--[[Toggle showing FX debug info in console.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.DebugFX_Toggle,
	setting_name = "DebugFX",
	setting_msg = T(302535920001175),
}

c = c + 1
Actions[c] = {ActionName = T(302535920001184--[[Particles]]),
	ActionMenubar = "ECM.Debug.Debug FX",
	ActionId = ".Particles",
	ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
	RolloverText = function()
		return SettingState(
			DebugFXParticles,
			T(302535920001176--[[Toggle showing FX debug info in console.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.DebugFX_Toggle,
	setting_name = "DebugFXParticles",
	setting_msg = T(302535920001184),
}

c = c + 1
Actions[c] = {ActionName = T(302535920001368--[[Sound FX]]),
	ActionMenubar = "ECM.Debug.Debug FX",
	ActionId = ".Sound FX",
	ActionIcon = "CommonAssets/UI/Menu/DisableEyeSpec.tga",
	RolloverText = function()
		return SettingState(
			DebugFXSound,
			T(302535920001176--[[Toggle showing FX debug info in console.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.DebugFX_Toggle,
	setting_name = "DebugFXSound",
	setting_msg = T(302535920001368),
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(302535920000467--[[Path Markers]]),
	ActionMenubar = "ECM.Debug",
	ActionId = ".Path Markers",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000467--[[Path Markers]]) .. " " .. T(302535920001382--[[Game Time]]),
	ActionMenubar = "ECM.Debug.Path Markers",
	ActionId = ".Game Time",
	ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
	RolloverText = T(302535920000462--[[Maps paths in real time]]) .. " " .. T(302535920000874--[[(see "Path Markers" to mark more than one at a time).]]),
	OnAction = ChoGGi_Funcs.Common.SetPathMarkersGameTime,
	ActionShortcut = "Ctrl-Numpad .",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000467--[[Path Markers]]),
	ActionMenubar = "ECM.Debug.Path Markers",
	ActionId = ".Path Markers",
	ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
	RolloverText = T(302535920000468--[[Shows the selected unit path or show a list to add/remove paths for rovers, drones, colonists, or shuttles.]]),
	OnAction = ChoGGi_Funcs.Menus.SetPathMarkers,
	ActionShortcut = "Ctrl-Numpad 0",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001527--[[Building Path Markers]]),
	ActionMenubar = "ECM.Debug.Path Markers",
	ActionId = ".Building Markers",
	ActionIcon = "CommonAssets/UI/Menu/ToggleCutSmoothTrans.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.Temp.BuildingPathMarkers_Toggle,
			T(302535920001528--[[Show inside waypoints colonists take to move around (not all buildings).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.BuildingPathMarkers_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(3578--[[Framerate Counter]]),
	ActionMenubar = "ECM.Debug",
	ActionId = ".Framerate Counter",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000926--[[Toggle]]),
	ActionMenubar = "ECM.Debug.Framerate Counter",
	ActionId = ".Toggle",
	ActionIcon = "CommonAssets/UI/Menu/CountPointLights.tga",
	RolloverText = function()
		local c = hr.FpsCounter
		return SettingState(
			c == 0 and T(847439380056--[[Disabled]])
				or c == 1 and T(3558--[[FPS]])
				or c == 2 and T(3559--[[ms]]),
			T(302535920000905--[["Switch between FPS, ms, and off.
This is temporary, use Options>Video>Framerate Counter to permanently save it."]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetFrameCounter,
	ActionSortKey = "-1",
}

c = c + 1
Actions[c] = {ActionName = T(302535920001698--[[Up]]) .. " " .. T(302535920001716--[[Left]]),
	ActionMenubar = "ECM.Debug.Framerate Counter",
	ActionId = ".Up Left",
	ActionIcon = "CommonAssets/UI/Menu/change_height_up.tga",
	OnAction = ChoGGi_Funcs.Menus.SetFrameCounterLocation,
	setting_mask = 0,
}
c = c + 1
Actions[c] = {ActionName = T(302535920001698--[[Up]]) .. " " .. T(302535920001715--[[Right]]),
	ActionMenubar = "ECM.Debug.Framerate Counter",
	ActionId = ".Up Right",
	ActionIcon = "CommonAssets/UI/Menu/change_height_up.tga",
	OnAction = ChoGGi_Funcs.Menus.SetFrameCounterLocation,
	setting_mask = 1,
	RolloverText = T(1000121--[[Default]]),
}
c = c + 1
Actions[c] = {ActionName = T(302535920001699--[[Down]]) .. " " .. T(302535920001716--[[Left]]),
	ActionMenubar = "ECM.Debug.Framerate Counter",
	ActionId = ".Down Left",
	ActionIcon = "CommonAssets/UI/Menu/change_height_down.tga",
	OnAction = ChoGGi_Funcs.Menus.SetFrameCounterLocation,
	setting_mask = 2,
}
c = c + 1
Actions[c] = {ActionName = T(302535920001699--[[Down]]) .. " " .. T(302535920001715--[[Right]]),
	ActionMenubar = "ECM.Debug.Framerate Counter",
	ActionId = ".Down Right",
	ActionIcon = "CommonAssets/UI/Menu/change_height_down.tga",
	OnAction = ChoGGi_Funcs.Menus.SetFrameCounterLocation,
	setting_mask = 3,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(302535920001683--[[Entity]]),
	ActionMenubar = "ECM.Debug",
	ActionId = ".Entity",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000495--[[Particles Reload]]),
	ActionMenubar = "ECM.Debug.Entity",
	ActionId = ".Particles Reload",
	ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
	RolloverText = T(302535920000496--[["Reloads particles from ""Data/Particles""..."]]),
	OnAction = ChoGGi_Funcs.Menus.ParticlesReload,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000449--[[Entity Spots Toggle]]),
	ActionMenubar = "ECM.Debug.Entity",
	ActionId = ".Entity Spots Toggle",
	ActionIcon = "CommonAssets/UI/Menu/ShowAll.tga",
	RolloverText = function()
		local obj = SelectedObj
		return SettingState(
			obj and obj.ChoGGi_ShowAttachSpots,
			T(302535920000450--[[Toggle showing attachment spots on selected object.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Common.EntitySpots_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000235--[[Entity Spots]]),
	ActionMenubar = "ECM.Debug.Entity",
	ActionId = ".Entity Spots",
	ActionIcon = "CommonAssets/UI/Menu/ListCollections.tga",
	RolloverText = T(302535920001445--[[Shows list of attaches for use with .ent files.]]),
	OnAction = ChoGGi_Funcs.Common.ExamineEntSpots,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000475--[[Entity Spawner]]),
	ActionMenubar = "ECM.Debug.Entity",
	ActionId = ".Object Spawner",
	ActionIcon = "CommonAssets/UI/Menu/add_water.tga",
	RolloverText = T(302535920000476--[["Shows list of entity objects with option to spawn at mouse cursor."]]),
	OnAction = ChoGGi_Funcs.Common.EntitySpawner,
	ActionShortcut = "Ctrl-Shift-S",
	ActionBindable = true,
	IgnoreRepeated = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001491--[[View All Entities]]),
	ActionMenubar = "ECM.Debug.Entity",
	ActionId = ".View All Entities",
	ActionIcon = "CommonAssets/UI/Menu/ApplyWaterMarkers.tga",
	RolloverText = T(302535920001492--[[Loads a blank map and places all entities in it.]]),
	OnAction = ChoGGi_Funcs.Menus.ViewAllEntities,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001458--[[Material Properties]]),
	ActionMenubar = "ECM.Debug.Entity",
	ActionId = ".Material Properties",
	ActionIcon = "CommonAssets/UI/Menu/ConvertEnvironment.tga",
	RolloverText = T(302535920001459--[[Shows list of material settings for use with .mtl files.]]),
	OnAction = ChoGGi_Funcs.Common.GetMaterialProperties,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000682--[[Change Entity]]),
	ActionMenubar = "ECM.Debug.Entity",
	ActionId = ".Change Entity",
	ActionIcon = "CommonAssets/UI/Menu/ConvertEnvironment.tga",
	RolloverText = T(302535920000683--[[Changes the entity of selected object, all of same type or all of same type in selected object's dome.]]),
	OnAction = ChoGGi_Funcs.Menus.ChangeEntity,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000684--[[Change Entity Scale]]),
	ActionMenubar = "ECM.Debug.Entity",
	ActionId = ".Change Entity Scale",
	ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
	RolloverText = function()
		local obj = SelectedObj
		return obj and SettingState(
			obj:GetScale(),
			T(302535920000685--[[You want them big, you want them small; have at it.]])
		) or T(302535920000685)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetEntityScale,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(302535920001367--[[Toggles]]),
	ActionMenubar = "ECM.Debug",
	ActionId = ".Toggles",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920001205--[[Skip Missing Mods]]),
	ActionMenubar = "ECM.Debug.Toggles",
	ActionId = ".Skip Missing Mods",
	ActionIcon = "CommonAssets/UI/Menu/JoinGame.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SkipMissingMods,
			T(302535920001657--[[Stops confirmation dialog about missing mods when loading saved games.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SkipMissingMods_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001728--[[Skip Incompatible Mods]]),
	ActionMenubar = "ECM.Debug.Toggles",
	ActionId = ".Skip Incompatible Mods",
	ActionIcon = "CommonAssets/UI/Menu/JoinGame.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SkipIncompatibleModsMsg,
			T(302535920001729--[[Get rid of "This savegame was loaded in the past without required mods or with an incompatible game version.".]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SkipIncompatibleModsMsg_Toggle,
}


c = c + 1
Actions[c] = {ActionName = T(302535920001658--[[Skip Missing DLC]]),
	ActionMenubar = "ECM.Debug.Toggles",
	ActionId = ".Skip Missing DLC",
	ActionIcon = "CommonAssets/UI/Menu/JoinGame.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SkipMissingDLC,
			T(302535920001659--[[Stops confirmation dialog about missing DLC when loading saved games.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SkipMissingDLC_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001066--[[InfoPanel Dialog]]),
	ActionMenubar = "ECM.Debug.Toggles",
	ActionId = ".InfoPanel Dialog",
	ActionIcon = "CommonAssets/UI/Menu/EnrichTerrainEditor.tga",
	RolloverText = T(302535920001451--[[Center the InfoPanel dialog (selection panel).]]),
	OnAction = ChoGGi_Funcs.Menus.InfoPanelDlg_Toggle,
	ActionShortcut = "Ctrl-Shift-I",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001649--[[Toggle Interface]]),
	ActionMenubar = "ECM.Debug.Toggles",
	ActionId = ".Toggle Interface",
	ActionIcon = "CommonAssets/UI/Menu/EnrichTerrainEditor.tga",
	RolloverText = T(302535920001650--[[Toggle all interface elements for screenshots/etc.]]),
	OnAction = ChoGGi_Funcs.Menus.Interface_Toggle,
	ActionShortcut = "Ctrl-Alt-I",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000049--[[Loading Screen Log]]),
	ActionMenubar = "ECM.Debug.Toggles",
	ActionId = ".Loading Screen Log",
	ActionIcon = "CommonAssets/UI/Menu/AreaProperties.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.LoadingScreenLog,
			T(302535920001621--[["Be able to see the console log (and other dialogs) during the loading screen.

Warning: Leaves "Welcome to Mars" msg onscreen till map is loaded."]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.LoadingScreenLog_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001498--[[Examine Persist Errors]]),
	ActionMenubar = "ECM.Debug.Toggles",
	ActionId = ".Examine Persist Errors",
	ActionIcon = "CommonAssets/UI/Menu/JoinGame.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DebugPersistSaves,
			T(302535920001499--[[Shows an examine dialog with any persist errors when saving.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.ExaminePersistErrors_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001314--[[Toggle Render]]),
	ActionMenubar = "ECM.Debug.Toggles",
	ActionId = ".Toggle Render",
	ActionIcon = "CommonAssets/UI/Menu/Shot.tga",
	RolloverText = T(302535920001315--[[Toggle rendering certain stuff.]]),
	OnAction = ChoGGi_Funcs.Menus.Render_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000451--[[Measure Tool]]),
	ActionMenubar = "ECM.Debug.Toggles",
	ActionId = ".Measure Tool",
	ActionIcon = "CommonAssets/UI/Menu/MeasureTool.tga",
	RolloverText = function()
		return SettingState(
			MeasureTool.enabled,
			T(302535920000452--[[Measures stuff (press again to remove the lines).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.MeasureTool_Toggle,
	ActionShortcut = "Ctrl-M",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000459--[[Anim Debug Toggle]]),
	ActionMenubar = "ECM.Debug.Toggles",
	ActionId = ".Anim Debug Toggle",
	ActionIcon = "CommonAssets/UI/Menu/CameraEditor.tga",
	RolloverText = function()
		local obj = SelectedObj
		return obj and SettingState(
			obj.ChoGGi_ShowAnimDebug,
			T(302535920000460--[[Attaches text to each object showing animation info (or just to selected object).]])
		) or SettingState(
			ChoGGi.Temp.ShowAnimDebug,
			T(302535920000460)
		)
	end,
	OnAction = ChoGGi_Funcs.Common.ShowAnimDebug_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000479--[[Toggle Editor]]),
	ActionMenubar = "ECM.Debug.Toggles",
	ActionId = ".Toggle Editor",
	ActionIcon = "CommonAssets/UI/Menu/SelectionEditor.tga",
	RolloverText = T(302535920000480--[["Some sort of editor the devs left buried in code.
Select object(s) then hold ctrl/shift/alt and drag mouse.
click+drag for multiple selection.

It's not as if domes need to be where you placed them (people will just ignore if you move the domes all to one place for that airy mars look).


WARNING: Buggy! I kinda got it working, but expect issues!"]]),
	OnAction = ChoGGi_Funcs.Common.Editor_Toggle,
	ActionShortcut = "Ctrl-Shift-E",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000061--[[Place Objects]]),
	ActionMenubar = "ECM.Debug.Toggles",
	ActionId = ".Place Objects",
	ActionIcon = "CommonAssets/UI/Menu/enrich_terrain.tga",
	RolloverText = T(302535920000062--[[Opens editor mode with the place objects dialog.]]),
	OnAction = ChoGGi_Funcs.Common.PlaceObjects_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001310--[[DTM Slots Display]]),
	ActionMenubar = "ECM.Debug.Toggles",
	ActionId = ".DTM Slots Display",
	ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi_Funcs.Common.GetDialogECM("ChoGGi_DlgDTMSlots") and true,
			T(302535920001311--[[Show DTM slots display]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.DTMSlotsDlg_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(302535920001685--[[Object]]),
	ActionMenubar = "ECM.Debug",
	ActionId = ".Object",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920001547--[[Visible Objects]]),
	ActionMenubar = "ECM.Debug.Object",
	ActionId = ".Visible Objects",
	ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
	RolloverText = T(302535920001548--[[Shows list of objects rendered in the current frame.]]),
	OnAction = ChoGGi_Funcs.Menus.ListVisibleObjects,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000455--[[Object Cloner]]),
	ActionMenubar = "ECM.Debug.Object",
	ActionId = ".Object Cloner",
	ActionIcon = "CommonAssets/UI/Menu/EnrichTerrainEditor.tga",
	RolloverText = T(302535920000456--[[Clones selected/moused over object to current mouse position (should probably use the shortcut key rather than this menu item).]]),
	OnAction = ChoGGi_Funcs.Common.ObjectCloner,
	ActionShortcut = "Shift-Q",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000457--[[Anim State Set]]),
	ActionMenubar = "ECM.Debug.Object",
	ActionId = ".Anim State Set",
	ActionIcon = "CommonAssets/UI/Menu/UnlockCamera.tga",
	RolloverText = T(302535920000458--[[Make selected object dance on command.]]),
	OnAction = ChoGGi_Funcs.Common.SetAnimState,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001707--[[Edit]]) .. " " .. T(302535920001685--[[Object]]),
	ActionMenubar = "ECM.Debug.Object",
	ActionId = ".Object Manipulator",
	ActionIcon = "CommonAssets/UI/Menu/SaveMapEntityList.tga",
	RolloverText = T(302535920000472--[[Manipulate objects (selected or under mouse cursor)]]),
	OnAction = ChoGGi_Funcs.Common.OpenInObjectEditorDlg,
	ActionShortcut = "F5",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000481--[[Open In Ged Object Editor]]),
	ActionMenubar = "ECM.Debug.Object",
	ActionId = ".Open In Ged Object Editor",
	ActionIcon = "CommonAssets/UI/Menu/SelectionEditor.tga",
	RolloverText = T(302535920000482--[["Shows some info about the object, and so on. Some buttons may make camera wonky (use Game>Camera>Reset)."]]),
	OnAction = ChoGGi_Funcs.Menus.OpenInGedObjectEditor,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001685--[[Object]]) .. " " .. T(302535920001476--[[Edit Flags]]),
	ActionMenubar = "ECM.Debug.Object",
	ActionId = ".Object Edit Flags",
	ActionIcon = "CommonAssets/UI/Menu/JoinGame.tga",
	RolloverText = T(302535920001447--[[Show and toggle the list of flags for selected object.]]),
	OnAction = ChoGGi_Funcs.Common.ObjFlagsList,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000129--[[Set]]) .. " " .. T(302535920001184--[[Particles]]),
	ActionMenubar = "ECM.Debug.Object",
	ActionId = ".Set Particles",
	ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
	RolloverText = T(302535920001421--[[Shows a list of particles you can use on the selected obj.]]),
	OnAction = ChoGGi_Funcs.Common.SetParticles,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000487--[[Delete All Of Selected Object]]),
	ActionMenubar = "ECM.Debug.Object",
	ActionId = ".Delete All Of Selected Object",
	ActionIcon = "CommonAssets/UI/Menu/delete_objects.tga",
	RolloverText = T(302535920000488--[[Will ask for confirmation beforehand (will not delete domes).]]),
	OnAction = ChoGGi_Funcs.Menus.DeleteAllSelectedObjects,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000489--[[Delete Object(s)]]),
	ActionMenubar = "ECM.Debug.Object",
	ActionId = ".Delete Object(s)",
	ActionIcon = "CommonAssets/UI/Menu/delete_objects.tga",
	RolloverText = T(302535920000490--[["Deletes selected object or object under mouse cursor (most objs, not all)."]]),
	OnAction = ChoGGi_Funcs.Menus.DeleteObject,
	ActionShortcut = "Ctrl-Alt-Shift-D",
	ActionBindable = true,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(948928900281--[[Story Bits]]),
	ActionMenubar = "ECM.Debug",
	ActionId = ".Story Bits",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	RolloverText = T(302535920000935--[[Random mini missions that happen while playing.]]),
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(186760604064--[[Test]]) .. " " .. T(948928900281--[[Story Bits]]),
	ActionMenubar = "ECM.Debug.Story Bits",
	ActionId = ".Test Story Bits",
	ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
	RolloverText = T(302535920001359--[[Test activate a story bit.]]),
	OnAction = ChoGGi_Funcs.Menus.TestStoryBits,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000978--[[Skip Story Bits]]),
	ActionMenubar = "ECM.Debug.Story Bits",
	ActionId = ".Skip Story Bits",
	ActionIcon = "CommonAssets/UI/Menu/JoinGame.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SkipStoryBitsDialogs,
			T(302535920000980--[["When a story bit appears; always select first option after slight delay."]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SkipStoryBitsDialogs_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000421--[[Override Condition Prereqs]]),
	ActionMenubar = "ECM.Debug.Story Bits",
	ActionId = ".Override Condition Prereqs",
	ActionIcon = "CommonAssets/UI/Menu/CountPointLights.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.OverrideConditionPrereqs,
			T(302535920000919--[[All storybit/negotiation/etc options are enabled.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.OverrideConditionPrereqs_Toggle,
}

