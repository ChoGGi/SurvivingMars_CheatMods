-- max 40 chars
DefineClass("ModOptions_ChoGGi_NurseryLimitBirthingToSpots", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "GlobalDomeCount",
			name = "All Domes Count",
		},
		{
			default = true,
			editor = "bool",
			id = "BypassNoNurseries",
			name = "Bypass No Nurseries",
		},
		{
			default = false,
			editor = "bool",
			id = "RespectIncubator",
			name = "Respect Incubator",
		},
		{
			default = false,
			editor = "bool",
			id = "UltimateNursery",
			name = "Ultimate Nursery",
		},
	},
})