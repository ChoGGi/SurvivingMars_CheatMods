-- See LICENSE for terms

local tostring,type = tostring,type

local default_icon = "UI/Icons/IPButtons/drone.tga"
local default_icon2 = "UI/Icons/IPButtons/transport_route.tga"
local default_icon3 = "UI/Icons/IPButtons/shuttle.tga"

local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local Strings = ChoGGi.Strings
local Translate = ChoGGi.ComFuncs.Translate
--~	local RetName = ChoGGi.ComFuncs.RetName

function ChoGGi.MenuFuncs.SetDroneType()
	local icons = Presets.EncyclopediaArticle.Vehicles
	local item_list = {
		{
			text = Translate(10278--[[Wasp Drone--]]),
			value = "FlyingDrone",
			hint = "<image " .. icons.FlyingDrone.image .. ">\n\n" .. Translate(10278--[[Wasp Drone--]]),
		},
		{
			text = Translate(1681--[[Drone--]]),
			value = "Drone",
			hint = "<image " .. icons.Drone.image .. ">\n\n" .. Translate(1681--[[Drone--]]),
		},
	}
	local sponsor = GetMissionSponsor()

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		sponsor.drone_class = choice[1].value
		MsgPopup(
			Strings[302535920001405--[[Drones will now spawn as: %s--]]]:format(choice[1].text),
			Strings[302535920001403--[[Drone Type--]]]
		)
	end

	-- if nothing is set than it's regular drones
	local name = g_Classes[sponsor.drone_class]
	name = name and name.display_name or 1681--[[Drone--]]

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001403--[[Drone Type--]]],
		hint = Strings[302535920000106--[[Current--]]] .. ": " .. Translate(name) .. "\n"
			.. Strings[302535920001406--[["Hubs can only have one type of drone, so you'll need pack/unpack all drones for each hub you wish to change (or use Drones>%s)."--]]]:format(Strings[302535920000513--[[Change Amount of Drones in Hub--]]]),
	}
end

function ChoGGi.MenuFuncs.SetRoverChargeRadius()
	local default_setting = 0
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting,value = default_setting},
		{text = 1,value = 1},
		{text = 2,value = 2},
		{text = 3,value = 3},
		{text = 4,value = 4},
		{text = 5,value = 5},
		{text = 10,value = 10},
		{text = 25,value = 25},
		{text = 50,value = 50},
		{text = 100,value = 100},
		{text = 250,value = 250},
		{text = 500,value = 500},
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
		local value = choice[1].value
		if type(value) == "number" then

			if value == default_setting then
				ChoGGi.UserSettings.RCChargeDist = nil
			else
				ChoGGi.UserSettings.RCChargeDist = value
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice[1].text,Strings[302535920000769--[[Selected--]]]),
				Strings[302535920000541--[[RC Set Charging Distance--]]],
				default_icon2
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

function ChoGGi.MenuFuncs.SetRoverWorkRadius()
	local default_setting = ChoGGi.Consts.RCRoverMaxRadius
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting,value = default_setting},
		{text = 40,value = 40},
		{text = 80,value = 80},
		{text = 160,value = 160},
		{text = 320,value = 320,hint = Strings[302535920000111--[[Cover the entire map from the centre.--]]]},
		{text = 640,value = 640,hint = Strings[302535920000112--[[Cover the entire map from a corner.--]]]},
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

			ChoGGi.ComFuncs.SetSavedSetting("RCRoverMaxRadius",value)
			--we need to set this so the hex grid during placement is enlarged
			const.RCRoverMaxRadius = value

			local objs = UICity.labels.RCRover or ""
			for i = 1, #objs do
				objs[i]:SetWorkRadius(value)
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000883--[[%s: I can see for miles and miles.--]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.RCRoverMaxRadius)),
				Strings[302535920000505--[[Work Radius RC Rover--]]],
				"UI/Icons/Upgrades/service_bots_04.tga"
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

