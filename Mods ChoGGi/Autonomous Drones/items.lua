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
		"DisplayName", T(0000, "Randomise Hub List"),
		"Help", T(0000, [[Randomise list of drone controllers, so the order is different each update (lowers the chance of "bunching").]]),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "UsePrefabs",
		"DisplayName", T(0000, "Use Prefabs"),
		"Help", T(0000, "Use drone prefabs to adjust the loads."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "HidePackButtons",
		"DisplayName", T(0000, "Hide Pack Buttons"),
		"Help", T(0000, "Hide Pack/Unpack buttons for drone controllers."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AddHeavy",
		"DisplayName", T(0000, "Add Heavy"),
		"Help", T(0000, "How many drones to add to heavy load controllers."),
		"DefaultValue", 12,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AddMedium",
		"DisplayName", T(0000, "Add Medium"),
		"Help", T(0000, "How many drones to add to medium load controllers."),
		"DefaultValue", 6,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AddEmpty",
		"DisplayName", T(0000, "Add Empty"),
		"Help", T(0000, "How many drones to add to empty controllers."),
		"DefaultValue", 1,
		"MinValue", 0,
		"MaxValue", 100,
	}),
}
