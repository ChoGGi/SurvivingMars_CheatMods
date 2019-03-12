-- See LICENSE for terms

-- collection of res widths
local hud_lookup_table = {
	[5760] = box(2560,0,2560,0),
}
-- value we check for a margin to use
local current_margin

local function WriteModSettings(clear)
	-- clear saved settings
	if clear then
		WriteModPersistentData("")
		return
	end

	local err, data = AsyncCompress(ValueToLuaCode(current_margin), false, "lz4")
	if err then
		print("Centred UI WriteModSettings AsyncCompress:",err)
		return
	end

	local err = WriteModPersistentData(data)
	if err then
		print("Centred UI WriteModSettings WriteModPersistentData:",err)
		return
	end

	return data
end

local function ReadModSettings()
	-- try to read saved settings
	local err,settings_data = ReadModPersistentData()

	if err or not settings_data or settings_data == "" then
		-- no settings found so write default settings (it returns the saved setting)
		settings_data = WriteModSettings()
	end

	err, settings_data = AsyncDecompress(settings_data)
	if err then
		print("Centred UI ReadModSettings 1:",err)
		return
	end

	-- and convert it to lua / update in-game settings
	err, current_margin = LuaCodeToTuple(settings_data)
	if err then
		print("Centred UI ReadModSettings 2:",err)
		return
	end

	return current_margin ~= "" and current_margin
end

-- on startup use either saved margin or check table for res width
current_margin = ReadModSettings() or hud_lookup_table[UIL.GetScreenSize():x()]

-- when res is changed from options try table first then settings
function OnMsg.SystemSize(pt)
	current_margin = hud_lookup_table[pt:x()] or ReadModSettings()
end

-- what the hud elements use to position
local orig_GetSafeMargins = GetSafeMargins
function GetSafeMargins(win_box)
	if win_box then
		return orig_GetSafeMargins(win_box)
	end
	-- if lookup table doesn't have width we fire orginal func
	return current_margin or orig_GetSafeMargins()
end

function OnMsg.ModsReloaded()
	local xt = XTemplates
	local idx = table.find(xt.HUD[1],"Id","idBottom")
	if not idx then
		print([[Centred UI: Missing HUD control idBottom]])
		return
	end
	xt = xt.HUD[1][idx]
	idx = table.find(xt,"Id","idRight")
	if not idx then
		print([[Centred UI: Missing HUD control idRight]])
		return
	end
	xt = xt[idx][1]

	local idx = table.find(xt, "ChoGGi_Template_CentredUI", true)
	if idx then
		xt[idx]:delete()
		table.remove(xt,idx)
	end

	table.insert(xt,#xt,PlaceObj("XTemplateTemplate", {
		"ChoGGi_Template_CentredUI", true,
		"__template", "HUDButtonTemplate",

		"RolloverTitle", [[Set Margin]],
		"RolloverText", [[Allows you to Test/Save a custom margin.
Don't forget to send me your res and margin, so I can add them to the list.]],
		"RolloverHint", T(0,[[<left_click> Show Options <right_click> Test Margin]]),
		"Id", "idSetupMargins",
		"Image", CurrentModPath .. "UI/hud_margin.png",
		"FXPress", "MainMenuButtonClick",
		"OnPress", function()
			HUD.idSetupMarginsOnPress()
		end,
	})
	)
end

-- they don't bother with registering right-clicks on the hud buttons
local orig_HUDButton_Open = HUDButton.Open
function HUDButton:Open()
	orig_HUDButton_Open(self)

	local btn = self[1]
	if btn.Id == "idSetupMargins" then
		btn:SetAltPress(true)
		btn:SetOnAltPress(function()
			HUD.idSetupMarginsOnPress(true)
		end)
	end
end

-- temp setting used for testing
local test_setting

local function SetMargins(choice_str)
	-- display textbox with saved or 0
	local saved = ReadModSettings()
	local margin = WaitInputText(
		choice_str,
		tostring(test_setting or saved and saved:minx() or 0)
	) or ""

	if margin ~= "" then
		-- it returns a string
		margin = tonumber(margin)

		if type(margin) == "number" then
			current_margin = box(margin,0,margin,0)

			if choice_str == [[Save Margin]] then
				WriteModSettings()
				test_setting = nil
			else
				test_setting = margin
			end
		end
	end
end

-- add button to hud to set margin
function HUD.idSetupMarginsOnPress(right)
	CreateRealTimeThread(function()
		-- right means skip straight to test
		if right then
			SetMargins([[Test Margin]])
		else
			local choice_str = WaitListChoice(
				{[[Test Margin]],[[Save Margin]],[[Clear Saved Setting]],[[Use Mod Setting]]},
				[[Set Margin]]
			)

			if not choice_str then
				return
			elseif choice_str == [[Clear Saved Setting]] then
				current_margin = nil
				WriteModSettings(true)
			elseif choice_str == [[Use Mod Setting]] then
				current_margin = hud_lookup_table[UIL.GetScreenSize():x()]
				WriteModSettings()
			else
				SetMargins(choice_str)
			end
		end

		-- update hud margins
		Msg("SafeAreaMarginsChanged")
	end)
end
