DefineClass("ModOptions_ChoGGi_ConstructionShowDustGrid", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "Option1",
			name = "Show During Construction",
			desc = "Show during construction",
		},
		{
			default = 0,
			editor = "number",
			id = "DistFromCursor",
			max = 100,
			min = 0,
			name = "Dist From Cursor",
		},

	},
})