function ChoGGi.MenuFuncs.SetDroneHubWorkRadius()
	local default_setting = ChoGGi.Consts.CommandCenterMaxRadius
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting,value = default_setting},
		{text = 40,value = 40},
		{text = 80,value = 80},
		{text = 160,value = 160},
		{text = 320,value = 320,hint = Strings[302535920000111--[[Cover the entire map from the centre.--]]]},
		{text = 640,value = 640,hint = Strings[302535920000112--[[Cover the entire map from a corner.--]]]},
	}

	--other hint type
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

			ChoGGi.ComFuncs.SetSavedSetting("CommandCenterMaxRadius",value)
			-- we need to set this so the hex grid during placement is enlarged
			const.CommandCenterMaxRadius = value

			local objs = UICity.labels.DroneHub or ""
			for i = 1, #objs do
				objs[i]:SetWorkRadius(value)
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000883--[[%s: I can see for miles and miles--]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.CommandCenterMaxRadius)),
				Strings[302535920000507--[[Work Radius DroneHub--]]],
				"UI/Icons/Upgrades/service_bots_04.tga"
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000886--[[Set DroneHub Work Radius--]]],
		hint = Strings[302535920000106--[[Current--]]] .. ": " .. hint .. "\n\n"
			.. Strings[302535920000115--[[Toggle selection to update visible hex grid.--]]],
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetDroneRockToConcreteSpeed()
	local default_setting = ChoGGi.Consts.DroneTransformWasteRockObstructorToStockpileAmount
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting,value = default_setting},
		{text = 0,value = 0},
		{text = 25,value = 25},
		{text = 50,value = 50},
		{text = 75,value = 75},
		{text = 100,value = 100},
		{text = 250,value = 250},
		{text = 500,value = 500},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.DroneTransformWasteRockObstructorToStockpileAmount then
		hint = ChoGGi.UserSettings.DroneTransformWasteRockObstructorToStockpileAmount
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			ChoGGi.ComFuncs.SetConstsG("DroneTransformWasteRockObstructorToStockpileAmount",value)

			ChoGGi.ComFuncs.SetSavedSetting("DroneTransformWasteRockObstructorToStockpileAmount",Consts.DroneTransformWasteRockObstructorToStockpileAmount)
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice[1].text,Strings[302535920000769--[[Selected--]]]),
				Strings[302535920000509--[[Drone Rock To Concrete Speed--]]],
				default_icon
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000509--[[Drone Rock To Concrete Speed--]]],
		hint = Strings[302535920000106--[[Current--]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetDroneMoveSpeed()
	local r = ChoGGi.Consts.ResourceScale
	local default_setting = ChoGGi.Consts.SpeedDrone
	local UpgradedSetting = ChoGGi.ComFuncs.GetResearchedTechValue("SpeedDrone")
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. (default_setting / r),value = default_setting,hint = Strings[302535920000889--[[base speed--]]]},
		{text = 5,value = 5 * r},
		{text = 10,value = 10 * r},
		{text = 15,value = 15 * r},
		{text = 25,value = 25 * r},
		{text = 50,value = 50 * r},
		{text = 100,value = 100 * r},
		{text = 1000,value = 1000 * r},
		{text = 10000,value = 10000 * r},
	}
	if default_setting ~= UpgradedSetting then
		table.insert(item_list,2,{text = Strings[302535920000890--[[Upgraded--]]] .. ": " .. (UpgradedSetting / r),value = UpgradedSetting,hint = Strings[302535920000891--[[apply tech unlocks--]]]})
	end

	local hint = UpgradedSetting
	if ChoGGi.UserSettings.SpeedDrone then
		hint = ChoGGi.UserSettings.SpeedDrone
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			local objs = UICity.labels.Drone or ""
			for i = 1, #objs do
				objs[i]:SetMoveSpeed(value)
			end
			ChoGGi.ComFuncs.SetSavedSetting("SpeedDrone",value)

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice[1].text,Strings[302535920000769--[[Selected--]]]),
				Strings[302535920000511--[[Drone Move Speed--]]],
				default_icon
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000511--[[Drone Move Speed--]]],
		hint = Strings[302535920000106--[[Current--]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetRCMoveSpeed()
	local r = ChoGGi.Consts.ResourceScale
	local default_setting = ChoGGi.Consts.SpeedRC
	local UpgradedSetting = ChoGGi.ComFuncs.GetResearchedTechValue("SpeedRC")
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. (default_setting / r),value = default_setting,hint = Strings[302535920000889--[[base speed--]]]},
		{text = 5,value = 5 * r},
		{text = 10,value = 10 * r},
		{text = 15,value = 15 * r},
		{text = 25,value = 25 * r},
		{text = 50,value = 50 * r},
		{text = 100,value = 100 * r},
		{text = 1000,value = 1000 * r},
		{text = 10000,value = 10000 * r},
	}
	if default_setting ~= UpgradedSetting then
		table.insert(item_list,2,{text = Strings[302535920000890--[[Upgraded--]]] .. ": " .. (UpgradedSetting / r),value = UpgradedSetting,hint = Strings[302535920000891--[[apply tech unlocks--]]]})
	end

	local hint = UpgradedSetting
	if ChoGGi.UserSettings.SpeedRC then
		hint = ChoGGi.UserSettings.SpeedRC
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			ChoGGi.ComFuncs.SetSavedSetting("SpeedRC",value)
			local objs = UICity.labels.Rover or ""
			for i = 1, #objs do
				objs[i]:SetMoveSpeed(value)
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice[1].text,Strings[302535920000769--[[Selected--]]]),
				Strings[302535920000543--[[RC Move Speed--]]],
				default_icon2
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

