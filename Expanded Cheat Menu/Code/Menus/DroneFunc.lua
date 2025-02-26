-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

local ChoGGi_Funcs = ChoGGi_Funcs
local tostring, type = tostring, type
local T = T
local Translate = ChoGGi_Funcs.Common.Translate

local MsgPopup = ChoGGi_Funcs.Common.MsgPopup
local SetPropertyProp = ChoGGi_Funcs.Common.SetPropertyProp

function ChoGGi_Funcs.Menus.SetDroneBatteryCap()
	local default_setting = ChoGGi_Funcs.Common.GetResearchedTechValue("DroneBatteryMax")
	local r = const.ResourceScale

	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. (default_setting / r), value = default_setting},
		{text = 10, value = 10 * r},
		{text = 25, value = 25 * r},
		{text = 50, value = 50 * r},
		{text = 100, value = 100 * r},
		{text = 125, value = 125 * r},
		{text = 250, value = 250 * r},
		{text = 500, value = 500 * r},
		{text = 1000, value = 1000 * r},
		{text = 10000, value = 10000 * r},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.DroneBatteryMax then
		hint = ChoGGi.UserSettings.DroneBatteryMax
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then

			-- I doubt updating this matters...
			const.DroneBatteryMax = value

			local objs = UIColony:GetCityLabels("Drone")
			for i = 1, #objs do
				objs[i].battery_max = value
			end

			if value == default_setting then
				ChoGGi.UserSettings.DroneBatteryMax = nil
			else
				ChoGGi.UserSettings.DroneBatteryMax = value
			end

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.DroneBatteryMax),
				T(302535920000051--[[Drone Battery Cap]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000051--[[Drone Battery Cap]]),
		hint = T(302535920000106--[[Current]]) .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SetDroneType()
	local icons = Presets.EncyclopediaArticle.Vehicles
	local item_list = {
		{
			text = Translate(10278--[[Wasp Drone]]),
			value = "FlyingDrone",
			hint = "<image " .. icons.FlyingDrone.image .. ">\n\n" .. T(10278--[[Wasp Drone]]),
		},
		{
			text = Translate(1681--[[Drone]]),
			value = "Drone",
			hint = "<image " .. icons.Drone.image .. ">\n\n" .. T(1681--[[Drone]]),
		},
	}
	local sponsor = GetMissionSponsor()

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		sponsor.drone_class = choice[1].value
		MsgPopup(
			Translate(302535920001405--[[Drones will now spawn as: %s]]):format(choice[1].text),
			T(302535920001403--[[Drone Type]])
		)
	end

	-- If nothing is set than it's regular drones
	local name = g_Classes[sponsor.drone_class]
	name = name and name.display_name or 1681--[[Drone]]

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920001403--[[Drone Type]]),
		hint = T(302535920000106--[[Current]]) .. ": " .. Translate(name) .. "\n"
			.. T{302535920001406--[["Hubs can only have one type of drone, so you'll need pack/unpack all drones for each hub you wish to change (or use Drones>%s)."]],
				str = T(302535920000513--[[Change Amount of Drones in Hub]]),
			},
	}
end

