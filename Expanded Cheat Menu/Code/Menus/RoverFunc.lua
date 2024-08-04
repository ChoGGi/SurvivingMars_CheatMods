-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

local ChoGGi_Funcs = ChoGGi_Funcs
local type = type
local T = T
--local Translate = ChoGGi_Funcs.Common.Translate
local MsgPopup = ChoGGi_Funcs.Common.MsgPopup

--~	local RetName = ChoGGi_Funcs.Common.RetName

function ChoGGi_Funcs.Menus.SetRoverChargeRadius()
	local default_setting = 0
	local item_list = {
		{text = T(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 1, value = 1},
		{text = 2, value = 2},
		{text = 3, value = 3},
		{text = 4, value = 4},
		{text = 5, value = 5},
		{text = 10, value = 10},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.RCChargeDist then
		hint = ChoGGi.UserSettings.RCChargeDist
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then

			if value == default_setting then
				ChoGGi.UserSettings.RCChargeDist = nil
			else
				ChoGGi.UserSettings.RCChargeDist = value
			end

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(choice.text),
				T(302535920000541--[[RC Set Charging Distance]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000880--[[Set Rover Charge Radius]]),
		hint = T(302535920000106--[[Current]]) .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SetRCMoveSpeed()
	local r = const.ResourceScale
	local default_setting = ChoGGi.Consts.SpeedRC
	local UpgradedSetting = ChoGGi_Funcs.Common.GetResearchedTechValue("SpeedRC")
	local item_list = {
		{text = T(1000121--[[Default]]) .. ": " .. (default_setting / r), value = default_setting, hint = T(302535920000889--[[base speed]])},
		{text = 5, value = 5 * r},
		{text = 10, value = 10 * r},
		{text = 15, value = 15 * r},
		{text = 25, value = 25 * r},
		{text = 50, value = 50 * r},
		{text = 100, value = 100 * r},
		{text = 1000, value = 1000 * r},
		{text = 10000, value = 10000 * r},
	}
	if default_setting ~= UpgradedSetting then
		table.insert(item_list, 2, {text = T(302535920000890--[[Upgraded]]) .. ": " .. (UpgradedSetting / r), value = UpgradedSetting, hint = T(302535920000891--[[apply tech unlocks]])})
	end

	local hint = UpgradedSetting
	if ChoGGi.UserSettings.SpeedRC then
		hint = ChoGGi.UserSettings.SpeedRC
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			ChoGGi_Funcs.Common.SetSavedConstSetting("SpeedRC", value)
			local objs = UIColony.city_labels.labels.Rover or ""
			for i = 1, #objs do
				objs[i]:SetBase("move_speed", value)
			end

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(choice.text),
				T(302535920000543--[[RC Move Speed]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000543--[[RC Move Speed]]),
		hint = T(302535920000106--[[Current]]) .. ": " .. hint .. "\n\n"
			.. T(302535920001085--[[Setting speed to a non integer (e.g 2.5) crashes the game!]]),
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.RCTransportInstantTransfer_Toggle()
	ChoGGi_Funcs.Common.SetConsts("RCRoverTransferResourceWorkTime", ChoGGi_Funcs.Common.NumRetBool(Consts.RCRoverTransferResourceWorkTime, 0, ChoGGi.Consts.RCRoverTransferResourceWorkTime))
	ChoGGi_Funcs.Common.SetConsts("RCTransportGatherResourceWorkTime", ChoGGi_Funcs.Common.NumRetBool(Consts.RCTransportGatherResourceWorkTime, 0, ChoGGi_Funcs.Common.GetResearchedTechValue("RCTransportGatherResourceWorkTime")))
	ChoGGi_Funcs.Common.SetSavedConstSetting("RCRoverTransferResourceWorkTime")
	ChoGGi_Funcs.Common.SetSavedConstSetting("RCTransportGatherResourceWorkTime")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.RCRoverTransferResourceWorkTime),
		T(302535920000549--[[RC Instant Resource Transfer]])
	)
end

function ChoGGi_Funcs.Menus.SetRCTransportStorageCapacity()
	local r = const.ResourceScale
	local default_setting = ChoGGi_Funcs.Common.GetResearchedTechValue("RCTransportStorageCapacity") / r
	local item_list = {
		{text = T(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 2000, value = 2000, hint = T(302535920000925--[[somewhere above 2000 will delete the save (when it's full)]])},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.RCTransportStorageCapacity then
		hint = ChoGGi.UserSettings.RCTransportStorageCapacity / r
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			local default = value == default_setting

			local value = value * r
			-- somewhere above 2000 screws the save
			if value > 2000000 then
				value = 2000000
			end
			-- for any rc constructors
			local rc_con_value = ChoGGi_Funcs.Common.GetResearchedTechValue("RCTransportStorageCapacity", "RCConstructor")

			-- loop through and set all
			if UIColony then
				local label = UIColony:GetCityLabels("RCTransportAndChildren")
				for i = 1, #label do
					local rc = label[i]
					if default and rc:IsKindOf("RCConstructor") then
						rc.max_shared_storage = rc_con_value
					else
						rc.max_shared_storage = value
					end
				end
			end

			if default then
				ChoGGi.UserSettings.RCTransportStorageCapacity = nil
			else
				ChoGGi_Funcs.Common.SetSavedConstSetting("RCTransportStorageCapacity", value)
			end

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(choice.text),
				T(302535920000551--[[RC Storage Capacity]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000927--[[Set RC Transport Capacity]]),
		hint = T(302535920000914--[[Current capacity]]) .. ": " .. hint,
		skip_sort = true,
	}
end

