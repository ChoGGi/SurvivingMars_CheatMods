-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local StringFormat = string.format
	local iconD = "CommonAssets/UI/Menu/ShowAll.tga"
	local iconRC = "CommonAssets/UI/Menu/HostGame.tga"
	local c = #Actions

	local str_ExpandedCM_Drones = "ECM.Expanded CM.Drones"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[517--[[Drones--]]]),
		ActionMenubar = "ECM.Expanded CM",
		ActionId = ".Drones",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Drones",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000505--[[Work Radius RC Rover--]]],
		ActionMenubar = str_ExpandedCM_Drones,
		ActionId = ".Work Radius RC Rover",
		ActionIcon = "CommonAssets/UI/Menu/DisableRMMaps.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.RCRoverMaxRadius,
				302535920000506--[[Change RC Rover drone radius (this ignores slider).--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetRoverWorkRadius,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000507--[[Work Radius DroneHub--]]],
		ActionMenubar = str_ExpandedCM_Drones,
		ActionId = ".Work Radius DroneHub",
		ActionIcon = "CommonAssets/UI/Menu/DisableRMMaps.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.CommandCenterMaxRadius,
				302535920000508--[[Change DroneHub drone radius (this ignores slider).--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetDroneHubWorkRadius,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000509--[[Drone Rock To Concrete Speed--]]],
		ActionMenubar = str_ExpandedCM_Drones,
		ActionId = ".Drone Rock To Concrete Speed",
		ActionIcon = iconD,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.DroneTransformWasteRockObstructorToStockpileAmount,
				302535920000510--[[How long it takes drones to convert rock to concrete.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetDroneRockToConcreteSpeed,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000511--[[Drone Move Speed--]]],
		ActionMenubar = str_ExpandedCM_Drones,
		ActionId = ".Drone Move Speed",
		ActionIcon = iconD,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.SpeedDrone,
				302535920000512--[[How fast drones will move.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetDroneMoveSpeed,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000513--[[Change Amount Of Drones In Hub--]]],
		ActionMenubar = str_ExpandedCM_Drones,
		ActionId = ".Change Amount Of Drones In Hub",
		ActionIcon = iconD,
		RolloverText = function()
			local sel = ChoGGi.ComFuncs.SelObject()
			if IsValid(sel) and sel:IsKindOf("DroneHub") then
				return ChoGGi.ComFuncs.SettingState(
					sel:GetDronesCount(),
					302535920000514--[[Select a DroneHub then change the amount of drones in said hub (dependent on prefab amount).--]]
				)
			else
				return S[302535920000514--[[Select a DroneHub then change the amount of drones in said hub (dependent on prefab amount).--]]]
			end
		end,
		OnAction = ChoGGi.MenuFuncs.SetDroneAmountDroneHub,
		ActionShortcut = "Shift-D",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000515--[[DroneFactory Build Speed--]]],
		ActionMenubar = str_ExpandedCM_Drones,
		ActionId = ".DroneFactory Build Speed",
		ActionIcon = iconD,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings.DroneFactory.performance_notauto",
				302535920000516--[[Change how fast drone factories build drones.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetDroneFactoryBuildSpeed,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000517--[[Drone Gravity--]]],
		ActionMenubar = str_ExpandedCM_Drones,
		ActionId = ".Drone Gravity",
		ActionIcon = iconD,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.GravityDrone,
				302535920000518--[[Change gravity of Drones.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetGravityDrones,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000519--[[Drone Battery Infinite--]]],
		ActionMenubar = str_ExpandedCM_Drones,
		ActionId = ".Drone Battery Infinite",
		ActionIcon = iconD,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.DroneMoveBatteryUse,
				302535920000519--[[Drone Battery Infinite--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.DroneBatteryInfinite_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000521--[[Drone Build Speed--]]],
		ActionMenubar = str_ExpandedCM_Drones,
		ActionId = ".Drone Build Speed",
		ActionIcon = iconD,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.DroneConstructAmount,
				302535920000522--[[Instant build/repair when resources are ready.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.DroneBuildSpeed_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000523--[[Drone Meteor Malfunction--]]],
		ActionMenubar = str_ExpandedCM_Drones,
		ActionId = ".Drone Meteor Malfunction",
		ActionIcon = iconD,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.DroneMeteorMalfunctionChance,
				302535920000524--[[Drones will not malfunction when close to a meteor impact site.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.DroneMeteorMalfunction_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[4645--[[Drone Recharge Time--]]],
		ActionMenubar = str_ExpandedCM_Drones,
		ActionId = ".Drone Recharge Time",
		ActionIcon = iconD,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.DroneRechargeTime,
				302535920000526--[[Faster/Slower Drone Recharge.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.DroneRechargeTime_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000527--[[Drone Repair Supply Leak Speed--]]],
		ActionMenubar = str_ExpandedCM_Drones,
		ActionId = ".Drone Repair Supply Leak Speed",
		ActionIcon = iconD,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.DroneRepairSupplyLeak,
				302535920000528--[[Faster Drone fix supply leak.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.DroneRepairSupplyLeak_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000529--[[Drone Carry Amount--]]],
		ActionMenubar = str_ExpandedCM_Drones,
		ActionId = ".Drone Carry Amount",
		ActionIcon = iconD,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.DroneResourceCarryAmount,
				302535920000530--[[Change amount drones can carry.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetDroneCarryAmount,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000531--[[Drones Per Drone Hub--]]],
		ActionMenubar = str_ExpandedCM_Drones,
		ActionId = ".Drones Per Drone Hub",
		ActionIcon = iconD,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.CommandCenterMaxDrones,
				302535920000532--[[Change amount of drones Drone Hubs will command.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetDronesPerDroneHub,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000533--[[Drones Per RC Rover--]]],
		ActionMenubar = str_ExpandedCM_Drones,
		ActionId = ".Drones Per RC Rover",
		ActionIcon = iconD,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.RCRoverMaxDrones,
				302535920000534--[[Change amount of drones RC Rovers will command.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetDronesPerRCRover,
	}

	local str_ExpandedCM_Shuttles = "ECM.Expanded CM.Shuttles"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[745--[[Shuttles--]]]),
		ActionMenubar = "ECM.Expanded CM",
		ActionId = ".Shuttles",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Shuttles",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000535--[[Set ShuttleHub Shuttle Capacity--]]],
		ActionMenubar = str_ExpandedCM_Shuttles,
		ActionId = ".Set ShuttleHub Shuttle Capacity",
		ActionIcon = iconD,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings.ShuttleHub.shuttles",
				302535920000536--[[Change amount of shuttles per shuttlehub.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetShuttleHubShuttleCapacity,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000537--[[Set Capacity--]]],
		ActionMenubar = str_ExpandedCM_Shuttles,
		ActionId = ".Set Capacity",
		ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.StorageShuttle,
				302535920000538--[[Change capacity of shuttles.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetShuttleCapacity,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000539--[[Set Speed--]]],
		ActionMenubar = str_ExpandedCM_Shuttles,
		ActionId = ".Set Speed",
		ActionIcon = "CommonAssets/UI/Menu/move_gizmo.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.SpeedShuttle,
				302535920000540--[[Change speed of shuttles.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetShuttleSpeed,
	}

	local str_ExpandedCM_Rovers = "ECM.Expanded CM.Rovers"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[5438--[[Rovers--]]]),
		ActionMenubar = "ECM.Expanded CM",
		ActionId = ".Rovers",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Rovers",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000541--[[Set Charging Distance--]]],
		ActionMenubar = str_ExpandedCM_Rovers,
		ActionId = ".Set Charging Distance",
		ActionIcon = iconRC,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.RCChargeDist,
				302535920000542--[[Distance from power lines that rovers can charge.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetRoverChargeRadius,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000543--[[RC Move Speed--]]],
		ActionMenubar = str_ExpandedCM_Rovers,
		ActionId = ".RC Move Speed",
		ActionIcon = "CommonAssets/UI/Menu/move_gizmo.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.SpeedRC,
				302535920000544--[[How fast RCs will move.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetRCMoveSpeed,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000545--[[RC Gravity--]]],
		ActionMenubar = str_ExpandedCM_Rovers,
		ActionId = ".RC Gravity",
		ActionIcon = iconRC,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.GravityRC,
				302535920000546--[[Change gravity of RCs.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetGravityRC,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000547--[[RC Rover Drone Recharge Free--]]],
		ActionMenubar = str_ExpandedCM_Rovers,
		ActionId = ".RC Rover Drone Recharge Free",
		ActionIcon = iconRC,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.RCRoverDroneRechargeCost,
				302535920000548--[[No more draining Rover Battery when recharging drones.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.RCRoverDroneRechargeFree_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000549--[[RC Transport Instant Transfer--]]],
		ActionMenubar = str_ExpandedCM_Rovers,
		ActionId = ".RC Transport Instant Transfer",
		ActionIcon = "CommonAssets/UI/Menu/Mirror.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.RCRoverTransferResourceWorkTime,
				302535920000550--[[RC Rover quick Transfer/Gather resources.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.RCTransportInstantTransfer_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000551--[[RC Transport Storage Capacity--]]],
		ActionMenubar = str_ExpandedCM_Rovers,
		ActionId = ".RC Transport Storage Capacity",
		ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.RCTransportStorageCapacity,
				302535920000552--[[Change amount of resources RC Transports can carry.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetRCTransportStorageCapacity,
	}

	local str_ExpandedCM_Rockets = "ECM.Expanded CM.Rockets"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[5238--[[Rockets--]]]),
		ActionMenubar = "ECM.Expanded CM",
		ActionId = ".Rockets",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Rockets",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001291--[[Max Export Amount--]]],
		ActionMenubar = str_ExpandedCM_Rockets,
		ActionId = ".Max Export Amount",
		ActionIcon = "CommonAssets/UI/Menu/Cube.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.RocketMaxExportAmount,
				302535920001290--[[Change how many rares per rocket you can export.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.RocketMaxExportAmount,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001317--[[Launch Fuel Per Rocket--]]],
		ActionMenubar = str_ExpandedCM_Rockets,
		ActionId = ".Launch Fuel Per Rocket",
		ActionIcon = "CommonAssets/UI/Menu/DisableNormalMaps.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.LaunchFuelPerRocket,
				302535920001318--[[Change how much fuel rockets need to launch.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.LaunchFuelPerRocket,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001319--[[Rockets Ignore Fuel--]]],
		ActionMenubar = str_ExpandedCM_Rockets,
		ActionId = ".Launch Fuel Per Rocket",
		ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.RocketsIgnoreFuel,
				302535920001320--[[Rockets don't need fuel to launch.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.RocketsIgnoreFuel_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000850--[[Change Resupply Settings--]]],
		ActionMenubar = str_ExpandedCM_Rockets,
		ActionId = ".Change Resupply Settings",
		ActionIcon = "CommonAssets/UI/Menu/change_height_down.tga",
		RolloverText = S[302535920001094--[["Shows a list of all cargo and allows you to change the price, weight taken up, if it's locked from view, and how many per click."--]]],
		OnAction = ChoGGi.MenuFuncs.ChangeResupplySettings,
	}

--~ 	c = c + 1
--~ 	Actions[c] = {ActionName = S[302535920000557--[[Launch Empty Rocket--]]],
--~ 		ActionMenubar = str_ExpandedCM_Rockets,
--~ 		ActionId = ".Launch Empty Rocket",
--~ 		ActionIcon = "CommonAssets/UI/Menu/change_height_up.tga",
--~ 		RolloverText = S[302535920000558--[[Launches an empty rocket to Mars.--]]],
--~ 		OnAction = ChoGGi.MenuFuncs.LaunchEmptyRocket,
--~ 	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000559--[[Cargo Capacity--]]],
		ActionMenubar = str_ExpandedCM_Rockets,
		ActionId = ".Cargo Capacity",
		ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.CargoCapacity,
				302535920000560--[[Change amount of storage space in rockets.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetRocketCargoCapacity,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000561--[[Travel Time--]]],
		ActionMenubar = str_ExpandedCM_Rockets,
		ActionId = ".Travel Time",
		ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.TravelTimeEarthMars,
				302535920000562--[[Change how long to take to travel between planets.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetRocketTravelTime,
	}

	c = c + 1
	Actions[c] = {ActionName = S[4594--[[Colonists Per Rocket--]]],
		ActionMenubar = str_ExpandedCM_Rockets,
		ActionId = ".Colonists Per Rocket",
		ActionIcon = "CommonAssets/UI/Menu/ToggleMarkers.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				Consts.MaxColonistsPerRocket,
				302535920000564--[[Change how many colonists can arrive on Mars in a single Rocket.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetColonistsPerRocket,
	}

end