function ChoGGi.MenuFuncs.SetDroneAmountDroneHub()
	local obj = ChoGGi.ComFuncs.SelObject()
	if not obj or not obj:IsKindOf("DroneControl") then
		return
	end

	local CurrentAmount = obj:GetDronesCount()
	local item_list = {
		{text = Strings[302535920000894--[[Current amount--]]] .. ": " .. CurrentAmount,value = CurrentAmount},
		{text = 1,value = 1},
		{text = 5,value = 5},
		{text = 10,value = 10},
		{text = 25,value = 25},
		{text = 50,value = 50},
		{text = 100,value = 100},
		{text = 250,value = 250},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then

			local change = Strings[302535920000746--[[added--]]]
			if choice[1].check1 then
				change = Strings[302535920000917--[[packed--]]]
				for _ = 1, value do
					obj:ConvertDroneToPrefab()
				end
			else
				for _ = 1, value do
					obj:UseDronePrefab()
				end
			end

			MsgPopup(
				choice[1].text .. ": " .. Translate(517--[[Drones--]]) .. " " .. change,
				Strings[302535920000513--[[Change Amount Of Drones In Hub--]]],
				default_icon
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000895--[[Change Amount Of Drones--]]],
		hint = Strings[302535920000896--[[Drones in hub--]]] .. ": " .. CurrentAmount .. " "
			.. Strings[302535920000897--[[Drone prefabs--]]] .. ": " .. UICity.drone_prefabs,
		skip_sort = true,
		checkboxes = {
			{
				title = Strings[302535920000898--[[Pack Drones--]]],
				hint = Strings[302535920000899--[[Check this to pack drone(s) into prefabs (number can be higher than attached drones).--]]],
			},
		},
	}
end

function ChoGGi.MenuFuncs.SetDroneFactoryBuildSpeed()
	local default_setting = ChoGGi.Consts.DroneFactoryBuildSpeed
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting,value = default_setting},
		{text = 25,value = 25},
		{text = 50,value = 50},
		{text = 75,value = 75},
		{text = 100,value = 100},
		{text = 250,value = 250},
		{text = 500,value = 500},
		{text = 1000,value = 1000},
		{text = 2500,value = 2500},
		{text = 5000,value = 5000},
		{text = 10000,value = 10000},
		{text = 25000,value = 25000},
		{text = 50000,value = 50000},
		{text = 100000,value = 100000},
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
		local value = choice[1].value
		if type(value) == "number" then
			local objs = UICity.labels.DroneFactory or ""
			for i = 1, #objs do
				objs[i].performance = value
			end
		end

		if value == default_setting then
			setting.performance_notauto = nil
		else
			setting.performance_notauto = value
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(choice[1].text),
			Strings[302535920000515--[[DroneFactory Build Speed--]]],
			default_icon
		)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000901--[[Set Drone Factory Build Speed--]]],
		hint = Strings[302535920000106--[[Current--]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.DroneBatteryInfinite_Toggle()
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
	local SetConstsG = ChoGGi.ComFuncs.SetConstsG
	local NumRetBool = ChoGGi.ComFuncs.NumRetBool
	local SetSavedSetting = ChoGGi.ComFuncs.SetSavedSetting
	for i = 1, #list do
		local name = list[i]
		SetConstsG(name,NumRetBool(Consts[name],0,cConsts[name]))
		SetSavedSetting(name,Consts[name])
	end

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DroneMoveBatteryUse),
		Strings[302535920000519--[[Drone Battery Infinite--]]],
		default_icon
	)
end

function ChoGGi.MenuFuncs.DroneBuildSpeed_Toggle()
	ChoGGi.ComFuncs.SetConstsG("DroneConstructAmount",ChoGGi.ComFuncs.ValueRetOpp(Consts.DroneConstructAmount,max_int,ChoGGi.Consts.DroneConstructAmount))
	ChoGGi.ComFuncs.SetConstsG("DroneBuildingRepairAmount",ChoGGi.ComFuncs.ValueRetOpp(Consts.DroneBuildingRepairAmount,max_int,ChoGGi.Consts.DroneBuildingRepairAmount))
	ChoGGi.ComFuncs.SetSavedSetting("DroneConstructAmount",Consts.DroneConstructAmount)
	ChoGGi.ComFuncs.SetSavedSetting("DroneBuildingRepairAmount",Consts.DroneBuildingRepairAmount)

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DroneConstructAmount),
		Strings[302535920000521--[[Drone Build Speed--]]],
		default_icon
	)
end

function ChoGGi.MenuFuncs.RCTransportInstantTransfer_Toggle()
	ChoGGi.ComFuncs.SetConstsG("RCRoverTransferResourceWorkTime",ChoGGi.ComFuncs.NumRetBool(Consts.RCRoverTransferResourceWorkTime,0,ChoGGi.Consts.RCRoverTransferResourceWorkTime))
	ChoGGi.ComFuncs.SetConstsG("RCTransportGatherResourceWorkTime",ChoGGi.ComFuncs.NumRetBool(Consts.RCTransportGatherResourceWorkTime,0,ChoGGi.ComFuncs.GetResearchedTechValue("RCTransportGatherResourceWorkTime")))
	ChoGGi.ComFuncs.SetSavedSetting("RCRoverTransferResourceWorkTime",Consts.RCRoverTransferResourceWorkTime)
	ChoGGi.ComFuncs.SetSavedSetting("RCTransportGatherResourceWorkTime",Consts.RCTransportGatherResourceWorkTime)

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000905--[[%s: Slight of hand--]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.RCRoverTransferResourceWorkTime)),
		Strings[302535920000549--[[RC Instant Resource Transfer--]]],
		"UI/Icons/IPButtons/resources_section.tga"
	)
end

