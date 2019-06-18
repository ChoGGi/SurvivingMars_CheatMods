DefineClass("ModOptions_ChoGGi_RaresPerRocket", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 90,
			max = 300,
			min = 30,
			editor = "number",
			id = "AmountOfRares",
			name = T(302535920011161, "Amount of rares"),
		},
	},
})