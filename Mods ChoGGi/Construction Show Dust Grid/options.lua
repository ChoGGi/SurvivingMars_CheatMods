DefineClass("ModOptions_ChoGGi_ConstructionShowDustGrid", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "Option1",
			name = T(302535920011364, "Show during construction"),
			desc = "Show during construction.",
		},
		{
			default = true,
			editor = "bool",
			id = "ShowConSites",
			name = T(302535920011368, "Show Construction Site Grids"),
		},
		{
			default = 50,
			max = 100,
			min = 0,
			editor = "number",
			id = "GridOpacity",
			name = T(302535920011365, "Grid Opacity"),
		},
		{
			default = 100,
			max = 100,
			min = 0,
			editor = "number",
			id = "GridScale",
			name = T(302535920011366, "Grid Scale"),
		},
		{
			default = 50,
			max = 250,
			min = 0,
			editor = "number",
			id = "DistFromCursor",
			name = T(302535920011367, "Dist From Cursor"),
		},
	},
})