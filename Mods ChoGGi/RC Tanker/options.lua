DefineClass("ModOptions_ChoGGi_RCTanker", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 5,
			max = 1000,
			min = 0,
			editor = "number",
			id = "LimitStorage",
			name = T(302535920011219, "Limit Tank Storage"),
--~ 			desc = "How many resource units it can hold.",
		},
	},
})
