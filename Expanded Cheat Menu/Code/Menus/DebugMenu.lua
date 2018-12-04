-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local StringFormat = string.format
	local c = #Actions

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s",S[302535920001416--[[Force--]]],S[948928900281--[[Story Bits--]]]),
		ActionMenubar = "ECM.Debug",
		ActionId = ".Force Story Bits",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001359--[["Just lists them for now, I'll make it force them soonish."--]]],
		OnAction = ChoGGi.MenuFuncs.ForceStoryBits,
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s",S[302535920000129--[[Set--]]],S[302535920001184--[[Particles--]]]),
		ActionMenubar = "ECM.Debug",
		ActionId = ".Set Particles",
		ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
		RolloverText = S[302535920001421--[[Shows a list of particles you can use on the selected obj.--]]],
		OnAction = function()
			ChoGGi.ComFuncs.SetParticles()
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001314--[[Toggle Render--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Toggle Render",
		ActionIcon = "CommonAssets/UI/Menu/Shot.tga",
		RolloverText = S[302535920001315--[[Toggle rendering certain stuff.--]]],
		OnAction = ChoGGi.MenuFuncs.Render_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001310--[[DTM Slots Display--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".DTM Slots Display",
		ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				GetDialog("DTMSlotsDlg") and true,
				302535920001311--[[Toggle DTM slots display--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.DTMSlotsDlg_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001312--[[FPS Counter Location--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".FPS Counter Location",
		ActionIcon = "CommonAssets/UI/Menu/EnrichTerrainEditor.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				hr.FpsCounterPos or 0,
				302535920001313--[[One of the four corners of your screen.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.FpsCounterLocation,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001208--[[Export Colonist Data To CSV--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Export Colonist Data To CSV",
		ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
		RolloverText = S[302535920001219--[[Exports data about colonists to %sColonists.csv--]]]:format(ConvertToOSPath("AppData/")),
		OnAction = ChoGGi.MenuFuncs.ExportColonistDataToCSV,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000449--[[Attach Spots Toggle--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Attach Spots Toggle",
		ActionIcon = "CommonAssets/UI/Menu/ShowAll.tga",
		RolloverText = function()
			local sel = SelectedObj
			return ChoGGi.ComFuncs.SettingState(
				sel and sel.ChoGGi_ShowAttachSpots,
				302535920000450--[[Toggle showing attachment spots on selected object.--]]
			)
		end,
		OnAction = function()
			ChoGGi.ComFuncs.AttachSpots_Toggle()
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000235--[[Attach Spots List--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Attach Spots List",
		ActionIcon = "CommonAssets/UI/Menu/ListCollections.tga",
		RolloverText = S[302535920001445--[[Shows list of attaches for use with .ent files.--]]],
		OnAction = function()
			ChoGGi.ComFuncs.ExamineEntSpots()
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000451--[[Measure Tool--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Measure Tool",
		ActionIcon = "CommonAssets/UI/Menu/MeasureTool.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				MeasureTool.enabled,
				302535920000452--[[Measures stuff (Use Ctrl-Shift-M to remove the lines).--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.MeasureTool_Toggle,
		ActionShortcut = "Ctrl-M",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000453--[[Reload Lua--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Reload Lua",
		ActionIcon = "CommonAssets/UI/Menu/EV_OpenFirst.tga",
		RolloverText = S[302535920000454--[[Fires some commands to reload lua files (use OnMsg.ReloadLua() to listen for it).--]]],
		OnAction = ChoGGi.MenuFuncs.ReloadLua,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000455--[[Object Cloner--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Object Cloner",
		ActionIcon = "CommonAssets/UI/Menu/EnrichTerrainEditor.tga",
		RolloverText = S[302535920000456--[[Clones selected/moused over object to current mouse position (should probably use the shortcut key rather than this menu item).--]]],
		OnAction = function()
			ChoGGi.MenuFuncs.ObjectCloner()
		end,
		ActionShortcut = "Shift-Q",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000457--[[Anim State Set--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Anim State Set",
		ActionIcon = "CommonAssets/UI/Menu/UnlockCamera.tga",
		RolloverText = S[302535920000458--[[Make object dance on command.--]]],
		OnAction = function()
			ChoGGi.ComFuncs.SetAnimState()
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000459--[[Anim Debug Toggle--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Anim Debug Toggle",
		ActionIcon = "CommonAssets/UI/Menu/CameraEditor.tga",
		RolloverText = function()
			local sel = SelectedObj
			if sel then
				return ChoGGi.ComFuncs.SettingState(
					sel.ChoGGi_ShowAnimDebug,
					302535920000460--[[Attaches text to each object showing animation info (or just to selected object).--]]
				)
			else
				return ChoGGi.ComFuncs.SettingState(
					ChoGGi.Temp.ShowAnimDebug,
					302535920000460--[[Attaches text to each object showing animation info (or just to selected object).--]]
				)
			end
		end,
		OnAction = function()
			ChoGGi.ComFuncs.ShowAnimDebug_Toggle()
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s",S[327465361219--[[Edit--]]],S[298035641454--[[Object--]]]),
		ActionMenubar = "ECM.Debug",
		ActionId = ".Object Manipulator",
		ActionIcon = "CommonAssets/UI/Menu/SaveMapEntityList.tga",
		RolloverText = S[302535920000472--[[Manipulate objects (selected or under mouse cursor)--]]],
		OnAction = function()
			ChoGGi.ComFuncs.OpenInObjectManipulatorDlg()
		end,
		ActionShortcut = "F5",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000475--[[Entity Spawner--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Object Spawner",
		ActionIcon = "CommonAssets/UI/Menu/add_water.tga",
		RolloverText = S[302535920000476--[["Shows list of objects, and spawns at mouse cursor."--]]],
		OnAction = function()
			ChoGGi.ComFuncs.EntitySpawner()
		end,
		ActionShortcut = "Ctrl-Shift-S",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000479--[[Toggle Editor--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Toggle Editor",
		ActionIcon = "CommonAssets/UI/Menu/SelectionEditor.tga",
		RolloverText = S[302535920000480--[["Select object(s) then hold ctrl/shift/alt and drag mouse.
	click+drag for multiple selection.

	It's not as if domes need to be where you placed them (people will just ignore if you move the domes all to one place for that airy mars look)."--]]],
		OnAction = ChoGGi.ComFuncs.Editor_Toggle,
		ActionShortcut = "Ctrl-Shift-E",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000481--[[Open In Ged Object Editor--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Open In Ged Object Editor",
		ActionIcon = "CommonAssets/UI/Menu/SelectionEditor.tga",
		RolloverText = S[302535920000482--[["Shows some info about the object, and so on. Some buttons may make camera wonky (use Game>Camera>Reset)."--]]],
		OnAction = function()
			GedObjectEditor = false
			OpenGedGameObjectEditor{ChoGGi.ComFuncs.SelObject()}
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000491--[[Examine Object--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Examine Object",
		ActionIcon = "CommonAssets/UI/Menu/PlayerInfo.tga",
		RolloverText = S[302535920000492--[[Opens the object examiner for the selected or moused-over obj.--]]],
		OnAction = function()
			local obj = ChoGGi.ComFuncs.SelObject()
			if obj then
				ChoGGi.ComFuncs.OpenInExamineDlg(obj)
				return
			end
			-- if in main menu then open examine and console
			if not Dialogs.HUD then
				ChoGGi.ComFuncs.OpenInExamineDlg(terminal.desktop)
				ChoGGi.ComFuncs.ToggleConsole(true)
			end
		end,
		ActionShortcut = "F4",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000495--[[Particles Reload--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Particles Reload",
		ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
		RolloverText = S[302535920000496--[[Reloads particles from "Data/Particles"...--]]],
		OnAction = ChoGGi.MenuFuncs.ParticlesReload,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000581--[[Toggle Object Collision--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Toggle Object Collision",
		ActionIcon = "CommonAssets/UI/Menu/road_type.tga",
		RolloverText = S[302535920000582--[[Select an object and activate this to toggle collision (if you have a rover stuck in a dome).--]]],
		OnAction = function()
			ChoGGi.ComFuncs.CollisionsObject_Toggle()
		end,
	}

	local str_Debug_Grids = "ECM.Debug.Grids"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[302535920000035--[[Grids--]]]),
		ActionMenubar = "ECM.Debug",
		ActionId = ".Grids",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Grids",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001297--[[Toggle Flight Grid--]]],
		ActionMenubar = str_Debug_Grids,
		ActionId = ".Toggle Flight Grid",
		ActionIcon = "CommonAssets/UI/Menu/ToggleCollisions.tga",
		RolloverText = S[302535920001298--[[Shows a square grid with terrain/objects shape.--]]],
		OnAction = function()
			ChoGGi.ComFuncs.FlightGrid_Toggle()
		end,
		ActionShortcut = "Shift-F2",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001328--[[Show Grid Disable--]]],
		ActionMenubar = str_Debug_Grids,
		ActionId = ".Show Grid Disable",
		ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
		RolloverText = S[302535920001329--[[Hide the white ground grids.--]]],
		OnAction = function()
			ChoGGi.MenuFuncs.PostProcGrids()
		end,
		ActionSortKey = "-1Show Grid Disable",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000724--[[Show Grid Square--]]],
		ActionMenubar = str_Debug_Grids,
		ActionId = ".Show Grid Square",
		ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
		RolloverText = S[302535920000725--[[Square (use Disable to hide).--]]],
		OnAction = function()
			ChoGGi.MenuFuncs.PostProcGrids("grid")
		end,
		ActionSortKey = "0Show Grid Square",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001192--[[Show Grid 45 Square--]]],
		ActionMenubar = str_Debug_Grids,
		ActionId = ".Show Grid 45 Square",
		ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
		RolloverText = S[302535920001325--[[Square 45 (use Disable to hide).--]]],
		OnAction = function()
			ChoGGi.MenuFuncs.PostProcGrids("grid45")
		end,
		ActionSortKey = "0Show Grid 45 Square",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001326--[[Show Grid Hex--]]],
		ActionMenubar = str_Debug_Grids,
		ActionId = ".Show Grid Hex",
		ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
		RolloverText = S[302535920001327--[[Hex (use Disable to hide).--]]],
		OnAction = function()
			ChoGGi.MenuFuncs.PostProcGrids("hexgrid")
		end,
		ActionSortKey = "0Show Grid Hex",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000499--[[Toggle Grid Follow Mouse--]]],
		ActionMenubar = str_Debug_Grids,
		ActionId = ".Toggle Grid Follow Mouse",
		ActionIcon = "CommonAssets/UI/Menu/ToggleWalk.tga",
		RolloverText = S[302535920000500--[["Show a hex grid around mouse: Green = pass/build, Yellow = no pass/build, Blue = pass/no build, Red = no pass/no build."--]]],
		OnAction = ChoGGi.MenuFuncs.debug_build_grid,
		ActionShortcut = "Shift-F1",
		ActionBindable = true,
		ActionSortKey = "8Toggle Grid Follow Mouse",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001417--[[Follow Mouse Grid Size--]]],
		ActionMenubar = str_Debug_Grids,
		ActionId = ".Follow Mouse Grid Size",
		ActionIcon = "CommonAssets/UI/Menu/ToggleWalk.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.DebugGridSize",
				302535920001418--[[Sets the size of the grid...--]]
			)
		end,
		OnAction = function()
			ChoGGi.MenuFuncs.debug_build_grid_settings("DebugGridSize")
		end,
		ActionSortKey = "9Follow Mouse Grid Size",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001419--[[Follow Mouse Grid Trans--]]],
		ActionMenubar = str_Debug_Grids,
		ActionId = ".Follow Mouse Grid Trans",
		ActionIcon = "CommonAssets/UI/Menu/ToggleWalk.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.DebugGridOpacity",
				302535920001420--[[How transparent the grid is.--]]
			)
		end,
		OnAction = function()
			ChoGGi.MenuFuncs.debug_build_grid_settings("DebugGridOpacity")
		end,
		ActionSortKey = "9Follow Mouse Grid Trans",
	}

	local str_Debug_DebugFX = "ECM.Debug.Debug FX"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[302535920001175--[[Debug FX--]]]),
		ActionMenubar = "ECM.Debug",
		ActionId = ".Debug FX",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Debug FX",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001175--[[Debug FX--]]],
		ActionMenubar = str_Debug_DebugFX,
		ActionId = ".Debug FX",
		ActionIcon = "CommonAssets/UI/Menu/FXEditor.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				DebugFX,
				302535920001176--[[Toggle showing FX debug info in console.--]]
			)
		end,
		OnAction = function()
			ChoGGi.MenuFuncs.DebugFX_Toggle("DebugFX",302535920001175)
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001184--[[Particles--]]],
		ActionMenubar = str_Debug_DebugFX,
		ActionId = ".Particles",
		ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				DebugFXParticles,
				302535920001176--[[Toggle showing FX debug info in console.--]]
			)
		end,
		OnAction = function()
			ChoGGi.MenuFuncs.DebugFX_Toggle("DebugFXParticles",302535920001184)
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001368--[[Sound FX--]]],
		ActionMenubar = str_Debug_DebugFX,
		ActionId = ".Sound FX",
		ActionIcon = "CommonAssets/UI/Menu/DisableEyeSpec.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				DebugFXSound,
				302535920001176--[[Toggle showing FX debug info in console.--]]
			)
		end,
		OnAction = function()
			ChoGGi.MenuFuncs.DebugFX_Toggle("DebugFXSound",302535920001368)
		end,
	}

	local str_Debug_PathMarkers = "ECM.Debug.Path Markers"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[302535920000467--[[Path Markers--]]]),
		ActionMenubar = "ECM.Debug",
		ActionId = ".Path Markers",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Path Markers",
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s",S[302535920000467--[[Path Markers--]]],S[302535920001382--[[Real Time--]]]),
		ActionMenubar = str_Debug_PathMarkers,
		ActionId = ".Game Time",
		ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
		RolloverText = StringFormat("%s %s",S[302535920000462--[[Maps paths in real time--]]],S[302535920000874--[[(see "Path Markers" to mark more than one at a time).--]]]),
		OnAction = function()
			ChoGGi.MenuFuncs.SetPathMarkersGameTime(nil,true)
		end,
		ActionShortcut = "Ctrl-Numpad .",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000467--[[Path Markers--]]],
		ActionMenubar = str_Debug_PathMarkers,
		ActionId = ".Path Markers",
		ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
		RolloverText = S[302535920000468--[[Shows the selected unit path or show a list to add/remove paths for rovers, drones, colonists, or shuttles.--]]],
		OnAction = function()
			ChoGGi.MenuFuncs.SetPathMarkersVisible()
		end,
		ActionShortcut = "Ctrl-Numpad 0",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000146--[[Delete Saved Games--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Delete Saved Games",
		ActionIcon = "CommonAssets/UI/Menu/DeleteArea.tga",
		RolloverText = StringFormat("%s\n\n%s",S[302535920001273--[["Shows a list of saved games, and allows you to delete more than one at a time."--]]],S[302535920001274--[[This is permanent!--]]]),
		OnAction = ChoGGi.MenuFuncs.DeleteSavedGames,
		ActionSortKey = "98.Delete Saved Games",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000487--[[Delete All Of Selected Object--]]],
		ActionMenubar = "ECM.Debug",
		ActionId = ".Delete All Of Selected Object",
		ActionIcon = "CommonAssets/UI/Menu/delete_objects.tga",
		RolloverText = S[302535920000488--[[Will ask for confirmation beforehand (will not delete domes).--]]],
		OnAction = function()
			ChoGGi.MenuFuncs.DeleteAllSelectedObjects()
		end,
		ActionSortKey = "99.Delete All Of Selected Object",
	}

	local str_Debug_DeleteObjects = "ECM.Debug.Delete Object(s)"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[302535920000489--[[Delete Object(s)--]]]),
		ActionMenubar = "ECM.Debug",
		ActionId = ".Delete Object(s)",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "99.Delete Object(s)",
	}
	c = c + 1
	Actions[c] = {ActionName = S[302535920000489--[[Delete Object(s)--]]],
		ActionMenubar = str_Debug_DeleteObjects,
		ActionId = ".Delete Object(s)",
		ActionIcon = "CommonAssets/UI/Menu/delete_objects.tga",
		RolloverText = S[302535920000490--[["Deletes selected object or object under mouse cursor (most objs, not all).

Use Editor Mode and mouse drag to select multiple objects for deletion."--]]],
		OnAction = function()
			ChoGGi.ComFuncs.DeleteObject()
		end,
		ActionShortcut = "Ctrl-Alt-Shift-D",
		ActionBindable = true,
		ActionSortKey = "99.Delete Object(s)",
	}

end
