-- See LICENSE for terms

local SelObjects = ChoGGi.ComFuncs.SelObjects
local OpenInExamineDlg = ChoGGi.ComFuncs.OpenInExamineDlg
local GetCursorWorldPos = GetCursorWorldPos
local IsValid = IsValid
local terminal = terminal


local mod_SpeedFour
local mod_SpeedFive
local mod_OpacityStepSize
local mod_ExamineObjectsRadius

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_SpeedFour = CurrentModOptions:GetProperty("SpeedFour")
	mod_SpeedFive = CurrentModOptions:GetProperty("SpeedFive")
	mod_OpacityStepSize = CurrentModOptions:GetProperty("OpacityStepSize")
	mod_ExamineObjectsRadius = CurrentModOptions:GetProperty("ExamineObjectsRadius")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

--
local GetShortcuts = GetShortcuts
local VKStrNamesInverse = VKStrNamesInverse
local function RetShortcuts(id)
	local keys = GetShortcuts(id)

	if keys then
		return keys[1] and VKStrNamesInverse[keys[1]],
			keys[2] and VKStrNamesInverse[keys[2]],
			-- third key is gamepad "key"
			keys[3] and VKStrNamesInverse[keys[3]]
	end
end
--

local Actions = ChoGGi.Temp.Actions

Actions[#Actions+1] = {ActionName = T(302535920011668, "Set Speed 1"),
	ActionId = "ChoGGi.RebindHardcodedKeys.SetSpeed1",
	OnAction = function()
		UIColony:SetGameSpeed(1)
		UISpeedState = "play"
	end,
	ActionShortcut = "1",
	replace_matching_id = true,
	ActionBindable = true,
	ActionMode = "Game",
}

Actions[#Actions+1] = {ActionName = T(302535920011669, "Set Speed 2"),
	ActionId = "ChoGGi.RebindHardcodedKeys.SetSpeed2",
	OnAction = function()
		UIColony:SetGameSpeed(const.mediumGameSpeed)
		UISpeedState = "medium"
	end,
	ActionShortcut = "2",
	replace_matching_id = true,
	ActionBindable = true,
	ActionMode = "Game",
}

Actions[#Actions+1] = {ActionName = T(302535920011670, "Set Speed 3"),
	ActionId = "ChoGGi.RebindHardcodedKeys.SetSpeed3",
	OnAction = function()
		UIColony:SetGameSpeed(const.fastGameSpeed)
		UISpeedState = "fast"
	end,
	ActionShortcut = "3",
	replace_matching_id = true,
	ActionBindable = true,
	ActionMode = "Game",
}

Actions[#Actions+1] = {ActionName = T(302535920012050, "Set Speed 4"),
	ActionId = "ChoGGi.RebindHardcodedKeys.SetSpeed4",
	OnAction = function()
		UIColony:SetGameSpeed(const.fastGameSpeed * mod_SpeedFour)
		UISpeedState = "faster"
	end,
	ActionShortcut = "4",
	replace_matching_id = true,
	ActionBindable = true,
	ActionMode = "Game",
}

Actions[#Actions+1] = {ActionName = T(302535920012051, "Set Speed 5"),
	ActionId = "ChoGGi.RebindHardcodedKeys.SetSpeed5",
	OnAction = function()
		UIColony:SetGameSpeed(const.fastGameSpeed * mod_SpeedFive)
		UISpeedState = "fastest"
	end,
	ActionShortcut = "5",
	replace_matching_id = true,
	ActionBindable = true,
	ActionMode = "Game",
}

Actions[#Actions+1] = {ActionName = T(302535920011666, "Refab Building"),
	ActionId = "ChoGGi.RebindHardcodedKeys.RefabBuilding",
	ActionShortcut = "Ctrl-R",
	replace_matching_id = true,
	OnAction = function()
		local objs = SelObjects()
		if #objs == 1 then
			local sel = objs[1]
			if sel and sel:IsKindOf("Refabable") and sel:CanRefab() then
				sel:ToggleRefab()
			end
		end
	end,
	ActionBindable = true,
	ActionMode = "Game",
}

