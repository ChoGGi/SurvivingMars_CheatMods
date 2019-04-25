DefineClass("ModOptions_ChoGGi_RCTanker", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 5,
			editor = "number",
			id = "LimitStorage",
			max = 1000,
			min = 0,
			name = "Limit Tank Storage",
			desc = "How many resource units it can hold.",
		},
	},
})
