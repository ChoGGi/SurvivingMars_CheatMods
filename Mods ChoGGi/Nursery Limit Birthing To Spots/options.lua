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
			name = T(302535920011453, "All Domes Count"),
		},
		{
			default = true,
			editor = "bool",
			id = "BypassNoNurseries",
			name = T(302535920011454, "Bypass No Nurseries"),
		},
		{
			default = false,
			editor = "bool",
			id = "RespectIncubator",
			name = T(302535920011455, "Respect Incubator"),
		},
		{
			default = false,
			editor = "bool",
			id = "UltimateNursery",
			name = T(302535920011456, "Ultimate Nursery"),
		},
	},
})