function ChoGGi_Funcs.Menus.SetRoverWorkRadius()
	local default_setting = ChoGGi.Consts.RCRoverMaxRadius
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 40, value = 40},
		{text = 80, value = 80},
		{text = 160, value = 160},
		{text = 320, value = 320, hint = T(302535920000111--[[Cover the entire map from the centre.]])},
		{text = 640, value = 640, hint = T(302535920000112--[[Cover the entire map from a corner.]])},
	}

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
			ChoGGi_Funcs.Common.SetSavedConstSetting("RCRoverMaxRadius")
			RCRover.service_area_max = value

			local objs = UIColony:GetCityLabels("RCRoverAndChildren")
			for i = 1, #objs do
				local obj = objs[i]
				SetPropertyProp(obj, "UIWorkRadius", "max", value)
				obj:SetWorkRadius(value)
				obj.service_area_max = value
			end

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.RCRoverMaxRadius),
				T(302535920000505--[[Work Radius RC Rover]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000884--[[Set Rover Work Radius]]),
		hint = T(302535920000106--[[Current]]) .. ": " .. hint .. "\n\n"
			.. T(302535920000115--[[Toggle selection to update visible hex grid.]]),
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SetDroneHubWorkRadius()
	local default_setting = ChoGGi.Consts.CommandCenterMaxRadius
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 40, value = 40},
		{text = 80, value = 80},
		{text = 160, value = 160},
		{text = 320, value = 320, hint = T(302535920000111--[[Cover the entire map from the centre.]])},
		{text = 640, value = 640, hint = T(302535920000112--[[Cover the entire map from a corner.]])},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.CommandCenterMaxRadius then
		hint = ChoGGi.UserSettings.CommandCenterMaxRadius
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then

			-- we need to set this so the hex grid during placement is enlarged
			const.CommandCenterMaxRadius = value
			ChoGGi_Funcs.Common.SetSavedConstSetting("CommandCenterMaxRadius")
			DroneHub.service_area_max = value

			local objs = UIColony:GetCityLabels("DroneHub")
			for i = 1, #objs do
				local obj = objs[i]
				SetPropertyProp(obj, "UIWorkRadius", "max", value)
				obj:SetWorkRadius(value)
				obj.service_area_max = value
			end

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.CommandCenterMaxRadius),
				T(302535920000507--[[Work Radius DroneHub]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000886--[[Set DroneHub Work Radius]]),
		hint = T(302535920000106--[[Current]]) .. ": " .. hint .. "\n\n"
			.. T(302535920000115--[[Toggle selection to update visible hex grid.]]),
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SetDroneRockToConcreteSpeed()
	local default_setting = ChoGGi.Consts.DroneTransformWasteRockObstructorToStockpileAmount
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 0, value = 0},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.DroneTransformWasteRockObstructorToStockpileAmount then
		hint = ChoGGi.UserSettings.DroneTransformWasteRockObstructorToStockpileAmount
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			ChoGGi_Funcs.Common.SetConsts("DroneTransformWasteRockObstructorToStockpileAmount", value)
			ChoGGi_Funcs.Common.SetSavedConstSetting("DroneTransformWasteRockObstructorToStockpileAmount")

			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(choice.text),
				T(302535920000509--[[Drone Rock To Concrete Speed]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000509--[[Drone Rock To Concrete Speed]]),
		hint = T(302535920000106--[[Current]]) .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SetDroneMoveSpeed(action)
	if not action then
		return
	end

	local speed = action.setting_speed
	local title = action.setting_title

	local r = const.ResourceScale
	local default_setting = ChoGGi.Consts[speed]
	local UpgradedSetting
	if speed == "SpeedDrone" then
		UpgradedSetting = ChoGGi_Funcs.Common.GetResearchedTechValue("SpeedDrone")
	end
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. (default_setting / r), value = default_setting, hint = T(302535920000889--[[base speed]])},
		{text = 2, value = 2 * r, hint = "2000"},
		{text = 3, value = 3 * r, hint = "3000"},
		{text = 4, value = 4 * r, hint = "4000"},
		{text = 5, value = 5 * r, hint = "5000"},
		{text = 10, value = 10 * r, hint = "10000"},
		{text = 15, value = 15 * r, hint = "15000"},
		{text = 25, value = 25 * r, hint = "25000"},
		{text = 50, value = 50 * r, hint = "50000"},
		{text = 100, value = 100 * r, hint = "100000"},
		{text = 1000, value = 1000 * r, hint = "100000"},
		{text = 10000, value = 10000 * r, hint = "10000000"},
	}

	-- only reg drones have upgraded speed tech (i think)
	if UpgradedSetting and default_setting ~= UpgradedSetting then
		table.insert(item_list, 2, {text = Translate(302535920000890--[[Upgraded]]) .. ": " .. (UpgradedSetting / r), value = UpgradedSetting, hint = T(302535920000891--[[apply tech unlocks]])})
	end

	local hint = UpgradedSetting or default_setting
	if UpgradedSetting then
		if ChoGGi.UserSettings.SpeedDrone then
			hint = ChoGGi.UserSettings.SpeedDrone
		end
	else
		if ChoGGi.UserSettings.SpeedWaspDrone then
			hint = ChoGGi.UserSettings.SpeedWaspDrone
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			local objs = UIColony:GetCityLabels("Drone")

			if UpgradedSetting then
				for i = 1, #objs do
					local obj = objs[i]
					if not obj:IsKindOf("FlyingDrone") then
						obj:SetBase("move_speed", value)
					end
				end
				ChoGGi_Funcs.Common.SetSavedConstSetting("SpeedDrone", value)
			else
				for i = 1, #objs do
					local obj = objs[i]
					if obj:IsKindOf("FlyingDrone") then
						obj:SetBase("move_speed", value)
					end
				end
				ChoGGi_Funcs.Common.SetSavedConstSetting("SpeedWaspDrone", value)
			end

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(choice.text),
				title
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = title,
		hint = T(302535920000106--[[Current]]) .. ": " .. hint .. "\n\n"
			.. T(302535920001085--[[Setting speed to a non integer (e.g 2.5) crashes the game!]]),
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SetDroneAmountDroneHub()
	local obj = ChoGGi_Funcs.Common.SelObject()
	if not obj or not obj:IsKindOf("DroneControl") then
		return
	end

	local CurrentAmount = obj:GetDronesCount()
	local item_list = {
		{text = Translate(302535920000894--[[Current amount]]) .. ": " .. CurrentAmount, value = CurrentAmount},
		{text = 1, value = 1},
		{text = 5, value = 5},
		{text = 10, value = 10},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 100, value = 100},
		{text = 250, value = 250},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then

			local change = T(302535920000746--[[added]])
			if choice[1].check1 then
				change = T(302535920000917--[[packed]])
				for _ = 1, value do
					obj:ConvertDroneToPrefab()
				end
			else
				for _ = 1, value do
					obj:UseDronePrefab()
				end
			end

			MsgPopup(
				choice[1].text .. ": " .. T(517, "Drones") .. " " .. change,
				T(302535920000513--[[Change Amount Of Drones In Hub]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000895--[[Change Amount Of Drones]]),
		hint = T(302535920000896--[[Drones in hub]]) .. ": " .. CurrentAmount .. " "
			.. T(302535920000897--[[Drone prefabs]]) .. ": " .. UICity.drone_prefabs,
		skip_sort = true,
		checkboxes = {
			{
				title = T(302535920000898--[[Pack Drones]]),
				hint = T(302535920000899--[[Check this to pack drone(s) into prefabs (number can be higher than attached drones).]]),
			},
		},
	}
end

function ChoGGi_Funcs.Menus.SetDroneFactoryBuildSpeed()
	local default_setting = ChoGGi.Consts.DroneFactoryBuildSpeed
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 2500, value = 2500},
		{text = 5000, value = 5000},
		{text = 10000, value = 10000},
		{text = 25000, value = 25000},
		{text = 50000, value = 50000},
		{text = 100000, value = 100000},
	}

	if not ChoGGi.UserSettings.BuildingSettings.DroneFactory then
		ChoGGi.UserSettings.BuildingSettings.DroneFactory = {}
	end
	local setting = ChoGGi.UserSettings.BuildingSettings.DroneFactory

	local hint = default_setting
	if setting.performance_notauto then
		hint = tostring(setting.performance_notauto)
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			local objs = UIColony:GetCityLabels("DroneFactory")
			for i = 1, #objs do
				objs[i].performance = value
			end
		end

		if value == default_setting then
			setting.performance_notauto = nil
		else
			setting.performance_notauto = value
		end

		ChoGGi_Funcs.Settings.WriteSettings()
		MsgPopup(
			ChoGGi_Funcs.Common.SettingState(choice.text),
			T(302535920000515--[[DroneFactory Build Speed]])
		)
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000901--[[Set Drone Factory Build Speed]]),
		hint = T(302535920000106--[[Current]]) .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.DroneBatteryInfinite_Toggle()
	local list = {
		"DroneMoveBatteryUse",
		"DroneCarryBatteryUse",
		"DroneConstructBatteryUse",
		"DroneBuildingRepairBatteryUse",
		"DroneDeconstructBatteryUse",
		"DroneTransformWasteRockObstructorToStockpileBatteryUse",
	}

	local Consts = Consts
	local cConsts = ChoGGi.Consts
	local SetConsts = ChoGGi_Funcs.Common.SetConsts
	local NumRetBool = ChoGGi_Funcs.Common.NumRetBool
	local SetSavedConstSetting = ChoGGi_Funcs.Common.SetSavedConstSetting
	for i = 1, #list do
		local name = list[i]
		SetConsts(name, NumRetBool(Consts[name], 0, cConsts[name]))
		SetSavedConstSetting(name, Consts[name])
	end

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.DroneMoveBatteryUse),
		T(302535920000519--[[Drone Battery Infinite]])
	)