function ChoGGi.MenuFuncs.DroneRechargeTime_Toggle()
	ChoGGi.ComFuncs.SetConstsG("DroneRechargeTime",ChoGGi.ComFuncs.NumRetBool(Consts.DroneRechargeTime,0,ChoGGi.Consts.DroneRechargeTime))
	ChoGGi.ComFuncs.SetSavedSetting("DroneRechargeTime",Consts.DroneRechargeTime)

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000907--[[%s: Well, if jacking on'll make strangers think I'm cool, I'll do it!--]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DroneRechargeTime)),
		Translate(4645--[[Drone Recharge Time--]]),
		"UI/Icons/Notifications/low_battery.tga",
		true
	)
end

function ChoGGi.MenuFuncs.DroneRepairSupplyLeak_Toggle()
	ChoGGi.ComFuncs.SetConstsG("DroneRepairSupplyLeak",ChoGGi.ComFuncs.ValueRetOpp(Consts.DroneRepairSupplyLeak,1,ChoGGi.Consts.DroneRepairSupplyLeak))
	ChoGGi.ComFuncs.SetSavedSetting("DroneRepairSupplyLeak",Consts.DroneRepairSupplyLeak)

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000908--[[%s: You know what they say about leaky pipes.--]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DroneRepairSupplyLeak)),
		Strings[302535920000527--[[Drone Repair Supply Leak Speed--]]],
		default_icon
	)
end

