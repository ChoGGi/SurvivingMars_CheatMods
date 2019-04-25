DefineClass("ModOptions_ChoGGi_AlienVisitors", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 5,
			editor = "number",
			id = "MaxSpawn",
			max = 500,
			min = 4,
			name = "Max Spawn",
			desc = "Max amount on new games.",
		},
	},
})