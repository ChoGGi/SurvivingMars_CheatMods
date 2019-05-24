DefineClass("ModOptions_ChoGGi_PassengerRocketTweaks", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "HideRocket",
			name = "Hide Background",
		},
		{
			default = false,
			editor = "bool",
			id = "MoreSpecInfo",
			name = "More Spec Info",
		},
		{
			default = false,
			editor = "bool",
			id = "PosPassList",
			name = "Position Pass List",
		},
		{
			default = 700,
			editor = "number",
			id = "PosX",
			max = 1000,
			min = 1,
			name = "X Margin",
		},
		{
			default = 500,
			editor = "number",
			id = "PosY",
			max = 1000,
			min = 1,
			name = "Y Margin",
		},
	},
})