-- See LICENSE for terms

local T = T
local concat = table.concat

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "Enable Mod"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SortHubListLoad",
		"DisplayName", T(302535920011794, "Sort Hub List Load"),
		"Help", T(302535920011795, [[Sort hub list by drone load order (overrides random list).

Turning off means randomise list of drone controllers, so the order is different each update (helps reduce "bunching").]]),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "UsePrefabs",
		"DisplayName", T(302535920011796, "Use Prefabs"),
		"Help", T(302535920011797, "Use drone prefabs to adjust the loads."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "UpdateDelay",
		"DisplayName", T(302535920011798, "Update Delay"),
		"Help", T(302535920011799, "On = Sol, Off = Hour."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "HidePackButtons",
		"DisplayName", T(302535920011800, "Hide Pack Buttons"),
		"Help", T(302535920011801, "Hide Pack/Unpack buttons for drone controllers."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DroneWorkDelay",
		"DisplayName", T(000, "Drone Work Delay"),
		"Help", T(000, [[How many "seconds" to wait before forcing the busy drone (0 to disable and wait).]]),
		"DefaultValue", 30,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "EarlyGame",
		"DisplayName", T(302535920011816, "Early Game"),
		"Help", T(302535920011817, "If under this amount of drones then try to evenly distribute drones across controllers instead of by load (0 to always enable, 1 to disable)."),
		"DefaultValue", 1,
		"MinValue", 0,
		"MaxValue", 250,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "IgnoreUnusedHubs",
		"DisplayName", T(302535920011823, "Ignore Unused Hubs"),
		"Help", T(302535920011824, [[Any hubs not "used" (see below) will have their drones ignored (manual assignment only).]]),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "UseDroneHubs",
		"DisplayName", concat(T(302535920011808, "Use ") .. T(5048, "Drone Hubs")),
		"Help", concat(T(302535920011809, "Assign Drones to ") .. T(5048, "Drone Hubs")),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "UseCommanders",
		"DisplayName", concat(T(302535920011808, "Use ") .. T(12091, "RC Commanders")),
		"Help", concat(T(302535920011809, "Assign Drones to ") .. T(12091, "RC Commanders") .. T(302535920011810, " and other DLC Commanders.")),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "UseRockets",
		"DisplayName", concat(T(302535920011808, "Use ") .. T(5238, "Rockets")),
		"Help", concat(T(302535920011809, "Assign Drones to ") .. T(5238, "Rockets")),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AddHeavy",
		"DisplayName", T(302535920011802, "Add Heavy"),
		"Help", T(302535920011803, "How many drones to add to heavy load controllers."),
		"DefaultValue", 5,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AddMedium",
		"DisplayName", T(302535920011804, "Add Medium"),
		"Help", T(302535920011805, "How many drones to add to medium load controllers."),
		"DefaultValue", 3,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AddEmpty",
		"DisplayName", T(302535920011806, "Add Empty"),
		"Help", T(302535920011807, "How many drones to add to empty controllers."),
		"DefaultValue", 1,
		"MinValue", 0,
		"MaxValue", 100,
	}),
}
