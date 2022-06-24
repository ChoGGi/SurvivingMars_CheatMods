-- See LICENSE for terms

local SelObjects = ChoGGi.ComFuncs.SelObjects
local GetCursorWorldPos = GetCursorWorldPos
local OpenInExamineDlg = ChoGGi.ComFuncs.OpenInExamineDlg
local terminal = terminal


local mod_SpeedFour
local mod_SpeedFive

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_SpeedFour = CurrentModOptions:GetProperty("SpeedFour")
	mod_SpeedFive = CurrentModOptions:GetProperty("SpeedFive")
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
		local radius = ChoGGi.UserSettings.ExamineObjectRadius or 2500
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
local filename

Actions[#Actions+1] = {ActionName = T(302535920011641, "Quicksave"),
	ActionId = "ChoGGi.AddQuicksaveHotkey.Quicksave",
	OnAction = function()
		if not UICity then
			return
		end

		CreateRealTimeThread(function()
			DeleteGame(filename or "Quicksave.savegame.sav")
			local err
			err, filename = SaveAutosaveGame("Quicksave")

			if err then
				ChoGGi.ComFuncs.MsgPopup(err, T(302535920011641, "Quicksave"))
			else
				ChoGGi.ComFuncs.MsgPopup(filename, T(302535920011641, "Quicksave"), {expiration = 3})
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
--~ 			LoadingScreenOpen("idLoadingScreen", "LoadSaveGame")
			local err = LoadGame(filename or "Quicksave.savegame.sav")
			if not err then
				CloseMenuDialogs()
			end
      if err then
				ChoGGi.ComFuncs.MsgWait(err, T(302535920011642, "Quickload"))
      end
--~ 			LoadingScreenClose("idLoadingScreen", "LoadSaveGame")
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

OnMsg.LoadGame = OverrideActionNew
OnMsg.NewCity = OverrideActionNew
--~ --



--~ -- Camera panning
--~ local cameraRTS = cameraRTS
--~ local function PanCamera(cmd, dist)
--~ 	local cur_pos, cur_la = cameraRTS.GetPosLookAt()
--~ 	local cur_off = cur_la - cur_pos

--~ 	-- +x left -x right +y up -y down
--~ 	local la = cur_la[cmd](cur_la, dist)

--~ 	local pos = la - cur_off

--~ 	cameraRTS.SetCamera(pos, la, 100)

--~ end

--[[
-- remove orig actions
function OnMsg.ShortcutsReloaded()
	local target = XShortcutsTarget
	target:RemoveAction(target:ActionById("actionPanUp"))
	target:RemoveAction(target:ActionById("actionPanDown"))
	target:RemoveAction(target:ActionById("actionPanLeft"))
	target:RemoveAction(target:ActionById("actionPanRight"))
end
]]
--~ Actions[#Actions+1] = {ActionName = T(0000, "Pan RTS Camera Left"),
--~ 	ActionId = "ChoGGi.RebindHardcodedKeys.PanRTSCameraLeft",
--~ 	ActionShortcut = "A",
--~ 	replace_matching_id = true,
--~ 	OnAction = function()
--~ 		PanCamera("AddX", 5000)
--~ 	end,
--~ 	ActionBindable = true,
--~ }
--~ Actions[#Actions+1] = {ActionName = T(0000, "Pan RTS Camera Right"),
--~ 	ActionId = "ChoGGi.RebindHardcodedKeys.PanRTSCameraRight",
--~ 	ActionShortcut = "D",
--~ 	replace_matching_id = true,
--~ 	OnAction = function()
--~ 		PanCamera("AddX", -5000)
--~ 	end,
--~ 	ActionBindable = true,
--~ }
--~ Actions[#Actions+1] = {ActionName = T(0000, "Pan RTS Camera Up"),
--~ 	ActionId = "ChoGGi.RebindHardcodedKeys.PanRTSCameraUp",
--~ 	ActionShortcut = "W",
--~ 	replace_matching_id = true,
--~ 	OnAction = function()
--~ 		PanCamera("AddY", 5000)
--~ 	end,
--~ 	ActionBindable = true,
--~ }
--~ Actions[#Actions+1] = {ActionName = T(0000, "Pan RTS Camera Down"),
--~ 	ActionId = "ChoGGi.RebindHardcodedKeys.PanRTSCameraDown",
--~ 	ActionShortcut = "S",
--~ 	replace_matching_id = true,
--~ 	OnAction = function()
--~ 		PanCamera("AddY", -5000)
--~ 	end,
--~ 	ActionBindable = true,
--~ }
