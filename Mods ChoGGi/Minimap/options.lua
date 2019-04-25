DefineClass("ModOptions_ChoGGi_Minimap", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = "true",
			editor = "bool",
			id = "UseScreenshots",
			name = "Screenshots or topography images (needs topo mod).",
			desc = "it's a bool!",
		},
	},
})
