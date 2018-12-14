-- See LICENSE for terms

local tostring,type = tostring,type
local StringFormat = string.format

local default_icon = "UI/Icons/IPButtons/drone.tga"
local default_icon2 = "UI/Icons/IPButtons/transport_route.tga"
local default_icon3 = "UI/Icons/IPButtons/shuttle.tga"

function OnMsg.ClassesGenerate()
	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local S = ChoGGi.Strings
	local Trans = ChoGGi.ComFuncs.Translate
--~	local RetName = ChoGGi.ComFuncs.RetName

	function ChoGGi.MenuFuncs.SetDroneType()
		local ItemList = {
			{
				text = S[10278--[[Wasp Drone--]]],
				value = "FlyingDrone",
			},
			{
				text = S[1681--[[Drone--]]],
				value = "Drone",
			},
		}
		local sponsor = GetMissionSponsor()

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			sponsor.drone_class = choice[1].value
			MsgPopup(
				S[302535920001405--[[Drones will now spawn as: %s--]]]:format(choice[1].text),
				302535920001403--[[Drone Type--]]
			)
		end

		-- if nothing is set than it's regular drones
		local name = g_Classes[sponsor.drone_class]
		name = name and name.display_name or 1681--[[Drone--]]

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920001403--[[Drone Type--]],
			hint = StringFormat("%s: %s\n%s",S[302535920000106--[[Current--]]],Trans(name),S[302535920001406--[["Hubs can only have one type of drone, so you'll need pack/unpack all drones for each hub you wish to change (or use Drones>%s)."--]]]:format(S[302535920000513--[[Change Amount of Drones in Hub--]]])),
		}
	end

	function ChoGGi.MenuFuncs.SetRoverChargeRadius()
		local ChoGGi = ChoGGi
		local DefaultSetting = 0
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
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
		local hint = DefaultSetting
		if ChoGGi.UserSettings.RCChargeDist then
			hint = ChoGGi.UserSettings.RCChargeDist
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then

				if value == DefaultSetting then
					ChoGGi.UserSettings.RCChargeDist = nil
				else
					ChoGGi.UserSettings.RCChargeDist = value
				end

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000769--[[Selected--]]),
					5438--[[Rovers--]],
					default_icon2
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000880--[[Set Rover Charge Radius--]],
			hint = StringFormat("%s: %s",S[302535920000106--[[Current--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetRoverWorkRadius()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.Consts.RCRoverMaxRadius
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 40,value = 40},
			{text = 80,value = 80},
			{text = 160,value = 160},
			{text = 320,value = 320,hint = 302535920000111--[[Cover the entire map from the centre.--]]},
			{text = 640,value = 640,hint = 302535920000112--[[Cover the entire map from a corner.--]]},
		}

		--other hint type
		local hint = DefaultSetting
		if ChoGGi.UserSettings.RCRoverMaxRadius then
			hint = ChoGGi.UserSettings.RCRoverMaxRadius
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then

				ChoGGi.ComFuncs.SetSavedSetting("RCRoverMaxRadius",value)
				--we need to set this so the hex grid during placement is enlarged
				const.RCRoverMaxRadius = value

				local tab = UICity.labels.RCRover or ""
				for i = 1, #tab do
					tab[i]:SetWorkRadius(value)
				end

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000883--[[%s: I can see for miles and miles.--]]]:format(ChoGGi.UserSettings.RCRoverMaxRadius),
					5438--[[Rovers--]],
					"UI/Icons/Upgrades/service_bots_04.tga"
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000884--[[Set Rover Work Radius--]],
			hint = StringFormat("%s: %s\n\n%s",S[302535920000106--[[Current--]]],hint,S[302535920000115--[[Toggle selection to update visible hex grid.--]]]),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetDroneHubWorkRadius()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.Consts.CommandCenterMaxRadius
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 40,value = 40},
			{text = 80,value = 80},
			{text = 160,value = 160},
			{text = 320,value = 320,hint = 302535920000111--[[Cover the entire map from the centre.--]]},
			{text = 640,value = 640,hint = 302535920000112--[[Cover the entire map from a corner.--]]},
		}

		--other hint type
		local hint = DefaultSetting
		if ChoGGi.UserSettings.CommandCenterMaxRadius then
			hint = ChoGGi.UserSettings.CommandCenterMaxRadius
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then

				ChoGGi.ComFuncs.SetSavedSetting("CommandCenterMaxRadius",value)
				--we need to set this so the hex grid during placement is enlarged
				const.CommandCenterMaxRadius = value

				local tab = UICity.labels.DroneHub or ""
				for i = 1, #tab do
					tab[i]:SetWorkRadius(value)
				end

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000883--[[%s: I can see for miles and miles--]]]:format(ChoGGi.UserSettings.CommandCenterMaxRadius),
					3518--[[Drone Hub--]],
					"UI/Icons/Upgrades/service_bots_04.tga"
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000886--[[Set DroneHub Work Radius--]],
			hint = StringFormat("%s: %s\n\n%s",S[302535920000106--[[Current--]]],hint,S[302535920000115--[[Toggle selection to update visible hex grid.--]]]),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetDroneRockToConcreteSpeed()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.Consts.DroneTransformWasteRockObstructorToStockpileAmount
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 0,value = 0},
			{text = 25,value = 25},
			{text = 50,value = 50},
			{text = 75,value = 75},
			{text = 100,value = 100},
			{text = 250,value = 250},
			{text = 500,value = 500},
		}

		local hint = DefaultSetting
		if ChoGGi.UserSettings.DroneTransformWasteRockObstructorToStockpileAmount then
			hint = ChoGGi.UserSettings.DroneTransformWasteRockObstructorToStockpileAmount
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				ChoGGi.ComFuncs.SetConstsG("DroneTransformWasteRockObstructorToStockpileAmount",value)

				ChoGGi.ComFuncs.SetSavedSetting("DroneTransformWasteRockObstructorToStockpileAmount",Consts.DroneTransformWasteRockObstructorToStockpileAmount)
				MsgPopup(
					ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000769--[[Selected--]]),
					517--[[Drones--]],
					default_icon
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000509--[[Drone Rock To Concrete Speed--]],
			hint = StringFormat("%s: %s",S[302535920000106--[[Current--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetDroneMoveSpeed()
		local ChoGGi = ChoGGi
		local r = ChoGGi.Consts.ResourceScale
		local DefaultSetting = ChoGGi.Consts.SpeedDrone
		local UpgradedSetting = ChoGGi.ComFuncs.GetResearchedTechValue("SpeedDrone")
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting / r),value = DefaultSetting,hint = 302535920000889--[[base speed--]]},
			{text = 5,value = 5 * r},
			{text = 10,value = 10 * r},
			{text = 15,value = 15 * r},
			{text = 25,value = 25 * r},
			{text = 50,value = 50 * r},
			{text = 100,value = 100 * r},
			{text = 1000,value = 1000 * r},
			{text = 10000,value = 10000 * r},
		}
		if DefaultSetting ~= UpgradedSetting then
			table.insert(ItemList,2,{text = StringFormat("%s: %s",S[302535920000890--[[Upgraded--]]],UpgradedSetting / r),value = UpgradedSetting,hint = 302535920000891--[[apply tech unlocks--]]})
		end

		local hint = UpgradedSetting
		if ChoGGi.UserSettings.SpeedDrone then
			hint = ChoGGi.UserSettings.SpeedDrone
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				local tab = UICity.labels.Drone or ""
				for i = 1, #tab do
					tab[i]:SetMoveSpeed(value)
				end
				ChoGGi.ComFuncs.SetSavedSetting("SpeedDrone",value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000769--[[Selected--]]),
					517--[[Drones--]],
					default_icon
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000511--[[Drone Move Speed--]],
			hint = StringFormat("%s: %s",S[302535920000106--[[Current--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetRCMoveSpeed()
		local ChoGGi = ChoGGi
		local r = ChoGGi.Consts.ResourceScale
		local DefaultSetting = ChoGGi.Consts.SpeedRC
		local UpgradedSetting = ChoGGi.ComFuncs.GetResearchedTechValue("SpeedRC")
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting / r),value = DefaultSetting,hint = 302535920000889--[[base speed--]]},
			{text = 5,value = 5 * r},
			{text = 10,value = 10 * r},
			{text = 15,value = 15 * r},
			{text = 25,value = 25 * r},
			{text = 50,value = 50 * r},
			{text = 100,value = 100 * r},
			{text = 1000,value = 1000 * r},
			{text = 10000,value = 10000 * r},
		}
		if DefaultSetting ~= UpgradedSetting then
			table.insert(ItemList,2,{text = StringFormat("%s: %s",S[302535920000890--[[Upgraded--]]],UpgradedSetting / r),value = UpgradedSetting,hint = 302535920000891--[[apply tech unlocks--]]})
		end

		local hint = UpgradedSetting
		if ChoGGi.UserSettings.SpeedRC then
			hint = ChoGGi.UserSettings.SpeedRC
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				ChoGGi.ComFuncs.SetSavedSetting("SpeedRC",value)
				local tab = UICity.labels.Rover or ""
				for i = 1, #tab do
					tab[i]:SetMoveSpeed(value)
				end

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000769--[[Selected--]]),
					5438--[[Rovers--]],
					default_icon2
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000543--[[RC Move Speed--]],
			hint = StringFormat("%s: %s",S[302535920000106--[[Current--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetDroneAmountDroneHub()
		local ChoGGi = ChoGGi
		local sel = ChoGGi.ComFuncs.SelObject()
		if not sel or not sel:IsKindOf("DroneControl") then
			return
		end

		local CurrentAmount = sel:GetDronesCount()
		local ItemList = {
			{text = StringFormat("%s: %s",S[302535920000894--[[Current amount--]]],CurrentAmount),value = CurrentAmount},
			{text = 1,value = 1},
			{text = 5,value = 5},
			{text = 10,value = 10},
			{text = 25,value = 25},
			{text = 50,value = 50},
			{text = 100,value = 100},
			{text = 250,value = 250},
		}

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then

				local change = S[302535920000746--[[added--]]]
				if choice[1].check1 then
					change = S[302535920000917--[[packed--]]]
					for _ = 1, value do
						sel:ConvertDroneToPrefab()
					end
				else
					for _ = 1, value do
						sel:UseDronePrefab()
					end
				end

				MsgPopup(
					StringFormat("%s: %s %s",choice[1].text,S[517--[[Drones--]]],change),
					517--[[Drones--]],
					default_icon
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000895--[[Change Amount Of Drones--]],
			hint = StringFormat("%s: %s %s: %s",S[302535920000896--[[Drones in hub--]]],CurrentAmount,S[302535920000897--[[Drone prefabs--]]],": ",UICity.drone_prefabs),
			check = {
				{
					title = 302535920000898--[[Pack Drones--]],
					hint = 302535920000899--[[Check this to pack drone(s) into prefabs (number can be higher than attached drones).--]],
				},
			},
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetDroneFactoryBuildSpeed()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.Consts.DroneFactoryBuildSpeed
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
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

		local hint = DefaultSetting
		if setting.performance_notauto then
			hint = tostring(setting.performance_notauto)
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				local tab = UICity.labels.DroneFactory or ""
				for i = 1, #tab do
					tab[i].performance = value
				end
			end

			if value == DefaultSetting then
				setting.performance_notauto = nil
			else
				setting.performance_notauto = value
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000900--[[Build Speed--]]),
				517--[[Drones--]],
				default_icon
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000901--[[Set Drone Factory Build Speed--]],
			hint = StringFormat("%s: %s",S[302535920000106--[[Current--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.DroneBatteryInfinite_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("DroneMoveBatteryUse",ChoGGi.ComFuncs.NumRetBool(Consts.DroneMoveBatteryUse,0,ChoGGi.Consts.DroneMoveBatteryUse))
		ChoGGi.ComFuncs.SetConstsG("DroneCarryBatteryUse",ChoGGi.ComFuncs.NumRetBool(Consts.DroneCarryBatteryUse,0,ChoGGi.Consts.DroneCarryBatteryUse))
		ChoGGi.ComFuncs.SetConstsG("DroneConstructBatteryUse",ChoGGi.ComFuncs.NumRetBool(Consts.DroneConstructBatteryUse,0,ChoGGi.Consts.DroneConstructBatteryUse))
		ChoGGi.ComFuncs.SetConstsG("DroneBuildingRepairBatteryUse",ChoGGi.ComFuncs.NumRetBool(Consts.DroneBuildingRepairBatteryUse,0,ChoGGi.Consts.DroneBuildingRepairBatteryUse))
		ChoGGi.ComFuncs.SetConstsG("DroneDeconstructBatteryUse",ChoGGi.ComFuncs.NumRetBool(Consts.DroneDeconstructBatteryUse,0,ChoGGi.Consts.DroneDeconstructBatteryUse))
		ChoGGi.ComFuncs.SetConstsG("DroneTransformWasteRockObstructorToStockpileBatteryUse",ChoGGi.ComFuncs.NumRetBool(Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse,0,ChoGGi.Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse))
		ChoGGi.ComFuncs.SetSavedSetting("DroneMoveBatteryUse",Consts.DroneMoveBatteryUse)
		ChoGGi.ComFuncs.SetSavedSetting("DroneCarryBatteryUse",Consts.DroneCarryBatteryUse)
		ChoGGi.ComFuncs.SetSavedSetting("DroneConstructBatteryUse",Consts.DroneConstructBatteryUse)
		ChoGGi.ComFuncs.SetSavedSetting("DroneBuildingRepairBatteryUse",Consts.DroneBuildingRepairBatteryUse)
		ChoGGi.ComFuncs.SetSavedSetting("DroneDeconstructBatteryUse",Consts.DroneDeconstructBatteryUse)
		ChoGGi.ComFuncs.SetSavedSetting("DroneTransformWasteRockObstructorToStockpileBatteryUse",Consts.DroneTransformWasteRockObstructorToStockpileBatteryUse)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000902--[[%s: What happens when the drones get into your Jolt Cola supply...--]]]:format(ChoGGi.UserSettings.DroneMoveBatteryUse),
			517--[[Drones--]],
			default_icon
		)
	end

	function ChoGGi.MenuFuncs.DroneBuildSpeed_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("DroneConstructAmount",ChoGGi.ComFuncs.ValueRetOpp(Consts.DroneConstructAmount,max_int,ChoGGi.Consts.DroneConstructAmount))
		ChoGGi.ComFuncs.SetConstsG("DroneBuildingRepairAmount",ChoGGi.ComFuncs.ValueRetOpp(Consts.DroneBuildingRepairAmount,max_int,ChoGGi.Consts.DroneBuildingRepairAmount))
		ChoGGi.ComFuncs.SetSavedSetting("DroneConstructAmount",Consts.DroneConstructAmount)
		ChoGGi.ComFuncs.SetSavedSetting("DroneBuildingRepairAmount",Consts.DroneBuildingRepairAmount)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			StringFormat("%s %s",S[302535920000902--[[%s: What happens when the drones get into your Jolt Cola supply...--]]]:format(ChoGGi.UserSettings.DroneConstructAmount),S[302535920000903--[[and drink it...--]]]),
			517--[[Drones--]],
			default_icon
		)
	end

	function ChoGGi.MenuFuncs.RCRoverDroneRechargeFree_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("RCRoverDroneRechargeCost",ChoGGi.ComFuncs.NumRetBool(Consts.RCRoverDroneRechargeCost,0,ChoGGi.Consts.RCRoverDroneRechargeCost))
		ChoGGi.ComFuncs.SetSavedSetting("RCRoverDroneRechargeCost",Consts.RCRoverDroneRechargeCost)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000904--[[%s: More where that came from--]]]:format(ChoGGi.UserSettings.RCRoverDroneRechargeCost),
			5438--[[Rovers--]],
			default_icon2
		)
	end

	function ChoGGi.MenuFuncs.RCTransportInstantTransfer_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("RCRoverTransferResourceWorkTime",ChoGGi.ComFuncs.NumRetBool(Consts.RCRoverTransferResourceWorkTime,0,ChoGGi.Consts.RCRoverTransferResourceWorkTime))
		ChoGGi.ComFuncs.SetConstsG("RCTransportGatherResourceWorkTime",ChoGGi.ComFuncs.NumRetBool(Consts.RCTransportGatherResourceWorkTime,0,ChoGGi.ComFuncs.GetResearchedTechValue("RCTransportGatherResourceWorkTime")))
		ChoGGi.ComFuncs.SetSavedSetting("RCRoverTransferResourceWorkTime",Consts.RCRoverTransferResourceWorkTime)
		ChoGGi.ComFuncs.SetSavedSetting("RCTransportGatherResourceWorkTime",Consts.RCTransportGatherResourceWorkTime)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000905--[[%s: Slight of hand--]]]:format(ChoGGi.UserSettings.RCRoverTransferResourceWorkTime),
			5438--[[Rovers--]],
			"UI/Icons/IPButtons/resources_section.tga"
		)
	end

	function ChoGGi.MenuFuncs.DroneMeteorMalfunction_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("DroneMeteorMalfunctionChance",ChoGGi.ComFuncs.NumRetBool(Consts.DroneMeteorMalfunctionChance,0,ChoGGi.Consts.DroneMeteorMalfunctionChance))
		ChoGGi.ComFuncs.SetSavedSetting("DroneMeteorMalfunctionChance",Consts.DroneMeteorMalfunctionChance)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000906--[[%s: I'm singing in the rain. Just singin' in the rain. What a glorious feeling.--]]]:format(ChoGGi.UserSettings.DroneMeteorMalfunctionChance),
			517--[[Drones--]],
			"UI/Icons/Notifications/meteor_storm.tga"
		)
	end

	function ChoGGi.MenuFuncs.DroneRechargeTime_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("DroneRechargeTime",ChoGGi.ComFuncs.NumRetBool(Consts.DroneRechargeTime,0,ChoGGi.Consts.DroneRechargeTime))
		ChoGGi.ComFuncs.SetSavedSetting("DroneRechargeTime",Consts.DroneRechargeTime)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000907--[[%s: Well, if jacking on'll make strangers think I'm cool, I'll do it!--]]]:format(ChoGGi.UserSettings.DroneRechargeTime),
			517--[[Drones--]],
			"UI/Icons/Notifications/low_battery.tga",
			true
		)
	end

	function ChoGGi.MenuFuncs.DroneRepairSupplyLeak_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("DroneRepairSupplyLeak",ChoGGi.ComFuncs.ValueRetOpp(Consts.DroneRepairSupplyLeak,1,ChoGGi.Consts.DroneRepairSupplyLeak))
		ChoGGi.ComFuncs.SetSavedSetting("DroneRepairSupplyLeak",Consts.DroneRepairSupplyLeak)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000908--[[%s: You know what they say about leaky pipes.--]]]:format(ChoGGi.UserSettings.DroneRepairSupplyLeak),
			517--[[Drones--]],
			default_icon
		)
	end

	function ChoGGi.MenuFuncs.SetDroneCarryAmount()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.ComFuncs.GetResearchedTechValue("DroneResourceCarryAmount")
		local hinttoolarge = S[302535920000909--[["If you set this amount larger then a building's ""Storage"" amount then the drones will NOT pick up storage (See: Fixes>%s)."--]]]:format(S[302535920000613--[[Drone Carry Amount--]]])
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 5,value = 5},
			{text = 10,value = 10},
			{text = 25,value = 25,hint = hinttoolarge},
			{text = 50,value = 50,hint = hinttoolarge},
			{text = 75,value = 75,hint = hinttoolarge},
			{text = 100,value = 100,hint = hinttoolarge},
			{text = 250,value = 250,hint = hinttoolarge},
			{text = 500,value = 500,hint = hinttoolarge},
			{text = 1000,value = 1000,hint = StringFormat("%s\n\n%s",hinttoolarge,S[302535920000910--[[Somewhere above 1000 will delete the save (when it's full)--]]])},
		}

		local hint = DefaultSetting
		if ChoGGi.UserSettings.DroneResourceCarryAmount then
			hint = ChoGGi.UserSettings.DroneResourceCarryAmount
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
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
					S[302535920000911--[[Drones can carry %s items.--]]]:format(choice[1].text),
					517--[[Drones--]],
					default_icon
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000913--[[Set Drone Carry Capacity--]],
			hint = StringFormat("%s: %s\n\n%s\n\n%s: 1000.",S[302535920000914--[[Current capacity--]]],hint,hinttoolarge,S[302535920000834--[[Max--]]]),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetDronesPerDroneHub()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.ComFuncs.GetResearchedTechValue("CommandCenterMaxDrones")
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
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

		local hint = DefaultSetting
		if ChoGGi.UserSettings.CommandCenterMaxDrones then
			hint = ChoGGi.UserSettings.CommandCenterMaxDrones
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				ChoGGi.ComFuncs.SetConstsG("CommandCenterMaxDrones",value)
				ChoGGi.ComFuncs.SetSavedSetting("CommandCenterMaxDrones",value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000916--[[DroneHubs can control %s drones.--]]]:format(choice[1].text),
					5438--[[Rovers--]],
					default_icon
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000918--[[Set DroneHub Drone Capacity--]],
			hint = StringFormat("%s: %s",S[302535920000914--[[Current capacity--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetDronesPerRCRover()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.ComFuncs.GetResearchedTechValue("RCRoverMaxDrones")
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
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

		local hint = DefaultSetting
		if ChoGGi.UserSettings.RCRoverMaxDrones then
			hint = ChoGGi.UserSettings.RCRoverMaxDrones
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				ChoGGi.ComFuncs.SetConstsG("RCRoverMaxDrones",value)
				ChoGGi.ComFuncs.SetSavedSetting("RCRoverMaxDrones",value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000921--[[RC Rovers can control %s drones.--]]]:format(choice[1].text),
					5438--[[Rovers--]],
					default_icon2
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000924--[[Set RC Rover Drone Capacity--]],
			hint = StringFormat("%s: %s",S[302535920000914--[[Current capacity--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetRCTransportStorageCapacity()
		local ChoGGi = ChoGGi
		local r = ChoGGi.Consts.ResourceScale
		local DefaultSetting = ChoGGi.ComFuncs.GetResearchedTechValue("RCTransportStorageCapacity") / r
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 50,value = 50},
			{text = 75,value = 75},
			{text = 100,value = 100},
			{text = 250,value = 250},
			{text = 500,value = 500},
			{text = 1000,value = 1000},
			{text = 2000,value = 2000,hint = 302535920000925--[[somewhere above 2000 will delete the save (when it's full)--]]},
		}

		local hint = DefaultSetting
		if ChoGGi.UserSettings.RCTransportStorageCapacity then
			hint = ChoGGi.UserSettings.RCTransportStorageCapacity / r
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				local default = value == DefaultSetting
				local value = value * r
				-- somewhere above 2000 screws the save
				if value > 2000000 then
					value = 2000000
				end
				-- loop through and set all
				if GameState.gameplay then
					local list = UICity.labels.RCTransport or ""
					for i = 1, #list do
						list[i].max_shared_storage = value
					end
				end

				if default then
					ChoGGi.UserSettings.RCTransportStorageCapacity = nil
				else
					ChoGGi.ComFuncs.SetSavedSetting("RCTransportStorageCapacity",value)
				end

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000926--[[RC Transport capacity is now %s.--]]]:format(choice[1].text),
					5438--[[Rovers--]],
					"UI/Icons/bmc_building_storages_shine.tga"
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000927--[[Set RC Transport Capacity--]],
			hint = StringFormat("%s: %s",S[302535920000914--[[Current capacity--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetShuttleCapacity()
		local ChoGGi = ChoGGi
		local r = ChoGGi.Consts.ResourceScale
		local DefaultSetting = ChoGGi.Consts.StorageShuttle / r
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 5,value = 5},
			{text = 10,value = 10},
			{text = 25,value = 25},
			{text = 50,value = 50},
			{text = 75,value = 75},
			{text = 100,value = 100},
			{text = 250,value = 250},
			{text = 500,value = 500},
			{text = 1000,value = 1000,hint = 302535920000928--[[somewhere above 1000 may delete the save (when it's full)--]]},
		}

		local hint = DefaultSetting
		if ChoGGi.UserSettings.StorageShuttle then
			hint = ChoGGi.UserSettings.StorageShuttle / r
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
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
				local tab = UICity.labels.CargoShuttle or ""
				for i = 1, #tab do
					tab[i].max_shared_storage = value
				end
				ChoGGi.ComFuncs.SetSavedSetting("StorageShuttle",value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000929--[[Shuttle storage is now %s.--]]]:format(choice[1].text),
					745--[[Shuttles--]],
					default_icon3
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000930--[[Set Cargo Shuttle Capacity--]],
			hint = StringFormat("%s: %s",S[302535920000914--[[Current capacity--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetShuttleSpeed()
		local ChoGGi = ChoGGi
		local r = ChoGGi.Consts.ResourceScale
		local DefaultSetting = ChoGGi.Consts.SpeedShuttle / r
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
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

		local hint = DefaultSetting
		if ChoGGi.UserSettings.SpeedShuttle then
			hint = ChoGGi.UserSettings.SpeedShuttle / r
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				local value = value * r
				-- loop through and set all shuttles
				local tab = UICity.labels.CargoShuttle or ""
				for i = 1, #tab do
					tab[i].move_speed = value
				end
				ChoGGi.ComFuncs.SetSavedSetting("SpeedShuttle",value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000931--[[Shuttle speed is now %s.--]]]:format(choice[1].text),
					745--[[Shuttles--]],
					default_icon3
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000932--[[Set Cargo Shuttle Speed--]],
			hint = S[302535920000933--[[Current speed: %s--]]]:format(hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetShuttleHubShuttleCapacity()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.Consts.ShuttleHubShuttleCapacity
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
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

		local hint = DefaultSetting
		local setting = ChoGGi.UserSettings.BuildingSettings.ShuttleHub
		if setting and setting.shuttles then
			hint = tostring(setting.shuttles)
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				--loop through and set all shuttles
				local tab = UICity.labels.ShuttleHub or ""
				for i = 1, #tab do
					tab[i].max_shuttles = value
				end
				if value == DefaultSetting then
					ChoGGi.UserSettings.BuildingSettings.ShuttleHub.shuttles = nil
				else
					ChoGGi.UserSettings.BuildingSettings.ShuttleHub.shuttles = value
				end
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				S[302535920000934--[[ShuttleHub shuttle capacity is now %s.--]]]:format(choice[1].text),
				745--[[Shuttles--]],
				default_icon3
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000535--[[Set ShuttleHub Shuttle Capacity--]],
			hint = StringFormat("%s: %s",S[302535920000914--[[Current capacity--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetGravityRC()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.Consts.GravityRC
		local r = ChoGGi.Consts.ResourceScale
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
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

		local hint = DefaultSetting
		if ChoGGi.UserSettings.GravityRC then
			hint = ChoGGi.UserSettings.GravityRC / r
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				local value = value * r
				local tab = UICity.labels.Rover or ""
				for i = 1, #tab do
					tab[i]:SetGravity(value)
				end
				ChoGGi.ComFuncs.SetSavedSetting("GravityRC",value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000919--[[RC gravity is now %s.--]]]:format(choice[1].text),
					5438--[[Rovers--]],
					default_icon2
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000920--[[Set RC Gravity--]],
			hint = S[302535920000841--[[Current gravity: %s--]]]:format(hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetGravityDrones()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.Consts.GravityDrone
		local r = ChoGGi.Consts.ResourceScale
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
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

		local hint = DefaultSetting
		if ChoGGi.UserSettings.GravityDrone then
			hint = ChoGGi.UserSettings.GravityDrone / r
		end
		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				local value = value * r
				--loop through and set all
				local tab = UICity.labels.Drone or ""
				for i = 1, #tab do
					tab[i]:SetGravity(value)
				end
				ChoGGi.ComFuncs.SetSavedSetting("GravityDrone",value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000919--[[RC gravity is now %s.--]]]:format(choice[1].text),
					5438--[[Rovers--]],
					default_icon2
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000923--[[Set Drone Gravity--]],
			hint = S[302535920000841--[[Current gravity: %s--]]]:format(hint),
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
			local ChoGGi = ChoGGi

			local ItemList = {
				{text = "pack",value = meta.pack,hint = 302535920001269--[[Amount Per Click--]]},
				{text = "kg",value = meta.kg,hint = 302535920001270--[[Weight Per Item--]]},
				{text = "price",value = meta.price,hint = 302535920001271--[[Price Per Item--]]},
				{text = "locked",value = meta.locked,hint = 302535920000126--[[Locked From Resupply View--]]},
			}

			local function CallBackFunc(choice)
				if #choice < 1 then
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
					302535920000850--[[Change Resupply Settings--]],
					302535920001272--[[Updated--]],
					"UI/Icons/Sections/spaceship.tga"
				)
			end

			ChoGGi.ComFuncs.OpenInListChoice{
				callback = CallBackFunc,
				items = ItemList,
				title = StringFormat("%s: %s",S[302535920000850--[[Change Resupply Settings--]]],name),
				hint = 302535920001121--[[Edit value for each setting you wish to change then press OK to save.--]],
				custom_type = 4,
			}
		end

		function ChoGGi.MenuFuncs.ChangeResupplySettings()
			local Cargo = ChoGGi.Tables.Cargo or ""
			local CargoPresets = ChoGGi.Tables.CargoPresets or ""

			local ItemList = {}
			for i = 1, #Cargo do
				ItemList[i] = {
					text = Trans(Cargo[i].name),
					value = Cargo[i].id,
					meta = Cargo[i],
				}
			end

			local function CallBackFunc(choice)
				if #choice < 1 then
					return
				end

				if choice[1].check1 then
					ChoGGi.UserSettings.CargoSettings = nil

					for cargo_id,cargo in pairs(Cargo) do
						cargo.pack = CargoPresets[cargo_id].pack
						cargo.kg = CargoPresets[cargo_id].kg
						cargo.price = CargoPresets[cargo_id].price
						cargo.locked = CargoPresets[cargo_id].locked
					end

					return
				end

				ShowResupplyList(choice[1].value,choice[1].meta)
			end

			ChoGGi.ComFuncs.OpenInListChoice{
				callback = CallBackFunc,
				items = ItemList,
				title = 302535920000850--[[Change Resupply Settings--]],
				hint = 302535920001094--[["Shows a list of all cargo and allows you to change the price, weight taken up, if it's locked from view, and how many per click."--]],
				custom_type = 7,
				custom_func = CallBackFunc,
				check = {
					{
						title = 302535920001084--[[Reset--]],
						hint = 302535920000237--[[Check this to reset settings.--]],
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
--~ 			302535920000942--[[Are you sure you want to launch an empty rocket?--]],
--~ 			CallBackFunc,
--~ 			302535920000943--[[Launch rocket to Mars.--]],
--~ 			302535920000944--[[Yamato Hasshin!--]]
--~ 		)
--~ 	end

	function ChoGGi.MenuFuncs.SetRocketCargoCapacity()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.ComFuncs.GetResearchedTechValue("CargoCapacity")
		local ItemList = {
			{text = StringFormat("%s: %s kg",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
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
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				ChoGGi.ComFuncs.SetConstsG("CargoCapacity",value)
				ChoGGi.ComFuncs.SetSavedSetting("CargoCapacity",value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000945--[[%s: I can still see some space...--]]]:format(choice[1].text),
					5238--[[Rockets--]],
					"UI/Icons/Sections/spaceship.tga"
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000946--[[Set Rocket Cargo Capacity--]],
			hint = StringFormat("%s: %s",S[302535920000914--[[Current capacity--]]],g_Consts.CargoCapacity),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetRocketTravelTime()
		local ChoGGi = ChoGGi
		local r = ChoGGi.Consts.ResourceScale
		local DefaultSetting = ChoGGi.ComFuncs.GetResearchedTechValue("TravelTimeEarthMars") / r
		local ItemList = {
			{text = S[302535920000947--[[Instant--]]],value = 0},
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = StringFormat("%s: %s",S[302535920000948--[[Original--]]],750),value = 750},
			{text = StringFormat("%s: %s",S[302535920000949--[[Half of Original--]]],375),value = 375},
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
		local hint = DefaultSetting
		if ChoGGi.UserSettings.TravelTimeEarthMars then
			hint = ChoGGi.UserSettings.TravelTimeEarthMars / r
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
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
					S[302535920000950--[[%s: 88 MPH--]]]:format(choice[1].text),
					5238--[[Rockets--]],
					"UI/Upgrades/autoregulator_04/timer.tga"
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000951--[[Rocket Travel Time--]],
			hint = StringFormat("%s: %s",S[302535920000106--[[Current--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetColonistsPerRocket()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.ComFuncs.GetResearchedTechValue("MaxColonistsPerRocket")
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
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
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				ChoGGi.ComFuncs.SetConstsG("MaxColonistsPerRocket",value)
				ChoGGi.ComFuncs.SetSavedSetting("MaxColonistsPerRocket",value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000952--[[%s: Long pig sardines--]]]:format(choice[1].text),
					5238--[[Rockets--]],
					"UI/Icons/Notifications/colonist.tga"
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000953--[[Set Colonist Capacity--]],
			hint = StringFormat("%s: %s",S[302535920000914--[[Current capacity--]]],g_Consts.MaxColonistsPerRocket),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.RocketMaxExportAmount()
		local ChoGGi = ChoGGi
		local r = ChoGGi.Consts.ResourceScale
		local DefaultSetting = ChoGGi.Consts.RocketMaxExportAmount
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting / r),value = DefaultSetting},
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
			ChoGGi.UserSettings.RocketMaxExportAmount = DefaultSetting
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				if value == DefaultSetting then
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
					ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000769--[[Selected--]]),
					5238--[[Rockets--]],
					"UI/Icons/Sections/PreciousMetals_2.tga"
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920001291--[[Max Export Amount--]],
			hint = StringFormat("%s: %s",S[302535920000914--[[Current capacity--]]],ChoGGi.UserSettings.RocketMaxExportAmount),
			skip_sort = true,
		}
	end

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
		local ChoGGi = ChoGGi
		if ChoGGi.UserSettings.RocketsIgnoreFuel then
			ChoGGi.UserSettings.RocketsIgnoreFuel = nil
			SetRocketFuelAmount(ChoGGi.Consts.LaunchFuelPerRocket)
		else
			ChoGGi.UserSettings.RocketsIgnoreFuel = true
			SetRocketFuelAmount(0)
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.RocketsIgnoreFuel,302535920001319--[[Rockets Ignore Fuel--]]),
			5238--[[Rockets--]],
			"UI/Icons/Sections/Fuel_1.tga"
		)
	end

	function ChoGGi.MenuFuncs.LaunchFuelPerRocket()
		local ChoGGi = ChoGGi
		local r = ChoGGi.Consts.ResourceScale
		local DefaultSetting = ChoGGi.Consts.LaunchFuelPerRocket
		local UpgradedSetting = ChoGGi.ComFuncs.GetResearchedTechValue("FuelRocket")
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting / r),value = DefaultSetting},
			{text = 5,value = 5 * r},
			{text = 10,value = 10 * r},
			{text = 15,value = 15 * r},
			{text = 25,value = 25 * r},
			{text = 50,value = 50 * r},
			{text = 100,value = 100 * r},
			{text = 1000,value = 1000 * r},
			{text = 10000,value = 10000 * r},
		}
		if DefaultSetting ~= UpgradedSetting then
			table.insert(ItemList,2,{text = StringFormat("%s: %s",S[302535920000890--[[Upgraded--]]],UpgradedSetting / r),value = UpgradedSetting})
		end

		if not ChoGGi.UserSettings.LaunchFuelPerRocket then
			ChoGGi.UserSettings.LaunchFuelPerRocket = DefaultSetting
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				if value == DefaultSetting then
					ChoGGi.UserSettings.LaunchFuelPerRocket = nil
				else
					ChoGGi.UserSettings.LaunchFuelPerRocket = value
				end
				SetRocketFuelAmount(value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000769--[[Selected--]]),
					5238--[[Rockets--]],
					"UI/Icons/Sections/Fuel_1.tga"
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920001317--[[Launch Fuel Per Rocket--]],
			hint = StringFormat("%s: %s",S[302535920000914--[[Current capacity--]]],ChoGGi.UserSettings.LaunchFuelPerRocket),
			skip_sort = true,
		}
	end

end
