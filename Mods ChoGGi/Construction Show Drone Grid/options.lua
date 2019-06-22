DefineClass("ModOptions_ChoGGi_ConstructionShowDroneGrid", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "Option1",
			name = "Show during construction",
			desc = "Show during construction.",
		},
		{
			default = 50,
			max = 100,
			min = 0,
			editor = "number",
			id = "GridOpacity",
			name = "Grid Opacity",
		},
		{
			default = 50,
			max = 100,
			min = 0,
			editor = "number",
			id = "DistFromCursor",
			name = "Dist From Cursor",
		},
	},
})