DefineClass("ModOptions_ChoGGi_RaresPerRocket", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 90,
			editor = "number",
			id = "AmountOfRares",
			max = 300,
			min = 30,
			name = T(0, "Amount of rares"),
		},
	},
})