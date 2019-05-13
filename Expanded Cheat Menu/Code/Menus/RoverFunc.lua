-- See LICENSE for terms

local type = type

local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local Strings = ChoGGi.Strings
local Translate = ChoGGi.ComFuncs.Translate
--~	local RetName = ChoGGi.ComFuncs.RetName

function ChoGGi.MenuFuncs.SetRoverChargeRadius()
	local default_setting = 0
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting, value = default_setting},
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

	--other hint type
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

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice.text),
				Strings[302535920000541--[[RC Set Charging Distance--]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000880--[[Set Rover Charge Radius--]]],
		hint = Strings[302535920000106--[[Current--]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetRCMoveSpeed()
	local r = const.ResourceScale
	local default_setting = ChoGGi.Consts.SpeedRC
	local UpgradedSetting = ChoGGi.ComFuncs.GetResearchedTechValue("SpeedRC")
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. (default_setting / r), value = default_setting, hint = Strings[302535920000889--[[base speed--]]]},
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
		table.insert(item_list, 2, {text = Strings[302535920000890--[[Upgraded--]]] .. ": " .. (UpgradedSetting / r), value = UpgradedSetting, hint = Strings[302535920000891--[[apply tech unlocks--]]]})
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
			ChoGGi.ComFuncs.SetSavedConstSetting("SpeedRC", value)
			local objs = UICity.labels.Rover or ""
			for i = 1, #objs do
				objs[i]:SetMoveSpeed(value)
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice.text),
				Strings[302535920000543--[[RC Move Speed--]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000543--[[RC Move Speed--]]],
		hint = Strings[302535920000106--[[Current--]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetGravityRC()
	local default_setting = ChoGGi.Consts.GravityRC
	local r = const.ResourceScale
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting, value = default_setting},
		{text = 1, value = 1},
		{text = 2, value = 2},
		{text = 3, value = 3},
		{text = 4, value = 4},
		{text = 5, value = 5},
		{text = 10, value = 10},
		{text = 15, value = 15},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.GravityRC then
		hint = ChoGGi.UserSettings.GravityRC / r
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			local value = value * r
			local objs = UICity.labels.Rover or ""
			for i = 1, #objs do
				objs[i]:SetGravity(value)
			end
			ChoGGi.ComFuncs.SetSavedConstSetting("GravityRC", value)

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice.text),
				Strings[302535920000545--[[RC Gravity--]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000920--[[Set RC Gravity--]]],
		hint = Strings[302535920000841--[[Current gravity: %s--]]]:format(hint),
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.RCTransportInstantTransfer_Toggle()
	ChoGGi.ComFuncs.SetConstsG("RCRoverTransferResourceWorkTime", ChoGGi.ComFuncs.NumRetBool(Consts.RCRoverTransferResourceWorkTime, 0, ChoGGi.Consts.RCRoverTransferResourceWorkTime))
	ChoGGi.ComFuncs.SetConstsG("RCTransportGatherResourceWorkTime", ChoGGi.ComFuncs.NumRetBool(Consts.RCTransportGatherResourceWorkTime, 0, ChoGGi.ComFuncs.GetResearchedTechValue("RCTransportGatherResourceWorkTime")))
	ChoGGi.ComFuncs.SetSavedConstSetting("RCRoverTransferResourceWorkTime")
	ChoGGi.ComFuncs.SetSavedConstSetting("RCTransportGatherResourceWorkTime")

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.RCRoverTransferResourceWorkTime),
		Strings[302535920000549--[[RC Instant Resource Transfer--]]]
	)
end

function ChoGGi.MenuFuncs.SetRCTransportStorageCapacity()
	local r = const.ResourceScale
	local default_setting = ChoGGi.ComFuncs.GetResearchedTechValue("RCTransportStorageCapacity") / r
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting, value = default_setting},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 2000, value = 2000, hint = Strings[302535920000925--[[somewhere above 2000 will delete the save (when it's full)--]]]},
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
			local rc_con_value = ChoGGi.ComFuncs.GetResearchedTechValue("RCTransportStorageCapacity", "RCConstructor")

			-- loop through and set all
			if GameState.gameplay then
				local label = UICity.labels.RCTransport or ""
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
				ChoGGi.ComFuncs.SetSavedConstSetting("RCTransportStorageCapacity", value)
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice.text),
				Strings[302535920000551--[[RC Storage Capacity--]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000927--[[Set RC Transport Capacity--]]],
		hint = Strings[302535920000914--[[Current capacity--]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetRoverWorkRadius()
	local default_setting = ChoGGi.Consts.RCRoverMaxRadius
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting, value = default_setting},
		{text = 40, value = 40},
		{text = 80, value = 80},
		{text = 160, value = 160},
		{text = 320, value = 320, hint = Strings[302535920000111--[[Cover the entire map from the centre.--]]]},
		{text = 640, value = 640, hint = Strings[302535920000112--[[Cover the entire map from a corner.--]]]},
	}

	--other hint type
	local hint = default_setting
	if ChoGGi.UserSettings.RCRoverMaxRadius then
		hint = ChoGGi.UserSettings.RCRoverMaxRadius
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then

			-- we need to set this so the hex grid during placement is enlarged
			const.RCRoverMaxRadius = value
			ChoGGi.ComFuncs.SetSavedConstSetting("RCRoverMaxRadius")

			local objs = UICity.labels.RCRover or ""
			for i = 1, #objs do
				objs[i]:SetWorkRadius(value)
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.RCRoverMaxRadius),
				Strings[302535920000505--[[Work Radius RC Rover--]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000884--[[Set Rover Work Radius--]]],
		hint = Strings[302535920000106--[[Current--]]] .. ": " .. hint .. "\n\n"
			.. Strings[302535920000115--[[Toggle selection to update visible hex grid.--]]],
		skip_sort = true,
	}
end
