-- max 40 chars
DefineClass("ModOptions_ChoGGi_MapOverviewShowSurfaceResources", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "ShowMetals",
			name = "Show Metals",
		},
		{
			default = true,
			editor = "bool",
			id = "ShowPolymers",
			name = "Show Polymers",
		},
		{
			default = 75,
			max = 100,
			min = 0,
			editor = "number",
			id = "TextOpacity",
			name = "Text Opacity",
		},
	},
})