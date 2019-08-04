DefineClass("ModOptions_ChoGGi_AlienVisitors", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 5,
			max = 500,
			min = 4,
			editor = "number",
			id = "MaxSpawn",
			name = T(302535920011387, "Max Spawn"),
--~ 			desc = "Max amount on new games.",
		},
	},
})