DefineClass("ModOptions_ChoGGi_ConstructionExtendLength", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 500,
			max = 1000,
			min = 0,
			editor = "number",
			id = "BuildDist",
			name = "How many hexes you can build",
		},
		{
			default = 500,
			max = 1000,
			min = 0,
			editor = "number",
			id = "PassChunks",
			name = "Passage length if bent",
		},
	},
})
