DefineClass("ModOptions_ChoGGi_SpecialistByExperience", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "IgnoreSpec",
			name = "Colonists who already have a spec are changed as well.",
			desc = "XXXXXXXXXXXXXX",
		},
		{
			default = 25,
			editor = "number",
			id = "SolsToTrain",
			max = 500,
			min = 1,
			name = "How many Sols before getting new spec.",
			desc = "XXXXXXXXXXXXXX",
		},
	},
})
