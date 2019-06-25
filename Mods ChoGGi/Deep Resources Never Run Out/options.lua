-- max 40 chars
DefineClass("ModOptions_ChoGGi_DeepResourcesNeverRunOut", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "MaxGrade",
			name = T(16, "Grade") .. " " .. T(781, "Very high"),
		},
		{
			default = false,
			editor = "bool",
			id = "UndergroundDeposits",
			name = T(791, "Underground Metals") .. " " .. T(795, "Underground Water"),
		},
	},
})


