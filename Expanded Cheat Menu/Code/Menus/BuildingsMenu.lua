-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

local ChoGGi_Funcs = ChoGGi_Funcs
local T = T
local Translate = ChoGGi_Funcs.Common.Translate
local SettingState = ChoGGi_Funcs.Common.SettingState
local RetTemplateOrClass = ChoGGi_Funcs.Common.RetTemplateOrClass
local RetName = ChoGGi_Funcs.Common.RetName
local Actions = ChoGGi.Temp.Actions
local c = #Actions
local icon = "CommonAssets/UI/Menu/Cube.tga"

-- menu
c = c + 1
Actions[c] = {ActionName = T(3980--[[Buildings]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Buildings",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000164--[[Storage Amount Of Diner & Grocery]]),
	ActionMenubar = "ECM.ECM.Buildings",
	ActionId = ".Storage Amount Of Diner & Grocery",
	ActionIcon = icon,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.ServiceWorkplaceFoodStorage,
			T(302535920000167--[[Change how much food is stored in them (less chance of starving colonists when busy).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetStorageAmountOfDinerGrocery,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000176--[[Empty Mech Depot]]),
	ActionMenubar = "ECM.ECM.Buildings",
	ActionId = ".Empty Mech Depot",
	ActionIcon = icon,
	RolloverText = T(302535920000177--[[Empties out selected/moused over mech depot into a small depot in front of it.]]),
	OnAction = ChoGGi_Funcs.Common.EmptyMechDepot,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000210--[[Moisture Vaporator Penalty]]),
	ActionMenubar = "ECM.ECM.Buildings",
	ActionId = ".Moisture Vaporator Penalty",
	ActionIcon = icon,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.MoistureVaporatorRange,
			T(302535920000211--[[Disable penalty when Moisture Vaporators are close to each other.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.MoistureVaporatorPenalty_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000180--[[Unlock Locked Buildings]]),
	ActionMenubar = "ECM.ECM.Buildings",
	ActionId = ".Unlock Locked Buildings",
	ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
	RolloverText = T{302535920000181--[["Shows a list of buildings you can unlock.
This doesn't apply to sponsor limited ones; see Toggles\<str>."]],
		str = T(302535920001398--[[Remove Sponsor Limits]]),
	},
	OnAction = ChoGGi_Funcs.Menus.UnlockLockedBuildings,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(5443--[[Training Buildings]]),
	ActionMenubar = "ECM.ECM.Buildings",
	ActionId = ".Training Buildings",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Training Buildings",
}

c = c + 1
Actions[c] = {ActionName = T(5245--[[Sanatoriums]]) .. " " .. T(302535920000198--[[Cure All]]),
	ActionMenubar = "ECM.ECM.Buildings.Training Buildings",
	ActionId = ".Sanatoriums Cure All",
	ActionIcon = icon,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SanatoriumCureAll,
			T(302535920000199--[[Toggle curing all traits (use "Show All Traits" & "Show Full List" to manually set).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SanatoriumCureAll_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(5248--[[Schools]]) .. " " .. T(302535920000200--[[Train All]]),
	ActionMenubar = "ECM.ECM.Buildings.Training Buildings",
	ActionId = ".Schools Train All",
	ActionIcon = icon,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SchoolTrainAll,
			T(302535920000199--[[Toggle curing all traits (use "Show All Traits" & "Show Full List" to manually set).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SchoolTrainAll_Toggle,
}

local SandS = T(5245--[[Sanatoriums]]) .. " & " .. T(5248--[[Schools]])

c = c + 1
Actions[c] = {ActionName = SandS .. ": " .. T(302535920000202--[[Show All Traits]]),
	ActionMenubar = "ECM.ECM.Buildings.Training Buildings",
	ActionId = ".Sanatoriums & Schools: Show All Traits",
	ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SanatoriumSchoolShowAllTraits,
			T(302535920000203--[[Shows all appropriate traits in Sanatoriums/Schools side panel popup menu.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.ShowAllTraits_Toggle,
}

c = c + 1
Actions[c] = {ActionName = SandS .. ": " .. T(302535920000204--[[Show Full List]]),
	ActionMenubar = "ECM.ECM.Buildings.Training Buildings",
	ActionId = ".Sanatoriums & Schools: Show Full List",
	ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SanatoriumSchoolShowAll,
			T(302535920000205--[[Toggle showing full list of trait selectors in side pane.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SanatoriumSchoolShowAll,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001344--[[Points To Train]]),
	ActionMenubar = "ECM.ECM.Buildings.Training Buildings",
	ActionId = ".Points To Train",
	ActionIcon = "CommonAssets/UI/Menu/ramp.tga",
	RolloverText = function()
		local obj = SelectedObj
		return obj and SettingState(
			"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".evaluation_points",
			T(302535920001345--[[How many points are needed to finish training.]])
		) or T(302535920001345--[[How many points are needed to finish training.]])
	end,
	OnAction = ChoGGi_Funcs.Menus.SetTrainingPoints,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(5068--[[Farms]]),
	ActionMenubar = "ECM.ECM.Buildings",
	ActionId = ".Farms",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Farms",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000192--[[Farm Shifts All On]]),
	ActionMenubar = "ECM.ECM.Buildings.Farms",
	ActionId = ".Farm Shifts All On",
	ActionIcon = icon,
	RolloverText = T(302535920000193--[[Turns on all the farm shifts.]]),
	OnAction = ChoGGi_Funcs.Menus.FarmShiftsAllOn,
}

c = c + 1
Actions[c] = {ActionName = T(4711--[[Crop Fail Threshold]]),
	ActionMenubar = "ECM.ECM.Buildings.Farms",
	ActionId = ".Crop Fail Threshold",
	ActionIcon = icon,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.CropFailThreshold,
			T(4710--[[Average performance of Farms required for Crops to succeed]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.CropFailThreshold_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000423--[[Unlock Crops]]),
	ActionMenubar = "ECM.ECM.Buildings.Farms",
	ActionId = ".Unlock Crops",
	ActionIcon = icon,
	RolloverText = T(302535920000444--[[Shows list of locked crops.]]),
	OnAction = ChoGGi_Funcs.Menus.UnlockCrops,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(302535920000157--[[Cables & Pipes]]),
	ActionMenubar = "ECM.ECM.Buildings",
	ActionId = ".Cables & Pipes",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Cables & Pipes",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000218--[[No Break]]),
	ActionMenubar = "ECM.ECM.Buildings.Cables & Pipes",
	ActionId = ".No Break",
	ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.CablesAndPipesNoBreak,
			T(302535920000157--[[Cables & Pipes]]) .. " " .. T(302535920000218--[[No Break]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.CablesAndPipesNoBreak_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(134--[[Instant Build]]),
	ActionMenubar = "ECM.ECM.Buildings.Cables & Pipes",
	ActionId = ".Instant Build",
	ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.InstantCables,
			T(302535920000157--[[Cables & Pipes]]) .. " " .. T(134--[[Instant Build]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.CablesAndPipesInstant_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(3980--[[Buildings]]),
	ActionMenubar = "ECM.ECM.Buildings",
	ActionId = ".Buildings",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Buildings",
	RolloverText = T(302535920000063--[[You need to select a building before using these.]]),
}

c = c + 1
Actions[c] = {ActionName = T(302535920000194--[[Production Amount Set]]),
	ActionMenubar = "ECM.ECM.Buildings.Buildings",
	ActionId = ".Production Amount Set",
	ActionIcon = icon,
	RolloverText = function()
		local obj = SelectedObj
		return obj and SettingState(
			"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".production",
			T(302535920000195--[["Set production of buildings of selected type, also applies to newly placed ones.
Works on any building that produces."]])
		) or T(302535920000195)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetProductionAmount,
	ActionShortcut = "Ctrl-Shift-P",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000186--[[Power-free Building]]),
	ActionMenubar = "ECM.ECM.Buildings.Buildings",
	ActionId = ".Power-free Building",
	ActionIcon = icon,
	RolloverText = function()
		local obj = SelectedObj
		return obj and SettingState(
			"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".nopower",
			T(302535920000187--[[Toggle electricity use for selected building type.]])
		) or T(302535920000187)
	end,
	OnAction = ChoGGi_Funcs.Menus.BuildingPower_Toggle,
	ActionSortKey = "2Power-free Building",
}

c = c + 1
Actions[c] = {ActionName = T(302535920001251--[[Water-free Building]]),
	ActionMenubar = "ECM.ECM.Buildings.Buildings",
	ActionId = ".Water-free Building",
	ActionIcon = icon,
	RolloverText = function()
		local obj = SelectedObj
		return obj and SettingState(
			"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".nowater",
			T(302535920001252--[[Toggle water use for selected building type.]])
		) or T(302535920001252)
	end,
	OnAction = ChoGGi_Funcs.Menus.BuildingWater_Toggle,
	ActionSortKey = "2Water-free Building",
}

c = c + 1
Actions[c] = {ActionName = T(302535920001253--[[Oxygen-free Building]]),
	ActionMenubar = "ECM.ECM.Buildings.Buildings",
	ActionId = ".Oxygen-free Building",
	ActionIcon = icon,
	RolloverText = function()
		local obj = SelectedObj
		return obj and SettingState(
			"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".noair",
			T(302535920001254--[[Toggle oxygen use for selected building type.]])
		) or T(302535920001254)
	end,
	OnAction = ChoGGi_Funcs.Menus.BuildingAir_Toggle,
	ActionSortKey = "2Oxygen-free Building",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000188--[[Set Charge & Discharge Rates]]),
	ActionMenubar = "ECM.ECM.Buildings.Buildings",
	ActionId = ".Set Charge & Discharge Rates",
	ActionIcon = icon,
	RolloverText = T(302535920000189--[[Change how fast Air/Water/Battery storage capacity changes.]]),
	OnAction = ChoGGi_Funcs.Menus.SetMaxChangeOrDischarge,
	ActionShortcut = "Ctrl-Shift-R",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000196--[[Fully Automated Building]]),
	ActionMenubar = "ECM.ECM.Buildings.Buildings",
	ActionId = ".Fully Automated Building",
	ActionIcon = icon,
	RolloverText = function()
		local obj = SelectedObj
		return obj and SettingState(
			"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".auto_performance",
			T(302535920000197--[[Work without workers (select a building and this will apply to all of type or selected).]])
		) or T(302535920000197)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetFullyAutomatedBuildings,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001114--[[Service Building Stats]]),
	ActionMenubar = "ECM.ECM.Buildings.Buildings",
	ActionId = ".Service Building Stats",
	ActionIcon = icon,
	RolloverText = function()
		local obj = SelectedObj
		return obj and SettingState(
			"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".service_stats",
			T(302535920001115--[["Tweak settings for parks and such.
Health change, Sanity change, Service Comfort, Comfort increase."]])
		) or T(302535920001115)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetServiceBuildingStats,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(302535920001367--[[Toggles]]),
	ActionMenubar = "ECM.ECM.Buildings",
	ActionId = ".Toggles",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Toggles",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000159--[[Remove Wonder Limit]]),
	ActionMenubar = "ECM.ECM.Buildings.Toggles",
	ActionId = ".Remove Wonder Limit",
	ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.Building_wonder,
			T(302535920000223--[["Unlimited wonder build limit (blocks the ""build a wonder"" achievement)."]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.Building_wonder_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000224--[[Show Hidden Buildings]]),
	ActionMenubar = "ECM.ECM.Buildings.Toggles",
	ActionId = ".Show Hidden Buildings",
	ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.Building_hide_from_build_menu,
			T(302535920000225--[[Show hidden buildings in build menu.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.Building_hide_from_build_menu_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001241--[[Instant Build]]),
	ActionMenubar = "ECM.ECM.Buildings.Toggles",
	ActionId = ".Instant Build",
	ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.Building_instant_build,
			T(302535920000229--[[Buildings are built instantly.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.Building_instant_build_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000226--[[Remove Spire Point Limit]]),
	ActionMenubar = "ECM.ECM.Buildings.Toggles",
	ActionId = ".Remove Spire Point Limit",
	ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.Building_dome_spot,
			T{302535920000227--[["Build spires anywhere in domes.
Use with <color ChoGGi_green><str></color> to fill up a dome with spires."]],
				str = T(302535920000230--[[Remove Building Limits]]),
			}
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.Building_dome_spot_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000230--[[Remove Building Limits]]),
	ActionMenubar = "ECM.ECM.Buildings.Toggles",
	ActionId = ".Remove Building Limits",
	ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.RemoveBuildingLimits,
			T{302535920000231--[["Buildings can be placed almost anywhere.
			See also <str>."]],
				str = T(302535920000226--[[Remove Spire Point Limit]]),
			}
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.RemoveBuildingLimits_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000214--[[Cheap Construction]]),
	ActionMenubar = "ECM.ECM.Buildings.Toggles",
	ActionId = ".Cheap Construction",
	ActionIcon = icon,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.rebuild_cost_modifier,
			T(302535920000215--[[Build with minimal resources.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.CheapConstruction_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000216--[[Building Damage Crime]]),
	ActionMenubar = "ECM.ECM.Buildings.Toggles",
	ActionId = ".Building Damage Crime",
	ActionIcon = icon,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.CrimeEventSabotageBuildingsCount,
			T(302535920000217--[[Disable damage from renegedes to buildings.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.BuildingDamageCrime_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000206--[[Maintenance Free Inside]]),
	ActionMenubar = "ECM.ECM.Buildings.Toggles",
	ActionId = ".Maintenance Free Inside",
	ActionIcon = icon,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.InsideBuildingsNoMaintenance,
			T(302535920000207--[[Buildings inside domes don't build maintenance points (takes away instead of adding).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.MaintenanceFreeBuildingsInside_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000208--[[Maintenance Free]]),
	ActionMenubar = "ECM.ECM.Buildings.Toggles",
	ActionId = ".Maintenance Free",
	ActionIcon = icon,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.RemoveMaintenanceBuildUp,
			T(302535920000209--[[Building maintenance points reverse (takes away instead of adding).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.MaintenanceFreeBuildings_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000174--[[Always Dusty]]),
	ActionMenubar = "ECM.ECM.Buildings.Toggles",
	ActionId = ".Always Dusty",
	ActionIcon = icon,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.AlwaysDustyBuildings,
			T{302535920000175--[["Buildings will never lose their dust (unless you turn this off, then it'll reset the dust amount).
Will be overridden by <str>."]],
				str = T(302535920000037--[[Always Clean]]),
			}
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.AlwaysDustyBuildings_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000037--[[Always Clean]]),
	ActionMenubar = "ECM.ECM.Buildings.Toggles",
	ActionId = ".Always Clean",
	ActionIcon = icon,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.AlwaysCleanBuildings,
			T(302535920000316--[[Buildings will never get dusty.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.AlwaysCleanBuildings_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(4713--[[Pipes pillar spacing]]),
	ActionMenubar = "ECM.ECM.Buildings.Toggles",
	ActionId = ".Pipes pillar spacing",
	ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.PipesPillarSpacing,
			T(302535920000183--[[Only place Pillars at start and end.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.PipesPillarsSpacing_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000184--[[Unlimited Connection Length]]),
	ActionMenubar = "ECM.ECM.Buildings.Toggles",
	ActionId = ".Unlimited Connection Length",
	ActionIcon = "CommonAssets/UI/Menu/road_type.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.UnlimitedConnectionLength,
			T(302535920000185--[[No more length limits to pipes, cables, and passages.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.UnlimitedConnectionLength_Toggle,
}

if g_AvailableDlc.picard then
	c = c + 1
	Actions[c] = {ActionName = T(302535920001633--[[Remove Realm Limits]]),
		ActionMenubar = "ECM.ECM.Buildings.Toggles",
		ActionId = ".Remove Realm Limits",
		ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
		RolloverText = function()
			return SettingState(
				ChoGGi.UserSettings.RemoveRealmLimits,
				T(302535920001663--[["Buildings from Asteroid/Underground/Surface can be built in any of the others.

Restart is needed when disabling this option!"]])
			)
		end,
		OnAction = ChoGGi_Funcs.Menus.RemoveRealmLimits_Toggle,
	}
end

if g_AvailableDlc.gagarin then
	c = c + 1
	Actions[c] = {ActionName = T(302535920001398--[[Remove Sponsor Limits]]),
		ActionMenubar = "ECM.ECM.Buildings.Toggles",
		ActionId = ".Remove Sponsor Limits",
		ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
		RolloverText = function()
			return SettingState(
				ChoGGi.UserSettings.SponsorBuildingLimits,
				T(302535920001399--[[Allow you to build all buildings no matter your sponsor.]])
			)
		end,
		OnAction = ChoGGi_Funcs.Menus.SponsorBuildingLimits_Toggle,
	}
end

c = c + 1
Actions[c] = {ActionName = T(302535920001407--[[Rotate During Placement]]),
	ActionMenubar = "ECM.ECM.Buildings.Toggles",
	ActionId = ".Rotate During Placement",
	ActionIcon = "CommonAssets/UI/Menu/RotateObjectsTool.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.RotateDuringPlacement,
			T(302535920001408--[[Allow you to rotate all buildings.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.RotateDuringPlacement_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(1120--[[Space Elevator]]),
	ActionMenubar = "ECM.ECM.Buildings",
	ActionId = ".Space Elevator",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Space Elevator",
}

c = c + 1
Actions[c] = {ActionName = T(302535920001330--[[Instant Export On Toggle]]),
	ActionMenubar = "ECM.ECM.Buildings.Space Elevator",
	ActionId = ".Instant Export On Toggle",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SpaceElevatorToggleInstantExport,
			T(302535920001331--[[Toggle Forbid Exports to have it instantly export current stock.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SpaceElevatorExport_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001336--[[Export When This Amount]]),
	ActionMenubar = "ECM.ECM.Buildings.Space Elevator",
	ActionId = ".Export When This Amount",
	ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
	RolloverText = function()
		return SettingState(
			"ChoGGi.UserSettings.BuildingSettings.SpaceElevator.export_when_this_amount",
			T(302535920001337--[[When you have this many rares in storage launch right away.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetExportWhenThisAmount,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001332--[[Export Amount Per Trip]]),
	ActionMenubar = "ECM.ECM.Buildings.Space Elevator",
	ActionId = ".Export Amount Per Trip",
	ActionIcon = "CommonAssets/UI/Menu/change_height_up.tga",
	RolloverText = function()
		return SettingState(
			"ChoGGi.UserSettings.BuildingSettings.SpaceElevator.max_export_storage",
			T(302535920001333--[[How many rare metals you can export per trip.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetSpaceElevatorTransferAmount,
	setting_name = "max_export_storage",
	setting_msg = T(302535920001332--[[Export Amount Per Trip]]),
}

c = c + 1
Actions[c] = {ActionName = T(302535920001334--[[Import Amount Per Trip]]),
	ActionMenubar = "ECM.ECM.Buildings.Space Elevator",
	ActionId = ".Import Amount Per Trip",
	ActionIcon = "CommonAssets/UI/Menu/change_height_down.tga",
	RolloverText = function()
		return SettingState(
			"ChoGGi.UserSettings.BuildingSettings.SpaceElevator.cargo_capacity",
			T(302535920001335--[[How much storage for import you can use.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetSpaceElevatorTransferAmount,
	setting_name = "cargo_capacity",
	setting_msg = T(302535920001334--[[Import Amount Per Trip]]),
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(302535920000163--[[Radius]]),
	ActionMenubar = "ECM.ECM.Buildings",
	ActionId = ".Radius",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Radius",
}

c = c + 1
Actions[c] = {ActionName = T(4818--[[Triboelectric Scrubber]]),
	ActionMenubar = "ECM.ECM.Buildings.Radius",
	ActionId = ".Triboelectric Scrubber",
	ActionIcon = icon,
	RolloverText = function()
		local obj = SelectedObj
		return obj and SettingState(
			"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".uirange",
			T{302535920000170--[["Change the range of the <str>."]], str = RetName(obj),}
		) or T{302535920000170--[[snipped]], str = T(4818--[[Triboelectric Scrubber]]),}
	end,
	OnAction = ChoGGi_Funcs.Menus.SetUIRangeBuildingRadius,
	bld_id = "TriboelectricScrubber",
	bld_msg = T(302535920000169--[["Ladies and gentlemen, this is your captain speaking. We have a small problem.
All four engines have stopped. We are doing our damnedest to get them going again.
I trust you are not in too much distress."]]),
}

c = c + 1
Actions[c] = {ActionName = T(5293--[[Subsurface Heater]]),
	ActionMenubar = "ECM.ECM.Buildings.Radius",
	ActionId = ".Subsurface Heater",
	ActionIcon = icon,
	RolloverText = function()
		local obj = SelectedObj
		return obj and SettingState(
			"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".uirange",
			T{302535920000170--[["Change the range of the <str>."]], str = RetName(obj),}
		) or T{302535920000170--[[snipped]], str = T(5293--[[Subsurface Heater]]),}
	end,
	OnAction = ChoGGi_Funcs.Menus.SetUIRangeBuildingRadius,
	bld_id = "SubsurfaceHeater",
	bld_msg = T(302535920000172--[[Some smart quip about heating?]]),
}

c = c + 1
Actions[c] = {ActionName = T(357216170041--[[Forestation Plant]]),
	ActionMenubar = "ECM.ECM.Buildings.Radius",
	ActionId = ".Forestation Plant",
	ActionIcon = icon,
	RolloverText = function()
		local obj = ChoGGi_Funcs.Common.SelObject()
		return obj and ChoGGi_Funcs.Common.SettingState(
			"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".uirange",
			T{302535920000170--[["Change the range of the <str>."]], str = RetName(obj),}
		) or T{302535920000170--[[snipped]], str = T(357216170041--[[Forestation Plant]]),}
	end,
	OnAction = ChoGGi_Funcs.Menus.SetUIRangeBuildingRadius,
	bld_id = "ForestationPlant",
	bld_msg = T(302535920000788--[[New building radius.]]),
}

c = c + 1
Actions[c] = {ActionName = T(11933--[[Core Heat Convector]]),
	ActionMenubar = "ECM.ECM.Buildings.Radius",
	ActionId = ".Core Heat Convector",
	ActionIcon = icon,
	RolloverText = function()
		local obj = ChoGGi_Funcs.Common.SelObject()
		return obj and ChoGGi_Funcs.Common.SettingState(
			"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".uirange",
			T{302535920000170--[["Change the range of the <str>."]], str = RetName(obj),}
		) or T{302535920000170--[[snipped]], str = T(11933--[[Core Heat Convector]]),}
	end,
	OnAction = ChoGGi_Funcs.Menus.SetUIRangeBuildingRadius,
	bld_id = "CoreHeatConvector",
	bld_msg = T(302535920000788--[[New building radius.]]),
}

c = c + 1
Actions[c] = {ActionName = T(302535920000178--[[Protection Radius]]),
	ActionMenubar = "ECM.ECM.Buildings.Radius",
	ActionId = ".Protection Radius",
	ActionIcon = icon,
	RolloverText = function()
		local obj = SelectedObj
		return obj and SettingState(
			"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".protect_range",
			T(302535920000179--[[Change threat protection coverage distance (MDSLaser/DefenceTower).]])
		) or T(302535920000179--[[Change threat protection coverage distance (MDSLaser/DefenceTower).]])
	end,
	OnAction = ChoGGi_Funcs.Menus.SetProtectionRadius,
}