function ChoGGi.MenuFuncs.SetDroneCarryAmount()
	local default_setting = ChoGGi.ComFuncs.GetResearchedTechValue("DroneResourceCarryAmount")
	local hinttoolarge = Strings[302535920000909--[["If you set this amount larger then a building's ""Storage"" amount then the drones will NOT pick up storage (See: Fixes>%s)."--]]]:format(Strings[302535920000613--[[Drone Carry Amount--]]])
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting,value = default_setting},
		{text = 5,value = 5},
		{text = 10,value = 10},
		{text = 25,value = 25,hint = hinttoolarge},
		{text = 50,value = 50,hint = hinttoolarge},
		{text = 75,value = 75,hint = hinttoolarge},
		{text = 100,value = 100,hint = hinttoolarge},
		{text = 250,value = 250,hint = hinttoolarge},
		{text = 500,value = 500,hint = hinttoolarge},
		{text = 1000,value = 1000,hint = hinttoolarge .. "\n\n" .. Strings[302535920000910--[[Somewhere above 1000 will delete the save (when it's full)--]]]},
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
			ChoGGi.ComFuncs.SetConstsG("DroneResourceCarryAmount",value)
			UpdateDroneResourceUnits()
			ChoGGi.ComFuncs.SetSavedSetting("DroneResourceCarryAmount",value)

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000911--[[Drones can carry %s items.--]]]:format(choice[1].text),
				Strings[302535920000529--[[Drone Carry Amount--]]],
				default_icon
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000913--[[Set Drone Carry Capacity--]]],
		hint = Strings[302535920000914--[[Current capacity--]]] .. ": " .. hint
			.. "\n\n" .. hinttoolarge .. "\n\n" .. Strings[302535920000834--[[Max--]]]
			.. ": 1000.",
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetDronesPerDroneHub()
	local default_setting = ChoGGi.ComFuncs.GetResearchedTechValue("CommandCenterMaxDrones")
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting,value = default_setting},
		{text = 5,value = 5},
		{text = 10,value = 10},
		{text = 25,value = 25},
		{text = 50,value = 50},
		{text = 75,value = 75},
		{text = 100,value = 100},
		{text = 250,value = 250},
		{text = 500,value = 500},
		{text = 1000,value = 1000},
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
			ChoGGi.ComFuncs.SetConstsG("CommandCenterMaxDrones",value)
			ChoGGi.ComFuncs.SetSavedSetting("CommandCenterMaxDrones",value)

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000916--[[DroneHubs can control %s drones.--]]]:format(choice[1].text),
				Strings[302535920000531--[[Drones Per Drone Hub--]]],
				default_icon
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000918--[[Set DroneHub Drone Capacity--]]],
		hint = Strings[302535920000914--[[Current capacity--]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetDronesPerRCRover()
	local default_setting = ChoGGi.ComFuncs.GetResearchedTechValue("RCRoverMaxDrones")
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting,value = default_setting},
		{text = 5,value = 5},
		{text = 10,value = 10},
		{text = 25,value = 25},
		{text = 50,value = 50},
		{text = 75,value = 75},
		{text = 100,value = 100},
		{text = 250,value = 250},
		{text = 500,value = 500},
		{text = 1000,value = 1000},
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
			ChoGGi.ComFuncs.SetConstsG("RCRoverMaxDrones",value)
			ChoGGi.ComFuncs.SetSavedSetting("RCRoverMaxDrones",value)

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000921--[[RC Rovers can control %s drones.--]]]:format(choice[1].text),
				Strings[302535920000533--[[Drones Per RC Rover--]]],
				default_icon2
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000924--[[Set RC Rover Drone Capacity--]]],
		hint = Strings[302535920000914--[[Current capacity--]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetRCTransportStorageCapacity()
	local r = ChoGGi.Consts.ResourceScale
	local default_setting = ChoGGi.ComFuncs.GetResearchedTechValue("RCTransportStorageCapacity") / r
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting,value = default_setting},
		{text = 50,value = 50},
		{text = 75,value = 75},
		{text = 100,value = 100},
		{text = 250,value = 250},
		{text = 500,value = 500},
		{text = 1000,value = 1000},
		{text = 2000,value = 2000,hint = Strings[302535920000925--[[somewhere above 2000 will delete the save (when it's full)--]]]},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.RCTransportStorageCapacity then
		hint = ChoGGi.UserSettings.RCTransportStorageCapacity / r
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			local default = value == default_setting

			local value = value * r
			-- somewhere above 2000 screws the save
			if value > 2000000 then
				value = 2000000
			end
			-- for any rc constructors
			local rc_con_value = ChoGGi.ComFuncs.GetResearchedTechValue("RCTransportStorageCapacity","RCConstructor")

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
				ChoGGi.ComFuncs.SetSavedSetting("RCTransportStorageCapacity",value)
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000926--[[RC Transport capacity is now %s.--]]]:format(choice[1].text),
				Strings[302535920000551--[[RC Storage Capacity--]]],
				"UI/Icons/bmc_building_storages_shine.tga"
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

function ChoGGi.MenuFuncs.SetShuttleCapacity()
	local r = ChoGGi.Consts.ResourceScale
	local default_setting = ChoGGi.Consts.StorageShuttle / r
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting,value = default_setting},
		{text = 5,value = 5},
		{text = 10,value = 10},
		{text = 25,value = 25},
		{text = 50,value = 50},
		{text = 75,value = 75},
		{text = 100,value = 100},
		{text = 250,value = 250},
		{text = 500,value = 500},
		{text = 1000,value = 1000,hint = Strings[302535920000928--[[somewhere above 1000 may delete the save (when it's full)--]]]},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.StorageShuttle then
		hint = ChoGGi.UserSettings.StorageShuttle / r
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			local value = value * r
			-- not tested but I assume too much = dead save as well (like rc and transport)
			if value > 1000000 then
				value = 1000000
			end

			-- loop through and set all shuttles
			local objs = UICity.labels.CargoShuttle or ""
			for i = 1, #objs do
				objs[i].max_shared_storage = value
			end
			ChoGGi.ComFuncs.SetSavedSetting("StorageShuttle",value)

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000929--[[Shuttle storage is now %s.--]]]:format(choice[1].text),
				Strings[302535920000537--[[Set Capacity--]]],
				default_icon3
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000930--[[Set Cargo Shuttle Capacity--]]],
		hint = Strings[302535920000914--[[Current capacity--]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetShuttleSpeed()
	local r = ChoGGi.Consts.ResourceScale
	local default_setting = ChoGGi.Consts.SpeedShuttle / r
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting,value = default_setting},
		{text = 50,value = 50},
		{text = 75,value = 75},
		{text = 100,value = 100},
		{text = 250,value = 250},
		{text = 500,value = 500},
		{text = 1000,value = 1000},
		{text = 5000,value = 5000},
		{text = 10000,value = 10000},
		{text = 25000,value = 25000},
		{text = 50000,value = 50000},
		{text = 100000,value = 100000},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.SpeedShuttle then
		hint = ChoGGi.UserSettings.SpeedShuttle / r
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			local value = value * r
			-- loop through and set all shuttles
			local objs = UICity.labels.CargoShuttle or ""
			for i = 1, #objs do
				objs[i].move_speed = value
			end
			ChoGGi.ComFuncs.SetSavedSetting("SpeedShuttle",value)

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000931--[[Shuttle speed is now %s.--]]]:format(choice[1].text),
				Strings[302535920000539--[[Set Speed--]]],
				default_icon3
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000932--[[Set Cargo Shuttle Speed--]]],
		hint = Strings[302535920000933--[[Current speed: %s--]]]:format(hint),
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetShuttleHubShuttleCapacity()
	local default_setting = ChoGGi.Consts.ShuttleHubShuttleCapacity
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting,value = default_setting},
		{text = 25,value = 25},
		{text = 50,value = 50},
		{text = 75,value = 75},
		{text = 100,value = 100},
		{text = 250,value = 250},
		{text = 500,value = 500},
		{text = 1000,value = 1000},
	}

	--check if there's an entry for building
	if not ChoGGi.UserSettings.BuildingSettings.ShuttleHub then
		ChoGGi.UserSettings.BuildingSettings.ShuttleHub = {}
	end

	local hint = default_setting
	local setting = ChoGGi.UserSettings.BuildingSettings.ShuttleHub
	if setting and setting.shuttles then
		hint = tostring(setting.shuttles)
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			-- loop through and set all shuttles
			local objs = UICity.labels.ShuttleHub or ""
			for i = 1, #objs do
				objs[i].max_shuttles = value
			end
			if value == default_setting then
				ChoGGi.UserSettings.BuildingSettings.ShuttleHub.shuttles = nil
			else
				ChoGGi.UserSettings.BuildingSettings.ShuttleHub.shuttles = value
			end
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			Strings[302535920000934--[[ShuttleHub shuttle capacity is now %s.--]]]:format(choice[1].text),
			Strings[302535920000535--[[Set ShuttleHub Shuttle Capacity--]]],
			default_icon3
		)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000535--[[Set ShuttleHub Shuttle Capacity--]]],
		hint = Strings[302535920000914--[[Current capacity--]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetGravityRC()
	local default_setting = ChoGGi.Consts.GravityRC
	local r = ChoGGi.Consts.ResourceScale
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting,value = default_setting},
		{text = 1,value = 1},
		{text = 2,value = 2},
		{text = 3,value = 3},
		{text = 4,value = 4},
		{text = 5,value = 5},
		{text = 10,value = 10},
		{text = 15,value = 15},
		{text = 25,value = 25},
		{text = 50,value = 50},
		{text = 75,value = 75},
		{text = 100,value = 100},
		{text = 250,value = 250},
		{text = 500,value = 500},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.GravityRC then
		hint = ChoGGi.UserSettings.GravityRC / r
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			local value = value * r
			local objs = UICity.labels.Rover or ""
			for i = 1, #objs do
				objs[i]:SetGravity(value)
			end
			ChoGGi.ComFuncs.SetSavedSetting("GravityRC",value)

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000919--[[RC gravity is now %s.--]]]:format(choice[1].text),
				Strings[302535920000545--[[RC Gravity--]]],
				default_icon2
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

function ChoGGi.MenuFuncs.SetGravityDrones()
	local default_setting = ChoGGi.Consts.GravityDrone
	local r = ChoGGi.Consts.ResourceScale
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting,value = default_setting},
		{text = 1,value = 1},
		{text = 2,value = 2},
		{text = 3,value = 3},
		{text = 4,value = 4},
		{text = 5,value = 5},
		{text = 10,value = 10},
		{text = 15,value = 15},
		{text = 25,value = 25},
		{text = 50,value = 50},
		{text = 75,value = 75},
		{text = 100,value = 100},
		{text = 250,value = 250},
		{text = 500,value = 500},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.GravityDrone then
		hint = ChoGGi.UserSettings.GravityDrone / r
	end
	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			local value = value * r
			--loop through and set all
			local objs = UICity.labels.Drone or ""
			for i = 1, #objs do
				objs[i]:SetGravity(value)
			end
			ChoGGi.ComFuncs.SetSavedSetting("GravityDrone",value)

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000919--[[RC gravity is now %s.--]]]:format(choice[1].text),
				Strings[302535920000517--[[Drone Gravity--]]],
				default_icon2
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000923--[[Set Drone Gravity--]]],
		hint = Strings[302535920000841--[[Current gravity: %s--]]]:format(hint),
		skip_sort = true,
	}
