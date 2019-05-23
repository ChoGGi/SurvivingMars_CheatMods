-- max 40 chars
DefineClass("ModOptions_ChoGGi_MoreTerrainRocks", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 10,
			editor = "number",
			id = "LargeRocksCost",
			max = 250,
			min = 1,
			name = "Cost of large rocks.",
		},
	},
})