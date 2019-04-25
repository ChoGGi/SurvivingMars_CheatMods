DefineClass("ModOptions_ChoGGi_ConstructionExtendLength", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 500,
			editor = "number",
			id = "BuildDist",
			max = 1000,
			min = 0,
			name = "How many hexes you can build",
		},
		{
			default = 500,
			editor = "number",
			id = "PassChunks",
			max = 1000,
			min = 0,
			name = "Passage length if bent",
		},
	},
})
