DefineClass("ModOptions_ChoGGi_ConstructionShowDustGrid", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "Option1",
			name = "Show Grids",
		},
		{
			default = true,
			editor = "bool",
			id = "ShowConSites",
			name = "Show Construction Site Grids",
		},
		{
			default = 25,
			editor = "number",
			id = "DistFromCursor",
			max = 100,
			min = 0,
			name = "Dist From Cursor",
		},
	},
})