-- See LICENSE for terms

function OnMsg.ClassesGenerate()
	local Translate = ChoGGi.ComFuncs.Translate
	local Strings = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local c = #Actions

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000680--[[Annoying Sounds--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Annoying Sounds",
		ActionIcon = "CommonAssets/UI/Menu/ToggleCutSmoothTrans.tga",
		RolloverText = Strings[302535920000681--[[Toggle annoying sounds (Sensor Tower, Mirror Sphere, Rover deployed drones, Drone incessant beeping).--]]],
		OnAction = ChoGGi.MenuFuncs.AnnoyingSounds_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001292--[[List All Objects--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".List All Objects",
		ActionIcon = "CommonAssets/UI/Menu/select_objects.tga",
		RolloverText = Strings[302535920001293--[[A list of objects; double-click on one to select and move the camera to it.--]]],
		OnAction = ChoGGi.MenuFuncs.ListAllObjects,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000864--[[Delete Large Rocks--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Delete Large Rocks",
		ActionIcon = "CommonAssets/UI/Menu/selslope.tga",
		RolloverText = Strings[302535920001238--[[Removes rocks for that smooth map feel.--]]],
		OnAction = ChoGGi.ComFuncs.DeleteLargeRocks,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001366--[[Delete Small Rocks--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Delete Small Rocks",
		ActionIcon = "CommonAssets/UI/Menu/selslope.tga",
		RolloverText = Strings[302535920001238--[[Removes rocks for that smooth map feel.--]]],
		OnAction = ChoGGi.ComFuncs.DeleteSmallRocks,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000674--[[Terrain Editor Toggle--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Terrain Editor Toggle",
		ActionIcon = "CommonAssets/UI/Menu/smooth_terrain.tga",
		RolloverText = Strings[302535920000675--[[Opens up the map editor with the brush tool visible.--]]],
		OnAction = ChoGGi.ComFuncs.TerrainEditor_Toggle,
		ActionShortcut = "Ctrl-Shift-T",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000485--[[Terrain Flatten Toggle--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Terrain Flatten Toggle",
		ActionIcon = "CommonAssets/UI/Menu/FixUnderwaterEdges.tga",
		RolloverText = Strings[302535920000486--[[Use the shortcut to turn this on as it will use where your cursor is as the height to flatten to.

	Use Shift + Arrow keys to change the height/radius.--]]],
		OnAction = ChoGGi.MenuFuncs.FlattenTerrain_Toggle,
		ActionShortcut = "Shift-F",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000623--[[Terrain Texture Change--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Terrain Texture Change",
		ActionIcon = "CommonAssets/UI/Menu/terrain_type.tga",
		RolloverText = Strings[302535920000624--[[Green or Icy mars? Coming right up!
(don't forget a light model)--]]],
		OnAction = ChoGGi.MenuFuncs.TerrainTextureChange,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001237--[[Terrain Texture Remap--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Terrain Texture Remap",
		ActionIcon = "CommonAssets/UI/Menu/terrain_type.tga",
		RolloverText = Strings[302535920001312--[["Instead of replacing all textures with one then re-adding stuff, this will remap existing textures."--]]],
		OnAction = ChoGGi.MenuFuncs.TerrainTextureRemap,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001111--[[Whiter Rocks--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Whiter Rocks",
		ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
		RolloverText = Strings[302535920001113--[[Helps the rocks blend in better when using the polar ground texture.--]]],
		OnAction = ChoGGi.MenuFuncs.WhiterRocks,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000493--[[Change Map--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Change Map",
		ActionIcon = "CommonAssets/UI/Menu/load_city.tga",
		RolloverText = Strings[302535920000494--[[Change map (options to pick commander, sponsor, etc...

Attention: If you get yellow ground areas; just load it again or try %s.--]]]:format(Strings[302535920001487--[[Reload Map--]]]),
		OnAction = ChoGGi.MenuFuncs.ChangeMap,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001487--[[Reload Map--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".ReloadMap",
		ActionIcon = "CommonAssets/UI/Menu/reload.tga",
		RolloverText = Strings[302535920001488--[[Reloads map as new game.--]]],
		ActionSortKey = "1Change Map ReloadMap",
		OnAction = ChoGGi.MenuFuncs.ReloadMap,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000265--[[Pulsating Pins--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Pulsating Pins",
		ActionIcon = "CommonAssets/UI/Menu/JoinGame.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.DisablePulsatingPinsMotion,
				Strings[302535920000335--[[When true pins will no longer do the pulsating motion (hover over to stop).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.PulsatingPins_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000625--[[Change Light Model--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Change Light Model",
		ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.Lightmodel,
				Strings[302535920000626--[[Changes the lighting mode (temporary or permanent).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.ChangeLightmodel,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000627--[[Change Light Model Custom--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Change Light Model Custom",
		ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
		RolloverText = function()
			-- it can get large, so for this one we stick the description first.
			return Strings[302535920000628--[["Make a custom lightmodel and save it to settings. You still need to use ""Change Light Model"" for permanent."--]]]
				.. "\n<color 100 255 100>" .. ValueToLuaCode(ChoGGi.UserSettings.LightmodelCustom) .. "</color>"
		end,
		OnAction = ChoGGi.MenuFuncs.EditLightmodelCustom,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000629--[[UI Transparency--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".UI Transparency",
		ActionIcon = "CommonAssets/UI/Menu/set_last_texture.tga",
		RolloverText = Strings[302535920000630--[[Change the transparency of UI items (info panel, menu, pins).--]]],
		OnAction = ChoGGi.MenuFuncs.SetTransparencyUI,
		ActionShortcut = "Ctrl-F3",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000631--[[UI Transparency Mouseover--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".UI Transparency Mouseover",
		ActionIcon = "CommonAssets/UI/Menu/set_last_texture.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.TransparencyToggle,
				Strings[302535920000632--[[Toggle removing transparency on mouseover.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.TransparencyUI_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000694--[[Set Opacity--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Set Opacity",
		ActionIcon = "CommonAssets/UI/Menu/set_last_texture.tga",
		RolloverText = function()
			local obj = ChoGGi.ComFuncs.SelObject()
			if IsValid(obj) then
				return ChoGGi.ComFuncs.SettingState(
					obj:GetOpacity(),
					Strings[302535920000695--[[Change the opacity of objects.--]]]
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
	Actions[c] = {ActionName = Translate(174--[[Color Modifier--]]),
		ActionMenubar = "ECM.Game",
		ActionId = ".Color Modifier",
		ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
		RolloverText = Strings[302535920000693--[[Select/mouse over an object to change the colours
	Use Shift- or Ctrl- for random colours/reset colours.--]]],
		OnAction = ChoGGi.ComFuncs.CreateObjectListAndAttaches,
		ActionShortcut = "F6",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000678--[[Change Surface Signs To Materials--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Change Surface Signs To Materials",
		ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
		RolloverText = Strings[302535920000679--[[Changes all the ugly immersion breaking signs to materials (reversible).--]]],
		OnAction = ChoGGi.ComFuncs.ChangeSurfaceSignsToMaterials,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000061--[[Place Objects--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Place Objects",
		ActionIcon = "CommonAssets/UI/Menu/enrich_terrain.tga",
		RolloverText = Strings[302535920000062--[[Opens editor mode with the place objects dialog.--]]],
		OnAction = ChoGGi.ComFuncs.PlaceObjects_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000862--[[Object Planner--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Object Planner",
		ActionIcon = "CommonAssets/UI/Menu/ShowOccluders.tga",
		RolloverText = Strings[302535920000863--[[Places fake construction site objects at mouse cursor (collision disabled).--]]],
		OnAction = ChoGGi.ComFuncs.EntitySpawner,
		setting_planning = true,
		ActionShortcut = "Ctrl-Shift-A",
		ActionBindable = true,
	}


	local str_Game_Camera = "ECM.Game.Camera"
	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001058--[[Camera--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Camera",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Camera",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001084--[[Reset--]]],
		ActionMenubar = str_Game_Camera,
		ActionId = ".Toggle Cursor",
		ActionIcon = "CommonAssets/UI/Menu/NewCamera.tga",
		RolloverText = Strings[302535920001370--[[If something makes the camera view wonky you can use this to fix it.--]]],
		OnAction = ChoGGi.MenuFuncs.ResetCamera,
		ActionSortKey = "-1",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000647--[[Border Scrolling--]]],
		ActionMenubar = str_Game_Camera,
		ActionId = ".Border Scrolling",
		ActionIcon = "CommonAssets/UI/Menu/CameraToggle.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.BorderScrollingToggle,
				Strings[302535920000648--[[Set size of activation for mouse border scrolling.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetBorderScrolling,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000649--[[Zoom Distance--]]],
		ActionMenubar = str_Game_Camera,
		ActionId = ".Zoom Distance",
		ActionIcon = "CommonAssets/UI/Menu/MoveUpCamera.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.CameraZoomToggle,
				Strings[302535920000650--[[Further zoom distance.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetCameraZoom,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001375--[[Bird's Eye--]]],
		ActionMenubar = str_Game_Camera,
		ActionId = ".Bird's Eye",
		ActionIcon = "CommonAssets/UI/Menu/UnlockCamera.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.CameraLookatDist,
				Strings[302535920001429--[[How far up the camera can move.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetCameraLookatDist,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000651--[[Toggle Free Camera--]]],
		ActionMenubar = str_Game_Camera,
		ActionId = ".Toggle Free Camera",
		ActionIcon = "CommonAssets/UI/Menu/NewCamera.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				cameraFly.IsActive(),
				Strings[302535920000652--[[I believe I can fly.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.CameraFree_Toggle,
		ActionShortcut = "Shift-C",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000653--[[Toggle Follow Camera--]]],
		ActionMenubar = str_Game_Camera,
		ActionId = ".Toggle Follow Camera",
		ActionIcon = "CommonAssets/UI/Menu/Shot.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				camera3p.IsActive(),
				Strings[302535920000654--[[Select (or mouse over) an object to follow.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.CameraFollow_Toggle,
		ActionShortcut = "Ctrl-Shift-F",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000655--[[Toggle Cursor--]]],
		ActionMenubar = str_Game_Camera,
		ActionId = ".Toggle Cursor",
		ActionIcon = "CommonAssets/UI/Menu/select_objects.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				IsMouseCursorHidden(),
				Strings[302535920000656--[[Toggle between moving camera and selecting objects.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.CursorVisible_Toggle,
		ActionShortcut = "Ctrl-Alt-F",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001489--[[Toggle Map Edge Limit--]]],
		ActionMenubar = str_Game_Camera,
		ActionId = ".Toggle Cursor",
		ActionIcon = "CommonAssets/UI/Menu/move_gizmo.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.MapEdgeLimit,
				Strings[302535920001490--[[Removes pushback limit at the edge of the map.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.MapEdgeLimit_Toggle,
	}

	local str_Game_Render = "ECM.Game.Render"
	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000845--[[Render--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Render",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Render",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000633--[[Lights Radius--]]],
		ActionMenubar = str_Game_Render,
		ActionId = ".Lights Radius",
		ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.LightsRadius,
				Strings[302535920000634--[[Sets light radius (Menu>Options>Video>Lights), menu options max out at 100.
	Lets you see lights from further away/more bleedout?--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetLightsRadius,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000635--[[Terrain Detail--]]],
		ActionMenubar = str_Game_Render,
		ActionId = ".Terrain Detail",
		ActionIcon = "CommonAssets/UI/Menu/selslope.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.TerrainDetail,
				Strings[302535920000636--[[Sets hr.TR_MaxChunks (Menu>Options>Video>Terrain), menu options max out at 200.
	Makes the background terrain more detailed (make sure to also stick Terrain on Ultra in the options menu).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetTerrainDetail,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000637--[[Video Memory--]]],
		ActionMenubar = str_Game_Render,
		ActionId = ".Video Memory",
		ActionIcon = "CommonAssets/UI/Menu/CountPointLights.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.VideoMemory,
				Strings[302535920000638--[[Sets hr.DTM_VideoMemory (Menu>Options>Video>Textures), menu options max out at 2048.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetVideoMemory,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000639--[[Shadow Map--]]],
		ActionMenubar = str_Game_Render,
		ActionId = ".Shadow Map",
		ActionIcon = "CommonAssets/UI/Menu/DisableEyeSpec.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.ShadowmapSize,
				Strings[302535920000640--[[Sets the shadow map size (Menu>Options>Video>Shadows), menu options max out at 4096.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetShadowmapSize,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000641--[[Disable Texture Compression--]]],
		ActionMenubar = str_Game_Render,
		ActionId = ".Disable Texture Compression",
		ActionIcon = "CommonAssets/UI/Menu/ExportImageSequence.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.DisableTextureCompression,
				Strings[302535920000642--[[Toggle texture compression (game defaults to on, seems to make a difference of 600MB vram).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.DisableTextureCompression_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000643--[[Higher Render Distance--]]],
		ActionMenubar = str_Game_Render,
		ActionId = ".Higher Render Distance",
		ActionIcon = "CommonAssets/UI/Menu/CameraEditor.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.HigherRenderDist,
				Strings[302535920000644--[[Renders model from further away.
	Not noticeable unless using higher zoom.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.HigherRenderDist_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000645--[[Higher Shadow Distance--]]],
		ActionMenubar = str_Game_Render,
		ActionId = ".Higher Shadow Distance",
		ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.HigherShadowDist,
				Strings[302535920000646--[[Renders shadows from further away.
	Not noticeable unless using higher zoom.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.HigherShadowDist_Toggle,
	}

	local str_Game_ExportCSV = "ECM.Game.Export CSV"
	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001449--[[Export--]]] .. " " .. Strings[302535920001448--[[CSV--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Export CSV",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Export CSV",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001208--[[Colonist Data--]]],
		ActionMenubar = str_Game_ExportCSV,
		ActionId = ".Colonist Data",
		ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
		RolloverText = Strings[302535920001219--[[Export colonist data to %sColonists.csv.--]]]:format(ConvertToOSPath("AppData/")),
		OnAction = ChoGGi.ComFuncs.ExportColonistDataToCSV,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001450--[[Graphs Data--]]],
		ActionMenubar = str_Game_ExportCSV,
		ActionId = ".Graphs Data",
		ActionIcon = "CommonAssets/UI/Menu/ConvertEnvironment.tga",
		RolloverText = Strings[302535920001452--[[Export command centre graph data to %sGraphs.csv.--]]]:format(ConvertToOSPath("AppData/")),
		OnAction = ChoGGi.ComFuncs.ExportGraphsToCSV,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001501--[[Map Data--]]],
		ActionMenubar = str_Game_ExportCSV,
		ActionId = ".Map Data",
		ActionIcon = "CommonAssets/UI/Menu/RandomMapPresetEditor.tga",
		RolloverText = Strings[302535920001502--[["Export map location data to %sMapData.csv (will take awhile).

See survivingmarsmaps.com for a filtered list.
Don't use in start new game screens (rating/topo will be messed up).
Difficulty Challenge/Named Location may not work on some saves (best to start a new game, or run from main menu)."--]]]:format(ConvertToOSPath("AppData/")),
		OnAction = ChoGGi.ComFuncs.ExportMapDataToCSV,
	}

	local str_Game_Screenshot = "ECM.Game.Screenshot"
	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000892--[[Screenshot--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Screenshot",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Screenshot",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000657--[[Screenshot--]]],
		ActionMenubar = str_Game_Screenshot,
		ActionId = ".Screenshot",
		ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
		RolloverText = Strings[302535920000658--[[Write screenshot--]]],
		OnAction = ChoGGi.MenuFuncs.TakeScreenshot,
		setting_mask = 0,
		ActionShortcut = "-PrtScr",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000659--[[Screenshot Upsampled--]]],
		ActionMenubar = str_Game_Screenshot,
		ActionId = ".Screenshot Upsampled",
		ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
		RolloverText = Strings[302535920000660--[[Write screenshot upsampled--]]],
		OnAction = ChoGGi.MenuFuncs.TakeScreenshot,
		setting_mask = 1,
		ActionShortcut = "-Ctrl-PrtScr",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000661--[[Show Interface in Screenshots--]]],
		ActionMenubar = str_Game_Screenshot,
		ActionId = ".Show Interface in Screenshots",
		ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.ShowInterfaceInScreenshots,
				Strings[302535920000662--[[Do you want to see the interface in screenshots?--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.ShowInterfaceInScreenshots_Toggle,
	}

	local str_Game_Interface = "ECM.Game.Interface"
	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000893--[[Interface--]]],
		ActionMenubar = "ECM.Game",
		ActionId = ".Interface",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Interface",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000663--[[Toggle Interface--]]],
		ActionMenubar = str_Game_Interface,
		ActionId = ".Toggle Interface",
		ActionIcon = "CommonAssets/UI/Menu/ToggleSelectionOcclusion.tga",
		RolloverText = Strings[302535920000244--[[Warning! This will hide everything. Remember the shortcut or have fun restarting.--]]],
		OnAction = ChoGGi.MenuFuncs.Interface_Toggle,
		ActionShortcut = "Ctrl-Alt-I",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001387--[[Toggle Signs--]]],
		ActionMenubar = str_Game_Interface,
		ActionId = ".Toggle Signs",
		ActionIcon = "CommonAssets/UI/Menu/ToggleMarkers.tga",
		RolloverText = Strings[302535920001388--[["Concrete, metal deposits, not working, etc..."--]]],
		OnAction = ToggleSigns,
		ActionShortcut = "Ctrl-Alt-U",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000666--[[Toggle on-screen hints--]]],
		ActionMenubar = str_Game_Interface,
		ActionId = ".Toggle on-screen hints",
		ActionIcon = "CommonAssets/UI/Menu/HideUnselected.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				HintsEnabled,
				Strings[302535920000667--[[Don't show hints for this game.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.OnScreenHints_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000668--[[Reset on-screen hints--]]],
		ActionMenubar = str_Game_Interface,
		ActionId = ".Reset on-screen hints",
		ActionIcon = "CommonAssets/UI/Menu/HideSelected.tga",
		RolloverText = Strings[302535920000669--[[Just in case you wanted to see them again.--]]],
		OnAction = ChoGGi.MenuFuncs.OnScreenHints_Reset,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000670--[[Never Show Hints--]]],
		ActionMenubar = str_Game_Interface,
		ActionId = ".Never Show Hints",
		ActionIcon = "CommonAssets/UI/Menu/set_debug_texture.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.DisableHints,
				Strings[302535920000671--[[No more hints ever.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.NeverShowHints_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001412--[[GUI Dock Side--]]],
		ActionMenubar = str_Game_Interface,
		ActionId = ".GUI Dock Side",
		ActionIcon = "CommonAssets/UI/Menu/DisableAOMaps.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.GUIDockSide and Translate(1000459--[[Right--]]) or Translate(1000457--[[Left--]]),
				Strings[302535920001413--[[Change which side (most) GUI menus are on.--]]]

			)
		end,
		OnAction = ChoGGi.MenuFuncs.GUIDockSide_Toggle,
	}

end
