-- See LICENSE for terms

local T = T
local table = table

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "LockMOXIEs",
		"DisplayName", T(302535920011964, "Lock MOXIEs"),
		"Help", T(302535920011965, "MOXIEs will be locked behind the Magnetic Filtering tech."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "OxygenUseChild",
		"DisplayName", table.concat(T(302535920011966, "Oxygen Use ") .. " " .. T(4775, "Child")),
		"Help", T(302535920011967, "How much oxygen is consumed per Sol by these colonists."),
		"DefaultValue", 35,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "OxygenUseYouth",
		"DisplayName", table.concat(T(302535920011966, "Oxygen Use ") .. " " .. T(4777, "Youth")),
		"Help", T(302535920011967, "How much oxygen is consumed per Sol by these colonists."),
		"DefaultValue", 80,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "OxygenUseAdult",
		"DisplayName", table.concat(T(302535920011966, "Oxygen Use ") .. " " .. T(4779, "Adult")),
		"Help", T(302535920011967, "How much oxygen is consumed per Sol by these colonists."),
		"DefaultValue", 75,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "OxygenUseMiddleAged",
		"DisplayName", table.concat(T(302535920011966, "Oxygen Use ") .. " " .. T(4781, "Middle Aged")),
		"Help", T(302535920011967, "How much oxygen is consumed per Sol by these colonists."),
		"DefaultValue", 70,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "OxygenUseSenior",
		"DisplayName", table.concat(T(302535920011966, "Oxygen Use ") .. " " .. T(4783, "Senior")),
		"Help", T(302535920011967, "How much oxygen is consumed per Sol by these colonists."),
		"DefaultValue", 60,
		"MinValue", 0,
		"MaxValue", 100,
	}),
}
