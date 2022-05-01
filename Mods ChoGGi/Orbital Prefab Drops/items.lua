-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "ModelType",
		"DisplayName", T(302535920011457, "Model Type"),
		"Help", T(302535920011515, [[1 = supply pod, 2 = old black hex, 3 = arc pod, 4 = drop pod (3/4 Space Race DLC).
Uses supply pod if you don't have DLC.]]),
		"DefaultValue", 1,
		"MinValue", 1,
		"MaxValue", 4,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "PrefabOnly",
		"DisplayName", T(302535920011458, "Prefab Only"),
		"Help", T(302535920011516, "Only rocket drop prefabs (or all buildings depending on Inside/Outside Buildings)."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "Outside",
		"DisplayName", T(302535920011459, "Outside Buildings"),
		"Help", T(302535920011517, "If you don't want them being dropped off outside domes."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "Inside",
		"DisplayName", T(302535920011460, "Inside Buildings"),
		"Help", T(302535920011518, "If you don't want them being dropped off inside domes."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DomeCrack",
		"DisplayName", T(302535920011461, "Dome Crack"),
		"Help", T(302535920011519, "If the site is in a dome, it'll crack the glass."),
		"DefaultValue", true,
	}),
}
