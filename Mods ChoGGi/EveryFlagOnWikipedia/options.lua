DefineClass("ModOptions_ChoGGi_EveryFlagOnWikipedia", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "RandomBirthplace",
			name = "Randomise Birthplace",
			desc = "Randomly picks birthplace for martians (so they don't all have martian names).",
		},
		{
			default = true,
			editor = "bool",
			id = "DefaultNationNames",
			name = "Default Nation Names",
			desc = "Existing Earth nations will not use the expanded names list.",
		},
	},
})