Actions[#Actions+1] = {ActionName = T(302535920000491, "Examine Object"),
	ActionId = "ChoGGi.RebindHardcodedKeys.ExamineObject",
	ActionShortcut = "F4",
	replace_matching_id = true,
	OnAction = function()
		-- try to get object in-game first
		local objs = SelObjects()
		local c = #objs
		if c > 0 then
			-- If it's a single obj then examine that, otherwise the whole list
			OpenInExamineDlg(c == 1 and objs[1] or objs)
			return
		end

		if UseGamepadUI() then
			return
		end

		-- next we check if there's a ui element under the cursor and return that
		local target = terminal.desktop:GetMouseTarget(terminal.GetMousePos())
		-- everywhere is covered in xdialogs so skip them
		if target and not target:IsKindOf("XDialog") then
			return OpenInExamineDlg(target)
		end

		-- If in main menu then open examine and console
		if not Dialogs.HUD then
      OpenInExamineDlg(terminal.desktop)
--~ 			local dlg = OpenInExamineDlg(terminal.desktop)
--~ 			-- off centre of central monitor
--~ 			local width = (terminal.desktop.measure_width or 1920) - (dlg.dialog_width_scaled + 100)
--~ 			dlg:SetPos(point(width, 100))
--~ 			ChoGGi.ComFuncs.ToggleConsole(true)
		end
	end,
	ActionBindable = true,
	IgnoreRepeated = true,
}

Actions[#Actions+1] = {ActionName = T(302535920011667, "Examine Objects"),
	ActionId = "ChoGGi.RebindHardcodedKeys.ExamineObjectRadius",
	ActionShortcut = "Shift-F4",
	replace_matching_id = true,
	OnAction = function()
		local pt
		local function SortDist(a, b)
			return a:GetDist2D(pt) < b:GetDist2D(pt)
		end
		local radius = ChoGGi.UserSettings.ExamineObjectRadius or mod_ExamineObjectsRadius
		local objs = SelObjects(radius)
		if objs[1] then
			pt = GetCursorWorldPos()
			-- sort by nearest
			table.sort(objs, SortDist)

			OpenInExamineDlg(objs, {
				has_params = true,
				override_title = true,
				title = T(302535920000069--[[Examine]]) .. " "
					.. T(302535920001103--[[Objects]]) .. " "
					.. T(302535920000163--[[Radius]]) .. ": " .. radius,
			})
		end
	end,
	ActionBindable = true,
	IgnoreRepeated = true,
	ActionMode = "Game",
}

Actions[#Actions+1] = {ActionName = T(302535920012068, "Toggle Interface"),
	ActionId = "ChoGGi.RebindHardcodedKeys.ToggleInterface",
	ActionShortcut = "Ctrl-Alt-I",
	replace_matching_id = true,
	OnAction = function()
		hr.RenderUIL = hr.RenderUIL == 0 and 1 or 0
	end,
	ActionBindable = true,
}

Actions[#Actions+1] = {ActionName = T(302535920011968, "Photo Mode Toggle"),
	ActionId = "ChoGGi.RebindHardcodedKeys.PhotoMode",
	ActionShortcut = "Shift-F12",
	replace_matching_id = true,
	OnAction = function()
		if g_PhotoMode then
			PhotoModeEnd()
			Dialogs.PhotoMode:Close()
			if GetTimeFactor() == 0 then
				local dlg = (GetMarsPauseDlg())
				if dlg then
					dlg:SetParent(terminal.desktop)
				end
			end

		else
			CloseIngameMainMenu()
			StartPhotoMode()
		end
	end,
	ActionBindable = true,
	ActionMode = "Game",
}

Actions[#Actions+1] = {ActionName = T(302535920011969, "Salvage Cursor"),
	ActionId = "ChoGGi.RebindHardcodedKeys.SalvageCursor",
	ActionShortcut = "Ctrl-Delete",
	replace_matching_id = true,
	OnAction = function()
		local igi = GetInGameInterface()
		if igi then
			if igi.mode == "selection" then
				g_LastBuildItem = "Salvage"
				igi:SetMode("demolish")
				PlayFX("DemolishButton", "start")
			else
				igi:SetMode("selection")
			end
		end
	end,
	ActionBindable = true,
	ActionMode = "Game",
}

