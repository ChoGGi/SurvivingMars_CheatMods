-- See LICENSE for terms

local Translate = ChoGGi.ComFuncs.Translate
local SettingState = ChoGGi.ComFuncs.SettingState
local Strings = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local c = #Actions
local icon = "CommonAssets/UI/Menu/ReportBug.tga"

-- menu
c = c + 1
Actions[c] = {ActionName = Strings[302535920000922--[[Fixes]]],
	ActionMenubar = "ECM.ECM",
	ActionId = ".Fixes",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	RolloverText = Strings[302535920000036--[[Click lightly!
Be sure to read the tooltip and if unsure than ask me.]]],
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001351--[[Rocket Crashes Game On Landing]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Rocket Crashes Game On Landing",
	ActionIcon = icon,
	RolloverText = Strings[302535920001352--[[When you select a landing site with certain rockets; your game will crash to desktop.]]],
	OnAction = ChoGGi.MenuFuncs.RocketCrashesGameOnLanding,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001299--[[Toggle Working On All Buildings]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Toggle Working On All Buildings",
	ActionIcon = icon,
	RolloverText = Strings[302535920001300--[[Does what it says; all buildings will have their working status toggled (fixes a couple issues).]]],
	OnAction = ChoGGi.MenuFuncs.ToggleWorkingAll,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001295--[[Drones Not Repairing Domes]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Drones Not Repairing Domes",
	ActionIcon = icon,
	RolloverText = Strings[302535920001296--[[If your drones are just dumping polymers into the centre of your dome.]]],
	OnAction = ChoGGi.MenuFuncs.DronesNotRepairingDomes,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001084--[[Reset]]] .. " " .. Translate(5221--[[RC Commanders]]),
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Reset RC Commanders",
	ActionIcon = icon,
	RolloverText = Strings[302535920000882--[[If you have borked commanders, this will probably fix them (may take a few seconds to apply).

You may need to toggle the recall drones button (for certain issues).]]],
	OnAction = ChoGGi.MenuFuncs.ResetCommanders,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000055--[[Reset All Colonists]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Reset All Colonists",
	ActionIcon = icon,
	RolloverText = Strings[302535920000939--[[Fix certain freezing issues (mouse still moves screen, keyboard doesn't), will lower comfort by about 20.]]],
	OnAction = ChoGGi.MenuFuncs.ResetAllColonists,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000583--[[Rebuild Walkable Points In Domes]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Rebuild Walkable Points In Domes",
	ActionIcon = icon,
	RolloverText = Strings[302535920000584--[[Useful? who knows, won't hurt.]]],
	OnAction = ChoGGi.MenuFuncs.RebuildWalkablePointsInDomes,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000585--[[Colonists Stuck Outside Rocket]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Colonists Stuck Outside Rocket",
	ActionIcon = icon,
	RolloverText = Strings[302535920000586--[[If any colonists are stuck AND you don't have any other rockets unloading colonists.

This will do a little copy n paste fix (they'll keep the same traits/whatnot).]]],
	OnAction = ChoGGi.MenuFuncs.ColonistsStuckOutsideRocket,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000587--[[Remove Missing Class Objects]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Remove Missing Class Objects",
	ActionIcon = icon,
	RolloverText = Translate(6779--[[Warning]]) .. ": " .. Strings[302535920000588--[[May crash game, SAVE FIRST. These are probably from mods that were removed (if you're getting a PinDlg error then this should fix it).]]],
	OnAction = ChoGGi.MenuFuncs.RemoveMissingClassObjects,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000591--[[Colonists Trying To Board Rocket Freezes Game]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Colonists Trying To Board Rocket Freezes Game",
	ActionIcon = icon,
	RolloverText = Strings[302535920000592--[[Doesn't fix the underlying cause, but it works.]]],
	OnAction = ChoGGi.MenuFuncs.ColonistsTryingToBoardRocketFreezesGame,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000593--[[Remove Particles With Null Polylines]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Remove Particles With Null Polylines",
	ActionIcon = icon,
	RolloverText = Strings[302535920000594--[["It won't hurt anything to run this, as for when/if: I suppose if you have a broken looking object? or a meteor crashes into your mirror sphere power decoy thingy.
This may remove some smoke stacks like the concrete extractors (just toggle working on any that don't have smoke)."]]],
	OnAction = ChoGGi.MenuFuncs.ParticlesWithNullPolylines,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000595--[[Mirror Sphere Stuck]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Mirror Sphere Stuck",
	ActionIcon = icon,
	RolloverText = Strings[302535920000596--[[If you have a mirror sphere stuck at the edge of the map, and it just won't die/move... (also removes any borked cone of a captured sphere)]]],
	OnAction = ChoGGi.MenuFuncs.MirrorSphereStuck,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000597--[[Stutter With High FPS]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Stutter With High FPS",
	ActionIcon = icon,
	RolloverText = Strings[302535920000598--[[If your units are doing stutter movement, but your FPS is fine then you likely have a unit with borked pathing (or there's one of those magical invisible walls in it's way).
<color red>This can cause your save to be corrupted and not load (likely with a bunch of mods), be very careful about using it.</color>

This also works for colonists practicing the human centipede.]]],
	OnAction = ChoGGi.MenuFuncs.StutterWithHighFPS,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000599--[[Drones Keep Trying Blocked Areas]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Drones Keep Trying Blocked Areas",
	ActionIcon = icon,
	RolloverText = Strings[302535920000600--[[If you have a certain dronehub who's drones keep trying to get somewhere they can't reach, try this.]]],
	OnAction = ChoGGi.MenuFuncs.DronesKeepTryingBlockedAreas,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000601--[[Idle Drones Won't Build When Resources Available]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Idle Drones Won't Build When Resources Available",
	ActionIcon = icon,
	RolloverText = Strings[302535920000602--[[If you have drones that are idle while contruction sites need to be built and resources are available then you likely have some unreachable building sites.

This removes any of those (resources won't be touched).]]],
	OnAction = ChoGGi.MenuFuncs.RemoveUnreachableConstructionSites,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000603--[[Remove Yellow Grid Marks]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Remove Yellow Grid Marks",
	ActionIcon = icon,
	RolloverText = Strings[302535920000604--[[If you have any buildings with those yellow grid marks around them (or anywhere else), then this will remove them.]]],
	OnAction = ChoGGi.MenuFuncs.RemoveYellowGridMarks,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001193--[[Remove Blue Grid Marks]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Remove Blue Grid Marks",
	ActionIcon = icon,
	RolloverText = Strings[302535920001197--[[If you have any buildings with the selection grid around it, and you don't have it selected (also fixes stuck RC Transport Ghosts).]]],
	OnAction = ChoGGi.MenuFuncs.RemoveBlueGridMarks,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000605--[[Project Morpheus Radar Fell Down]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Project Morpheus Radar Fell Down",
	ActionIcon = icon,
	RolloverText = Strings[302535920000606--[[Sometimes the blue radar thingy falls off.]]],
	OnAction = ChoGGi.MenuFuncs.ProjectMorpheusRadarFellDown,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000157--[[Cables & Pipes]]] .. ": " .. Strings[302535920000607--[[Instant Repair]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Cables & Pipes: Instant Repair",
	ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
	RolloverText = Strings[302535920000608--[[Instantly repair all broken pipes and cables.]]],
	OnAction = ChoGGi.MenuFuncs.CablesAndPipesRepair,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000609--[[Attach Buildings To Nearest Working Dome]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Attach Buildings To Nearest Working Dome",
	ActionIcon = icon,
	RolloverText = Strings[302535920000610--[[If you placed inside buildings outside and removed the dome they're attached to; use this.]]],
	OnAction = ChoGGi.MenuFuncs.AttachBuildingsToNearestWorkingDome,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001533--[[Remove Invalid Label Objects]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Remove Invalid Label Objects",
	ActionIcon = icon,
	RolloverText = Strings[302535920001534--[[Checks the city.labels for invalid objects and removes them from the label.]]],
	OnAction = ChoGGi.MenuFuncs.RemoveInvalidLabelObjects,
}

-- menu
c = c + 1
Actions[c] = {ActionName = Strings[302535920000938--[[Toggles]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".Toggles",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "6Toggles",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000248--[[Colonists Stuck Outside Service Buildings]]],
	ActionMenubar = "ECM.ECM.Fixes.Toggles",
	ActionId = ".Colonists Stuck Outside Service Buildings",
	ActionIcon = icon,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.ColonistsStuckOutsideServiceBuildings,
			Strings[302535920000249--[["Colonists will leave a diner/etc and stop outside of it and not move anymore (might be related to one of those smarter worker ai mods).

Seems to fix it after a Sol or two, so you shouldn't need to leave this running."]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ColonistsStuckOutsideServiceBuildings_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000613--[[Drone Carry Amount]]],
	ActionMenubar = "ECM.ECM.Fixes.Toggles",
	ActionId = ".Drone Carry Amount",
	ActionIcon = icon,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DroneResourceCarryAmountFix,
			Strings[302535920000614--[["Drones only pick up resources from buildings when the amount stored is equal or greater then their carry amount.
This forces them to pick up whenever there's more then one resource).

If you have an insane production amount set then it'll take an (in-game) hour between calling drones."]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.DroneResourceCarryAmountFix_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000615--[[Sort Command Center Dist]]],
	ActionMenubar = "ECM.ECM.Fixes.Toggles",
	ActionId = ".Sort Command Center Dist",
	ActionIcon = "CommonAssets/UI/Menu/Axis.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SortCommandCenterDist,
			Strings[302535920000616--[["Each Sol goes through all buildings and sorts their cc list by nearest.

Takes less then a second on a map with 3600+ buildings and 50+ drone hubs."]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SortCommandCenterDist_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001483--[[Missing Mod Buildings]]],
	ActionMenubar = "ECM.ECM.Fixes.Toggles",
	ActionId = ".Missing Mod Buildings",
	ActionIcon = "CommonAssets/UI/Menu/SelectRoute.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.FixMissingModBuildings,
			Strings[302535920001484--[["Removes any placed buildings that were from a mod.
This may break the save in other ways, best to just use it for testing."]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.FixMissingModBuildings_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = Strings[302535920000002--[[ECM]]] .. " " .. Strings[302535920000922--[[Fixes]]],
	ActionMenubar = "ECM.ECM.Fixes",
	ActionId = ".ECM Fixes",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "99",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000617--[[See tooltip]]],
	ActionMenubar = "ECM.ECM.Fixes.ECM Fixes",
	ActionId = ".See tooltip",
	ActionIcon = "CommonAssets/UI/Menu/help.tga",
	RolloverText = Strings[302535920000618--[[Fixes for stuff that I messed up, these should all be fine to fire even without the issues, but they shouldn't be needed.]]],
	OnAction = empty_func,
	ActionSortKey = "-1",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000619--[[Fix Black Cube Colonists]]],
	ActionMenubar = "ECM.ECM.Fixes.ECM Fixes",
	ActionId = ".Fix Black Cube Colonists",
	ActionIcon = icon,
	RolloverText = Strings[302535920000620--[[If any colonists are black cubes click this.]]],
	OnAction = ChoGGi.MenuFuncs.ColonistsFixBlackCube,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000621--[[Align All Buildings To Hex Grid]]],
	ActionMenubar = "ECM.ECM.Fixes.ECM Fixes",
	ActionId = ".Align All Buildings To Hex Grid",
	ActionIcon = icon,
	RolloverText = Strings[302535920000622--[[If you have any buildings that aren't aligned to the hex grids use this.]]],
	OnAction = ChoGGi.MenuFuncs.AlignAllBuildingsToHexGrid,
}
