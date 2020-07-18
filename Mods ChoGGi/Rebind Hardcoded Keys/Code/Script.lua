-- See LICENSE for terms

-- add keybind for toggle
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
-- key1, key2, gamepad
local key_table = {
	key1 = nil,
	key2 = nil,
	key3 = nil,
}

local function ReturnShortcuts(id)
	local keys = GetShortcuts(id)

	key_table.key1 = nil
	key_table.key2 = nil
	key_table.key3 = nil
	if keys[1] then
		key_table.key1 = VKStrNamesInverse[keys[1]]
	end
	if keys[2] then
		key_table.key2 = VKStrNamesInverse[keys[2]]
	end
	if keys[3] then
		key_table.key3 = VKStrNamesInverse[keys[3]]
	end

	return key_table.key1, key_table.key2, key_table.key3
end


local orig_ConstructionModeDialog_OnKbdKeyDown = ConstructionModeDialog.OnKbdKeyDown
function ConstructionModeDialog:OnKbdKeyDown(virtual_key, ...)
	-- check if input is key set in binds
	local back1, back2, back3 = ReturnShortcuts("ChoGGi.RebindHardcodedKeys.CycleVisualVariantBackward")
	local for1, for2, for3 = ReturnShortcuts("ChoGGi.RebindHardcodedKeys.CycleVisualVariantForward")
	local cancel1, cancel2, cancel3 = ReturnShortcuts("ChoGGi.RebindHardcodedKeys.ConstructionCancel")

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