Actions[#Actions+1] = {ActionName = T(302535920011698, "Cycle Visual Variant Backward"),
	ActionId = "ChoGGi.RebindHardcodedKeys.CycleVisualVariantBackward",
	ActionShortcut = "[",
	replace_matching_id = true,
	ActionBindable = true,
	ActionMode = "Game",
}
Actions[#Actions+1] = {ActionName = T(302535920011699, "Cycle Visual Variant Forward"),
	ActionId = "ChoGGi.RebindHardcodedKeys.CycleVisualVariantForward",
	ActionShortcut = "]",
	replace_matching_id = true,
	ActionBindable = true,
	ActionMode = "Game",
}

Actions[#Actions+1] = {ActionName = T(302535920011700, "Construction Cancel"),
	ActionId = "ChoGGi.RebindHardcodedKeys.ConstructionCancel",
	ActionShortcut = "Escape",
	replace_matching_id = true,
	ActionBindable = true,
	ActionMode = "Game",
}

-- Cycle Visual Variant/Construction Cancel
local ChoOrig_ConstructionModeDialog_OnKbdKeyDown = ConstructionModeDialog.OnKbdKeyDown
function ConstructionModeDialog:OnKbdKeyDown(virtual_key, ...)
	-- check if input is key set in binds
	local back1, back2, back3 = RetShortcuts("ChoGGi.RebindHardcodedKeys.CycleVisualVariantBackward")
	local for1, for2, for3 = RetShortcuts("ChoGGi.RebindHardcodedKeys.CycleVisualVariantForward")
	local cancel1, cancel2, cancel3 = RetShortcuts("ChoGGi.RebindHardcodedKeys.ConstructionCancel")

	-- fire off orig func with default key sent
	if virtual_key == cancel1 or virtual_key == cancel2 or virtual_key == cancel3 then
		return ChoOrig_ConstructionModeDialog_OnKbdKeyDown(self, const.vkEsc, ...)
	elseif virtual_key == for1 or virtual_key == for2 or virtual_key == for3 then
		return ChoOrig_ConstructionModeDialog_OnKbdKeyDown(self, const.vkClosesq, ...)
	elseif virtual_key == back1 or virtual_key == back2 or virtual_key == back3 then
		return ChoOrig_ConstructionModeDialog_OnKbdKeyDown(self, const.vkOpensq, ...)
	end

	return ChoOrig_ConstructionModeDialog_OnKbdKeyDown(self, virtual_key, ...)
--~ 	return "continue"
end
--
Actions[#Actions+1] = {ActionName = T(302535920011974, "Place Multiple Buildings"),
	ActionId = "ChoGGi.RebindHardcodedKeys.PlaceMultipleBuildings",
	ActionShortcut = "Shift",
	replace_matching_id = true,
	ActionBindable = true,
	ActionMode = "Game",
}

local ChoOrig_IsPlacingMultipleConstructions = IsPlacingMultipleConstructions
function IsPlacingMultipleConstructions(...)
	local key1, key2, key3 = RetShortcuts("ChoGGi.RebindHardcodedKeys.PlaceMultipleBuildings")
	if (key1 and terminal.IsKeyPressed(key1))
		or (key2 and terminal.IsKeyPressed(key2))
		or (key3 and terminal.IsKeyPressed(key3))
	then
    return true
	end

	return ChoOrig_IsPlacingMultipleConstructions(...)
