DefineClass("ModOptions_ChoGGi_SpecialistByExperience", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "IgnoreSpec",
			name = "Override existing specs",
			desc = "XXXXXXXXXXXXXX",
		},
		{
			default = 25,
			max = 500,
			min = 1,
			editor = "number",
			id = "SolsToTrain",
			name = "Sols to work before getting new spec",
			desc = "XXXXXXXXXXXXXX",
		},
	},
})
