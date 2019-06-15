DefineClass("ModOptions_ChoGGi_DomeTeleporters", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = GridConstructionController.max_hex_distance_to_allow_build or 20,
			editor = "number",
			id = "BuildDist",
			max = 1000,
			min = 1,
			name = T(302535920011079, "Build Distance"),
			desc = "How many hexes you can build.",
		},
	},
})