end
--
local savename_filename
Actions[#Actions+1] = {ActionName = T(302535920011641, "Quicksave"),
	ActionId = "ChoGGi.AddQuicksaveHotkey.Quicksave",
	OnAction = function()
		if not UIColony or not CanSaveGame() then
			return
		end

		-- Make sure bad things don't happen (ripped from Autosave())
		local igi = GetInGameInterface()
		if igi and not igi.mode_dialog:IsKindOf("UnitDirectionModeDialog") then
			igi:SetMode("selection")
		end

		CreateRealTimeThread(function()
			DeleteGame(savename_filename or "Quicksave.savegame.sav")
			local err
			err, savename_filename = SaveAutosaveGame("Quicksave")

			if err then
				ChoGGi.ComFuncs.MsgPopup(err, T(302535920011641, "Quicksave"))
			else
				ChoGGi.ComFuncs.MsgPopup(savename_filename, T(302535920011641, "Quicksave"), {expiration = 3})
			end
		end)
	end,
	ActionShortcut = "Ctrl-F5",
	replace_matching_id = true,
	ActionBindable = true,
}

Actions[#Actions+1] = {ActionName = T(302535920011642, "Quickload"),
	ActionId = "ChoGGi.AddQuicksaveHotkey.Quickload",
	OnAction = function()
    g_SaveLoadThread = IsValidThread(g_SaveLoadThread) and g_SaveLoadThread or CreateRealTimeThread(function()
			local err = LoadGame(savename_filename or "Quicksave.savegame.sav")
			if not err then
				CloseMenuDialogs()
			end
      if err then
				ChoGGi.ComFuncs.MsgWait(err, T(302535920011642, "Quickload"))
      end
    end)
	end,
	ActionShortcut = "Ctrl-F9",
	replace_matching_id = true,
	ActionBindable = true,
}

--
Actions[#Actions+1] = {ActionName = T(302535920012094, "Dialog Shortcut 1"),
	ActionId = "ChoGGi.RebindHardcodedKeys.DialogShortcut1",
	replace_matching_id = true,
	ActionBindable = true,
}

Actions[#Actions+1] = {ActionName = T(302535920012095, "Dialog Shortcut 2"),
	ActionId = "ChoGGi.RebindHardcodedKeys.DialogShortcut2",
	replace_matching_id = true,
	ActionBindable = true,
}

Actions[#Actions+1] = {ActionName = T(302535920012096, "Dialog Shortcut 3"),
	ActionId = "ChoGGi.RebindHardcodedKeys.DialogShortcut3",
	replace_matching_id = true,
	ActionBindable = true,
}

Actions[#Actions+1] = {ActionName = T(302535920012097, "Dialog Shortcut 4"),
	ActionId = "ChoGGi.RebindHardcodedKeys.DialogShortcut4",
	replace_matching_id = true,
	ActionBindable = true,
}

local num_overrides = {
	["idChoice1"] = "DialogShortcut1",
	["idChoice2"] = "DialogShortcut2",
	["idChoice3"] = "DialogShortcut3",
	["idChoice4"] = "DialogShortcut4",
}
--~ ForceActivateStoryBit("Boost5_LeapForward", ActiveMapID, nil, true)
local function OverrideActionNew()
	local ChoOrig_XAction_new = XAction.new
	function XAction.new(obj, context, ...)
		if not context then
			return ChoOrig_XAction_new(obj, context, ...)
		end

		local override = num_overrides[context.ActionId]
		if override then
			local keys = GetShortcuts("ChoGGi.RebindHardcodedKeys." .. num_overrides[context.ActionId])
			if keys then
				if keys[1] then
					context.ActionShortcut = keys[1]
				elseif keys[2] then
					context.ActionShortcut = keys[2]
				elseif keys[3] then
					context.ActionShortcut = keys[3]
				end
			end
		end

		return ChoOrig_XAction_new(obj, context, ...)
	end
end

OnMsg.NewCity = OverrideActionNew
OnMsg.LoadGame = OverrideActionNew
--
GlobalVar("g_ChoGGi_MoreKeybinds_ResourceIconsOpacity", false)
local function UpdateOpacity(value)
	if not value then
		value = g_ChoGGi_MoreKeybinds_ResourceIconsOpacity or 100
	end
	-- list of objs on current map
	local objs = MapGet("map", "SubsurfaceDeposit", function(d)
		if d.revealed then
			return true
		end
	end) or "" -- I thought MapGet always returned a table...

	for i = 1, #objs do
		local obj = objs[i]
		if IsValid(obj) then
			pcall(obj.SetOpacity, obj, value)
		end
	end
