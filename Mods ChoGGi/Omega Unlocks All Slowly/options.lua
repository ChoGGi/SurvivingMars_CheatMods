-- max 40 chars
DefineClass("ModOptions_ChoGGi_OmegaUnlocksAllSlowly", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 1,
			max = 100,
			min = 1,
			editor = "number",
			id = "SolsBetweenUnlock",
			name = "Sols Between Unlock",
		},
	},
})