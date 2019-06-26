DefineClass("ModOptions_ChoGGi_ConstructionShowDomeGrid", {
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
			default = false,
			editor = "bool",
			id = "SelectDome",
			name = T(131775917427, "Select") .. " " .. T(1234, "Dome"),
		},
		{
			default = false,
			editor = "bool",
			id = "SelectOutside",
			name = T(131775917427, "Select") .. " " .. T(885971788025, "Outside Buildings"),
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