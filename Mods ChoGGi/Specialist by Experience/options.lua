DefineClass("ModOptions_ChoGGi_SpecialistByExperience", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "IgnoreSpec",
			name = T(302535920011473, "Override existing specs"),
--~ 			desc = "XXXXXXXXXXXXXX",
		},
		{
			default = 25,
			max = 500,
			min = 1,
			editor = "number",
			id = "SolsToTrain",
			name = T(302535920011474, "Sols to work before getting new spec"),
--~ 			desc = "XXXXXXXXXXXXXX",
		},
	},
})
