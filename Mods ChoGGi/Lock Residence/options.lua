DefineClass("ModOptions_ChoGGi_LockResidence", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "NeverChange",
			name = T(302535920011087, "Never Change"),
			desc = "Residents will never change residence (may cause issues).",
		},
	},
})
