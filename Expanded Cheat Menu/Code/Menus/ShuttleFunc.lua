-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

local ChoGGi_Funcs = ChoGGi_Funcs
local tostring, type = tostring, type
local T = T
local MsgPopup = ChoGGi_Funcs.Common.MsgPopup
local Translate = ChoGGi_Funcs.Common.Translate

function ChoGGi_Funcs.Menus.SetShuttleCapacity()
	local r = const.ResourceScale
	local default_setting = ChoGGi.Consts.StorageShuttle / r
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 5, value = 5},
		{text = 10, value = 10},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000, hint = T(302535920000928--[[somewhere above 1000 may delete the save (when it's full)]])},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.StorageShuttle then
		hint = ChoGGi.UserSettings.StorageShuttle / r
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			local value = value * r
			-- not tested but I assume too much = dead save as well (like rc and transport)
			if value > 1000000 then
				value = 1000000
			end

			ChoGGi_Funcs.Common.SetSavedConstSetting("StorageShuttle", value)
			ChoGGi_Funcs.Settings.WriteSettings()

			-- loop through and set all shuttles
			local objs = UIColony:GetCityLabels("CargoShuttle")
			for i = 1, #objs do
				objs[i].max_shared_storage = value
			end
			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(choice.text),
				T(302535920000930--[[Set Cargo Shuttle Capacity]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000930--[[Set Cargo Shuttle Capacity]]),
		hint = T(302535920000914--[[Current capacity]]) .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SetShuttleSpeed()
	local r = const.ResourceScale
	local default_setting = ChoGGi.Consts.SpeedShuttle / r
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 5000, value = 5000},
		{text = 10000, value = 10000},
		{text = 25000, value = 25000},
		{text = 50000, value = 50000},
		{text = 100000, value = 100000},
	}

	local hint_str = default_setting
	if ChoGGi.UserSettings.SpeedShuttle then
		hint_str = ChoGGi.UserSettings.SpeedShuttle / r
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			local value = value * r
			-- loop through and set all shuttles
			local objs = UIColony:GetCityLabels("CargoShuttle")
			for i = 1, #objs do
				objs[i]:SetBase("move_speed", value)
			end
			ChoGGi_Funcs.Common.SetSavedConstSetting("SpeedShuttle", value)

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(choice.text),
				T(302535920000932--[[Set Cargo Shuttle Speed]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000932--[[Set Cargo Shuttle Speed]]),
		hint = T{302535920000933--[["Current speed: <color ChoGGi_green><str></color>"]],
			str = hint_str,
		},
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SetShuttleHubShuttleCapacity()
	local default_setting = ChoGGi.Consts.ShuttleHubShuttleCapacity
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
	}

	--check if there's an entry for building
	if not ChoGGi.UserSettings.BuildingSettings.ShuttleHub then
		ChoGGi.UserSettings.BuildingSettings.ShuttleHub = {}
	end

	local hint_str = default_setting
	local setting = ChoGGi.UserSettings.BuildingSettings.ShuttleHub
	if setting and setting.shuttles then
		hint_str = tostring(setting.shuttles)
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			-- loop through and set all shuttles
			local objs = UIColony:GetCityLabels("ShuttleHub")
			for i = 1, #objs do
				objs[i].max_shuttles = value
			end
			if value == default_setting then
				ChoGGi.UserSettings.BuildingSettings.ShuttleHub.shuttles = nil
			else
				ChoGGi.UserSettings.BuildingSettings.ShuttleHub.shuttles = value
			end
		end

		ChoGGi_Funcs.Settings.WriteSettings()
		MsgPopup(
			ChoGGi_Funcs.Common.SettingState(choice.text),
			T(302535920000535--[[Set ShuttleHub Shuttle Capacity]])
		)
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000535--[[Set ShuttleHub Shuttle Capacity]]),
		hint = T(302535920000914--[[Current capacity]]) .. ": " .. hint_str,
		skip_sort = true,
	}
end
