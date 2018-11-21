-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local StringFormat = string.format
	local icon = "CommonAssets/UI/Menu/Cube.tga"
	local c = #Actions

	local str_ExpandedCM_Buildings = "ECM.Expanded CM.Buildings"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[3980--[[Buildings--]]]),
		ActionMenubar = "ECM.Expanded CM",
		ActionId = ".Buildings",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Buildings",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000164--[[Storage Amount Of Diner & Grocery--]]],
		ActionMenubar = str_ExpandedCM_Buildings,
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
	Actions[c] = {ActionName = S[302535920000168--[[Triboelectric Scrubber Radius--]]],
		ActionMenubar = str_ExpandedCM_Buildings,
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
	Actions[c] = {ActionName = S[302535920000171--[[SubsurfaceHeater Radius--]]],
		ActionMenubar = str_ExpandedCM_Buildings,
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
	Actions[c] = {ActionName = S[302535920000176--[[Empty Mech Depot--]]],
		ActionMenubar = str_ExpandedCM_Buildings,
		ActionId = ".Empty Mech Depot",
		ActionIcon = icon,
		RolloverText = S[302535920000177--[[Empties out selected/moused over mech depot into a small depot in front of it.--]]],
		OnAction = function()
			ChoGGi.ComFuncs.EmptyMechDepot()
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000210--[[Moisture Vaporator Penalty--]]],
		ActionMenubar = str_ExpandedCM_Buildings,
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

	c = c + 1
	Actions[c] = {ActionName = S[302535920000180--[[Unlock Locked Buildings--]]],
		ActionMenubar = str_ExpandedCM_Buildings,
		ActionId = ".Unlock Locked Buildings",
		ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
		RolloverText = S[302535920000181--[["Gives you a list of buildings you can unlock in the build menu (doesn't apply to sponsor limited ones, see Toggles\%s)."--]]]:format(S[302535920001398--[[Remove Sponsor Limits--]]]),
		OnAction = ChoGGi.MenuFuncs.UnlockLockedBuildings,
	}

	local str_ExpandedCM_Buildings_SanatoriumsSchools = "ECM.Expanded CM.Buildings.Sanatoriums & Schools"
	local SandS = StringFormat("%s & %s",S[5245--[[Sanatoriums--]]],S[5248--[[Schools--]]])
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",SandS),
		ActionMenubar = "ECM.Expanded CM.Buildings",
		ActionId = ".Sanatoriums & Schools",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Sanatoriums & Schools",
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s",S[5245--[[Sanatoriums--]]],S[302535920000198--[[Cure All--]]]),
		ActionMenubar = str_ExpandedCM_Buildings_SanatoriumsSchools,
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
	Actions[c] = {ActionName = StringFormat("%s %s",S[5248--[[Schools--]]],S[302535920000200--[[Train All--]]]),
		ActionMenubar = str_ExpandedCM_Buildings_SanatoriumsSchools,
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
	Actions[c] = {ActionName = StringFormat("%s: %s",SandS,S[302535920000202--[[Show All Traits--]]]),
		ActionMenubar = str_ExpandedCM_Buildings_SanatoriumsSchools,
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
	Actions[c] = {ActionName = StringFormat("%s: %s",SandS,S[302535920000204--[[Show Full List--]]]),
		ActionMenubar = str_ExpandedCM_Buildings_SanatoriumsSchools,
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

	local str_ExpandedCM_Buildings_Farms = "ECM.Expanded CM.Buildings.Farms"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[5068--[[Farms--]]]),
		ActionMenubar = "ECM.Expanded CM.Buildings",
		ActionId = ".Farms",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Farms",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000192--[[Farm Shifts All On--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Farms,
		ActionId = ".Farm Shifts All On",
		ActionIcon = icon,
		RolloverText = S[302535920000193--[[Turns on all the farm shifts.--]]],
		OnAction = ChoGGi.MenuFuncs.FarmShiftsAllOn,
	}

	c = c + 1
	Actions[c] = {ActionName = S[4711--[[Crop Fail Threshold--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Farms,
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

	local str_ExpandedCM_Buildings_CablesPipes = "ECM.Expanded CM.Buildings.Cables & Pipes"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[302535920000157--[[Cables & Pipes--]]]),
		ActionMenubar = "ECM.Expanded CM.Buildings",
		ActionId = ".Cables & Pipes",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Cables & Pipes",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000218--[[No Chance Of Break--]]],
		ActionMenubar = str_ExpandedCM_Buildings_CablesPipes,
		ActionId = ".Cables & Pipes: No Chance Of Break",
		ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.BreakChanceCablePipe,
				StringFormat("%s: %s",S[302535920000157--[[Cables & Pipes--]]],S[302535920000219--[[will never break.--]]])
			)
		end,
		OnAction = ChoGGi.MenuFuncs.CablesAndPipesNoBreak_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[134--[[Instant Build--]]],
		ActionMenubar = str_ExpandedCM_Buildings_CablesPipes,
		ActionId = ".Cables & Pipes: Instant Build",
		ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.InstantCables,
				StringFormat("%s: %s",S[302535920000157--[[Cables & Pipes--]]],S[302535920000221--[[are built instantly.--]]])
			)
		end,
		OnAction = ChoGGi.MenuFuncs.CablesAndPipesInstant_Toggle,
	}

	local str_ExpandedCM_Buildings_Buildings = "ECM.Expanded CM.Buildings.Buildings"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[3980--[[Buildings--]]]),
		ActionMenubar = "ECM.Expanded CM.Buildings",
		ActionId = ".Buildings",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Buildings",
		RolloverText = S[302535920000063--[[You need to select a building before using these.--]]],
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000194--[[Production Amount Set--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Buildings,
		ActionId = ".Production Amount Set",
		ActionIcon = icon,
		RolloverText = function()
			local sel = ChoGGi.ComFuncs.SelObject()
			return ChoGGi.ComFuncs.SettingState(
				StringFormat("ChoGGi.UserSettings.BuildingSettings.%s.production",sel and sel.template_name),
				302535920000195--[["Set production of buildings of selected type, also applies to newly placed ones.
	Works on any building that produces."--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetProductionAmount,
		ActionShortcut = "Ctrl-Shift-P",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000186--[[Power-free Building--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Buildings,
		ActionId = ".Power-free Building",
		ActionIcon = icon,
		RolloverText = function()
			local sel = ChoGGi.ComFuncs.SelObject()
			return ChoGGi.ComFuncs.SettingState(
				StringFormat("ChoGGi.UserSettings.BuildingSettings.%s.nopower",sel and sel.template_name),
				302535920000187--[[Toggle electricity use for selected building type.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.BuildingPower_Toggle,
		ActionSortKey = "2Power-free Building",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001251--[[Water-free Building--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Buildings,
		ActionId = ".Water-free Building",
		ActionIcon = icon,
		RolloverText = function()
			local sel = ChoGGi.ComFuncs.SelObject()
			return ChoGGi.ComFuncs.SettingState(
				StringFormat("ChoGGi.UserSettings.BuildingSettings.%s.nowater",sel and sel.template_name),
				302535920001252--[[Toggle water use for selected building type.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.BuildingWater_Toggle,
		ActionSortKey = "2Water-free Building",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001253--[[Oxygen-free Building--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Buildings,
		ActionId = ".Oxygen-free Building",
		ActionIcon = icon,
		RolloverText = function()
			local sel = ChoGGi.ComFuncs.SelObject()
			return ChoGGi.ComFuncs.SettingState(
				StringFormat("ChoGGi.UserSettings.BuildingSettings.%s.noair",sel and sel.template_name),
				302535920001254--[[Toggle oxygen use for selected building type.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.BuildingAir_Toggle,
		ActionSortKey = "2Oxygen-free Building",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000188--[[Set Charge & Discharge Rates--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Buildings,
		ActionId = ".Set Charge & Discharge Rates",
		ActionIcon = icon,
		RolloverText = S[302535920000189--[[Change how fast Air/Water/Battery storage capacity changes.--]]],
		OnAction = ChoGGi.MenuFuncs.SetMaxChangeOrDischarge,
		ActionShortcut = "Ctrl-Shift-R",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000178--[[Protection Radius--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Buildings,
		ActionId = ".Protection Radius",
		ActionIcon = icon,
		RolloverText = function()
			local sel = ChoGGi.ComFuncs.SelObject()
			return ChoGGi.ComFuncs.SettingState(
				StringFormat("ChoGGi.UserSettings.BuildingSettings.%s.protect_range",sel and sel.template_name),
				302535920000179--[[Change threat protection coverage distance.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetProtectionRadius,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000196--[[Fully Automated Building--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Buildings,
		ActionId = ".Fully Automated Building",
		ActionIcon = icon,
		RolloverText = function()
			local sel = ChoGGi.ComFuncs.SelObject()
			return ChoGGi.ComFuncs.SettingState(
				StringFormat("ChoGGi.UserSettings.BuildingSettings.%s.auto_performance",sel and sel.template_name),
				302535920000197--[[Work without workers (select a building and this will apply to all of type or selected).--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetFullyAutomatedBuildings,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001114--[[Service Building Stats--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Buildings,
		ActionId = ".Service Building Stats",
		ActionIcon = icon,
		RolloverText = function()
			local sel = ChoGGi.ComFuncs.SelObject()
			return ChoGGi.ComFuncs.SettingState(
				StringFormat("ChoGGi.UserSettings.BuildingSettings.%s.service_stats",sel and sel.template_name),
				302535920001115--[["Tweak settings for parks and such.
	Health change, Sanity change, Service Comfort, Comfort increase."--]]
			)
		end,
		OnAction = function()
			ChoGGi.MenuFuncs.SetServiceBuildingStats()
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001344--[[Points To Train--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Buildings,
		ActionId = ".Points To Train",
		ActionIcon = "CommonAssets/UI/Menu/ramp.tga",
		RolloverText = function()
			local sel = ChoGGi.ComFuncs.SelObject()
			return ChoGGi.ComFuncs.SettingState(
				StringFormat("ChoGGi.UserSettings.BuildingSettings.%s.evaluation_points",sel and sel.template_name),
				302535920001345--[[How many points are needed to finish training.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetTrainingPoints,
	}

	local str_ExpandedCM_Buildings_Toggles = "ECM.Expanded CM.Buildings.Toggles"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[302535920001367--[[Toggles--]]]),
		ActionMenubar = "ECM.Expanded CM.Buildings",
		ActionId = ".Toggles",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Toggle",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000159--[[Unlimited Wonders--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Toggles,
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
	Actions[c] = {ActionName = S[302535920000224--[[Show Hidden Buildings--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Toggles,
		ActionId = ".Show Hidden Buildings",
		ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.Building_hide_from_build_menu,
				302535920000225--[[Show hidden buildings in build menu.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.Building_hide_from_build_menu_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001241--[[Instant Build--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Toggles,
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
	Actions[c] = {ActionName = S[302535920000226--[[Remove Spire Point Limit--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Toggles,
		ActionId = ".Remove Spire Point Limit",
		ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.Building_dome_spot,
				S[302535920000227--[["Build spires anywhere in domes.
	Use with %s to fill up a dome with spires."--]]]:format(S[302535920000230--[[Remove Building Limits--]]])
			)
		end,
		OnAction = ChoGGi.MenuFuncs.Building_dome_spot_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000230--[[Remove Building Limits--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Toggles,
		ActionId = ".Remove Building Limits",
		ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.RemoveBuildingLimits,
				S[302535920000231--[["Buildings can be placed almost anywhere (I left uneven terrain blocked, and pipes don't like domes).
	See also %s."--]]]:format(S[302535920000226--[[Remove Spire Point Limit--]]])
			)
		end,
		OnAction = ChoGGi.MenuFuncs.RemoveBuildingLimits_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000214--[[Cheap Construction--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Toggles,
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
	Actions[c] = {ActionName = S[302535920000216--[[Building Damage Crime--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Toggles,
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
	Actions[c] = {ActionName = S[302535920000206--[[Maintenance Free Inside--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Toggles,
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
	Actions[c] = {ActionName = S[302535920000208--[[Maintenance Free--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Toggles,
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
	Actions[c] = {ActionName = S[302535920000191--[[Use Last Orientation--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Toggles,
		ActionId = ".Use Last Orientation",
		ActionIcon = "CommonAssets/UI/Menu/ToggleMapAreaEditor.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.UseLastOrientation,
				302535920000190--[[Use last building placement orientation.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.UseLastOrientation_Toggle,
		ActionShortcut = "F7",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000174--[[Always Dusty--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Toggles,
		ActionId = ".Always Dusty",
		ActionIcon = icon,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.AlwaysDustyBuildings,
				S[302535920000175--[[Buildings will never lose their dust (unless you turn this off, then it'll reset the dust amount).
Will be overridden by %s.--]]]:format(S[302535920000037--[[Always Clean--]]])
			)
		end,
		OnAction = ChoGGi.MenuFuncs.AlwaysDustyBuildings_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000037--[[Always Clean--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Toggles,
		ActionId = ".Always Clean",
		ActionIcon = icon,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.AlwaysCleanBuildings,
				302535920000316--[[Buildings will never get dusty.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.AlwaysCleanBuildings_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000182--[[Pipes Pillars Spacing--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Toggles,
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
	Actions[c] = {ActionName = S[302535920000184--[[Unlimited Connection Length--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Toggles,
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
	Actions[c] = {ActionName = S[302535920000064--[[Build On Geysers--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Toggles,
		ActionId = ".Build On Geysers",
		ActionIcon = "CommonAssets/UI/Menu/FixUnderwaterEdges.tga",
		OnAction = ChoGGi.MenuFuncs.BuildOnGeysers_Toggle,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.BuildOnGeysers,
				302535920000065--[[Allows you to build on geysers. Use Shift-F4 around the area to delete the geyser objects (about 10-20 depending on size).--]]
			)
		end,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001398--[[Remove Sponsor Limits--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Toggles,
		ActionId = ".Remove Sponsor Limits",
		ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.SponsorBuildingLimits,
				302535920001399--[[Allow you to build all buildings no matter your sponsor.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SponsorBuildingLimits_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001407--[[Rotate During Placement--]]],
		ActionMenubar = str_ExpandedCM_Buildings_Toggles,
		ActionId = ".Rotate During Placement",
		ActionIcon = "CommonAssets/UI/Menu/RotateObjectsTool.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.RotateDuringPlacement,
				302535920001408--[[Allow you to rotate all buildings.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.RotateDuringPlacement_Toggle,
	}

	local str_ExpandedCM_Buildings_SpaceElevator = "ECM.Expanded CM.Buildings.Space Elevator"
	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s ..",S[1120--[[Space Elevator--]]]),
		ActionMenubar = "ECM.Expanded CM.Buildings",
		ActionId = ".Space Elevator",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Space Elevator",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001330--[[Instant Export On Toggle--]]],
		ActionMenubar = str_ExpandedCM_Buildings_SpaceElevator,
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
	Actions[c] = {ActionName = S[302535920001336--[[Export When This Amount--]]],
		ActionMenubar = str_ExpandedCM_Buildings_SpaceElevator,
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
	Actions[c] = {ActionName = S[302535920001332--[[Export Amount Per Trip--]]],
		ActionMenubar = str_ExpandedCM_Buildings_SpaceElevator,
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
	Actions[c] = {ActionName = S[302535920001334--[[Import Amount Per Trip--]]],
		ActionMenubar = str_ExpandedCM_Buildings_SpaceElevator,
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

end