end

do -- ChangeResupplySettings
	local function CheckResupplySetting(cargo_val,name,value,meta)
		if ChoGGi.Tables.CargoPresets[name][cargo_val] == value then
			ChoGGi.UserSettings.CargoSettings[name][cargo_val] = nil
		else
			ChoGGi.UserSettings.CargoSettings[name][cargo_val] = value
		end
		meta[cargo_val] = value
	end

	local function ShowResupplyList(name,meta)
		local item_list = {
			{text = "pack",value = meta.pack,hint = Strings[302535920001269--[[Amount Per Click--]]]},
			{text = "kg",value = meta.kg,hint = Strings[302535920001270--[[Weight Per Item--]]]},
			{text = "price",value = meta.price,hint = Strings[302535920001271--[[Price Per Item--]]]},
			{text = "locked",value = meta.locked,hint = Strings[302535920000126--[[Locked From Resupply View--]]]},
		}

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end

			if not ChoGGi.UserSettings.CargoSettings[name] then
				ChoGGi.UserSettings.CargoSettings[name] = {}
			end

			for i = 1, #choice do
				local value,value_type = ChoGGi.ComFuncs.RetProperType(choice[i].value)
				local text = choice[i].text
				if text == "pack" and value_type == "number" then
					CheckResupplySetting("pack",name,value,meta)
				elseif text == "kg" and value_type == "number" then
					CheckResupplySetting("kg",name,value,meta)
				elseif text == "price" and value_type == "number" then
					CheckResupplySetting("price",name,value,meta)
				elseif text == "locked" and value_type == "boolean" then
					CheckResupplySetting("locked",name,value,meta)
				end
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000850--[[Change Resupply Settings--]]],
				Strings[302535920001272--[[Updated--]]],
				"UI/Icons/Sections/spaceship.tga"
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920000850--[[Change Resupply Settings--]]] .. ": " .. name,
			hint = Strings[302535920001121--[[Edit value for each setting you wish to change then press OK to save.--]]],
			custom_type = 4,
		}
	end

	function ChoGGi.MenuFuncs.ChangeResupplySettings()
		local Cargo = ChoGGi.Tables.Cargo or ""
		local CargoPresets = ChoGGi.Tables.CargoPresets or ""

		local item_list = {}
		for i = 1, #Cargo do
			item_list[i] = {
				text = Translate(Cargo[i].name),
				value = Cargo[i].id,
				meta = Cargo[i],
			}
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end

			if choice[1].check1 then
				ChoGGi.UserSettings.CargoSettings = nil

				for cargo_id,cargo in pairs(Cargo) do
					local preset = CargoPresets[cargo_id]
					cargo.pack = preset.pack
					cargo.kg = preset.kg
					cargo.price = preset.price
					cargo.locked = preset.locked
				end

				return
			end

			ShowResupplyList(choice[1].value,choice[1].meta)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920000850--[[Change Resupply Settings--]]],
			hint = Strings[302535920001094--[["Shows a list of all cargo and allows you to change the price, weight taken up, if it's locked from view, and how many per click."--]]],
			custom_type = 7,
			checkboxes = {
				{
					title = Strings[302535920001084--[[Reset--]]],
					hint = Strings[302535920000237--[[Check this to reset settings.--]]],
				},
			},
		}
	end
