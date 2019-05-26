-- max 40 chars
DefineClass("ModOptions_ChoGGi_OmegaUnlocksAllSlowly", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 1,
			editor = "number",
			id = "SolsBetweenUnlock",
			max = 100,
			min = 1,
			name = "Sols Between Unlock",
		},
	},
})