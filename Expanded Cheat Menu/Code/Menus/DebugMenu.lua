-- See LICENSE for terms

function OnMsg.ClassesGenerate()
	local Translate = ChoGGi.ComFuncs.Translate
	local Strings = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local c = #Actions

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001181--[[Used Terrain Textures--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Used Terrain Textures",
		ActionIcon = "CommonAssets/UI/Menu/terrain_type.tga",
		RolloverText = Strings[302535920001198--[[Show a list of terrain textures used in current map.--]]],
		OnAction = ChoGGi.ComFuncs.ExUsedTerrainTextures,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001125--[[Test Locale File--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Test Locale File",
		ActionIcon = "CommonAssets/UI/Menu/Subtitle.tga",
		RolloverText = Strings[302535920001136--[[Test a CSV for malformed strings (can cause freezing when loaded normally).--]]],
		OnAction = ChoGGi.MenuFuncs.TestLocaleFile,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001547--[[Visible Objects--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Visible Objects",
		ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
		RolloverText = Strings[302535920001548--[[Shows list of objects rendered in the current frame.--]]],
		OnAction = ChoGGi.MenuFuncs.ListVisibleObjects,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001498--[[Examine Persist Errors--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Examine Persist Errors",
		ActionIcon = "CommonAssets/UI/Menu/JoinGame.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.DebugPersistSaves,
				Strings[302535920001499--[[Shows an examine dialog with any persist errors when saving (needs ECM HelperMod).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.ExaminePersistErrors_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001458--[[Material Properties--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Material Properties",
		ActionIcon = "CommonAssets/UI/Menu/ConvertEnvironment.tga",
		RolloverText = Strings[302535920001459--[[Shows list of material settings for use with .mtl files.--]]],
		OnAction = ChoGGi.ComFuncs.GetMaterialProperties,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001491--[[View All Entities--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".View All Entities",
		ActionIcon = "CommonAssets/UI/Menu/ApplyWaterMarkers.tga",
		RolloverText = Strings[302535920001492--[[Loads a blank map and places all entities in it.--]]],
		OnAction = ChoGGi.MenuFuncs.ViewAllEntities,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001416--[[Force--]]] .. " " .. Translate(948928900281--[[Story Bits--]]),
		ActionMenubar = "ECM.Debug",
		ActionId = ".Force Story Bits",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = Strings[302535920001359--[[Start or display the msg from a story bit.--]]],
		OnAction = ChoGGi.MenuFuncs.ForceStoryBits,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000129--[[Set--]]] .. " " .. Strings[302535920001184--[[Particles--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Set Particles",
		ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
		RolloverText = Strings[302535920001421--[[Shows a list of particles you can use on the selected obj.--]]],
		OnAction = ChoGGi.ComFuncs.SetParticles,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001314--[[Toggle Render--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Toggle Render",
		ActionIcon = "CommonAssets/UI/Menu/Shot.tga",
		RolloverText = Strings[302535920001315--[[Toggle rendering certain stuff.--]]],
		OnAction = ChoGGi.MenuFuncs.Render_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001310--[[DTM Slots Display--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".DTM Slots Display",
		ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				GetDialog("DTMSlotsDlg") and true,
				Strings[302535920001311--[[Show DTM slots display--]]]
			)
		end,
		OnAction = ChoGGi.ComFuncs.OpenInDTMSlotsDlg,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000449--[[Attach Spots Toggle--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Attach Spots Toggle",
		ActionIcon = "CommonAssets/UI/Menu/ShowAll.tga",
		RolloverText = function()
			local obj = SelectedObj
			return ChoGGi.ComFuncs.SettingState(
				obj and obj.ChoGGi_ShowAttachSpots,
				Strings[302535920000450--[[Toggle showing attachment spots on selected object.--]]]
			)
		end,
		OnAction = ChoGGi.ComFuncs.AttachSpots_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000235--[[Attach Spots List--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Attach Spots List",
		ActionIcon = "CommonAssets/UI/Menu/ListCollections.tga",
		RolloverText = Strings[302535920001445--[[Shows list of attaches for use with .ent files.--]]],
		OnAction = ChoGGi.ComFuncs.ExamineEntSpots,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000451--[[Measure Tool--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Measure Tool",
		ActionIcon = "CommonAssets/UI/Menu/MeasureTool.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				MeasureTool.enabled,
				Strings[302535920000452--[[Measures stuff (press again to remove the lines).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.MeasureTool_Toggle,
		ActionShortcut = "Ctrl-M",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000453--[[Reload Lua--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Reload Lua",
		ActionIcon = "CommonAssets/UI/Menu/EV_OpenFirst.tga",
		RolloverText = Strings[302535920000454--[[Fires some commands to reload lua files (use OnMsg.ReloadLua() to listen for it).--]]],
		OnAction = ChoGGi.MenuFuncs.ReloadLua,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000455--[[Object Cloner--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Object Cloner",
		ActionIcon = "CommonAssets/UI/Menu/EnrichTerrainEditor.tga",
		RolloverText = Strings[302535920000456--[[Clones selected/moused over object to current mouse position (should probably use the shortcut key rather than this menu item).--]]],
		OnAction = ChoGGi.MenuFuncs.ObjectCloner,
		ActionShortcut = "Shift-Q",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000457--[[Anim State Set--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Anim State Set",
		ActionIcon = "CommonAssets/UI/Menu/UnlockCamera.tga",
		RolloverText = Strings[302535920000458--[[Make object dance on command.--]]],
		OnAction = ChoGGi.ComFuncs.SetAnimState,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000459--[[Anim Debug Toggle--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Anim Debug Toggle",
		ActionIcon = "CommonAssets/UI/Menu/CameraEditor.tga",
		RolloverText = function()
			local obj = SelectedObj
			return obj and ChoGGi.ComFuncs.SettingState(
				obj.ChoGGi_ShowAnimDebug,
				Strings[302535920000460--[[Attaches text to each object showing animation info (or just to selected object).--]]]
			) or ChoGGi.ComFuncs.SettingState(
				ChoGGi.Temp.ShowAnimDebug,
				Strings[302535920000460]
			)
		end,
		OnAction = ChoGGi.ComFuncs.ShowAnimDebug_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Translate(327465361219--[[Edit--]]) .. " " .. Translate(298035641454--[[Object--]]),
		ActionMenubar = "ECM.Debug",
		ActionId = ".Object Manipulator",
		ActionIcon = "CommonAssets/UI/Menu/SaveMapEntityList.tga",
		RolloverText = Strings[302535920000472--[[Manipulate objects (selected or under mouse cursor)--]]],
		OnAction = ChoGGi.ComFuncs.OpenInObjectEditorDlg,
		ActionShortcut = "F5",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000475--[[Entity Spawner--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Object Spawner",
		ActionIcon = "CommonAssets/UI/Menu/add_water.tga",
		RolloverText = Strings[302535920000476--[["Shows list of objects, and spawns at mouse cursor."--]]],
		OnAction = ChoGGi.ComFuncs.EntitySpawner,
		ActionShortcut = "Ctrl-Shift-Strings",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000479--[[Toggle Editor--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Toggle Editor",
		ActionIcon = "CommonAssets/UI/Menu/SelectionEditor.tga",
		RolloverText = Strings[302535920000480--[["Select object(s) then hold ctrl/shift/alt and drag mouse.
	click+drag for multiple selection.

	It's not as if domes need to be where you placed them (people will just ignore if you move the domes all to one place for that airy mars look)."--]]],
		OnAction = ChoGGi.ComFuncs.Editor_Toggle,
		ActionShortcut = "Ctrl-Shift-E",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000481--[[Open In Ged Object Editor--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Open In Ged Object Editor",
		ActionIcon = "CommonAssets/UI/Menu/SelectionEditor.tga",
		RolloverText = Strings[302535920000482--[["Shows some info about the object, and so on. Some buttons may make camera wonky (use Game>Camera>Reset)."--]]],
		OnAction = ChoGGi.MenuFuncs.OpenInGedObjectEditor,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000491--[[Examine Object--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Examine Object",
		ActionIcon = "CommonAssets/UI/Menu/PlayerInfo.tga",
		RolloverText = Strings[302535920000492--[[Opens the object examiner for the selected or moused-over obj.--]]],
		OnAction = ChoGGi.MenuFuncs.ExamineObject,
		ActionShortcut = "F4",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000495--[[Particles Reload--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Particles Reload",
		ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
		RolloverText = Strings[302535920000496--[[Reloads particles from "Data/Particles"...--]]],
		OnAction = ChoGGi.MenuFuncs.ParticlesReload,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000581--[[Toggle Object Collision--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Toggle Object Collision",
		ActionIcon = "CommonAssets/UI/Menu/road_type.tga",
		RolloverText = Strings[302535920000582--[[Select an object and activate this to toggle collision (if you have a rover stuck in a dome).--]]],
		OnAction = ChoGGi.ComFuncs.CollisionsObject_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Translate(298035641454--[[Object--]]) .. " " .. Strings[302535920001476--[[Flags--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Object Flags",
		ActionIcon = "CommonAssets/UI/Menu/JoinGame.tga",
		RolloverText = Strings[302535920001447--[[Shows list of flags set for selected object.--]]],
		OnAction = ChoGGi.ComFuncs.ObjFlagsList,
	}

	local str_Debug_Grids = "ECM.Debug.Grids"
	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000035--[[Grids--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Grids",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Grids",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001328--[[Show Grid Disable--]]],
		ActionMenubar = str_Debug_Grids,
		ActionId = ".Show Grid Disable",
		ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
		RolloverText = Strings[302535920001329--[[Hide the white ground grids.--]]],
		OnAction = ChoGGi.MenuFuncs.PostProcGrids,
		ActionSortKey = "-1Show Grid Disable",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000724--[[Show Grid Square--]]],
		ActionMenubar = str_Debug_Grids,
		ActionId = ".Show Grid Square",
		ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
		RolloverText = Strings[302535920000725--[[Square (use Disable to hide).--]]],
		OnAction = ChoGGi.MenuFuncs.PostProcGrids,
		grid_mask = "grid",
		ActionSortKey = "0Show Grid Square",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001192--[[Show Grid 45 Square--]]],
		ActionMenubar = str_Debug_Grids,
		ActionId = ".Show Grid 45 Square",
		ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
		RolloverText = Strings[302535920001325--[[Square 45 (use Disable to hide).--]]],
		OnAction = ChoGGi.MenuFuncs.PostProcGrids,
		grid_mask = "grid45",
		ActionSortKey = "0Show Grid 45 Square",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001326--[[Show Grid Hex--]]],
		ActionMenubar = str_Debug_Grids,
		ActionId = ".Show Grid Hex",
		ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
		RolloverText = Strings[302535920001327--[[Hex (use Disable to hide).--]]],
		OnAction = ChoGGi.MenuFuncs.PostProcGrids,
		grid_mask = "hexgrid",
		ActionSortKey = "0Show Grid Hex",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001297--[[Toggle Flight Grid--]]],
		ActionMenubar = str_Debug_Grids,
		ActionId = ".Toggle Flight Grid",
		ActionIcon = "CommonAssets/UI/Menu/ToggleCollisions.tga",
		RolloverText = Strings[302535920001298--[[Shows a square grid with terrain/objects shape.--]]],
		OnAction = ChoGGi.MenuFuncs.FlightGrid_Toggle,
		ActionShortcut = "Shift-F2",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000499--[[Toggle Building Grid--]]],
		ActionMenubar = str_Debug_Grids,
		ActionId = ".Toggle Building Grid",
		ActionIcon = "CommonAssets/UI/Menu/ToggleWalk.tga",
		RolloverText = Strings[302535920000500--[["Show a hex grid around mouse: Green = pass/build, Yellow = no pass/build, Blue = pass/no build, Red = no pass/no build."--]]],
		OnAction = ChoGGi.MenuFuncs.debug_build_grid,
		ActionShortcut = "Shift-F1",
		ActionBindable = true,
		ActionSortKey = "8Toggle Grid Follow Mouse",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001417--[[Follow Mouse Grid Size--]]],
		ActionMenubar = str_Debug_Grids,
		ActionId = ".Follow Mouse Grid Size",
		ActionIcon = "CommonAssets/UI/Menu/ToggleWalk.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.DebugGridSize",
				Strings[302535920001418--[[Sets the size of the Building/Flight grid.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.debug_build_grid_settings,
		setting_mask = "DebugGridSize",
		ActionSortKey = "9Follow Mouse Grid Size",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001419--[[Follow Mouse Grid Translate--]]],
		ActionMenubar = str_Debug_Grids,
		ActionId = ".Follow Mouse Grid Translate",
		ActionIcon = "CommonAssets/UI/Menu/ToggleWalk.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.DebugGridOpacity",
				Strings[302535920001420--[[How transparent the Building grid is.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.debug_build_grid_settings,
		setting_mask = "DebugGridOpacity",
		ActionSortKey = "9Follow Mouse Grid Translate",
	}

	local str_Debug_DebugFX = "ECM.Debug.Debug FX"
	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001175--[[Debug FX--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Debug FX",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Debug FX",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001175--[[Debug FX--]]],
		ActionMenubar = str_Debug_DebugFX,
		ActionId = ".Debug FX",
		ActionIcon = "CommonAssets/UI/Menu/FXEditor.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				DebugFX,
				Strings[302535920001176--[[Toggle showing FX debug info in console.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.DebugFX_Toggle,
		setting_name = "DebugFX",
		setting_msg = Strings[302535920001175],
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001184--[[Particles--]]],
		ActionMenubar = str_Debug_DebugFX,
		ActionId = ".Particles",
		ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				DebugFXParticles,
				Strings[302535920001176--[[Toggle showing FX debug info in console.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.DebugFX_Toggle,
		setting_name = "DebugFXParticles",
		setting_msg = Strings[302535920001184],
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001368--[[Sound FX--]]],
		ActionMenubar = str_Debug_DebugFX,
		ActionId = ".Sound FX",
		ActionIcon = "CommonAssets/UI/Menu/DisableEyeSpec.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				DebugFXSound,
				Strings[302535920001176--[[Toggle showing FX debug info in console.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.DebugFX_Toggle,
		setting_name = "DebugFXSound",
		setting_msg = Strings[302535920001368],
	}

	local str_Debug_PathMarkers = "ECM.Debug.Path Markers"
	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000467--[[Path Markers--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Path Markers",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Path Markers",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000467--[[Path Markers--]]] .. " " .. Strings[302535920001382--[[Real Time--]]],
		ActionMenubar = str_Debug_PathMarkers,
		ActionId = ".Game Time",
		ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
		RolloverText = Strings[302535920000462--[[Maps paths in real time--]]] .. " " .. Strings[302535920000874--[[(see "Path Markers" to mark more than one at a time).--]]],
		OnAction = ChoGGi.MenuFuncs.SetPathMarkersGameTime,
		ActionShortcut = "Ctrl-Numpad .",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000467--[[Path Markers--]]],
		ActionMenubar = str_Debug_PathMarkers,
		ActionId = ".Path Markers",
		ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
		RolloverText = Strings[302535920000468--[[Shows the selected unit path or show a list to add/remove paths for rovers, drones, colonists, or shuttles.--]]],
		OnAction = ChoGGi.MenuFuncs.SetPathMarkers,
		ActionShortcut = "Ctrl-Numpad 0",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001527--[[Building Path Markers--]]],
		ActionMenubar = str_Debug_PathMarkers,
		ActionId = ".Building Markers",
		ActionIcon = "CommonAssets/UI/Menu/ToggleCutSmoothTrans.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.Temp.BuildingPathMarkers_Toggle,
				Strings[302535920001528--[[Show inside waypoints colonists take to move around (not all buildings).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.BuildingPathMarkers_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000487--[[Delete All Of Selected Object--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Delete All Of Selected Object",
		ActionIcon = "CommonAssets/UI/Menu/delete_objects.tga",
		RolloverText = Strings[302535920000488--[[Will ask for confirmation beforehand (will not delete domes).--]]],
		OnAction = ChoGGi.MenuFuncs.DeleteAllSelectedObjects,
		ActionSortKey = "99.Delete All Of Selected Object",
	}

	local str_Debug_DeleteObjects = "ECM.Debug.Delete Object(s)"
	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000489--[[Delete Object(s)--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Delete Object(s)",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "99.Delete Object(s)",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000489--[[Delete Object(s)--]]],
		ActionMenubar = str_Debug_DeleteObjects,
		ActionId = ".Delete Object(s)",
		ActionIcon = "CommonAssets/UI/Menu/delete_objects.tga",
		RolloverText = Strings[302535920000490--[["Deletes selected object or object under mouse cursor (most objs, not all).

Use Editor Mode and mouse drag to select multiple objects for deletion."--]]],
		OnAction = ChoGGi.ComFuncs.DeleteObject,
		ActionShortcut = "Ctrl-Alt-Shift-D",
		ActionBindable = true,
		ActionSortKey = "99.Delete Object(s)",
	}

end
