-- See LICENSE for terms

local S = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local icon = "CommonAssets/UI/Menu/Cube.tga"
local c = #Actions

local str_ExpandedCM_Buildings = "Expanded CM.Buildings"
c = c + 1
Actions[c] = {
	ActionMenubar = "Expanded CM",
	ActionName = string.format("%s ..",S[3980--[[Buildings--]]]),
	ActionId = ".Buildings",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Buildings",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings,
	ActionName = S[302535920000164--[[Storage Amount Of Diner & Grocery--]]],
	ActionId = ".Storage Amount Of Diner & Grocery",
	ActionIcon = icon,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.ServiceWorkplaceFoodStorage,
			302535920000167--[[Change how much food is stored in them (less chance of starving colonists when busy).--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetStorageAmountOfDinerGrocery,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings,
	ActionName = S[302535920000168--[[Triboelectric Scrubber Radius--]]],
	ActionId = ".Triboelectric Scrubber Radius",
	ActionIcon = icon,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.TriboelectricScrubberRadius,
			302535920000170--[[Extend the range of the scrubber.--]]
		)
	end,
	OnAction = function()
		ChoGGi.MenuFuncs.SetUIRangeBuildingRadius("TriboelectricScrubber",302535920000169--[["Ladies and gentlemen, this is your captain speaking. We have a small problem.
All four engines have stopped. We are doing our damnedest to get them going again.
I trust you are not in too much distress."--]])
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings,
	ActionName = S[302535920000171--[[SubsurfaceHeater Radius--]]],
	ActionId = ".SubsurfaceHeater Radius",
	ActionIcon = icon,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.SubsurfaceHeaterRadius,
			302535920000173--[[Extend the range of the heater.--]]
		)
	end,
	OnAction = function()
		ChoGGi.MenuFuncs.SetUIRangeBuildingRadius("SubsurfaceHeater","\n",302535920000172--[[Some smart quip about heating?--]])
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings,
	ActionName = S[302535920000176--[[Empty Mech Depot--]]],
	ActionId = ".Empty Mech Depot",
	ActionIcon = icon,
	RolloverText = S[302535920000177--[[Empties out selected/moused over mech depot into a small depot in front of it.--]]],
	OnAction = function()
		ChoGGi.CodeFuncs.EmptyMechDepot()
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings,
	ActionName = S[302535920000210--[[Moisture Vaporator Penalty--]]],
	ActionId = ".Moisture Vaporator Penalty",
	ActionIcon = icon,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.MoistureVaporatorRange,
			302535920000211--[[Disable penalty when Moisture Vaporators are close to each other.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.MoistureVaporatorPenalty_Toggle,
}

local str_ExpandedCM_Buildings_SanatoriumsSchools = "Expanded CM.Buildings.Sanatoriums & Schools"
local SandS = string.format("%s & %s",S[5245--[[Sanatoriums--]]],S[5248--[[Schools--]]])
c = c + 1
Actions[c] = {
	ActionMenubar = "Expanded CM.Buildings",
	ActionName = string.format("%s ..",SandS),
	ActionId = ".Sanatoriums & Schools",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Sanatoriums & Schools",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_SanatoriumsSchools,
	ActionName = string.format("%s %s",S[5245--[[Sanatoriums--]]],S[302535920000198--[[Cure All--]]]),
	ActionId = ".Sanatoriums Cure All",
	ActionIcon = icon,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.SanatoriumCureAll,
			302535920000199--[[Toggle curing all traits (use "Show All Traits" & "Show Full List" to manually set).--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SanatoriumCureAll_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_SanatoriumsSchools,
	ActionName = string.format("%s %s",S[5248--[[Schools--]]],S[302535920000200--[[Train All--]]]),
	ActionId = ".Schools Train All",
	ActionIcon = icon,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.SchoolTrainAll,
			302535920000199--[[Toggle curing all traits (use "Show All Traits" & "Show Full List" to manually set).--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SchoolTrainAll_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_SanatoriumsSchools,
	ActionName = string.format("%s: %s",SandS,S[302535920000202--[[Show All Traits--]]]),
	ActionId = ".Sanatoriums & Schools: Show All Traits",
	ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.SanatoriumSchoolShowAllTraits,
			302535920000203--[[Shows all appropriate traits in Sanatoriums/Schools side panel popup menu.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ShowAllTraits_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_SanatoriumsSchools,
	ActionName = string.format("%s: %s",SandS,S[302535920000204--[[Show Full List--]]]),
	ActionId = ".Sanatoriums & Schools: Show Full List",
	ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.SanatoriumSchoolShowAll,
			302535920000205--[[Toggle showing full list of trait selectors in side pane.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SanatoriumSchoolShowAll,
}

local str_ExpandedCM_Buildings_Farms = "Expanded CM.Buildings.Farms"
c = c + 1
Actions[c] = {
	ActionMenubar = "Expanded CM.Buildings",
	ActionName = string.format("%s ..",S[5068--[[Farms--]]]),
	ActionId = ".Farms",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Farms",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Farms,
	ActionName = S[302535920000192--[[Farm Shifts All On--]]],
	ActionId = ".Farm Shifts All On",
	ActionIcon = icon,
	RolloverText = S[302535920000193--[[Turns on all the farm shifts.--]]],
	OnAction = ChoGGi.MenuFuncs.FarmShiftsAllOn,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Farms,
	ActionName = S[4711--[[Crop Fail Threshold--]]],
	ActionId = ".Crop Fail Threshold",
	ActionIcon = icon,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.CropFailThreshold,
			302535920000213--[[Remove Threshold for failing crops (crops won't fail).--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.CropFailThreshold_Toggle,
}

local str_ExpandedCM_Buildings_CablesPipes = "Expanded CM.Buildings.Cables & Pipes"
c = c + 1
Actions[c] = {
	ActionMenubar = "Expanded CM.Buildings",
	ActionName = string.format("%s ..",S[302535920000157--[[Cables & Pipes--]]]),
	ActionId = ".Cables & Pipes",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Cables & Pipes",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_CablesPipes,
	ActionName = S[302535920000218--[[No Chance Of Break--]]],
	ActionId = ".Cables & Pipes: No Chance Of Break",
	ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.BreakChanceCablePipe,
			string.format("%s: %s",S[302535920000157--[[Cables & Pipes--]]],S[302535920000219--[[will never break.--]]])
		)
	end,
	OnAction = ChoGGi.MenuFuncs.CablesAndPipesNoBreak_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_CablesPipes,
	ActionName = S[134--[[Instant Build--]]],
	ActionId = ".Cables & Pipes: Instant Build",
	ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.InstantCables,
			string.format("%s: %s",S[302535920000157--[[Cables & Pipes--]]],S[302535920000221--[[are built instantly.--]]])
		)
	end,
	OnAction = ChoGGi.MenuFuncs.CablesAndPipesInstant_Toggle,
}

local str_ExpandedCM_Buildings_Buildings = "Expanded CM.Buildings.Buildings"
c = c + 1
Actions[c] = {
	ActionMenubar = "Expanded CM.Buildings",
	ActionName = string.format("%s ..",S[3980--[[Buildings--]]]),
	ActionId = ".Buildings",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Buildings",
	RolloverText = S[302535920000063--[[You need to select a building before using these.--]]],
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Buildings,
	ActionName = S[302535920000194--[[Production Amount Set--]]],
	ActionId = ".Production Amount Set",
	ActionIcon = icon,
	RolloverText = S[302535920000195--[["Set production of buildings of selected type, also applies to newly placed ones.
Works on any building that produces."--]]],
	OnAction = ChoGGi.MenuFuncs.SetProductionAmount,
	ActionShortcut = ChoGGi.UserSettings.KeyBindings.SetProductionAmount,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Buildings,
	ActionName = S[302535920000186--[[Power-free Building--]]],
	ActionId = ".Power-free Building",
	ActionIcon = icon,
	RolloverText = S[302535920000187--[[Toggle electricity use for selected building type.--]]],
	OnAction = ChoGGi.MenuFuncs.BuildingPower_Toggle,
	ActionSortKey = "12",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Buildings,
	ActionName = S[302535920001251--[[Water-free Building--]]],
	ActionId = ".Water-free Building",
	ActionIcon = icon,
	RolloverText = S[302535920001252--[[Toggle water use for selected building type.--]]],
	OnAction = ChoGGi.MenuFuncs.BuildingWater_Toggle,
	ActionSortKey = "13",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Buildings,
	ActionName = S[302535920001253--[[Oxygen-free Building--]]],
	ActionId = ".Oxygen-free Building",
	ActionIcon = icon,
	RolloverText = S[302535920001254--[[Toggle oxygen use for selected building type.--]]],
	OnAction = ChoGGi.MenuFuncs.BuildingAir_Toggle,
	ActionSortKey = "14",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Buildings,
	ActionName = S[302535920000188--[[Set Charge & Discharge Rates--]]],
	ActionId = ".Set Charge & Discharge Rates",
	ActionIcon = icon,
	RolloverText = S[302535920000189--[[Change how fast Air/Water/Battery storage capacity changes.--]]],
	OnAction = ChoGGi.MenuFuncs.SetMaxChangeOrDischarge,
	ActionShortcut = ChoGGi.UserSettings.KeyBindings.SetMaxChangeOrDischarge,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Buildings,
	ActionName = S[302535920000178--[[Protection Radius--]]],
	ActionId = ".Protection Radius",
	ActionIcon = icon,
	RolloverText = S[302535920000179--[[Change threat protection coverage distance.--]]],
	OnAction = ChoGGi.MenuFuncs.SetProtectionRadius,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Buildings,
	ActionName = S[302535920000196--[[Fully Automated Building--]]],
	ActionId = ".Fully Automated Building",
	ActionIcon = icon,
	RolloverText = S[302535920000197--[[Work without workers (select a building and this will apply to all of type or selected).--]]],
	OnAction = ChoGGi.MenuFuncs.SetFullyAutomatedBuildings,
}

local str_ExpandedCM_Buildings_Toggle = "Expanded CM.Buildings.Toggle"
c = c + 1
Actions[c] = {
	ActionMenubar = "Expanded CM.Buildings",
	ActionName = string.format("%s ..",S[454042608125--[[Toggle--]]]),
	ActionId = ".Toggle",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Toggle",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Toggle,
	ActionName = S[302535920000159--[[Unlimited Wonders--]]],
	ActionId = ".Unlimited Wonders",
	ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.Building_wonder,
			302535920000223--[[Unlimited wonder build limit (restart game to toggle).--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.Building_wonder_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Toggle,
	ActionName = S[302535920000224--[[Show Hidden Buildings--]]],
	ActionId = ".Show Hidden Buildings",
	ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.Building_hide_from_build_menu,
			302535920000225--[[Show hidden buildings (restart game to toggle).--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.Building_hide_from_build_menu_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Toggle,
	ActionName = S[302535920000226--[[Build Spires Outside of Spire Point--]]],
	ActionId = ".Build Spires Outside of Spire Point",
	ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.Building_dome_spot,
			302535920000227--[["Build spires outside spire point.
Use with Remove Building Limits to fill up a dome with spires."--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.Building_dome_spot_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Toggle,
	ActionName = S[302535920001241--[[Instant Build--]]],
	ActionId = ".Instant Build",
	ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.Building_instant_build,
			302535920000229--[[Buildings are built instantly.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.Building_instant_build_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Toggle,
	ActionName = S[302535920000230--[[Remove Building Limits--]]],
	ActionId = ".Remove Building Limits",
	ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.RemoveBuildingLimits,
			302535920000231--[[Buildings can be placed almost anywhere (I left uneven terrain blocked, and pipes don't like domes).--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.RemoveBuildingLimits_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Toggle,
	ActionName = S[302535920000214--[[Cheap Construction--]]],
	ActionId = ".Cheap Construction",
	ActionIcon = icon,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.rebuild_cost_modifier,
			302535920000215--[[Build with minimal resources.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.CheapConstruction_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Toggle,
	ActionName = S[302535920000216--[[Building Damage Crime--]]],
	ActionId = ".Building Damage Crime",
	ActionIcon = icon,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.CrimeEventSabotageBuildingsCount,
			302535920000217--[[Disable damage from renegedes to buildings.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.BuildingDamageCrime_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Toggle,
	ActionName = S[302535920000206--[[Maintenance Free Inside--]]],
	ActionId = ".Maintenance Free Inside",
	ActionIcon = icon,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.InsideBuildingsNoMaintenance,
			302535920000207--[[Buildings inside domes don't build maintenance points (takes away instead of adding).--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.MaintenanceFreeBuildingsInside_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Toggle,
	ActionName = S[302535920000208--[[Maintenance Free--]]],
	ActionId = ".Maintenance Free",
	ActionIcon = icon,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.RemoveMaintenanceBuildUp,
			302535920000209--[[Building maintenance points reverse (takes away instead of adding).--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.MaintenanceFreeBuildings_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Toggle,
	ActionName = S[302535920000191--[[Use Last Orientation--]]],
	ActionId = ".Use Last Orientation",
	ActionIcon = "CommonAssets/UI/Menu/ToggleMapAreaEditor.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.UseLastOrientation,
			302535920000190--[[Use last building placement orientation.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.UseLastOrientation_Toggle,
	ActionShortcut = ChoGGi.UserSettings.KeyBindings.UseLastOrientation,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Toggle,
	ActionName = S[302535920000174--[[Always Dusty--]]],
	ActionId = ".Always Dusty",
	ActionIcon = icon,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.AlwaysDustyBuildings,
			302535920000175--[[Buildings will never lose their dust (unless you turn this off, then it'll reset the dust amount).--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.AlwaysDustyBuildings_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Toggle,
	ActionName = S[302535920000182--[[Pipes Pillars Spacing--]]],
	ActionId = ".Pipes Pillars Spacing",
	ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.PipesPillarSpacing,
			302535920000183--[[Only place Pillars at start and end.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.PipesPillarsSpacing_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Toggle,
	ActionName = S[302535920000184--[[Unlimited Connection Length--]]],
	ActionId = ".Unlimited Connection Length",
	ActionIcon = "CommonAssets/UI/Menu/road_type.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.UnlimitedConnectionLength,
			302535920000185--[[No more length limits to pipes, cables, and passages.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.UnlimitedConnectionLength_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_Toggle,
	ActionName = S[302535920000180--[[Unlock Locked Buildings--]]],
	ActionId = ".Unlock Locked Buildings",
	ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
	RolloverText = S[302535920000181--[[Gives you a list of buildings you can unlock in the build menu.--]]],
	OnAction = ChoGGi.MenuFuncs.UnlockLockedBuildings,
}

local str_ExpandedCM_Buildings_SpaceElevator = "Expanded CM.Buildings.Space Elevator"
c = c + 1
Actions[c] = {
	ActionMenubar = "Expanded CM.Buildings",
	ActionName = string.format("%s ..",S[1120--[[Space Elevator--]]]),
	ActionId = ".Space Elevator",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Space Elevator",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_SpaceElevator,
	ActionName = S[302535920001330--[[Instant Export On Toggle--]]],
	ActionId = ".Instant Export On Toggle",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.SpaceElevatorToggleInstantExport,
			302535920001331--[[Toggle Forbid Exports to have it instantly export current stock.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SpaceElevatorExport_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_SpaceElevator,
	ActionName = S[302535920001336--[[Export When This Amount--]]],
	ActionId = ".Export When This Amount",
	ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			"ChoGGi.UserSettings.BuildingSettings.SpaceElevator.export_when_this_amount",
			302535920001337--[[When you have this many rares in storage launch right away.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetExportWhenThisAmount,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_SpaceElevator,
	ActionName = S[302535920001332--[[Export Amount Per Trip--]]],
	ActionId = ".Export Amount Per Trip",
	ActionIcon = "CommonAssets/UI/Menu/change_height_up.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			"ChoGGi.UserSettings.BuildingSettings.SpaceElevator.max_export_storage",
			302535920001333--[[How many rare metals you can export per trip.--]]
		)
	end,
	OnAction = function()
		ChoGGi.MenuFuncs.SetSpaceElevatorTransferAmount("max_export_storage",302535920001332)
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Buildings_SpaceElevator,
	ActionName = S[302535920001334--[[Import Amount Per Trip--]]],
	ActionId = ".Import Amount Per Trip",
	ActionIcon = "CommonAssets/UI/Menu/change_height_down.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			"ChoGGi.UserSettings.BuildingSettings.SpaceElevator.cargo_capacity",
			302535920001335--[[How much storage for import you can use.--]]
		)
	end,
	OnAction = function()
		ChoGGi.MenuFuncs.SetSpaceElevatorTransferAmount("cargo_capacity",302535920001334)
	end,
}