end -- do

--~ 	function ChoGGi.MenuFuncs.LaunchEmptyRocket()
--~ 		local function CallBackFunc(answer)
--~ 			if answer then
--~ 				UICity:OrderLanding()
--~ 			end
--~ 		end
--~ 		ChoGGi.ComFuncs.QuestionBox(
--~ 			Strings[302535920000942--[[Are you sure you want to launch an empty rocket?--]]],
--~ 			CallBackFunc,
--~ 			Strings[302535920000943--[[Launch rocket to Mars.--]]],
--~ 			Strings[302535920000944--[[Yamato Hasshin!--]]]
--~ 		)
--~ 	end

function ChoGGi.MenuFuncs.SetRocketCargoCapacity()
	local default_setting = ChoGGi.ComFuncs.GetResearchedTechValue("CargoCapacity")
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting .. " kg",value = default_setting},
		{text = "50 000 kg",value = 50000},
		{text = "100 000 kg",value = 100000},
		{text = "250 000 kg",value = 250000},
		{text = "500 000 kg",value = 500000},
		{text = "1 000 000 kg",value = 1000000},
		{text = "10 000 000 kg",value = 10000000},
		{text = "100 000 000 kg",value = 100000000},
		{text = "1 000 000 000 kg",value = 1000000000},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			ChoGGi.ComFuncs.SetConstsG("CargoCapacity",value)
			ChoGGi.ComFuncs.SetSavedSetting("CargoCapacity",value)

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000945--[[%s: I can still see some space...--]]]:format(choice[1].text),
				Strings[302535920000559--[[Cargo Capacity--]]],
				"UI/Icons/Sections/spaceship.tga"
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000946--[[Set Rocket Cargo Capacity--]]],
		hint = Strings[302535920000914--[[Current capacity--]]] .. ": " .. g_Consts.CargoCapacity,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetRocketTravelTime()
	local r = ChoGGi.Consts.ResourceScale
	local default_setting = ChoGGi.ComFuncs.GetResearchedTechValue("TravelTimeEarthMars") / r
	local item_list = {
		{text = Strings[302535920000947--[[Instant--]]],value = 0},
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting,value = default_setting},
		{text = Strings[302535920000948--[[Original--]]] .. ": " .. 750,value = 750},
		{text = Strings[302535920000949--[[Half of Original--]]] .. ": " .. 375,value = 375},
		{text = 10,value = 10},
		{text = 25,value = 25},
		{text = 50,value = 50},
		{text = 100,value = 100},
		{text = 150,value = 150},
		{text = 200,value = 200},
		{text = 250,value = 250},
		{text = 500,value = 500},
		{text = 1000,value = 1000},
	}

	--other hint type
	local hint = default_setting
	if ChoGGi.UserSettings.TravelTimeEarthMars then
		hint = ChoGGi.UserSettings.TravelTimeEarthMars / r
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			local value = value * r
			ChoGGi.ComFuncs.SetConstsG("TravelTimeEarthMars",value)
			ChoGGi.ComFuncs.SetConstsG("TravelTimeMarsEarth",value)
			ChoGGi.ComFuncs.SetSavedSetting("TravelTimeEarthMars",value)
			ChoGGi.ComFuncs.SetSavedSetting("TravelTimeMarsEarth",value)

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000950--[[%s: 88 MPH--]]]:format(choice[1].text),
				Strings[302535920000561--[[Travel Time--]]],
				"UI/Upgrades/autoregulator_04/timer.tga"
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000951--[[Rocket Travel Time--]]],
		hint = Strings[302535920000106--[[Current--]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetColonistsPerRocket()
	local default_setting = ChoGGi.ComFuncs.GetResearchedTechValue("MaxColonistsPerRocket")
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting,value = default_setting},
		{text = 25,value = 25},
		{text = 50,value = 50},
		{text = 75,value = 75},
		{text = 100,value = 100},
		{text = 250,value = 250},
		{text = 500,value = 500},
		{text = 1000,value = 1000},
		{text = 10000,value = 10000},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			ChoGGi.ComFuncs.SetConstsG("MaxColonistsPerRocket",value)
			ChoGGi.ComFuncs.SetSavedSetting("MaxColonistsPerRocket",value)

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000952--[[%s: Long pig sardines--]]]:format(choice[1].text),
				Translate(4594--[[Colonists Per Rocket--]]),
				"UI/Icons/Notifications/colonist.tga"
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000953--[[Set Colonist Capacity--]]],
		hint = Strings[302535920000914--[[Current capacity--]]] .. ": " .. g_Consts.MaxColonistsPerRocket,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.RocketMaxExportAmount()
	local r = ChoGGi.Consts.ResourceScale
	local default_setting = ChoGGi.Consts.RocketMaxExportAmount
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. (default_setting / r),value = default_setting},
		{text = 5,value = 5 * r},
		{text = 10,value = 10 * r},
		{text = 15,value = 15 * r},
		{text = 25,value = 25 * r},
		{text = 50,value = 50 * r},
		{text = 100,value = 100 * r},
		{text = 1000,value = 1000 * r},
		{text = 10000,value = 10000 * r},
	}

	if not ChoGGi.UserSettings.RocketMaxExportAmount then
		ChoGGi.UserSettings.RocketMaxExportAmount = default_setting
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			if value == default_setting then
				ChoGGi.UserSettings.RocketMaxExportAmount = nil
			else
				ChoGGi.UserSettings.RocketMaxExportAmount = value
			end

			local rockets = UICity.labels.AllRockets or ""
			for i = 1, #rockets do
				if rockets[i].export_requests then
					ChoGGi.ComFuncs.SetTaskReqAmount(rockets[i],value,"export_requests","max_export_storage")
				else
					rockets[i].max_export_storage = value
				end
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice[1].text,Strings[302535920000769--[[Selected--]]]),
				Strings[302535920001291--[[Max Export Amount--]]],
				"UI/Icons/Sections/PreciousMetals_2.tga"
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001291--[[Max Export Amount--]]],
		hint = Strings[302535920000914--[[Current capacity--]]] .. ": " .. ChoGGi.UserSettings.RocketMaxExportAmount,
		skip_sort = true,
	}
