-- See LICENSE for terms

-- add keybind for toggle
local Actions = ChoGGi.Temp.Actions
Actions[#Actions+1] = {ActionName = T(0000, "Salvage Cursor"),
	ActionId = "ChoGGi.RebindHardcodedKeys.SalvageCursor",
	ActionShortcut = "Ctrl-Delete",
	replace_matching_id = true,
	OnAction = function()
		local igi = GetInGameInterface()
		if igi.mode == "selection" then
			g_LastBuildItem = "Salvage"
			igi:SetMode("demolish")
			PlayFX("DemolishButton", "start")
		else
			igi:SetMode("selection")
		end
	end,
	ActionBindable = true,
}
local Actions = ChoGGi.Temp.Actions
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
