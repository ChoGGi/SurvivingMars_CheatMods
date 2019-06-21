DefineClass("ModOptions_ChoGGi_AddWaterEachSol", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 50,
			max = 1000,
			min = 0,
			editor = "number",
			id = "AmountOfWater",
			name = "How much water each deposit receives each Sol.",
		},
	},
})