end

do -- RocketsIgnoreFuel_Toggle/LaunchFuelPerRocket
	local function SetRocketFuelAmount(amount)
		local rockets = UICity.labels.AllRockets or ""
		for i = 1, #rockets do
			if rockets[i].refuel_request then
				ChoGGi.ComFuncs.SetTaskReqAmount(rockets[i],amount,"refuel_request","launch_fuel")
			else
				rockets[i].launch_fuel = amount
			end
		end
	end

	function ChoGGi.MenuFuncs.RocketsIgnoreFuel_Toggle()
		if ChoGGi.UserSettings.RocketsIgnoreFuel then
			ChoGGi.UserSettings.RocketsIgnoreFuel = nil
			SetRocketFuelAmount(ChoGGi.Consts.LaunchFuelPerRocket)
		else
			ChoGGi.UserSettings.RocketsIgnoreFuel = true
			SetRocketFuelAmount(0)
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.RocketsIgnoreFuel),
			Strings[302535920001319--[[Rockets Ignore Fuel--]]],
			"UI/Icons/Sections/Fuel_1.tga"
		)
	end

	function ChoGGi.MenuFuncs.LaunchFuelPerRocket()
		local r = ChoGGi.Consts.ResourceScale
		local default_setting = ChoGGi.Consts.LaunchFuelPerRocket
		local UpgradedSetting = ChoGGi.ComFuncs.GetResearchedTechValue("FuelRocket")
		local item_list = {
			{text = Translate(1000121--[[Default--]]) .. ": " .. (default_setting / r),value = default_setting},
			{text = 5,value = 5 * r},
			{text = 10,value = 10 * r},
			{text = 15,value = 15 * r},
			{text = 25,value = 25 * r},
			{text = 50,value = 50 * r},
			{text = 100,value = 100 * r},
			{text = 1000,value = 1000 * r},
			{text = 10000,value = 10000 * r},
		}
		if default_setting ~= UpgradedSetting then
			table.insert(item_list,2,{text = Strings[302535920000890--[[Upgraded--]]] .. ": " .. (UpgradedSetting / r),value = UpgradedSetting})
		end

		if not ChoGGi.UserSettings.LaunchFuelPerRocket then
			ChoGGi.UserSettings.LaunchFuelPerRocket = default_setting
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				if value == default_setting then
					ChoGGi.UserSettings.LaunchFuelPerRocket = nil
				else
					ChoGGi.UserSettings.LaunchFuelPerRocket = value
				end
				SetRocketFuelAmount(value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					ChoGGi.ComFuncs.SettingState(choice[1].text,Strings[302535920000769--[[Selected--]]]),
					Strings[302535920001317--[[Launch Fuel Per Rocket--]]],
					"UI/Icons/Sections/Fuel_1.tga"
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920001317--[[Launch Fuel Per Rocket--]]],
			hint = Strings[302535920000914--[[Current capacity--]]] .. ": " .. ChoGGi.UserSettings.LaunchFuelPerRocket,
			skip_sort = true,
		}
	end
end -- do
