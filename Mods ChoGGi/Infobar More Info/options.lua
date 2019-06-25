-- max 40 chars
DefineClass("ModOptions_ChoGGi_InfobarAddDischargeRates", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "SkipGrid0",
			name = T(9428, "Skip") .. " " .. T{11629,"GRID <i>",i=0},
		},
		{
			default = true,
			editor = "bool",
			id = "SkipGrid1",
			name = T(9428, "Skip") .. " " .. T{11629,"GRID <i>",i=1},
		},
		{
			default = false,
			editor = "bool",
			id = "MergedGrids",
			name = T(7850, "Aggregated information for your Colony."),
		},
		{
			default = 45,
			max = 100,
			min = 0,
			editor = "number",
			id = "RolloverWidth",
			name = T(1000112, "Rollover") .. " " .. T(326044431931, "SIZE"),
		},

	},
})
