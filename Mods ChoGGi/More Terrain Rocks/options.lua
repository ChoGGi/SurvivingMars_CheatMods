-- max 40 chars
DefineClass("ModOptions_ChoGGi_MoreTerrainRocks", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 10,
			max = 250,
			min = 1,
			editor = "number",
			id = "LargeRocksCost",
			name = "Cost of large rocks.",
		},
	},
})