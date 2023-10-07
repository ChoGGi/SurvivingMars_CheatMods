-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SkipGrid0",
		"DisplayName", table.concat(T(9428, "Skip") .. " " .. T{11629, "GRID <i>", i = 0}),
		"Help", T(302535920011573, "Grids with production+consumption = 0 (doesn't skip grids that aren't producing due to throttle)."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SkipGrid1",
		"DisplayName", table.concat(T(9428, "Skip") .. " " .. T{11629, "GRID <i>", i = 1}),
		"Help", T(302535920011572, "Grids that only have a single bld (sensor towers)."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "SkipGridX",
		"DisplayName", table.concat(T(9428, "Skip") .. " " .. T{11629, "GRID <i>", i = "X"}),
		"Help", T(302535920011571, "Grids that only have X amount of buildings (for smaller clusters, like a concrete \"hub\", 0 to disable)."),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 50,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DepositRemainingWarning",
		"DisplayName", T(302535920011939, "Deposit Remaining Warning"),
		"Help", T(302535920011940, "Show warning message when surface resource deposits (all of a single type) are below X amount (0 to disable)."),
		"DefaultValue", 100,
		"MinValue", 0,
		"MaxValue", 1000,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "MergedGrids",
		"DisplayName", T(302535920011492, "Merge Grid Info"),
		"Help", T(302535920011569, "Splits each grid into a separate section in the tooltip."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RolloverWidth",
		"DisplayName", table.concat(T(1000112, "Rollover") .. " " .. T(326044431931, "SIZE")),
		"Help", T(302535920011568, "Game default is 45, if you want the tooltips wider use this (I use small UI scale)."),
		"DefaultValue", 45,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DisableTransparency",
		"DisplayName", T(302535920011577, "Disable Transparency"),
		"Help", T(302535920011576, "Disable transparency of Infobar."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "AlwaysShowRemaining",
		"DisplayName", T(302535920011828, "Always Show Remaining"),
		"Help", T(302535920011829, "Keep showing remaining amount of resources instead of N/A when prod over consump (time formatting only shows hours for neg numbers, this game uses 24 per Sol)."),
		"DefaultValue", false,
	}),
}