end

function ChoGGi_Funcs.Menus.DroneBuildSpeed_Toggle()
	ChoGGi_Funcs.Common.SetConsts("DroneTimeToWorkOnLandscapeMultiplier", ChoGGi_Funcs.Common.ValueRetOpp(Consts.DroneTimeToWorkOnLandscapeMultiplier, max_int, ChoGGi.Consts.DroneTimeToWorkOnLandscapeMultiplier))
	ChoGGi_Funcs.Common.SetConsts("DroneConstructAmount", ChoGGi_Funcs.Common.ValueRetOpp(Consts.DroneConstructAmount, max_int, ChoGGi.Consts.DroneConstructAmount))
	ChoGGi_Funcs.Common.SetConsts("DroneBuildingRepairAmount", ChoGGi_Funcs.Common.ValueRetOpp(Consts.DroneBuildingRepairAmount, max_int, ChoGGi.Consts.DroneBuildingRepairAmount))
	ChoGGi_Funcs.Common.SetSavedConstSetting("DroneTimeToWorkOnLandscapeMultiplier")
	ChoGGi_Funcs.Common.SetSavedConstSetting("DroneConstructAmount")
	ChoGGi_Funcs.Common.SetSavedConstSetting("DroneBuildingRepairAmount")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.DroneConstructAmount),
		T(302535920000521--[[Drone Build Speed]])
	)
