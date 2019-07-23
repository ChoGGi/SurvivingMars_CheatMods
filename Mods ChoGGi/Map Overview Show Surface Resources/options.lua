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
			name = T(302535920011374, "Show Metals"),
		},
		{
			default = true,
			editor = "bool",
			id = "ShowPolymers",
			name = T(302535920011375, "Show Polymers"),
		},
		{
			default = false,
			editor = "bool",
			id = "TextBackground",
			name = T(302535920011376, "Text Background"),
		},
		{
			default = 0,
			max = 255,
			min = 0,
			editor = "number",
			id = "TextOpacity",
			name = T(302535920011377, "Text Opacity"),
		},
		{
			default = 1,
			max = 10,
			min = 1,
			editor = "number",
			id = "TextStyle",
			name = T(302535920011378, "Text Style"),
		},
	},
})