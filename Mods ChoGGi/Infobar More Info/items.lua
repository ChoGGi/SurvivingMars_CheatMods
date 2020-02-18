return {
	PlaceObj("ModItemOptionToggle", {
		"name", "SkipGrid0",
		"DisplayName", table.concat(T(9428, "Skip") .. " " .. T{11629, "GRID <i>", i = 0}),
		"Help", T(302535920011505, "Grids with production+consumption = 0 (doesn't skip grids that aren't producing due to throttle)."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SkipGrid1",
		"DisplayName", table.concat(T(9428, "Skip") .. " " .. T{11629, "GRID <i>", i = 1}),
		"Help", T(302535920011506, "Grids that only have a single bld (sensor towers)."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "SkipGridX",
		"DisplayName", table.concat(T(9428, "Skip") .. " " .. T{11629, "GRID <i>", i = "X"}),
		"Help", T(302535920011507, "Grids that only have X amount of buildings (for smaller clusters, like a concrete \"hub\", 0 to disable)."),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 50,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "MergedGrids",
		"DisplayName", T(302535920011508, "Merge Grid Info"),
		"Help", T(302535920011509, "Splits each grid into a separate section in the tooltip."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RolloverWidth",
		"DisplayName", table.concat(T(1000112, "Rollover") .. " " .. T(326044431931, "SIZE")),
		"Help", T(302535920011510, "Game default is 45, if you want the tooltips wider use this (I use small UI scale)."),
		"DefaultValue", 45,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DisableTransparency",
		"DisplayName", T(302535920011501, "Disable Transparency"),
		"Help", T(302535920011502, "Disable transparency of Infobar."),
		"DefaultValue", false,
	}),
}