end

function ChoGGi_Funcs.Menus.DroneRechargeTime_Toggle()
	ChoGGi_Funcs.Common.SetConsts("DroneRechargeTime", ChoGGi_Funcs.Common.NumRetBool(Consts.DroneRechargeTime, 0, ChoGGi.Consts.DroneRechargeTime))
	ChoGGi_Funcs.Common.SetSavedConstSetting("DroneRechargeTime")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		Translate(302535920000907--[[%s: Well, if jacking on'll make strangers think I'm cool, I'll do it!]]):format(ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.DroneRechargeTime)),
		T(4645, "Drone Recharge Time")
	)
end

function ChoGGi_Funcs.Menus.DroneRepairSupplyLeak_Toggle()
	ChoGGi_Funcs.Common.SetConsts("DroneRepairSupplyLeak", ChoGGi_Funcs.Common.ValueRetOpp(Consts.DroneRepairSupplyLeak, 1, ChoGGi.Consts.DroneRepairSupplyLeak))
	ChoGGi_Funcs.Common.SetSavedConstSetting("DroneRepairSupplyLeak")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.DroneRepairSupplyLeak),
		T(302535920000527--[[Drone Repair Supply Leak Speed]])
	)
end

function ChoGGi_Funcs.Menus.SetDroneCarryAmount()
	local default_setting = ChoGGi_Funcs.Common.GetResearchedTechValue("DroneResourceCarryAmount")
	local hinttoolarge = T{302535920000909--[["If you set this amount larger then a building's ""<color ChoGGi_green>Storage</color>"" amount then the drones will NOT pick up storage (See: Fixes><str>)."]],
		str = T(302535920000613--[[Drone Carry Amount]]),
	}
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 5, value = 5},
		{text = 10, value = 10},
		{text = 25, value = 25, hint = hinttoolarge},
		{text = 50, value = 50, hint = hinttoolarge},
		{text = 75, value = 75, hint = hinttoolarge},
		{text = 100, value = 100, hint = hinttoolarge},
		{text = 250, value = 250, hint = hinttoolarge},
		{text = 500, value = 500, hint = hinttoolarge},
		{text = 1000, value = 1000, hint = hinttoolarge .. "\n\n" .. T(302535920000910--[[Somewhere above 1000 will delete the save (when it's full)]])},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.DroneResourceCarryAmount then
		hint = ChoGGi.UserSettings.DroneResourceCarryAmount
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			-- somewhere above 1000 screws the save
			if value > 1000 then
				value = 1000
			end

			if value == 1 then
				ChoGGi.UserSettings.DroneResourceCarryAmountFix = nil
			else
				ChoGGi.UserSettings.DroneResourceCarryAmountFix = true
			end

			ChoGGi_Funcs.Common.SetConsts("DroneResourceCarryAmount", value)
			UpdateDroneResourceUnits()
			ChoGGi_Funcs.Common.SetSavedConstSetting("DroneResourceCarryAmount")

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				Translate(302535920000911--[[Drones can carry %s items.]]):format(choice[1].text),
				T(6980, "Drone resource carry amount")
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000913--[[Set Drone Carry Capacity]]),
		hint = T(302535920000914--[[Current capacity]]) .. ": " .. hint
			.. "\n\n" .. hinttoolarge .. "\n\n" .. T(302535920000834--[[Max]])
			.. ": 1000.",
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SetDronesPerDroneHub()
	local default_setting = ChoGGi_Funcs.Common.GetResearchedTechValue("CommandCenterMaxDrones")
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
		{text = 1000, value = 1000},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.CommandCenterMaxDrones then
		hint = ChoGGi.UserSettings.CommandCenterMaxDrones
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			ChoGGi_Funcs.Common.SetConsts("CommandCenterMaxDrones", value)
			ChoGGi_Funcs.Common.SetSavedConstSetting("CommandCenterMaxDrones")

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				Translate(302535920000916--[[DroneHubs can control %s drones.]]):format(choice[1].text),
				T(4707--[[Command center max Drones]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000918--[[Set DroneHub Drone Capacity]]),
		hint = T(302535920000914--[[Current capacity]]) .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SetDronesPerRCRover()
	local default_setting = ChoGGi_Funcs.Common.GetResearchedTechValue("RCRoverMaxDrones")
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
		{text = 1000, value = 1000},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.RCRoverMaxDrones then
		hint = ChoGGi.UserSettings.RCRoverMaxDrones
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			ChoGGi_Funcs.Common.SetConsts("RCRoverMaxDrones", value)
			ChoGGi_Funcs.Common.SetSavedConstSetting("RCRoverMaxDrones")

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				Translate(302535920000921--[[RC Rovers can control %s drones.]]):format(choice[1].text),
				T(4633--[[RC Commander max Drones]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000924--[[Set RC Rover Drone Capacity]]),
		hint = T(302535920000914--[[Current capacity]]) .. ": " .. hint,
		skip_sort = true,
	}
end
