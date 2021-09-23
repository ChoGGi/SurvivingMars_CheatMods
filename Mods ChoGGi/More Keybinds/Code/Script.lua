-- See LICENSE for terms

local SelObjects = ChoGGi.ComFuncs.SelObjects
local GetCursorWorldPos = GetCursorWorldPos
local OpenInExamineDlg = ChoGGi.ComFuncs.OpenInExamineDlg
local Strings = ChoGGi.Strings

local Actions = ChoGGi.Temp.Actions

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

		local terminal = terminal

		-- next we check if there's a ui element under the cursor and return that
		local target = terminal.desktop:GetMouseTarget(terminal.GetMousePos())
		-- everywhere is covered in xdialogs so skip them
		if target and not target:IsKindOf("XDialog") then
			return OpenInExamineDlg(target)
		end

		-- If in main menu then open examine and console
		if not Dialogs.HUD then
			local dlg = OpenInExamineDlg(terminal.desktop)
--~ 			-- off centre of central monitor
--~ 			local width = (terminal.desktop.measure_width or 1920) - (dlg.dialog_width_scaled + 100)
--~ 			dlg:SetPos(point(width, 100))
--~ 			ChoGGi.ComFuncs.ToggleConsole(true)
		end
	end,
	ActionBindable = true,
}

Actions[#Actions+1] = {ActionName = Strings[302535920000069--[[Examine]]] .. " " .. Strings[302535920001103--[[Objects]]] .. " " .. Strings[302535920000163--[[Radius]]],
	ActionId = "ChoGGi.RebindHardcodedKeys.ExamineObjectRadius",
	ActionShortcut = "Shift-F4",
	replace_matching_id = true,
	OnAction = function()
		local pt
		local function SortDist(a, b)
			return a:GetDist2D(pt) < b:GetDist2D(pt)
		end
		function ChoGGi.MenuFuncs.ExamineObjectRadius()
			local radius = ChoGGi.UserSettings.ExamineObjectRadius or 2500
			local objs = SelObjects(radius)
			if objs[1] then
				pt = GetCursorWorldPos()
				-- sort by nearest
				table.sort(objs, SortDist)

				OpenInExamineDlg(objs, {
					has_params = true,
					override_title = true,
					title = Strings[302535920000069--[[Examine]]] .. " "
						.. Strings[302535920001103--[[Objects]]] .. " "
						.. Strings[302535920000163--[[Radius]]] .. ": " .. radius,
				})
			end
		end
	end,
	ActionBindable = true,
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
}

Actions[#Actions+1] = {ActionName = T(302535920011698, "Cycle Visual Variant Backward"),
	ActionId = "ChoGGi.RebindHardcodedKeys.CycleVisualVariantBackward",
	ActionShortcut = "[",
	replace_matching_id = true,
	ActionBindable = true,
}
Actions[#Actions+1] = {ActionName = T(302535920011699, "Cycle Visual Variant Forward"),
	ActionId = "ChoGGi.RebindHardcodedKeys.CycleVisualVariantForward",
	ActionShortcut = "]",
	replace_matching_id = true,
	ActionBindable = true,
}

Actions[#Actions+1] = {ActionName = T(302535920011700, "Construction Cancel"),
	ActionId = "ChoGGi.RebindHardcodedKeys.ConstructionCancel",
	ActionShortcut = "Escape",
	replace_matching_id = true,
	ActionBindable = true,
}

-- Cycle Visual Variant/Construction Cancel
local GetShortcuts = GetShortcuts
local VKStrNamesInverse = VKStrNamesInverse
local function RetShortcuts(id)
	local keys = GetShortcuts(id)

	return keys[1] and VKStrNamesInverse[keys[1]],
		keys[2] and VKStrNamesInverse[keys[2]],
		keys[31] and VKStrNamesInverse[keys[3]]
end

local orig_ConstructionModeDialog_OnKbdKeyDown = ConstructionModeDialog.OnKbdKeyDown
function ConstructionModeDialog:OnKbdKeyDown(virtual_key, ...)
	-- check if input is key set in binds
	local back1, back2, back3 = RetShortcuts("ChoGGi.RebindHardcodedKeys.CycleVisualVariantBackward")
	local for1, for2, for3 = RetShortcuts("ChoGGi.RebindHardcodedKeys.CycleVisualVariantForward")
	local cancel1, cancel2, cancel3 = RetShortcuts("ChoGGi.RebindHardcodedKeys.ConstructionCancel")

	-- fire off orig func with default key sent
	if virtual_key == cancel1 or virtual_key == cancel2 or virtual_key == cancel3 then
		return orig_ConstructionModeDialog_OnKbdKeyDown(self, const.vkEsc, ...)
	elseif virtual_key == for1 or virtual_key == for2 or virtual_key == for3 then
		return orig_ConstructionModeDialog_OnKbdKeyDown(self, const.vkClosesq, ...)
	elseif virtual_key == back1 or virtual_key == back2 or virtual_key == back3 then
		return orig_ConstructionModeDialog_OnKbdKeyDown(self, const.vkOpensq, ...)
	end

	return "continue"
end
--
Actions[#Actions+1] = {ActionName = T(302535920011974, "Place Multiple Buildings"),
	ActionId = "ChoGGi.RebindHardcodedKeys.PlaceMultipleBuildings",
	ActionShortcut = "Shift",
	replace_matching_id = true,
	ActionBindable = true,
}

local IsKeyPressed = terminal.IsKeyPressed

local orig_IsPlacingMultipleConstructions = IsPlacingMultipleConstructions
function IsPlacingMultipleConstructions(...)
	local shift1, shift2, shift3 = RetShortcuts("ChoGGi.RebindHardcodedKeys.PlaceMultipleBuildings")
	if IsKeyPressed(shift1) or IsKeyPressed(shift2) or IsKeyPressed(shift3) then
    return true
	end

	return orig_IsPlacingMultipleConstructions(...)
end

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
