DefineClass("ModOptions_ChoGGi_AddWaterEachSol", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 50,
			editor = "number",
			id = "AmountOfWater",
			max = 1000,
			min = 0,
			name = "How much water each deposit receives each Sol.",
		},
	},
})