end
Actions[#Actions+1] = {ActionName = T(0000, "Resource Icons Opacity"),
	ActionId = "ChoGGi.RebindHardcodedKeys.ResourceIconsOpacity",
	ActionShortcut = "Ctrl-I",
	replace_matching_id = true,
	OnAction = function()
		-- get new opacity to use
		local current = g_ChoGGi_MoreKeybinds_ResourceIconsOpacity or 100
		local new = current - mod_OpacityStepSize
		if new < 0 then
			new = 100
		end

		UpdateOpacity(new)

		-- save current opacity
		g_ChoGGi_MoreKeybinds_ResourceIconsOpacity = new
	end,
	ActionBindable = true,
	ActionMode = "Game",
}
-- Map overview transition will reset opacity
OnMsg.CameraTransitionEnd = UpdateOpacity
-- Might help some log spam
local function UpdateOpacityDelay()
	CreateRealTimeThread(function()
		Sleep(5000)
		UpdateOpacity()
	end)
end
OnMsg.CityStart = UpdateOpacityDelay
OnMsg.LoadGame = UpdateOpacityDelay
OnMsg.ChangeMapDone = UpdateOpacityDelay
--
Actions[#Actions+1] = {ActionName = T(0000, "Fill Selected Depot"),
	ActionId = "ChoGGi.RebindHardcodedKeys.FillSelectedDepot",
	OnAction = function()
		local obj = SelectedObj
		if not obj then
			return
		end

		if obj.CheatFill then
			obj:CheatFill()
		end
		if obj.CheatRefill then
			obj:CheatRefill()
		end
		if obj.CheatFillDepot then
			obj:CheatFillDepot()
		end
	end,
	ActionShortcut = "Ctrl-F",
	replace_matching_id = true,
	ActionBindable = true,
	ActionMode = "Game",
}
--
-- I doubt it'll cause any issues, but might as well hide buttons from people without B&B
if g_AvailableDlc.picard then
	Actions[#Actions+1] = {ActionName = T(0000, "Change Map Surface"),
		ActionId = "ChoGGi.RebindHardcodedKeys.ChangeMapSurface",
		OnAction = function()
			CreateRealTimeThread(function()
				UpdateToMap(UIColony.surface_map_id)
			end)
		end,
		ActionShortcut = "Ctrl-1",
		replace_matching_id = true,
		ActionBindable = true,
		ActionMode = "Game",
	}
	Actions[#Actions+1] = {ActionName = T(0000, "Change Map Underground"),
		ActionId = "ChoGGi.RebindHardcodedKeys.ChangeMapUnderground",
		OnAction = function()
			if UIColony.underground_map_unlocked then
				CreateRealTimeThread(function()
					UpdateToMap(UIColony.underground_map_id)
				end)
			end
		end,
		ActionShortcut = "Ctrl-2",
		replace_matching_id = true,
		ActionBindable = true,
		ActionMode = "Game",
	}
	-- loop for asteroids, I'm adding 8 keys for my mod that allows more than 3
	local function IsAsteroidEnabled(index)
		local asteroid = UIColony.asteroids[index]
		return asteroid and asteroid.available
	end
	for i = 3, 10 do
		local asteroid_idx = i - 2
		if i == 10 then
			i = 0
		end
		Actions[#Actions+1] = {ActionName = T(0000, "Change Map Asteroid " .. asteroid_idx),
			ActionId = "ChoGGi.RebindHardcodedKeys.ChangeMapAsteroid" .. asteroid_idx,
			OnAction = function()
				if IsAsteroidEnabled(asteroid_idx) then
					CreateRealTimeThread(function()
						UpdateToMap(UIColony.asteroids[asteroid_idx].map)
					end)
				end
			end,
			ActionShortcut = "Ctrl-" .. i,
			replace_matching_id = true,
			ActionBindable = true,
			ActionMode = "Game",
		}
	end
end
--
--
--
--
--
--
