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
			name = T(302535920011399, "How many hexes you can build"),
		},
		{
			default = 500,
			max = 1000,
			min = 0,
			editor = "number",
			id = "PassChunks",
			name = T(302535920011400, "Passage length if bent"),
		},
	},
})
