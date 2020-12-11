-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "Enable Mod"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RandomiseHubList",
		"DisplayName", T(302535920011794, "Randomise Hub List"),
		"Help", T(302535920011795, [[Randomise list of drone controllers, so the order is different each update (lowers the chance of "bunching").]]),
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
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "HidePackButtons",
		"DisplayName", T(302535920011800, "Hide Pack Buttons"),
		"Help", T(302535920011801, "Hide Pack/Unpack buttons for drone controllers."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AddHeavy",
		"DisplayName", T(302535920011802, "Add Heavy"),
		"Help", T(302535920011803, "How many drones to add to heavy load controllers."),
		"DefaultValue", 12,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AddMedium",
		"DisplayName", T(302535920011804, "Add Medium"),
		"Help", T(302535920011805, "How many drones to add to medium load controllers."),
		"DefaultValue", 6,
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
